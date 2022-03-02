Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9901C4CAA4C
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 17:33:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242482AbiCBQdj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 11:33:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242308AbiCBQdg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 11:33:36 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2066.outbound.protection.outlook.com [40.107.223.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B2D62B1AC
        for <netdev@vger.kernel.org>; Wed,  2 Mar 2022 08:32:34 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P25V26XmmqgCRcLEPkR4BilIpKRXAED3y4GWWcqyg0S/WF/fnqZhmgRwtvdATvxzjlCkniZdPWhzVwFK6UHq9aaBo7ZCoQEvkkULn1BhKRp9L9PrEa3aPqbJPuhAr89MET/auxSqab+PDOhRGMCu/52zQLmsr2wJDVJdzBZnxspidCYXqHueuuaAH7NeOZrFGFN3a4RJyuUNJzXC+brUnu3nwaZmg1sagLXOKdWQydhQRdHXEU0ZFq+NMXP1MJujAwkCx/Mc4EVwo0wBnnxQHCrS9HNhYlq9Uy2CIBz7+FWPcl2OGzmGWHHIkt+iG6VOHFXA8ZeWql+QJerDf14b1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kgAyiuAA5HBNrmgZfNzyawMC0iUSmKq7GZHmgWT4f80=;
 b=mlCWrD43eienweUFyos6ydimHhPFlmJki3ByY/DknVznypZB4XwVDBMidRShWcCUenX42V50ibMDYdn0WHPqFWuBiCOuuyTm4TVMDrWRRw8Eujto91A6gslv69rWPnKQnEMIWfKZZV+SBC2FefW+pAjCzk2zZptCD1Yx+aGtNQS3JfrJnUuZRVgwhdvKv7DJ4/Br5YtpmPoeQ4A72RmGwre2LOwxSn656Uf16qD1hJiUg03ybgfLuMeN6qC3T9Zn11wXx5zXFOX5afDM9v0aZxSyb8fSG4lkIG+K6E2zLj2dGgTvvPoJDvUOUVruM6xwWoHpf8/IDwleMyKYbAfvsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kgAyiuAA5HBNrmgZfNzyawMC0iUSmKq7GZHmgWT4f80=;
 b=cBQChLOvx+1EqmjjsADqapFzvhrMSpErYjlh2myzDc2mMTwhWjeT+5RiY5XGOG9QMczk3sNImu/59Uqs4xtbzoW/3IwM/qynk2YK6QRGLxQBWoYaA5vUyO3WwOIfJrki5MqPq/3VqfYzsfKGfI9Zz4FHJ3e8ZBfLtw/DWOl7Q2jrTSfsK+TZaHSLtkzB+e2JUmMihkq+XjsTk68P7ZaYuhKL70LNQ7A1AYJCIHSNqB0u2gV5bTHLbR40S6Lp7FheCIuEKaCtsvgArbWE8eC3rFpCVJJ4vjXMZm0GkFQqyZkBfBsi+H5tVNAkJJIwNcH398wz6sVyVoMP/vxCGRvAHw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4337.namprd12.prod.outlook.com (2603:10b6:5:2a9::12)
 by CY4PR12MB1942.namprd12.prod.outlook.com (2603:10b6:903:128::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.21; Wed, 2 Mar
 2022 16:32:32 +0000
Received: from DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::95a1:8c7f:10ef:2581]) by DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::95a1:8c7f:10ef:2581%6]) with mapi id 15.20.5038.014; Wed, 2 Mar 2022
 16:32:32 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, petrm@nvidia.com,
        jiri@nvidia.com, roopa@nvidia.com, razor@blackwall.org,
        dsahern@gmail.com, andrew@lunn.ch, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next v2 06/14] net: dev: Add hardware stats support
