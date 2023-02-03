Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 372AD6899AF
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 14:28:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232340AbjBCN1h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 08:27:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229785AbjBCN1a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 08:27:30 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2046.outbound.protection.outlook.com [40.107.220.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7B6792EED
        for <netdev@vger.kernel.org>; Fri,  3 Feb 2023 05:27:28 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RA4ET3HggWNDpSkEeD9uzTZj3cFhrtVPk6z/J0owqb+GLGFYWYPI3i2/gDkJc/74DKLhjwPXQn1Z9Cxj9vChH5SqJJ50UdM6EA7Q8pyMutX/ROpQgvxGB6rtvkuoSdEVZaGPy2+jtOcC5JdVFgj82aZiqHB9wr/IHkI4gniSZ800IBA0aiRg2X/CaFkXW95j3P+oyj80f/EfwPZqZwJ0t1Tyzz/VOZsfWoW4zx1xL7epav54q/0FZhiN/aG0J+Jd9cTscLrUQeC1AMXywnru6nEl6mS4RCWr5Z0qBdqNLj9KOoohvqE6u1we7UWlE2MjOS0Ldlyj+em134ngCtyszQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=S8/No3axzKUhsGFPUO61Pfphbx5WUJkQ4WQPvJ/aelA=;
 b=Oh/L47SIldDvl8oL2ob9tly6FnzYpgFbhtb+crj1J9TD2lENBMh7mmv97JX68g+P4lBORYO/RXRelnsKRYN3Fo63vNP8CIcQJ2Wd5W7KqR8wSRA5MDtdm8IDu1WQjIgEIwxaWCfLxYdME92B1XUuYYyWoUYGwno2JXghY/cyXOHBZyisZkvlDvf+IUeVYN9lpl7aqSljb0BRNXjqgEk1G88QM32OaqZmiuF5jQrtQxhW0el8CkwqdqTwTZHcTUq4uR4RPbRUPkRAzVZozji1Y+m5GaHnAMtjCJ9BEGB9VxhACr/rhNgc9oyEA7YaU9ui6FVMl/mY6fq9roGZlD5BAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S8/No3axzKUhsGFPUO61Pfphbx5WUJkQ4WQPvJ/aelA=;
 b=Lq4byY11KyHK+KLuJ83YPGYEmmp2JRki0Gxk1WiBL+0HkEqEPrxk7G+G/sr0lNR914dP8YIf5R1fpCWA4u5yPGDmVi2DQkejviY2Mh+7gJNektvzHrgM9OfntR3gSVW1q1u9CHrDE4r8MNW3LIziTdmU5rjqpz+OBN/SC1l4UXGZyZ2Z/Q6glcNoLVinQPREEtPYHzQxAEqeRuA+1N1CrlVqLBNCQW3POuxmAufDsSjfcZk7z8htBlMCTlx3hJnRPNx58Z5o76VpsatV6eiDlUxO1BOoDnnr3g9cTDHZ2GAZ7GoX3YzOa+KqGdDB5qDpx8uorEDiqZdq+n/zRLTzwQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com (2603:10b6:a03:45e::8)
 by SN7PR12MB6930.namprd12.prod.outlook.com (2603:10b6:806:262::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.29; Fri, 3 Feb
 2023 13:27:26 +0000
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::9fd9:dadc:4d8a:2d84]) by SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::9fd9:dadc:4d8a:2d84%4]) with mapi id 15.20.6064.027; Fri, 3 Feb 2023
 13:27:26 +0000
From:   Aurelien Aptel <aaptel@nvidia.com>
To:     linux-nvme@lists.infradead.org, netdev@vger.kernel.org,
        sagi@grimberg.me, hch@lst.de, kbusch@kernel.org, axboe@fb.com,
        chaitanyak@nvidia.com, davem@davemloft.net, kuba@kernel.org
Cc:     Aurelien Aptel <aaptel@nvidia.com>, aurelien.aptel@gmail.com,
        smalin@nvidia.com, malin1024@gmail.com, ogerlitz@nvidia.com,
        yorayz@nvidia.com, borisp@nvidia.com
