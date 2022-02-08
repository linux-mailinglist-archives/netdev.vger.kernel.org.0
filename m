Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D86974ACFF6
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 04:56:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346605AbiBHD4c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 22:56:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346586AbiBHD41 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 22:56:27 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 533E1C0401E9;
        Mon,  7 Feb 2022 19:56:27 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2182heIi004452;
        Tue, 8 Feb 2022 03:55:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=80XCyxtM54pk/m3McabUOojmV1zB7KPHD65XkaCXA4c=;
 b=KfZIuNUS2X5iQxDHvJEaYBXD0nFlT62wuKRskhqHBHGcxiaJ9ugwGS6o4nm/Ek3EyDPV
 LLqmNgzkV8xEjOY0TqjDJgUULwWBvevx1A+Go/uBJ7OogbNT3ZJbl+fXNNdxi0vLXmmn
 i5t29jKThQcfzVDMHXTra3ci6qGOIvBX9oNE9+aS4GNXC9LiGkWsqlWxcRv5aWONv2GE
 EUE36r0gOdP8o9xKYCc8SCkc+csWeDE/B1eOB2dsO/vE/aB+1QynssdqIwEoEFMWorLG
 D08pVxObeBV7CL+yv8vdDu+VKIK7V3MV3vaGoIq/sac4GBEReNg11+rLjoHj8nr05fiI Aw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3e1g13r7w4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Feb 2022 03:55:36 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 2183tWpr009521;
        Tue, 8 Feb 2022 03:55:35 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam08lp2174.outbound.protection.outlook.com [104.47.73.174])
        by aserp3020.oracle.com with ESMTP id 3e1h25ckv3-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Feb 2022 03:55:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k2dqXkfmYDX2bpUnCvQa2GJdK1iFYYACzMZm+DRUicTGTW2DdkLvw6ahrtbbcWTi/a5+5dmU4Fh8Oz9+Uu2aMIkQC7wjnJ2zFo98MEP05ZfKUIru4RabZ5xu7xArEE0G9TGeOJ6TVBJBM3fnu4hbn6bx1NQ8bVNYN+I4KEZXWWdrwAumza72nDvoXm3tiLRtX444Jvq+ejDjkdP6EwKdS4R1uDfI15DDT/K6ePUlICmDOSIy8MwhAlxjmFF94E8i7R/gYOIQ2HTpCizO6irh1RI2P0xmY7jPReNc+KPT7PrgRnZaS7JUPm1FEAs3iO9mEaKFfbbMifqmEiGXDH8rbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=80XCyxtM54pk/m3McabUOojmV1zB7KPHD65XkaCXA4c=;
 b=lC0d1ASrQx1wZcn7JPJi3vsuY6CMPpcptkcUMqcMw+XKdHsiv6a59tBLZqKz+cJynb3lffL4esPN+g6Dg70pE0R0pt0x54wbOCiLZhN15fw4mAoJiWdqJr4YGIxJuPRKLSo4IOs8Z8fqGOr8O3Zj+iutFUumPTR2cTw6Fv3rtQSlws8ohQtWBjar19eiq1UIGwQ75AEFeFDKWSrKflmQrmti4ZWGOXuINnn+W3/4tXHvgm1g7Z2jbsm6siffyWSUo2/wnlCtRT9EWXOSAiAw3KVi4XntDEJIaGUtVXDLQte+0daViTScSDKvsz1UcyObXpK/1DhiuTme7lluPIgt7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=80XCyxtM54pk/m3McabUOojmV1zB7KPHD65XkaCXA4c=;
 b=UuNOmXo+vHf986m7gaNEzJZOwpdAO7bw18rhH4fTum9teY0GR8PYolcSM1juzylmDwDnvjDho2l9rbo6pFEjHtrwgy9k5WXr3haLKxUCog1C8m6Q6ZGH2Hk1VHseFGdAif9+C2zXJvVLwPo61x25mn8tG+uDH8VHvitr66yY0f4=
