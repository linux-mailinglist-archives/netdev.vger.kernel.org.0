Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E7CA64EFB9
	for <lists+netdev@lfdr.de>; Fri, 16 Dec 2022 17:49:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231462AbiLPQtd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Dec 2022 11:49:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231381AbiLPQtL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Dec 2022 11:49:11 -0500
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-he1eur04on2082.outbound.protection.outlook.com [40.107.7.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86C1B2EF5F;
        Fri, 16 Dec 2022 08:49:09 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZPnzNEl/TN+cpzQnodWFhH6LLOv/jD6zl26RXu/80Xn8Y5LhtF8wVrO4DfVC1xXm1y4MIEK1QpnUUY+fPIwBwXhQT4bVmfjoY9l4/TO5sOBV2JpB2Tx5HS99Huc3FRaI63s6H5C/NmpFcH9AjdpwYd/g81fTkRljmsQcQCGcZS5KIzko02SmbjqJZR1te1uYUwggb8Fw7uySpIacV7SyXzDJt4laEV0dkY4VQfqj84cQslCTSQGj00uqLzCr2+4Q5ARtQxAkrvw7iM3vNTrEZmt+Ve9Kn9ljvEkVF/owTYhYTSmuXYKb+ilcSPLvIYvR3pjy1gRwbFzvsOlS7QFpWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gZ5+60YgTTFJLnItN5vGFfcUAmm1TcS4Ut+u2eL/CsI=;
 b=Niw6mKP14nX80odQiiv3MNrPsmBg+CPM55E0PEZ8IhRMzv2+eclmULPUf0qcXThzu7NZcKOB/ZGIkytmFA2IvcgwvwgDsCbladJpxS25rCZXA860cw0hxooYc70EpoWtQJBcnKhFSTVm2Si05Kuk4H1MMB9l+AsNCI7DLj1cgm5EG+d53k7mJhkOijYj8aZ12Qxw52pz4WrbaUuX7nNObOuJh9+v40xO17WKLWw36zAstVU0oRh4LWblcQ/9F3YVlne7+p2fYrhM49UoDfj5NIVBd84R+2lD8YwAmrj0UZcrVLCAgxp/fEy67LWQd1sB+3vTu+pELchMcVZAR/9yhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gZ5+60YgTTFJLnItN5vGFfcUAmm1TcS4Ut+u2eL/CsI=;
 b=XOnlE/68tvDWqyioU2wJMir2pRpBoxRfp2+NgeCB4qtsnRhXHe2pD4FES8EboqyF/L9IM7X4pJ+uw0/5lQBXgup9PXSP2nmtzz7y5XXZQclk2zs3VoFWL6bxZZ10wPFGzgOPMHC0oslB/YxwlWdh+J/XiGMZpVhzHOYeYSjxm5WEKWLaKcGK08zZctaNyLVIhHV0nuWguKbV4Vte97jx/wIe+O+hX7niwpjVn/7mC9H2oLnmaszwUvvScENrkVGLKH1xrgTqLi7RcPJyFzxInhgxkiHITsJwZbbYM6yK0sp5PA4MwpItipAb2tEmgXHC/E5rsVcsh6YkSgsR7xSLRg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB9PR03MB8847.eurprd03.prod.outlook.com (2603:10a6:10:3dd::13)
 by AM9PR03MB8010.eurprd03.prod.outlook.com (2603:10a6:20b:43d::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.12; Fri, 16 Dec
 2022 16:49:07 +0000
Received: from DB9PR03MB8847.eurprd03.prod.outlook.com
 ([fe80::2b95:1fe4:5d8f:22fb]) by DB9PR03MB8847.eurprd03.prod.outlook.com
 ([fe80::2b95:1fe4:5d8f:22fb%6]) with mapi id 15.20.5880.019; Fri, 16 Dec 2022
 16:49:07 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>
Cc:     Paolo Abeni <pabeni@redhat.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        linux-kernel@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Tim Harvey <tharvey@gateworks.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Sean Anderson <sean.anderson@seco.com>
Subject: [PATCH net-next v4 4/4] phy: aquantia: Determine rate adaptation support from registers
Date:   Fri, 16 Dec 2022 11:48:51 -0500
Message-Id: <20221216164851.2932043-5-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20221216164851.2932043-1-sean.anderson@seco.com>
References: <20221216164851.2932043-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0150.namprd13.prod.outlook.com
 (2603:10b6:208:2bb::35) To DB9PR03MB8847.eurprd03.prod.outlook.com
 (2603:10a6:10:3dd::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB9PR03MB8847:EE_|AM9PR03MB8010:EE_
X-MS-Office365-Filtering-Correlation-Id: b61168b7-905d-4538-bdee-08dadf85729c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eUJ11rGXli+5gJ0E8P7pU9T0TJ2zh+ybscoAu5ak9ET2DF64X9TyrMBCPjrCHeNuIqwTtr4QajVImgBnj8Pkj1LSMQha2m0bIBE5gHzuHgKCO5Oxp7iTntNXVx2Tx6NheXuut2uqQLoEKCpIFJLRJswgeXvY9qe9aOwqek7/i3LI+nXFhx1Po3htk6G5Ks2imStZwTQ88vuCfeZ7T04T16PUKSW+2Vqke26xXf6QFMJaPdA3Z/LpMMBDXmPuaaBR4J7ram7aWNS3Y97IkmGxVHXnnoeaP7l3vJaFyGr1H38NDhtRR1UywXyFtLfgPBJmStyynOHzV3Tw+gTr/XHYUdtI9ocNl9YI4feTvvwkV+W/fgEcHTOWurms/frdrsQaGu2qqTEgABH4ddZ/SrxvO26PAhP+eh45RYZGcu8wKeADu4FvqIw0Wwf/kNgEtd+T12bfFV/tvBqmG7p/5LbLDpKBuNeERwLWe7nbg3XTzWaVVa7dbIPo0aXo5DOPFVNeVHuAEMW018gDIRQVdcP9umcXql7VOIFcKT8SmwY4HzewKDDwaw571pb4KaqXDIkc+n1VjsegyRXHB4Mz2eyMsvb20SgLqeEoNOhOvJutnZREH81oAEyEqq9CNJLIQAPD4RO+4KgC1Ok1uDYG24jbTPEk8BkyaJjWbBdYbaWXn3IVaS7ixUrP0wozIBRzCFYq+oQRiNf6idDI0B3e+4UvgQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR03MB8847.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(396003)(366004)(346002)(376002)(39850400004)(451199015)(2616005)(1076003)(86362001)(83380400001)(36756003)(38350700002)(44832011)(38100700002)(316002)(41300700001)(2906002)(8936002)(66476007)(66556008)(66946007)(4326008)(5660300002)(8676002)(7416002)(186003)(52116002)(478600001)(107886003)(26005)(6486002)(6512007)(54906003)(6506007)(6666004)(110136005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5NYYKhjHKs+azNVznnb12M2DXzznY3CS9Z9oqjiByUAr+A7pD6TmjqkPBnPU?=
 =?us-ascii?Q?I/wYhZMc2lu0prQePtA3p2jIiFIT7WVNa2luHXOTmfxbVCVt03xWXTGdsiMQ?=
 =?us-ascii?Q?NkMHXw0heJpiZZU3CjEBw6Yd+eJaaPsT7AQBVgp2y4DuTJOQpZINZHD0XfsB?=
 =?us-ascii?Q?ILDlbvnFVFy1+ngmC7ZeC4AoctvyHLiLQfeDA90cCXZ0NPE4zpuuaeUYU217?=
 =?us-ascii?Q?6yrMeXzzAbsd7pYzxtpJjuGoDrzzi7qCnYki04WXgAEGUG7Qc4QthyliXfmh?=
 =?us-ascii?Q?ps1Nr43DbVp45DniCBHbpYvFAD4fbIlmwkTzb/1O94OYWfg1gP82TWq/KH6U?=
 =?us-ascii?Q?CC65l/aSvZMjgRmgAKqsuhbETc1Iqv9xu7Up72yoZPaSs93E3lOzWvyQbQvY?=
 =?us-ascii?Q?o0vdolo3zbJrWWA+4D/+IGdsx+3d0W+dt2jGzxmTrYqhfiP2l+oJBd/5du6E?=
 =?us-ascii?Q?AYspjwWgYNPVMdfDaqnDMIeebX9fSaCrF8M6zkcWUPvD2unxxM4YSsSRDlr4?=
 =?us-ascii?Q?nhx2siwQIvc1GnplNxJ4+ti/5akRzyUiVyW3Q25uJeBFbjzX2lFa4hWA0WTm?=
 =?us-ascii?Q?IgnmkV0V7kDOl+qdy0wcsaZY5QpbOZ06zntyy9WwU/i8kDmF13pCWyK7F7Sx?=
 =?us-ascii?Q?NywkcQ0V5s85QEErhf1d87trE8qmTQYOhg0duavgdJV0sVVecu7/Gjzwnbw5?=
 =?us-ascii?Q?7aY6766SBjgWM+R8L25i6hZFvZv8xE8FOEZznC3MG53zZRyQO+NqVHyP3DDP?=
 =?us-ascii?Q?YmOEUX/NbFX3RXw4HkD4kuWsdSDZwSaKZarETkVaJ7wdqdae4M8yqkyqx1L9?=
 =?us-ascii?Q?Prqp3KuZm1fzfRBz8KdgLvYecqLqpl0h7djpCiL0t+uHxuqW8BYkafhmuHyg?=
 =?us-ascii?Q?3TV13AXNaIWbLUxkTWiW83B/hkX73dOHfye+MIrx5X5cPMxau+WaOAcRFbaw?=
 =?us-ascii?Q?KSORsn13hNnM1krGZlYpqF92ifxrhK5P4v+VKQaZckzTpeRt5hFPpm0c8hGd?=
 =?us-ascii?Q?VaMBEHtiybfm8StHjcXReEKm0pLJrYzWLc+HFQkHj/vS16LdEKjFf+fkrTLd?=
 =?us-ascii?Q?JGjMBAeNjNIvM+h0gjnUT7KzMu4JgjCO/H8KVNZXiH0ndxs+Q29bjXiWiBBK?=
 =?us-ascii?Q?YHSpldVZFcDLacyqB7EyhWbUWV8q6whIXFAzapy0YlzO4PzQmVWEyP1EWsl7?=
 =?us-ascii?Q?WCWUrzw+6hLWqA0CUOAMrATbunA1weOrmwMmGTT7UaAMW5kE+kR11i0kIMXn?=
 =?us-ascii?Q?ORWG1w2tcxNd+uVgsmBO9nubX+6JSHkVds7p7EZtSKyY3XnfCxbhoNeum/kF?=
 =?us-ascii?Q?C46GtP+mBfuPkgY5EyOqJmw8KfYTrlXTZdcl39ywya4Z/LeJ0pjN5UZcgQ5+?=
 =?us-ascii?Q?zX+aLoNKpdvlq1VPvLE/hY22yybL458h7FJQnWmrLqQbGSJn6yaDzc2oZGJ8?=
 =?us-ascii?Q?YgTKMifhyZnboEOIgFalvKFkDxVHrv5AY8TN0lcRIzAwfO7Wa7mZyVG8mME5?=
 =?us-ascii?Q?3zv+175FGFXSebaMuBTjRsWgGQaxOVvoC6YktlfegOh+DHXW7tWpIkD5N7DA?=
 =?us-ascii?Q?UsmJR1sdi+xEl4ZWEPxSgb3R1rAhAG3UYSLdRb6bueIbTC4BoSXyrk1FKT5O?=
 =?us-ascii?Q?2Q=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b61168b7-905d-4538-bdee-08dadf85729c
X-MS-Exchange-CrossTenant-AuthSource: DB9PR03MB8847.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Dec 2022 16:49:07.4739
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HQIK7Cu1ltHix0woKR7hgKJEKmAb4c9ERPbT4aEBT9FhH6v4QsPwTP8pmvK6EuoNRMNofAwpA3AaXc4/d6WdRw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR03MB8010
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
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

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
---
This commit fixes 3c42563b3041 ("net: phy: aquantia: Add support for
rate matching"). In an effort to avoid backporting of this commit until
it has soaked in master for a while, the fixes tag has been left off.

Changes in v4:
- Fix kerneldoc using - instead of : for parameters

Changes in v3:
- Fix incorrect bits for PMA/PMD speed

Changes in v2:
- Rework to just validate things instead of modifying registers

 drivers/net/phy/aquantia_main.c | 160 ++++++++++++++++++++++++++++++--
 1 file changed, 154 insertions(+), 6 deletions(-)

diff --git a/drivers/net/phy/aquantia_main.c b/drivers/net/phy/aquantia_main.c
index 334a6904ca5a..e942b99be823 100644
--- a/drivers/net/phy/aquantia_main.c
+++ b/drivers/net/phy/aquantia_main.c
@@ -111,6 +111,12 @@
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
@@ -175,6 +181,7 @@ static const struct aqr107_hw_stat aqr107_hw_stats[] = {
 
 struct aqr107_priv {
 	u64 sgmii_stats[AQR107_SGMII_STAT_SZ];
+	int pmapmd_speeds;
 };
 
 static int aqr107_get_sset_count(struct phy_device *phydev)
@@ -677,13 +684,146 @@ static int aqr107_wait_processor_intensive_op(struct phy_device *phydev)
 	return 0;
 }
 
+/**
+ * struct aqr107_link_speed_cfg - Common configuration for link speeds
+ * @speed: The speed of this config
+ * @reg: The global system configuration register for this speed
+ * @speed_bit: The bit in the PMA/PMD speed ability register which determines
+ *             whether this link speed is supported
+ */
+struct aqr107_link_speed_cfg {
+	int speed;
+	u16 reg, speed_bit;
+};
+
+/**
+ * aqr107_rate_adapt_ok_one() - Validate rate adaptation for one configuration
+ * @phydev: The phy to act on
+ * @serdes_speed: The speed of the serdes (aka the phy interface)
+ * @link_cfg: The config for the link speed
+ *
+ * This function validates whether rate adaptation will work for a particular
+ * combination of @serdes_speed and @link_cfg.
+ *
+ * Return: %true if the @link_cfg.reg is configured for rate adaptation, %true
+ *         if @link_cfg.speed will not be advertised, %false otherwise.
+ */
+static bool aqr107_rate_adapt_ok_one(struct phy_device *phydev, int serdes_speed,
+				     const struct aqr107_link_speed_cfg *link_cfg)
+{
+	struct aqr107_priv *priv = phydev->priv;
+	int val;
+
+	phydev_dbg(phydev, "validating link_speed=%d serdes_speed=%d\n",
+		   link_cfg->speed, serdes_speed);
+
+	/* Vacuously OK, since we won't advertise it anyway */
+	if (!(priv->pmapmd_speeds & link_cfg->speed_bit))
+		return true;
+
+	val = phy_read_mmd(phydev, MDIO_MMD_VEND1, link_cfg->reg);
+	if (val < 0) {
+		phydev_warn(phydev, "could not read register %x:%.04x (err = %d)\n",
+			    MDIO_MMD_VEND1, link_cfg->reg, val);
+		return false;
+	}
+
+	phydev_dbg(phydev, "%x:%.04x = %.04x\n", MDIO_MMD_VEND1, link_cfg->reg, val);
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
+	static const struct aqr107_link_speed_cfg speed_table[] = {
+		{
+			.speed = SPEED_10,
+			.reg = VEND1_GLOBAL_CFG_10M,
+			.speed_bit = MDIO_PMA_SPEED_10,
+		},
+		{
+			.speed = SPEED_100,
+			.reg = VEND1_GLOBAL_CFG_100M,
+			.speed_bit = MDIO_PMA_SPEED_100,
+		},
+		{
+			.speed = SPEED_1000,
+			.reg = VEND1_GLOBAL_CFG_1G,
+			.speed_bit = MDIO_PMA_SPEED_1000,
+		},
+		{
+			.speed = SPEED_2500,
+			.reg = VEND1_GLOBAL_CFG_2_5G,
+			.speed_bit = MDIO_PMA_SPEED_2_5G,
+		},
+		{
+			.speed = SPEED_5000,
+			.reg = VEND1_GLOBAL_CFG_5G,
+			.speed_bit = MDIO_PMA_SPEED_5G,
+		},
+		{
+			.speed = SPEED_10000,
+			.reg = VEND1_GLOBAL_CFG_10G,
+			.speed_bit = MDIO_PMA_SPEED_10G,
+		},
+	};
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(speed_table) &&
+		    speed_table[i].speed <= speed; i++)
+		if (!aqr107_rate_adapt_ok_one(phydev, speed, &speed_table[i]))
+			return false;
+
+	/* Must match at least one speed */
+	if (i == ARRAY_SIZE(speed_table) && speed != speed_table[i].speed)
+		return false;
+
+	return true;
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
 
@@ -713,10 +853,18 @@ static int aqr107_resume(struct phy_device *phydev)
 
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
+	priv->pmapmd_speeds = phy_read_mmd(phydev, MDIO_MMD_PMAPMD, MDIO_SPEED);
+	if (priv->pmapmd_speeds < 0) {
+		phydev_err(phydev, "could not read PMA/PMD speeds\n");
+		return priv->pmapmd_speeds;
+	};
 
 	return aqr_hwmon_probe(phydev);
 }
-- 
2.35.1.1320.gc452695387.dirty

