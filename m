Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 730A04C54B1
	for <lists+netdev@lfdr.de>; Sat, 26 Feb 2022 09:51:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230313AbiBZIvi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Feb 2022 03:51:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230292AbiBZIvg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Feb 2022 03:51:36 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF3B37C171;
        Sat, 26 Feb 2022 00:51:01 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21Q4n0pP008190;
        Sat, 26 Feb 2022 08:50:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=KULiEBIbcn9Eo3Ut40u3HCw508xCB4/Jx/reEsrZzC0=;
 b=AHILOU2vJkR/7plCSGEA/t8i9NtFie8Z5sZBPFLmbq2f8ieE+4PUl+RWKdbHtY27QWAU
 rPfJ2vENvQFjixeUwGVKJszytAw7Jw+vv96cioKbHCvJVLVIiJm+IcgFlaLxHJNQVg+6
 ymfGMdF4jWxZ0c3SDADSn7l+XVy7Ii018SwA/8qIBxGM3Et3kQDSW1ZvDRkpCLScbjm9
 MOkJHCji8P8OqCXS228+MkR85YwJ7ASd6llZdmVSqenr1pk5reEu3KEjZSrGpsdOdybx
 EDXVnFZpYQBgYsgBNVNaUeBo6fh6XBa2EpDvOGuB6cRrzFfCtF7gvNN7Xe7bz3M3ovg4 6A== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3efb02gdu0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 26 Feb 2022 08:50:00 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21Q8kO7r005020;
        Sat, 26 Feb 2022 08:49:59 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2170.outbound.protection.outlook.com [104.47.55.170])
        by userp3030.oracle.com with ESMTP id 3ef9askqdw-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 26 Feb 2022 08:49:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K40YzUD+AXWMUA5NCeSaRxCXmGyhBKO3RRKS+Cf+CrAGfs2QRtIF/OGOytAMLYcspS5qTis97KBFR9Vexe62hZr5XtROlbp7N5Hoyfn7h+FWh4b3DfTBzkQbMRpzW3HiOAkdAYnaHFBW4Uvq3mchZEeq8c+TR+KVCzmVZBRJpmOX5LCgNxguKfXYxRSoORU4WZBD+tH7TmNsUM9LwtDcI3GAU8niLWSIBhzBPs4DyQzE0SM1J2OMF2rWWWfniT3+U9PpJc6uXWcjif9q+Hc/MqHwuNL7BICpf6JKquuDUdAZhCker2sNut1Kdc1tGzdpLMc/sxQmV2ORA1kVJmpGqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KULiEBIbcn9Eo3Ut40u3HCw508xCB4/Jx/reEsrZzC0=;
 b=oElxz/lBUyS9ClWqEJC1KoiSl3osRmcpE/IiSpo6zoLjN8XyKe4N/x7bMgJvAB9W2UpbSO0UBPWjdN9oDHe4sdtrC/mr6fCo/NQHDJ4jeTzLqz5n1YaM10i1reErN20L0l3FfzQJlHbhfn5b9xqxwOV4k0TDAMno/QPIMUlserO9j4Jc3AGQBpsNtIw1MvwpWRAqpOaFUiMRc5BOwEYZptddSmcpDlWVrx/OTPhFYZPlzNLlMdI46A9DrBDW++cynpKEkAGpn++ASRq/X5ZbKAnRc0St1DwAMWhse1AiQpB68/LB7LB9RXa3mprvR8CTob8pkucoDeHZoW3OtfFl4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KULiEBIbcn9Eo3Ut40u3HCw508xCB4/Jx/reEsrZzC0=;
 b=L0Zizxwykjje2NR/TC4rz2EMQNGo3CwshS4350hS280swduHy29qViYl1ZEndjfYARIcxwb4MSGatNsVhm8CTk8ifM2nKkEWhwagtCqOiE0OzLiFv03U93KVboUg1UWGP8Ocjx5JqwPetv7Zin+Nf7rahB1S6SgJ3QjfWYPBSgg=
Received: from BYAPR10MB2663.namprd10.prod.outlook.com (2603:10b6:a02:a9::20)
 by CY4PR10MB1768.namprd10.prod.outlook.com (2603:10b6:910:c::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.26; Sat, 26 Feb
 2022 08:49:55 +0000
Received: from BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::a0d5:610d:bcf:9b47]) by BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::a0d5:610d:bcf:9b47%4]) with mapi id 15.20.5017.025; Sat, 26 Feb 2022
 08:49:55 +0000
