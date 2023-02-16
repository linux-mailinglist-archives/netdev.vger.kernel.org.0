Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E536699D18
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 20:42:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229788AbjBPTmG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 14:42:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229725AbjBPTmF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 14:42:05 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60EF8442FB;
        Thu, 16 Feb 2023 11:42:04 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id bg2so2943531pjb.4;
        Thu, 16 Feb 2023 11:42:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=G4QgR2qSWRsij/ehAnuEJjnt6z8m+Ffw0O1dyxbWKi0=;
        b=nGuZSyaaUFlOotrvei+5M04+/P3PDPJxznFBTpleiPDhYXrhrPzelantnoxqJKlzol
         JtMoH2it7/MHWSHkKXYF3DSxksQ2JfPwM08qd1YORMPdsIZyxCSHseWTpNBJSUQmqPAN
         +pqbQihu3E6RPfpLoqplEB+pO3cbrGxNh7akbgRCnv3K05AXddd8TKkKGJR9EFHdUVan
         PW6lxBaNx/52T4nv7Q94o9qhB03PJJCIRk0W9Q7CXpaaTjvJ9+MbXbPn3ffHZzoRL5+W
         CyHlLDTc+NZtm0pVZ9beAa1JECG29mnLvk3aAgH1h3aobneE/IWVBQzC1zDuYAv9mCyB
         3k5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=G4QgR2qSWRsij/ehAnuEJjnt6z8m+Ffw0O1dyxbWKi0=;
        b=sA1okw6m/mMPR/IOsdP8rWTGI08msRIwwf1Pwc3ZNdF/PgklbqvogkV5QGd77lZ0mT
         uiQ3vVB3v67Ld+wgusfBgWdGmzMMO7xiFC6gE6GuhymliYAn9CspoIrCT+f7zWjx+n3C
         bsxBXW4OMJWBZjdCQFjPyJ+bd6d5fAt9b+SVejKxb/8aNsZDG7YSgFHgvV9fmL2qhd6p
         bgSU20Cd0XxIVLzWwh+c7p4rkYq9SGOvK4GrpYQLOfuVnLfcjeteS/6OYUwGhpQoCX5q
         iWPDm2Db8zF456iSgZQGDsFeSFWkNocRBT6Ak51/Lr652pwDdxioNdBVyoqKruU0NU33
         Rn8Q==
X-Gm-Message-State: AO0yUKVTm0rWwaxdEYVNCWzwZkyZ9qyUGXo3Zvch5Zzvl2RiT1gDbAPs
        32+GtLsFAZANUgz0pGAIOi8=
X-Google-Smtp-Source: AK7set9pXPabTV58jlzchU/RTq4w5XX28G9nXsYyqC1p9dhG5mJvlAcNZrtsEB0GnhZPsQNV1H7Peg==
X-Received: by 2002:a05:6a21:339b:b0:c6:d6e9:c496 with SMTP id yy27-20020a056a21339b00b000c6d6e9c496mr4017506pzb.24.1676576523823;
        Thu, 16 Feb 2023 11:42:03 -0800 (PST)
Received: from stbirv-lnx-3.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id i70-20020a639d49000000b004fbe302b3f6sm1559334pgd.74.2023.02.16.11.42.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Feb 2023 11:42:03 -0800 (PST)
From:   Doug Berger <opendmb@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Broadcom internal kernel review list 
        <bcm-kernel-feedback-list@broadcom.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Stefan Wahren <wahrenst@gmx.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Doug Berger <opendmb@gmail.com>
Subject: [PATCH net] net: bcmgenet: fix MoCA LED control
Date:   Thu, 16 Feb 2023 11:41:28 -0800
Message-Id: <20230216194128.3593734-1-opendmb@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When the bcmgenet_mii_config() code was refactored it was missed
that the LED control for the MoCA interface got overwritten by
the port_ctrl value. Its previous programming is restored here.

Fixes: 4f8d81b77e66 ("net: bcmgenet: Refactor register access in bcmgenet_mii_config")
Signed-off-by: Doug Berger <opendmb@gmail.com>
---
 drivers/net/ethernet/broadcom/genet/bcmmii.c | 11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmmii.c b/drivers/net/ethernet/broadcom/genet/bcmmii.c
index b615176338b2..be042905ada2 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmmii.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmmii.c
@@ -176,15 +176,6 @@ void bcmgenet_phy_power_set(struct net_device *dev, bool enable)
 
 static void bcmgenet_moca_phy_setup(struct bcmgenet_priv *priv)
 {
-	u32 reg;
-
-	if (!GENET_IS_V5(priv)) {
-		/* Speed settings are set in bcmgenet_mii_setup() */
-		reg = bcmgenet_sys_readl(priv, SYS_PORT_CTRL);
-		reg |= LED_ACT_SOURCE_MAC;
-		bcmgenet_sys_writel(priv, reg, SYS_PORT_CTRL);
-	}
-
 	if (priv->hw_params->flags & GENET_HAS_MOCA_LINK_DET)
 		fixed_phy_set_link_update(priv->dev->phydev,
 					  bcmgenet_fixed_phy_link_update);
@@ -217,6 +208,8 @@ int bcmgenet_mii_config(struct net_device *dev, bool init)
 
 		if (!phy_name) {
 			phy_name = "MoCA";
+			if (!GENET_IS_V5(priv))
+				port_ctrl |= LED_ACT_SOURCE_MAC;
 			bcmgenet_moca_phy_setup(priv);
 		}
 		break;
-- 
2.25.1

