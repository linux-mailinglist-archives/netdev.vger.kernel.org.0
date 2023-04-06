Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EEB86D9397
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 12:05:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236525AbjDFKFG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 06:05:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229771AbjDFKFC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 06:05:02 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 246F1B4;
        Thu,  6 Apr 2023 03:04:56 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id v6-20020a05600c470600b003f034269c96so13209797wmo.4;
        Thu, 06 Apr 2023 03:04:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680775494;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=R+hM+tHbZ+If23R2mU7acrR6jDzcA+O5nuDMi4zO4as=;
        b=q3jLRL06yCZXCxmeAix65vVky2IHzonw+BRHtCwQzoVkoxpeV4EB6KarHxMUvMca3M
         iyqQ4SWZH4TJIs6jzmoSMDUcvCVXoK3TlGLOFntwP8aHnJfuyuhLildwO6LK6FhGHIhh
         NLEn+X72WwvFXbrPifwoog3Y+LjoVoGWQguMsGSpGpIAJGEmERTLT2zhknS8LacCG7TI
         s3A+MPWuchAfqTBBkU7Yg1nBPVQUbqgDprh3DfqpbWGLDOGlNnP7meA89dP+U5X/4i6m
         qSLyGmxowmbnWPLbLWzzHUR6pUAPPhVIb2c2YYezWj0FmpRlVTQhBClC7wW5HxffqXiF
         mbpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680775494;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=R+hM+tHbZ+If23R2mU7acrR6jDzcA+O5nuDMi4zO4as=;
        b=11G/WQ9xOpsT6YGJYHvafr5lulnYUgwg9kndTRWt24qtRRfKoIyKKbBrN0hApzQbJV
         Fu0uteMlh+idqHQCjS8hOYeokakUWfbMyQdTYET+aFO1boLGgE3l8SXLW7iB7efXGss2
         FHo63OKrLgH9tAne+VDZ+HdMrSmoYwWkTz4+uMDA7QelnDNRc0iwgu3Q8WqOiNIooA7m
         t7owootTBaHxoAWA+cKRcR/qRqUDpKssxCIbkdzg10HoxfO63vCZ6VrVOWSNJQg+NOsn
         rBpmHS28zYrX+Wh71MCNjASiERKWXOHxu7Lplmz0Zmlid1UNdiWxPMeQX0qguGAzPI6o
         NXTw==
X-Gm-Message-State: AAQBX9fYVLLF4Kx/NZuzj6JhJpD1GScpYVO8AtE1gbEU/BZ7ZFns4Ygz
        8J694UtUPNt7+qt/2nRn4XQ=
X-Google-Smtp-Source: AKy350ZVk2iGHOLHwn6dfuv7zfbt8FK/X9Xx8C/5BG6iVRJi95CMyi1tjC7ZPIIAGKvS8EoeXDG+/Q==
X-Received: by 2002:a05:600c:2216:b0:3e2:1dac:b071 with SMTP id z22-20020a05600c221600b003e21dacb071mr3872433wml.13.1680775494418;
        Thu, 06 Apr 2023 03:04:54 -0700 (PDT)
Received: from arinc9-PC.lan ([149.91.1.15])
        by smtp.gmail.com with ESMTPSA id a13-20020adfe5cd000000b002cea8664304sm1293939wrn.91.2023.04.06.03.04.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Apr 2023 03:04:53 -0700 (PDT)
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
        <angelogioacchino.delregno@collabora.com>
Cc:     =?UTF-8?q?Ar=C4=B1n=C3=A7=20=C3=9CNAL?= <arinc.unal@arinc9.com>,
        erkin.bozoglu@xeront.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [RFC PATCH net-next] net: dsa: mt7530: fix port specifications for MT7988
Date:   Thu,  6 Apr 2023 13:04:45 +0300
Message-Id: <20230406100445.52915-1-arinc.unal@arinc9.com>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arınç ÜNAL <arinc.unal@arinc9.com>

