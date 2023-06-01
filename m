Return-Path: <netdev+bounces-7250-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 85E1971F51B
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 23:53:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 171A91C2110B
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 21:53:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F38431EFD;
	Thu,  1 Jun 2023 21:53:10 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F660182D0
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 21:53:10 +0000 (UTC)
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EF9D195;
	Thu,  1 Jun 2023 14:53:08 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id 41be03b00d2f7-5289ce6be53so2025739a12.0;
        Thu, 01 Jun 2023 14:53:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685656388; x=1688248388;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=G68pkf+EjV1cJeNi8PG38UDN9hb7qm/88/NxhsQ9ajQ=;
        b=qPShLCalzxPyskuTUtXZ7Rfu3OmvacivFQo9Tdli8QuHYwxvsavpZksdzUj+JLa5N7
         /rDvwBZ+i+5sqwj34S+D0T1JHpugEWa0m2h+b3o5x2WXGUnJKLqs7YsvKhNEUyylbfOo
         LV7YZxGKYNCZYl3EUV148rFXC0LsEu9t7X17R7/xkM+C9huYqS5BSW3nZAXkXf0nVMk/
         67At7Dihrqjz1O1qxtxPvuuDveooVDbZj1gpidQC3F5DQxH+EDWomFgdmuhNGn0JlL31
         fr/P85Wq+1jgWvo/NP8c+2ElLEqT5Q84sq+F7VaZ/seJqFPxJeAnGTfhsnblA66BGA56
         UleQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685656388; x=1688248388;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=G68pkf+EjV1cJeNi8PG38UDN9hb7qm/88/NxhsQ9ajQ=;
        b=AcWeGHIm0UeYcKXF0aihIHu8NuXoNorMH/yFyagfW+rB61BA1PiitYKye1VmHsVMT7
         tdEIzOqtL7uDBd9p8Mlzewbfy/6413flogUrU5oMGLKE5e/x3R4mwW51/5CKR3X2ltPQ
         wx8+hAO2zt9bDpxmcH7VoF63GsQ1FTkwwXf6rF4MFrpDLBsk6UQWsPsIT0P6FjqdNlXz
         pKUNkGJrAUGjs3AEuH0dF1u7ufQweeLZJYi98pqWu0RQo9VIM/lLMAR+EDST+0mOx6Tf
         l+faDMJQZJlb/meouzPsLCzbxc5utQRzPk4v2U58yUeOAPygN8t++Uf8k4YMW4NkdHBk
         ygAw==
X-Gm-Message-State: AC+VfDypi18hvFs+1JTX9roq0TatFDe0phS+AMyhMgbx30qjSqw2wD9l
	4StAGAu7i5eQP8raf/9PjZI=
X-Google-Smtp-Source: ACHHUZ4XZw/TCgBBXeCw4ofQdb31hqwKZnZeGlgkaYFxQEsbFoQbQp0RTtP6YgUCAVPjwpruBATcSg==
X-Received: by 2002:a17:902:c945:b0:1af:b5af:367b with SMTP id i5-20020a170902c94500b001afb5af367bmr535957pla.29.1685656387852;
        Thu, 01 Jun 2023 14:53:07 -0700 (PDT)
Received: from babbage.. (162-227-164-7.lightspeed.sntcca.sbcglobal.net. [162.227.164.7])
        by smtp.gmail.com with ESMTPSA id b7-20020a170902650700b001b034d2e71csm4049207plk.34.2023.06.01.14.53.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Jun 2023 14:53:07 -0700 (PDT)
From: msmulski2@gmail.com
To: andrew@lunn.ch
Cc: f.fainelli@gmail.com,
	olteanv@gmail.com,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	linux@armlinux.org.uk,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	simon.horman@corigine.com,
	kabel@kernel.org,
	Michal Smulski <michal.smulski@ooma.com>
Subject: [PATCH net-next v5 1/1] net: dsa: mv88e6xxx: implement USXGMII mode for mv88e6393x
Date: Thu,  1 Jun 2023 14:52:51 -0700
Message-Id: <20230601215251.3529-2-msmulski2@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230601215251.3529-1-msmulski2@gmail.com>
References: <20230601215251.3529-1-msmulski2@gmail.com>
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
index 8731af6d79de..5a92ccfd08ea 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -815,8 +815,7 @@ static void mv88e6393x_phylink_get_caps(struct mv88e6xxx_chip *chip, int port,
 				config->mac_capabilities |= MAC_5000FD |
 					MAC_10000FD;
 			}
-			/* FIXME: USXGMII is not supported yet */
-			/* __set_bit(PHY_INTERFACE_MODE_USXGMII, supported); */
+			__set_bit(PHY_INTERFACE_MODE_USXGMII, supported);
 		}
 	}
 
diff --git a/drivers/net/dsa/mv88e6xxx/port.c b/drivers/net/dsa/mv88e6xxx/port.c
index e9b4a6ea4d09..dd66ec902d4c 100644
--- a/drivers/net/dsa/mv88e6xxx/port.c
+++ b/drivers/net/dsa/mv88e6xxx/port.c
@@ -566,6 +566,9 @@ static int mv88e6xxx_port_set_cmode(struct mv88e6xxx_chip *chip, int port,
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


