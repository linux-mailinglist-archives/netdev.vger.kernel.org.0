Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 535BF4928B3
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 15:47:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343913AbiAROr2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jan 2022 09:47:28 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:8466 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1343801AbiAROr2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jan 2022 09:47:28 -0500
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20IEkPrn017986;
        Tue, 18 Jan 2022 14:47:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-type : mime-version;
 s=corp-2021-07-09; bh=ZOx/UyJmqFtjfYwCIhqYIqXT070tUzKm19R2TP2GxXY=;
 b=EAsY5ZVFiuCAJ3/IHmv4GaupXFdAdkNXHCY8490hA434+ZId9J0hL/OwJxKac7jfFR7i
 IHzmgIrkTUWTpLrYb8Ni/Y9IS68dTtO6TdoRr+KhtM/E5QnzSvvXBiKEaEhpo2Yj4L+K
 nNzrKvzHY8P0EtBXL+sKLmbul33g7MbOLYYVsjdhqmGasfB3sslqbcr4oMqLgo1ecwMh
 FSGC96TfaENeQH73OWzkV9Glpu6cRF4oEUL/cS1YkzrcbaGjFgKB516IgO/yTf9uakYD
 fR/1MMXChzXibug/6JmI8gsy7eL52AtarR0YwcbQwwIYIBn63aCtYgkFYoOYQtl2BYuy oQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dnc51a07n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Jan 2022 14:47:24 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 20IEkMvn015371;
        Tue, 18 Jan 2022 14:47:23 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2042.outbound.protection.outlook.com [104.47.66.42])
        by aserp3020.oracle.com with ESMTP id 3dkp34a0u8-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Jan 2022 14:47:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FFW/30A3X8ysVdIo8r1DXmpLIHGkfbwqcOpOBQgjJim8fPvFIPV80TYm+CmCEkapxIYE2QCv1WnX0Z3L1fBU4whn81NyH2/COw2JtJwKifhzHMjuZ1gZ3lI94wPMmOZA2O5mKURy2iXxeW+yT+WNxCo+LeoTlF7pOqMq7YqBhd+SI/v0LRM3Py/DFp9ywl7XO+5qZa0E0BstZ5Ih0BT6j4LTGEmFArnG1LfwKeuO9KWFsYn2FkCFVm8ssO3FHwCaqO67g4WGRuLqJ3a86OWSttfyF5sJywORfNh4ke0z00Ss8fxTyoDIalkRqMSvR1nY6NKc1JkuRga/ePuz/qc6PA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZOx/UyJmqFtjfYwCIhqYIqXT070tUzKm19R2TP2GxXY=;
 b=flYi2iTth+XXvhpdQL7B/QuDZRC+cGpzN0jkpL3Oe5UDifqpsYkQITy3+IszVMBKyQnj+3z49YP1WoZeahGYNwcBJ2XetdAPIjAbtd4DDjCeOQIo3KtApZzAw2ScA8atnKsAY9lqVCUCKF42wtgAo4Zd6tb7iNpXgZKAcK7ereexgjgVe0MxJdJ2FxuRwOTybC4JMZY2TgYYJzP8DZyv77oIuL67O9z93geKW4TUNa3z34pN/cMqWbbNZDJdxNfYjVXlQB9ryDJ8/KBoQSJDwttaxxiSPSLdUuIFHQPYiYU04UhHPWtK1aqXARqNYyYmA/0QEf+1N707BE+ZsywlSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZOx/UyJmqFtjfYwCIhqYIqXT070tUzKm19R2TP2GxXY=;
 b=hvcBPUqJEc3Av+UKxerG3UnhWczNpgpkoxz5e8cqjiXbNAShoPlqyJ5MkeIKlH5Wv2+kh0Htsk+WUkCZD3YuhJDdXvWvIlEoWQEHdCWHb41EdInY9ZnNJURCo0pSee04DIHX7rXwFVlSMj2rRDVXu1J5CHto7PmPgoj9mOuK4Tc=
