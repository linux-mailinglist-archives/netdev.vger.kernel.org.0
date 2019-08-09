Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0282B88640
	for <lists+netdev@lfdr.de>; Sat, 10 Aug 2019 00:50:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729712AbfHIWu3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 18:50:29 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:38925 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729445AbfHIWu2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Aug 2019 18:50:28 -0400
Received: by mail-qt1-f195.google.com with SMTP id l9so97330000qtu.6
        for <netdev@vger.kernel.org>; Fri, 09 Aug 2019 15:50:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=njmZoSfHVkt6a6uwsEmTUOsak5SYfork3h+O2DJdGfw=;
        b=kNY2iatAZ0Qq7nR6L3sT2YS/U+2D882UY6DT4t7TuFQ4eeAU2kD2v5f3r46JWBDL5Q
         NCCb0Wm0t1Up1o/+EUVsOjRCx9RKkAIGBvC5MumffvvHSeSDsANcRo2In0jCK9y5gZuG
         aMRusOChi3j3+KpE64dzPNSc04ylw7OpIzihBx8H6tcSZe0QzqW8iAnfE+X3/dKp3bCA
         8aw32vA7hc6IHKC9fL6gYgs4ye97DuBlkj5dB184kJrrZfvDNCdrNcVMAevyvWh2FTOa
         2Pcnb5euPbMuXNV2DQZdakEGCupo76QM0wwxrxiQXFv15rchchxqZilVfkFUAqCiNjZr
         PDng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=njmZoSfHVkt6a6uwsEmTUOsak5SYfork3h+O2DJdGfw=;
        b=IHFJAV+zn2zQnjt1kX+j+ol5YR82hOoNL8fNnABMWutK33U5IeR2l9l4HDquYIIHpa
         I9b76/MeheTpqXyZuzgFbmgWCTaeUameXYonDAORCUFhntBqnY54XUvUQ8BfKPa4nu6f
         o0IcuJBglUmktjlvWVEf8PIPrvAfYx9or6k8VHc6bmaDL7UwA3HcNeLtsxJs6XcGFnnM
         ZG8+dzayxQz+5GutfhDL6/7yIE9/z3DA0gZW4tT52XktOB0VpZVmSqhXWDQqHwlFZYN8
         qGlavH/Ky0mUo4IkFK+CCssx3yOTxolqhpn8LMU5/vJKr/n/LN4zadgK/84V4gOgVvmE
         g9Dg==
X-Gm-Message-State: APjAAAWRpn4pxuWctcYFRHUgF1DlGKIW9d2K6vvGHvr4T71gzrVTQHRv
        S5H60kLS0Tk34zaOawswYHrKHprI
X-Google-Smtp-Source: APXvYqxc2DBOG4fiXuonnjxxRhEZ2veLpaEpc62BfBjjuLW/tzh9ofERtDSn1KPpdVEXElec5cXd5w==
X-Received: by 2002:a0c:b408:: with SMTP id u8mr5103017qve.181.1565391026490;
        Fri, 09 Aug 2019 15:50:26 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id f2sm1545051qkj.58.2019.08.09.15.50.25
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 09 Aug 2019 15:50:25 -0700 (PDT)
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, f.fainelli@gmail.com, andrew@lunn.ch,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: [PATCH net-next 5/7] net: dsa: mv88e6xxx: remove wait and update routines
Date:   Fri,  9 Aug 2019 18:47:57 -0400
Message-Id: <20190809224759.5743-6-vivien.didelot@gmail.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190809224759.5743-1-vivien.didelot@gmail.com>
References: <20190809224759.5743-1-vivien.didelot@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that we have proper Wait Bit and Wait Mask routines, remove the
unused mv88e6xxx_wait routine and its Global 1 and Global 2 variants.

The indirect tables such as the Device Mapping Table or Priority
Override Table make use of an Update bit to distinguish reading (0)
from writing (1) operations. After a write operation occurs, the bit
self clears right away so there's no need to wait on it. Thus keep
things simple and remove the mv88e6xxx_update helper as well.

Signed-off-by: Vivien Didelot <vivien.didelot@gmail.com>
---
 drivers/net/dsa/mv88e6xxx/chip.c            | 22 -----------
 drivers/net/dsa/mv88e6xxx/chip.h            |  3 --
 drivers/net/dsa/mv88e6xxx/global1.c         |  5 ---
 drivers/net/dsa/mv88e6xxx/global1.h         |  1 -
 drivers/net/dsa/mv88e6xxx/global2.c         | 43 ++++++++++-----------
 drivers/net/dsa/mv88e6xxx/global2.h         | 12 ------
 drivers/net/dsa/mv88e6xxx/global2_scratch.c |  3 +-
 7 files changed, 22 insertions(+), 67 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index b7e0513c675a..818a83eb2dcb 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -394,28 +394,6 @@ static void mv88e6xxx_irq_poll_free(struct mv88e6xxx_chip *chip)
 	mv88e6xxx_reg_unlock(chip);
 }
 
