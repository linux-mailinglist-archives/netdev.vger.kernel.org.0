Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19B60A461D
	for <lists+netdev@lfdr.de>; Sat, 31 Aug 2019 22:19:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728573AbfHaUTC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Aug 2019 16:19:02 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:36218 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728562AbfHaUTB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 31 Aug 2019 16:19:01 -0400
Received: by mail-qt1-f193.google.com with SMTP id z4so11524543qtc.3
        for <netdev@vger.kernel.org>; Sat, 31 Aug 2019 13:19:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mlltVA2PG44BnUziPMJf0Bgq5qff6sZaQGoUY3kl6l0=;
        b=jZJm96MnL6WaWaiV15H2HQS/4LA8tVrBqd8cL1JtO0bffbhLNgARZc2GIMfx1Z0Vgx
         Yqw0gjOWs+6DVZQkQgZXnm8/MrXa7srQYhLytcB2Tw8du8ODf2uUMAIXxVqYdZ6IO1MY
         JHn47Yu5d4Eqwez4qM5+QbT09DrInLnWJyGmIa/5JXyAcAaR3jhiBp/HgktvHtimZz6A
         3qY9LjqMsrVOzO1j4ceaQfbT8c76UalN3sjCq0Zeowgng0apnhyNi2o8zXTvsUFSZ4Sa
         vNaZyjdShQcujfR8Fa9Ds8sAX7UZy2CeFjSQDttDGRsOjDRkiL/O9rZsWzx+COlphEah
         dUVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mlltVA2PG44BnUziPMJf0Bgq5qff6sZaQGoUY3kl6l0=;
        b=KEJQkm2yJs0W0JlqmMnvRAt5OZh4j1AhW4yYcQKVXRx+diSjt01uVcQbLN696Nioj7
         N0XR0odl9msTVjiwwAawUGWyx5o3RkFYGEpp6+HeA0wS907pIGYtXmXR4YRbMT9qTzVI
         dg0bGA4w+r+vqqwuuNEIMAvpKM5GKm6SeD7nYql03+0bEqZigeLr+W55C4YPezplVCGH
         H08KQEmDJYh5xgyIQypvL4fA8vb2PBEyhMD+jeGvWTe7rYQ2cQSFlysu01FGOtsehght
         Wt1GStevF0hTtMZWvqVu5VttJTorns13xNvpb8VHtWSVpgPP8CAGqNWSrc82Z+rthFVa
         3Ulw==
X-Gm-Message-State: APjAAAU+8cwAhxY5GfUa2IzNuE/Ek0WKG/F2CMv4i95cfcVoWcAS5/A7
        uV2Uzjsqt7cRlpjSDcmjpHtI0eIq
X-Google-Smtp-Source: APXvYqz1eyC2RnWx48HK0VxAQx5IJd74urzuciY3TKf4uDJ3oBqcue4zw9mNo2eZDgKVZA02PDhVEA==
X-Received: by 2002:ac8:f43:: with SMTP id l3mr21855840qtk.278.1567282739566;
        Sat, 31 Aug 2019 13:18:59 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id j50sm5190524qtj.30.2019.08.31.13.18.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Aug 2019 13:18:59 -0700 (PDT)
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>,
        f.fainelli@gmail.com, andrew@lunn.ch,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: [PATCH net-next 03/10] net: dsa: mv88e6xxx: introduce .serdes_irq_mapping
Date:   Sat, 31 Aug 2019 16:18:29 -0400
Message-Id: <20190831201836.19957-4-vivien.didelot@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190831201836.19957-1-vivien.didelot@gmail.com>
References: <20190831201836.19957-1-vivien.didelot@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce a new .serdes_irq_mapping operation to prepare the
abstraction of IRQ mapping from the SERDES IRQ setup code.