Received: from PH0PR10MB5515.namprd10.prod.outlook.com (2603:10b6:510:109::7)
 by CH0PR10MB5260.namprd10.prod.outlook.com (2603:10b6:610:c4::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.7; Tue, 18 Jan
 2022 14:47:21 +0000
Received: from PH0PR10MB5515.namprd10.prod.outlook.com
 ([fe80::edcf:c580:da6f:4a5]) by PH0PR10MB5515.namprd10.prod.outlook.com
 ([fe80::edcf:c580:da6f:4a5%6]) with mapi id 15.20.4888.014; Tue, 18 Jan 2022
 14:47:21 +0000
From:   Praveen Kumar Kannoju <praveen.kannoju@oracle.com>
To:     santosh.shilimkar@oracle.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        rds-devel@oss.oracle.com, linux-kernel@vger.kernel.org
Cc:     rama.nichanamatlu@oracle.com,
        rajesh.sivaramasubramaniom@oracle.com,
        Praveen Kumar Kannoju <praveen.kannoju@oracle.com>
Subject: [PATCH RFC] rds: ib: Reduce the contention caused by the asynchronous workers to flush the mr pool
Date:   Tue, 18 Jan 2022 14:47:18 +0000
Message-Id: <1642517238-9912-1-git-send-email-praveen.kannoju@oracle.com>
X-Mailer: git-send-email 1.8.3.1
Content-Type: text/plain
X-ClientProxiedBy: SN7PR04CA0162.namprd04.prod.outlook.com
 (2603:10b6:806:125::17) To PH0PR10MB5515.namprd10.prod.outlook.com
 (2603:10b6:510:109::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 96fc8bdf-02d2-49cf-8355-08d9da916e83
X-MS-TrafficTypeDiagnostic: CH0PR10MB5260:EE_
X-Microsoft-Antispam-PRVS: <CH0PR10MB5260D57CE26CD53E3A8A46258C589@CH0PR10MB5260.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:327;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SurURjX/VX/c2s1YbS+yCJj2LCSV/keUZI/06K3vMhk0O4N62Qfu47BUM6iEmOht4OjEEZkz+UPVJcJD88nb04CVZ3CeuupHnoFnyyniMMNL3yM5FfTa6ua8B+DfAP/tu2BjDhkW19N9JVsQm9kz+fAk/Y8B8NVuYdfspTdN1rCesoBR3VBP2Iq1aiTIMUxiYgtLXvxi/J5eQIjXX64XZvmN3NCxG2qVcsIzupsCra8kJhfzdBJIn5KeqOPkafAfzB8n4JpD/K5O8LtgDRuJTTIaTiBPZBqAZYawCJmnoEl6AIWPbjDaziXzDDGB0HAYpZyvhchvW9DED3JI66AE7bDovMKU8q0Rw1Y1EH1XMwnb1s+aC2YAbrhj3wpxSQHvcnyDCxQaUoVeVsmKui1sO5PfGcH3aWvJsPWFpB8RZ2NavjT9DM3UEDJYYjOMM2E8M/28zC8Br2owOcjpwHidlTdA5VD4QtuPhqHH2QlaCeykxQdJFJLe5+I/+AfYySitKTZ9fouEcYjfGqrCg3kRdTxasTRQfDawj9X8e5FNnLu3XUix35F3+4tJc4l8RidcXmbElBKix6nBysxye6WRu4WOvsR1F3gPfz1zkEbuNaLp0KiSGmGQvP0T5QlethyEtF8/6huPYB9S19wzrA0ZVLst+d7TAp6oIQaDJaYFUGQwrbJQ6yl8SkuqrYaJVSI9Ko0ayEAYmMjdwjYC9s1VQg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5515.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6666004)(86362001)(316002)(83380400001)(38350700002)(38100700002)(5660300002)(8676002)(52116002)(508600001)(66946007)(66476007)(66556008)(26005)(2906002)(6506007)(186003)(6512007)(2616005)(8936002)(6486002)(107886003)(4326008)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?MA/yowDZutI4yJbuLUQd2DWk4BAGf9adweVZmzfEJuiTIr1UWwvsWVVIJMEK?=
 =?us-ascii?Q?usglflCjbuovkaTyRE1JQACft+1BEZK1VQTfbjoF251YrRstsbvp8YTLYBAu?=
 =?us-ascii?Q?1jezl/Gj/GxfVVDaSyx0sWwvy9Tq5fEuHOpGW6r/c64iSXuY/wCdVWVwLnQy?=
 =?us-ascii?Q?B9FbmGY3ToiLQWWDZLFSWPyJJx53weBaklNR6LcDCr3m7AziYrzrZ1sfkOkz?=
 =?us-ascii?Q?1v8VgbagacJmr1WlFmL6yjRoXlQJWI/qf2pbUwlVBWm0Zms2ZwEjdUbEH67F?=
 =?us-ascii?Q?acfQdUS/RdCMhBJO8W13FKrzcIBMAG3vNz+Vtd0M0NadOx6AEkG8OExIBSzS?=
 =?us-ascii?Q?3NHlhAm+h4fqifSU70i5jEnPq5Y0o3VmlnVt4UG8qBNHgAWSBO/LgNOMu5+e?=
 =?us-ascii?Q?zi3JzVDvyLZns2I6PviZWiOd8gyJu7w4p47Pweo8ATm1A/XJREIjdA7fL409?=
 =?us-ascii?Q?nJquDm29sMV+vAwjBGp11E4nauiscsGC0M5W4UtYa1Ef+LOw+n81tyDCgHAn?=
 =?us-ascii?Q?pouPdI5GJ1D9s5Zsy7oBmjmhElEvrzXwyq8tT5rtJww9gEBl5EjUD70tvmSR?=
 =?us-ascii?Q?pXlI4E7Z3MWyr/L7AHYgs7GRSx4wIqnnKOodGNMiUn7hHb1Tz/n6XWJLXGOG?=
 =?us-ascii?Q?1QaAmW0fswb1fBt1iR2zqgAl7oeG/vA2H6gXiiYswvzsrM3TVLZVU3CvPHCH?=
 =?us-ascii?Q?VJnr6KZ2sSc+Jv7Uwc3SU0tBXD5FxV7wcX9PVuuJ7mdYhCdg9Kx5/PCu2uGn?=
 =?us-ascii?Q?EBLVL0QS3FH4QwWoAm7lWXgAxmyK9al7w6ioGVr+s+giNfWBeA8vigSG0mid?=
 =?us-ascii?Q?R52orHR4JThuHcsYt2jegoVxAXj0s5P3ILOc88Ek73tjmZG2HO+N01DCmwj9?=
 =?us-ascii?Q?gwt5C6O93lt3nXgg5noSQ+3li2HxW8kG+P1FqfANCVLU507773kyKnO5b0aR?=
 =?us-ascii?Q?erPrwyOibRk9IXUBdcM0p3rpTtFyns9kJUQgtIbD38u/sAMbQvFITy6n2ia8?=
 =?us-ascii?Q?FSHIf76yc0xzuid9YqaEYe8k4NGda9pVaP0SSPvcEQaBjeau8ogwhOg3Mxx3?=
 =?us-ascii?Q?XtFPHp6AD+j5/wxXy27uxhHeVwmsktE7BUJhgIB+GjTfWajmIwhi0gzziv2O?=
 =?us-ascii?Q?o8fTh8siJ0qJ49tn7kDJfO0rdpaBotfxbR1wvxW8NMS0Nc0qFhrTrGJKzf4C?=
 =?us-ascii?Q?fHBcyEDt3WQwsNnU1oC+7k+cak8/UEUop/DJ9oYeQNyOvQuw/FyA/S9U8Vde?=
 =?us-ascii?Q?IMSr0QheyTmj5dEP63NZba1ryI2S0Py7o3iCdtzmF2MLORPxoySXpIbpt2yj?=
 =?us-ascii?Q?smnkpVNLnqeEdtwHN2AeVrTsVJ8LS5JZenPlVK/v2YzzH/gjwy+aViRMGylv?=
 =?us-ascii?Q?YxJaPyUlQa2eTOVd+8Xe46M8PYrqbvRF9aAz6bAr18ycCtFiSMDoJ0ySyHzu?=
 =?us-ascii?Q?sx0oDFiD+qOmkwp2pypJ4ylhI3ny5Qqieo732J+Y3xl2t163+P8BJPmkPYLa?=
 =?us-ascii?Q?EDlEhRjoOBlaervy5MtjhBJOJD94494qBTRsGGXQVXfLDG8dtr67ehM/LFsr?=
 =?us-ascii?Q?+5ZToOKMVxkILfJYPMwKwHAgspQp+LGS9/sIUCnoj1Ly/8odFjf8qy0P3QTv?=
 =?us-ascii?Q?rnx+vM5KK22om4BGk/U4rd8Ehkk1d/NEb9wWnjNHqmSoz4i6ZZs7BJNalH41?=
 =?us-ascii?Q?oSckFw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 96fc8bdf-02d2-49cf-8355-08d9da916e83
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5515.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2022 14:47:21.0736
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cP8zYic5QpOxzZuKj0ptkIduEqrPTOUJiLXx19MQjV1Cv0SAwTccEPYSl2P5UwquVt/3DVY7Dh5Al6s7dvJ4tuMwpXOHfYxgEwR0w9O0Jgg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5260
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10230 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0
 mlxlogscore=999 adultscore=0 suspectscore=0 malwarescore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201180090
X-Proofpoint-GUID: LtysyrPv85yy8Mcufn2YeInKFhSGJ6c2
X-Proofpoint-ORIG-GUID: LtysyrPv85yy8Mcufn2YeInKFhSGJ6c2
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

