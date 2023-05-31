Return-Path: <netdev+bounces-6674-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 07BE171765E
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 07:50:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 984231C20D09
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 05:50:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 114944C66;
	Wed, 31 May 2023 05:50:18 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2ECA2103
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 05:50:17 +0000 (UTC)
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10EC611C
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 22:50:16 -0700 (PDT)
Received: by mail-io1-xd33.google.com with SMTP id ca18e2360f4ac-77487fc1f16so376505139f.0
        for <netdev@vger.kernel.org>; Tue, 30 May 2023 22:50:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685512215; x=1688104215;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=VrOgpR5X1OX4A8M0LrCgcJmJYoNUal7sHmMz47cg/2U=;
        b=SRtv10iml8SdNFhghXskMT4iYF+9dBv715GFxD6xsqBWdkQV36tYMP5++zjyXuCZeq
         Uqk3pq26AVoOFJ3AxNZMD4hnkRG4YNIbYx8gaEwyqCWAaLnVdDTICi0q5wU/eXl7Viw+
         S5qU1n6O6NdEYaYq8EnchqHF57ZsQe4KsbanptaBMVmLsPbKUWMAiz14e0pz6JKAmyq3
         xXrAhHXDiuBXv5uSAo9Cfiixfem0fXK4Um7idRxImhn3Uox/Uoe4nnHnd7COhwEkAqsL
         r1iqkxyOr5JMbMD8APGzKKPA6Ci1uh+qKB3cpU1xu/kTACNG+LVFHyc+NSIleiTS+ZBB
         IjPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685512215; x=1688104215;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VrOgpR5X1OX4A8M0LrCgcJmJYoNUal7sHmMz47cg/2U=;
        b=VL90iIz10oxTAtqoHn17Su0/mfzrG6qJrhyA0OfqYyJmhdS7VDSXGeQABS77Bxod+B
         jbXQ+7vRybZ2XG5+aC5XMBhDBf33sUlccQLu0/ocxtGN2Q/BoWCX1Lz4BsxojX3jgiIJ
         4klpjzyH4Xxa+faozULfJ3+iEEyeThhoVU9oQnvr1VtSFLH3pe9lRZmej3AgFFTYgbTm
         luOaQs+4q1C3aITAbwLzvE+Xd+AoRiu+/h8LVcanpmmC9GSo/Qwpgpv5v+KdPCMc7GFt
         WoWmVsIIFHs9Mfivnon+yGrItmW76CDaVmXQ7ZnDKYAdKtmof//qXeWHbnEX94jZASSk
         kV4A==
X-Gm-Message-State: AC+VfDybLTSTfsq9xZvilfsnuW6Aw4RENfyC2qR9soZgYZC3nEp8n9GR
	JeZGRoIArI2MS3ZnenvcjlHzPTjW1uI=
X-Google-Smtp-Source: ACHHUZ6uWmuLtq2UXIEhntQvKJjX+3uhITF8cPXObUHEdtrgfr1w7hJUms6+9mXimV3RosqgOHgjaA==
X-Received: by 2002:a92:c048:0:b0:335:7a0a:3cd7 with SMTP id o8-20020a92c048000000b003357a0a3cd7mr1632255ilf.11.1685512215204;
        Tue, 30 May 2023 22:50:15 -0700 (PDT)
Received: from babbage.. (162-227-164-7.lightspeed.sntcca.sbcglobal.net. [162.227.164.7])
        by smtp.gmail.com with ESMTPSA id n3-20020a170902e54300b001ae268978cfsm319418plf.259.2023.05.30.22.50.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 May 2023 22:50:14 -0700 (PDT)
From: Michal Smulski <msmulski2@gmail.com>
X-Google-Original-From: Michal Smulski <michal.smulski@ooma.com>
To: andrew@lunn.ch
Cc: f.fainelli@gmail.com,
	olteanv@gmail.com,
	netdev@vger.kernel.org,
	Michal Smulski <michal.smulski@ooma.com>
Subject: [PATCH net-next v3] net: dsa: mv88e6xxx: implement USXGMII mode for mv88e6393x
Date: Tue, 30 May 2023 22:50:10 -0700
Message-Id: <20230531055010.990-1-michal.smulski@ooma.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
	FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Enable USXGMII mode for mv88e6393x chips. Tested on Marvell 88E6191X.

