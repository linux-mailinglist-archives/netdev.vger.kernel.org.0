Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A5F9598941
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 18:51:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344961AbiHRQq5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 12:46:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345037AbiHRQqo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 12:46:44 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2050.outbound.protection.outlook.com [40.107.22.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF17CBA9DE;
        Thu, 18 Aug 2022 09:46:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jjCDbIt4Gz8xSBJiosVcS8n15zF2y3CDcEcjrwU8M6Lvc1v95AT7JkjZqHedgJisUsj2+/kAPhKUqwpBVR0xkBFcfnzhggx7tIaXjJKZZpKJifaRjz89QOrJQvvnEMb+c3uq8LnV+jM7ODlIJ0EafzCpk8+Q2Jw4Ag5whUILLQtb37lxlucf6zeEc1HAl44YdOZ5UhZAUqSmp/NXH+6uFwykx/VHM7yDr9mkyq3o5X/08fQ3iYFSYJ0zeFBi3EoUj5Cutr6aulY0UCWaJ9xShRNBy5oJVfbnYkgrPJIAfoR2Bc1sQJdzbF+exvWOJDxHeahiKjIcOkHgTIdmNfqzMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=msiT+UkpoCrjHVQp2GSjV0d6CwJSb1xGjry1C/EbVZU=;
 b=Z1GswzkMr78kTpH64To21hPZzEs031WsiyPjs9zH9jMgMnRxBTNZEpoWapK9772YYYR8347RYH/9E8jOqzQygeIAMIbu5MewS4SVMMlxsSsmR0JPIKo6R03pxtnAKk55uMT4XosLv3QRbl0UC333StNKVXNOnVldqlHwduAG3+xUnQz1AeVP9xAZ7L3TEs2zlRscNwflPADL1CijhHid6wfUjkkH54pVNXlh0gXXs6HjwlysNmb/KtoRzh4gZG+8i22c0kDRTfXMMw2B8cnslvDf0FcCdMhIF5chT/TtvZAGJ8Ea1Jo3lbgbu3kamPWDk44eZuWGsDs+2BP+WpYO8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=msiT+UkpoCrjHVQp2GSjV0d6CwJSb1xGjry1C/EbVZU=;
 b=jnur/gNwNzq/vNvaQ02j4yC1gnMrSm6BhzIt3Co07BeKzZaimHjJNElq3kFyTEWO2vj/hvatVwfB1wFFzVOQUDWt/fWgti+XMrQjLxlYcMTva7aZk5uWmAq8pBXw9rnOUQbS5v9PoXr4uFsRj+jsFgZYNKDEfPi6gxfyPYkORRRksYIN79oQmoVQletiY3giFmIQll2Deo6sX1fFpagiX3kid4I/9qrCue+FCwVH1nI+vnJhFD/uFHdyKqUMbMlND/PfkVs6fQywDoazKMxq/a7faw7mY9qGjqn/8oE56UR0gN55Y5Wq4WQKVOBRObCfUjotzcMd1l3HkPkG/sXltg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by PAXPR03MB7649.eurprd03.prod.outlook.com (2603:10a6:102:1dc::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.16; Thu, 18 Aug
 2022 16:46:42 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2%4]) with mapi id 15.20.5504.019; Thu, 18 Aug 2022
 16:46:42 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        linux-kernel@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Sean Anderson <sean.anderson@seco.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next v4 09/10] net: phy: aquantia: Add some additional phy interfaces
Date:   Thu, 18 Aug 2022 12:46:15 -0400
Message-Id: <20220818164616.2064242-10-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20220818164616.2064242-1-sean.anderson@seco.com>
References: <20220818164616.2064242-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR07CA0019.namprd07.prod.outlook.com
 (2603:10b6:208:1a0::29) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 15876b1f-f863-44e4-608e-08da81393a86
