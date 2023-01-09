Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C891E662716
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 14:31:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234946AbjAINbs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 08:31:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234878AbjAINbj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 08:31:39 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2048.outbound.protection.outlook.com [40.107.94.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3093513D14
        for <netdev@vger.kernel.org>; Mon,  9 Jan 2023 05:31:38 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hiBc2itVgd/rTfCv9oM5W+SryhbTHMArpc2QhrMBNFyIsKirFHqtiyCoI45/jIYW7w7l1icecPtFXsSt3Ku37Lb1klOba8F9j8FFhOfF2Xr5aUXYvpndI+qQEdOB3jK2ZjQe2zHrYynJY4nqleVTUirlsmESAze+k6PXICT2fJcVjAVbFkQc8gVOTyJTi9AINQrG72Gwc9LHQ44kKqVaLNX6V91caVr+P7XLt/H7yXJ0l3DNngFXw3qOGBbJQAxOurstkj8+YErENNv6Br1d7L6VQcPkx2AaczMvM6KePzKYey9NcBRum3zLAFwCi/PL214XgsjiyoNQEE/6vNipiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2cJzTLAcYAv18TubcpqRIKLMTOyL+3PupQgDg1msi9M=;
 b=QwxlinQCwQKJB+YV8vkAQNdHHCDXDetckX7mRYlS++F3O+sQxo/0hZxM4wwLFQtTFjcjDzFk6bgnylQGioVK/spOJoNAjlxmHaK0RVTMj+nIx5MCeuBUjqa9R2GjY0J17e3E+DbUqoWZKSn2MMsQiaQIXDb07hf82OGnpQPMt/2rGGj32iCaS/oVl/rRQHqzXgjg9nB6c8N7vibMLJ86UaR0czziyGyqw7FdmQu7iEGLpeD723R0RrscepEzJTiR/7v/7fkt2lGrXRlatZ6X1gk9J4C/fql8kPPjXlJS6ad+iFbh5Qx4j/OxqDIgRQ5R/kxbzsM1Q7Du5vk6nr7jGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2cJzTLAcYAv18TubcpqRIKLMTOyL+3PupQgDg1msi9M=;
 b=UX2RHZhsf2MstMhD70dnv1U0Ayp8fPZ4kIAIxhN/HNkj7pk/AfaCvw/aaJ90MDJIcxwjsjnvt84Ld+ZXDPOjCbaLOxSkoJ8ANeYRanngP1BHkHffa1Wn9s4OrYALoJZzsWD0J6/5zYH+aSsO50zAbPLld7fszaa45j5eleC9+tMocKKcJxFwW2ZXVQpNHePUBGFlTX03Ni3ZaX4nvAQGw/XvYbUR5QObK2xHMAmaDflZKdOLNRPQjWvMDjuqmn+5Cn8Y+zmyxx8H/cqSnCHv0Em0SsbBgJX6TvKNgaImlQ6H9X6mIbExNsMP4Kb9FrvBs8QzlUn+UHDdlchaiVzMgg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com (2603:10b6:a03:45e::8)
 by PH7PR12MB7307.namprd12.prod.outlook.com (2603:10b6:510:20b::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Mon, 9 Jan
 2023 13:31:36 +0000
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::6d66:a4bb:4018:3c70]) by SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::6d66:a4bb:4018:3c70%6]) with mapi id 15.20.5986.018; Mon, 9 Jan 2023
 13:31:36 +0000
From:   Aurelien Aptel <aaptel@nvidia.com>
To:     linux-nvme@lists.infradead.org, netdev@vger.kernel.org,
        sagi@grimberg.me, hch@lst.de, kbusch@kernel.org, axboe@fb.com,
        chaitanyak@nvidia.com, davem@davemloft.net, kuba@kernel.org
Cc:     Boris Pismenny <borisp@nvidia.com>,
        Aurelien Aptel <aaptel@nvidia.com>, aurelien.aptel@gmail.com,
        smalin@nvidia.com, malin1024@gmail.com, ogerlitz@nvidia.com,
        yorayz@nvidia.com
