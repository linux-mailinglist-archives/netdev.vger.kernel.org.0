Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A51854CD6DB
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 15:56:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239317AbiCDO5N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 09:57:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229962AbiCDO5M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 09:57:12 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73F131BD9AC;
        Fri,  4 Mar 2022 06:56:24 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 224EFZTw011983;
        Fri, 4 Mar 2022 14:55:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=JlAgFzVLhY5R7MWHn2Jcitz03VhS5pnPfmzBOrCrbLE=;
 b=rsVge4DVr6NtWEXpHzpq34K9Htmnt24leEsQzUAT8nh2LFlh5lapD1vAZxIQhpDhXD64
 XZysFOmTvS9HU0rUMhFDM6+cHF9qcBV+2QskrU71Z3dXpkaVJGLNfr1e7iXsJujIroZG
 qjNZjkQUQJ01deCAoz7v0a4Img7+mA7GBuwN4Ak/sMSRDg+KkE+DV6KEInkj5mTYAiDH
 izsLQpFHAY+qqp4KdfeN8VS2ZECyZoboyqz2KjnJB1f6i+br5TicBQ74wMoceWyZwnfS
 mjGRYneIhPeSLNxA+/hnXmXZU3il/Cn5wVOJCLxBE8a7lpoCVa3tB/urtyYKmrhFXYZe /w== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ek4hvhxwy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Mar 2022 14:55:20 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 224EZUGD130215;
        Fri, 4 Mar 2022 14:55:19 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2177.outbound.protection.outlook.com [104.47.57.177])
        by userp3020.oracle.com with ESMTP id 3ek4jh0831-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Mar 2022 14:55:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XZPrQ0gyOU+2dBTfyEEK4jqNlus9uZwrNfUj6AlznAWmgjtOqeoRZS3p/QCZ+E2DJk7Rf+3WxqrKd6VNClkZXqRCIilfVgxThEs88YTDW6KSmVoMQWy3+M1OiPHYfWnOuuxcfcR8e0RtYSyUz7PU9IOQKmcYHhso9cYIgINGahgVuwMt5Nx34m02QAjJTETgV3fZOhkTavur74mcA0Yy4/drkQFLr37NRg7U7KeVWqPDNLoDrZ1+1vTjllw2jtnLyScTWpha2juHKV2foE63YYXrZMFr2DwbyZz1ROAeHxO9rOQJNWJUjdaKZcvpy1NXKVbBu9wq8IivR4lm44Ld6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JlAgFzVLhY5R7MWHn2Jcitz03VhS5pnPfmzBOrCrbLE=;
 b=S3eOiYzLISfJjm9P/4JAeCNGu56GGK7HnSBkTkDV8gEFmW07tocLqdNyOzmMzobY05FVPvrjjinzJ3e7ZKvwG/krVvgn/d7Xys1ywwlHQlAOVlntH8p8pBPK7dGEHAfP/DLqK/N7aMaG6M/XBZgFn3Vk8/rkg5ZDVwIF+jV6CSKPavgzXQdHqp5+X4CkjGyz9EVGd/DHQACAhnOeuSdJmuk77haOtWbI2wf1QChNjjG6J2zVOV1v/qRy8+P6IgddvbCFg+rYoJjJtHrDd7ODUkq9RfM3TeMyn8w+KKtN5LJgHcgsDf4zcvyvrKbQcZI/gXfRTpydYxInLcGptVPTgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JlAgFzVLhY5R7MWHn2Jcitz03VhS5pnPfmzBOrCrbLE=;
 b=luwqyjUzHhFMmwZInrdK0/HXW/C41fKBJ8uwX/VHKYh7YzZRUrE+JPXLmPna7H5MB8sSJ0kVgKFisKpVRotUJrDHVYBzU9wvKj/DbtekgrTdG+m+bkO99pujanmB4sAtRHqTzmm3JR9D7V6uSwgUNi/jGaWTTgefOnctTyJ//UQ=
