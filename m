Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34BE2662311
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 11:21:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237057AbjAIKVz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 05:21:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237147AbjAIKVi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 05:21:38 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2062b.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe59::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E66AA1BEA2
        for <netdev@vger.kernel.org>; Mon,  9 Jan 2023 02:19:35 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=alMTeAZ0V98Qg3tE8zWfNF7PR9WUUDVidTI44SoVSVyBWnHl/o0N1NakKFunudZm+PDaiHzdp65mA5v0bmqLYnzjSZU8cT8DyZVhsrU6n+NywqMoQLwC7nMI63ELF9Mk43AXbnQxO/v7sgcdOtJfo+ned00pzDe05QDC7ZXAH6GwqKY5dI/Hi/n1OompvIK20u/GZs18nSEuHwylTb0m6HkXe2xGOCTXueaxk4YHEpFo+2MpVvuKfArBhoyVRZdTM/VUIXAuCO6E0lHCQBuvsyERPXT6xVPzcDV/brOryG2BHDA7XO5jA8P34u+Akdk5oB3Ozu/0Gyim55bUu5KsRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nf9NXGYIgqcO5dcK4hWWgGBxMYNyDC0EePWyNsNd9Jk=;
 b=WIteLyO97mWot4BIL4ke8OGQu0PHrQgijZNZi1pmLP+k585iGDNz50Q+iThTUn1jTzwGgx6wlu/iLr9hCehYo2K0mSK/GKbP3VDXGeA+53foKV/8+Av5OJMQILZHEq4/8FW5WhwV5KkuuosJgYyn0gy8W9V4Ws3iskC5NEhr4jNHbpV/EeMywfX2UUBfQwaEdDxO2qxIWpZVwVG6QZoAtJKGqfwqGq9LEC5Zz72+OU4rzL5Llnh17LlW7tZnk/qQdL6l4IEIRyUWEl+3HEaXpFpUrj7MkL+MNyXG0aVzUEAOEalkNtrJNFCehOs/6Fl5mr6pptpvXtW5i5j/hN/+cg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nf9NXGYIgqcO5dcK4hWWgGBxMYNyDC0EePWyNsNd9Jk=;
 b=3uAs6Y7OKoWzZxjnACDFvRAbphNjnatNp9TS70bGSppX63faZZG1OtnIfa5SPpw7ctG5BhsdoLJEQ2B2DRTsAsyAD7QesJwdBdaq0QXKNPl6Uz5AUYi5f1eit5sdHE1bDeCZurCmEJu0ND+YOu0NYtiKDNJ5UirFVgYRiwyTmcQ=
