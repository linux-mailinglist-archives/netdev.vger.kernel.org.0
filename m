Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 061E35B6BD0
	for <lists+netdev@lfdr.de>; Tue, 13 Sep 2022 12:43:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231130AbiIMKnk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Sep 2022 06:43:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231626AbiIMKng (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Sep 2022 06:43:36 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4497A5E306
        for <netdev@vger.kernel.org>; Tue, 13 Sep 2022 03:43:34 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id f11so19363646lfa.6
        for <netdev@vger.kernel.org>; Tue, 13 Sep 2022 03:43:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=CJwKt806KlDMmbLXPqFo3IXy3dC96xism66KV4s8wBo=;
        b=TArcjbf2e8L6qmbJ1ZNXoBSmX3Xn7xmTofXt2PU4npCqsRyD0yZ8N20Ky/otxrd5MR
         /XK/OvK8z8EOLHSkzVCnGhQk0nZHVPuIpJoDN54CdXIz3OnePQRXoOif2ah6DZqY7k61
         8DoSjUTZgF/mdlm+KLMlyS7pHs/qLVV9A8U6ZUqN/EWZsm5i6yuLuXEokAr/hHMPC78/
         PCiVEI/8VbRi2Kke/yNUam2GxxrXe/qC7pzEcoKiVsjmvlvxmieWkB190UTLYyW3VPE1
         29kZ/SrWUM+ZsHlVyfVtTXvR5R/c7z0aeHeECoeTpQ8p7+K6rnhdaLtVWngR2R1+mkbN
         iVmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=CJwKt806KlDMmbLXPqFo3IXy3dC96xism66KV4s8wBo=;
        b=z8ZZ/545WTQLanuQhuIcQZGmbj7qgom35WaP6HlBXY9zpzgL3zCbCGgjfzeYT9JySc
         j74ec2IdKbqEuri5PMdbRDTj4949HXCwGb6I/2I6CQVK0zUW7eTvvpjQobTaV4D9Ngqd
         WK2NcJZVZe9TMPUlBnzRpgfonPAPU/JYtSyoa+W3NDtFeo+Z++rMIgntqiCstbUyrPMT
         9bjNKFYvh/yxEac0tkK/hEI81SD17ewN0W+isdssAoXo7ayrAvob2mYi1u3LA16gnB3b
         yqvB0Esj3W2N+LPbExbRKmuY9YDIZX3QUaElqZQs3bf6l5yMso+ge4zym2OpEO6rJI3H
         uwJA==
X-Gm-Message-State: ACgBeo2oR3YUfFzjj0T7W7TwEi2n5nvBPqHck6tmIAqAIV34hIooQdpt
        XpYwwInynQ5TzHiE3B/I0VKunIpXA7nzEuRp
X-Google-Smtp-Source: AA6agR70oBjWlaM0gtnWV7mHPwhQDf0DzVSs7mtcJwmuycMOt1cvtKsl/XdgRSjruPyLe+FsUSPN6w==
X-Received: by 2002:ac2:4e03:0:b0:485:74c4:97ce with SMTP id e3-20020ac24e03000000b0048574c497cemr9517300lfr.13.1663065812319;
        Tue, 13 Sep 2022 03:43:32 -0700 (PDT)
Received: from wse-c0089.westermo.com (h-98-128-229-160.NA.cust.bahnhof.se. [98.128.229.160])
        by smtp.gmail.com with ESMTPSA id i2-20020a2ea362000000b0026bf27c7056sm1018946ljn.67.2022.09.13.03.43.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Sep 2022 03:43:31 -0700 (PDT)
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
        Mattias Forsblad <mattias.forsblad@gmail.com>
Subject: [PATCH net-next v10 1/6] net: dsa: mv88e6xxx: Add RMU enable for select switches.
Date:   Tue, 13 Sep 2022 12:43:15 +0200
Message-Id: <20220913104320.471673-2-mattias.forsblad@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220913104320.471673-1-mattias.forsblad@gmail.com>
References: <20220913104320.471673-1-mattias.forsblad@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
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

