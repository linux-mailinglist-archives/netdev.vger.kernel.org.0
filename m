Return-Path: <netdev+bounces-7859-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 968DC721D99
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 07:40:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 419622811B9
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 05:40:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED1B53FE4;
	Mon,  5 Jun 2023 05:40:05 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF5395232
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 05:40:05 +0000 (UTC)
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22C3EDA;
	Sun,  4 Jun 2023 22:40:03 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id 98e67ed59e1d1-2566ed9328eso3764591a91.2;
        Sun, 04 Jun 2023 22:40:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685943602; x=1688535602;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gRf5RgM+IqBriCpYLm9GI0+lLf3tUab6LwmeZmNjKV0=;
        b=TmqmnBvMkvkCAlDLrGWozvnafL8k4UIHMj34U0TG+mrDUSZw3wHI7ykJsZvKbn14n+
         zaa8MtQ8nUIPS57eT7pLrHD6tLSYaC2OTS09NiuCQ5kbiFTwLnBTielZTK2DjQsnOY5/
         wn6wJbuirrpFYVpoK1BhmGydW6x0G8HrWp6l9iOPblItgYVg2BHkpVwpGbO9XupNebUn
         uKlNHVlcJBFWKilHzH6oh2hCQCQwAyaE1IJMu1R+F42jqzqTFylDvI/IVhcuotJOgv+7
         7WG0u1nCsAM1zcIjcSaqcyMFj+KTrH+SMSSEo8/1CYeKdJsRKJRoi74pcQXmcC1BJ4IT
         Un6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685943602; x=1688535602;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gRf5RgM+IqBriCpYLm9GI0+lLf3tUab6LwmeZmNjKV0=;
        b=IWno/hdLTJFNsZA1N0tDJW7AWhzy5zjny6iiBz37eANyECIkDpvG9oQb04MZ07L88S
         MbK4YSPvv2bu3CB/bLNcb8haWgHxhWoDNUlKyRki54WGZ/ps1EfTp15j581XXRi1evVA
         UeWgXqjVnHiK26RNpZlMMkp9bwZ5aN6hnq9IndrhUQDyE65q5g2Fv1AByZAGXcQz79BA
         yMzTbRG3x2D9ywVeyDe7WitBCo5xA2qb6C+KA2lD3V7ZL4mlVAZk6O3R1jvoVtx28o6l
         pUonv9HNAgINxrFJ00j0W1eIjkkRfbi68gLANmv8LSYuDoiYe2C8ZiNiBhVqxPIaNn+Z
         XUBQ==
X-Gm-Message-State: AC+VfDyQdG29sxen3zaiBp7bt9h3QyfHyW0hLBguA4JMATUda6W+ZBLO
	HHQuis0hTMWfTBhWf6x4WfU=
X-Google-Smtp-Source: ACHHUZ6MTyIFFBnjG3xZU4lhpJRxKwhYl861mXuMn9QtJwrzXzdkbaGRT+xSowihCREFMQxhZz+Nlw==
X-Received: by 2002:a17:90a:498b:b0:253:30e1:7d68 with SMTP id d11-20020a17090a498b00b0025330e17d68mr6178774pjh.0.1685943602519;
        Sun, 04 Jun 2023 22:40:02 -0700 (PDT)
Received: from babbage.. (162-227-164-7.lightspeed.sntcca.sbcglobal.net. [162.227.164.7])
        by smtp.gmail.com with ESMTPSA id c13-20020a17090a674d00b0024dee5cbe29sm4994822pjm.27.2023.06.04.22.40.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Jun 2023 22:40:02 -0700 (PDT)
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
	ioana.ciornei@nxp.com,
	Michal Smulski <michal.smulski@ooma.com>
