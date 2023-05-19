Return-Path: <netdev+bounces-3930-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 91E2170993D
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 16:15:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7649E1C212BE
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 14:15:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3F161119D;
	Fri, 19 May 2023 14:13:15 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D422011C8B
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 14:13:15 +0000 (UTC)
Received: from relay4-d.mail.gandi.net (relay4-d.mail.gandi.net [217.70.183.196])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6039312C;
	Fri, 19 May 2023 07:13:13 -0700 (PDT)
Received: (Authenticated sender: alexis.lothore@bootlin.com)
	by mail.gandi.net (Postfix) with ESMTPSA id 7C022E0004;
	Fri, 19 May 2023 14:13:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
	t=1684505592;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+pTZBh4+ZRBlZb4kygGnhcmsOQohHM/7lyy4o5VBhtc=;
	b=VMGIdgCi44uU+239PmKYr3hORa6blm2Sw0Jfh58S3ybM2XtaCYH2LcWaKdiocMO9iv0PrG
	c47UrQC4zi1D7b22yRPaveCOwSGl7d8GI6OP39pzKa+PHE5t4K+O81oQsDXD7Tj4rIYOko
	Q8R7mYKMjPFISfWn77kUDVO2CkV/zmTCmcaJN9ZU8AdblWuScJ4UhQv31rgI34J64nfIrd
	gm7/IPYQCNXHjRteibT71pJIYxtFHuY21pTWTxS8wnyL2phD67vJRH8vI4xPoIDVejWINk
	tO4ovUl6uVkeDAHJ014SetNThJWq1MJT+YMUakikoGJoc/8rZfxB/dgYweZGRg==
From: alexis.lothore@bootlin.com
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
Cc: netdev@vger.kernel.org,
	devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	thomas.petazzoni@bootlin.com,
	paul.arola@telus.com,
	scott.roberts@telus.com,
	=?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
	=?UTF-8?q?Alexis=20Lothor=C3=A9?= <alexis.lothore@bootlin.com>
Subject: [PATCH net-next v2 7/7] net: dsa: mv88e6xxx: enable support for 88E6361 switch
Date: Fri, 19 May 2023 16:13:03 +0200
Message-Id: <20230519141303.245235-8-alexis.lothore@bootlin.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230519141303.245235-1-alexis.lothore@bootlin.com>
References: <20230519141303.245235-1-alexis.lothore@bootlin.com>
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
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Alexis Lothoré <alexis.lothore@bootlin.com>

Marvell 88E6361 is an 8-port switch derived from the
88E6393X/88E9193X/88E6191X switches family. It can benefit from the
existing mv88e6xxx driver by simply adding the proper switch description in
the driver. Main differences with other switches from this
family are:
- 8 ports exposed (instead of 11): ports 1, 2 and 8 not available
- No 5GBase-x nor SFI/USXGMII support

---
Changes since v1:
- define internal phys offset
- enforce 88e6361 features in mv88e6393x_phylink_get_caps
- enforce 88e6361 features in mv88e6393x_port_set_speed_duplex
- enforce 88e6361 features in mv88e6393x_port_max_speed_mode

Signed-off-by: Alexis Lothoré <alexis.lothore@bootlin.com>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 42 ++++++++++++++++++++++++++++----
 drivers/net/dsa/mv88e6xxx/chip.h |  3 ++-
 drivers/net/dsa/mv88e6xxx/port.c | 11 ++++++++-
 drivers/net/dsa/mv88e6xxx/port.h |  1 +
 4 files changed, 50 insertions(+), 7 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 0e6267193ac1..7c77b4b634f9 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -790,6 +790,8 @@ static void mv88e6393x_phylink_get_caps(struct mv88e6xxx_chip *chip, int port,
 	unsigned long *supported = config->supported_interfaces;
 	bool is_6191x =
 		chip->info->prod_num == MV88E6XXX_PORT_SWITCH_ID_PROD_6191X;
+	bool is_6361 =
+		chip->info->prod_num == MV88E6XXX_PORT_SWITCH_ID_PROD_6361;
 
 	mv88e6xxx_translate_cmode(chip->ports[port].cmode, supported);
 
@@ -804,13 +806,17 @@ static void mv88e6393x_phylink_get_caps(struct mv88e6xxx_chip *chip, int port,
 		/* 6191X supports >1G modes only on port 10 */
 		if (!is_6191x || port == 10) {
 			__set_bit(PHY_INTERFACE_MODE_2500BASEX, supported);
-			__set_bit(PHY_INTERFACE_MODE_5GBASER, supported);
-			__set_bit(PHY_INTERFACE_MODE_10GBASER, supported);
+			config->mac_capabilities |= MAC_2500FD;
+
+			/* 6361 only supports up to 2500BaseX */
+			if (!is_6361) {
+				__set_bit(PHY_INTERFACE_MODE_5GBASER, supported);
+				__set_bit(PHY_INTERFACE_MODE_10GBASER, supported);
+				config->mac_capabilities |= MAC_5000FD |
+					MAC_10000FD;
+			}
 			/* FIXME: USXGMII is not supported yet */
 			/* __set_bit(PHY_INTERFACE_MODE_USXGMII, supported); */
-
-			config->mac_capabilities |= MAC_2500FD | MAC_5000FD |
-				MAC_10000FD;
 		}
 	}
 
@@ -6311,6 +6317,32 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.ptp_support = true,
 		.ops = &mv88e6352_ops,
 	},
