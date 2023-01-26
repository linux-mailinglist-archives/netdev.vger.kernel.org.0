Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7FAF67D132
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 17:22:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232619AbjAZQWH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 11:22:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232667AbjAZQWE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 11:22:04 -0500
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2058.outbound.protection.outlook.com [40.107.100.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E468021970
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 08:22:00 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f/lSaKrAhb15IV+xu1EoakV2cKqvok/iBGTnnyLCU1woIPDHL0OpEGoUr+7J04SGQ0Ktly6+5wLbhhBKepWy4vFUaz629OgzE/dwOKfQLxpCFO8MFVe6dgcDBGdiWMebI/EfRbS6rzSNofDxE+SP5nWalIAAI6fX1pWU4VXIwfFCfzM1mF/NcYHjUS2JrTiz+8RLryUUoYLrXy5NGEGc0UKa3ziO16XAjT72PFFmpfjDJLbxG31qqfKixOjaudh61CgBGVs0vRXVxDvV1vyVTsolNGOlVbu+YIVOBF96UgUYq0MZ1STlt/P0X/u0Ljr8uT9sASjL8xW6hAxkOi1EIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aKjj9meYp/3nrEIZ8//od9CCx+EAq4q7EIsTdJ+x2ng=;
 b=SFJrQOKmwJ6Efpt0Nx3Q0cPC9qAP10oiy6tHGNjqo4Vvs8Ydbgqb41UJYtLOV7WDzAZ7pDtZyQXJCi6kOCh0d383HepbNb4CaKBCBK/9y1EiyK8FCDB6cwSPgPCyRH/w2qikK6AjIGBLI0+ELiwFVcANYUbsNhdmcyBXjGlxPPbeKiMsSbllLVRCZ0zwNCAZ3/N+XmEs89NOGlQM3tVknptpi8U7qA49h1abhAI8Wz/iAkDSqN75SrBYzp7QFzarL7lTfGGNgs4K5+KU4GVZ4d+eOzB0Y1ELW+civDHUQbPcPb3sVXQMu/Cbc9cavXq2lEBGGTrA+ZWMDB5qB5j9aQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aKjj9meYp/3nrEIZ8//od9CCx+EAq4q7EIsTdJ+x2ng=;
 b=ml80rGrJEjKK0WPuG4wptwL/jEAbv6MbhZYyv9gELPmHflACvep7XsO4nnm/qU7kmVIysT1ucIWPcYh2j1UzPdMcClDyWZNcyv/lwGvcTMwL1gsBQZnt1w3fz5NJWPkhUvYPFfMGqBNr7puYFli2VYNug5ft/RSkOs8xX05MK4nQXmZRgt0/I/Iblwx7ID0Hxr7s7JhFBSpFUQZNo11Aw+cNKLw9q3rT1qiahDU+7l7t4OcMObxhtkl63TvU7uh2wl1+OtQdPDZOEJ28Oore3ObHgEx3/i9tG0HGMRgkNrdWsIicJBE6y/f0d4/mn/HENFlj8L8WL9QH7o1tMaq9fA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com (2603:10b6:a03:45e::8)
 by SJ0PR12MB5422.namprd12.prod.outlook.com (2603:10b6:a03:3ac::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.22; Thu, 26 Jan
 2023 16:21:59 +0000
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::9fd9:dadc:4d8a:2d84]) by SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::9fd9:dadc:4d8a:2d84%6]) with mapi id 15.20.6043.022; Thu, 26 Jan 2023
 16:21:59 +0000
From:   Aurelien Aptel <aaptel@nvidia.com>
To:     linux-nvme@lists.infradead.org, netdev@vger.kernel.org,
        sagi@grimberg.me, hch@lst.de, kbusch@kernel.org, axboe@fb.com,
        chaitanyak@nvidia.com, davem@davemloft.net, kuba@kernel.org
Cc:     Aurelien Aptel <aaptel@nvidia.com>, aurelien.aptel@gmail.com,
        smalin@nvidia.com, malin1024@gmail.com, ogerlitz@nvidia.com,
        yorayz@nvidia.com, borisp@nvidia.com
