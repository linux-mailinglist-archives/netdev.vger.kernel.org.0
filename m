Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEB7D5B1E99
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 15:21:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232271AbiIHNVf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 09:21:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232431AbiIHNVZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 09:21:25 -0400
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 236CDF5C6F
        for <netdev@vger.kernel.org>; Thu,  8 Sep 2022 06:21:19 -0700 (PDT)
Received: by mail-lj1-x231.google.com with SMTP id z20so19869651ljq.3
        for <netdev@vger.kernel.org>; Thu, 08 Sep 2022 06:21:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=OuZz8t9M3CfwTVq9eSXZjcE5bGKsKdRKLCmhNl2YNFo=;
        b=gAxYah5PtItYojhKjqFl7CjwPls35ZZCaIpJDax9k44LhTpV2vXsl4KECl3+FIhtAi
         umoMS0RtvTjXQRpBJENgRf/BH+GpyE4nuinKaUG4ldgCs9QWmEy6CxxfAzTwn4ZT8d6g
         aB84GlCy14ta8uACh0OM2Vx3jVukt/EDyTgBqwrF55C9niGBEIaOG1sN5E3Avap+ZHZ+
         ZDY5uQJ08K1Q7lPS8k3qgWFtrSHF3fnaapAlc29b1+XyiCLb7QUk8at09yeXBODQrSdG
         Ukm9mbY9Eikn1Hkl5sxVpCuTsK/hoE6cyFfkvQny9XwSW9tQF9Niy9242ms498o4gj+y
         Kr1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=OuZz8t9M3CfwTVq9eSXZjcE5bGKsKdRKLCmhNl2YNFo=;
        b=oSVsUHrM2f8afRUcMnJTWEJxG2v2+IM9xT3WzzvXZk9K5vm7VrgsuT8k94sazmQOlY
         Uo9FiQ0C6XBRF6vaxW/8+y+IhwuQhlnT71b7RruyA9Bguw7WAMKXlLPl5FSOetbS1aBi
         R3HAZXbLLgSmQwZ7lcVf+raIzK7TwV/2zErsyvs3sTAY3ejByF/JJqNgE0Jqzz6uybgQ
         m4r+2uhvUDyf1rh/Mw3JcAexkVGYodcxLL0/7iWmw/GHrJe9ijJUbuYtuUkC5voC5uVe
         LNDwbfu2gSVZCAiTC0t31vg4/04G8WycqCpmIsl1LC3ZTWyEkhHQvyd8bfKZyowC6/Ej
         LqDg==
X-Gm-Message-State: ACgBeo0hSSSHTkfLtHZ4u993f5jQClAbOuJZ41MGKo4VukLQaLvHkcpI
        1cGbqR8rPwQgLeH4fwz5xj8Sz6I4AWd1Z+Xk
X-Google-Smtp-Source: AA6agR5niJnLs2zs34VLS5ikUy2RInjYPhfZxd3AvaAwKMIjZCLXPITQ4fbHTVNFyiaKA/kt/8KkiQ==
X-Received: by 2002:a05:651c:158e:b0:26b:46a6:bf63 with SMTP id h14-20020a05651c158e00b0026b46a6bf63mr1078418ljq.21.1662643277099;
        Thu, 08 Sep 2022 06:21:17 -0700 (PDT)
Received: from wse-c0089.raspi.local (h-98-128-229-160.NA.cust.bahnhof.se. [98.128.229.160])
        by smtp.gmail.com with ESMTPSA id j6-20020a056512344600b00498f32ae907sm104837lfr.95.2022.09.08.06.21.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Sep 2022 06:21:16 -0700 (PDT)
From:   Mattias Forsblad <mattias.forsblad@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Mattias Forsblad <mattias.forsblad@gmail.com>
Subject: [PATCH net-next v7 5/6] net: dsa: mv88e6xxx: rmon: Use RMU for reading RMON data
Date:   Thu,  8 Sep 2022 15:21:08 +0200
Message-Id: <20220908132109.3213080-6-mattias.forsblad@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220908132109.3213080-1-mattias.forsblad@gmail.com>
References: <20220908132109.3213080-1-mattias.forsblad@gmail.com>
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

Use the Remote Management Unit for efficiently accessing
the RMON data.

