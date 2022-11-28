Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 755EC63B295
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 20:55:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233266AbiK1Tz0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 14:55:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232908AbiK1TzY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 14:55:24 -0500
Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2077.outbound.protection.outlook.com [40.107.104.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B1B7205C6;
        Mon, 28 Nov 2022 11:55:21 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RAiKfKOYRqNPeySEGVbCu33DE3K3bKHrkvsg3lbCYyzR9kfvybxJJ7J6CSPa8Mv8p49Gi0360ZwUxuq9XYcvNssggvKeerqXXUNVQkcs9xTKZFn4PG9yBwATb6g2s3T6sz0VQRMpdlszsA4J2eEvz+Xvxi+5sV4Ux9wQbP0ipG24xq9++FRvXXBT2GGvA9IuF1iR4rvA7Zt0xPH/TASEN4tBopw/Jg/W/OY1iM3g114M9cR+wr9Yys7XxNa7J/6tzHItu7vynJkizNFXcoP8X5aJqHUjQDNuKJxl4KmfrDEdXnIzO1nRhsGHYPwMs/6WgYErmXlz9DXAHoYBf3SNsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5L37gLRUNy+4DYV+QAGu8WfoshKXJKlyp7itX/sEkRQ=;
 b=c+dVsoGXwGwqKhTQ7cyjS/CceKIoIZPeG7HI1STyt++LiMlPJfUYhAdTjjmKmnBVU1SaKW0FTisEm1p7jZaieg9VZ/8Nvmfa/R8Jnpni7UW+79NdQustk/2VXLqE/8VV1MYq7sIcEqDTIzBQtjZZPGLACtuiIO8N8CesANNmeZspWTwQIkeIofzDxzk8wGlDCA9PwqPaZO7AHuXCEkkMspePqVASBIivuemTf7I0eGPpHUR4wJk2KHBZMF8R9PQiRimFXtgN78j1ZqBzrQD2RHp2ywU1EFk06esFJVBcoXQHlhAG8xSZbF94+5puco1i3q2uKiHivvBeNx+Sl/IAdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5L37gLRUNy+4DYV+QAGu8WfoshKXJKlyp7itX/sEkRQ=;
 b=e7Tuh5iCuYKX5wgN2jmfYIEBMwtTaCUlbUtmL38p2T58kpJEl3lH+lm+yWdCj57Vf84iWtT4+4xJ6ZohTSUm44oIuccqarJdgXfUHRrqYc/7nweoGL7TAWJjaBPOCb2QAjRUwfyTKG9lDbzGkhTvJKkkLTwpw+3xvJNfBhPuHTtIDV1L6Myp6uODlbNDKPKssgYCVF/plZw+wRhRNH9xrEXnphesMI/uK62WfJv3RDlkfNDmvkHXwdvorf4UG/Lo59N8fpM9OOE4vWMqhFgHJluLREWl0dQ+FbUG53a0phKjcFJd+acQ5eVPQ07E9PQdfR+6NTyxcejU5P+qUmiIJg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from AS8PR03MB8832.eurprd03.prod.outlook.com (2603:10a6:20b:56e::11)
 by PR3PR03MB6364.eurprd03.prod.outlook.com (2603:10a6:102:73::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Mon, 28 Nov
 2022 19:55:18 +0000
Received: from AS8PR03MB8832.eurprd03.prod.outlook.com
 ([fe80::bad2:a53e:f389:6347]) by AS8PR03MB8832.eurprd03.prod.outlook.com
 ([fe80::bad2:a53e:f389:6347%4]) with mapi id 15.20.5857.023; Mon, 28 Nov 2022
 19:55:18 +0000
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
Subject: [PATCH net v2 2/2] phy: aquantia: Determine rate adaptation support from registers
Date:   Mon, 28 Nov 2022 14:54:09 -0500
Message-Id: <20221128195409.100873-2-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20221128195409.100873-1-sean.anderson@seco.com>
References: <20221128195409.100873-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BLAPR05CA0031.namprd05.prod.outlook.com
 (2603:10b6:208:335::12) To AS8PR03MB8832.eurprd03.prod.outlook.com
 (2603:10a6:20b:56e::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AS8PR03MB8832:EE_|PR3PR03MB6364:EE_
X-MS-Office365-Filtering-Correlation-Id: 45eed58c-8bc8-4c18-5447-08dad17a79d2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dpotk0nE97WWOSZmrcLP8TrRyqoQy6ozagJ3CjduP6Uw+k2Ct2T7SnChIt80NJtvNjI/eDlcw1y7PhVHmsWppL04OriNIW99KA2rVcWz6lU3+Z4RR4t7bXUiWGsrYgugUBcd8uBtuqaYDh2PbkXkiv2t6MNVmQlIwHKro8qDBs/KCFo5zfamwZ/7qFq1nl+XjdSrDdQUVJuGH9u+P5NNQmre/BsDt6gUgW7XNM9K3W3g/V/LSSI4QIVZrylNVRK91e79dFW7yQwnhPw12aFEYJy7KUvIie5Y91/4Oj5EhnCx1ZL6oEjcF+nB7JL7G9/jJytYf8sgiUdxha4seGMmLuQzvxiQq/XHc/5hv/pIrhQAmG4d8ti1LTGyMFK/V9yLf8YCYCuHfqMnAZmu+t6Z++hYdWUfMSB8arFcnMYb2L6+yiIkwDW2d3CKsRCl/4uXpCXWqxdcYyW8iWu8Gw0/2/mbtWOLynAlVJHjtpBhAJ3aRRFaTO4zQJXBH1OlcsU8FidcDaCRY+fymToazNqfe72TwqY5A0LCQATWUJ/NDm3SPQ6M2sPrVx8Gz1YwySXXANXTD2yapni/gQtcY1CHKBBQmzo8dXpvouUklk3qcg1LDxvt2bjGBi1AWIlbdaktooqkQGFnkhwpX5TUDdeUge1Br7FAxgljJKVRCPDERJBToai5t+vRdN88zmTTAhwo
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8PR03MB8832.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(39850400004)(136003)(346002)(396003)(366004)(451199015)(52116002)(478600001)(6486002)(83380400001)(2906002)(6666004)(107886003)(110136005)(38350700002)(38100700002)(7416002)(5660300002)(44832011)(36756003)(1076003)(8936002)(6506007)(41300700001)(2616005)(8676002)(4326008)(86362001)(66476007)(66946007)(66556008)(26005)(54906003)(6512007)(186003)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?t4KcndyrocRXugwVQ2WuizQ54YTfjG92wIgpvl39uKQ7pmmkLWm7dtTpjPUJ?=
 =?us-ascii?Q?gO+VNyIowDIHB/mImG5B1a3V8FE1LkEVu8Uf89xJYAb11zjBNW/BjcMsb7QU?=
 =?us-ascii?Q?Zf1GAr4OGOmb4xP6ZnjipkKii8yw65lN9xQcqTFKEu/BC8kNBTSczMEpg1g6?=
 =?us-ascii?Q?Dk+Urf9VeQQ2rverTo9qst/X73LLenjB/QMXbEybOA9TV4h5ilDtYCuBHDSc?=
 =?us-ascii?Q?D1lyKO2IA+VYr6aUTTfGgOopsYn+4sgF2w1KqJ4XO1CMhNywF1yutW/XDRKF?=
 =?us-ascii?Q?DbFpJ/xunMXe8J2T7/AsoIWqZ9R65nyBN/IgTbM5DLPO8ZjsTjltifbGy0gs?=
 =?us-ascii?Q?+KMNL4yeeps2wzUfqJkzvo1fHbwXmL3zue3Fiq/ici0Iazqm1HOHpvfc04Pj?=
 =?us-ascii?Q?oFqsbcN4D9qPLwOnbYHX/S6iWa6kNUn2vmjmdWnyBkTBj8z8hQqcEVpJCWGH?=
 =?us-ascii?Q?HoxC93BKR7YHHWyAmdbiC//AylXQ/oX8ihaJCgucSWZycnwsdB+dzMGYr7Qw?=
 =?us-ascii?Q?aLhrrUy2U/oF9WKVwmL7tg25XoVPlVYyWW0u6s+q+Y5E7MhF11KeZWMIBNZs?=
 =?us-ascii?Q?qaOgEpRVIZ9vzFuMI7NfxR14HT8Ja/FkOo94XHNkRx2p9EHs5yCGhumSDowK?=
 =?us-ascii?Q?BLkdXAEbkWKa+YUZ5/q2BBrY4Er7Xl+RyjtfolRq+LAu9HeAYIRs141BdRNV?=
 =?us-ascii?Q?tdzWohwdhUaZCUuWy5Fswts5Prf4zd+ZxPjM+1KNS+YvkZv+rw2Xkmii9ZCN?=
 =?us-ascii?Q?p8lPVv9MgRudAwcwhAYwqipG/4xGz9UgnnAmxSIlYvwsurpmt1XvlcKOpccX?=
 =?us-ascii?Q?1sL5AI1Ah5bq0mI7AvW+x32qo1zHRvWckX+sP16KLssq4p6nk6sdYNetWV6t?=
 =?us-ascii?Q?rlD153DGW0O2cwzWRS2aLuveO/ZMeKjhAwUOcVOC5qLEO+GsLH2s0mEow28u?=
 =?us-ascii?Q?t9+nLJo/INO/HXTm7cTuQuk3yMXfbu4CPU1XKq5FuciJs53jQhpiwL/6VKQQ?=
 =?us-ascii?Q?peavPAjmmLLLMxLzZ/UsGsKUqbqFE6kGfXgblXHcARA82pk2AHSn8LKXNtrL?=
 =?us-ascii?Q?nAGdrm+lWX3t9MuvQ8t0cqv454oNXC17QCmQ+R0HuSBIp1tucoRY0ISwWwe6?=
 =?us-ascii?Q?ljU+YDQ2W0F0L2NDOOhHeOV3BlVTDA6wiNNEa36eq9f3tz26OooNccT/fTvm?=
 =?us-ascii?Q?81GGVYgEb3EezrU+w0CON9DacVNrCVFAdnzzM7jAZ700hWKOYtRvG8YfX47q?=
 =?us-ascii?Q?msjp247qStvntGXRlwXqXtahKKGc47NzGP0evcU75zt25SaDBk2Od6EegZEH?=
 =?us-ascii?Q?K84lrBZ01BUHu58M2bZtUMXQNSfG8eRtaOvO2iYv3Nc5T0WrhhUDBagA56vx?=
 =?us-ascii?Q?caswJMG9zs1Kg1KEHT8KTtVdF4on9v3VAP8e0YCuJQNY+dpzKVlTc1kMIFRQ?=
 =?us-ascii?Q?1o1+Dk/dTPUsIcJJMGYcsXugViCJJa7Uc5887ieCxomX2mn2kk+vCa2t9m18?=
 =?us-ascii?Q?52Fh01IBSAJrOHnROO2Y0NiePuvQwBnEEPQPxZojORKj8NYklyGBC0+tIKY3?=
 =?us-ascii?Q?H8AAY1yVzt/+eeBu8/bBgjwcxeZBRFIC2cnCcOl/7lvA02DHVvT97SNfcoke?=
 =?us-ascii?Q?Cg=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 45eed58c-8bc8-4c18-5447-08dad17a79d2
X-MS-Exchange-CrossTenant-AuthSource: AS8PR03MB8832.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Nov 2022 19:55:18.7327
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: m/FEnE30ww3AJXQlHj/JE6BecRO/KiOpZE3mTb1VKfkJDK+KBd1ekhU5u3ZzV9+Ebd84lo5bnUwF1MkmcoxGDg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR3PR03MB6364
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When autonegotiation completes, the phy interface will be set based on
the global config register for that speed. If the SERDES mode is set to
something which the MAC does not support, then the link will not come
up. To avoid this, validate each combination of interface speed and link
speed which might be configured. This way, we ensure that we only
consider rate adaptation in our advertisement when we can actually use
it.

The API for get_rate_matching requires that PHY_INTERFACE_MODE_NA be
handled properly. To do this, we adopt a structure similar to
phylink_validate. At the top-level, we either validate a particular
interface speed or all of them. Below that, we validate each combination
of serdes speed and link speed.

For some firmwares, not all speeds are supported. In this case, the
global config register for that speed will be initialized to zero
(indicating that rate adaptation is not supported). We can detect this
by reading the PMA/PMD speed register to determine which speeds are
supported. This register is read once in probe and cached for later.

Fixes: 3c42563b3041 ("net: phy: aquantia: Add support for rate matching")
Signed-off-by: Sean Anderson <sean.anderson@seco.com>
---
This commit should not get backported until it soaks in master for a
while.

The names for the bits in MDIO_SPEED are pretty ugly. IMO
they should all use the MDIO_PMA_SPEED_ prefix, but I think since they
are in uapi we are stuck with these names...

Changes in v2:
- Rework to just validate things instead of modifying registers

 drivers/net/phy/aquantia_main.c | 156 ++++++++++++++++++++++++++++++--
 1 file changed, 150 insertions(+), 6 deletions(-)

diff --git a/drivers/net/phy/aquantia_main.c b/drivers/net/phy/aquantia_main.c
index 47a76df36b74..998cdbb59ae3 100644
--- a/drivers/net/phy/aquantia_main.c
+++ b/drivers/net/phy/aquantia_main.c
@@ -109,6 +109,12 @@
 #define VEND1_GLOBAL_CFG_RATE_ADAPT_NONE	0
 #define VEND1_GLOBAL_CFG_RATE_ADAPT_USX		1
 #define VEND1_GLOBAL_CFG_RATE_ADAPT_PAUSE	2
+#define VEND1_GLOBAL_CFG_SERDES_MODE		GENMASK(2, 0)
+#define VEND1_GLOBAL_CFG_SERDES_MODE_XFI	0
+#define VEND1_GLOBAL_CFG_SERDES_MODE_SGMII	3
+#define VEND1_GLOBAL_CFG_SERDES_MODE_OCSGMII	4
+#define VEND1_GLOBAL_CFG_SERDES_MODE_XFI5G	6
+#define VEND1_GLOBAL_CFG_SERDES_MODE_XFI20G	7
 
 #define VEND1_GLOBAL_RSVD_STAT1			0xc885
 #define VEND1_GLOBAL_RSVD_STAT1_FW_BUILD_ID	GENMASK(7, 4)
@@ -173,6 +179,7 @@ static const struct aqr107_hw_stat aqr107_hw_stats[] = {
 
 struct aqr107_priv {
 	u64 sgmii_stats[AQR107_SGMII_STAT_SZ];
+	int supported_speeds;
 };
 
 static int aqr107_get_sset_count(struct phy_device *phydev)
@@ -675,13 +682,141 @@ static int aqr107_wait_processor_intensive_op(struct phy_device *phydev)
 	return 0;
 }
 
+/**
+ * aqr107_rate_adapt_ok_one() - Validate rate adaptation for one configuration
+ * @phydev: The phy to act on
+ * @serdes_speed: The speed of the serdes (aka the phy interface)
+ * @link_speed: The speed of the link
+ *
+ * This function validates whether rate adaptation will work for a particular
+ * combination of @serdes_speed and @link_speed.
+ *
+ * Return: %true if the global config register for @link_speed is configured for
+ * rate adaptation, %true if @link_speed will not be advertised, %false
+ * otherwise.
+ */
+static bool aqr107_rate_adapt_ok_one(struct phy_device *phydev, int serdes_speed,
+				     int link_speed)
+{
+	struct aqr107_priv *priv = phydev->priv;
+	int val, speed_bit;
+	u32 reg;
+
+	phydev_dbg(phydev, "validating link_speed=%d serdes_speed=%d\n",
+		   link_speed, serdes_speed);
+
+	switch (link_speed) {
+	case SPEED_10000:
+		reg = VEND1_GLOBAL_CFG_10G;
+		speed_bit = MDIO_SPEED_10G;
+		break;
+	case SPEED_5000:
+		reg = VEND1_GLOBAL_CFG_5G;
+		speed_bit = MDIO_PCS_SPEED_5G;
+		break;
+	case SPEED_2500:
+		reg = VEND1_GLOBAL_CFG_2_5G;
+		speed_bit = MDIO_PCS_SPEED_2_5G;
+		break;
+	case SPEED_1000:
+		reg = VEND1_GLOBAL_CFG_1G;
+		speed_bit = MDIO_PMA_SPEED_1000;
+		break;
+	case SPEED_100:
+		reg = VEND1_GLOBAL_CFG_100M;
+		speed_bit = MDIO_PMA_SPEED_100;
+		break;
+	case SPEED_10:
+		reg = VEND1_GLOBAL_CFG_10M;
+		speed_bit = MDIO_PMA_SPEED_10;
+		break;
+	default:
+		WARN_ON_ONCE(1);
+		return false;
+	}
+
+	/* Vacuously OK, since we won't advertise it anyway */
+	if (!(priv->supported_speeds & speed_bit))
+		return true;
+
+	val = phy_read_mmd(phydev, MDIO_MMD_VEND1, reg);
+	if (val < 0) {
+		phydev_warn(phydev, "could not read register %x:%.04x (err = %d)\n",
+			    MDIO_MMD_VEND1, reg, val);
+		return false;
+	}
+
+	phydev_dbg(phydev, "%x:%.04x = %.04x\n", MDIO_MMD_VEND1, reg, val);
+	if (FIELD_GET(VEND1_GLOBAL_CFG_RATE_ADAPT, val) !=
+		VEND1_GLOBAL_CFG_RATE_ADAPT_PAUSE)
+		return false;
+
+	switch (FIELD_GET(VEND1_GLOBAL_CFG_SERDES_MODE, val)) {
+	case VEND1_GLOBAL_CFG_SERDES_MODE_XFI20G:
+		return serdes_speed == SPEED_20000;
+	case VEND1_GLOBAL_CFG_SERDES_MODE_XFI:
+		return serdes_speed == SPEED_10000;
+	case VEND1_GLOBAL_CFG_SERDES_MODE_XFI5G:
+		return serdes_speed == SPEED_5000;
+	case VEND1_GLOBAL_CFG_SERDES_MODE_OCSGMII:
+		return serdes_speed == SPEED_2500;
+	case VEND1_GLOBAL_CFG_SERDES_MODE_SGMII:
+		return serdes_speed == SPEED_1000;
+	default:
+		return false;
+	}
+}
+
+/**
+ * aqr107_rate_adapt_ok() - Validate rate adaptation for an interface speed
+ * @phydev: The phy device
+ * @speed: The serdes (phy interface) speed
+ *
+ * This validates whether rate adaptation will work for a particular @speed.
+ * All link speeds less than or equal to @speed are validate to ensure they are
+ * configured properly.
+ *
+ * Return: %true if rate adaptation is supported for @speed, %false otherwise.
+ */
+static bool aqr107_rate_adapt_ok(struct phy_device *phydev, int speed)
+{
+	switch (speed) {
+	case SPEED_10000:
+		if (!aqr107_rate_adapt_ok_one(phydev, speed, SPEED_10000) ||
+		    !aqr107_rate_adapt_ok_one(phydev, speed, SPEED_5000))
+			return false;
+		fallthrough;
+	case SPEED_2500:
+		if (!aqr107_rate_adapt_ok_one(phydev, speed, SPEED_2500))
+			return false;
+		fallthrough;
+	case SPEED_1000:
+		if (!aqr107_rate_adapt_ok_one(phydev, speed, SPEED_1000) ||
+		    !aqr107_rate_adapt_ok_one(phydev, speed, SPEED_100) ||
+		    !aqr107_rate_adapt_ok_one(phydev, speed, SPEED_10))
+			return false;
+		return true;
+	default:
+		return false;
+	};
+}
+
 static int aqr107_get_rate_matching(struct phy_device *phydev,
 				    phy_interface_t iface)
 {
-	if (iface == PHY_INTERFACE_MODE_10GBASER ||
-	    iface == PHY_INTERFACE_MODE_2500BASEX ||
-	    iface == PHY_INTERFACE_MODE_NA)
+	if (iface != PHY_INTERFACE_MODE_NA) {
+		if (aqr107_rate_adapt_ok(phydev,
+					 phy_interface_max_speed(iface)))
+			return RATE_MATCH_PAUSE;
+		else
+			return RATE_MATCH_NONE;
+	}
+
+	if (aqr107_rate_adapt_ok(phydev, SPEED_10000) ||
+	    aqr107_rate_adapt_ok(phydev, SPEED_2500) ||
+	    aqr107_rate_adapt_ok(phydev, SPEED_1000))
 		return RATE_MATCH_PAUSE;
+
 	return RATE_MATCH_NONE;
 }
 
@@ -711,10 +846,19 @@ static int aqr107_resume(struct phy_device *phydev)
 
 static int aqr107_probe(struct phy_device *phydev)
 {
-	phydev->priv = devm_kzalloc(&phydev->mdio.dev,
-				    sizeof(struct aqr107_priv), GFP_KERNEL);
-	if (!phydev->priv)
+	struct aqr107_priv *priv;
+
+	priv = devm_kzalloc(&phydev->mdio.dev, sizeof(*priv), GFP_KERNEL);
+	if (!priv)
 		return -ENOMEM;
+	phydev->priv = priv;
+
+	priv->supported_speeds = phy_read_mmd(phydev, MDIO_MMD_PMAPMD,
+					      MDIO_SPEED);
+	if (priv->supported_speeds < 0) {
+		phydev_err(phydev, "could not determine supported speeds\n");
+		return priv->supported_speeds;
+	};
 
 	return aqr_hwmon_probe(phydev);
 }
-- 
2.35.1.1320.gc452695387.dirty

