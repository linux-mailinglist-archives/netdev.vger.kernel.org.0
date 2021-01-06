Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F16992EBD77
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 13:08:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726233AbhAFMIK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 07:08:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725789AbhAFMII (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jan 2021 07:08:08 -0500
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5791DC061357;
        Wed,  6 Jan 2021 04:07:28 -0800 (PST)
Received: by mail-lf1-x129.google.com with SMTP id y19so5863954lfa.13;
        Wed, 06 Jan 2021 04:07:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GtNHX48dLzLiJrWj2DR02vrUENOgCoAb989+ddBBe9E=;
        b=qOFpGXjDFrKHM42zsRe443xJqek+x8NtHpKg3peKhPzCkBm0qRXC+3sHJ3OMXimWrs
         C20b1WOVIJn2m7PTmVTBKyo7U+5D49KnAUWhp7T5jbV1foB0k6DThBLu0uBdrSKsRRKW
         4lH0KGXOjLo6B5c2WpSoGfvSoA4iDQArotiQd8WqiLzEAXehoPDUJ+UNMikEtvgd//7P
         bXGy1sskOzaXLyQFIhHZYYYm2jkLXH3Q7VLFyauMTJy6j/usRrj2lbQYN2Khhh3JYOY3
         vM2F5s7auqbu4iGsSRnj7EZBiDSiUvSsbiHOmmUSh9x92N1ErwGuk8ArjDoLbL/Up/Qm
         3Xiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GtNHX48dLzLiJrWj2DR02vrUENOgCoAb989+ddBBe9E=;
        b=THaqRQ6w+Kr7K9UODgGjopXJmELvHywdm9ni0TqB61XXEM2JnUBRhiigSQl4EGVKp+
         wVPGf+HCn3wzjoDKWwFRRdpuVIDGy6iHBRakDBKdjr0gQ1v8i0eDV/PgPNS+DpisdNyA
         1yx97PTade8320QMI0TgKG4gM8V84n24Qn2/NDQQu+TMcfISqE/S2irQm+wdKrMkLvPt
         y7hzpClApGoMiPZu4bXjqoUUW3zI63OEQORvjhjXsuhFWtcSXMyErhpmV0QeSlfTnkpY
         mTuORJMNpgD8Hl8mVHBHSWPLlcdLAvT3iBBiDU7EKZCn34Oz91guzKvk3Jh4CKCWzmkV
         M/Yg==
X-Gm-Message-State: AOAM533AFF8vmR4j723mBG6f71al9awUVJBOeYM0zQp0p0x6Rb3Jz48e
        nxRkQJbZTgxAdPrh7ejyddU=
X-Google-Smtp-Source: ABdhPJwmBMGgdHbNd2QX2fe/LreM/10VZ39iBThHDMI2D1OUYS5Cjpi2XbO4qIpS9JHV45bX96Rr0w==
X-Received: by 2002:a05:6512:31d6:: with SMTP id j22mr1727091lfe.239.1609934846875;
        Wed, 06 Jan 2021 04:07:26 -0800 (PST)
Received: from localhost.lan (ip-194-187-74-233.konfederacka.maverick.com.pl. [194.187.74.233])
        by smtp.gmail.com with ESMTPSA id v5sm316096lfd.103.2021.01.06.04.07.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Jan 2021 04:07:26 -0800 (PST)
From:   =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, bcm-kernel-feedback-list@broadcom.com,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>
Subject: [PATCH net-next 3/3] net: dsa: bcm_sf2: support BCM4908's integrated switch
Date:   Wed,  6 Jan 2021 13:07:11 +0100
Message-Id: <20210106120711.630-3-zajec5@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210106120711.630-1-zajec5@gmail.com>
References: <20210106120711.630-1-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rafał Miłecki <rafal@milecki.pl>

BCM4908 family SoCs come with integrated Starfighter 2 switch. Its
registers layout it a mix of BCM7278 and BCM7445. It has 5 integrated
PHYs and 8 ports. It also supports RGMII and SerDes.

Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
---
 drivers/net/dsa/b53/b53_common.c | 14 +++++++++++++
 drivers/net/dsa/b53/b53_priv.h   |  1 +
 drivers/net/dsa/bcm_sf2.c        | 36 +++++++++++++++++++++++++++++---
 drivers/net/dsa/bcm_sf2_regs.h   |  1 +
 4 files changed, 49 insertions(+), 3 deletions(-)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index 288b5a5c3e0d..85dddd87bcfc 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -2459,6 +2459,20 @@ static const struct b53_chip_data b53_switch_chips[] = {
 		.jumbo_pm_reg = B53_JUMBO_PORT_MASK,
 		.jumbo_size_reg = B53_JUMBO_MAX_SIZE,
 	},
+	/* Starfighter 2 */
+	{
+		.chip_id = BCM4908_DEVICE_ID,
+		.dev_name = "BCM4908",
+		.vlans = 4096,
+		.enabled_ports = 0x1bf,
+		.arl_bins = 4,
+		.arl_buckets = 256,
+		.cpu_port = 8, /* TODO: ports 4, 5, 8 */
+		.vta_regs = B53_VTA_REGS,
+		.duplex_reg = B53_DUPLEX_STAT_GE,
+		.jumbo_pm_reg = B53_JUMBO_PORT_MASK,
+		.jumbo_size_reg = B53_JUMBO_MAX_SIZE,
+	},
 	{
 		.chip_id = BCM7445_DEVICE_ID,
 		.dev_name = "BCM7445",
diff --git a/drivers/net/dsa/b53/b53_priv.h b/drivers/net/dsa/b53/b53_priv.h
index 7c67409bb186..6d0c724763c7 100644
--- a/drivers/net/dsa/b53/b53_priv.h
+++ b/drivers/net/dsa/b53/b53_priv.h
@@ -64,6 +64,7 @@ struct b53_io_ops {
 #define B53_INVALID_LANE	0xff
 
 enum {
+	BCM4908_DEVICE_ID = 0x4908,
 	BCM5325_DEVICE_ID = 0x25,
 	BCM5365_DEVICE_ID = 0x65,
 	BCM5389_DEVICE_ID = 0x89,
diff --git a/drivers/net/dsa/bcm_sf2.c b/drivers/net/dsa/bcm_sf2.c
index 1e9a0adda2d6..afbdbe234518 100644
--- a/drivers/net/dsa/bcm_sf2.c
+++ b/drivers/net/dsa/bcm_sf2.c
@@ -105,7 +105,8 @@ static void bcm_sf2_imp_setup(struct dsa_switch *ds, int port)
 	b53_brcm_hdr_setup(ds, port);
 
 	if (port == 8) {
-		if (priv->type == BCM7445_DEVICE_ID)
+		if (priv->type == BCM4908_DEVICE_ID ||
+		    priv->type == BCM7445_DEVICE_ID)
 			offset = CORE_STS_OVERRIDE_IMP;
 		else
 			offset = CORE_STS_OVERRIDE_IMP2;
@@ -715,7 +716,8 @@ static void bcm_sf2_sw_mac_link_down(struct dsa_switch *ds, int port,
 	u32 reg, offset;
 
 	if (port != core_readl(priv, CORE_IMP0_PRT_ID)) {
-		if (priv->type == BCM7445_DEVICE_ID)
+		if (priv->type == BCM4908_DEVICE_ID ||
+		    priv->type == BCM7445_DEVICE_ID)
 			offset = CORE_STS_OVERRIDE_GMIIP_PORT(port);
 		else
 			offset = CORE_STS_OVERRIDE_GMIIP2_PORT(port);
@@ -742,7 +744,8 @@ static void bcm_sf2_sw_mac_link_up(struct dsa_switch *ds, int port,
 	bcm_sf2_sw_mac_link_set(ds, port, interface, true);
 
 	if (port != core_readl(priv, CORE_IMP0_PRT_ID)) {
-		if (priv->type == BCM7445_DEVICE_ID)
+		if (priv->type == BCM4908_DEVICE_ID ||
+		    priv->type == BCM7445_DEVICE_ID)
 			offset = CORE_STS_OVERRIDE_GMIIP_PORT(port);
 		else
 			offset = CORE_STS_OVERRIDE_GMIIP2_PORT(port);
@@ -1135,6 +1138,30 @@ struct bcm_sf2_of_data {
 	unsigned int num_cfp_rules;
 };
 
+static const u16 bcm_sf2_4908_reg_offsets[] = {
+	[REG_SWITCH_CNTRL]	= 0x00,
+	[REG_SWITCH_STATUS]	= 0x04,
+	[REG_DIR_DATA_WRITE]	= 0x08,
+	[REG_DIR_DATA_READ]	= 0x0c,
+	[REG_SWITCH_REVISION]	= 0x10,
+	[REG_PHY_REVISION]	= 0x14,
+	[REG_SPHY_CNTRL]	= 0x24,
+	[REG_CROSSBAR]		= 0xc8,
+	[REG_RGMII_0_CNTRL]	= 0xe0,
+	[REG_RGMII_1_CNTRL]	= 0xec,
+	[REG_RGMII_2_CNTRL]	= 0xf8,
+	[REG_LED_0_CNTRL]	= 0x40,
+	[REG_LED_1_CNTRL]	= 0x4c,
+	[REG_LED_2_CNTRL]	= 0x58,
+};
+
+static const struct bcm_sf2_of_data bcm_sf2_4908_data = {
+	.type		= BCM4908_DEVICE_ID,
+	.core_reg_align	= 0,
+	.reg_offsets	= bcm_sf2_4908_reg_offsets,
+	.num_cfp_rules	= 0,
+};
+
 /* Register offsets for the SWITCH_REG_* block */
 static const u16 bcm_sf2_7445_reg_offsets[] = {
 	[REG_SWITCH_CNTRL]	= 0x00,
@@ -1183,6 +1210,9 @@ static const struct bcm_sf2_of_data bcm_sf2_7278_data = {
 };
 
 static const struct of_device_id bcm_sf2_of_match[] = {
+	{ .compatible = "brcm,bcm4908-switch",
+	  .data = &bcm_sf2_4908_data
+	},
 	{ .compatible = "brcm,bcm7445-switch-v4.0",
 	  .data = &bcm_sf2_7445_data
 	},
diff --git a/drivers/net/dsa/bcm_sf2_regs.h b/drivers/net/dsa/bcm_sf2_regs.h
index d8a5e6269c0e..1d2d55c9f8aa 100644
--- a/drivers/net/dsa/bcm_sf2_regs.h
+++ b/drivers/net/dsa/bcm_sf2_regs.h
@@ -17,6 +17,7 @@ enum bcm_sf2_reg_offs {
 	REG_SWITCH_REVISION,
 	REG_PHY_REVISION,
 	REG_SPHY_CNTRL,
+	REG_CROSSBAR,
 	REG_RGMII_0_CNTRL,
 	REG_RGMII_1_CNTRL,
 	REG_RGMII_2_CNTRL,
-- 
2.26.2

