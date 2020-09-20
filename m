Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9AA02714EE
	for <lists+netdev@lfdr.de>; Sun, 20 Sep 2020 16:17:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726508AbgITORW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Sep 2020 10:17:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726409AbgITORP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Sep 2020 10:17:15 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5178C0613D1
        for <netdev@vger.kernel.org>; Sun, 20 Sep 2020 07:17:14 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id e22so10385215edq.6
        for <netdev@vger.kernel.org>; Sun, 20 Sep 2020 07:17:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sartura-hr.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2hcmqKdxd5jCcj+hc+Lsnk1IaTb5X0I65MAc8nSQ+Y8=;
        b=yjLzYSIetbOCCwodThD5Xmbocg7UZRxnBgTLi5Jv6yE0KsvOIbp8lIEBOV+fdzbkI1
         D8C/zm2p5DClaU7c8af114Q383NYIJooCl8KZWC+r3uYMAaNFgT5ZDgyxa5mDWRIGOw+
         0taTN5TR11kjqbynIAKoU5tk81uAUX+UwQbfw6JEGbefMG4JRfswysDCDdnip7s3JeD+
         n4y0AmRWNYwrTUHQJ3gZCU+IoaQk7qxX7EDJTnOHHX/+3ym94U6BKx340H7Z/AAYcehk
         kwNP82FOfDf4hRXzwPE16tm33EFtJ+3Yd+Si1651TMWk+dw44Sn3feT8+z/eG51t/Bgq
         /kJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2hcmqKdxd5jCcj+hc+Lsnk1IaTb5X0I65MAc8nSQ+Y8=;
        b=hhisNsZGYYDEXruO2TrUsrvtJ8PQbr9R+jnvSuIjW5StlH4H2bZNkTIltbN9ql1+P1
         rypYX4lKKN0kd76hvxqraerBfneAkUTNyA7pYO9J6OOCuvj4oVwKDoftU3pNSBQlwC0J
         f3sZbw1VXWwPJ/8sn/5n2J+c3dt0vFxb2CzcchmH8fQsc3suzWlO6/t/TN+LoChNGdzN
         ZmAc/FsxWrfVUL5gF6yKQovxtIPb8VFSDmmMtQ/HFZE+2cUagga61qNt5z6baqbvVg5x
         /S+cm5VVIoTwQeplS2popUmGQG44KegsnKMQDZ6sVgmZ2UtT2+3MikKz9soHG/t288Ff
         EEzA==
X-Gm-Message-State: AOAM530RVLxmMazv0VHERobq217ZK6/IGfcyVvcJD/hLCQpp7eQmlp2l
        9RAQ/APof41VAuAMhhd8s/lXnw==
X-Google-Smtp-Source: ABdhPJwPxQrfJoslP75YddpB1ANO6q8z+1GxInHWqTH9e8b5Nsghb1z0h1f6W6U41ls4UzHGn3CATw==
X-Received: by 2002:aa7:c054:: with SMTP id k20mr48536586edo.224.1600611433477;
        Sun, 20 Sep 2020 07:17:13 -0700 (PDT)
Received: from localhost.localdomain ([88.207.4.31])
        by smtp.googlemail.com with ESMTPSA id g11sm6631594edt.88.2020.09.20.07.17.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Sep 2020 07:17:12 -0700 (PDT)
From:   Robert Marko <robert.marko@sartura.hr>
To:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
Cc:     Robert Marko <robert.marko@sartura.hr>,
        Luka Perkov <luka.perkov@sartura.hr>
Subject: [PATCH v4 2/2] net: mdio-ipq4019: add Clause 45 support
Date:   Sun, 20 Sep 2020 16:16:53 +0200
Message-Id: <20200920141653.357493-3-robert.marko@sartura.hr>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200920141653.357493-1-robert.marko@sartura.hr>
References: <20200920141653.357493-1-robert.marko@sartura.hr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While up-streaming the IPQ4019 driver it was thought that the controller had no Clause 45 support,
but it actually does and its activated by writing a bit to the mode register.

