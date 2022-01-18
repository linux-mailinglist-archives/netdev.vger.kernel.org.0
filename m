Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7459049267F
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 14:11:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241844AbiARNK6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jan 2022 08:10:58 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:27944 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238429AbiARNK4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jan 2022 08:10:56 -0500
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20I8bB3L007148;
        Tue, 18 Jan 2022 13:10:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-type : mime-version;
 s=corp-2021-07-09; bh=ZOx/UyJmqFtjfYwCIhqYIqXT070tUzKm19R2TP2GxXY=;
 b=nBQWjdapQ3Fr22Nsl+5yRT/ub9/+lur6eQSrHC34qPdumdSN4u7rV2VIwm1B3yvJ8WVD
 TFM1+zqBwFRP2r68UdOUrV8fEpQTKR0tNRh5EOZ2lPX3BsJg4ZGHU6wil4j3ZycKcDLj
 u2hFEFbrF5ErGgDYBf1ijC7SrbbeOMLr5KVxQs6LloZltjV/f38C4sn6QxikxI/k78Xk
 nrKguAn//TTrcEUDzCIjhoIcpNeCiYs2lVYofqtfIzxdyhhnbHn/Ocg3xn6rdRGv+G6S
 i9+0D+W59HKkKr3LwCJ9PcpWOwN/q5XOQwuKBPcl6UurDf8YNMeYYnuL9UDUAbxgn6zV +g== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dnc519rab-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Jan 2022 13:10:52 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 20ID6NJX033778;
        Tue, 18 Jan 2022 13:10:51 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2106.outbound.protection.outlook.com [104.47.58.106])
        by aserp3020.oracle.com with ESMTP id 3dkp3467su-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Jan 2022 13:10:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=knKLNkEpRbpbJ/HILvx94l3QHcB3CDBPvEdz9Z6kOKedOPaBKrw+bwi+Ak7NvCUxQpOn2zsrH9Oy2nLwOQyFF7VdUthC2VDltzcc4p/mYUkzJrCn3EQInYtIapOhoGlFoh0vi6WZ6sveA65huMbZzNsyYRy2dqjB0pYNdAPeIvgUpm1jPwbqNwAi67Y4R1ot7wqsEJM6/Li3TCAtjI9oxBzyNKQoOYEX7KMdCaYi9PsXtwdqfGr3XhbB369akQysmVwv+VAJnatNo2gduXGI1PirB8rNTjeyfloFChRKTk1SuGx6ncoTBRgssSvmszoC/15nfTV/oTk8pxs2MqCo2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZOx/UyJmqFtjfYwCIhqYIqXT070tUzKm19R2TP2GxXY=;
 b=gJykQUg/pZhL/C3xUYSMPAkypA14oypZbM8gEHx4YwDc+YCox6LWPC6cpN4tCV/dHLl5XBIpub2czSCF0AUZgJ4NheucQMIGbZ7hVBeSEzQPfR8iNHyc+y+9Xv54l0qVSbUPywu/dlg+qCKFMo53VyFPmOGLYtT0SAx3yCmB3vvZz8X4flK+bZ+VyLoQXOylvLg6FYmv6aI8BRlGLTVBGztfic9fmDcDGME2GByMgcKTA+GNOc9Ktc9N1C7wHdxJI88F+UBwUQZwf3HaPK9G82xo+EowSW/PZIJQDA/+J2aTcad2M7t+IhtQtopQU9JOQXMeO+NQbHNrT7WmqogIOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZOx/UyJmqFtjfYwCIhqYIqXT070tUzKm19R2TP2GxXY=;
 b=sqLKjMOSFtTEANI/nWAVL5FRI0R6CQKuuOkEKMByMzjy7SjgvdUcbWsWm7GqJrMMeh0/tScOTNl76EXn4alQH7h00vlk17B3kTEl4S6vUBiE9l3T8jHyoZ/RISEOdX92/nHVIHlMcdQpe4jwGUl02rIq+nggVbsBtYjkt2UuZZo=
