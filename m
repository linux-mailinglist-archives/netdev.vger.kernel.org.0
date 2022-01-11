Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 643EF48BA3E
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 22:55:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230171AbiAKVzy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 16:55:54 -0500
Received: from mx0c-0054df01.pphosted.com ([67.231.159.91]:8212 "EHLO
        mx0c-0054df01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231654AbiAKVzu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jan 2022 16:55:50 -0500
Received: from pps.filterd (m0208999.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 20BBn7jA012445;
        Tue, 11 Jan 2022 16:55:31 -0500
Received: from can01-to1-obe.outbound.protection.outlook.com (mail-to1can01lp2056.outbound.protection.outlook.com [104.47.61.56])
        by mx0c-0054df01.pphosted.com (PPS) with ESMTPS id 3dgjrs98t5-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 Jan 2022 16:55:31 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Akpavn2njX07btXSbsYuoRxdx/FZh0Dpf0Gb8Sn2/av+sNLmk9RsxfbUADAdHQecRF5uBkqLeFdSq9PZ6+3maI9JRdQCuTyc1qKB7kb0GiP63OxpqtLI6tMJoRanDBTEaqRm1gRp5sy5P4wwoUEumLc+2/6Fauw9lDxSlXRyosGFMVS3tpS/QbmYWH+z7AH6BwjwcDXJkOqkf5pZtgvWSwYtRhSF/8JhkjOLRzmCOR/8H85nFfAg/ZBpxGLS59LKA987vZn8tf5nsifCCu0E4ibtBexkPxSBAaO6+6xUrZmx8T4kesSJWDE7X9xk7zQPgTloAOcznz2kscK5R3WcQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YuAOwskVohn1G0sROrtidgXl/Lw5cfa+Pv+sjvljH9k=;
 b=VqbeerkiE97321RTOrM4KH1+5GlSHVvA+tb717L1EqCjvaP5qFhvtf+4HemZ+fxzemBfhZxzC3c6V3XBVZZRP730qe2iXWTDsAJ479mVaFrsrGW5GJ1pjxOJrSwUJJ38alTw9LAoqi7gEq/+lcO7/zqnHiwa+QTKODQ5j6LEDBv+oIUnUhAZemRWVEQjBtjYSzED+v59WwGSsVlxB8Z+5+yemm6ZffJ3wiOyeyD3IQILEharDxCbyCKd2bUpJF8njwXULs/xz8Jkjl/zLCl/RuPEhentcHNGemsHOBm8Z0MJqerFsXRcSxXYVOTGkShzLj2zP7A+1dbo1U7jxLOfbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YuAOwskVohn1G0sROrtidgXl/Lw5cfa+Pv+sjvljH9k=;
 b=MLsJ2d6Qg7K247y82Y6iwtecTx1gFbaTsZjMwqcQYmjfKv1pCLdf1iPOONtkZmDCslA7tsxdtTETA5WurKlBj/ThSPdcXRNTFjdLymqgkzK4ZArLShHLRPNnN6eJ8h+52pNkEJ8NlbKVPDQy8Jl6+IegdiXjuSvW3bwqqWQOHFA=
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:6a::19)
 by YTOPR0101MB0860.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b00:24::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.11; Tue, 11 Jan
 2022 21:55:29 +0000
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::d1f6:d9e4:7cc7:af76]) by YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::d1f6:d9e4:7cc7:af76%5]) with mapi id 15.20.4867.012; Tue, 11 Jan 2022
 21:55:29 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     netdev@vger.kernel.org
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org,
        Robert Hancock <robert.hancock@calian.com>
