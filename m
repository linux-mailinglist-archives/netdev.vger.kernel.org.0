Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB66C6EDE32
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 10:33:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233868AbjDYIdK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Apr 2023 04:33:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233660AbjDYIbz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Apr 2023 04:31:55 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CDC66E97;
        Tue, 25 Apr 2023 01:30:50 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id a640c23a62f3a-953343581a4so804686566b.3;
        Tue, 25 Apr 2023 01:30:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682411447; x=1685003447;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DcEecCSVjHrfHWDBYIR91HFhVC039k17zyIM1kkNbqQ=;
        b=h2YPjHK0YyO7kNZZERdjSTIaMFrALCP6RRpluyNBwxaPpj25GQO2pTQy4iso+ZgTWJ
         m2oELAWptlmGrWwGjYhskz6AsvghdBhJeVgvpptyhUFqAuZE7r64COHv8CMtaFtHmzVy
         r87HvoD3RlubhBui6i3/vQjE13pc19SUaVhcb3ZWf469GD0W2IlpUt3tu5a5M6kY3o5I
         r2dQCnOmZjFfnElUeJ2Jw5aE81g9+fdXfDaspf5ID0bsvjPI3enVLMPaX8ebhRM9czR9
         Z2QiOyE4q2Wsz3ShuYCqg+GpoxFw3k0TfzImRWkRXNLg2SYldcGZG0BPLedGaQC+zpm/
         zp+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682411447; x=1685003447;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DcEecCSVjHrfHWDBYIR91HFhVC039k17zyIM1kkNbqQ=;
        b=NTAxXk1oXAYmZ+6+5DHtbGTZoNcdiNpLjPzx1ltVdrX/fSjclRsCXQlEMLW51dqZ1w
         ng02NpxbNdSkV2GG7ItAlYKl6QxUlRelqKq0EFVlD6pe4sim9vGkf8Dh++lT0LghaBwB
         PPi1Rp2H6+b4IgBTEKpw9XCjj1h62X376a22s24ORB805C6XBivKS57Bj5dMsztWQI0o
         r7HiPWqnGSr9dphHypQIN2ul6YwJlkF+1BnXSqDdvzIt4k8BC/ld9Ujf+POPc8aGj1tI
         wsdI+6OjJPFklGF0tQCMcDvZXMt/yVaqQ4c7pDKuWNjg1n9BIJhTPPOiE/T30LJ6qvs1
         y8AA==
X-Gm-Message-State: AAQBX9e0JlG3Wvo/t6Kw5xub7DM/uXxIshP/LXYs1bD5ApsdRq8fqa7E
        nuCXxoa4RWMWHhnrAedMsX0=
X-Google-Smtp-Source: AKy350abyOKtoHYjyLXq41z67rG+LsmeRwF0MW2/duqF1viLa2JB7MaaggWeLrdoUs9PCpq1t6qKzg==
X-Received: by 2002:a17:907:c002:b0:932:ac6c:7ef9 with SMTP id ss2-20020a170907c00200b00932ac6c7ef9mr12445119ejc.22.1682411446671;
        Tue, 25 Apr 2023 01:30:46 -0700 (PDT)
Received: from arinc9-PC.lan ([149.91.1.15])
        by smtp.gmail.com with ESMTPSA id mc2-20020a170906eb4200b0094ca077c985sm6439028ejb.213.2023.04.25.01.30.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Apr 2023 01:30:46 -0700 (PDT)
From:   arinc9.unal@gmail.com
X-Google-Original-From: arinc.unal@arinc9.com
To:     Sean Wang <sean.wang@mediatek.com>,
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
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     =?UTF-8?q?Ar=C4=B1n=C3=A7=20=C3=9CNAL?= <arinc.unal@arinc9.com>,
        Richard van Schagen <richard@routerhints.com>,
        Richard van Schagen <vschagen@cs.com>,
        Frank Wunderlich <frank-w@public-files.de>,
        Bartel Eerdekens <bartel.eerdekens@constell8.be>,
        erkin.bozoglu@xeront.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH net-next 22/24] net: dsa: mt7530: get rid of useless error returns on phylink code path
