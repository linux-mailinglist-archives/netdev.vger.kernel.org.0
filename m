Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A63A566E14E
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 15:51:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230195AbjAQOvc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 09:51:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229686AbjAQOva (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 09:51:30 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3110A32507
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 06:51:28 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id vm8so75895158ejc.2
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 06:51:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=b5dLy407+vBKmqg0S67+GUaT0O6M/EsU3XgvMkQjPQU=;
        b=QYxu3ZSjOY/CDZtPkzuNn5q370CND8HE700/5kencxE9zic2FI1wYRZlGGpBsbsLEU
         gfobr4bEHpZNWYECYrkPeRRsN9s1c5lORo3XE9mDrbvrGOAemqq1/e5x2DebefisujSZ
         XHveQQ9GjVcoLWELp33YgMXsUPozQjO2+Huf9Tdzlw3FhAyIhbOFDP/YobbZhpdGEL2u
         fjYnIeR/yemq/8azTqFgtdNFonNUDGVRmArttnPjACl8B7c5CgFhTQBWmFIR1T74N2JT
         ggwoGv35F8fpy/2gk3qWaV1/b4ygK2XHvA3HVNNunCewAVtlvHgHctF+/G38p+XkshJv
         B5kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=b5dLy407+vBKmqg0S67+GUaT0O6M/EsU3XgvMkQjPQU=;
        b=F8Iy6kZiwu+kn3OgpA2Qz8cdLoxiqjCzHgIFCDjk5x5z5bKX3NZIDreDq2a0JMretv
         FC45ml6Pq06p4b73OC3yi5GiCXS4BH3CKgUX1bZlWqRFwadbA/XIpneNbH3diLGRSddm
         CSEjtbL8RhXVI6OtuS8mLAoLrhL19dX2rI6zFxJsV39/U6+nXthhUtJqK3Ii4SpWpys2
         ovi3EghFy7ZhbujrQoIOItKieafJJjWdCPjxTOK3FbGcX5bgHCjI7oLTAcRJl5JsxI9j
         wyZWQVasLHNGArbQizUWTC3V+mNszkYcjFkmYWQ39nYKGbMpnXobZWfz5blOOFe798Sr
         qPSg==
X-Gm-Message-State: AFqh2ko6+rosDI5yD1ZMOgQTkEquaxwlEGsUqVHmWMFRAFjBVooExe+p
        Ub/WFE55ShNLDqn8FM/kQ+g=
X-Google-Smtp-Source: AMrXdXsteKFfcuU8ekKbYW6rkuOdcnAX7Jr+Ngn2mOHPrTqB6iiGMRgB3rEQuDh/OPjQHBEi0IuxaA==
X-Received: by 2002:a17:906:1b4a:b0:84d:4e4e:2c7b with SMTP id p10-20020a1709061b4a00b0084d4e4e2c7bmr16587158ejg.30.1673967086569;
        Tue, 17 Jan 2023 06:51:26 -0800 (PST)
Received: from ?IPV6:2a01:c22:7346:8100:dcf9:ba16:7d23:185e? (dynamic-2a01-0c22-7346-8100-dcf9-ba16-7d23-185e.c22.pool.telefonica.de. [2a01:c22:7346:8100:dcf9:ba16:7d23:185e])
        by smtp.googlemail.com with ESMTPSA id 17-20020a170906059100b007c16f120aacsm13174653ejn.121.2023.01.17.06.51.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Jan 2023 06:51:26 -0800 (PST)
Message-ID: <1f841ad8-d2f9-cf39-da65-5c90fddb3cee@gmail.com>
Date:   Tue, 17 Jan 2023 15:51:14 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Content-Language: en-US
To:     Andrew Lunn <andrew@lunn.ch>, Paolo Abeni <pabeni@redhat.com>,
        Jerome Brunet <jbrunet@baylibre.com>
Cc:     Neil Armstrong <neil.armstrong@linaro.org>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Kevin Hilman <khilman@baylibre.com>,
        Jerome Brunet <jbrunet@baylibre.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "open list:ARM/Amlogic Meson..." <linux-amlogic@lists.infradead.org>
References: <d75ef7df-a645-7fdd-491a-f89f70dbea01@gmail.com>
 <Y8Qwk5H8Yd7qiN0j@lunn.ch> <03ea260e-f03c-d9d7-6f5f-ff72836f5739@gmail.com>
 <51abd8ca-8172-edfa-1c18-b1e48231f316@linaro.org>
 <6de25c61-c187-fb88-5bd7-477b1db1510e@gmail.com>
 <699f6ee109b3a72b2b377f42a78705f47d4a77b9.camel@redhat.com>
 <Y8ai6+oaaP0KwkAY@lunn.ch>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH net-next] net: phy: meson-gxl: support more G12A-internal
 PHY versions
