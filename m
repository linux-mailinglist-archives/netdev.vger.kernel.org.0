Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACD7D67386E
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 13:29:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230329AbjASM3B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 07:29:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230240AbjASM16 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 07:27:58 -0500
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-ve1eur01on2079.outbound.protection.outlook.com [40.107.14.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D746C45F75;
        Thu, 19 Jan 2023 04:27:53 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ehAY7P05XeWdYOQ7wfTRY5KwhpPrwgqRsy7JcUD5uTIjEnS8zqmTfbwvTj7A10jbBbr7sfr4SofjhSETQiI+2Jj/WqrvXmhKLo0RyxYuUP7FW3o35TIB+gIQzIE4YEbiSvCd58pgz7Y6odT89yJREYEI4TS/oV7fp8FGPPA6dadj7bqTLHTygOmrAc3PLWqi2rj4NtP/hjndJ1NeufEv76kK+A8YwZWIZ8T3/LXTyKGgRhk1TwkcPf5HItM0oJdKeQ5UykoB8rdG+icaoLb8CKbhXKx2AvoCGb4dg4JYvl0FL6rznfzDuU20b1ZHXG0uZSwIMvON6GoN0C5yeK2l0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=si+H5qi4gV2od/wVwdQ6vXelbErQn1IhBuuyhQbQ7KY=;
 b=mAO7ZQ15vgX4I+ZXfhgj5imJ4lJah1MgTv75iNAG3N3wmFKa3zagZI7CAkxf1HY8tej+ux/b+1nM3pPgV7uXEogImHIjgrJgnqkmxwq4XPnokJJn3yR5JAJKbbLtL78sryiL1J0nFjtE3lAoHDdCxa2ygSFTNmps7TVD2grnVHZ8nPEkvD8Ikp1QMU6+5w2xAtOyu75FLJVNtOHoM5XctEjrO0/TXHW+UkPTbKTjKrN/eP9daJwCGqBEsRIMj8giy/KO5RXSEtLknFVT5WLl9moD5IICFuc/741I9Wb01IhsRtiTns6yBAQqrbMM9MYZT0xYnto5q8ZEEbokLqUXYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=si+H5qi4gV2od/wVwdQ6vXelbErQn1IhBuuyhQbQ7KY=;
 b=Ln5nirgqmd9BH1brUKMTtcnNrN3zANrUhRzkP8AI8gKzVZ6JhWSDLvA1+z9rZg/wDaqsnH5NRVJGvVCbX/9ahxWaHZctwvsn7OFixf4p1Tm8W+kKvSFou3nugukN4oginbQy93ujTIMuT5HiMxJFqjtyG6yp53owf4nXD4nEVEU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PAXPR04MB9376.eurprd04.prod.outlook.com (2603:10a6:102:2b2::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.24; Thu, 19 Jan
 2023 12:27:47 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%4]) with mapi id 15.20.6002.024; Thu, 19 Jan 2023
 12:27:47 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Michal Kubecek <mkubecek@suse.cz>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Rui Sousa <rui.sousa@nxp.com>,
        Ferenc Fejes <ferenc.fejes@ericsson.com>,
        Pranavi Somisetty <pranavi.somisetty@amd.com>,
        Harini Katakam <harini.katakam@amd.com>,
        Colin Foster <colin.foster@in-advantage.com>,
        UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH v4 net-next 04/12] net: ethtool: netlink: retrieve stats from multiple sources (eMAC, pMAC)
