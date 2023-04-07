Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B7B26DAE48
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 15:49:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233753AbjDGNtl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 09:49:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233084AbjDGNsg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 09:48:36 -0400
Received: from mail-yw1-x1135.google.com (mail-yw1-x1135.google.com [IPv6:2607:f8b0:4864:20::1135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28CA1BDCF;
        Fri,  7 Apr 2023 06:47:08 -0700 (PDT)
Received: by mail-yw1-x1135.google.com with SMTP id 00721157ae682-5491fa028adso300433117b3.10;
        Fri, 07 Apr 2023 06:47:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680875223;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ry2z2xzBFl6Ly3vSlf60f+roED9HAgz7ua4fkZgzGE0=;
        b=nvabayHRaa0wJNq5xr3lp6l3ZDlC5KFNMNjRRnz9aSNijFWOS7QmbHM8oCFQcscqD9
         Iv7GTUuGeVdhLvDRMdfL3jidQZa+qM+MmavROSLl2te5yMbpSNhMCNiAyaa6QkjckIlv
         +yQDAOjsc/6p5XsmUd5MmhRumvNYA50UAvy0EbG0rsN9SKtXJYePV6anYLe7eaPEiK9o
         0njzayi/bq+89C+fdmkavyuzb1deC+SI+RlVOt8rnvsu5mVdq4DWohClqH6GppHEPGub
         5TtoANm2RKrWq3pVkGvXNU5a5dvMwKzDSeUQmlsNtJLY3I3QIPxmFdWGuHbd1xPYu8gv
         Ayfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680875223;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ry2z2xzBFl6Ly3vSlf60f+roED9HAgz7ua4fkZgzGE0=;
        b=x3M9w+bRvhAsX0CBSntvC8Pv/CquRzDU7hQF68V3ruFHmt4Any4b/Yk7HrhCStfFOO
         uGyW4fpk5g0Vqm1QdUuXxtd2yCzCbuPZ8m/kfeNN/emUC5YOGagFbF7pSyeRN3O4gScg
         p/LpMhMMEQ27YSjNBaMLENRrU60vhDzVZ1i4Lzl2kkhGVrzKdhjBAPkDKv/6zen1VlXy
         bOlN+XakqB7QCTsv/KQC56VQ7uxCS1y8J2xAaVdqep3tD72dN5/8XE2Cpa7CpFy1zZwY
         8SIXKHK5w6Hg7zdH0eEIuMgmLBiF8asrEJ5zjBfFePhygANc4udqvqvchfFk+4GUQ9AM
         Zigg==
X-Gm-Message-State: AAQBX9eRHa7CygizTRTq6oHPZkyXX2wHVI4Oki1Avsgs3m4UoziJ9s0D
        g4T2YX3B8VPvEGcT8pviePo=
X-Google-Smtp-Source: AKy350YW7y265QatP/CV0i11Fyx7KsB2qxeRvdCVwy2fI9QdnVPoo69cQtD3E9zcZyaw2/YvhyONFQ==
X-Received: by 2002:a81:9105:0:b0:541:a151:fe72 with SMTP id i5-20020a819105000000b00541a151fe72mr1793803ywg.39.1680875222720;
        Fri, 07 Apr 2023 06:47:02 -0700 (PDT)
Received: from arinc9-PC.lan ([149.91.1.15])
        by smtp.gmail.com with ESMTPSA id 139-20020a810e91000000b00545a0818473sm1034317ywo.3.2023.04.07.06.46.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Apr 2023 06:47:02 -0700 (PDT)
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
Subject: [RFC PATCH v2 net-next 06/14] net: dsa: mt7530: do not set CPU port interfaces to PHY_INTERFACE_MODE_NA
Date:   Fri,  7 Apr 2023 16:46:18 +0300
Message-Id: <20230407134626.47928-7-arinc.unal@arinc9.com>
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

