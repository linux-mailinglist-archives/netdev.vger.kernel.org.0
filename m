Return-Path: <netdev+bounces-7273-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BB57671F711
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 02:17:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3FA0F1C2115B
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 00:17:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 606E519A;
	Fri,  2 Jun 2023 00:17:15 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 514DC10EA
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 00:17:15 +0000 (UTC)
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86B4012C;
	Thu,  1 Jun 2023 17:17:13 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id d2e1a72fcca58-64d4e4598f0so1742913b3a.2;
        Thu, 01 Jun 2023 17:17:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685665033; x=1688257033;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IYbA7Tv6vnB3umdnQgU7lqFqRdQGMgWyX0qyQnI7T+0=;
        b=eCdLzXrp9rMa8KaIIl7JmBEAVybNOYaHJJDlWYiSI8YENn5FcOvC/ekjMOqcbgQTnz
         uPsc9UweExirwjr2mDTBo8LJ0yA5MR3reTdCWy9WFrWpto0EhFuVwgQw/X+e/DSqKjKp
         mWtOj85IIGmyMAHAPOr0uRS9nIdj4Q7n2jmZ17JUSZ6rGD0gI5LKDZhu6s5S5VcYRb/0
         Ea4I5lUPPBD6fYULZ6N8AAdlGaaFNh1GawESiF+plUMAit0jHtXxevXajSE+rdb82gTR
         RBP08INJxpsbUeFspbWpmmXHFm9BwOhWxxK9XNVsx8WKsjkw2H1CWbKZFiRThHD7dIOX
         liqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685665033; x=1688257033;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IYbA7Tv6vnB3umdnQgU7lqFqRdQGMgWyX0qyQnI7T+0=;
        b=bptvE8vRfKA+AihlCOUHQsFucv09zsugH6YG9wvd8NLoKZsneM7jWW3oXsyX08cM2G
         m7oYaxmG1eOV6OoldNiaoPN49clrUnYNXk8daQOLZhDxLAR30YymFmqU/p7ZfDDgMGd6
         dMx+IApXDTwNBsIhxa63YenCmo2CUk+1kvRcsD9qltbtFOFOjg8te260I8AAUtYO1+Fq
         3p23Npn0fSNGdxWf44cPqIe7cYsEgAyZby93hECze3TSAHAiN0BoIJZbzQSP7PWO4h3f
         f0w94A7CFxveVVgyzCSIrcKoC/tqv6BHjx5rP8pyHbia789vQ4MDqtQlhNmMAGtRGags
         yAHw==
X-Gm-Message-State: AC+VfDylEW4VcN60n1MBPrZBJOf1Mp+6IqfrfYgAbPhRmyBHGHwMF8nK
	aqcYzhDSPXJ0QcU+wBwm+qI=
X-Google-Smtp-Source: ACHHUZ4RPziFi3k08RFhB0lesiMOXu59DDlAib/GjyNB0g5ZBxqv1cG9hTte2uvtBcYUjn7O8mu+BQ==
X-Received: by 2002:a05:6a20:5494:b0:10c:8f0c:f81c with SMTP id i20-20020a056a20549400b0010c8f0cf81cmr13703644pzk.53.1685665032924;
        Thu, 01 Jun 2023 17:17:12 -0700 (PDT)
Received: from babbage.. (162-227-164-7.lightspeed.sntcca.sbcglobal.net. [162.227.164.7])
        by smtp.gmail.com with ESMTPSA id b38-20020a631b66000000b0051eff0a70d7sm8063pgm.94.2023.06.01.17.17.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Jun 2023 17:17:12 -0700 (PDT)
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
Subject: [PATCH net-next v6 1/1] net: dsa: mv88e6xxx: implement USXGMII mode for mv88e6393x
Date: Thu,  1 Jun 2023 17:17:04 -0700
Message-Id: <20230602001705.2747-2-msmulski2@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230602001705.2747-1-msmulski2@gmail.com>
References: <20230602001705.2747-1-msmulski2@gmail.com>
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
 drivers/net/dsa/mv88e6xxx/serdes.c | 46 ++++++++++++++++++++++++++++--
 drivers/net/dsa/mv88e6xxx/serdes.h |  4 +++
 4 files changed, 52 insertions(+), 4 deletions(-)

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
index 72faec8f44dc..504424f59795 100644
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
@@ -984,7 +985,41 @@ static int mv88e6393x_serdes_pcs_get_state_10g(struct mv88e6xxx_chip *chip,
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
+				    MV88E6390_USXGMII_PHY_STATUS, &status);
+	if (err) {
+		dev_err(chip->dev, "can't read Serdes USXGMII PHY status: %d\n", err);
+		return err;
+	}
+	dev_dbg(chip->dev, "USXGMII PHY status: 0x%x\n", status);
+
+	state->link = !!(status & MDIO_USXGMII_LINK);
+
+	if (state->link) {
+		err = mv88e6390_serdes_read(chip, lane, MDIO_MMD_PHYXS,
+					    MV88E6390_USXGMII_LP_STATUS, &lp_status);
+		if (err) {
+			dev_err(chip->dev, "can't read Serdes USXGMII LP status: %d\n", err);
+			return err;
+		}
+		dev_dbg(chip->dev, "USXGMII LP status: 0x%x\n", lp_status);
 
+		phylink_decode_usxgmii_word(state, lp_status);
+	}
 	return 0;
 }
 
