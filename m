Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A355C4BD590
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 06:45:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344627AbiBUFiq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 00:38:46 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:52408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344603AbiBUFia (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 00:38:30 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 804DD40A33;
        Sun, 20 Feb 2022 21:38:07 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21L4k2eM024949;
        Mon, 21 Feb 2022 05:35:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=d5V6bqFTVChzaWkL7iyTuWVDTsodaQaSgjo1ckTJ4sg=;
 b=MSNAEmIVbnTNKw/WTtMo0yUCOTOgofQ0X7n3kz6jcq/VsgIyTBKfZyEGdEFtl3Ch7tIj
 5QY4dcYER/mYRzX7UmVhtjW5zrUS/4HspOg2vBgA4iUyFNtUgBVg4pJbkPOFFWFKsQ4T
 pI1yzt79TB0lurxLJTOXPyLjLnLrtaOugHbZ5vai77TgGxwpK53j8rTypaieBRWZrjg8
 Y/Ek0DF7dB72HBy0GDFx3e4bWWsSdHE0MG66gbILaqAPVN1OUifw5Mkg5LmBT7zuUxYA
 rHO5tMIK7ZcIjY8tI50TOvSvCGwNkZL4rqr/knQMKRBLiDoqmd5s+0nJ3mvOB6per9Lo SA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3eaqb3b4k0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Feb 2022 05:35:18 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21L5UkVZ019493;
        Mon, 21 Feb 2022 05:35:17 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2045.outbound.protection.outlook.com [104.47.51.45])
        by aserp3030.oracle.com with ESMTP id 3eapke8nxk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Feb 2022 05:35:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iXwdwmRqCHACRCfWmf3ZDmpcXgQ3CL8vMqvbnrnrOU/nroTt8sOxqqz8HqT4ubLGOFZUhvhuWiYkD4zWxwnWqO1I9thwcVVZL3pSas5oKcivFSg/S2VWUaJfGxFu429KzkXhdxmf7mJn6MvJYaRdXH8Sfxxxe2lph2y8vxBpxWkwrsA5FB6O7vFe4xE5xBohzz2L/GAsCzRHqZIfWUqKlhdIVk1/DVU1d+sJip16is5qSrAvs4gkkq5CMA8jH4W5hzR5UnSg/nSx0tXIFLAVsjWo6/0D5WNWUaNrUwSJrvXTiC4JESA3VCTOVQ/m+6Ol74sqLuWsx3zY1UpVCpBzBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d5V6bqFTVChzaWkL7iyTuWVDTsodaQaSgjo1ckTJ4sg=;
 b=hXMMSwkXfLlaLRIF29WEEcCobd1y+ZOBRzHnsLPX36JBd4nMizj8tyE4tJvjnHRDoA53yCNrCS6W3RBO5jv5g9C7EsHbKo01z7RF1GydVv3zBGAI6XHG4B2F/WhAMs8ww/SDIqtV/yZrZRAyYaNTD2qbcuxiGoo+Q4B6RYvcC6WxxithzT7Eb4hPCwNMTFyJKgIAUNFWlPFUqAPC1+hhQ5zZD5H6a0H20gM2/jOW+BjmURHR/o61wx/EHVFtmdEwqMwpIsZthbYQ7naibZYyEzopcBDdZpoSr2jQowGxsXHneSpHOXzUFEN4hqNYU4DCRF7+rsutXQV5EkQGCJ5/og==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d5V6bqFTVChzaWkL7iyTuWVDTsodaQaSgjo1ckTJ4sg=;
 b=kxbCGVVHeRDStijb7teQ/SxcbxizSCJoGSjXI7nuQuNfqr0CE4V9+rPwQ3JlEupf225lVYhlGtJm9l7vU47GIgsnwPdP7o9jceYBnCkztx14sT1/3dDn/lXbucj0lDShL/WYvShQE3AzhahAYLyXMSJ5BS9D4MxBMw59Whmdu5Q=
Received: from BYAPR10MB2663.namprd10.prod.outlook.com (2603:10b6:a02:a9::20)
 by MWHPR10MB1533.namprd10.prod.outlook.com (2603:10b6:300:26::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.17; Mon, 21 Feb
 2022 05:35:14 +0000
Received: from BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::a0d5:610d:bcf:9b47]) by BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::a0d5:610d:bcf:9b47%4]) with mapi id 15.20.4995.027; Mon, 21 Feb 2022
 05:35:14 +0000
