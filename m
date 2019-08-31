Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC34BA4622
	for <lists+netdev@lfdr.de>; Sat, 31 Aug 2019 22:19:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728624AbfHaUTM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Aug 2019 16:19:12 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:46690 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728595AbfHaUTH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 31 Aug 2019 16:19:07 -0400
Received: by mail-qk1-f193.google.com with SMTP id q7so1198114qkn.13
        for <netdev@vger.kernel.org>; Sat, 31 Aug 2019 13:19:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TeByo3Ckpi8g7zRScvKHhMf+eNUsM1DU9OHs2z0ZFfI=;
        b=EFvSJuOYDu94wMOonljtfeiwYYFJbaY5fhH+MBJtd92nFNu+mO6voHH3BEF8WU4ZNz
         Iiuq6KFf4V0opm0VAT/glkSPglhcPbxtoHxl+kdRT114SSQLRMH1auZVgaJpCsVCpeOy
         rNsEZOE7fiWmiLcKlLMdZOEeM8ZMuUqpbLLBhCOTjKZeUePw30CkDx02gUjN9T3/x1+o
         u0YFyPFdCB/m3f+C67ByQ2XQ0eY7H9X1gi1ajnXMXGBwI6s6ODQd0wEuJx1X3BK+E8LH
         Ezmi90UykNvQamRAv4evNpS9jPN4ZVcBEkNMmJEGPXYzp8HnJSjsAOLrMuLCncRupiAp
         sqSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TeByo3Ckpi8g7zRScvKHhMf+eNUsM1DU9OHs2z0ZFfI=;
        b=hdbjVt0WU3rHHz50ePQDoFDkmHfTiLZlaNOOdb5IdoRCMG97m5h0mCnlfE5NoRHpqp
         l0aymK0dvtLVBoHYEOST19OPRfAuQcUtlcn8CWfbiW/SIOwcOGGkOBEMsqrdwvhHK0R2
         wdjopTdmqtgnRC9iqjiGxJuihWgErQHwZe+SD20OqOFIU/jhPCBTKxB0Nv2kuALW884i
         unJ/7er1a1GaztKtuIKkuoai0hoYhLPmD/C1SHZon5SoE26vOiEZZtDXd6EEJlk7VlBx
         OswfMDVy+tiVzAqu+KVK6tRnZWHOW+IfKYUddHEZeG+AcewxPAleSg8P5RxiWovHJ/fX
         0OQw==
X-Gm-Message-State: APjAAAWVQUM5dc5q8ZzFG0lPBh+8AboNs0n1A96AaR4wAV+5qKb35mKe
        KwVbQaejR284z80d39B2v0vifdNF
X-Google-Smtp-Source: APXvYqy4IVPzqmt7YMWKu8qtZP+xMPD+R1WmZIwYWrlVHVznsx/cBawHVv+7hdyeDLEIey6GYZ+N3Q==
X-Received: by 2002:ae9:f812:: with SMTP id x18mr21444128qkh.290.1567282746209;
        Sat, 31 Aug 2019 13:19:06 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id b192sm4187485qkg.39.2019.08.31.13.19.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Aug 2019 13:19:05 -0700 (PDT)
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>,
        f.fainelli@gmail.com, andrew@lunn.ch,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: [PATCH net-next 08/10] net: dsa: mv88e6xxx: introduce .serdes_irq_enable
Date:   Sat, 31 Aug 2019 16:18:34 -0400
Message-Id: <20190831201836.19957-9-vivien.didelot@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190831201836.19957-1-vivien.didelot@gmail.com>
References: <20190831201836.19957-1-vivien.didelot@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce a new .serdes_irq_enable operation to prepare the abstraction
of IRQ enabling from the SERDES IRQ setup code.

