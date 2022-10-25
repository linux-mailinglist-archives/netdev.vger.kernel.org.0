Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9A2460D81B
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 01:42:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232864AbiJYXml (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 19:42:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233056AbiJYXmZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 19:42:25 -0400
Received: from mail-qt1-x836.google.com (mail-qt1-x836.google.com [IPv6:2607:f8b0:4864:20::836])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E0A41740A;
        Tue, 25 Oct 2022 16:42:21 -0700 (PDT)
Received: by mail-qt1-x836.google.com with SMTP id r19so8820500qtx.6;
        Tue, 25 Oct 2022 16:42:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=KzON37HtcPKShg855491Hc+Jv/my7RTdOwTJBPVLddY=;
        b=k75whvR6wb0GL5eGZn2cLvJ73YnpQYwEpCreRbXYodXbfUjjXiO8ulcrXCXZsAOOlG
         pPZQp8WkDNFlhO2wP6DPkGR9ULI/uEvAjJWWIhO8y4I9IGofiY5Z0MPm0oLxUy8m+lQ7
         GIK5FZGbZJr2D26UEbhjDXidF8hTajLro4Yext4n4171MZ0twY/puu/N7UeP1E4a3vGh
         pfDqD41kySyVxif5oWsylPmNo71vH84crzWFbUkir5aeaiWKFS5TeLV26l573Tpy33lh
         qWofTuCNMNL3Rri5IHn7i2BaOMNNDFUISJdCmAqIN0TkJ6KLvSbtk20N4/AOLXQvehqm
         w4+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KzON37HtcPKShg855491Hc+Jv/my7RTdOwTJBPVLddY=;
        b=If+xYFesQGQiXNGQDzh0zdb7FJZhJO2iV9vTnx3BG2qLCXNMYfnp9E5xf2+APLDERE
         hgAeSLEAphKqssPwod+Xal4vy6KwGu8Dn2uPWFhADf6IoZAleoh4+AhkssMMIc8Wv2vp
         pflg1DuDbeSAqKXPdnHYzWdmKnIZAM1MO5d/cRTPXlBslcDSR/hY0XTf7AGkd1nvyOTA
         SwEBFeUrJ6ocqndl46LBupTdrp3khj6pJMixko9l7GFdKJRuw1TaTSbO5Kf+ax5ahqcc
         FTRevqoGMiWP7lmfEAqRKmhdWH/8+zXcfMwYd/BGmXHMM6ASZzVC9qc5xh5hO7ye+O6n
         yuaw==
X-Gm-Message-State: ACrzQf3LTYqa4nxDUaVzOEaObkRwwu06ktYjEfmc3eBBDK5quxH0VS9p
        O8Ss9fiHlV0bks8hbBVn0vHNMVYXzQdrEw==
X-Google-Smtp-Source: AMsMyM6mMBVuscxqAwcod0NzoPNMqN0k90jOIm0lKKJ4Wcqa7HvK+Q0WDGAJrN8/rQFpH0gqNCab1A==
X-Received: by 2002:a05:622a:350:b0:39a:286b:1b21 with SMTP id r16-20020a05622a035000b0039a286b1b21mr34020468qtw.427.1666741339732;
        Tue, 25 Oct 2022 16:42:19 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id a1-20020a05620a438100b006cea2984c9bsm2882502qkp.100.2022.10.25.16.42.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Oct 2022 16:42:19 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Broadcom internal kernel review list 
        <bcm-kernel-feedback-list@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net] net: bcmsysport: Indicate MAC is in charge of PHY PM
Date:   Tue, 25 Oct 2022 16:42:01 -0700
Message-Id: <20221025234201.2549360-1-f.fainelli@gmail.com>
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

Avoid the PHY library call unnecessarily into the suspend/resume
functions by setting phydev->mac_managed_pm to true. The SYSTEMPORT
driver essentially does exactly what mdio_bus_phy_resume() does by
calling phy_resume().

Fixes: fba863b81604 ("net: phy: make PHY PM ops a no-op if MAC driver manages PHY PM")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/ethernet/broadcom/bcmsysport.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/bcmsysport.c b/drivers/net/ethernet/broadcom/bcmsysport.c
index 867f14c30e09..425d6ccd5413 100644
--- a/drivers/net/ethernet/broadcom/bcmsysport.c
+++ b/drivers/net/ethernet/broadcom/bcmsysport.c
@@ -1991,6 +1991,9 @@ static int bcm_sysport_open(struct net_device *dev)
 		goto out_clk_disable;
 	}
 
+	/* Indicate that the MAC is responsible for PHY PM */
+	phydev->mac_managed_pm = true;
+
 	/* Reset house keeping link status */
 	priv->old_duplex = -1;
 	priv->old_link = -1;
-- 
2.25.1

