Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 044265AF0CC
	for <lists+netdev@lfdr.de>; Tue,  6 Sep 2022 18:44:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234302AbiIFQl4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 12:41:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236580AbiIFQkz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 12:40:55 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60081.outbound.protection.outlook.com [40.107.6.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B45C11800;
        Tue,  6 Sep 2022 09:19:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cnHOePxcC2p5Y8nkFbP48+ZMF2WEcdHv2TxZsgwh7+Ca9l8VuC3MvFCa0jUpNAfzakUwt0N+sfLRHeXaT0WPuyBsRJDJSw6fG3/RPrA1QqbWcNqSOU1PSoiyQYAKA6YVwWNMvCIusCeyOe3reLt02WXtibFh506y+OdeDZp11mWh+bmJqnAqRB4NKpUSMxo2nCjz3tdyXez5XXMtK6PQXyprogsRwsnZCLkm8xpu1RWfleogcyvwkaCsQIuAb70BkW4Rh5r5JQJCVqbhi4bE1k4bpIeRaKAte3vJgUY9TN2L9cYx44lOGo8af2FKjufJjq/NEWtIjez3vE9v8DshIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=msiT+UkpoCrjHVQp2GSjV0d6CwJSb1xGjry1C/EbVZU=;
 b=fAAAIAyEQSlGDLu1NDtLboTnnZN/DS5/Jnsp/xW/C+HHLhlELHq1B6hPvJrgTeCay3aBgeEmXtzWO2b067Y5EDiO1vbP86nZL1PcajNMHUeGXSTz7PzqL++g3V5mSZpA8y8Y9iTAlUeDWrTVRCJHrmRGjHN46EAZEUN6iC2Wi7c25sHLyrqhd+46AeTXcgvFUQAeBQ6pgkTrc4KBi37w9V+ZjzADist2ysmLwWkFYv3JQzi4Rz4n2MdIQiRni7E98BFI2hSeZbES0ltCqW2hW1Oom9XzLWbQ4clqf3MTbZyDbxXegvT5tBW46BJk1oi96fsCuOHhBk0AKOICkZF0yQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=msiT+UkpoCrjHVQp2GSjV0d6CwJSb1xGjry1C/EbVZU=;
 b=zTR5JNE9DY9fAAzSmtO276HYmUbrfuCBZMpaxfljqUGQiQNjcJVrwTFx9ohh+/dBocq/4Tz4DGofgMbNhXR6Gt9B8bIP9VBIYSgOBVj5GiHVctEMFIWoEdyg6dErsedGdRIOycKmmvnULCjaCpXUIyEmU/WK5A0BVF54qxvzYRsfpvoni2O54E7aaZkBKv+IGPEAYJX3JrtRGMGRDtV7PeXhjcv7ajtzoGsP7k/jHIDGaIm7FqbNpA7XIlpD/xUg63eo+g5gHr4L1I/VspPsluBsDwugatUMdvV1kL9iSfEuBUrVV+28OFH5QACKj+UZxcqsP8r74vPY4y3A/iL9wQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by VE1PR03MB5664.eurprd03.prod.outlook.com (2603:10a6:803:11d::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.17; Tue, 6 Sep
 2022 16:19:18 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2%4]) with mapi id 15.20.5588.018; Tue, 6 Sep 2022
 16:19:18 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        linux-kernel@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Sean Anderson <sean.anderson@seco.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next v5 7/8] net: phy: aquantia: Add some additional phy interfaces
Date:   Tue,  6 Sep 2022 12:18:51 -0400
Message-Id: <20220906161852.1538270-8-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20220906161852.1538270-1-sean.anderson@seco.com>
References: <20220906161852.1538270-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL0PR02CA0046.namprd02.prod.outlook.com
 (2603:10b6:207:3d::23) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a9a3cb16-b3a0-4d2a-ac61-08da90238a32