Signed-off-by: Vivien Didelot <vivien.didelot@gmail.com>
---
 drivers/net/dsa/mv88e6xxx/chip.c   | 11 +++++
 drivers/net/dsa/mv88e6xxx/chip.h   |  2 +
 drivers/net/dsa/mv88e6xxx/port.c   |  4 +-
 drivers/net/dsa/mv88e6xxx/serdes.c | 73 ++++++++++++------------------
 drivers/net/dsa/mv88e6xxx/serdes.h | 26 +++++++++--
 5 files changed, 66 insertions(+), 50 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 3522b11d5566..258174634bb2 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -2934,6 +2934,7 @@ static const struct mv88e6xxx_ops mv88e6141_ops = {
 	.serdes_power = mv88e6390_serdes_power,
 	.serdes_get_lane = mv88e6341_serdes_get_lane,
 	.serdes_irq_mapping = mv88e6390_serdes_irq_mapping,
+	.serdes_irq_enable = mv88e6390_serdes_irq_enable,
 	.serdes_irq_setup = mv88e6390_serdes_irq_setup,
 	.serdes_irq_free = mv88e6390_serdes_irq_free,
 	.gpio_ops = &mv88e6352_gpio_ops,
@@ -3184,6 +3185,7 @@ static const struct mv88e6xxx_ops mv88e6176_ops = {
 	.serdes_get_lane = mv88e6352_serdes_get_lane,
 	.serdes_power = mv88e6352_serdes_power,
 	.serdes_irq_mapping = mv88e6352_serdes_irq_mapping,
+	.serdes_irq_enable = mv88e6352_serdes_irq_enable,
 	.serdes_irq_setup = mv88e6352_serdes_irq_setup,
 	.serdes_irq_free = mv88e6352_serdes_irq_free,
 	.gpio_ops = &mv88e6352_gpio_ops,
@@ -3268,6 +3270,7 @@ static const struct mv88e6xxx_ops mv88e6190_ops = {
 	.serdes_power = mv88e6390_serdes_power,
 	.serdes_get_lane = mv88e6390_serdes_get_lane,
 	.serdes_irq_mapping = mv88e6390_serdes_irq_mapping,
+	.serdes_irq_enable = mv88e6390_serdes_irq_enable,
 	.serdes_irq_setup = mv88e6390_serdes_irq_setup,
 	.serdes_irq_free = mv88e6390_serdes_irq_free,
 	.gpio_ops = &mv88e6352_gpio_ops,
@@ -3316,6 +3319,7 @@ static const struct mv88e6xxx_ops mv88e6190x_ops = {
 	.serdes_power = mv88e6390_serdes_power,
 	.serdes_get_lane = mv88e6390x_serdes_get_lane,
 	.serdes_irq_mapping = mv88e6390_serdes_irq_mapping,
+	.serdes_irq_enable = mv88e6390_serdes_irq_enable,
 	.serdes_irq_setup = mv88e6390_serdes_irq_setup,
 	.serdes_irq_free = mv88e6390_serdes_irq_free,
 	.gpio_ops = &mv88e6352_gpio_ops,
@@ -3364,6 +3368,7 @@ static const struct mv88e6xxx_ops mv88e6191_ops = {
 	.serdes_power = mv88e6390_serdes_power,
 	.serdes_get_lane = mv88e6390_serdes_get_lane,
 	.serdes_irq_mapping = mv88e6390_serdes_irq_mapping,
+	.serdes_irq_enable = mv88e6390_serdes_irq_enable,
 	.serdes_irq_setup = mv88e6390_serdes_irq_setup,
 	.serdes_irq_free = mv88e6390_serdes_irq_free,
 	.avb_ops = &mv88e6390_avb_ops,
@@ -3414,6 +3419,7 @@ static const struct mv88e6xxx_ops mv88e6240_ops = {
 	.serdes_get_lane = mv88e6352_serdes_get_lane,
 	.serdes_power = mv88e6352_serdes_power,
 	.serdes_irq_mapping = mv88e6352_serdes_irq_mapping,
+	.serdes_irq_enable = mv88e6352_serdes_irq_enable,
 	.serdes_irq_setup = mv88e6352_serdes_irq_setup,
 	.serdes_irq_free = mv88e6352_serdes_irq_free,
 	.gpio_ops = &mv88e6352_gpio_ops,
@@ -3504,6 +3510,7 @@ static const struct mv88e6xxx_ops mv88e6290_ops = {
 	.serdes_power = mv88e6390_serdes_power,
 	.serdes_get_lane = mv88e6390_serdes_get_lane,
 	.serdes_irq_mapping = mv88e6390_serdes_irq_mapping,
+	.serdes_irq_enable = mv88e6390_serdes_irq_enable,
 	.serdes_irq_setup = mv88e6390_serdes_irq_setup,
 	.serdes_irq_free = mv88e6390_serdes_irq_free,
 	.gpio_ops = &mv88e6352_gpio_ops,
@@ -3642,6 +3649,7 @@ static const struct mv88e6xxx_ops mv88e6341_ops = {
 	.serdes_power = mv88e6390_serdes_power,
 	.serdes_get_lane = mv88e6341_serdes_get_lane,
 	.serdes_irq_mapping = mv88e6390_serdes_irq_mapping,
+	.serdes_irq_enable = mv88e6390_serdes_irq_enable,
 	.serdes_irq_setup = mv88e6390_serdes_irq_setup,
 	.serdes_irq_free = mv88e6390_serdes_irq_free,
 	.gpio_ops = &mv88e6352_gpio_ops,
@@ -3775,6 +3783,7 @@ static const struct mv88e6xxx_ops mv88e6352_ops = {
 	.serdes_get_lane = mv88e6352_serdes_get_lane,
 	.serdes_power = mv88e6352_serdes_power,
 	.serdes_irq_mapping = mv88e6352_serdes_irq_mapping,
+	.serdes_irq_enable = mv88e6352_serdes_irq_enable,
 	.serdes_irq_setup = mv88e6352_serdes_irq_setup,
 	.serdes_irq_free = mv88e6352_serdes_irq_free,
 	.gpio_ops = &mv88e6352_gpio_ops,
@@ -3830,6 +3839,7 @@ static const struct mv88e6xxx_ops mv88e6390_ops = {
 	.serdes_power = mv88e6390_serdes_power,
 	.serdes_get_lane = mv88e6390_serdes_get_lane,
 	.serdes_irq_mapping = mv88e6390_serdes_irq_mapping,
+	.serdes_irq_enable = mv88e6390_serdes_irq_enable,
 	.serdes_irq_setup = mv88e6390_serdes_irq_setup,
 	.serdes_irq_free = mv88e6390_serdes_irq_free,
 	.gpio_ops = &mv88e6352_gpio_ops,
@@ -3882,6 +3892,7 @@ static const struct mv88e6xxx_ops mv88e6390x_ops = {
 	.serdes_power = mv88e6390_serdes_power,
 	.serdes_get_lane = mv88e6390x_serdes_get_lane,
 	.serdes_irq_mapping = mv88e6390_serdes_irq_mapping,
+	.serdes_irq_enable = mv88e6390_serdes_irq_enable,
 	.serdes_irq_setup = mv88e6390_serdes_irq_setup,
 	.serdes_irq_free = mv88e6390_serdes_irq_free,
 	.gpio_ops = &mv88e6352_gpio_ops,
diff --git a/drivers/net/dsa/mv88e6xxx/chip.h b/drivers/net/dsa/mv88e6xxx/chip.h
index 724ce2bf8258..0c7b0f6053d8 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.h
+++ b/drivers/net/dsa/mv88e6xxx/chip.h
@@ -452,6 +452,8 @@ struct mv88e6xxx_ops {
 					   int port);
 	int (*serdes_irq_setup)(struct mv88e6xxx_chip *chip, int port);
 	void (*serdes_irq_free)(struct mv88e6xxx_chip *chip, int port);
+	int (*serdes_irq_enable)(struct mv88e6xxx_chip *chip, int port, u8 lane,
+				 bool enable);
 
 	/* Statistics from the SERDES interface */
 	int (*serdes_get_sset_count)(struct mv88e6xxx_chip *chip, int port);
diff --git a/drivers/net/dsa/mv88e6xxx/port.c b/drivers/net/dsa/mv88e6xxx/port.c
index df71c08eda35..04006344adb2 100644
--- a/drivers/net/dsa/mv88e6xxx/port.c
+++ b/drivers/net/dsa/mv88e6xxx/port.c
@@ -434,7 +434,7 @@ static int mv88e6xxx_port_set_cmode(struct mv88e6xxx_chip *chip, int port,
 	lane = mv88e6xxx_serdes_get_lane(chip, port);
 	if (lane) {
 		if (chip->ports[port].serdes_irq) {
-			err = mv88e6390_serdes_irq_disable(chip, port, lane);
+			err = mv88e6xxx_serdes_irq_disable(chip, port, lane);
 			if (err)
 				return err;
 		}
@@ -469,7 +469,7 @@ static int mv88e6xxx_port_set_cmode(struct mv88e6xxx_chip *chip, int port,
 			return err;
 
 		if (chip->ports[port].serdes_irq) {
-			err = mv88e6390_serdes_irq_enable(chip, port, lane);
+			err = mv88e6xxx_serdes_irq_enable(chip, port, lane);
 			if (err)
 				return err;
 		}
diff --git a/drivers/net/dsa/mv88e6xxx/serdes.c b/drivers/net/dsa/mv88e6xxx/serdes.c
index e3ea8cca85b0..3562ef03ae55 100644
--- a/drivers/net/dsa/mv88e6xxx/serdes.c
+++ b/drivers/net/dsa/mv88e6xxx/serdes.c
@@ -226,15 +226,15 @@ static irqreturn_t mv88e6352_serdes_thread_fn(int irq, void *dev_id)
 	return ret;
 }
 
-static int mv88e6352_serdes_irq_enable(struct mv88e6xxx_chip *chip)
+int mv88e6352_serdes_irq_enable(struct mv88e6xxx_chip *chip, int port, u8 lane,
+				bool enable)
 {
-	return mv88e6352_serdes_write(chip, MV88E6352_SERDES_INT_ENABLE,
-				      MV88E6352_SERDES_INT_LINK_CHANGE);
-}
+	u16 val = 0;
 
-static int mv88e6352_serdes_irq_disable(struct mv88e6xxx_chip *chip)
-{
-	return mv88e6352_serdes_write(chip, MV88E6352_SERDES_INT_ENABLE, 0);
+	if (enable)
+		val |= MV88E6352_SERDES_INT_LINK_CHANGE;
+
+	return mv88e6352_serdes_write(chip, MV88E6352_SERDES_INT_ENABLE, val);
 }
 
 unsigned int mv88e6352_serdes_irq_mapping(struct mv88e6xxx_chip *chip, int port)
@@ -245,9 +245,11 @@ unsigned int mv88e6352_serdes_irq_mapping(struct mv88e6xxx_chip *chip, int port)
 int mv88e6352_serdes_irq_setup(struct mv88e6xxx_chip *chip, int port)
 {
 	unsigned int irq;
+	u8 lane;
 	int err;
 
-	if (!mv88e6352_port_has_serdes(chip, port))
+	lane = mv88e6xxx_serdes_get_lane(chip, port);
+	if (!lane)
 		return 0;
 
 	irq = mv88e6xxx_serdes_irq_mapping(chip, port);
@@ -272,15 +274,18 @@ int mv88e6352_serdes_irq_setup(struct mv88e6xxx_chip *chip, int port)
 		return err;
 	}
 
-	return mv88e6352_serdes_irq_enable(chip);
+	return mv88e6xxx_serdes_irq_enable(chip, port, lane);
 }
 
 void mv88e6352_serdes_irq_free(struct mv88e6xxx_chip *chip, int port)
 {
-	if (!mv88e6352_port_has_serdes(chip, port))
+	u8 lane;
+
+	lane = mv88e6xxx_serdes_get_lane(chip, port);
+	if (!lane)
 		return;
 
-	mv88e6352_serdes_irq_disable(chip);
+	mv88e6xxx_serdes_irq_disable(chip, port, lane);
 
 	/* Freeing the IRQ will trigger irq callbacks. So we cannot
 	 * hold the reg_lock.
@@ -546,51 +551,31 @@ static void mv88e6390_serdes_irq_link_sgmii(struct mv88e6xxx_chip *chip,
 }
 
 static int mv88e6390_serdes_irq_enable_sgmii(struct mv88e6xxx_chip *chip,
-					     u8 lane)
-{
-	return mv88e6390_serdes_write(chip, lane, MDIO_MMD_PHYXS,
-				      MV88E6390_SGMII_INT_ENABLE,
-				      MV88E6390_SGMII_INT_LINK_DOWN |
-				      MV88E6390_SGMII_INT_LINK_UP);
-}
-
-static int mv88e6390_serdes_irq_disable_sgmii(struct mv88e6xxx_chip *chip,
-					      u8 lane)
+					     u8 lane, bool enable)
 {
-	return mv88e6390_serdes_write(chip, lane, MDIO_MMD_PHYXS,
-				      MV88E6390_SGMII_INT_ENABLE, 0);
-}
+	u16 val = 0;
 
-int mv88e6390_serdes_irq_enable(struct mv88e6xxx_chip *chip, int port,
-				u8 lane)
-{
-	u8 cmode = chip->ports[port].cmode;
-	int err = 0;
+	if (enable)
+		val |= MV88E6390_SGMII_INT_LINK_DOWN |
+			MV88E6390_SGMII_INT_LINK_UP;
 
-	switch (cmode) {
-	case MV88E6XXX_PORT_STS_CMODE_SGMII:
-	case MV88E6XXX_PORT_STS_CMODE_1000BASEX:
-	case MV88E6XXX_PORT_STS_CMODE_2500BASEX:
-		err = mv88e6390_serdes_irq_enable_sgmii(chip, lane);
-	}
-
-	return err;
+	return mv88e6390_serdes_write(chip, lane, MDIO_MMD_PHYXS,
+				      MV88E6390_SGMII_INT_ENABLE, val);
 }
 
-int mv88e6390_serdes_irq_disable(struct mv88e6xxx_chip *chip, int port,
-				 u8 lane)
+int mv88e6390_serdes_irq_enable(struct mv88e6xxx_chip *chip, int port, u8 lane,
+				bool enable)
 {
 	u8 cmode = chip->ports[port].cmode;
-	int err = 0;
 
 	switch (cmode) {
 	case MV88E6XXX_PORT_STS_CMODE_SGMII:
 	case MV88E6XXX_PORT_STS_CMODE_1000BASEX:
 	case MV88E6XXX_PORT_STS_CMODE_2500BASEX:
-		err = mv88e6390_serdes_irq_disable_sgmii(chip, lane);
+		return mv88e6390_serdes_irq_enable_sgmii(chip, lane, enable);
 	}
 
-	return err;
+	return 0;
 }
 
 static int mv88e6390_serdes_irq_status_sgmii(struct mv88e6xxx_chip *chip,
@@ -676,7 +661,7 @@ int mv88e6390_serdes_irq_setup(struct mv88e6xxx_chip *chip, int port)
 		return err;
 	}
 
-	return mv88e6390_serdes_irq_enable(chip, port, lane);
+	return mv88e6xxx_serdes_irq_enable(chip, port, lane);
 }
 
 void mv88e6390_serdes_irq_free(struct mv88e6xxx_chip *chip, int port)
@@ -687,7 +672,7 @@ void mv88e6390_serdes_irq_free(struct mv88e6xxx_chip *chip, int port)
 	if (!lane)
 		return;
 
-	mv88e6390_serdes_irq_disable(chip, port, lane);
+	mv88e6xxx_serdes_irq_disable(chip, port, lane);
 
 	/* Freeing the IRQ will trigger irq callbacks. So we cannot
 	 * hold the reg_lock.
diff --git a/drivers/net/dsa/mv88e6xxx/serdes.h b/drivers/net/dsa/mv88e6xxx/serdes.h
index c70023f57090..e2d38b5d4222 100644
--- a/drivers/net/dsa/mv88e6xxx/serdes.h
+++ b/drivers/net/dsa/mv88e6xxx/serdes.h
@@ -88,15 +88,15 @@ int mv88e6390_serdes_power(struct mv88e6xxx_chip *chip, int port, u8 lane,
 			   bool on);
 int mv88e6390_serdes_irq_setup(struct mv88e6xxx_chip *chip, int port);
 void mv88e6390_serdes_irq_free(struct mv88e6xxx_chip *chip, int port);
+int mv88e6352_serdes_irq_enable(struct mv88e6xxx_chip *chip, int port, u8 lane,
+				bool enable);
+int mv88e6390_serdes_irq_enable(struct mv88e6xxx_chip *chip, int port, u8 lane,
+				bool enable);
 int mv88e6352_serdes_get_sset_count(struct mv88e6xxx_chip *chip, int port);
 int mv88e6352_serdes_get_strings(struct mv88e6xxx_chip *chip,
 				 int port, uint8_t *data);
 int mv88e6352_serdes_get_stats(struct mv88e6xxx_chip *chip, int port,
 			       uint64_t *data);
-int mv88e6390_serdes_irq_enable(struct mv88e6xxx_chip *chip, int port,
-				u8 lane);
-int mv88e6390_serdes_irq_disable(struct mv88e6xxx_chip *chip, int port,
-				 u8 lane);
 int mv88e6352_serdes_irq_setup(struct mv88e6xxx_chip *chip, int port);
 void mv88e6352_serdes_irq_free(struct mv88e6xxx_chip *chip, int port);
 
@@ -137,4 +137,22 @@ mv88e6xxx_serdes_irq_mapping(struct mv88e6xxx_chip *chip, int port)
 	return chip->info->ops->serdes_irq_mapping(chip, port);
 }
 
+static inline int mv88e6xxx_serdes_irq_enable(struct mv88e6xxx_chip *chip,
+					      int port, u8 lane)
+{
+	if (!chip->info->ops->serdes_irq_enable)
+		return -EOPNOTSUPP;
+
+	return chip->info->ops->serdes_irq_enable(chip, port, lane, true);
+}
+
+static inline int mv88e6xxx_serdes_irq_disable(struct mv88e6xxx_chip *chip,
+					       int port, u8 lane)
+{
+	if (!chip->info->ops->serdes_irq_enable)
+		return -EOPNOTSUPP;
+
+	return chip->info->ops->serdes_irq_enable(chip, port, lane, false);
+}
+
 #endif
-- 
2.23.0

