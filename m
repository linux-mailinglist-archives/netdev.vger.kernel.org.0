Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B98D5B9D75
	for <lists+netdev@lfdr.de>; Thu, 15 Sep 2022 16:39:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230251AbiIOOi6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Sep 2022 10:38:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230370AbiIOOid (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Sep 2022 10:38:33 -0400
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 082159F748
        for <netdev@vger.kernel.org>; Thu, 15 Sep 2022 07:37:08 -0700 (PDT)
Received: by mail-lj1-x232.google.com with SMTP id 9so21550683ljr.2
        for <netdev@vger.kernel.org>; Thu, 15 Sep 2022 07:37:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=CJwKt806KlDMmbLXPqFo3IXy3dC96xism66KV4s8wBo=;
        b=XAmIpqvXIZB9DhsvX+3dP2wezezRSnjUEm9tUVldD2SW4e9HnBw3lL2tgoUiIFHPER
         4J0LLdFZAk8IaDCiD2uS9lGAdaHg/Jq+G0Fe5sfaiN2R1pOrZ0fYKqfUOc6adwToWYVz
         76BsTMh/L8Y9HkisW7TU2ahQTrOVsxtYICNM2VyYYNQDHo2cPQ6jwq3taT+he0QPAVph
         Htfq5qFKOLdC24nxLbZdrt1nQRfSbo8T8Q2fm2D66aP5qkwErNgYqY7PEn9yUWQ4+E5G
         zQx0CtWn+hDYidYTOLQAAHE30S3hntfgOB8CML7NlsCcpnx2ggVnm1Mvhk7Y7dnlgcDb
         tCdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=CJwKt806KlDMmbLXPqFo3IXy3dC96xism66KV4s8wBo=;
        b=1WsrU0c64QHrXamHztbfk+BiumbnTCEMdxboq2rYE51QvbcO+t6wBg33sNbxF++bZM
         I3CyCXvTzUXr+7UVf3LmtaSJy+IT7eV34dwaGQX2Prv2+sBAX2C9hus3+ehMN+wCLtqr
         ZodZiM4hohJhYedtUjpgYdlaoPwHPPuUxjgyZywNyygselUfdLSZr32ykK9oRhcRgL/t
         U83ki7wh32nB0wvmDuCG+pKPAnRRE0mvbqm/Zua+tyCk91AbTDaDLbaf6F/DnOKmFsIo
         FZlkMlvzUMsnF3jlS3uFzFV5k1Trxx/OQTY/Rk3sCXhtEq/K+ObqhSosY+jeBAUHae3X
         8Dtg==
X-Gm-Message-State: ACrzQf3w2Cd0D8JomGgrodoM0ZFofjQHxE+LSTnZRZENPzE4A0K3wW+Y
        vO5WJ7bkV6q2k/0AfSiwX08O0+ZREaLUlDQ6
X-Google-Smtp-Source: AMsMyM7edhihH0jc+FRTYH1jiZgrxAX5HjDEKIS/TGNpxZDan0TQxu5ez96yIHZ+BuZja7Pa4TxlyQ==
X-Received: by 2002:a2e:3212:0:b0:26c:1796:93ab with SMTP id y18-20020a2e3212000000b0026c179693abmr13813ljy.299.1663252625812;
        Thu, 15 Sep 2022 07:37:05 -0700 (PDT)
Received: from wse-c0089.raspi.local (h-98-128-229-160.NA.cust.bahnhof.se. [98.128.229.160])
        by smtp.gmail.com with ESMTPSA id x15-20020ac259cf000000b004984ab5956dsm2995794lfn.202.2022.09.15.07.37.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Sep 2022 07:37:05 -0700 (PDT)
From:   Mattias Forsblad <mattias.forsblad@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux@armlinux.org.uk,
        ansuelsmth@gmail.com, Mattias Forsblad <mattias.forsblad@gmail.com>
Subject: [PATCH net-next v12 1/6] net: dsa: mv88e6xxx: Add RMU enable for select switches.
Date:   Thu, 15 Sep 2022 16:36:53 +0200
Message-Id: <20220915143658.3377139-2-mattias.forsblad@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220915143658.3377139-1-mattias.forsblad@gmail.com>
References: <20220915143658.3377139-1-mattias.forsblad@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add RMU enable functionality for some Marvell SOHO switches.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Mattias Forsblad <mattias.forsblad@gmail.com>
---
 drivers/net/dsa/mv88e6xxx/chip.c    |  6 +++
 drivers/net/dsa/mv88e6xxx/chip.h    |  1 +
 drivers/net/dsa/mv88e6xxx/global1.c | 64 +++++++++++++++++++++++++++++
 drivers/net/dsa/mv88e6xxx/global1.h |  3 ++
 4 files changed, 74 insertions(+)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 6f4ea39ab466..46e12b53a9e4 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -4098,6 +4098,7 @@ static const struct mv88e6xxx_ops mv88e6085_ops = {
 	.ppu_disable = mv88e6185_g1_ppu_disable,
 	.reset = mv88e6185_g1_reset,
 	.rmu_disable = mv88e6085_g1_rmu_disable,
+	.rmu_enable = mv88e6085_g1_rmu_enable,
 	.vtu_getnext = mv88e6352_g1_vtu_getnext,
 	.vtu_loadpurge = mv88e6352_g1_vtu_loadpurge,
 	.stu_getnext = mv88e6352_g1_stu_getnext,
@@ -4181,6 +4182,7 @@ static const struct mv88e6xxx_ops mv88e6097_ops = {
 	.pot_clear = mv88e6xxx_g2_pot_clear,
 	.reset = mv88e6352_g1_reset,
 	.rmu_disable = mv88e6085_g1_rmu_disable,
+	.rmu_enable = mv88e6085_g1_rmu_enable,
 	.vtu_getnext = mv88e6352_g1_vtu_getnext,
 	.vtu_loadpurge = mv88e6352_g1_vtu_loadpurge,
 	.phylink_get_caps = mv88e6095_phylink_get_caps,
@@ -5300,6 +5302,7 @@ static const struct mv88e6xxx_ops mv88e6352_ops = {
 	.pot_clear = mv88e6xxx_g2_pot_clear,
 	.reset = mv88e6352_g1_reset,
 	.rmu_disable = mv88e6352_g1_rmu_disable,
+	.rmu_enable = mv88e6352_g1_rmu_enable,
 	.atu_get_hash = mv88e6165_g1_atu_get_hash,
 	.atu_set_hash = mv88e6165_g1_atu_set_hash,
 	.vtu_getnext = mv88e6352_g1_vtu_getnext,
@@ -5367,6 +5370,7 @@ static const struct mv88e6xxx_ops mv88e6390_ops = {
 	.pot_clear = mv88e6xxx_g2_pot_clear,
 	.reset = mv88e6352_g1_reset,
 	.rmu_disable = mv88e6390_g1_rmu_disable,
+	.rmu_enable = mv88e6390_g1_rmu_enable,
 	.atu_get_hash = mv88e6165_g1_atu_get_hash,
 	.atu_set_hash = mv88e6165_g1_atu_set_hash,
 	.vtu_getnext = mv88e6390_g1_vtu_getnext,
@@ -5434,6 +5438,7 @@ static const struct mv88e6xxx_ops mv88e6390x_ops = {
 	.pot_clear = mv88e6xxx_g2_pot_clear,
 	.reset = mv88e6352_g1_reset,
 	.rmu_disable = mv88e6390_g1_rmu_disable,
+	.rmu_enable = mv88e6390_g1_rmu_enable,
 	.atu_get_hash = mv88e6165_g1_atu_get_hash,
 	.atu_set_hash = mv88e6165_g1_atu_set_hash,
 	.vtu_getnext = mv88e6390_g1_vtu_getnext,
@@ -5504,6 +5509,7 @@ static const struct mv88e6xxx_ops mv88e6393x_ops = {
 	.pot_clear = mv88e6xxx_g2_pot_clear,
 	.reset = mv88e6352_g1_reset,
 	.rmu_disable = mv88e6390_g1_rmu_disable,
+	.rmu_enable = mv88e6390_g1_rmu_enable,
 	.atu_get_hash = mv88e6165_g1_atu_get_hash,
 	.atu_set_hash = mv88e6165_g1_atu_set_hash,
 	.vtu_getnext = mv88e6390_g1_vtu_getnext,
diff --git a/drivers/net/dsa/mv88e6xxx/chip.h b/drivers/net/dsa/mv88e6xxx/chip.h
index e693154cf803..7ce3c41f6caf 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.h
+++ b/drivers/net/dsa/mv88e6xxx/chip.h
@@ -637,6 +637,7 @@ struct mv88e6xxx_ops {
 
 	/* Remote Management Unit operations */
 	int (*rmu_disable)(struct mv88e6xxx_chip *chip);
+	int (*rmu_enable)(struct mv88e6xxx_chip *chip, int port);
 
 	/* Precision Time Protocol operations */
 	const struct mv88e6xxx_ptp_ops *ptp_ops;
diff --git a/drivers/net/dsa/mv88e6xxx/global1.c b/drivers/net/dsa/mv88e6xxx/global1.c
index 5848112036b0..1b3a3218c0b5 100644
--- a/drivers/net/dsa/mv88e6xxx/global1.c
+++ b/drivers/net/dsa/mv88e6xxx/global1.c
@@ -466,18 +466,82 @@ int mv88e6085_g1_rmu_disable(struct mv88e6xxx_chip *chip)
 				      MV88E6085_G1_CTL2_RM_ENABLE, 0);
 }
 
+int mv88e6085_g1_rmu_enable(struct mv88e6xxx_chip *chip, int port)
+{
+	int val = MV88E6352_G1_CTL2_RMU_MODE_DISABLED;
+
+	switch (port) {
+	case 9:
+		val = MV88E6085_G1_CTL2_RM_ENABLE;
+		break;
+	case 10:
+		val = MV88E6085_G1_CTL2_RM_ENABLE | MV88E6085_G1_CTL2_P10RM;
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	return mv88e6xxx_g1_ctl2_mask(chip, MV88E6085_G1_CTL2_P10RM |
+				      MV88E6085_G1_CTL2_RM_ENABLE, val);
+}
+
 int mv88e6352_g1_rmu_disable(struct mv88e6xxx_chip *chip)
 {
 	return mv88e6xxx_g1_ctl2_mask(chip, MV88E6352_G1_CTL2_RMU_MODE_MASK,
 				      MV88E6352_G1_CTL2_RMU_MODE_DISABLED);
 }
 
+int mv88e6352_g1_rmu_enable(struct mv88e6xxx_chip *chip, int port)
+{
+	int val = MV88E6352_G1_CTL2_RMU_MODE_DISABLED;
+
+	switch (port) {
+	case 4:
+		val = MV88E6352_G1_CTL2_RMU_MODE_PORT_4;
+		break;
+	case 5:
+		val = MV88E6352_G1_CTL2_RMU_MODE_PORT_5;
+		break;
+	case 6:
+		val = MV88E6352_G1_CTL2_RMU_MODE_PORT_6;
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	return mv88e6xxx_g1_ctl2_mask(chip, MV88E6352_G1_CTL2_RMU_MODE_MASK, val);
+}
+
 int mv88e6390_g1_rmu_disable(struct mv88e6xxx_chip *chip)
 {
 	return mv88e6xxx_g1_ctl2_mask(chip, MV88E6390_G1_CTL2_RMU_MODE_MASK,
 				      MV88E6390_G1_CTL2_RMU_MODE_DISABLED);
 }
 
+int mv88e6390_g1_rmu_enable(struct mv88e6xxx_chip *chip, int port)
+{
+	int val = MV88E6390_G1_CTL2_RMU_MODE_DISABLED;
+
+	switch (port) {
+	case 0:
+		val = MV88E6390_G1_CTL2_RMU_MODE_PORT_0;
+		break;
+	case 1:
+		val = MV88E6390_G1_CTL2_RMU_MODE_PORT_1;
+		break;
+	case 9:
+		val = MV88E6390_G1_CTL2_RMU_MODE_PORT_9;
+		break;
+	case 10:
+		val = MV88E6390_G1_CTL2_RMU_MODE_PORT_10;
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	return mv88e6xxx_g1_ctl2_mask(chip, MV88E6390_G1_CTL2_RMU_MODE_MASK, val);
+}
+
 int mv88e6390_g1_stats_set_histogram(struct mv88e6xxx_chip *chip)
 {
 	return mv88e6xxx_g1_ctl2_mask(chip, MV88E6390_G1_CTL2_HIST_MODE_MASK,
diff --git a/drivers/net/dsa/mv88e6xxx/global1.h b/drivers/net/dsa/mv88e6xxx/global1.h
index 65958b2a0d3a..b9aa66712037 100644
--- a/drivers/net/dsa/mv88e6xxx/global1.h
+++ b/drivers/net/dsa/mv88e6xxx/global1.h
@@ -313,8 +313,11 @@ int mv88e6250_g1_ieee_pri_map(struct mv88e6xxx_chip *chip);
 int mv88e6185_g1_set_cascade_port(struct mv88e6xxx_chip *chip, int port);
 
 int mv88e6085_g1_rmu_disable(struct mv88e6xxx_chip *chip);
+int mv88e6085_g1_rmu_enable(struct mv88e6xxx_chip *chip, int port);
 int mv88e6352_g1_rmu_disable(struct mv88e6xxx_chip *chip);
+int mv88e6352_g1_rmu_enable(struct mv88e6xxx_chip *chip, int port);
 int mv88e6390_g1_rmu_disable(struct mv88e6xxx_chip *chip);
+int mv88e6390_g1_rmu_enable(struct mv88e6xxx_chip *chip, int port);
 
 int mv88e6xxx_g1_set_device_number(struct mv88e6xxx_chip *chip, int index);
 
-- 
2.25.1

