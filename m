Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96B6148CA0F
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 18:45:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355910AbiALRpQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 12:45:16 -0500
Received: from mx0d-0054df01.pphosted.com ([67.231.150.19]:23264 "EHLO
        mx0d-0054df01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1355881AbiALRpI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 12:45:08 -0500
Received: from pps.filterd (m0209000.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 20CGTfDc011851;
        Wed, 12 Jan 2022 12:44:44 -0500
Received: from can01-to1-obe.outbound.protection.outlook.com (mail-to1can01lp2056.outbound.protection.outlook.com [104.47.61.56])
        by mx0c-0054df01.pphosted.com (PPS) with ESMTPS id 3dj2j2g1ep-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 12 Jan 2022 12:44:44 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PtDrKJJrjk4VRpCbe3vQPGwIBUogQcMAF/cUB6xOx0PyB6mmJXR54bJwg8vqbAU5b+YVmx0nS62gg8X/D7Fntv/Ubvdw7tGDk2ezxwSTj7tM2t6mVTSQsfAixElmaY0JQqD7gcUN/kNI4GUOS0qmXC0gtdCckcEx+U8wkt6FwhixlbQVisZmCmvvDoiB6kAFbE4Vb9lgYPOQ4a6aIprB/0Bqc4n7RhLgqPNp6tdi52xaMvI/8tj20wasthDf0zcm2MIybXPJ4CuGMUkMF1+HLagJ4z/p28bRBriMyrblfC7G1ZuL2P10gFNq99IJPxOEdKB/Ss/rcbpQMciZox/wcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZpXWaBZB/QYS8THuKXaWQSKjFB8HiOgnMRklhzH7QlM=;
 b=RGwcDCOaYMweLIyEoXr4drKoZJe4bEE2UErwp2pVCXH6D4fV8dh5O1sDS0kqG1zsp/GlJt2PJ69KVtevUqkyIW74O8V4w9GWQi4YYZgsaIos749GezFcEwMSSFIhVbTA2O3BK9fnsts9HANvP5xjiPr/xLnYH3LggWQFWEoYmCxiMGBbziyoNWoTr84zEZANnMg1rUjTcd0tf4Gh6inKOnOYZOut1nyO+oNekPQwzcn/REzoGLKMxeSqXlJMsX4Zp+D0sJFZMgFFnqycGQMc7UgG4cyzuFKcUWgbkOhTWhwyF7BnYEpTC7yVM5zWAqSfwv04Ebn3DfvFiThVKxAkOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZpXWaBZB/QYS8THuKXaWQSKjFB8HiOgnMRklhzH7QlM=;
 b=jOBVe6bTqFSNi5hE79kmTFr0gQKDpkvqP5tPZc354gmjbd6YMbtztGeyAtiM0ZwJVktqI4QSiOg70snQ+gK8gTwqyGR1JqKRgMcnr8WxIAIrmAP6lMdnYKwCEjzoNuGeZNoY2XhyvoxM68AngVc73LJeoo0nZ5OOOvl+Sd+44DU=
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:6a::19)
 by YTXPR0101MB1215.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b00:6::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.10; Wed, 12 Jan
 2022 17:44:43 +0000
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6929:c39f:d893:b6c8]) by YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6929:c39f:d893:b6c8%2]) with mapi id 15.20.4888.010; Wed, 12 Jan 2022
 17:44:43 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     netdev@vger.kernel.org
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org, mail@david-bauer.net,
        Robert Hancock <robert.hancock@calian.com>
Subject: [PATCH net-next v3 3/3] net: phy: at803x: Support downstream SFP cage
Date:   Wed, 12 Jan 2022 11:44:18 -0600
Message-Id: <20220112174418.873691-4-robert.hancock@calian.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220112174418.873691-1-robert.hancock@calian.com>
References: <20220112174418.873691-1-robert.hancock@calian.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR18CA0029.namprd18.prod.outlook.com
 (2603:10b6:610:4f::39) To YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:6a::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7ff35fad-e912-4066-e883-08d9d5f33799
