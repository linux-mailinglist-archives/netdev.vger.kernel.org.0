Return-Path: <netdev+bounces-6878-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 21D907188C5
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 19:48:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AFF921C20EF3
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 17:48:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E7A0518AE8;
	Wed, 31 May 2023 17:48:01 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCEC617736
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 17:48:01 +0000 (UTC)
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE30B125
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 10:47:59 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id 98e67ed59e1d1-256e1d87998so1433565a91.3
        for <netdev@vger.kernel.org>; Wed, 31 May 2023 10:47:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685555279; x=1688147279;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ajIyFu2x37mehVVsEJFolcxAi/OAEIlKCYgc+FYe4Ns=;
        b=e5q01iDs0rSEjv74g6BXy5wMIEAp77OhP4DB6hYO+8n8aa8yuGwvKSH+CQHF5ghy1A
         Z02J8Bjc2FfVplguFDFzi5g2SnAgSwf5eAjjv2CgugWpU8CftXjSSp9ysLZFAtelKQRH
         ARFiV29x6nn64Gu0yXnOrSscBf+LKfC2ZCGc8YBJB2FrZDRx0LGllQThg07QZDNJYisz
         JGpLBocXVOwE220uEZr4+5w5NXlizuDoBlUQVSjqc9ZQQE5Kjo6Xbu6a1dYJ4SppyiNx
         f5yS/1pTB39lcWulHZVOf+/k7rYzzuSfADhn8V3YWJeJi5jHeL8V64N67+KTGrO52Lb6
         1mMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685555279; x=1688147279;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ajIyFu2x37mehVVsEJFolcxAi/OAEIlKCYgc+FYe4Ns=;
        b=RZaNWYPUvB7Rd8nTYenqM7gNEl9F6hfxrMsZ1d+8CZClA66dc5JGsVEe2Rb2TKHjbF
         00vPXwFkQSpGh4pqbndxgRdZTPmsx2hufCrIxp2SRm5Cbnr4pRlZn9wvs01CYSWTteME
         SCrluGulPHNBwhUzrwCiLi7gXVRzRLSqou6gfej1W/vxP15NApiw4+ERvdqiQdZh636M
         RIhl9tK+rBizUBEt+IeLWifLF/DYhFDg5FQYh4uoLRpVi4lIzTZuJ2PXJbXMbpR080ON
         Ouspy8NqD1HJPc88kEs/Ex8yjjwYuVjGIaXBDAp/k3+iMmY16xJX+pM1c7llqiZWamA3
         3/kg==
X-Gm-Message-State: AC+VfDz2aPRyQKN1s6dKnkJIWDOm06CZWwnoCdA0FznyQVNeZvLEpk4f
	UvCS3c29A8ocOediK8zeeR8L7ndvIis=
X-Google-Smtp-Source: ACHHUZ5PqD8jjWgJiwZCaFBgYKJpa0AtuuDyPZuA7vujZLyxwlgLF/Xjar45SKsg6m/vpUoRNFiA7g==
X-Received: by 2002:a17:902:db09:b0:1b0:6031:4480 with SMTP id m9-20020a170902db0900b001b060314480mr6768945plx.39.1685555279064;
        Wed, 31 May 2023 10:47:59 -0700 (PDT)
Received: from babbage.. (162-227-164-7.lightspeed.sntcca.sbcglobal.net. [162.227.164.7])
        by smtp.gmail.com with ESMTPSA id h13-20020a170902f7cd00b001aadd0d7364sm1694898plw.83.2023.05.31.10.47.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 May 2023 10:47:58 -0700 (PDT)
From: msmulski2@gmail.com
To: netdev@vger.kernel.org
Cc: michal.smulski@ooma.com
Subject: [PATCH net-next v4] net: dsa: mv88e6xxx: implement USXGMII mode for mv88e6393x
Date: Wed, 31 May 2023 10:47:20 -0700
Message-Id: <20230531174720.7821-1-msmulski2@gmail.com>
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

From: Michal Smulski <michal.smulski@ooma.com>

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
index 72faec8f44dc..e4f3dc39bc46 100644
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
+ * on some educated guesses. It appears that there are no status bits related to
+ * autonegotiation complete or flow control.
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