Subject: [PATCH net-next v2 1/3] net: phy: at803x: move page selection fix to config_init
Date:   Tue, 11 Jan 2022 15:55:02 -0600
Message-Id: <20220111215504.2714643-2-robert.hancock@calian.com>
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
X-MS-Office365-Filtering-Correlation-Id: e70970c9-82d5-4c63-424e-08d9d54d1551
X-MS-TrafficTypeDiagnostic: YTOPR0101MB0860:EE_
X-Microsoft-Antispam-PRVS: <YTOPR0101MB0860D2565D716AFD81348EDAEC519@YTOPR0101MB0860.CANPRD01.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 51tDPXiJwDe6pdTdRDzaQ1HRSE2tbhiTgtpToxb+Z1YIFVZsgwnJpiIRjAvcj4feO/qzGWHq/epNiyZ4sbzlcFIPb79y/jMzAbz28L+AM8/gnuG3OC84rZbMQ0kvUXe7J5Rnqt4bFRYcIWsZMmkKnC3MJxo8pDkzg7AEwk5ePFydHKo/NJVnZqiquTf9P3Y2mRncOfZbDTnvqEQSymkP5HW/37rYiAJw8wp8ZxCuZYLCpQzxxHIM2LeB7bGwiUEVsGaWQT9d5keGrV2vU3d+zZ1C5DksSttLFELM8cMcgCX2ORGEW+seBOLhW/GgPmXJWzM9aTQe90Uw1a40JDiRmS1gP7HBfENI3P+KTHKNHRecBfWTbOTMwBZS/y3UEXVctTBJZLw5RZUGhAKtLSh/BVS5OO119jZGdnHdIQ0weewcOzNVBjBxx8I0nT4qbnv7MdnJEClFFWzYzHMkZNbraQ8ZT4EH5tg62T9SDUdbD82sXnL26FJsiKqhSf6GztmO3rhp4Xc69a/PBPNobzJZVvo16jXtHut1Yw49T+zrrZV3nzow8nYguB1r5PBWM0cNy8XNUlGISDZFHIqMa+DGc52lRNKz3398zTk+9D9EIIOMlmAhhTSZ2oZEfcNny9TfApQG5/aF1fWIbHsrkTlkYsSOaUKG/6wjEMdHveep/xmzck6oipBA5rwdmXWKF2Z6T61QIz0SEHwCrCiE9hzUwg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(366004)(1076003)(52116002)(36756003)(186003)(6506007)(8936002)(38100700002)(6666004)(44832011)(38350700002)(6512007)(2616005)(316002)(66476007)(508600001)(83380400001)(107886003)(8676002)(86362001)(5660300002)(6916009)(66556008)(2906002)(66946007)(4326008)(26005)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?w522B4iVQDhU7G277qydwc6qDmid3BSdzVAzFu5yqTTg0zwRu1nROwSJr32N?=
 =?us-ascii?Q?XpPIgm/D/vGxmTIg2D5akau/Yu3e5hOoE920SKWkW2XSkYeACwwnP1Nuljce?=
 =?us-ascii?Q?Jx33KXx25FD34orVpstJCHefISYCtT8C43NyoO8QVEu6JwRUwfKoXYmIpo4D?=
 =?us-ascii?Q?QAy9+hFsP0p50SWqh7V93kOKaRI0EL9rFir+9i2rfesPK1AmpuabqpUlnMV6?=
 =?us-ascii?Q?lL2jvGvFutUnugJEFbTqTrwY0doce3ojIcuyGMiabA8muTT1U8J+5aZzXG0R?=
 =?us-ascii?Q?1mCQOT+xxBwNE9clXLiVkb1EOpeZ5HaOMvcdZamrd5w/xvZKMv1FJO8l7NQD?=
 =?us-ascii?Q?R6+TDryujxFoEbZVaL4ZMyfXGZCBZ7tAyLrzv6nAOvpJUpg/xtcOfsAxFWZ7?=
 =?us-ascii?Q?VTL3LdNgBpNklmU/NWOGA8zGzLuZJ6v4L/A2EUviMEu3x3SuXPuPKqY/xWKr?=
 =?us-ascii?Q?L7yuAPiotXvUGjv7TsNdZaezVl+abzoJ1cCpASlOd5ciRrlZHmPcLY36NQyF?=
 =?us-ascii?Q?tEJ03xvQfmT1Vyb2ZQ2B/RJW7aniFSudXBlNIiOQvIuOC980NHwtpX/CNiJo?=
 =?us-ascii?Q?ORnBRpmwvlH0gQ7+gnEUpQ6kUtqMkL8kUvAkFCT7TxfTHndf0uekXUCNP5YZ?=
 =?us-ascii?Q?QtaydWR5egUga4RjUHACP8r20MPKTzPe7wHPGsSHybx1nYEnvfytifHwUofz?=
 =?us-ascii?Q?dNbpiyYrSS4QEtqhC6o/icCqURfJtfzzOKd1xL9oBi2AyVfoRWhPMnOQF2LY?=
 =?us-ascii?Q?QPzndrcyZ3HZ5RCNlZYPFx8q+8sM2AaK2xe96vPeVPau7RT/+TatoGqUjEa9?=
 =?us-ascii?Q?9Sa1YdrlaTF3bMQ1VdgB8ungdHDpqZZsgR8PCF/RrsEzMkTYwbdWnWJaaXO4?=
 =?us-ascii?Q?WbLUiWTDPeEwoyfQuW6kaTnmtJdVgjWCid7vGdEV2hoMLrUy0pXlkGjk92jR?=
 =?us-ascii?Q?50vsHo0zz1HgBPBclBexkk5v9V+9ioHR2NckQTLQ6TOZoiq8HMZ/ZbbUDzpa?=
 =?us-ascii?Q?khWD9hBT82P1EKynRaZ53BsvDlDzkqLleF9spPTVcb6wMGLxJxxEQXXMmr69?=
 =?us-ascii?Q?ygO7WRP7YD+RvMVQilx6eP4xWQC26FQ7Ol8AO3/V5S2/iGjhA1HMgkfa1naa?=
 =?us-ascii?Q?vugHUzuVbzHsBDrAP9ow1yOAAvgx97gzJNsP4xkLwo+YBp4pGVXDEprBCWTE?=
 =?us-ascii?Q?TUug2DXTkEOaeyyBU2oa2yYIUBuxRA+kGzcWiL2LugJ0ZvBtBFJhHOVQ3d1n?=
 =?us-ascii?Q?6kZzJzQyU5jIQ+LvmLpV982TvcjRmoYTp5lbjRX8rszc9woeaIZZzUy2Y8S6?=
 =?us-ascii?Q?kK1jLrX2jF1PHPGjdlMYhySzmka4gqtvvKchamSQUaLHKbLrfBRfnRj7g5T8?=
 =?us-ascii?Q?A3mg25TZYKrUxHe770mSZ9QQAAOZxNbqLkXHau0/ivkR1hmwhFfigirdI3XB?=
 =?us-ascii?Q?gGsnUSzpfoIot5r+z/++foKjYKBuydO7yIJu4bNojl0bsw21XVmbAxeY1RAE?=
 =?us-ascii?Q?4jtjI4GTWsGWG1lxMojvXBIBahvOUHv6TpmTClXzBpL2wNPHqXQKGLYmBCb0?=
 =?us-ascii?Q?2TcEPWB0MyFrWTnyocE9bH8itbWZC3ai30JJc0IZJg3HGAWqTtGxc0DdNv3P?=
 =?us-ascii?Q?gO0UqipBpUYkqDoC7UiMQ0wAkeh86OHTToRwlV2XTsPRfiwqpRvmFdZ5Rk4G?=
 =?us-ascii?Q?BKCeI6h+wJnys5CQNcXjd6zEbok=3D?=
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e70970c9-82d5-4c63-424e-08d9d54d1551
X-MS-Exchange-CrossTenant-AuthSource: YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jan 2022 21:55:29.7105
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BmAZjv3qe5MFWYDKrFpmIOfCTsXAa1pSu3xujOrqkTQY3Q6fSKXY07EeBlovfiJw7pb9+LTV/71OsbAlZJJtHUGqGkslxSW71rO99z4/mMo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YTOPR0101MB0860
X-Proofpoint-ORIG-GUID: W12rnVayZDxDqPcNFENCWir8yh2vdKIh
X-Proofpoint-GUID: W12rnVayZDxDqPcNFENCWir8yh2vdKIh
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

