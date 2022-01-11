Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD44F48BA41
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 22:56:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232894AbiAKVz7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 16:55:59 -0500
Received: from mx0c-0054df01.pphosted.com ([67.231.159.91]:8216 "EHLO
        mx0c-0054df01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229533AbiAKVzx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jan 2022 16:55:53 -0500
Received: from pps.filterd (m0208999.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 20BBn7jB012445;
        Tue, 11 Jan 2022 16:55:32 -0500
Received: from can01-to1-obe.outbound.protection.outlook.com (mail-to1can01lp2056.outbound.protection.outlook.com [104.47.61.56])
        by mx0c-0054df01.pphosted.com (PPS) with ESMTPS id 3dgjrs98t5-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 Jan 2022 16:55:31 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UnytHqBIs+Ot+yv2qLkJXzNEFDlqcW86aZTi2pQx7HIKv49hhjIiandh9sL9z4hAKL+IsF4peDRTQzT4/j/sp/P8xeTftO8ngZNkZ/3zNmHr4zzmAdJRO59unzAX5nZsPyOGsDh09YgoMpIzHzslj/eKWP0YCsSom2jiBF/7P5U6lVuHgXtf+rjW5Cl3rAFYD7RnxWfln62TM7Hwei/pqEGkukZMmDavsPywYVOpqlATog4CkB09gL9tEkc1e3f2mETOmQoVAn4xzVAud1RR8Qp8xEu+Wn/zUhBIvx8wRVmDttweAdJ9Qr9sPUdfZ5aMvgwgdxgYk38lMD//2VDxYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EEZkAxnjK9MWxxhWI3Gz46BeOPRHgtv6cjjv1/qXUMI=;
 b=X6GKUt/IGkl7w8EtVZ/fXb2j5QaUAyvwftDqJbLcZ38Va6voc8egwwW73/P4NW/yw5HWjIFDlJeSehhYNatTbsdfQwOMkh6F6vThaGAFxSTqV0BB84EtPzUD87geo8bNAT3XhzYKeb9ATFW1wl9JNC4Dr2RlWFFqtLIErFi9uCZSTmK2F4FQyDlFV7wT6z2nlmCBNdLT3ec86DWh9e1H7KGLqrpzYJwqEMIVocW2Erqus6yQlKRAc2pftNEQwbadHAiJoZEkoFNqUHGDQbiYF222TTTZw8j7DQnRwuElqJgHEZbXVikAdutkwU2f8Va7PQryZ+8cBxyan/yxU8n0JA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EEZkAxnjK9MWxxhWI3Gz46BeOPRHgtv6cjjv1/qXUMI=;
 b=Y6sUzfWaeOol5xEs8i5XYwYQ9SQPFqyjb+2AjDK1iCp123tgQo8z8o9+lRgKUjl1Y2qh8VTCHKqlkYdD4VTREj2HFMAYhq4XfXxjTA1eBi7RHmEAfpn0tDCRIi/hbpDFYLBQchQHvzfxD4GV8WXUU9n43BeMPxY3Qbn8/7uQQZY=
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:6a::19)
 by YTOPR0101MB0860.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b00:24::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.11; Tue, 11 Jan
 2022 21:55:30 +0000
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::d1f6:d9e4:7cc7:af76]) by YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::d1f6:d9e4:7cc7:af76%5]) with mapi id 15.20.4867.012; Tue, 11 Jan 2022
 21:55:30 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     netdev@vger.kernel.org
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org,
        Robert Hancock <robert.hancock@calian.com>
Subject: [PATCH net-next v2 2/3] net: phy: at803x: add fiber support
Date:   Tue, 11 Jan 2022 15:55:03 -0600
Message-Id: <20220111215504.2714643-3-robert.hancock@calian.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220111215504.2714643-1-robert.hancock@calian.com>
References: <20220111215504.2714643-1-robert.hancock@calian.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR04CA0021.namprd04.prod.outlook.com
 (2603:10b6:610:76::26) To YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:6a::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 76545d77-f122-4ac9-fe73-08d9d54d15b2
