Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0A7D59817A
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 12:31:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244084AbiHRK34 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 06:29:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239816AbiHRK3u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 06:29:50 -0400
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ED016FA05
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 03:29:48 -0700 (PDT)
Received: by mail-lj1-x22d.google.com with SMTP id q16so711778ljp.7
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 03:29:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=eAHy0GgVxTHg1eUciceHmM/Hyp1NsAkVTFVZaJvQ9zY=;
        b=EePFQ4ppu84vqkjd7Tzzlqwgp7K+RPZHTJMHzKh6jWQHbJMdzUiTQrhB7PHRR8VT7v
         kxxMZJVtXHa6IRaF5jsDn6b5jXbTQI4y/QOLiyRzOi0WhxFyh/UbxBhcFkRllVPKjExD
         eOc5ikUIdZ4Iqa8Erao9Ck3L1bC1fVXf/KsnuqAJ43crez+yQJaXFVGs3Viy2m+w6C8C
         9ebrxnSE8qnBDW18lK0vcnW+xf54Hl+Agb3c+RApvf0M8z4wjOPUHNhfvqKN+DJJFiXG
         dlRpLJAkT4T1lceUUxvGw5mSRL6V2HLaZljjQ8Fabf0af4IukZWIJs9M4NFl24CXGlYO
         fGtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=eAHy0GgVxTHg1eUciceHmM/Hyp1NsAkVTFVZaJvQ9zY=;
        b=jp6VUVcLYMOBj2B2Ro7VdfYDCOaDqBpMR8fUsyORMXtNpNM9M5qBrkks8sg22obWr1
         FyFUC+98Xpt2KjZfk1AUp4LbuoE8s/Tgyq6AYMW8uRNl4rkitk3jITjkc6hTRPI+3ag5
         unwahv60hKbbREz1i1UCrNoDUbo1vucDb4xCQBDqK/SQfOsz1pwXgqGYAtMp6/6IGGJy
         2MbGS8MWDJiwbaNeMzdJm1LIzDR8KsI2X6S0r4o3CxhOz/f3D/AkJVuOAvDLVPVFAYD0
         sXRM2ZZGLd62qL8b+MVyimrZS03ReIWFbwSippz0ktd+lvy1tuoiRkBAhGC+XYMDeDAz
         BfJw==
X-Gm-Message-State: ACgBeo3KPXNo/w4wLrqRrSPRPVrF7DuimgguOevF77UXhrtUIEnRi6hD
        XvAkUe3JMnK3DwLx0GYrYXTKI9AgadqFIw==
X-Google-Smtp-Source: AA6agR4KOI0eQ5F1mJ6pidHUzTFHF/1ljDnwii/EleoMLuPiGTHBWCa3CPRKsRdAE9fC5yUqbTvEGQ==
X-Received: by 2002:a05:651c:1248:b0:261:7fe4:9a99 with SMTP id h8-20020a05651c124800b002617fe49a99mr682651ljh.223.1660818586675;
        Thu, 18 Aug 2022 03:29:46 -0700 (PDT)
Received: from wse-c0089.raspi.local (h-98-128-229-160.NA.cust.bahnhof.se. [98.128.229.160])
        by smtp.gmail.com with ESMTPSA id z10-20020a056512370a00b0048afa5daaf3sm171035lfr.123.2022.08.18.03.29.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Aug 2022 03:29:46 -0700 (PDT)
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
Subject: [RFC net-next PATCH 3/3] mv88e6xxx: rmon: Use RMU to collect rmon data.
Date:   Thu, 18 Aug 2022 12:29:24 +0200
Message-Id: <20220818102924.287719-4-mattias.forsblad@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220818102924.287719-1-mattias.forsblad@gmail.com>
References: <20220818102924.287719-1-mattias.forsblad@gmail.com>
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

If RMU is supported, use that interface to
collect rmon data.

Signed-off-by: Mattias Forsblad <mattias.forsblad@gmail.com>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 41 +++++++++++++++++++++++---------
 1 file changed, 30 insertions(+), 11 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 888c6e47dd16..344d6633ad6d 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -1226,16 +1226,29 @@ static int mv88e6xxx_stats_get_stats(struct mv88e6xxx_chip *chip, int port,
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
+			if (chip->rmu.ops->get_rmon && !(stat->type & STATS_TYPE_PORT)) {
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
@@ -1310,16 +1323,22 @@ static void mv88e6xxx_get_ethtool_stats(struct dsa_switch *ds, int port,
 	struct mv88e6xxx_chip *chip = ds->priv;
 	int ret;
 
-	mv88e6xxx_reg_lock(chip);
+	if (chip->rmu.ops && chip->rmu.ops->get_rmon) {
+		ret = chip->rmu.ops->get_rmon(chip, port, data);
+		if (ret == -ETIMEDOUT)
+			return;
+	} else {
 
-	ret = mv88e6xxx_stats_snapshot(chip, port);
-	mv88e6xxx_reg_unlock(chip);
+		mv88e6xxx_reg_lock(chip);
 
-	if (ret < 0)
-		return;
+		ret = mv88e6xxx_stats_snapshot(chip, port);
+		mv88e6xxx_reg_unlock(chip);
 
-	mv88e6xxx_get_stats(chip, port, data);
+		if (ret < 0)
+			return;
 
+		mv88e6xxx_get_stats(chip, port, data);
+	}
 }
 
 static int mv88e6xxx_get_regs_len(struct dsa_switch *ds, int port)
-- 
2.25.1

