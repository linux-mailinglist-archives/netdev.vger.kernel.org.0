Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70F6E67D131
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 17:22:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232670AbjAZQWE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 11:22:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232644AbjAZQV5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 11:21:57 -0500
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2089.outbound.protection.outlook.com [40.107.100.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2180279A1
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 08:21:55 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AQ2R6Q9wXsJqqdhYl9TfnAgtQaJcVE/fJMBscC6al5IvdcDqY0oDOH3dWhapFPP8W+nQukcpSpM9pPq8Sk7N6xNfnMt4OFbh+7b1J4w1kYqwi0QQxEhk9vMGQL+z5IzLsf/gnpMKApSVKrTwxgiJCFt+2BrVwYdbb+GJIGylgZ1QeMDTUuVmLIUr7yc1ATWY0ayrckhqLTLl2yopBVFyQ0Yo/vA2pnL6qGVYpy5lWqftfD9W//0HBlDjNP7D2p9KMyBi9MV+/hebQVYwqLcAm9Jz0tihE3soDAyKdZw7aYXcqU4qVv4JY4vuY/fM6SBY7iUxz8Xz97E2VI0MEuemkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zco3Rye9t8L5HeNT0o8pojqa6/I6RzXj1AyZBLRytV0=;
 b=c9JoKaefZPIOq7pCTd5TevL6KpAaGi8WDA/97QAnL60DrGhSn8YelaqHHvj2dsPvGdq3t+2VHpR7UJMPafulqqAXtHqr17zH+/RvqPrJLpiUBDEoXQP5Z4/VAr9FoYPgBUbtf2jRwf7iMWHp2RLxAAjCdXENAVHVNrEcwBA/AW7TR8MbfArX8PVxLhCtr/2clRzerA2GgVsU53jE78uLOR3VZd4a2o2z50QZBc7sOcsvv5yZh8zKaZePOKGKjoP1OavADQF9szppXvuYQDV6M6DhOV3BfAJ8iYOZ2N+hltbkeZt/ngs3awzDhTudVCNVb5gR2f3ZeZtVG5qbOQvZQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zco3Rye9t8L5HeNT0o8pojqa6/I6RzXj1AyZBLRytV0=;
 b=Utdcr4DOpSU3iQPovzgZAJg86ThTePw1rwCqn138Wz9y43lTgeonxnM+qm97UdjnFB5vgQR1iGnTq4EwICNmVjkEDZU6aWOX1cq9j0fpyMFZ2jmUh0XQvJtRppDGoJoOE0ejjKbs4VLW4PS7s67kVAQRidHolMFjIDkleDuJTx8PC7tb/hWLe32aESd8mIqlPOAcPaCBTSq+w4AVc5gIRvK+8/ZIOdabtBdvs4odROI97XBcHAnAjvhwItRuUXO2xWGHVSD6HuzmiUxVvWckMIPrEBD2/dgtWUdcaDkbFwL6AzbeY/3kTX1DEmBxvd7jfwO8SImOgaNheyjnfYDyMA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com (2603:10b6:a03:45e::8)
 by SJ0PR12MB5422.namprd12.prod.outlook.com (2603:10b6:a03:3ac::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.22; Thu, 26 Jan
 2023 16:21:53 +0000
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::9fd9:dadc:4d8a:2d84]) by SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::9fd9:dadc:4d8a:2d84%6]) with mapi id 15.20.6043.022; Thu, 26 Jan 2023
 16:21:53 +0000
From:   Aurelien Aptel <aaptel@nvidia.com>
To:     linux-nvme@lists.infradead.org, netdev@vger.kernel.org,
        sagi@grimberg.me, hch@lst.de, kbusch@kernel.org, axboe@fb.com,
        chaitanyak@nvidia.com, davem@davemloft.net, kuba@kernel.org,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Aurelien Aptel <aaptel@nvidia.com>, aurelien.aptel@gmail.com,
        smalin@nvidia.com, malin1024@gmail.com, ogerlitz@nvidia.com,
        yorayz@nvidia.com, borisp@nvidia.com