Date:   Tue, 25 Apr 2023 11:29:31 +0300
Message-Id: <20230425082933.84654-23-arinc.unal@arinc9.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20230425082933.84654-1-arinc.unal@arinc9.com>
References: <20230425082933.84654-1-arinc.unal@arinc9.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arınç ÜNAL <arinc.unal@arinc9.com>

Remove error returns on the cases where they are already handled with the
function the mac_port_get_caps member points to.

mt7531_mac_config() is also called from mt7531_cpu_port_config() outside of
phylink but the port and interface modes are already handled there.

Change the functions and the mac_port_config function pointer to void now
that there're no error returns anymore.

Remove mt753x_is_mac_port() that used to help the said error returns.

On mt7531_mac_config(), switch to if statements to simplify the code.

Remove internal phy cases from mt753x_phylink_mac_config() as there is no
configuration to be done for them. There's also no need to check the
interface mode as that's already handled with the function the
mac_port_get_caps member points to.

Tested-by: Arınç ÜNAL <arinc.unal@arinc9.com>
Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
Acked-by: Daniel Golle <daniel@makrotopia.org>
Tested-by: Daniel Golle <daniel@makrotopia.org>
---
 drivers/net/dsa/mt7530.c | 81 ++++++++--------------------------------
 drivers/net/dsa/mt7530.h |  2 +-
 2 files changed, 17 insertions(+), 66 deletions(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index 0bd38323e2b6..02e6ba5a4403 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -2550,7 +2550,7 @@ static void mt7988_mac_port_get_caps(struct dsa_switch *ds, int port,
 	}
 }
 
-static int
+static void
 mt7530_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
 		  phy_interface_t interface)
 {
@@ -2561,22 +2561,14 @@ mt7530_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
 	} else if (port == 6) {
 		mt7530_setup_port6(priv->ds, interface);
 	}
-
-	return 0;
 }
 
-static int mt7531_rgmii_setup(struct mt7530_priv *priv, u32 port,
-			      phy_interface_t interface,
-			      struct phy_device *phydev)
+static void mt7531_rgmii_setup(struct mt7530_priv *priv, u32 port,
+			       phy_interface_t interface,
+			       struct phy_device *phydev)
 {
 	u32 val;
 
-	if (priv->p5_sgmii) {
-		dev_err(priv->dev, "RGMII mode is not available for port %d\n",
-			port);
-		return -EINVAL;
-	}
-
 	val = mt7530_read(priv, MT7531_CLKGEN_CTRL);
 	val |= GP_CLK_EN;
 	val &= ~GP_MODE_MASK;
@@ -2604,20 +2596,14 @@ static int mt7531_rgmii_setup(struct mt7530_priv *priv, u32 port,
 		case PHY_INTERFACE_MODE_RGMII_ID:
 			break;
 		default:
-			return -EINVAL;
+			break;
 		}
 	}
-	mt7530_write(priv, MT7531_CLKGEN_CTRL, val);
 
-	return 0;
-}
-
-static bool mt753x_is_mac_port(u32 port)
-{
-	return (port == 5 || port == 6);
+	mt7530_write(priv, MT7531_CLKGEN_CTRL, val);
 }
 