@@ -1020,6 +1055,9 @@ int mv88e6393x_serdes_pcs_get_state(struct mv88e6xxx_chip *chip, int port,
 	case PHY_INTERFACE_MODE_10GBASER:
 		return mv88e6393x_serdes_pcs_get_state_10g(chip, port, lane,
 							   state);
+	case PHY_INTERFACE_MODE_USXGMII:
+		return mv88e639x_serdes_pcs_get_state_usxgmii(chip, port, lane,
+							   state);
 
 	default:
 		return -EOPNOTSUPP;
@@ -1173,6 +1211,7 @@ int mv88e6393x_serdes_irq_enable(struct mv88e6xxx_chip *chip, int port,
 		return mv88e6390_serdes_irq_enable_sgmii(chip, lane, enable);
 	case MV88E6393X_PORT_STS_CMODE_5GBASER:
 	case MV88E6393X_PORT_STS_CMODE_10GBASER:
+	case MV88E6393X_PORT_STS_CMODE_USXGMII:
 		return mv88e6393x_serdes_irq_enable_10g(chip, lane, enable);
 	}
 
@@ -1213,6 +1252,7 @@ irqreturn_t mv88e6393x_serdes_irq_status(struct mv88e6xxx_chip *chip, int port,
 		break;
 	case MV88E6393X_PORT_STS_CMODE_5GBASER:
 	case MV88E6393X_PORT_STS_CMODE_10GBASER:
+	case MV88E6393X_PORT_STS_CMODE_USXGMII:
 		err = mv88e6393x_serdes_irq_status_10g(chip, lane, &status);
 		if (err)
 			return err;
@@ -1477,7 +1517,8 @@ static int mv88e6393x_serdes_erratum_5_2(struct mv88e6xxx_chip *chip, int lane,
 	 * to SERDES operating in 10G mode. These registers only apply to 10G
 	 * operation and have no effect on other speeds.
 	 */
-	if (cmode != MV88E6393X_PORT_STS_CMODE_10GBASER)
+	if (cmode != MV88E6393X_PORT_STS_CMODE_10GBASER &&
+	    cmode != MV88E6393X_PORT_STS_CMODE_USXGMII)
 		return 0;
 
 	for (i = 0; i < ARRAY_SIZE(fixes); ++i) {
@@ -1582,6 +1623,7 @@ int mv88e6393x_serdes_power(struct mv88e6xxx_chip *chip, int port, int lane,
 		break;
 	case MV88E6393X_PORT_STS_CMODE_5GBASER:
 	case MV88E6393X_PORT_STS_CMODE_10GBASER:
+	case MV88E6393X_PORT_STS_CMODE_USXGMII:
 		err = mv88e6390_serdes_power_10g(chip, lane, on);
 		break;
 	default:
diff --git a/drivers/net/dsa/mv88e6xxx/serdes.h b/drivers/net/dsa/mv88e6xxx/serdes.h
index 29bb4e91e2f6..e245687ddb1d 100644
--- a/drivers/net/dsa/mv88e6xxx/serdes.h
+++ b/drivers/net/dsa/mv88e6xxx/serdes.h
@@ -48,6 +48,10 @@
 #define MV88E6393X_10G_INT_LINK_CHANGE	BIT(2)
 #define MV88E6393X_10G_INT_STATUS	0x9001
 
+/* USXGMII */
+#define MV88E6390_USXGMII_LP_STATUS       0xf0a2
+#define MV88E6390_USXGMII_PHY_STATUS      0xf0a6
+
 /* 1000BASE-X and SGMII */
 #define MV88E6390_SGMII_BMCR		(0x2000 + MII_BMCR)
 #define MV88E6390_SGMII_BMSR		(0x2000 + MII_BMSR)
-- 
2.34.1