So lets add it as newer SoC-s use the same controller and Clause 45 compliant PHY-s.

Signed-off-by: Robert Marko <robert.marko@sartura.hr>
Cc: Luka Perkov <luka.perkov@sartura.hr>
---
Changes since v3:
* Rename MDIO_MODE_BIT to MDIO_MODE_C45

Changes since v2:
* Fix missed reverse christmas tree

Changes since v1:
* Maintain reverse christmas tree

 drivers/net/phy/mdio-ipq4019.c | 103 ++++++++++++++++++++++++++++-----
 1 file changed, 89 insertions(+), 14 deletions(-)

diff --git a/drivers/net/phy/mdio-ipq4019.c b/drivers/net/phy/mdio-ipq4019.c
index 64b169e5a699..25c25ea6da66 100644
--- a/drivers/net/phy/mdio-ipq4019.c
+++ b/drivers/net/phy/mdio-ipq4019.c
@@ -12,6 +12,7 @@
 #include <linux/phy.h>
 #include <linux/platform_device.h>
 
+#define MDIO_MODE_REG				0x40
 #define MDIO_ADDR_REG				0x44
 #define MDIO_DATA_WRITE_REG			0x48
 #define MDIO_DATA_READ_REG			0x4c
@@ -20,6 +21,12 @@
 #define MDIO_CMD_ACCESS_START		BIT(8)
 #define MDIO_CMD_ACCESS_CODE_READ	0
 #define MDIO_CMD_ACCESS_CODE_WRITE	1
+#define MDIO_CMD_ACCESS_CODE_C45_ADDR	0
+#define MDIO_CMD_ACCESS_CODE_C45_WRITE	1
+#define MDIO_CMD_ACCESS_CODE_C45_READ	2
+
+/* 0 = Clause 22, 1 = Clause 45 */
+#define MDIO_MODE_C45				BIT(8)
 
 #define IPQ4019_MDIO_TIMEOUT	10000
 #define IPQ4019_MDIO_SLEEP		10
@@ -41,19 +48,44 @@ static int ipq4019_mdio_wait_busy(struct mii_bus *bus)
 static int ipq4019_mdio_read(struct mii_bus *bus, int mii_id, int regnum)
 {
 	struct ipq4019_mdio_data *priv = bus->priv;
+	unsigned int data;
 	unsigned int cmd;
 
-	/* Reject clause 45 */
-	if (regnum & MII_ADDR_C45)
-		return -EOPNOTSUPP;
-
 	if (ipq4019_mdio_wait_busy(bus))
 		return -ETIMEDOUT;
 
-	/* issue the phy address and reg */
-	writel((mii_id << 8) | regnum, priv->membase + MDIO_ADDR_REG);
+	/* Clause 45 support */
+	if (regnum & MII_ADDR_C45) {
+		unsigned int mmd = (regnum >> 16) & 0x1F;
+		unsigned int reg = regnum & 0xFFFF;
+
+		/* Enter Clause 45 mode */
+		data = readl(priv->membase + MDIO_MODE_REG);
+
+		data |= MDIO_MODE_C45;
+
+		writel(data, priv->membase + MDIO_MODE_REG);
+
+		/* issue the phy address and mmd */
+		writel((mii_id << 8) | mmd, priv->membase + MDIO_ADDR_REG);
+
+		/* issue reg */
+		writel(reg, priv->membase + MDIO_DATA_WRITE_REG);
+
+		cmd = MDIO_CMD_ACCESS_START | MDIO_CMD_ACCESS_CODE_C45_ADDR;
+	} else {
+		/* Enter Clause 22 mode */
+		data = readl(priv->membase + MDIO_MODE_REG);
 
-	cmd = MDIO_CMD_ACCESS_START | MDIO_CMD_ACCESS_CODE_READ;
+		data &= ~MDIO_MODE_C45;
+
+		writel(data, priv->membase + MDIO_MODE_REG);
+
+		/* issue the phy address and reg */
+		writel((mii_id << 8) | regnum, priv->membase + MDIO_ADDR_REG);
+
+		cmd = MDIO_CMD_ACCESS_START | MDIO_CMD_ACCESS_CODE_READ;
+	}
 
 	/* issue read command */
 	writel(cmd, priv->membase + MDIO_CMD_REG);
@@ -62,6 +94,15 @@ static int ipq4019_mdio_read(struct mii_bus *bus, int mii_id, int regnum)
 	if (ipq4019_mdio_wait_busy(bus))
 		return -ETIMEDOUT;
 
+	if (regnum & MII_ADDR_C45) {
+		cmd = MDIO_CMD_ACCESS_START | MDIO_CMD_ACCESS_CODE_C45_READ;
+
+		writel(cmd, priv->membase + MDIO_CMD_REG);
+
+		if (ipq4019_mdio_wait_busy(bus))
+			return -ETIMEDOUT;
+	}
+
 	/* Read and return data */
 	return readl(priv->membase + MDIO_DATA_READ_REG);
 }
