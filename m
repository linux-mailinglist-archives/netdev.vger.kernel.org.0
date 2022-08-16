Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 778C1596585
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 00:30:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238017AbiHPW3o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 18:29:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238011AbiHPW3l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 18:29:41 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60064.outbound.protection.outlook.com [40.107.6.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19DE67A516
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 15:29:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iacu8LLy/Qcnxql8rD4yxO27jcTxVjnDsBHrLM62ll0AiLNK0zlaGfaMIVDuwoCD3TguR2iGVFys8vdkul2KliiPx0F8w9NLp/+YlR7Y9EVYTWHVFbd7aiCN26se0CRB3QX3p1RtA9voY2p2ilQXYeEqwAgG1qlsW2eCs/LcgzryC4crKA0W6lsAA2mxZcr97NHZjX5mf4S30zbVyHrWMvDH0mToKejZztqdZEGNd+o8vkd3qUlAbxwOQM5JTURLXgiE3vaAMSJnLYYtKZOxvmTMwz5tesKgkTNemYetZWSk7sUYYsMNuQMzgZBwT6nopTlDBJG/sTu4LC13E4CUIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L8QAgZ0bvKjRmZRmw7Pasl2q6c1Dp/W9swj6gjKmlBY=;
 b=eZB8JZIiBoOk0z3TmDyUMJ4XsDEr30B5S12kYYqwBtLupeduYO0ABMEO78hYz5dFPFWpaMUv3mCYJeiS3/zoeUKNRKfeSlpiws8lKn3yKgjCxStAkCyXzgQ8Vz0zX9OWbeYooCzkkw8MqKezCg6vEHR3KsFxDa8ORu3UboM5s0Ab7Qy8yXvBvIoKMz/S3ek3hf7+/eQzm7jbFnAOqdBLf9CKELKEd1hM6ErNTZdS8aSgl5bAifXP40j14RFJbvTldFx5PMiV/OdxPCl8kgKeXye3eRmhCugPd81HHbp+BarFRgPmEEuBCOuuCT8DHkI+hMUZe+DhCvfdYROSseuVSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L8QAgZ0bvKjRmZRmw7Pasl2q6c1Dp/W9swj6gjKmlBY=;
 b=oSSm5ULODdf0yS4RDpLSZHuXS7PzXCX1b5AihQWk3S3ymxvuTrHtyDeon8L18pnX/8jcqG/ASGgzYRDjjOG5cs75Y7sO1K6C/xGBXYiXOr3JSLIb5yKSAOV8e1B19OPt9EL0QeuIlwYwmX0PsLwnDIsfNBYeRslMaOVRJN5gOTw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM9PR04MB8618.eurprd04.prod.outlook.com (2603:10a6:20b:439::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.10; Tue, 16 Aug
 2022 22:29:32 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857%4]) with mapi id 15.20.5525.011; Tue, 16 Aug 2022
 22:29:32 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Michal Kubecek <mkubecek@suse.cz>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Rui Sousa <rui.sousa@nxp.com>,
        Ferenc Fejes <ferenc.fejes@ericsson.com>
Subject: [RFC PATCH net-next 2/7] net: ethtool: add support for Frame Preemption and MAC Merge layer
Date:   Wed, 17 Aug 2022 01:29:15 +0300
Message-Id: <20220816222920.1952936-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220816222920.1952936-1-vladimir.oltean@nxp.com>
References: <20220816222920.1952936-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0501CA0021.eurprd05.prod.outlook.com
 (2603:10a6:800:92::31) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 613b8e90-ac9b-4390-e20b-08da7fd6ca17