Date:   Wed,  2 Mar 2022 18:31:20 +0200
Message-Id: <20220302163128.218798-7-idosch@nvidia.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220302163128.218798-1-idosch@nvidia.com>
References: <20220302163128.218798-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0102CA0102.eurprd01.prod.exchangelabs.com
 (2603:10a6:803:15::43) To DM6PR12MB4337.namprd12.prod.outlook.com
 (2603:10b6:5:2a9::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fc0e826a-7aba-4e01-fac8-08d9fc6a3fdb
X-MS-TrafficTypeDiagnostic: CY4PR12MB1942:EE_
X-Microsoft-Antispam-PRVS: <CY4PR12MB1942E4FB9428C6783FD978DEB2039@CY4PR12MB1942.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nI95pFOWMddPIqmWuHXBFIHW1fkWayX+a/V1E91hRZ/HevGhmNy4RzysUd6HMN44GYiB/fTbTjFDn67bDY4WJCF/L7QK1v8f55hX8rVGeJxxkvOr7s9dFSatBpEBVojpCbJePJ7ZOHo0RZKX7LH8Y4GBfdd6APHTcWy4suGvwF+X5tJrLSGeVv0lMn7QJ/2YD2wm2/J+6m9tsdJvDL7G1yq95CYiL9Dkl1xye+sdyqZFGUQA72pKUOYeCv5AnFKKnYqbpVVegSvdHzzk22MFeofMeBHTKd2258M1eQ9FkCq0bPoesE4MspZvrfuReM8MWDIy34tu54cUWdqN0ANLRFlHu6qZCX0N67QjL3XlCLodr9qEFjVx7owDscuD8KzfLpSXoPy1zZy/xusCZchykx+TCwcHlV+MxOuGIkO8uqmOLeaTYWOyRL3nQYtSSQJvIswdMmpfnTRymh0SaypNidBGT6TYWw3bKkEyD8AQYmuJwLOFqRp8zqFA17te3lXhh4mvfBIDLcaxFmMOZm4xYjEMHxSL2LVFXBwt2T07iWe0xR518qr4SAcZ8pKGuoMPvuYV0GTtwfjFrW4X+MpaBY874SfAUGKYP/OUPM3oYu48J3Ylcn6LOyYwYZ0QJMEo1wqCWH+c4sJ0F6UMTVmlew==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4337.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(38100700002)(36756003)(2616005)(86362001)(26005)(186003)(1076003)(6916009)(316002)(107886003)(4326008)(66574015)(6666004)(66476007)(6506007)(66946007)(6512007)(66556008)(8676002)(6486002)(508600001)(2906002)(83380400001)(30864003)(8936002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?yXyzxgqj4iXkYvOFdAXf1QdB/QwbJ4Bg+ovJpLlpAkDQirYollfWHr6H41nV?=
 =?us-ascii?Q?jJ4VtFcHzSQAPJ8pdfAITwvzY/vm7usXAtfPx34aCmrsW9AFap7oTY4ze3KD?=
 =?us-ascii?Q?j1/FZFYlktLFAZOLq9TR/tHc9jZTKJnfQonW+j0x0My9rbwwiQX+y2IPoMWW?=
 =?us-ascii?Q?HYIZJ6obGTul98tGp/SE43DCF84AX4KFss8sSLyu9JpU8CxoN+OOY62/oW0J?=
 =?us-ascii?Q?zOwpSgdz0m1UAbHwHaFz1XzOFlFY6lqcFXk+aohA9TUq+SSmi3yrgIuKptKu?=
 =?us-ascii?Q?IG+jGag2QlvWeYOSEUD4U5Z3TB3gjp+sq35/fENBXybMCNRwtcxMzo2eZje6?=
 =?us-ascii?Q?AtgLskiTVPoQT0mZ1WYA4dxecxKfBayBJ+DxfX+hEIHJWeJZ9ValgwZmNIMz?=
 =?us-ascii?Q?cD59pvzFiw1zzX87DUiAnsS4h/zPDMv+ejlm0Lx9aXL5OssaWP/GOoWFFrbx?=
 =?us-ascii?Q?EVBAei09P8prhNHnV7RQoGE4RHa9Lv4YAsuRaMxo9Txf0GADGeJs6vvlXn1W?=
 =?us-ascii?Q?skb0iZ2CvppbZB4Bb4zv6eEmTX2Au0RZD3TtPPyHcwqFoSo4UGzjg1DGMyPI?=
 =?us-ascii?Q?UzBfl7MwqmEPOjAC/sH199jQVroU+Vb0H+ZfGGTrz/rFLYqPkjsN688O64AN?=
 =?us-ascii?Q?oWQLWk3p5JbqJs9tN8JkveIKNuZQq+fe1Z4WRshXSsVSOCAGcbnGPI37KxlG?=
 =?us-ascii?Q?XzkrpJe7vuWv1QPdINqy72oiqe5c81mX/6gJg6l6Hm8rf0yOUsmwyFOtzTyV?=
 =?us-ascii?Q?7B0P1Rj+q7PTRRNtorgGaCQr/pQQWGZfeVWO3cadiWvGvIvuWm41f+l8FU6F?=
 =?us-ascii?Q?7Ph8B5XxKCbzE9DFB0wsAipMWtPNuonl65Cwv5imUoYz3/GoVbYV1vnwRkzv?=
 =?us-ascii?Q?eLw4NGY82rp2wqMW8nbeJk7hgaRU80RCr05SkKO7Rm2ho1Ox5QUV39WorILM?=
 =?us-ascii?Q?WYzMG3bONufQym/bpgYQYFSEx/YwsW1lsveGcyFsLuP/Lgea0IwRkmHrZdeb?=
 =?us-ascii?Q?n5L/SOrOTZ47biH6lgeVcUfVD4hhluF5v/xpeBD9rh0KEEFuC13OrkVtUDg2?=
 =?us-ascii?Q?qlH55ly0TrneGOkH/UFOSlXfTS12mm3e2GjwOPjtjgx1V5LXLlkJ+KLqVi5M?=
 =?us-ascii?Q?zsQl0569jQ3meNie6iimZcILGpl4nn4WP0fnpwT0i860mFb7dxBtM8dQB9QE?=
 =?us-ascii?Q?NHxw2Gch+xxe7qQWSJyPwW3sk9lUzItrORsYmEZeOeSao6HAogohogs48r94?=
 =?us-ascii?Q?2MppUnoJdmUHgmS08bDWJZfyWmxjpyECRlTOhYq+RvAUpJe4tkfurfQK4ev9?=
 =?us-ascii?Q?ynIT1BAtd3p4dbJ8044jr7fKEoILObBgTxSQjxH1/ZCFGAkqzb/Z8TlUXElu?=
 =?us-ascii?Q?bAteB2PPq+sZwDCdAd0143Bu2Fa9rVQnJsBzhangNgloms8HRdiBJT4jCK/T?=
 =?us-ascii?Q?dhGD/me6ZpxYGgQE5slAL5iPOxwQXfl0LBcDuVr0uKlrpa4U8kRgRFkfAkre?=
 =?us-ascii?Q?PzopLzueo5xRoZWG5eMInq0ZEPiG5AOIaPwwNXZWbeKR5d14gI79m0CReo32?=
 =?us-ascii?Q?DTYOrTpBByz1fqLetwwtprslIG5pGbHo8fiYh3XpI+2b64nUV0CaKCUthgRV?=
 =?us-ascii?Q?8raH7avm5rvverRzAcUPJwM=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fc0e826a-7aba-4e01-fac8-08d9fc6a3fdb
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4337.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2022 16:32:32.1343
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xAqXcVxkMLo3xR5G+hP1amUnEfbcM+OLfVAR/lxgPQ7Hw8Pvw3GkBIZSSfgBh2wiNhIwjxuY9TF1uHf7oksuDA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1942
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@nvidia.com>

Offloading switch device drivers may be able to collect statistics of the
traffic taking place in the HW datapath that pertains to a certain soft
netdevice, such as VLAN. Add the necessary infrastructure to allow exposing
these statistics to the offloaded netdevice in question. The API was shaped
by the following considerations:

- Collection of HW statistics is not free: there may be a finite number of
  counters, and the act of counting may have a performance impact. It is
  therefore necessary to allow toggling whether HW counting should be done
  for any particular SW netdevice.

- As the drivers are loaded and removed, a particular device may get
  offloaded and unoffloaded again. At the same time, the statistics values
  need to stay monotonic (modulo the eventual 64-bit wraparound),
  increasing only to reflect traffic measured in the device.

  To that end, the netdevice keeps around a lazily-allocated copy of struct
  rtnl_link_stats64. Device drivers then contribute to the values kept
  therein at various points. Even as the driver goes away, the struct stays
  around to maintain the statistics values.

- Different HW devices may be able to count different things. The
  motivation behind this patch in particular is exposure of HW counters on
  Nvidia Spectrum switches, where the only practical approach to counting
  traffic on offloaded soft netdevices currently is to use router interface
  counters, and count L3 traffic. Correspondingly that is the statistics
  suite added in this patch.

  Other devices may be able to measure different kinds of traffic, and for
  that reason, the APIs are built to allow uniform access to different
  statistics suites.

- Because soft netdevices and offloading drivers are only loosely bound, a
  netdevice uses a notifier chain to communicate with the drivers. Several
  new notifiers, NETDEV_OFFLOAD_XSTATS_*, have been added to carry messages
  to the offloading drivers.

- Devices can have various conditions for when a particular counter is
  available. As the device is configured and reconfigured, the device
  offload may become or cease being suitable for counter binding. A
  netdevice can use a notifier type NETDEV_OFFLOAD_XSTATS_REPORT_USED to
  ping offloading drivers and determine whether anyone currently implements
  a given statistics suite. This information can then be propagated to user
  space.

  When the driver decides to unoffload a netdevice, it can use a
  newly-added function, netdev_offload_xstats_report_delta(), to record
  outstanding collected statistics, before destroying the HW counter.

This patch adds a helper, call_netdevice_notifiers_info_robust(), for
dispatching a notifier with the possibility of unwind when one of the
consumers bails. Given the wish to eventually get rid of the global
notifier block altogether, this helper only invokes the per-netns notifier
block.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 include/linux/netdevice.h    |  42 ++++++
 include/uapi/linux/if_link.h |  15 ++
 net/core/dev.c               | 267 ++++++++++++++++++++++++++++++++++-
 3 files changed, 323 insertions(+), 1 deletion(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index c79ee2296296..19a27ac361ef 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1950,6 +1950,7 @@ enum netdev_ml_priv_type {
  *	@watchdog_dev_tracker:	refcount tracker used by watchdog.
  *	@dev_registered_tracker:	tracker for reference held while
  *					registered
+ *	@offload_xstats_l3:	L3 HW stats for this netdevice.
  *
  *	FIXME: cleanup struct net_device such that network protocol info
  *	moves out.
@@ -2287,6 +2288,7 @@ struct net_device {
 	netdevice_tracker	linkwatch_dev_tracker;
 	netdevice_tracker	watchdog_dev_tracker;
 	netdevice_tracker	dev_registered_tracker;
+	struct rtnl_hw_stats64	*offload_xstats_l3;
 };
 #define to_net_dev(d) container_of(d, struct net_device, dev)
 
@@ -2727,6 +2729,10 @@ enum netdev_cmd {
 	NETDEV_CVLAN_FILTER_DROP_INFO,
 	NETDEV_SVLAN_FILTER_PUSH_INFO,
 	NETDEV_SVLAN_FILTER_DROP_INFO,
+	NETDEV_OFFLOAD_XSTATS_ENABLE,
+	NETDEV_OFFLOAD_XSTATS_DISABLE,
+	NETDEV_OFFLOAD_XSTATS_REPORT_USED,
+	NETDEV_OFFLOAD_XSTATS_REPORT_DELTA,
 };
 const char *netdev_cmd_to_name(enum netdev_cmd cmd);
 
@@ -2777,6 +2783,42 @@ struct netdev_notifier_pre_changeaddr_info {
 	const unsigned char *dev_addr;
 };
 
+enum netdev_offload_xstats_type {
+	NETDEV_OFFLOAD_XSTATS_TYPE_L3 = 1,
+};
+
+struct netdev_notifier_offload_xstats_info {
+	struct netdev_notifier_info info; /* must be first */
+	enum netdev_offload_xstats_type type;
+
+	union {
+		/* NETDEV_OFFLOAD_XSTATS_REPORT_DELTA */
+		struct netdev_notifier_offload_xstats_rd *report_delta;
+		/* NETDEV_OFFLOAD_XSTATS_REPORT_USED */
+		struct netdev_notifier_offload_xstats_ru *report_used;
+	};
+};
+
+int netdev_offload_xstats_enable(struct net_device *dev,
+				 enum netdev_offload_xstats_type type,
+				 struct netlink_ext_ack *extack);
+int netdev_offload_xstats_disable(struct net_device *dev,
+				  enum netdev_offload_xstats_type type);
+bool netdev_offload_xstats_enabled(const struct net_device *dev,
+				   enum netdev_offload_xstats_type type);
+int netdev_offload_xstats_get(struct net_device *dev,
+			      enum netdev_offload_xstats_type type,
+			      struct rtnl_hw_stats64 *stats, bool *used,
+			      struct netlink_ext_ack *extack);
+void
+netdev_offload_xstats_report_delta(struct netdev_notifier_offload_xstats_rd *rd,
+				   const struct rtnl_hw_stats64 *stats);
+void
+netdev_offload_xstats_report_used(struct netdev_notifier_offload_xstats_ru *ru);
+void netdev_offload_xstats_push_delta(struct net_device *dev,
+				      enum netdev_offload_xstats_type type,
+				      const struct rtnl_hw_stats64 *stats);
+
 static inline void netdev_notifier_info_init(struct netdev_notifier_info *info,
 					     struct net_device *dev)
 {
diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index 4d62ea6e1288..ef6a62a2e15d 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -245,6 +245,21 @@ struct rtnl_link_stats64 {
 	__u64	rx_nohandler;
 };
 
+/* Subset of link stats useful for in-HW collection. Meaning of the fields is as
+ * for struct rtnl_link_stats64.
+ */
+struct rtnl_hw_stats64 {
+	__u64	rx_packets;
+	__u64	tx_packets;
+	__u64	rx_bytes;
+	__u64	tx_bytes;
+	__u64	rx_errors;
+	__u64	tx_errors;
+	__u64	rx_dropped;
+	__u64	tx_dropped;
+	__u64	multicast;
+};
+
 /* The struct should be in sync with struct ifmap */
 struct rtnl_link_ifmap {
 	__u64	mem_start;
diff --git a/net/core/dev.c b/net/core/dev.c
index 2d6771075720..c9e54e5ad48d 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -1622,7 +1622,8 @@ const char *netdev_cmd_to_name(enum netdev_cmd cmd)
 	N(UDP_TUNNEL_DROP_INFO) N(CHANGE_TX_QUEUE_LEN)
 	N(CVLAN_FILTER_PUSH_INFO) N(CVLAN_FILTER_DROP_INFO)
 	N(SVLAN_FILTER_PUSH_INFO) N(SVLAN_FILTER_DROP_INFO)
-	N(PRE_CHANGEADDR)
+	N(PRE_CHANGEADDR) N(OFFLOAD_XSTATS_ENABLE) N(OFFLOAD_XSTATS_DISABLE)
+	N(OFFLOAD_XSTATS_REPORT_USED) N(OFFLOAD_XSTATS_REPORT_DELTA)
 	}
 #undef N
 	return "UNKNOWN_NETDEV_EVENT";
@@ -1939,6 +1940,32 @@ static int call_netdevice_notifiers_info(unsigned long val,
 	return raw_notifier_call_chain(&netdev_chain, val, info);
 }
 
+/**
+ *	call_netdevice_notifiers_info_robust - call per-netns notifier blocks
+ *	                                       for and rollback on error
+ *	@val_up: value passed unmodified to notifier function
+ *	@val_down: value passed unmodified to the notifier function when
+ *	           recovering from an error on @val_up
+ *	@info: notifier information data
+ *
+ *	Call all per-netns network notifier blocks, but not notifier blocks on
+ *	the global notifier chain. Parameters and return value are as for
+ *	raw_notifier_call_chain_robust().
+ */
+
+static int
+call_netdevice_notifiers_info_robust(unsigned long val_up,
+				     unsigned long val_down,
+				     struct netdev_notifier_info *info)
+{
+	struct net *net = dev_net(info->dev);
+
+	ASSERT_RTNL();
+
+	return raw_notifier_call_chain_robust(&net->netdev_chain,
+					      val_up, val_down, info);
+}
+
 static int call_netdevice_notifiers_extack(unsigned long val,
 					   struct net_device *dev,
 					   struct netlink_ext_ack *extack)
@@ -7728,6 +7755,242 @@ void netdev_bonding_info_change(struct net_device *dev,
 }
 EXPORT_SYMBOL(netdev_bonding_info_change);
 
+static int netdev_offload_xstats_enable_l3(struct net_device *dev,
+					   struct netlink_ext_ack *extack)
+{
+	struct netdev_notifier_offload_xstats_info info = {
+		.info.dev = dev,
+		.info.extack = extack,
+		.type = NETDEV_OFFLOAD_XSTATS_TYPE_L3,
+	};
+	int err;
+	int rc;
+
+	dev->offload_xstats_l3 = kzalloc(sizeof(*dev->offload_xstats_l3),
+					 GFP_KERNEL);
+	if (!dev->offload_xstats_l3)
+		return -ENOMEM;
+
+	rc = call_netdevice_notifiers_info_robust(NETDEV_OFFLOAD_XSTATS_ENABLE,
+						  NETDEV_OFFLOAD_XSTATS_DISABLE,
+						  &info.info);
+	err = notifier_to_errno(rc);
+	if (err)
+		goto free_stats;
+
+	return 0;
+
+free_stats:
+	kfree(dev->offload_xstats_l3);
+	dev->offload_xstats_l3 = NULL;
+	return err;
+}
+
+int netdev_offload_xstats_enable(struct net_device *dev,
+				 enum netdev_offload_xstats_type type,
+				 struct netlink_ext_ack *extack)
+{
+	ASSERT_RTNL();
+
+	if (netdev_offload_xstats_enabled(dev, type))
+		return -EALREADY;
+
+	switch (type) {
+	case NETDEV_OFFLOAD_XSTATS_TYPE_L3:
+		return netdev_offload_xstats_enable_l3(dev, extack);
+	}
+
+	WARN_ON(1);
+	return -EINVAL;
+}
+EXPORT_SYMBOL(netdev_offload_xstats_enable);
+
+static void netdev_offload_xstats_disable_l3(struct net_device *dev)
+{
+	struct netdev_notifier_offload_xstats_info info = {
+		.info.dev = dev,
+		.type = NETDEV_OFFLOAD_XSTATS_TYPE_L3,
+	};
+
+	call_netdevice_notifiers_info(NETDEV_OFFLOAD_XSTATS_DISABLE,
+				      &info.info);
+	kfree(dev->offload_xstats_l3);
+	dev->offload_xstats_l3 = NULL;
+}
+
+int netdev_offload_xstats_disable(struct net_device *dev,
+				  enum netdev_offload_xstats_type type)
+{
+	ASSERT_RTNL();
+
+	if (!netdev_offload_xstats_enabled(dev, type))
+		return -EALREADY;
+
+	switch (type) {
+	case NETDEV_OFFLOAD_XSTATS_TYPE_L3:
+		netdev_offload_xstats_disable_l3(dev);
+		return 0;
+	}
+
+	WARN_ON(1);
+	return -EINVAL;
+}
+EXPORT_SYMBOL(netdev_offload_xstats_disable);
+
+static void netdev_offload_xstats_disable_all(struct net_device *dev)
+{
+	netdev_offload_xstats_disable(dev, NETDEV_OFFLOAD_XSTATS_TYPE_L3);
+}
+
+static struct rtnl_hw_stats64 *
+netdev_offload_xstats_get_ptr(const struct net_device *dev,
+			      enum netdev_offload_xstats_type type)
+{
+	switch (type) {
+	case NETDEV_OFFLOAD_XSTATS_TYPE_L3:
+		return dev->offload_xstats_l3;
+	}
+
+	WARN_ON(1);
+	return NULL;
+}
+
+bool netdev_offload_xstats_enabled(const struct net_device *dev,
+				   enum netdev_offload_xstats_type type)
+{
+	ASSERT_RTNL();
+
+	return netdev_offload_xstats_get_ptr(dev, type);
+}
+EXPORT_SYMBOL(netdev_offload_xstats_enabled);
+
+struct netdev_notifier_offload_xstats_ru {
+	bool used;
+};
+
+struct netdev_notifier_offload_xstats_rd {
+	struct rtnl_hw_stats64 stats;
+	bool used;
+};
+
+static void netdev_hw_stats64_add(struct rtnl_hw_stats64 *dest,
+				  const struct rtnl_hw_stats64 *src)
+{
+	dest->rx_packets	  += src->rx_packets;
+	dest->tx_packets	  += src->tx_packets;
+	dest->rx_bytes		  += src->rx_bytes;
+	dest->tx_bytes		  += src->tx_bytes;
+	dest->rx_errors		  += src->rx_errors;
+	dest->tx_errors		  += src->tx_errors;
+	dest->rx_dropped	  += src->rx_dropped;
+	dest->tx_dropped	  += src->tx_dropped;
+	dest->multicast		  += src->multicast;
+}
+
+static int netdev_offload_xstats_get_used(struct net_device *dev,
+					  enum netdev_offload_xstats_type type,
+					  bool *p_used,
+					  struct netlink_ext_ack *extack)
+{
+	struct netdev_notifier_offload_xstats_ru report_used = {};
+	struct netdev_notifier_offload_xstats_info info = {
+		.info.dev = dev,
+		.info.extack = extack,
+		.type = type,
+		.report_used = &report_used,
+	};
+	int rc;
+
+	WARN_ON(!netdev_offload_xstats_enabled(dev, type));
+	rc = call_netdevice_notifiers_info(NETDEV_OFFLOAD_XSTATS_REPORT_USED,
+					   &info.info);
+	*p_used = report_used.used;
+	return notifier_to_errno(rc);
+}
+
+static int netdev_offload_xstats_get_stats(struct net_device *dev,
+					   enum netdev_offload_xstats_type type,
+					   struct rtnl_hw_stats64 *p_stats,
+					   bool *p_used,
+					   struct netlink_ext_ack *extack)
+{
+	struct netdev_notifier_offload_xstats_rd report_delta = {};
+	struct netdev_notifier_offload_xstats_info info = {
+		.info.dev = dev,
+		.info.extack = extack,
+		.type = type,
+		.report_delta = &report_delta,
+	};
+	struct rtnl_hw_stats64 *stats;
+	int rc;
+
+	stats = netdev_offload_xstats_get_ptr(dev, type);
+	if (WARN_ON(!stats))
+		return -EINVAL;
+
+	rc = call_netdevice_notifiers_info(NETDEV_OFFLOAD_XSTATS_REPORT_DELTA,
+					   &info.info);
+
+	/* Cache whatever we got, even if there was an error, otherwise the
+	 * successful stats retrievals would get lost.
+	 */
+	netdev_hw_stats64_add(stats, &report_delta.stats);
+
+	if (p_stats)
+		*p_stats = *stats;
+	*p_used = report_delta.used;
+
+	return notifier_to_errno(rc);
+}
+
+int netdev_offload_xstats_get(struct net_device *dev,
+			      enum netdev_offload_xstats_type type,
+			      struct rtnl_hw_stats64 *p_stats, bool *p_used,
+			      struct netlink_ext_ack *extack)
+{
+	ASSERT_RTNL();
+
+	if (p_stats)
+		return netdev_offload_xstats_get_stats(dev, type, p_stats,
+						       p_used, extack);
+	else
+		return netdev_offload_xstats_get_used(dev, type, p_used,
+						      extack);
+}
+EXPORT_SYMBOL(netdev_offload_xstats_get);
+
+void
+netdev_offload_xstats_report_delta(struct netdev_notifier_offload_xstats_rd *report_delta,
+				   const struct rtnl_hw_stats64 *stats)
+{
+	report_delta->used = true;
+	netdev_hw_stats64_add(&report_delta->stats, stats);
+}
+EXPORT_SYMBOL(netdev_offload_xstats_report_delta);
+
+void
+netdev_offload_xstats_report_used(struct netdev_notifier_offload_xstats_ru *report_used)
+{
+	report_used->used = true;
+}
+EXPORT_SYMBOL(netdev_offload_xstats_report_used);
+
+void netdev_offload_xstats_push_delta(struct net_device *dev,
+				      enum netdev_offload_xstats_type type,
+				      const struct rtnl_hw_stats64 *p_stats)
+{
+	struct rtnl_hw_stats64 *stats;
+
+	ASSERT_RTNL();
+
+	stats = netdev_offload_xstats_get_ptr(dev, type);
+	if (WARN_ON(!stats))
+		return;
+
+	netdev_hw_stats64_add(stats, p_stats);
+}
+EXPORT_SYMBOL(netdev_offload_xstats_push_delta);
+
 /**
  * netdev_get_xmit_slave - Get the xmit slave of master device
  * @dev: device
@@ -10417,6 +10680,8 @@ void unregister_netdevice_many(struct list_head *head)
 
 		dev_xdp_uninstall(dev);
 
+		netdev_offload_xstats_disable_all(dev);
+
 		/* Notify protocols, that we are about to destroy
 		 * this device. They should clean all the things.
 		 */
-- 
2.33.1