In-Reply-To: <Y8ai6+oaaP0KwkAY@lunn.ch>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 17.01.2023 14:30, Andrew Lunn wrote:
>>> The PHY compatible string in DT is the following in all cases:
>>> compatible = "ethernet-phy-id0180.3301"
> 
> This form of compatible has two purposes.
> 
> 1) You cannot read the PHY ID register during MDIO bus enumeration,
> generally because you need to turn on GPIOs, clocks, regulators etc,
> which the MDIO/PHY core does not know how to do.
> 
> 2) The PHY has bad values in its ID registers, typically because the
> manufactures messed up.
> 
> If you have a compatible like this, the ID registers are totally
> ignored by Linux, and the ID is used to find the driver and tell the
> driver exactly which of the multiple devices it supports it should
> assume the device is.
> 
> So you should use this from of compatible with care. You can easily
> end up thinking you have a different PHY to what you actually have,
> which could then result in wrong erratas being applied etc, or even
> the wrong driver being used.
> 

Right. I checked and this compatible was added with
280c17df8fbf ("arm64: dts: meson: g12a: add mdio multiplexer").

compatible = "ethernet-phy-id0180.3301", "ethernet-phy-ieee802.3-c22";

The commit message doesn't explain why overriding the PHY ID
is needed. Maybe Jerome as author can shed some light on it.

At least on my system it's not needed (after setting the PHY ID
in the PHY driver to the actual value).

Would be interesting to know whether PHY is still detected
and driver loaded with this patch on g12 systems.
If the genphy driver should be used then the actual PHY ID
would be interesting (look for attribute phy_id in sysfs).

diff --git a/arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi b/arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi
index 585dd70f6..8af48aff0 100644
--- a/arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi
@@ -1695,8 +1695,7 @@ int_mdio: mdio@1 {
 					#size-cells = <0>;
 
 					internal_ephy: ethernet_phy@8 {
-						compatible = "ethernet-phy-id0180.3301",
-							     "ethernet-phy-ieee802.3-c22";
+						compatible = "ethernet-phy-ieee802.3-c22";
 						interrupts = <GIC_SPI 9 IRQ_TYPE_LEVEL_HIGH>;
 						reg = <8>;
 						max-speed = <100>;
diff --git a/drivers/net/phy/meson-gxl.c b/drivers/net/phy/meson-gxl.c
index c49062ad7..0fd76d49a 100644
--- a/drivers/net/phy/meson-gxl.c
+++ b/drivers/net/phy/meson-gxl.c
@@ -262,7 +262,7 @@ static struct phy_driver meson_gxl_phy[] = {
 		.suspend        = genphy_suspend,
 		.resume         = genphy_resume,
 	}, {
-		PHY_ID_MATCH_EXACT(0x01803301),
+		PHY_ID_MATCH_EXACT(0x01803300),
 		.name		= "Meson G12A Internal PHY",
 		/* PHY_BASIC_FEATURES */
 		.flags		= PHY_IS_INTERNAL,
-- 
2.39.0

>     Andrew

