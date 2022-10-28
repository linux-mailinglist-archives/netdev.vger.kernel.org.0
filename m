Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 649B46113A2
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 15:52:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229686AbiJ1Nw3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Oct 2022 09:52:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230220AbiJ1NwI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Oct 2022 09:52:08 -0400
Received: from mail-oa1-x36.google.com (mail-oa1-x36.google.com [IPv6:2001:4860:4864:20::36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3455B66122
        for <netdev@vger.kernel.org>; Fri, 28 Oct 2022 06:52:05 -0700 (PDT)
Received: by mail-oa1-x36.google.com with SMTP id 586e51a60fabf-13bd2aea61bso6401983fac.0
        for <netdev@vger.kernel.org>; Fri, 28 Oct 2022 06:52:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=/yycjx9EZfEMmLg6e9jie3OqjuhLySPHM3clyxIkHyk=;
        b=e0bEgbLsKyKPtHNUePN3190MmWMA02OCfX6Nr9pGLlBlPGCDKebz32iDCVIspgXBL4
         LOstyYieXmBHMrBtLGyYbvXxuwpCwk2aLRxpDh0Yxfw6JaFhN2QWFSm7CnAfIpzeQfpC
         n0J2ZcCpRSokgp89M3ycXLJQKNG5NveXDrWZib/o28URg1XUP5pZeGdMO4AIZGtPUKSZ
         li4y0/5rLW+dijh/8j49n6EVHJMxcJznmHKcuZHMPVejyctoqYRsf6cYlulLhqDE86/B
         +F5XZ5W/eoM1QaN91dQkW7lJYPq+hFku7hR4bUCdcyfcJY/aJ4f3PpR1SinonW6aQggf
         Fk+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/yycjx9EZfEMmLg6e9jie3OqjuhLySPHM3clyxIkHyk=;
        b=45xUuFhnXbVvP6QLBD46aQKub5N+jbQ/XNUsIpQjE0CZXnbrRGbOZHqhknU9xVc4my
         NltbBcSKLZk4Oeo7rcBCKeZTVKR2MUWtg6QHz9uxM+aXrLKTMj+L+A14Rw/+L98FpYus
         1sWa+7O2eoQ2SH95bIIPCjXKIZgbdI6e0ftspvCC4epL7JnNnv47btysQuufPNr8r9Fu
         c96i0Hf6Ajr0AFUA5SHFsK5AFFTNUsW0cYfz/6cd9BlPVxI0kTFfoM74XsgeSmbhnaZx
         gZYQGqz//InR2TeVsb+dmGPiEGPY0DW/Tja9A16C3f49oNn7tdcRD2ji+iSbO0ZlcyR7
         YxGw==
X-Gm-Message-State: ACrzQf0BmNoaVHT1OtuevxaCtxC5IPNS5K6Z5vJL9hZRl9B5vj3LYxqR
        B+MY22XDrFJajbcuXumUtsAe9kmLSpI=
X-Google-Smtp-Source: AMsMyM4UZI7XR4lWHrixKz+J2wTaZNYH/fQpes0ubAzLGLx1iXfHJsNCCQP4SXQUqKHdRsGX1H0f0w==
X-Received: by 2002:a05:6870:538d:b0:136:3cc4:78fa with SMTP id h13-20020a056870538d00b001363cc478famr9462740oan.278.1666965124436;
        Fri, 28 Oct 2022 06:52:04 -0700 (PDT)
Received: from localhost.localdomain ([2804:14c:485:4b69:4f96:b37f:e49c:a5a1])
        by smtp.gmail.com with ESMTPSA id z8-20020a056870e30800b00132f141ef2dsm2097637oad.56.2022.10.28.06.52.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Oct 2022 06:52:03 -0700 (PDT)
From:   Fabio Estevam <festevam@gmail.com>
To:     kuba@kernel.org
Cc:     davem@davemloft.net, olteanv@gmail.com, andrew@lunn.ch,
        netdev@vger.kernel.org,
        =?UTF-8?q?Steffen=20B=C3=A4tz?= <steffen@innosonix.de>,
        Fabio Estevam <festevam@denx.de>
Subject: [PATCH v2 net-next] net: dsa: mv88e6xxx: Add .port_set_rgmii_delay to 88E6320
Date:   Fri, 28 Oct 2022 10:51:48 -0300
Message-Id: <20221028135148.105691-1-festevam@gmail.com>
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

Currently, the port_set_rgmii_delay hook is missing for the 88E6320
family, which causes failure to retrieve an IP address via DHCP.

Add mv88e6320_port_set_rgmii_delay() that allows applying the RGMII
delay for ports 2, 5 and 6, which are the ports only that can be used
in RGMII mode.

Tested on a i.MX8MN board connected to an 88E6320 switch.

This change also applies safely to the 88E6321 variant.

The only difference between 88E6320 versus 88E6321 is temperature grade
and pinout.

They share exactly the same MDIO register map for ports 2,5 an 6, which
are the only ports that can be used in RGMII mode. 

Signed-off-by: Steffen Bätz <steffen@innosonix.de>
Signed-off-by: Fabio Estevam <festevam@denx.de>
---
Changes since v1:
- Improve the commit log by saying that change is also
valid for the 88E631 chip. (Andrew).

 drivers/net/dsa/mv88e6xxx/chip.c | 1 +
 drivers/net/dsa/mv88e6xxx/port.c | 9 +++++++++
 drivers/net/dsa/mv88e6xxx/port.h | 2 ++
 3 files changed, 12 insertions(+)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 2479be3a1e35..dc7cbf48bda5 100644
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
index cb04243f37c1..fe8f2085bb0b 100644
--- a/drivers/net/dsa/mv88e6xxx/port.h
+++ b/drivers/net/dsa/mv88e6xxx/port.h
@@ -336,6 +336,8 @@ int mv88e6352_port_set_rgmii_delay(struct mv88e6xxx_chip *chip, int port,
 				   phy_interface_t mode);
 int mv88e6390_port_set_rgmii_delay(struct mv88e6xxx_chip *chip, int port,
 				   phy_interface_t mode);
+int mv88e6320_port_set_rgmii_delay(struct mv88e6xxx_chip *chip, int port,
+				   phy_interface_t mode);
 
 int mv88e6xxx_port_set_link(struct mv88e6xxx_chip *chip, int port, int link);
 
-- 
2.25.1