On the switch on the MT7988 SoC, there are only 4 PHYs. There's only port 6
as the CPU port, there's no port 5. Split the switch statement with a check
to enforce these for the switch on the MT7988 SoC. The internal phy-mode is
specific to MT7988 so put it for MT7988 only.

Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
---

Daniel, this is based on the information you provided me about the switch.
I will add this to my current patch series if it looks good to you.

Arınç

---
 drivers/net/dsa/mt7530.c | 67 ++++++++++++++++++++++++++--------------
 1 file changed, 43 insertions(+), 24 deletions(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index 6fbbdcb5987f..f167fa135ef1 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -2548,7 +2548,7 @@ static void mt7988_mac_port_get_caps(struct dsa_switch *ds, int port,
 	phy_interface_zero(config->supported_interfaces);
 
 	switch (port) {
-	case 0 ... 4: /* Internal phy */
+	case 0 ... 3: /* Internal phy */
 		__set_bit(PHY_INTERFACE_MODE_INTERNAL,
 			  config->supported_interfaces);
 		break;
@@ -2710,37 +2710,56 @@ mt753x_phylink_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
 	struct mt7530_priv *priv = ds->priv;
 	u32 mcr_cur, mcr_new;
 
-	switch (port) {
-	case 0 ... 4: /* Internal phy */
-		if (state->interface != PHY_INTERFACE_MODE_GMII &&
-		    state->interface != PHY_INTERFACE_MODE_INTERNAL)
-			goto unsupported;
-		break;
-	case 5: /* Port 5, a CPU port. */
-		if (priv->p5_interface == state->interface)
+	if (priv->id == ID_MT7988) {
+		switch (port) {
+		case 0 ... 3: /* Internal phy */
+			if (state->interface != PHY_INTERFACE_MODE_INTERNAL)
+				goto unsupported;
 			break;
+		case 6: /* Port 6, a CPU port. */
+			if (priv->p6_interface == state->interface)
+				break;
 
-		if (mt753x_mac_config(ds, port, mode, state) < 0)
+			if (mt753x_mac_config(ds, port, mode, state) < 0)
+				goto unsupported;
+
+			priv->p6_interface = state->interface;
+			break;
+		default:
 			goto unsupported;
+		}
+	} else {
+		switch (port) {
+		case 0 ... 4: /* Internal phy */
+			if (state->interface != PHY_INTERFACE_MODE_GMII)
+				goto unsupported;
+			break;
+		case 5: /* Port 5, a CPU port. */
+			if (priv->p5_interface == state->interface)
+				break;
 
-		if (priv->p5_intf_sel == P5_INTF_SEL_GMAC5 ||
-		    priv->p5_intf_sel == P5_INTF_SEL_GMAC5_SGMII)
-			priv->p5_interface = state->interface;
-		break;
-	case 6: /* Port 6, a CPU port. */
-		if (priv->p6_interface == state->interface)
+			if (mt753x_mac_config(ds, port, mode, state) < 0)
+				goto unsupported;
+
+			if (priv->p5_intf_sel == P5_INTF_SEL_GMAC5 ||
+			priv->p5_intf_sel == P5_INTF_SEL_GMAC5_SGMII)
+				priv->p5_interface = state->interface;
 			break;
+		case 6: /* Port 6, a CPU port. */
+			if (priv->p6_interface == state->interface)
+				break;
 
-		if (mt753x_mac_config(ds, port, mode, state) < 0)
-			goto unsupported;
+			if (mt753x_mac_config(ds, port, mode, state) < 0)
+				goto unsupported;
 
-		priv->p6_interface = state->interface;
-		break;
-	default:
+			priv->p6_interface = state->interface;
+			break;
+		default:
 unsupported:
-		dev_err(ds->dev, "%s: unsupported %s port: %i\n",
-			__func__, phy_modes(state->interface), port);
-		return;
+			dev_err(ds->dev, "%s: unsupported %s port: %i\n",
+				__func__, phy_modes(state->interface), port);
+			return;
+		}
 	}
 
 	mcr_cur = mt7530_read(priv, MT7530_PMCR_P(port));
-- 
2.37.2

