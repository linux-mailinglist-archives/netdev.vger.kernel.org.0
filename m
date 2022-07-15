Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B246576967
	for <lists+netdev@lfdr.de>; Sat, 16 Jul 2022 00:03:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231902AbiGOWCw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 18:02:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231899AbiGOWBY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 18:01:24 -0400
Received: from EUR03-VE1-obe.outbound.protection.outlook.com (mail-eopbgr50084.outbound.protection.outlook.com [40.107.5.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7BCF8C15A;
        Fri, 15 Jul 2022 15:00:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TjphGwh45PlM83TTl1DP25zxzX1nLIZ2tbL5t8dCGd0muKlyCpAJuQw4yUll/CXw8u8Wq7Y9yjokZxa0L9ssKCS8ZwGxpO5AJ68ClDsTRKE4Dk8g+1lWsvGLTlC1D/sfBSNCytbA15SABrJKAjK9IA2b8ZE/ekQBgL4A7q/HkbHNhP1ZUV75ES+B1O5FAHRpJ6MXpBn36/y2Ppl2FDOHlDv+SSAKIc+PTxW2oErVFzhorr4ez0tTI4VEvai/8JuiqlKUjlbREtkEJTJ0IIFEcGqn26+FfLg8XNrZN1fiqQKmOlce2pzUG9iFSmM0qFVFq79iPLqm2AphbuVcB4h9Ag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rPY1njZtILUEsQez2HiDy/q4A3Gla8dBhyfomEEgm84=;
 b=lusYGXx5BAdHlQyu6rIgHsXde280MHnNrwQ56C0B0qiKbYv7UTQnTeHkuh4sxliVUDZNSwK7P6cuIybyOPJ0nNhsXmzk+Bz0iFNdppyEGXfwUX4z9EA9m49Ik9ADV6565Tr3CZf4FRWWRmDBo4+27pev5v4s1kxjPnT/REanQNt3v6b/UI2aeJ+w7QDMGWfqsTtPV8oc+boDh+E3N7hEegmE38mKV83qfkQdjSsJ3M9c9GSyP4PMonH/whVc9q5+9E3hqBuymfVSC4g1g8eRNwWMOC93hWPwH3rXzCQzc1PKHrwQtIsq4at/TQH8qxUF5MeLJ73MGUcKBvc+lCQsZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rPY1njZtILUEsQez2HiDy/q4A3Gla8dBhyfomEEgm84=;
 b=sKxr0VtlG49Vn0K1Jz7AqVL1hlkAJz5/2HXhWPF4L9mD0BpyQm7LhSFkdUu4X2dLUBGDB5CS+mIqJaKW6jQFSK9bpSGEIq4A7A3vnMVKoM2xSuDcbGMtc2t7zNDmh671gk+fanRHI0drX/bJb2fMBh2wIh8fsGfMJWy4CPvDM/BXSZC+FcrK8NMDT88Qux1JT5jljue8FWxfMDSN33/n32IxxIWIw/C1alU7qsWD+nRoe1BUXEJF7+juhzsSWOSfngqeXJRlRfC5K5DUwHr8vYJabE/k98VKLtsU/QGlR/EVxYQhovkG7s/ywPcNXOB8WaLXavK9hmFpQ/WWC9dZYQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from VI1PR03MB4973.eurprd03.prod.outlook.com (2603:10a6:803:c5::12)
 by DU0PR03MB8598.eurprd03.prod.outlook.com (2603:10a6:10:3e5::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.15; Fri, 15 Jul
 2022 22:00:46 +0000
Received: from VI1PR03MB4973.eurprd03.prod.outlook.com
 ([fe80::5c3e:4e46:703b:8558]) by VI1PR03MB4973.eurprd03.prod.outlook.com
 ([fe80::5c3e:4e46:703b:8558%7]) with mapi id 15.20.5438.015; Fri, 15 Jul 2022
 22:00:46 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>, netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        linux-arm-kernel@lists.infradead.org,
        Russell King <linux@armlinux.org.uk>,
        linux-kernel@vger.kernel.org,
        Sean Anderson <sean.anderson@seco.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next v3 14/47] net: phy: aquantia: Add support for rate adaptation
Date:   Fri, 15 Jul 2022 17:59:21 -0400
Message-Id: <20220715215954.1449214-15-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20220715215954.1449214-1-sean.anderson@seco.com>
References: <20220715215954.1449214-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR10CA0009.namprd10.prod.outlook.com
 (2603:10b6:610:4c::19) To VI1PR03MB4973.eurprd03.prod.outlook.com
 (2603:10a6:803:c5::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 631a5be3-786a-479a-5f9e-08da66ad7886
X-MS-TrafficTypeDiagnostic: DU0PR03MB8598:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: l4Ky9M9kiKPona2NxSMDwNgjXuLuklieoEVnc7PsCgJlBdqnH5hjUittW7N6vztDWl3K9su5FGgdhLCqh3cmfZJibWknk98Yvwvt4l17JfgpK7S6ocqaQJ5uIf66LU+s8kYE4SMIYo2Evx5SiR3vaLfdMxxB7kgnuDxpOEtsrubPdyceKiEFlwNX4JgonfT+8DsjtiwplccUFYht7401Z1DSflauziXMDnTvU/jRqN3Ly/0Jf1+U2wcX0NkWHPeCZW9Z6pwtEP1VPexJN6WcaWSDsY8w+2W0rXZJh85wmjcvsvOfJGufb8Lvo5sec92zbJP6z8BQnIZ2jt1FIINhRw7ZYw+JhHfFyVmLLhfzihRGqGAGO/cW02OmciGC8GJxPjZQ+1COnjvWo0G3X8xdS4B+VIkJ3HUZNRUo1OSPDqYT1dcKgw6mrElPWNmc/MSJoLjrLm9UEDW2bPOh6BJJNGOE7+I7fj6CZwwLEQWKwvxivRTezDV5fExQkukuYIg9GoEZ375K90LUOtjZUrWg/5lhxR9k4HSyeW+Bn71M9XKLMTD/Bec1lfgsN9Mv7nUVfVfiBv5CGHpq/LWLDBNpWNgYUMOFBVT5UlM6PPPR23OhErzz5OJsYiW1b7FopvbH5juS4Q8j46RfHFQMmnLbzJwHBU6idbYAUUKNZVG2+H+yl02hrFUnaQGo9RKDeQhiRYMp2xryKrBveRPVAS41m4B4XLP8eJh/7SWUJZvNZyudKXjkkxxTJZainPlbTEnVwSByb6Sr5/YDRhpmWtMQge5jiWHUJ1Gj7M6/CvIYDu927d2kEmOmaKPRDGvR630S
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR03MB4973.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(366004)(39850400004)(376002)(346002)(396003)(5660300002)(8936002)(44832011)(7416002)(2906002)(54906003)(66556008)(4326008)(8676002)(66476007)(66946007)(110136005)(86362001)(316002)(186003)(2616005)(26005)(38350700002)(52116002)(36756003)(6666004)(41300700001)(478600001)(6486002)(1076003)(6506007)(83380400001)(6512007)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1SzR9k4tEzLQymcaDuOIqtBGw2TcK/HG7R5Nu5+LM26JH7UJUXwMFg0fOyAV?=
 =?us-ascii?Q?zoOrcH/96u/Ke4ockyBKuoTmlWpRHjrgwVRAKVJGjm3IGwrtD74mNjtxMLxc?=
 =?us-ascii?Q?G4M2cXwa8grwkc/kpEdw4VT7gQfN1VCFjKoZQ4E902dkF6aRuv4ODiMmSbeL?=
 =?us-ascii?Q?H4U62ljak/u40uVLdQY2xY2MDv5MV2BvHhFl/HiJCNDGQAZQSq9ARbE/i3iT?=
 =?us-ascii?Q?HLeY1OIa02841TeImlpWyMSHiQq1wEKQz8j62wxbEa9Dec5fm+UMQ8bLp6jH?=
 =?us-ascii?Q?7gqf65wBPz4fMUpK6q+c2U4E+wpd3ku1JwZDF8CzLua9WuAHpiLwrb7nfo6+?=
 =?us-ascii?Q?BjKgOcjJbWX2m2duVrXhYGfWOwJe8oUbBauhX4UTnfnkRhRc1suQyD76d2Ox?=
 =?us-ascii?Q?leZ5pe5jrZe/aYOv2IPCsE2uUzARDsEEjXW+/ewf+kVQ6TheR7HS9Ln6867o?=
 =?us-ascii?Q?Sgn1eZdr2Sev2KwVQOtqgAFqX0o/NwExYA3ZXZ3vkrZb0c5dkBMF1w7R/ZdB?=
 =?us-ascii?Q?Ec7E7kj3/8PgUzx9NHUshfMyQlLpcajD9taWjwBTBKKTZVBFZxDXSNKCa6CY?=
 =?us-ascii?Q?OwBjTpfmLkTd84oZn0QtL1PcgFCRut3cG/Bq6nbg+6UppZeYI+/eslMx9jUw?=
 =?us-ascii?Q?NHNktluIiBxZx3qCw0+efyJJ5zqvD6iChsC7ZqMBNvywNPpbxuSCjgLWJxzZ?=
 =?us-ascii?Q?j4Jk5h3SZnJNdJamHAjGaCcx2PKcR0ASp51exPSJ9DjNaczk0MQPiFOILoJr?=
 =?us-ascii?Q?9XaSFV7XopYErH1WvW1J2hxy8Pk2B07I5P3OqnxkfaOjFhBkyT2pkiOZgymE?=
 =?us-ascii?Q?dWU6z3qjlyqeKIsBOwav9GLPg4Znw33yHkFfPROwDSDBjaEyBOz8bc18i9sd?=
 =?us-ascii?Q?fmk3rnOYOqzy4sSKMPzGNxn8a18ePhTxsJyRnGIPFCSeq+OFJmDsNlciWJhS?=
 =?us-ascii?Q?+iTGR1MkFM2d8YtGUCfVkAkktpvcCdBrs+63r1Mh5uCvRnPPuo7zYdI3Ixou?=
 =?us-ascii?Q?HzxIWbdx+MmH+izExXGnHxPvrQuhRfm6vQXxZUn88IDcK2MIInmk23z9khaK?=
 =?us-ascii?Q?Fv/2tYl2lTU4F+bZ7dDONhsfHQKyNIUGrqpnv/Y19Gd0CRfQYjBfU6YxeOZM?=
 =?us-ascii?Q?/MKQcI3lTLsBx28fMP0eKQf/Ti0hOXslJHvvxbCSnQIcbk2EOGL29jVsyg8Q?=
 =?us-ascii?Q?fGzqXpOFJhXpznmLwb4+9M9aw7/MFwPTDMA593eYVNHNQZcQmfXdTNesL5/3?=
 =?us-ascii?Q?j62cqcCORmRxEvKgT7n5Q43/grhQNMPK3WHDA42nSkWxipE03+xx0W8Bb30D?=
 =?us-ascii?Q?TBhMdyixwrNvPQB7aqpRWFLwdVwFuapMk4eD29QJNu028tEjrDGaNEBal//P?=
 =?us-ascii?Q?Ce9ZNatshH/ochBDIkckh6mrM518u/dQKooaR/zDZOHiAy+3bxqDgLo8C7wa?=
 =?us-ascii?Q?w1+/q0BroppDzlBLKsoR2jhRqvH0sQ6OJrRMeqYieWeDt94bgIHrGywGeDTb?=
 =?us-ascii?Q?s/ASCrq1Xz33Clerey+65p0dK8tjGZWIa94ax0S4pjlya7n3aL9udXrOxD0Q?=
 =?us-ascii?Q?baU5fCcHqlku3TqWnT1klTj1RKmtFqXZ5njgt1hihKjEcdF2DfjvKlWFwxvZ?=
 =?us-ascii?Q?NQ=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 631a5be3-786a-479a-5f9e-08da66ad7886
X-MS-Exchange-CrossTenant-AuthSource: VI1PR03MB4973.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2022 22:00:46.4887
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SDindBxdFq0x4JMT7YkMAf5Pfxowg1nCl5pjbXdI5bxE4lqHeidrRM8yNoNtD4ZMctgiaSkENB9iqPcj7YFTLw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR03MB8598
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds support for rate adaptation for phys similar to the AQR107. We
assume that all phys using aqr107_read_status support rate adaptation.
However, it could be possible to determine support based on the firmware
revision if there are phys discovered which do not support rate adaptation.
However, as rate adaptation is advertised in the datasheets for these phys,
I suspect it is supported most boards.

Despite the name, the "config" registers are updated with the current rate
adaptation method (if any). Because they appear to be updated
automatically, I don't know if these registers can be used to disable rate
adaptation.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
---

Changes in v3:
- New

 drivers/net/phy/aquantia_main.c | 49 ++++++++++++++++++++++++++++++---
 1 file changed, 45 insertions(+), 4 deletions(-)

diff --git a/drivers/net/phy/aquantia_main.c b/drivers/net/phy/aquantia_main.c
index 0a2f8c4aa845..e2ddcf0a68fc 100644
--- a/drivers/net/phy/aquantia_main.c
+++ b/drivers/net/phy/aquantia_main.c
@@ -95,6 +95,17 @@
 #define VEND1_GLOBAL_FW_ID_MAJOR		GENMASK(15, 8)
 #define VEND1_GLOBAL_FW_ID_MINOR		GENMASK(7, 0)
 
+#define VEND1_GLOBAL_CFG_10M			0x0310
+#define VEND1_GLOBAL_CFG_100M			0x031b
+#define VEND1_GLOBAL_CFG_1G			0x031c
+#define VEND1_GLOBAL_CFG_2_5G			0x031d
+#define VEND1_GLOBAL_CFG_5G			0x031e
+#define VEND1_GLOBAL_CFG_10G			0x031f
+#define VEND1_GLOBAL_CFG_RATE_ADAPT		GENMASK(8, 7)
+#define VEND1_GLOBAL_CFG_RATE_ADAPT_NONE	0
+#define VEND1_GLOBAL_CFG_RATE_ADAPT_USX		1
+#define VEND1_GLOBAL_CFG_RATE_ADAPT_PAUSE	2
+
 #define VEND1_GLOBAL_RSVD_STAT1			0xc885
 #define VEND1_GLOBAL_RSVD_STAT1_FW_BUILD_ID	GENMASK(7, 4)
 #define VEND1_GLOBAL_RSVD_STAT1_PROV_ID		GENMASK(3, 0)
@@ -340,39 +351,56 @@ static int aqr_read_status(struct phy_device *phydev)
 static int aqr107_read_rate(struct phy_device *phydev)
 {
 	int val;
+	u32 config_reg;
 
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
+		phydev->rate_adaptation = RATE_ADAPT_PAUSE;
 	else
-		phydev->duplex = DUPLEX_HALF;
+		phydev->rate_adaptation = RATE_ADAPT_NONE;
 
 	return 0;
 }
@@ -613,6 +641,16 @@ static void aqr107_link_change_notify(struct phy_device *phydev)
 		phydev_info(phydev, "Aquantia 1000Base-T2 mode active\n");
 }
 
+static enum rate_adaptation
+aqr107_get_rate_adaptation(struct phy_device *phydev, phy_interface_t iface)
+{
+	if (iface == PHY_INTERFACE_MODE_10GBASER ||
+	    iface == PHY_INTERFACE_MODE_2500BASEX ||
+	    iface == PHY_INTERFACE_MODE_NA)
+		return RATE_ADAPT_PAUSE;
+	return RATE_ADAPT_NONE;
+}
+
 static int aqr107_suspend(struct phy_device *phydev)
 {
 	return phy_set_bits_mmd(phydev, MDIO_MMD_VEND1, MDIO_CTRL1,
@@ -674,6 +712,7 @@ static struct phy_driver aqr_driver[] = {
 	PHY_ID_MATCH_MODEL(PHY_ID_AQR107),
 	.name		= "Aquantia AQR107",
 	.probe		= aqr107_probe,
+	.get_rate_adaptation = aqr107_get_rate_adaptation,
 	.config_init	= aqr107_config_init,
 	.config_aneg    = aqr_config_aneg,
 	.config_intr	= aqr_config_intr,
@@ -692,6 +731,7 @@ static struct phy_driver aqr_driver[] = {
 	PHY_ID_MATCH_MODEL(PHY_ID_AQR115),
 	.name		= "Aquantia AQR115",
 	.probe		= aqr107_probe,
+	.get_rate_adaptation = aqr107_get_rate_adaptation,
 	.config_init	= aqr107_config_init,
 	.config_aneg    = aqr_config_aneg,
 	.config_intr	= aqr_config_intr,
@@ -710,6 +750,7 @@ static struct phy_driver aqr_driver[] = {
 	PHY_ID_MATCH_MODEL(PHY_ID_AQCS109),
 	.name		= "Aquantia AQCS109",
 	.probe		= aqr107_probe,
+	.get_rate_adaptation = aqr107_get_rate_adaptation,
 	.config_init	= aqcs109_config_init,
 	.config_aneg    = aqr_config_aneg,
 	.config_intr	= aqr_config_intr,
-- 
2.35.1.1320.gc452695387.dirty

