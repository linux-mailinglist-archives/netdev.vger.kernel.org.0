Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E712A4620
	for <lists+netdev@lfdr.de>; Sat, 31 Aug 2019 22:19:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728601AbfHaUTH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Aug 2019 16:19:07 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:35322 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728567AbfHaUTG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 31 Aug 2019 16:19:06 -0400
Received: by mail-qk1-f195.google.com with SMTP id d26so1631017qkk.2
        for <netdev@vger.kernel.org>; Sat, 31 Aug 2019 13:19:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OCovpEiLqEpcTxOziCsT6uQiQPay8Ng/0cc9GJxx8hw=;
        b=eQzVbiNilVwU+2+uiMYtXyduDVTM45VOYnsh9zJRVht+6+snLwuzrqkv4CmPQrzgmQ
         6uePSgj6FrC9GpTgSwmrPAPMPf9r06pbyBl5qXxnEJ7eDe6qP9gzw7SeK/kD8CfJobo7
         zB0gPSO0BmsabDj2de4z5GC67loJcGsAWObDjyTjGxE1aPdsJlHlfcWvdGShkqMh5RP3
         Dy7cY3FoyjE7a6syghz7xZvngvQ2/wAkqrH7mVssbAzjnYK3hnbb/BcdP1D1bTPq5W1k
         X7CSrGH5s916AVn8ZoLnZCmyrFzK97trluEnrPyzbSnJ1fX4YiOa7JcDCLPmAUXLCdyd
         cVwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OCovpEiLqEpcTxOziCsT6uQiQPay8Ng/0cc9GJxx8hw=;
        b=M2u+A+aoh8FA/CWhlWtzFYpvC7ghHylBytcmcLukGvG3I8SpbWCwLiO9Y7BDrLi9F0
         uoCBf3ECq9J1iPHddx2hiMIJcQ8zK2x0N4O+qm2asbKXnsFneyaXnEtoXDWiub1aPaSP
         R4goCxrhdr+qzpw/pdBAt0z2lsuldnqfpLNVrKYQezaVZwWlFM2PV6QWzNfuP/79bvTx
         +jGHdmtYyi9qDUWUGpwvhebuiCky1XOYHjD+10QUBYHSgbwbGfhSILRo4xRPvhyQ9sSI
         Huo/9EdrfzMZj3hGiDeaK5GHoBJrKJ12OYCRmzxmOTYesXU4N5auZLM1WU8oWveaNung
         7WGg==
X-Gm-Message-State: APjAAAV8LLXlKyJRMzl8JCz/LltuJPHUKYfwbcFvmISjXda7iXhl8QN0
        cxO9/KJlxuxfwYQsW4OFtYlJSQCs
X-Google-Smtp-Source: APXvYqxmsB1vL87O+1tfk0Hx75F2BHdHng3NR2a9IO4Np7wtu2TAO3y6sZ5MWcFz51F3F5hb/YCvfA==
X-Received: by 2002:a37:9804:: with SMTP id a4mr22259242qke.149.1567282744897;
        Sat, 31 Aug 2019 13:19:04 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id n66sm4975374qkf.89.2019.08.31.13.19.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Aug 2019 13:19:04 -0700 (PDT)
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>,
        f.fainelli@gmail.com, andrew@lunn.ch,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: [PATCH net-next 07/10] net: dsa: mv88e6xxx: pass lane to .serdes_power
Date:   Sat, 31 Aug 2019 16:18:33 -0400
Message-Id: <20190831201836.19957-8-vivien.didelot@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190831201836.19957-1-vivien.didelot@gmail.com>
References: <20190831201836.19957-1-vivien.didelot@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now the first step of all .serdes_power implementations is getting
the lane mapping. Since we have an operation for that, call it in
the wrapper and pass the lane down to the .serdes_power operation.

This also allows to avoid querying the SERDES lane twice in
mv88e6xxx_port_set_cmode.

At the same time provide mv88e6xxx_serdes_power_{up,down} helpers
and prefer up/down instead of on/off as in the documentation.

