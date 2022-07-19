Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F064757AAAE
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 01:52:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240360AbiGSXw1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 19:52:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239923AbiGSXvo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 19:51:44 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2051.outbound.protection.outlook.com [40.107.21.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 359CE65588;
        Tue, 19 Jul 2022 16:51:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VlKEN9YR2JBM+TA1guPwo3wVmsjllTYtIVuCpHwnA++ovi7J/u4csR+OnvOIpgfqnSnApRWxHSqcNbkPR3enI0MAqG8VcfFJod06a0QHw+jnHKaHcMWLGzc11IWo3wZy3RlLA6BhFtSPzSNm/Fnn/2qN3LVYwZurtNZRICRrKqUw4OINfKpv/jA+unlV854PSP5FPVx+pbwDJu2VSPHvRFSMaEg1E/k6xhi8UXp5ye8eDnYSZc/b0eobtCLH294cvYzORlVDzTLwB2LNjzGefRRbE12QCSq/iaAPGxio87WC9D3SDVsiaVLjuNPKR6p0Nvb/pCCWrYMIyt2apuXEvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oVy7nVSWqRIeR70nLj9MPIyvrl4E3rMb27p44Yx2C34=;
 b=RlsHlW2ivDmDnisB6qy1dTF8Inz4E+F9j/7sSC4P4PS3KD9pVgd4yBYZg2zpXSHJoEslBVpnvl3eIXz6Vy6mB9O/IjAXCuTxyToAObFN/vLkLbEkMldTNXLulYUmobWTGdeofgGJayl/v1FxjcA4gIjLI6ZiFPLCKrQhUNzb1lJSshLLoHMxhfkx5IGYlTE1H4kvtrF//LWbA568mpibAwrvIaFJaGww8fOIDWxL9+Xbby04yOX2ax+ny19m6/EBR8uJAmpW9Kpxk5pJKNI4tszbbmFtHD4fO8+76NYe+VWMcjpCGzvb/RfAKyWN0dXC5itmHek6dFAAIWBhN80snQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oVy7nVSWqRIeR70nLj9MPIyvrl4E3rMb27p44Yx2C34=;
 b=AaD9NEsO3RuStZ2vRxRwiLbw/Kwex1i8CSvpeYvRNRUVE4oC4tBscbJSrDaQFOWVQIrMvQh9ltSsXltKXfFbLmD6KDdNq+Zlu+V0VZT/o+qCbrKKMaLDwTUBBGntLQWggDOibe7RrcyKwC9kyxs6qcmJR1fExKNXYb/ldzCxiAmim04vJdhmoTiCb69dgPBIQkfuANp/G9pQHWa9bj27N770u1KhkHQ/2xHudtO+nrCP6NmCeWb7V0XsXeqAa85rLwIVwWY9oZYMvBXIjcELLQtznHfg6Rkc/Y3Lew86KBDAURg6frqB9PeVsaJhdtNN9yIAs6vi1RxeEkp40sImTA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by DB7PR03MB4811.eurprd03.prod.outlook.com (2603:10a6:10:30::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.23; Tue, 19 Jul
 2022 23:50:38 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::757e:b75f:3449:45b1]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::757e:b75f:3449:45b1%6]) with mapi id 15.20.5438.023; Tue, 19 Jul 2022
 23:50:38 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     Alexandru Marginean <alexandru.marginean@nxp.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sean Anderson <sean.anderson@seco.com>
Subject: [PATCH v2 10/11] net: phy: aquantia: Add some additional phy interfaces
Date:   Tue, 19 Jul 2022 19:50:00 -0400
Message-Id: <20220719235002.1944800-11-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20220719235002.1944800-1-sean.anderson@seco.com>
References: <20220719235002.1944800-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0227.namprd13.prod.outlook.com
 (2603:10b6:208:2bf::22) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cc5b7c82-544b-45fe-9448-08da69e17b63
