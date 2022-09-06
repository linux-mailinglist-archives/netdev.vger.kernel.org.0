Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2A0C5ADFE1
	for <lists+netdev@lfdr.de>; Tue,  6 Sep 2022 08:35:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238554AbiIFGfW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 02:35:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238456AbiIFGfG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 02:35:06 -0400
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FCDC1C92F
        for <netdev@vger.kernel.org>; Mon,  5 Sep 2022 23:35:00 -0700 (PDT)
Received: by mail-lf1-x12c.google.com with SMTP id z29so15807314lfb.13
        for <netdev@vger.kernel.org>; Mon, 05 Sep 2022 23:35:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=LxrY8W4Dz89WPRlYtgGZD7N0n+0CsAyn/ajZNgWy40o=;
        b=TYDCja6DpRMCXlKb8HcN3JITXAaqbyi0Y5DDv39W/mzV0HZuzi4AuxL73Ogg0VCMfT
         b39g7qt5nHVQ0zWAnPIU7cumTkaGMPAD9KFNG4ZKJ/9zzp+sQE5xgWQcsppVAkmtb21M
         70OYta16SMLbxLgKAFdsSZQMsBCrjpE+7XhFDZh6KzVOzuepblENP7Bc3qv4y+Q+Mtjr
         KBB8EykNLGJAnGFGWKbGEAc78Okplj+QxID+1WQ3lkudH69JgX6WhjD3uOB5070/51ZK
         j4TYiz/GIGygdda2rovjAzkzABeNP2bbQekhG7jTNY0IoNZ2vjduROykA5XJVl1l/Imb
         +l+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=LxrY8W4Dz89WPRlYtgGZD7N0n+0CsAyn/ajZNgWy40o=;
        b=WVX0X9K/3KFNmJQ5jair7fgp0vW5Q+0fuL3WPijsPEgDvm74OCmOF4vXX95sAOFic4
         Fgz5AjVoCjNiIybRH+cYwUtdh+yEipmNS7H2NMtd0+iL0P2jVNAS4ES07O1GHJyvTsxf
         jUuNZrcdCqLcCukl/wmsGR1PYSHImBYxMfd6E4RUnoEvXCOt5GxxGDq5ul2LJ5I3+h2n
         deXdhfRwjxPeyXL2L6pRGsNynoJgAddv2dUwJR4UHL3v/8UVLjNpdYWJdrDUI3/PQrIT
         cO8CPDGMQNtRBOdh5GSKMRMZf7zk33oxbnPKjiCFZop4xGFKnspaNuql2EOpUceSHtgw
         UUsg==
X-Gm-Message-State: ACgBeo0BdoFhdZYF/NLpClUkC7b+YXvALlNHPTEV/DJpc7ci1yOL2nWH
        lX6nLzb00NxjgwfhW5PEBF8vFYkEXtPCQUnb
X-Google-Smtp-Source: AA6agR4Qr8mjVTb2CKAPk2+8Q7BCqeL6686h9803A+NPx825zsKGTk97KG6Ah4/SGJIscWCWPebvkQ==
X-Received: by 2002:a05:6512:6d5:b0:494:990f:a820 with SMTP id u21-20020a05651206d500b00494990fa820mr8629318lff.536.1662446098241;
        Mon, 05 Sep 2022 23:34:58 -0700 (PDT)
Received: from wse-c0089.raspi.local (h-98-128-229-160.NA.cust.bahnhof.se. [98.128.229.160])
        by smtp.gmail.com with ESMTPSA id z12-20020a2e8e8c000000b00261bf4e9f90sm1646924ljk.66.2022.09.05.23.34.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Sep 2022 23:34:57 -0700 (PDT)
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
Subject: [PATCH net-next v4 5/6] net: dsa: mv88e6xxx: rmon: Use RMU for reading RMON data
Date:   Tue,  6 Sep 2022 08:34:49 +0200
Message-Id: <20220906063450.3698671-6-mattias.forsblad@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220906063450.3698671-1-mattias.forsblad@gmail.com>
References: <20220906063450.3698671-1-mattias.forsblad@gmail.com>
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
 drivers/net/dsa/mv88e6xxx/chip.c | 39 ++++++++++++++++++++++++++------
 drivers/net/dsa/mv88e6xxx/chip.h |  2 ++
 2 files changed, 34 insertions(+), 7 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index bbdf229c9e71..f32048de68fc 100644
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
@@ -1312,8 +1326,8 @@ static void mv88e6xxx_get_stats(struct mv88e6xxx_chip *chip, int port,
 	mv88e6xxx_reg_unlock(chip);
 }
 
-static void mv88e6xxx_get_ethtool_stats(struct dsa_switch *ds, int port,
-					uint64_t *data)
+static void mv88e6xxx_get_ethtool_stats_mdio(struct dsa_switch *ds, int port,
+					     uint64_t *data)
 {
 	struct mv88e6xxx_chip *chip = ds->priv;
 	int ret;
@@ -1327,7 +1341,18 @@ static void mv88e6xxx_get_ethtool_stats(struct dsa_switch *ds, int port,
 		return;
 
 	mv88e6xxx_get_stats(chip, port, data);
+}
 
+static void mv88e6xxx_get_ethtool_stats(struct dsa_switch *ds, int port,
+					uint64_t *data)
+{
+	struct mv88e6xxx_chip *chip = ds->priv;
+
+	/* If RMU isn't available fall back to MDIO access. */
+	if (mv88e6xxx_rmu_available(chip))
+		chip->rmu.ops->get_rmon(chip, port, data);
+	else
+		mv88e6xxx_get_ethtool_stats_mdio(ds, port, data);
 }
 
 static int mv88e6xxx_get_regs_len(struct dsa_switch *ds, int port)
diff --git a/drivers/net/dsa/mv88e6xxx/chip.h b/drivers/net/dsa/mv88e6xxx/chip.h
index e81935a9573d..c7477b716473 100644
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
@@ -430,6 +431,7 @@ struct mv88e6xxx_bus_ops {
 	int (*read)(struct mv88e6xxx_chip *chip, int addr, int reg, u16 *val);
 	int (*write)(struct mv88e6xxx_chip *chip, int addr, int reg, u16 val);
 	int (*init)(struct mv88e6xxx_chip *chip);
+	int (*get_rmon)(struct mv88e6xxx_chip *chip, int port, uint64_t *data);
 };
 
 struct mv88e6xxx_mdio_bus {
-- 
2.25.1