X-MS-TrafficTypeDiagnostic: VE1PR03MB5664:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /TE6v/DCCqjtX3c+1ETdBII382QbwJjrr3jR1Gbdd7zQU3bM2Yzqspqonl67AC5PP4I5wU47ODNEbL5XBOvB+V35Wr8b/TvVzO2nnlg0YfytsRSXYeH7wCQ36gmnTK7u0mHkDK7dRFtJ1fFLyuAahYGYjcxrELBmMcAA4YMITP2E9W3+LjNwxgcVPoERfTtBByRZ0gJb6h0m+ZN1JS/rZWnPL+hxUnQkJQz+Ioz6V6FF+GSxddy8dMqYIj8XS1Vafrny1Doe0A5G74rdTTTcV9Bi0FjBtovAXRb6vNs8vuVtJAJhdBtu4Fu51h3TZYiDWij3v2h9DXWPFB6iww3AwbWDEAFgERcw5NY6bnCvRcLNZLTf5gUOACMNbpHc8YACEgRMsU7eFyalpQ/TORc34cREKgYblkNpP70qEoZM2JlDWREnL4B/WGU0TScVJmEqmNhXETC3TdM8qiJfQpv4yr/c+M0iGcRru1o/tZEZ0KAG6vMv0+WO6/mhZfAmt8DiZ0ep9wI/LLQbuz+CQfXdR6mucj42jNiI9CGfFjSRLTExBAQn0MsWm8gOKnjfknMw9xZOJuwCd5eCqLV995uMsvvcPlOEb4HTUJjASrD0ZGA1hQbnzGgQbQQEMOka+7Wj7h/56zCjVYpGX4LqP/jF0V/RxI7FISdqpqtQhiLcVM7eFUD6peoacPiJAGW3fAy/yfAJZweziho8wrdZd6iIvwCTbiNYYyLl4fCi6kHmjtD/hCAuJEAXK/dkQbesUeeOPS14/WabUQxqrSF1a5ceEQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(376002)(39850400004)(346002)(366004)(396003)(6666004)(26005)(6512007)(6506007)(41300700001)(2906002)(38350700002)(83380400001)(478600001)(38100700002)(6486002)(36756003)(4326008)(7416002)(66556008)(66946007)(110136005)(54906003)(316002)(5660300002)(44832011)(8676002)(66476007)(86362001)(8936002)(186003)(52116002)(2616005)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?sVpGdw/Ph8Mj4FjnBpQ7s3VW5Un0Ua6TJthMmtzOeBdIgQe1wJcufADA2zE5?=
 =?us-ascii?Q?MPQl1t4j+1jJ1xbhepgvMBSjXVM+xIghCldcmub9oxKaoIsxabiNXlodkwZv?=
 =?us-ascii?Q?uOAjsbgZqVN7yPTBKFLzmzGW79f5zCeRER8VFD4nmBjZC01ay6ErgLVr/gA7?=
 =?us-ascii?Q?93mC8hZS3noNtOYWma77boUKGnTbBSUx8X2TWh+6UFIHPbzkbXPx3/piS5XV?=
 =?us-ascii?Q?W5p61Ft39KDqRnCIKUcjy2U95NMcyy5iNIPOBIOofl/ABquRDQPsM1j6gjNr?=
 =?us-ascii?Q?BDhn0t63hnYiUfS/G4FdRtt7cnTbu6LZh+TtZzXL8bg0WIsZ82De8kl93Tfn?=
 =?us-ascii?Q?xL0M9UbJZmGk9qTC6qMzAQg32rjq4kJTo4JgUPRICTMEYQ3NDtJfbjLCOPD6?=
 =?us-ascii?Q?O+x5iBlVoNNUERBxjEbCyBnb6J4fsmF6j7qcF97jJeqt9zOBRkHHmDo6+QKg?=
 =?us-ascii?Q?e4LTvLJNgmUG/kcESYFP0Ont8EheSNYuD9xXmNKfWW8G4Kpl/RhOYFIRMIqp?=
 =?us-ascii?Q?wLMz9vpVy9gKVRVV9kXWmXy97Jy08kjGYCdSLQTsZKcT5T2Xz28BZ/A3XqjI?=
 =?us-ascii?Q?dQOO+MVUoDi8CFMYUQcBTdZneCSURFJltIoUIJbx/RRGsGugbISlWXb7g60X?=
 =?us-ascii?Q?+Zt04CugIt6L0NslF8L/QPDdJ0of/7s9hiQ8AQyKFSOQSlRvyfYETTvUUbd0?=
 =?us-ascii?Q?/R0RJLJVxj3dFPNqpNejKQlVeg15r4pfd9WYamnALhI4obGPDxQWoP1LUNBZ?=
 =?us-ascii?Q?lRH9u3pS7B0LJegohud19GknubH3wGUmADg12cBZGCJ806W31QVwIakaJAjq?=
 =?us-ascii?Q?zsP1dDSfGADkn2sq84Jh2YVWv5OlPmW91YjWnZxFd9+6oGrY0Cl1gCaGuk4G?=
 =?us-ascii?Q?ij0q3jdw3Mrm9KpJ1gMfzE8CicXjwVP+oxDJvi44ufnK1/GYwYCryKZXJJcz?=
 =?us-ascii?Q?Vo7yKAEgh4sd4IkA8VfnvduGqXWLBxK4x7p9nXuL1L4leAJS+3kskqRtbcp3?=
 =?us-ascii?Q?9xDTXPf+tL7A93NRiyAQi2QSRhyC/+Vgu+zGgn3CMSzYULcCFm5ZgDVQcccW?=
 =?us-ascii?Q?hGpvk5e1Y7EOjZuh3pCThvky/nXEed4taTOkUepxS8T4hYT2bk+aRbxJzgPR?=
 =?us-ascii?Q?Pnz61myReCBB3XMkkMfcXj24obSlbMN90ssuy07mEgfGqqBp2//46Z46eHN2?=
 =?us-ascii?Q?3eShHj6kLJH+R1oFt0nHgLiWlyjk4CA3u0rPU2O67dq4lKiXdXEBX6dZtYq/?=
 =?us-ascii?Q?Ms5bqG8AjlGOEJOYCKb5uOFn5p72Cn1Uja/CjcprvDt3oOsc45S5pIfgnFkZ?=
 =?us-ascii?Q?Rzj+w5nlx2Zd9b0bAvclETZFltqBo6RfP4nEtQOBdSzN6wfaYuA557Frvztg?=
 =?us-ascii?Q?ofvQ2WK7eQFafz6+J26b+LEaPtW/3dUlii6HcMMZmiE+8JNnyCuv1YokGnzo?=
 =?us-ascii?Q?aaYetm5IDBCjhO7uDm2WnLhCeoBJGOuammnCi9zwGNS7rxyCAg2BOUFQNIRq?=
 =?us-ascii?Q?jh7H6u4ghwvZVyHru2RslNSMWiwPpO0F3v2Js++RcavIGJ1GenqhodhDyCJA?=
 =?us-ascii?Q?7IgaXlRqlINoITpm/6iX5VdVtVIgIKUy7RKTQT90eKF1WmuRWS47tfIWOv8G?=
 =?us-ascii?Q?4g=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a9a3cb16-b3a0-4d2a-ac61-08da90238a32
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Sep 2022 16:19:14.4428
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CMknJOM58K7vcrwcGX7Fb8rT+IUlD+erNk2YdP9WZZZTusPkXIcssrX7bk+WTULTVkFI35OK5ilkujeNyOehLA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR03MB5664
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These are documented in the AQR115 register reference. I haven't tested
them, but perhaps they'll be useful to someone.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---

