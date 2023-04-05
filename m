Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0AF16D88C3
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 22:39:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234248AbjDEUjh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 16:39:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233431AbjDEUjQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 16:39:16 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2336559D5;
        Wed,  5 Apr 2023 13:39:15 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id v20-20020a05600c471400b003ed8826253aso2756968wmo.0;
        Wed, 05 Apr 2023 13:39:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680727153;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=E0IMeO1O4SBYZQwg5+XaETPP4flNHm2gc4lWDzFifZI=;
        b=mi7PrvZmmvLEO+3MKptjpM80IcUEqSCRCtCJIny9XFduJeLpEnTUAXzOk8cEf6CcPO
         Xl2gw36OSSAUO8EhYEticwUjDS8haigdxksMlOZzUzmyDZmpfs+OekQlqeOAI0oQFWLx
         MjbQB7cxX2F1nKtmLFZRB3mx4bdKVzCrIYwIfuYP+nciACktK8ciENNRAqydQwwTpgm3
         v+4fkqOv0Ge2UXnMvxQjtTmR6vk6bMC6SMiA7Y+cc4cq4UicGEeVkeSs/6V2OFtExoF7
         bznc1ooFPRdTUBXsUnsFyTHh429aJmgPbnOAzOVNqejlTO47eqx+Xv1wtl58/CZPFU51
         7gxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680727153;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=E0IMeO1O4SBYZQwg5+XaETPP4flNHm2gc4lWDzFifZI=;
        b=bLEJliYhTAwtVP08jx7FpdgBCFUtP975TbIyV+6GOQ+3fsLcyjIu3VbkmNRJXXlo26
         k7+LntBKd5rqZ9UwgL0elTgszIkBbAZJocH1Ts1N0F2ncZd8Z+XB0AUOUoMl4dDVZkjK
         tHHpRK+/1szvgD80OYLQOobauJl1mTLgp29SRP1DPMZaSdZo81dRNajbqERAHG/FYgwF
         jGMdwcDujqobRy5CunDDhuj6ZR/psog/LF1d2696bxP1FFCDzPLiwXuyzV7Hn80GjZrH
         yiNMx6NetJ4ME6wLD7VDomuUD+/35sNA9IkpPMMfKir+UETJVYqtF1T2mufGMX1ziErJ
         qgpw==
X-Gm-Message-State: AAQBX9dtWMG4IucF3eIImTfdGzD2IzCEgQJUzCYLlap+i2gK2fWoioX8
        3mw5s4rl0kPrqh6Rh2qLDXg=
X-Google-Smtp-Source: AKy350Z5iIa4fumSDUmJ7ok3oTLcRfGGebEHh0loZFWOHE06MqRBazTetiRRs+kMSZS76dSAraf2RA==
X-Received: by 2002:a05:600c:b51:b0:3ed:2a91:3bc9 with SMTP id k17-20020a05600c0b5100b003ed2a913bc9mr5946344wmr.15.1680727153425;
        Wed, 05 Apr 2023 13:39:13 -0700 (PDT)
Received: from arinc9-PC.lan ([149.91.1.15])
        by smtp.gmail.com with ESMTPSA id p19-20020a05600c469300b003eda46d6792sm3259867wmo.32.2023.04.05.13.39.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Apr 2023 13:39:13 -0700 (PDT)
From:   arinc9.unal@gmail.com
X-Google-Original-From: arinc.unal@arinc9.com
To:     =?UTF-8?q?Ren=C3=A9=20van=20Dorst?= <opensource@vdorst.com>,
        Sean Wang <sean.wang@mediatek.com>,
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
        Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>,
        Richard van Schagen <richard@routerhints.com>,
        Richard van Schagen <vschagen@cs.com>,
        Frank Wunderlich <frank-w@public-files.de>,
        erkin.bozoglu@xeront.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [RFC PATCH net-next 04/12] net: dsa: mt7530: set priv->p5_interface in correct conditions
Date:   Wed,  5 Apr 2023 23:38:51 +0300
Message-Id: <20230405203859.391267-5-arinc.unal@arinc9.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20230405203859.391267-1-arinc.unal@arinc9.com>
References: <20230405203859.391267-1-arinc.unal@arinc9.com>
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

Currently, priv->p5_interface is set on mt7530_setup_port5() even though
it's being set on mt753x_phylink_mac_config() after mt7530_setup_port5() is
run.

The only case for setting priv->p5_interface on mt7530_setup_port5() is
when PHY muxing is enabled. That is because port 5 is not defined as a port
on the devicetree, therefore, it cannot be controlled by phylink.

To address this, set priv->p5_interface only if PHY muxing is enabled.

On mt753x_phylink_mac_config, != P5_DISABLED is enough but to be explicit,
look for p5_intf_sel being P5_INTF_SEL_GMAC5 or P5_INTF_SEL_GMAC5_SGMII.

Tested-by: Arınç ÜNAL <arinc.unal@arinc9.com>
Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
---

If you think priv->p5_interface should not be set when port 5 is used for
PHY muxing, let me know.

Arınç

---
 drivers/net/dsa/mt7530.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index 9ab2e128b564..fccd59564532 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -976,7 +976,9 @@ static void mt7530_setup_port5(struct dsa_switch *ds, phy_interface_t interface)
 	dev_dbg(ds->dev, "Setup P5, HWTRAP=0x%x, intf_sel=%s, phy-mode=%s\n",
 		val, p5_intf_modes(priv->p5_intf_sel), phy_modes(interface));
 
-	priv->p5_interface = interface;
+	if (priv->p5_intf_sel == P5_INTF_SEL_PHY_P0 ||
+	    priv->p5_intf_sel == P5_INTF_SEL_PHY_P4)
+		priv->p5_interface = interface;
 
 unlock_exit:
 	mutex_unlock(&priv->reg_mutex);
@@ -2746,7 +2748,8 @@ mt753x_phylink_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
 		if (mt753x_mac_config(ds, port, mode, state) < 0)
 			goto unsupported;
 
-		if (priv->p5_intf_sel != P5_DISABLED)
+		if (priv->p5_intf_sel == P5_INTF_SEL_GMAC5 ||
+		    priv->p5_intf_sel == P5_INTF_SEL_GMAC5_SGMII)
 			priv->p5_interface = state->interface;
 		break;
 	case 6: /* Port 6, a CPU port. */
-- 
2.37.2