Subject: [PATCH v8 01/25] net: Introduce direct data placement tcp offload
Date:   Mon,  9 Jan 2023 15:30:52 +0200
Message-Id: <20230109133116.20801-2-aaptel@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230109133116.20801-1-aaptel@nvidia.com>
References: <20230109133116.20801-1-aaptel@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P302CA0045.GBRP302.PROD.OUTLOOK.COM
 (2603:10a6:600:317::20) To SJ1PR12MB6075.namprd12.prod.outlook.com
 (2603:10b6:a03:45e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR12MB6075:EE_|PH7PR12MB7307:EE_
X-MS-Office365-Filtering-Correlation-Id: 5d006dd0-b1ae-4f37-4ff0-08daf245d4af
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0e6JzlWbAqi/dm7vPcBBSQaZizMpW1n65FTjQODousFEum1GlHABW3BE3CQnrMfjGwNLCfKWcszHwqdNfV10nTKiGoOu56OONODm4eYlo01V8uCokET/NkqpWOXCwQ/v6DLobTr8SRYXDLCDaF4dwfnsk5TxCy/slJ5V8mQDY9g5QADH3zFTgd9sEfK39kuGPrP9Yb8i4dSvxKKeJfAmJ0YY+Iuj7Lam2kIwoHa3u2iy+/6LOHLU29wqejLMM67LZVm9E6wotUxdmSbSdh9Kyz6qa+/NJu49xZlSb3bSx3xC8FnOCes7s7I8Wn2D7+eYq/jp/CoOhWuxVYoEQyTW5mvofDmPnsyAXfKFw0HChjj1HJKA3mJbibg0IhfHER+109aeOpHu6t+759iFtMrft+e8ngORdIrN0DNC2kPLkpyNlpTl8yNsK22RSV8lR0T1bYfsNIBmDIGGQ11fShgNqsWgZg0FdSS4x9rtzZUGlwvg79gtTNTxBZgmycxsPa1/vjFc6ba2kyPWkJs/srx8N5yJLF7UuonWQAi49NeqXcGSlQD7OM5d0glBDrMbvYbV8iKyXbmyHTsw7VE9gW5Gb+Z3pPFJyTnIjwmXa/HM+b9NFwVbZ5rOgjtiVGSxmQxxqGTw6myQKsUQkQb8+kX27Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR12MB6075.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(39860400002)(366004)(376002)(396003)(346002)(451199015)(4326008)(6506007)(38100700002)(107886003)(6666004)(8936002)(54906003)(66556008)(5660300002)(30864003)(86362001)(2616005)(478600001)(26005)(6512007)(41300700001)(6486002)(186003)(36756003)(7416002)(316002)(66476007)(83380400001)(2906002)(1076003)(66946007)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?YLXX6/EIo60Z/w6nJd3PIPZD06DH9epkvlT4f+eYkzjYeI0y7Ph+RCvmjPV+?=
 =?us-ascii?Q?1sWnYos87WhFicwm003kV1o9kxfcYM35ew2AmBUt8kmoK19CE95y7h0EEnYN?=
 =?us-ascii?Q?52JvAAdEdDppw45hjyX8ypK1WW8G/7XwdldpdTHRJvL4AQ4how6L1aXKxhXx?=
 =?us-ascii?Q?PdfZd/2GapB4y6ijFP3WEbK70jt6i8CGrl585Kun53gyr0dU79mc5qfaiKKw?=
 =?us-ascii?Q?QenkPPE+a6tErGS506BxsjlaJo6K39gpx9OnydDrmW4B4U9/VH6Q4Q8duAJE?=
 =?us-ascii?Q?c/kLuvh61Sgr3rYd4aaNqK8sCePtNbQ0hEfgE9aP13tZVeoJjIng+0Kb9Rso?=
 =?us-ascii?Q?0OYujZVNWpAYFZYa8Xk+UkepwBZtezh0l6Km7X2PgRgBHaBuPhoQldWs7+B/?=
 =?us-ascii?Q?Uf4RU/X295j8Sg6RwyO2c/YD4WZtWoelYmEa+YT9Y2QkVsDu7MdDYRJsXjDC?=
 =?us-ascii?Q?rgTglh+9cJbS27uNmOI7OZBhebIDq4bICqHYMa/hREULAonAucjHQG+c2Plp?=
 =?us-ascii?Q?9BIzCWFwG+Ypv4X1umxtrjuYNQr8Z79rxLBGsR5Pva0kxbaDqdkvGYW46pmJ?=
 =?us-ascii?Q?UOFRIWp3X5roOZWrX0R/ucB6c2ZLa+MjUp+g402McstU9un7rw2uS4ZO8Pzt?=
 =?us-ascii?Q?AaWgPqrlRs1ob5to2JpMo6V3Ex+ZggZy/rvTJvoiqz9/T462Pjfj4MP3qQDF?=
 =?us-ascii?Q?EUV+XWMuiz8T/YdrCW705ZA8meEKB86/+uzdxU5meNTmviHWusVPpJi3pMPr?=
 =?us-ascii?Q?eBMEITLuylLWxjF5JhNp+1u6yiEv1ytJC3zeGneHWkwd5crFAANKwW8j81Cf?=
 =?us-ascii?Q?TfmyWZxevGU6HWRePk4QLgVpTh9pgtegnJ6CfWQknj0BdppkJOsihDcSwcko?=
 =?us-ascii?Q?FKjOcmHyvCVOWYV3x1M6vgDLTOeCLRy35tE32NfadxhnPs4HUEhK02SH1KjQ?=
 =?us-ascii?Q?HYviFfQoc6afOxfvgSnW2AmBHlq0d24jJ1CLFPgaFVNgU1xT2FM9RF2oEXmW?=
 =?us-ascii?Q?X6m/vO5DmYE+09AqJBeQDo0UxKxr/wyaIICdSMTiOALXT6nbmQp0SDgHHS/e?=
 =?us-ascii?Q?H7JFNT/UGi52r6aRZ9TVNFQOkmIp0XkdSVJJk6V+bDMUqtd1QrxcO5Xzslx4?=
 =?us-ascii?Q?PVVvHjWuNbr1T1poGRxXZvzG1i8R0LfRVWZa+vuyU51UjDRiz4h8yTF+1762?=
 =?us-ascii?Q?39ummHOcndagMM7enR5gVjvS6DJNLD66ErlTegThk8UU0/D3rMwFfY9MU7AC?=
 =?us-ascii?Q?cmC+uNOzYxLrKfmU2/ASme9BUFxUPhFVCRRppjGIhqEAL4Cp/NAW+LVF9LzU?=
 =?us-ascii?Q?IAOFq7PXocbFRYB5QZ/5kbTm4eZ9AoiwBpSkvyaEFLnUtvoCO1MQ67EUo/qn?=
 =?us-ascii?Q?2+Nue1bmgw+dM4JW8FsDSzccvLFSq94EA6ZSknRJX5nQsGR/5a6nM3m4VPki?=
 =?us-ascii?Q?ufGcNISCSNSuFlRPHsIFq60O5EplDS1mQvi0C58MOczfJ59HLMGWWF8LxX6L?=
 =?us-ascii?Q?yNgXN8iXKqwMi+K2SBWjiYz8uU2VxJ3TQ2o2NwIaXYZCAj/DwP7sBCWpVxoX?=
 =?us-ascii?Q?6aEgwbGSVf0G59jwSmxCQdeZ2HbrsH7PJ42B7nYD?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d006dd0-b1ae-4f37-4ff0-08daf245d4af
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR12MB6075.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jan 2023 13:31:36.4551
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: p+WXRr/HE0k9uiFXvJZZMymba4NVXKgMQKs+EYMP/T0jWhATfsWETIwqncnmqWn+hn0le39c8WFAhST6MAG1Zw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7307
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
 include/linux/netdevice.h          |  12 ++
 include/linux/skbuff.h             |  24 ++++
 include/net/inet_connection_sock.h |   4 +
 include/net/ulp_ddp.h              | 173 +++++++++++++++++++++++++++++
 include/net/ulp_ddp_caps.h         |  41 +++++++
 net/Kconfig                        |  20 ++++
 net/core/skbuff.c                  |   3 +-
 net/ipv4/tcp_input.c               |   8 ++
 net/ipv4/tcp_ipv4.c                |   3 +
 net/ipv4/tcp_offload.c             |   3 +
 10 files changed, 290 insertions(+), 1 deletion(-)
 create mode 100644 include/net/ulp_ddp.h
 create mode 100644 include/net/ulp_ddp_caps.h

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index aad12a179e54..bd270c4bbf97 100644
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
@@ -2071,6 +2080,9 @@ struct net_device {
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
index 000000000000..d3e0180462a5
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
+	void (*ulp_ddp_teardown)(struct net_device *netdev,
+				 struct sock *sk,
+				 struct ulp_ddp_io *io,
+				 void *ddp_ctx);
+	void (*ulp_ddp_resync)(struct net_device *netdev,
+			       struct sock *sk, u32 seq);
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
index 3a10387f9434..4b77f7c4687f 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -72,6 +72,7 @@
 #include <net/mptcp.h>
 #include <net/mctp.h>
 #include <net/page_pool.h>
+#include <net/ulp_ddp.h>
 
 #include <linux/uaccess.h>
 #include <trace/events/skb.h>
@@ -6476,7 +6477,7 @@ void skb_condense(struct sk_buff *skb)
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