X-MS-TrafficTypeDiagnostic: YTXPR0101MB1215:EE_
X-Microsoft-Antispam-PRVS: <YTXPR0101MB12152295ADCA3F6526B06CA6EC529@YTXPR0101MB1215.CANPRD01.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tkTrAVH5TcMLB6DuKNevI0Y1HNhySsZRQIT7R4KyJRxcbLwdxqz8qt2CPIGyZUN3zzyEPr48XJb54SJkcW2qUE7XDPX7PXivuY0I6ea8z588ryc3BtbS5pB7ou7hZ5ABad+BiE658R67OU4Q/8GJg5GtVILHapEj41f88ZDYsrCS3jqlSgWP11dGL0QY89xixgLMBYGd/uup15p8xoWotW459E/zKQCT4GpbZpO3NjroFuGGKAsrF34o13U9F9YL+ntniQ8LzycO1z10vlsvBGoFa3whSP+FNpoeDaKEYrkEWqoo84Sz2TYTEf/t0Ga1csgv8q+DbvZXA1VGgJxFogkkm3JmfD4gWoVV6N7RvBxXgGlcnobu0Q+Ap6ls4bt80C0kPcI8kHMSG3avngpP698BolRzKMr4MnFrSD4fXVh2TEWrQtktmysPj0keXdsyH0hwlVm+F0pceky73yLh5h+icTeFAufFJFe9Tch+kg6dvS0Tw7i1p/mOO+rbGyPMXE/glgP/pPSze2PxaNDOmXzT8lz1hOIjr4W91gvWnmuLXZj1pfHYEBfy2EHEgWqcigNlFXCaELfJn0Mhi19RAwm6CUVoJpgu09xmITZSvnW2K1chvJ+tLXhQBCXMtH1WMK+osFjA8khr2tdXHGOn2EVMOmAVhJtz/FdeWcrgfccZY19Guhd2lUJIbqZfkPIE8YRGXVO0RfR8fDjYsNSo3w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(366004)(8676002)(107886003)(66476007)(6486002)(26005)(5660300002)(8936002)(2906002)(83380400001)(6666004)(508600001)(66556008)(186003)(1076003)(66946007)(6916009)(2616005)(316002)(38350700002)(6512007)(38100700002)(4326008)(52116002)(44832011)(6506007)(36756003)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?7llg50XNvJ0G2yhZUZyBpBY+33i5kDUh4Tgc7dNek7tXYYwKl+cz6DzQ+9fE?=
 =?us-ascii?Q?D8CWxMnU+8Y+AMtTOXwDvtjRCGvyRUttrsLYMpGVbjoY7Ni5Ieu4QJ4c/HGA?=
 =?us-ascii?Q?92d++AtDvnIjz3n3w4bEFvtvEGsTcJALrXbSiA7qihCD101k8GVCvGzs0cFM?=
 =?us-ascii?Q?qDDCNg9ifxO6wIQ03F02BwMudMyRj6TJPz1yYeYcP1KFtPdGMc+G7a/aP/VZ?=
 =?us-ascii?Q?MLQ5YyY6vR7CBSEtyw4hiIeFr1wwkl3afB+Lh6srMVWNjR9wiJWhSf14z8KB?=
 =?us-ascii?Q?oeT4T9l9qVzhwlPuWqcq47iwrb+8VAIMLo2YZaJWG5NuBJcIdM0CFlIE9r9K?=
 =?us-ascii?Q?oJjIqub4NxSoVlQyAAkE6Y86UkHLzjDdYp5oy0+5qN7VaUEFJ3e/opYBW5GZ?=
 =?us-ascii?Q?SpPencY53yqXty/XslmJEVSzNC4Ky3g6YYeUoXe9rP6/43TBoSzIBBTGCJKn?=
 =?us-ascii?Q?z15bM9//d7cgrkTJ2agox02ULigr4sxSHrm+O/p7jTCEYMGsaZoYu7pJHpBs?=
 =?us-ascii?Q?JyXoxq5nKuddPSETYjizNiU6pL/JIY5x1BQd9K2YSwE1zWep2t43lDTO4u9M?=
 =?us-ascii?Q?h9H4zuiktNAFj0L8s8n8eE0spU0MOsibWC7lqkbVKHuv8y9YEvQOwZoGjDtY?=
 =?us-ascii?Q?WdwGwtiAUjD2Do7sJXY/588YFmN0CslnjBtwJ3VvUx7Xv1Ti9O0jHGpP+wIi?=
 =?us-ascii?Q?5FXMhA8Q/Ox8zXDuAUMF8cZrbY7aXGqCVK0Fa57OCA2T+oa4e90/zXSw3JF/?=
 =?us-ascii?Q?aLtdokDeEog7xBfE6ZJqTQk6FXZ7EMl4Evn2Ti/vwA+DLLsuVzVEgJuNzFAJ?=
 =?us-ascii?Q?4vFhfDfFhAwUbQ87el1fW5JZxv50H4JmEz6lyPTe8XME7FEcylpXGQf50nwN?=
 =?us-ascii?Q?1ta4RdsMrf99jaHvF4wYe7NI11iCQNZuwYv5h8sT9VQnPgDh90LJ1SuQ7Ft+?=
 =?us-ascii?Q?gfEqjOtDVvPp3KfWL+RZoPD1sYRB59SecQF3lEMuuIAWXgoj4aUyB8pwgF+R?=
 =?us-ascii?Q?IMmx9GzAgdrUM4QhXqFr2sutzDdz94Lv1i7J1c3qwvFo5HV2kN7cCVQglq//?=
 =?us-ascii?Q?ZEPcag/K6nICY1sZr41IRlDNA15He/1MY6+HoDl5PImodu2RiuO6uFBLfxl5?=
 =?us-ascii?Q?Tekag2WBikoRFGkea8+l9joCxQwMgvYv63nAU0qwDyHP66YWrYMjNqrVVD8K?=
 =?us-ascii?Q?4F+Qp5f/b0db/RA0aut8XGfpgZfvlLNu/c3WFKDf9X+XpgrYkSH/vad5S4nd?=
 =?us-ascii?Q?A0NBNhHCtkjgLkNQkQhWGbyor/yt14r15mTBsBYSpn+ZNq4yyEy/+ekPaHEq?=
 =?us-ascii?Q?MGWzqjKFXYesRCi7xTKjcVEIdqZ7lHgDvjREhmltjhJPdwIDnSCEqcsYyLyK?=
 =?us-ascii?Q?lCrGqRuFYK6wAlLuIjif1qexNEMSBomn4so6ne+Tkw0VuEsgfDKez7P5ySMt?=
 =?us-ascii?Q?32SM6lZNfxaE5BGCs6QQnET3gtncxEemSGE5gTwXTwFv8az2YWMhID5TVddv?=
 =?us-ascii?Q?Ij2N357i+oL+VoCc43s8Ec/hZmVJg6RusCJVcKZbbNHJJQhPE1hMR5cfVQOA?=
 =?us-ascii?Q?x/QURw7Gv6VGgmBTLJgEQ9msKaaJ7LIJhppFlSh1Wqn0zyjzztG5dY1u8ijF?=
 =?us-ascii?Q?B3sA3jGLOhuz2B5m+Bbs/8t9YMgJn0JhtZVpCSznBlC3x+apt9XGAUeqjDAj?=
 =?us-ascii?Q?q5nMBHFJD30qHFuOPpTGFlEp4Ls=3D?=
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ff35fad-e912-4066-e883-08d9d5f33799
X-MS-Exchange-CrossTenant-AuthSource: YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2022 17:44:43.8581
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ktlCynWk5qqWO2eO0s1tA9evvWKGKF4upaPEPoLx9pP4y45Qk+dKnWSJDAglHHeeMvivbUtrOUnzl9VuNeCNuUX/goowWR42AfcZVXROMpU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YTXPR0101MB1215
X-Proofpoint-GUID: dfRgOUFu1HU4I_csDdPb171Xy4b4_ZXY
X-Proofpoint-ORIG-GUID: dfRgOUFu1HU4I_csDdPb171Xy4b4_ZXY
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-12_05,2022-01-11_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 mlxscore=0
 malwarescore=0 bulkscore=0 priorityscore=1501 mlxlogscore=999
 lowpriorityscore=0 spamscore=0 phishscore=0 adultscore=0 suspectscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201120108
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for downstream SFP cages for AR8031 and AR8033. This is
primarily intended for fiber modules or direct-attach cables, however
copper modules which work in 1000Base-X mode may also function. Such
modules are allowed with a warning.

