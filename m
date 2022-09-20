Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66B2A5BEFEA
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 00:14:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230458AbiITWNV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 18:13:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230233AbiITWNE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 18:13:04 -0400
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-eopbgr150077.outbound.protection.outlook.com [40.107.15.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8665E6EF31;
        Tue, 20 Sep 2022 15:13:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H9z6b02gaIpGCjrOPO/m5WAH1u2ckd5QxE3BuwhgBZ/LYCgVjIOVj2Om5OUGkW5EjwfLeDO0WZEJGt08ZZcuKOlga9OI/sAXdJRDPoOhaOLi5dFOPoKJkQQeSGoa4v5at5enw/YCdSRGYZdSYU8Zpn1l53QrI0LLkdbLCQkQxwoW8LMCJOHY2nNmPZBufDfwTAZ6KYi7eg8uMGks4+zj5gSbXu34VY/7Ji1jGRhiXU6nZkf3UsY/IJjb/deF17Uxm7RjeK1djJQDEbly0Yu9JpDk5zSe5oCLtVVdXZ2wzpTDn+UJ65Ye9pXAcp5OkYp0q/RXhIWA0YBdM3t5qme5qw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JErFfUQ1xu2g9TF8RcVSZhbD/Bd6qxZ0p5OOaat821M=;
 b=Vwfr1sfYDHBbkPn59xAcftjliWVg9qh/rgX1eaza0d+zK4UujRmG+PF5PI3D/3VOuOm5mSZzt7hahWQYoeDG0bsARrtiFuSh+Cdorg5ssLEU+S8NqF3ya75EtnjpvQ86zAMRN8nYf+xtYslHMXywBQcyljcw0qfHPsXCxuA9oZ/47Y7vOj3jGQaEW35xUQh87+uPPNys2oBVhtSV/HOQ7uSdlpa1J+MUBV/mHWIiamjlVTTb7chqia+U1AZusHuMbUQmaB8CeSFZCmw4ILCYVo8uxEl83zY+wXyHQL/8v2vCOATNwIcDeCdzC7slw/5xfknPPD8+YGwIWqMGa3BBOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JErFfUQ1xu2g9TF8RcVSZhbD/Bd6qxZ0p5OOaat821M=;
 b=P2HKm0JW44xK/azxGHrM+oLbPWhH8W7DNoPQO6m3tJZxsr0XPoQ9wvArRNofrmGYHt6+FHWBOoZc9w2A0P89h/P6ZYZSbK7SZlTbC8vR8z7jOwGqIehaiVwdtpm04jTb2FcGGPBItL8C+fsbbdf/g9FhD7N+rroZTrluG0AWcN9jlZcQROOXKJgIpvutPkNVRT5ZgmngxvyolY4+SRaLIVPk/qinSHIzqd2JLWs9eQM3VdXcAv+CXhpPtcwLzh4/VfBZ+kUYRpx09ykjDWpb8LoCBIEtZLaGta2XDG4CWTDY3TaDOBi2DiSRXmRL/QV4KRAwKT/ZQyF/6MF5lwgcSA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by AS4PR03MB8179.eurprd03.prod.outlook.com (2603:10a6:20b:4e2::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.18; Tue, 20 Sep
 2022 22:12:58 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::204a:de22:b651:f86d]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::204a:de22:b651:f86d%6]) with mapi id 15.20.5654.014; Tue, 20 Sep 2022
 22:12:58 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        linux-kernel@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sean Anderson <sean.anderson@seco.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next v6 8/8] net: phy: aquantia: Add support for rate matching
Date:   Tue, 20 Sep 2022 18:12:35 -0400
Message-Id: <20220920221235.1487501-9-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20220920221235.1487501-1-sean.anderson@seco.com>
References: <20220920221235.1487501-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR01CA0038.prod.exchangelabs.com (2603:10b6:208:23f::7)
 To DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB7PR03MB4972:EE_|AS4PR03MB8179:EE_