(no changes since v3)

Changes in v3:
- Move unused defines to next commit (where they will be used)

 drivers/net/phy/aquantia_main.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/aquantia_main.c b/drivers/net/phy/aquantia_main.c
index 8b7a46db30e0..b3a5db487e52 100644
--- a/drivers/net/phy/aquantia_main.c
+++ b/drivers/net/phy/aquantia_main.c
@@ -27,9 +27,12 @@
 #define MDIO_PHYXS_VEND_IF_STATUS		0xe812
 #define MDIO_PHYXS_VEND_IF_STATUS_TYPE_MASK	GENMASK(7, 3)
 #define MDIO_PHYXS_VEND_IF_STATUS_TYPE_KR	0
+#define MDIO_PHYXS_VEND_IF_STATUS_TYPE_KX	1
 #define MDIO_PHYXS_VEND_IF_STATUS_TYPE_XFI	2
 #define MDIO_PHYXS_VEND_IF_STATUS_TYPE_USXGMII	3
+#define MDIO_PHYXS_VEND_IF_STATUS_TYPE_XAUI	4
 #define MDIO_PHYXS_VEND_IF_STATUS_TYPE_SGMII	6
+#define MDIO_PHYXS_VEND_IF_STATUS_TYPE_RXAUI	7
 #define MDIO_PHYXS_VEND_IF_STATUS_TYPE_OCSGMII	10
 
 #define MDIO_AN_VEND_PROV			0xc400