Received: from BYAPR10MB2663.namprd10.prod.outlook.com (2603:10b6:a02:a9::20)
 by CY4PR10MB1352.namprd10.prod.outlook.com (2603:10b6:903:28::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.16; Tue, 8 Feb
 2022 03:55:33 +0000
Received: from BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::a0d5:610d:bcf:9b47]) by BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::a0d5:610d:bcf:9b47%4]) with mapi id 15.20.4951.019; Tue, 8 Feb 2022
 03:55:33 +0000
From:   Dongli Zhang <dongli.zhang@oracle.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        rostedt@goodmis.org, mingo@redhat.com, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, imagedong@tencent.com,
        joao.m.martins@oracle.com, joe.jin@oracle.com, dsahern@gmail.com,
        edumazet@google.com
Subject: [PATCH 1/2] net: tap: track dropped skb via kfree_skb_reason()
Date:   Mon,  7 Feb 2022 19:55:09 -0800
Message-Id: <20220208035510.1200-2-dongli.zhang@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220208035510.1200-1-dongli.zhang@oracle.com>
References: <20220208035510.1200-1-dongli.zhang@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: SA0PR13CA0010.namprd13.prod.outlook.com
 (2603:10b6:806:130::15) To BYAPR10MB2663.namprd10.prod.outlook.com
 (2603:10b6:a02:a9::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 71018ff7-9931-44cf-562e-08d9eab6db5b
X-MS-TrafficTypeDiagnostic: CY4PR10MB1352:EE_
X-Microsoft-Antispam-PRVS: <CY4PR10MB1352D3EFCF80881B48BF3ED6F02D9@CY4PR10MB1352.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: N2GHdDKEVVB0Cs0/sgPoXmdLy9M6YpqOYosfdX+3n3d+3ZXSCnfGIVuy4FTcgawHK70lj4aae6D38tBRubSEV1Sbx8OPl03ZscDLDC9ISQ0RCvzpAN0ub65IrKZmtZD6BnJjABanza0v9daMBWVmhNF7lYY+E1T/wDefO0vzw3tTv9btXtXekkZXnUuQc3pCzqKF8llMv0qMrkVuvMFb7pxnCMudn95l3IDbA4OmuAfs5naqgS0FrN3H/xo7YWFDZYN/ruPunRlc0z5S2KJeBD894fstjqyNMO0iQluqnzGvc/uVfg7Jep5hNBuq8xpSnLgPLXM18zaXGQEK3CNvEHcpf+lw73cvkC7DAjIAnJGecZKtDElBgyJjdAz4Lo+yMVUQO1ch8fJrlJIo36OTo/UH5VChL2UdwCFz6Sr9OPX40kbCTTO90s/VfASyccaZh5MAMBwC7+AMLFbVi3zco3hWsLBKw2zfliv5XXvDHO/dL0Fgp5z/cLkoSnIDrKKLVmf+EXognXnJmMrHZcHTGF75GIhycdyu3g80xR5j6wTCt2IO0ulLQSOCN01SLNczDuxtuRtVe98z3KxcXtxQ0G1Us8IekXH8pSaSFoolplm1sJ9tPb0OGSl1YuM/SSAsCuq3BNWlIrG5+wVDwBLJ7LsE3jxGkp/uDwfFc2ffOSGykFtnX1EKkutxQBW3m+eRJblQKnjjbydxrCh7+KSP5A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2663.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6486002)(4326008)(1076003)(38350700002)(38100700002)(83380400001)(6512007)(26005)(186003)(8936002)(2616005)(52116002)(6666004)(6506007)(8676002)(7416002)(66476007)(2906002)(86362001)(36756003)(44832011)(508600001)(66556008)(66946007)(5660300002)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?BjqBzQcEYdVQVlvAEY3CKCnlPsZoTSeb+qGPmEjxdnf5PUD2ZC5bBQ4oUEFD?=
 =?us-ascii?Q?N2HFeapbe8rbMOqWipIy39aqPqfB42ySdBcLBGoCV2tclLXvTeMW+qsedIdV?=
 =?us-ascii?Q?PZKHQZzA3WDExswWVOKYe7QlaqnYquqNxaNpcazX9AMFdUlRxrROcXvm9hYB?=
 =?us-ascii?Q?g3mL0j7ymcEy2TTrgM1hNL8tMDas/7BlfOIHfL9nKp9i+TFi+pSRTbJiptqo?=
 =?us-ascii?Q?tnJDEsKNru/14iDGcYoAbrTQQCoNwTE+cJVd68kr3bVyQjFTB1y820ht9gtl?=
 =?us-ascii?Q?5SYbRFeZxgND6oeZBjx8DiFeVt61ZJGUseR8zaznVMagz/DoaDUbt4CVJ1Gj?=
 =?us-ascii?Q?RMJpvglVXVEdNM3ewF1dCa0IYZcd14zNTXBkNENDmtkAsghWVVvrLBLub4xl?=
 =?us-ascii?Q?lZuJXgaV3yV9nW000R3A8Omwm+4jFdHOx49mzEdavySZPa2H7oXguv7NQ9Dx?=
 =?us-ascii?Q?wcF9p0JJsUQhSQ43JpQ357qgdyoUr1ySqNiPEvGaYiaQep/Kxuj2k1Ktysi0?=
 =?us-ascii?Q?LnQl3nGVDO2wofqFLXKIVBJJdDtcJ4L5p1q2DBX5yU38KIbWBiAx+JBeHqmn?=
 =?us-ascii?Q?FTK8HZKgjnjrmeIyRDQZKZM7yyp6AcdkSWTZhJqKIUmtHL27IlflMC/3sXjC?=
 =?us-ascii?Q?XvXjrm/3wL8cmg5eEDBkp/5tee7fWknGjyjv25Szpd0T22G3Cbj1VTEOosf1?=
 =?us-ascii?Q?NhLVDr+L2LhgaXpYKi++MTspziWJQFo/WYWsS4tjGN7be5puy+tKQNaSRa4z?=
 =?us-ascii?Q?WNPSaUwJNcG/0yUuVztkraNrWAtTeJW2YqCikSNNMhezd0dd/9ntwDhsZB5S?=
 =?us-ascii?Q?qAAuVm4YVMnoqlltJIjHpKU0O/1AyqsRjn0wHw3W226NbBnR7+C9UvHjHVS3?=
 =?us-ascii?Q?DKxvcvN2u4eiiP4wlXLBhSwule98k7JJwu7t3xw+ZZ6ZGo+pbYUQ+lEGc9BI?=
 =?us-ascii?Q?ThQAqL9jL4R+veUeezvs1IsafDA+/iOqTDHC1/vTDMscijYCHSVPNiQMc59d?=
 =?us-ascii?Q?9bKhaM5rdk1qJlswXmGsakpKMW8e0/VsEGQ4uDEj9EK0M8EPqZrQUghi+l0X?=
 =?us-ascii?Q?12EOdz3JUfbP7YqAcLEoHYdcs13YP3gZauIzf/Pd8lb/m/4ROpZlWaW4OLeH?=
 =?us-ascii?Q?Up5J92kle2y7vPEflht4zs5qeDjET1gz4Zo94geWZk48Df3F33pCFpu+5CzE?=
 =?us-ascii?Q?UkBnyl3jbHMrS0WPZGcjWKcnOmJDNRq7dB+zRhhSm3KKmC3cPQq7ZSPGS55w?=
 =?us-ascii?Q?RGtKMVVr/QdvSuVB9DVb51ZSdjGruFTN9PWVfiT/XFc32QWYnXhYZk1GT5xZ?=
 =?us-ascii?Q?aXwvcZJS2Yheg88TXkMWZxuodw5J1QONAAsdFCufsLsjNBDUK5kkNKI6x2YH?=
 =?us-ascii?Q?7VkDpeOZcG6Od4kWE0s284vB7I7/EadsRiWYDX2q5ZS2H+X8BYpjpZNoybh0?=
 =?us-ascii?Q?wnYe9at7+dmSprFy24rDIKbYzqtQm3ywZBeze0umqvmBtOdIoKeJw2ov4+IP?=
 =?us-ascii?Q?8hStGUCFDnjrUGuxtFYDbjcltxEG5v5pEVqwI+gYFcEO2uE2puOlXk2a1Su/?=
 =?us-ascii?Q?xduQMgGRTg1S5ONaOyZiwMC3Kot9cFxUfq6wanB7GuhEmdGRSAPMLBDMUO1r?=
 =?us-ascii?Q?cnD5PMhYQ8IkaYY5itUEVLc=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 71018ff7-9931-44cf-562e-08d9eab6db5b
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2663.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2022 03:55:33.7279
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /d0quLaGOYCqSFuyMXa2ATJkdKIQmmvnVNRrxTI9lSZdVyP/yr9hbYmnrlfzEOicmA2LXd/vD4dlkAXm70z0dg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR10MB1352
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10251 signatures=673430
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 bulkscore=0
 phishscore=0 malwarescore=0 mlxlogscore=999 adultscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202080019