@@ -70,23 +111,57 @@ static int ipq4019_mdio_write(struct mii_bus *bus, int mii_id, int regnum,
 							 u16 value)
 {
 	struct ipq4019_mdio_data *priv = bus->priv;
+	unsigned int data;
 	unsigned int cmd;
 
-	/* Reject clause 45 */
-	if (regnum & MII_ADDR_C45)
-		return -EOPNOTSUPP;
-
 	if (ipq4019_mdio_wait_busy(bus))
 		return -ETIMEDOUT;
 
-	/* issue the phy address and reg */
-	writel((mii_id << 8) | regnum, priv->membase + MDIO_ADDR_REG);
+	/* Clause 45 support */
+	if (regnum & MII_ADDR_C45) {
+		unsigned int mmd = (regnum >> 16) & 0x1F;
+		unsigned int reg = regnum & 0xFFFF;
+
+		/* Enter Clause 45 mode */
+		data = readl(priv->membase + MDIO_MODE_REG);
+
+		data |= MDIO_MODE_C45;
+
+		writel(data, priv->membase + MDIO_MODE_REG);
+
+		/* issue the phy address and mmd */
+		writel((mii_id << 8) | mmd, priv->membase + MDIO_ADDR_REG);
+
+		/* issue reg */
+		writel(reg, priv->membase + MDIO_DATA_WRITE_REG);
+
+		cmd = MDIO_CMD_ACCESS_START | MDIO_CMD_ACCESS_CODE_C45_ADDR;
+
+		writel(cmd, priv->membase + MDIO_CMD_REG);
+
+		if (ipq4019_mdio_wait_busy(bus))
+			return -ETIMEDOUT;
+	} else {
+		/* Enter Clause 22 mode */
+		data = readl(priv->membase + MDIO_MODE_REG);
+
+		data &= ~MDIO_MODE_C45;
+
+		writel(data, priv->membase + MDIO_MODE_REG);
+
+		/* issue the phy address and reg */
+		writel((mii_id << 8) | regnum, priv->membase + MDIO_ADDR_REG);
+	}
 
 	/* issue write data */
 	writel(value, priv->membase + MDIO_DATA_WRITE_REG);
 
-	cmd = MDIO_CMD_ACCESS_START | MDIO_CMD_ACCESS_CODE_WRITE;
 	/* issue write command */
+	if (regnum & MII_ADDR_C45)
+		cmd = MDIO_CMD_ACCESS_START | MDIO_CMD_ACCESS_CODE_C45_WRITE;
+	else
+		cmd = MDIO_CMD_ACCESS_START | MDIO_CMD_ACCESS_CODE_WRITE;
+
 	writel(cmd, priv->membase + MDIO_CMD_REG);
 
 	/* Wait write complete */
-- 
2.26.2

