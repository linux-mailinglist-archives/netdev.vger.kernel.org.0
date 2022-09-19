Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 546595BCA4A
	for <lists+netdev@lfdr.de>; Mon, 19 Sep 2022 13:09:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230111AbiISLJK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 07:09:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230033AbiISLI7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 07:08:59 -0400
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA570E01B
        for <netdev@vger.kernel.org>; Mon, 19 Sep 2022 04:08:57 -0700 (PDT)
Received: by mail-lf1-x12b.google.com with SMTP id a2so22321197lfb.6
        for <netdev@vger.kernel.org>; Mon, 19 Sep 2022 04:08:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=xMPI3N4HEitsK3nKmRgxAWSFwBXRQJHlzN+CdBb5P4k=;
        b=XXAp1P4QBMZWYMBCo9RWJ7wsfwYpRXrAGG6IKnF7wdOydKUn8VbpgJfRapAf/cYiLA
         7jSKJyRBIppnj6/DAa5q63KnHfV1FhNcEpjgeGve34R6933/kyYgUE6GyUIcjzvhTbbI
         URZSbX+/05Go/rB8BgBtlXtVAwU5+01zoEycKvlkcO/DlLVrNuSlQ5iilv95UKidvppj
         uL6dev03ZK8+tGOPydeS9dBl0EKZVI5jIceV2twOrVdCfdTAi155Ea6HdeeFFiTMUgwQ
         gJxghHG2LoLIuwua7V9//EAXaAL7RLsSxv28fFu+UwILYelELVfVjeAgdoj27+ZQsnoZ
         JezQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=xMPI3N4HEitsK3nKmRgxAWSFwBXRQJHlzN+CdBb5P4k=;
        b=lnOfm62pKKfBzHYC1NlTIQPlXdIXrI4mXjoDmp6REGuDs/FarK2F4+M8pDNoUhVGut
         VGIfBFDRDjUoigvN1E29ztPAIby4Tf+/MSHkZmz1AuXhYxinMw4jwijv5JugvuKeXSuU
         F9UqN7DK0w+oqfmGzRp43RsNN/vQ7PBU/yZEqLXPRCN9DjbjZimFxTo6m6dcn2Q015RB
         hRHbyXAVj00qoiqsRK9aUCsHshmzOgyLtA+/7BsRplm+XPgEmUX/TgSBjlb+j3ADvVQw
         S14IVzmPNGmphcizntCfjA0FkgJE7ebPPm3s6DH4pWTd9yLXbaGRbkXaqME9HA/71lYe
         DzZA==
X-Gm-Message-State: ACrzQf2ma2z8o4vWtF3iQ0wdM5cY9uhl/XickGRUxkEHhRH2EskE5TMQ
        M9P9+NZm28EKLG8cWgjDkzUruOBwhtRVmg==
X-Google-Smtp-Source: AMsMyM6GaDKiyUTjEWrMKOGrxkjOmZgrMtbPeNA7Ffwhb8gQ4c9CBNAtGswETFmPVerUU3M/RWXMQA==
X-Received: by 2002:a05:6512:31d5:b0:498:f3dc:dd2 with SMTP id j21-20020a05651231d500b00498f3dc0dd2mr5628331lfe.101.1663585736017;
        Mon, 19 Sep 2022 04:08:56 -0700 (PDT)
Received: from wse-c0089.westermo.com (h-98-128-229-160.NA.cust.bahnhof.se. [98.128.229.160])
        by smtp.gmail.com with ESMTPSA id t13-20020a05651c204d00b00266d3f689e1sm4879261ljo.43.2022.09.19.04.08.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Sep 2022 04:08:55 -0700 (PDT)
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
Subject: [PATCH net-next v14 6/7] net: dsa: mv88e6xxx: rmon: Use RMU for reading RMON data
Date:   Mon, 19 Sep 2022 13:08:46 +0200
Message-Id: <20220919110847.744712-7-mattias.forsblad@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220919110847.744712-1-mattias.forsblad@gmail.com>
References: <20220919110847.744712-1-mattias.forsblad@gmail.com>
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

Redirect calls for collecting the RMON counters to RMU
instead of over legacy MDIO.

Signed-off-by: Mattias Forsblad <mattias.forsblad@gmail.com>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 12 +++++++++---
 drivers/net/dsa/mv88e6xxx/chip.h |  2 ++
 drivers/net/dsa/mv88e6xxx/smi.c  |  3 +++
 3 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 5b22fe4b3284..860896849785 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -1386,10 +1386,9 @@ static void mv88e6xxx_get_stats(struct mv88e6xxx_chip *chip, int port,
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
@@ -1401,7 +1400,14 @@ static void mv88e6xxx_get_ethtool_stats(struct dsa_switch *ds, int port,
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
index aca7cfef196e..7b692ba688f7 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.h
+++ b/drivers/net/dsa/mv88e6xxx/chip.h
@@ -811,6 +811,8 @@ int mv88e6xxx_wait_bit(struct mv88e6xxx_chip *chip, int addr, int reg,
 		       int bit, int val);
 struct mii_bus *mv88e6xxx_default_mdio_bus(struct mv88e6xxx_chip *chip);
 
+void mv88e6xxx_get_ethtool_stats_mdio(struct mv88e6xxx_chip *chip, int port,
+				      uint64_t *data);
 static inline void mv88e6xxx_reg_lock(struct mv88e6xxx_chip *chip)
 {
 	mutex_lock(&chip->reg_lock);
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

