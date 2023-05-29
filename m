Return-Path: <netdev+bounces-6016-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A29F7145F1
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 10:04:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 44341280DE5
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 08:04:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0346B3D79;
	Mon, 29 May 2023 08:02:49 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7A5F6AAC
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 08:02:48 +0000 (UTC)
Received: from relay3-d.mail.gandi.net (relay3-d.mail.gandi.net [217.70.183.195])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B940E0;
	Mon, 29 May 2023 01:02:45 -0700 (PDT)
X-GND-Sasl: alexis.lothore@bootlin.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
	t=1685347364;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wPLy8gbYNUrZjATOCdFHCsb4lMos6/9mDXRS3C5jaRY=;
	b=hDPOvMJOEL+P7wtRxV4tL+n6Slr1dNc37owCWvy2bzk7bG8UrcuTPmnPU2mpR927Brn7il
	/2ADph3OrDmom/JDu3gwuETvqiYmoSsfSMlnK8Z3zao1dpFEFIm2EarZHJrI7cq6ZWD15n
	yECNMhRmYbJf2S8dLRxyqXEwUjESgZl659F1xoKO1TM5/OQxqs3x+vX5eldWD7NqcDpB4e
	mKxbfWa5VBAlzOQcImJes0xeA+BXwt1QcZF8qM6B2erGQ8NSzD4YxYPboLfxPsIOKPee39
	dVTL4LGTgTz1AZS/yZgRr9WPjNZxxf3FdNstBm1EGzCCJu94/CMI/X9UDu5lwA==
X-GND-Sasl: alexis.lothore@bootlin.com
X-GND-Sasl: alexis.lothore@bootlin.com
X-GND-Sasl: alexis.lothore@bootlin.com
X-GND-Sasl: alexis.lothore@bootlin.com
X-GND-Sasl: alexis.lothore@bootlin.com
X-GND-Sasl: alexis.lothore@bootlin.com
X-GND-Sasl: alexis.lothore@bootlin.com
X-GND-Sasl: alexis.lothore@bootlin.com
X-GND-Sasl: alexis.lothore@bootlin.com
X-GND-Sasl: alexis.lothore@bootlin.com
X-GND-Sasl: alexis.lothore@bootlin.com
X-GND-Sasl: alexis.lothore@bootlin.com
X-GND-Sasl: alexis.lothore@bootlin.com
X-GND-Sasl: alexis.lothore@bootlin.com
X-GND-Sasl: alexis.lothore@bootlin.com
X-GND-Sasl: alexis.lothore@bootlin.com
X-GND-Sasl: alexis.lothore@bootlin.com
X-GND-Sasl: alexis.lothore@bootlin.com
X-GND-Sasl: alexis.lothore@bootlin.com
Received: by mail.gandi.net (Postfix) with ESMTPSA id 808696000D;
	Mon, 29 May 2023 08:02:42 +0000 (UTC)
From: =?UTF-8?q?Alexis=20Lothor=C3=A9?= <alexis.lothore@bootlin.com>
To: Andrew Lunn <andrew@lunn.ch>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Vladimir Oltean <olteanv@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Richard Cochran <richardcochran@gmail.com>,
	Rob Herring <robh+dt@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Russell King <linux@armlinux.org.uk>
Cc: linux-kernel@vger.kernel.org ,
	netdev@vger.kernel.org ,
	devicetree@vger.kernel.org ,
	Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
	paul.arola@telus.com ,
	scott.roberts@telus.com ,
	=?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
	=?UTF-8?q?Alexis=20Lothor=C3=A9?= <alexis.lothore@bootlin.com>
Subject: [PATCH net-next v4 6/7] net: dsa: mv88e6xxx: pass mv88e6xxx_chip structure to port_max_speed_mode
Date: Mon, 29 May 2023 10:02:45 +0200
Message-Id: <20230529080246.82953-7-alexis.lothore@bootlin.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230529080246.82953-1-alexis.lothore@bootlin.com>
References: <20230529080246.82953-1-alexis.lothore@bootlin.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Some switches families have minor differences on supported link speed for
ports. Instead of redefining a new port_max_speed_mode for each different
configuration, allow to pass mv88e6xxx_chip structure to allow
differentiating those chips by known chip id

Signed-off-by: Alexis Lothoré <alexis.lothore@bootlin.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
Changes since v3:
- fix SoB

Changes since v2:
- add reviewed-by tag
---
 drivers/net/dsa/mv88e6xxx/chip.c |  2 +-
 drivers/net/dsa/mv88e6xxx/chip.h |  3 ++-
 drivers/net/dsa/mv88e6xxx/port.c | 12 ++++++++----
 drivers/net/dsa/mv88e6xxx/port.h | 12 ++++++++----
 4 files changed, 19 insertions(+), 10 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index d3d861e55fe0..a2b5cac39507 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -3334,7 +3334,7 @@ static int mv88e6xxx_setup_port(struct mv88e6xxx_chip *chip, int port)
 		caps = pl_config.mac_capabilities;
 
 		if (chip->info->ops->port_max_speed_mode)
