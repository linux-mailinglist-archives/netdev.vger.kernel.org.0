Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 157BD64EED5
	for <lists+netdev@lfdr.de>; Fri, 16 Dec 2022 17:18:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232173AbiLPQR7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Dec 2022 11:17:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231869AbiLPQRz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Dec 2022 11:17:55 -0500
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AE6BDEED;
        Fri, 16 Dec 2022 08:17:54 -0800 (PST)
Received: by mail-wr1-x433.google.com with SMTP id i7so2990618wrv.8;
        Fri, 16 Dec 2022 08:17:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RkJKVUgt9KZftJMXu3IPRrd/BPLaQPA4lfamAmDQzlQ=;
        b=AK9QygFPw664p8EF3uhWnlPwjpUzVf4TDrYoH5xjrfvCbNbrSNdx5kzTv0T1BbcEEn
         j/PRTQ/xnnl22n6uttVGyvnvivcmqrcCVDr4UBk9NhwI1xLwndXG8ahep+qc5jdZmwlq
         YJnevGVZyq7OPmNrfc0fHuiyixORl6z2W7vrdAyx654IqDyMiSU8h5dK11bTc1E1sTYe
         q2NLXxXWvlGY5Of/5NU8d1jnT4HcNO4mctMy78+bljbdDXoD6y8iLuD7ogSRWAegTCpR
         ODa0bM8s4OydJ4SISwUpPL0I5drLTrY0fe6fVudnobLOGKezN/aB7ntDFTmoC+/9Klnc
         y7fQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RkJKVUgt9KZftJMXu3IPRrd/BPLaQPA4lfamAmDQzlQ=;
        b=EFGK2jNKQPAfisPXxYVzHvIT73U5RUz7lG7UkiTiuG0fgRaTMqCO9b/xQhZZ44v3Mu
         reAz0OEhJZJtwAwlgh8Fead8z7nEjcB162QMXxK/DLKPvraxJI47xp97JXbiaPNpcP5f
         NS8YlMsyqBjjwG8+8xoITDv8MB5tobAHNQEwurHfi2n6t8TmO5YnLo/lCDBZydqZOvBu
         JakYzLbWnCgYFkaMUuCfF/UkRgfJYKhB7ubgZouq0ahfMcDUh0Q+XL5/7zjWStbArsVE
         F+rd+b/TexUbF1d4qlxq+v5aZZzu6vWyaOTd67LpG6oqnLU/akHygl20E2RhyQf5AJZl
         X6bA==
X-Gm-Message-State: ANoB5pmHaf+7syUkX3i2VT2G+0i9oEqR3/UT6jsDmpJmKFjdTgU+fdmY
        15Q11vk7MySBxE3eyvjg8C8=
X-Google-Smtp-Source: AA0mqf5jir7amSR96F5aPkMyaBDWiBOV4T+CjezqdKAz2b41KXioCxUWUnB1aHbdnSo2arprO0Y4Eg==
X-Received: by 2002:adf:d84f:0:b0:242:219b:614 with SMTP id k15-20020adfd84f000000b00242219b0614mr19476258wrl.65.1671207472981;
        Fri, 16 Dec 2022 08:17:52 -0800 (PST)
Received: from localhost.localdomain (93-42-71-18.ip85.fastwebnet.it. [93.42.71.18])
        by smtp.googlemail.com with ESMTPSA id bj19-20020a0560001e1300b002238ea5750csm3079720wrb.72.2022.12.16.08.17.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Dec 2022 08:17:52 -0800 (PST)
From:   Christian Marangi <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Christian Marangi <ansuelsmth@gmail.com>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Ronald Wahl <ronald.wahl@raritan.com>, stable@vger.kernel.org
Subject: [net PATCH 3/5] Revert "net: dsa: qca8k: cache lo and hi for mdio write"
Date:   Fri, 16 Dec 2022 17:17:19 +0100
Message-Id: <20221216161721.23863-3-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20221216161721.23863-1-ansuelsmth@gmail.com>
References: <20221216161721.23863-1-ansuelsmth@gmail.com>
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

This reverts commit 2481d206fae7884cd07014fd1318e63af35e99eb.

The Documentation is very confusing about the topic.
The cache logic for hi and lo is wrong and actually miss some regs to be
actually written.

What the Docuemntation actually intended was that it's possible to skip
writing hi OR lo if half of the reg is not needed to be written or read.

Revert the change in favor of a better and correct implementation.

Reported-by: Ronald Wahl <ronald.wahl@raritan.com>
Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
Cc: stable@vger.kernel.org # v5.18+
---
 drivers/net/dsa/qca/qca8k-8xxx.c | 61 +++++++-------------------------
 drivers/net/dsa/qca/qca8k.h      |  5 ---
 2 files changed, 12 insertions(+), 54 deletions(-)

diff --git a/drivers/net/dsa/qca/qca8k-8xxx.c b/drivers/net/dsa/qca/qca8k-8xxx.c
index 46151320b2a8..fbcd5c2b13ae 100644
--- a/drivers/net/dsa/qca/qca8k-8xxx.c
+++ b/drivers/net/dsa/qca/qca8k-8xxx.c
@@ -36,44 +36,6 @@ qca8k_split_addr(u32 regaddr, u16 *r1, u16 *r2, u16 *page)
 	*page = regaddr & 0x3ff;
 }
 