Subject: [PATCH v10 01/25] net: Introduce direct data placement tcp offload
Date:   Thu, 26 Jan 2023 18:21:12 +0200
Message-Id: <20230126162136.13003-2-aaptel@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230126162136.13003-1-aaptel@nvidia.com>
References: <20230126162136.13003-1-aaptel@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0571.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:276::10) To SJ1PR12MB6075.namprd12.prod.outlook.com
 (2603:10b6:a03:45e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR12MB6075:EE_|SJ0PR12MB5422:EE_
X-MS-Office365-Filtering-Correlation-Id: 144279f6-2f6d-4b22-c134-08daffb96f6b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /y1lRuCu7FDjBALRLdrzDwVA9Zwrr1arWygwBFUja5vj2T2ZBVShfalMwJBFu3Fl9Xd2K6u72XZIqhTpn8nrRAoe31FIKWZcB2TCJ2U+kcGCKrZpfQt92ap1Sa4I4WeOGHSz14WueE/wtL5U7g7WLY2SXR5KTvKZtG9sziaxgFb+BKrXOdP0sjFR22VUv5/mYLDd5WfXmHtah9FCgKsdXMFREoxKMmw1b+JSdCFP9J554NG3HrCb+TKua6ECwL3Jm8tyYeL2yUDJOqkPNfrQwhckqwXexklX7bgpwIzLHrI1ctRK3G/muxBTETxrc64gOGNP+K2nmZ7vRtW+BmmuTm8AeR1ck7LYmJCUUErOuVkJyhM/wNPc2UKsOP+Rl10XJDC6itaYyIvaDeSTXBLf4XLQaJcn5EJBlZsUS4Jd2dQ9X7MIfAgGhEc22MteF4GZEjlEqMs6+usKk2cI4AGpuwxqcVgZWXLzBntlzAez4sMh3cGmZSA6yrSwx2tBXUT81DyC7+FIhAy0HHpmVti+XbGSKs+kew32s0HxAIcQ/Zws6L/TwMv76TlJ7VcaXhx0WwHI4BDRAD4twrHUdyAtbuPkSb77UPpOt8XIVqXb8t8Z9dLt8nRYQTqMsbcUQWqcyCl6Qc/VNWbZ9oGXvQtekmaSIh3iHEoFSDleeWgczjrT3qv+8Z8NknpNc1Tck09X
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR12MB6075.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(376002)(39860400002)(136003)(396003)(366004)(451199018)(316002)(38100700002)(41300700001)(8676002)(66556008)(66946007)(66476007)(6916009)(4326008)(5660300002)(30864003)(7416002)(36756003)(86362001)(8936002)(921005)(2906002)(6506007)(1076003)(26005)(6512007)(186003)(478600001)(6486002)(83380400001)(6666004)(107886003)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?u3cVvFtUnbOUIw08bLD58Pnr2qIr4EvQvpiWMuGzUtMe+irww1pI6899AnFq?=
 =?us-ascii?Q?B8E8izngcmcyzehx1yklRouDhUIeDWXOjpc5UTd46JZHLnGwIkr1YIcpVPia?=
 =?us-ascii?Q?QDdmeLisF+9Cp3+pJMhNCTTwLR1Lvc7N2AgGtbXmHQ7XmbE7x7hNKHandpki?=
 =?us-ascii?Q?/i8m6Eqw82DWlQ9o7QToNGe55K9T2mvWk9ATxwlE7voDt0J8o2IoEdYyRvs7?=
 =?us-ascii?Q?h5kWOdff/gx+NDD4ejQtYL9wvlipWYsJRjpgEuCq9wjub1+AUTMX5zLR4hU2?=
 =?us-ascii?Q?i1v46YSvn+0z0PEzsgdTUdQMuTXnkRMLUZF3i6YEObl50kCCLirhp3zlACPN?=
 =?us-ascii?Q?e6fx4CsA/6UYp8rU1asJ1W4mjILDQQw2c9ccoqYzLrTbW02vVO2mAK46G/KY?=
 =?us-ascii?Q?NteeZaMXf5tmpkQyLcuzGlhaHoivrQOXAwRLrwK2JPNeIqL6c+PEpze38auQ?=
 =?us-ascii?Q?BgTV9MhPPihPNBzQnuoR9vWIf59srcdr9eb6L8hfIhllDOGPQVw7ic3XnAiQ?=
 =?us-ascii?Q?KVEueKx8qkJhWEReGh2zcKdaqRAj9rMwWN8XITs3ZJYGuZM7K7J/dfd19pqe?=
 =?us-ascii?Q?ETK0P4/ngR0yp4FQraSjVU/qO1ApGCDFQUvzAFRRMd1a03mE4M3R6mGpEhtB?=
 =?us-ascii?Q?Y35/0fizWqsAIn97ECCyZGI/4bZJXjmeVdvPjtV4RPeMCwmiF66p9EZYwmXI?=
 =?us-ascii?Q?Me7z6UkkSPDCuEOax0ZEI/JaUJPCUeirpMl/yi5BSZbuuIX5VrieAuABg5BI?=
 =?us-ascii?Q?CwRDXZBPyDiu6xgrDd/hMj5V41nhhNlUTM6kLJeOVS/IBAc2J7fSaUQtvpWN?=
 =?us-ascii?Q?QS9FmUaJ9LsoppdprmjbeqfnAME+IQSjLNyOT0A39HlLBfd2uMHf0kvra8Og?=
 =?us-ascii?Q?eKTSRZY1Aefj6hTkq9eU9CjoGEEjS27BMV+74tBsfY2dBuSNspbCial6R80X?=
 =?us-ascii?Q?8dby5A/bTyPOgYwPNi1Su5cL/lpa5pmFZI3dGkjZKEQIeOmP5I5NL7DaHwyi?=
 =?us-ascii?Q?Bd4opXNZVkVeKetL4C6ql/uTDacogj8D8orE0M1sFMOyY6etEN+fnM/CUplD?=
 =?us-ascii?Q?HHueccCdfx3fN2ASaBLIvxO6To3j5QX28lRotApCbAybRSw3Pu/zJarReftI?=
 =?us-ascii?Q?48U1g6JX+XOJ7KeiO1mOUBjK8EL81Bqm9JbnP0Z9MpIncNIruM09JneurI5c?=
 =?us-ascii?Q?nHzqvocS+PEbSAORgpMoYmo79rDfp3LVXXHgwrqe8EIkkcFY8MKNBNqBoKu/?=
 =?us-ascii?Q?iCkLOr3o2UPOpC3cPAEcrEtaGJe2RzpBh5Dz32mYzQlXduuI8vAziVOuXZOU?=
 =?us-ascii?Q?H7dMmNHKvi8AMNO+oJCuT18tb4hjZLFIgcPULSxZ7GMNA4kbb5vx6YGWFMbr?=
 =?us-ascii?Q?EaeJU+zWs6O5XC2DWt2eSF0MoJ/Rgu4XejSZZKCDfRZpn4C8mSou7fSUMHaO?=
 =?us-ascii?Q?NW/uyZme+XUBCgTqVpbGZ6rBy4fMyUbgr1JqRUP0guIvP4uT/JGUxRAfDbeQ?=
 =?us-ascii?Q?eBXS+0IWgd4+SiEtuC24RQZ4jlgY0dvSfLB4vQfmOZ5ByZIToKcmB27zFS6r?=
 =?us-ascii?Q?my2Y8hNiq0oFKIQhaKE/DN45lNi4uJ28Qvn7WZDz?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 144279f6-2f6d-4b22-c134-08daffb96f6b
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR12MB6075.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2023 16:21:53.2836
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Lh1Qy5wSqQGGoDbI0heqX2CMu/E/rkmBvI7shKKzjJ/Zwk6h+q5Ap1LeWtmvGJYcaMA4/zDMVUpSjXKHqKXqWw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5422
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
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
skb_condense, we mark the skb->ulp_ddp bit.
In addition, the skb->ulp_crc will be used by the upper layers to
determine if CRC re-calculation is required. The two separated skb
indications are needed to avoid false positives GRO flushing events.

Follow-up patches will use this interface for DDP in NVMe-TCP.

Capability bits stored in net_device allow drivers to report which
ULP DDP capabilities a device supports. Control over these
capabilities will be exposed to userspace in later patches.

Signed-off-by: Boris Pismenny <borisp@nvidia.com>
Signed-off-by: Ben Ben-Ishay <benishay@nvidia.com>
Signed-off-by: Or Gerlitz <ogerlitz@nvidia.com>
Signed-off-by: Yoray Zack <yorayz@nvidia.com>
Signed-off-by: Shai Malin <smalin@nvidia.com>
Signed-off-by: Aurelien Aptel <aaptel@nvidia.com>
---
 include/linux/netdevice.h          |  15 +++
 include/linux/skbuff.h             |  24 ++++
 include/net/inet_connection_sock.h |   6 +
 include/net/ulp_ddp.h              | 187 +++++++++++++++++++++++++++++
 include/net/ulp_ddp_caps.h         |  35 ++++++
 net/Kconfig                        |  20 +++
 net/core/skbuff.c                  |   3 +-
 net/ipv4/tcp_input.c               |  13 +-
 net/ipv4/tcp_ipv4.c                |   3 +
 net/ipv4/tcp_offload.c             |   3 +
 10 files changed, 307 insertions(+), 2 deletions(-)
 create mode 100644 include/net/ulp_ddp.h
 create mode 100644 include/net/ulp_ddp_caps.h

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index aad12a179e54..289cfdade177 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -52,6 +52,10 @@
 #include <net/net_trackers.h>
 #include <net/net_debug.h>
 
+#ifdef CONFIG_ULP_DDP
+#include <net/ulp_ddp_caps.h>
+#endif
+
 struct netpoll_info;
 struct device;
 struct ethtool_ops;
@@ -1392,6 +1396,8 @@ struct netdev_net_notifier {
  *	Get hardware timestamp based on normal/adjustable time or free running
  *	cycle counter. This function is required if physical clock supports a
  *	free running cycle counter.
+ * struct ulp_ddp_dev_ops *ulp_ddp_ops;
+ *	ULP DDP operations (see include/net/ulp_ddp.h)
  */
 struct net_device_ops {
 	int			(*ndo_init)(struct net_device *dev);
@@ -1616,6 +1622,9 @@ struct net_device_ops {
 	ktime_t			(*ndo_get_tstamp)(struct net_device *dev,
 						  const struct skb_shared_hwtstamps *hwtstamps,
 						  bool cycles);
+#if IS_ENABLED(CONFIG_ULP_DDP)
+	const struct ulp_ddp_dev_ops	*ulp_ddp_ops;
+#endif
 };
 
 /**
@@ -1783,6 +1792,9 @@ enum netdev_ml_priv_type {
  *	@mpls_features:	Mask of features inheritable by MPLS
  *	@gso_partial_features: value(s) from NETIF_F_GSO\*
  *
+ *	@ulp_ddp_caps:	Bitflags keeping track of supported and enabled
+ *			ULP DDP capabilities.
+ *
  *	@ifindex:	interface index
  *	@group:		The group the device belongs to
  *
@@ -2071,6 +2083,9 @@ struct net_device {
 	netdev_features_t	mpls_features;
 	netdev_features_t	gso_partial_features;
 
+#ifdef CONFIG_ULP_DDP
+	struct ulp_ddp_netdev_caps ulp_ddp_caps;
+#endif
 	unsigned int		min_mtu;
 	unsigned int		max_mtu;
 	unsigned short		type;
diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 4c8492401a10..8708c5935e89 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -811,6 +811,8 @@ typedef unsigned char *sk_buff_data_t;
  *		delivery_time in mono clock base (i.e. EDT).  Otherwise, the
  *		skb->tstamp has the (rcv) timestamp at ingress and
  *		delivery_time at egress.
+ *	@ulp_ddp: DDP offloaded
+ *	@ulp_crc: CRC offloaded
  *	@napi_id: id of the NAPI struct this skb came from
  *	@sender_cpu: (aka @napi_id) source CPU in XPS
  *	@alloc_cpu: CPU which did the skb allocation.
@@ -983,6 +985,10 @@ struct sk_buff {
 	__u8			slow_gro:1;
 	__u8			csum_not_inet:1;
 	__u8			scm_io_uring:1;
+#ifdef CONFIG_ULP_DDP
+	__u8                    ulp_ddp:1;
+	__u8			ulp_crc:1;
+#endif
 
 #ifdef CONFIG_NET_SCHED
 	__u16			tc_index;	/* traffic control index */
@@ -5053,5 +5059,23 @@ static inline void skb_mark_for_recycle(struct sk_buff *skb)
 }
 #endif
 
+static inline bool skb_is_ulp_ddp(struct sk_buff *skb)
+{
+#ifdef CONFIG_ULP_DDP
+	return skb->ulp_ddp;
+#else
+	return 0;
+#endif
+}
+
+static inline bool skb_is_ulp_crc(struct sk_buff *skb)
+{
+#ifdef CONFIG_ULP_DDP
+	return skb->ulp_crc;
+#else
+	return 0;
+#endif
+}
+
 #endif	/* __KERNEL__ */
 #endif	/* _LINUX_SKBUFF_H */
diff --git a/include/net/inet_connection_sock.h b/include/net/inet_connection_sock.h
index c2b15f7e5516..b11fbbc95541 100644
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
@@ -98,6 +100,10 @@ struct inet_connection_sock {
 	const struct tcp_ulp_ops  *icsk_ulp_ops;
 	void __rcu		  *icsk_ulp_data;
 	void (*icsk_clean_acked)(struct sock *sk, u32 acked_seq);
+#ifdef CONFIG_ULP_DDP
+	const struct ulp_ddp_ulp_ops  *icsk_ulp_ddp_ops;
+	void __rcu		  *icsk_ulp_ddp_data;
+#endif
 	unsigned int		  (*icsk_sync_mss)(struct sock *sk, u32 pmtu);
 	__u8			  icsk_ca_state:5,
 				  icsk_ca_initialized:1,
diff --git a/include/net/ulp_ddp.h b/include/net/ulp_ddp.h
new file mode 100644
index 000000000000..50a8f29630c0
--- /dev/null
+++ b/include/net/ulp_ddp.h
@@ -0,0 +1,187 @@
+/* SPDX-License-Identifier: GPL-2.0
+ *
+ * ulp_ddp.h
+ *	Author:	Boris Pismenny <borisp@nvidia.com>
+ *	Copyright (c) 2023, NVIDIA CORPORATION & AFFILIATES.  All rights reserved.
+ */
+#ifndef _ULP_DDP_H
+#define _ULP_DDP_H
+
+#include <linux/netdevice.h>
+#include <net/inet_connection_sock.h>
+#include <net/sock.h>
+
+#include "ulp_ddp_caps.h"
+
+enum ulp_ddp_type {
+	ULP_DDP_NVME = 1,
+};
+
+/**
+ * struct nvme_tcp_ddp_limits - nvme tcp driver limitations
+ *
+ * @full_ccid_range:	true if the driver supports the full CID range
+ */
+struct nvme_tcp_ddp_limits {
+	bool			full_ccid_range;
+};
+
+/**
+ * struct ulp_ddp_limits - Generic ulp ddp limits: tcp ddp
+ * protocol limits.
+ * Add new instances of ulp_ddp_limits in the union below (nvme-tcp, etc.).
+ *
+ * @type:		type of this limits struct
+ * @max_ddp_sgl_len:	maximum sgl size supported (zero means no limit)
+ * @io_threshold:	minimum payload size required to offload
+ * @nvmeotcp:		NVMe-TCP specific limits
+ */
+struct ulp_ddp_limits {
+	enum ulp_ddp_type	type;
+	int			max_ddp_sgl_len;
+	int			io_threshold;
+	union {
+		struct nvme_tcp_ddp_limits nvmeotcp;
+	};
+};
+
+/**
+ * struct nvme_tcp_ddp_config - nvme tcp ddp configuration for an IO queue
+ *
+ * @pfv:	pdu version (e.g., NVME_TCP_PFV_1_0)
+ * @cpda:	controller pdu data alignment (dwords, 0's based)
+ * @dgst:	digest types enabled (header or data, see enum nvme_tcp_digest_option).
+ *		The netdev will offload crc if it is supported.
+ * @queue_size: number of nvme-tcp IO queue elements
+ * @queue_id:	queue identifier
+ * @io_cpu:	cpu core running the IO thread for this queue
+ */
+struct nvme_tcp_ddp_config {
+	u16			pfv;
+	u8			cpda;
+	u8			dgst;
+	int			queue_size;
+	int			queue_id;
+	int			io_cpu;
+};
+
+/**
+ * struct ulp_ddp_config - Generic ulp ddp configuration
+ * Add new instances of ulp_ddp_config in the union below (nvme-tcp, etc.).
+ *
+ * @type:	type of this config struct
+ * @nvmeotcp:	NVMe-TCP specific config
+ */
+struct ulp_ddp_config {
+	enum ulp_ddp_type    type;
+	union {
+		struct nvme_tcp_ddp_config nvmeotcp;
+	};
+};
+
+/**
+ * struct ulp_ddp_io - ulp ddp configuration for an IO request.
+ *
+ * @command_id: identifier on the wire associated with these buffers
+ * @nents:	number of entries in the sg_table
+ * @sg_table:	describing the buffers for this IO request
+ * @first_sgl:	first SGL in sg_table
+ */
+struct ulp_ddp_io {
+	u32			command_id;
+	int			nents;
+	struct sg_table		sg_table;
+	struct scatterlist	first_sgl[SG_CHUNK_SIZE];
+};
+
+struct ethtool_ulp_ddp_stats;
+
+/**
+ * struct ulp_ddp_dev_ops - operations used by an upper layer protocol
+ *                          to configure ddp offload
+ *
+ * @limits:    query ulp driver limitations and quirks.
+ * @sk_add:    add offload for the queue represented by socket+config
+ *             pair. this function is used to configure either copy, crc
+ *             or both offloads.
+ * @sk_del:    remove offload from the socket, and release any device
+ *             related resources.
+ * @setup:     request copy offload for buffers associated with a
+ *             command_id in ulp_ddp_io.
+ * @teardown:  release offload resources association between buffers
+ *             and command_id in ulp_ddp_io.
+ * @resync:    respond to the driver's resync_request. Called only if
+ *             resync is successful.
+ * @set_caps:  set device ULP DDP capabilities.
+ *	       returns a negative error code or zero.
+ * @get_stats: query ULP DDP statistics.
+ */
+struct ulp_ddp_dev_ops {
+	int (*limits)(struct net_device *netdev,
+		      struct ulp_ddp_limits *limits);
+	int (*sk_add)(struct net_device *netdev,
+		      struct sock *sk,
+		      struct ulp_ddp_config *config);
+	void (*sk_del)(struct net_device *netdev,
+		       struct sock *sk);
+	int (*setup)(struct net_device *netdev,
+		     struct sock *sk,
+		     struct ulp_ddp_io *io);
+	void (*teardown)(struct net_device *netdev,
+			 struct sock *sk,
+			 struct ulp_ddp_io *io,
+			 void *ddp_ctx);
+	void (*resync)(struct net_device *netdev,
+		       struct sock *sk, u32 seq);
+	int (*set_caps)(struct net_device *dev, unsigned long *bits);
+	int (*get_stats)(struct net_device *dev,
+			 struct ethtool_ulp_ddp_stats *stats);
+};
+
+#define ULP_DDP_RESYNC_PENDING BIT(0)
+
+/**
+ * struct ulp_ddp_ulp_ops - Interface to register upper layer
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
+ * struct ulp_ddp_ctx - Generic ulp ddp context
+ *
+ * @type:	type of this context struct
+ * @buf:	protocol-specific context struct
+ */
+struct ulp_ddp_ctx {
+	enum ulp_ddp_type	type;
+	unsigned char		buf[];
+};
+
+static inline struct ulp_ddp_ctx *ulp_ddp_get_ctx(const struct sock *sk)
+{
+#ifdef CONFIG_ULP_DDP
+	struct inet_connection_sock *icsk = inet_csk(sk);
+
+	return (__force struct ulp_ddp_ctx *)icsk->icsk_ulp_ddp_data;
+#else
+	return NULL;
+#endif
+}
+
+static inline void ulp_ddp_set_ctx(struct sock *sk, void *ctx)
+{
+#ifdef CONFIG_ULP_DDP
+	struct inet_connection_sock *icsk = inet_csk(sk);
+
+	rcu_assign_pointer(icsk->icsk_ulp_ddp_data, ctx);
+#endif
+}
+
+#endif	/* _ULP_DDP_H */
diff --git a/include/net/ulp_ddp_caps.h b/include/net/ulp_ddp_caps.h
new file mode 100644
index 000000000000..8ee964a4df78
--- /dev/null
+++ b/include/net/ulp_ddp_caps.h
@@ -0,0 +1,35 @@
+/* SPDX-License-Identifier: GPL-2.0
+ *
+ * ulp_ddp.h
+ *	Author:	Aurelien Aptel <aaptel@nvidia.com>
+ *	Copyright (c) 2023, NVIDIA CORPORATION & AFFILIATES.  All rights reserved.
+ */
+#ifndef _ULP_DDP_CAPS_H
+#define _ULP_DDP_CAPS_H
+
+#include <linux/types.h>
+
+enum {
+	ULP_DDP_C_NVME_TCP_BIT,
+	ULP_DDP_C_NVME_TCP_DDGST_RX_BIT,
+
+	/* add capabilities above */
+	ULP_DDP_C_COUNT,
+};
+
+struct ulp_ddp_netdev_caps {
+	DECLARE_BITMAP(active, ULP_DDP_C_COUNT);
+	DECLARE_BITMAP(hw, ULP_DDP_C_COUNT);
+};
+
+static inline bool ulp_ddp_cap_turned_on(unsigned long *old, unsigned long *new, int bit_nr)
+{
+	return !test_bit(bit_nr, old) && test_bit(bit_nr, new);
+}
+
+static inline bool ulp_ddp_cap_turned_off(unsigned long *old, unsigned long *new, int bit_nr)
+{
+	return test_bit(bit_nr, old) && !test_bit(bit_nr, new);
+}
+
+#endif
diff --git a/net/Kconfig b/net/Kconfig
index 48c33c222199..3c59eba4a438 100644
--- a/net/Kconfig
+++ b/net/Kconfig
@@ -471,4 +471,24 @@ config NETDEV_ADDR_LIST_TEST
 	default KUNIT_ALL_TESTS
 	depends on KUNIT
 
+config ULP_DDP
+	bool "ULP direct data placement offload"
+	help
+	  This feature provides a generic infrastructure for Direct
+	  Data Placement (DDP) offload for Upper Layer Protocols (ULP,
+	  such as NVMe-TCP).
+
+	  If the ULP and NIC driver supports it, the ULP code can
+	  request the NIC to place ULP response data directly
+	  into application memory, avoiding a costly copy.
+
+	  This infrastructure also allows for offloading the ULP data
+	  integrity checks (e.g. data digest) that would otherwise
+	  require another costly pass on the data we managed to avoid
+	  copying.
+
+	  For more information, see
+	  <file:Documentation/networking/ulp-ddp-offload.rst>.
+
+
 endif   # if NET
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 180df58e85c7..a3d2104c93b7 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -72,6 +72,7 @@
 #include <net/mptcp.h>
 #include <net/mctp.h>
 #include <net/page_pool.h>
+#include <net/ulp_ddp.h>
 
 #include <linux/uaccess.h>
 #include <trace/events/skb.h>
@@ -6520,7 +6521,7 @@ void skb_condense(struct sk_buff *skb)
 {
 	if (skb->data_len) {
 		if (skb->data_len > skb->end - skb->tail ||
-		    skb_cloned(skb))
+		    skb_cloned(skb) || skb_is_ulp_ddp(skb))
 			return;
 
 		/* Nice, we can free page frag(s) right now */
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index cc072d2cfcd8..4a7edad5b2b7 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -4671,7 +4671,10 @@ static bool tcp_try_coalesce(struct sock *sk,
 	if (from->decrypted != to->decrypted)
 		return false;
 #endif
-
+#ifdef CONFIG_ULP_DDP
+	if (skb_is_ulp_crc(from) != skb_is_ulp_crc(to))
+		return false;
+#endif
 	if (!skb_try_coalesce(to, from, fragstolen, &delta))
 		return false;
 
@@ -5234,6 +5237,10 @@ tcp_collapse(struct sock *sk, struct sk_buff_head *list, struct rb_root *root,
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
@@ -5267,6 +5274,10 @@ tcp_collapse(struct sock *sk, struct sk_buff_head *list, struct rb_root *root,
 #ifdef CONFIG_TLS_DEVICE
 				if (skb->decrypted != nskb->decrypted)
 					goto end;
+#endif
+#ifdef CONFIG_ULP_DDP
+				if (skb_is_ulp_crc(skb) != skb_is_ulp_crc(nskb))
+					goto end;
 #endif
 			}
 		}
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 8320d0ecb13a..8c5e1e2e2809 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -1861,6 +1861,9 @@ bool tcp_add_backlog(struct sock *sk, struct sk_buff *skb,
 	      TCP_SKB_CB(skb)->tcp_flags) & (TCPHDR_ECE | TCPHDR_CWR)) ||
 #ifdef CONFIG_TLS_DEVICE
 	    tail->decrypted != skb->decrypted ||
+#endif
+#ifdef CONFIG_ULP_DDP
+	    skb_is_ulp_crc(tail) != skb_is_ulp_crc(skb) ||
 #endif
 	    thtail->doff != th->doff ||
 	    memcmp(thtail + 1, th + 1, hdrlen - sizeof(*th)))
diff --git a/net/ipv4/tcp_offload.c b/net/ipv4/tcp_offload.c
index 45dda7889387..2e62f18e85c0 100644
--- a/net/ipv4/tcp_offload.c
+++ b/net/ipv4/tcp_offload.c
@@ -268,6 +268,9 @@ struct sk_buff *tcp_gro_receive(struct list_head *head, struct sk_buff *skb)
 #ifdef CONFIG_TLS_DEVICE
 	flush |= p->decrypted ^ skb->decrypted;
 #endif
+#ifdef CONFIG_ULP_DDP
+	flush |= skb_is_ulp_crc(p) ^ skb_is_ulp_crc(skb);
+#endif
 
 	if (flush || skb_gro_receive(p, skb)) {
 		mss = 1;
-- 
2.31.1