Signed-off-by: Michal Smulski <michal.smulski@ooma.com>
---
 drivers/net/dsa/mv88e6xxx/chip.c   |  3 +-
 drivers/net/dsa/mv88e6xxx/port.c   |  3 ++
 drivers/net/dsa/mv88e6xxx/serdes.c | 70 +++++++++++++++++++++++++++++-
 drivers/net/dsa/mv88e6xxx/serdes.h | 13 ++++++
 4 files changed, 85 insertions(+), 4 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 5bbe95fa951c..71cee154622f 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -806,8 +806,7 @@ static void mv88e6393x_phylink_get_caps(struct mv88e6xxx_chip *chip, int port,
 			__set_bit(PHY_INTERFACE_MODE_2500BASEX, supported);
 			__set_bit(PHY_INTERFACE_MODE_5GBASER, supported);
 			__set_bit(PHY_INTERFACE_MODE_10GBASER, supported);
-			/* FIXME: USXGMII is not supported yet */
-			/* __set_bit(PHY_INTERFACE_MODE_USXGMII, supported); */
+			__set_bit(PHY_INTERFACE_MODE_USXGMII, supported);
 
 			config->mac_capabilities |= MAC_2500FD | MAC_5000FD |
 				MAC_10000FD;
diff --git a/drivers/net/dsa/mv88e6xxx/port.c b/drivers/net/dsa/mv88e6xxx/port.c
index f79cf716c541..8daeeeb66880 100644
--- a/drivers/net/dsa/mv88e6xxx/port.c
+++ b/drivers/net/dsa/mv88e6xxx/port.c
@@ -554,6 +554,9 @@ static int mv88e6xxx_port_set_cmode(struct mv88e6xxx_chip *chip, int port,
 	case PHY_INTERFACE_MODE_10GBASER:
 		cmode = MV88E6393X_PORT_STS_CMODE_10GBASER;
 		break;
+	case PHY_INTERFACE_MODE_USXGMII:
+		cmode = MV88E6393X_PORT_STS_CMODE_USXGMII;
+		break;
 	default:
 		cmode = 0;
 	}
diff --git a/drivers/net/dsa/mv88e6xxx/serdes.c b/drivers/net/dsa/mv88e6xxx/serdes.c
index 72faec8f44dc..3c6d22506b47 100644
--- a/drivers/net/dsa/mv88e6xxx/serdes.c
+++ b/drivers/net/dsa/mv88e6xxx/serdes.c
@@ -683,7 +683,8 @@ int mv88e6393x_serdes_get_lane(struct mv88e6xxx_chip *chip, int port)
 	    cmode == MV88E6XXX_PORT_STS_CMODE_SGMII ||
 	    cmode == MV88E6XXX_PORT_STS_CMODE_2500BASEX ||
 	    cmode == MV88E6393X_PORT_STS_CMODE_5GBASER ||
-	    cmode == MV88E6393X_PORT_STS_CMODE_10GBASER)
+	    cmode == MV88E6393X_PORT_STS_CMODE_10GBASER ||
+	    cmode == MV88E6393X_PORT_STS_CMODE_USXGMII)
 		lane = port;
 
 	return lane;
@@ -984,6 +985,64 @@ static int mv88e6393x_serdes_pcs_get_state_10g(struct mv88e6xxx_chip *chip,
 			state->speed = SPEED_10000;
 		state->duplex = DUPLEX_FULL;
 	}
+	return 0;
+}
+
+/* USXGMII registers for Marvell switch 88e639x are undocumented and this function is based
+ * on some educated guesses. There does not seem to bit status bit related to
+ * autonegotion complete or flow control.
+ */
+static int mv88e639x_serdes_pcs_get_state_usxgmii(struct mv88e6xxx_chip *chip,
+						  int port, int lane,
+						  struct phylink_link_state *state)
+{
+	u16 status, lp_status;
+	int err;
+
+	err = mv88e6390_serdes_read(chip, lane, MDIO_MMD_PHYXS,
+				    MV88E6390_USXGMII_LP_STATUS, &lp_status);
+	if (err) {
+		dev_err(chip->dev, "can't read Serdes USXGMII LP status: %d\n", err);
+		return err;
+	}
+	dev_dbg(chip->dev, "USXGMII LP statsus: 0x%x\n", lp_status);
+
+	err = mv88e6390_serdes_read(chip, lane, MDIO_MMD_PHYXS,
+				    MV88E6390_USXGMII_PHY_STATUS, &status);
+	if (err) {
+		dev_err(chip->dev, "can't read Serdes USXGMII PHY status: %d\n", err);
+		return err;
+	}
+	dev_dbg(chip->dev, "USXGMII PHY statsus: 0x%x\n", status);
+
+	state->link = !!(status & MV88E6390_USXGMII_PHY_STATUS_LINK);
+	state->duplex = status &
+		MV88E6390_USXGMII_PHY_STATUS_DUPLEX_FULL ?
+		DUPLEX_FULL : DUPLEX_HALF;
+
+	switch (status & MV88E6390_USXGMII_PHY_STATUS_SPEED_MASK) {
+	case MV88E6390_USXGMII_PHY_STATUS_SPEED_10000:
+		state->speed = SPEED_10000;
+		break;
+	case MV88E6390_USXGMII_PHY_STATUS_SPEED_5000:
+		state->speed = SPEED_5000;
+		break;
+	case MV88E6390_USXGMII_PHY_STATUS_SPEED_2500:
+		state->speed = SPEED_2500;
+		break;
+	case MV88E6390_USXGMII_PHY_STATUS_SPEED_1000:
+		state->speed = SPEED_1000;
+		break;
+	case MV88E6390_USXGMII_PHY_STATUS_SPEED_100:
+		state->speed = SPEED_100;
+		break;
+	case MV88E6390_USXGMII_PHY_STATUS_SPEED_10:
+		state->speed = SPEED_10;
+		break;
+	default:
+		dev_err(chip->dev, "invalid PHY speed\n");
+		return -EINVAL;
+	}
 
 	return 0;
 }
