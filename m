Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5DBC5BAD3C
	for <lists+netdev@lfdr.de>; Fri, 16 Sep 2022 14:19:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231518AbiIPMTD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Sep 2022 08:19:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231514AbiIPMSh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Sep 2022 08:18:37 -0400
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E9F9B1B8C
        for <netdev@vger.kernel.org>; Fri, 16 Sep 2022 05:18:31 -0700 (PDT)
Received: by mail-lj1-x232.google.com with SMTP id z20so25792590ljq.3
        for <netdev@vger.kernel.org>; Fri, 16 Sep 2022 05:18:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=7+LlQBUZ7/OEf/6g4JDT2otZBXDp71d8tOJsxf3Wqmc=;
        b=FymrDNb5dvAIRZUuoEVu6Nfb6fNR/hck0hm53L0L7QCFPPrvWhX5tbt2tUMaG7KOtA
         pgc6HQki6Ug9oFD1qNt6ZD4wFUqkh7yhTmtgceJg8xPLJfc+pqq5ZqY6PXQQS4xYRu5G
         T7mRcM/biwCj1RSfhOBS3A2qwn0JDHH6nZwoX9w2BhjIuqjdEh2NDOfaet6Qmuub/aOZ
         MQdrPLMjA32fy1k59zp6OT5VTnvVlYyhpTep/YLnwpPNTdh8BARMVX+FaOU2bkxTyte3
         qWwd/B6fcy+EMvhsA73owPsRCx00c2ACqzlKi693bo9IKAElYtjpmAsmVsmlBsEjdtGK
         66Qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=7+LlQBUZ7/OEf/6g4JDT2otZBXDp71d8tOJsxf3Wqmc=;
        b=j2P71s2jU5NQxzNQweBaWL8SZo4ZOvoRWxcw+KJ6DyyDEwxS0vFFfA98fnvhHK6c0S
         tjXxwKTCdPnNPQr/VH89nUGQ9tNdfK0Othz3UFWsCizNIA9lpjLZ0bvbpl4gMWRRXpj7
         Ki7sQ26T9QBu/dFaM8V9ldWF4WSr9gN9jwZEdbu52pAUankseuB850HSjmN9vfG6d6M5
         FtRFnM7pDWywOQhH+e3zvyoCn5kP1O5P1e6EZBW+Pd4zNsB0ugnblZ7ZlCkWWSviLyKE
         j6YWANcOiuDpWSAIBScUsJtCpjstza8T5WZ1aEdev5Cw9oxjHTafDYuDH7mWgNmV4i/S
         czXQ==
X-Gm-Message-State: ACrzQf1g4uoQyLmptRWo/NMGM/olP9ojEo2JIdQW0dEec7pqdmIzaLSs
        FlCK4CjdJzB+aKHwJ2KW5YXs8cyaNj23tCU27T8=
X-Google-Smtp-Source: AMsMyM4gQmstsvYx0YGR3SsRDlGSAoanE8jL6WinpEmL1foirLoX4FAvBrfPYMf2FcvJBpYMZi4qBw==
X-Received: by 2002:a05:651c:158f:b0:26b:dd9c:dca5 with SMTP id h15-20020a05651c158f00b0026bdd9cdca5mr1393304ljq.400.1663330709265;
        Fri, 16 Sep 2022 05:18:29 -0700 (PDT)
Received: from wse-c0089.westermo.com (h-98-128-229-160.NA.cust.bahnhof.se. [98.128.229.160])
        by smtp.gmail.com with ESMTPSA id h6-20020a0565123c8600b0049f5358062dsm313824lfv.98.2022.09.16.05.18.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Sep 2022 05:18:28 -0700 (PDT)
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
Subject: [PATCH net-next v13 5/6] net: dsa: mv88e6xxx: rmon: Use RMU for reading RMON data
Date:   Fri, 16 Sep 2022 14:18:16 +0200
Message-Id: <20220916121817.4061532-6-mattias.forsblad@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220916121817.4061532-1-mattias.forsblad@gmail.com>
References: <20220916121817.4061532-1-mattias.forsblad@gmail.com>
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

Use the Remote Management Unit for efficiently accessing
the RMON data.

Signed-off-by: Mattias Forsblad <mattias.forsblad@gmail.com>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 12 +++++++++---
 drivers/net/dsa/mv88e6xxx/chip.h |  2 ++
 drivers/net/dsa/mv88e6xxx/smi.c  |  3 +++
 3 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 28ed926d981f..344dc0dd6e7b 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -1383,10 +1383,9 @@ static void mv88e6xxx_get_stats(struct mv88e6xxx_chip *chip, int port,
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
@@ -1398,7 +1397,14 @@ static void mv88e6xxx_get_ethtool_stats(struct dsa_switch *ds, int port,
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
index 20db488f2dc8..f8f3c7d59350 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.h
+++ b/drivers/net/dsa/mv88e6xxx/chip.h
@@ -812,6 +812,8 @@ int mv88e6xxx_wait_bit(struct mv88e6xxx_chip *chip, int addr, int reg,
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

