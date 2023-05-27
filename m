Return-Path: <netdev+bounces-5927-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C99257135DE
	for <lists+netdev@lfdr.de>; Sat, 27 May 2023 19:20:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 36BA528164F
	for <lists+netdev@lfdr.de>; Sat, 27 May 2023 17:20:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D734134D7;
	Sat, 27 May 2023 17:20:31 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3E231078A
	for <netdev@vger.kernel.org>; Sat, 27 May 2023 17:20:30 +0000 (UTC)
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70086BD
	for <netdev@vger.kernel.org>; Sat, 27 May 2023 10:20:29 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id 98e67ed59e1d1-2533d3acd5fso1829169a91.2
        for <netdev@vger.kernel.org>; Sat, 27 May 2023 10:20:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685208029; x=1687800029;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=1E4QyHUOhQEPcLNcQX0gZ66dtUoSVYwmK9jFuqpxoo4=;
        b=m3YscQma1tyYCTgXXCb9Aga+QC2oo0rQKytacm+GJ08WvNfw5b+hNmodCe6CnQ+10h
         LfJzMtMkA+A3FBZ19Xvx/GXkxND71fHunzpdJdmPdKRElFXoD29hnfExhCmgLLz2phBU
         GnGGYaEWWJtYLql/7EaA1CFqxdHx04SZdKDEiKU8AVZIqQrfGZz38xZGGWlQjLCQMol3
         zA5IeTix+1whxp/gKe5eFKCjRqlk1aK8VIQx+jPEL33g+yu4wr3r/0mJre465u4lysY5
         cVFPphgzL19ABML9FX8F9Ri1+VF9Jpl37aaOdGR00ZLul4LlyqydkWJdyV+ZYH7K3Xf/
         l45Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685208029; x=1687800029;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1E4QyHUOhQEPcLNcQX0gZ66dtUoSVYwmK9jFuqpxoo4=;
        b=kBGL8QkUfukR7V2/ze4ZCsziVfMK1blZu+8WjLeAhzP2GRpG9d3aORIJ3lhDWtxqMG
         5VqYro1tVA33BoJzWKPYqFBh8zxSWxPmO5eaB72DdrD8JNbEeeHZ3+fGur6hkORb7iAj
         xA7BFLTeDsJeIwn/gUQioIAXIJb+30U7ejPPw4tcY4pG8qoTM2+4cESP+w4cYSGqHSiK
         cPUStsfBJx//eOWqd3DXH3m3P0SJg42gPdEWpDA1KkyavvUj+91ZMfj2C9WKeYrfh7zy
         Yb38f+D+Y0Ou/9lRyNGYgfZgHwBzFH2w1Tkud8BWRaI9Vr7FxXRc7ujba9hmVrRu4ZTs
         TQGw==
X-Gm-Message-State: AC+VfDzIR2cF6IcnCBbtGmFxZRV1tkKRQIK29XTWP9H3c0x85PZYBx8a
	Eq81TR7eQHKTRMt3RhykJWI=
X-Google-Smtp-Source: ACHHUZ4RiZQdY7s+SNzMq4H0EoJmVNKqIEZVAmCbXeLTvRtBkhCPWu28e4vNpHsnFSmvrCzhB4SrZw==
X-Received: by 2002:a17:90a:cd05:b0:255:8fd0:fbf4 with SMTP id d5-20020a17090acd0500b002558fd0fbf4mr6365428pju.5.1685208028793;
        Sat, 27 May 2023 10:20:28 -0700 (PDT)
Received: from babbage.. (162-227-164-7.lightspeed.sntcca.sbcglobal.net. [162.227.164.7])
        by smtp.gmail.com with ESMTPSA id y1-20020a17090a2b4100b0025645d118adsm1430504pjc.14.2023.05.27.10.20.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 27 May 2023 10:20:28 -0700 (PDT)
From: Michal Smulski <msmulski2@gmail.com>
X-Google-Original-From: Michal Smulski <michal.smulski@ooma.com>
To: andrew@lunn.ch
Cc: f.fainelli@gmail.com,
	olteanv@gmail.com,
	netdev@vger.kernel.org,
	Michal Smulski <michal.smulski@ooma.com>
Subject: [PATCH net-next v2] net: dsa: mv88e6xxx: implement USXGMII mode for mv88e6393x
Date: Sat, 27 May 2023 10:20:24 -0700
Message-Id: <20230527172024.9154-1-michal.smulski@ooma.com>
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
 drivers/net/dsa/mv88e6xxx/chip.c   |  3 +--
 drivers/net/dsa/mv88e6xxx/port.c   |  3 +++
 drivers/net/dsa/mv88e6xxx/serdes.c | 10 ++++++++--
 3 files changed, 12 insertions(+), 4 deletions(-)

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
index 72faec8f44dc..ae051d383c7e 100644
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
@@ -1018,6 +1019,7 @@ int mv88e6393x_serdes_pcs_get_state(struct mv88e6xxx_chip *chip, int port,
 							    state);
 	case PHY_INTERFACE_MODE_5GBASER:
 	case PHY_INTERFACE_MODE_10GBASER:
+	case PHY_INTERFACE_MODE_USXGMII:
 		return mv88e6393x_serdes_pcs_get_state_10g(chip, port, lane,
 							   state);
 
@@ -1173,6 +1175,7 @@ int mv88e6393x_serdes_irq_enable(struct mv88e6xxx_chip *chip, int port,
 		return mv88e6390_serdes_irq_enable_sgmii(chip, lane, enable);
 	case MV88E6393X_PORT_STS_CMODE_5GBASER:
 	case MV88E6393X_PORT_STS_CMODE_10GBASER:
+	case MV88E6393X_PORT_STS_CMODE_USXGMII:
 		return mv88e6393x_serdes_irq_enable_10g(chip, lane, enable);
 	}
 
@@ -1213,6 +1216,7 @@ irqreturn_t mv88e6393x_serdes_irq_status(struct mv88e6xxx_chip *chip, int port,
 		break;
 	case MV88E6393X_PORT_STS_CMODE_5GBASER:
 	case MV88E6393X_PORT_STS_CMODE_10GBASER:
+	case MV88E6393X_PORT_STS_CMODE_USXGMII:
 		err = mv88e6393x_serdes_irq_status_10g(chip, lane, &status);
 		if (err)
 			return err;
@@ -1477,7 +1481,8 @@ static int mv88e6393x_serdes_erratum_5_2(struct mv88e6xxx_chip *chip, int lane,
 	 * to SERDES operating in 10G mode. These registers only apply to 10G
 	 * operation and have no effect on other speeds.
 	 */
-	if (cmode != MV88E6393X_PORT_STS_CMODE_10GBASER)
+	if (cmode != MV88E6393X_PORT_STS_CMODE_10GBASER &&
+	    cmode != MV88E6393X_PORT_STS_CMODE_USXGMII)
 		return 0;
 
 	for (i = 0; i < ARRAY_SIZE(fixes); ++i) {
@@ -1582,6 +1587,7 @@ int mv88e6393x_serdes_power(struct mv88e6xxx_chip *chip, int port, int lane,
 		break;
 	case MV88E6393X_PORT_STS_CMODE_5GBASER:
 	case MV88E6393X_PORT_STS_CMODE_10GBASER:
+	case MV88E6393X_PORT_STS_CMODE_USXGMII:
 		err = mv88e6390_serdes_power_10g(chip, lane, on);
 		break;
 	default:
-- 
2.34.1