From:   Dongli Zhang <dongli.zhang@oracle.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        rostedt@goodmis.org, mingo@redhat.com, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, imagedong@tencent.com,
        joao.m.martins@oracle.com, joe.jin@oracle.com, dsahern@gmail.com,
        edumazet@google.com
Subject: [PATCH net-next v4 2/4] net: tap: track dropped skb via kfree_skb_reason()
Date:   Sat, 26 Feb 2022 00:49:27 -0800
Message-Id: <20220226084929.6417-3-dongli.zhang@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220226084929.6417-1-dongli.zhang@oracle.com>
References: <20220226084929.6417-1-dongli.zhang@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0196.namprd05.prod.outlook.com
 (2603:10b6:a03:330::21) To BYAPR10MB2663.namprd10.prod.outlook.com
 (2603:10b6:a02:a9::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2b1c431f-d024-420e-6692-08d9f904f5c3
X-MS-TrafficTypeDiagnostic: CY4PR10MB1768:EE_
X-Microsoft-Antispam-PRVS: <CY4PR10MB17684DF4FB381E1B25E6C4C1F03F9@CY4PR10MB1768.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sNqvK3CRhgEr8xzKfamNaIGI+wC5cWoYOi/g0ufdiEEd4wbGVfHgaGpaiZ5R/x6s3n0vRYSwBLRD+QBMKhuN4Mwno0F7YvFOLwKurlDwjxE1a/3NF2TlAAnvyxzwHCzB8LfutUp4r/AP/NVfE1LnEuX2MLCQzQZL4ykjy5O8jg34B0Mn7hYBZi4aEgxzbl56wn3CFbGctSU2dNqLcti3aotiZhLmL/viQoDF8TMZhRjhXDszmThhjRydWT8qxCUTP1z6ql4Gmk0q29gO7iJYZ9D0bDoHlg6uMNJSALSWqJSCz1TYbjgbnPUgod9QowubT1sSBPupeEqajoFy3Ox/zFFMi7xhAOq62auNPLkOQuEmNoGtuRenGXf+H5G2YGgawzAYWUxeXmq8q8qq0WS4EvJTEnTnfcYmbC0SJqjw39RxyVHwE7vOZx7ysGB+2smmMRzgGjK2O1f2QeAkLbMj9ujVS6rESE9hysKHr07HlWdTKHlmMLjrRNeHVw0rXRHrhpScYoxkLXehQ33nEyy28BeVBin4Utpha+STeyxBnbccU7Ot00t5nx8dyvN4+vAwQK7UPVenSTmAeEpDjNd1Q4xSPp5Lc2TF1TpdtnYXTlnJim5luGLyEtVSXF6nqKiVS3Cani6ApbVgIksY91n8tC4A5mOp5B68lapDxqV3TzEJu+JybbeRcI7TMwnBpUETQQ1d82dYIutREX87+Uskvw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2663.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(52116002)(316002)(6512007)(6666004)(6506007)(186003)(5660300002)(86362001)(8936002)(44832011)(26005)(7416002)(1076003)(2616005)(2906002)(8676002)(66476007)(66556008)(83380400001)(66946007)(38350700002)(38100700002)(4326008)(6486002)(508600001)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?X73KnMAgIoNWHepzmwnCxFSmDRoQNK780Tm/qKnI4K1MxXWfWgidtK8yPiqB?=
 =?us-ascii?Q?96aPwh8ejGwswRrggkUq8OGtc3OxK9jMLUpj6S4y19pjDiJyL11bFsVROxES?=
 =?us-ascii?Q?Pa7X/j8NLgpR2A2GG64+DYT7+G5TB4TApot/zpgKFT2rJm1zCcRI/zdRwC9B?=
 =?us-ascii?Q?6MYMLX5Y8rHsb9WfKxwO8SpzT8ZE99XIjQ9ZLZqyyfSb8+IFb5qIqpkETq9B?=
 =?us-ascii?Q?b73G5u6773dooUnLfmstuTqWNffhbkhRnOMlu/veL7dRBXJNHNM3vtXA+E0X?=
 =?us-ascii?Q?q9d8iCTPaCop6w7bfatTxO3cnCBf8sh9W0hMLjoiFWpa6EXTxLxq2cpJYdys?=
 =?us-ascii?Q?ubqkJnRHQ0u9pe9UAiLVsYhPnCyxKYzXZ9C70fRpKNCJCFFpf2Gq4tRssrYm?=
 =?us-ascii?Q?myzlRdHeZjWe1V0Y+JLapx90mivgiHmbr2nwb9GcKu4mWmL2fU/KadTaRCbL?=
 =?us-ascii?Q?/DcEHa2vazsIfKU+uUlOevVH2NGerfHMkOwZDId6wZIy5pL/RgMyFWjqB0Ol?=
 =?us-ascii?Q?6paMB+B9/DCG20mn2qfHAUyXLTPxXl4/lQRZT1KRD5cIXupKJX3jeH7FWBs/?=
 =?us-ascii?Q?VxLovyNndUOH5txDxKRJWExIb0uee78hnJVu3bavlxSWwGQR/QysAyaq3BvG?=
 =?us-ascii?Q?AU4+4WA0fgz49ZBINkszQ4TZQUJ0x+xe9GxGT9tNLXKdxWopN5jgUiNClQBr?=
 =?us-ascii?Q?9SrNz+zanEN4VaXUxNaeID14YqqFqLdD8hfvrdfOWYOQqVRUXp4vH+dLRNEf?=
 =?us-ascii?Q?MtAtdH5Cw0HUQae5DN4ceRIPC0p4mzm3zl9tqRyPAVf4Rthm/zRoh2PJnu4l?=
 =?us-ascii?Q?FjBXU9bjbCxBk7SBJ9B+px8SP8OFFnruTIEIxvLjQByvOf3T6dgW2Ts19fHh?=
 =?us-ascii?Q?QtX3OxIRT2nvDwm8KQPJ617yzWq57aJD6xTM+KKzZNg+I6vl22bSNSwl/0rs?=
 =?us-ascii?Q?kZJTPa2aOtbRLKYLO/x7xHDEeNohWXu6PiFCsrkVM3v8Gcsd/d0R0PYa4DKK?=
 =?us-ascii?Q?HUcotRE4a6IiPQNd1nePeSh8DRmZZqgHMQJZMInkrxzMm3Kzs+4lpD928G/6?=
 =?us-ascii?Q?Uo5NuCOw4HD3K7k+or9UHErd3N/vnp30F2TGKOwehI5+ycC3JpgG+PTDyIVC?=
 =?us-ascii?Q?ZsLPElMB/KdsnSztkn8HeiWlvqVPkHqvHnG6U/3BfnpwEw9trMg48QXcoCXp?=
 =?us-ascii?Q?SgfPW75vQ3cvh3ra54td38mZBSkvi3aUValWn9hiEfoPdoQ7QYxTmgmwjpEp?=
 =?us-ascii?Q?8NELj0kMNvCGcn01l6e7uDV5SFbHOKnW3TgEf4ci5Jmjl6G5rOHDhfwN+7WE?=
 =?us-ascii?Q?Ll/dPq6r5nrH64MYsj+Bels8dvuTMthQbsY2aVJMJDWhNN5s5dMvePwdlV5V?=
 =?us-ascii?Q?uETFbZrrYfN/x4bZ7ledg5egJV0cbbB6tT0coS2Ej0LoNu7XxRFkx/sbhk5S?=
 =?us-ascii?Q?FF3moWCLxIeDjaHnQIOu6sRvKC7HwO8PFCQNmnwjcUdNbRcIAM48uMBAu1a5?=
 =?us-ascii?Q?7LT6mexsyAHhOXgg3Q+JkPh47PAlMBbpClYes2VEzvD5nXBmCsXK8E1rIZs9?=
 =?us-ascii?Q?+YN+kzsYxfEaoPzFm1V0LowMYfEwpC2w+qIJJkdxSsdEmyBdRU/xyKDbF6w6?=
 =?us-ascii?Q?GkkHvjAOK3PS7I7FHI2dwj4=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b1c431f-d024-420e-6692-08d9f904f5c3
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2663.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2022 08:49:54.9919
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: X4xOEFrqyr5KhAbucr9NDiG0VjSKdOI2OX9JZBhfnL8OTyJnTh1Xoo83tW6mm1wGtyXuLECpV+gMZb4+zL/QWg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR10MB1768
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10269 signatures=684655
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 malwarescore=0
 mlxscore=0 phishscore=0 suspectscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202260060
X-Proofpoint-GUID: dLfnqIzUtmsjzVCU4ACEHqQwQC18JO8J
X-Proofpoint-ORIG-GUID: dLfnqIzUtmsjzVCU4ACEHqQwQC18JO8J
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The TAP can be used as vhost-net backend. E.g., the tap_handle_frame() is
the interface to forward the skb from TAP to vhost-net/virtio-net.

However, there are many "goto drop" in the TAP driver. Therefore, the
kfree_skb_reason() is involved at each "goto drop" to help userspace
ftrace/ebpf to track the reason for the loss of packets.

The below reasons are introduced:

- SKB_DROP_REASON_SKB_CSUM
- SKB_DROP_REASON_SKB_COPY_DATA
- SKB_DROP_REASON_SKB_GSO_SEG
- SKB_DROP_REASON_DEV_HDR
- SKB_DROP_REASON_FULL_RING

Cc: Joao Martins <joao.m.martins@oracle.com>
Cc: Joe Jin <joe.jin@oracle.com>
Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
---
Changed since v1:
  - revise the reason name
Changed since v2:
  - declare drop_reason as type "enum skb_drop_reason"
  - handle the drop in skb_list_walk_safe() case

 drivers/net/tap.c          | 35 +++++++++++++++++++++++++----------
 include/linux/skbuff.h     |  9 +++++++++
 include/trace/events/skb.h |  5 +++++
 3 files changed, 39 insertions(+), 10 deletions(-)

diff --git a/drivers/net/tap.c b/drivers/net/tap.c
index 8e3a28ba6b28..b48f519fe63f 100644
--- a/drivers/net/tap.c
+++ b/drivers/net/tap.c
@@ -322,6 +322,7 @@ rx_handler_result_t tap_handle_frame(struct sk_buff **pskb)
 	struct tap_dev *tap;
 	struct tap_queue *q;
 	netdev_features_t features = TAP_FEATURES;
+	enum skb_drop_reason drop_reason;
 
 	tap = tap_dev_get_rcu(dev);
 	if (!tap)
@@ -343,12 +344,16 @@ rx_handler_result_t tap_handle_frame(struct sk_buff **pskb)
 		struct sk_buff *segs = __skb_gso_segment(skb, features, false);
 		struct sk_buff *next;
 
-		if (IS_ERR(segs))
+		if (IS_ERR(segs)) {
+			drop_reason = SKB_DROP_REASON_SKB_GSO_SEG;
 			goto drop;
+		}
 
 		if (!segs) {
-			if (ptr_ring_produce(&q->ring, skb))
+			if (ptr_ring_produce(&q->ring, skb)) {
+				drop_reason = SKB_DROP_REASON_FULL_RING;
 				goto drop;
+			}
 			goto wake_up;
 		}
 
@@ -356,8 +361,9 @@ rx_handler_result_t tap_handle_frame(struct sk_buff **pskb)
 		skb_list_walk_safe(segs, skb, next) {
 			skb_mark_not_on_list(skb);
 			if (ptr_ring_produce(&q->ring, skb)) {
-				kfree_skb(skb);
-				kfree_skb_list(next);
+				drop_reason = SKB_DROP_REASON_FULL_RING;
+				kfree_skb_reason(skb, drop_reason);
+				kfree_skb_list_reason(next, drop_reason);
 				break;
 			}
 		}
@@ -369,10 +375,14 @@ rx_handler_result_t tap_handle_frame(struct sk_buff **pskb)
 		 */
 		if (skb->ip_summed == CHECKSUM_PARTIAL &&
 		    !(features & NETIF_F_CSUM_MASK) &&
-		    skb_checksum_help(skb))
+		    skb_checksum_help(skb)) {
+			drop_reason = SKB_DROP_REASON_SKB_CSUM;
 			goto drop;
-		if (ptr_ring_produce(&q->ring, skb))
+		}
+		if (ptr_ring_produce(&q->ring, skb)) {
+			drop_reason = SKB_DROP_REASON_FULL_RING;
 			goto drop;
+		}
 	}
 
 wake_up:
