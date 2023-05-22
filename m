Return-Path: <netdev+bounces-4259-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 54B7F70BD6E
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 14:19:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2981E1C20A92
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 12:19:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7DD0813AFB;
	Mon, 22 May 2023 12:16:54 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C4F813ACC
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 12:16:54 +0000 (UTC)
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C08AE7F;
	Mon, 22 May 2023 05:16:30 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id a640c23a62f3a-96f683e8855so500888466b.2;
        Mon, 22 May 2023 05:16:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684757770; x=1687349770;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=09nd6fTFveBIw7H/yL3o+Sjulkglg9M/F+8IUrvwpII=;
        b=EnpEKFtOllWOIegh28dhFbPOFH/HrmzaHge/LOuCS9HUToi39rBRx2FNGrAZcvXM+T
         AZlW3o1QfFyb6Clgw1RJYXfBrM/2yqMfVl9DG6qebBEI4sSdIEhb1rcYxRvMiakpB4q4
         z07RkUSOb45BSrnYSg9fCLSyXOMFCykMXAvVb07Evbl7MkutAW3kWDtvUvo2mfC+yzht
         HyMDIGKR8mlinmJYbV9bxGWQki9RmN9IvFKg3V3i3dRhOEoNoetIJJddkAxA2svnfG5O
         FPWs7km3YkEBZqSg/eNKj4NChquNnmOsaiQ/3+dZfAZkM9crRMBhqymCeYX4APL7opEK
         HBBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684757770; x=1687349770;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=09nd6fTFveBIw7H/yL3o+Sjulkglg9M/F+8IUrvwpII=;
        b=FIIfxHkTwY56vmYcOxiHqaEyOQH7aWcwkpUTIqNtRtmxqR7AizAqOQU4hCUbCfmUSQ
         hgq2b6bb65FN9KurYW7xUvkoZhvRlb2LTqoFIdp9P5UNwcDaHEfDnl5m7Lmfb0sE/8rY
         h0tnxXY6gQrSLzOc+bcp1VYCp+ZLV+iwcjgrwi8US+tEAWZvJwLuKyqLrzfELE675k1Y
         mR7cu2z4pjK0RLyIf3VerqUplrtvQkHzx4fHTQ0VOsSaBL0Ol/1vuTabXCrOm8NzJIE+
         AwxzEhgAsIi69mSVCSAJjNjm1prjYoXHOHtsgb+IKa/ZuQw5dr7U08EVGziGI3bSFUBC
         ygUA==
X-Gm-Message-State: AC+VfDzO7oFJnGW5qeXwTRB3bXmvtNS99/9KRxJUPUMPnQBPo0M0JKuZ
	Yi4QiwzfmNaB7e+pDIs71Es=
X-Google-Smtp-Source: ACHHUZ5hU+NOmEAdAFMlajNG3Yg1qbkVUC8BFFF3ClhNmgfBkSGyllIYy5W5FEVql6P6xiR8IV0xfA==
X-Received: by 2002:a17:907:7252:b0:970:c9f:2db3 with SMTP id ds18-20020a170907725200b009700c9f2db3mr1169157ejc.5.1684757769819;
        Mon, 22 May 2023 05:16:09 -0700 (PDT)
Received: from arinc9-PC.. ([149.91.1.15])
        by smtp.gmail.com with ESMTPSA id y26-20020a17090614da00b009659fed3612sm2999950ejc.24.2023.05.22.05.16.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 May 2023 05:16:09 -0700 (PDT)
From: arinc9.unal@gmail.com
X-Google-Original-From: arinc.unal@arinc9.com
To: Sean Wang <sean.wang@mediatek.com>,
	Landen Chao <Landen.Chao@mediatek.com>,
	DENG Qingfang <dqfext@gmail.com>,
	Daniel Golle <daniel@makrotopia.org>,
	Andrew Lunn <andrew@lunn.ch>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Vladimir Oltean <olteanv@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Russell King <linux@armlinux.org.uk>
Cc: =?UTF-8?q?Ar=C4=B1n=C3=A7=20=C3=9CNAL?= <arinc.unal@arinc9.com>,
	Richard van Schagen <richard@routerhints.com>,
	Richard van Schagen <vschagen@cs.com>,
	Frank Wunderlich <frank-w@public-files.de>,
	Bartel Eerdekens <bartel.eerdekens@constell8.be>,
	erkin.bozoglu@xeront.com,
	mithat.guner@xeront.com,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Subject: [PATCH net-next 08/30] net: dsa: mt7530: change p{5,6}_interface to p{5,6}_configured
Date: Mon, 22 May 2023 15:15:10 +0300
Message-Id: <20230522121532.86610-9-arinc.unal@arinc9.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230522121532.86610-1-arinc.unal@arinc9.com>
References: <20230522121532.86610-1-arinc.unal@arinc9.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Arınç ÜNAL <arinc.unal@arinc9.com>

The idea of p5_interface and p6_interface pointers is to prevent
mt753x_mac_config() from running twice for MT7531, as it's already run with
mt753x_cpu_port_enable() from mt7531_setup_common(), if the port is used as
a CPU port.

