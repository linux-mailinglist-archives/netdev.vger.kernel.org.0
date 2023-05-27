Return-Path: <netdev+bounces-5830-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CC7287130DB
	for <lists+netdev@lfdr.de>; Sat, 27 May 2023 02:22:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 833891C21141
	for <lists+netdev@lfdr.de>; Sat, 27 May 2023 00:22:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B7850182;
	Sat, 27 May 2023 00:22:11 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7F3B7E
	for <netdev@vger.kernel.org>; Sat, 27 May 2023 00:22:11 +0000 (UTC)
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1322DA4
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 17:22:09 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id 98e67ed59e1d1-2564b0921f1so84993a91.3
        for <netdev@vger.kernel.org>; Fri, 26 May 2023 17:22:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685146928; x=1687738928;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Fh394JWFsM0j09eLaQQ0slsZwb083qLyulLFLALPioE=;
        b=LtPiStZWZ0KZuYDRDnDPRt2Ndyow/WeSxYqr1OITQdskviUIC2Hu+0cjN9q9YrPxX/
         WRhY7v0nq7Hy4aI9z7NbMNtoAM5CHYVCDapL6RZ2rP4F43BzPscA/kXsdocBqY6hYgK9
         Qj+/q+Vv1+Chbgootwjc/X146RGUzYRi1ZUvngRDLUytpdXK+ww+R07+RrEoiGLgZzOh
         lMCL5jzNWdwqPeITN1OWM6Cbk4IJ7CoDUDbcLOAAvcxLgrRmJTyY30/EfCK2YLw54lUI
         aNsMBJSZfvsS5yZabcV8PDN3Dja4Bz269hNJQCOWSyDUvrIjFRjBSc4XblY/wIH/1FXj
         gbxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685146928; x=1687738928;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Fh394JWFsM0j09eLaQQ0slsZwb083qLyulLFLALPioE=;
        b=FUYQA0RXvlBGlNlAWv1Z8RNNt6LunZKXm3rI8g86kzsz2Y9cnCGFQ22Iy1C0si/LDM
         rBaWbskLNF+Z/iMgkRMcy3E3NISjZPKjhkbY5MIM62EPSPeL7zunxm0wu5uP7l+1t8BX
         SaMhyu7nLf4kA9mF2+OXI/QZFAu7Mz6o6x4FeRS84jTZQW0EEZwHeLh7b4krfLijqJ2f
         JlD8v2GN9SGphpLKM3n3dTpGVGWWdJsydXNGS+4WMCr38kK6yRHqiX002sdXmgjpo51D
         X5VUfxyGcdHn85NeSSOOu30qf9SyOhDALmiNqfKK1hdzPIxXUObaaH54OYyPpjeLsdtw
         bRmQ==
X-Gm-Message-State: AC+VfDy98/G4eSJUOCcQg3EZjngRT17l+S5DONdCcEY5O8eNXobXyB/i
	J30ONHHnW4hVzzzHPJKWO/A=
X-Google-Smtp-Source: ACHHUZ6Nm9D6l44x0rDrutMn4TQleU8YLARGzxtCtPuDsHSp51li/WJd9/behOTBvHoRudIab27KgA==
X-Received: by 2002:a17:90b:3102:b0:253:2f58:fe62 with SMTP id gc2-20020a17090b310200b002532f58fe62mr3928308pjb.19.1685146928379;
        Fri, 26 May 2023 17:22:08 -0700 (PDT)
Received: from babbage.. (162-227-164-7.lightspeed.sntcca.sbcglobal.net. [162.227.164.7])
        by smtp.gmail.com with ESMTPSA id gi6-20020a17090b110600b0024df400a9e6sm3257080pjb.37.2023.05.26.17.22.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 May 2023 17:22:07 -0700 (PDT)
From: Michal Smulski <msmulski2@gmail.com>
X-Google-Original-From: Michal Smulski <michal.smulski@ooma.com>
To: andrew@lunn.ch
Cc: f.fainelli@gmail.com,
	olteanv@gmail.com,
	netdev@vger.kernel.org,
	Michal Smulski <michal.smulski@ooma.com>
Subject: [PATCH net-next] net: dsa: mv88e6xxx: implement USXGMII mode for mv88e6393x
Date: Fri, 26 May 2023 17:21:44 -0700
Message-Id: <20230527002144.8109-1-michal.smulski@ooma.com>
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
index 72faec8f44dc..2b5da9b2cb45 100644
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
+	if (cmode != MV88E6393X_PORT_STS_CMODE_10GBASER ||
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