The fix to select the copper page on AR8031 was being done in the probe
function rather than config_init, so it would not be redone after resume
from suspend. Move this to config_init so it is always redone when
needed.

Fixes: c329e5afb42f ("net: phy: at803x: select correct page on config init")
Signed-off-by: Robert Hancock <robert.hancock@calian.com>
---
 drivers/net/phy/at803x.c | 40 ++++++++++++++++------------------------
 1 file changed, 16 insertions(+), 24 deletions(-)

diff --git a/drivers/net/phy/at803x.c b/drivers/net/phy/at803x.c
index dae95d9a07e8..23d6f2e5f48b 100644
--- a/drivers/net/phy/at803x.c
+++ b/drivers/net/phy/at803x.c
@@ -784,25 +784,7 @@ static int at803x_probe(struct phy_device *phydev)
 			return ret;
 	}
 
-	/* Some bootloaders leave the fiber page selected.
-	 * Switch to the copper page, as otherwise we read
-	 * the PHY capabilities from the fiber side.
-	 */
-	if (phydev->drv->phy_id == ATH8031_PHY_ID) {
-		phy_lock_mdio_bus(phydev);
-		ret = at803x_write_page(phydev, AT803X_PAGE_COPPER);
-		phy_unlock_mdio_bus(phydev);
-		if (ret)
-			goto err;
-	}
-
 	return 0;
-
-err:
-	if (priv->vddio)
-		regulator_disable(priv->vddio);
-
-	return ret;
 }
 
 static void at803x_remove(struct phy_device *phydev)
@@ -912,6 +894,22 @@ static int at803x_config_init(struct phy_device *phydev)
 {
 	int ret;
 
+	if (phydev->drv->phy_id == ATH8031_PHY_ID) {
+	       /* Some bootloaders leave the fiber page selected.
+		* Switch to the copper page, as otherwise we read
+		* the PHY capabilities from the fiber side.
+		*/
+		phy_lock_mdio_bus(phydev);
+		ret = at803x_write_page(phydev, AT803X_PAGE_COPPER);
+		phy_unlock_mdio_bus(phydev);
+		if (ret)
+			return ret;
+
+		ret = at8031_pll_config(phydev);
+		if (ret < 0)
+			return ret;
+	}
+
 	/* The RX and TX delay default is:
 	 *   after HW reset: RX delay enabled and TX delay disabled
 	 *   after SW reset: RX delay enabled, while TX delay retains the
@@ -941,12 +939,6 @@ static int at803x_config_init(struct phy_device *phydev)
 	if (ret < 0)
 		return ret;
 
-	if (phydev->drv->phy_id == ATH8031_PHY_ID) {
-		ret = at8031_pll_config(phydev);
-		if (ret < 0)
-			return ret;
-	}
-
 	/* Ar803x extended next page bit is enabled by default. Cisco
 	 * multigig switches read this bit and attempt to negotiate 10Gbps
 	 * rates even if the next page bit is disabled. This is incorrect
-- 
2.31.1

