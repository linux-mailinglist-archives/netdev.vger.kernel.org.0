Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C8504CFF49
	for <lists+netdev@lfdr.de>; Mon,  7 Mar 2022 13:58:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242626AbiCGM66 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Mar 2022 07:58:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241500AbiCGM65 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 07:58:57 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FD414EA2B;
        Mon,  7 Mar 2022 04:58:03 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 227BsdbR018382;
        Mon, 7 Mar 2022 12:57:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2021-07-09;
 bh=5EqviAnDo1EXAPzrCX7Sjcd0q7vJ4g6GIoYbRpUiP8E=;
 b=cFpeErkHFqBTDK9uMEKxWpzuI5V+h+W5CIumqK2AC76L1+lKxN0kCbp0hYK/j31bpqz4
 iRM9CXtn61108iuOOZZDhoGzGrtxm1T8S0f1T2NSGDQEPjw5/dANI1lJ+WA0mMXECUwO
 Sv4KT7o764IdZvSwYLtDtFosl3MK/qNawjXbeu8NA3VzZ3rjLdu77N2VaFckyE/lIcMw
 rV3D/c/QkAxMBEZJi3KmT4n7fsu5nNvTtOHNhjyFT5dV0PIAdq2PheuyFxDwnJRmEC5d
 AL/uL/MQIf1umZR2qWKRrrG2RH6hTisZr8boOEn4fQXlE3xwCQcGx4byrMpBlbJSGTAc uQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3em0dtuqpb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 07 Mar 2022 12:57:53 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 227Cud00039947;
        Mon, 7 Mar 2022 12:57:52 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2108.outbound.protection.outlook.com [104.47.70.108])
        by userp3020.oracle.com with ESMTP id 3em1ahykqy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 07 Mar 2022 12:57:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dws1N2o/74vIDGBJTx1mywAwhlT8JCiX+F17H8EPAgcD084MtSz+mKK5iS6wr8EOKV+HBydMDhur31E3kBlmYDnAo/+fmm8dtjW4wXOO/gupmN3/Z3XB7dcthRvSnRCXpc9gyE+vPaQx6mS3pbw0ldJ3ROGWXwDurJ/Ru3fmIjQssinN4+cfqBCBoDfXquXR/dLY9qkjOFhmfyRAgP78rzRLrQPMwd+ClPcqZoNlezBVxlGgh7nDBgF0yJgMuk5HvBhUULFVcF6ACR+TqkIxqGbfu4zeViHLUuR8pa7C6pSsVJvMRF3u9wcXpRTKoNMiulcDBL2Gv66oFS9i3uh93A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5EqviAnDo1EXAPzrCX7Sjcd0q7vJ4g6GIoYbRpUiP8E=;
 b=ECL7DCYCcnnYFLEm+E39hSCezq9q1xV6r5UiML8cewcF8Dz5kkAsWI9gwaQ6mQr31I/3yK1ubowv7dHFYWahoLX3DLuuDo1IecLs+FXfxo3F5KKLOF2J1PAyF9TT5wNNEI4P/OdWOQsVnK45mTtn+doEC0mM8fPdYtYy8ozYw9zonLz2XahgW4DFBlg0/QEUQsQqypXdDQa2zWrvfohfFqB95rtet0tXaSs5y1hQyKhvSHLuQGDp3vjUkW11yo39fWmvCNQoE+8S4HOQyzznx7mS2uL62mry0y9pPK2TEJVWsCrMBELQjbA9wRs+TpBvnHxoTszDoPWimghf9JNWyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5EqviAnDo1EXAPzrCX7Sjcd0q7vJ4g6GIoYbRpUiP8E=;
 b=ls4llv4HCbCj5pL2GqNf3WJCvRgqaEEHaVsrxvPySO9gQ0Q5KrOXd1FiR0FTnd6rm9Jf6m78gj2cxIPRg8j9IKShXMaA1V2HzkvfonXxdeecOVpKKrosMfxBT+dut7lh9Ndt1GbbW3SjKZcVWjJiAL7Fv1qd0pDsuINJlkEwUOI=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by BYAPR10MB3367.namprd10.prod.outlook.com
 (2603:10b6:a03:15d::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.19; Mon, 7 Mar
 2022 12:57:49 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::2c3d:92b5:42b3:c1c5]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::2c3d:92b5:42b3:c1c5%4]) with mapi id 15.20.5038.026; Mon, 7 Mar 2022
 12:57:49 +0000