-static int
+static void
 mt7531_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
 		  phy_interface_t interface)
 {
@@ -2625,42 +2611,21 @@ mt7531_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
 	struct phy_device *phydev;
 	struct dsa_port *dp;
 
-	if (!mt753x_is_mac_port(port)) {
-		dev_err(priv->dev, "port %d is not a MAC port\n", port);
-		return -EINVAL;
-	}
-
-	switch (interface) {
-	case PHY_INTERFACE_MODE_RGMII:
-	case PHY_INTERFACE_MODE_RGMII_ID:
-	case PHY_INTERFACE_MODE_RGMII_RXID:
-	case PHY_INTERFACE_MODE_RGMII_TXID:
+	if (phy_interface_mode_is_rgmii(interface)) {
 		dp = dsa_to_port(ds, port);
 		phydev = dp->slave->phydev;
-		return mt7531_rgmii_setup(priv, port, interface, phydev);
-	case PHY_INTERFACE_MODE_SGMII:
-	case PHY_INTERFACE_MODE_NA:
-	case PHY_INTERFACE_MODE_1000BASEX:
-	case PHY_INTERFACE_MODE_2500BASEX:
-		/* handled in SGMII PCS driver */
-		return 0;
-	default:
-		return -EINVAL;
+		mt7531_rgmii_setup(priv, port, interface, phydev);
 	}
-
-	return -EINVAL;
 }
 
-static int
+static void
 mt753x_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
 		  const struct phylink_link_state *state)
 {
 	struct mt7530_priv *priv = ds->priv;
 
-	if (!priv->info->mac_port_config)
-		return 0;
-
-	return priv->info->mac_port_config(ds, port, mode, state->interface);
+	if (priv->info->mac_port_config)
+		priv->info->mac_port_config(ds, port, mode, state->interface);
 }
 
 static struct phylink_pcs *
@@ -2689,30 +2654,18 @@ mt753x_phylink_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
 	u32 mcr_cur, mcr_new;
 
 	switch (port) {
-	case 0 ... 4: /* Internal phy */
-		if (state->interface != PHY_INTERFACE_MODE_GMII &&
-		    state->interface != PHY_INTERFACE_MODE_INTERNAL)
-			goto unsupported;
-		break;
 	case 5: /* Port 5, can be used as a CPU port. */
 		if (priv->p5_configured)
 			break;
 
-		if (mt753x_mac_config(ds, port, mode, state) < 0)
-			goto unsupported;
+		mt753x_mac_config(ds, port, mode, state);
 		break;
 	case 6: /* Port 6, can be used as a CPU port. */
 		if (priv->p6_configured)
 			break;
 
-		if (mt753x_mac_config(ds, port, mode, state) < 0)
-			goto unsupported;
+		mt753x_mac_config(ds, port, mode, state);
 		break;
-	default:
-unsupported:
-		dev_err(ds->dev, "%s: unsupported %s port: %i\n",
-			__func__, phy_modes(state->interface), port);
-		return;
 	}
 
 	mcr_cur = mt7530_read(priv, MT7530_PMCR_P(port));
@@ -2805,7 +2758,6 @@ mt7531_cpu_port_config(struct dsa_switch *ds, int port)
 	struct mt7530_priv *priv = ds->priv;
 	phy_interface_t interface;
 	int speed;
-	int ret;
 
 	switch (port) {
 	case 5:
@@ -2830,9 +2782,8 @@ mt7531_cpu_port_config(struct dsa_switch *ds, int port)
 	else
 		speed = SPEED_1000;
 
-	ret = mt7531_mac_config(ds, port, MLO_AN_FIXED, interface);
-	if (ret)
-		return ret;
+	mt7531_mac_config(ds, port, MLO_AN_FIXED, interface);
+
 	mt7530_write(priv, MT7530_PMCR_P(port),
 		     PMCR_CPU_PORT_SETTING(priv->id));
 	mt753x_phylink_pcs_link_up(&priv->pcs[port].pcs, MLO_AN_FIXED,
diff --git a/drivers/net/dsa/mt7530.h b/drivers/net/dsa/mt7530.h
index f7a504e4c17b..b7f80a487073 100644
--- a/drivers/net/dsa/mt7530.h
+++ b/drivers/net/dsa/mt7530.h
@@ -722,7 +722,7 @@ struct mt753x_info {
 	void (*mac_port_validate)(struct dsa_switch *ds, int port,
 				  phy_interface_t interface,
 				  unsigned long *supported);
-	int (*mac_port_config)(struct dsa_switch *ds, int port,
+	void (*mac_port_config)(struct dsa_switch *ds, int port,
 			       unsigned int mode,
 			       phy_interface_t interface);
 };
-- 
2.37.2