X-MS-Office365-Filtering-Correlation-Id: 3e1476fa-578b-4d8d-b024-08da9b55464a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AJ7+ti7w95nnRNP2MNzM59nf5WUA9gux2YVpeAYDEOg4JqThmwXxvcVmZUa1VYKb9YavdgfOou9RYpBT3KQxeGgRcWPRaXRvDSiqN0f3dL5I69lPBTt5W6K7zXyRMxNiuQGNPPXH9B2C0TFreE0qkJXBYWl7raXnQAWtkoV2At8oT1qGsH4A/0ZeP/k5b9tlEs8Rr3V8m9Z8ldJZ6+8rzpbGBKBOC9kwxEOTKf9t8JPG/kOdcI/jC5XK46mEIhd4hsvmm57CGeIPTQV+xRRfOSXhgUj3tlxWr9Fb6c6VJipymEvbJDDh8MBcy5FsLGvvzxlPymuP3D/wVSrhQ2c6OJRvOh8kDj4pL04m/ndj96yIdLfEC88PWoKx4YZ2EUCH8NhUl8+LxMkfANSyiFJN9Wkk7P0aqtp3guVbn+Jy2x7j+ESkpQcC/hDqrzc0AwydT3HqeNTyccmVH9YNNBD7LRn4hdAmKKi8SLDNc6oWFsMb73gSJerb0u2PpN0Hn7DGvTLK4xdKPuEG/VZS8Buqf5TVewCFDyoEQIcHyvk6ZtIZftP6GjQ9U6c9pj3uIuecSNWLLidkphOqSG+I9jRXJghkT/HJp7pc4Aus2lbcFguf20DbEVp/+9Cl6A4TRdN5F2YkvIcpXAp/avKTFFD1taID+ruIxGcZxN/AD3cMqYHRkGSmKjZofVFdqGNgpuYkO9usU48ApgcfR06MEms4XkVEjXX4j0vr4UqK2ehhM6i3axxUp9yKiPeMC6ywBPX17t8uUqrfrzrYOUaMOyFVzQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39850400004)(366004)(396003)(376002)(346002)(136003)(451199015)(7416002)(8676002)(186003)(478600001)(1076003)(66476007)(66556008)(66946007)(4326008)(5660300002)(2616005)(44832011)(86362001)(8936002)(83380400001)(6486002)(26005)(316002)(54906003)(2906002)(6512007)(36756003)(110136005)(6506007)(38350700002)(6666004)(41300700001)(38100700002)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?W/n58PjEx9T70Mm/33nX7e4jZJwXp3J7UTwZAx2tc36Bah7kM5tcs/5c+7Db?=
 =?us-ascii?Q?q3y6TgfRJ2p+YqSvZpofAgrZ3ldUTX21Mix2ZNNt/KUQ0Nuk+L2MMZFQCekb?=
 =?us-ascii?Q?YRWlMmNj3LuHuC7PMXsjpu+7J6iwYYLeBmhCH3Vf11prXoh7q5Q+HSu1OQDp?=
 =?us-ascii?Q?Mq3adb70eysi5zQGWsS7s7MPNTCOGY0SrBQ/VoQqk+l/0oIGARWU192Mkwce?=
 =?us-ascii?Q?so1bSligg//ajFKC4gHwPO1YaXxWDCWFXAm6QWpvJWbzAsDSRXm60pduGO7q?=
 =?us-ascii?Q?mMjB4hMQ6/aAyPw0iCNwipUUwO8Ot+jzdMSJFTGkixKXj0sOxCjsz5tTAY0c?=
 =?us-ascii?Q?P5r7fdtCvc70poW5XRHRvsDKS8ZENNXQ6yUXKftJAs/jMDhEhsjMs7IJezJt?=
 =?us-ascii?Q?R8EnTXEHVFj4vBsaGV2svVOdMCoYv2sF1Z3K7Il4orOg3rY55fOMVAgyfMN0?=
 =?us-ascii?Q?i062AzqXHyBs+XZ3hyvuVGtI2sh5fYrt0io7xKxy9r1dW48ylXRCEB/qFhYq?=
 =?us-ascii?Q?xMBd9YjXHeXYBQegRX/DxmNb3QAw1G6jz8L/DJ2YSQ9XLlWgjn4Iq2riuNlJ?=
 =?us-ascii?Q?y/p1JAPm9BUx+qq4+xMoUdFdylhRljCKhRDWH6PYd5olxuyIM8EH5G/3J5U6?=
 =?us-ascii?Q?iZZ2TkEX53wE26bouMcn/hqB58rRMlmvvQfTTsXr3Ykk2AO+hBIExToeLS+2?=
 =?us-ascii?Q?cGtLP0iXO3mMuPnDxFE7rP7O8cTrTJT5pxy/O1uDdkXf1kMigoZKjLJLZyS6?=
 =?us-ascii?Q?pCP7EWpjw9hLVSBGjrBU2bY/+PGjyVqi+OdAPSgvdDV0KvY/UOYG5Z7h5iON?=
 =?us-ascii?Q?w0ZkIBo/XkuqfW1RCxDKh6u0R8m3HNFAA/fdgRb+kYuEHwWVRjgWDjYsFVL5?=
 =?us-ascii?Q?8B362xx9TuPu7IUx+XP1KuGt84x4JswRHV9NRdUGyI8qIIOdgONTjSgoXlpD?=
 =?us-ascii?Q?GV33AvYt06yD1M6ZT/80a93kZ73vbl6H/Eadtr1n4wKdQR1OANuBAawjDtTv?=
 =?us-ascii?Q?By+NbU0yp8IpE5vLYgvw/vl+RXzlFkxlyuVFt5ZFRrn4IWCoKE6OcFRUFpm8?=
 =?us-ascii?Q?tD/kZAqzQr6kjqhwm6fxN6Y2St+QTkwOz56NrF+qJHn55KwABsi5nLM6a69S?=
 =?us-ascii?Q?GoBFNnlui0fDl1OxGxt+HRa0E5KUL2QvRMeuLCj2ZK9UVNhSdkL4zyo15KnH?=
 =?us-ascii?Q?0QySwGTOOo0LdCQPgpRwK8Goji2ApafxZG6d6h43xsOH2XuYHohY5sAOshb2?=
 =?us-ascii?Q?1s8HoXZ5nQCMyDxoCKuSrnJ3BdHi4+FDd/sfzSL4yFhSEHEOw1Jxv3We2IS2?=
 =?us-ascii?Q?pfpA/JKWSL2MGIXEYCARS9iMdezBFPgN9hwFtu8S/xjQi7MYIh3GTJhlcYSv?=
 =?us-ascii?Q?mbHpwFUIS5URx2j0Zw88qBFCkdtpn+/drAolZeo4Z8y1hR+Jkwpo/FB8BrTQ?=
 =?us-ascii?Q?1eMBO3PljiMMudFwscJJXDi8vm0B2L9M7dM1bDEtb0XIicosdjAXrjf8E+3w?=
 =?us-ascii?Q?0CpDpuxXDf7ScdDCZ5BJoZzDwRI6PeBz61BJMIU7+PFQA7o76v19ZDTLXWVJ?=
 =?us-ascii?Q?GWq4ZdFHRp4hdkrHxvi1/UmTaEq7NbLI/R7HRb75plrnh/HK3ygoIH32GBY8?=
 =?us-ascii?Q?qg=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e1476fa-578b-4d8d-b024-08da9b55464a
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Sep 2022 22:12:58.1109
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: O7PVt4E69eX8hvoLP7bKlS/4xuWw0vwDwIDoCROOJFN7c4xB60gtR+vgrjUsFDvjNG9j3Fu2n7mIaqNuqUWyrg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS4PR03MB8179
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds support for rate matching for phys similar to the AQR107. We
assume that all phys using aqr107_read_status support rate matching.
However, it could be possible to determine support based on the firmware
revision if there are phys discovered which do not support rate
matching.  However, as rate matching is advertised in the datasheets for
these phys, I suspect it is supported most boards.

