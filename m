Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A8D4589FEE
	for <lists+netdev@lfdr.de>; Thu,  4 Aug 2022 19:36:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239266AbiHDRgW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Aug 2022 13:36:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239243AbiHDRgT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Aug 2022 13:36:19 -0400
Received: from mail-qk1-x733.google.com (mail-qk1-x733.google.com [IPv6:2607:f8b0:4864:20::733])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BDA0606A7;
        Thu,  4 Aug 2022 10:36:16 -0700 (PDT)
Received: by mail-qk1-x733.google.com with SMTP id w6so124069qkf.3;
        Thu, 04 Aug 2022 10:36:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=avoNOnlZVAxzPQg+1uXUNZlTJ0YbKBrrRYTPwZcHnyY=;
        b=JQnbFopw+aj9BR6B2P6sOXHUuSoj1e/9X7npW8I34hJRsQaizZUrQYA5hBkULkmxgm
         GaBKH/m5DM4oU8aSXz9R84S06bM37mCm1qaEPYhi9LXaxSavMZ6nQ61cZJeulzLN8WFn
         XQxLijsMXjUCXroFK0/f0zVtxx9HpOoToyEDV7MLR0qeF0+A3+ii5bQYLXb73Ez+WA5B
         EhG7dWm0axK/XPK/03Pl2D+Vrc9eLvGQP/i6r/53OubRYolh8llqFJqiuj7bPvQYRTpW
         yW+1FTtth5LWlJ/AXTFz5AO//XJoitM2/19grG046jycKUED735zPIQaGgRpLRkDiYIo
         ylDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=avoNOnlZVAxzPQg+1uXUNZlTJ0YbKBrrRYTPwZcHnyY=;
        b=hxxFTtqKKVA5I8n5tRJDllbnOtA+GMkXMU+4V5AVKkBOA5GsdEElCq1cJL9V/X/TP4
         V0Ag2Q+h8KHtCCvvQQyhnAiwZNUfNzJhfDyGfBYbZB7EQRI2E1asHi9T5ojTMSvndcHD
         YdLejo3uKGCAn1AJGkfJKxCWY4CcfdRUuABNaGpNoGuW2vxYR6IryLojiqQaJIEBdLeb
         M5USV9mfqSdqn5z22pBb6DCG5b0tMsjGc/a4dFpqGmPVC6uaH4aSZ2LK5dcl/afKz54f
         vGiJ1qZKeN66lYndojQSDcGmi1t4SB1p9waaVAW6sMy7Cidglu75nH+JLgbNyP8th9c5
         8hDA==
X-Gm-Message-State: ACgBeo3rlJxskyGW2x5Fsd6/VnEuBhaJPY+9awGdSI846k3FKd8whZPg
        wEaJExxM9CoBdhvu3bFQ4KQQYu5uebc=
X-Google-Smtp-Source: AA6agR7WOpt+qdu3oWVXRxkI5Rg3+rLPmgv2HqG9RsbFaMhuGjS3WR4+TO7DTgSd2jrcnGzjORRlIA==
X-Received: by 2002:a37:89c7:0:b0:6b6:104c:b0ee with SMTP id l190-20020a3789c7000000b006b6104cb0eemr2225957qkd.288.1659634575115;
        Thu, 04 Aug 2022 10:36:15 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id s13-20020a05622a178d00b0031eeefd896esm1112131qtk.3.2022.08.04.10.36.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Aug 2022 10:36:14 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Doug Berger <opendmb@gmail.com>,
        Broadcom internal kernel review list 
        <bcm-kernel-feedback-list@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net] net: bcmgenet: Indicate MAC is in charge of PHY PM
Date:   Thu,  4 Aug 2022 10:36:04 -0700
Message-Id: <20220804173605.1266574-1-f.fainelli@gmail.com>
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

Avoid the PHY library call unnecessarily into the suspend/resume functions by
setting phydev->mac_managed_pm to true. The GENET driver essentially does
exactly what mdio_bus_phy_resume() does by calling phy_init_hw() plus
phy_resume().

Fixes: fba863b81604 ("net: phy: make PHY PM ops a no-op if MAC driver manages PHY PM")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
The commit ID used in the Fixes: tag is to ensure that this goes back to
when the support for mac_managed_pm was introduced, however in premise
this issue has existed for a while, so we might consider a targeted
backport all the way back to 4.9.

 drivers/net/ethernet/broadcom/genet/bcmmii.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmmii.c b/drivers/net/ethernet/broadcom/genet/bcmmii.c
index c888ddee1fc4..7ded559842e8 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmmii.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmmii.c
@@ -393,6 +393,9 @@ int bcmgenet_mii_probe(struct net_device *dev)
 	if (priv->internal_phy && !GENET_IS_V5(priv))
 		dev->phydev->irq = PHY_MAC_INTERRUPT;
 
+	/* Indicate that the MAC is responsible for PHY PM */
+	dev->phydev->mac_managed_pm = true;
+
 	return 0;
 }
 
-- 
2.25.1