Date:   Thu, 19 Jan 2023 14:26:56 +0200
Message-Id: <20230119122705.73054-5-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230119122705.73054-1-vladimir.oltean@nxp.com>
References: <20230119122705.73054-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM8P189CA0020.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:218::25) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|PAXPR04MB9376:EE_
X-MS-Office365-Filtering-Correlation-Id: f2021e81-5527-4d64-3411-08dafa189243
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8ZqtNnpaRnE7Zlz9HtEhoZLbnhPNekZOWJzlWmNo15IEXjmxgLR4bK+Cpjk0oVI5aoW1SXxkYdJK5aTGUQIA5wRClK25xNz9Nw8zBMRN6vD6xK30pNliNFq5PxjQQ4iNw3Ecd1VgscN+eN1viM9lFeQ0KNWVCnkt3y9K28HSh58cZ3g7K0ML8yrWc+rPnscUE/UH2+1oSfK7xWITKopE7sCh5wQ5o2IjmOcHcYnHncGgUx6yWixSOFI3VCAMV7sSFDFltMaTW93PqRnq6joqg1vCvOwSXEfGSDZ1fr6wYKnm0Mank2avYxcEEsK4kpeEMXuYsLwqKM9upnjFETnjJJG8YHnQkSqz4LOsPpRx6TEKCZLp5Uu7rsP6F9QQfQ0AT7lah0HDwVDytvVliL/mqsKnOaOEf075b1qYtuj0xKDUpa+U4DEq3plRF89O3vq5qarIKWJ2y5l5jjFP1tVqN9pSzjBWACYw8Z16n2xXcbidhsttABWjfrgBJiFomdoFY9LycbsAbTHVFKn55QAkrVB4+9YoOKvVBnPQPmOmiYPlOPflEmy2kIq27PTrSvQanjojHyfyzCd4IWoM3VIAVNEiKiE7DnQpiFPFCVjc4XZemLhXYV60z+XtRu3khyZSELGLOHkVscECHXi+zb37EJkx6xlAr0xMB3mob/0wYdma750VnU9TSgPkj+WCvmglvDdTwA50dm9H2MwDi3PvZ1b0U6AIc7RXOLEXMlcN8IWF/eK5mZ2De1xXX6qeedWr
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(39860400002)(376002)(136003)(346002)(366004)(451199015)(6506007)(66946007)(66476007)(44832011)(30864003)(66556008)(7416002)(8936002)(5660300002)(2906002)(38350700002)(38100700002)(316002)(6666004)(54906003)(52116002)(86362001)(36756003)(4326008)(6486002)(478600001)(6916009)(41300700001)(8676002)(26005)(1076003)(6512007)(186003)(83380400001)(2616005)(309714004)(134885004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?CgHTQM2EQVeHnaRk1h548mr4OKIYHwa4ZaT57IN8cD3nLwl9ne+z8HLImNHR?=
 =?us-ascii?Q?UzRZPgdBFapW9InqJBsbyZnwkYjWLKNIG8+Ax93sKcNPW+CSfONKkPicAE8h?=
 =?us-ascii?Q?2brdB0jbxl2bEQNVuKQU4D1kcmVe4bBdZ73m3Ost3Cdc/q8SLhXvBBb/VCzM?=
 =?us-ascii?Q?hiex74wklbrqVKnO+g+JiU8m0iP4rwB0WYmpLt8/4mHZNtaG64OsP8foNSGN?=
 =?us-ascii?Q?mN/heRmhFuC20TdNa7U7lvdoPU/7ufzYJW7Gp4ViYcV4po6ff7gHKibkZ4AM?=
 =?us-ascii?Q?7uhdA7iLuG8U8kl0vT5NYkj7JEoGQf7R9i57fBD0lPKzGFUXRmMBfxbvRtTe?=
 =?us-ascii?Q?Ucuf74sTzNR3PefBPwDLYUCacGHRXHmtwjmBhNr+Q8TzYFrC6JOqfYy0/ivx?=
 =?us-ascii?Q?V7+h/WD2qnqv9/dskqLRgmPVFCs6w8exr19YAxEG22FlZAOTGmFlU9hiv/EE?=
 =?us-ascii?Q?EOUzYUAS7UYRRBH4gRySBpUOcw8IwH7KIwpzXKGGMThSkS0KdEhiccVulP/n?=
 =?us-ascii?Q?Ykkd8WbrYC9xEIrKbXwylTbAoBk27ZArWs5WKo5t5/hxT+Q64pn1Y71dfPP2?=
 =?us-ascii?Q?KZNGj8gNDaC+90fAerUay5KbUmlClY1pL20FyTtoZV/dv8ne9y++Ij5LavXv?=
 =?us-ascii?Q?2/1yQzPgTK6nQNXFjkXYZL5GfjXRR18McMwEBJ715qTVPNd17tVrXBPjTk7z?=
 =?us-ascii?Q?Qttz5MkAHBwtLjAMTt4WFwbJgQzq9InfniC5rfaxpGv3Y07/FyJs2KY8ZUvt?=
 =?us-ascii?Q?IWs9B5VUid/VVy48bzzqHH4ZSHvyb1MStow8ScyfXb6xpbwaLDmsZfPaL7/3?=
 =?us-ascii?Q?WZEv4+UIObP5SFY/bq7oUKXoRJJC9QUBCK8mZ/i10vgBfj84Rt6V3kipw3yO?=
 =?us-ascii?Q?8b5XcqwoezqAjBTdefoTsOSD9vToowFnraNpJQjuhw2XiIPuK4beC3Ur/hL4?=
 =?us-ascii?Q?suf+YCIPoEl4Dcl/WY33LImmH1APS/Ow9QN2tgrTR7ff7EXofaYEBQlGvBQD?=
 =?us-ascii?Q?Vm40nj/Pr0J5d5HjhepZVTNdPb+TQ3JEK/VYYWjiq9ESBHpL+hUpb1y46Ita?=
 =?us-ascii?Q?Jm//Dr+Wv5Qjg3FeV07P2xSA1VgEYwAAXeWU9eYEPylK7TJsT9yhgqQmaWTo?=
 =?us-ascii?Q?Wyh7OuL2jQWeOqfKqiPXfv2s/eBPEkNgqaPpvAGLj/w4YmMDyioT+hmHjORS?=
 =?us-ascii?Q?/2znnmc23S3ORU9tQ529rE9uWnEkTW+CiPfM1ulEBfx8Ucce+elWv45/EcPf?=
 =?us-ascii?Q?CUQPDor1xq3uCGBcmYLLP1U7E+q8OyhDKHuYO2oKdpiTjVuHE89k83pCO2en?=
 =?us-ascii?Q?dMOMv1hlbywg8N4slw9GwuJhjC+YhsykS7M9DweRVVTxD3eMLWVC0F+lkKYZ?=
 =?us-ascii?Q?oDmAfyEm6Vblac+/fQde4bG3309K5MEX00sdFiAcxupTLOA7TpERVEfZ7tGb?=
 =?us-ascii?Q?P7sLc3Oc5LXngQ+9B0c4O0ueyiFxIk27aufQmRot/uGcQ0MX3Blj/IGsDkF+?=
 =?us-ascii?Q?JPSKTjRNsaccZLO/RrmUrCvV4sMmZYP1CVT/zcMXOk7dBTZX1mRcQgiNlTQH?=
 =?us-ascii?Q?QR3vRQAWEoVrF0yzFHqIxQaBRyJNKB7zH+4NTNuT7fvuNjb5fvnisAqwVMkA?=
 =?us-ascii?Q?CQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f2021e81-5527-4d64-3411-08dafa189243
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2023 12:27:47.0445
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Qq7EyvffR6NEQa5hOBd8za8rE/iOxzX07MqU6k4JzjWy0W7nkMI2HbH0/tZBlsP6QD6tSDcA83nISnZomF0MOQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB9376
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

IEEE 802.3-2018 clause 99 defines a MAC Merge sublayer which contains an
Express MAC and a Preemptible MAC. Both MACs are hidden to higher and
lower layers and visible as a single MAC (packet classification to eMAC
or pMAC on TX is done based on priority; classification on RX is done
based on SFD).

For devices which support a MAC Merge sublayer, it is desirable to
retrieve individual packet counters from the eMAC and the pMAC, as well
as aggregate statistics (their sum).

Introduce a new ETHTOOL_A_STATS_SRC attribute which is part of the
policy of ETHTOOL_MSG_STATS_GET and, and an ETHTOOL_A_PAUSE_STATS_SRC
which is part of the policy of ETHTOOL_MSG_PAUSE_GET (accepted when
ETHTOOL_FLAG_STATS is set in the common ethtool header). Both of these
take values from enum ethtool_mac_stats_src, defaulting to "aggregate"
in the absence of the attribute.

Existing drivers do not need to pay attention to this enum which was
added to all driver-facing structures, just the ones which report the
MAC merge layer as supported.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v3->v4: s/Preemptable/Preemptible/
v2->v3:
- rename enum ethtool_stats_src to enum ethtool_mac_stats_src
- rename ETHTOOL_STATS_SRC_* to ETHTOOL_MAC_STATS_SRC_*
- change how __ethtool_dev_mm_supported() is implemented
v1->v2: patch is new (Jakub's suggestion)

 include/linux/ethtool.h              |  9 ++++++
 include/uapi/linux/ethtool.h         | 18 +++++++++++
 include/uapi/linux/ethtool_netlink.h |  3 ++
 net/ethtool/common.h                 |  2 ++
 net/ethtool/mm.c                     | 16 ++++++++++
 net/ethtool/netlink.h                |  4 +--
 net/ethtool/pause.c                  | 48 ++++++++++++++++++++++++++++
 net/ethtool/stats.c                  | 32 ++++++++++++++++++-
 8 files changed, 129 insertions(+), 3 deletions(-)

diff --git a/include/linux/ethtool.h b/include/linux/ethtool.h
index 37eba38da502..0ccba6612190 100644
--- a/include/linux/ethtool.h
+++ b/include/linux/ethtool.h
@@ -311,6 +311,7 @@ static inline void ethtool_stats_init(u64 *stats, unsigned int n)
  * via a more targeted API.
  */
 struct ethtool_eth_mac_stats {
+	enum ethtool_mac_stats_src src;
 	u64 FramesTransmittedOK;
 	u64 SingleCollisionFrames;
 	u64 MultipleCollisionFrames;
@@ -339,6 +340,7 @@ struct ethtool_eth_mac_stats {
  * via a more targeted API.
  */
 struct ethtool_eth_phy_stats {
+	enum ethtool_mac_stats_src src;
 	u64 SymbolErrorDuringCarrier;
 };
 
@@ -346,6 +348,7 @@ struct ethtool_eth_phy_stats {
  * via a more targeted API.
  */
 struct ethtool_eth_ctrl_stats {
+	enum ethtool_mac_stats_src src;
 	u64 MACControlFramesTransmitted;
 	u64 MACControlFramesReceived;
 	u64 UnsupportedOpcodesReceived;
@@ -353,6 +356,8 @@ struct ethtool_eth_ctrl_stats {
 
 /**
  * struct ethtool_pause_stats - statistics for IEEE 802.3x pause frames
+ * @src: input field denoting whether stats should be queried from the eMAC or
+ *	pMAC (if the MM layer is supported). To be ignored otherwise.
  * @tx_pause_frames: transmitted pause frame count. Reported to user space
  *	as %ETHTOOL_A_PAUSE_STAT_TX_FRAMES.
  *
@@ -366,6 +371,7 @@ struct ethtool_eth_ctrl_stats {
  *	from the standard.
  */
 struct ethtool_pause_stats {
+	enum ethtool_mac_stats_src src;
 	u64 tx_pause_frames;
 	u64 rx_pause_frames;
 };
@@ -417,6 +423,8 @@ struct ethtool_rmon_hist_range {
 
 /**
  * struct ethtool_rmon_stats - selected RMON (RFC 2819) statistics
+ * @src: input field denoting whether stats should be queried from the eMAC or
+ *	pMAC (if the MM layer is supported). To be ignored otherwise.
  * @undersize_pkts: Equivalent to `etherStatsUndersizePkts` from the RFC.
  * @oversize_pkts: Equivalent to `etherStatsOversizePkts` from the RFC.
  * @fragments: Equivalent to `etherStatsFragments` from the RFC.
@@ -432,6 +440,7 @@ struct ethtool_rmon_hist_range {
  * ranges is left to the driver.
  */
 struct ethtool_rmon_stats {
+	enum ethtool_mac_stats_src src;
 	u64 undersize_pkts;
 	u64 oversize_pkts;
 	u64 fragments;
diff --git a/include/uapi/linux/ethtool.h b/include/uapi/linux/ethtool.h
index 529a93696ab6..f7fba0dc87e5 100644
--- a/include/uapi/linux/ethtool.h
+++ b/include/uapi/linux/ethtool.h
@@ -711,6 +711,24 @@ enum ethtool_stringset {
 	ETH_SS_COUNT
 };
 
+/**
+ * enum ethtool_mac_stats_src - source of ethtool MAC statistics
+ * @ETHTOOL_MAC_STATS_SRC_AGGREGATE:
+ *	if device supports a MAC merge layer, this retrieves the aggregate
+ *	statistics of the eMAC and pMAC. Otherwise, it retrieves just the
+ *	statistics of the single (express) MAC.
+ * @ETHTOOL_MAC_STATS_SRC_EMAC:
+ *	if device supports a MM layer, this retrieves the eMAC statistics.
+ *	Otherwise, it retrieves the statistics of the single (express) MAC.
+ * @ETHTOOL_MAC_STATS_SRC_PMAC:
+ *	if device supports a MM layer, this retrieves the pMAC statistics.
+ */
+enum ethtool_mac_stats_src {
+	ETHTOOL_MAC_STATS_SRC_AGGREGATE,
+	ETHTOOL_MAC_STATS_SRC_EMAC,
+	ETHTOOL_MAC_STATS_SRC_PMAC,
+};
+
 /**
  * enum ethtool_module_power_mode_policy - plug-in module power mode policy
  * @ETHTOOL_MODULE_POWER_MODE_POLICY_HIGH: Module is always in high power mode.
diff --git a/include/uapi/linux/ethtool_netlink.h b/include/uapi/linux/ethtool_netlink.h
index 58af390823b0..ffb073c0dbb4 100644
--- a/include/uapi/linux/ethtool_netlink.h
+++ b/include/uapi/linux/ethtool_netlink.h
@@ -428,6 +428,7 @@ enum {
 	ETHTOOL_A_PAUSE_RX,				/* u8 */
 	ETHTOOL_A_PAUSE_TX,				/* u8 */
 	ETHTOOL_A_PAUSE_STATS,				/* nest - _PAUSE_STAT_* */
+	ETHTOOL_A_PAUSE_STATS_SRC,			/* u32 */
 
 	/* add new constants above here */
 	__ETHTOOL_A_PAUSE_CNT,
@@ -744,6 +745,8 @@ enum {
 
 	ETHTOOL_A_STATS_GRP,			/* nest - _A_STATS_GRP_* */
 
+	ETHTOOL_A_STATS_SRC,			/* u32 */
+
 	/* add new constants above here */
 	__ETHTOOL_A_STATS_CNT,
 	ETHTOOL_A_STATS_MAX = (__ETHTOOL_A_STATS_CNT - 1)
diff --git a/net/ethtool/common.h b/net/ethtool/common.h
index b1b9db810eca..28b8aaaf9bcb 100644
--- a/net/ethtool/common.h
+++ b/net/ethtool/common.h
@@ -54,4 +54,6 @@ int ethtool_get_module_info_call(struct net_device *dev,
 int ethtool_get_module_eeprom_call(struct net_device *dev,
 				   struct ethtool_eeprom *ee, u8 *data);
 
+bool __ethtool_dev_mm_supported(struct net_device *dev);
+
 #endif /* _ETHTOOL_COMMON_H */
diff --git a/net/ethtool/mm.c b/net/ethtool/mm.c
index 76b209ad53d2..809d196665c6 100644
--- a/net/ethtool/mm.c
+++ b/net/ethtool/mm.c
@@ -253,3 +253,19 @@ int ethnl_set_mm(struct sk_buff *skb, struct genl_info *info)
 	ethnl_parse_header_dev_put(&req_info);
 	return ret;
 }
+
+/* Returns whether a given device supports the MAC merge layer
+ * (has an eMAC and a pMAC). Must be called under rtnl_lock() and
+ * ethnl_ops_begin().
+ */
+bool __ethtool_dev_mm_supported(struct net_device *dev)
+{
+	const struct ethtool_ops *ops = dev->ethtool_ops;
+	struct ethtool_mm_state state = {};
+	int ret = -EOPNOTSUPP;
+
+	if (ops && ops->get_mm)
+		ret = ops->get_mm(dev, &state);
+
+	return !!ret;
+}
diff --git a/net/ethtool/netlink.h b/net/ethtool/netlink.h
index 60278485b00b..29aef39476eb 100644
--- a/net/ethtool/netlink.h
+++ b/net/ethtool/netlink.h
@@ -399,7 +399,7 @@ extern const struct nla_policy ethnl_channels_get_policy[ETHTOOL_A_CHANNELS_HEAD
 extern const struct nla_policy ethnl_channels_set_policy[ETHTOOL_A_CHANNELS_COMBINED_COUNT + 1];
 extern const struct nla_policy ethnl_coalesce_get_policy[ETHTOOL_A_COALESCE_HEADER + 1];
 extern const struct nla_policy ethnl_coalesce_set_policy[ETHTOOL_A_COALESCE_MAX + 1];
-extern const struct nla_policy ethnl_pause_get_policy[ETHTOOL_A_PAUSE_HEADER + 1];
+extern const struct nla_policy ethnl_pause_get_policy[ETHTOOL_A_PAUSE_STATS_SRC + 1];
 extern const struct nla_policy ethnl_pause_set_policy[ETHTOOL_A_PAUSE_TX + 1];
 extern const struct nla_policy ethnl_eee_get_policy[ETHTOOL_A_EEE_HEADER + 1];
 extern const struct nla_policy ethnl_eee_set_policy[ETHTOOL_A_EEE_TX_LPI_TIMER + 1];
@@ -410,7 +410,7 @@ extern const struct nla_policy ethnl_tunnel_info_get_policy[ETHTOOL_A_TUNNEL_INF
 extern const struct nla_policy ethnl_fec_get_policy[ETHTOOL_A_FEC_HEADER + 1];
 extern const struct nla_policy ethnl_fec_set_policy[ETHTOOL_A_FEC_AUTO + 1];
 extern const struct nla_policy ethnl_module_eeprom_get_policy[ETHTOOL_A_MODULE_EEPROM_I2C_ADDRESS + 1];
-extern const struct nla_policy ethnl_stats_get_policy[ETHTOOL_A_STATS_GROUPS + 1];
+extern const struct nla_policy ethnl_stats_get_policy[ETHTOOL_A_STATS_SRC + 1];
 extern const struct nla_policy ethnl_phc_vclocks_get_policy[ETHTOOL_A_PHC_VCLOCKS_HEADER + 1];
 extern const struct nla_policy ethnl_module_get_policy[ETHTOOL_A_MODULE_HEADER + 1];
 extern const struct nla_policy ethnl_module_set_policy[ETHTOOL_A_MODULE_POWER_MODE_POLICY + 1];
diff --git a/net/ethtool/pause.c b/net/ethtool/pause.c
index a8c113d244db..e2be9e89c9d9 100644
--- a/net/ethtool/pause.c
+++ b/net/ethtool/pause.c
@@ -5,8 +5,12 @@
 
 struct pause_req_info {
 	struct ethnl_req_info		base;
+	enum ethtool_mac_stats_src	src;
 };
 
+#define PAUSE_REQINFO(__req_base) \
+	container_of(__req_base, struct pause_req_info, base)
+
 struct pause_reply_data {
 	struct ethnl_reply_data		base;
 	struct ethtool_pauseparam	pauseparam;
@@ -19,13 +23,40 @@ struct pause_reply_data {
 const struct nla_policy ethnl_pause_get_policy[] = {
 	[ETHTOOL_A_PAUSE_HEADER]		=
 		NLA_POLICY_NESTED(ethnl_header_policy_stats),
+	[ETHTOOL_A_PAUSE_STATS_SRC]		=
+		NLA_POLICY_MAX(NLA_U32, ETHTOOL_MAC_STATS_SRC_PMAC),
 };
 
+static int pause_parse_request(struct ethnl_req_info *req_base,
+			       struct nlattr **tb,
+			       struct netlink_ext_ack *extack)
+{
+	enum ethtool_mac_stats_src src = ETHTOOL_MAC_STATS_SRC_AGGREGATE;
+	struct pause_req_info *req_info = PAUSE_REQINFO(req_base);
+
+	if (tb[ETHTOOL_A_PAUSE_STATS_SRC]) {
+		if (!(req_base->flags & ETHTOOL_FLAG_STATS)) {
+			NL_SET_ERR_MSG_MOD(extack,
+					   "ETHTOOL_FLAG_STATS must be set when requesting a source of stats");
+			return -EINVAL;
+		}
+
+		src = nla_get_u32(tb[ETHTOOL_A_PAUSE_STATS_SRC]);
+	}
+
+	req_info->src = src;
+
+	return 0;
+}
+
 static int pause_prepare_data(const struct ethnl_req_info *req_base,
 			      struct ethnl_reply_data *reply_base,
 			      struct genl_info *info)
 {
+	const struct pause_req_info *req_info = PAUSE_REQINFO(req_base);
 	struct pause_reply_data *data = PAUSE_REPDATA(reply_base);
+	enum ethtool_mac_stats_src src = req_info->src;
+	struct netlink_ext_ack *extack = info->extack;
 	struct net_device *dev = reply_base->dev;
 	int ret;
 
@@ -34,14 +65,26 @@ static int pause_prepare_data(const struct ethnl_req_info *req_base,
 
 	ethtool_stats_init((u64 *)&data->pausestat,
 			   sizeof(data->pausestat) / 8);
+	data->pausestat.src = src;
 
 	ret = ethnl_ops_begin(dev);
 	if (ret < 0)
 		return ret;
+
+	if ((src == ETHTOOL_MAC_STATS_SRC_EMAC ||
+	     src == ETHTOOL_MAC_STATS_SRC_PMAC) &&
+	    !__ethtool_dev_mm_supported(dev)) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Device does not support MAC merge layer");
+		ethnl_ops_complete(dev);
+		return -EOPNOTSUPP;
+	}
+
 	dev->ethtool_ops->get_pauseparam(dev, &data->pauseparam);
 	if (req_base->flags & ETHTOOL_FLAG_STATS &&
 	    dev->ethtool_ops->get_pause_stats)
 		dev->ethtool_ops->get_pause_stats(dev, &data->pausestat);
+
 	ethnl_ops_complete(dev);
 
 	return 0;
@@ -56,6 +99,7 @@ static int pause_reply_size(const struct ethnl_req_info *req_base,
 
 	if (req_base->flags & ETHTOOL_FLAG_STATS)
 		n += nla_total_size(0) +	/* _PAUSE_STATS */
+		     nla_total_size(sizeof(u32)) + /* _PAUSE_STATS_SRC */
 		     nla_total_size_64bit(sizeof(u64)) * ETHTOOL_PAUSE_STAT_CNT;
 	return n;
 }
@@ -77,6 +121,9 @@ static int pause_put_stats(struct sk_buff *skb,
 	const u16 pad = ETHTOOL_A_PAUSE_STAT_PAD;
 	struct nlattr *nest;
 
+	if (nla_put_u32(skb, ETHTOOL_A_PAUSE_STATS_SRC, pause_stats->src))
+		return -EMSGSIZE;
+
 	nest = nla_nest_start(skb, ETHTOOL_A_PAUSE_STATS);
 	if (!nest)
 		return -EMSGSIZE;
@@ -121,6 +168,7 @@ const struct ethnl_request_ops ethnl_pause_request_ops = {
 	.req_info_size		= sizeof(struct pause_req_info),
 	.reply_data_size	= sizeof(struct pause_reply_data),
 
+	.parse_request		= pause_parse_request,
 	.prepare_data		= pause_prepare_data,
 	.reply_size		= pause_reply_size,
 	.fill_reply		= pause_fill_reply,
diff --git a/net/ethtool/stats.c b/net/ethtool/stats.c
index a20e0a24ff61..26a70320e01d 100644
--- a/net/ethtool/stats.c
+++ b/net/ethtool/stats.c
@@ -7,6 +7,7 @@
 struct stats_req_info {
 	struct ethnl_req_info		base;
 	DECLARE_BITMAP(stat_mask, __ETHTOOL_STATS_CNT);
+	enum ethtool_mac_stats_src	src;
 };
 
 #define STATS_REQINFO(__req_base) \
@@ -75,16 +76,19 @@ const char stats_rmon_names[__ETHTOOL_A_STATS_RMON_CNT][ETH_GSTRING_LEN] = {
 	[ETHTOOL_A_STATS_RMON_JABBER]		= "etherStatsJabbers",
 };
 
-const struct nla_policy ethnl_stats_get_policy[ETHTOOL_A_STATS_GROUPS + 1] = {
+const struct nla_policy ethnl_stats_get_policy[ETHTOOL_A_STATS_SRC + 1] = {
 	[ETHTOOL_A_STATS_HEADER]	=
 		NLA_POLICY_NESTED(ethnl_header_policy),
 	[ETHTOOL_A_STATS_GROUPS]	= { .type = NLA_NESTED },
+	[ETHTOOL_A_STATS_SRC]		=
+		NLA_POLICY_MAX(NLA_U32, ETHTOOL_MAC_STATS_SRC_PMAC),
 };
 
 static int stats_parse_request(struct ethnl_req_info *req_base,
 			       struct nlattr **tb,
 			       struct netlink_ext_ack *extack)
 {
+	enum ethtool_mac_stats_src src = ETHTOOL_MAC_STATS_SRC_AGGREGATE;
 	struct stats_req_info *req_info = STATS_REQINFO(req_base);
 	bool mod = false;
 	int err;
@@ -100,6 +104,11 @@ static int stats_parse_request(struct ethnl_req_info *req_base,
 		return -EINVAL;
 	}
 
+	if (tb[ETHTOOL_A_STATS_SRC])
+		src = nla_get_u32(tb[ETHTOOL_A_STATS_SRC]);
+
+	req_info->src = src;
+
 	return 0;
 }
 
@@ -109,6 +118,8 @@ static int stats_prepare_data(const struct ethnl_req_info *req_base,
 {
 	const struct stats_req_info *req_info = STATS_REQINFO(req_base);
 	struct stats_reply_data *data = STATS_REPDATA(reply_base);
+	enum ethtool_mac_stats_src src = req_info->src;
+	struct netlink_ext_ack *extack = info->extack;
 	struct net_device *dev = reply_base->dev;
 	int ret;
 
@@ -116,11 +127,25 @@ static int stats_prepare_data(const struct ethnl_req_info *req_base,
 	if (ret < 0)
 		return ret;
 
+	if ((src == ETHTOOL_MAC_STATS_SRC_EMAC ||
+	     src == ETHTOOL_MAC_STATS_SRC_PMAC) &&
+	    !__ethtool_dev_mm_supported(dev)) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Device does not support MAC merge layer");
+		ethnl_ops_complete(dev);
+		return -EOPNOTSUPP;
+	}
+
 	/* Mark all stats as unset (see ETHTOOL_STAT_NOT_SET) to prevent them
 	 * from being reported to user space in case driver did not set them.
 	 */
 	memset(&data->stats, 0xff, sizeof(data->stats));
 
+	data->phy_stats.src = src;
+	data->mac_stats.src = src;
+	data->ctrl_stats.src = src;
+	data->rmon_stats.src = src;
+
 	if (test_bit(ETHTOOL_STATS_ETH_PHY, req_info->stat_mask) &&
 	    dev->ethtool_ops->get_eth_phy_stats)
 		dev->ethtool_ops->get_eth_phy_stats(dev, &data->phy_stats);
@@ -146,6 +171,8 @@ static int stats_reply_size(const struct ethnl_req_info *req_base,
 	unsigned int n_grps = 0, n_stats = 0;
 	int len = 0;
 
+	len += nla_total_size(sizeof(u32)); /* _STATS_SRC */
+
 	if (test_bit(ETHTOOL_STATS_ETH_PHY, req_info->stat_mask)) {
 		n_stats += sizeof(struct ethtool_eth_phy_stats) / sizeof(u64);
 		n_grps++;
@@ -379,6 +406,9 @@ static int stats_fill_reply(struct sk_buff *skb,
 	const struct stats_reply_data *data = STATS_REPDATA(reply_base);
 	int ret = 0;
 
+	if (nla_put_u32(skb, ETHTOOL_A_STATS_SRC, req_info->src))
+		return -EMSGSIZE;
+
 	if (!ret && test_bit(ETHTOOL_STATS_ETH_PHY, req_info->stat_mask))
 		ret = stats_put_stats(skb, data, ETHTOOL_STATS_ETH_PHY,
 				      ETH_SS_STATS_ETH_PHY,
-- 
2.34.1

