Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FD774130E4
	for <lists+netdev@lfdr.de>; Tue, 21 Sep 2021 11:45:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231484AbhIUJrZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Sep 2021 05:47:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231446AbhIUJrP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Sep 2021 05:47:15 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67B97C061756
        for <netdev@vger.kernel.org>; Tue, 21 Sep 2021 02:45:47 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id y28so77403554lfb.0
        for <netdev@vger.kernel.org>; Tue, 21 Sep 2021 02:45:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=tkxo73GWUy/uIB8IfADrAIFsQogVyvL7nJnT5aa13Qo=;
        b=MRYLQIRGxCmSDURlQqf94WUF7867KHz9sks1FZ2i40OsVGR6+M43URUjzyD0ABOZsS
         cKg+pDKFV6tvzhMF8tiRF3+xCxv1i56TdjFF2zmljrbmlV6Y8dto7Ht+rEHEU2FwIF/7
         FPn1qcvAmHLiDPCHxh/JjGBF1vbF51sQQTFBzyfQsD4Vrj2AaD4cw2kHlx9/2udWeTSf
         iTbeAznS73wlVM4Y02c0gy6HJ1ErT0wVH8DFrwKdZqwD7hW/PlRD8f/p06nemhW1O4rC
         CGgpgmik0u553c2uJojZNtFlhO+TaMK4jLPtPWiJl3Xp1aOloazuF12ljmijq40mZkTA
         J6Vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tkxo73GWUy/uIB8IfADrAIFsQogVyvL7nJnT5aa13Qo=;
        b=rIh2sM/ffD68chD0kms+mO6JOE5hMSqrwZJIkt858GSHFtc8o9pBQUodm/X72BrrrT
         y34eiPIemYJUgkdu0HZlJ/I5lm7pYHpzCBPu+GsPemWEnN6ovq5/dyuYQm6iUTnXl+Qd
         Z29H3Cj7rkqq0Lvx+SnXZP33OVVFhBhe7fEMqYEkzhwKZ2PO1oei9l5aqjVuq8ATx4ZN
         BYbyaf48QEXNpz2oixtB3ALSgpGOswZbPg+TXvwQVKc7Mb8MkYMOytahU51B64p91SHY
         ljSrfudCShFmv1psQxkGZlM5zwJdkzp999Q5MHI/tkjeyuTjhQFXULZ6g6TwJ0KcoAPj
         KE/Q==
X-Gm-Message-State: AOAM532JIxFOKJGC6+QXMRwcDbnsVUgM2wwqkvFdULPDRODxzMWzoWhM
        sZIQORQFpXcl56VxURXlNrl0Y/4CS8U=
X-Google-Smtp-Source: ABdhPJwVjEe1jPJvOLLxxTl0TCb4E5rB0kqlQEzVIofpKA5NyL7T4DfcUR3HSXBL5v2Ay/u5OyY7EQ==
X-Received: by 2002:a2e:131a:: with SMTP id 26mr26485770ljt.46.1632217545703;
        Tue, 21 Sep 2021 02:45:45 -0700 (PDT)
Received: from localhost.localdomain (ip-194-187-74-233.konfederacka.maverick.com.pl. [194.187.74.233])
        by smtp.googlemail.com with ESMTPSA id n26sm1483939lfe.72.2021.09.21.02.45.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Sep 2021 02:45:45 -0700 (PDT)
Subject: Re: Race between "Generic PHY" and "bcm53xx" drivers after
 -EPROBE_DEFER
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>
References: <3639116e-9292-03ca-b9d9-d741118a4541@gmail.com>
 <4648f65c-4d38-dbe9-a902-783e6dfb9cbd@gmail.com>
 <20210920170348.o7u66gpwnh7bczu2@skbuf>
 <11994990-11f2-8701-f0a4-25cb35393595@gmail.com>
 <20210920174022.uc42krhj2on3afud@skbuf>
 <25e4d46a-5aaf-1d69-162c-2746559b4487@gmail.com>
 <20210920180240.tyi6v3e647rx7dkm@skbuf>
 <e010a9da-417d-e4b2-0f2f-b35f92b0812f@gmail.com>
 <20210920181727.al66xrvjmgqwyuz2@skbuf>
 <d2c7a300-656f-ffec-fb14-2b4e99f28081@gmail.com>
From:   =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Message-ID: <9a9b648c-2867-bdf8-8f6b-086d459419a8@gmail.com>
Date:   Tue, 21 Sep 2021 11:45:42 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <d2c7a300-656f-ffec-fb14-2b4e99f28081@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 20.09.2021 20:25, Florian Fainelli wrote:
> On 9/20/21 11:17 AM, Vladimir Oltean wrote:
> [snip]
>>> All I am saying is that there is not really any need to come up with a
>>> Device Tree-based solution since you can inspect the mdio_device and
>>> find out whether it is an Ethernet PHY or a MDIO device proper, and that
>>> ought to cover all cases that I can think of.
>>
>> Okay, but where's the problem? I guess we're on the same page, and
>> you're saying that we should not be calling bcma_mdio_mii_register, and
>> assigning the result to bgmac->mii_bus, because that makes us call
>> bcma_phy_connect instead of bgmac_phy_connect_direct. But based on what
>> condition? Simply if bgmac->phyaddr == BGMAC_PHY_NOREGS?
> 
> Yes simply that condition, I really believe it ought to be enough for
> the space these devices are in use.

I'm afraid I got lost somewhere in this discussion.

If we don't call bcma_mdio_mii_register() (as suggested in quoted
e-mail) then MDIO device 0x1e won't get created and "bcm53xx"
(b53_mdio.c) won't ever load.

We need b53 to load to support the switch.


On 20.09.2021 19:03, Vladimir Oltean wrote:
 > On Mon, Sep 20, 2021 at 09:36:23AM -0700, Florian Fainelli wrote:
 >> Given that the MDIO node does have a compatible string which is not in
 >> the form of an Ethernet PHY's compatible string, I wonder if we can
 >> somewhat break the circular dependency using that information.
 >
 > I think you're talking about:
 >
 > of_mdiobus_register
 > -> of_mdiobus_child_is_phy
 >
 > but as mentioned, that code path should not be creating PHY devices.

With the following patch [1] applied:
[PATCH net-next] net: bgmac: support MDIO described in DT
https://lore.kernel.org/linux-devicetree/20210920123441.9088-1-zajec5@gmail.com/

of_mdiobus_register() finds MDIO bus child at 0x1e from:
[PATCH 1/2] ARM: dts: BCM53573: Describe on-SoC BCM53125 rev 4 switch
https://lore.kernel.org/linux-devicetree/20210920141024.1409-1-zajec5@gmail.com/

and it calls of_mdiobus_register_device().

For that MDIO device kernel first tries to load "bcm53xx" (b53_mdio.c)
which returns -EPROBE_DEFER and then kernel loads "Generic PHY".
