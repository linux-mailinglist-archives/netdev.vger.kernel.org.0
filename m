Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C20D06D36A4
	for <lists+netdev@lfdr.de>; Sun,  2 Apr 2023 11:48:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230191AbjDBJsb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Apr 2023 05:48:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbjDBJsa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Apr 2023 05:48:30 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F06E59E8
        for <netdev@vger.kernel.org>; Sun,  2 Apr 2023 02:48:29 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id r29so26395879wra.13
        for <netdev@vger.kernel.org>; Sun, 02 Apr 2023 02:48:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680428908;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=AxNLqwe7oCB4JXyBb+HCY+YQ9gAGvcZfdTIxvMULNNY=;
        b=TUj/LbQXS5AilzPoAPviWunmxFJ38xjPPr5k7HLhoD/S4ljgP887uo0GX6mLaYZKuC
         P287QNkqKn5PsTQRwYDWL1Yy3RpGqZHxqIT0dsIu3J3TY9VCCe1DCoy5KLtq9cWrViiv
         L3b2Cuz/fg1CVjd8DKp6Tg3NEl9KDuLsqVNaz5Aya02Ieoyfjmuu8i8jBWUezUGvaMct
         H2z6ZQ+ka9puLP3iNXgnl6Iat9jc0JnNlh2EvJ5vSvZkOMvB1S504+/YzOaIWa2SuGHv
         XCoXeyfOfRoFgIWigszmGIZcuPxjAjXmZY5A277zCcKol1lEI7HwvL2ZWUppSoSePOT9
         KsIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680428908;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AxNLqwe7oCB4JXyBb+HCY+YQ9gAGvcZfdTIxvMULNNY=;
        b=U6dfJO4p1nFYl3UYJBzGSedDq83ucj+X/jiY+D9T3LFX71PmXLBxNl19jZynWVaunA
         opFeXUtBveU7TbemJdRyrNcaMdtOQ65aLPVe+xymr3casdgnDwWR5YCTcR+f2xirxWGa
         m1mtV84ERsEcKHOG1krsG7AISDgLSB6oItZVCDoMAhy8EavvAMVWCuiRhDG0pHQNzWK1
         tGGsuObtFh8nHpY9Xzx5eYAcwx5PedgrJmTs1uTut1UTMZqZnapKuMlqWfU4/yBPvbPR
         NmBvEt2Qc3FMvxWqEZQ5hOxFcqczoE2UKR4rYQrZ2GrKjvS41VUhOndQUNwli/S+jan5
         u+JQ==
X-Gm-Message-State: AAQBX9cEE0gRStPlyFDtP/KXpTN8I0iypedXemcydw7RuHffTZec737U
        bHu2Qef3Sx5RX+NIl1xYVJk=
X-Google-Smtp-Source: AKy350YvLuFzEXwAlZMrAw2O2kiJHtSaniO94Ij2S8y+njmGkkuUtVqJcVJlWuhedGDTrSPuQCnpWA==
X-Received: by 2002:adf:f38e:0:b0:2dc:c9c0:85cc with SMTP id m14-20020adff38e000000b002dcc9c085ccmr26163248wro.59.1680428907837;
        Sun, 02 Apr 2023 02:48:27 -0700 (PDT)
Received: from ?IPV6:2a01:c22:7b85:6800:129:5577:2076:7bf8? (dynamic-2a01-0c22-7b85-6800-0129-5577-2076-7bf8.c22.pool.telefonica.de. [2a01:c22:7b85:6800:129:5577:2076:7bf8])
        by smtp.googlemail.com with ESMTPSA id x9-20020a5d4449000000b002e40d124460sm6890448wrr.97.2023.04.02.02.48.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 02 Apr 2023 02:48:27 -0700 (PDT)
Message-ID: <44049041-67ee-43f6-a598-c7397ac63a56@gmail.com>
Date:   Sun, 2 Apr 2023 11:44:40 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: [PATCH net-next 1/7] net: phy: smsc: rename flag energy_enable
Content-Language: en-US
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <17fcccf5-8d81-298e-0671-d543340da105@gmail.com>
In-Reply-To: <17fcccf5-8d81-298e-0671-d543340da105@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Rename the flag to edpd_enable, as we're not enabling energy but
edpd (energy detect power down) mode. In addition change the
type to a bit field member in preparation of adding further flags.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/phy/smsc.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/phy/smsc.c b/drivers/net/phy/smsc.c
index 730964b85..928cf6d8b 100644
--- a/drivers/net/phy/smsc.c
+++ b/drivers/net/phy/smsc.c
@@ -44,7 +44,7 @@ static struct smsc_hw_stat smsc_hw_stats[] = {
 };
 
 struct smsc_phy_priv {
-	bool energy_enable;
+	unsigned int edpd_enable:1;
 };
 
 static int smsc_phy_ack_interrupt(struct phy_device *phydev)
@@ -102,7 +102,7 @@ int smsc_phy_config_init(struct phy_device *phydev)
 {
 	struct smsc_phy_priv *priv = phydev->priv;
 
-	if (!priv || !priv->energy_enable || phydev->irq != PHY_POLL)
+	if (!priv || !priv->edpd_enable || phydev->irq != PHY_POLL)
 		return 0;
 
 	/* Enable energy detect power down mode */
@@ -198,7 +198,7 @@ int lan87xx_read_status(struct phy_device *phydev)
 	if (err)
 		return err;
 
-	if (!phydev->link && priv && priv->energy_enable &&
+	if (!phydev->link && priv && priv->edpd_enable &&
 	    phydev->irq == PHY_POLL) {
 		/* Disable EDPD to wake up PHY */
 		int rc = phy_read(phydev, MII_LAN83C185_CTRL_STATUS);
@@ -284,10 +284,10 @@ int smsc_phy_probe(struct phy_device *phydev)
 	if (!priv)
 		return -ENOMEM;
 
-	priv->energy_enable = true;
+	priv->edpd_enable = true;
 
 	if (device_property_present(dev, "smsc,disable-energy-detect"))
-		priv->energy_enable = false;
+		priv->edpd_enable = false;
 
 	phydev->priv = priv;
 
-- 
2.40.0