@@ -1020,6 +1079,9 @@ int mv88e6393x_serdes_pcs_get_state(struct mv88e6xxx_chip *chip, int port,
 	case PHY_INTERFACE_MODE_10GBASER:
 		return mv88e6393x_serdes_pcs_get_state_10g(chip, port, lane,
 							   state);
+	case PHY_INTERFACE_MODE_USXGMII:
+		return mv88e639x_serdes_pcs_get_state_usxgmii(chip, port, lane,
+							   state);
 
 	default:
 		return -EOPNOTSUPP;
@@ -1173,6 +1235,7 @@ int mv88e6393x_serdes_irq_enable(struct mv88e6xxx_chip *chip, int port,
 		return mv88e6390_serdes_irq_enable_sgmii(chip, lane, enable);
 	case MV88E6393X_PORT_STS_CMODE_5GBASER:
 	case MV88E6393X_PORT_STS_CMODE_10GBASER:
+	case MV88E6393X_PORT_STS_CMODE_USXGMII:
 		return mv88e6393x_serdes_irq_enable_10g(chip, lane, enable);
 	}
 
@@ -1213,6 +1276,7 @@ irqreturn_t mv88e6393x_serdes_irq_status(struct mv88e6xxx_chip *chip, int port,
 		break;
 	case MV88E6393X_PORT_STS_CMODE_5GBASER:
 	case MV88E6393X_PORT_STS_CMODE_10GBASER:
+	case MV88E6393X_PORT_STS_CMODE_USXGMII:
 		err = mv88e6393x_serdes_irq_status_10g(chip, lane, &status);
 		if (err)
 			return err;
@@ -1477,7 +1541,8 @@ static int mv88e6393x_serdes_erratum_5_2(struct mv88e6xxx_chip *chip, int lane,
 	 * to SERDES operating in 10G mode. These registers only apply to 10G
 	 * operation and have no effect on other speeds.
 	 */
-	if (cmode != MV88E6393X_PORT_STS_CMODE_10GBASER)
+	if (cmode != MV88E6393X_PORT_STS_CMODE_10GBASER &&
+	    cmode != MV88E6393X_PORT_STS_CMODE_USXGMII)
 		return 0;
 
 	for (i = 0; i < ARRAY_SIZE(fixes); ++i) {
@@ -1582,6 +1647,7 @@ int mv88e6393x_serdes_power(struct mv88e6xxx_chip *chip, int port, int lane,
 		break;
 	case MV88E6393X_PORT_STS_CMODE_5GBASER:
 	case MV88E6393X_PORT_STS_CMODE_10GBASER:
+	case MV88E6393X_PORT_STS_CMODE_USXGMII:
 		err = mv88e6390_serdes_power_10g(chip, lane, on);
 		break;
 	default:
diff --git a/drivers/net/dsa/mv88e6xxx/serdes.h b/drivers/net/dsa/mv88e6xxx/serdes.h
index 29bb4e91e2f6..899b8518113a 100644
--- a/drivers/net/dsa/mv88e6xxx/serdes.h
+++ b/drivers/net/dsa/mv88e6xxx/serdes.h
@@ -48,6 +48,19 @@
 #define MV88E6393X_10G_INT_LINK_CHANGE	BIT(2)
 #define MV88E6393X_10G_INT_STATUS	0x9001
 
+/* USXGMII */
+#define MV88E6390_USXGMII_LP_STATUS       0xf0a2
+#define MV88E6390_USXGMII_PHY_STATUS      0xf0a6
+#define MV88E6390_USXGMII_PHY_STATUS_SPEED_MASK	GENMASK(11, 9)
+#define MV88E6390_USXGMII_PHY_STATUS_SPEED_5000	0xa00
+#define MV88E6390_USXGMII_PHY_STATUS_SPEED_2500	0x800
+#define MV88E6390_USXGMII_PHY_STATUS_SPEED_10000	0x600
+#define MV88E6390_USXGMII_PHY_STATUS_SPEED_1000	0x400
+#define MV88E6390_USXGMII_PHY_STATUS_SPEED_100	0x200
+#define MV88E6390_USXGMII_PHY_STATUS_SPEED_10	0x000
+#define MV88E6390_USXGMII_PHY_STATUS_DUPLEX_FULL	BIT(12)
+#define MV88E6390_USXGMII_PHY_STATUS_LINK		BIT(15)
+
 /* 1000BASE-X and SGMII */
 #define MV88E6390_SGMII_BMCR		(0x2000 + MII_BMCR)
 #define MV88E6390_SGMII_BMSR		(0x2000 + MII_BMSR)
-- 
2.34.1


