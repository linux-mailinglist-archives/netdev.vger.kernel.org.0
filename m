Return-Path: <netdev+bounces-8132-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id F13CA722DD0
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 19:44:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 726161C20C89
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 17:44:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 08C551F929;
	Mon,  5 Jun 2023 17:44:49 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0EC4DDC0
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 17:44:48 +0000 (UTC)
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68A67DC;
	Mon,  5 Jun 2023 10:44:47 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id d2e1a72fcca58-652a6cf1918so2291560b3a.1;
        Mon, 05 Jun 2023 10:44:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685987087; x=1688579087;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=w6fDPbYpxfUCf9MWy0YeBPZwa3RAS3wW7hTm0LfrIRI=;
        b=IF8IckqYSdlmuzz93kiJFFDBMHYvRokzLjPNRyrMtLXZbStYbUv5anlXeITg6A00O3
         vxOjVc1H6h2tK+7/+TQzx1f0lfsuIU9FKuGqWFlUn97MsG3LbAw1cKKCoiaafD+ekDJE
         Fvqd+XyP5OAJELvmjthoik3OpmSXp+cJXzdbIGBEW7bUHkHptejbKz4n8K5lRerxrvvf
         9PbKE3TiLOtrCoqWNrSyxQRAaV58BeZcrtw/LVs5dVG4bHCPdvroBV5W3JHOMLRegssZ
         KafLAX6LMlQgZxngRmyk9o3S+rM05qt/k3Twcy3iNp9IZx7434G375XAWPsl9Km/h/FF
         dJNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685987087; x=1688579087;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=w6fDPbYpxfUCf9MWy0YeBPZwa3RAS3wW7hTm0LfrIRI=;
        b=c5i+3qdc9REIMkH7meZ0JKoJ4lQ5gqqtK3Bi1ZCIEKM1Zetut4vhvFTaDT2GKPODIS
         FxFz1kYTXHFbMI6bfRAO+VJ7CUvbTIgqBYnB8qX1iDXTP+w0QaJMOJhnOH1thyBpBuNB
         f4g06oyYDPxbsByNK2GrLPRnE2k7aS0OTe0TiHvq5U36HB+E16b2JmsMhxNitRGBSLcg
         qp+6UIbHwtxa2sSddHKgHa8knacA5GDbmscXfdhKCpLOg+doYrK92gzbsq7TTHUPluks
         xdelucZleiRoKq7k6X0Txb3PNEnnKGETbOi+3bsocJK7Bs3UA1YkPMc0xJ+ngAfl8oFT
         1aRw==
X-Gm-Message-State: AC+VfDzCXHSqQwiX+6SpnaRWKl1Aj3N4p7l5OtGGup01jjNIx3rTU13W
	OoNjY9Q4VQTmIINhH6RBU/U=
X-Google-Smtp-Source: ACHHUZ7nzK694jwFW6EH99oHobKiVDDd6KLFqfI+qF070FSTszwBz7WTPeB/rcRTw4kbWG2AO2UN9g==
X-Received: by 2002:a05:6a21:6d96:b0:117:1c52:ba7c with SMTP id wl22-20020a056a216d9600b001171c52ba7cmr1675549pzb.6.1685987086538;
        Mon, 05 Jun 2023 10:44:46 -0700 (PDT)
Received: from babbage.. (162-227-164-7.lightspeed.sntcca.sbcglobal.net. [162.227.164.7])
        by smtp.gmail.com with ESMTPSA id fe16-20020a056a002f1000b00653dc27acadsm4519135pfb.205.2023.06.05.10.44.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jun 2023 10:44:46 -0700 (PDT)
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
Subject: [PATCH net-next v8] net: dsa: mv88e6xxx: implement USXGMII mode for mv88e6393x
Date: Mon,  5 Jun 2023 10:44:42 -0700
Message-Id: <20230605174442.12493-1-msmulski2@gmail.com>
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
Changelist (v7 -> v8):
1. added comments related to the link bit of lp_status register.

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
index 72faec8f44dc..80167d53212f 100644
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
+		/* lp_status appears to include the "link" bit as per USXGMII spec. */
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