-static int
-qca8k_set_lo(struct qca8k_priv *priv, int phy_id, u32 regnum, u16 lo)
-{
-	u16 *cached_lo = &priv->mdio_cache.lo;
-	struct mii_bus *bus = priv->bus;
-	int ret;
-
-	if (lo == *cached_lo)
-		return 0;
-
-	ret = bus->write(bus, phy_id, regnum, lo);
-	if (ret < 0)
-		dev_err_ratelimited(&bus->dev,
-				    "failed to write qca8k 32bit lo register\n");
-
-	*cached_lo = lo;
-	return 0;
-}
-
-static int
-qca8k_set_hi(struct qca8k_priv *priv, int phy_id, u32 regnum, u16 hi)
-{
-	u16 *cached_hi = &priv->mdio_cache.hi;
-	struct mii_bus *bus = priv->bus;
-	int ret;
-
-	if (hi == *cached_hi)
-		return 0;
-
-	ret = bus->write(bus, phy_id, regnum, hi);
-	if (ret < 0)
-		dev_err_ratelimited(&bus->dev,
-				    "failed to write qca8k 32bit hi register\n");
-
-	*cached_hi = hi;
-	return 0;
-}
-
 static int
 qca8k_mii_read32(struct mii_bus *bus, int phy_id, u32 regnum, u32 *val)
 {
@@ -97,7 +59,7 @@ qca8k_mii_read32(struct mii_bus *bus, int phy_id, u32 regnum, u32 *val)
 }
 
 static void
-qca8k_mii_write32(struct qca8k_priv *priv, int phy_id, u32 regnum, u32 val)
+qca8k_mii_write32(struct mii_bus *bus, int phy_id, u32 regnum, u32 val)
 {
 	u16 lo, hi;
 	int ret;
@@ -105,9 +67,12 @@ qca8k_mii_write32(struct qca8k_priv *priv, int phy_id, u32 regnum, u32 val)
 	lo = val & 0xffff;
 	hi = (u16)(val >> 16);
 
-	ret = qca8k_set_lo(priv, phy_id, regnum, lo);
+	ret = bus->write(bus, phy_id, regnum, lo);
 	if (ret >= 0)
-		ret = qca8k_set_hi(priv, phy_id, regnum + 1, hi);
+		ret = bus->write(bus, phy_id, regnum + 1, hi);
+	if (ret < 0)
+		dev_err_ratelimited(&bus->dev,
+				    "failed to write qca8k 32bit register\n");
 }
 
 static int
@@ -442,7 +407,7 @@ qca8k_regmap_write(void *ctx, uint32_t reg, uint32_t val)
 	if (ret < 0)
 		goto exit;
 
-	qca8k_mii_write32(priv, 0x10 | r2, r1, val);
+	qca8k_mii_write32(bus, 0x10 | r2, r1, val);
 
 exit:
 	mutex_unlock(&bus->mdio_lock);
@@ -475,7 +440,7 @@ qca8k_regmap_update_bits(void *ctx, uint32_t reg, uint32_t mask, uint32_t write_
 
 	val &= ~mask;
 	val |= write_val;
-	qca8k_mii_write32(priv, 0x10 | r2, r1, val);
+	qca8k_mii_write32(bus, 0x10 | r2, r1, val);
 
 exit:
 	mutex_unlock(&bus->mdio_lock);
@@ -750,14 +715,14 @@ qca8k_mdio_write(struct qca8k_priv *priv, int phy, int regnum, u16 data)
 	if (ret)
 		goto exit;
 
-	qca8k_mii_write32(priv, 0x10 | r2, r1, val);
+	qca8k_mii_write32(bus, 0x10 | r2, r1, val);
 
 	ret = qca8k_mdio_busy_wait(bus, QCA8K_MDIO_MASTER_CTRL,
 				   QCA8K_MDIO_MASTER_BUSY);
 
 exit:
 	/* even if the busy_wait timeouts try to clear the MASTER_EN */
-	qca8k_mii_write32(priv, 0x10 | r2, r1, 0);
+	qca8k_mii_write32(bus, 0x10 | r2, r1, 0);
 
 	mutex_unlock(&bus->mdio_lock);
 
@@ -787,7 +752,7 @@ qca8k_mdio_read(struct qca8k_priv *priv, int phy, int regnum)
 	if (ret)
 		goto exit;
 
-	qca8k_mii_write32(priv, 0x10 | r2, r1, val);
+	qca8k_mii_write32(bus, 0x10 | r2, r1, val);
 
 	ret = qca8k_mdio_busy_wait(bus, QCA8K_MDIO_MASTER_CTRL,
 				   QCA8K_MDIO_MASTER_BUSY);
@@ -798,7 +763,7 @@ qca8k_mdio_read(struct qca8k_priv *priv, int phy, int regnum)
 
 exit:
 	/* even if the busy_wait timeouts try to clear the MASTER_EN */
-	qca8k_mii_write32(priv, 0x10 | r2, r1, 0);
+	qca8k_mii_write32(bus, 0x10 | r2, r1, 0);
 
 	mutex_unlock(&bus->mdio_lock);
 
@@ -1968,8 +1933,6 @@ qca8k_sw_probe(struct mdio_device *mdiodev)
 	}
 
 	priv->mdio_cache.page = 0xffff;
-	priv->mdio_cache.lo = 0xffff;
-	priv->mdio_cache.hi = 0xffff;
 
 	/* Check the detected switch id */
 	ret = qca8k_read_switch_id(priv);
diff --git a/drivers/net/dsa/qca/qca8k.h b/drivers/net/dsa/qca/qca8k.h
index 0b7a5cb12321..03514f7a20be 100644
--- a/drivers/net/dsa/qca/qca8k.h
+++ b/drivers/net/dsa/qca/qca8k.h
@@ -375,11 +375,6 @@ struct qca8k_mdio_cache {
  * mdio writes
  */
 	u16 page;
-/* lo and hi can also be cached and from Documentation we can skip one
- * extra mdio write if lo or hi is didn't change.
- */
-	u16 lo;
-	u16 hi;
 };
 
 struct qca8k_pcs {
-- 
2.37.2

