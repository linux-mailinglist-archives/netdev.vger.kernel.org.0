Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0B4E66E25A
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 16:36:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233489AbjAQPgs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 10:36:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232686AbjAQPg1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 10:36:27 -0500
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2080.outbound.protection.outlook.com [40.107.102.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6329C234FB
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 07:36:06 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D8vINgkbym1ofhJaGjYcRsXETz17t/7iJup3v+l4UymbeubiaMLGXXONsTlB1cLsnpic5qYv3xBL8tSePicBJ4rhydgvf0x8wpRRR/HX75InLmegOt5zf8+L33TRVg/E5tBihrEQIOUAXWD1jlKZ9MTyLBk58MQWZOjSYG9jzAgxf9l4tZxZPLTY/eH68RDgQeOGtbOBD4295g4KkmBTQVB6g2fVxGMB+HAOy/SwPI9j0fOYvDF+dAkLN/Xq5DvEd751m2FNMSHgc9xhPtQRAgGhmewv8yDP5m06JsMSF6krjIWgVrAFhEzoShEqcWK/9kiBzIytfjGVk5LOEpkk5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SxyITcFiDN5tnx8eQUB17e0hPvw8kMBk5UhlxJsEnPM=;
 b=Kt2bL1i2XFpaLv8m4erSZ5Rds6feZTgHFmQx+vpX3kixTd7WZh0W4eSdQdXn1W763lsCtTa4FhvRSXItkwQntSO7Lh26+tbMZt3z7LTt8P0p9hhkFm2lvMtQy/vDeijdfZ4ODQHhmbPEM95iUUy2JafHNRMhX3dncADeAlw+T345FUotaTI/3AaIIBoRPx/FIBasAZ4JBNK1kLMO02aU83Ihts2790Wh1w7UYncbHoiEFL2fGbiOtheC5VIg1IIk/T+nnHtcfbu0fPyfT9bACguJ8Lne+gHVLcbI5kKaVRsqlfXd3ClzVnM/SnMNQtlCYX0kTmKGOxPwa//C23+qsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SxyITcFiDN5tnx8eQUB17e0hPvw8kMBk5UhlxJsEnPM=;
 b=FUaYOkQ7hLZizLU1e0JSJEdFfevwGb3aJpome5n1XU6d6iEj/6kGu4nt5YHom6ThxiNfR+Ao8eOv0/JKafBXhNNVxLxgrjNZN+DPqu8w5xQgPew/uxumDqn8bLlv4vKlHDlo2Y/ru9tbbbyxU1VLZe2vtRPMqLuvmzWTahI9JzNBZh+VEy/u5RXaRU+5775q2Kfw/GoPCHduTkSwliNTR4z02uPuTWJ7ARP/F1thVCGSUg+rjwSo5jqJC9OqOtsde28i1goRg67vWB6iirUWvRpibPfpkoKHzTg0lfy3EJRBYOfwQ1NGz4Zyj2SE2yYoZdaRpu5J0LqhgbD5EqFH+g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com (2603:10b6:a03:45e::8)
 by BL3PR12MB6425.namprd12.prod.outlook.com (2603:10b6:208:3b4::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.13; Tue, 17 Jan
 2023 15:36:03 +0000
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::6d66:a4bb:4018:3c70]) by SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::6d66:a4bb:4018:3c70%8]) with mapi id 15.20.6002.013; Tue, 17 Jan 2023
 15:36:03 +0000
From:   Aurelien Aptel <aaptel@nvidia.com>
To:     linux-nvme@lists.infradead.org, netdev@vger.kernel.org,
        sagi@grimberg.me, hch@lst.de, kbusch@kernel.org, axboe@fb.com,
        chaitanyak@nvidia.com, davem@davemloft.net, kuba@kernel.org
Cc:     Boris Pismenny <borisp@nvidia.com>,
        Aurelien Aptel <aaptel@nvidia.com>, aurelien.aptel@gmail.com,
        smalin@nvidia.com, malin1024@gmail.com, ogerlitz@nvidia.com,
        yorayz@nvidia.com