X-MS-TrafficTypeDiagnostic: DB7PR03MB4811:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 65UAEm+322HHuncdR+ZXAE4jS6LNCJcVFV2sQCUJzbWjJ77r/agJfkpoQvqFCb/qAYUIgKcTWafcqzwlRKCKdqFZS/ZFUugkOfvfS1aWuJrkLvGmzdvlsIMaj+B7q7H6+eebgHq6lq3+TBVzR3QjGMP56rCWbdBS5UudghebuzHGiPdPu/Do1PRkJrKOtaByAgS/Fub2ixaHFcvk6KAiKFirQ1wzPrg3aXXwgj9X6c8JRk6wDgUeNMFqVrTJedz84PzREZIGu15yam5RF4kHYUyThYuKWNNRPzYNz7Khu0rNNSdS4z5UorMjo+cpOCeCKWv1SjEqn2jroLZw4U7Tt0/HQJONb3leRx2YNGwK5MmlPBeA4gOw0rylpJPI0I85c5hjGSweyuMVmD3V7BLFeGCukO6/LKq7MsRL6PYux3vvJylaLxbMfkwRkQzjIctZlAW/L/Sm2KimMqgO61AHhQm8HCZjcu3NSF4pv/3znHvQMrJ5RmuNeB2TkYe6aox0+Qv5KcdKtp8nYAnKLtQ9wgTgXqTl+Gl/TrbyJdV9H1gyDnXlLrlL0/TZwqxeURjbRvFPuuCh6A1QOONCwEoUHyeGu8R7UTyjbN/dkjliTPzdLeUB3FVYNtxrbjfmivXeVTHvZ59SSue6xreTlwV6YgyQuKEOReCZ2gzCiPy+Vg8AYdUzudrGZjgwjenGntq7uZzUWMOZNfrxZM49541NRpHEEuVDCkH18odhRTSHNltxrAhVdIJVSlS5iGtM3v/J8wgb0YyNYi/33Mu9fRsS483bX/yZkHdoPsCtlf9zHSU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(136003)(39850400004)(396003)(376002)(346002)(54906003)(2906002)(1076003)(83380400001)(186003)(66476007)(66946007)(8676002)(6666004)(4326008)(110136005)(36756003)(66556008)(52116002)(26005)(6512007)(6506007)(2616005)(107886003)(38350700002)(478600001)(86362001)(41300700001)(44832011)(5660300002)(316002)(7416002)(8936002)(38100700002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?TWIqpKtpVI2RP22ycVnzRBzr6Cqa90O9RR1Z4MAALfwXXFmIYhBYW7E+bunR?=
 =?us-ascii?Q?wRSMB/L1D64mVli34Y1Zgbfv7okjkMdcoZ2jWe4WUTd0C9uSKNnWPzrmAUHt?=
 =?us-ascii?Q?M/86WfZHqoCgPqbCCebwDBUzWuWEUyOBT1jBQge6Fcb4/W7tgA3S1YYyN7Wj?=
 =?us-ascii?Q?VpQzjeJoHl0eLFY6OHOghKa23nJO6ODo5Q9F0b0RZoUXCIljqftHvNoasGk5?=
 =?us-ascii?Q?mIqBHY6vB32dHfgnrTesfJzXd0mNXVMidAsstAZFQdABG2rwuW35jkB7b/XB?=
 =?us-ascii?Q?LRZPieY0RvIPDRD/g+AIE4A43EvjXrvyoslMr6Vb4HKwyiw0ibIIWJjRv7fG?=
 =?us-ascii?Q?6ojRmhi7G0C4ipP5y4Kval/JDYjncd21oGhJMQvQSNcyzRe3QrhchGCIM9eO?=
 =?us-ascii?Q?6Smf5ZnDJ59wVsxpSTjoXavWhEwG/91ut3TiN8EPohYTADHUnTwS2gyiKV+e?=
 =?us-ascii?Q?MtsiBFgAVBtsIEIsEZ526pmyMaKYMPYb+eWGqVuEatURCqpGpXGGLkrKS7ij?=
 =?us-ascii?Q?6100nQ5lsd5orhOH6E7d0yFdPMDKm1H5tbijyO24ppk3JVeMHJl4m66Gep4g?=
 =?us-ascii?Q?+MZ5BrHk5MT9pTrDAR0X+T44tTWRgGGjL8Pd0tzTcqlVUhfoetvBPvkVopie?=
 =?us-ascii?Q?hhdhzgvVqsei+RKWly27mwNG+1tEd6tFiilaMvobwogxDixUw1I31xQC++Xd?=
 =?us-ascii?Q?cAKWnBjO2tXGTCaJl5rmVkfP5oJteTfkL7/Qrxr2p27uCSw1wdtIYhBIqFQk?=
 =?us-ascii?Q?oCBZfGRBUQeIsd7u+JTaSCgnVbGW4JHp5MiT2mhIJSTgfcQLQ2B7ZydCebE8?=
 =?us-ascii?Q?KB4HcodK7UorHePTqUlbKmtwUE82hlTnPBmvLhydWWTga+JW1qh30vc3yBzh?=
 =?us-ascii?Q?U4Std+lKHXBwGVVswbN8P4FoRW7WgvUQHE98Sbx3s069wTGoZUgOypu8egjt?=
 =?us-ascii?Q?9aEC/aezvGLeV1LWTuzk/OgGysCtuEGDDCOBUAQloxhGIFtYCTxUSMv7H53W?=
 =?us-ascii?Q?3RM7NEcGBW/BcdyWn1jqLqoK+qMHPNFetTh9sboPMM+hj+jSUNprnTNsjMi8?=
 =?us-ascii?Q?72OKgMHVndHK8Vmc/gJOhfkp00Z5Fi8EbxEDPH1WVKmbxlELR4XGSY0Uje4T?=
 =?us-ascii?Q?3FJKTepwEF0NXYUD8uqFlnrv1XoEQAl7KaIewNkwixT3DIH9lQg8IOSpCYcy?=
 =?us-ascii?Q?LIw8w0gHKJpIxXOsDrehEyC/3LPemGuvWdFSGIkVDDLPOB847gY40kOs6wdx?=
 =?us-ascii?Q?rT+A4lyEWGbA71GQC/mpkyl6IUZtBbMPJsoW1r6Aomt3B1RfSbJFo8cNkRJK?=
 =?us-ascii?Q?AF5l6ygGcSS9o5mAp9xNzweRJYQmzN2UNvQjctDWVCiM4a2tH1Et5bFTlpQY?=
 =?us-ascii?Q?TFl5uxm07u1WcX6qd2Stc1g5MbcrlztO+suetW2ME/6/iREerkpln3u5n/Wh?=
 =?us-ascii?Q?7v4smaAItEA19fytnafDowl1dmYyOp8vCAtNLSHQepmuq4Gx3LZUnFCyw2cH?=
 =?us-ascii?Q?09TlaBxN8JyMPWfdRbA2xLc2EnjveaheQrGjow5YQDPj7vYRS6aw2HCtuQIx?=
 =?us-ascii?Q?HwVk43iXd8xWqWtSvYEPfhjgVC983N6HtJ/d5rJIehSfjtU4VrRs5PG7dYGV?=
 =?us-ascii?Q?tQ=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cc5b7c82-544b-45fe-9448-08da69e17b63
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jul 2022 23:50:38.5965
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Zq+Nn6xBst+QDkQ4PONEWv3jclV6d3/zS1XwiASpdGqb3f8o6znEWIkWlIyHGcH8rc00QTNTu4JlrGt3yI/Npw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR03MB4811
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
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

(no changes since v1)

 drivers/net/phy/aquantia_main.c | 31 ++++++++++++++++++++++++++++++-
 1 file changed, 30 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/aquantia_main.c b/drivers/net/phy/aquantia_main.c
index 8b7a46db30e0..1e7036945a4e 100644
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
@@ -91,6 +94,19 @@
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
@@ -335,6 +351,7 @@ static int aqr_read_status(struct phy_device *phydev)
 
 static int aqr107_read_rate(struct phy_device *phydev)
 {
+	u32 config_reg;
 	int val;
 
 	val = phy_read_mmd(phydev, MDIO_MMD_AN, MDIO_AN_TX_VEND_STATUS1);
@@ -392,15 +409,24 @@ static int aqr107_read_status(struct phy_device *phydev)
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
@@ -513,11 +539,14 @@ static int aqr107_config_init(struct phy_device *phydev)
 
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

