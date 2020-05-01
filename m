Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 205201C0B90
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 03:14:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728122AbgEABOj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 21:14:39 -0400
Received: from mail-eopbgr30082.outbound.protection.outlook.com ([40.107.3.82]:14630
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727114AbgEABOi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Apr 2020 21:14:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LuzqVo8OM/PaRflk7z/WS8TnUuG3WLtx48Eu05YJvlC4ooT/yKE4BVx02d4Onq/N4uoGl+6/gG+gG+peA0nqfrFmaUuJ/NKDROiRfkPWJwggXHzuvIm5mEfrWcovGONmbZVB8+M7JtIwt1EKXq6MHZM9f5rVM1q7ygmM/2QhScoi9+fF2XC1E9gYhIizgNq8Zt4NON4ARXHX/ahFfKbz0Sn8DErVyc+mjc2WEKfW8Z7eY/VOnWnXxbRH3BCYiTnG0WBzZAkxoQWx0wbUhTTnCRu4z+8ImHepFLMYst2pE6B+MH9QUzFlFhhorXymPVQisl71FFgedCTPAc9VChs9vw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m6o32I+dZ9zebhm5fx0w4+Xp6sZ5xhXmBHYYZZv9Kcg=;
 b=iNeKE9AAWx2BL0VPUjIFggh9obzy3tusA6hVH0I2w/IMRcvkCWRP+/AfvyM3Oa210un6fSqFWTotIwEHIGQbSG9sSugu2SCHOLtep3OSECfCO/C/gsXNfZzGRzyZ01kpreCNNONyGKG+7MO4uAi7ihx7NB8Z1VhEGFe7na0wfQUpM6n7e6wOaO2R3mq/Eu2DbjmPv0KpTClO8f+Kq/1ZqsNL6nXmwZRKiNgqHBn2sbdgW5xi2lOlzzkrEVy0aITs0CL0p+A6DGmuShd2dxD9V7oIXE/+NRBVEvh/cZODQ88MD7vTzn7P9GlXiAiXxmublsLzzYkI/MOf51XnVVOfkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m6o32I+dZ9zebhm5fx0w4+Xp6sZ5xhXmBHYYZZv9Kcg=;
 b=FXtZbUnS8IH6OtCuDBnHZ7GAGA9xtAb0eWuIEyzDQF4VvIH1HETU/TEpi+dV52ujz24NN3M2hawbofpQLbgX4oundqdpqQ2Gz4yQRkmrn5g0YcVphMrtq29ir76l/SwiEA7I/HlkRLLBuwqz5ZFFnF+UfLL94px2mGzj0UCVsWg=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from VE1PR04MB6496.eurprd04.prod.outlook.com (2603:10a6:803:11c::29)
 by VE1PR04MB6734.eurprd04.prod.outlook.com (2603:10a6:803:121::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.19; Fri, 1 May
 2020 01:14:34 +0000
Received: from VE1PR04MB6496.eurprd04.prod.outlook.com
 ([fe80::1479:38ea:d4f7:a173]) by VE1PR04MB6496.eurprd04.prod.outlook.com
 ([fe80::1479:38ea:d4f7:a173%7]) with mapi id 15.20.2937.023; Fri, 1 May 2020
 01:14:34 +0000
From:   Po Liu <Po.Liu@nxp.com>
To:     davem@davemloft.net, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     vinicius.gomes@intel.com, vlad@buslov.dev, po.liu@nxp.com,
        claudiu.manoil@nxp.com, vladimir.oltean@nxp.com,
        alexandru.marginean@nxp.com, michael.chan@broadcom.com,
        vishal@chelsio.com, saeedm@mellanox.com, leon@kernel.org,
        jiri@mellanox.com, idosch@mellanox.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        kuba@kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        simon.horman@netronome.com, pablo@netfilter.org,
        moshe@mellanox.com, m-karicheri2@ti.com,
        andre.guedes@linux.intel.com, stephen@networkplumber.org,
        Po Liu <Po.Liu@nxp.com>
Subject: [v5,net-next  3/4] net: enetc: add hw tc hw offload features for PSPF capability
Date:   Fri,  1 May 2020 08:53:17 +0800
Message-Id: <20200501005318.21334-4-Po.Liu@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200501005318.21334-1-Po.Liu@nxp.com>
References: <20200428033453.28100-5-Po.Liu@nxp.com>
 <20200501005318.21334-1-Po.Liu@nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: SG2PR03CA0108.apcprd03.prod.outlook.com
 (2603:1096:4:7c::36) To VE1PR04MB6496.eurprd04.prod.outlook.com
 (2603:10a6:803:11c::29)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.73) by SG2PR03CA0108.apcprd03.prod.outlook.com (2603:1096:4:7c::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.16 via Frontend Transport; Fri, 1 May 2020 01:14:26 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [119.31.174.73]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 1cd7918f-3362-42fb-01b9-08d7ed6d01ea
X-MS-TrafficTypeDiagnostic: VE1PR04MB6734:|VE1PR04MB6734:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VE1PR04MB6734177AE832FCC3C1070F8892AB0@VE1PR04MB6734.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-Forefront-PRVS: 0390DB4BDA
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mOLXnvHj37VK4/LlaikvRRVuoxdQqFQePopxikPYuiQvCN24l9liEEKwIY3aWVBmKso3lSgLO/voecN5yd7vTKffgoADZPgm9dg6q8aLwnIEHHFrxgqzcojobooZEWhpDVORnDG0sCE6KwIiU4hOOR8GbNFJ0krSv04t90SB1/vcW8o62JWybwqwm+DO/N+2UWHgIixGykevdBgJJsF/jOfhQqp0cpiVR0uOqEsinefh5qHsET4CsMbQaAgUd/HFIdcBmmPn6diS1IV4RazDoDDEcDJ1qwzUhdRc7tHMLFOIEOHyX7rKe9l14Fd2TyzrfLKC+uN+7SdAxaUqhma27qZcTmbab9XPm9rjEzQwB9e+RqwzTuCfsJV/1l0HYwEOF3+Ot9O2cEFdbg97cGxREeYxG1WEfS7bwIjTLzp1wlEFdvDYzb5ePWlY3Kt1iLRJaPaRNmdNI+fY5dKKQIf1ExS3LVWukL6lPSUIzIbCGtnZo2di8KwqZ7HxNx7Tav8K
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR04MB6496.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(39860400002)(136003)(396003)(376002)(346002)(16526019)(186003)(36756003)(478600001)(26005)(2906002)(4326008)(8936002)(6486002)(86362001)(52116002)(316002)(7416002)(6512007)(6506007)(69590400007)(1076003)(6666004)(66476007)(66556008)(2616005)(66946007)(956004)(8676002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: KSgbFN5MoSJGcJO+dvxt7N2KYjGu6WtRyHu/hNe2srq8Kxg8Z7WMAXqvr5bm+R++pmprSSLoymzsP0zcCosr4YoTVNuAWQtxUBotBU3809/vf+ZD8vUvK0HkJTOtPGXK2al4s58bnFrw/4ad6hRHWK2Hx0jgPQ499qnHN5scyzetUDlMf2mL1zqutv56NALpA65A4exYRKONMRwMOzLWmPN5JCY9KR5EZXYglPZcK/IGFdjuwKZDD5lv/UQLcb4gIMXwkrbMNRHPHweSGJ8HLN30uG91EBfBcTkpmRFetONeAHbzfNt4Q4SJLbjbLuA1NFHHxJXSZRoOfbrxiUIyC/jGEevDUQZjUe8w2klWEW6Z9Jq62b0fBiyWR6dvxFrql88xBDCQy4s0R0rPHal9a796/NKRfIf2IoZX0BNNdvHedxYj8wyqZlKc2YYytUriqFBPNlhEmi7ZktTDKUrS7SEL2UK5TRh6syG+3lnwEZEILu7JuWmiUJTrxNF8mLH1LZ4kuAeQ09bZ1Bypb6kLSDW8Pfb0oeAJZmdWpD2rnkM9yZuAMooDoTFw6lqYb7Ev4NET27KZYewv5OIHlbgCjtAoMmcL5WnZPi7JBRLSir0/qigoCTmzmLiFr/HLJnyrGB5cfUL5To5giJjLKju4/lKhKHk3xbKWslYMSEo2q8xho9dVb4tz9bVUiZcQ3IflrkV+EEFuYOToTdfdbmUX/FIaQp3tHhDJ9n0d+vphbI/Fms+FCdS9plTUZfDyyFDZQ5ejhpu8tGWk/YhLO0H6UVUoOULGChWmV3L5UN6Rhe8=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1cd7918f-3362-42fb-01b9-08d7ed6d01ea
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 May 2020 01:14:33.8993
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3BeYG+o/Wza0bp1HOJGUaRm85fKiU82CDoydBmSHsaJxLGvmhN2fckmlBvuF9Ajm
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6734
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

