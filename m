Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 539126C94F9
	for <lists+netdev@lfdr.de>; Sun, 26 Mar 2023 16:09:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231984AbjCZOJA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Mar 2023 10:09:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232134AbjCZOIs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Mar 2023 10:08:48 -0400
Received: from mail-qv1-xf2b.google.com (mail-qv1-xf2b.google.com [IPv6:2607:f8b0:4864:20::f2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFBD35FF9;
        Sun, 26 Mar 2023 07:08:41 -0700 (PDT)
Received: by mail-qv1-xf2b.google.com with SMTP id g9so5080617qvt.8;
        Sun, 26 Mar 2023 07:08:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679839721;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OZg7tvfajeNq18GFXC3qap3a+zEsuUc1lJRtB/LOjbQ=;
        b=kue9NahdmEFNFyi9Z9Kz+d6ev+kVXTNIPGO4kEw4t5gZOePO6QCbTzsp4J2nifJLua
         IvVE35jxat4ieYUrXcrzHb4x5W8p21TysgFzvp0p3/vYkBbV5xwuumCEx5OpRm2qmQtR
         +3IWUiRLB2cZp6IJJU6nDHArLhTbp/oIdO32Y0dDpSr8oFTBKDLmLF3dKLFNAnblnK5E
         4Wr86j1QaZ147zL0eak8zzxON0GVY/gePSBwTsdoQFwVkQfYDidKNTZOixQfy+FyO8aW
         AJ8VdyTPDzdGSbVFJZL7iWEcjrMXBhsbSF0B9Uw9ZkNCWVH6GG9dy31Dl3335S/Y7vM8
         NuzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679839721;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OZg7tvfajeNq18GFXC3qap3a+zEsuUc1lJRtB/LOjbQ=;
        b=qZq30z6DP7mQmpRhIKfIIsfWOJ+WrJGCqX8zgjSFrYjTuNMi9YjqaCecK2HsxYYYHL
         3g1Rq+NBuvflzMG/qLReTe9C7WOAm6Gv3C4EQTHuxbTF6l2YE+22tBDyXqN8R5J6JdO7
         eurl3ev7+Ll5XnTPrIzV+oP45YyHCnObR2+VVs2lG2AHJ9je9Z3IX78QY2sV277eXdW/
         XAFazjMmg9GOkEuv9caxzPOMCEXh4vfo/oiOfvION8Z3q13txlq8QGHkkxyqTX1yy77Q
         MP5N9W/K6jsdQjOAAashkqov+F47pYKZe4CDjmliLMTvN34JpjYxlzZXDcHQxuHAtgCG
         iqDw==
X-Gm-Message-State: AAQBX9dYfK0CPCJgdtUplAqLFFuVlN3hsz9WoDx5h6/+r/EggiPCemBH
        XR35/JneLinnt7C9LsXqhD8=
X-Google-Smtp-Source: AKy350bUQGpng0t7Er8DLfWm+MeX5EgNvC3Zf1IA9OKQCjTVHq37FERAld7067znB0Xsj5mlftsQqw==
X-Received: by 2002:a05:6214:e66:b0:583:8e58:6c0f with SMTP id jz6-20020a0562140e6600b005838e586c0fmr13020778qvb.40.1679839721008;
        Sun, 26 Mar 2023 07:08:41 -0700 (PDT)
Received: from arinc9-PC.lan ([149.91.1.15])
        by smtp.gmail.com with ESMTPSA id j5-20020a0ce6a5000000b005dd8b93458esm2212220qvn.38.2023.03.26.07.08.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Mar 2023 07:08:40 -0700 (PDT)
From:   arinc9.unal@gmail.com
X-Google-Original-From: arinc.unal@arinc9.com
To:     Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Russell King <linux@armlinux.org.uk>,
        =?UTF-8?q?Ren=C3=A9=20van=20Dorst?= <opensource@vdorst.com>
Cc:     =?UTF-8?q?Ar=C4=B1n=C3=A7=20=C3=9CNAL?= <arinc.unal@arinc9.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Landen Chao <landen.chao@mediatek.com>,
        Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>,
        Richard van Schagen <richard@routerhints.com>,
        Richard van Schagen <vschagen@cs.com>,
        Frank Wunderlich <frank-w@public-files.de>,
        erkin.bozoglu@xeront.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH net 3/7] net: dsa: mt7530: do not run mt7530_setup_port5() if port 5 is disabled
Date:   Sun, 26 Mar 2023 17:08:14 +0300
Message-Id: <20230326140818.246575-4-arinc.unal@arinc9.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20230326140818.246575-1-arinc.unal@arinc9.com>
References: <20230326140818.246575-1-arinc.unal@arinc9.com>
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

There's no need to run all the code on mt7530_setup_port5() if port 5 is
disabled. Run mt7530_setup_port5() if priv->p5_intf_sel is not P5_DISABLED
and remove the P5_DISABLED case from mt7530_setup_port5().

Stop initialising the interface variable as the remaining cases will always
call mt7530_setup_port5() with it initialised.

Fixes: 38f790a80560 ("net: dsa: mt7530: Add support for port 5")
Tested-by: Arınç ÜNAL <arinc.unal@arinc9.com>
Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
---
 drivers/net/dsa/mt7530.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index eba356249ada..6d33c1050458 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -949,9 +949,6 @@ static void mt7530_setup_port5(struct dsa_switch *ds, phy_interface_t interface)
 		/* MT7530_P5_MODE_GMAC: P5 -> External phy or 2nd GMAC */
 		val &= ~MHWTRAP_P5_DIS;
 		break;
-	case P5_DISABLED:
-		interface = PHY_INTERFACE_MODE_NA;
-		break;
 	default:
 		dev_err(ds->dev, "Unsupported p5_intf_sel %d\n",
 			priv->p5_intf_sel);
@@ -2257,7 +2254,6 @@ mt7530_setup(struct dsa_switch *ds)
 		 * Determine if phy muxing is defined and which phy to mux.
 		 */
 		priv->p5_intf_sel = P5_DISABLED;
-		interface = PHY_INTERFACE_MODE_NA;
 
 		for_each_child_of_node(dn, mac_np) {
 			if (!of_device_is_compatible(mac_np,
@@ -2290,7 +2286,8 @@ mt7530_setup(struct dsa_switch *ds)
 			break;
 		}
 
-		mt7530_setup_port5(ds, interface);
+		if (priv->p5_intf_sel != P5_DISABLED)
+			mt7530_setup_port5(ds, interface);
 	}
 
 #ifdef CONFIG_GPIOLIB
-- 
2.37.2