Signed-off-by: Mattias Forsblad <mattias.forsblad@gmail.com>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 36 +++++++++++++++++++++++++-------
 drivers/net/dsa/mv88e6xxx/chip.h |  4 ++++
 drivers/net/dsa/mv88e6xxx/smi.c  |  3 +++
 3 files changed, 35 insertions(+), 8 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index bbdf229c9e71..bd16afa2e1a5 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -1234,16 +1234,30 @@ static int mv88e6xxx_stats_get_stats(struct mv88e6xxx_chip *chip, int port,
 				     u16 bank1_select, u16 histogram)
 {
 	struct mv88e6xxx_hw_stat *stat;
+	int offset = 0;
+	u64 high;
 	int i, j;
 
 	for (i = 0, j = 0; i < ARRAY_SIZE(mv88e6xxx_hw_stats); i++) {
 		stat = &mv88e6xxx_hw_stats[i];
 		if (stat->type & types) {
-			mv88e6xxx_reg_lock(chip);
-			data[j] = _mv88e6xxx_get_ethtool_stat(chip, stat, port,
-							      bank1_select,
-							      histogram);
-			mv88e6xxx_reg_unlock(chip);
+			if (mv88e6xxx_rmu_available(chip) &&
+			    !(stat->type & STATS_TYPE_PORT)) {
+				if (stat->type & STATS_TYPE_BANK1)
+					offset = 32;
+
+				data[j] = chip->ports[port].rmu_raw_stats[stat->reg + offset];
+				if (stat->size == 8) {
+					high = chip->ports[port].rmu_raw_stats[stat->reg + offset
+							+ 1];
+					data[j] += (high << 32);
+				}
+			} else {
+				mv88e6xxx_reg_lock(chip);
+				data[j] = _mv88e6xxx_get_ethtool_stat(chip, stat, port,
+								      bank1_select, histogram);
+				mv88e6xxx_reg_unlock(chip);
+			}
 
 			j++;
 		}
@@ -1312,10 +1326,9 @@ static void mv88e6xxx_get_stats(struct mv88e6xxx_chip *chip, int port,
 	mv88e6xxx_reg_unlock(chip);
 }
 
-static void mv88e6xxx_get_ethtool_stats(struct dsa_switch *ds, int port,
-					uint64_t *data)
+void mv88e6xxx_get_ethtool_stats_mdio(struct mv88e6xxx_chip *chip, int port,
+				      uint64_t *data)
 {
-	struct mv88e6xxx_chip *chip = ds->priv;
 	int ret;
 
 	mv88e6xxx_reg_lock(chip);
@@ -1327,7 +1340,14 @@ static void mv88e6xxx_get_ethtool_stats(struct dsa_switch *ds, int port,
 		return;
 
 	mv88e6xxx_get_stats(chip, port, data);
+}
+
+static void mv88e6xxx_get_ethtool_stats(struct dsa_switch *ds, int port,
+					uint64_t *data)
+{
+	struct mv88e6xxx_chip *chip = ds->priv;
 
+	chip->smi_ops->get_rmon(chip, port, data);
 }
 
 static int mv88e6xxx_get_regs_len(struct dsa_switch *ds, int port)
diff --git a/drivers/net/dsa/mv88e6xxx/chip.h b/drivers/net/dsa/mv88e6xxx/chip.h
index 566d18cf5170..5459037067e6 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.h
+++ b/drivers/net/dsa/mv88e6xxx/chip.h
@@ -266,6 +266,7 @@ struct mv88e6xxx_vlan {
 struct mv88e6xxx_port {
 	struct mv88e6xxx_chip *chip;
 	int port;
+	u64 rmu_raw_stats[64];
 	struct mv88e6xxx_vlan bridge_pvid;
 	u64 serdes_stats[2];
 	u64 atu_member_violation;
@@ -431,6 +432,7 @@ struct mv88e6xxx_bus_ops {
 	int (*read)(struct mv88e6xxx_chip *chip, int addr, int reg, u16 *val);
 	int (*write)(struct mv88e6xxx_chip *chip, int addr, int reg, u16 val);
 	int (*init)(struct mv88e6xxx_chip *chip);
+	void (*get_rmon)(struct mv88e6xxx_chip *chip, int port, uint64_t *data);
 };
 
 struct mv88e6xxx_mdio_bus {
@@ -807,6 +809,8 @@ int mv88e6xxx_wait_mask(struct mv88e6xxx_chip *chip, int addr, int reg,
 int mv88e6xxx_wait_bit(struct mv88e6xxx_chip *chip, int addr, int reg,
 		       int bit, int val);
 struct mii_bus *mv88e6xxx_default_mdio_bus(struct mv88e6xxx_chip *chip);
+void mv88e6xxx_get_ethtool_stats_mdio(struct mv88e6xxx_chip *chip, int port,
+				      uint64_t *data);
 
 static inline void mv88e6xxx_reg_lock(struct mv88e6xxx_chip *chip)
 {
diff --git a/drivers/net/dsa/mv88e6xxx/smi.c b/drivers/net/dsa/mv88e6xxx/smi.c
index a990271b7482..ae805c449b85 100644
--- a/drivers/net/dsa/mv88e6xxx/smi.c
+++ b/drivers/net/dsa/mv88e6xxx/smi.c
@@ -83,6 +83,7 @@ static int mv88e6xxx_smi_direct_wait(struct mv88e6xxx_chip *chip,
 static const struct mv88e6xxx_bus_ops mv88e6xxx_smi_direct_ops = {
 	.read = mv88e6xxx_smi_direct_read,
 	.write = mv88e6xxx_smi_direct_write,
+	.get_rmon = mv88e6xxx_get_ethtool_stats_mdio,
 };
 
 static int mv88e6xxx_smi_dual_direct_read(struct mv88e6xxx_chip *chip,
@@ -100,6 +101,7 @@ static int mv88e6xxx_smi_dual_direct_write(struct mv88e6xxx_chip *chip,
 static const struct mv88e6xxx_bus_ops mv88e6xxx_smi_dual_direct_ops = {
 	.read = mv88e6xxx_smi_dual_direct_read,
 	.write = mv88e6xxx_smi_dual_direct_write,
+	.get_rmon = mv88e6xxx_get_ethtool_stats_mdio,
 };
 
 /* Offset 0x00: SMI Command Register
@@ -166,6 +168,7 @@ static const struct mv88e6xxx_bus_ops mv88e6xxx_smi_indirect_ops = {
 	.read = mv88e6xxx_smi_indirect_read,
 	.write = mv88e6xxx_smi_indirect_write,
 	.init = mv88e6xxx_smi_indirect_init,
+	.get_rmon = mv88e6xxx_get_ethtool_stats_mdio,
 };
 
 int mv88e6xxx_smi_init(struct mv88e6xxx_chip *chip,
-- 
2.25.1

