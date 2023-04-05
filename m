Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A352F6D88C8
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 22:39:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234096AbjDEUjt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 16:39:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234117AbjDEUjg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 16:39:36 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6C986A44;
        Wed,  5 Apr 2023 13:39:19 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id m6-20020a05600c3b0600b003ee6e324b19so22722327wms.1;
        Wed, 05 Apr 2023 13:39:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680727158;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ry2z2xzBFl6Ly3vSlf60f+roED9HAgz7ua4fkZgzGE0=;
        b=B10ji6xoiT0KxNstoIf5OK4ul/y1PldmpWHRRnHJt1TTMY8uy1Ri+rx+FbMG8mP5nx
         wTD2y33SyfmX093zp8tIpavy1sb+9KEomRXl/FO+f6xxOC/m9jruqhWPxaIQCdu1LVNf
         uvT/t3r/to1RYojP7TVRl8ook1fgIpCss11RcOxcLXlUurmJsQbXhBALHRSAFxiVVg5f
         ymEWzmFrLRRgAiYlmWj3C/y8x2kup19rTBLxrMKnHg+Y4h4mBKBFP6Nb/S9p9nmqCFSs
         KocXGXZdx8t7MCkX7DZ82p2f7imGHXztIQEeRqlIiNfvyu1RFK2Do2NIrLimLMw8Z5ff
         bpIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680727158;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ry2z2xzBFl6Ly3vSlf60f+roED9HAgz7ua4fkZgzGE0=;
        b=qWpyjiwgC0OjPptaSUwhq9JuEnu8lum84Nnm8CllOTYCRdlu+2OaUs7c4czK09K/Cn
         +lB4bVkrL3XUcG42oF0S4ylcuPODEJHyHwt10nX6hR0Lh2CHLpcxQSIRmdfSiJB1Rfd4
         YiWnVe5RHV+3x92FcqnpbLBvgxvDXOJo3KXf0m5f1M5glK8mZGOBlf2g1k4jJhTppRFV
         dpgh3yZCPHyFi0u9X3+YywMHhlN0Rl4+JrXMIbGgUaziXhSapFhYPU6Otjyf3rvCikly
         /VzQi8hzGLLOABTiecRdCaj5NSO6tM7I3Cld6VTo/x7M8b6/YFuSyz41eJBW2fFg+pss
         CqAw==
X-Gm-Message-State: AAQBX9cDdB2Uo0jOtjIJMcM5p8d/DgFK80kLYNHAky8Nxy1E81nSg419
        hy1vYXEPQwv7fToPFF8X2cg=
X-Google-Smtp-Source: AKy350bQFfU4n56kkWO8UhzXgxMrHnZq+NNzuA43JcBRFIly5bQiINuogGqFG5ekfNdRs/vk5zwdgA==
X-Received: by 2002:a05:600c:ace:b0:3ed:ea48:cd92 with SMTP id c14-20020a05600c0ace00b003edea48cd92mr5970347wmr.15.1680727158320;
        Wed, 05 Apr 2023 13:39:18 -0700 (PDT)
Received: from arinc9-PC.lan ([149.91.1.15])
        by smtp.gmail.com with ESMTPSA id p19-20020a05600c469300b003eda46d6792sm3259867wmo.32.2023.04.05.13.39.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Apr 2023 13:39:17 -0700 (PDT)
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
Subject: [RFC PATCH net-next 06/12] net: dsa: mt7530: do not set CPU port interfaces to PHY_INTERFACE_MODE_NA
Date:   Wed,  5 Apr 2023 23:38:53 +0300
Message-Id: <20230405203859.391267-7-arinc.unal@arinc9.com>
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

There is no need to set priv->p5_interface and priv->p6_interface to
PHY_INTERFACE_MODE_NA on mt7530_setup() and mt7531_setup().

As Vladimir explained, in include/linux/phy.h we have:

typedef enum {
	PHY_INTERFACE_MODE_NA,

In lack of other initialiser, the first element of an enum gets the value 0
in C.

Then, "priv" is allocated by this driver with devm_kzalloc(), which means
that its entire memory is zero-filled. So priv->p5_interface and
priv->p6_interface are already set to 0, PHY_INTERFACE_MODE_NA.

There is no code path between the devm_kzalloc(), and the position in
mt7530_setup() and mt7531_setup() that would change the value of
priv->p5_interface or priv->p6_interface from 0.

The only place they are modified is mt753x_phylink_mac_config() but
mt753x_phylink_mac_config() runs after mt753x_setup(), as can be seen on
the code path below.

mt7530_probe()
   -> dsa_register_switch()
      -> dsa_switch_probe()
         -> dsa_tree_setup()
            -> dsa_tree_setup_switches()
               -> dsa_switch_setup()
                  -> ds->ops->setup(): mt753x_setup()
            -> dsa_tree_setup_ports()
               -> dsa_port_setup()
                  [...]
                  -> dsa_port_phylink_create()
                     [...]
                     -> phylink_mac_config()
                        -> pl->mac_ops->mac_config():
                           dsa_port_phylink_mac_config()
                           -> ds->ops->phylink_mac_config():
                              mt753x_phylink_mac_config()

Therefore, do not put 0 into a variable containing 0.

Tested-by: Arınç ÜNAL <arinc.unal@arinc9.com>
Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
---
 drivers/net/dsa/mt7530.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index 8a47dcb96cdf..fc5428baa905 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -2247,8 +2247,6 @@ mt7530_setup(struct dsa_switch *ds)
 	val |= MHWTRAP_MANUAL;
 	mt7530_write(priv, MT7530_MHWTRAP, val);
 
-	priv->p6_interface = PHY_INTERFACE_MODE_NA;
-
 	/* Enable and reset MIB counters */
 	mt7530_mib_reset(ds);
 
@@ -2466,10 +2464,6 @@ mt7531_setup(struct dsa_switch *ds)
 	mt7530_rmw(priv, MT7531_GPIO_MODE0, MT7531_GPIO0_MASK,
 		   MT7531_GPIO0_INTERRUPT);
 
-	/* Let phylink decide the interface later. */
-	priv->p5_interface = PHY_INTERFACE_MODE_NA;
-	priv->p6_interface = PHY_INTERFACE_MODE_NA;
-
 	/* Enable PHY core PLL, since phy_device has not yet been created
 	 * provided for phy_[read,write]_mmd_indirect is called, we provide
 	 * our own mt7531_ind_mmd_phy_[read,write] to complete this
-- 
2.37.2