Subject: [PATCH v9 01/25] net: Introduce direct data placement tcp offload
Date:   Tue, 17 Jan 2023 17:35:11 +0200
Message-Id: <20230117153535.1945554-2-aaptel@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230117153535.1945554-1-aaptel@nvidia.com>
References: <20230117153535.1945554-1-aaptel@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P265CA0156.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2c7::18) To SJ1PR12MB6075.namprd12.prod.outlook.com
 (2603:10b6:a03:45e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR12MB6075:EE_|BL3PR12MB6425:EE_
X-MS-Office365-Filtering-Correlation-Id: bdb533aa-3b35-4c78-33de-08daf8a08aae
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: H1lM6SsaY+/xrhVXlI4QCWOXNIGiqm3LVc8EntqtMrbNtIuC0eQhuVcvp/0mIXHyDqBIKQzgg6Whi/CYc6/IVVOzBx5mBiiptnV7IFpTkjXOWVD59Ogk4MV1unxLOfF2xqtVglOLzuthRmcuQXGKlMZkgy5TBASm1lWMhEPJ9yjnY5v3bE9amZiCFBgQ3ExCKZaugAClAZw03BWWq65DfGGKbbQMci7RGNmi7JwSAhBY+lmQXLaalVrJrhI7Lei27ndiPXL7ZtwqlGpnEmNFo6crLO0OCXao5EUYNt/FF4EywYkoVxmUGJE3nGQkjs92MBQl/uzndRJ0o4BGi5gqqvHdq7gBwTsmbt6qgbXXS5W/IR9SJeA9+6WaD49gO7LXP82z2mtWgRcoW+h0mMC9EVEt2nyufJ6f5JKyEdjLPouYdR+4eRcoQTrQMhkx/8AMwW8Uj498lH6t9Hwz477JkVLoMAgFRoeb9+2qQPjUIbTEUyAXFCFdqjTpkye1hT8+LlQS2RnoQlYMOzjynkIEdzI6dDF2H3NzxGAOoyGzk9871HX+9oH9ssK61B6OqtR2WEXwNC11mRX+7ZIMOx5zU71FLI4hSKC3KSQ8/dlRGqdugJUr1uNWWI7z/+soBcyBpNIY94Q/bv8plo3KhVHP3A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR12MB6075.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(396003)(136003)(346002)(366004)(39860400002)(451199015)(30864003)(6512007)(6506007)(107886003)(6666004)(26005)(36756003)(6486002)(38100700002)(186003)(86362001)(2616005)(83380400001)(478600001)(1076003)(8936002)(7416002)(5660300002)(8676002)(2906002)(66946007)(316002)(4326008)(66476007)(66556008)(54906003)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?C5Iy8MS2qca28TDVokYEUrTr+keq+IFQDKCabZimneycY4/CAr2VwxMwiCMR?=
 =?us-ascii?Q?K9skofNnVshKQBo1WJJlnJBXsZM5A7+wFh7W0HExsTq2P53KBRY4bF3P1uQO?=
 =?us-ascii?Q?O1jNfGS9b489h3ECvL+HKurR4Rk/901Uk5uZ7WfVpMfdCDFQ9GaSo3/lVS0H?=
 =?us-ascii?Q?CpvsDMjhVfdvFO14pGUqmG9rA9F9HpXTFm/rbGG+ixOYuUmC0JmZOIF7jIks?=
 =?us-ascii?Q?+1j1LMKlD5ODhYEguO2+LxKNpS0AvRk3o3d8Avz8zZZr/ONOE1HJRcLEfdoZ?=
 =?us-ascii?Q?h2Ni3iQ5YCXDDl7Nq08CIzaAUqndS41f12hL/o/OAOWtlgyI36hXRneB2DXg?=
 =?us-ascii?Q?kble+Pv5o1wj22X+zI5jezwcutDeS6qmLjcDYEfK1/lCL7sUgYPZYnQEN+YC?=
 =?us-ascii?Q?GIeMrr2/iF9GkpoByy339sXiyycuoaGLFOzdO2ts6m2Pd372w7tfOxu2su6L?=
 =?us-ascii?Q?Yna38wT/sv0ZOjtrGsxZeAMLKsXQ03mw7PkJvKEQV80Rql7o2sGF0qBck9MB?=
 =?us-ascii?Q?esSpvThJJtZwMFbdYXFEghKD7YBJC/wvkBTmoTouaaE0mLlWggSbKyE5RNpg?=
 =?us-ascii?Q?m80EKKAdUPVpnbcCh0SYW8V7JEQeLxuB61Tpj2losXbKWHuYOQb6jAQJbBCf?=
 =?us-ascii?Q?AYY6v/1MqLrVe5ofFQvHQ/QXHhY4QeY8oSsFrz8RJNdPOaSdD6VSDCFvsWO6?=
 =?us-ascii?Q?BB36o7X+FH1BA/ydFj7xnQUtNGPtUlu1IjRoRkgzhVvw94xShXcF4H+rMxKc?=
 =?us-ascii?Q?tiSb3rjWqW6jtKZ0hyX5PP6NGF9Plep1TKhJ8pCofvL7JBUecuKxVa0GZz2J?=
 =?us-ascii?Q?PefXSw0HOH+p2f6zyGUmtKIJ8v6evn65yWpQK9tGCRuq9Uw1dRMOfn5UvxER?=
 =?us-ascii?Q?UXSho0VhSQOrq1W+06LUCiCxQUdDz8OAII2xACIJcoLbO4iQyjSDQnfYTqC0?=
 =?us-ascii?Q?QVb1j5djXz5IZza1ef8EH5LpxUjYUU0vCHuD70VEDYC8Op1uoa3TG9t6FWLL?=
 =?us-ascii?Q?7KkXZqQtFM1JhUNigXD8REhCMbKIbeNcE2iVpcRMrbN43h3MI5kRbFMM/s2l?=
 =?us-ascii?Q?Z8ijMF2zHAMPa6MSBk6IbuIYaWOesCN1r695U5ZwTJMaR4uH0tqme5KmDgrg?=
 =?us-ascii?Q?Xld6ckJodD+RY9DasWkNhRyIxZ2yGp1zWTurHW0rXOzC3SOQMJmuVWXiG5Xs?=
 =?us-ascii?Q?2/rCXoIhy751BqXGgXZ6XhGJKyuhbSa0KPNoqIXMQL2V3HHJ02dp0a1weC7m?=
 =?us-ascii?Q?ouZVfjA1inX/cWx6BLDm3AyicqEeVKaUGeCsGbW4G66acHid5bkBjjLRzL2V?=
 =?us-ascii?Q?89qChm7hItdVfrYAntgCi+FItn7vqKmDxi49sqSKZCRFhVVgBaKPiVVYvIEt?=
 =?us-ascii?Q?E6NaGrlsVmMbI9DJdT1nCKxGkNClMJDbPaFXZ47gaEgmDVb2HGJ8TYVCz+oQ?=
 =?us-ascii?Q?lTWc1Hgx1belmgT/79nyhhIiDUMVn3ku+KODMCNWu76yhYGtd8FWK6v/1JZT?=
 =?us-ascii?Q?P6EhO77kRHU/HRDFpYWZI3UeYHtptM77RgaPuKj2cDn6dzBlOyWqJPkcJ2Gn?=
 =?us-ascii?Q?wFO0XBnnRwRY3s44x73VS+0kZ3jIcikzoIN/CLYX?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bdb533aa-3b35-4c78-33de-08daf8a08aae
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR12MB6075.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jan 2023 15:36:03.3349
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6m1VE8X4tq+S/PLuJt5MSaBAHr3SLA2b3Rxjn/nFxX5Wsex7oQNxWKFmImARqtUWqFiKMoSxik/MOy+1aeALDA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6425
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
 include/net/inet_connection_sock.h |   4 +
 include/net/ulp_ddp.h              | 173 +++++++++++++++++++++++++++++
 include/net/ulp_ddp_caps.h         |  41 +++++++
 net/Kconfig                        |  20 ++++
 net/core/skbuff.c                  |   3 +-
 net/ipv4/tcp_input.c               |   8 ++
 net/ipv4/tcp_ipv4.c                |   3 +
 net/ipv4/tcp_offload.c             |   3 +
 10 files changed, 293 insertions(+), 1 deletion(-)
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
index 000000000000..845755ebda3e
--- /dev/null
+++ b/include/net/ulp_ddp.h
@@ -0,0 +1,173 @@
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
diff --git a/include/net/ulp_ddp_caps.h b/include/net/ulp_ddp_caps.h
new file mode 100644
index 000000000000..e16e5a694238
--- /dev/null
+++ b/include/net/ulp_ddp_caps.h
@@ -0,0 +1,41 @@
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
+#define __ULP_DDP_C_BIT(bit)	((u64)1 << (bit))
+#define __ULP_DDP_C(name)	__ULP_DDP_C_BIT(ULP_DDP_C_##name##_BIT)
+
+#define ULP_DDP_C_NVME_TCP		__ULP_DDP_C(NVME_TCP)
+#define ULP_DDP_C_NVME_TCP_DDGST_RX	__ULP_DDP_C(NVME_TCP)
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
index 4e73ab3482b8..d410dbf862f9 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -72,6 +72,7 @@
 #include <net/mptcp.h>
 #include <net/mctp.h>
 #include <net/page_pool.h>
+#include <net/ulp_ddp.h>
 
 #include <linux/uaccess.h>
 #include <trace/events/skb.h>
@@ -6522,7 +6523,7 @@ void skb_condense(struct sk_buff *skb)
 {
 	if (skb->data_len) {
 		if (skb->data_len > skb->end - skb->tail ||
-		    skb_cloned(skb))
+		    skb_cloned(skb) || skb_is_ulp_ddp(skb))
 			return;
 
 		/* Nice, we can free page frag(s) right now */
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index cc072d2cfcd8..c711614604a6 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -5234,6 +5234,10 @@ tcp_collapse(struct sock *sk, struct sk_buff_head *list, struct rb_root *root,
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
@@ -5267,6 +5271,10 @@ tcp_collapse(struct sock *sk, struct sk_buff_head *list, struct rb_root *root,
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

