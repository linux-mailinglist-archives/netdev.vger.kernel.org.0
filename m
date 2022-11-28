Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5AD263B296
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 20:55:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231193AbiK1Tz1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 14:55:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232931AbiK1TzY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 14:55:24 -0500
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-he1eur04on2045.outbound.protection.outlook.com [40.107.7.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A888205E1;
        Mon, 28 Nov 2022 11:55:23 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KAq/qIIfHZEwy3okBU0GmyDFmLuF0cM2ls1q9UwMfNupuvh1wcXISUDYTNf2KsEwM+w0dcIF9fzfpn+zTw+Doi1d4kE+OMi11Z2UhRvdI2cIuMChkNOrgWXQEE3wLzFfdIOccHLMbSNNKzCktZ0cIE7zlPxocH1Bc7eTCWW8hkikl5CFGeqvvtVm95Yem+YSOXBPq+Ct+kmbmYuXlgQqvJ99466/IBk63trqhJrwQ2krggAYCm43FYw7DQ2yLBvU26hB44QFh8RWwxQ8xtXWRzNXPxHM0mXfpo0TUiel7X46B8N2h7sE1VJgVTPwXIKyoAyjHMKg/omygBlK+aoaPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=B1ow1JDImsxrurO/ZmlXekwKK0WwkV5Xup+3WG6T+LU=;
 b=A2DyoT3zRXsjsqODl2uyTWZLj4L10O8N3ntf/MZYBlup6wXfI+YOT0TQPv1zJPWZ/YMKgU7Iji+6+tN9aBJpjl2u0nc4/198ztwkmnKlmM+VZaHduwj9LQ/SOL8E12zrYzk7toycb+84mwG7FByMugnd4Bmfr8HNIQtIWPoRcII55qH0QmA1oo5BKUqIeR8LjdQecpe+VDbE6olTBg+sCXvN0aVYBObRCCJ14HeGD4oq/p6+P5O+fu1L4+DuP8ydYTzI4SQMFM/xfS1lz/wldG2sSYnZ9L4mMGhHOYsVVy4PxKGCUIpsk1VgJuS3dsR28YZvUWvQPZ5az2iVB27PHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B1ow1JDImsxrurO/ZmlXekwKK0WwkV5Xup+3WG6T+LU=;
 b=Bqgoxv0M6pB43FkkM7/G6ovpjAaByqJynM4LgK+s3SToBNvF/W70sYUfY7LHuOcWYPTgJgeOiQZ5ZQ2OfB8Y2huqGIf55L30cAlHiM8m5v8M0kdwCzFL28Qlpibw/43ozd6YXbOOlbm+UWe68OCic0UxBlZ2ZCo2WVbbyJBL9z3a725wkPio9pRJ0ZTD4+u8FUOhsaELMcVawcy6I7tR/GYBN0EtFG4GpAFxQdvBlLnfJ7cZQJKhMvgdRZ8ReEydIWoNJbH+ENOp5sAUU8qy6qPhhXms/VZPzAsWvKuscReROW1xATpatAuWHcsKo2/+px1frsmbpFXSZxTb8nKDkg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from AS8PR03MB8832.eurprd03.prod.outlook.com (2603:10a6:20b:56e::11)
 by GV1PR03MB8816.eurprd03.prod.outlook.com (2603:10a6:150:a2::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.21; Mon, 28 Nov
 2022 19:55:17 +0000
Received: from AS8PR03MB8832.eurprd03.prod.outlook.com
 ([fe80::bad2:a53e:f389:6347]) by AS8PR03MB8832.eurprd03.prod.outlook.com
 ([fe80::bad2:a53e:f389:6347%4]) with mapi id 15.20.5857.023; Mon, 28 Nov 2022
 19:55:17 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Tim Harvey <tharvey@gateworks.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sean Anderson <sean.anderson@seco.com>
Subject: [PATCH net v2 1/2] net: phy: Move/rename phylink_interface_max_speed
Date:   Mon, 28 Nov 2022 14:54:08 -0500
Message-Id: <20221128195409.100873-1-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BLAPR05CA0031.namprd05.prod.outlook.com
 (2603:10b6:208:335::12) To AS8PR03MB8832.eurprd03.prod.outlook.com
 (2603:10a6:20b:56e::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AS8PR03MB8832:EE_|GV1PR03MB8816:EE_
X-MS-Office365-Filtering-Correlation-Id: a2111223-2354-4534-fb65-08dad17a77eb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9PtGTJT0GWjPwLhA5W7zJ6veas1AqwKGQ+j60VBjxqcRCpuzWlFhXISA87d9AsqTy4GDBk/pnAbJcGyybUSFTwaF9G9UaloBnWKqtZ3bOxLjZ2GNN0kIWxerJcIr+Q0tIWoHro997HvFKHkjTmBCAg+PRkylNj31QrHzpRltSxnR6ZnJmhWnBSoY2YbRg1I81+zjxWhJT6lbHlCrz6owahqnjtMC+4yb33FpM+AYwGjA+znd/w5nS1lEhIoyeWzyBFQyp7vPj45KDGLyajFkQErQzrrVpfJHdyLeouU7lRwUBbPS4Ve/2BrGwBolJRFdH4icsH/T04IgJXT3TKRPbs3N9C1MJ5vLexOd3g5nYdJQUu14Atg/pIvHzR1i9keQ+awlq4xheyRg3jSnKf4lVTOz0Br0dl/go6IBKmURy948zNsukkhcj5VR3rN2sMpKXSJrPxkyhBj6AaA8v929I+Xj54l4XFSyyAs9pqowhjoI+SMRLB1cj0OsDSoxAHcGfLL+Ba9ipEC8mPks7+4dyDk5oL8wlEES6TYYG2qpjjUfmuLPcNxuVZmjF4hKjv5AdkCi/khd5hMMCUoSm2HgImVXGC7mDSTgBEIlaarPAIaIdUZEUi/fhd+g7jJgnLKUQtP1Pe2p4jaWWgbXN2O+qWRF2CsAs29/FmLmgFPE3kgNorbD3lIJIIqQmrlRDGvj
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8PR03MB8832.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(136003)(366004)(346002)(39850400004)(376002)(451199015)(38350700002)(38100700002)(316002)(6486002)(54906003)(478600001)(110136005)(83380400001)(41300700001)(26005)(6512007)(2616005)(8936002)(2906002)(86362001)(186003)(66476007)(66556008)(4326008)(8676002)(7416002)(1076003)(52116002)(66946007)(44832011)(36756003)(6506007)(5660300002)(6666004)(107886003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?phg9P5Md4oo+R0Gll/8U1EzaLcm59YO3h10n0jJD/jOTw55CKH3jLHMJ34hl?=
 =?us-ascii?Q?XPNfsG2VT7m0PR5HFqTKp54Ey+MSROxuggLsjvJakxZz1sTmk93sszSpzEhI?=
 =?us-ascii?Q?9CQAMKsrDccIuS6yGtDtkMOwtw2xMSjU/EznJgnGxsHd//CvhdkueViGQS7j?=
 =?us-ascii?Q?iekfpgRYOzIckwjETYalINouJm8rqSecaMuy0ERDa0hFs9kQSD2C9F75lSd+?=
 =?us-ascii?Q?YNFHet7qStU0dqjkVc9K19LTckCCDzXmV7ObR9puFqPiACJNo1jhfSPjmTGu?=
 =?us-ascii?Q?ibSywa/nOtISNyF4+1IfG7FmqT9EUhHdAGLa3IWJdeE8+wy3DBNEuN+Rc9Aw?=
 =?us-ascii?Q?BGVBHzAvzywPzsXUqLxVBmJcdbiuf3iqyxUf+tB1jRoCfBXRS/oK0d7ePf39?=
 =?us-ascii?Q?ICAajs5Yk1Ffze3ZjSqviU1FtH84/qGO03YbPzp1Viyiv/orsSJ096cj5cAH?=
 =?us-ascii?Q?D8cAVe3J1jxgB2zzPnlhE/Sh44Zpr17VfSA2YXwLbPZKEZN+gn5NeCNK8DC6?=
 =?us-ascii?Q?TBUFOUR91vA743z8BiWxlGKV1B09NSWTsDV26bZyvaJYzMzMWwV7QAV4f3kA?=
 =?us-ascii?Q?SVexmnfaUOVnVPRXzadpaI0HwS28dXR1K+hvwohIJQOm6kbBOWy2kzx53qbh?=
 =?us-ascii?Q?cGRDD/nTxKVxkNSZ1SKZ2yBs+BXxx+AqBoZMhDG+zqBWexnLTKLLBDMgNAos?=
 =?us-ascii?Q?royDd5VpttPR4MP5aNVINQ1Jgjjd6UJdEi2mVU3V96BkmJGPPwBNBnHO3y93?=
 =?us-ascii?Q?UapK2tnRulOovBmN4EqRD36U7dX4lihwQf7x1rRQhmjUqDhhXXNAkxxVe2Kg?=
 =?us-ascii?Q?1d5i43waD1iH10eNLPfyfQUgiwvx6OVqk5Zazl77Su5orUKjbZ6QsN5I/xgG?=
 =?us-ascii?Q?w4Ygzaoo+yzcJHo8C2b8E8M/bXBaxRRU0V3YxgRf7hJBqzhW5yxaoLVlr0sF?=
 =?us-ascii?Q?8T7R9Qv6e12NhLpK2FVghggNo6aLQI7RPcsrdkSQX0eaTHQgT9DNWhYPMd+/?=
 =?us-ascii?Q?Dl/ZrpBa7/Q2SzmI0lY95MHUGQX33XiNlGlkBLdtux8kzbn+hU3Tg/veqNFB?=
 =?us-ascii?Q?gt8cAAUKc6Qs6B8RmaRuQjfv19IM5jUyKGI71510hsWqD6Apba5MTh+9owi3?=
 =?us-ascii?Q?NaIf1GgmSE5Pauay34wEQY1JK2S8yuqN2JAI3dXTiHL8KKgvSppcAbWVDFPN?=
 =?us-ascii?Q?1KjL6jWh/xdyFas/rrFHy0FmeYD3ZACQFHsLraaWEGU14uMQhU6Rvu2vWOBq?=
 =?us-ascii?Q?CUkktOXhcqUQd3O2qQwvawUuabpnEdfVpxDOSmMZ2yH6+H4+3SUZ3VGL5Ly1?=
 =?us-ascii?Q?FfgKyFnfQDdJ8xXXAfpVvz+lPLJlgfn29VPoAxX4r8Ws17tQnBYo95FRN6RU?=
 =?us-ascii?Q?CHDKGLX8GOmA7jJaV5uKFe0XguCiCoEaBLjl2/Z2MJPdYL0SSqqPH2g4zrSS?=
 =?us-ascii?Q?fb2AVEZXtU8bZF0xF37wDTkD01NRoJjMIGdQAzWs0Hjlra4iANYa2B3l+ULA?=
 =?us-ascii?Q?Yxu5N8Q0cIgStOnNPbQmccjAIq2mTp4XQMsdXhUEnMzDq93aODkZ3uRW63P0?=
 =?us-ascii?Q?AsWCLRV/J57aPP55BQuo3sP0kiMR6DBLQD8SjpB1jrsJWrFYNoMDeWo0bR/l?=
 =?us-ascii?Q?EQ=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a2111223-2354-4534-fb65-08dad17a77eb
X-MS-Exchange-CrossTenant-AuthSource: AS8PR03MB8832.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Nov 2022 19:55:16.9504
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: c/s8ZNUtWxrhRCZZgOoPuXULQ3Rh2JSheP9NqRgADkHyEcF0LXgKzEUtZAzFz/+A3VpzPy0wel/HNS3T4rW+RQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1PR03MB8816
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

Changes in v2:
- New

 drivers/net/phy/phy-core.c | 70 +++++++++++++++++++++++++++++++++++
 drivers/net/phy/phylink.c  | 75 ++------------------------------------
 include/linux/phy.h        |  1 +
 3 files changed, 74 insertions(+), 72 deletions(-)

diff --git a/drivers/net/phy/phy-core.c b/drivers/net/phy/phy-core.c
index 2c8bf438ea61..a60ab7946bba 100644
--- a/drivers/net/phy/phy-core.c
+++ b/drivers/net/phy/phy-core.c
@@ -148,6 +148,76 @@ int phy_interface_num_ports(phy_interface_t interface)
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
index 2805b04d6402..90536f3120ec 100644
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
 
@@ -1202,7 +1133,7 @@ static void phylink_link_up(struct phylink *pl,
 		 * the link_state) to the interface speed, and will send
 		 * pause frames to the MAC to limit its transmission speed.
 		 */
-		speed = phylink_interface_max_speed(link_state.interface);
+		speed = phy_interface_max_speed(link_state.interface);
 		duplex = DUPLEX_FULL;
 		rx_pause = true;
 		break;
@@ -1212,7 +1143,7 @@ static void phylink_link_up(struct phylink *pl,
 		 * the link_state) to the interface speed, and will cause
 		 * collisions to the MAC to limit its transmission speed.
 		 */
-		speed = phylink_interface_max_speed(link_state.interface);
+		speed = phy_interface_max_speed(link_state.interface);
 		duplex = DUPLEX_HALF;
 		break;
 	}
diff --git a/include/linux/phy.h b/include/linux/phy.h
index ddf66198f751..bb160611d9ad 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -997,6 +997,7 @@ const char *phy_duplex_to_str(unsigned int duplex);
 const char *phy_rate_matching_to_str(int rate_matching);
 
 int phy_interface_num_ports(phy_interface_t interface);
+int phy_interface_max_speed(phy_interface_t interface);
 
 /* A structure for mapping a particular speed and duplex
  * combination to a particular SUPPORTED and ADVERTISED value
-- 
2.35.1.1320.gc452695387.dirty

