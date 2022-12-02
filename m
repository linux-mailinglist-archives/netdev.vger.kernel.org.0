Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E446C640CF6
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 19:18:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234327AbiLBSRk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 13:17:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234320AbiLBSRj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 13:17:39 -0500
Received: from EUR03-AM7-obe.outbound.protection.outlook.com (mail-am7eur03on2065.outbound.protection.outlook.com [40.107.105.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B5DB1172;
        Fri,  2 Dec 2022 10:17:37 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Zlokok0b9r6duRszF+FUik+YnQ4GtsLtGVblggblrefBLa6Z4DRjf73AapBz2gENr2vyJh5EWj60FUjMEjhDpkqN2HxEjsL8oCxCuaxUo5XGKZX0jtkhKIXwE+9gyPMoxLVGoYvnSii7k1bdn5yXDVfYcWW+/2vvWOOggoFKO+9HEg/yCpKriY5Oj+1bYh7bKq7Ypo/zXLvNiN7NHMyOMLFvfPIrTxR8VMd1PZBWGVDTY7ua9mfMDkxYeqOv+Ewya28BTM8I1P8hA7dp3wS+AbSnqlTTuail9C8fr5IfJMNz4GMVErvLVMD71anF/u86Ea3N3nN0kd6PRukJOAYazg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qcykd8ozgb3khZ4QG9LdAl4Q+yIgKs8/2rS7hQ5g3FE=;
 b=XE88+Tj+Gc5JA3N0txwGgpun2aHKzt9uLnlvA8ng6Hhl86u1aBdUcSgbeZqfXjXWIe26StCV1FmRszwK8MbtW/JsjidSUHKlpiIcs9s39EoIz0QreJ1qjJX1zJtM+dzVmPcfRwTetJAj88Xm9QVLJPMn4QViGCL06GkVrFRsxIi0DcMTMjc4GqjZQPpya/uauBlHqr8Y1YbP/WBM7aFSl+p4ToKNxKSqgs+3onvl/in+nNVIN/xEril01rVExHT2L2d8xWXS908M6CzJIUIAvsSoBvBhtyiAnJHahT/l0Cj86nuNZ3Xs8VIAL6co3CNjB3Ro9XyhBwh5xZestZ7JWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qcykd8ozgb3khZ4QG9LdAl4Q+yIgKs8/2rS7hQ5g3FE=;
 b=zA2uMZYDFTqXUrrs903RM4kaDF8vFXtLiLRTcOqE27GyxzgdxVj4hYVpleio62j+Fy9YcG60hZPJBJ6W6c4x9wDkoQBdIDKGiPV1sFZ6F+DXZ5T455aKZDEbRMWoOxHt1lZQ2LnbElhs70TNgr7jP0X8alEmmPtKCeVdZoqvT7X9dbbfZQzMfCLAI4lhoqdaHzfjYEULkPJrc96tL5AgrSKj0Ua2uH1jtM8uhfr1vUaqVHW59xnKub8c8bQORtY2yraI9pLOK8brTBkKkIhD9WF/0d6grH2arOMfCJc87JQqrfhgXWI1QeVpdU1QGfRkZ/KF7DItM5Zxzq4N671x6A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB9PR03MB8847.eurprd03.prod.outlook.com (2603:10a6:10:3dd::13)
 by DBBPR03MB7081.eurprd03.prod.outlook.com (2603:10a6:10:206::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.10; Fri, 2 Dec
 2022 18:17:32 +0000
Received: from DB9PR03MB8847.eurprd03.prod.outlook.com
 ([fe80::2b95:1fe4:5d8f:22fb]) by DB9PR03MB8847.eurprd03.prod.outlook.com
 ([fe80::2b95:1fe4:5d8f:22fb%8]) with mapi id 15.20.5857.023; Fri, 2 Dec 2022
 18:17:32 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Tim Harvey <tharvey@gateworks.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Sean Anderson <sean.anderson@seco.com>
Subject: [PATCH net-next v3 1/3] net: phy: Move/rename phylink_interface_max_speed
Date:   Fri,  2 Dec 2022 13:17:16 -0500
Message-Id: <20221202181719.1068869-2-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20221202181719.1068869-1-sean.anderson@seco.com>
References: <20221202181719.1068869-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1P222CA0012.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:208:2c7::17) To DB9PR03MB8847.eurprd03.prod.outlook.com
 (2603:10a6:10:3dd::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB9PR03MB8847:EE_|DBBPR03MB7081:EE_
X-MS-Office365-Filtering-Correlation-Id: 661acce5-8328-4344-a8cb-08dad4917ad9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: t55UeB4z2bRJ1XIpNdzykQW0EJ2GRGreu+KcsEulDffLHo9H0rOn7G888UW+9xDxhJ0vJ4IeNlzpxSQhgf2kulnZ5Qm60l3t5MOdSyCL/S4qeoUBY4p3ynhlhdBx9ecevY263Om+q6/JsNpWBbzvj2xXVDwiYBdbYFS+cBRe1ExFWRlHMDTwV8VJVJMdEB91YV/enzxVWBlCe2Hgy+KWfZfOJxCPYPQMO/Cz3oUHsc9KQG4/e3UpH0EIVE26fs46s9mqlIi5CLHyxYrneRSwctLDqH+4VBW9LbbUXKZiJUZwMJ0bpku3KOxdEzEUxo7wmWwfitQtBuOVoCm7OqhoAVPKcM4yE1P3FRWgpbDfD7aLN4P+LhXZ3IXvEWxSADD4jKUqoBQzuOr671gmofs4pqPcNIrVL68MyMGL4GEB/OkNz1zWTV4Sk+C6R5QRX27hVEsq0ePGb40HGIvEGb9JpWIPys0d4yJCtl8uqGJnZAbz5ZlBjVr46jOsX53eqBpn8bZ1fRj4cwFO956eYhbTBMwqFcddkpGvp73BFYJP14Ii93bxwewklYg8xg7QQYKWGXCd+B/oleQ27C7TpM9CA5KzzTyY4UKqaENz8DeeAXQe5vTYqHOGZDWdrctfSV5iiRYFSivzlM4Ifswg16jr/4sNrNz2TiwPOLm2cSb+sLdZ3KW189LycOkQAif7FENz
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR03MB8847.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(346002)(39850400004)(396003)(366004)(376002)(451199015)(36756003)(38100700002)(38350700002)(86362001)(54906003)(316002)(110136005)(8676002)(107886003)(6666004)(478600001)(6486002)(26005)(6512007)(6506007)(52116002)(83380400001)(1076003)(186003)(41300700001)(2906002)(66556008)(66476007)(2616005)(7416002)(5660300002)(4326008)(66946007)(44832011)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?OS6GkKjbHZ4mECyKDvKs7x41Z77a4EjVHwtsN5bcCJsHW7X5dxYtAW2Z8V+4?=
 =?us-ascii?Q?8PudHkCEbfhGVAX8JR2Jd+98qqoFcAa3IMQpaGo8ustFIztfFmt2A+KVVVTf?=
 =?us-ascii?Q?WcIllUikcyU3H0RRqSNEuwVrWWOXeyBRUrigN7UVIFTVxTi/khIKzHVNJ6PM?=
 =?us-ascii?Q?gS/5BeAlWIDr99pNdBsgRGJg4El/G+d9fQaxUiCBXAM6kPibJFuqlXK6t2Yi?=
 =?us-ascii?Q?NuGfGPhjWYNXUbwpoxEIdXhJwYhd6JzqJO1hp0lPk7w94IlPAQhhTzt5C7Dn?=
 =?us-ascii?Q?9KeWdboG7n23bjxyoklsjSb51FScvl+RH5moYTV4bocrwPMbNBIW+d+GgShH?=
 =?us-ascii?Q?6NrfUDOVQyO2yXB1U45XCKT6pU/QLLEskom9nZ0tsmowwrQBtvEAFa1yeWvB?=
 =?us-ascii?Q?8gU+Bj0rMik86Fwpqx5JHoyUJ2NbHflW9qvDEWeOGKCJia6MX9KXYNDifn3z?=
 =?us-ascii?Q?492Q3EpbiSgfL0BNBZ16FYjUn8WUJrQpUxY/xYGiwARKtrZIMCBjyvJMjN3w?=
 =?us-ascii?Q?DVMDMlRW9N2qH7rqhHyJ6fww4+PZiIzpF31ANmlOd5BsUnQBpMZVU6mZ8Zi1?=
 =?us-ascii?Q?WbYKKjeNuQ+ubH7aeBTGxTbyhwowuhUpBlzrB7NHWdw7OyFJKOwCS/UmAUS4?=
 =?us-ascii?Q?gs5cHokQKcTlfLm/RQfFkBoVFAAIfG5p4+SkEC/UX6/ElQFbOziY3wAfueG5?=
 =?us-ascii?Q?aupjSw+uz7brwgpH3RYKt0FUuWRbU++nRkIRKjTsMg5LZtr8zU4BFCncuG70?=
 =?us-ascii?Q?bKkItP/MR6gxZY6YQD+WYBT32Q8kbJ9JtDr95RqAAw4NeTUIUnOKV/7iwVyv?=
 =?us-ascii?Q?Gxfqvy4HiSDd7vvedDcwh5M5XN5HT6GehdTjThwCRhNET0LCo2Vo6uJcyohv?=
 =?us-ascii?Q?lxcdRhpcaPJYqBvVu0y93mp9fXDKfUhxDPlnfiR8jRxYYwgnBwFGrrWwa231?=
 =?us-ascii?Q?nFxcgg5QrTHnk4zHzrsdXGWqwDrqaXGehkdsrrhfJNkjy6pZxWBeROaDfnwH?=
 =?us-ascii?Q?yCpN3uhbwVAv0GLEeYljbWGKbbqOb3JT+CzF2T0kRH8skQf5HK+M/PR4nB2l?=
 =?us-ascii?Q?2wbPSQw7YNBSf9+QW/4SBSrLBGJlppQMrguqMeBQQN0XuPeMeoA/JmV2NEkJ?=
 =?us-ascii?Q?9wCsjsqHPVKl1cg4B0isZKEPrBON1w4EEVVQ3O2Ir6PF9iEjreLPAEZOYCGi?=
 =?us-ascii?Q?0sCbjObH66nGy02PoBslYNvSlmNUvOnaDcimf4NEqOh/CnPYKBWJEotUqnyf?=
 =?us-ascii?Q?l71FSJIB34SvqF0FCCiQEjpQnCncO1V1VyMXR5k2/2oU10LOHGEt9s60hUIB?=
 =?us-ascii?Q?n7xUjC3mssnzehTRSFINjjm5em5ncyPzgiFep1P/5JPEX6RXeurL3Ode/G5z?=
 =?us-ascii?Q?xnBUADbbmQsEsBcw6B+JeZNg6pkc1WruBWYWKHGxRems6PBwFddRZ6fMoVKH?=
 =?us-ascii?Q?gX80NAkylknT0l26SluSkh504PzR0i9I5wVo32c+FdRj5JyZmROap3j7wMyh?=
 =?us-ascii?Q?Bf62k55ZgQbXFJDoR+SZ3cRmKm9X8+ZCy+5DbP9ZLsD16Spnmoa6I+SsHYyR?=
 =?us-ascii?Q?9wlFbyehk9wwG60gSdaFDGDCSk6ER0ncka5RHfXt6W8y8gEgH9Gw22juh46J?=
 =?us-ascii?Q?Pw=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 661acce5-8328-4344-a8cb-08dad4917ad9
X-MS-Exchange-CrossTenant-AuthSource: DB9PR03MB8847.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Dec 2022 18:17:32.3715
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3pnDXdo0Tht0L/8VwJBVaBzXxPupDI7LBzUyWD3FoKG5nyfDBJ1WaMVdseYs0ZLOBYoxNPK33+cjfcW9ejswZw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR03MB7081
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is really a core phy function like phy_interface_num_ports. Move it
to drivers/net/phy/phy-core.c and rename it accordingly.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
---

(no changes since v2)

Changes in v2:
- New

 drivers/net/phy/phy-core.c | 70 +++++++++++++++++++++++++++++++++++
 drivers/net/phy/phylink.c  | 75 ++------------------------------------
 include/linux/phy.h        |  1 +
 3 files changed, 74 insertions(+), 72 deletions(-)

diff --git a/drivers/net/phy/phy-core.c b/drivers/net/phy/phy-core.c
index 5d08c627a516..5a515434a228 100644
--- a/drivers/net/phy/phy-core.c
+++ b/drivers/net/phy/phy-core.c
@@ -150,6 +150,76 @@ int phy_interface_num_ports(phy_interface_t interface)
 }
 EXPORT_SYMBOL_GPL(phy_interface_num_ports);
 
+/**
+ * phy_interface_max_speed() - get the maximum speed of a phy interface
+ * @interface: phy interface mode defined by &typedef phy_interface_t
+ *
+ * Determine the maximum speed of a phy interface. This is intended to help
+ * determine the correct speed to pass to the MAC when the phy is performing
+ * rate matching.
+ *
+ * Return: The maximum speed of @interface
+ */
+int phy_interface_max_speed(phy_interface_t interface)
+{
+	switch (interface) {
+	case PHY_INTERFACE_MODE_100BASEX:
+	case PHY_INTERFACE_MODE_REVRMII:
+	case PHY_INTERFACE_MODE_RMII:
+	case PHY_INTERFACE_MODE_SMII:
+	case PHY_INTERFACE_MODE_REVMII:
+	case PHY_INTERFACE_MODE_MII:
+		return SPEED_100;
+
+	case PHY_INTERFACE_MODE_TBI:
+	case PHY_INTERFACE_MODE_MOCA:
+	case PHY_INTERFACE_MODE_RTBI:
+	case PHY_INTERFACE_MODE_1000BASEX:
+	case PHY_INTERFACE_MODE_1000BASEKX:
+	case PHY_INTERFACE_MODE_TRGMII:
+	case PHY_INTERFACE_MODE_RGMII_TXID:
+	case PHY_INTERFACE_MODE_RGMII_RXID:
+	case PHY_INTERFACE_MODE_RGMII_ID:
+	case PHY_INTERFACE_MODE_RGMII:
+	case PHY_INTERFACE_MODE_QSGMII:
+	case PHY_INTERFACE_MODE_SGMII:
+	case PHY_INTERFACE_MODE_GMII:
+		return SPEED_1000;
+
+	case PHY_INTERFACE_MODE_2500BASEX:
+		return SPEED_2500;
+
+	case PHY_INTERFACE_MODE_5GBASER:
+		return SPEED_5000;
+
+	case PHY_INTERFACE_MODE_XGMII:
+	case PHY_INTERFACE_MODE_RXAUI:
+	case PHY_INTERFACE_MODE_XAUI:
+	case PHY_INTERFACE_MODE_10GBASER:
+	case PHY_INTERFACE_MODE_10GKR:
+	case PHY_INTERFACE_MODE_USXGMII:
+	case PHY_INTERFACE_MODE_QUSGMII:
+		return SPEED_10000;
+
+	case PHY_INTERFACE_MODE_25GBASER:
+		return SPEED_25000;
+
+	case PHY_INTERFACE_MODE_XLGMII:
+		return SPEED_40000;
+
+	case PHY_INTERFACE_MODE_INTERNAL:
+	case PHY_INTERFACE_MODE_NA:
+	case PHY_INTERFACE_MODE_MAX:
+		/* No idea! Garbage in, unknown out */
+		return SPEED_UNKNOWN;
+	}
+
+	/* If we get here, someone forgot to add an interface mode above */
+	WARN_ON_ONCE(1);
+	return SPEED_UNKNOWN;
+}
+EXPORT_SYMBOL_GPL(phy_interface_max_speed);
+
 /* A mapping of all SUPPORTED settings to speed/duplex.  This table
  * must be grouped by speed and sorted in descending match priority
  * - iow, descending speed.
diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 09cc65c0da93..f8cba09f9d87 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -156,75 +156,6 @@ static const char *phylink_an_mode_str(unsigned int mode)
 	return mode < ARRAY_SIZE(modestr) ? modestr[mode] : "unknown";
 }
 
-/**
- * phylink_interface_max_speed() - get the maximum speed of a phy interface
- * @interface: phy interface mode defined by &typedef phy_interface_t
- *
- * Determine the maximum speed of a phy interface. This is intended to help
- * determine the correct speed to pass to the MAC when the phy is performing
- * rate matching.
- *
- * Return: The maximum speed of @interface
- */
-static int phylink_interface_max_speed(phy_interface_t interface)
-{
-	switch (interface) {
-	case PHY_INTERFACE_MODE_100BASEX:
-	case PHY_INTERFACE_MODE_REVRMII:
-	case PHY_INTERFACE_MODE_RMII:
-	case PHY_INTERFACE_MODE_SMII:
-	case PHY_INTERFACE_MODE_REVMII:
-	case PHY_INTERFACE_MODE_MII:
-		return SPEED_100;
-
-	case PHY_INTERFACE_MODE_TBI:
-	case PHY_INTERFACE_MODE_MOCA:
-	case PHY_INTERFACE_MODE_RTBI:
-	case PHY_INTERFACE_MODE_1000BASEX:
-	case PHY_INTERFACE_MODE_1000BASEKX:
-	case PHY_INTERFACE_MODE_TRGMII:
-	case PHY_INTERFACE_MODE_RGMII_TXID:
-	case PHY_INTERFACE_MODE_RGMII_RXID:
-	case PHY_INTERFACE_MODE_RGMII_ID:
-	case PHY_INTERFACE_MODE_RGMII:
-	case PHY_INTERFACE_MODE_QSGMII:
-	case PHY_INTERFACE_MODE_SGMII:
-	case PHY_INTERFACE_MODE_GMII:
-		return SPEED_1000;
-
-	case PHY_INTERFACE_MODE_2500BASEX:
-		return SPEED_2500;
-
-	case PHY_INTERFACE_MODE_5GBASER:
-		return SPEED_5000;
-
-	case PHY_INTERFACE_MODE_XGMII:
-	case PHY_INTERFACE_MODE_RXAUI:
-	case PHY_INTERFACE_MODE_XAUI:
-	case PHY_INTERFACE_MODE_10GBASER:
-	case PHY_INTERFACE_MODE_10GKR:
-	case PHY_INTERFACE_MODE_USXGMII:
-	case PHY_INTERFACE_MODE_QUSGMII:
-		return SPEED_10000;
-
-	case PHY_INTERFACE_MODE_25GBASER:
-		return SPEED_25000;
-
-	case PHY_INTERFACE_MODE_XLGMII:
-		return SPEED_40000;
-
-	case PHY_INTERFACE_MODE_INTERNAL:
-	case PHY_INTERFACE_MODE_NA:
-	case PHY_INTERFACE_MODE_MAX:
-		/* No idea! Garbage in, unknown out */
-		return SPEED_UNKNOWN;
-	}
-
-	/* If we get here, someone forgot to add an interface mode above */
-	WARN_ON_ONCE(1);
-	return SPEED_UNKNOWN;
-}
-
 /**
  * phylink_caps_to_linkmodes() - Convert capabilities to ethtool link modes
  * @linkmodes: ethtool linkmode mask (must be already initialised)
@@ -435,7 +366,7 @@ unsigned long phylink_get_capabilities(phy_interface_t interface,
 				       unsigned long mac_capabilities,
 				       int rate_matching)
 {
-	int max_speed = phylink_interface_max_speed(interface);
+	int max_speed = phy_interface_max_speed(interface);
 	unsigned long caps = MAC_SYM_PAUSE | MAC_ASYM_PAUSE;
 	unsigned long matched_caps = 0;
 
@@ -1221,7 +1152,7 @@ static void phylink_link_up(struct phylink *pl,
 		 * the link_state) to the interface speed, and will send
 		 * pause frames to the MAC to limit its transmission speed.
 		 */
-		speed = phylink_interface_max_speed(link_state.interface);
+		speed = phy_interface_max_speed(link_state.interface);
 		duplex = DUPLEX_FULL;
 		rx_pause = true;
 		break;
@@ -1231,7 +1162,7 @@ static void phylink_link_up(struct phylink *pl,
 		 * the link_state) to the interface speed, and will cause
 		 * collisions to the MAC to limit its transmission speed.
 		 */
-		speed = phylink_interface_max_speed(link_state.interface);
+		speed = phy_interface_max_speed(link_state.interface);
 		duplex = DUPLEX_HALF;
 		break;
 	}
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 71eeb4e3b1fd..65d21a79bab3 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -1004,6 +1004,7 @@ const char *phy_duplex_to_str(unsigned int duplex);
 const char *phy_rate_matching_to_str(int rate_matching);
 
 int phy_interface_num_ports(phy_interface_t interface);
+int phy_interface_max_speed(phy_interface_t interface);
 
 /* A structure for mapping a particular speed and duplex
  * combination to a particular SUPPORTED and ADVERTISED value
-- 
2.35.1.1320.gc452695387.dirty

