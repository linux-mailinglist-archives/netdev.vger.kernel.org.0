Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDB55605C11
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 12:19:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230463AbiJTKTm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 06:19:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231252AbiJTKTE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 06:19:04 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam07on2041.outbound.protection.outlook.com [40.107.212.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BA311DB89E
        for <netdev@vger.kernel.org>; Thu, 20 Oct 2022 03:18:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U+tXY2rxLxshpuvIyfLQi4OPrgX92xDTO0hPrUwhaydgVOqE/Czhb2fMP3tar9lwFwtEQSMLlNKUXynC+X/vspa5FyYnQQWH0xaX9P1bqnylH9wUZzQ28A2xXmJ8nItd6XmgzVLSmonlRkFfqJ7UFAwne8yfmfqDsWp1mcQIW6WbGVKHxwDyveJYH5Ai3+y0xfvGe1MFcyyM2XjIjV8HoNRdFrbIYBwAYFqAz+G705lWqBYEeCSLyPRkgtxi9Ty0fDZAAwg8x5J6mzH6K9woYckDSxQpfiepZRRfxmhY2RmE7EE9fVTMYmLEFKYzVJA4DwiLTPRfrgNeJ7RSVqmyog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FMeR6cA014X5QIz1Hm8QdSxQbO765KeUlCQHMF9WHYU=;
 b=CFPQz6IXSt6VjDQRgB8pNmryXa8FgrYOVObsjC5Wh3ElGzSxTk35+DYV5xg+ZhXY16ufahvLfZ4nNCrk7Sw2y1Btph5Gad8MtOgqMDjn0YxYfD1SQdD3i6ekSn+2TvLlwbvCTpNgGwWZFyNJmPLQgZHtDWUfnUBLHO68CE7J9ttHGjiV0/lPqulg40KD5/vTlXNhAaM2Z58A/Dz/doymBi4Ehu/kCAoEZSqmxLYJXzbS9PSolattet/0SAA0z/JeYzu9o+eikilwUdZUeHs0dZQ572k3OYgyFSnGNlY21pNk7djE/LHPOObRimA0ToQclVUEplQwmxoO0PSxVIM2DA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FMeR6cA014X5QIz1Hm8QdSxQbO765KeUlCQHMF9WHYU=;
 b=FZjuTxzaRJ79Hx1JwPrzNZvInHPBxMLLOQR/E16gsE+nO27gSr3yGzJEs7Ys6ulUfHEQX90v6Ag3WJnFfSnP2A5b/HtO9qcJxL2l6Uy1yv1bZmev3e9kkJ5G875IyVBziczUCCqButv2unyQU4J6+f4srWWWFt+93z0rICTJZbV3tcP6daNxwSLqR0fhz0yL72dh6DigaGFYUhz1sYIE97ylWuwFfulv9FSE0EAu0cMIihKPZJjWIbt/JTG3e3SHcZBg+gbyeu19hg2H44xq9iI9NCIKbiN9jPRs2djHQV1jcIT4yzZxgxYhbs4Y6cmdTZHdkl1DG77kckcB9HZXUg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com (2603:10b6:a03:45e::8)
 by IA1PR12MB7568.namprd12.prod.outlook.com (2603:10b6:208:42c::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.29; Thu, 20 Oct
 2022 10:18:51 +0000
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::b8be:60e9:7ad8:c088]) by SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::b8be:60e9:7ad8:c088%3]) with mapi id 15.20.5723.033; Thu, 20 Oct 2022
 10:18:51 +0000
From:   Aurelien Aptel <aaptel@nvidia.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com, pabeni@redhat.com, saeedm@nvidia.com,
        tariqt@nvidia.com, linux-nvme@lists.infradead.org,
        sagi@grimberg.me, hch@lst.de, kbusch@kernel.org, axboe@fb.com,
        chaitanyak@nvidia.com
Cc:     smalin@nvidia.com, aaptel@nvidia.com, ogerlitz@nvidia.com,
        yorayz@nvidia.com, borisp@nvidia.com, aurelien.aptel@gmail.com,
        malin1024@gmail.com