X-Proofpoint-GUID: 9ut66aZSMiMZd6sg0Pu2kreK320tH9zK
X-Proofpoint-ORIG-GUID: 9ut66aZSMiMZd6sg0Pu2kreK320tH9zK
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
ftrace/ebpf to track the reason for the loss of packets

Cc: Joao Martins <joao.m.martins@oracle.com>
Cc: Joe Jin <joe.jin@oracle.com>
Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
---
 drivers/net/tap.c          | 30 ++++++++++++++++++++++--------
 include/linux/skbuff.h     |  5 +++++
 include/trace/events/skb.h |  5 +++++
 3 files changed, 32 insertions(+), 8 deletions(-)

diff --git a/drivers/net/tap.c b/drivers/net/tap.c
index 8e3a28ba6b28..232572289e63 100644
--- a/drivers/net/tap.c
+++ b/drivers/net/tap.c
@@ -322,6 +322,7 @@ rx_handler_result_t tap_handle_frame(struct sk_buff **pskb)
 	struct tap_dev *tap;
 	struct tap_queue *q;
 	netdev_features_t features = TAP_FEATURES;
+	int drop_reason = SKB_DROP_REASON_NOT_SPECIFIED;
 
 	tap = tap_dev_get_rcu(dev);
 	if (!tap)
