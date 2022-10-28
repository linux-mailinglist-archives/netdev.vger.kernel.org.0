Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E38F61178E
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 18:32:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229991AbiJ1QcN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Oct 2022 12:32:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229686AbiJ1QcM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Oct 2022 12:32:12 -0400
Received: from mail-oi1-x22e.google.com (mail-oi1-x22e.google.com [IPv6:2607:f8b0:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 667311C77DE
        for <netdev@vger.kernel.org>; Fri, 28 Oct 2022 09:32:11 -0700 (PDT)
Received: by mail-oi1-x22e.google.com with SMTP id y67so6692011oiy.1
        for <netdev@vger.kernel.org>; Fri, 28 Oct 2022 09:32:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=zm7L5aMJn3MDw5RXOfPSdbME1yQT4EnJl2D1CRVxl0E=;
        b=c8XnqL6iW+6ZPJGcYFSkBlkTozFzkYSYFTcGQSub5cbmUjnWSUM+nvuI95TPA1+XGq
         YNXZl/4Glk0OcK3xmuHo6u9aQm0Gi7NKCMcEVcOkoN7pkIag+rSPEALejCz4MSD0aAwB
         q5l3KqCwGPygtNw7QMc0X9Dof4D5ea1qa0Nq8CTknl1/N6AUZeVNSa15190F14lUpPwA
         twVw+2PSV+7SUpsFoqx3/cQinebMAyr7IMb2KM9ILUIl4XadAnUe0/PxRBECPfVR2Hvp
         ZdL9VCoXXXFQmWgcUnLd5qv5R/EBT5fmJ1r3mFkt9iAUouEttrDPPhdyAr+JLvXK/aBe
         RNIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zm7L5aMJn3MDw5RXOfPSdbME1yQT4EnJl2D1CRVxl0E=;
        b=yOe85w5miKR17RKHCQVLBhA2i2hHWh6EqZid1Lvxg9UQqkTYwSw7HmgRMUsxvPuXo7
         D6RXh2n+jlWOBBVVzTAjGZ0aPsMiYC/Co06fyX56u6uxTjPNb8bT87Mc/o87uYjkSY5H
         yFmYsylT/XqM1QyNUrQv8L2PM1ZxmcboDx3xcXWjAVEnSx9URtEuJ/XrJIdHYSAuWJr7
         hvqT3sPwbQkSkRaIjOgxAMEKkTORkXukNGJ0yJ/5BkCST2pyIruckr70cRQdX5TwN3he
         7Wy7jID40pVsDFOyZ9m7vwkPS4ZH0bf+/hiUgZcslxgpbCNk82PGAK80Kp/P5qd/GY7P
         Zwxg==
X-Gm-Message-State: ACrzQf2qLyhh47CrgxIzQuuUffkeHyOkWYy71wj/H4IlbF6mV62HtbmQ
        ivI3wpGmha2Zyek45iJ4I1I=
X-Google-Smtp-Source: AMsMyM6HpoNYVJTZ7xup975AyVZx+63kTXi1ms1O+Pg+OfTkyk6QNjPQN6Zc4/sOxVboE8CrfLXr1Q==
X-Received: by 2002:a54:458d:0:b0:359:a896:7581 with SMTP id z13-20020a54458d000000b00359a8967581mr183799oib.22.1666974730675;
        Fri, 28 Oct 2022 09:32:10 -0700 (PDT)
Received: from localhost.localdomain ([2804:14c:485:4b69:4f96:b37f:e49c:a5a1])
        by smtp.gmail.com with ESMTPSA id k20-20020a056870d39400b0012d6f3d370bsm2261958oag.55.2022.10.28.09.32.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Oct 2022 09:32:10 -0700 (PDT)
From:   Fabio Estevam <festevam@gmail.com>
To:     kuba@kernel.org
Cc:     davem@davemloft.net, olteanv@gmail.com, andrew@lunn.ch,
        netdev@vger.kernel.org,
        =?UTF-8?q?Steffen=20B=C3=A4tz?= <steffen@innosonix.de>,
        Fabio Estevam <festevam@denx.de>
Subject: [PATCH v3 net-next] net: dsa: mv88e6xxx: Add RGMII delay to 88E6320
Date:   Fri, 28 Oct 2022 13:31:58 -0300
Message-Id: <20221028163158.198108-1-festevam@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Steffen Bätz <steffen@innosonix.de>

Currently, the .port_set_rgmii_delay hook is missing for the 88E6320
family, which causes failure to retrieve an IP address via DHCP.

Add mv88e6320_port_set_rgmii_delay() that allows applying the RGMII
delay for ports 2, 5, and 6, which are the only ports that can be used
in RGMII mode.

Tested on a custom i.MX8MN board connected to an 88E6320 switch.

This change also applies safely to the 88E6321 variant.

The only difference between 88E6320 versus 88E6321 is the temperature
grade and pinout.

They share exactly the same MDIO register map for ports 2, 5, and 6,
which are the only ports that can be used in RGMII mode.

Signed-off-by: Steffen Bätz <steffen@innosonix.de>
[fabio: Improved commit log and extended it to mv88e6321_ops]
Signed-off-by: Fabio Estevam <festevam@denx.de>
---
Changes since v2:
- Add .port_set_rgmii_delay to mv88e6321_ops as well (Andrew).
Changes since v1:
- Improve the commit log by saying that change is also
valid for the 88E631 chip. (Andrew).

 drivers/net/dsa/mv88e6xxx/chip.c | 2 ++
 drivers/net/dsa/mv88e6xxx/port.c | 9 +++++++++
 drivers/net/dsa/mv88e6xxx/port.h | 2 ++
 3 files changed, 13 insertions(+)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 2479be3a1e35..bf34c942db99 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -5029,6 +5029,7 @@ static const struct mv88e6xxx_ops mv88e6320_ops = {
 	.phy_write = mv88e6xxx_g2_smi_phy_write,
 	.port_set_link = mv88e6xxx_port_set_link,
 	.port_sync_link = mv88e6xxx_port_sync_link,
+	.port_set_rgmii_delay = mv88e6320_port_set_rgmii_delay,
 	.port_set_speed_duplex = mv88e6185_port_set_speed_duplex,
 	.port_tag_remap = mv88e6095_port_tag_remap,
 	.port_set_frame_mode = mv88e6351_port_set_frame_mode,
@@ -5073,6 +5074,7 @@ static const struct mv88e6xxx_ops mv88e6321_ops = {
 	.phy_write = mv88e6xxx_g2_smi_phy_write,
 	.port_set_link = mv88e6xxx_port_set_link,
 	.port_sync_link = mv88e6xxx_port_sync_link,
+	.port_set_rgmii_delay = mv88e6320_port_set_rgmii_delay,
 	.port_set_speed_duplex = mv88e6185_port_set_speed_duplex,
 	.port_tag_remap = mv88e6095_port_tag_remap,
 	.port_set_frame_mode = mv88e6351_port_set_frame_mode,
diff --git a/drivers/net/dsa/mv88e6xxx/port.c b/drivers/net/dsa/mv88e6xxx/port.c
index 5c4195c635b0..f79cf716c541 100644
--- a/drivers/net/dsa/mv88e6xxx/port.c
+++ b/drivers/net/dsa/mv88e6xxx/port.c
@@ -133,6 +133,15 @@ int mv88e6390_port_set_rgmii_delay(struct mv88e6xxx_chip *chip, int port,
 	return mv88e6xxx_port_set_rgmii_delay(chip, port, mode);
 }
 
+int mv88e6320_port_set_rgmii_delay(struct mv88e6xxx_chip *chip, int port,
+				   phy_interface_t mode)
+{
+	if (port != 2 && port != 5 && port != 6)
+		return -EOPNOTSUPP;
+
+	return mv88e6xxx_port_set_rgmii_delay(chip, port, mode);
+}
+
 int mv88e6xxx_port_set_link(struct mv88e6xxx_chip *chip, int port, int link)
 {
 	u16 reg;
diff --git a/drivers/net/dsa/mv88e6xxx/port.h b/drivers/net/dsa/mv88e6xxx/port.h
index cb04243f37c1..aec9d4fd20e3 100644
--- a/drivers/net/dsa/mv88e6xxx/port.h
+++ b/drivers/net/dsa/mv88e6xxx/port.h
@@ -332,6 +332,8 @@ int mv88e6xxx_port_wait_bit(struct mv88e6xxx_chip *chip, int port, int reg,
 
 int mv88e6185_port_set_pause(struct mv88e6xxx_chip *chip, int port,
 			     int pause);
+int mv88e6320_port_set_rgmii_delay(struct mv88e6xxx_chip *chip, int port,
+				   phy_interface_t mode);
 int mv88e6352_port_set_rgmii_delay(struct mv88e6xxx_chip *chip, int port,
 				   phy_interface_t mode);
 int mv88e6390_port_set_rgmii_delay(struct mv88e6xxx_chip *chip, int port,
-- 
2.25.1