-int mv88e6xxx_wait(struct mv88e6xxx_chip *chip, int addr, int reg, u16 mask)
-{
-	return mv88e6xxx_wait_mask(chip, addr, reg, mask, 0x0000);
-}
-
-/* Indirect write to single pointer-data register with an Update bit */
-int mv88e6xxx_update(struct mv88e6xxx_chip *chip, int addr, int reg, u16 update)
-{
-	u16 val;
-	int err;
-
-	/* Wait until the previous operation is completed */
-	err = mv88e6xxx_wait(chip, addr, reg, BIT(15));
-	if (err)
-		return err;
-
-	/* Set the Update bit to trigger a write operation */
-	val = BIT(15) | update;
-
-	return mv88e6xxx_write(chip, addr, reg, val);
-}
-
 int mv88e6xxx_port_setup_mac(struct mv88e6xxx_chip *chip, int port, int link,
 			     int speed, int duplex, int pause,
 			     phy_interface_t mode)
diff --git a/drivers/net/dsa/mv88e6xxx/chip.h b/drivers/net/dsa/mv88e6xxx/chip.h
index 9cdb6bfead25..a406be2f5652 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.h
+++ b/drivers/net/dsa/mv88e6xxx/chip.h
@@ -590,11 +590,8 @@ int mv88e6xxx_read(struct mv88e6xxx_chip *chip, int addr, int reg, u16 *val);
 int mv88e6xxx_write(struct mv88e6xxx_chip *chip, int addr, int reg, u16 val);
 int mv88e6xxx_wait_mask(struct mv88e6xxx_chip *chip, int addr, int reg,
 			u16 mask, u16 val);
-int mv88e6xxx_update(struct mv88e6xxx_chip *chip, int addr, int reg,
-		     u16 update);
 int mv88e6xxx_wait_bit(struct mv88e6xxx_chip *chip, int addr, int reg,
 		       int bit, int val);
-int mv88e6xxx_wait(struct mv88e6xxx_chip *chip, int addr, int reg, u16 mask);
 int mv88e6xxx_port_setup_mac(struct mv88e6xxx_chip *chip, int port, int link,
 			     int speed, int duplex, int pause,
 			     phy_interface_t mode);
diff --git a/drivers/net/dsa/mv88e6xxx/global1.c b/drivers/net/dsa/mv88e6xxx/global1.c
index 5ace6490695b..25ec4c0ac589 100644
--- a/drivers/net/dsa/mv88e6xxx/global1.c
+++ b/drivers/net/dsa/mv88e6xxx/global1.c
@@ -27,11 +27,6 @@ int mv88e6xxx_g1_write(struct mv88e6xxx_chip *chip, int reg, u16 val)
 	return mv88e6xxx_write(chip, addr, reg, val);
 }
 