Received: from PH0PR10MB5515.namprd10.prod.outlook.com (2603:10b6:510:109::7)
 by BLAPR10MB5220.namprd10.prod.outlook.com (2603:10b6:208:324::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.9; Tue, 18 Jan
 2022 13:10:48 +0000
Received: from PH0PR10MB5515.namprd10.prod.outlook.com
 ([fe80::edcf:c580:da6f:4a5]) by PH0PR10MB5515.namprd10.prod.outlook.com
 ([fe80::edcf:c580:da6f:4a5%6]) with mapi id 15.20.4888.014; Tue, 18 Jan 2022
 13:10:48 +0000
From:   Praveen Kumar Kannoju <praveen.kannoju@oracle.com>
To:     santosh.shilimkar@oracle.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        rds-devel@oss.oracle.com, linux-kernel@vger.kernel.org
Cc:     rama.nichanamatlu@oracle.com,
        rajesh.sivaramasubramaniom@oracle.com,
        Praveen Kumar Kannoju <praveen.kannoju@oracle.com>
Subject: [PATCH RFC] rds: ib: Reduce the contention caused by the asynchronous workers to flush the mr pool
Date:   Tue, 18 Jan 2022 13:10:47 +0000
Message-Id: <1642511447-8998-1-git-send-email-praveen.kannoju@oracle.com>
X-Mailer: git-send-email 1.8.3.1
Content-Type: text/plain
X-ClientProxiedBy: BYAPR05CA0099.namprd05.prod.outlook.com
 (2603:10b6:a03:e0::40) To PH0PR10MB5515.namprd10.prod.outlook.com
 (2603:10b6:510:109::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3365dd62-537a-4485-1374-08d9da83f1f1
X-MS-TrafficTypeDiagnostic: BLAPR10MB5220:EE_
X-Microsoft-Antispam-PRVS: <BLAPR10MB5220E67A8A9CAF3AEF39D8BD8C589@BLAPR10MB5220.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:327;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lEu5ivmeBzfcSPc7VFIsElC7gjKl1fVqSKXN9HiFSCRDdbRnNUkrQixmhUWh/BGOdaA59tqdXo5IIFb/rymNV6zLD8uAbSfAVapUBN/fTrdCjlLkUBjj25+a6zpeJ8d9Z1qz0Nny3TnvAV/9HDYS1/ALVCcuGWPuoxFg/Urfk/zTXptzymwyHK68a7CWejIvp/o0hWmiUcRAXfDWYLee5kejqvJ+a0wMyI02DUnIqQlwJK2Qy00nBlJSYIEcCjBvwdPmRtI8feP4IJX+k6PFkuzqWnLHoyJPKasEnDhWyChE3K/OQ/BIDtT3yfVotuQTtZjMwn/RQxDWpfinoxPI6VshYZipDosr/dCZ87XssxD0Bs8qf1FnD9z30bk0DJ/fcGZ+nesx60e9REmy0p23bhgaMf8JOkuqZeRWmIzD7O+trv8fDC7cSG1z3UzkAtixetVAPjVweiVkxuNFFzf1SS0bSh26VIVY75ijhfDgLtTK2PajjeEgUJLP4KUF5At2IoSDMuEWcXarCUXW1MpzZQSIBOMC/JdbN+iVVJg8XX5r2TtqUKHQzwpqadmTjF7QXIHKyCu9DLHbKM6EQBrKwlcF2nkHL8r+vdQAdlz3kAw/u6UYcMNtLmqWF3WxEA/IacqV+XHLYWSox1gwC1Ial26h8pikI3y3A+zsqrrVsbACbc6L8YzjClLsVGg0AidY6f7/SKhzl2YPbAs6pzV7VQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5515.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(66476007)(26005)(36756003)(66556008)(2906002)(107886003)(6512007)(8676002)(508600001)(186003)(2616005)(66946007)(8936002)(38100700002)(38350700002)(83380400001)(6486002)(6506007)(316002)(4326008)(5660300002)(52116002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VlnHkNKPzWfHbuihr83PxOJhDq1jkyxTi5+RmdPQAjTkn5MEnbI+qlN0Y9dI?=
 =?us-ascii?Q?jQzwHKhdYvT78e9uaxlDtCt0cgi0f/uS1dnTQO5P8eY7LAH6dbbdUX6kiFoO?=
 =?us-ascii?Q?onioCONlITgicXFBYjRfP3T+Mk+sE4Ye2Z3h3vibecJfDOCZHlEOYpRhHnL1?=
 =?us-ascii?Q?lORuoD/lykbu/Cx3VdnOqSjP8SPOPkuY9yi//DOTTzid2bc2zi/7ustQ56Hh?=
 =?us-ascii?Q?jwpbPaKE9mjOgXtqvc0z6uIEwzsxN/K2Ot0EtlCnRMYrfjRYZCmtNOVPbxku?=
 =?us-ascii?Q?W6YF8+mD9RTrzFqqn1lZAjeKF23lxa/02JU0qYQSe3heWbCevJW4gnjTzwzB?=
 =?us-ascii?Q?AZlYWBEUgxQixOy1G+tQH6tDT91qU/waMNOCSjFtKFWzFU+VaRyZaXvpk4S/?=
 =?us-ascii?Q?tE4EAFcPfXfH/AXr8lt8fDBVzM+bNlo/dosMnuhDs7sdjgjzmVgLpIXyVkqz?=
 =?us-ascii?Q?hsOEPiDtH1uy1eRYFqzo4Ia4YvE/khz2C6UsJwK0foLraHWToPGPei3WDBWy?=
 =?us-ascii?Q?yxrIZxaDPklu17Rf8wSSN6iovxqZC3iTb3r3UTheumROjBuvxOCF2UEwclHB?=
 =?us-ascii?Q?3qxhBsM/dS//z/2qn2GA7aVh8LbtLcuqJd77lwBu3jsDVCA7ACOwl9+E9f1n?=
 =?us-ascii?Q?Ow+3SN2CrsZ0yXnj3rg/doOtiBuIQVnBS0Syj6asZPkdL8JPNqBIrDCdcF8z?=
 =?us-ascii?Q?XRGjg6Xl9A47kAKVadLE5EkjmZz/e/XBxfcCTFk+x4+qb0glZFToFkEudsKo?=
 =?us-ascii?Q?BOhtSuMNYXEzEJyQpECb4WxAv/iEw25G6tF0fijG0zfCzXYhJW3hpGBRrPiX?=
 =?us-ascii?Q?7XJsDffKx/5OZF386NSBkAgqV8IWAmbcjSxnOUwoBBwHKCaWPZbOC7fP5zT+?=
 =?us-ascii?Q?LQwXqPMpsp1pa5VI8EiwtXiggJnmXtwP6dRcIig/V9D+9gLizDepzzifKPTS?=
 =?us-ascii?Q?RJFI1nhATRAH9ObwHvAm9mAWj3zxdeEKotAjlAv0M8CfiIxwwMsb0ZxChxTh?=
 =?us-ascii?Q?NT2WsyqA8O0TbzuUjLufx9jVxpSOY+UjDYTE1Yn6aOYTUCQ6XGBufztDfpcZ?=
 =?us-ascii?Q?ybqKDLQrtRN3Kr17nu1b6cbqQHZ6NH93DBtsmCsYdfiTh5C0BizxPLPJa8u+?=
 =?us-ascii?Q?Req0hF4SSXa+L07Xzwi+8YwwOPaAvrcGNMggWbMVdPGtwL5eFcK7y3gVSA2F?=
 =?us-ascii?Q?6cgFZ7PB2aSdtXvDcWN5ghsysnZK84J8z1KgvWPzBiGZGAyYLdxcubcaPRej?=
 =?us-ascii?Q?WEl5UaaxCVt5B8xhEwyk6LaUpORyp3XPqcFuOUb9lolCUECd3s1PJd5w7F48?=
 =?us-ascii?Q?lw6yTwJt+de3YxXXz/WTQJu49hqArCS673GSuMsMNk65VkTCyq4t1bgN1RUA?=
 =?us-ascii?Q?xWs2+jkcQtXHAkUHGsVQGI2bkhrSCv2dVbrovPglPfxr1VOEjApsAJdZHijA?=
 =?us-ascii?Q?yTIc50G4ZXI5B2OHb2RuIMy+s26F7iVOAiherQyJOAYkmU7xnWnZeZ87h5xM?=
 =?us-ascii?Q?EK/6qx1BDT47EmXLIGMngzQEGPLrhGPAxSXm2nmFhhX/JuFyC/hc1GjizNoF?=
 =?us-ascii?Q?rVsrnYts1UhR0jbm+YJHO9woEQhlGW37YFkgUBv9qXTKStQaCeoEoI9gSGAM?=
 =?us-ascii?Q?QLV5ezUcRkJa9riBcfwKRxdCIfymz3c5qM3Jwpn9ZyUadgDbtder5GRtP1np?=
 =?us-ascii?Q?unaxIw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3365dd62-537a-4485-1374-08d9da83f1f1
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5515.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2022 13:10:48.5409
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5CYNbNWAoNBR176TmOlzAej5GPUAEV1174PTPLD9Oukv6u+bXUesnfj0R32gp0fFQX0oTV8p/YiOmdT9Duc1mBdX4tbgO0YpGYpkcyz6DFk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5220
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10230 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0
 mlxlogscore=999 adultscore=0 suspectscore=0 malwarescore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201180081
X-Proofpoint-GUID: 2mCiCVTQWrsKLymhR99rcxW2roKpQ_Ha
X-Proofpoint-ORIG-GUID: 2mCiCVTQWrsKLymhR99rcxW2roKpQ_Ha
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch aims to reduce the number of asynchronous workers being spawned
to execute the function "rds_ib_flush_mr_pool" during the high I/O
situations. Synchronous call path's to this function "rds_ib_flush_mr_pool"
will be executed without being disturbed. By reducing the number of
processes contending to flush the mr pool, the total number of D state
processes waiting to acquire the mutex lock will be greatly reduced, which
otherwise were causing DB instance crash as the corresponding processes
were not progressing while waiting to acquire the mutex lock.

Signed-off-by: Praveen Kumar Kannoju <praveen.kannoju@oracle.com>
---
 net/rds/ib.h       |  1 +
 net/rds/ib_mr.h    |  2 ++
 net/rds/ib_rdma.c  | 18 ++++++++++++++++--
 net/rds/ib_stats.c |  1 +
 4 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/net/rds/ib.h b/net/rds/ib.h
index 2ba7110..d881e3f 100644
--- a/net/rds/ib.h
+++ b/net/rds/ib.h
@@ -308,6 +308,7 @@ struct rds_ib_statistics {
 	uint64_t	s_ib_rdma_mr_1m_pool_flush;
 	uint64_t	s_ib_rdma_mr_1m_pool_wait;
 	uint64_t	s_ib_rdma_mr_1m_pool_depleted;
+	uint64_t	s_ib_rdma_flush_mr_pool_avoided;
 	uint64_t	s_ib_rdma_mr_8k_reused;
 	uint64_t	s_ib_rdma_mr_1m_reused;
 	uint64_t	s_ib_atomic_cswp;
diff --git a/net/rds/ib_mr.h b/net/rds/ib_mr.h
index ea5e9ae..9cbec6e 100644
--- a/net/rds/ib_mr.h
+++ b/net/rds/ib_mr.h
@@ -105,6 +105,8 @@ struct rds_ib_mr_pool {
 	unsigned long		max_items_soft;
 	unsigned long		max_free_pinned;
 	unsigned int		max_pages;
+
+	bool                    flush_ongoing;	/* To avoid redundant flushes */
 };
 
 extern struct workqueue_struct *rds_ib_mr_wq;
diff --git a/net/rds/ib_rdma.c b/net/rds/ib_rdma.c
index 8f070ee..6b640b5 100644
--- a/net/rds/ib_rdma.c
+++ b/net/rds/ib_rdma.c
@@ -393,6 +393,8 @@ int rds_ib_flush_mr_pool(struct rds_ib_mr_pool *pool,
 	 */
 	dirty_to_clean = llist_append_to_list(&pool->drop_list, &unmap_list);
 	dirty_to_clean += llist_append_to_list(&pool->free_list, &unmap_list);
+	WRITE_ONCE(pool->flush_ongoing, true);
+	smp_wmb();
 	if (free_all) {
 		unsigned long flags;
 
@@ -430,6 +432,8 @@ int rds_ib_flush_mr_pool(struct rds_ib_mr_pool *pool,
 	atomic_sub(nfreed, &pool->item_count);
 
 out:
+	WRITE_ONCE(pool->flush_ongoing, false);
+	smp_wmb();
 	mutex_unlock(&pool->flush_lock);
 	if (waitqueue_active(&pool->flush_wait))
 		wake_up(&pool->flush_wait);
@@ -507,8 +511,17 @@ void rds_ib_free_mr(void *trans_private, int invalidate)
 
 	/* If we've pinned too many pages, request a flush */
 	if (atomic_read(&pool->free_pinned) >= pool->max_free_pinned ||
-	    atomic_read(&pool->dirty_count) >= pool->max_items / 5)
-		queue_delayed_work(rds_ib_mr_wq, &pool->flush_worker, 10);
+	    atomic_read(&pool->dirty_count) >= pool->max_items / 5) {
+		smp_rmb();
+		if (!READ_ONCE(pool->flush_ongoing)) {
+			queue_delayed_work(rds_ib_mr_wq, &pool->flush_worker, 10);
+		} else {
+			/* This counter indicates the number of redundant
+			 * flush calls avoided, and provides an indication
+			 * of the load pattern imposed on kernel.
+			 */
+			rds_ib_stats_inc(s_ib_rdma_flush_mr_pool_avoided);
+		}
 
 	if (invalidate) {
 		if (likely(!in_interrupt())) {
@@ -670,6 +683,7 @@ struct rds_ib_mr_pool *rds_ib_create_mr_pool(struct rds_ib_device *rds_ibdev,
 
 	pool->max_free_pinned = pool->max_items * pool->max_pages / 4;
 	pool->max_items_soft = rds_ibdev->max_mrs * 3 / 4;
+	pool->flush_ongoing = false;
 
 	return pool;
 }
diff --git a/net/rds/ib_stats.c b/net/rds/ib_stats.c
index ac46d89..29ae5cb 100644
--- a/net/rds/ib_stats.c
+++ b/net/rds/ib_stats.c
@@ -75,6 +75,7 @@
 	"ib_rdma_mr_1m_pool_flush",
 	"ib_rdma_mr_1m_pool_wait",
 	"ib_rdma_mr_1m_pool_depleted",
+	"ib_rdma_flush_mr_pool_avoided",
 	"ib_rdma_mr_8k_reused",
 	"ib_rdma_mr_1m_reused",
 	"ib_atomic_cswp",
-- 
1.8.3.1

