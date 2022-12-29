Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B897658F33
	for <lists+netdev@lfdr.de>; Thu, 29 Dec 2022 17:44:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233810AbiL2QoX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Dec 2022 11:44:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233726AbiL2Qny (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Dec 2022 11:43:54 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBD4DA199;
        Thu, 29 Dec 2022 08:43:53 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id co23so17864609wrb.4;
        Thu, 29 Dec 2022 08:43:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jrqQ5aadtTFDZwC1mRGFpiDvvLuLZKkOGcKdL+4a/mA=;
        b=Iov0wQJpvLY/j0lFfzCTPyIlmWC39JWU5cgkIICccu9F4gYaVJ5eG3vNMMUBcL1bDv
         oytrHMlJWGlzA8tCHrbWbqhT8AmiNTDKWkyR/1lpK3/aV0djtOw3xNDHjLgt83i0Gjcb
         CSy0NGZWsQMyT08dNJvIYkT0yB2xsLZDOH79JyjV+E4RyaSELi1D087tlYC8/0XWCjHQ
         FQ3hteJEuIxCEyBcAtZY8YAMVzmi12kX6MV3gf1sPUC3djB6WiiDFWILmoPWJb5HekEA
         n1jVyQOM9aUh5nsUSdwBBNuocZ+VUBBWIrM2QInkWzXRROCk0c9rbPYvTNbwOKKVR0Dp
         72ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jrqQ5aadtTFDZwC1mRGFpiDvvLuLZKkOGcKdL+4a/mA=;
        b=7mB42A5Oktgtz6Zwweqjt/fw8g0Z5v55ZdMWyVzVTDsxPjctD1NxeCjmMNA+xbyZob
         qikZtQg3BOMwo9XJJS/GJKZEEk6BTbqJA8jelMJXNvMh/kn0tSpX0gmiYd9MGpw0leKU
         NZFOP1i95r0Gw+GI95FyLPr4iI80cPS6qXj9ntoPxAA4yrfIDDca79yYpD+vmsvRc4xR
         KR5YYSUbb2MVZjS/Z1DlmuNP9SCe8RMy3xRQrN/ox2SFDNjY1PwJ4sTqnSHCkK3+9hkU
         JVXhJTxgO5kS8ho3vvkmQ631hHhaaarST8wRW736WBDJuw/XMdjiezmY+j3aG38jhNNU
         XmBg==
X-Gm-Message-State: AFqh2krEUpsapzcG6rQm3VsCGLYSmMErpEXq0nAE4DZLNVUKheI4ZCOZ
        JuY9hY5aQloj75tAzZux88o=
X-Google-Smtp-Source: AMrXdXs0VKl1bl7hw5apjyEm7nwkQ51ocuMMgWBMkxIcHqjUyEg1KuMf3vG97yiA0aV7TCUWhZc1Dg==
X-Received: by 2002:a5d:55c7:0:b0:242:5f1f:9d3b with SMTP id i7-20020a5d55c7000000b002425f1f9d3bmr17685769wrw.16.1672332232083;
        Thu, 29 Dec 2022 08:43:52 -0800 (PST)
Received: from localhost.localdomain (host-82-55-238-56.retail.telecomitalia.it. [82.55.238.56])
        by smtp.googlemail.com with ESMTPSA id t18-20020a5d42d2000000b00288a3fd9248sm4326586wrr.91.2022.12.29.08.43.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Dec 2022 08:43:51 -0800 (PST)
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
Subject: [net PATCH v2 3/5] Revert "net: dsa: qca8k: cache lo and hi for mdio write"
Date:   Thu, 29 Dec 2022 17:33:34 +0100
Message-Id: <20221229163336.2487-4-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20221229163336.2487-1-ansuelsmth@gmail.com>
References: <20221229163336.2487-1-ansuelsmth@gmail.com>
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

What the Documentation actually intended was that it's possible to skip
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