Subject: [PATCH v6 01/23] net: Introduce direct data placement tcp offload
Date:   Thu, 20 Oct 2022 13:18:16 +0300
Message-Id: <20221020101838.2712846-2-aaptel@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20221020101838.2712846-1-aaptel@nvidia.com>
References: <20221020101838.2712846-1-aaptel@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0330.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18c::11) To SJ1PR12MB6075.namprd12.prod.outlook.com
 (2603:10b6:a03:45e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR12MB6075:EE_|IA1PR12MB7568:EE_
X-MS-Office365-Filtering-Correlation-Id: 3f324e04-e4e5-4b20-6d64-08dab2847bda
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YNgDVfCfxDQQn0wgg5XVPgEV6uDrIP6RksLDS1e9NKI8H3qd2EoEsqOLldjPs75A2B4Q8FFAEvEg6Kq9I8/aKBhmfVTClxLw6hBbmD9e0gy/qEmDXO9wM0RBYy6MY2KqaswxJ8ARdDXeb4HuZVQA7U97W14um+y0QyWyWZNTW4L4XWoJ43Lq1jfVbMGi1iS7JOjE3lZSHISMqRNiV3tWK28d2Aafljoo3inTi6jB9bMXZ9Qb+OBi5x+//AhJEZPmYYHhDoIW2cmwA1NnW0GK2Og9zS1KwdModcr5/RxWAVkAWxTuil0wXulLPnMMklZNZtEToJsJ+0QQB/D/l8lppsHnu5hCqGL4QoUHaUKxVrK2O28WDI5fMx298mO6CTCVUFGfDkOsZcBweMqVR3cWURgsmlpwglXR3XmLbTUXNWmUr8dBcDWlT7NoHCbu3liZxqlmi3hkBE5Wk/f2ion2PFHgwxTy67qYFeZJ68wgMWXZoweUCyeYodnjSrQw/Fj2FI7sTPnTCr0zWQx0pPa4RrNANM5Kjhe+3fHyEHsI4N7jX/72Rua3Fct2g28q+2tS40j2IrJ8xxpxAttji9AdOYGr2+rhRxrLkYcPWkec+vqb1Sjj3ndkrYuot0YNxVWGLOvGktTB1rC7e9pj7PTS7syeezxsV9hlMWipXEeWhG9UQE3+ItE1WMopuf7b5Qw/SkaR6+O2fIhp7jx5sL7Z69OpeMElWXLbF7PutUENxSGvzUXaG+uCvzDRrcVkV9zp
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR12MB6075.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(39860400002)(376002)(396003)(346002)(366004)(451199015)(921005)(6486002)(38100700002)(478600001)(6506007)(36756003)(2616005)(4326008)(6636002)(86362001)(316002)(66946007)(66556008)(8676002)(6666004)(186003)(66476007)(5660300002)(1076003)(6512007)(26005)(2906002)(8936002)(30864003)(7416002)(83380400001)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?QHbfrxbZC6Kc8X0eTb8jOqrR/y4EzQrSAYpO2gwwR88ccI+qtEBEbu8GFWfE?=
 =?us-ascii?Q?1rEFm72Oc07abiaLyJBCfAYl4tpPaRZ8IG07HXSZc9yJxpZOWE9uKuRG4qlc?=
 =?us-ascii?Q?bmH1NuZO1UO0R1ZDne5850LgcjUVp8Tm+HmXIiLW397fCmrJxdPN7WSzLj4G?=
 =?us-ascii?Q?5i4ezqTFMErCsaOIxDc7hWqohGzbIWNoPUT5yd+NBiwtXigIMF+WDZ8XYNyP?=
 =?us-ascii?Q?BMVLbr5qbuUB1b13Lit+2T4zXkrH5ITlpzkSWGNQYNN33tkiazlSHK9cIEAl?=
 =?us-ascii?Q?82+OlpLjF3ygrwl27AIybDI4D2GUXLyQ1F6WkLlVMpPhoi/rVVTwuQinjL3s?=
 =?us-ascii?Q?Ch59kYvxYkRIMnxUPjZ6RmQbTDebNc/EtWLPC7zSZatHlPZVQv5Ewx6jOM9B?=
 =?us-ascii?Q?1q3ItOT4MfKxf491Muuhbn25h15lhGFDyFnRjlImoCHsZyEBeianCQcaxN0W?=
 =?us-ascii?Q?tn6N/Fb3NT7/arcpObbSpE0b4ycZHQbRLHPntX2uBJamFIrQh6sW0yQXtXZG?=
 =?us-ascii?Q?vDLqZMXe+WqBaZDKub7C/8a9KEBXCnGEv6HDVLYeTBjbpXf1ZqKzTlvhvNWJ?=
 =?us-ascii?Q?6K9BqhR/j5qqp4X16aiJi5Ksm7HnX+jBPuHENjeh2c1TxqfPSn1yCJh++jDZ?=
 =?us-ascii?Q?EW0ba6nQMBIA1dX9bqFm6dWDQWbb16IOHfO0CKtaaOIGmQMW4XpLqyPlgyoG?=
 =?us-ascii?Q?R4twVvkHFjwpFi25k5OnogsliBKIQ5Oq3H39hn2vb/y0wau+JpY1Qgu0OBSC?=
 =?us-ascii?Q?0qfE3j4pekWX5yQH/IA0jBPvOyCLrc1vxmNDh1CWFz9SVDGPcXyCVya4fMmm?=
 =?us-ascii?Q?f7zl3wG0xice+Khn7WAVfo6CKcyXzuN74dY9vjVzWqEOZMcfhl3NTBR0ofTq?=
 =?us-ascii?Q?9fS3veAjKptRZRFaBO7KEwSTBhLw7zm5VVWuQpYBf9gzsX3UE6U6Gg+zedFs?=
 =?us-ascii?Q?WmBiFTgeTi0QdC63jmDd/JtBa5qyt999MPUlZZ80GH4QEotm2IpDt/RviSo3?=
 =?us-ascii?Q?//61lFmuOUB7ZtX/L8ZT+Ux3YGPGdc6N/Wv8Oc8AmESTmXd1aZzAyntPQ9cv?=
 =?us-ascii?Q?pce6v5+SASVngsQ2BolCIAwDLNOQEtDUjausMrQWitkguI9Q0D6lX8VkflOS?=
 =?us-ascii?Q?B2SfGRiiZd6xxkTBNvaXXJR8VBLAu2J0QoSwQUabikwNElFIje915nn2ixc3?=
 =?us-ascii?Q?8+MfseAn6mXC7KOS1+sZTkarV2NKZ4ERfKkMklKlXsgptKAOWITVp04Qqr+R?=
 =?us-ascii?Q?arozzmdcfZHZn8XOnkU2nozhoLcLWSjfcQVmE4QRyoA/zfPbl/tiPteUtnnN?=
 =?us-ascii?Q?/HThI5HaUc94jOH4qUxwRILhZ0R+ZYRTkowG/kU7twzaDmTiG77aOFsWSS3y?=
 =?us-ascii?Q?viYP+VQy5HIZ0CW1BivXAnORcfA1p8aStGmxebQYHBgfSKoQjjGfBv9udxLr?=
 =?us-ascii?Q?xrchCPb0v0I8Obi8xtU71N6BX5WFqaX9ZVmXtlHJytsouNvHyw/RlcDpCikd?=
 =?us-ascii?Q?+m5WYOpHfO+85n22SZnSOTaH6vYGeZYCelJCgD/J70n8kflZ6i+WhzsEtauR?=
 =?us-ascii?Q?hGZtT6j2yBCiNRsXMVujh4dvi5xYSYrcT1Y80RZ8?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f324e04-e4e5-4b20-6d64-08dab2847bda
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR12MB6075.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2022 10:18:51.0467
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uoxeWW7+75/SIDLyzQ0uYNcH+J+49lq70cEVJ2jTQwvyJowXfVPvjGVrR5Nt+k06mh8YisVm0KV1y/UHRghycg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB7568
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Boris Pismenny <borisp@nvidia.com>

This commit introduces direct data placement (DDP) offload for TCP.

The motivation is saving compute resources/cycles that are spent
to copy data from SKBs to the block layer buffers and CRC
calculation/verification for received PDUs (Protocol Data Units).

The DDP capability is accompanied by new net_device operations that
configure hardware contexts.

There is a context per socket, and a context per DDP operation.
Additionally, a resynchronization routine is used to assist
hardware handle TCP OOO, and continue the offload. Furthermore,
we let the offloading driver advertise what is the max hw
sectors/segments.

The interface includes five net-device ddp operations:

 1. sk_add - add offload for the queue represented by socket+config pair
 2. sk_del - remove the offload for the socket/queue
 3. ddp_setup - request copy offload for buffers associated with an IO
 4. ddp_teardown - release offload resources for that IO
 5. limits - query NIC driver for quirks and limitations (e.g.
             max number of scatter gather entries per IO)

Using this interface, the NIC hardware will scatter TCP payload
directly to the BIO pages according to the command_id.

To maintain the correctness of the network stack, the driver is
expected to construct SKBs that point to the BIO pages.

The SKB passed to the network stack from the driver represents
data as it is on the wire, while it is pointing directly to data
in destination buffers.

As a result, data from page frags should not be copied out to
the linear part. To avoid needless copies, such as when using
skb_condense, we mark the skb->ddp bit.
In addition, the skb->crc will be used by the upper layers to
determine if CRC re-calculation is required. The two separated skb
indications are needed to avoid false positives GRO flushing events.

Follow-up patches will use this interface for DDP in NVMe-TCP.

Signed-off-by: Boris Pismenny <borisp@nvidia.com>
Signed-off-by: Ben Ben-Ishay <benishay@nvidia.com>
Signed-off-by: Or Gerlitz <ogerlitz@nvidia.com>
Signed-off-by: Yoray Zack <yorayz@nvidia.com>
Signed-off-by: Shai Malin <smalin@nvidia.com>
Signed-off-by: Aurelien Aptel <aaptel@nvidia.com>
---
 include/linux/netdev_features.h    |   3 +-
 include/linux/netdevice.h          |   5 +
 include/linux/skbuff.h             |  11 ++
 include/net/inet_connection_sock.h |   4 +
 include/net/ulp_ddp.h              | 171 +++++++++++++++++++++++++++++
 net/Kconfig                        |  10 ++
 net/core/skbuff.c                  |   3 +-
 net/ethtool/common.c               |   1 +
 net/ipv4/tcp_input.c               |   8 ++
 net/ipv4/tcp_ipv4.c                |   3 +
 net/ipv4/tcp_offload.c             |   3 +
 11 files changed, 220 insertions(+), 2 deletions(-)
 create mode 100644 include/net/ulp_ddp.h

diff --git a/include/linux/netdev_features.h b/include/linux/netdev_features.h
index 7c2d77d75a88..bf7391aa04c7 100644
--- a/include/linux/netdev_features.h
+++ b/include/linux/netdev_features.h
@@ -14,7 +14,7 @@ typedef u64 netdev_features_t;
 enum {
 	NETIF_F_SG_BIT,			/* Scatter/gather IO. */
 	NETIF_F_IP_CSUM_BIT,		/* Can checksum TCP/UDP over IPv4. */
-	__UNUSED_NETIF_F_1,
+	NETIF_F_HW_ULP_DDP_BIT,         /* ULP direct data placement offload */
 	NETIF_F_HW_CSUM_BIT,		/* Can checksum all the packets. */
 	NETIF_F_IPV6_CSUM_BIT,		/* Can checksum TCP/UDP over IPV6 */
 	NETIF_F_HIGHDMA_BIT,		/* Can DMA to high memory. */
@@ -168,6 +168,7 @@ enum {
 #define NETIF_F_HW_HSR_TAG_RM	__NETIF_F(HW_HSR_TAG_RM)
 #define NETIF_F_HW_HSR_FWD	__NETIF_F(HW_HSR_FWD)
 #define NETIF_F_HW_HSR_DUP	__NETIF_F(HW_HSR_DUP)
+#define NETIF_F_HW_ULP_DDP	__NETIF_F(HW_ULP_DDP)
 
 /* Finds the next feature with the highest number of the range of start-1 till 0.
  */
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index a36edb0ec199..ff6f4978723a 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1043,6 +1043,7 @@ struct dev_ifalias {
 
 struct devlink;
 struct tlsdev_ops;
+struct ulp_ddp_dev_ops;
 
 struct netdev_net_notifier {
 	struct list_head list;
@@ -2096,6 +2097,10 @@ struct net_device {
 	const struct tlsdev_ops *tlsdev_ops;
 #endif
 
+#if IS_ENABLED(CONFIG_ULP_DDP)
+	const struct ulp_ddp_dev_ops *ulp_ddp_ops;
+#endif
+
 	const struct header_ops *header_ops;
 
 	unsigned char		operstate;
diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 9fcf534f2d92..5b6e27d281a6 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -810,6 +810,8 @@ typedef unsigned char *sk_buff_data_t;
  *		delivery_time in mono clock base (i.e. EDT).  Otherwise, the
  *		skb->tstamp has the (rcv) timestamp at ingress and
  *		delivery_time at egress.
+ *	@ulp_ddp: DDP offloaded
+ *	@ulp_crc: CRC offloaded
  *	@napi_id: id of the NAPI struct this skb came from
  *	@sender_cpu: (aka @napi_id) source CPU in XPS
  *	@alloc_cpu: CPU which did the skb allocation.
@@ -982,6 +984,15 @@ struct sk_buff {
 #endif
 	__u8			slow_gro:1;
 	__u8			csum_not_inet:1;
+#ifdef CONFIG_ULP_DDP
+	__u8                    ulp_ddp:1;
+	__u8			ulp_crc:1;
+#define IS_ULP_DDP(skb) ((skb)->ulp_ddp)
+#define IS_ULP_CRC(skb) ((skb)->ulp_crc)
+#else
+#define IS_ULP_DDP(skb) (0)
+#define IS_ULP_CRC(skb) (0)
+#endif
 
 #ifdef CONFIG_NET_SCHED
 	__u16			tc_index;	/* traffic control index */
diff --git a/include/net/inet_connection_sock.h b/include/net/inet_connection_sock.h
index c2b15f7e5516..2ba73167b3bb 100644
--- a/include/net/inet_connection_sock.h
+++ b/include/net/inet_connection_sock.h
@@ -68,6 +68,8 @@ struct inet_connection_sock_af_ops {
  * @icsk_ulp_ops	   Pluggable ULP control hook
  * @icsk_ulp_data	   ULP private data
  * @icsk_clean_acked	   Clean acked data hook
+ * @icsk_ulp_ddp_ops	   Pluggable ULP direct data placement control hook
+ * @icsk_ulp_ddp_data	   ULP direct data placement private data
  * @icsk_ca_state:	   Congestion control state
  * @icsk_retransmits:	   Number of unrecovered [RTO] timeouts
  * @icsk_pending:	   Scheduled timer event
@@ -98,6 +100,8 @@ struct inet_connection_sock {
 	const struct tcp_ulp_ops  *icsk_ulp_ops;
 	void __rcu		  *icsk_ulp_data;
 	void (*icsk_clean_acked)(struct sock *sk, u32 acked_seq);
+	const struct ulp_ddp_ulp_ops  *icsk_ulp_ddp_ops;
+	void __rcu		  *icsk_ulp_ddp_data;
 	unsigned int		  (*icsk_sync_mss)(struct sock *sk, u32 pmtu);
 	__u8			  icsk_ca_state:5,
 				  icsk_ca_initialized:1,
diff --git a/include/net/ulp_ddp.h b/include/net/ulp_ddp.h
new file mode 100644
index 000000000000..57cc4ab22e18
--- /dev/null
+++ b/include/net/ulp_ddp.h
@@ -0,0 +1,171 @@
+/* SPDX-License-Identifier: GPL-2.0
+ *
+ * ulp_ddp.h
+ *	Author:	Boris Pismenny <borisp@nvidia.com>
+ *	Copyright (C) 2022 NVIDIA CORPORATION & AFFILIATES.
+ */
+#ifndef _ULP_DDP_H
+#define _ULP_DDP_H
+
+#include <linux/netdevice.h>
+#include <net/inet_connection_sock.h>
+#include <net/sock.h>
+
+enum ulp_ddp_type {
+	ULP_DDP_NVME = 1,
+};
+
+enum ulp_ddp_offload_capabilities {
+	ULP_DDP_C_NVME_TCP = 1,
+	ULP_DDP_C_NVME_TCP_DDGST_RX = 2,
+};
+
+/**
+ * struct ulp_ddp_limits - Generic ulp ddp limits: tcp ddp
+ * protocol limits.
+ * Protocol implementations must use this as the first member.
+ * Add new instances of ulp_ddp_limits below (nvme-tcp, etc.).
+ *
+ * @max_ddp_sgl_len:	maximum sgl size supported (zero means no limit)
+ * @io_threshold:	minimum payload size required to offload
+ */
+struct ulp_ddp_limits {
+	enum ulp_ddp_type	type;
+	u64			offload_capabilities;
+	int			max_ddp_sgl_len;
+	int			io_threshold;
+	unsigned char		buf[];
+};
+
+/**
+ * struct nvme_tcp_ddp_limits - nvme tcp driver limitations
+ *
+ * @full_ccid_range:	true if the driver supports the full CID range
+ */
+struct nvme_tcp_ddp_limits {
+	struct ulp_ddp_limits	lmt;
+
+	bool			full_ccid_range;
+};
+
+/**
+ * struct ulp_ddp_config - Generic ulp ddp configuration: tcp ddp IO queue
+ * config implementations must use this as the first member.
+ * Add new instances of ulp_ddp_config below (nvme-tcp, etc.).
+ */
+struct ulp_ddp_config {
+	enum ulp_ddp_type    type;
+	unsigned char        buf[];
+};
+
+/**
+ * struct nvme_tcp_ddp_config - nvme tcp ddp configuration for an IO queue
+ *
+ * @pfv:        pdu version (e.g., NVME_TCP_PFV_1_0)
+ * @cpda:       controller pdu data alignment (dwords, 0's based)
+ * @dgst:       digest types enabled (header or data, see enum nvme_tcp_digest_option).
+ *              The netdev will offload crc if it is supported.
+ * @queue_size: number of nvme-tcp IO queue elements
+ * @queue_id:   queue identifier
+ * @cpu_io:     cpu core running the IO thread for this queue
+ */
+struct nvme_tcp_ddp_config {
+	struct ulp_ddp_config	cfg;
+
+	u16			pfv;
+	u8			cpda;
+	u8			dgst;
+	int			queue_size;
+	int			queue_id;
+	int			io_cpu;
+};
+
+/**
+ * struct ulp_ddp_io - ulp ddp configuration for an IO request.
+ *
+ * @command_id:  identifier on the wire associated with these buffers
+ * @nents:       number of entries in the sg_table
+ * @sg_table:    describing the buffers for this IO request
+ * @first_sgl:   first SGL in sg_table
+ */
+struct ulp_ddp_io {
+	u32			command_id;
+	int			nents;
+	struct sg_table		sg_table;
+	struct scatterlist	first_sgl[SG_CHUNK_SIZE];
+};
+
+/* struct ulp_ddp_dev_ops - operations used by an upper layer protocol
+ *                          to configure ddp offload
+ *
+ * @ulp_ddp_limits:    query ulp driver limitations and quirks.
+ * @ulp_ddp_sk_add:    add offload for the queue represented by socket+config
+ *                     pair. this function is used to configure either copy, crc
+ *                     or both offloads.
+ * @ulp_ddp_sk_del:    remove offload from the socket, and release any device
+ *                     related resources.
+ * @ulp_ddp_setup:     request copy offload for buffers associated with a
+ *                     command_id in ulp_ddp_io.
+ * @ulp_ddp_teardown:  release offload resources association between buffers
+ *                     and command_id in ulp_ddp_io.
+ * @ulp_ddp_resync:    respond to the driver's resync_request. Called only if
+ *                     resync is successful.
+ */
+struct ulp_ddp_dev_ops {
+	int (*ulp_ddp_limits)(struct net_device *netdev,
+			      struct ulp_ddp_limits *limits);
+	int (*ulp_ddp_sk_add)(struct net_device *netdev,
+			      struct sock *sk,
+			      struct ulp_ddp_config *config);
+	void (*ulp_ddp_sk_del)(struct net_device *netdev,
+			       struct sock *sk);
+	int (*ulp_ddp_setup)(struct net_device *netdev,
+			     struct sock *sk,
+			     struct ulp_ddp_io *io);
+	int (*ulp_ddp_teardown)(struct net_device *netdev,
+				struct sock *sk,
+				struct ulp_ddp_io *io,
+				void *ddp_ctx);
+	void (*ulp_ddp_resync)(struct net_device *netdev,
+			       struct sock *sk, u32 seq);
+};
+
+#define ULP_DDP_RESYNC_PENDING BIT(0)
+
+/**
+ * struct ulp_ddp_ulp_ops - Interface to register uppper layer
+ *                          Direct Data Placement (DDP) TCP offload.
+ * @resync_request:         NIC requests ulp to indicate if @seq is the start
+ *                          of a message.
+ * @ddp_teardown_done:      NIC driver informs the ulp that teardown is done,
+ *                          used for async completions.
+ */
+struct ulp_ddp_ulp_ops {
+	bool (*resync_request)(struct sock *sk, u32 seq, u32 flags);
+	void (*ddp_teardown_done)(void *ddp_ctx);
+};
+
+/**
+ * struct ulp_ddp_ctx - Generic ulp ddp context: device driver per queue contexts must
+ * use this as the first member.
+ */
+struct ulp_ddp_ctx {
+	enum ulp_ddp_type	type;
+	unsigned char		buf[];
+};
+
+static inline struct ulp_ddp_ctx *ulp_ddp_get_ctx(const struct sock *sk)
+{
+	struct inet_connection_sock *icsk = inet_csk(sk);
+
+	return (__force struct ulp_ddp_ctx *)icsk->icsk_ulp_ddp_data;
+}
+
+static inline void ulp_ddp_set_ctx(struct sock *sk, void *ctx)
+{
+	struct inet_connection_sock *icsk = inet_csk(sk);
+
+	rcu_assign_pointer(icsk->icsk_ulp_ddp_data, ctx);
+}
+
+#endif	/* _ULP_DDP_H */
diff --git a/net/Kconfig b/net/Kconfig
index 48c33c222199..cd59be2d6c6e 100644
--- a/net/Kconfig
+++ b/net/Kconfig
@@ -471,4 +471,14 @@ config NETDEV_ADDR_LIST_TEST
 	default KUNIT_ALL_TESTS
 	depends on KUNIT
 
+config ULP_DDP
+	bool "ULP direct data placement offload"
+	default n
+	help
+	  Direct Data Placement (DDP) offload enables ULP, such as
+	  NVMe-TCP, to request the NIC to place ULP payload data
+	  of a command response directly into kernel pages while
+	  calculate/verify the data digest on ULP PDU as they go through
+	  the NIC. Thus avoiding the costly per-byte overhead.
+
 endif   # if NET
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 1d9719e72f9d..a7e92547924f 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -72,6 +72,7 @@
 #include <net/mptcp.h>
 #include <net/mctp.h>
 #include <net/page_pool.h>
+#include <net/ulp_ddp.h>
 
 #include <linux/uaccess.h>
 #include <trace/events/skb.h>
@@ -6409,7 +6410,7 @@ void skb_condense(struct sk_buff *skb)
 {
 	if (skb->data_len) {
 		if (skb->data_len > skb->end - skb->tail ||
-		    skb_cloned(skb))
+		    skb_cloned(skb) || IS_ULP_DDP(skb))
 			return;
 
 		/* Nice, we can free page frag(s) right now */
diff --git a/net/ethtool/common.c b/net/ethtool/common.c
index 566adf85e658..da125a8357df 100644
--- a/net/ethtool/common.c
+++ b/net/ethtool/common.c
@@ -74,6 +74,7 @@ const char netdev_features_strings[NETDEV_FEATURE_COUNT][ETH_GSTRING_LEN] = {
 	[NETIF_F_HW_HSR_TAG_RM_BIT] =	 "hsr-tag-rm-offload",
 	[NETIF_F_HW_HSR_FWD_BIT] =	 "hsr-fwd-offload",
 	[NETIF_F_HW_HSR_DUP_BIT] =	 "hsr-dup-offload",
+	[NETIF_F_HW_ULP_DDP_BIT] =	 "ulp-ddp-offload",
 };
 
 const char
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index bc2ea12221f9..17d50cf63fa1 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -5232,6 +5232,10 @@ tcp_collapse(struct sock *sk, struct sk_buff_head *list, struct rb_root *root,
 		memcpy(nskb->cb, skb->cb, sizeof(skb->cb));
 #ifdef CONFIG_TLS_DEVICE
 		nskb->decrypted = skb->decrypted;
+#endif
+#ifdef CONFIG_ULP_DDP
+		nskb->ulp_ddp = skb->ulp_ddp;
+		nskb->ulp_crc = skb->ulp_crc;
 #endif
 		TCP_SKB_CB(nskb)->seq = TCP_SKB_CB(nskb)->end_seq = start;
 		if (list)
@@ -5265,6 +5269,10 @@ tcp_collapse(struct sock *sk, struct sk_buff_head *list, struct rb_root *root,
 #ifdef CONFIG_TLS_DEVICE
 				if (skb->decrypted != nskb->decrypted)
 					goto end;
+#endif
+#ifdef CONFIG_ULP_DDP
+				if (IS_ULP_CRC(skb) != IS_ULP_CRC(nskb))
+					goto end;
 #endif
 			}
 		}
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 6376ad915765..81333dcb4349 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -1821,6 +1821,9 @@ bool tcp_add_backlog(struct sock *sk, struct sk_buff *skb,
 	      TCP_SKB_CB(skb)->tcp_flags) & (TCPHDR_ECE | TCPHDR_CWR)) ||
 #ifdef CONFIG_TLS_DEVICE
 	    tail->decrypted != skb->decrypted ||
+#endif
+#ifdef CONFIG_ULP_DDP
+	    IS_ULP_CRC(tail) != IS_ULP_CRC(skb) ||
 #endif
 	    thtail->doff != th->doff ||
 	    memcmp(thtail + 1, th + 1, hdrlen - sizeof(*th)))
diff --git a/net/ipv4/tcp_offload.c b/net/ipv4/tcp_offload.c
index 45dda7889387..5b8b4cbc50c1 100644
--- a/net/ipv4/tcp_offload.c
+++ b/net/ipv4/tcp_offload.c
@@ -268,6 +268,9 @@ struct sk_buff *tcp_gro_receive(struct list_head *head, struct sk_buff *skb)
 #ifdef CONFIG_TLS_DEVICE
 	flush |= p->decrypted ^ skb->decrypted;
 #endif
+#ifdef CONFIG_ULP_DDP
+	flush |= IS_ULP_CRC(p) ^ IS_ULP_CRC(skb);
+#endif
 
 	if (flush || skb_gro_receive(p, skb)) {
 		mss = 1;
-- 
2.31.1

