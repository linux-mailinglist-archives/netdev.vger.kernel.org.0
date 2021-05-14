Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F37038125C
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 23:01:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233776AbhENVCi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 17:02:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232299AbhENVBv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 May 2021 17:01:51 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8652C061343;
        Fri, 14 May 2021 14:00:35 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id m12so596265eja.2;
        Fri, 14 May 2021 14:00:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JOALTuxE/kbgvTYa4pHz27R0kgkVrbKEA3LdLcLYyUU=;
        b=EqJH/rzHUj6w/aJQCzz/5ePdPXu34U2udWHJNAmcBifQ1Jt6ChXYvdu/BPKCeK0M6V
         HYhyDdVs8pa59K2V0zSy12tJhWPYSgM6A996GDU9MxUPCKuQvotuBNzerN9oOZOqavZN
         LV0io51DQCYk0MKrGyHNtLHwmgJwe/MO9c1lH06PZV4Y+f1Mf9NJzyPCDZZl45lpTT3X
         FH2maNDjAUYna3KL7jQtXKnZoin3OWFKEgsAZN5r1F7cdjwnB7c9tN3oT2d+ysawdjA1
         agz9ntCn/nH3sbUt573h0SBVCWwIvBtPmgCnFRfVcFocNctUwTG17J97RpWAFRb6o5VQ
         G9cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JOALTuxE/kbgvTYa4pHz27R0kgkVrbKEA3LdLcLYyUU=;
        b=tj+bx6GWjAIzca8QTcuFwYF7Hgy6VEzDJr0cnetzQKgW9KMOBbciZjaikdKD6aj4MC
         eYCttTtW+znEqhz2f8WNpclJgNes/xtth2Lo+HpcH6jsemZw7L5Dy9iVc3bGKUxsdx+t
         DtCmpot0+AAtSCZ7RTVxZpO56wpSP+ZzaP0EKG8ETxH1OQy+0kcyatLXgO/wgSAA9wNN
         DFH/d7Vli3UGw/ySbxqrcmU6gZd9SLu8xCTH3bKR+2s2KkLuhi30DaSI1GjMS4jBwW7Y
         ZnSMG+O5UbpgOqLP2ftc4ASOxqUYVUwM4BPGeyN0y0EDUEXvwaPwgKOl8nojOnSTkvV6
         2JfA==
X-Gm-Message-State: AOAM531l8dU7GhHCMve3kuQFF1jRaoqb2A3NJKqAvqFxWzyOdHrRkjmD
        1Sgx5W6TgglzBY9/KxTg98g=
X-Google-Smtp-Source: ABdhPJy3nhv0T3nADARr3dU2Ac/USskE7c+RglmfEVGE47IZiS7XRsLeM3WAg5VXbxaYvIf1M4M8Ng==
X-Received: by 2002:a17:907:7747:: with SMTP id kx7mr33969367ejc.400.1621026034382;
        Fri, 14 May 2021 14:00:34 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-35-189-2.ip56.fastwebnet.it. [93.35.189.2])
        by smtp.googlemail.com with ESMTPSA id c3sm5455237edn.16.2021.05.14.14.00.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 May 2021 14:00:34 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Ansuel Smith <ansuelsmth@gmail.com>
Subject: [PATCH net-next v6 18/25] net: dsa: qca8k: dsa: qca8k: protect MASTER busy_wait with mdio mutex
Date:   Fri, 14 May 2021 23:00:08 +0200
Message-Id: <20210514210015.18142-19-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210514210015.18142-1-ansuelsmth@gmail.com>
References: <20210514210015.18142-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

MDIO_MASTER operation have a dedicated busy wait that is not protected
by the mdio mutex. This can cause situation where the MASTER operation
is done and a normal operation is executed between the MASTER read/write
and the MASTER busy_wait. Rework the qca8k_mdio_read/write function to
address this issue by binding the lock for the whole MASTER operation
and not only the mdio read/write common operation.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/dsa/qca8k.c | 68 +++++++++++++++++++++++++++++++++--------
 1 file changed, 55 insertions(+), 13 deletions(-)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index a2b4d5097868..1f8bfe0a78f4 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -627,9 +627,32 @@ qca8k_port_to_phy(int port)
 	return port - 1;
 }
 