Despite the name, the "config" registers are updated with the current
rate matching method (if any). Because they appear to be updated
automatically, I don't know if these registers can be used to disable
rate matching.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
---

Changes in v6:
- Rename rate adaptation to rate matching

Changes in v2:
- Add comments clarifying the register defines
- Reorder variables in aqr107_read_rate

 drivers/net/phy/aquantia_main.c | 51 ++++++++++++++++++++++++++++++---
 1 file changed, 47 insertions(+), 4 deletions(-)

diff --git a/drivers/net/phy/aquantia_main.c b/drivers/net/phy/aquantia_main.c
index b3a5db487e52..b0aac1b8cede 100644
--- a/drivers/net/phy/aquantia_main.c
+++ b/drivers/net/phy/aquantia_main.c
@@ -94,6 +94,19 @@
 #define VEND1_GLOBAL_FW_ID_MAJOR		GENMASK(15, 8)
 #define VEND1_GLOBAL_FW_ID_MINOR		GENMASK(7, 0)
 
+/* The following registers all have similar layouts; first the registers... */
+#define VEND1_GLOBAL_CFG_10M			0x0310
+#define VEND1_GLOBAL_CFG_100M			0x031b
+#define VEND1_GLOBAL_CFG_1G			0x031c
+#define VEND1_GLOBAL_CFG_2_5G			0x031d
+#define VEND1_GLOBAL_CFG_5G			0x031e
+#define VEND1_GLOBAL_CFG_10G			0x031f
+/* ...and now the fields */
+#define VEND1_GLOBAL_CFG_RATE_ADAPT		GENMASK(8, 7)
+#define VEND1_GLOBAL_CFG_RATE_ADAPT_NONE	0
+#define VEND1_GLOBAL_CFG_RATE_ADAPT_USX		1
+#define VEND1_GLOBAL_CFG_RATE_ADAPT_PAUSE	2
+
 #define VEND1_GLOBAL_RSVD_STAT1			0xc885
 #define VEND1_GLOBAL_RSVD_STAT1_FW_BUILD_ID	GENMASK(7, 4)
 #define VEND1_GLOBAL_RSVD_STAT1_PROV_ID		GENMASK(3, 0)
