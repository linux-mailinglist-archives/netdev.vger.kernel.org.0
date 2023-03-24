Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EA1B6C847E
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 19:07:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232272AbjCXSHg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 14:07:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232277AbjCXSHU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 14:07:20 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 960591F49E
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 11:06:08 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id o32so1642993wms.1
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 11:06:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679681167;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=AnQAZyBTB+IURJdf5abE+JXNErsgJQIfqFPQ78I7Yvg=;
        b=XbEbHrMZ2e+ld5YNPhGjq3FKLqG1JdlfCA+4Zj2KlYYwkjWNfyw5TU8HOktdTZwVN4
         mUs/hcgH8qla/Xq+fFtGcACVAtiltvQRY/+seM0TcwqhSZanpGIT9Op7RS3TEckcR1fK
         6X6JDdooraDSho9tNElFyVn4VHgAT1q+85TMrVFfaQEWExczodPK2Prvohn7roT4M1nT
         oQdAmS0VUKCAl0dAWlNXyqutjgav4wcokKVyG1i1FyQcB4+9EKxxPWiJL/nBXY3cBLb/
         Y8cMDLOuOosu+xBlILaVUCECGjuRPKKQdY8I/HgmBCRj+l5CebkZhjHGuXV38go2/Msj
         yBBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679681167;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AnQAZyBTB+IURJdf5abE+JXNErsgJQIfqFPQ78I7Yvg=;
        b=2kHxeIJpiaUHlI3lP5JNbG+O42FbM0kqRsJozPD0qXMoXscwD4oPuIGT5LWFGJoF+n
         1E0qyUJkyRxDPTWmBOq+9ZzTe7fpiVSZGFC4aoKu7lKCJ5aM0trZF3WtJbeKXrLbAVJi
         sYKO3iveudyeaxhg/oqlbmg/7tK/BpsObYOXWhmwimVXqkW6AGOERGdUMGSATXLvktyd
         8PAJmEEybLFjWQRKZZZ0NbtcnFYrwabXRbPxkpeUOxqH5HUIb2+tSO4L6xtxLARM/47o
         swn+uLHdeUBMXNqNDcA0NeyvzBO5scqRGobeUk9ipR3/kCaq8ZS+SU6ERNbGPbMZmOqn
         iddA==
X-Gm-Message-State: AO0yUKX7IKMjwgIAbJk8jJnCrqE5+p9uKJGsjuVd+LORQ7CRy3DKJtn7
        J8HKWGsltqnFFoltbVJ4zq5aKdsB174=
X-Google-Smtp-Source: AK7set805OM7N9+MtK90AsfiYGpSKcgKIweIYu8J/n8/FCA9JfSiyZHyYfAaBDOBXA22twUrzQ2cLg==
X-Received: by 2002:a7b:c384:0:b0:3ee:5d1d:6c4e with SMTP id s4-20020a7bc384000000b003ee5d1d6c4emr3174216wmj.16.1679681167134;
        Fri, 24 Mar 2023 11:06:07 -0700 (PDT)
Received: from ?IPV6:2a01:c23:b926:df00:a161:16e2:f237:a7d4? (dynamic-2a01-0c23-b926-df00-a161-16e2-f237-a7d4.c23.pool.telefonica.de. [2a01:c23:b926:df00:a161:16e2:f237:a7d4])
        by smtp.googlemail.com with ESMTPSA id i11-20020a05600c290b00b003ee20b4b2dasm5431862wmd.46.2023.03.24.11.06.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Mar 2023 11:06:06 -0700 (PDT)
Message-ID: <c84cad5a-ed93-b664-340e-eca99716ec18@gmail.com>
Date:   Fri, 24 Mar 2023 19:04:46 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: [PATCH net-next 3/4] net: phy: micrel: remove getting reference clock
Content-Language: en-US
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Broadcom internal kernel review list 
        <bcm-kernel-feedback-list@broadcom.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <0c529488-0fd8-19e1-c5a9-9cf1fab78ed3@gmail.com>
In-Reply-To: <0c529488-0fd8-19e1-c5a9-9cf1fab78ed3@gmail.com>
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

Now that getting the reference clock has been moved to phylib, we can
remove it here.

Only one clock is supported by the PHY, therefore it's ok that we now use
the first clock instead of the named one.

Note that currently devm_clk_get is used instead of devm_clk_get_optional,
but nevertheless the clock is treated as optional.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/phy/micrel.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
index e26c6723c..dfd2c1d0f 100644
--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -1884,7 +1884,6 @@ static int kszphy_probe(struct phy_device *phydev)
 	const struct kszphy_type *type = phydev->drv->driver_data;
 	const struct device_node *np = phydev->mdio.dev.of_node;
 	struct kszphy_priv *priv;
-	struct clk *clk;
 
 	priv = devm_kzalloc(&phydev->mdio.dev, sizeof(*priv), GFP_KERNEL);
 	if (!priv)
@@ -1896,10 +1895,8 @@ static int kszphy_probe(struct phy_device *phydev)
 
 	kszphy_parse_led_mode(phydev);
 
-	clk = devm_clk_get(&phydev->mdio.dev, "rmii-ref");
-	/* NOTE: clk may be NULL if building without CONFIG_HAVE_CLK */
-	if (!IS_ERR_OR_NULL(clk)) {
-		unsigned long rate = clk_get_rate(clk);
+	if (phydev->refclk) {
+		unsigned long rate = clk_get_rate(phydev->refclk);
 		bool rmii_ref_clk_sel_25_mhz;
 
 		if (type)
-- 
2.40.0