X-MS-TrafficTypeDiagnostic: YTOPR0101MB0860:EE_
X-Microsoft-Antispam-PRVS: <YTOPR0101MB0860E0F8FEE1D88427138B56EC519@YTOPR0101MB0860.CANPRD01.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: j/sJ98Rd/zqtg1PpyovtweIjxK6JGiHrnuG5xQh0rCQgy67vbGIhkrSNSImBSUT0x6XCfQYILEtfo86Lrpxoy1AzbV7nPx9ryZAIEmx6sIp60IrFN1l+eekdXo2yv007IIH9Xz2ehAQDfM/Q5ArqGSOjzWwtVEPZKtZqEBHgMut1WjDotvq14WFIyz/1eSeVN7ms6kzd4LzqRzSJoj0+GfW6IrxAm6iHUzEysYRwkcLZ8QzQuUMBwOmbkkyyAwvncjorQMi39qtak64okEZ2VyH6l4zcSVPjRr0rPKJ7ifZzJvwNWD2cAIphNHNeHDlYrPmQtb8HRFbj2bTIoOQEbRZYdpUtu71bflL2DQ0B759GSBPml/HusQtXdc80B7+1kNHYQdzJ95J2OUUo/GcCdKwt8WC6WkCUrm4OZXf6r5285Y5kg7G5DD0COUeCVZ0odJt5DhPzfMD5TmVRnwtEVY4EtcnN1w98SwHqb4RZvxrbiFfkTgcc2kUzwKrsQYnAEq61aMyMy18L9J9M9Yw2sc+kRK18izVdq2gSWCb0eAmdcV09KPjoTsYbeSq8sy/LzrK9anBTUfTzZkNAzvuYWtT0+8lThPvca5lJLey/1RqYCeQvVyLgxg/W79YlfKGxP22f65CRNsPdGYGOnKaCyExat9VYur05jlHu1cIjHXWXPGGAst7qKqw16a70lg9I+4oukrHZZe+OitjYXVospg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(366004)(1076003)(52116002)(36756003)(186003)(6506007)(8936002)(38100700002)(6666004)(44832011)(38350700002)(6512007)(2616005)(316002)(66476007)(508600001)(83380400001)(107886003)(8676002)(86362001)(5660300002)(6916009)(66556008)(2906002)(66946007)(4326008)(26005)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?wdQ6bRFiaYO7B1+tghaqYJA1q2EZpE5Lbq+bN961Jv5SxhmnMR4yqbvVakDC?=
 =?us-ascii?Q?nQCoVrX9+sbo4wI2rkKcG9s2mEDENIulP0cYP5KghMGIqhvBe5XPj6S618Yp?=
 =?us-ascii?Q?/ZH5zTyA2Dod3fmCgD4gGyyYX9FTS0bzCRtWUubLXU3t2ojIQHE5Fnc9HfjN?=
 =?us-ascii?Q?yCUAuQawo0uubl8cNeqlVpfBNmVXNp3Y7nnPXgIWQtcPThqIp8v9tRq6TeQc?=
 =?us-ascii?Q?Jiq0+X4gWW/Gbop/8+bt7x5iZfu6ori+LGus/fKvnE+j+7+vmAMrISuQKFXW?=
 =?us-ascii?Q?h0f4jHSDtFelcX9gdaePQ6+QRxO4qJ+EEMgi3ZpsAFc1bE/xmfu2F9LufWtL?=
 =?us-ascii?Q?c03pRV18eYILGpweIbsfaViUbu7Df+dhvG6hrEgek/FmKpVwF37rNzOPBDNs?=
 =?us-ascii?Q?kfwsj4VwKGhShn0RfGd7UncB6u1Of34BMsFM4+gt8qhEkL0wlXVvlt8BvoBb?=
 =?us-ascii?Q?mGZlSjAUoqH6KXJ7EvUEh20qdBC+Q6cu3E3UznAmaBCx/AO334ItWFGOGeoa?=
 =?us-ascii?Q?KDQimpx864RXs/YE1k+d+Xg1O1CAldDwf7P8sPTNRsmnaIMNy1USWYY9jGtu?=
 =?us-ascii?Q?Y6BGSuAfws098HKM9n+vT+ELiH+XNSnzyr9VWv8W2FxeFXIMy4djhjtCizCX?=
 =?us-ascii?Q?/e2cWEEGsh+k+yrzh1MzVIrgQA40WdjydpjXHUDJYA3So2/nNEtbpwhg5yb8?=
 =?us-ascii?Q?dJpaOW47CQv38mczNhotcl6SujAyMXdaGdLm0pz6AB1g5pcJ1w/mnV5SHOpR?=
 =?us-ascii?Q?ZLfxlpXBjB8+6MXMmWXFDcaqNBcLbCiRtlPMLPLFdCTK+r7W9bZt5OK02n1I?=
 =?us-ascii?Q?u8eB8pJsvg7CfsSmz8XH94chNtF/tV/ySJjT3f+SD4glblclH1NoPyIgO4Og?=
 =?us-ascii?Q?PKKXERxXWe/gGjsct2zOQHoPoStnGU5XSEGQ7H0S9I+m2tJb992xS7nMSDvL?=
 =?us-ascii?Q?qomcLZ8rQ2+KNtQA/24vj6TY+rNddNNZ1+2CRlE+CaLvK5paEDjtdKsPKKIt?=
 =?us-ascii?Q?G43ywdNBSASLAAKudNpWxjmjX9o3wDduzxm5F/aZ8cOlfsGIbLQOB8Qti9Pc?=
 =?us-ascii?Q?K1iEOn0FCv6ENQLCQSlfdEwJDfudMbXobH89jDdy9Nt6BDqbbeRg3AbHptpT?=
 =?us-ascii?Q?56g5wdn7RBPVF11ijW+kWOm9T8e0fyLkwMs/SIIUrfVpe020I9oPTZ0/XnDX?=
 =?us-ascii?Q?fVaodmU386Lo+EoBZBarNff9bYmBW/637e4IpYiZfUqYoXVV9kpbKzbxeJki?=
 =?us-ascii?Q?rU0pKiNNJNxSztKjpGX+Uu/mlOfZqosKLo11wIivWM60ExSKHn1xHQwgmt2F?=
 =?us-ascii?Q?dJoTamm2U90GGgLHEpPjTRkD2s7fxlxOXxl+zPtO2HjNiI7alHeDuDPfsLJ5?=
 =?us-ascii?Q?4wRwDuz3mL2GOLQeH6kRhtXsinDbMkutpGhCjLO0q7LTgCCNxFNweKxwxABj?=
 =?us-ascii?Q?eiacgwRcOEavjYiukDbCj3nwHHzloh8cGesZ97LIep/2dq31qW728MI4OP1n?=
 =?us-ascii?Q?zyNY+Ehtw6A5KfYAuhMzE1+vO72irWmf3L2WCzfGrmH2RxjO12ZNkP++azV2?=
 =?us-ascii?Q?yjhROHzz1+Y8xn4025SYLWjayTgpu89YqAaPG0PxDqESD+krYME0aqO9jn8f?=
 =?us-ascii?Q?0OE1Gqf6mSz4h4M7yQB3ttnuxl31YE+gLWveNNQ7vDG2AaFGh2FanIpkOLCH?=
 =?us-ascii?Q?iQjEpQewU912XzZAnWzXpt6PpwI=3D?=
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 76545d77-f122-4ac9-fe73-08d9d54d15b2
X-MS-Exchange-CrossTenant-AuthSource: YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jan 2022 21:55:30.4135
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3lTl8VNTdcJPpPjVCu7Su7mhxaif3hRl7hjs3K04Hc6aFRdD1vfTaKUQNYzwQoe7gI8etM8DhjdwRxX0C7wz2WxPMMp+eBA7kvqTezlJasE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YTOPR0101MB0860
X-Proofpoint-ORIG-GUID: MjbVefZXynYSXqmXsX6v7-Cz_BCqUSlD
X-Proofpoint-GUID: MjbVefZXynYSXqmXsX6v7-Cz_BCqUSlD
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-11_04,2022-01-11_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 priorityscore=1501 suspectscore=0 adultscore=0 clxscore=1015 phishscore=0
 mlxlogscore=999 malwarescore=0 spamscore=0 mlxscore=0 bulkscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201110114
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Previously this driver always forced the copper page to be selected,
however for AR8031 in 100Base-FX or 1000Base-X modes, the fiber page
needs to be selected. Set the appropriate mode based on the hardware
mode_cfg strap selection.