Signed-off-by: Vivien Didelot <vivien.didelot@gmail.com>
---
 drivers/net/dsa/mv88e6xxx/chip.c   | 11 +++++++++++
 drivers/net/dsa/mv88e6xxx/chip.h   |  2 ++
 drivers/net/dsa/mv88e6xxx/serdes.c | 26 ++++++++++++++++++++------
 drivers/net/dsa/mv88e6xxx/serdes.h | 12 ++++++++++++
 4 files changed, 45 insertions(+), 6 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index c648f9fbfa59..0ab4ce86eda7 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -2931,6 +2931,7 @@ static const struct mv88e6xxx_ops mv88e6141_ops = {
 	.vtu_loadpurge = mv88e6352_g1_vtu_loadpurge,
 	.serdes_power = mv88e6390_serdes_power,
 	.serdes_get_lane = mv88e6341_serdes_get_lane,
+	.serdes_irq_mapping = mv88e6390_serdes_irq_mapping,
 	.serdes_irq_setup = mv88e6390_serdes_irq_setup,
 	.serdes_irq_free = mv88e6390_serdes_irq_free,
 	.gpio_ops = &mv88e6352_gpio_ops,
@@ -3178,6 +3179,7 @@ static const struct mv88e6xxx_ops mv88e6176_ops = {
 	.vtu_getnext = mv88e6352_g1_vtu_getnext,
 	.vtu_loadpurge = mv88e6352_g1_vtu_loadpurge,
 	.serdes_power = mv88e6352_serdes_power,
+	.serdes_irq_mapping = mv88e6352_serdes_irq_mapping,
 	.serdes_irq_setup = mv88e6352_serdes_irq_setup,
 	.serdes_irq_free = mv88e6352_serdes_irq_free,
 	.gpio_ops = &mv88e6352_gpio_ops,
@@ -3261,6 +3263,7 @@ static const struct mv88e6xxx_ops mv88e6190_ops = {
 	.vtu_loadpurge = mv88e6390_g1_vtu_loadpurge,
 	.serdes_power = mv88e6390_serdes_power,
 	.serdes_get_lane = mv88e6390_serdes_get_lane,
+	.serdes_irq_mapping = mv88e6390_serdes_irq_mapping,
 	.serdes_irq_setup = mv88e6390_serdes_irq_setup,
 	.serdes_irq_free = mv88e6390_serdes_irq_free,
 	.gpio_ops = &mv88e6352_gpio_ops,
@@ -3308,6 +3311,7 @@ static const struct mv88e6xxx_ops mv88e6190x_ops = {
 	.vtu_loadpurge = mv88e6390_g1_vtu_loadpurge,
 	.serdes_power = mv88e6390_serdes_power,
 	.serdes_get_lane = mv88e6390x_serdes_get_lane,
+	.serdes_irq_mapping = mv88e6390_serdes_irq_mapping,
 	.serdes_irq_setup = mv88e6390_serdes_irq_setup,
 	.serdes_irq_free = mv88e6390_serdes_irq_free,
 	.gpio_ops = &mv88e6352_gpio_ops,
@@ -3355,6 +3359,7 @@ static const struct mv88e6xxx_ops mv88e6191_ops = {
 	.vtu_loadpurge = mv88e6390_g1_vtu_loadpurge,
 	.serdes_power = mv88e6390_serdes_power,
 	.serdes_get_lane = mv88e6390_serdes_get_lane,
+	.serdes_irq_mapping = mv88e6390_serdes_irq_mapping,
 	.serdes_irq_setup = mv88e6390_serdes_irq_setup,
 	.serdes_irq_free = mv88e6390_serdes_irq_free,
 	.avb_ops = &mv88e6390_avb_ops,
@@ -3403,6 +3408,7 @@ static const struct mv88e6xxx_ops mv88e6240_ops = {
 	.vtu_getnext = mv88e6352_g1_vtu_getnext,
 	.vtu_loadpurge = mv88e6352_g1_vtu_loadpurge,
 	.serdes_power = mv88e6352_serdes_power,
+	.serdes_irq_mapping = mv88e6352_serdes_irq_mapping,
 	.serdes_irq_setup = mv88e6352_serdes_irq_setup,
 	.serdes_irq_free = mv88e6352_serdes_irq_free,
 	.gpio_ops = &mv88e6352_gpio_ops,
@@ -3492,6 +3498,7 @@ static const struct mv88e6xxx_ops mv88e6290_ops = {
 	.vtu_loadpurge = mv88e6390_g1_vtu_loadpurge,
 	.serdes_power = mv88e6390_serdes_power,
 	.serdes_get_lane = mv88e6390_serdes_get_lane,
+	.serdes_irq_mapping = mv88e6390_serdes_irq_mapping,
 	.serdes_irq_setup = mv88e6390_serdes_irq_setup,
 	.serdes_irq_free = mv88e6390_serdes_irq_free,
 	.gpio_ops = &mv88e6352_gpio_ops,
@@ -3629,6 +3636,7 @@ static const struct mv88e6xxx_ops mv88e6341_ops = {
 	.vtu_loadpurge = mv88e6352_g1_vtu_loadpurge,
 	.serdes_power = mv88e6390_serdes_power,
 	.serdes_get_lane = mv88e6341_serdes_get_lane,
+	.serdes_irq_mapping = mv88e6390_serdes_irq_mapping,
 	.serdes_irq_setup = mv88e6390_serdes_irq_setup,
 	.serdes_irq_free = mv88e6390_serdes_irq_free,
 	.gpio_ops = &mv88e6352_gpio_ops,
@@ -3760,6 +3768,7 @@ static const struct mv88e6xxx_ops mv88e6352_ops = {
 	.vtu_getnext = mv88e6352_g1_vtu_getnext,
 	.vtu_loadpurge = mv88e6352_g1_vtu_loadpurge,
 	.serdes_power = mv88e6352_serdes_power,
+	.serdes_irq_mapping = mv88e6352_serdes_irq_mapping,
 	.serdes_irq_setup = mv88e6352_serdes_irq_setup,
 	.serdes_irq_free = mv88e6352_serdes_irq_free,
 	.gpio_ops = &mv88e6352_gpio_ops,
@@ -3814,6 +3823,7 @@ static const struct mv88e6xxx_ops mv88e6390_ops = {
 	.vtu_loadpurge = mv88e6390_g1_vtu_loadpurge,
 	.serdes_power = mv88e6390_serdes_power,
 	.serdes_get_lane = mv88e6390_serdes_get_lane,
+	.serdes_irq_mapping = mv88e6390_serdes_irq_mapping,
 	.serdes_irq_setup = mv88e6390_serdes_irq_setup,
 	.serdes_irq_free = mv88e6390_serdes_irq_free,
 	.gpio_ops = &mv88e6352_gpio_ops,
@@ -3865,6 +3875,7 @@ static const struct mv88e6xxx_ops mv88e6390x_ops = {
 	.vtu_loadpurge = mv88e6390_g1_vtu_loadpurge,
 	.serdes_power = mv88e6390_serdes_power,
 	.serdes_get_lane = mv88e6390x_serdes_get_lane,
+	.serdes_irq_mapping = mv88e6390_serdes_irq_mapping,
 	.serdes_irq_setup = mv88e6390_serdes_irq_setup,
 	.serdes_irq_free = mv88e6390_serdes_irq_free,
 	.gpio_ops = &mv88e6352_gpio_ops,
diff --git a/drivers/net/dsa/mv88e6xxx/chip.h b/drivers/net/dsa/mv88e6xxx/chip.h
index 2016f51c868b..b116bd7f6109 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.h
+++ b/drivers/net/dsa/mv88e6xxx/chip.h
@@ -447,6 +447,8 @@ struct mv88e6xxx_ops {
 	int (*serdes_get_lane)(struct mv88e6xxx_chip *chip, int port, u8 *lane);
 
 	/* SERDES interrupt handling */
+	unsigned int (*serdes_irq_mapping)(struct mv88e6xxx_chip *chip,
+					   int port);
 	int (*serdes_irq_setup)(struct mv88e6xxx_chip *chip, int port);
 	void (*serdes_irq_free)(struct mv88e6xxx_chip *chip, int port);
 
diff --git a/drivers/net/dsa/mv88e6xxx/serdes.c b/drivers/net/dsa/mv88e6xxx/serdes.c
index f65652e6edec..4fb1dca64ef1 100644
--- a/drivers/net/dsa/mv88e6xxx/serdes.c
+++ b/drivers/net/dsa/mv88e6xxx/serdes.c
@@ -240,18 +240,25 @@ static int mv88e6352_serdes_irq_disable(struct mv88e6xxx_chip *chip)
 	return mv88e6352_serdes_write(chip, MV88E6352_SERDES_INT_ENABLE, 0);
 }
 
+unsigned int mv88e6352_serdes_irq_mapping(struct mv88e6xxx_chip *chip, int port)
+{
+	return irq_find_mapping(chip->g2_irq.domain, MV88E6352_SERDES_IRQ);
+}
+
 int mv88e6352_serdes_irq_setup(struct mv88e6xxx_chip *chip, int port)
 {
+	unsigned int irq;
 	int err;
 
 	if (!mv88e6352_port_has_serdes(chip, port))
 		return 0;
 
-	chip->ports[port].serdes_irq = irq_find_mapping(chip->g2_irq.domain,
-							MV88E6352_SERDES_IRQ);
-	if (!chip->ports[port].serdes_irq)
+	irq = mv88e6xxx_serdes_irq_mapping(chip, port);
+	if (!irq)
 		return 0;
 
+	chip->ports[port].serdes_irq = irq;
+
 	/* Requesting the IRQ will trigger irq callbacks. So we cannot
 	 * hold the reg_lock.
 	 */
@@ -673,8 +680,14 @@ static irqreturn_t mv88e6390_serdes_thread_fn(int irq, void *dev_id)
 	return ret;
 }
 
+unsigned int mv88e6390_serdes_irq_mapping(struct mv88e6xxx_chip *chip, int port)
+{
+	return irq_find_mapping(chip->g2_irq.domain, port);
+}
+
 int mv88e6390_serdes_irq_setup(struct mv88e6xxx_chip *chip, int port)
 {
+	unsigned int irq;
 	int err;
 	u8 lane;
 
@@ -685,11 +698,12 @@ int mv88e6390_serdes_irq_setup(struct mv88e6xxx_chip *chip, int port)
 		return err;
 	}
 
-	chip->ports[port].serdes_irq = irq_find_mapping(chip->g2_irq.domain,
-							port);
-	if (!chip->ports[port].serdes_irq)
+	irq = mv88e6xxx_serdes_irq_mapping(chip, port);
+	if (!irq)
 		return 0;
 
+	chip->ports[port].serdes_irq = irq;
+
 	/* Requesting the IRQ will trigger irq callbacks. So we cannot
 	 * hold the reg_lock.
 	 */
diff --git a/drivers/net/dsa/mv88e6xxx/serdes.h b/drivers/net/dsa/mv88e6xxx/serdes.h
index c2e6fc3ddf8b..cb8d287c9388 100644
--- a/drivers/net/dsa/mv88e6xxx/serdes.h
+++ b/drivers/net/dsa/mv88e6xxx/serdes.h
@@ -90,6 +90,10 @@ static inline int mv88e6xxx_serdes_get_lane(struct mv88e6xxx_chip *chip,
 int mv88e6341_serdes_get_lane(struct mv88e6xxx_chip *chip, int port, u8 *lane);
 int mv88e6390_serdes_get_lane(struct mv88e6xxx_chip *chip, int port, u8 *lane);
 int mv88e6390x_serdes_get_lane(struct mv88e6xxx_chip *chip, int port, u8 *lane);
+unsigned int mv88e6352_serdes_irq_mapping(struct mv88e6xxx_chip *chip,
+					  int port);
+unsigned int mv88e6390_serdes_irq_mapping(struct mv88e6xxx_chip *chip,
+					  int port);
 int mv88e6352_serdes_power(struct mv88e6xxx_chip *chip, int port, bool on);
 int mv88e6390_serdes_power(struct mv88e6xxx_chip *chip, int port, bool on);
 int mv88e6390_serdes_irq_setup(struct mv88e6xxx_chip *chip, int port);
@@ -106,5 +110,13 @@ int mv88e6390_serdes_irq_disable(struct mv88e6xxx_chip *chip, int port,
 int mv88e6352_serdes_irq_setup(struct mv88e6xxx_chip *chip, int port);
 void mv88e6352_serdes_irq_free(struct mv88e6xxx_chip *chip, int port);
 
+static inline unsigned int
+mv88e6xxx_serdes_irq_mapping(struct mv88e6xxx_chip *chip, int port)
+{
+	if (!chip->info->ops->serdes_irq_mapping)
+		return 0;
+
+	return chip->info->ops->serdes_irq_mapping(chip, port);
+}
 
 #endif
-- 
2.23.0

