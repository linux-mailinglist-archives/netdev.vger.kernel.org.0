Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F3056A5F02
	for <lists+netdev@lfdr.de>; Tue, 28 Feb 2023 19:51:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229679AbjB1SvA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Feb 2023 13:51:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229546AbjB1Su7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Feb 2023 13:50:59 -0500
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2075.outbound.protection.outlook.com [40.107.20.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08D172E800;
        Tue, 28 Feb 2023 10:50:54 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oKwixBM3VEVGE8my6aCajwQrVDtL4SmQ5j4ha+Y4HF3o/A+yfZUX85lg30qnXO+twD+MzQ2WhcRbhizwweaf4dEeYNkDsQjej9BI6er29UIgLBYXJWMjBR1YDyffpaciSvKpwsPseDEewBSKLy0kY3LNgAmGKlD5WYt4pM4UIx5UE8ByZeuJdUjiOnPmgtvDJHS6VphH6d0L6SzuY0n3yU9zy1KDwilvd2cnyu6UJtB+R0rAwa77Y7EVkHD3cmylIcmGbq4IkrKePpqJrbZPb2wROdxuf/EYg/U7LopybFntyAFu6AK4mC8SiRjFvlUIsI6Q8ICfRCbiMbiW3LYfVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b7GRhpDuVBeWIyUGqLT9rWk011t6ySRD+xMU46Yyh2w=;
 b=Ob5DyvrMarCCz58MkOQjAj7OKBfi1vFAsR0s+HtlkpJskcj4hmfskjaiB7+c5sb+2SADH9rD3mC8uzYOu9fYPXSvHEEDUzwG8w04/ECekiT586bmZ0ICBXTfClwnBTJpc2cA5EIP2ipSxQj+veOgSNHa3kmFOqcdEBGV1oRdzCfT4EFbQs8GfmqfIPJPACL6VNYKQPULVYLtElheYKqpjaPlQkXPBshruDihzaJSx4hEcAnUOUwfWXmF4O79rnjMy4zbYdBgiNrV5AXq6ZH/C3eQ2nb3GlxBn+4vLcuUwFTJWkq//qWRc4QG/G2kprfinfzt/6tIpHsHBXRIuwmNpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=variscite.com; dmarc=pass action=none
 header.from=variscite.com; dkim=pass header.d=variscite.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=variscite.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b7GRhpDuVBeWIyUGqLT9rWk011t6ySRD+xMU46Yyh2w=;
 b=SJlJ0v0jx1ubMn9qxPIx2X/pNPpb+9WxqtT3yuK+HlgVG5i3ybDFwLiRnsxSP0+20py0yI2DHbvtfeXoeO5jHPbvr29JQXwPn8MrqJyiF+TA/fKlhb5/DzIfph4yOmfF3X3WS+a2rigUP2vfJu4bRm7YIiRWj/+o/PqXCD2j7z9xvdoHdguM40hi5YK5VjSi8iPAy1Jv46UnoLF6kkd+z9LehyBdr36q8peyLVdG95lNSHp18Xo+VC1F4DxGf7ZnqgyDV/02vb5FH9MCck0uxG96cebSGK5N4/o2xBVzaEluxHSsSxMrjQd/9GpGTtxkDS6+RMoktFrkvE+flxrqAg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=variscite.com;
Received: from DU0PR08MB9003.eurprd08.prod.outlook.com (2603:10a6:10:471::13)
 by AS4PR08MB8168.eurprd08.prod.outlook.com (2603:10a6:20b:58f::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.17; Tue, 28 Feb
 2023 18:50:51 +0000
Received: from DU0PR08MB9003.eurprd08.prod.outlook.com
 ([fe80::27d4:87f6:273e:4a80]) by DU0PR08MB9003.eurprd08.prod.outlook.com
 ([fe80::27d4:87f6:273e:4a80%7]) with mapi id 15.20.6134.025; Tue, 28 Feb 2023
 18:50:51 +0000
From:   Ken Sloat <ken.s@variscite.com>
Cc:     noname.nuno@gmail.com, pabeni@redhat.com, edumazet@google.com,
        Ken Sloat <ken.s@variscite.com>,
        Michael Hennerich <michael.hennerich@analog.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Alexandru Tachici <alexandru.tachici@analog.com>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/2] net: phy: adin: Add flags to allow disabling of fast link down
Date:   Tue, 28 Feb 2023 13:49:55 -0500
Message-Id: <20230228184956.2309584-1-ken.s@variscite.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230228144056.2246114-1-ken.s@variscite.com>
References: <20230228144056.2246114-1-ken.s@variscite.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN1PR13CA0016.namprd13.prod.outlook.com
 (2603:10b6:408:e2::21) To DU0PR08MB9003.eurprd08.prod.outlook.com
 (2603:10a6:10:471::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DU0PR08MB9003:EE_|AS4PR08MB8168:EE_
X-MS-Office365-Filtering-Correlation-Id: 9b195a7d-70e3-41e4-8e0d-08db19bcb6b9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: G+TqIPpLZtIlhmp8sVNCuEIX3thJfpMNZUHxvD18t1gIG6xZOdiC2OL3onWhT0fY86gUwzWw1V78rPL7AX1iQ995eVEqcJAKd5gRO81rG8ENtcrHNIy3oTfi5auUCWuMnfWTzHK/aayq7ouD3XaAtXfK88x+cWCewlZNybf3SwSGcYp0CjntwkjxtRm2DBB81jZfmd+3POiydvhGLcLVduEnmzQAguj3XKgeg80JN/frVChQcBttNh8ThuTZIKBIDC5Besna3Uxks1fTL2hv2kx14GMQkaYsQohtKiVmE/e7RAbX8LC6VpRiSKY2D2LqL4AZ21YC5f6n/O5uRvdQf1TtqkHKGGbKFD4RY/0OlfcsfQuWeuuPKGrpsVKKTxGDlXkR80fT6aRcjtsy7hHgmOgV8/o8mq8DSHjbDScncgnFp7cMYtX0LjM1GE5kEhHSUcMYabNeDG9zCjnJfeL6vCWh/rD5nHYzOLGBez7elq7APgEmWU4231RDdFs61hul+GGKFdTLc2dUdXzUgHVu1Uf6XEPkrKZvgQGAkgPQJRr23+L/2q+Th6zmmdfYLJBmtNzzUdWhSWs2A45tQMZI719KgOdZgrVUCulug8V1AdPxW7mu3dvwxQhRyi81mwE4QgHzFDUhQ0n2d5ksXccQi0QdIX4xmNUXZD5iXD7Alr6y2NFcNiMWdzAzJSpWqRaygt4I0fWGCFZCJLcidOnv0BrODbyI/jaVXLKuSW/ttQM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB9003.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(396003)(366004)(346002)(39840400004)(376002)(109986016)(451199018)(83380400001)(478600001)(316002)(54906003)(36756003)(4326008)(8676002)(38100700002)(38350700002)(2616005)(6506007)(6512007)(1076003)(186003)(26005)(52116002)(6486002)(7416002)(5660300002)(66556008)(66946007)(66476007)(8936002)(86362001)(41300700001)(2906002)(266003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?u0Pfid3eNswsLe2X8/AJDFDJZoOqNcwgq1Ix5UVOuNNPmNXPHrQONEGcYeRc?=
 =?us-ascii?Q?21d9p+ZxPV72zSVzEMvmSeyTV1/Umy6zyNhr6esK18p1pJjNjR5qaGGqjfya?=
 =?us-ascii?Q?Lv8kqP1gtzLfJ3sytPgNvl6MPlRJbMXzK4It1Niz6cUWjfzBa4fF+Iovm2QW?=
 =?us-ascii?Q?Dj6mLp5Ir7A+PyEk7dsglqoTInIU3G2aqciHTmedEcZYUqEYUosGJd/LvrnG?=
 =?us-ascii?Q?hp3LBMJfet83coKd/njxYAkEC6b1P3oLmvUw4sNckuSJl0XIHnACruwKoA+v?=
 =?us-ascii?Q?zYFsRe7pYujkWX5BLCzYZgov3d4ZPjJEVAekRW8PmaQ562pvKXW2cBUSYTT4?=
 =?us-ascii?Q?ro5GsqYlNvwAjS90DCbf5Bh7730XOWsMkkvWGZ8E+SHXVS4HLpJXrbG1Iw+j?=
 =?us-ascii?Q?DQNlgnV328GqhH91WKxDtK8LDvnmI05Bda6v8gXH63C6dcVuSKnyX3/PPlJ0?=
 =?us-ascii?Q?rcmY87/SGxhZcH3AE4JDvdaCY+LjC4htKzmrvzOOV0wqgZI1/frWYgxFX3tp?=
 =?us-ascii?Q?D8lx4U534H1q7ucVy0WF6f92IdjBV6dnNFEIBmiRzaiFncuLSZ0+B0W7dHfp?=
 =?us-ascii?Q?WgIC2GlLhgJAwLdgvyHU19s40+ntLqRCFvf8UxI1elWBX8fxvfd4odeHB/oY?=
 =?us-ascii?Q?nwBAiLtiLQElnnsEcpXX17/z1s7xGBNj40OD9eUANjXze5dRE6XJvbMpWmzi?=
 =?us-ascii?Q?eU1lqU0mVuJpoTIjzWFRILby5geVXWciYeVXOenzzzZMBkr8aAs9Tkh8pCaw?=
 =?us-ascii?Q?FaReFMQuPVcq0zI6NLrrUR1ACx5A2eKHyQcM/YasOgN2JwdfNILSyrQEOA2C?=
 =?us-ascii?Q?q7sAqj9KnVV5xIwECBUuc0QuNKbMrS8N2avsHIlGHXJ4f20OWugy9ulF08Z2?=
 =?us-ascii?Q?3JLADIgTc/yZqauLh5049FTtd5cibFnUOyunpO+hVnO8bmkQngkYqGiinH5c?=
 =?us-ascii?Q?X+V0PuCnqZdfIw22MphqF7+50uvWiFiAaqr0HKABsuWyxKfxV8p/YhCpLiic?=
 =?us-ascii?Q?tSoa3M+2P0gSSEGwDRYDmJ6Yk7nuAJCGBATmzv/emGMzLWvo4FUF9eE8Y+Dm?=
 =?us-ascii?Q?DPKtfAsNg5WWipmPrHpj7fnJsXMtNMhnIAP3eSpIia9NPuqRR960hGN6EZoh?=
 =?us-ascii?Q?5c/XO0jKXAj8CFIKMIZZguKfdYi1cNIIai/NLhLDM7RGWDAHMoMJ71vzkWRB?=
 =?us-ascii?Q?/ACiGlQZINOtqGHqZMkzUAcR0+bSsft0dsBaQyWXW8xHOlnw/KDOcnXv5U4s?=
 =?us-ascii?Q?WsD+lxIH5Yq73lZLn33t0kdRXkZDrwuQvxirjZRaSmPFnN0v5Dh8GzAjSA5G?=
 =?us-ascii?Q?jVspovvGTW/VeZ+kR2cXdC3wTi3U1F30WQTiXzf3c10C1yGSU7xeeWKKWJyg?=
 =?us-ascii?Q?IsLvT+9rVBEo5f9l93k/YiqpoSrHUQslDOUcM+iFyP55KIM+5caYomQnjooG?=
 =?us-ascii?Q?fSVVt6a8zUNJnbYBAJdIz+JMdRoei4xazrLCS/ibnUymPP9avM8C9POHr1rB?=
 =?us-ascii?Q?i9xMVtTIfkwahcpEIAzgF+4hz3ygBusjVQntQkzqUbQrzsGzA9sTTi4HsvF6?=
 =?us-ascii?Q?+4uzk/ZqBAwBUI63LezbeECEQPHNphfGpGtXk8Hz?=
X-OriginatorOrg: variscite.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b195a7d-70e3-41e4-8e0d-08db19bcb6b9
X-MS-Exchange-CrossTenant-AuthSource: DU0PR08MB9003.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Feb 2023 18:50:51.4778
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 399ae6ac-38f4-4ef0-94a8-440b0ad581de
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PUXdoYAvpomqXsSMOnVH7tYuKaycWX5+xvHFJGW2F/yxbFJvPbEYHkbt+IHL66cBMTcyuBC3h69jpd7W3cNRdQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS4PR08MB8168
X-Spam-Status: No, score=-0.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,RCVD_IN_VALIDITY_RPBL,SPF_HELO_PASS,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"Enhanced Link Detection" is an ADI PHY feature that allows for earlier
detection of link down if certain signal conditions are met. Also known
on other PHYs as "Fast Link Down," this feature is for the most part
enabled by default on the PHY. This is not suitable for all applications
and breaks the IEEE standard as explained in the ADI datasheet.

To fix this, add override flags to disable fast link down for 1000BASE-T
and 100BASE-TX respectively by clearing any related feature enable bits.

This new feature was tested on an ADIN1300 but according to the
datasheet applies equally for 100BASE-TX on the ADIN1200.

Signed-off-by: Ken Sloat <ken.s@variscite.com>
---
Changes in v2:
 -Change "FLD" nomenclature to commonly used "Fast Link Down" phrase in
    source code and bindings. Also document this in the commit comments.
 -Utilize phy_clear_bits_mmd() in register bit operations.

 drivers/net/phy/adin.c | 43 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)

diff --git a/drivers/net/phy/adin.c b/drivers/net/phy/adin.c
index da65215d19bb..0bab7e4d3e29 100644
--- a/drivers/net/phy/adin.c
+++ b/drivers/net/phy/adin.c
@@ -69,6 +69,15 @@
 #define ADIN1300_EEE_CAP_REG			0x8000
 #define ADIN1300_EEE_ADV_REG			0x8001
 #define ADIN1300_EEE_LPABLE_REG			0x8002
+#define ADIN1300_FLD_EN_REG				0x8E27
+#define   ADIN1300_FLD_PCS_ERR_100_EN			BIT(7)
+#define   ADIN1300_FLD_PCS_ERR_1000_EN			BIT(6)
+#define   ADIN1300_FLD_SLCR_OUT_STUCK_100_EN	BIT(5)
+#define   ADIN1300_FLD_SLCR_OUT_STUCK_1000_EN	BIT(4)
+#define   ADIN1300_FLD_SLCR_IN_ZDET_100_EN		BIT(3)
+#define   ADIN1300_FLD_SLCR_IN_ZDET_1000_EN		BIT(2)
+#define   ADIN1300_FLD_SLCR_IN_INVLD_100_EN		BIT(1)
+#define   ADIN1300_FLD_SLCR_IN_INVLD_1000_EN	BIT(0)
 #define ADIN1300_CLOCK_STOP_REG			0x9400
 #define ADIN1300_LPI_WAKE_ERR_CNT_REG		0xa000
 
@@ -508,6 +517,36 @@ static int adin_config_clk_out(struct phy_device *phydev)
 			      ADIN1300_GE_CLK_CFG_MASK, sel);
 }
 
