Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B901A61109E
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 14:07:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230218AbiJ1MHY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Oct 2022 08:07:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230211AbiJ1MHS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Oct 2022 08:07:18 -0400
Received: from mail-oo1-xc2c.google.com (mail-oo1-xc2c.google.com [IPv6:2607:f8b0:4864:20::c2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20933D73D0
        for <netdev@vger.kernel.org>; Fri, 28 Oct 2022 05:07:16 -0700 (PDT)
Received: by mail-oo1-xc2c.google.com with SMTP id v8-20020a4ab688000000b00486ac81143fso743345ooo.1
        for <netdev@vger.kernel.org>; Fri, 28 Oct 2022 05:07:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=GR+m1s8xk4yO3whnGXXqKJGoS7xpg5Ml4xPbhb4grPw=;
        b=bVut0nFme1vyw/JHAGuzHzacbw9ymua14F6HHVu6Zo3hLxYdpcoXwuloXpuIRcFl3i
         N0vsbCxeZLmK/z9KQ5y3uTRFftInf8mX+jhF25fXAW1OoQyk6S5uw3w/3cpEXqYPywIh
         iHZfpymzPfB7CIOdq3+UebG+TuAGToAs1d29MnzcbjxcYtuzbf0AKjWyTfJKL77YF8fR
         RnGtvRh+mArBy+DuN2QPi67wHwIAwZLufSf+RXJJzRr4fjlPnJ2jCfKoTUXrOGIAnPNY
         QVTkpSXgmOnLkwwvIzZe6RCvOcyg1yA9eZMK1/C+IHZlSrNddAmYyJTXISHa8YbIYUmI
         1kQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GR+m1s8xk4yO3whnGXXqKJGoS7xpg5Ml4xPbhb4grPw=;
        b=WbMLsEYn05443QnsbMdWUl/O79tTbnToCBAFbUv3iQL+NXSmICLXebqc3isVJ/hk1j
         /Hg0qFrG0JYiAwFlKPklPGr2MOWRCN0DrfOcZSAHyeaiqYYHfKI9MUH6SN1nrVQ2l7x7
         W3Vbw/i79m4pV1+era6PngBEaysSrzefn69istDxP6G3u1p7dzgKcpBvqNoWE1iQ5YtY
         F0DVlatU+e57UL5ipaL9q7RQigmjnAsXSOkmdkCRx0n2xfzCpo4airJSIkJy3/7BZG0/
         44HLsfiRB1sQ3NyfY5Wx3VlPkzVDttvwDQISwUQXRqkHXaopRcGtCPx4azhYPjar52fD
         Y/Sw==
X-Gm-Message-State: ACrzQf1PMn0pdV+QOPDHcYEI9zGVeQNwcvdNVD1HkQbszYuWByNylsYU
        JpfIdm+3AR03efbtqIuq1Ns=
X-Google-Smtp-Source: AMsMyM4U0eZDaURASCKeo++mwpi+3ecNO+tSjbweWWAGmwB1+9gRv9+T3GcM4m9M2VMIIeqpjQik3w==
X-Received: by 2002:a05:6820:168:b0:480:fd05:4ffd with SMTP id k8-20020a056820016800b00480fd054ffdmr17659113ood.63.1666958836066;
        Fri, 28 Oct 2022 05:07:16 -0700 (PDT)
Received: from localhost.localdomain ([2804:14c:485:4b69:4f96:b37f:e49c:a5a1])
        by smtp.gmail.com with ESMTPSA id er13-20020a056870c88d00b0013669485016sm1445487oab.37.2022.10.28.05.07.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Oct 2022 05:07:15 -0700 (PDT)
From:   Fabio Estevam <festevam@gmail.com>
To:     kuba@kernel.org
Cc:     olteanv@gmail.com, andrew@lunn.ch, netdev@vger.kernel.org,
        =?UTF-8?q?Steffen=20B=C3=A4tz?= <steffen@innosonix.de>,
        Fabio Estevam <festevam@gmail.com>
Subject: [PATCH] net: dsa: mv88e6xxx: Add .port_set_rgmii_delay to 88E6320
Date:   Fri, 28 Oct 2022 09:06:54 -0300
Message-Id: <20221028120654.90508-1-festevam@gmail.com>
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

Currently, the port_set_rgmii_delay hook is missing for 88E6320, which
causes failure to retrieve an IP address via DHCP.

Add mv88e6320_port_set_rgmii_delay() that allows applying the RGMII
delay for ports 3 and 4, which are the 10/100/1000 PHYs.

Tested on a i.MX8MN board connected to a 88E6320 switch.

Signed-off-by: Steffen Bätz <steffen@innosonix.de>
Signed-off-by: Fabio Estevam <festevam@gmail.com>
---
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