@@ -343,12 +344,16 @@ rx_handler_result_t tap_handle_frame(struct sk_buff **pskb)
 		struct sk_buff *segs = __skb_gso_segment(skb, features, false);
 		struct sk_buff *next;
 
-		if (IS_ERR(segs))
+		if (IS_ERR(segs)) {
+			drop_reason = SKB_DROP_REASON_SKB_GSO_SEGMENT;
 			goto drop;
+		}
 
 		if (!segs) {
-			if (ptr_ring_produce(&q->ring, skb))
+			if (ptr_ring_produce(&q->ring, skb)) {
+				drop_reason = SKB_DROP_REASON_PTR_FULL;
 				goto drop;
+			}
 			goto wake_up;
 		}
 
@@ -369,10 +374,14 @@ rx_handler_result_t tap_handle_frame(struct sk_buff **pskb)
 		 */
 		if (skb->ip_summed == CHECKSUM_PARTIAL &&
 		    !(features & NETIF_F_CSUM_MASK) &&
-		    skb_checksum_help(skb))
+		    skb_checksum_help(skb)) {
+			drop_reason = SKB_DROP_REASON_SKB_CHECKSUM;
 			goto drop;
-		if (ptr_ring_produce(&q->ring, skb))
+		}
+		if (ptr_ring_produce(&q->ring, skb)) {
+			drop_reason = SKB_DROP_REASON_PTR_FULL;
 			goto drop;
+		}
 	}
 
 wake_up:
