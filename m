Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E709A5A0C89
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 11:26:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233370AbiHYJ0q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 05:26:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239962AbiHYJ0n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 05:26:43 -0400
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A2726DAC5
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 02:26:41 -0700 (PDT)
Received: by mail-lj1-x231.google.com with SMTP id u24so13257926lji.0
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 02:26:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=RxV0nDEAfKqC3x7raaUN+mLOW4U9IZpu1YewQ98T9Tc=;
        b=ZhYOiBsIwUThLbwSJWXxJ6FoRPKj1W6h/5GEgoWpB2n+hQzL5kIpj0oRnzIjXSe3/C
         OtjcxEwukDFf6VzFa2OlmXfWFvi2s5xZRkP2XfTPOlY05U3T5q7luETEwe2nnDUBFrQe
         Y7tHaNH3mp024+GPv6ZrN+NCi1xlZ03yffz4/idMyw14ElWesvViaDVBJ4Ku3f37xSsM
         VTD+RbUIpmBOHwPdy6tHqa2hnFgM2IIRiHpDn4/FUEw3aKI2RVbVtNAdsMJGLftz4Y0d
         fRE9/ZHcAzg8yw3xAfO0rg7vVzg2R1iYK49Y6aYvK+4m9mD4jPur1ULt0zxlXC5Dh8gN
         5jlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=RxV0nDEAfKqC3x7raaUN+mLOW4U9IZpu1YewQ98T9Tc=;
        b=05ofqSL7+Gg2ev0lReswoROPBamA8mfRYxoe4KuXRDRvVGxdppSDdl5mfN89LmzZdM
         YS/asXY7pLDU6yktwP4G5uLlGE+ieRZIKaD5PRkmgPeH0S2cIoQqiqndbGVXtqCFQvpa
         doXaanKbPj43ckSXuZH0V1q9newQa/uUsDIxM9J/Lax+z8iB4+Kqf4bHq+748RaChVSv
         Fn0uqeHRDmB4qCMp+69o7Fpr7v18s0xVGifjfIkilkC9ZFezlQWG2QSxXPDhk2gn6Ww/
         WY07Pn5DAjT5k4VMgtfpgEftWID9p16hmkdTNNRJzG4kM72BXR2dptd7qDVO2TtHxwAe
         WCGg==
X-Gm-Message-State: ACgBeo0vxelmQw0YZ5YEg739P6wE8R8IrxTUmdRNflkuOw0tZMSuICO/
        R+ajE2bqQbMfi409L6+Rb8FgX6O1yo83nlgzchM=
X-Google-Smtp-Source: AA6agR6MbDM2fAhqpvqqDfFeVUi+SnMLj9pxO/FB81lvKyoidZIEEZcUoIqolLVn2DBU4ejvT7DUkg==
X-Received: by 2002:a2e:a98b:0:b0:25f:d9e9:588d with SMTP id x11-20020a2ea98b000000b0025fd9e9588dmr849924ljq.205.1661419599336;
        Thu, 25 Aug 2022 02:26:39 -0700 (PDT)
Received: from wse-c0089.raspi.local (h-98-128-229-160.NA.cust.bahnhof.se. [98.128.229.160])
        by smtp.gmail.com with ESMTPSA id p9-20020a2eba09000000b0025df5f38da8sm429740lja.119.2022.08.25.02.26.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Aug 2022 02:26:38 -0700 (PDT)
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
Subject: [PATCH net-next v1 3/3] rmon: Use RMU if available
Date:   Thu, 25 Aug 2022 11:26:29 +0200
Message-Id: <20220825092629.236131-4-mattias.forsblad@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220825092629.236131-1-mattias.forsblad@gmail.com>
References: <20220825092629.236131-1-mattias.forsblad@gmail.com>
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
 drivers/net/dsa/mv88e6xxx/chip.c | 41 ++++++++++++++++++++++++++------
 1 file changed, 34 insertions(+), 7 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 4c0510abd875..0d0241ace708 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -1226,16 +1226,30 @@ static int mv88e6xxx_stats_get_stats(struct mv88e6xxx_chip *chip, int port,
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
+			if (chip->rmu.ops && chip->rmu.ops->get_rmon &&
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
@@ -1304,8 +1318,8 @@ static void mv88e6xxx_get_stats(struct mv88e6xxx_chip *chip, int port,
 	mv88e6xxx_reg_unlock(chip);
 }
 
-static void mv88e6xxx_get_ethtool_stats(struct dsa_switch *ds, int port,
-					uint64_t *data)
+static void mv88e6xxx_get_ethtool_stats_mdio(struct dsa_switch *ds, int port,
+					     uint64_t *data)
 {
 	struct mv88e6xxx_chip *chip = ds->priv;
 	int ret;
@@ -1319,7 +1333,20 @@ static void mv88e6xxx_get_ethtool_stats(struct dsa_switch *ds, int port,
 		return;
 
 	mv88e6xxx_get_stats(chip, port, data);
+}
 
+static void mv88e6xxx_get_ethtool_stats(struct dsa_switch *ds, int port,
+					uint64_t *data)
+{
+	struct mv88e6xxx_chip *chip = ds->priv;
+
+	/* If initialization of RMU isn't available
+	 * fall back to MDIO access.
+	 */
+	if (chip->rmu.ops && chip->rmu.ops->get_rmon)
+		chip->rmu.ops->get_rmon(chip, port, data);
+	else
+		mv88e6xxx_get_ethtool_stats_mdio(ds, port, data);
 }
 
 static int mv88e6xxx_get_regs_len(struct dsa_switch *ds, int port)
-- 
2.25.1