+static int adin_fast_down_disable(struct phy_device *phydev)
+{
+	struct device *dev = &phydev->mdio.dev;
+	int rc;
+
+	if (device_property_read_bool(dev, "adi,disable-fast-down-1000base-t")) {
+		rc = phy_clear_bits_mmd(phydev, MDIO_MMD_VEND1,
+					  ADIN1300_FLD_EN_REG,
+					  ADIN1300_FLD_PCS_ERR_1000_EN |
+					  ADIN1300_FLD_SLCR_OUT_STUCK_1000_EN |
+					  ADIN1300_FLD_SLCR_IN_ZDET_1000_EN |
+					  ADIN1300_FLD_SLCR_IN_INVLD_1000_EN);
+		if (rc < 0)
+			return rc;
+	}
+
+	if (device_property_read_bool(dev, "adi,disable-fast-down-100base-tx")) {
+		phy_clear_bits_mmd(phydev, MDIO_MMD_VEND1,
+					  ADIN1300_FLD_EN_REG,
+					  ADIN1300_FLD_PCS_ERR_100_EN |
+					  ADIN1300_FLD_SLCR_OUT_STUCK_100_EN |
+					  ADIN1300_FLD_SLCR_IN_ZDET_100_EN |
+					  ADIN1300_FLD_SLCR_IN_INVLD_100_EN);
+		if (rc < 0)
+			return rc;
+	}
+
+	return 0;
+}
+
 static int adin_config_init(struct phy_device *phydev)
 {
 	int rc;
@@ -534,6 +573,10 @@ static int adin_config_init(struct phy_device *phydev)
 	if (rc < 0)
 		return rc;
 
+	rc = adin_fast_down_disable(phydev);
+	if (rc < 0)
+		return rc;
+
 	phydev_dbg(phydev, "PHY is using mode '%s'\n",
 		   phy_modes(phydev->interface));
 
-- 
2.34.1