@@ -383,7 +392,7 @@ rx_handler_result_t tap_handle_frame(struct sk_buff **pskb)
 	/* Count errors/drops only here, thus don't care about args. */
 	if (tap->count_rx_dropped)
 		tap->count_rx_dropped(tap);
-	kfree_skb(skb);
+	kfree_skb_reason(skb, drop_reason);
 	return RX_HANDLER_CONSUMED;
 }
 EXPORT_SYMBOL_GPL(tap_handle_frame);
@@ -632,6 +641,7 @@ static ssize_t tap_get_user(struct tap_queue *q, void *msg_control,
 	int depth;
 	bool zerocopy = false;
 	size_t linear;
+	int drop_reason = SKB_DROP_REASON_NOT_SPECIFIED;
 
 	if (q->flags & IFF_VNET_HDR) {
 		vnet_hdr_len = READ_ONCE(q->vnet_hdr_sz);
@@ -696,8 +706,10 @@ static ssize_t tap_get_user(struct tap_queue *q, void *msg_control,
 	else
 		err = skb_copy_datagram_from_iter(skb, 0, from, len);
 
-	if (err)
+	if (err) {
+		drop_reason = SKB_DROP_REASON_SKB_COPY_DATA;
 		goto err_kfree;
+	}
 
 	skb_set_network_header(skb, ETH_HLEN);
 	skb_reset_mac_header(skb);
@@ -706,8 +718,10 @@ static ssize_t tap_get_user(struct tap_queue *q, void *msg_control,
 	if (vnet_hdr_len) {
 		err = virtio_net_hdr_to_skb(skb, &vnet_hdr,
 					    tap_is_little_endian(q));
-		if (err)
+		if (err) {
+			drop_reason = SKB_DROP_REASON_VIRTNET_HDR;
 			goto err_kfree;
+		}
 	}
 
 	skb_probe_transport_header(skb);
@@ -738,7 +752,7 @@ static ssize_t tap_get_user(struct tap_queue *q, void *msg_control,
 	return total_len;
 
 err_kfree:
-	kfree_skb(skb);
+	kfree_skb_reason(skb, drop_reason);
 
 err:
 	rcu_read_lock();
diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 8a636e678902..16c30d2e20dc 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -320,6 +320,11 @@ enum skb_drop_reason {
 	SKB_DROP_REASON_TCP_CSUM,
 	SKB_DROP_REASON_SOCKET_FILTER,
 	SKB_DROP_REASON_UDP_CSUM,
+	SKB_DROP_REASON_SKB_GSO_SEGMENT,
+	SKB_DROP_REASON_SKB_CHECKSUM,
+	SKB_DROP_REASON_SKB_COPY_DATA,
+	SKB_DROP_REASON_PTR_FULL,
+	SKB_DROP_REASON_VIRTNET_HDR,
 	SKB_DROP_REASON_MAX,
 };
 
diff --git a/include/trace/events/skb.h b/include/trace/events/skb.h
index a8a64b97504d..bf1509c31cea 100644
--- a/include/trace/events/skb.h
+++ b/include/trace/events/skb.h
@@ -16,6 +16,11 @@
 	EM(SKB_DROP_REASON_TCP_CSUM, TCP_CSUM)			\
 	EM(SKB_DROP_REASON_SOCKET_FILTER, SOCKET_FILTER)	\
 	EM(SKB_DROP_REASON_UDP_CSUM, UDP_CSUM)			\
+	EM(SKB_DROP_REASON_SKB_GSO_SEGMENT, SKB_GSO_SEGMENT)	\
+	EM(SKB_DROP_REASON_SKB_CHECKSUM, SKB_CHECKSUM)		\
+	EM(SKB_DROP_REASON_SKB_COPY_DATA, SKB_COPY_DATA)	\
+	EM(SKB_DROP_REASON_PTR_FULL, PTR_FULL)			\
+	EM(SKB_DROP_REASON_VIRTNET_HDR, VIRTNET_HDR)		\
 	EMe(SKB_DROP_REASON_MAX, MAX)
 
 #undef EM
-- 
2.17.1