+	[MV88E6361] = {
+		.prod_num = MV88E6XXX_PORT_SWITCH_ID_PROD_6361,
+		.family = MV88E6XXX_FAMILY_6393,
+		.name = "Marvell 88E6361",
+		.num_databases = 4096,
+		.num_macs = 16384,
+		.num_ports = 11,
+		/* Ports 1, 2 and 8 are not routed */
+		.invalid_port_mask = BIT(1) | BIT(2) | BIT(8),
+		.num_internal_phys = 5,
+		.internal_phys_offset = 3,
+		.max_vid = 4095,
+		.max_sid = 63,
+		.port_base_addr = 0x0,
+		.phy_base_addr = 0x0,
+		.global1_addr = 0x1b,
+		.global2_addr = 0x1c,
+		.age_time_coeff = 3750,
+		.g1_irqs = 10,
+		.g2_irqs = 14,
+		.atu_move_port_mask = 0x1f,
+		.pvt = true,
+		.multi_chip = true,
+		.ptp_support = true,
+		.ops = &mv88e6393x_ops,
+	},
 	[MV88E6390] = {
 		.prod_num = MV88E6XXX_PORT_SWITCH_ID_PROD_6390,
 		.family = MV88E6XXX_FAMILY_6390,
diff --git a/drivers/net/dsa/mv88e6xxx/chip.h b/drivers/net/dsa/mv88e6xxx/chip.h
index dd7c8880e987..79c06ba42c54 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.h
+++ b/drivers/net/dsa/mv88e6xxx/chip.h
@@ -82,6 +82,7 @@ enum mv88e6xxx_model {
 	MV88E6350,
 	MV88E6351,
 	MV88E6352,
+	MV88E6361,
 	MV88E6390,
 	MV88E6390X,
 	MV88E6393X,
@@ -100,7 +101,7 @@ enum mv88e6xxx_family {
 	MV88E6XXX_FAMILY_6351,	/* 6171 6175 6350 6351 */
 	MV88E6XXX_FAMILY_6352,	/* 6172 6176 6240 6352 */
 	MV88E6XXX_FAMILY_6390,  /* 6190 6190X 6191 6290 6390 6390X */
-	MV88E6XXX_FAMILY_6393,	/* 6191X 6193X 6393X */
+	MV88E6XXX_FAMILY_6393,	/* 6191X 6193X 6361 6393X */
 };
 
 /**
diff --git a/drivers/net/dsa/mv88e6xxx/port.c b/drivers/net/dsa/mv88e6xxx/port.c
index 66f1b40b4e96..e72ea3c8092f 100644
--- a/drivers/net/dsa/mv88e6xxx/port.c
+++ b/drivers/net/dsa/mv88e6xxx/port.c
@@ -421,9 +421,14 @@ phy_interface_t mv88e6390x_port_max_speed_mode(struct mv88e6xxx_chip *chip,
 int mv88e6393x_port_set_speed_duplex(struct mv88e6xxx_chip *chip, int port,
 				     int speed, int duplex)
 {
+	bool is_6361 =
+		chip->info->prod_num == MV88E6XXX_PORT_SWITCH_ID_PROD_6361;
 	u16 reg, ctrl;
 	int err;
 
+	if (is_6361 && speed > 2500)
+		return -EOPNOTSUPP;
+
 	if (speed == 200 && port != 0)
 		return -EOPNOTSUPP;
 
@@ -506,8 +511,12 @@ int mv88e6393x_port_set_speed_duplex(struct mv88e6xxx_chip *chip, int port,
 phy_interface_t mv88e6393x_port_max_speed_mode(struct mv88e6xxx_chip *chip,
 					       int port)
 {
+	bool is_6361 =
+		chip->info->prod_num == MV88E6XXX_PORT_SWITCH_ID_PROD_6361;
+
 	if (port == 0 || port == 9 || port == 10)
-		return PHY_INTERFACE_MODE_10GBASER;
+		return is_6361 ? PHY_INTERFACE_MODE_2500BASEX :
+			PHY_INTERFACE_MODE_10GBASER;
 
 	return PHY_INTERFACE_MODE_NA;
 }
diff --git a/drivers/net/dsa/mv88e6xxx/port.h b/drivers/net/dsa/mv88e6xxx/port.h
index 3c9fc17abdd2..56dfa9d3d4e0 100644
--- a/drivers/net/dsa/mv88e6xxx/port.h
+++ b/drivers/net/dsa/mv88e6xxx/port.h
@@ -138,6 +138,7 @@
 #define MV88E6XXX_PORT_SWITCH_ID_PROD_6141	0x3400
 #define MV88E6XXX_PORT_SWITCH_ID_PROD_6341	0x3410
 #define MV88E6XXX_PORT_SWITCH_ID_PROD_6352	0x3520
+#define MV88E6XXX_PORT_SWITCH_ID_PROD_6361	0x2610
 #define MV88E6XXX_PORT_SWITCH_ID_PROD_6350	0x3710
 #define MV88E6XXX_PORT_SWITCH_ID_PROD_6351	0x3750
 #define MV88E6XXX_PORT_SWITCH_ID_PROD_6390	0x3900
-- 
2.40.1