Received: from BYAPR10MB2663.namprd10.prod.outlook.com (2603:10b6:a02:a9::20)
 by DM6PR10MB3977.namprd10.prod.outlook.com (2603:10b6:5:1d0::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.25; Fri, 4 Mar
 2022 14:55:16 +0000
Received: from BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::a0d5:610d:bcf:9b47]) by BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::a0d5:610d:bcf:9b47%4]) with mapi id 15.20.5038.017; Fri, 4 Mar 2022
 14:55:16 +0000
From:   Dongli Zhang <dongli.zhang@oracle.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        rostedt@goodmis.org, mingo@redhat.com, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, imagedong@tencent.com,
        joao.m.martins@oracle.com, joe.jin@oracle.com, dsahern@gmail.com,
        edumazet@google.com
Subject: [PATCH net-next v6 1/3] net: tap: track dropped skb via kfree_skb_reason()
Date:   Fri,  4 Mar 2022 06:55:05 -0800
Message-Id: <20220304145507.1883-2-dongli.zhang@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220304145507.1883-1-dongli.zhang@oracle.com>
References: <20220304145507.1883-1-dongli.zhang@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: BYAPR05CA0034.namprd05.prod.outlook.com
 (2603:10b6:a03:c0::47) To BYAPR10MB2663.namprd10.prod.outlook.com
 (2603:10b6:a02:a9::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3728bfd1-2b27-4e23-3322-08d9fdeefe77
X-MS-TrafficTypeDiagnostic: DM6PR10MB3977:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB3977BF43E9C856E2E9EDEF03F0059@DM6PR10MB3977.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AnHMizgQGOlDon82PrgeMjztmf8l/xbODzyES4UMwMyUod9Nwc2xZ3vWvXkm2BWoOQKLMHTWX8GxfV3ogKAnGmQc2bX2K3KnhJecCNzcEMc1dVLlSPTvIfE6iGkgM99g/3xLPY49m85wtm24PG48mhFNwV6iRFRF3beQK8a14c3y64kCuVWlqUT5UbpJn8XTqTmrL+wx9qgwBEb6aHRY9EDefEoAdVJCEJOnMZLLcJwfyCb/yJadr7DFdCfcyGqUtDnVopTh4hjGJgjdsME0r/S2UgG0WD6KNry17ZsmIhC15iTywfOPifYtU+Uyo6+twYgPsX/g9Z0a9VQsI+Vim/toS8UuAaTLUDZMVNAoGkyK7LS156e3g+rZKkkkimDMfMBNnhf1sxS307zLkhqMShHTA16dvF/DhfbI7LlvUCZ2KSyA+UCeUtevHxROaYCUmAxMPhRjQhcglGefWaSxImSuAe5O2Qk7RhkWKks9gjUoRKadIFFscwsMPGV9R8E774ROCMlPBREGn7MvIuPErkGB/VMSByUW5lhw94zu9N6amsCoWRSYVDsbn9nPfXJVDv251KUA+SBADlrlXnTis7GvILCL8UmtYcNUsO9JUlETMtdjJhOec0lYKioJymngxs3EcmouQROPRAd21d1k3tSaez2asZFaSa7bTYYf1gaLEqhTSg9F/2MSTU1J1g3+R/22lbfmWmjg7TFPV/U7gw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2663.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(508600001)(6486002)(316002)(86362001)(38100700002)(52116002)(1076003)(2616005)(6666004)(38350700002)(6512007)(6506007)(83380400001)(66556008)(66476007)(44832011)(66946007)(7416002)(4326008)(2906002)(36756003)(8936002)(5660300002)(8676002)(26005)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?y9U7qjhWo8UBhT015gLYUAdkV1BC+i3gkgcO1GkujTPD0m+3zdL8Bm/dXHle?=
 =?us-ascii?Q?R642CnDcI3/F+EpV7Ek5jAe6TuG0QH7FKAtm0GjAm4LaJlk7lld5R9jXmVcA?=
 =?us-ascii?Q?Exta9iO2c5ULncgyWr5b29GSE6SNt3uvTjv4b7Kfrx705qiUFrJjkxL4SH8e?=
 =?us-ascii?Q?Eo5g0am5XYPnzVJlHXIrSGsHFuYgGyjEJq/cajL5xVehwvX6uuBiUXvZgGy1?=
 =?us-ascii?Q?rNzpaMMljNcaU636UESX3fEbcrYyigQhNPDP112muouC7gBSA4NT7zDbRBEK?=
 =?us-ascii?Q?KP8aRXZH2rvZ0b6UYtYnCHmq5IT1yc6+ehgsY9c2rRrwStf/Ab3vAd7YVfak?=
 =?us-ascii?Q?r3ThZYbEB40rpj3FKbelfhXHT4F+GvcyvITOuek9DOx531PWOHSsQOYl5yQw?=
 =?us-ascii?Q?lK50byDLXfqG5dqd9h/ZTyN4ew16LkqpcDQKIqf88dDDNaHWeB/Kl/XdpGq8?=
 =?us-ascii?Q?PfKLMjnCO7jy0JRxW6KZzEeVCdqX9Yx0sa8AjRUgK4gQKxyQuwU5WLg4OMCA?=
 =?us-ascii?Q?oy1YkO90Bw8WqoDStMDObvwZDl+EUk6vcj6Wowx6j5q+M6IJAs7baYo5dcnr?=
 =?us-ascii?Q?C7Cd/XcNA39tXne54JFlsbUK+Y48pOwH6yQ99JJFGD9brT2uDR9QFDYlizj3?=
 =?us-ascii?Q?p1YGmqf3N6GfbOotHh3tgJgR+xBEWUxOYo4+qb1S6hwkoPlNqqLLU+18Tppg?=
 =?us-ascii?Q?BjIW99+3fiKxeJvCaa+Jn6A2uJKPXcFWhie8vUC/IitS3oRu6eLkm7WqWdQU?=
 =?us-ascii?Q?o0+tB4uT6DM4Te271jo+gLtv03YrUXEnHKLGAr3zQcqnSi9Qh1uHr0IZaZLc?=
 =?us-ascii?Q?1k1h9+Q6eS39BxhAyoH3KEKK9kD3pkJ6dse5yif2vrvSz+dKrp7l7iykXxxN?=
 =?us-ascii?Q?cP2I0xCl1NExiMZILi7i7RPa2GKT6N9p3QK+/m8QDktDHvMoDyrfaXWfeElr?=
 =?us-ascii?Q?GDu4TPZBcePQ6tfuU4+26i/9ihTmrz2FkCxHpjiM2cOk+txKfFpAUCS3NiS2?=
 =?us-ascii?Q?2gyMccgYetPLNF6jQSdOEqehtDX0KSn8XMiZiCsRCgq+fxdzdSTa48hFdiWS?=
 =?us-ascii?Q?Y82m3U66em6/hs2LJpj2Dv5autzMezHL7jQTRtcUzxEFU7fb43y45r0PUz8j?=
 =?us-ascii?Q?WLwIa9PoFn5MNgXtv+jdCsGykNmbqxZtBF4l26CjnwgSTeow/yXr79yN84OS?=
 =?us-ascii?Q?djGSujdmq0YSSYfYjBNYDIU7ilDtYIXD3U0/dfZcxm4hrVqujZiSHdFwGKQW?=
 =?us-ascii?Q?y9Y9Ljso71uPPXidVGxboWHYS0NOBcchcarGROUGudM86e+aNZtBFqBfoz73?=
 =?us-ascii?Q?WGOpgVykFI+cYmCw26gPCB11E+idpgoHm4RQfEDjpFdZrYSxK89+gMB1/Z+w?=
 =?us-ascii?Q?Rnb4m434gDGQ5uc/8XIqiGDMkl0az5ocyX2gcXC25As2akIQsRsQFmjaOfVF?=
 =?us-ascii?Q?Ty/IvxENiSxHudHlyfQnZ3ySoG9GZlrK5VX9UerqQz80jxYZwOeA125BMk4C?=
 =?us-ascii?Q?5DAcK2aFpnQqea8RO/wAGfAg88k83CzGfy3sAheSHJDktm15p4Ll0as3bLkW?=
 =?us-ascii?Q?f/wgpkDxhys28g9F+a+s4TWXeNbKAdozAlUbQ5+/KE50vOoQbc9x+A9jtyy5?=
 =?us-ascii?Q?qpxI7LoEGsE3RYFyNv6x4xg=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3728bfd1-2b27-4e23-3322-08d9fdeefe77
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2663.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Mar 2022 14:55:16.3998
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ChOt+8keF/vvHqnDs4jwxj2DB5zjCoanqXRZZNEk7BdCph1RIteBWvH14aoqYXbXjh215RNVPS5fp20ro7IN9Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3977
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10276 signatures=690470
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 adultscore=0 spamscore=0 phishscore=0 suspectscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203040080
X-Proofpoint-ORIG-GUID: m5bR0lRzcxcdddWsK8khUNQrH4L5tuxl
X-Proofpoint-GUID: m5bR0lRzcxcdddWsK8khUNQrH4L5tuxl
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
- SKB_DROP_REASON_SKB_GSO_SEG
- SKB_DROP_REASON_SKB_UCOPY_FAULT
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
Changed since v4:
  - add 'computation' to SKB_CSUM comment
  - change COPY_DATA to UCOPY_FAULT
  - add 'metadata' to DEV_HDR comment
Changed since v5:
  - rebase to net-next

 drivers/net/tap.c          | 35 +++++++++++++++++++++++++----------
 include/linux/skbuff.h     | 13 +++++++++++++
 include/trace/events/skb.h |  5 +++++
 3 files changed, 43 insertions(+), 10 deletions(-)

diff --git a/drivers/net/tap.c b/drivers/net/tap.c
index ba2ef5437e16..c3d42062559d 100644
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
+		drop_reason = SKB_DROP_REASON_SKB_UCOPY_FAULT;
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
index 2be263184d1e..67cfff4065b6 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -412,6 +412,19 @@ enum skb_drop_reason {
 					 * this means that L3 protocol is
 					 * not supported
 					 */
+	SKB_DROP_REASON_SKB_CSUM,	/* sk_buff checksum computation
+					 * error
+					 */
+	SKB_DROP_REASON_SKB_GSO_SEG,	/* gso segmentation error */
+	SKB_DROP_REASON_SKB_UCOPY_FAULT,	/* failed to copy data from
+						 * user space, e.g., via
+						 * zerocopy_sg_from_iter()
+						 * or skb_orphan_frags_rx()
+						 */
+	SKB_DROP_REASON_DEV_HDR,	/* device driver specific
+					 * header/metadata is invalid
+					 */
+	SKB_DROP_REASON_FULL_RING,	/* ring buffer is full */
 	SKB_DROP_REASON_MAX,
 };
 
diff --git a/include/trace/events/skb.h b/include/trace/events/skb.h
index c0769d943f8e..240e7e7591fc 100644
--- a/include/trace/events/skb.h
+++ b/include/trace/events/skb.h
@@ -51,6 +51,11 @@
 	EM(SKB_DROP_REASON_XDP, XDP)				\
 	EM(SKB_DROP_REASON_TC_INGRESS, TC_INGRESS)		\
 	EM(SKB_DROP_REASON_PTYPE_ABSENT, PTYPE_ABSENT)		\
+	EM(SKB_DROP_REASON_SKB_CSUM, SKB_CSUM)			\
+	EM(SKB_DROP_REASON_SKB_GSO_SEG, SKB_GSO_SEG)		\
+	EM(SKB_DROP_REASON_SKB_UCOPY_FAULT, SKB_UCOPY_FAULT)	\
+	EM(SKB_DROP_REASON_DEV_HDR, DEV_HDR)			\
+	EM(SKB_DROP_REASON_FULL_RING, FULL_RING)		\
 	EMe(SKB_DROP_REASON_MAX, MAX)
 
 #undef EM
-- 
2.17.1