Enable the appropriate interrupt bits to detect fiber-side link up
or down events.

Update config_aneg and read_status methods to use the appropriate
Clause 37 calls when fiber mode is in use.

Signed-off-by: Robert Hancock <robert.hancock@calian.com>
---
 drivers/net/phy/at803x.c | 80 ++++++++++++++++++++++++++++++++++------
 1 file changed, 69 insertions(+), 11 deletions(-)

diff --git a/drivers/net/phy/at803x.c b/drivers/net/phy/at803x.c
index 23d6f2e5f48b..63d84eb2eddb 100644
--- a/drivers/net/phy/at803x.c
+++ b/drivers/net/phy/at803x.c
@@ -51,6 +51,8 @@
 #define AT803X_INTR_ENABLE_PAGE_RECEIVED	BIT(12)
 #define AT803X_INTR_ENABLE_LINK_FAIL		BIT(11)
 #define AT803X_INTR_ENABLE_LINK_SUCCESS		BIT(10)
+#define AT803X_INTR_ENABLE_LINK_FAIL_BX		BIT(8)
+#define AT803X_INTR_ENABLE_LINK_SUCCESS_BX	BIT(7)
 #define AT803X_INTR_ENABLE_WIRESPEED_DOWNGRADE	BIT(5)
 #define AT803X_INTR_ENABLE_POLARITY_CHANGED	BIT(1)
 #define AT803X_INTR_ENABLE_WOL			BIT(0)