X-MS-TrafficTypeDiagnostic: AM9PR04MB8618:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Cermo04FRdubhRxrTKr4UP0lm24XpvylNjNJVkxLmBxUikMQaG+QI0tScCjsOpkalH5uru70fWdeQfQGO7TRcdmA8HGCF56CPBG5g6uW0K8JJ0gN3e9bu2EOiL1MHenqFeUAE9A6mJ0xPC1Hf86bEjvDFjLQY02lQzEca39zdOTG+dMgPOpdGYol4PTdhtMyGcuTvGYb7p5DaneqWaiJgekZkZYMXcIB3FJGc1H1fvQDFUqt7/mgIDgUR/Md8Df06CTx8sw5gjP3a1+OhWS/2WUJ8w5+yeDL0+eO+EqD/GxUiZEFdLJSMnYwvf3vUfB26JupDkCVehOvDW+rx4Zv7i4F1+EE3Hq34X86VE2pyURPFZD5+mdPDKqsMxDqMwBnh6WBRMv03mDzSif8nSakGZbzCYP3+HqAiIGnmK4jzkpYu2OEs6k/GzKo41sHEV/jZsvekjlSkCgctdPV7GibLbxUhc6I1yMPLBdHGGmNZu+Zu1UmGXtNPYKO6bQYmOSWEKIQeLOFhmOFG10Ym2Ary6rkk26F911lP65zrhyNaNqq+JAW5wracT6CtmyTsQ7+pi9v4oDiLch2jfWRJkBA5itL+T3vVmxIItZ8JmZEMLfCPVB0tDXWKPlsCo5d4MjgWEiYe1aNJSgrqrt6vBSRCVW3iCKaiPt9umTVTk9dhQmWqe6mnInfGWH7o10RIwkdMbMX30/YP3DyQYmrRvCCHDFyWy8bY+lFG7fOd1Mf0f8Znep3QR1zj5t3PEQgx4RB7J/eo5rVDV2A+fttgqmk/B5qspdVHnzJwyUzPk+pVzzMZp3b6J66yY7cwTS8+wtYzU5PUf+nxXG6c2lN7ucIUIxI733eXHtIWPcdRmhjr+4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(136003)(366004)(346002)(39860400002)(376002)(66946007)(44832011)(316002)(1076003)(66556008)(8676002)(83380400001)(41300700001)(6666004)(6916009)(4326008)(2906002)(36756003)(54906003)(186003)(2616005)(38100700002)(26005)(38350700002)(30864003)(19627235002)(6506007)(6512007)(66476007)(6486002)(8936002)(86362001)(478600001)(52116002)(5660300002)(966005)(134885004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?iwb3UU2ff7KpeBKKU3gGp18pamQ7wIURZCaELV7Vi+5f81FCASE6leIuCtov?=
 =?us-ascii?Q?5pRC+gPp0RPu3b2wPh8JHduuu+IhotSN7furxpbSqYsOyruG++mEf7MtgdZ6?=
 =?us-ascii?Q?B6N90gM6KSgQEMlW3VO/FwcxGCW5o8tNl7F28MmdGNrrejJNYhRlK3gYMh+4?=
 =?us-ascii?Q?HSpFWmQESEJYUwfEN96vJUAsZWLv97rrRTaxjIHbEMn76k20GRMikgs0O5GE?=
 =?us-ascii?Q?bwchKMeAwj5q9bQdyU3BKBG3MTR6CkplbKHmnDOPEusvSLVZM5/KyvAUcI76?=
 =?us-ascii?Q?WXGH6jj4F+Vb9nn8ND+WH7w3AV7ImHxgcqIK3VDkHGA0XOgSy4m4bdZYIntp?=
 =?us-ascii?Q?zjQE7ZkLzvFcF0SYKY0ZndNAmeFarPCGHl+BNVPF9vek+nsyFP5WRB6Eumvb?=
 =?us-ascii?Q?Yf3F5kp6M39G7m1/w8Aw8u10iJGSCbNwY0D2KWp+hPheQQK1eEaSh3Tw/nsi?=
 =?us-ascii?Q?e7Gatw+wC+ny+8Nz1a8oA6uPZLlwoWNMV6cgw3rGji/LDLB6FYWscvxKdxpz?=
 =?us-ascii?Q?N59EsjQgKrN3/NXZAznz+E6WgBVbdhoMvXvnjO3KNUFiDiqnX7rSvk0FqSFk?=
 =?us-ascii?Q?uCj+sBjU9LenmbvV74RyPvTweXB0RrOQ3iD9W6s5jJIrxT4fDyKn+ASo9LMF?=
 =?us-ascii?Q?uHImS2RTXl3SHAhoou0bIDjv5lTZz+nubIKAKeZlZAB+EKVsHU47+TzDTr8g?=
 =?us-ascii?Q?MtZVckz5wusKDKwfwJCiAFjCFOFgzfn2ToVRzvRtlul45EjuqmjqBwONUpF6?=
 =?us-ascii?Q?AfMASiuVTG+G/jzjHqNVcom8suU3C7YeZ2u1g6EFrcTFN3HdVeltyw32JU/e?=
 =?us-ascii?Q?7wCz6BkWsB3J3t3XyYrhpr9MCj3R+Tea+jKsVn5k01h2f/6TkHee3157339+?=
 =?us-ascii?Q?eHPA4kTBCPoINS/N5vrZ16IlbIFTWaf1wYmGLotz169IXsM1QvWZ80bxlETI?=
 =?us-ascii?Q?3N/vX7gFPjXxp7tgV2fYhTuaLGFXD3gNm+n39wvKdpU4matSI3d3CYnB1fgA?=
 =?us-ascii?Q?eQV30BEN3hzVMhsnfsEV3IaDZzSlzknW8HcewYn9IOiUJLCMX2UyYecFVLbD?=
 =?us-ascii?Q?eQ2iga5/gIKMH/50xhDK77ZKeSH239iCi0/bqo9tvlLuh6TteTmQ29jf4eEN?=
 =?us-ascii?Q?UOMrMtFnR9e3bH+cXaHrTm83jSmq4FFUt+3uvBl0ZGGTrH+8S4H4/7f5uAtC?=
 =?us-ascii?Q?kldtAMy3unAhIUogX4yRqwlt0trW9DlGnYWgCRbODU+ZXCqqXp+gc58DekxB?=
 =?us-ascii?Q?9X831LqLhq7AK13CBOLeTEUDtMIsDiKls0CkHHTn/Ky+KJoIXXA9pdUb9paP?=
 =?us-ascii?Q?0BBLnP4RX3BHF0+0SKsT9EjE5CJWpmMRNwEhPk7ynKRJ8RU9yPqPWF4gv+qO?=
 =?us-ascii?Q?9k3+NRh9pi02NVmy0xTD9MnGvGYccBVcynImf11LhUg0/Ctj6C3HT12gwRlc?=
 =?us-ascii?Q?Fjwa3E9RsudbF1baklDFpLBu7WS95pEabIeRfORJGgmx8vZBxZYdclOSbyVo?=
 =?us-ascii?Q?5lg/+B1q33qxa3arGWyyqZu31dQ97UkD80dSdka96HXgC2I2pUe8qJdR2WRE?=
 =?us-ascii?Q?NIf1zzTalv08ux3pRAtDY7q077UdkdwdT2yQ0gG8JZuK5oEAaYBukI0VVCxe?=
 =?us-ascii?Q?eA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 613b8e90-ac9b-4390-e20b-08da7fd6ca17
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Aug 2022 22:29:31.8981
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kQ+JpmkbUEM511kIXGDYlwfi9ovUgd3neXYpEpgy0yjTYLbEABhRrJWgGvDrbdTUrEKPaDLq06sfkQSrhOEsHA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8618
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Frame preemption (IEEE 802.1Q-2018 clause 6.7.2) and the MAC merge
sublayer (IEEE 802.3-2018 clause 99) are 2 specifications, part of the
Time Sensitive Networking enhancements, which work together to minimize
latency caused by frame interference. The overall goal of TSN is for
normal traffic and traffic belonging to real-time control processes to
be able to cohabitate on the same L2 network and not bother each other
too much.

They achieve this (partly) by introducing the concept of preemptable
traffic, i.e. Ethernet frames that have an altered Start-Of-Frame
delimiter, which can be fragmented and reassembled at L2 on a link-local
basis. The non-preemptable frames are called express traffic, and they
can preempt preemptable frames, therefore having lower latency, which
can matter at lower (100 Mbps) link speeds, or at high MTUs (jumbo
frames around 9K). Preemption is not recursive, i.e. a PT frame cannot
preempt another PT frame. Preemption also does not depend upon priority,
or otherwise said, an ET frame with prio 0 will still preempt a PT frame
with prio 7.

In terms of implementation, the specs talk about the fact that the
express traffic is handled by an express MAC (eMAC) and the preemptable
traffic by a preemptable MAC (pMAC), and these MACs are multiplexed on
the same MII by a MAC merge layer.

On RX, packets go to the eMAC or to the pMAC based on their SFD (the
definition of which was generalized to SMD, Start-of-mPacket-Delimiter,
where mPacket is essentially an Ethernet frame fragment, or a complete
frame). On TX, the eMAC/pMAC classification decision is taken by the
802.1Q spec, based on packet priority (each of the 8 priority values may
have an admin-status of preemptable or express).

I have modeled both the Ethernet part of the spec and the queuing part
as separate netlink messages, with separate ethtool command sets
intended for them. I am slightly flexible as to where to place the FP
settings; there were previous discussions about placing them in tc.
At the moment I haven't received a good enough argument to move them out
of ethtool, so here they are.
https://patchwork.kernel.org/project/netdevbpf/cover/20220520011538.1098888-1-vinicius.gomes@intel.com/

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 include/linux/ethtool.h              |  59 ++++++
 include/uapi/linux/ethtool.h         |  15 ++
 include/uapi/linux/ethtool_netlink.h |  82 ++++++++
 net/ethtool/Makefile                 |   3 +-
 net/ethtool/fp.c                     | 295 +++++++++++++++++++++++++++
 net/ethtool/mm.c                     | 228 +++++++++++++++++++++
 net/ethtool/netlink.c                |  38 ++++
 net/ethtool/netlink.h                |   8 +
 8 files changed, 727 insertions(+), 1 deletion(-)
 create mode 100644 net/ethtool/fp.c
 create mode 100644 net/ethtool/mm.c

diff --git a/include/linux/ethtool.h b/include/linux/ethtool.h
index 99dc7bfbcd3c..fa504dd22bf6 100644
--- a/include/linux/ethtool.h
+++ b/include/linux/ethtool.h
@@ -453,6 +453,49 @@ struct ethtool_module_power_mode_params {
 	enum ethtool_module_power_mode mode;
 };
 
+/**
+ * struct ethtool_fp_param - 802.1Q Frame Preemption parameters
+ */
+struct ethtool_fp_param {
+	u8 preemptable_prios;
+	u32 hold_advance;
+	u32 release_advance;
+};
+
+/**
+ * struct ethtool_mm_state - 802.3 MAC merge layer state
+ */
+struct ethtool_mm_state {
+	u32 verify_time;
+	enum ethtool_mm_verify_status verify_status;
+	bool supported;
+	bool enabled;
+	bool active;
+	u8 add_frag_size;
+};
+
+/**
+ * struct ethtool_mm_cfg - 802.3 MAC merge layer configuration
+ */
+struct ethtool_mm_cfg {
+	u32 verify_time;
+	bool verify_disable;
+	bool enabled;
+	u8 add_frag_size;
+};
+
+/* struct ethtool_mm_stats - 802.3 MAC merge layer statistics, as defined in
+ * IEEE 802.3-2018 subclause 30.14.1 oMACMergeEntity managed object class
+ */
+struct ethtool_mm_stats {
+	u64 MACMergeFrameAssErrorCount;
+	u64 MACMergeFrameSmdErrorCount;
+	u64 MACMergeFrameAssOkCount;
+	u64 MACMergeFragCountRx;
+	u64 MACMergeFragCountTx;
+	u64 MACMergeHoldCount;
+};
+
 /**
  * struct ethtool_ops - optional netdev operations
  * @cap_link_lanes_supported: indicates if the driver supports lanes
@@ -624,6 +667,11 @@ struct ethtool_module_power_mode_params {
  *	plugged-in.
  * @set_module_power_mode: Set the power mode policy for the plug-in module
  *	used by the network device.
+ * @get_fp_param: Query the 802.1Q Frame Preemption parameters.
+ * @set_fp_param: Set the 802.1Q Frame Preemption parameters.
+ * @get_mm_state: Query the 802.3 MAC Merge layer state.
+ * @set_mm_cfg: Set the 802.3 MAC Merge layer parameters.
+ * @get_mm_stats: Query the 802.3 MAC Merge layer statistics.
  *
  * All operations are optional (i.e. the function pointer may be set
  * to %NULL) and callers must take this into account.  Callers must
@@ -760,6 +808,17 @@ struct ethtool_ops {
 	int	(*set_module_power_mode)(struct net_device *dev,
 					 const struct ethtool_module_power_mode_params *params,
 					 struct netlink_ext_ack *extack);
+	void	(*get_fp_param)(struct net_device *dev,
+				struct ethtool_fp_param *params);
+	int	(*set_fp_param)(struct net_device *dev,
+				const struct ethtool_fp_param *params,
+				struct netlink_ext_ack *extack);
+	void	(*get_mm_state)(struct net_device *dev,
+				struct ethtool_mm_state *state);
+	int	(*set_mm_cfg)(struct net_device *dev, struct ethtool_mm_cfg *cfg,
+			      struct netlink_ext_ack *extack);
+	void	(*get_mm_stats)(struct net_device *dev,
+				struct ethtool_mm_stats *stats);
 };
 
 int ethtool_check_ops(const struct ethtool_ops *ops);
diff --git a/include/uapi/linux/ethtool.h b/include/uapi/linux/ethtool.h
index 2d5741fd44bb..7a21fcb26a43 100644
--- a/include/uapi/linux/ethtool.h
+++ b/include/uapi/linux/ethtool.h
@@ -736,6 +736,21 @@ enum ethtool_module_power_mode {
 	ETHTOOL_MODULE_POWER_MODE_HIGH,
 };
 
+/* Values from ieee8021FramePreemptionAdminStatus */
+enum ethtool_fp_admin_status {
+	ETHTOOL_FP_PARAM_ENTRY_ADMIN_STATUS_EXPRESS = 1,
+	ETHTOOL_FP_PARAM_ENTRY_ADMIN_STATUS_PREEMPTABLE = 2,
+};
+
+enum ethtool_mm_verify_status {
+	ETHTOOL_MM_VERIFY_STATUS_UNKNOWN,
+	ETHTOOL_MM_VERIFY_STATUS_INITIAL,
+	ETHTOOL_MM_VERIFY_STATUS_VERIFYING,
+	ETHTOOL_MM_VERIFY_STATUS_SUCCEEDED,
+	ETHTOOL_MM_VERIFY_STATUS_FAILED,
+	ETHTOOL_MM_VERIFY_STATUS_DISABLED,
+};
+
 /**
  * struct ethtool_gstrings - string set for data tagging
  * @cmd: Command number = %ETHTOOL_GSTRINGS
diff --git a/include/uapi/linux/ethtool_netlink.h b/include/uapi/linux/ethtool_netlink.h
index d2fb4f7be61b..658810274c49 100644
--- a/include/uapi/linux/ethtool_netlink.h
+++ b/include/uapi/linux/ethtool_netlink.h
@@ -49,6 +49,10 @@ enum {
 	ETHTOOL_MSG_PHC_VCLOCKS_GET,
 	ETHTOOL_MSG_MODULE_GET,
 	ETHTOOL_MSG_MODULE_SET,
+	ETHTOOL_MSG_FP_GET,
+	ETHTOOL_MSG_FP_SET,
+	ETHTOOL_MSG_MM_GET,
+	ETHTOOL_MSG_MM_SET,
 
 	/* add new constants above here */
 	__ETHTOOL_MSG_USER_CNT,
@@ -94,6 +98,10 @@ enum {
 	ETHTOOL_MSG_PHC_VCLOCKS_GET_REPLY,
 	ETHTOOL_MSG_MODULE_GET_REPLY,
 	ETHTOOL_MSG_MODULE_NTF,
+	ETHTOOL_MSG_FP_GET_REPLY,
+	ETHTOOL_MSG_FP_NTF,
+	ETHTOOL_MSG_MM_GET_REPLY,
+	ETHTOOL_MSG_MM_NTF,
 
 	/* add new constants above here */
 	__ETHTOOL_MSG_KERNEL_CNT,
@@ -862,6 +870,80 @@ enum {
 	ETHTOOL_A_MODULE_MAX = (__ETHTOOL_A_MODULE_CNT - 1)
 };
 
+/* FRAME PREEMPTION (802.1Q) */
+
+enum {
+	ETHTOOL_A_FP_PARAM_ENTRY_UNSPEC,
+	ETHTOOL_A_FP_PARAM_ENTRY_PRIO,		/* u8 */
+	ETHTOOL_A_FP_PARAM_ENTRY_ADMIN_STATUS,	/* u8 */
+
+	/* add new constants above here */
+	__ETHTOOL_A_FP_PARAM_ENTRY_CNT,
+	ETHTOOL_A_FP_PARAM_ENTRY_MAX = (__ETHTOOL_A_FP_PARAM_ENTRY_CNT - 1)
+};
+
+enum {
+	ETHTOOL_A_FP_PARAM_UNSPEC,
+	ETHTOOL_A_FP_PARAM_ENTRY,		/* nest */
+
+	/* add new constants above here */
+	__ETHTOOL_A_FP_PARAM_CNT,
+	ETHTOOL_A_FP_PARAM_MAX = (__ETHTOOL_A_FP_PARAM_CNT - 1)
+};
+
+enum {
+	ETHTOOL_A_FP_UNSPEC,
+	ETHTOOL_A_FP_HEADER,			/* nest - _A_HEADER_* */
+	ETHTOOL_A_FP_PARAM_TABLE,		/* nest */
+	ETHTOOL_A_FP_HOLD_ADVANCE,		/* u32 */
+	ETHTOOL_A_FP_RELEASE_ADVANCE,		/* u32 */
+
+	/* add new constants above here */
+	__ETHTOOL_A_FP_CNT,
+	ETHTOOL_A_FP_MAX = (__ETHTOOL_A_FP_CNT - 1)
+};
+
+/* MAC MERGE (802.3) */
+
+enum {
+	ETHTOOL_A_MM_STAT_UNSPEC,
+	ETHTOOL_A_MM_STAT_PAD,
+
+	/* aMACMergeFrameAssErrorCount */
+	ETHTOOL_A_MM_STAT_REASSEMBLY_ERRORS,	/* u64 */
+	/* aMACMergeFrameSmdErrorCount */
+	ETHTOOL_A_MM_STAT_SMD_ERRORS,		/* u64 */
+	/* aMACMergeFrameAssOkCount */
+	ETHTOOL_A_MM_STAT_REASSEMBLY_OK,	/* u64 */
+	/* aMACMergeFragCountRx */
+	ETHTOOL_A_MM_STAT_RX_FRAG_COUNT,	/* u64 */
+	/* aMACMergeFragCountTx */
+	ETHTOOL_A_MM_STAT_TX_FRAG_COUNT,	/* u64 */
+	/* aMACMergeHoldCount */
+	ETHTOOL_A_MM_STAT_HOLD_COUNT,		/* u64 */
+
+	/* add new constants above here */
+	__ETHTOOL_A_MM_STAT_CNT,
+	ETHTOOL_A_MM_STAT_MAX = (__ETHTOOL_A_MM_STAT_CNT - 1)
+};
+
+enum {
+	ETHTOOL_A_MM_UNSPEC,
+	ETHTOOL_A_MM_HEADER,			/* nest - _A_HEADER_* */
+	ETHTOOL_A_MM_VERIFY_STATUS,		/* u8 */
+	ETHTOOL_A_MM_VERIFY_DISABLE,		/* u8 */
+	ETHTOOL_A_MM_VERIFY_TIME,		/* u32 */
+	ETHTOOL_A_MM_SUPPORTED,			/* u8 */
+	ETHTOOL_A_MM_ENABLED,			/* u8 */
+	ETHTOOL_A_MM_ACTIVE,			/* u8 */
+	ETHTOOL_A_MM_ADD_FRAG_SIZE,		/* u8 */
+	ETHTOOL_A_MM_STATS,			/* nest - _A_MM_STAT_* */
+
+	/* add new constants above here */
+	__ETHTOOL_A_MM_CNT,
+	ETHTOOL_A_MM_MAX = (__ETHTOOL_A_MM_CNT - 1)
+};
+
 /* generic netlink info */
 #define ETHTOOL_GENL_NAME "ethtool"
 #define ETHTOOL_GENL_VERSION 1
diff --git a/net/ethtool/Makefile b/net/ethtool/Makefile
index b76432e70e6b..31e056f17856 100644
--- a/net/ethtool/Makefile
+++ b/net/ethtool/Makefile
@@ -7,4 +7,5 @@ obj-$(CONFIG_ETHTOOL_NETLINK)	+= ethtool_nl.o
 ethtool_nl-y	:= netlink.o bitset.o strset.o linkinfo.o linkmodes.o \
 		   linkstate.o debug.o wol.o features.o privflags.o rings.o \
 		   channels.o coalesce.o pause.o eee.o tsinfo.o cabletest.o \
-		   tunnels.o fec.o eeprom.o stats.o phc_vclocks.o module.o
+		   tunnels.o fec.o eeprom.o stats.o phc_vclocks.o module.o \
+		   fp.o mm.o
diff --git a/net/ethtool/fp.c b/net/ethtool/fp.c
new file mode 100644
index 000000000000..20f19d8c1461
--- /dev/null
+++ b/net/ethtool/fp.c
@@ -0,0 +1,295 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright 2022 NXP
+ */
+#include "common.h"
+#include "netlink.h"
+
+struct fp_req_info {
+	struct ethnl_req_info		base;
+};
+
+struct fp_reply_data {
+	struct ethnl_reply_data		base;
+	struct ethtool_fp_param		params;
+};
+
+#define FP_REPDATA(__reply_base) \
+	container_of(__reply_base, struct fp_reply_data, base)
+
+const struct nla_policy ethnl_fp_get_policy[ETHTOOL_A_FP_HEADER + 1] = {
+	[ETHTOOL_A_FP_HEADER] = NLA_POLICY_NESTED(ethnl_header_policy),
+};
+
+static int fp_prepare_data(const struct ethnl_req_info *req_base,
+			   struct ethnl_reply_data *reply_base,
+			   struct genl_info *info)
+{
+	struct fp_reply_data *data = FP_REPDATA(reply_base);
+	struct net_device *dev = reply_base->dev;
+	int ret;
+
+	if (!dev->ethtool_ops->get_fp_param)
+		return -EOPNOTSUPP;
+
+	ret = ethnl_ops_begin(dev);
+	if (ret < 0)
+		return ret;
+
+	dev->ethtool_ops->get_fp_param(dev, &data->params);
+	ethnl_ops_complete(dev);
+
+	return 0;
+}
+
+static int fp_reply_size(const struct ethnl_req_info *req_base,
+			 const struct ethnl_reply_data *reply_base)
+{
+	int len = 0;
+
+	len += nla_total_size(0); /* _FP_PARAM_ENTRY */
+	len += nla_total_size(sizeof(u8)); /* _FP_PARAM_ENTRY_PRIO */
+	len += nla_total_size(sizeof(u8)); /* _FP_PARAM_ENTRY_ADMIN_STATUS */
+	len *= 8; /* 8 prios */
+	len += nla_total_size(0); /* _FP_PARAM_TABLE */
+	len += nla_total_size(sizeof(u32)); /* _FP_HOLD_ADVANCE */
+	len += nla_total_size(sizeof(u32)); /* _FP_RELEASE_ADVANCE */
+
+	return len;
+}
+
+static int fp_fill_reply(struct sk_buff *skb,
+			 const struct ethnl_req_info *req_base,
+			 const struct ethnl_reply_data *reply_base)
+{
+	const struct fp_reply_data *data = FP_REPDATA(reply_base);
+	const struct ethtool_fp_param *params = &data->params;
+	enum ethtool_fp_admin_status admin_status;
+	struct nlattr *nest_table, *nest_entry;
+	int prio;
+	int ret;
+
+	if (nla_put_u32(skb, ETHTOOL_A_FP_HOLD_ADVANCE, params->hold_advance) ||
+	    nla_put_u32(skb, ETHTOOL_A_FP_RELEASE_ADVANCE, params->release_advance))
+		return -EMSGSIZE;
+
+	nest_table = nla_nest_start(skb, ETHTOOL_A_FP_PARAM_TABLE);
+	if (!nest_table)
+		return -EMSGSIZE;
+
+	for (prio = 0; prio < 8; prio++) {
+		admin_status = (params->preemptable_prios & BIT(prio)) ?
+			ETHTOOL_FP_PARAM_ENTRY_ADMIN_STATUS_PREEMPTABLE :
+			ETHTOOL_FP_PARAM_ENTRY_ADMIN_STATUS_EXPRESS;
+
+		nest_entry = nla_nest_start(skb, ETHTOOL_A_FP_PARAM_ENTRY);
+		if (!nest_entry)
+			goto nla_nest_cancel_table;
+
+		if (nla_put_u8(skb, ETHTOOL_A_FP_PARAM_ENTRY_PRIO, prio))
+			goto nla_nest_cancel_entry;
+
+		if (nla_put_u8(skb, ETHTOOL_A_FP_PARAM_ENTRY_ADMIN_STATUS,
+			       admin_status))
+			goto nla_nest_cancel_entry;
+
+		nla_nest_end(skb, nest_entry);
+	}
+
+	nla_nest_end(skb, nest_table);
+
+	return 0;
+
+nla_nest_cancel_entry:
+	nla_nest_cancel(skb, nest_entry);
+nla_nest_cancel_table:
+	nla_nest_cancel(skb, nest_table);
+	return ret;
+}
+
+const struct ethnl_request_ops ethnl_fp_request_ops = {
+	.request_cmd		= ETHTOOL_MSG_FP_GET,
+	.reply_cmd		= ETHTOOL_MSG_FP_GET_REPLY,
+	.hdr_attr		= ETHTOOL_A_FP_HEADER,
+	.req_info_size		= sizeof(struct fp_req_info),
+	.reply_data_size	= sizeof(struct fp_reply_data),
+
+	.prepare_data		= fp_prepare_data,
+	.reply_size		= fp_reply_size,
+	.fill_reply		= fp_fill_reply,
+};
+
+static const struct nla_policy
+ethnl_fp_set_param_entry_policy[ETHTOOL_A_FP_PARAM_ENTRY_MAX  + 1] = {
+	[ETHTOOL_A_FP_PARAM_ENTRY_PRIO] = { .type = NLA_U8 },
+	[ETHTOOL_A_FP_PARAM_ENTRY_ADMIN_STATUS] = { .type = NLA_U8 },
+};
+
+static const struct nla_policy
+ethnl_fp_set_param_table_policy[ETHTOOL_A_FP_PARAM_MAX + 1] = {
+	[ETHTOOL_A_FP_PARAM_ENTRY] = NLA_POLICY_NESTED(ethnl_fp_set_param_entry_policy),
+};
+
+const struct nla_policy ethnl_fp_set_policy[ETHTOOL_A_FP_MAX + 1] = {
+	[ETHTOOL_A_FP_HEADER] = NLA_POLICY_NESTED(ethnl_header_policy),
+	[ETHTOOL_A_FP_PARAM_TABLE] = NLA_POLICY_NESTED(ethnl_fp_set_param_table_policy),
+};
+
+static int fp_parse_param_entry(const struct nlattr *nest,
+				struct ethtool_fp_param *params,
+				u8 *seen_prios, bool *mod,
+				struct netlink_ext_ack *extack)
+{
+	struct nlattr *tb[ARRAY_SIZE(ethnl_fp_set_param_entry_policy)];
+	u8 preemptable_prios = params->preemptable_prios;
+	u8 prio, admin_status;
+	int ret;
+
+	if (!nest)
+		return 0;
+
+	ret = nla_parse_nested(tb,
+			       ARRAY_SIZE(ethnl_fp_set_param_entry_policy) - 1,
+			       nest, ethnl_fp_set_param_entry_policy,
+			       extack);
+	if (ret)
+		return ret;
+
+	if (!tb[ETHTOOL_A_FP_PARAM_ENTRY_PRIO]) {
+		NL_SET_ERR_MSG_ATTR(extack, nest,
+				    "Missing 'prio' attribute");
+		return -EINVAL;
+	}
+
+	if (!tb[ETHTOOL_A_FP_PARAM_ENTRY_ADMIN_STATUS]) {
+		NL_SET_ERR_MSG_ATTR(extack, nest,
+				    "Missing 'admin_status' attribute");
+		return -EINVAL;
+	}
+
+	prio = nla_get_u8(tb[ETHTOOL_A_FP_PARAM_ENTRY_PRIO]);
+	if (prio >= 8) {
+		NL_SET_ERR_MSG_ATTR(extack, nest,
+				    "Range exceeded for 'prio' attribute");
+		return -ERANGE;
+	}
+
+	if (*seen_prios & BIT(prio)) {
+		NL_SET_ERR_MSG_ATTR(extack, nest,
+				    "Duplicate 'prio' attribute");
+		return -EINVAL;
+	}
+
+	*seen_prios |= BIT(prio);
+
+	admin_status = nla_get_u8(tb[ETHTOOL_A_FP_PARAM_ENTRY_ADMIN_STATUS]);
+	switch (admin_status) {
+	case ETHTOOL_FP_PARAM_ENTRY_ADMIN_STATUS_PREEMPTABLE:
+		preemptable_prios |= BIT(prio);
+		break;
+	case ETHTOOL_FP_PARAM_ENTRY_ADMIN_STATUS_EXPRESS:
+		preemptable_prios &= ~BIT(prio);
+		break;
+	default:
+		NL_SET_ERR_MSG_ATTR(extack, nest,
+				    "Unexpected value for 'admin_status' attribute");
+		return -EINVAL;
+	}
+
+	if (preemptable_prios != params->preemptable_prios) {
+		params->preemptable_prios = preemptable_prios;
+		*mod = true;
+	}
+
+	return 0;
+}
+
+static int fp_parse_param_table(const struct nlattr *nest,
+				struct ethtool_fp_param *params, bool *mod,
+				struct netlink_ext_ack *extack)
+{
+	u8 seen_prios = 0;
+	struct nlattr *n;
+	int rem, ret;
+
+	if (!nest)
+		return 0;
+
+	nla_for_each_nested(n, nest, rem) {
+		struct sched_entry *entry;
+
+		if (nla_type(n) != ETHTOOL_A_FP_PARAM_ENTRY) {
+			NL_SET_ERR_MSG_ATTR(extack, n,
+					    "Attribute is not of type 'entry'");
+			continue;
+		}
+
+		ret = fp_parse_param_entry(n, params, &seen_prios, mod, extack);
+		if (ret < 0) {
+			kfree(entry);
+			return ret;
+		}
+	}
+
+	return 0;
+}
+
+int ethnl_set_fp_param(struct sk_buff *skb, struct genl_info *info)
+{
+	struct netlink_ext_ack *extack = info->extack;
+	struct ethnl_req_info req_info = {};
+	struct ethtool_fp_param params = {};
+	struct nlattr **tb = info->attrs;
+	const struct ethtool_ops *ops;
+	struct net_device *dev;
+	bool mod = false;
+	int ret;
+
+	ret = ethnl_parse_header_dev_get(&req_info, tb[ETHTOOL_A_FP_HEADER],
+					 genl_info_net(info), extack, true);
+	if (ret)
+		return ret;
+
+	dev = req_info.dev;
+	ops = dev->ethtool_ops;
+
+	if (!ops->get_fp_param || !ops->set_fp_param) {
+		ret = -EOPNOTSUPP;
+		goto out_dev;
+	}
+
+	rtnl_lock();
+	ret = ethnl_ops_begin(dev);
+	if (ret)
+		goto out_rtnl;
+
+	dev->ethtool_ops->get_fp_param(dev, &params);
+
+	ethnl_update_u32(&params.hold_advance, tb[ETHTOOL_A_FP_HOLD_ADVANCE],
+			 &mod);
+	ethnl_update_u32(&params.release_advance,
+			 tb[ETHTOOL_A_FP_RELEASE_ADVANCE], &mod);
+
+	ret = fp_parse_param_table(tb[ETHTOOL_A_FP_PARAM_TABLE], &params, &mod,
+				   extack);
+	if (ret || !mod)
+		goto out_ops;
+
+	ret = dev->ethtool_ops->set_fp_param(dev, &params, extack);
+	if (ret) {
+		if (!extack->_msg)
+			NL_SET_ERR_MSG(extack,
+				       "Failed to update frame preemption parameters");
+		goto out_ops;
+	}
+
+	ethtool_notify(dev, ETHTOOL_MSG_FP_NTF, NULL);
+
+out_ops:
+	ethnl_ops_complete(dev);
+out_rtnl:
+	rtnl_unlock();
+out_dev:
+	dev_put(dev);
+	return ret;
+}
diff --git a/net/ethtool/mm.c b/net/ethtool/mm.c
new file mode 100644
index 000000000000..d4731fb7aee4
--- /dev/null
+++ b/net/ethtool/mm.c
@@ -0,0 +1,228 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright 2022 NXP
+ */
+#include "common.h"
+#include "netlink.h"
+
+struct mm_req_info {
+	struct ethnl_req_info		base;
+};
+
+struct mm_reply_data {
+	struct ethnl_reply_data		base;
+	struct ethtool_mm_state		state;
+	struct ethtool_mm_stats		stats;
+};
+
+#define MM_REPDATA(__reply_base) \
+	container_of(__reply_base, struct mm_reply_data, base)
+
+#define ETHTOOL_MM_STAT_CNT \
+	(__ETHTOOL_A_MM_STAT_CNT - (ETHTOOL_A_MM_STAT_PAD + 1))
+
+const struct nla_policy ethnl_mm_get_policy[ETHTOOL_A_MM_HEADER + 1] = {
+	[ETHTOOL_A_MM_HEADER] = NLA_POLICY_NESTED(ethnl_header_policy_stats),
+};
+
+static int mm_prepare_data(const struct ethnl_req_info *req_base,
+			   struct ethnl_reply_data *reply_base,
+			   struct genl_info *info)
+{
+	struct mm_reply_data *data = MM_REPDATA(reply_base);
+	struct net_device *dev = reply_base->dev;
+	const struct ethtool_ops *ops;
+	int ret;
+
+	ops = dev->ethtool_ops;
+
+	if (!ops->get_mm_state)
+		return -EOPNOTSUPP;
+
+	ethtool_stats_init((u64 *)&data->stats,
+			   sizeof(data->stats) / sizeof(u64));
+
+	ret = ethnl_ops_begin(dev);
+	if (ret < 0)
+		return ret;
+
+	ops->get_mm_state(dev, &data->state);
+
+	if (ops->get_mm_stats && (req_base->flags & ETHTOOL_FLAG_STATS))
+		ops->get_mm_stats(dev, &data->stats);
+
+	ethnl_ops_complete(dev);
+
+	return 0;
+}
+
+static int mm_reply_size(const struct ethnl_req_info *req_base,
+			 const struct ethnl_reply_data *reply_base)
+{
+	int len = 0;
+
+	len += nla_total_size(sizeof(u8)); /* _MM_VERIFY_STATUS */
+	len += nla_total_size(sizeof(u32)); /* _MM_VERIFY_TIME */
+	len += nla_total_size(sizeof(u8)); /* _MM_SUPPORTED */
+	len += nla_total_size(sizeof(u8)); /* _MM_ENABLED */
+	len += nla_total_size(sizeof(u8)); /* _MM_ACTIVE */
+	len += nla_total_size(sizeof(u8)); /* _MM_ADD_FRAG_SIZE */
+
+	if (req_base->flags & ETHTOOL_FLAG_STATS)
+		len += nla_total_size(0) + /* _MM_STATS */
+		       nla_total_size_64bit(sizeof(u64)) * ETHTOOL_MM_STAT_CNT;
+
+	return len;
+}
+
+static int mm_put_stat(struct sk_buff *skb, u64 val, u16 attrtype)
+{
+	if (val == ETHTOOL_STAT_NOT_SET)
+		return 0;
+	if (nla_put_u64_64bit(skb, attrtype, val, ETHTOOL_A_MM_STAT_PAD))
+		return -EMSGSIZE;
+	return 0;
+}
+
+static int mm_put_stats(struct sk_buff *skb,
+			const struct ethtool_mm_stats *stats)
+{
+	struct nlattr *nest;
+
+	nest = nla_nest_start(skb, ETHTOOL_A_MM_STATS);
+	if (!nest)
+		return -EMSGSIZE;
+
+	if (mm_put_stat(skb, stats->MACMergeFrameAssErrorCount,
+			ETHTOOL_A_MM_STAT_REASSEMBLY_ERRORS) ||
+	    mm_put_stat(skb, stats->MACMergeFrameSmdErrorCount,
+			ETHTOOL_A_MM_STAT_SMD_ERRORS) ||
+	    mm_put_stat(skb, stats->MACMergeFrameAssOkCount,
+			ETHTOOL_A_MM_STAT_REASSEMBLY_OK) ||
+	    mm_put_stat(skb, stats->MACMergeFragCountRx,
+			ETHTOOL_A_MM_STAT_RX_FRAG_COUNT) ||
+	    mm_put_stat(skb, stats->MACMergeFragCountTx,
+			ETHTOOL_A_MM_STAT_TX_FRAG_COUNT) ||
+	    mm_put_stat(skb, stats->MACMergeHoldCount,
+			ETHTOOL_A_MM_STAT_HOLD_COUNT))
+		goto err_cancel;
+
+	nla_nest_end(skb, nest);
+	return 0;
+
+err_cancel:
+	nla_nest_cancel(skb, nest);
+	return -EMSGSIZE;
+}
+
+static int mm_fill_reply(struct sk_buff *skb,
+			 const struct ethnl_req_info *req_base,
+			 const struct ethnl_reply_data *reply_base)
+{
+	const struct mm_reply_data *data = MM_REPDATA(reply_base);
+	const struct ethtool_mm_state *state = &data->state;
+
+	if (nla_put_u8(skb, ETHTOOL_A_MM_VERIFY_STATUS, state->verify_status) ||
+	    nla_put_u32(skb, ETHTOOL_A_MM_VERIFY_TIME, state->verify_time) ||
+	    nla_put_u8(skb, ETHTOOL_A_MM_SUPPORTED, state->supported) ||
+	    nla_put_u8(skb, ETHTOOL_A_MM_ENABLED, state->enabled) ||
+	    nla_put_u8(skb, ETHTOOL_A_MM_ACTIVE, state->active) ||
+	    nla_put_u8(skb, ETHTOOL_A_MM_ADD_FRAG_SIZE, state->add_frag_size))
+		return -EMSGSIZE;
+
+	if (req_base->flags & ETHTOOL_FLAG_STATS &&
+	    mm_put_stats(skb, &data->stats))
+		return -EMSGSIZE;
+
+	return 0;
+}
+
+const struct ethnl_request_ops ethnl_mm_request_ops = {
+	.request_cmd		= ETHTOOL_MSG_MM_GET,
+	.reply_cmd		= ETHTOOL_MSG_MM_GET_REPLY,
+	.hdr_attr		= ETHTOOL_A_MM_HEADER,
+	.req_info_size		= sizeof(struct mm_req_info),
+	.reply_data_size	= sizeof(struct mm_reply_data),
+
+	.prepare_data		= mm_prepare_data,
+	.reply_size		= mm_reply_size,
+	.fill_reply		= mm_fill_reply,
+};
+
+const struct nla_policy ethnl_mm_set_policy[ETHTOOL_A_MM_MAX + 1] = {
+	[ETHTOOL_A_MM_HEADER] = NLA_POLICY_NESTED(ethnl_header_policy),
+	[ETHTOOL_A_MM_VERIFY_DISABLE] = { .type = NLA_U8 },
+	[ETHTOOL_A_MM_VERIFY_TIME] = { .type = NLA_U32 },
+	[ETHTOOL_A_MM_ENABLED] = { .type = NLA_U8 },
+	[ETHTOOL_A_MM_ADD_FRAG_SIZE] = { .type = NLA_U8 },
+};
+
+static void mm_state_to_cfg(const struct ethtool_mm_state *state,
+			    struct ethtool_mm_cfg *cfg)
+{
+	cfg->verify_disable =
+		state->verify_status == ETHTOOL_MM_VERIFY_STATUS_DISABLED;
+	cfg->verify_time = state->verify_time;
+	cfg->enabled = state->enabled;
+	cfg->add_frag_size = state->add_frag_size;
+}
+
+int ethnl_set_mm_cfg(struct sk_buff *skb, struct genl_info *info)
+{
+	struct netlink_ext_ack *extack = info->extack;
+	struct ethnl_req_info req_info = {};
+	struct ethtool_mm_state state = {};
+	struct nlattr **tb = info->attrs;
+	struct ethtool_mm_cfg cfg = {};
+	const struct ethtool_ops *ops;
+	struct net_device *dev;
+	bool mod = false;
+	int ret;
+
+	ret = ethnl_parse_header_dev_get(&req_info, tb[ETHTOOL_A_MM_HEADER],
+					 genl_info_net(info), extack, true);
+	if (ret)
+		return ret;
+
+	dev = req_info.dev;
+	ops = dev->ethtool_ops;
+
+	if (!ops->get_mm_state || !ops->set_mm_cfg) {
+		ret = -EOPNOTSUPP;
+		goto out_dev;
+	}
+
+	rtnl_lock();
+	ret = ethnl_ops_begin(dev);
+	if (ret)
+		goto out_rtnl;
+
+	ops->get_mm_state(dev, &state);
+
+	mm_state_to_cfg(&state, &cfg);
+
+	ethnl_update_bool(&cfg.verify_disable, tb[ETHTOOL_A_MM_VERIFY_DISABLE],
+			  &mod);
+	ethnl_update_u32(&cfg.verify_time, tb[ETHTOOL_A_MM_VERIFY_TIME], &mod);
+	ethnl_update_bool(&cfg.enabled, tb[ETHTOOL_A_MM_ENABLED], &mod);
+	ethnl_update_u8(&cfg.add_frag_size, tb[ETHTOOL_A_MM_ADD_FRAG_SIZE],
+			&mod);
+
+	ret = ops->set_mm_cfg(dev, &cfg, extack);
+	if (ret) {
+		if (!extack->_msg)
+			NL_SET_ERR_MSG(extack,
+				       "Failed to update MAC merge configuration");
+		goto out_ops;
+	}
+
+	ethtool_notify(dev, ETHTOOL_MSG_MM_NTF, NULL);
+
+out_ops:
+	ethnl_ops_complete(dev);
+out_rtnl:
+	rtnl_unlock();
+out_dev:
+	dev_put(dev);
+	return ret;
+}
diff --git a/net/ethtool/netlink.c b/net/ethtool/netlink.c
index e26079e11835..82ad2bd92d70 100644
--- a/net/ethtool/netlink.c
+++ b/net/ethtool/netlink.c
@@ -286,6 +286,8 @@ ethnl_default_requests[__ETHTOOL_MSG_USER_CNT] = {
 	[ETHTOOL_MSG_STATS_GET]		= &ethnl_stats_request_ops,
 	[ETHTOOL_MSG_PHC_VCLOCKS_GET]	= &ethnl_phc_vclocks_request_ops,
 	[ETHTOOL_MSG_MODULE_GET]	= &ethnl_module_request_ops,
+	[ETHTOOL_MSG_FP_GET]		= &ethnl_fp_request_ops,
+	[ETHTOOL_MSG_MM_GET]		= &ethnl_mm_request_ops,
 };
 
 static struct ethnl_dump_ctx *ethnl_dump_context(struct netlink_callback *cb)
@@ -598,6 +600,8 @@ ethnl_default_notify_ops[ETHTOOL_MSG_KERNEL_MAX + 1] = {
 	[ETHTOOL_MSG_EEE_NTF]		= &ethnl_eee_request_ops,
 	[ETHTOOL_MSG_FEC_NTF]		= &ethnl_fec_request_ops,
 	[ETHTOOL_MSG_MODULE_NTF]	= &ethnl_module_request_ops,
+	[ETHTOOL_MSG_FP_NTF]		= &ethnl_fp_request_ops,
+	[ETHTOOL_MSG_MM_NTF]		= &ethnl_mm_request_ops,
 };
 
 /* default notification handler */
@@ -691,6 +695,8 @@ static const ethnl_notify_handler_t ethnl_notify_handlers[] = {
 	[ETHTOOL_MSG_EEE_NTF]		= ethnl_default_notify,
 	[ETHTOOL_MSG_FEC_NTF]		= ethnl_default_notify,
 	[ETHTOOL_MSG_MODULE_NTF]	= ethnl_default_notify,
+	[ETHTOOL_MSG_FP_NTF]		= ethnl_default_notify,
+	[ETHTOOL_MSG_MM_NTF]		= ethnl_default_notify,
 };
 
 void ethtool_notify(struct net_device *dev, unsigned int cmd, const void *data)
@@ -1020,6 +1026,38 @@ static const struct genl_ops ethtool_genl_ops[] = {
 		.policy = ethnl_module_set_policy,
 		.maxattr = ARRAY_SIZE(ethnl_module_set_policy) - 1,
 	},
+	{
+		.cmd	= ETHTOOL_MSG_FP_GET,
+		.doit	= ethnl_default_doit,
+		.start	= ethnl_default_start,
+		.dumpit	= ethnl_default_dumpit,
+		.done	= ethnl_default_done,
+		.policy = ethnl_fp_get_policy,
+		.maxattr = ARRAY_SIZE(ethnl_fp_get_policy) - 1,
+	},
+	{
+		.cmd	= ETHTOOL_MSG_FP_SET,
+		.flags	= GENL_UNS_ADMIN_PERM,
+		.doit	= ethnl_set_fp_param,
+		.policy = ethnl_fp_set_policy,
+		.maxattr = ARRAY_SIZE(ethnl_fp_set_policy) - 1,
+	},
+	{
+		.cmd	= ETHTOOL_MSG_MM_GET,
+		.doit	= ethnl_default_doit,
+		.start	= ethnl_default_start,
+		.dumpit	= ethnl_default_dumpit,
+		.done	= ethnl_default_done,
+		.policy = ethnl_mm_get_policy,
+		.maxattr = ARRAY_SIZE(ethnl_mm_get_policy) - 1,
+	},
+	{
+		.cmd	= ETHTOOL_MSG_MM_SET,
+		.flags	= GENL_UNS_ADMIN_PERM,
+		.doit	= ethnl_set_mm_cfg,
+		.policy = ethnl_mm_set_policy,
+		.maxattr = ARRAY_SIZE(ethnl_mm_set_policy) - 1,
+	},
 };
 
 static const struct genl_multicast_group ethtool_nl_mcgrps[] = {
diff --git a/net/ethtool/netlink.h b/net/ethtool/netlink.h
index 1653fd2cf0cf..a2e56df74c85 100644
--- a/net/ethtool/netlink.h
+++ b/net/ethtool/netlink.h
@@ -371,6 +371,8 @@ extern const struct ethnl_request_ops ethnl_module_eeprom_request_ops;
 extern const struct ethnl_request_ops ethnl_stats_request_ops;
 extern const struct ethnl_request_ops ethnl_phc_vclocks_request_ops;
 extern const struct ethnl_request_ops ethnl_module_request_ops;
+extern const struct ethnl_request_ops ethnl_fp_request_ops;
+extern const struct ethnl_request_ops ethnl_mm_request_ops;
 
 extern const struct nla_policy ethnl_header_policy[ETHTOOL_A_HEADER_FLAGS + 1];
 extern const struct nla_policy ethnl_header_policy_stats[ETHTOOL_A_HEADER_FLAGS + 1];
@@ -409,6 +411,10 @@ extern const struct nla_policy ethnl_stats_get_policy[ETHTOOL_A_STATS_GROUPS + 1
 extern const struct nla_policy ethnl_phc_vclocks_get_policy[ETHTOOL_A_PHC_VCLOCKS_HEADER + 1];
 extern const struct nla_policy ethnl_module_get_policy[ETHTOOL_A_MODULE_HEADER + 1];
 extern const struct nla_policy ethnl_module_set_policy[ETHTOOL_A_MODULE_POWER_MODE_POLICY + 1];
+extern const struct nla_policy ethnl_fp_get_policy[ETHTOOL_A_FP_HEADER + 1];
+extern const struct nla_policy ethnl_fp_set_policy[ETHTOOL_A_FP_MAX + 1];
+extern const struct nla_policy ethnl_mm_get_policy[ETHTOOL_A_MM_HEADER + 1];
+extern const struct nla_policy ethnl_mm_set_policy[ETHTOOL_A_MM_MAX + 1];
 
 int ethnl_set_linkinfo(struct sk_buff *skb, struct genl_info *info);
 int ethnl_set_linkmodes(struct sk_buff *skb, struct genl_info *info);
@@ -428,6 +434,8 @@ int ethnl_tunnel_info_start(struct netlink_callback *cb);
 int ethnl_tunnel_info_dumpit(struct sk_buff *skb, struct netlink_callback *cb);
 int ethnl_set_fec(struct sk_buff *skb, struct genl_info *info);
 int ethnl_set_module(struct sk_buff *skb, struct genl_info *info);
+int ethnl_set_fp_param(struct sk_buff *skb, struct genl_info *info);
+int ethnl_set_mm_cfg(struct sk_buff *skb, struct genl_info *info);
 
 extern const char stats_std_names[__ETHTOOL_STATS_CNT][ETH_GSTRING_LEN];
 extern const char stats_eth_phy_names[__ETHTOOL_A_STATS_ETH_PHY_CNT][ETH_GSTRING_LEN];
-- 
2.34.1