X-MS-TrafficTypeDiagnostic: PAXPR03MB7649:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iF9Tp1nqjNxXXvCROrw99ayG8q+aBLFJmhEbm/4Ix1JZuzkckBoDQWjbbXhPvTKjoGzJRUuqzuoaBxYkEqs0yUQqWAGOgqVZ0xA1fW9t4DSnCPvOAjrZCSaq48nDvmVQpzdMYB35dCfa1WwcNShDriXgb45c2y1Qj+db4ti9zwxRFF6ZvVZnALthyQXgo1bJtJwOjhB75h+r63wHHymSYLSgHqC2WYp4at6NBsFaLX8CCYcXGr9MdNlTcObSlLFZ6PUTfEkd8eGHh4WkSisFple+Q/emwziqUY+Wox0vGBVbi8mgHZaOng8plNRRphThnlA/p8ZZHug7pP7hDJ3NrO9563HP36MzlZZzQhtgYPC3Cy/KreQ7gRaWD6vhkCmS4VmtELE/p3NbnZ9CfBviAoke/oLDViig5j+GZwr/j0XL2SyRlOBSzRzx985IIIN0IWwIm+haZBGUoIJrkByuqErU1gKU5EsFq23P55hoWotuwkagZYFJaRTfbsLWM+/6Uckq48Mj0gcqDzRbfGQTYCyc358uo3XdI4O507M8/zI6CsblzDnX37loJrDnLFbqRgM7J9B6/xwyHTqoVYRWbJ9fTG9yH9BFkSUqXTFj0a4rAZTpIW7VfOdNUmQLJ2X9g5qIWprsheEfvZW3SotkVbAXaJ2kti/pe+pJXgUxdlAP9se+U7RLUTF+niJIEwsiM8lRc17hQFPSiAJmv16tVOn98owXPodOCJRhDRq1P1I1eY5BUPFO2Z4dtix+aXif4RSJ2seduDuQ3vbIjmLBSg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39850400004)(396003)(346002)(376002)(366004)(136003)(66476007)(66946007)(478600001)(66556008)(6486002)(8676002)(2906002)(41300700001)(6512007)(86362001)(52116002)(4326008)(6666004)(186003)(1076003)(2616005)(7416002)(44832011)(5660300002)(26005)(8936002)(36756003)(54906003)(110136005)(6506007)(38350700002)(38100700002)(316002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Nbetuu1fRr5Ipxz8dN9L5XFdeF25T79Y1HFKVGqbfG8GCgW4auln/z5Cub44?=
 =?us-ascii?Q?OupRCthj0gJc7QnKJbnDtevnm2Ef/tAZq0hFJLLD6RE3wLII36hUJpmairIR?=
 =?us-ascii?Q?foG9JzvgXoJ4mgKof3HxAs2dZfzPoaW1FiIW9X+2L2xIlJTgWaxldcGbFYlg?=
 =?us-ascii?Q?T/WQ3STRPmO8/aN6TO55PobemIw7B6b9L2Na5dkPTWZrwjJTooWSjYK23QL2?=
 =?us-ascii?Q?+YogN10Ndu3X9jc1hOOBj2ioVzglz0+aWKrctnA67Ol/ept+TFXL3fjxY+DH?=
 =?us-ascii?Q?cVJmyk/MPnyMjXKh0DPIQ3NE8hHS2WX7GsnoXVmsN5EZyA2Ycrtp3ypX/Qwy?=
 =?us-ascii?Q?idiEViGMI9g6d6L0w6XTBFIfmsP1QSeiYH4K1sxA3A6cTlqy9uqUMU0UF4Zi?=
 =?us-ascii?Q?FlpD4Vr2Wq3LWKPpUuxwrGwTzEkuZVvjphZGkEQFLuYDqS4FxmiUJ3WeV2eg?=
 =?us-ascii?Q?XIVFxWXvHHH6bnqcPres2SAj3G0E9ndD0edix/R7oukHsRP6jMADz9DH45M1?=
 =?us-ascii?Q?YoGzT3JGcczJTjUPGMkBfBd3Qz/WGoNnoTRaf5axjU661UKoIboPrqlvQDYK?=
 =?us-ascii?Q?iLspHnORon5XuTUJgIbpDI7FO0Ulj+ML8eUKgauT6xm3ifNBZiQNpbcgtsX9?=
 =?us-ascii?Q?TrM/usS3O5xQ3QqpmuTG3nctFTypBHPWjk1ErLubjb9WNgUyzSNJjehym4vd?=
 =?us-ascii?Q?z2Nx+VWZP7lL4gPSEZy8wow5qSI9MavCW4FrAizk4n1/j0Xb+nLj14EXtYfQ?=
 =?us-ascii?Q?H3dI8kXHMa8SoBeewPeqE8fMd006uMK3qOTZPZfugGIoU7DxsR57xCzhVUEf?=
 =?us-ascii?Q?PtxSvpwbHWPmJXzM36FghHJAWT5FiadzFdgG4JAgKALlwE2o6fol6mbJ5SVG?=
 =?us-ascii?Q?Dcwj0MMVpTgcKeozfJy5DSCl2NYwWVp66h1W5LQvJCHFHQL6DfmoixEsDzBa?=
 =?us-ascii?Q?QmCq0N12tpxYAfDeNBQcFOLPNe8AlOqpU9D097df2rJ4TOhGHv4ytySKFvIO?=
 =?us-ascii?Q?R7hLA6aaZ5wvuwp4EWRC5pwxJs9v0qFxVk1TR0iDcdKqV/gCpviyxhO9VI0E?=
 =?us-ascii?Q?KRs6yqkXA2KK4rO5lNuMyThhiNJqR2jJiUeE4dLD14/f1M6uhIoY6JUQnEIr?=
 =?us-ascii?Q?IJD59SA1K6iUZrtvtVzPoEKvV12WNQQ+mPNU/O73ZI9kbwcSeNMY7+voGzsX?=
 =?us-ascii?Q?wnnaW2TaQTPrrvSy37gBBYTbJpry+RYR2mujy/E7jWyACNcinyWHzuWhoMPk?=
 =?us-ascii?Q?HX9PKwaDb/+NRuUulZDDQmvat+cSnlkP9thIAtTJLbtN68d7SzOaHSseA4fU?=
 =?us-ascii?Q?Fp3pBgEZSrmT0DqCB+0XKtG4HEeGmRY/wOOdjyuNnWmUnMS6J1q1mhrCK6+3?=
 =?us-ascii?Q?QcaNjKYLue2zRSrLiJRqnX2RvsGvaVgsmbmo40QkZOpF5W9TCUCLNN51nylT?=
 =?us-ascii?Q?qRo0EOBIqBS+C5dRp9c/dgbKz16xqwKLrRhGc0jIAv8TR5FY4ksf8PiuHgnC?=
 =?us-ascii?Q?AFVfaBcJ6HQCoQt4JUh9iBuH5BkhYeGa/05hyGyn9TlQzE8JpOYRuwrqnioM?=
 =?us-ascii?Q?o/OsswlDYPhOjF7zJOY8rwKIGzDJNBIyWxK3FMZ7+3D75tr86M76Oy0kFAro?=
 =?us-ascii?Q?oA=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 15876b1f-f863-44e4-608e-08da81393a86
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2022 16:46:42.5569
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: b9fwp5ZahWXV2qPkSB7SZuwYvYrTNEpsAe6K5MwsQZblzsoL+vxGhFxDlsf4uN+JdDANSQAJYSx4Vvdy7YClCw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR03MB7649
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
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