-			mode = chip->info->ops->port_max_speed_mode(port);
+			mode = chip->info->ops->port_max_speed_mode(chip, port);
 		else
 			mode = PHY_INTERFACE_MODE_NA;
 
diff --git a/drivers/net/dsa/mv88e6xxx/chip.h b/drivers/net/dsa/mv88e6xxx/chip.h
index eca51946c100..dd7c8880e987 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.h
+++ b/drivers/net/dsa/mv88e6xxx/chip.h
@@ -518,7 +518,8 @@ struct mv88e6xxx_ops {
 				     int speed, int duplex);
 
 	/* What interface mode should be used for maximum speed? */
-	phy_interface_t (*port_max_speed_mode)(int port);
+	phy_interface_t (*port_max_speed_mode)(struct mv88e6xxx_chip *chip,
+					       int port);
 
 	int (*port_tag_remap)(struct mv88e6xxx_chip *chip, int port);
 
diff --git a/drivers/net/dsa/mv88e6xxx/port.c b/drivers/net/dsa/mv88e6xxx/port.c
index f79cf716c541..66f1b40b4e96 100644
--- a/drivers/net/dsa/mv88e6xxx/port.c
+++ b/drivers/net/dsa/mv88e6xxx/port.c
@@ -342,7 +342,8 @@ int mv88e6341_port_set_speed_duplex(struct mv88e6xxx_chip *chip, int port,
 					       duplex);
 }
 
-phy_interface_t mv88e6341_port_max_speed_mode(int port)
+phy_interface_t mv88e6341_port_max_speed_mode(struct mv88e6xxx_chip *chip,
+					      int port)
 {
 	if (port == 5)
 		return PHY_INTERFACE_MODE_2500BASEX;
@@ -381,7 +382,8 @@ int mv88e6390_port_set_speed_duplex(struct mv88e6xxx_chip *chip, int port,
 					       duplex);
 }
 
-phy_interface_t mv88e6390_port_max_speed_mode(int port)
+phy_interface_t mv88e6390_port_max_speed_mode(struct mv88e6xxx_chip *chip,
+					      int port)
 {
 	if (port == 9 || port == 10)
 		return PHY_INTERFACE_MODE_2500BASEX;
@@ -403,7 +405,8 @@ int mv88e6390x_port_set_speed_duplex(struct mv88e6xxx_chip *chip, int port,
 					       duplex);
 }
 
-phy_interface_t mv88e6390x_port_max_speed_mode(int port)
+phy_interface_t mv88e6390x_port_max_speed_mode(struct mv88e6xxx_chip *chip,
+					       int port)
 {
 	if (port == 9 || port == 10)
 		return PHY_INTERFACE_MODE_XAUI;
@@ -500,7 +503,8 @@ int mv88e6393x_port_set_speed_duplex(struct mv88e6xxx_chip *chip, int port,
 	return 0;
 }
 
-phy_interface_t mv88e6393x_port_max_speed_mode(int port)
+phy_interface_t mv88e6393x_port_max_speed_mode(struct mv88e6xxx_chip *chip,
+					       int port)
 {
 	if (port == 0 || port == 9 || port == 10)
 		return PHY_INTERFACE_MODE_10GBASER;
diff --git a/drivers/net/dsa/mv88e6xxx/port.h b/drivers/net/dsa/mv88e6xxx/port.h
index d19b6303b91f..8331b9a89a15 100644
--- a/drivers/net/dsa/mv88e6xxx/port.h
+++ b/drivers/net/dsa/mv88e6xxx/port.h
@@ -359,10 +359,14 @@ int mv88e6390x_port_set_speed_duplex(struct mv88e6xxx_chip *chip, int port,
 int mv88e6393x_port_set_speed_duplex(struct mv88e6xxx_chip *chip, int port,
 				     int speed, int duplex);
 
-phy_interface_t mv88e6341_port_max_speed_mode(int port);
-phy_interface_t mv88e6390_port_max_speed_mode(int port);
-phy_interface_t mv88e6390x_port_max_speed_mode(int port);
-phy_interface_t mv88e6393x_port_max_speed_mode(int port);
+phy_interface_t mv88e6341_port_max_speed_mode(struct mv88e6xxx_chip *chip,
+					      int port);
+phy_interface_t mv88e6390_port_max_speed_mode(struct mv88e6xxx_chip *chip,
+					      int port);
+phy_interface_t mv88e6390x_port_max_speed_mode(struct mv88e6xxx_chip *chip,
+					       int port);
+phy_interface_t mv88e6393x_port_max_speed_mode(struct mv88e6xxx_chip *chip,
+					       int port);
 
 int mv88e6xxx_port_set_state(struct mv88e6xxx_chip *chip, int port, u8 state);
 
-- 
2.40.1


