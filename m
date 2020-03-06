Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC4AC17BDEE
	for <lists+netdev@lfdr.de>; Fri,  6 Mar 2020 14:15:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727138AbgCFNPP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Mar 2020 08:15:15 -0500
Received: from mail-eopbgr70075.outbound.protection.outlook.com ([40.107.7.75]:25537
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726054AbgCFNPP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Mar 2020 08:15:15 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gOmHHMYMruqN9Xs8d76w725rs8xlRzrv4PQqseODTPwMiD2tr66pBw73Pkrb6fhqkohuZTTJpB8uJkIhQkGxtnSOKVy1pIEzpnG7QIhkC9eQG+5yXo2Pxrl8xAJmk1xK8RYWTIXpC9cymbWwHNJUHnZudK3i8jPCj8+mZoHKkhfNza6dFwRm7fKIqzVQEWtygsZ+pQRcFmDHllTemQ9LpuF8FR9KXyVXQxW1Pk4exkn3kADiOwIL9NAfR+OTjougYq7RRpEO6yD8iUxHPqSK4Sa6pMroXS8iIupiJXBtXB3TbRQb6iyeI1oY025+EIS4uiEfL5IISvuRdwzxUG5Ukw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iGOeGzBMg1jMDgF4RlMUfc9N1aO4t575OSXc5MEesaQ=;
 b=iqwo9M6PI2fXlnjMcm2BBX0zKjiPYqviwO4IS6D2KQOqvNBFo46CaSOF8AB0khAMX2cBxTmR0CWjq1EQys3qEu05QnoYw4vPNIfmBZgcQwrPbQISMcoUZNAE64+Re/91zPYWxKFJZFHgUBv6TiEajgEwLtN+rRPVda4i5kuNhBlWxBO3pgQMI7Wn1Zwlo/oMjnA31zG7fb8dyq00QGOO3Zgyt8FgDqzMOIzCmsODigUACPgkg/PJmw7cGcEimfCYyv5cAcO0mfqjlmxYKP5JG4My0XzUNaJaURHBLiz2fbDDuV1NOcGH8vJbuCFhPquAn3HT02EzmPrJzqRcY/bycQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iGOeGzBMg1jMDgF4RlMUfc9N1aO4t575OSXc5MEesaQ=;
 b=IuBZ40r9tUxVYi2itXvAW+hxycApM5a0Wwa57/Ip+uTd4jFFitRQMZ7PaZleO0vQdYKICsp+uzGU11s1SNzXYfrUo1v+igP0lN5FJo+DekJy8Up92j4yEeaVV9hpNxsmju4CQE61m3Uyy60Xcmp3pkhGklay3GX26DTsUGaK6nQ=
Authentication-Results: spf=none (sender IP is ) smtp.mailfrom=po.liu@nxp.com; 
Received: from VE1PR04MB6496.eurprd04.prod.outlook.com (20.179.232.221) by
 VE1PR04MB6718.eurprd04.prod.outlook.com (20.179.234.221) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2793.16; Fri, 6 Mar 2020 13:15:11 +0000
Received: from VE1PR04MB6496.eurprd04.prod.outlook.com
 ([fe80::8cb8:5c41:d843:b66d]) by VE1PR04MB6496.eurprd04.prod.outlook.com
 ([fe80::8cb8:5c41:d843:b66d%5]) with mapi id 15.20.2772.019; Fri, 6 Mar 2020
 13:15:11 +0000
From:   Po Liu <Po.Liu@nxp.com>
To:     davem@davemloft.net, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     vinicius.gomes@intel.com, po.liu@nxp.com, claudiu.manoil@nxp.com,
        vladimir.oltean@nxp.com, alexandru.marginean@nxp.com,
        xiaoliang.yang_1@nxp.com, roy.zang@nxp.com, mingkai.hu@nxp.com,
        jerry.huang@nxp.com, leoyang.li@nxp.com, michael.chan@broadcom.com,
        vishal@chelsio.com, saeedm@mellanox.com, leon@kernel.org,
        jiri@mellanox.com, idosch@mellanox.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        kuba@kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        john.hurley@netronome.com, simon.horman@netronome.com,
        pieter.jansenvanvuuren@netronome.com, pablo@netfilter.org,
        moshe@mellanox.com, ivan.khoronzhuk@linaro.org,
        m-karicheri2@ti.com, andre.guedes@linux.intel.com,
        jakub.kicinski@netronome.com, Po Liu <Po.Liu@nxp.com>
Subject: [RFC,net-next  4/9] net: enetc: add hw tc hw offload features for PSPF capability
Date:   Fri,  6 Mar 2020 20:56:02 +0800
Message-Id: <20200306125608.11717-5-Po.Liu@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200306125608.11717-1-Po.Liu@nxp.com>
References: <20200306125608.11717-1-Po.Liu@nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: SG2PR06CA0205.apcprd06.prod.outlook.com
 (2603:1096:4:68::13) To VE1PR04MB6496.eurprd04.prod.outlook.com
 (2603:10a6:803:11c::29)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.73) by SG2PR06CA0205.apcprd06.prod.outlook.com (2603:1096:4:68::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.14 via Frontend Transport; Fri, 6 Mar 2020 13:15:01 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [119.31.174.73]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: e6e66fee-0a92-4f36-31e9-08d7c1d06606
X-MS-TrafficTypeDiagnostic: VE1PR04MB6718:|VE1PR04MB6718:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VE1PR04MB6718F19DED82E09B4A577C4C92E30@VE1PR04MB6718.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-Forefront-PRVS: 0334223192
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(376002)(39860400002)(396003)(346002)(136003)(199004)(189003)(36756003)(5660300002)(66946007)(66476007)(66556008)(478600001)(316002)(2616005)(86362001)(956004)(4326008)(26005)(6506007)(6486002)(6512007)(52116002)(16526019)(8936002)(186003)(69590400007)(81166006)(1076003)(81156014)(7416002)(8676002)(2906002)(142933001);DIR:OUT;SFP:1101;SCL:1;SRVR:VE1PR04MB6718;H:VE1PR04MB6496.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 10RMGolBR5NocQYfHt5KhxjpQnKI87S8Y1ecOdoMq627eHv9S/Dx7p8epsQRz3EkyWHIMysijVsGfKpEW4qxgyTXLKelflPAd+8pSZvlAs79hbMPPtpHRLGa81216BifVY2WV8orNJmRQsUeKYhmBtIDvda8Eds8iuAhVxAik1URYyeSTDqKcIJZ9CMOH9kNmfRUhoW7kdkf8MfEmyA5IdJ5ieG1p25zbgeotakSZ9Wo3Wrkdrdh5hEPiF8tXSfI5xMJ+qQsuy3y0gjZGSzWpuoD+jWoad6nOe+SVG0XnqMOxj/rcTer/x3IQ2JaBuh88s2IXDUytrkRBXoDUvhX3VaL+I9C6dc0L53wEpbRSBgZmZLJmZTV+R7A3gGe4b198lHXW7xR9ZmeknknP7smv0wjlyBhV36DTKXFjgXI08FYFJDo/X2rd+L8y3QD8Xp/cwe4b/KBl/IMWFs/+qRtglRuxjLgIrrdoQ+85akshiDQSSEMEzbF54IP30Qpn9Z4kNUmMYYBK/G/9JioV6/5OQ==
X-MS-Exchange-AntiSpam-MessageData: +riOobxLEvm83yh3T3c08ImLtN8eAZ3M2cfWFZlneZKjUkB10mtSBR9z2YrhOEqnAsaIBEydUY4ETp21IKbT2XJwl5bbNr9CHd09bO1GFVs9KvGdYqqUB6BgX0/d7Zc1UJXJbdKHH5IN1Y0sRVvaNQ==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e6e66fee-0a92-4f36-31e9-08d7c1d06606
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Mar 2020 13:15:11.3520
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: V//f4JFNLbRqlTSbG7dscDHuu1thquRAmnvgqWUKZRt0QRGcujC/ntxJEzR0ySm+
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6718
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch is to let ethtool enable/disable the tc flower offload
features. Hardware enetc has the feature of PSFP which is for per-stream
policing. When enable the tc hw offloading feature, driver would enable
the IEEE 802.1Qci feature. It is only set the register enable bit for
this feature not enable for any entry of per stream filtering and stream
gate or stream identify but get how much capabilities for each features.

Signed-off-by: Po Liu <Po.Liu@nxp.com>
---
 drivers/net/ethernet/freescale/enetc/enetc.c  | 23 ++++++++
 drivers/net/ethernet/freescale/enetc/enetc.h  | 55 +++++++++++++++++++
 .../net/ethernet/freescale/enetc/enetc_hw.h   | 17 ++++++
 .../net/ethernet/freescale/enetc/enetc_pf.c   |  8 +++
 4 files changed, 103 insertions(+)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index 1f79e36116a3..d810651317e1 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -762,6 +762,9 @@ void enetc_get_si_caps(struct enetc_si *si)
 
 	if (val & ENETC_SIPCAPR0_QBV)
 		si->hw_features |= ENETC_SI_F_QBV;
+
+	if (val & ENETC_SIPCAPR0_PSFP)
+		si->hw_features |= ENETC_SI_F_PSFP;
 }
 
 static int enetc_dma_alloc_bdr(struct enetc_bdr *r, size_t bd_size)
