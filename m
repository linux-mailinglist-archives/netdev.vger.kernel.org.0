Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3353C1BB4DE
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 05:56:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726431AbgD1D4I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 23:56:08 -0400
Received: from mail-db8eur05on2040.outbound.protection.outlook.com ([40.107.20.40]:30783
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725917AbgD1D4H (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Apr 2020 23:56:07 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O0aRy0OD64EfzzsoGVoufnsAWaqm4ywA6BwV5cFZ/KbGvSKxA0DFaztLHsVl108rpI2lzW5eyyYFx9V3gcKSIY3jrQIJqH1Tfp+/sxtj5QvXJjHEOfzoLDSiLB9Z0d229aAOhe6mP9R62DExb6RpsuOEOD0boA+lJnOiKGxxps7iDp0L/vnvhVYdGGlaMVwIQlJ1IPenwHqTkEUVDyIK43H4vpcwmCrhIsz0f4ruTWv0OhcJunA7P02pLpG3CUlpwraojvppQFz6e5s+0lF2jCWMMvehsdWeCQoH8EBmanOnqcndoR57uf/e7cYvp1iieWWEWlG1kTn4T8IUI7kx/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m6o32I+dZ9zebhm5fx0w4+Xp6sZ5xhXmBHYYZZv9Kcg=;
 b=gVRDxZHY9JZ8lPV5lEoFNxLwOJy+OBUwyM14O40KHJ+xRHhBK+4y8kFVfGUQyLt2rg6R4qag6VPRmkys7btdiOxLiui19DriPCk77MCecPEiFH38r6KjZpwhVF4xgBIGm0nVjMFBB3rUBfLlx2hozbxg2n5PpFciJQOx21ByTwW3Y1tjv5catSPo4IKeYuICce1O5GDIM0nBgeBHI+Q45t/si0FF9eizRsw4k00Oj88eTNAgDLfaKbRxIWs/1nc1E2nDKybJKpmVB5SuqEdMCH962f4t8aME0YO9VYhKskmivsHo0wFghy6wOZQLsOdpFFpKFVTorzjFjGih5/Chbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m6o32I+dZ9zebhm5fx0w4+Xp6sZ5xhXmBHYYZZv9Kcg=;
 b=mvmI69NRK2+2QNLRQSKxvvcNT5BMDrwEh200TLob16YxaUsrAEaFAyPnHKVko8uOjq39KRAgi3A+4uU3LPja1hYBvnjsBzHtWRj69Jo00mPuJRd9Tqwe1HhYgWdnV0ZWtJO66IJ3gdpjKcNGzACEGlRtE6uy2xe7jKiW9h7Gd6M=
Authentication-Results: spf=none (sender IP is ) smtp.mailfrom=po.liu@nxp.com; 
Received: from VE1PR04MB6496.eurprd04.prod.outlook.com (2603:10a6:803:11c::29)
 by VE1PR04MB6445.eurprd04.prod.outlook.com (2603:10a6:803:11c::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.22; Tue, 28 Apr
 2020 03:56:03 +0000
Received: from VE1PR04MB6496.eurprd04.prod.outlook.com
 ([fe80::1479:38ea:d4f7:a173]) by VE1PR04MB6496.eurprd04.prod.outlook.com
 ([fe80::1479:38ea:d4f7:a173%7]) with mapi id 15.20.2937.023; Tue, 28 Apr 2020
 03:56:03 +0000
From:   Po Liu <Po.Liu@nxp.com>
To:     davem@davemloft.net, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     vinicius.gomes@intel.com, po.liu@nxp.com, claudiu.manoil@nxp.com,
        vladimir.oltean@nxp.com, alexandru.marginean@nxp.com,
        michael.chan@broadcom.com, vishal@chelsio.com, saeedm@mellanox.com,
        leon@kernel.org, jiri@mellanox.com, idosch@mellanox.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        kuba@kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        simon.horman@netronome.com, pablo@netfilter.org,
        moshe@mellanox.com, m-karicheri2@ti.com,
        andre.guedes@linux.intel.com, stephen@networkplumber.org,
        Po Liu <Po.Liu@nxp.com>
Subject: [v4,net-next  3/4] net: enetc: add hw tc hw offload features for PSPF capability
Date:   Tue, 28 Apr 2020 11:34:52 +0800
Message-Id: <20200428033453.28100-4-Po.Liu@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200428033453.28100-1-Po.Liu@nxp.com>
References: <20200422024852.23224-5-Po.Liu@nxp.com>
 <20200428033453.28100-1-Po.Liu@nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: SG2PR04CA0198.apcprd04.prod.outlook.com
 (2603:1096:4:14::36) To VE1PR04MB6496.eurprd04.prod.outlook.com
 (2603:10a6:803:11c::29)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.73) by SG2PR04CA0198.apcprd04.prod.outlook.com (2603:1096:4:14::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13 via Frontend Transport; Tue, 28 Apr 2020 03:55:55 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [119.31.174.73]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 70b4e16a-fe56-44cf-ee84-08d7eb2811d1
X-MS-TrafficTypeDiagnostic: VE1PR04MB6445:|VE1PR04MB6445:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VE1PR04MB64452AD1A216019779C2858692AC0@VE1PR04MB6445.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-Forefront-PRVS: 0387D64A71
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR04MB6496.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(396003)(136003)(39860400002)(366004)(346002)(6666004)(52116002)(478600001)(69590400007)(16526019)(1076003)(6506007)(81156014)(6486002)(8936002)(8676002)(316002)(5660300002)(186003)(86362001)(956004)(2906002)(6512007)(66946007)(2616005)(66556008)(66476007)(7416002)(4326008)(36756003)(26005);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3ev/P2CCrYuub4ZoirJ+dZF66sy4pHbYwWwc+PcGdCQP9q2SgIHolx6YMsKwvdklXF4jP72J8R8xeia5e9jTz5gxEO/a2ehZq3oOJWNVg8aAgg1B2lGKjfXzFG/iqXFJfKsBITZOTT1C0mHrgRdaGnANITT6Gg55vKcLMWFG7h6VBMahmkQU2QvCkQ+CF+/4ujRUTcdHKWmwpA0ZxkzFPxOIcg6MfrLllsARft2WkWsc8FzINrtvFl1wCWEJawsEFjOn/q5iEa5Wkh+3oBzmIxqgCaNUY/s6wJo53iJUJRGEi/iPnMBbE56kiSE0Y2SnKuqPzvUnGRMtzfqxVC1ezVJsdMBvwmXeSJ2zoxZJgZYbs4mPIkx+MZzZtyixBDpmHEcukbQ89gTz4WYP5WgEgz2NjpGe2v6J6L1k8rSKUlVsf+XJjbKyBEGDDwQcwlp/UHm9nS3UuY1LD/oFzOyPYsWt4Ckdd9W6vbLRqoRRoBF1ifJPnq+G31AXQps5EouV
X-MS-Exchange-AntiSpam-MessageData: j7yL/R3TcK461GnpVxCdX9f11mi6wqQtySUvCmGpRnJsyWuz7Tv3YrKJ0Jejc6+3qUYknqFO1JTaMBFtyV4R0Pkh4RhJvf6RQnSRIS/MBH+HSq4fU1SnNZN3bKB4AMaHrQPl+oxlGbArcFWUnAfktW2TLY5s5y1nmW1pi3695zoG7Xks3I1rwtf/tztPbg2KCR4dr1MOxjdYBk+wRKcG3WkePphcqpJQ+P3gSeTc37Hz9uCmRs6+jjE0fRpz3FtkmDA59uReVqdcX+tMlLs21w/YaI2HSPSo+oBziNvV5bzlmk/Ypdb048oYm+EvriC3hgesh4OyfwLmDF9FDtlMJxFLwkVIvy9QjFDHM4zNbgdY4+jrc/9cL/9VS53JvG9hdfs3oKeYudwTIrHRehEZHqLRkKFFdXT3ps0z47suTCkYWf7foCgOravXqs2DnvwDGQG1J7OBFPMNyaXyBS/BzY4p2OzmvZEC3g+mRMX5fY/7rp7MgW+Fw6i5unXbR7T+SdhjFQe3aU+Zh65gQQ2PBHG6FkNxcJPXr6LuZ3YGh9g/H8VOSWRva0OE7wbFHeRGjN1BQLx34IysxXIIh/1ER+woi4Gbo7g9ZCkv/Kt1x+ZhwwQKDxiyJq3v4awdFFUhGXeXsWrGPjDKza1Rgf0SqIE2zqEvYiJdJpJb9TA7rkfeOXJTM9ukUa8Ws9K9/BWUx60KD91Hg258/y00JS8zxAVy8rekD1TxV6jA2WGifKF/hKppjt8yMkLiXixhNQONkfw6gsRhAvc/et2SH0eqR5Ix48q0HEqznxSpQ50ZpAc=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 70b4e16a-fe56-44cf-ee84-08d7eb2811d1
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2020 03:56:02.9772
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8yKqALg+WIUp7mkTZsTbYCsTz7RtVD8Zg7hKJw7XccAfkvcgqS2DoUQtuaLqTPm2
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6445
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch is to let ethtool enable/disable the tc flower offload
features. Hardware ENETC has the feature of PSFP which is for per-stream
policing. When enable the tc hw offloading feature, driver would enable
the IEEE 802.1Qci feature. It is only set the register enable bit for
this feature not enable for any entry of per stream filtering and stream
gate or stream identify but get how much capabilities for each feature.

Signed-off-by: Po Liu <Po.Liu@nxp.com>
---
 drivers/net/ethernet/freescale/enetc/enetc.c  | 23 +++++++++
 drivers/net/ethernet/freescale/enetc/enetc.h  | 48 +++++++++++++++++++
 .../net/ethernet/freescale/enetc/enetc_hw.h   | 17 +++++++
 .../net/ethernet/freescale/enetc/enetc_pf.c   |  8 ++++
 4 files changed, 96 insertions(+)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index ccf2611f4a20..04aac7cbb506 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -756,6 +756,9 @@ void enetc_get_si_caps(struct enetc_si *si)
 
 	if (val & ENETC_SIPCAPR0_QBV)
 		si->hw_features |= ENETC_SI_F_QBV;
+
+	if (val & ENETC_SIPCAPR0_PSFP)
+		si->hw_features |= ENETC_SI_F_PSFP;
 }
 
 static int enetc_dma_alloc_bdr(struct enetc_bdr *r, size_t bd_size)
@@ -1567,6 +1570,23 @@ static int enetc_set_rss(struct net_device *ndev, int en)
 	return 0;
 }
 
+static int enetc_set_psfp(struct net_device *ndev, int en)
+{
+	struct enetc_ndev_priv *priv = netdev_priv(ndev);
+
+	if (en) {
+		priv->active_offloads |= ENETC_F_QCI;
+		enetc_get_max_cap(priv);
+		enetc_psfp_enable(&priv->si->hw);
+	} else {
+		priv->active_offloads &= ~ENETC_F_QCI;
+		memset(&priv->psfp_cap, 0, sizeof(struct psfp_cap));
+		enetc_psfp_disable(&priv->si->hw);
+	}
+
+	return 0;
+}
+
 int enetc_set_features(struct net_device *ndev,
 		       netdev_features_t features)
 {
@@ -1575,6 +1595,9 @@ int enetc_set_features(struct net_device *ndev,
 	if (changed & NETIF_F_RXHASH)
 		enetc_set_rss(ndev, !!(features & NETIF_F_RXHASH));
 
+	if (changed & NETIF_F_HW_TC)
+		enetc_set_psfp(ndev, !!(features & NETIF_F_HW_TC));
+
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/freescale/enetc/enetc.h b/drivers/net/ethernet/freescale/enetc/enetc.h
index 56c43f35b633..2cfe877c3778 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.h
+++ b/drivers/net/ethernet/freescale/enetc/enetc.h
@@ -151,6 +151,7 @@ enum enetc_errata {
 };
 
 #define ENETC_SI_F_QBV BIT(0)
+#define ENETC_SI_F_PSFP BIT(1)
 
 /* PCI IEP device data */
 struct enetc_si {
@@ -203,12 +204,20 @@ struct enetc_cls_rule {
 };
 
 #define ENETC_MAX_BDR_INT	2 /* fixed to max # of available cpus */
+struct psfp_cap {
+	u32 max_streamid;
+	u32 max_psfp_filter;
+	u32 max_psfp_gate;
+	u32 max_psfp_gatelist;
+	u32 max_psfp_meter;
+};
 
 /* TODO: more hardware offloads */
 enum enetc_active_offloads {
 	ENETC_F_RX_TSTAMP	= BIT(0),
 	ENETC_F_TX_TSTAMP	= BIT(1),
 	ENETC_F_QBV             = BIT(2),
+	ENETC_F_QCI		= BIT(3),
 };
 
 struct enetc_ndev_priv {
@@ -231,6 +240,8 @@ struct enetc_ndev_priv {
 
 	struct enetc_cls_rule *cls_rules;
 
+	struct psfp_cap psfp_cap;
+
 	struct device_node *phy_node;
 	phy_interface_t if_mode;
 };
@@ -289,9 +300,46 @@ int enetc_setup_tc_taprio(struct net_device *ndev, void *type_data);
 void enetc_sched_speed_set(struct net_device *ndev);
 int enetc_setup_tc_cbs(struct net_device *ndev, void *type_data);
 int enetc_setup_tc_txtime(struct net_device *ndev, void *type_data);
+
+static inline void enetc_get_max_cap(struct enetc_ndev_priv *priv)
+{
+	u32 reg;
+
+	reg = enetc_port_rd(&priv->si->hw, ENETC_PSIDCAPR);
+	priv->psfp_cap.max_streamid = reg & ENETC_PSIDCAPR_MSK;
+	/* Port stream filter capability */
+	reg = enetc_port_rd(&priv->si->hw, ENETC_PSFCAPR);
+	priv->psfp_cap.max_psfp_filter = reg & ENETC_PSFCAPR_MSK;
+	/* Port stream gate capability */
+	reg = enetc_port_rd(&priv->si->hw, ENETC_PSGCAPR);
+	priv->psfp_cap.max_psfp_gate = (reg & ENETC_PSGCAPR_SGIT_MSK);
+	priv->psfp_cap.max_psfp_gatelist = (reg & ENETC_PSGCAPR_GCL_MSK) >> 16;
+	/* Port flow meter capability */
+	reg = enetc_port_rd(&priv->si->hw, ENETC_PFMCAPR);
+	priv->psfp_cap.max_psfp_meter = reg & ENETC_PFMCAPR_MSK;
+}
+
+static inline void enetc_psfp_enable(struct enetc_hw *hw)
+{
+	enetc_wr(hw, ENETC_PPSFPMR, enetc_rd(hw, ENETC_PPSFPMR) |
+		 ENETC_PPSFPMR_PSFPEN | ENETC_PPSFPMR_VS |
+		 ENETC_PPSFPMR_PVC | ENETC_PPSFPMR_PVZC);
+}
+
+static inline void enetc_psfp_disable(struct enetc_hw *hw)
+{
+	enetc_wr(hw, ENETC_PPSFPMR, enetc_rd(hw, ENETC_PPSFPMR) &
+		 ~ENETC_PPSFPMR_PSFPEN & ~ENETC_PPSFPMR_VS &
+		 ~ENETC_PPSFPMR_PVC & ~ENETC_PPSFPMR_PVZC);
+}
 #else
 #define enetc_setup_tc_taprio(ndev, type_data) -EOPNOTSUPP
 #define enetc_sched_speed_set(ndev) (void)0
 #define enetc_setup_tc_cbs(ndev, type_data) -EOPNOTSUPP
 #define enetc_setup_tc_txtime(ndev, type_data) -EOPNOTSUPP
+#define enetc_get_max_cap(p)		\
+	memset(&((p)->psfp_cap), 0, sizeof(struct psfp_cap))
+
+#define enetc_psfp_enable(hw) (void)0
+#define enetc_psfp_disable(hw) (void)0
 #endif
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_hw.h b/drivers/net/ethernet/freescale/enetc/enetc_hw.h
index 2a6523136947..587974862f48 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_hw.h
+++ b/drivers/net/ethernet/freescale/enetc/enetc_hw.h
@@ -19,6 +19,7 @@
 #define ENETC_SICTR1	0x1c
 #define ENETC_SIPCAPR0	0x20
 #define ENETC_SIPCAPR0_QBV	BIT(4)
+#define ENETC_SIPCAPR0_PSFP	BIT(9)
 #define ENETC_SIPCAPR0_RSS	BIT(8)
 #define ENETC_SIPCAPR1	0x24
 #define ENETC_SITGTGR	0x30
@@ -228,6 +229,15 @@ enum enetc_bdr_type {TX, RX};
 #define ENETC_PM0_IFM_RLP	(BIT(5) | BIT(11))
 #define ENETC_PM0_IFM_RGAUTO	(BIT(15) | ENETC_PMO_IFM_RG | BIT(1))
 #define ENETC_PM0_IFM_XGMII	BIT(12)
+#define ENETC_PSIDCAPR		0x1b08
+#define ENETC_PSIDCAPR_MSK	GENMASK(15, 0)
+#define ENETC_PSFCAPR		0x1b18
+#define ENETC_PSFCAPR_MSK	GENMASK(15, 0)
+#define ENETC_PSGCAPR		0x1b28
+#define ENETC_PSGCAPR_GCL_MSK	GENMASK(18, 16)
+#define ENETC_PSGCAPR_SGIT_MSK	GENMASK(15, 0)
+#define ENETC_PFMCAPR		0x1b38
+#define ENETC_PFMCAPR_MSK	GENMASK(15, 0)
 
 /* MAC counters */
 #define ENETC_PM0_REOCT		0x8100
@@ -621,3 +631,10 @@ struct enetc_cbd {
 /* Port time specific departure */
 #define ENETC_PTCTSDR(n)	(0x1210 + 4 * (n))
 #define ENETC_TSDE		BIT(31)
+
+/* PSFP setting */
+#define ENETC_PPSFPMR 0x11b00
+#define ENETC_PPSFPMR_PSFPEN BIT(0)
+#define ENETC_PPSFPMR_VS BIT(1)
+#define ENETC_PPSFPMR_PVC BIT(2)
+#define ENETC_PPSFPMR_PVZC BIT(3)
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_pf.c b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
index de1ad4975074..cef9fbfdb056 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_pf.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
@@ -727,6 +727,14 @@ static void enetc_pf_netdev_setup(struct enetc_si *si, struct net_device *ndev,
 	if (si->hw_features & ENETC_SI_F_QBV)
 		priv->active_offloads |= ENETC_F_QBV;
 
+	if (si->hw_features & ENETC_SI_F_PSFP) {
+		priv->active_offloads |= ENETC_F_QCI;
+		ndev->features |= NETIF_F_HW_TC;
+		ndev->hw_features |= NETIF_F_HW_TC;
+		enetc_get_max_cap(priv);
+		enetc_psfp_enable(&si->hw);
+	}
+
 	/* pick up primary MAC address from SI */
 	enetc_get_primary_mac_addr(&si->hw, ndev->dev_addr);
 }
-- 
2.17.1