Subject: [PATCH net-next v7 1/1] net: dsa: mv88e6xxx: implement USXGMII mode for mv88e6393x
Date: Sun,  4 Jun 2023 22:39:54 -0700
Message-Id: <20230605053954.4051-2-msmulski2@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230605053954.4051-1-msmulski2@gmail.com>
References: <20230605053954.4051-1-msmulski2@gmail.com>
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
 drivers/net/dsa/mv88e6xxx/serdes.c | 47 ++++++++++++++++++++++++++++--
 drivers/net/dsa/mv88e6xxx/serdes.h |  4 +++
 4 files changed, 53 insertions(+), 4 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 2af0c1145d36..8b51756bd805 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -812,11 +812,10 @@ static void mv88e6393x_phylink_get_caps(struct mv88e6xxx_chip *chip, int port,
 			if (!is_6361) {
 				__set_bit(PHY_INTERFACE_MODE_5GBASER, supported);
 				__set_bit(PHY_INTERFACE_MODE_10GBASER, supported);
+				__set_bit(PHY_INTERFACE_MODE_USXGMII, supported);
 				config->mac_capabilities |= MAC_5000FD |
 					MAC_10000FD;
 			}
-			/* FIXME: USXGMII is not supported yet */
-			/* __set_bit(PHY_INTERFACE_MODE_USXGMII, supported); */
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
index 72faec8f44dc..a28b368ed016 100644
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
@@ -984,7 +985,42 @@ static int mv88e6393x_serdes_pcs_get_state_10g(struct mv88e6xxx_chip *chip,
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
+	state->an_complete = state->link;
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
 
@@ -1020,6 +1056,9 @@ int mv88e6393x_serdes_pcs_get_state(struct mv88e6xxx_chip *chip, int port,
 	case PHY_INTERFACE_MODE_10GBASER:
 		return mv88e6393x_serdes_pcs_get_state_10g(chip, port, lane,
 							   state);
+	case PHY_INTERFACE_MODE_USXGMII:
+		return mv88e639x_serdes_pcs_get_state_usxgmii(chip, port, lane,
+							   state);
 
 	default:
 		return -EOPNOTSUPP;
@@ -1173,6 +1212,7 @@ int mv88e6393x_serdes_irq_enable(struct mv88e6xxx_chip *chip, int port,
 		return mv88e6390_serdes_irq_enable_sgmii(chip, lane, enable);
 	case MV88E6393X_PORT_STS_CMODE_5GBASER:
 	case MV88E6393X_PORT_STS_CMODE_10GBASER:
+	case MV88E6393X_PORT_STS_CMODE_USXGMII:
 		return mv88e6393x_serdes_irq_enable_10g(chip, lane, enable);
 	}
 
@@ -1213,6 +1253,7 @@ irqreturn_t mv88e6393x_serdes_irq_status(struct mv88e6xxx_chip *chip, int port,
 		break;
 	case MV88E6393X_PORT_STS_CMODE_5GBASER:
 	case MV88E6393X_PORT_STS_CMODE_10GBASER:
+	case MV88E6393X_PORT_STS_CMODE_USXGMII:
 		err = mv88e6393x_serdes_irq_status_10g(chip, lane, &status);
 		if (err)
 			return err;
@@ -1477,7 +1518,8 @@ static int mv88e6393x_serdes_erratum_5_2(struct mv88e6xxx_chip *chip, int lane,
 	 * to SERDES operating in 10G mode. These registers only apply to 10G
 	 * operation and have no effect on other speeds.
 	 */
-	if (cmode != MV88E6393X_PORT_STS_CMODE_10GBASER)
+	if (cmode != MV88E6393X_PORT_STS_CMODE_10GBASER &&
+	    cmode != MV88E6393X_PORT_STS_CMODE_USXGMII)
 		return 0;
 
 	for (i = 0; i < ARRAY_SIZE(fixes); ++i) {
@@ -1582,6 +1624,7 @@ int mv88e6393x_serdes_power(struct mv88e6xxx_chip *chip, int port, int lane,
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