+static int
+qca8k_mdio_busy_wait(struct qca8k_priv *priv, u32 reg, u32 mask)
+{
+	u16 r1, r2, page;
+	u32 val;
+	int ret;
+
+	qca8k_split_addr(reg, &r1, &r2, &page);
+
+	ret = read_poll_timeout(qca8k_mii_read32, val, !(val & mask), 0,
+				QCA8K_BUSY_WAIT_TIMEOUT * USEC_PER_MSEC, false,
+				priv->bus, 0x10 | r2, r1);
+
+	/* Check if qca8k_read has failed for a different reason
+	 * before returnting -ETIMEDOUT
+	 */
+	if (ret < 0 && val < 0)
+		return val;
+
+	return ret;
+}
+
 static int
 qca8k_mdio_write(struct qca8k_priv *priv, int port, u32 regnum, u16 data)
 {
+	u16 r1, r2, page;
 	u32 phy, val;
 	int ret;
 
@@ -645,12 +668,21 @@ qca8k_mdio_write(struct qca8k_priv *priv, int port, u32 regnum, u16 data)
 	      QCA8K_MDIO_MASTER_REG_ADDR(regnum) |
 	      QCA8K_MDIO_MASTER_DATA(data);
 
-	ret = qca8k_write(priv, QCA8K_MDIO_MASTER_CTRL, val);
+	qca8k_split_addr(QCA8K_MDIO_MASTER_CTRL, &r1, &r2, &page);
+
+	mutex_lock_nested(&priv->bus->mdio_lock, MDIO_MUTEX_NESTED);
+
+	ret = qca8k_set_page(priv->bus, page);
 	if (ret)
-		return ret;
+		goto exit;
+
+	qca8k_mii_write32(priv->bus, 0x10 | r2, r1, val);
 
-	ret = qca8k_busy_wait(priv, QCA8K_MDIO_MASTER_CTRL,
-			      QCA8K_MDIO_MASTER_BUSY);
+	ret = qca8k_mdio_busy_wait(priv, QCA8K_MDIO_MASTER_CTRL,
+				   QCA8K_MDIO_MASTER_BUSY);
+
+exit:
+	mutex_unlock(&priv->bus->mdio_lock);
 
 	/* even if the busy_wait timeouts try to clear the MASTER_EN */
 	qca8k_reg_clear(priv, QCA8K_MDIO_MASTER_CTRL,
@@ -662,6 +694,7 @@ qca8k_mdio_write(struct qca8k_priv *priv, int port, u32 regnum, u16 data)
 static int
 qca8k_mdio_read(struct qca8k_priv *priv, int port, u32 regnum)
 {
+	u16 r1, r2, page;
 	u32 phy, val;
 	int ret;
 
@@ -676,21 +709,30 @@ qca8k_mdio_read(struct qca8k_priv *priv, int port, u32 regnum)
 	      QCA8K_MDIO_MASTER_READ | QCA8K_MDIO_MASTER_PHY_ADDR(phy) |
 	      QCA8K_MDIO_MASTER_REG_ADDR(regnum);
 
-	ret = qca8k_write(priv, QCA8K_MDIO_MASTER_CTRL, val);
-	if (ret)
-		return ret;
+	qca8k_split_addr(QCA8K_MDIO_MASTER_CTRL, &r1, &r2, &page);
 
-	ret = qca8k_busy_wait(priv, QCA8K_MDIO_MASTER_CTRL,
-			      QCA8K_MDIO_MASTER_BUSY);
+	mutex_lock_nested(&priv->bus->mdio_lock, MDIO_MUTEX_NESTED);
+
+	ret = qca8k_set_page(priv->bus, page);
 	if (ret)
-		return ret;
+		goto exit;
 
-	val = qca8k_read(priv, QCA8K_MDIO_MASTER_CTRL);
-	if (val < 0)
-		return val;
+	qca8k_mii_write32(priv->bus, 0x10 | r2, r1, val);
 
+	ret = qca8k_mdio_busy_wait(priv, QCA8K_MDIO_MASTER_CTRL,
+				   QCA8K_MDIO_MASTER_BUSY);
+	if (ret)
+		goto exit;
+
+	val = qca8k_mii_read32(priv->bus, 0x10 | r2, r1);
 	val &= QCA8K_MDIO_MASTER_DATA_MASK;
 
+exit:
+	mutex_unlock(&priv->bus->mdio_lock);
+
+	if (val >= 0)
+		val &= QCA8K_MDIO_MASTER_DATA_MASK;
+
 	/* even if the busy_wait timeouts try to clear the MASTER_EN */
 	qca8k_reg_clear(priv, QCA8K_MDIO_MASTER_CTRL,
 			QCA8K_MDIO_MASTER_EN);
-- 
2.30.2