@@ -392,15 +395,24 @@ static int aqr107_read_status(struct phy_device *phydev)
 	case MDIO_PHYXS_VEND_IF_STATUS_TYPE_KR:
 		phydev->interface = PHY_INTERFACE_MODE_10GKR;
 		break;
+	case MDIO_PHYXS_VEND_IF_STATUS_TYPE_KX:
+		phydev->interface = PHY_INTERFACE_MODE_1000BASEKX;
+		break;
 	case MDIO_PHYXS_VEND_IF_STATUS_TYPE_XFI:
 		phydev->interface = PHY_INTERFACE_MODE_10GBASER;
 		break;
 	case MDIO_PHYXS_VEND_IF_STATUS_TYPE_USXGMII:
 		phydev->interface = PHY_INTERFACE_MODE_USXGMII;
 		break;
+	case MDIO_PHYXS_VEND_IF_STATUS_TYPE_XAUI:
+		phydev->interface = PHY_INTERFACE_MODE_XAUI;
+		break;
 	case MDIO_PHYXS_VEND_IF_STATUS_TYPE_SGMII:
 		phydev->interface = PHY_INTERFACE_MODE_SGMII;
 		break;
+	case MDIO_PHYXS_VEND_IF_STATUS_TYPE_RXAUI:
+		phydev->interface = PHY_INTERFACE_MODE_RXAUI;
+		break;
 	case MDIO_PHYXS_VEND_IF_STATUS_TYPE_OCSGMII:
 		phydev->interface = PHY_INTERFACE_MODE_2500BASEX;
 		break;
@@ -513,11 +525,14 @@ static int aqr107_config_init(struct phy_device *phydev)
 
 	/* Check that the PHY interface type is compatible */
 	if (phydev->interface != PHY_INTERFACE_MODE_SGMII &&
+	    phydev->interface != PHY_INTERFACE_MODE_1000BASEKX &&
 	    phydev->interface != PHY_INTERFACE_MODE_2500BASEX &&
 	    phydev->interface != PHY_INTERFACE_MODE_XGMII &&
 	    phydev->interface != PHY_INTERFACE_MODE_USXGMII &&
 	    phydev->interface != PHY_INTERFACE_MODE_10GKR &&
-	    phydev->interface != PHY_INTERFACE_MODE_10GBASER)
+	    phydev->interface != PHY_INTERFACE_MODE_10GBASER &&
+	    phydev->interface != PHY_INTERFACE_MODE_XAUI &&
+	    phydev->interface != PHY_INTERFACE_MODE_RXAUI)
 		return -ENODEV;
 
 	WARN(phydev->interface == PHY_INTERFACE_MODE_XGMII,
-- 
2.35.1.1320.gc452695387.dirty