-int mv88e6xxx_g1_wait(struct mv88e6xxx_chip *chip, int reg, u16 mask)
-{
-	return mv88e6xxx_wait(chip, chip->info->global1_addr, reg, mask);
-}
-
 int mv88e6xxx_g1_wait_bit(struct mv88e6xxx_chip *chip, int reg, int
 			  bit, int val)
 {
diff --git a/drivers/net/dsa/mv88e6xxx/global1.h b/drivers/net/dsa/mv88e6xxx/global1.h
index ffa11749fecb..78b9ae22d18c 100644
--- a/drivers/net/dsa/mv88e6xxx/global1.h
+++ b/drivers/net/dsa/mv88e6xxx/global1.h
@@ -249,7 +249,6 @@
 
 int mv88e6xxx_g1_read(struct mv88e6xxx_chip *chip, int reg, u16 *val);
 int mv88e6xxx_g1_write(struct mv88e6xxx_chip *chip, int reg, u16 val);
-int mv88e6xxx_g1_wait(struct mv88e6xxx_chip *chip, int reg, u16 mask);
 int mv88e6xxx_g1_wait_bit(struct mv88e6xxx_chip *chip, int reg, int
 			  bit, int val);
 int mv88e6xxx_g1_wait_mask(struct mv88e6xxx_chip *chip, int reg,
diff --git a/drivers/net/dsa/mv88e6xxx/global2.c b/drivers/net/dsa/mv88e6xxx/global2.c
index b5acf45f30cb..bdbb72fc20ed 100644
--- a/drivers/net/dsa/mv88e6xxx/global2.c
+++ b/drivers/net/dsa/mv88e6xxx/global2.c
@@ -26,16 +26,6 @@ int mv88e6xxx_g2_write(struct mv88e6xxx_chip *chip, int reg, u16 val)
 	return mv88e6xxx_write(chip, chip->info->global2_addr, reg, val);
 }
 
-int mv88e6xxx_g2_update(struct mv88e6xxx_chip *chip, int reg, u16 update)
-{
-	return mv88e6xxx_update(chip, chip->info->global2_addr, reg, update);
-}
-
-int mv88e6xxx_g2_wait(struct mv88e6xxx_chip *chip, int reg, u16 mask)
-{
-	return mv88e6xxx_wait(chip, chip->info->global2_addr, reg, mask);
-}
-
 int mv88e6xxx_g2_wait_bit(struct mv88e6xxx_chip *chip, int reg, int
 			  bit, int val)
 {
@@ -130,7 +120,8 @@ int mv88e6xxx_g2_device_mapping_write(struct mv88e6xxx_chip *chip, int target,
 	 * but bit 4 is reserved on older chips, so it is safe to use.
 	 */
 
-	return mv88e6xxx_g2_update(chip, MV88E6XXX_G2_DEVICE_MAPPING, val);
+	return mv88e6xxx_g2_write(chip, MV88E6XXX_G2_DEVICE_MAPPING,
+				  MV88E6XXX_G2_DEVICE_MAPPING_UPDATE | val);
 }
 
 /* Offset 0x07: Trunk Mask Table register */
@@ -143,7 +134,8 @@ static int mv88e6xxx_g2_trunk_mask_write(struct mv88e6xxx_chip *chip, int num,
 	if (hash)
 		val |= MV88E6XXX_G2_TRUNK_MASK_HASH;
 
-	return mv88e6xxx_g2_update(chip, MV88E6XXX_G2_TRUNK_MASK, val);
+	return mv88e6xxx_g2_write(chip, MV88E6XXX_G2_TRUNK_MASK,
+				  MV88E6XXX_G2_TRUNK_MASK_UPDATE | val);
 }
 
 /* Offset 0x08: Trunk Mapping Table register */
@@ -154,7 +146,8 @@ static int mv88e6xxx_g2_trunk_mapping_write(struct mv88e6xxx_chip *chip, int id,
 	const u16 port_mask = BIT(mv88e6xxx_num_ports(chip)) - 1;
 	u16 val = (id << 11) | (map & port_mask);
 
-	return mv88e6xxx_g2_update(chip, MV88E6XXX_G2_TRUNK_MAPPING, val);
+	return mv88e6xxx_g2_write(chip, MV88E6XXX_G2_TRUNK_MAPPING,
+				  MV88E6XXX_G2_TRUNK_MAPPING_UPDATE | val);
 }
 
 int mv88e6xxx_g2_trunk_clear(struct mv88e6xxx_chip *chip)
@@ -270,7 +263,8 @@ static int mv88e6xxx_g2_switch_mac_write(struct mv88e6xxx_chip *chip,
 {
 	u16 val = (pointer << 8) | data;
 
-	return mv88e6xxx_g2_update(chip, MV88E6XXX_G2_SWITCH_MAC, val);
+	return mv88e6xxx_g2_write(chip, MV88E6XXX_G2_SWITCH_MAC,
+				  MV88E6XXX_G2_SWITCH_MAC_UPDATE | val);
 }
 
 int mv88e6xxx_g2_set_switch_mac(struct mv88e6xxx_chip *chip, u8 *addr)
@@ -293,7 +287,8 @@ static int mv88e6xxx_g2_pot_write(struct mv88e6xxx_chip *chip, int pointer,
 {
 	u16 val = (pointer << 8) | (data & 0x7);
 
-	return mv88e6xxx_g2_update(chip, MV88E6XXX_G2_PRIO_OVERRIDE, val);
+	return mv88e6xxx_g2_write(chip, MV88E6XXX_G2_PRIO_OVERRIDE,
+				  MV88E6XXX_G2_PRIO_OVERRIDE_UPDATE | val);
 }
 
 int mv88e6xxx_g2_pot_clear(struct mv88e6xxx_chip *chip)
@@ -857,12 +852,13 @@ const struct mv88e6xxx_irq_ops mv88e6250_watchdog_ops = {
 
 static int mv88e6390_watchdog_setup(struct mv88e6xxx_chip *chip)
 {
-	return mv88e6xxx_g2_update(chip, MV88E6390_G2_WDOG_CTL,
-				   MV88E6390_G2_WDOG_CTL_PTR_INT_ENABLE |
-				   MV88E6390_G2_WDOG_CTL_CUT_THROUGH |
-				   MV88E6390_G2_WDOG_CTL_QUEUE_CONTROLLER |
-				   MV88E6390_G2_WDOG_CTL_EGRESS |
-				   MV88E6390_G2_WDOG_CTL_FORCE_IRQ);
+	return mv88e6xxx_g2_write(chip, MV88E6390_G2_WDOG_CTL,
+				  MV88E6390_G2_WDOG_CTL_UPDATE |
+				  MV88E6390_G2_WDOG_CTL_PTR_INT_ENABLE |
+				  MV88E6390_G2_WDOG_CTL_CUT_THROUGH |
+				  MV88E6390_G2_WDOG_CTL_QUEUE_CONTROLLER |
+				  MV88E6390_G2_WDOG_CTL_EGRESS |
+				  MV88E6390_G2_WDOG_CTL_FORCE_IRQ);
 }
 
 static int mv88e6390_watchdog_action(struct mv88e6xxx_chip *chip, int irq)
@@ -895,8 +891,9 @@ static int mv88e6390_watchdog_action(struct mv88e6xxx_chip *chip, int irq)
 
 static void mv88e6390_watchdog_free(struct mv88e6xxx_chip *chip)
 {
-	mv88e6xxx_g2_update(chip, MV88E6390_G2_WDOG_CTL,
-			    MV88E6390_G2_WDOG_CTL_PTR_INT_ENABLE);
+	mv88e6xxx_g2_write(chip, MV88E6390_G2_WDOG_CTL,
+			   MV88E6390_G2_WDOG_CTL_UPDATE |
+			   MV88E6390_G2_WDOG_CTL_PTR_INT_ENABLE);
 }
 
 const struct mv88e6xxx_irq_ops mv88e6390_watchdog_ops = {
diff --git a/drivers/net/dsa/mv88e6xxx/global2.h b/drivers/net/dsa/mv88e6xxx/global2.h
index f5574e463a92..42da4bca73e8 100644
--- a/drivers/net/dsa/mv88e6xxx/global2.h
+++ b/drivers/net/dsa/mv88e6xxx/global2.h
@@ -295,8 +295,6 @@ static inline int mv88e6xxx_g2_require(struct mv88e6xxx_chip *chip)
 
 int mv88e6xxx_g2_read(struct mv88e6xxx_chip *chip, int reg, u16 *val);
 int mv88e6xxx_g2_write(struct mv88e6xxx_chip *chip, int reg, u16 val);
-int mv88e6xxx_g2_update(struct mv88e6xxx_chip *chip, int reg, u16 update);
-int mv88e6xxx_g2_wait(struct mv88e6xxx_chip *chip, int reg, u16 mask);
 int mv88e6xxx_g2_wait_bit(struct mv88e6xxx_chip *chip, int reg,
 			  int bit, int val);
 
@@ -378,16 +376,6 @@ static inline int mv88e6xxx_g2_write(struct mv88e6xxx_chip *chip, int reg, u16 v
 	return -EOPNOTSUPP;
 }
 
-static inline int mv88e6xxx_g2_update(struct mv88e6xxx_chip *chip, int reg, u16 update)
-{
-	return -EOPNOTSUPP;
-}
-
-static inline int mv88e6xxx_g2_wait(struct mv88e6xxx_chip *chip, int reg, u16 mask)
-{
-	return -EOPNOTSUPP;
-}
-
 static inline int mv88e6xxx_g2_wait_bit(struct mv88e6xxx_chip *chip,
 					int reg, int bit, int val)
 {
diff --git a/drivers/net/dsa/mv88e6xxx/global2_scratch.c b/drivers/net/dsa/mv88e6xxx/global2_scratch.c
index baddecadd8be..33b7b9570d29 100644
--- a/drivers/net/dsa/mv88e6xxx/global2_scratch.c
+++ b/drivers/net/dsa/mv88e6xxx/global2_scratch.c
@@ -37,7 +37,8 @@ static int mv88e6xxx_g2_scratch_write(struct mv88e6xxx_chip *chip, int reg,
 {
 	u16 value = (reg << 8) | data;
 
-	return mv88e6xxx_g2_update(chip, MV88E6XXX_G2_SCRATCH_MISC_MISC, value);
+	return mv88e6xxx_g2_write(chip, MV88E6XXX_G2_SCRATCH_MISC_MISC,
+				  MV88E6XXX_G2_SCRATCH_MISC_UPDATE | value);
 }
 
 /**
-- 
2.22.0