Date:   Mon, 7 Mar 2022 15:57:36 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, Roopa Prabhu <roopa@nvidia.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH net-next] vxlan_core: delete unnecessary condition
Message-ID: <20220307125735.GC16710@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: ZR0P278CA0179.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:45::19) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f1601637-a3fc-4c65-6976-08da003a1517
X-MS-TrafficTypeDiagnostic: BYAPR10MB3367:EE_
X-Microsoft-Antispam-PRVS: <BYAPR10MB336792C57E97DCACD98F2E9B8E089@BYAPR10MB3367.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bJqAu3HeGnn92qMDQr9n7oJh8DGWCQ/SGZgMwfjSer/2E71WC+NB6H+WmiB72YGrTmWK/Iir/+Sv7dOguqKeOZ4HoyU08LjgEJYI73eRtM9nAY2m8WMeqi4PKnxSgGSOjJmUkNk6iN6YwSXNKIo4JMRZ4zIcfbFQDhAVcnxxP8k9h2u6/GxO/18ab6HkqsvKDSxHA3m/q3HWCVaKdhPM5JgyaS1MbdmtDGnuP0hhNFg6YoWVTkJlcSkZMKeWJJpATplbcygtoih98cTOcZzSLSmePZke/SvtUdn1YXjGn/AVz95hjVAZB6KVOqXKuSbFQ3HxEBoz7TutCX19lrn8JBR8wuNDHqFwyzONn/PunY83qiAPomO2kmsnetKQfC7KyRU7mG5MniPFdn7VNkLNUbZalrBCwat1mt2yZVgbyetWonIdyOxOBzgpeO4Ee9vnyZCtIdeSDuA0A7OrmYzguVaHcNfvsvAD4flBhvJM39T3F96ZBKrjaWNBelWPprJbacN/vBzNC7MtRL/7lDGa/kK7HKlBwnGs7OfNYINHbf3hgoMUGBHdsyEcZGMmZH2WO/sKQljjds4dPVIHx22Ggo2bbJMrj+Aif/ayAkAVH1APVccZPV+1tnviUvjl3H8GgjXb2hpr/szxxymyeig0s3ythjgPJX3ys7JYvhk5rrjlRtnob716bTj4PDQFUPUyI08oxKh7KzgKS7l/B9N8gA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(83380400001)(66556008)(66476007)(6486002)(6506007)(8676002)(4326008)(6666004)(52116002)(66946007)(8936002)(508600001)(54906003)(316002)(33716001)(110136005)(86362001)(6512007)(38100700002)(38350700002)(186003)(9686003)(1076003)(26005)(2906002)(33656002)(5660300002)(44832011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?GdlErOcEOrp1hCjjS+4j6JQ8yIczt5iqyPusQj17HythdL4qww9LtqbZUPXd?=
 =?us-ascii?Q?x1PTCRl72uxNlJvSCOQVYs2Kfj3vp8ldD3qvd++yBf6fLtJT4IjeHnZRXSbm?=
 =?us-ascii?Q?zGRy3Z1FDXLAR5aUBHM6MkeizVeNgOM0p4q8ZbY1luo4eM9yXqRKG/t7OgJ8?=
 =?us-ascii?Q?db5+MhChr05U81d9RF8GYE5x8b0006/9B5ylUlEveEnnvwvpdpMRWw1pKOvy?=
 =?us-ascii?Q?XjzJdGyFdKFhbTiKjSqJV+544UQdJqB8T3Bo/vOnWydjns5U5usHs0NCTiua?=
 =?us-ascii?Q?SfobcUXvD5E49Uv2qf5wx4uaEPNlp2fIa+HNR0RY0k23mYl65OrtoFvz2q2X?=
 =?us-ascii?Q?PBSOo4Dn7BHFjVA3P1A20VxG7jhGQEXcOXLTqYa3FInYLblwDhQYWeXWFnwK?=
 =?us-ascii?Q?A6LJdGqwGhkSQEhxqQ6M7PuvR7gLLT20XhCuVvWjkYZMdKjY6HsS8v8T+rU2?=
 =?us-ascii?Q?A3iZzSh4AlOlLTShu27UqZbGm0lx9LlZtARCiwMgDwdEtZ1cksuTagEk908P?=
 =?us-ascii?Q?Zt6sdB9AVWM+dS6svMhe05WwXPTFISCvY/CDvSbcffwlDNju3lXrjE2uHA3I?=
 =?us-ascii?Q?kDb7Q625CbaCiuRzWFdknvO9E9kNE3s16m/oQN0m3wtpBc4QWFddIxbv5HAN?=
 =?us-ascii?Q?PWYq/cwwHWZwNIQMbrT6mVa7jXDTJZLn6iQOcNyx9CkWf/xEjGfFsC+oKrLA?=
 =?us-ascii?Q?DQiRvROXscqR56uDZscph8nxn+UkVRXM5YC6b5LHHkVLLhpzwg/COAabl/6d?=
 =?us-ascii?Q?RW4zCqdljF+TWlaAFR21hstFmPF8tR2bbPk0L0H3yyV8nFm8IGkz5obfphF0?=
 =?us-ascii?Q?ZBF9WQyIKx9MAlX3H+79SlmUkDw09B7lo7E+8Y0g2fMNbH49LKxKBefhwnQr?=
 =?us-ascii?Q?3GqtoV+5Fpd641TfBQmgiA5mJ+aX2MXsaDlFjRxUMTG1nXRMnQHgxj97uohF?=
 =?us-ascii?Q?D+hQVWhUwcrHrfw+HDigiPSjq20tEWFdq38yiFIDa7Ijb728avf1ZmhpK3bU?=
 =?us-ascii?Q?pW+xKCpAnFt1Wv3H5tkXOhPy9pulZu3/vovxwoKLfSm/186q4wWdBOs0N1km?=
 =?us-ascii?Q?c2BEu2fzslnQGF6mkqFCe5df1bN/GQXvBdhAgJrNVK8wt9D9xwFioMCQ6O8E?=
 =?us-ascii?Q?lTaYSpt2bwAW5FShuZxhFnatRe8fFz4UGL2QknPjVXUnEvuHOt3nSkCGqe9W?=
 =?us-ascii?Q?kPeHwRoiBEUYrA2hDiO8bToO9oYvjBOaACMdTt0ooPBuVET1pETcmibiLlm7?=
 =?us-ascii?Q?bfMo4E+kbCdEYUp609iEkTWQHF9DP1nYiwsMM57LH0Q9rAYtanYl19aR9CNq?=
 =?us-ascii?Q?YU1+LlRd0SSeLLGJoNhDGjRwuAIWi0GxbojLfjBOLOu4bsVhCXR5MqUMUc6R?=
 =?us-ascii?Q?G49ZoyfGnJH7ehs7LP9mnNf8n/V9B5bNAm+reNGO/DXoneqCNz7C57GG6MeA?=
 =?us-ascii?Q?VXcwg59zCviOxNcbqb5xOCLD0n3CnyrCL7IF7KN7m4JX5GbVD50EemnoT0Fn?=
 =?us-ascii?Q?wDosP8ZFJo//1per78isP9G/eWce54og7KMbOoldMdmquHcopSxde7xD6r7J?=
 =?us-ascii?Q?bj/2sM2ZCsrAkXEJWQxmQJ4NU5AMeYZsbBRwrw0OKGV2pQxLDOMP3tJlp3OG?=
 =?us-ascii?Q?Q2JL7wXyY7iTE2PTreshWTW1d5lcwKaXJS51DgIqt1bqL/ZDP8r55NH2rHds?=
 =?us-ascii?Q?iWdowQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f1601637-a3fc-4c65-6976-08da003a1517
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Mar 2022 12:57:49.1899
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0mRxivuFT6wpbMKbalEym1vBGAxjaK05RSzu9KB3tpHFr4cAsu3ieXcGDAe5pFvegsu2fQaa9GQNUFnFyxxtMX0wNqXjQsnU0BessXlxsdU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3367
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10278 signatures=690470
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 bulkscore=0
 malwarescore=0 spamscore=0 adultscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203070075
X-Proofpoint-ORIG-GUID: EaqIvi7X6HKFi78xAakiJ0tIF4eTR3U1
X-Proofpoint-GUID: EaqIvi7X6HKFi78xAakiJ0tIF4eTR3U1
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The previous check handled the "if (!nh)" condition so we know "nh"
is non-NULL here.  Delete the check and pull the code in one tab.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
This not a bug so a Fixes tag is innappropriate, however for reviewers
this was introduced in commit 4095e0e1328a ("drivers: vxlan: vnifilter:
per vni stats")
---
 drivers/net/vxlan/vxlan_core.c | 54 ++++++++++++++++------------------
 1 file changed, 26 insertions(+), 28 deletions(-)

diff --git a/drivers/net/vxlan/vxlan_core.c b/drivers/net/vxlan/vxlan_core.c
index 4ab09dd5a32a..795f438940ee 100644
--- a/drivers/net/vxlan/vxlan_core.c
+++ b/drivers/net/vxlan/vxlan_core.c
@@ -811,37 +811,35 @@ static int vxlan_fdb_nh_update(struct vxlan_dev *vxlan, struct vxlan_fdb *fdb,
 		goto err_inval;
 	}
 
-	if (nh) {
-		if (!nexthop_get(nh)) {
-			NL_SET_ERR_MSG(extack, "Nexthop has been deleted");
-			nh = NULL;
-			goto err_inval;
-		}
-		if (!nexthop_is_fdb(nh)) {
-			NL_SET_ERR_MSG(extack, "Nexthop is not a fdb nexthop");
-			goto err_inval;
-		}
+	if (!nexthop_get(nh)) {
+		NL_SET_ERR_MSG(extack, "Nexthop has been deleted");
+		nh = NULL;
+		goto err_inval;
+	}
+	if (!nexthop_is_fdb(nh)) {
+		NL_SET_ERR_MSG(extack, "Nexthop is not a fdb nexthop");
+		goto err_inval;
+	}
 
-		if (!nexthop_is_multipath(nh)) {
-			NL_SET_ERR_MSG(extack, "Nexthop is not a multipath group");
+	if (!nexthop_is_multipath(nh)) {
+		NL_SET_ERR_MSG(extack, "Nexthop is not a multipath group");
+		goto err_inval;
+	}
+
+	/* check nexthop group family */
+	switch (vxlan->default_dst.remote_ip.sa.sa_family) {
+	case AF_INET:
+		if (!nexthop_has_v4(nh)) {
+			err = -EAFNOSUPPORT;
+			NL_SET_ERR_MSG(extack, "Nexthop group family not supported");
 			goto err_inval;
 		}
-
-		/* check nexthop group family */
-		switch (vxlan->default_dst.remote_ip.sa.sa_family) {
-		case AF_INET:
-			if (!nexthop_has_v4(nh)) {
-				err = -EAFNOSUPPORT;
-				NL_SET_ERR_MSG(extack, "Nexthop group family not supported");
-				goto err_inval;
-			}
-			break;
-		case AF_INET6:
-			if (nexthop_has_v4(nh)) {
-				err = -EAFNOSUPPORT;
-				NL_SET_ERR_MSG(extack, "Nexthop group family not supported");
-				goto err_inval;
-			}
+		break;
+	case AF_INET6:
+		if (nexthop_has_v4(nh)) {
+			err = -EAFNOSUPPORT;
+			NL_SET_ERR_MSG(extack, "Nexthop group family not supported");
+			goto err_inval;
 		}
 	}
 
-- 
2.20.1

