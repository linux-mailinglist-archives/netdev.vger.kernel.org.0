Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 122F66EDE0E
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 10:30:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233699AbjDYIax (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Apr 2023 04:30:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233696AbjDYIa2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Apr 2023 04:30:28 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7242A5276;
        Tue, 25 Apr 2023 01:30:06 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id a640c23a62f3a-94f6c285d92so1016487566b.3;
        Tue, 25 Apr 2023 01:30:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682411404; x=1685003404;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eABp2T9EGqsly6qmK4v+G30KCoQ1T2FiObQ9xyRbH5o=;
        b=cB2aKGIKnK8sXy/Np6pdmxyc+H4rqYNIVyGo0WJHquZ4p1zxP/OkiRB7B5VPV33B7T
         E6fuLwcVajOBonc8NJ6DBT3VMTZXWjNyYQ1mnvg1dCh/5jN6rKD9LJGPhXB9ivuhPK8C
         rItsC6KgUAbEEiIYHncPzBKzs0p0kZdUP2hGnO06QAUHSiYr8gTlUZBpomQ0dzCVzaOK
         fntcT2UXSJ17Zv+v3gE/FHQ6gmKtNZeZU+819BJ8KyzWOxKYYRegkWHY+8/7YOD35cIR
         txiPeeN6E4etTGJ9qROOlONRBmkSa6alo7mf5poLGjr9q/yfXmkrSUk7sq6qaCU686Bm
         Qodg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682411404; x=1685003404;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eABp2T9EGqsly6qmK4v+G30KCoQ1T2FiObQ9xyRbH5o=;
        b=VSiZs0QVk4+xHMAQGsxV1aqjc85e+32W8dS+IGalmZrS/nvtxlNYRevjfEgBgadx3I
         m2VFc0fsbY0mLdOuwHSVKzJR3YAxHD7jN2XdHzAT11D+QsNRWTKu+2ED6telyXlRpWv4
         6KotVNNqF/5COgCAz88C5/dpBj4zT/MY07+G0bOLjxDUF+YMu5BbKU74McmSvhmn5JBW
         jlZBOAedFt5BgnBi1llvWXO9j8GZheSl8U8ZefaRjr7f4nZNTKDjol0xBXRPhpDm4BmK
         MZhRm8Lo1tVw12sCSZ0QWBm6P/DsIVB1BrmOY+e4xJrnGl45GXXX9gEvfpo3Wd7D37di
         C8mQ==
X-Gm-Message-State: AAQBX9cXDQe0Xu5bIRs33Sbkd6+G/bM7j8TAK6gy4MvG9rhUv7ZEkqg9
        IdzgSWpjpDomEE+NCT1pSKY=
X-Google-Smtp-Source: AKy350Yfh4FNIpf1J1n9WFWtoIVX5lNY5G4I5kWaXKL49JEYOX0YSizzV0wjGFCcMhOxnyzB565mnA==
X-Received: by 2002:a17:907:c06:b0:949:cb6a:b6f7 with SMTP id ga6-20020a1709070c0600b00949cb6ab6f7mr15611951ejc.56.1682411404365;
        Tue, 25 Apr 2023 01:30:04 -0700 (PDT)
Received: from arinc9-PC.lan ([149.91.1.15])
        by smtp.gmail.com with ESMTPSA id mc2-20020a170906eb4200b0094ca077c985sm6439028ejb.213.2023.04.25.01.30.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Apr 2023 01:30:03 -0700 (PDT)
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
Subject: [PATCH net-next 05/24] net: dsa: mt7530: improve comments regarding port 5 and 6
Date:   Tue, 25 Apr 2023 11:29:14 +0300
Message-Id: <20230425082933.84654-6-arinc.unal@arinc9.com>
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

There's no logic to numerically order the CPU ports. State the port number
and its capability of being used as a CPU port instead.

Remove the irrelevant PHY muxing information from
mt7530_mac_port_get_caps(). Explain the supported MII modes instead.

Remove the out of place PHY muxing information from
mt753x_phylink_mac_config(). The function is for both the MT7530 and MT7531
switches but there's no PHY muxing on MT7531.

These comments were gradually introduced with the commits below.
ca366d6c889b ("net: dsa: mt7530: Convert to PHYLINK API")
38f790a80560 ("net: dsa: mt7530: Add support for port 5")
88bdef8be9f6 ("net: dsa: mt7530: Extend device data ready for adding a new
hardware")
c288575f7810 ("net: dsa: mt7530: Add the support of MT7531 switch")

Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
Acked-by: Daniel Golle <daniel@makrotopia.org>
---
 drivers/net/dsa/mt7530.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index 29abf2745294..d0eae8e8c41d 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -2498,7 +2498,9 @@ static void mt7530_mac_port_get_caps(struct dsa_switch *ds, int port,
 			  config->supported_interfaces);
 		break;
 
-	case 5: /* 2nd cpu port with phy of port 0 or 4 / external phy */
+	case 5: /* Port 5 which can be used as a CPU port supports rgmii with
+		 * delays, mii, and gmii.
+		 */
 		phy_interface_set_rgmii(config->supported_interfaces);
 		__set_bit(PHY_INTERFACE_MODE_MII,
 			  config->supported_interfaces);
@@ -2506,7 +2508,9 @@ static void mt7530_mac_port_get_caps(struct dsa_switch *ds, int port,
 			  config->supported_interfaces);
 		break;
 
-	case 6: /* 1st cpu port */
+	case 6: /* Port 6 which can be used as a CPU port supports rgmii and
+		 * trgmii.
+		 */
 		__set_bit(PHY_INTERFACE_MODE_RGMII,
 			  config->supported_interfaces);
 		__set_bit(PHY_INTERFACE_MODE_TRGMII,
@@ -2526,14 +2530,17 @@ static void mt7531_mac_port_get_caps(struct dsa_switch *ds, int port,
 			  config->supported_interfaces);
 		break;
 
-	case 5: /* 2nd cpu port supports either rgmii or sgmii/8023z */
+	case 5: /* Port 5 which can be used as a CPU port supports rgmii with
+		 * delays on MT7531BE, sgmii/802.3z on MT7531AE.
+		 */
 		if (!priv->p5_sgmii) {
 			phy_interface_set_rgmii(config->supported_interfaces);
 			break;
 		}
 		fallthrough;
 
-	case 6: /* 1st cpu port supports sgmii/8023z only */
+	case 6: /* Port 6 which can be used as a CPU port supports sgmii/802.3z.
+		 */
 		__set_bit(PHY_INTERFACE_MODE_SGMII,
 			  config->supported_interfaces);
 		__set_bit(PHY_INTERFACE_MODE_1000BASEX,
@@ -2725,7 +2732,7 @@ mt753x_phylink_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
 		    state->interface != PHY_INTERFACE_MODE_INTERNAL)
 			goto unsupported;
 		break;
-	case 5: /* 2nd cpu port with phy of port 0 or 4 / external phy */
+	case 5: /* Port 5, can be used as a CPU port. */
 		if (priv->p5_interface == state->interface)
 			break;
 
@@ -2735,7 +2742,7 @@ mt753x_phylink_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
 		if (priv->p5_intf_sel != P5_DISABLED)
 			priv->p5_interface = state->interface;
 		break;
-	case 6: /* 1st cpu port */
+	case 6: /* Port 6, can be used as a CPU port. */
 		if (priv->p6_interface == state->interface)
 			break;
 
-- 
2.37.2