Received: from BN9PR03CA0953.namprd03.prod.outlook.com (2603:10b6:408:108::28)
 by IA1PR12MB6649.namprd12.prod.outlook.com (2603:10b6:208:3a2::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Mon, 9 Jan
 2023 10:19:32 +0000
Received: from BL02EPF00010206.namprd05.prod.outlook.com
 (2603:10b6:408:108:cafe::f9) by BN9PR03CA0953.outlook.office365.com
 (2603:10b6:408:108::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18 via Frontend
 Transport; Mon, 9 Jan 2023 10:19:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL02EPF00010206.mail.protection.outlook.com (10.167.241.196) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5986.15 via Frontend Transport; Mon, 9 Jan 2023 10:19:32 +0000
Received: from jatayu.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 9 Jan
 2023 04:19:28 -0600
From:   Raju Rangoju <Raju.Rangoju@amd.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <edumazet@google.com>,
        <pabeni@redhat.com>, <thomas.lendacky@amd.com>,
        <Shyam-sundar.S-k@amd.com>, Raju Rangoju <Raju.Rangoju@amd.com>
Subject: [PATCH net-next] amd-xgbe: Add support for 10 Mbps speed
Date:   Mon, 9 Jan 2023 15:48:19 +0530
Message-ID: <20230109101819.747572-1-Raju.Rangoju@amd.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF00010206:EE_|IA1PR12MB6649:EE_
X-MS-Office365-Filtering-Correlation-Id: b418072c-8fb2-4ded-d796-08daf22b0032
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0dFHoxHfuBOQYR3LO6RliHaPA1XsrzgVmQZ/qPn/xl03kxBdZ/51ZvKbXe4E6rgJzDnyPYM/l83ZG5Wur7klAzX5wgXfZQ3pS+hVbpxQU0+Ka5RwWgRbsRbcqpcOUcJ1/mwwyvoDc8H6JfBWjVmyaItuVepD7eQD5Z841t0y47GgHLgFMsrsR82fLh5HE5TbTW9sOfDgPEWtKaFIVfRo2YvNA26rXoHxUZPRB8FJsPzqgP33ElMSBx7B4clpNzsleOHI7mHRrOM8LctLxr6rrcxgkE1FRikFovfxBpZS93LByD4mra9RXFMVNUUzAUfi9qkYs9rYofapd6sgy2ivgehNwyg7wOf+Tvu2Kf9RUk6mrl15NpUJ0YhMlABOtF/AYYYVJ9LrLyUp8x0VGI1UaYME0CpxJxFMqQszssON7GmI4XlWSzY2tLIMrHIdqAdsK/5ez6ZiHVNEoS5pu5jnPIdDzdn1D1/OYNx5xr++8c8kujfCDFWsQ6YMNxLJbN2buF50hHeImzwe4QuO0FllVDmoUTqKrq0DXajOzdLteUhOXCzXGAjAISxUQqtAPXsQY8TVNfVpkkyo7Mb6AcDfp4XfWVxXOmerglmpSbGCBWuzWKYPWBHJC8husZ/c3Kk056+dUeITWt54Ys09O6bdPezQm+HqPY7CtujRxQR4i1RAq0TDYiP0BZc0nd6HbcU2xld0vKfG7hHJbKwdLj11DTEkLDErI6v0XboJMt1+szE=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(396003)(136003)(376002)(346002)(451199015)(36840700001)(46966006)(40470700004)(2906002)(478600001)(6666004)(186003)(16526019)(26005)(7696005)(47076005)(54906003)(316002)(2616005)(6916009)(70586007)(36756003)(70206006)(8676002)(4326008)(336012)(426003)(40460700003)(1076003)(41300700001)(40480700001)(30864003)(5660300002)(82740400003)(8936002)(83380400001)(36860700001)(82310400005)(86362001)(356005)(81166007)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jan 2023 10:19:32.6725
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b418072c-8fb2-4ded-d796-08daf22b0032
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BL02EPF00010206.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6649
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the necessary changes to support 10 Mbps speed for BaseT and SFP
port modes. This is supported in MAC ver >= 30H.

Signed-off-by: Raju Rangoju <Raju.Rangoju@amd.com>
---
 drivers/net/ethernet/amd/xgbe/xgbe-dev.c    |   3 +
 drivers/net/ethernet/amd/xgbe/xgbe-mdio.c   |  24 +++++
 drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c | 107 ++++++++++++++++++--
 drivers/net/ethernet/amd/xgbe/xgbe.h        |   2 +
 4 files changed, 126 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-dev.c b/drivers/net/ethernet/amd/xgbe/xgbe-dev.c
index 3936543a74d8..e033d6c819f3 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-dev.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-dev.c
@@ -807,6 +807,9 @@ static int xgbe_set_speed(struct xgbe_prv_data *pdata, int speed)
 	unsigned int ss;
 
 	switch (speed) {
+	case SPEED_10:
+		ss = 0x07;
+		break;
 	case SPEED_1000:
 		ss = 0x03;
 		break;
diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-mdio.c b/drivers/net/ethernet/amd/xgbe/xgbe-mdio.c
index 0c5c1b155683..cde0f86791b6 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-mdio.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-mdio.c
@@ -274,6 +274,15 @@ static void xgbe_sgmii_1000_mode(struct xgbe_prv_data *pdata)
 	pdata->phy_if.phy_impl.set_mode(pdata, XGBE_MODE_SGMII_1000);
 }
 
+static void xgbe_sgmii_10_mode(struct xgbe_prv_data *pdata)
+{
+	/* Set MAC to 10M speed */
+	pdata->hw_if.set_speed(pdata, SPEED_10);
+
+	/* Call PHY implementation support to complete rate change */
+	pdata->phy_if.phy_impl.set_mode(pdata, XGBE_MODE_SGMII_10);
+}
+
 static void xgbe_sgmii_100_mode(struct xgbe_prv_data *pdata)
 {
 	/* Set MAC to 1G speed */
@@ -306,6 +315,9 @@ static void xgbe_change_mode(struct xgbe_prv_data *pdata,
 	case XGBE_MODE_KR:
 		xgbe_kr_mode(pdata);
 		break;
+	case XGBE_MODE_SGMII_10:
+		xgbe_sgmii_10_mode(pdata);
+		break;
 	case XGBE_MODE_SGMII_100:
 		xgbe_sgmii_100_mode(pdata);
 		break;
@@ -1074,6 +1086,8 @@ static const char *xgbe_phy_fc_string(struct xgbe_prv_data *pdata)
 static const char *xgbe_phy_speed_string(int speed)
 {
 	switch (speed) {
+	case SPEED_10:
+		return "10Mbps";
 	case SPEED_100:
 		return "100Mbps";
 	case SPEED_1000:
@@ -1161,6 +1175,7 @@ static int xgbe_phy_config_fixed(struct xgbe_prv_data *pdata)
 	case XGBE_MODE_KX_1000:
 	case XGBE_MODE_KX_2500:
 	case XGBE_MODE_KR:
+	case XGBE_MODE_SGMII_10:
 	case XGBE_MODE_SGMII_100:
 	case XGBE_MODE_SGMII_1000:
 	case XGBE_MODE_X:
@@ -1222,6 +1237,8 @@ static int __xgbe_phy_config_aneg(struct xgbe_prv_data *pdata, bool set_mode)
 			xgbe_set_mode(pdata, XGBE_MODE_SGMII_1000);
 		} else if (xgbe_use_mode(pdata, XGBE_MODE_SGMII_100)) {
 			xgbe_set_mode(pdata, XGBE_MODE_SGMII_100);
+		} else if (xgbe_use_mode(pdata, XGBE_MODE_SGMII_10)) {
+			xgbe_set_mode(pdata, XGBE_MODE_SGMII_10);
 		} else {
 			enable_irq(pdata->an_irq);
 			ret = -EINVAL;
@@ -1301,6 +1318,9 @@ static void xgbe_phy_status_result(struct xgbe_prv_data *pdata)
 		mode = xgbe_phy_status_aneg(pdata);
 
 	switch (mode) {
+	case XGBE_MODE_SGMII_10:
+		pdata->phy.speed = SPEED_10;
+		break;
 	case XGBE_MODE_SGMII_100:
 		pdata->phy.speed = SPEED_100;
 		break;
@@ -1443,6 +1463,8 @@ static int xgbe_phy_start(struct xgbe_prv_data *pdata)
 		xgbe_sgmii_1000_mode(pdata);
 	} else if (xgbe_use_mode(pdata, XGBE_MODE_SGMII_100)) {
 		xgbe_sgmii_100_mode(pdata);
+	} else if (xgbe_use_mode(pdata, XGBE_MODE_SGMII_10)) {
+		xgbe_sgmii_10_mode(pdata);
 	} else {
 		ret = -EINVAL;
 		goto err_irq;
@@ -1540,6 +1562,8 @@ static int xgbe_phy_best_advertised_speed(struct xgbe_prv_data *pdata)
 		return SPEED_1000;
 	else if (XGBE_ADV(lks, 100baseT_Full))
 		return SPEED_100;
+	else if (XGBE_ADV(lks, 10baseT_Full))
+		return SPEED_10;
 
 	return SPEED_UNKNOWN;
 }
diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c b/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
index c731a04731f8..de7118cb10b8 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
@@ -124,6 +124,7 @@
 #include "xgbe.h"
 #include "xgbe-common.h"
 
+#define XGBE_PHY_PORT_SPEED_10		BIT(0)
 #define XGBE_PHY_PORT_SPEED_100		BIT(1)
 #define XGBE_PHY_PORT_SPEED_1000	BIT(2)
 #define XGBE_PHY_PORT_SPEED_2500	BIT(3)
@@ -759,6 +760,8 @@ static void xgbe_phy_sfp_phy_settings(struct xgbe_prv_data *pdata)
 		XGBE_SET_SUP(lks, Pause);
 		XGBE_SET_SUP(lks, Asym_Pause);
 		if (phy_data->sfp_base == XGBE_SFP_BASE_1000_T) {
+			if (phy_data->port_speeds & XGBE_PHY_PORT_SPEED_10)
+				XGBE_SET_SUP(lks, 10baseT_Full);
 			if (phy_data->port_speeds & XGBE_PHY_PORT_SPEED_100)
 				XGBE_SET_SUP(lks, 100baseT_Full);
 			if (phy_data->port_speeds & XGBE_PHY_PORT_SPEED_1000)
@@ -1542,6 +1545,16 @@ static enum xgbe_mode xgbe_phy_an37_sgmii_outcome(struct xgbe_prv_data *pdata)
 		xgbe_phy_phydev_flowctrl(pdata);
 
 	switch (pdata->an_status & XGBE_SGMII_AN_LINK_SPEED) {
+	case XGBE_SGMII_AN_LINK_SPEED_10:
+		if (pdata->an_status & XGBE_SGMII_AN_LINK_DUPLEX) {
+			XGBE_SET_LP_ADV(lks, 10baseT_Full);
+			mode = XGBE_MODE_SGMII_10;
+		} else {
+			/* Half-duplex not supported */
+			XGBE_SET_LP_ADV(lks, 10baseT_Half);
+			mode = XGBE_MODE_UNKNOWN;
+		}
+		break;
 	case XGBE_SGMII_AN_LINK_SPEED_100:
 		if (pdata->an_status & XGBE_SGMII_AN_LINK_DUPLEX) {
 			XGBE_SET_LP_ADV(lks, 100baseT_Full);
@@ -1658,7 +1671,10 @@ static enum xgbe_mode xgbe_phy_an73_redrv_outcome(struct xgbe_prv_data *pdata)
 			switch (phy_data->sfp_base) {
 			case XGBE_SFP_BASE_1000_T:
 				if (phy_data->phydev &&
-				    (phy_data->phydev->speed == SPEED_100))
+				    (phy_data->phydev->speed == SPEED_10))
+					mode = XGBE_MODE_SGMII_10;
+				else if (phy_data->phydev &&
+					 (phy_data->phydev->speed == SPEED_100))
 					mode = XGBE_MODE_SGMII_100;
 				else
 					mode = XGBE_MODE_SGMII_1000;
@@ -1673,7 +1689,10 @@ static enum xgbe_mode xgbe_phy_an73_redrv_outcome(struct xgbe_prv_data *pdata)
 			break;
 		default:
 			if (phy_data->phydev &&
-			    (phy_data->phydev->speed == SPEED_100))
+			    (phy_data->phydev->speed == SPEED_10))
+				mode = XGBE_MODE_SGMII_10;
+			else if (phy_data->phydev &&
+				 (phy_data->phydev->speed == SPEED_100))
 				mode = XGBE_MODE_SGMII_100;
 			else
 				mode = XGBE_MODE_SGMII_1000;
@@ -2127,6 +2146,20 @@ static void xgbe_phy_sgmii_100_mode(struct xgbe_prv_data *pdata)
 	netif_dbg(pdata, link, pdata->netdev, "100MbE SGMII mode set\n");
 }
 
+static void xgbe_phy_sgmii_10_mode(struct xgbe_prv_data *pdata)
+{
+	struct xgbe_phy_data *phy_data = pdata->phy_data;
+
+	xgbe_phy_set_redrv_mode(pdata);
+
+	/* 10M/SGMII */
+	xgbe_phy_perform_ratechange(pdata, XGBE_MB_CMD_SET_1G, XGBE_MB_SUBCMD_10MBITS);
+
+	phy_data->cur_mode = XGBE_MODE_SGMII_10;
+
+	netif_dbg(pdata, link, pdata->netdev, "10MbE SGMII mode set\n");
+}
+
 static void xgbe_phy_kr_mode(struct xgbe_prv_data *pdata)
 {
 	struct xgbe_phy_data *phy_data = pdata->phy_data;
@@ -2185,6 +2218,7 @@ static enum xgbe_mode xgbe_phy_switch_baset_mode(struct xgbe_prv_data *pdata)
 		return xgbe_phy_cur_mode(pdata);
 
 	switch (xgbe_phy_cur_mode(pdata)) {
+	case XGBE_MODE_SGMII_10:
 	case XGBE_MODE_SGMII_100:
 	case XGBE_MODE_SGMII_1000:
 		return XGBE_MODE_KR;
@@ -2252,6 +2286,8 @@ static enum xgbe_mode xgbe_phy_get_baset_mode(struct xgbe_phy_data *phy_data,
 					      int speed)
 {
 	switch (speed) {
+	case SPEED_10:
+		return XGBE_MODE_SGMII_10;
 	case SPEED_100:
 		return XGBE_MODE_SGMII_100;
 	case SPEED_1000:
@@ -2269,6 +2305,8 @@ static enum xgbe_mode xgbe_phy_get_sfp_mode(struct xgbe_phy_data *phy_data,
 					    int speed)
 {
 	switch (speed) {
+	case SPEED_10:
+		return XGBE_MODE_SGMII_10;
 	case SPEED_100:
 		return XGBE_MODE_SGMII_100;
 	case SPEED_1000:
@@ -2343,6 +2381,9 @@ static void xgbe_phy_set_mode(struct xgbe_prv_data *pdata, enum xgbe_mode mode)
 	case XGBE_MODE_KR:
 		xgbe_phy_kr_mode(pdata);
 		break;
+	case XGBE_MODE_SGMII_10:
+		xgbe_phy_sgmii_10_mode(pdata);
+		break;
 	case XGBE_MODE_SGMII_100:
 		xgbe_phy_sgmii_100_mode(pdata);
 		break;
@@ -2399,6 +2440,9 @@ static bool xgbe_phy_use_baset_mode(struct xgbe_prv_data *pdata,
 	struct ethtool_link_ksettings *lks = &pdata->phy.lks;
 
 	switch (mode) {
+	case XGBE_MODE_SGMII_10:
+		return xgbe_phy_check_mode(pdata, mode,
+					   XGBE_ADV(lks, 10baseT_Full));
 	case XGBE_MODE_SGMII_100:
 		return xgbe_phy_check_mode(pdata, mode,
 					   XGBE_ADV(lks, 100baseT_Full));
@@ -2428,6 +2472,11 @@ static bool xgbe_phy_use_sfp_mode(struct xgbe_prv_data *pdata,
 			return false;
 		return xgbe_phy_check_mode(pdata, mode,
 					   XGBE_ADV(lks, 1000baseX_Full));
+	case XGBE_MODE_SGMII_10:
+		if (phy_data->sfp_base != XGBE_SFP_BASE_1000_T)
+			return false;
+		return xgbe_phy_check_mode(pdata, mode,
+					   XGBE_ADV(lks, 10baseT_Full));
 	case XGBE_MODE_SGMII_100:
 		if (phy_data->sfp_base != XGBE_SFP_BASE_1000_T)
 			return false;
@@ -2520,10 +2569,17 @@ static bool xgbe_phy_valid_speed_basex_mode(struct xgbe_phy_data *phy_data,
 	}
 }
 
-static bool xgbe_phy_valid_speed_baset_mode(struct xgbe_phy_data *phy_data,
+static bool xgbe_phy_valid_speed_baset_mode(struct xgbe_prv_data *pdata,
 					    int speed)
 {
+	struct xgbe_phy_data *phy_data = pdata->phy_data;
+	unsigned int ver;
+
 	switch (speed) {
+	case SPEED_10:
+		/* Supported in ver >= 30H */
+		ver = XGMAC_GET_BITS(pdata->hw_feat.version, MAC_VR, SNPSVER);
+		return (ver >= 0x30) ? true : false;
 	case SPEED_100:
 	case SPEED_1000:
 		return true;
@@ -2536,10 +2592,17 @@ static bool xgbe_phy_valid_speed_baset_mode(struct xgbe_phy_data *phy_data,
 	}
 }
 
-static bool xgbe_phy_valid_speed_sfp_mode(struct xgbe_phy_data *phy_data,
+static bool xgbe_phy_valid_speed_sfp_mode(struct xgbe_prv_data *pdata,
 					  int speed)
 {
+	struct xgbe_phy_data *phy_data = pdata->phy_data;
+	unsigned int ver;
+
 	switch (speed) {
+	case SPEED_10:
+		/* Supported in ver >= 30H */
+		ver = XGMAC_GET_BITS(pdata->hw_feat.version, MAC_VR, SNPSVER);
+		return (ver >= 0x30) && (phy_data->sfp_speed == XGBE_SFP_SPEED_100_1000);
 	case SPEED_100:
 		return (phy_data->sfp_speed == XGBE_SFP_SPEED_100_1000);
 	case SPEED_1000:
@@ -2586,12 +2649,12 @@ static bool xgbe_phy_valid_speed(struct xgbe_prv_data *pdata, int speed)
 	case XGBE_PORT_MODE_1000BASE_T:
 	case XGBE_PORT_MODE_NBASE_T:
 	case XGBE_PORT_MODE_10GBASE_T:
-		return xgbe_phy_valid_speed_baset_mode(phy_data, speed);
+		return xgbe_phy_valid_speed_baset_mode(pdata, speed);
 	case XGBE_PORT_MODE_1000BASE_X:
 	case XGBE_PORT_MODE_10GBASE_R:
 		return xgbe_phy_valid_speed_basex_mode(phy_data, speed);
 	case XGBE_PORT_MODE_SFP:
-		return xgbe_phy_valid_speed_sfp_mode(phy_data, speed);
+		return xgbe_phy_valid_speed_sfp_mode(pdata, speed);
 	default:
 		return false;
 	}
@@ -2862,6 +2925,12 @@ static int xgbe_phy_mdio_reset_setup(struct xgbe_prv_data *pdata)
 static bool xgbe_phy_port_mode_mismatch(struct xgbe_prv_data *pdata)
 {
 	struct xgbe_phy_data *phy_data = pdata->phy_data;
+	unsigned int ver;
+
+	/* 10 Mbps speed is not supported in ver < 30H */
+	ver = XGMAC_GET_BITS(pdata->hw_feat.version, MAC_VR, SNPSVER);
+	if (ver < 0x30 && (phy_data->port_speeds & XGBE_PHY_PORT_SPEED_10))
+		return true;
 
 	switch (phy_data->port_mode) {
 	case XGBE_PORT_MODE_BACKPLANE:
@@ -2875,7 +2944,8 @@ static bool xgbe_phy_port_mode_mismatch(struct xgbe_prv_data *pdata)
 			return false;
 		break;
 	case XGBE_PORT_MODE_1000BASE_T:
-		if ((phy_data->port_speeds & XGBE_PHY_PORT_SPEED_100) ||
+		if ((phy_data->port_speeds & XGBE_PHY_PORT_SPEED_10) ||
+		    (phy_data->port_speeds & XGBE_PHY_PORT_SPEED_100) ||
 		    (phy_data->port_speeds & XGBE_PHY_PORT_SPEED_1000))
 			return false;
 		break;
@@ -2884,13 +2954,15 @@ static bool xgbe_phy_port_mode_mismatch(struct xgbe_prv_data *pdata)
 			return false;
 		break;
 	case XGBE_PORT_MODE_NBASE_T:
-		if ((phy_data->port_speeds & XGBE_PHY_PORT_SPEED_100) ||
+		if ((phy_data->port_speeds & XGBE_PHY_PORT_SPEED_10) ||
+		    (phy_data->port_speeds & XGBE_PHY_PORT_SPEED_100) ||
 		    (phy_data->port_speeds & XGBE_PHY_PORT_SPEED_1000) ||
 		    (phy_data->port_speeds & XGBE_PHY_PORT_SPEED_2500))
 			return false;
 		break;
 	case XGBE_PORT_MODE_10GBASE_T:
-		if ((phy_data->port_speeds & XGBE_PHY_PORT_SPEED_100) ||
+		if ((phy_data->port_speeds & XGBE_PHY_PORT_SPEED_10) ||
+		    (phy_data->port_speeds & XGBE_PHY_PORT_SPEED_100) ||
 		    (phy_data->port_speeds & XGBE_PHY_PORT_SPEED_1000) ||
 		    (phy_data->port_speeds & XGBE_PHY_PORT_SPEED_10000))
 			return false;
@@ -2900,7 +2972,8 @@ static bool xgbe_phy_port_mode_mismatch(struct xgbe_prv_data *pdata)
 			return false;
 		break;
 	case XGBE_PORT_MODE_SFP:
-		if ((phy_data->port_speeds & XGBE_PHY_PORT_SPEED_100) ||
+		if ((phy_data->port_speeds & XGBE_PHY_PORT_SPEED_10) ||
+		    (phy_data->port_speeds & XGBE_PHY_PORT_SPEED_100) ||
 		    (phy_data->port_speeds & XGBE_PHY_PORT_SPEED_1000) ||
 		    (phy_data->port_speeds & XGBE_PHY_PORT_SPEED_10000))
 			return false;
@@ -3269,6 +3342,10 @@ static int xgbe_phy_init(struct xgbe_prv_data *pdata)
 		XGBE_SET_SUP(lks, Pause);
 		XGBE_SET_SUP(lks, Asym_Pause);
 		XGBE_SET_SUP(lks, TP);
+		if (phy_data->port_speeds & XGBE_PHY_PORT_SPEED_10) {
+			XGBE_SET_SUP(lks, 10baseT_Full);
+			phy_data->start_mode = XGBE_MODE_SGMII_10;
+		}
 		if (phy_data->port_speeds & XGBE_PHY_PORT_SPEED_100) {
 			XGBE_SET_SUP(lks, 100baseT_Full);
 			phy_data->start_mode = XGBE_MODE_SGMII_100;
@@ -3299,6 +3376,10 @@ static int xgbe_phy_init(struct xgbe_prv_data *pdata)
 		XGBE_SET_SUP(lks, Pause);
 		XGBE_SET_SUP(lks, Asym_Pause);
 		XGBE_SET_SUP(lks, TP);
+		if (phy_data->port_speeds & XGBE_PHY_PORT_SPEED_10) {
+			XGBE_SET_SUP(lks, 10baseT_Full);
+			phy_data->start_mode = XGBE_MODE_SGMII_10;
+		}
 		if (phy_data->port_speeds & XGBE_PHY_PORT_SPEED_100) {
 			XGBE_SET_SUP(lks, 100baseT_Full);
 			phy_data->start_mode = XGBE_MODE_SGMII_100;
@@ -3321,6 +3402,10 @@ static int xgbe_phy_init(struct xgbe_prv_data *pdata)
 		XGBE_SET_SUP(lks, Pause);
 		XGBE_SET_SUP(lks, Asym_Pause);
 		XGBE_SET_SUP(lks, TP);
+		if (phy_data->port_speeds & XGBE_PHY_PORT_SPEED_10) {
+			XGBE_SET_SUP(lks, 10baseT_Full);
+			phy_data->start_mode = XGBE_MODE_SGMII_10;
+		}
 		if (phy_data->port_speeds & XGBE_PHY_PORT_SPEED_100) {
 			XGBE_SET_SUP(lks, 100baseT_Full);
 			phy_data->start_mode = XGBE_MODE_SGMII_100;
@@ -3361,6 +3446,8 @@ static int xgbe_phy_init(struct xgbe_prv_data *pdata)
 		XGBE_SET_SUP(lks, Asym_Pause);
 		XGBE_SET_SUP(lks, TP);
 		XGBE_SET_SUP(lks, FIBRE);
+		if (phy_data->port_speeds & XGBE_PHY_PORT_SPEED_10)
+			phy_data->start_mode = XGBE_MODE_SGMII_10;
 		if (phy_data->port_speeds & XGBE_PHY_PORT_SPEED_100)
 			phy_data->start_mode = XGBE_MODE_SGMII_100;
 		if (phy_data->port_speeds & XGBE_PHY_PORT_SPEED_1000)
diff --git a/drivers/net/ethernet/amd/xgbe/xgbe.h b/drivers/net/ethernet/amd/xgbe/xgbe.h
index 71f24cb47935..da37476a2848 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe.h
+++ b/drivers/net/ethernet/amd/xgbe/xgbe.h
@@ -293,6 +293,7 @@
 
 #define XGBE_SGMII_AN_LINK_STATUS	BIT(1)
 #define XGBE_SGMII_AN_LINK_SPEED	(BIT(2) | BIT(3))
+#define XGBE_SGMII_AN_LINK_SPEED_10	0x00
 #define XGBE_SGMII_AN_LINK_SPEED_100	0x04
 #define XGBE_SGMII_AN_LINK_SPEED_1000	0x08
 #define XGBE_SGMII_AN_LINK_DUPLEX	BIT(4)
@@ -594,6 +595,7 @@ enum xgbe_mode {
 	XGBE_MODE_KX_2500,
 	XGBE_MODE_KR,
 	XGBE_MODE_X,
+	XGBE_MODE_SGMII_10,
 	XGBE_MODE_SGMII_100,
 	XGBE_MODE_SGMII_1000,
 	XGBE_MODE_SFI,
-- 
2.25.1