@@ -338,40 +351,57 @@ static int aqr_read_status(struct phy_device *phydev)
 
 static int aqr107_read_rate(struct phy_device *phydev)
 {
+	u32 config_reg;
 	int val;
 
 	val = phy_read_mmd(phydev, MDIO_MMD_AN, MDIO_AN_TX_VEND_STATUS1);
 	if (val < 0)
 		return val;
 
+	if (val & MDIO_AN_TX_VEND_STATUS1_FULL_DUPLEX)
+		phydev->duplex = DUPLEX_FULL;
+	else
+		phydev->duplex = DUPLEX_HALF;
+
 	switch (FIELD_GET(MDIO_AN_TX_VEND_STATUS1_RATE_MASK, val)) {
 	case MDIO_AN_TX_VEND_STATUS1_10BASET:
 		phydev->speed = SPEED_10;
+		config_reg = VEND1_GLOBAL_CFG_10M;
 		break;
 	case MDIO_AN_TX_VEND_STATUS1_100BASETX:
 		phydev->speed = SPEED_100;
+		config_reg = VEND1_GLOBAL_CFG_100M;
 		break;
 	case MDIO_AN_TX_VEND_STATUS1_1000BASET:
 		phydev->speed = SPEED_1000;
+		config_reg = VEND1_GLOBAL_CFG_1G;
 		break;
 	case MDIO_AN_TX_VEND_STATUS1_2500BASET:
 		phydev->speed = SPEED_2500;
+		config_reg = VEND1_GLOBAL_CFG_2_5G;
 		break;
 	case MDIO_AN_TX_VEND_STATUS1_5000BASET:
 		phydev->speed = SPEED_5000;
+		config_reg = VEND1_GLOBAL_CFG_5G;
 		break;
 	case MDIO_AN_TX_VEND_STATUS1_10GBASET:
 		phydev->speed = SPEED_10000;
+		config_reg = VEND1_GLOBAL_CFG_10G;
 		break;
 	default:
 		phydev->speed = SPEED_UNKNOWN;
-		break;
+		return 0;
 	}
 
-	if (val & MDIO_AN_TX_VEND_STATUS1_FULL_DUPLEX)
-		phydev->duplex = DUPLEX_FULL;
+	val = phy_read_mmd(phydev, MDIO_MMD_VEND1, config_reg);
+	if (val < 0)
+		return val;
+
+	if (FIELD_GET(VEND1_GLOBAL_CFG_RATE_ADAPT, val) ==
+	    VEND1_GLOBAL_CFG_RATE_ADAPT_PAUSE)
+		phydev->rate_matching = RATE_MATCH_PAUSE;
 	else
-		phydev->duplex = DUPLEX_HALF;
+		phydev->rate_matching = RATE_MATCH_NONE;
 
 	return 0;
 }
@@ -612,6 +642,16 @@ static void aqr107_link_change_notify(struct phy_device *phydev)
 		phydev_info(phydev, "Aquantia 1000Base-T2 mode active\n");
 }
 
+static int aqr107_get_rate_matching(struct phy_device *phydev,
+				    phy_interface_t iface)
+{
+	if (iface == PHY_INTERFACE_MODE_10GBASER ||
+	    iface == PHY_INTERFACE_MODE_2500BASEX ||
+	    iface == PHY_INTERFACE_MODE_NA)
+		return RATE_MATCH_PAUSE;
+	return RATE_MATCH_NONE;
+}
+
 static int aqr107_suspend(struct phy_device *phydev)
 {
 	return phy_set_bits_mmd(phydev, MDIO_MMD_VEND1, MDIO_CTRL1,
@@ -673,6 +713,7 @@ static struct phy_driver aqr_driver[] = {
 	PHY_ID_MATCH_MODEL(PHY_ID_AQR107),
 	.name		= "Aquantia AQR107",
 	.probe		= aqr107_probe,
+	.get_rate_matching = aqr107_get_rate_matching,
 	.config_init	= aqr107_config_init,
 	.config_aneg    = aqr_config_aneg,
 	.config_intr	= aqr_config_intr,
@@ -691,6 +732,7 @@ static struct phy_driver aqr_driver[] = {
 	PHY_ID_MATCH_MODEL(PHY_ID_AQCS109),
 	.name		= "Aquantia AQCS109",
 	.probe		= aqr107_probe,
+	.get_rate_matching = aqr107_get_rate_matching,
 	.config_init	= aqcs109_config_init,
 	.config_aneg    = aqr_config_aneg,
 	.config_intr	= aqr_config_intr,
@@ -717,6 +759,7 @@ static struct phy_driver aqr_driver[] = {
 	PHY_ID_MATCH_MODEL(PHY_ID_AQR113C),
 	.name           = "Aquantia AQR113C",
 	.probe          = aqr107_probe,
+	.get_rate_matching = aqr107_get_rate_matching,
 	.config_init    = aqr107_config_init,
 	.config_aneg    = aqr_config_aneg,
 	.config_intr    = aqr_config_intr,
-- 
2.35.1.1320.gc452695387.dirty