Signed-off-by: Vivien Didelot <vivien.didelot@gmail.com>
---
 drivers/net/dsa/mv88e6xxx/chip.c   |  8 +++++---
 drivers/net/dsa/mv88e6xxx/chip.h   |  3 ++-
 drivers/net/dsa/mv88e6xxx/port.c   |  4 ++--
 drivers/net/dsa/mv88e6xxx/serdes.c | 32 ++++++++++++------------------
 drivers/net/dsa/mv88e6xxx/serdes.h | 24 ++++++++++++++++++++--
 5 files changed, 44 insertions(+), 27 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 3962e7368ae5..3522b11d5566 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -2057,13 +2057,15 @@ static int mv88e6xxx_setup_egress_floods(struct mv88e6xxx_chip *chip, int port)
 static int mv88e6xxx_serdes_power(struct mv88e6xxx_chip *chip, int port,
 				  bool on)
 {
+	u8 lane;
 	int err;
 
-	if (!chip->info->ops->serdes_power)
+	lane = mv88e6xxx_serdes_get_lane(chip, port);
+	if (!lane)
 		return 0;
 
 	if (on) {
-		err = chip->info->ops->serdes_power(chip, port, true);
+		err = mv88e6xxx_serdes_power_up(chip, port, lane);
 		if (err)
 			return err;
 
@@ -2074,7 +2076,7 @@ static int mv88e6xxx_serdes_power(struct mv88e6xxx_chip *chip, int port,
 		    chip->ports[port].serdes_irq)
 			chip->info->ops->serdes_irq_free(chip, port);
 
-		err = chip->info->ops->serdes_power(chip, port, false);
+		err = mv88e6xxx_serdes_power_down(chip, port, lane);
 	}
 
 	return err;
diff --git a/drivers/net/dsa/mv88e6xxx/chip.h b/drivers/net/dsa/mv88e6xxx/chip.h
index add0ec5188ec..724ce2bf8258 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.h
+++ b/drivers/net/dsa/mv88e6xxx/chip.h
@@ -441,7 +441,8 @@ struct mv88e6xxx_ops {
 	int (*mgmt_rsvd2cpu)(struct mv88e6xxx_chip *chip);
 
 	/* Power on/off a SERDES interface */
-	int (*serdes_power)(struct mv88e6xxx_chip *chip, int port, bool on);
+	int (*serdes_power)(struct mv88e6xxx_chip *chip, int port, u8 lane,
+			    bool up);
 
 	/* SERDES lane mapping */
 	u8 (*serdes_get_lane)(struct mv88e6xxx_chip *chip, int port);
diff --git a/drivers/net/dsa/mv88e6xxx/port.c b/drivers/net/dsa/mv88e6xxx/port.c
index 06e2bdf6fa82..df71c08eda35 100644
--- a/drivers/net/dsa/mv88e6xxx/port.c
+++ b/drivers/net/dsa/mv88e6xxx/port.c
@@ -439,7 +439,7 @@ static int mv88e6xxx_port_set_cmode(struct mv88e6xxx_chip *chip, int port,
 				return err;
 		}
 
-		err = mv88e6390_serdes_power(chip, port, false);
+		err = mv88e6xxx_serdes_power_down(chip, port, lane);
 		if (err)
 			return err;
 	}
@@ -464,7 +464,7 @@ static int mv88e6xxx_port_set_cmode(struct mv88e6xxx_chip *chip, int port,
 		if (!lane)
 			return -ENODEV;
 
-		err = mv88e6390_serdes_power(chip, port, true);
+		err = mv88e6xxx_serdes_power_up(chip, port, lane);
 		if (err)
 			return err;
 
diff --git a/drivers/net/dsa/mv88e6xxx/serdes.c b/drivers/net/dsa/mv88e6xxx/serdes.c
index e8ad66987be9..e3ea8cca85b0 100644
--- a/drivers/net/dsa/mv88e6xxx/serdes.c
+++ b/drivers/net/dsa/mv88e6xxx/serdes.c
@@ -49,19 +49,17 @@ static int mv88e6390_serdes_write(struct mv88e6xxx_chip *chip,
 	return mv88e6xxx_phy_write(chip, lane, reg_c45, val);
 }
 
-int mv88e6352_serdes_power(struct mv88e6xxx_chip *chip, int port, bool on)
+int mv88e6352_serdes_power(struct mv88e6xxx_chip *chip, int port, u8 lane,
+			   bool up)
 {
 	u16 val, new_val;
 	int err;
 
-	if (!mv88e6xxx_serdes_get_lane(chip, port))
-		return 0;
-
 	err = mv88e6352_serdes_read(chip, MII_BMCR, &val);
 	if (err)
 		return err;
 
-	if (on)
+	if (up)
 		new_val = val & ~BMCR_PDOWN;
 	else
 		new_val = val | BMCR_PDOWN;
@@ -409,9 +407,9 @@ u8 mv88e6390x_serdes_get_lane(struct mv88e6xxx_chip *chip, int port)
 	return lane;
 }
 
-/* Set the power on/off for 10GBASE-R and 10GBASE-X4/X2 */
+/* Set power up/down for 10GBASE-R and 10GBASE-X4/X2 */
 static int mv88e6390_serdes_power_10g(struct mv88e6xxx_chip *chip, u8 lane,
-				      bool on)
+				      bool up)
 {
 	u16 val, new_val;
 	int err;
@@ -422,7 +420,7 @@ static int mv88e6390_serdes_power_10g(struct mv88e6xxx_chip *chip, u8 lane,
 	if (err)
 		return err;
 
-	if (on)
+	if (up)
 		new_val = val & ~(MV88E6390_PCS_CONTROL_1_RESET |
 				  MV88E6390_PCS_CONTROL_1_LOOPBACK |
 				  MV88E6390_PCS_CONTROL_1_PDOWN);
@@ -436,9 +434,9 @@ static int mv88e6390_serdes_power_10g(struct mv88e6xxx_chip *chip, u8 lane,
 	return err;
 }
 
-/* Set the power on/off for SGMII and 1000Base-X */
+/* Set power up/down for SGMII and 1000Base-X */
 static int mv88e6390_serdes_power_sgmii(struct mv88e6xxx_chip *chip, u8 lane,
-					bool on)
+					bool up)
 {
 	u16 val, new_val;
 	int err;
@@ -448,7 +446,7 @@ static int mv88e6390_serdes_power_sgmii(struct mv88e6xxx_chip *chip, u8 lane,
 	if (err)
 		return err;
 
-	if (on)
+	if (up)
 		new_val = val & ~(MV88E6390_SGMII_CONTROL_RESET |
 				  MV88E6390_SGMII_CONTROL_LOOPBACK |
 				  MV88E6390_SGMII_CONTROL_PDOWN);
@@ -462,23 +460,19 @@ static int mv88e6390_serdes_power_sgmii(struct mv88e6xxx_chip *chip, u8 lane,
 	return err;
 }
 
-int mv88e6390_serdes_power(struct mv88e6xxx_chip *chip, int port, bool on)
+int mv88e6390_serdes_power(struct mv88e6xxx_chip *chip, int port, u8 lane,
+			   bool up)
 {
 	u8 cmode = chip->ports[port].cmode;
-	u8 lane;
-
-	lane = mv88e6xxx_serdes_get_lane(chip, port);
-	if (!lane)
-		return 0;
 
 	switch (cmode) {
 	case MV88E6XXX_PORT_STS_CMODE_SGMII:
 	case MV88E6XXX_PORT_STS_CMODE_1000BASEX:
 	case MV88E6XXX_PORT_STS_CMODE_2500BASEX:
-		return mv88e6390_serdes_power_sgmii(chip, lane, on);
+		return mv88e6390_serdes_power_sgmii(chip, lane, up);
 	case MV88E6XXX_PORT_STS_CMODE_XAUI:
 	case MV88E6XXX_PORT_STS_CMODE_RXAUI:
-		return mv88e6390_serdes_power_10g(chip, lane, on);
+		return mv88e6390_serdes_power_10g(chip, lane, up);
 	}
 
 	return 0;
diff --git a/drivers/net/dsa/mv88e6xxx/serdes.h b/drivers/net/dsa/mv88e6xxx/serdes.h
index 7df27a0de9aa..c70023f57090 100644
--- a/drivers/net/dsa/mv88e6xxx/serdes.h
+++ b/drivers/net/dsa/mv88e6xxx/serdes.h
@@ -82,8 +82,10 @@ unsigned int mv88e6352_serdes_irq_mapping(struct mv88e6xxx_chip *chip,
 					  int port);
 unsigned int mv88e6390_serdes_irq_mapping(struct mv88e6xxx_chip *chip,
 					  int port);
-int mv88e6352_serdes_power(struct mv88e6xxx_chip *chip, int port, bool on);
-int mv88e6390_serdes_power(struct mv88e6xxx_chip *chip, int port, bool on);
+int mv88e6352_serdes_power(struct mv88e6xxx_chip *chip, int port, u8 lane,
+			   bool on);
+int mv88e6390_serdes_power(struct mv88e6xxx_chip *chip, int port, u8 lane,
+			   bool on);
 int mv88e6390_serdes_irq_setup(struct mv88e6xxx_chip *chip, int port);
 void mv88e6390_serdes_irq_free(struct mv88e6xxx_chip *chip, int port);
 int mv88e6352_serdes_get_sset_count(struct mv88e6xxx_chip *chip, int port);
@@ -108,6 +110,24 @@ static inline u8 mv88e6xxx_serdes_get_lane(struct mv88e6xxx_chip *chip,
 	return chip->info->ops->serdes_get_lane(chip, port);
 }
 
+static inline int mv88e6xxx_serdes_power_up(struct mv88e6xxx_chip *chip,
+					    int port, u8 lane)
+{
+	if (!chip->info->ops->serdes_power)
+		return -EOPNOTSUPP;
+
+	return chip->info->ops->serdes_power(chip, port, lane, true);
+}
+
+static inline int mv88e6xxx_serdes_power_down(struct mv88e6xxx_chip *chip,
+					      int port, u8 lane)
+{
+	if (!chip->info->ops->serdes_power)
+		return -EOPNOTSUPP;
+
+	return chip->info->ops->serdes_power(chip, port, lane, false);
+}
+
 static inline unsigned int
 mv88e6xxx_serdes_irq_mapping(struct mv88e6xxx_chip *chip, int port)
 {
-- 
2.23.0