@@ -383,7 +393,7 @@ rx_handler_result_t tap_handle_frame(struct sk_buff **pskb)
 	/* Count errors/drops only here, thus don't care about args. */
 	if (tap->count_rx_dropped)
 		tap->count_rx_dropped(tap);
-	kfree_skb(skb);
+	kfree_skb_reason(skb, drop_reason);
 	return RX_HANDLER_CONSUMED;
 }
 EXPORT_SYMBOL_GPL(tap_handle_frame);
@@ -632,6 +642,7 @@ static ssize_t tap_get_user(struct tap_queue *q, void *msg_control,
 	int depth;
 	bool zerocopy = false;
 	size_t linear;
+	enum skb_drop_reason drop_reason;
 
 	if (q->flags & IFF_VNET_HDR) {
 		vnet_hdr_len = READ_ONCE(q->vnet_hdr_sz);
@@ -696,8 +707,10 @@ static ssize_t tap_get_user(struct tap_queue *q, void *msg_control,
 	else
 		err = skb_copy_datagram_from_iter(skb, 0, from, len);
 
-	if (err)
+	if (err) {
+		drop_reason = SKB_DROP_REASON_SKB_COPY_DATA;
 		goto err_kfree;
+	}
 
 	skb_set_network_header(skb, ETH_HLEN);
 	skb_reset_mac_header(skb);
@@ -706,8 +719,10 @@ static ssize_t tap_get_user(struct tap_queue *q, void *msg_control,
 	if (vnet_hdr_len) {
 		err = virtio_net_hdr_to_skb(skb, &vnet_hdr,
 					    tap_is_little_endian(q));
-		if (err)
+		if (err) {
+			drop_reason = SKB_DROP_REASON_DEV_HDR;
 			goto err_kfree;
+		}
 	}
 
 	skb_probe_transport_header(skb);
@@ -738,7 +753,7 @@ static ssize_t tap_get_user(struct tap_queue *q, void *msg_control,
 	return total_len;
 
 err_kfree:
-	kfree_skb(skb);
+	kfree_skb_reason(skb, drop_reason);
 
 err:
 	rcu_read_lock();
diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index bc3f7822110c..9f523da4d3f2 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -380,6 +380,15 @@ enum skb_drop_reason {
 					 * the ofo queue, corresponding to
 					 * LINUX_MIB_TCPOFOMERGE
 					 */
+	SKB_DROP_REASON_SKB_CSUM,	/* sk_buff checksum error */
+	SKB_DROP_REASON_SKB_COPY_DATA,	/* failed to copy data from or to
+					 * sk_buff
+					 */
+	SKB_DROP_REASON_SKB_GSO_SEG,	/* gso segmentation error */
+	SKB_DROP_REASON_DEV_HDR,	/* there is something wrong with
+					 * device driver specific header
+					 */
+	SKB_DROP_REASON_FULL_RING,	/* ring buffer is full */
 	SKB_DROP_REASON_MAX,
 };
 
diff --git a/include/trace/events/skb.h b/include/trace/events/skb.h
index 2ab7193313aa..5b5f1351dcde 100644
--- a/include/trace/events/skb.h
+++ b/include/trace/events/skb.h
@@ -37,6 +37,11 @@
 	EM(SKB_DROP_REASON_TCP_OLD_DATA, TCP_OLD_DATA)		\
 	EM(SKB_DROP_REASON_TCP_OVERWINDOW, TCP_OVERWINDOW)	\
 	EM(SKB_DROP_REASON_TCP_OFOMERGE, TCP_OFOMERGE)		\
+	EM(SKB_DROP_REASON_SKB_CSUM, SKB_CSUM)			\
+	EM(SKB_DROP_REASON_SKB_COPY_DATA, SKB_COPY_DATA)	\
+	EM(SKB_DROP_REASON_SKB_GSO_SEG, SKB_GSO_SEG)		\
+	EM(SKB_DROP_REASON_DEV_HDR, DEV_HDR)			\
+	EM(SKB_DROP_REASON_FULL_RING, FULL_RING)		\
 	EMe(SKB_DROP_REASON_MAX, MAX)
 
 #undef EM
-- 
2.17.1

