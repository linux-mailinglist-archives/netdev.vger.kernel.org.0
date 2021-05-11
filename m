Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D998379C7C
	for <lists+netdev@lfdr.de>; Tue, 11 May 2021 04:08:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231200AbhEKCIz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 May 2021 22:08:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230465AbhEKCId (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 May 2021 22:08:33 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1601C06175F;
        Mon, 10 May 2021 19:07:26 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id g65so10203128wmg.2;
        Mon, 10 May 2021 19:07:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=h4SZ7QJmv/HrbOtolTPG3AL+9UHJYBuUDPau4+rnOa8=;
        b=hYr322Z25JC3I331hnvdrRjI0Qr52IZNfK/4+3NbuNNQ2NkK9rQ/tD+Qlnd0GcuM76
         nJmQ/lx+6FmX8iiY9GxbloV33UverIRJLGhjDj0XhescNdSo04jm2+FYYUE+FEnuyFjx
         v139cSEPiyr85TgQ7T0lnLNEIizgG10TojcM1RT5oG9K3mFB2JPpDG9GamQpOaLRYX2U
         9gXe5N76eJqpNoYLLQ7bCIJMDq98WPYsw3uKOQlgLUyEoIMJhgENkPhCuk2eez5IxFRW
         EyEJ8SK3NaRI/IyJAVyat5Dn+UseKJ+CZWGRalaS0oLGKujaGXI838A7Z6ctlnfVoWyZ
         go3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=h4SZ7QJmv/HrbOtolTPG3AL+9UHJYBuUDPau4+rnOa8=;
        b=nPq7HWCSk+CgDNfGSw/g1GdL/1PTSagquolnHUYbXeRvjN0/8/kLqGqB9oCHFCo/Pj
         RHgzxEGemwy3N450CnjK+TMEPctPSAXFhtk+fxMXRNyoBnev9fliHdufUTJ10K9kIlLK
         bz8s+cWokiD4v2//IeOrrVO0+rmK4NUZXu71ljMIhu+nD4F8hv/CqUZHI3JJPxC41TSE
         ikiJutMrbtczAORLe9Y8V1C/RQPOSfvWGRzAcy2kYvb7XIDFnu6rhES97KPj/8nQ6yqO
         uvOzcaCxUrP81xrpZEG57g1cZoI4omJuA1/96FiJbjP83F5g88gbzT5n3v6Yp7bNHUQp
         DeCg==
X-Gm-Message-State: AOAM532hcEoH264An4sRZk93sf7wJJY1CJR3Qusyyw62yaBtYH8Y/Bsa
        sBs7iMgvs7R2gaCzAnj9JbI=
X-Google-Smtp-Source: ABdhPJzj4GfK4ByOnxvSaHgWWNVfyyJjhlecf7MUL9FQSpwz04f6daLN/PKi4nk05QAbgpHgnvr05Q==
X-Received: by 2002:a1c:c20a:: with SMTP id s10mr200567wmf.0.1620698845327;
        Mon, 10 May 2021 19:07:25 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-35-189-2.ip56.fastwebnet.it. [93.35.189.2])
        by smtp.googlemail.com with ESMTPSA id q20sm2607436wmq.2.2021.05.10.19.07.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 May 2021 19:07:24 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        netdev@vger.kernel.org (open list:NETWORKING DRIVERS),
        devicetree@vger.kernel.org (open list:OPEN FIRMWARE AND FLATTENED
        DEVICE TREE BINDINGS), linux-kernel@vger.kernel.org (open list)
Cc:     Ansuel Smith <ansuelsmth@gmail.com>
Subject: [RFC PATCH net-next v5 03/25] net: dsa: qca8k: improve qca8k read/write/rmw bus access
Date:   Tue, 11 May 2021 04:04:38 +0200
Message-Id: <20210511020500.17269-4-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210511020500.17269-1-ansuelsmth@gmail.com>
References: <20210511020500.17269-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Put bus in local variable to improve faster access to the mdio bus.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/dsa/qca8k.c | 29 ++++++++++++++++-------------
 1 file changed, 16 insertions(+), 13 deletions(-)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index 25fa7084e820..3c882d325fdf 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -142,17 +142,18 @@ qca8k_set_page(struct mii_bus *bus, u16 page)
 static u32
 qca8k_read(struct qca8k_priv *priv, u32 reg)
 {
+	struct mii_bus *bus = priv->bus;
 	u16 r1, r2, page;
 	u32 val;
 
 	qca8k_split_addr(reg, &r1, &r2, &page);
 
-	mutex_lock_nested(&priv->bus->mdio_lock, MDIO_MUTEX_NESTED);
+	mutex_lock_nested(&bus->mdio_lock, MDIO_MUTEX_NESTED);
 
-	qca8k_set_page(priv->bus, page);
-	val = qca8k_mii_read32(priv->bus, 0x10 | r2, r1);
+	qca8k_set_page(bus, page);
+	val = qca8k_mii_read32(bus, 0x10 | r2, r1);
 
-	mutex_unlock(&priv->bus->mdio_lock);
+	mutex_unlock(&bus->mdio_lock);
 
 	return val;
 }
@@ -160,35 +161,37 @@ qca8k_read(struct qca8k_priv *priv, u32 reg)
 static void
 qca8k_write(struct qca8k_priv *priv, u32 reg, u32 val)
 {
+	struct mii_bus *bus = priv->bus;
 	u16 r1, r2, page;
 
 	qca8k_split_addr(reg, &r1, &r2, &page);
 
-	mutex_lock_nested(&priv->bus->mdio_lock, MDIO_MUTEX_NESTED);
+	mutex_lock_nested(&bus->mdio_lock, MDIO_MUTEX_NESTED);
 
-	qca8k_set_page(priv->bus, page);
-	qca8k_mii_write32(priv->bus, 0x10 | r2, r1, val);
+	qca8k_set_page(bus, page);
+	qca8k_mii_write32(bus, 0x10 | r2, r1, val);
 
-	mutex_unlock(&priv->bus->mdio_lock);
+	mutex_unlock(&bus->mdio_lock);
 }
 
 static u32
 qca8k_rmw(struct qca8k_priv *priv, u32 reg, u32 mask, u32 val)
 {
+	struct mii_bus *bus = priv->bus;
 	u16 r1, r2, page;
 	u32 ret;
 
 	qca8k_split_addr(reg, &r1, &r2, &page);
 
-	mutex_lock_nested(&priv->bus->mdio_lock, MDIO_MUTEX_NESTED);
+	mutex_lock_nested(&bus->mdio_lock, MDIO_MUTEX_NESTED);
 
-	qca8k_set_page(priv->bus, page);
-	ret = qca8k_mii_read32(priv->bus, 0x10 | r2, r1);
+	qca8k_set_page(bus, page);
+	ret = qca8k_mii_read32(bus, 0x10 | r2, r1);
 	ret &= ~mask;
 	ret |= val;
-	qca8k_mii_write32(priv->bus, 0x10 | r2, r1, ret);
+	qca8k_mii_write32(bus, 0x10 | r2, r1, ret);
 
-	mutex_unlock(&priv->bus->mdio_lock);
+	mutex_unlock(&bus->mdio_lock);
 
 	return ret;
 }
-- 
2.30.2