Subject: [PATCH v11 02/25] net/ethtool: add new stringset ETH_SS_ULP_DDP_{CAPS,STATS}
Date:   Fri,  3 Feb 2023 15:26:42 +0200
Message-Id: <20230203132705.627232-3-aaptel@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230203132705.627232-1-aaptel@nvidia.com>
References: <20230203132705.627232-1-aaptel@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR3P281CA0081.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1f::11) To SJ1PR12MB6075.namprd12.prod.outlook.com
 (2603:10b6:a03:45e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR12MB6075:EE_|SN7PR12MB6930:EE_
X-MS-Office365-Filtering-Correlation-Id: 36be2440-2d0c-4727-6b5f-08db05ea6430
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9Bn/SYNuc4WHcxBrysuNWvyY0MURY8yNdKidZciy0eVyObc0lNYbCTTAGZziTKicCWAZm3+LSq+uFY1w/WTP9bDyv7v63yGbEvFhGu0aTQQAti+chWlRSPAjKUkkpRuKqemODwlvBkm2EULI8wzxUAdyluQwUMdU4ohkVf4BZKISKjKItENcsfiDeTMFhNWpbitlkg0WPZQ0g9DI1HVTJnok3zsNSNRN7jKTsa/fryI2xuqOYHwzPf2VwV4txol/czvPqpvna6l62Lla2EPdXRTE5UFFIJcJaRddjGEW4x8l4y5rjyTTQ2qohLbbRpSK4BYFGiVxwvC4TMtIdaDNpXuFYAw5XbIpI4bXc9h+6Upr7p3D2OpFyc01+hRAwkDenzQ8gIJOZ9Bkfu213iyL9+yyTevr2Ha/qXnS4tx+5D+3IGMPnnXY9ywVifHxNHaTpnvAkx57apvG/Vj4djPWwfiG2lwQOTmtwiWjSue1iQDQ/LuOu0fi6qYwmKeCuFZEqD6ATuSFCtosvHgEXveIhA7yoaTEuBATfA4S7ObMbblxsX8h2TQTmPXfO+Pn59+LK7OOE8SgDsrQbJGifVXeuuRbt+IGaqNlQBGR5Kwb6P6HJvejRI6dOf2hv9aPllSsxX+tVePB/Rptsl3LkeilVw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR12MB6075.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(396003)(39860400002)(136003)(366004)(346002)(451199018)(7416002)(5660300002)(2906002)(2616005)(86362001)(38100700002)(1076003)(6506007)(6512007)(26005)(186003)(83380400001)(478600001)(6486002)(36756003)(6666004)(107886003)(66946007)(66476007)(316002)(66556008)(41300700001)(8676002)(8936002)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vx8We4DdTJzms7eALn/9f+Z71Brlmow0jOG94W5F+tUoqBDuhcNtd4+RV0CE?=
 =?us-ascii?Q?iw0VPUKKsl40xgNNXESK3oZTWPfF+phVAw/Di9Oet2KkdEvqx2AcPv5kasVn?=
 =?us-ascii?Q?ZH3/ZdUTnYrN5nEqDmq+qRHFaVxb8Jb5vQ9OHkJMNL7cRsiD4hTwyStyl8L0?=
 =?us-ascii?Q?QyEVql6useTxbZnFHTuF9Wz9qMH5vVsyJULsqFV/FcMq5ZT0rB/CuB0isfUo?=
 =?us-ascii?Q?4jPElR2zXlejPOkMiWlBVfPdrAsZBkHNJfmXcDPh/F/U/MjCjwlXTm9EVDq0?=
 =?us-ascii?Q?2ukfEQzCpveu1srYK2qVjG99H3O6LEny5+kwiRU+86F8/PheYCygsDsdVZgQ?=
 =?us-ascii?Q?gjGsUaH51tdu/smRd1cqUb6cnfSPAfdfxzCgmwU1E4Mgbe582QYckFudeqIV?=
 =?us-ascii?Q?b2foN2R4sB/nRJz/Ks1uyntFUXr8xR9ND/NOvD+C3Y1/r6e5niJsVTnpEiz2?=
 =?us-ascii?Q?7DLGwnyMn7QnsbVbJOzUfqPxq4A4mNgqq+2xfPTEPl+arSzEb7lfPgJmuY/o?=
 =?us-ascii?Q?I6PH0Fg8A3jaeSN6ZwYJ8YkP4A/SHWct8QxCUsxLxx2NvXqXvn4FUnELlz40?=
 =?us-ascii?Q?Wat8rIQVtfA+FAtPLzUZ2+c6POOInFC6zCjl92hEm1A+RYr6pD12BTUkzzgk?=
 =?us-ascii?Q?GUpv7Aqam+XTt2W/cU72RsQ6HcQZ6ZpLNjrf4Es/Qj+Xqqby/y4OBdMB4Hwl?=
 =?us-ascii?Q?x+ptV4Px3oVZ5duuW6r0COfgwRJMXCUCyV2SWFKIDo/3A4Bp2T/WCZgFLN02?=
 =?us-ascii?Q?1PmZcv8QNI0lXKMYs75Z62juDSyvVOpxyb8B1l1bdcOWt7qTcWo8FMbuET0F?=
 =?us-ascii?Q?yNwqeJjYu1igshlIspVwoxi2OiJfBV87KXu2vyEKhIAz5EXXNEMf3xK1Lt7d?=
 =?us-ascii?Q?L5jOSi9vOtMRcfBWCKyMFhh7eeuJzSh869WopIZR7rcG+Ecsq0SPLuQ/A7lM?=
 =?us-ascii?Q?MmAoc/H3v2x+TGRG6ItDHa6ljjTOjO+hB4EciOxVrK6+cslSThcZHG5WMSWe?=
 =?us-ascii?Q?1R3P0cKpf/aQM1AnD8k46/BvUoS14RGydTdP3v4nCg48AO/8f9VmjZQcz+Bc?=
 =?us-ascii?Q?e24EQpBQW4/0RuPfHCiO2Fc85QBWvR+qNU19e+5Oz+jJbchaM7i6Yub42LPM?=
 =?us-ascii?Q?KcEbM7M37sbsq8+4/iMPzFe010nkFXvNZMHn0Qy/5DWgFDFfTJXoHMZS3oNr?=
 =?us-ascii?Q?MqhAUo9+Tay083Yo6k2T1729juyC2DpFEe287k3ryUeX5ISnDjA86lU7xFwk?=
 =?us-ascii?Q?yiYuEUGkGpefiN/dNFpi18vK7xuvYfdTP9jwADCsohLcpKFT0hf5bVfWy/rW?=
 =?us-ascii?Q?xbBvfIBvp6rU4EXYdshOXD9slB+/JHIrpYd6KWu4HZUmPxjE8TbxKukCOuCV?=
 =?us-ascii?Q?UwkHff/s3TtmhP0wtlEACZ0Le+f0CBsnLkvCUBDGX+67LYZhHYHKxvXsyXSL?=
 =?us-ascii?Q?w+LElmC5TnYwpy+6uZK9vzfa3c92DrZSn+wqaDzA0/ICMf0FHtPSy+V6nvCi?=
 =?us-ascii?Q?S6kQYSN38OKuM3E6kh3ShIFfLogEykogBvg3ub0pfhHhx9jYcdPVksFjJkwM?=
 =?us-ascii?Q?+MKyCHVBl4znVFlunEbPpK9DRdOnt2XgNZEuYyUg?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 36be2440-2d0c-4727-6b5f-08db05ea6430
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR12MB6075.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Feb 2023 13:27:26.5856
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6epE256LTSqJrq2/xUVgbO+dlyZmu2uxtT2vjb7HzDsXCHG/kEsHk1knzL7Ug03ZjBuvZlnLNCNT2RY2ITxsvg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6930
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit exposes ULP DDP capability and statistics names to
userspace via netlink.

In order to support future ULP DDP capabilities and statistics without
having to change the netlink protocol (and userspace ethtool) we add
new string sets to let userspace dynamically fetch what the kernel
supports.

* ETH_SS_ULP_DDP_CAPS stores names of ULP DDP capabilities
* ETH_SS_ULP_DDP_STATS stores names of ULP DDP statistics.

These stringsets will be used in later commits when implementing the
new ULP DDP GET/SET netlink messages.

We keep the convention of strset.c of having the static_assert()
right after the array declaration, despite the checkpatch warning.

Signed-off-by: Shai Malin <smalin@nvidia.com>
Signed-off-by: Aurelien Aptel <aaptel@nvidia.com>
---
 include/linux/ethtool.h              | 32 ++++++++++++++++++++++++++++
 include/uapi/linux/ethtool.h         |  4 ++++
 include/uapi/linux/ethtool_netlink.h | 22 +++++++++++++++++++
 net/ethtool/common.c                 | 23 ++++++++++++++++++++
 net/ethtool/common.h                 |  2 ++
 net/ethtool/strset.c                 | 11 ++++++++++
 6 files changed, 94 insertions(+)

diff --git a/include/linux/ethtool.h b/include/linux/ethtool.h
index 515c78d8eb7c..6b55db2b8287 100644
--- a/include/linux/ethtool.h
+++ b/include/linux/ethtool.h
@@ -584,6 +584,38 @@ struct ethtool_mm_stats {
 	u64 MACMergeHoldCount;
 };
 
+/**
+ * struct ethtool_ulp_ddp_stats - ULP DDP offload statistics
+ * @rx_nvmeotcp_sk_add: number of sockets successfully prepared for offloading.
+ * @rx_nvmeotcp_sk_add_fail: number of sockets that failed to be prepared for offloading.
+ * @rx_nvmeotcp_sk_del: number of sockets where offloading has been removed.
+ * @rx_nvmeotcp_ddp_setup: number of NVMeTCP PDU successfully prepared for Direct Data Placement.
+ * @rx_nvmeotcp_ddp_setup_fail: number of PDUs that failed DDP preparation.
+ * @rx_nvmeotcp_ddp_teardown: number of PDUs done with DDP.
+ * @rx_nvmeotcp_drop: number of PDUs dropped.
+ * @rx_nvmeotcp_resync: number of resync.
+ * @rx_nvmeotcp_packets: number of offloaded PDUs.
+ * @rx_nvmeotcp_bytes: number of offloaded bytes.
+ */
+struct ethtool_ulp_ddp_stats {
+	u64 rx_nvmeotcp_sk_add;
+	u64 rx_nvmeotcp_sk_add_fail;
+	u64 rx_nvmeotcp_sk_del;
+	u64 rx_nvmeotcp_ddp_setup;
+	u64 rx_nvmeotcp_ddp_setup_fail;
+	u64 rx_nvmeotcp_ddp_teardown;
+	u64 rx_nvmeotcp_drop;
+	u64 rx_nvmeotcp_resync;
+	u64 rx_nvmeotcp_packets;
+	u64 rx_nvmeotcp_bytes;
+
+	/*
+	 * add new stats at the end and keep in sync with
+	 * - ETHTOOL_ULP_DDP_STATS_* enum in uapi
+	 * - ulp_ddp_stats_name stringset
+	 */
+};
+
 /**
  * struct ethtool_ops - optional netdev operations
  * @cap_link_lanes_supported: indicates if the driver supports lanes
diff --git a/include/uapi/linux/ethtool.h b/include/uapi/linux/ethtool.h
index f7fba0dc87e5..8b8585b5fa56 100644
--- a/include/uapi/linux/ethtool.h
+++ b/include/uapi/linux/ethtool.h
@@ -681,6 +681,8 @@ enum ethtool_link_ext_substate_module {
  * @ETH_SS_STATS_ETH_MAC: names of IEEE 802.3 MAC statistics
  * @ETH_SS_STATS_ETH_CTRL: names of IEEE 802.3 MAC Control statistics
  * @ETH_SS_STATS_RMON: names of RMON statistics
+ * @ETH_SS_ULP_DDP_CAPS: names of ULP DDP capabilities
+ * @ETH_SS_ULP_DDP_STATS: names of ULP DDP statistics
  *
  * @ETH_SS_COUNT: number of defined string sets
  */
@@ -706,6 +708,8 @@ enum ethtool_stringset {
 	ETH_SS_STATS_ETH_MAC,
 	ETH_SS_STATS_ETH_CTRL,
 	ETH_SS_STATS_RMON,
+	ETH_SS_ULP_DDP_CAPS,
+	ETH_SS_ULP_DDP_STATS,
 
 	/* add new constants above here */
 	ETH_SS_COUNT
diff --git a/include/uapi/linux/ethtool_netlink.h b/include/uapi/linux/ethtool_netlink.h
index ffb073c0dbb4..1722581b2db6 100644
--- a/include/uapi/linux/ethtool_netlink.h
+++ b/include/uapi/linux/ethtool_netlink.h
@@ -972,6 +972,28 @@ enum {
 	ETHTOOL_A_MM_MAX = (__ETHTOOL_A_MM_CNT - 1)
 };
 
+/* ULP DDP */
+
+enum {
+	ETHTOOL_A_ULP_DDP_STATS_UNSPEC,
+	ETHTOOL_A_ULP_DDP_STATS_PAD,
+
+	ETHTOOL_A_ULP_DDP_STATS_RX_NVMEOTCP_SK_ADD,
+	ETHTOOL_A_ULP_DDP_STATS_RX_NVMEOTCP_SK_ADD_FAIL,
+	ETHTOOL_A_ULP_DDP_STATS_RX_NVMEOTCP_SK_DEL,
+	ETHTOOL_A_ULP_DDP_STATS_RX_NVMEOTCP_DDP_SETUP,
+	ETHTOOL_A_ULP_DDP_STATS_RX_NVMEOTCP_DDP_SETUP_FAIL,
+	ETHTOOL_A_ULP_DDP_STATS_RX_NVMEOTCP_DDP_TEARDOWN,
+	ETHTOOL_A_ULP_DDP_STATS_RX_NVMEOTCP_DROP,
+	ETHTOOL_A_ULP_DDP_STATS_RX_NVMEOTCP_RESYNC,
+	ETHTOOL_A_ULP_DDP_STATS_RX_NVMEOTCP_PACKETS,
+	ETHTOOL_A_ULP_DDP_STATS_RX_NVMEOTCP_BYTES,
+
+	/* add new constants above here */
+	__ETHTOOL_A_ULP_DDP_STATS_CNT,
+	ETHTOOL_A_ULP_DDP_STATS_MAX = __ETHTOOL_A_ULP_DDP_STATS_CNT - 1
+};
+
 /* generic netlink info */
 #define ETHTOOL_GENL_NAME "ethtool"
 #define ETHTOOL_GENL_VERSION 1
diff --git a/net/ethtool/common.c b/net/ethtool/common.c
index 5fb19050991e..751017dca228 100644
--- a/net/ethtool/common.c
+++ b/net/ethtool/common.c
@@ -5,6 +5,7 @@
 #include <linux/phy.h>
 #include <linux/rtnetlink.h>
 #include <linux/ptp_clock_kernel.h>
+#include <net/ulp_ddp_caps.h>
 
 #include "common.h"
 
@@ -465,6 +466,28 @@ const char udp_tunnel_type_names[][ETH_GSTRING_LEN] = {
 static_assert(ARRAY_SIZE(udp_tunnel_type_names) ==
 	      __ETHTOOL_UDP_TUNNEL_TYPE_CNT);
 
+const char ulp_ddp_caps_names[][ETH_GSTRING_LEN] = {
+	[ULP_DDP_C_NVME_TCP_BIT]		= "nvme-tcp-ddp",
+	[ULP_DDP_C_NVME_TCP_DDGST_RX_BIT]	= "nvme-tcp-ddgst-rx-offload",
+};
+static_assert(ARRAY_SIZE(ulp_ddp_caps_names) == ULP_DDP_C_COUNT);
+
+const char ulp_ddp_stats_names[][ETH_GSTRING_LEN] = {
+	[ETHTOOL_A_ULP_DDP_STATS_UNSPEC]			= "unspec",
+	[ETHTOOL_A_ULP_DDP_STATS_PAD]				= "pad",
+	[ETHTOOL_A_ULP_DDP_STATS_RX_NVMEOTCP_SK_ADD]		= "rx_nvmeotcp_sk_add",
+	[ETHTOOL_A_ULP_DDP_STATS_RX_NVMEOTCP_SK_ADD_FAIL]	= "rx_nvmeotcp_sk_add_fail",
+	[ETHTOOL_A_ULP_DDP_STATS_RX_NVMEOTCP_SK_DEL]		= "rx_nvmeotcp_sk_del",
+	[ETHTOOL_A_ULP_DDP_STATS_RX_NVMEOTCP_DDP_SETUP]		= "rx_nvmeotcp_ddp_setup",
+	[ETHTOOL_A_ULP_DDP_STATS_RX_NVMEOTCP_DDP_SETUP_FAIL]	= "rx_nvmeotcp_ddp_setup_fail",
+	[ETHTOOL_A_ULP_DDP_STATS_RX_NVMEOTCP_DDP_TEARDOWN]	= "rx_nvmeotcp_ddp_teardown",
+	[ETHTOOL_A_ULP_DDP_STATS_RX_NVMEOTCP_DROP]		= "rx_nvmeotcp_drop",
+	[ETHTOOL_A_ULP_DDP_STATS_RX_NVMEOTCP_RESYNC]		= "rx_nvmeotcp_resync",
+	[ETHTOOL_A_ULP_DDP_STATS_RX_NVMEOTCP_PACKETS]		= "rx_nvmeotcp_packets",
+	[ETHTOOL_A_ULP_DDP_STATS_RX_NVMEOTCP_BYTES]		= "rx_nvmeotcp_bytes",
+};
+static_assert(ARRAY_SIZE(ulp_ddp_stats_names) == __ETHTOOL_A_ULP_DDP_STATS_CNT);
+
 /* return false if legacy contained non-0 deprecated fields
  * maxtxpkt/maxrxpkt. rest of ksettings always updated
  */
diff --git a/net/ethtool/common.h b/net/ethtool/common.h
index 28b8aaaf9bcb..ebb0abec04a3 100644
--- a/net/ethtool/common.h
+++ b/net/ethtool/common.h
@@ -36,6 +36,8 @@ extern const char sof_timestamping_names[][ETH_GSTRING_LEN];
 extern const char ts_tx_type_names[][ETH_GSTRING_LEN];
 extern const char ts_rx_filter_names[][ETH_GSTRING_LEN];
 extern const char udp_tunnel_type_names[][ETH_GSTRING_LEN];
+extern const char ulp_ddp_caps_names[][ETH_GSTRING_LEN];
+extern const char ulp_ddp_stats_names[][ETH_GSTRING_LEN];
 
 int __ethtool_get_link(struct net_device *dev);
 
diff --git a/net/ethtool/strset.c b/net/ethtool/strset.c
index 3f7de54d85fb..959a1b61e8e7 100644
--- a/net/ethtool/strset.c
+++ b/net/ethtool/strset.c
@@ -2,6 +2,7 @@
 
 #include <linux/ethtool.h>
 #include <linux/phy.h>
+#include <net/ulp_ddp_caps.h>
 #include "netlink.h"
 #include "common.h"
 
@@ -105,6 +106,16 @@ static const struct strset_info info_template[] = {
 		.count		= __ETHTOOL_A_STATS_RMON_CNT,
 		.strings	= stats_rmon_names,
 	},
+	[ETH_SS_ULP_DDP_CAPS] = {
+		.per_dev	= false,
+		.count		= ULP_DDP_C_COUNT,
+		.strings	= ulp_ddp_caps_names,
+	},
+	[ETH_SS_ULP_DDP_STATS] = {
+		.per_dev	= false,
+		.count		= __ETHTOOL_A_ULP_DDP_STATS_CNT,
+		.strings	= ulp_ddp_stats_names,
+	},
 };
 
 struct strset_req_info {
-- 
2.31.1

