Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 730A243CF90
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 19:17:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243249AbhJ0RUP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 13:20:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243236AbhJ0RUN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Oct 2021 13:20:13 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83954C061570
        for <netdev@vger.kernel.org>; Wed, 27 Oct 2021 10:17:48 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id g184so3573287pgc.6
        for <netdev@vger.kernel.org>; Wed, 27 Oct 2021 10:17:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=32JTrVlDCDcbyAzfMSsn1ULoFBKFb5a2mOeY7+hxAsg=;
        b=ZbBy0Ng/ibkFrKOgfIFkMqhCnDSKAbph7SOQMAA2YExJ9fczLGbn1XK+iJXOjaLK+u
         Wb4yBAwLN6ulOnfotBFVEsIstA0pHHI/W3NctIp9HlarADMfoDldBiqdFybhmOUTp2Mx
         Gh++BQo2xdkKayHRfqlBybQHQdl5sna3RE8CyiXYXfKvl4c1QhhpnYm8KpPkax3JwGGz
         C4caiiOaiBsLMzOYTKXcyGAOSpSh+2wTOIlNz5oUuKpv8CRcmSirzp08B79nb76odNid
         jdJO/6UTLascpqBnIUXh7+ZEwfSI1N3M/itImlxzjzEeHXqT6FvgZ4q6zrW8J8mHgLVI
         Xr2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=32JTrVlDCDcbyAzfMSsn1ULoFBKFb5a2mOeY7+hxAsg=;
        b=DgLPY/cLKB/7+1vvaSo4VQNYy+HwNMnMjXbd7LYyc+Cq9A5CT8gEDGvAVTIIBOB7WW
         2LZZGI8HV/NJbiJRajoAQVJr9nje0POQnGEk3hzncxpKcoH4jTk1w90ESEFpQgGUcdBJ
         0idhenGH+ZlT0i4H6rLHt17BVSptj2kUs3ye1CzGcIIWI31fHHIJCbjXNWOvm8Ee3OC8
         Z/WEHRDfxmMwrr1TG+h5e0d1F7BVb0RiWk/Nmfx6/Oh20tB4pVEMpO2t1OovO/uvhXUB
         z6Ok8fNtpdtVg25ZJgbn8IA7r8PAl5QF7kAsMyugHQMfOeC8+IiyxaxkBVpe0P+gMDrx
         LbHA==
X-Gm-Message-State: AOAM533PSTkUIKxl9Ady9+KBi4dvxseEh28BKIsWpRj9Dx+WTTxA2Y2z
        zIRKBq5A5BpLw77A2M7m+Ss=
X-Google-Smtp-Source: ABdhPJz0okbdpLXNHCO7fQiFYF1XmPqYwEUcDnuamzhH6cz3RWb293+uJJJDblUaZzQWwyPAjAztWA==
X-Received: by 2002:a63:9042:: with SMTP id a63mr20992746pge.230.1635355067789;
        Wed, 27 Oct 2021 10:17:47 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id d19sm352171pgk.81.2021.10.27.10.17.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Oct 2021 10:17:47 -0700 (PDT)
Subject: Re: mdio: separate gpio-reset property per child phy usecase
To:     Radhey Shyam Pandey <radheys@xilinx.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     Michal Simek <michals@xilinx.com>,
        Harini Katakam <harinik@xilinx.com>
References: <SA1PR02MB85605C26380A9D8F4D1FB2AAC7859@SA1PR02MB8560.namprd02.prod.outlook.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <64248ee1-55dd-b1bd-6c4e-0a272d230e8e@gmail.com>
Date:   Wed, 27 Oct 2021 10:17:46 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <SA1PR02MB85605C26380A9D8F4D1FB2AAC7859@SA1PR02MB8560.namprd02.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

+PHY library maintainers,

On 10/27/21 5:58 AM, Radhey Shyam Pandey wrote:
> Hi all,
> 
> In a xilinx internal board we have shared GEM MDIO configuration with
> TI DP83867 phy and for proper phy detection both PHYs need prior separate
> GPIO-reset.
> 
> Description:
> There are two GEM ethernet IPs instances GEM0 and GEM1. GEM0 and GEM1 used
> shared MDIO driven by GEM1.
> 
> TI PHYs need prior reset (RESET_B) for PHY detection at defined address. 
> However with current framework limitation " one reset line per PHY present 
> on the MDIO bus" the other PHY get detected at incorrect address and later
> having child PHY node reset property will also not help.
> 
> In order to fix this one possible solution is to allow reset-gpios 
> property to have PHY reset GPIO tuple for each phy. If this
> approach looks fine we can make changes and send out a RFC.

I don't think your proposed solution would work because there is no way
to disambiguate which 'reset-gpios' property applies to which PHY,
unless you use a 'reset-gpio-names' property which encodes the phy
address in there. But even doing so, if the 'reset-gpios' property is
placed within the MDIO controller node then it applies within its scope
which is the MDIO controller. The other reason why it is wrong is
because the MDIO bus itself may need multiple resets to be toggled to be
put in a functional state. This is probably uncommon for MDIO, but it is
not for other types of peripherals with complex asynchronous reset
circuits (the things you love to hate).

The MDIO bus layer supports something like this which is much more
accurate in describing the reset GPIOs pertaining to each PHY device:

	mdio {
		..
		phy0: ethernet-phy@0 {
			reg = <0>;
			reset-gpios = <&slg7xl45106 5 GPIO_ACTIVE_HIGH>;
		};
		phy1: ethernet-phy@8 {
			reg = <8>;
			reset-gpios = <&slg7xl45106 6 GPIO_ACTIVE_HIGH>;
		};
	};

The code that will parse that property is in drivers/net/phy/mdio_bus.c
under mdiobus_register_gpiod()/mdiobus_register_reset() and then
mdio_device_reset() called by phy_device_reset() will pulse the per-PHY
device reset line/GPIO.

Are you saying that you tried that and this did not work somehow? Can
you describe in more details how the timing of the reset pulsing affects
the way each TI PHY is going to gets its MDIO address assigned?

Thanks
-- 
Florian
