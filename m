Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D19E8A4624
	for <lists+netdev@lfdr.de>; Sat, 31 Aug 2019 22:19:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728629AbfHaUTN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Aug 2019 16:19:13 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:43088 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728602AbfHaUTI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 31 Aug 2019 16:19:08 -0400
Received: by mail-qk1-f196.google.com with SMTP id m2so9199486qkd.10
        for <netdev@vger.kernel.org>; Sat, 31 Aug 2019 13:19:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=h6ajpuxEsaLMzN/znFNgyYDS5Hy3WyXcICNNEbJUo2c=;
        b=HgAikyonu9WMxdyrGqY3zzESmoawl9aoukaVuxT3KvpsD5HPFpj/YyL+GiNWqxytYf
         treFsxgGUxBX14ihNon2cx8i4gj3JcaRHJReyiHC5I0Hmh67m3tcrWRf4eQU9OPTtsVJ
         PuA1iov/TYohhOBaofu1/IEhI79Vme4UVm/zXh9Psstk2UA/x+XSXuYEw1PU2+fwcG5r
         Lo3mk54C17NYA7ZUy/EB4cC57FVYVNgXie0whNd0P3Y4x8k4Tlohc5TgWFq3yTuICE5q
         HivsM1uXN5gTlyMmb5J3P4aikSqQkMMBVwiS1l7LQqp4AvT4UP2ts47ZEqiFHjBf1n8d
         dG4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=h6ajpuxEsaLMzN/znFNgyYDS5Hy3WyXcICNNEbJUo2c=;
        b=aC5jco/dJLmiVFXo5UgTb8rAunO5s9Fgm5TOCipjBbMytArsJGgxtJOsqKi76DDGqd
         Ru8ral5zy5Uf8AbmtVhTvNyu0elzag1H9ESI2FZn959Y7HPFzaBSvHyfj2ikVUfw5IF3
         qmfAAu+yzUpkp6sKkoVj0ToiGaOpOwrfZDM51TGUKQnVsF1CHeZsHjEc4tTWoW1HVpCv
         bJkCXKpZEdKD+NnRjEW1t4x5q3D18UTGIoWsn7iInvwdY+QK5eKW09eHnufIPg65NXlN
         93+rVcEUUVLYpAqm2GokUCKi2aM5pKmh+ap/0PhjqQSaXANrVUpG56asbmpijCezCFZJ
         UPdA==
X-Gm-Message-State: APjAAAVobpFmcfcYxeZmI6QSQJQXCYVNQekbV0TUH8pXLeMwXC/2BQ9d
        BjwlbKVN8hjov8tPspwylsFBoEzO
X-Google-Smtp-Source: APXvYqy+6d9nSsCUrtxlgjkzVJ6rEiEsHF3fGwNPyE3/gPS6Ynpt+hrMUAG5206+IpmK38v7+J8yeg==
X-Received: by 2002:a37:512:: with SMTP id 18mr20712976qkf.220.1567282747667;
        Sat, 31 Aug 2019 13:19:07 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id m13sm4253883qka.92.2019.08.31.13.19.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Aug 2019 13:19:07 -0700 (PDT)
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>,
        f.fainelli@gmail.com, andrew@lunn.ch,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: [PATCH net-next 09/10] net: dsa: mv88e6xxx: introduce .serdes_irq_status
Date:   Sat, 31 Aug 2019 16:18:35 -0400
Message-Id: <20190831201836.19957-10-vivien.didelot@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190831201836.19957-1-vivien.didelot@gmail.com>
References: <20190831201836.19957-1-vivien.didelot@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce a new .serdes_irq_status operation to prepare the abstraction
of IRQ thread from the SERDES IRQ setup code.

