Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F2D66B1329
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 21:35:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229936AbjCHUe4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 15:34:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230360AbjCHUei (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 15:34:38 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93898CCE91
        for <netdev@vger.kernel.org>; Wed,  8 Mar 2023 12:34:22 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id cw28so70754622edb.5
        for <netdev@vger.kernel.org>; Wed, 08 Mar 2023 12:34:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678307661;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aVTCViV9KCP7APavv03NS1lEmiUdD59919rqFC3aoNA=;
        b=CvpzAa2xOfm0xWNlMe4v6dfHrIGemV3lBdvCLVOwX7/hKiq1QIe6kf9xDp43Wrob/F
         gI+wkku57swK8y7UIilWa4zpd6DgHtw+fHK3KS+nucQZzjl2aP+YbyIEhVzakmH3Oe1W
         pO+73mR8fHaVEFuLZeP8ULiLUIt0TLF4dFXdJ0DdVHIAsmvfqEA+iyuIAkdtz5cd9pSQ
         PS8WOK/kZr/BxoFwzE/PaZ3UERoAMk9DAyediHDzyj76XKIPy1Jgmh5HBO7D+hQ56WC8
         DnvPvOrNW8F5T2oD8z4FtZ8l4vHcvcx1/s9Hd2ZXkE6ywgMAc2KbBapAE0bdLcEeZmTH
         IoZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678307661;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=aVTCViV9KCP7APavv03NS1lEmiUdD59919rqFC3aoNA=;
        b=mGZfu0XEG/XA5cU9PrX0SCd7rhbxtww3snQFHWWdYU5Ewa4fIoJRiYDHQjlPnjVlPB
         4+5Li3nE+iFS8oQ66QHeYZ6SKv4hVM6r32Kir20gwjERIyyzjOwMGe9ZkuepQm0lJMbr
         bFHACoQ96mlJUz0hmCR+aViLf4Oj1rfhytgJSNzx4PtdfHgubUb8iwKE1ch7ecwSqSW+
         j2KD9mXwJqckRAA5VymocsdazSdpc8KmiRwaDYflhxpxMVxoyANhXDTRDBwBzhotliHH
         HSwr1cnEfG1lOz7W+06+7FAqbYVzA7l/FZHVsgjSp67KC4N0b4/lvmhuIcxeBWLWumyb
         gZUA==
X-Gm-Message-State: AO0yUKW/JRjU6RnB5byzEqaP8mbn8W5ZohjU17V0VR6hura+gO27ClTf
        qTz7ofGDkIkdMFw/7ITJihMeMsfliWk=
X-Google-Smtp-Source: AK7set9XsRYsXrHkQEkmYDb+oRZzPMildBIF3QuhqDEOefQQYnjlVlSNSTalsQJldk9qmFHWqZvE/w==
X-Received: by 2002:a17:906:bfc9:b0:88d:ba89:1837 with SMTP id us9-20020a170906bfc900b0088dba891837mr21391502ejb.8.1678307660967;
        Wed, 08 Mar 2023 12:34:20 -0800 (PST)
Received: from ?IPV6:2a01:c22:6ed9:d400:9df:5c71:99fe:44f3? (dynamic-2a01-0c22-6ed9-d400-09df-5c71-99fe-44f3.c22.pool.telefonica.de. [2a01:c22:6ed9:d400:9df:5c71:99fe:44f3])
        by smtp.googlemail.com with ESMTPSA id k20-20020a17090627d400b008b17ca37966sm7970205ejc.148.2023.03.08.12.34.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Mar 2023 12:34:20 -0800 (PST)
Message-ID: <a969f012-1d3b-7a36-51cf-89a5f8f15a9b@gmail.com>
Date:   Wed, 8 Mar 2023 21:34:13 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Content-Language: en-US
To:     Russell King - ARM Linux <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>, Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next] net: phy: smsc: use device_property_present in
 smsc_phy_probe
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use unified device property API.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/phy/smsc.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/phy/smsc.c b/drivers/net/phy/smsc.c
index 630104c16..1c2808f74 100644
--- a/drivers/net/phy/smsc.c
+++ b/drivers/net/phy/smsc.c
@@ -272,7 +272,6 @@ static void smsc_get_stats(struct phy_device *phydev,
 static int smsc_phy_probe(struct phy_device *phydev)
 {
 	struct device *dev = &phydev->mdio.dev;
-	struct device_node *of_node = dev->of_node;
 	struct smsc_phy_priv *priv;
 	struct clk *refclk;
 
@@ -282,7 +281,7 @@ static int smsc_phy_probe(struct phy_device *phydev)
 
 	priv->energy_enable = true;
 
-	if (of_property_read_bool(of_node, "smsc,disable-energy-detect"))
+	if (device_property_present(dev, "smsc,disable-energy-detect"))
 		priv->energy_enable = false;
 
 	phydev->priv = priv;
-- 
2.39.2

