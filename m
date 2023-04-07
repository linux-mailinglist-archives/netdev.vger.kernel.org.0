Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 451926DAE42
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 15:49:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232354AbjDGNtK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 09:49:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232102AbjDGNs1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 09:48:27 -0400
Received: from mail-yw1-x1133.google.com (mail-yw1-x1133.google.com [IPv6:2607:f8b0:4864:20::1133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68697BDE7;
        Fri,  7 Apr 2023 06:46:57 -0700 (PDT)
Received: by mail-yw1-x1133.google.com with SMTP id 00721157ae682-5491fa028adso300426067b3.10;
        Fri, 07 Apr 2023 06:46:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680875213;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=crYfk2VDIQF894aVQJBbVhrnboljTGA23/Z6qxtRjD0=;
        b=QY+JalpFS6CArA2lrrReVeAa2wVaum9DzGiL//HC2IZCot6mehT7TTubrAM34WoH4v
         bjD2iOhSj6XgUDYZtrCf1tRoZM2T5r+kHBIHctNa5KRCGRDnRH+CPvPVh2MbdmPfXerV
         4ZPSjhu65Avak1reJ5XEpF5TIzdgUo9hVnD9YA1KOXSm/QCqAROiGt5j2pC8T3GI0Gi8
         DO8I2stIfAKP2mUw6+UvQgSv94v41jSH10z9+Yk7DhdKEIp+edhIe9KgyXwG1jU29x25
         5YCmpxjjsQFDn7tONHozn++go+gA9HsSZ5z1fIeHgTLmCjlRUBWekd8K4kFjCeqt9biA
         HOTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680875213;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=crYfk2VDIQF894aVQJBbVhrnboljTGA23/Z6qxtRjD0=;
        b=PNABwoaXBsHj/h8JRm+jyEzxZ1Ns6uRU/KIwiD4nDpR7hu47Oi5L69zeTG4o1o/S9J
         VFyQ5tIdZsSteCaeHXLZ366o1fPSmUab3i1hnJmzHMdBwAqCkfypR8/U3WRKagCvgflu
         Whw30xS/MCIyI2rNEn5mYwFawohlkv70qEstfzD9UE6ArDuLR60+ZrOCWqZivTsDYkxJ
         kYq8tzFdE4NMR7x+cmlJGICsQDcN0tLBecu/DP5eIpY0WeX/pPLjpiRaRUM5LYPzdP4d
         ZxcMg3ppsIVHwb8dSsoFdY7bT6oqzuDm3cmvZgG4DVzBd7zgxVVHm8zOpSr0s+pusSfi
         zmiA==
X-Gm-Message-State: AAQBX9cf8kyLOUrMbB42o0x9LgfG6/3bnHaGIR1gV01dh8saCr5AqeTO
        xoCVrFEKrHlJ3D9XH9IEd5k=
X-Google-Smtp-Source: AKy350YCviPdDCOMqYkjoXEQJo3vspWZPzx5722NzonIxcctqluA1mW7IKTic0Bg6HEGuQ5EyGmWnQ==
X-Received: by 2002:a81:63d5:0:b0:545:e54f:b1ff with SMTP id x204-20020a8163d5000000b00545e54fb1ffmr1848742ywb.4.1680875213597;
        Fri, 07 Apr 2023 06:46:53 -0700 (PDT)
Received: from arinc9-PC.lan ([149.91.1.15])
        by smtp.gmail.com with ESMTPSA id 139-20020a810e91000000b00545a0818473sm1034317ywo.3.2023.04.07.06.46.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Apr 2023 06:46:53 -0700 (PDT)
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
        erkin.bozoglu@xeront.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [RFC PATCH v2 net-next 04/14] net: dsa: mt7530: set priv->p5_interface in correct conditions
Date:   Fri,  7 Apr 2023 16:46:16 +0300
Message-Id: <20230407134626.47928-5-arinc.unal@arinc9.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20230407134626.47928-1-arinc.unal@arinc9.com>
References: <20230407134626.47928-1-arinc.unal@arinc9.com>
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