Subject: [PATCH v10 02/25] net/ethtool: add new stringset ETH_SS_ULP_DDP_{CAPS,STATS}
Date:   Thu, 26 Jan 2023 18:21:13 +0200
Message-Id: <20230126162136.13003-3-aaptel@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230126162136.13003-1-aaptel@nvidia.com>
References: <20230126162136.13003-1-aaptel@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P265CA0268.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:37a::20) To SJ1PR12MB6075.namprd12.prod.outlook.com
 (2603:10b6:a03:45e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR12MB6075:EE_|SJ0PR12MB5422:EE_
X-MS-Office365-Filtering-Correlation-Id: f85ae1c8-d246-4745-48a8-08daffb97305
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EFey9dt5+dq9tJW6YP0u4kzjyBUSKrUzpRzeqjpKgY9YkpKkNEpGM43qXIxPk6PCuM+JbCHMmBL30hcjDdq1TPu2MyqzxHUG4pnx9KRdP66ZTOPy4sqz4Yoqnsp1iu0lGsvR3VNoU1TCmpH5IxHUa3xpiHSin42lQ81/U0iR5cbeDpooj8I+sgIuDALFgcNsp4m86uIYDxsbz4v1tJhy8Tq4MUsP9gB5ys0kAHGMd/d72QYcd9tfU6BIkJ9tOx6ONfYziZ24C6CI80uiA7g5nxPpOo+lOcmphxPIghqKP5hJyebLHH8zSBk2sT0tXukQsn+xnuk8SuE+UiEZbwrbhr6lF5F5n5PeaSMhPzbYsSSojxzbE6hdbLzU/kAuqoCurKnbQLTKL6L60QvWMbV/s6ZgwyRPZxl0Ij4EsMbHlLC0orfh8DDw2NvO3SGrgyyalrbi1STdq55XBPRnPb1PyiRKl1K0CBF7/nCy2euM5CUiQg1D62xZQdS8a9Ag/dcDMYmPszKwedpZSmIyuAcK4UEC0UWHp8uwuKxcvxEpx+keiXgKCklfkG1gF+hAR4JxrNLQ8bFaRbajhx0tYXQW4VaekBHYDKPJWcdhYPcnEWAMCFaXhClK5/Jd+ZHBljVxsMdDFlFNFyddH5D9c69z0Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR12MB6075.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(376002)(39860400002)(136003)(396003)(366004)(451199018)(316002)(38100700002)(41300700001)(8676002)(66556008)(66946007)(66476007)(4326008)(5660300002)(7416002)(36756003)(86362001)(8936002)(2906002)(6506007)(1076003)(26005)(6512007)(186003)(478600001)(6486002)(83380400001)(6666004)(107886003)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?EUZkoaNdDuAsi3PpxnR+KeMhOES5/xI1PmDznmuus9QqxX32TEdUy4Fwfy+H?=
 =?us-ascii?Q?O539GXeEsLgxVUVyCBDbwQeqr0foD64HW9YDG3dH03svuAeFlW7G/8Aui8Cm?=
 =?us-ascii?Q?xX4D+7m5ZYtdF9P/BFYbNguR4Yp0qqQJAxH5Rg2yPk7cRh0GDoPPsusSl1te?=
 =?us-ascii?Q?KTTxwYk4Og4nYWNrKwsomBORPvMskK76BLVk0ucGM+se7hA4y+Iym0xRW+wy?=
 =?us-ascii?Q?jjlvfsSRQXpRqwCHTMRd0zBfx4EnZU0b98u1xtuu55y0e7KgfdnjqkYjw2ys?=
 =?us-ascii?Q?ODcTDIcUq4ddrFJoNx1h2tqJAx0KwAf579xftmKJrQJIsSPsQqHsoHKWzV/z?=
 =?us-ascii?Q?bi4Ppw80ev/8yZS9DfQRUrnyqQ0J4ysST0lJTkiOS+j1E6hGrwZSqMT1Y+4H?=
 =?us-ascii?Q?k2jYRGtT+7VrY0QiL83lPMMRK89yqg8te/X+L5y/FhDef2qvKzFKFSx4OFyf?=
 =?us-ascii?Q?2B0kPOFzKZ/DVVPj4xnz2h0+IcYWJ7vZFoU4Sv9TMXy3rm+ClceMFg50OkS3?=
 =?us-ascii?Q?ztI2/smBhrMta/bu3f3yRatOHQ1L0HoOVv+9N63xZAmduqonOS0G2rk2yF08?=
 =?us-ascii?Q?fsGll2nhx2N9cIC64EkbtugwntwQzAFsgj0p5ZlpJBqtaM2Yi5zPq3uJ9kf2?=
 =?us-ascii?Q?urjcNciYPKaycI1sZ1gZ7s7B/HGWtojpXuLISvgcJfz3Ao5Dl/RWzJtSz0Uc?=
 =?us-ascii?Q?NRQgEaioSIo7bJGT6KYphliDSaANSQiFC/QudmoFMdT0XnKe50sWAhZQgUxK?=
 =?us-ascii?Q?4IKeHA/FAQbZd5/SNsptKoZirHypM8JqUA1P2GK/gPKG0Fu7qT7A8oHOiq6C?=
 =?us-ascii?Q?OdejpMZY9aAVWXBYfe41t+OD3UBD2X0zupOZk1XW5TzWX1KDgQBAIPK0w7Yh?=
 =?us-ascii?Q?fki/Dbyssgc3z7TdkiyTXSqx4cpyl9phOl/Jag8Y2/Kxr7ngywQTGTqAlDHO?=
 =?us-ascii?Q?3mKlnOr8Xa42rT3Qgtfi/R7RN8XE5PqR6x5PYBdA0m/gipryq88J2IxfqbgL?=
 =?us-ascii?Q?tt7v/mtLan8Bpm1ENZIKuOFr9pKB5cWlYRXthE9IfSGvEji1JW2WYnup+39K?=
 =?us-ascii?Q?pY08SKx+N384VoLKESffoXW6CMdMyisdD+PPTDqNrcrjJdc+6HOSQEQfuI4n?=
 =?us-ascii?Q?jI3lfU6hyfTF/ePH531MMGBKUF+36ZISjn64IOuCMYTmdMCXicBMYiuOQQeu?=
 =?us-ascii?Q?Sx6U8RwC4iu595S0/fVwxdNeGtTSX6e1hjcYfvNKdkDRSCXzBvQ7nQpvgQtu?=
 =?us-ascii?Q?J1SGAFAySjJ2JxAEdCq3SDR753XL/VN6j+3hUHmCpWtMyH9eHIEHN8r131jl?=
 =?us-ascii?Q?6+2+7Bfv/7HHxEbjlfpCF901dD2Fy52gp5TkJ22YRuvP6pzlReihbrSq8E+C?=
 =?us-ascii?Q?jLyKxNMHsxUpDlRquTpJ5lz5bTyziXIyDkAW8GhabA8cryxopntTSpDkbRoV?=
 =?us-ascii?Q?L4jk3UrK3C/BZe8b+PS3l1MkOQ1t4A8U2rnXTpA4gZagF93mOXJedPiRaGZf?=
 =?us-ascii?Q?T0GX4OH4Yqwy7rFjWygldXELj9g0MkM1lQDDelAREGFnINGx0ZZwvzCMGyTz?=
 =?us-ascii?Q?niqhMJ98w1cWZ4EObJzv9RFRJZHrtwCCpp0lcFC/?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f85ae1c8-d246-4745-48a8-08daffb97305
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR12MB6075.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2023 16:21:59.1666
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: j5Wmd/tvR27kI99CefxmTvhCArxuiTPJYRIYZ+Au/UIhP8VpZuHtRsRPqpHpgk9eXa0M5oDxrdLK2opGl6u6Mw==
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
 include/uapi/linux/ethtool_netlink.h | 20 +++++++++++++++++
 net/ethtool/common.c                 | 22 +++++++++++++++++++
 net/ethtool/common.h                 |  2 ++
 net/ethtool/strset.c                 | 11 ++++++++++
 6 files changed, 91 insertions(+)

diff --git a/include/linux/ethtool.h b/include/linux/ethtool.h
index 6a8253d3fea8..5f0962ce52c5 100644
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
index ffb073c0dbb4..14a1858fd106 100644
--- a/include/uapi/linux/ethtool_netlink.h
+++ b/include/uapi/linux/ethtool_netlink.h
@@ -972,6 +972,26 @@ enum {
 	ETHTOOL_A_MM_MAX = (__ETHTOOL_A_MM_CNT - 1)
 };
 
+/* ULP DDP */
+
+enum {
+	ETHTOOL_A_ULP_DDP_STATS_UNSPEC,
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
index 5fb19050991e..ae4b1e38cf8e 100644
--- a/net/ethtool/common.c
+++ b/net/ethtool/common.c
@@ -5,6 +5,7 @@
 #include <linux/phy.h>
 #include <linux/rtnetlink.h>
 #include <linux/ptp_clock_kernel.h>
+#include <net/ulp_ddp_caps.h>
 
 #include "common.h"
 
@@ -465,6 +466,27 @@ const char udp_tunnel_type_names[][ETH_GSTRING_LEN] = {
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