Signed-off-by: Robert Hancock <robert.hancock@calian.com>
---
 drivers/net/phy/at803x.c | 56 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 56 insertions(+)

diff --git a/drivers/net/phy/at803x.c b/drivers/net/phy/at803x.c
index 63d84eb2eddb..c4e87c76edcb 100644
--- a/drivers/net/phy/at803x.c
+++ b/drivers/net/phy/at803x.c
@@ -19,6 +19,8 @@
 #include <linux/regulator/of_regulator.h>
 #include <linux/regulator/driver.h>
 #include <linux/regulator/consumer.h>
+#include <linux/phylink.h>
+#include <linux/sfp.h>
 #include <dt-bindings/net/qca-ar803x.h>
 
 #define AT803X_SPECIFIC_FUNCTION_CONTROL	0x10
@@ -664,6 +666,55 @@ static int at8031_register_regulators(struct phy_device *phydev)
 	return 0;
 }
 
+static int at803x_sfp_insert(void *upstream, const struct sfp_eeprom_id *id)
+{
+	struct phy_device *phydev = upstream;
+	__ETHTOOL_DECLARE_LINK_MODE_MASK(phy_support);
+	__ETHTOOL_DECLARE_LINK_MODE_MASK(sfp_support);
+	phy_interface_t iface;
+
+	linkmode_zero(phy_support);
+	phylink_set(phy_support, 1000baseX_Full);
+	phylink_set(phy_support, 1000baseT_Full);
+	phylink_set(phy_support, Autoneg);
+	phylink_set(phy_support, Pause);
+	phylink_set(phy_support, Asym_Pause);
+
+	linkmode_zero(sfp_support);
+	sfp_parse_support(phydev->sfp_bus, id, sfp_support);
+	/* Some modules support 10G modes as well as others we support.
+	 * Mask out non-supported modes so the correct interface is picked.
+	 */
+	linkmode_and(sfp_support, phy_support, sfp_support);
+
+	if (linkmode_empty(sfp_support)) {
+		dev_err(&phydev->mdio.dev, "incompatible SFP module inserted\n");
+		return -EINVAL;
+	}
+
+	iface = sfp_select_interface(phydev->sfp_bus, sfp_support);
+
+	/* Only 1000Base-X is supported by AR8031/8033 as the downstream SerDes
+	 * interface for use with SFP modules.
+	 * However, some copper modules detected as having a preferred SGMII
+	 * interface do default to and function in 1000Base-X mode, so just
+	 * print a warning and allow such modules, as they may have some chance
+	 * of working.
+	 */
+	if (iface == PHY_INTERFACE_MODE_SGMII)
+		dev_warn(&phydev->mdio.dev, "module may not function if 1000Base-X not supported\n");
+	else if (iface != PHY_INTERFACE_MODE_1000BASEX)
+		return -EINVAL;
+
+	return 0;
+}
+
+static const struct sfp_upstream_ops at803x_sfp_ops = {
+	.attach = phy_sfp_attach,
+	.detach = phy_sfp_detach,
+	.module_insert = at803x_sfp_insert,
+};
+
 static int at803x_parse_dt(struct phy_device *phydev)
 {
 	struct device_node *node = phydev->mdio.dev.of_node;
@@ -771,6 +822,11 @@ static int at803x_parse_dt(struct phy_device *phydev)
 			phydev_err(phydev, "failed to get VDDIO regulator\n");
 			return PTR_ERR(priv->vddio);
 		}
+
+		/* Only AR8031/8033 support 1000Base-X for SFP modules */
+		ret = phy_sfp_probe(phydev, &at803x_sfp_ops);
+		if (ret < 0)
+			return ret;
 	}
 
 	return 0;
-- 
2.31.1