@@ -85,7 +87,17 @@
 #define AT803X_DEBUG_DATA			0x1E
 
 #define AT803X_MODE_CFG_MASK			0x0F
-#define AT803X_MODE_CFG_SGMII			0x01
+#define AT803X_MODE_CFG_BASET_RGMII		0x00
+#define AT803X_MODE_CFG_BASET_SGMII		0x01
+#define AT803X_MODE_CFG_BX1000_RGMII_50		0x02
+#define AT803X_MODE_CFG_BX1000_RGMII_75		0x03
+#define AT803X_MODE_CFG_BX1000_CONV_50		0x04
+#define AT803X_MODE_CFG_BX1000_CONV_75		0x05
+#define AT803X_MODE_CFG_FX100_RGMII_50		0x06
+#define AT803X_MODE_CFG_FX100_CONV_50		0x07
+#define AT803X_MODE_CFG_RGMII_AUTO_MDET		0x0B
+#define AT803X_MODE_CFG_FX100_RGMII_75		0x0E
+#define AT803X_MODE_CFG_FX100_CONV_75		0x0F
 
 #define AT803X_PSSR				0x11	/*PHY-Specific Status Register*/
 #define AT803X_PSSR_MR_AN_COMPLETE		0x0200
@@ -283,6 +295,8 @@ struct at803x_priv {
 	u16 clk_25m_mask;
 	u8 smarteee_lpi_tw_1g;
 	u8 smarteee_lpi_tw_100m;
+	bool is_fiber;
+	bool is_1000basex;
 	struct regulator_dev *vddio_rdev;
 	struct regulator_dev *vddh_rdev;
 	struct regulator *vddio;
@@ -784,7 +798,33 @@ static int at803x_probe(struct phy_device *phydev)
 			return ret;
 	}
 
+	if (phydev->drv->phy_id == ATH8031_PHY_ID) {
+		int ccr = phy_read(phydev, AT803X_REG_CHIP_CONFIG);
+		int mode_cfg;
+
+		if (ccr < 0)
+			goto err;
+		mode_cfg = ccr & AT803X_MODE_CFG_MASK;
+
+		switch (mode_cfg) {
+		case AT803X_MODE_CFG_BX1000_RGMII_50:
+		case AT803X_MODE_CFG_BX1000_RGMII_75:
+			priv->is_1000basex = true;
+			fallthrough;
+		case AT803X_MODE_CFG_FX100_RGMII_50:
+		case AT803X_MODE_CFG_FX100_RGMII_75:
+			priv->is_fiber = true;
+			break;
+		}
+	}
+
 	return 0;
+
+err:
+	if (priv->vddio)
+		regulator_disable(priv->vddio);
+
+	return ret;
 }
 
 static void at803x_remove(struct phy_device *phydev)