Change p5_interface and p6_interface to p5_configured and p6_configured.
Make them boolean.

Do not set them for any other reason.

The priv->p5_intf_sel check is useless as in this code path, it will always
be P5_INTF_SEL_GMAC5.

There was also no need to set priv->p5_interface and priv->p6_interface to
PHY_INTERFACE_MODE_NA on mt7530_setup() and mt7531_setup() as they would
already be set to that when "priv" is allocated. The pointers were of the
phy_interface_t enumeration type, and the first element of the enum is
PHY_INTERFACE_MODE_NA. There was nothing in between that would change this
beforehand.

Tested-by: Arınç ÜNAL <arinc.unal@arinc9.com>
Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
Acked-by: Daniel Golle <daniel@makrotopia.org>
---
 drivers/net/dsa/mt7530.c | 19 ++++---------------
 drivers/net/dsa/mt7530.h | 10 ++++++----
 2 files changed, 10 insertions(+), 19 deletions(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index 710c6622d648..d837aa20968c 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -2234,8 +2234,6 @@ mt7530_setup(struct dsa_switch *ds)
 	val |= MHWTRAP_MANUAL;
 	mt7530_write(priv, MT7530_MHWTRAP, val);
 
-	priv->p6_interface = PHY_INTERFACE_MODE_NA;
-
 	/* Enable and reset MIB counters */
 	mt7530_mib_reset(ds);
 
@@ -2455,10 +2453,6 @@ mt7531_setup(struct dsa_switch *ds)
 	mt7530_rmw(priv, MT7531_GPIO_MODE0, MT7531_GPIO0_MASK,
 		   MT7531_GPIO0_INTERRUPT);
 
-	/* Let phylink decide the interface later. */
-	priv->p5_interface = PHY_INTERFACE_MODE_NA;
-	priv->p6_interface = PHY_INTERFACE_MODE_NA;
-
 	/* Enable PHY core PLL, since phy_device has not yet been created
 	 * provided for phy_[read,write]_mmd_indirect is called, we provide
 	 * our own mt7531_ind_mmd_phy_[read,write] to complete this
@@ -2728,25 +2722,20 @@ mt753x_phylink_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
 			goto unsupported;
 		break;
 	case 5: /* Port 5, can be used as a CPU port. */
-		if (priv->p5_interface == state->interface)
+		if (priv->p5_configured)
 			break;
 
 		if (mt753x_mac_config(ds, port, mode, state) < 0)
 			goto unsupported;
-
-		if (priv->p5_intf_sel != P5_DISABLED)
-			priv->p5_interface = state->interface;
 		break;
 	case 6: /* Port 6, can be used as a CPU port. */
-		if (priv->p6_interface == state->interface)
+		if (priv->p6_configured)
 			break;
 
 		mt753x_pad_setup(ds, state);
 
 		if (mt753x_mac_config(ds, port, mode, state) < 0)
 			goto unsupported;
-
-		priv->p6_interface = state->interface;
 		break;
 	default:
 unsupported:
@@ -2854,12 +2843,12 @@ mt7531_cpu_port_config(struct dsa_switch *ds, int port)
 		else
 			interface = PHY_INTERFACE_MODE_2500BASEX;
 
-		priv->p5_interface = interface;
+		priv->p5_configured = true;
 		break;
 	case 6:
 		interface = PHY_INTERFACE_MODE_2500BASEX;
 
-		priv->p6_interface = interface;
+		priv->p6_configured = true;
 		break;
 	default:
 		return -EINVAL;
diff --git a/drivers/net/dsa/mt7530.h b/drivers/net/dsa/mt7530.h
index 2602c95fd3a5..06037be5882c 100644
--- a/drivers/net/dsa/mt7530.h
+++ b/drivers/net/dsa/mt7530.h
@@ -745,8 +745,10 @@ struct mt753x_info {
  * @ports:		Holding the state among ports
  * @reg_mutex:		The lock for protecting among process accessing
  *			registers
- * @p6_interface:	Holding the current port 6 interface
- * @p5_interface:	Holding the current port 5 interface
+ * @p6_configured:	Flag for distinguishing if port 6 of the MT7531 switch
+ *			is already configured
+ * @p5_configured:	Flag for distinguishing if port 5 of the MT7531 switch
+ *			is already configured
  * @p5_intf_sel:	Holding the current port 5 interface select
  * @p5_sgmii:		Flag for distinguishing if port 5 of the MT7531 switch
  *			has got SGMII
@@ -767,8 +769,8 @@ struct mt7530_priv {
 	const struct mt753x_info *info;
 	unsigned int		id;
 	bool			mcm;
-	phy_interface_t		p6_interface;
-	phy_interface_t		p5_interface;
+	bool			p6_configured;
+	bool			p5_configured;
 	enum p5_interface_select p5_intf_sel;
 	bool			p5_sgmii;
 	u8			mirror_rx;
-- 
2.39.2


