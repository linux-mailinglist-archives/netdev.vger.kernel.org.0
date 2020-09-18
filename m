Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39CCB2707A0
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 22:56:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726452AbgIRU4t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 16:56:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726390AbgIRU4r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 16:56:47 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67C2BC0613D3
        for <netdev@vger.kernel.org>; Fri, 18 Sep 2020 13:56:44 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id b79so6833238wmb.4
        for <netdev@vger.kernel.org>; Fri, 18 Sep 2020 13:56:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sartura-hr.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=y7Ouw5q1csmctc1fhzHHzDmNSVOw553D4RNVDspsGXc=;
        b=b3xm3zFHU+buD3Ln0FVgbcbMbPnMTvNIGdUxLkI6vtACC9VE086XBT4yBgh5+OIeLu
         hONtUk4H33USs1oL5kO06ZO/xyR5t+4UF7s8nr8Bx3RoiHrzakL4lIulE8tSo0zrJ2u3
         Q9TZFQfjXuas/3eDUG9Fp+Av1c59pY0NK4zwdnKZlbkNch64Dvbs9WEhfOfV8klTns2b
         0dWTemmqkKCSpjERQZSGdcV4jiPZwn62CaX3AingfR5BB+T+k+yoK4nPK94EHojF+ssN
         sCVwojz2Nf1/r0iB/o+MWxGvpkt3e76/RL4rXKUlWyweqz2NcE4ghDcdt7lsIkopadXX
         Y11g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=y7Ouw5q1csmctc1fhzHHzDmNSVOw553D4RNVDspsGXc=;
        b=Qj7cUiOXN6D9khqqPQYb2TU893jDd0Lo+ZsrvM50gUzj5sD1xsPUxTG2Re5aVJRYDS
         8ue1JMxP0kJa2yg0hdaKmBymOZBK0mRthkW8ttEae0YmnAUqiU0NPpHvOxaP9X4HyS1H
         hS/FqlnxH1XSWnjDjxKZg72k1oRKZubko2yAomGCTl9YMQHsfbk8B5jhvsy+uu9Cpyca
         NffBspIBzvsD7oS99i+ys9/bVdO+hrPreXGWLIwVKqLP7kEBj7kwtgJnlsDprx0S9YIF
         50lNejelGKku6cAZNCPhH3NDgqsuyD1PqiEag/paCXaloWpIBqhSdR5uF3ZqusWmF5+d
         mPdg==
X-Gm-Message-State: AOAM533UfEdCWMEmECXsLmcR2+dh6RyQ4mkKCiOcjQvc9Gta1WvShodG
        PQcZDYWQzQOSGKdS6mrCwmMYXw==
X-Google-Smtp-Source: ABdhPJwsXsTpXRP28mmPzwga2ydJd/E7HzwKvWR6b2GYMUMdfEuS1Tl9h3jYI5Eo4VWTyjUHbOUc5A==
X-Received: by 2002:a7b:cf36:: with SMTP id m22mr18367968wmg.51.1600462603052;
        Fri, 18 Sep 2020 13:56:43 -0700 (PDT)
Received: from localhost.localdomain (dh207-97-14.xnet.hr. [88.207.97.14])
        by smtp.googlemail.com with ESMTPSA id a17sm7661875wra.24.2020.09.18.13.56.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Sep 2020 13:56:42 -0700 (PDT)
From:   Robert Marko <robert.marko@sartura.hr>
To:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
Cc:     Robert Marko <robert.marko@sartura.hr>,
        Luka Perkov <luka.perkov@sartura.hr>
Subject: [PATCH v3 2/2] net: mdio-ipq4019: add Clause 45 support
Date:   Fri, 18 Sep 2020 22:56:33 +0200
Message-Id: <20200918205633.2698654-3-robert.marko@sartura.hr>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200918205633.2698654-1-robert.marko@sartura.hr>
References: <20200918205633.2698654-1-robert.marko@sartura.hr>
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
Changes since v2:
* Fix missed reverse christmas tree

Changes since v1:
* Maintain reverse christmas tree

 drivers/net/phy/mdio-ipq4019.c | 103 ++++++++++++++++++++++++++++-----
 1 file changed, 89 insertions(+), 14 deletions(-)

diff --git a/drivers/net/phy/mdio-ipq4019.c b/drivers/net/phy/mdio-ipq4019.c
index 64b169e5a699..24fecbf659e8 100644
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
+#define MDIO_MODE_BIT				BIT(8)
 
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
+		data |= MDIO_MODE_BIT;
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
+		data &= ~MDIO_MODE_BIT;
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
+		data |= MDIO_MODE_BIT;
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
+		data &= ~MDIO_MODE_BIT;
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