@@ -1566,6 +1569,23 @@ static int enetc_set_rss(struct net_device *ndev, int en)
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
@@ -1574,6 +1594,9 @@ int enetc_set_features(struct net_device *ndev,
 	if (changed & NETIF_F_RXHASH)
 		enetc_set_rss(ndev, !!(features & NETIF_F_RXHASH));
 
+	if (changed & NETIF_F_HW_TC)
+		enetc_set_psfp(ndev, !!(features & NETIF_F_HW_TC));
+
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/freescale/enetc/enetc.h b/drivers/net/ethernet/freescale/enetc/enetc.h
index 9938f7a5fc0a..bcdade8f7b8a 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.h
+++ b/drivers/net/ethernet/freescale/enetc/enetc.h
@@ -120,6 +120,7 @@ enum enetc_errata {
 };
 
 #define ENETC_SI_F_QBV BIT(0)
+#define ENETC_SI_F_PSFP BIT(1)
 
 /* PCI IEP device data */
 struct enetc_si {
@@ -172,12 +173,20 @@ struct enetc_cls_rule {
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
@@ -200,6 +209,8 @@ struct enetc_ndev_priv {
 
 	struct enetc_cls_rule *cls_rules;
 
+	struct psfp_cap psfp_cap;
+
 	struct device_node *phy_node;
 	phy_interface_t if_mode;
 };
@@ -258,9 +269,53 @@ int enetc_setup_tc_taprio(struct net_device *ndev, void *type_data);
 void enetc_sched_speed_set(struct net_device *ndev);
 int enetc_setup_tc_cbs(struct net_device *ndev, void *type_data);
 int enetc_setup_tc_txtime(struct net_device *ndev, void *type_data);
+
+static inline void enetc_get_max_cap(struct enetc_ndev_priv *priv)
+{
+	u32 reg = 0;
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
+	enetc_wr(hw, ENETC_PPSFPMR, enetc_rd(hw, ENETC_PPSFPMR)
+		 | ENETC_PPSFPMR_PSFPEN | ENETC_PPSFPMR_VS
+		 | ENETC_PPSFPMR_PVC | ENETC_PPSFPMR_PVZC);
+}
+
+static inline void enetc_psfp_disable(struct enetc_hw *hw)
+{
+	enetc_wr(hw, ENETC_PPSFPMR, enetc_rd(hw, ENETC_PPSFPMR)
+		 & ~ENETC_PPSFPMR_PSFPEN & ~ENETC_PPSFPMR_VS
+		 & ~ENETC_PPSFPMR_PVC & ~ENETC_PPSFPMR_PVZC);
+}
 #else
 #define enetc_setup_tc_taprio(ndev, type_data) -EOPNOTSUPP
 #define enetc_sched_speed_set(ndev) (void)0
 #define enetc_setup_tc_cbs(ndev, type_data) -EOPNOTSUPP
 #define enetc_setup_tc_txtime(ndev, type_data) -EOPNOTSUPP
+#define enetc_get_max_cap(p)		\
+	memset(&((p)->psfp_cap), 0, sizeof(struct psfp_cap))
+
+static inline void enetc_psfp_enable(struct enetc_hw *hw)
+{
+	return 0;
+}
+
+static inline void enetc_psfp_disable(struct enetc_hw *hw)
+{
+	return 0;
+}
 #endif
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_hw.h b/drivers/net/ethernet/freescale/enetc/enetc_hw.h
index da134e211c1a..99d520207069 100644
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
@@ -624,3 +634,10 @@ struct enetc_cbd {
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
index 545a344bce00..d880cbdc0d2e 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_pf.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
@@ -740,6 +740,14 @@ static void enetc_pf_netdev_setup(struct enetc_si *si, struct net_device *ndev,
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