Signed-off-by: Vivien Didelot <vivien.didelot@gmail.com>
---
 drivers/net/dsa/mv88e6xxx/chip.c   | 11 ++++++
 drivers/net/dsa/mv88e6xxx/chip.h   |  2 +
 drivers/net/dsa/mv88e6xxx/serdes.c | 59 +++++++++++++++++++-----------
 drivers/net/dsa/mv88e6xxx/serdes.h | 13 +++++++
 4 files changed, 64 insertions(+), 21 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 258174634bb2..c2061e20bb32 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -2935,6 +2935,7 @@ static const struct mv88e6xxx_ops mv88e6141_ops = {
 	.serdes_get_lane = mv88e6341_serdes_get_lane,
 	.serdes_irq_mapping = mv88e6390_serdes_irq_mapping,
 	.serdes_irq_enable = mv88e6390_serdes_irq_enable,
+	.serdes_irq_status = mv88e6390_serdes_irq_status,
 	.serdes_irq_setup = mv88e6390_serdes_irq_setup,
 	.serdes_irq_free = mv88e6390_serdes_irq_free,
 	.gpio_ops = &mv88e6352_gpio_ops,
@@ -3186,6 +3187,7 @@ static const struct mv88e6xxx_ops mv88e6176_ops = {
 	.serdes_power = mv88e6352_serdes_power,
 	.serdes_irq_mapping = mv88e6352_serdes_irq_mapping,
 	.serdes_irq_enable = mv88e6352_serdes_irq_enable,
+	.serdes_irq_status = mv88e6352_serdes_irq_status,
 	.serdes_irq_setup = mv88e6352_serdes_irq_setup,
 	.serdes_irq_free = mv88e6352_serdes_irq_free,
 	.gpio_ops = &mv88e6352_gpio_ops,
@@ -3271,6 +3273,7 @@ static const struct mv88e6xxx_ops mv88e6190_ops = {
 	.serdes_get_lane = mv88e6390_serdes_get_lane,
 	.serdes_irq_mapping = mv88e6390_serdes_irq_mapping,
 	.serdes_irq_enable = mv88e6390_serdes_irq_enable,
+	.serdes_irq_status = mv88e6390_serdes_irq_status,
 	.serdes_irq_setup = mv88e6390_serdes_irq_setup,
 	.serdes_irq_free = mv88e6390_serdes_irq_free,
 	.gpio_ops = &mv88e6352_gpio_ops,
@@ -3320,6 +3323,7 @@ static const struct mv88e6xxx_ops mv88e6190x_ops = {
 	.serdes_get_lane = mv88e6390x_serdes_get_lane,
 	.serdes_irq_mapping = mv88e6390_serdes_irq_mapping,
 	.serdes_irq_enable = mv88e6390_serdes_irq_enable,
+	.serdes_irq_status = mv88e6390_serdes_irq_status,
 	.serdes_irq_setup = mv88e6390_serdes_irq_setup,
 	.serdes_irq_free = mv88e6390_serdes_irq_free,
 	.gpio_ops = &mv88e6352_gpio_ops,
@@ -3369,6 +3373,7 @@ static const struct mv88e6xxx_ops mv88e6191_ops = {
 	.serdes_get_lane = mv88e6390_serdes_get_lane,
 	.serdes_irq_mapping = mv88e6390_serdes_irq_mapping,
 	.serdes_irq_enable = mv88e6390_serdes_irq_enable,
+	.serdes_irq_status = mv88e6390_serdes_irq_status,
 	.serdes_irq_setup = mv88e6390_serdes_irq_setup,
 	.serdes_irq_free = mv88e6390_serdes_irq_free,
 	.avb_ops = &mv88e6390_avb_ops,
@@ -3420,6 +3425,7 @@ static const struct mv88e6xxx_ops mv88e6240_ops = {
 	.serdes_power = mv88e6352_serdes_power,
 	.serdes_irq_mapping = mv88e6352_serdes_irq_mapping,
 	.serdes_irq_enable = mv88e6352_serdes_irq_enable,
+	.serdes_irq_status = mv88e6352_serdes_irq_status,
 	.serdes_irq_setup = mv88e6352_serdes_irq_setup,
 	.serdes_irq_free = mv88e6352_serdes_irq_free,
 	.gpio_ops = &mv88e6352_gpio_ops,
@@ -3511,6 +3517,7 @@ static const struct mv88e6xxx_ops mv88e6290_ops = {
 	.serdes_get_lane = mv88e6390_serdes_get_lane,
 	.serdes_irq_mapping = mv88e6390_serdes_irq_mapping,
 	.serdes_irq_enable = mv88e6390_serdes_irq_enable,
+	.serdes_irq_status = mv88e6390_serdes_irq_status,
 	.serdes_irq_setup = mv88e6390_serdes_irq_setup,
 	.serdes_irq_free = mv88e6390_serdes_irq_free,
 	.gpio_ops = &mv88e6352_gpio_ops,
@@ -3650,6 +3657,7 @@ static const struct mv88e6xxx_ops mv88e6341_ops = {
 	.serdes_get_lane = mv88e6341_serdes_get_lane,
 	.serdes_irq_mapping = mv88e6390_serdes_irq_mapping,
 	.serdes_irq_enable = mv88e6390_serdes_irq_enable,
+	.serdes_irq_status = mv88e6390_serdes_irq_status,
 	.serdes_irq_setup = mv88e6390_serdes_irq_setup,
 	.serdes_irq_free = mv88e6390_serdes_irq_free,
 	.gpio_ops = &mv88e6352_gpio_ops,
@@ -3784,6 +3792,7 @@ static const struct mv88e6xxx_ops mv88e6352_ops = {
 	.serdes_power = mv88e6352_serdes_power,
 	.serdes_irq_mapping = mv88e6352_serdes_irq_mapping,
 	.serdes_irq_enable = mv88e6352_serdes_irq_enable,
+	.serdes_irq_status = mv88e6352_serdes_irq_status,
 	.serdes_irq_setup = mv88e6352_serdes_irq_setup,
 	.serdes_irq_free = mv88e6352_serdes_irq_free,
 	.gpio_ops = &mv88e6352_gpio_ops,
@@ -3840,6 +3849,7 @@ static const struct mv88e6xxx_ops mv88e6390_ops = {
 	.serdes_get_lane = mv88e6390_serdes_get_lane,
 	.serdes_irq_mapping = mv88e6390_serdes_irq_mapping,
 	.serdes_irq_enable = mv88e6390_serdes_irq_enable,
+	.serdes_irq_status = mv88e6390_serdes_irq_status,
 	.serdes_irq_setup = mv88e6390_serdes_irq_setup,
 	.serdes_irq_free = mv88e6390_serdes_irq_free,
 	.gpio_ops = &mv88e6352_gpio_ops,
@@ -3893,6 +3903,7 @@ static const struct mv88e6xxx_ops mv88e6390x_ops = {
 	.serdes_get_lane = mv88e6390x_serdes_get_lane,
 	.serdes_irq_mapping = mv88e6390_serdes_irq_mapping,
 	.serdes_irq_enable = mv88e6390_serdes_irq_enable,
+	.serdes_irq_status = mv88e6390_serdes_irq_status,
 	.serdes_irq_setup = mv88e6390_serdes_irq_setup,
 	.serdes_irq_free = mv88e6390_serdes_irq_free,
 	.gpio_ops = &mv88e6352_gpio_ops,
diff --git a/drivers/net/dsa/mv88e6xxx/chip.h b/drivers/net/dsa/mv88e6xxx/chip.h
index 0c7b0f6053d8..9a73fd1d643b 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.h
+++ b/drivers/net/dsa/mv88e6xxx/chip.h
@@ -454,6 +454,8 @@ struct mv88e6xxx_ops {
 	void (*serdes_irq_free)(struct mv88e6xxx_chip *chip, int port);
 	int (*serdes_irq_enable)(struct mv88e6xxx_chip *chip, int port, u8 lane,
 				 bool enable);
+	irqreturn_t (*serdes_irq_status)(struct mv88e6xxx_chip *chip, int port,
+					 u8 lane);
 
 	/* Statistics from the SERDES interface */
 	int (*serdes_get_sset_count)(struct mv88e6xxx_chip *chip, int port);
diff --git a/drivers/net/dsa/mv88e6xxx/serdes.c b/drivers/net/dsa/mv88e6xxx/serdes.c
index 3562ef03ae55..d37419ba26ab 100644
--- a/drivers/net/dsa/mv88e6xxx/serdes.c
+++ b/drivers/net/dsa/mv88e6xxx/serdes.c
@@ -202,25 +202,33 @@ static void mv88e6352_serdes_irq_link(struct mv88e6xxx_chip *chip, int port)
 	dsa_port_phylink_mac_change(ds, port, up);
 }
 
-static irqreturn_t mv88e6352_serdes_thread_fn(int irq, void *dev_id)
+irqreturn_t mv88e6352_serdes_irq_status(struct mv88e6xxx_chip *chip, int port,
+					u8 lane)
 {
-	struct mv88e6xxx_port *port = dev_id;
-	struct mv88e6xxx_chip *chip = port->chip;
 	irqreturn_t ret = IRQ_NONE;
 	u16 status;
 	int err;
 
-	mv88e6xxx_reg_lock(chip);
-
 	err = mv88e6352_serdes_read(chip, MV88E6352_SERDES_INT_STATUS, &status);
 	if (err)
-		goto out;
+		return ret;
 
 	if (status & MV88E6352_SERDES_INT_LINK_CHANGE) {
 		ret = IRQ_HANDLED;
-		mv88e6352_serdes_irq_link(chip, port->port);
+		mv88e6352_serdes_irq_link(chip, port);
 	}
-out:
+
+	return ret;
+}
+
+static irqreturn_t mv88e6352_serdes_thread_fn(int irq, void *dev_id)
+{
+	struct mv88e6xxx_port *port = dev_id;
+	struct mv88e6xxx_chip *chip = port->chip;
+	irqreturn_t ret = IRQ_NONE;
+
+	mv88e6xxx_reg_lock(chip);
+	ret = mv88e6xxx_serdes_irq_status(chip, port->port, 0);
 	mv88e6xxx_reg_unlock(chip);
 
 	return ret;
@@ -589,21 +597,13 @@ static int mv88e6390_serdes_irq_status_sgmii(struct mv88e6xxx_chip *chip,
 	return err;
 }
 
-static irqreturn_t mv88e6390_serdes_thread_fn(int irq, void *dev_id)
+irqreturn_t mv88e6390_serdes_irq_status(struct mv88e6xxx_chip *chip, int port,
+					u8 lane)
 {
-	struct mv88e6xxx_port *port = dev_id;
-	struct mv88e6xxx_chip *chip = port->chip;
+	u8 cmode = chip->ports[port].cmode;
 	irqreturn_t ret = IRQ_NONE;
-	u8 cmode = port->cmode;
 	u16 status;
 	int err;
-	u8 lane;
-
-	mv88e6xxx_reg_lock(chip);
-
-	lane = mv88e6xxx_serdes_get_lane(chip, port->port);
-	if (!lane)
-		goto out;
 
 	switch (cmode) {
 	case MV88E6XXX_PORT_STS_CMODE_SGMII:
@@ -611,13 +611,30 @@ static irqreturn_t mv88e6390_serdes_thread_fn(int irq, void *dev_id)
 	case MV88E6XXX_PORT_STS_CMODE_2500BASEX:
 		err = mv88e6390_serdes_irq_status_sgmii(chip, lane, &status);
 		if (err)
-			goto out;
+			return ret;
 		if (status & (MV88E6390_SGMII_INT_LINK_DOWN |
 			      MV88E6390_SGMII_INT_LINK_UP)) {
 			ret = IRQ_HANDLED;
-			mv88e6390_serdes_irq_link_sgmii(chip, port->port, lane);
+			mv88e6390_serdes_irq_link_sgmii(chip, port, lane);
 		}
 	}
+
+	return ret;
+}
+
+static irqreturn_t mv88e6390_serdes_thread_fn(int irq, void *dev_id)
+{
+	struct mv88e6xxx_port *port = dev_id;
+	struct mv88e6xxx_chip *chip = port->chip;
+	irqreturn_t ret = IRQ_NONE;
+	u8 lane;
+
+	mv88e6xxx_reg_lock(chip);
+	lane = mv88e6xxx_serdes_get_lane(chip, port->port);
+	if (!lane)
+		goto out;
+
+	ret = mv88e6xxx_serdes_irq_status(chip, port->port, lane);
 out:
 	mv88e6xxx_reg_unlock(chip);
 
diff --git a/drivers/net/dsa/mv88e6xxx/serdes.h b/drivers/net/dsa/mv88e6xxx/serdes.h
index e2d38b5d4222..52f937347a36 100644
--- a/drivers/net/dsa/mv88e6xxx/serdes.h
+++ b/drivers/net/dsa/mv88e6xxx/serdes.h
@@ -92,6 +92,10 @@ int mv88e6352_serdes_irq_enable(struct mv88e6xxx_chip *chip, int port, u8 lane,
 				bool enable);
 int mv88e6390_serdes_irq_enable(struct mv88e6xxx_chip *chip, int port, u8 lane,
 				bool enable);
+irqreturn_t mv88e6352_serdes_irq_status(struct mv88e6xxx_chip *chip, int port,
+					u8 lane);
+irqreturn_t mv88e6390_serdes_irq_status(struct mv88e6xxx_chip *chip, int port,
+					u8 lane);
 int mv88e6352_serdes_get_sset_count(struct mv88e6xxx_chip *chip, int port);
 int mv88e6352_serdes_get_strings(struct mv88e6xxx_chip *chip,
 				 int port, uint8_t *data);
@@ -155,4 +159,13 @@ static inline int mv88e6xxx_serdes_irq_disable(struct mv88e6xxx_chip *chip,
 	return chip->info->ops->serdes_irq_enable(chip, port, lane, false);
 }
 
+static inline irqreturn_t
+mv88e6xxx_serdes_irq_status(struct mv88e6xxx_chip *chip, int port, u8 lane)
+{
+	if (!chip->info->ops->serdes_irq_status)
+		return IRQ_NONE;
+
+	return chip->info->ops->serdes_irq_status(chip, port, lane);
+}
+
 #endif
-- 
2.23.0