From:   Dongli Zhang <dongli.zhang@oracle.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        rostedt@goodmis.org, mingo@redhat.com, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, imagedong@tencent.com,
        joao.m.martins@oracle.com, joe.jin@oracle.com, dsahern@gmail.com,
        edumazet@google.com
Subject: [PATCH net-next v3 2/4] net: tap: track dropped skb via kfree_skb_reason()
Date:   Sun, 20 Feb 2022 21:34:38 -0800
Message-Id: <20220221053440.7320-3-dongli.zhang@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220221053440.7320-1-dongli.zhang@oracle.com>
References: <20220221053440.7320-1-dongli.zhang@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: SA1P222CA0020.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:22c::21) To BYAPR10MB2663.namprd10.prod.outlook.com
 (2603:10b6:a02:a9::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7fc895a0-a1e4-4031-a1f5-08d9f4fbefa5
X-MS-TrafficTypeDiagnostic: MWHPR10MB1533:EE_
X-Microsoft-Antispam-PRVS: <MWHPR10MB1533513F1FE7344506CC9626F03A9@MWHPR10MB1533.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YVZ1P4+mPWq7PTmr/0ALIT8P5pbooGf05CsSrjNfIfM10ZXJUCkSJSiC19IU0I4ETAA6OWmmftmqf8QzgtczCbrE0NuIO200MX/gCC9Wfc6YXB4DSMzas7827XI96GnFl7Dk1rgAe++nW6/U9/3Rb4qqXoiM+ffBV8T/WdBxngLghxMLhHXkR3bYYmudS5Egx0rJOEq6ImKbN5GiGghJHz//Lri0udGZrflRy7GlOARmWYJGkEBh/uRN/mpCVsxScXOW+envMyUpCGW8ohTnsiKMDyY1SR9O/o20GI0/Te5iMLlZTzQSdAirHMOiXXd5NNgKHzJNMS5rWGKCXkfK++f1Cx1TCyv+fK4sAkX/JVQ3ssFO6yXY3/4q8+0fbtM6tVY8aj+TneHvtEgEMuPRshz1V1hnPiMWnUmotzoHhnemBzH9gJfKgOxZyOLfVkaz2D1gx9rQlCSS/j4IrktPwphcaAKMC+SJgZkSPeX38CFjbm12yyWpDjOt4dI3yrLsNSTbtsFXwfCGGMlEZHsjatzt0mCMEkXuMGWtqaSe5RI0iwrGmq5PNZHqWvp50s4pAkhHRcq16B9fMjO1FOHqMbBJ4dNZYmkn0s1xFF6ISLNivs19dfIb8x82drcmBDMzB5nFgN73UEF0gf1yR9v8zexEAn7lJ5dJVkMHlMANpX5FR0yDS3dEixl30k48faz3zaWSfNkNE7HM9y5loOn7tQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2663.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(4326008)(38100700002)(38350700002)(83380400001)(36756003)(7416002)(44832011)(5660300002)(2906002)(8936002)(2616005)(8676002)(6486002)(6506007)(26005)(52116002)(186003)(66946007)(66556008)(6512007)(1076003)(66476007)(6666004)(508600001)(316002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?XxQEqoia+5sTg8kplKikVc2cAXv2LGNRoRbChrn9Ri1uh59il+aIYL+HFjVC?=
 =?us-ascii?Q?vJ/iVSJC8MnFomTAzhdyplK43s+au6zZSol3HTFpbzTPkPDvPobyXA11J/Gy?=
 =?us-ascii?Q?LbjVXSyA+pLA7Kcqq7jH0dsNo52mB59Robvon2mScSTKmaJtGiNQzjXqeW7D?=
 =?us-ascii?Q?OruxkdXJ9GSpWUliPLKlYZ1kU3SEm1SOB8wJER4BcHUByBYW/OBvmCWnBkzc?=
 =?us-ascii?Q?VOPIyA0T+xaKuMow1MSrAiFcmAqP9T6qlAAdSD8NI2NFMn6RsFlL3HK1E5HQ?=
 =?us-ascii?Q?3IGzz41THe9NfWUpmDmFmA58Q/YBR5Mjjz9+s5eRLe0C5hKzmnybV7v2bTwS?=
 =?us-ascii?Q?NnFPhB0+CWAs6LvVeN7WLC4KRN0vRDZ+oQJkQFSQR38kcXUV0G70fn8dPjFv?=
 =?us-ascii?Q?HM3GP1ZWlsppJZS1CPN2jF6svyvEjp6DsleXDqZQYtGovk8k/3hfIRzEd3+1?=
 =?us-ascii?Q?APtxhFbeyLnSJebULgO6I522v0+2UQ9sAQr4OzHauwQ3bMzmcueuJc06fICv?=
 =?us-ascii?Q?PPwv+Ik9iEONlTK5ZimTLx86w1SbcrR2eR5kWOr6chvOlPZJUQjS7uUVu+Ad?=
 =?us-ascii?Q?dmUgdnco+QesigWPjxMs0U9rZ14PHFFUNHV2NlNAEaC2usUc7IW07fOEt4wh?=
 =?us-ascii?Q?Lav3q6Syi/exKNiL56gulJQSngYaliTXChLJFcrRB3xH41ZRkvYMTU3ledw5?=
 =?us-ascii?Q?as3W9j2UCzY+DOkh4fpeZhAFims3irE9u4wcX3NmKfOqP1yQXXkDTD3L0A5M?=
 =?us-ascii?Q?IA7exhjjDEjQpRyaxC2BiDUEfFf42Qa9R5bBxocUI7KUAyhfoCwDmb2GkcVd?=
 =?us-ascii?Q?b2U8iMPSnM/MzXHyavdgIbSfAuhb0tfUwvNiOexI2ejWGRGP3lxfA6WZL2Pp?=
 =?us-ascii?Q?2ck0LZAzc3CPcGH2PF/k53JJ6T2nD7bhopksOb9D8vHGoh7rUQIGrUAfI1Qe?=
 =?us-ascii?Q?HrEprE41908tkCio9siidcNnQhzoL46jANfryySe0w3k20Tg5u6X8WUty54e?=
 =?us-ascii?Q?ARTu/vRnzAsoEa+NUIt9j20aBbX2y5K8AkcgLRlUb9fIwyq9YoP2Lbjv5+d8?=
 =?us-ascii?Q?AgMPNrD7zq5KjecmVHE3waprHUam0aQUsap7nIEiNuWGnaS3XpYI2ZHdOHLW?=
 =?us-ascii?Q?Bpw1w7gkarnYBTw7w00t+I7dmCDy4q6RAZT38n1lmEq/gS+Bjtu8MfgxpDzC?=
 =?us-ascii?Q?VgWjsxivDw9JiObvfzu3/CHAQyruMWnBsKDNknD+eRarI193hPLzRJ9GGmYq?=
 =?us-ascii?Q?cZuauVgMdGnJZlGz3zrhLQP6R6UQnBPd3hfCw9MPCaDLyXx9w6bnhkSE7sY+?=
 =?us-ascii?Q?5GzPyOEVD9BptdtnpZ0FSk5Wr51yFApqX7TqGgB9kyxdcr1MJiQx5T7uz5hU?=
 =?us-ascii?Q?/Mxo7Jpun8zPJzkucmYUqEIbPKrdWAKRoSOrICs3pOSRR/t/eYyDkZ9mDpd8?=
 =?us-ascii?Q?2Dgr95VANfVaW8e71IUoKrTdHI2jNGX0xT2ct0gEZTuUNNJ8jsB0v38oYZKD?=
 =?us-ascii?Q?xsJxkc7FsadSrth4AhU8ampRIoNit2gycmqXsJlykMAF5q1mNMHnPC3wYYdr?=
 =?us-ascii?Q?yCBn7afDgGNMgJUJ5rbTYopn73YExiCk7Qvf5sSOC8ikdw6LfZQwpZIDMSo1?=
 =?us-ascii?Q?pDJKzrMPISsFnU/5hMqudD4=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7fc895a0-a1e4-4031-a1f5-08d9f4fbefa5
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2663.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Feb 2022 05:35:14.5932
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JCRUmmTKd6xBJRQ3LPgdleUY8FyjmoN4OXjFVEGMC9RvxQ8fwYvbdPFvURrBvxhdf07DaNsYwT2aHOhTvji/CA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1533
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10264 signatures=677614
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 mlxscore=0
 spamscore=0 mlxlogscore=999 adultscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202210034
X-Proofpoint-ORIG-GUID: HbhJjSoTUd1daD8alR_4WhWEL3pOsTXK
X-Proofpoint-GUID: HbhJjSoTUd1daD8alR_4WhWEL3pOsTXK
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
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
index 8e3a28b..b48f519 100644
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
index 87ebe2f..52550c7 100644
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
index 2ab7193..5b5f135 100644
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
1.8.3.1