@@ -797,6 +837,7 @@ static void at803x_remove(struct phy_device *phydev)
 
 static int at803x_get_features(struct phy_device *phydev)
 {
+	struct at803x_priv *priv = phydev->priv;
 	int err;
 
 	err = genphy_read_abilities(phydev);
@@ -823,12 +864,13 @@ static int at803x_get_features(struct phy_device *phydev)
 	 * As a result of that, ESTATUS_1000_XFULL is set
 	 * to 1 even when operating in copper TP mode.
 	 *
-	 * Remove this mode from the supported link modes,
-	 * as this driver currently only supports copper
-	 * operation.
+	 * Remove this mode from the supported link modes
+	 * when not operating in 1000BaseX mode.
 	 */
-	linkmode_clear_bit(ETHTOOL_LINK_MODE_1000baseX_Full_BIT,
-			   phydev->supported);
+	if (!priv->is_1000basex)
+		linkmode_clear_bit(ETHTOOL_LINK_MODE_1000baseX_Full_BIT,
+				   phydev->supported);
+
 	return 0;
 }
 
@@ -892,15 +934,18 @@ static int at8031_pll_config(struct phy_device *phydev)
 
 static int at803x_config_init(struct phy_device *phydev)
 {
+	struct at803x_priv *priv = phydev->priv;
 	int ret;
 
 	if (phydev->drv->phy_id == ATH8031_PHY_ID) {
-	       /* Some bootloaders leave the fiber page selected.
-		* Switch to the copper page, as otherwise we read
-		* the PHY capabilities from the fiber side.
-		*/
+		/* Some bootloaders leave the fiber page selected.
+		 * Switch to the appropriate page (fiber or copper), as otherwise we
+		 * read the PHY capabilities from the wrong page.
+		 */
 		phy_lock_mdio_bus(phydev);
-		ret = at803x_write_page(phydev, AT803X_PAGE_COPPER);
+		ret = at803x_write_page(phydev,
+					priv->is_fiber ? AT803X_PAGE_FIBER :
+							 AT803X_PAGE_COPPER);
 		phy_unlock_mdio_bus(phydev);
 		if (ret)
 			return ret;
@@ -959,6 +1004,7 @@ static int at803x_ack_interrupt(struct phy_device *phydev)
 
 static int at803x_config_intr(struct phy_device *phydev)
 {
+	struct at803x_priv *priv = phydev->priv;
 	int err;
 	int value;
 
@@ -975,6 +1021,10 @@ static int at803x_config_intr(struct phy_device *phydev)
 		value |= AT803X_INTR_ENABLE_DUPLEX_CHANGED;
 		value |= AT803X_INTR_ENABLE_LINK_FAIL;
 		value |= AT803X_INTR_ENABLE_LINK_SUCCESS;
+		if (priv->is_fiber) {
+			value |= AT803X_INTR_ENABLE_LINK_FAIL_BX;
+			value |= AT803X_INTR_ENABLE_LINK_SUCCESS_BX;
+		}
 
 		err = phy_write(phydev, AT803X_INTR_ENABLE, value);
 	} else {
@@ -1107,8 +1157,12 @@ static int at803x_read_specific_status(struct phy_device *phydev)
 
 static int at803x_read_status(struct phy_device *phydev)
 {
+	struct at803x_priv *priv = phydev->priv;
 	int err, old_link = phydev->link;
 
+	if (priv->is_1000basex)
+		return genphy_c37_read_status(phydev);
+
 	/* Update the link, but return if there was an error */
 	err = genphy_update_link(phydev);
 	if (err)
@@ -1162,6 +1216,7 @@ static int at803x_config_mdix(struct phy_device *phydev, u8 ctrl)
 
 static int at803x_config_aneg(struct phy_device *phydev)
 {
+	struct at803x_priv *priv = phydev->priv;
 	int ret;
 
 	ret = at803x_config_mdix(phydev, phydev->mdix_ctrl);
@@ -1178,6 +1233,9 @@ static int at803x_config_aneg(struct phy_device *phydev)
 			return ret;
 	}
 
+	if (priv->is_1000basex)
+		return genphy_c37_config_aneg(phydev);
+
 	/* Do not restart auto-negotiation by setting ret to 0 defautly,
 	 * when calling __genphy_config_aneg later.
 	 */
-- 
2.31.1

