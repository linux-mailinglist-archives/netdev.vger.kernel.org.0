Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F69E273F69
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 12:17:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726633AbgIVKRB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Sep 2020 06:17:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726610AbgIVKQp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Sep 2020 06:16:45 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2C62C0613D2
        for <netdev@vger.kernel.org>; Tue, 22 Sep 2020 03:16:44 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id r7so21997906ejs.11
        for <netdev@vger.kernel.org>; Tue, 22 Sep 2020 03:16:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sartura-hr.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LGX6bMTHeK9dl0OlUYi3pEreR5jusQDI4rgzHH0PXrY=;
        b=qfjrHGnP/i79awJU19BgoDoHfklS2j55O1X+ktD7J5cDQhvoK5Jp5IZEIydAsFYslR
         p/Oo3FzkyGG6u5XGywldonY1dzL6TtL8xD7QddOCWB69cWIbHqydL5W3gsz04QhzrmM+
         JZFHSVww2z/v7FeYCSqhrsD2dz17oQCk6Lidi/EXi5LW7R+B86HwlpnYU7cJdlrG3qZV
         v+qYmHWwcvh3khws70/JcX7bjhNtsIkO2dNxvpflTbP2VGwnzWgygoPZt6/XnBg2HD/7
         VvDco0y8FKewzgV+I/II+EGPY3JXOJKsBrdvr6JnyiLmHOLAqXm8mZOYHGIpv2yD8TDs
         5w3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LGX6bMTHeK9dl0OlUYi3pEreR5jusQDI4rgzHH0PXrY=;
        b=uWdEm8bkV8mjJhPoBIPMp0UpRbg1pAghRQrqAOLIQsREU38H3xDxguFr86wgduc9+D
         4Vl3lTNxgAu7UPIlUjxeko92zxg7xQSIBe82hPZClgoHMevO56LDw7ixsmJx0RvU13tm
         7eRry0kwXGe+RZ+Qyb9RbzdFCYAHwDBbunKWIdZhSvrK1MzUr7ET2I+7WYCz3LsX5FMa
         2JWj6LD3xfUbpQze/C5f8dE7JQP78BKL2yIe5OC2SEw9dyfDIrPznaqHGn0/iNAA/Wao
         LJQrEzl5Ak3TXHtsh8Ng/ptYzQl9r9HAtQgmRBGlqxUQIDuNTVVxtwHwDVNwWJSAHdX+
         KE6Q==
X-Gm-Message-State: AOAM533yq3VNZtgJEUWw9P8wFMEPqcvhbDmcYT5nMso7psvHmYXyzChy
        WVi3hRGU/7BWq3N9+LG4s/pvFw==
X-Google-Smtp-Source: ABdhPJzF5DGwi8aLAsaKOamx3h90UQXbre99VtUmtnWWes3AKtPAunD6dDsPEdgcfn6R3rd/AyRJTw==
X-Received: by 2002:a17:906:cec9:: with SMTP id si9mr3955841ejb.351.1600769803625;
        Tue, 22 Sep 2020 03:16:43 -0700 (PDT)
Received: from localhost.localdomain ([88.207.4.22])
        by smtp.googlemail.com with ESMTPSA id p3sm10595368edp.28.2020.09.22.03.16.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2020 03:16:43 -0700 (PDT)
From:   Robert Marko <robert.marko@sartura.hr>
To:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
Cc:     Robert Marko <robert.marko@sartura.hr>,
        Luka Perkov <luka.perkov@sartura.hr>
Subject: [PATCH v5 2/2] net: mdio-ipq4019: add Clause 45 support
Date:   Tue, 22 Sep 2020 12:16:32 +0200
Message-Id: <20200922101632.54896-3-robert.marko@sartura.hr>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200922101632.54896-1-robert.marko@sartura.hr>
References: <20200922101632.54896-1-robert.marko@sartura.hr>
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
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
Changes since v4:
* Rebase onto net-next.git

Changes since v3:
* Rename MDIO_MODE_BIT to MDIO_MODE_C45

Changes since v2:
* Fix missed reverse christmas tree

Changes since v1:
* Maintain reverse christmas tree

 drivers/net/mdio/mdio-ipq4019.c | 103 +++++++++++++++++++++++++++-----
 1 file changed, 89 insertions(+), 14 deletions(-)

diff --git a/drivers/net/mdio/mdio-ipq4019.c b/drivers/net/mdio/mdio-ipq4019.c
index 64b169e5a699..25c25ea6da66 100644
--- a/drivers/net/mdio/mdio-ipq4019.c
+++ b/drivers/net/mdio/mdio-ipq4019.c
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

