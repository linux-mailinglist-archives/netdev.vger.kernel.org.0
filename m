Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92AA766B3E4
	for <lists+netdev@lfdr.de>; Sun, 15 Jan 2023 21:38:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231160AbjAOUiO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Jan 2023 15:38:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231356AbjAOUiL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Jan 2023 15:38:11 -0500
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F3CA12F35
        for <netdev@vger.kernel.org>; Sun, 15 Jan 2023 12:38:09 -0800 (PST)
Received: by mail-wm1-x32e.google.com with SMTP id ay40so18733729wmb.2
        for <netdev@vger.kernel.org>; Sun, 15 Jan 2023 12:38:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:from:content-language
         :references:cc:to:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cEFlSf16WFxddMhHmvpZYMaVEQuEHnQ55NRL/ZWegJ4=;
        b=qxU5FHdv1qSMxl7GIcCDig/+qAFuafJVkVFx/qD0B3CZLK58kfEN5uTIsmuZqmm5CR
         bTVSlwIF94O4jgqLzTJgTVpDwdlIuf5GHf3KDZxKw0IMAmndibgnNrQi11Iiz+pG1zeo
         ee8Ak6LM7tk2M5YrT5Ig4tf7ma2JXg6DTqCIpRnzzkN5Z9oLDxV65chQ/u0jLwPHGCVE
         HCD6Hl9PbFn+4sWZUqwHYuCLtRIdFIDj9rgjDoWz7twueyExbTTFyj5U3nfdhzo9PzCs
         V+I0gG6ms//r/dGN2bQ60Xx0+7htrOdiHRkS++q8BLol3OwI4T3xJm/jGO8w6z1NhbW6
         ZGJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:from:content-language
         :references:cc:to:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cEFlSf16WFxddMhHmvpZYMaVEQuEHnQ55NRL/ZWegJ4=;
        b=OWaW3HljLl8XTudOT5ahXiTyyiWaYXmRO9+45qH6l55QUWk9Ou74I70BRV4WxXC0ye
         xXLE1CuhbKDIILb1MY8SxwvPb8pfpFCevtdkbhUG/b2Mk2/OZjhZNCNqEesCFafHtrkU
         XxxUsAHE3Q5/THQj0ayejWMIfAUYdw4pa9Fj0afhoozWfrAKSFX5sNKvYE71cmQsZbmg
         16ouO3kVikNhZhJ9FnJBYeKgKWQ4h4L+jZeHrIN/46R9PZrkyOOyM2ppKMkOGzEjWtZ9
         acqigx/PFIGI3KzvC5zcjbQBFZSyY0RgMgNxPaDCq2ycScHC3bLp67VQxiNuci/zO9DG
         1GwA==
X-Gm-Message-State: AFqh2kojgiCP+iww0R4/Rf1xVCBXUNj1bVsSVY5qS1sYTaUWqhr+Wj8M
        JD7NDUgC3VBZWQUlejyoIdKpOBTzZbc=
X-Google-Smtp-Source: AMrXdXsaBVxKQKx0Z40WV6Xqs0q2xvaWR7myGk5yZXzRG5gPyCypgGCphHNJWWhYFt2DnvpW93dpOw==
X-Received: by 2002:a05:600c:4e08:b0:3cf:a41d:844b with SMTP id b8-20020a05600c4e0800b003cfa41d844bmr65637432wmq.5.1673815087980;
        Sun, 15 Jan 2023 12:38:07 -0800 (PST)
Received: from ?IPV6:2a01:c22:6e61:8c00:154f:326e:8d45:8ce7? (dynamic-2a01-0c22-6e61-8c00-154f-326e-8d45-8ce7.c22.pool.telefonica.de. [2a01:c22:6e61:8c00:154f:326e:8d45:8ce7])
        by smtp.googlemail.com with ESMTPSA id l24-20020a1ced18000000b003d99da8d30asm35971141wmh.46.2023.01.15.12.38.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 15 Jan 2023 12:38:07 -0800 (PST)
Message-ID: <6de25c61-c187-fb88-5bd7-477b1db1510e@gmail.com>
Date:   Sun, 15 Jan 2023 21:38:06 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
To:     Neil Armstrong <neil.armstrong@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     Russell King - ARM Linux <linux@armlinux.org.uk>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
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
Content-Language: en-US
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH net-next] net: phy: meson-gxl: support more G12A-internal
 PHY versions
In-Reply-To: <51abd8ca-8172-edfa-1c18-b1e48231f316@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 15.01.2023 19:43, Neil Armstrong wrote:
> Hi Heiner,
> 
> Le 15/01/2023 à 18:09, Heiner Kallweit a écrit :
>> On 15.01.2023 17:57, Andrew Lunn wrote:
>>> On Sun, Jan 15, 2023 at 04:19:37PM +0100, Heiner Kallweit wrote:
>>>> On my SC2-based system the genphy driver was used because the PHY
>>>> identifies as 0x01803300. It works normal with the meson g12a
>>>> driver after this change.
>>>> Switch to PHY_ID_MATCH_MODEL to cover the different sub-versions.
>>>
>>> Hi Heiner
>>>
>>> Are there any datasheets for these devices? Anything which documents
>>> the lower nibble really is a revision?
>>>
>>> I'm just trying to avoid future problems where we find it is actually
>>> a different PHY, needs its own MATCH_EXACT entry, and then we find we
>>> break devices using 0x01803302 which we had no idea exists, but got
>>> covered by this change.
>>>
>> The SC2 platform inherited a lot from G12A, therefore it's plausible
>> that it's the same PHY. Also the vendor driver for SC2 gives a hint
>> as it has the following compatible for the PHY:
>>
>> compatible = "ethernet-phy-id0180.3301", "ethernet-phy-ieee802.3-c22";
>>
>> But you're right, I can't say for sure as I don't have the datasheets.
> 
> On G12A (& GXL), the PHY ID is set in the MDIO MUX registers,
> please see:
> https://elixir.bootlin.com/linux/latest/source/drivers/net/mdio/mdio-mux-meson-g12a.c#L36
> 
> So you should either add support for the PHY mux in SC2 or check
> what is in the ETH_PHY_CNTL0 register.
> 
Thanks for the hint. I just checked and reading back ETH_PHY_CNTL0 at the
end of g12a_enable_internal_mdio() gives me the expected result of 0x33010180.
But still the PHY reports 3300.
Even if I write some other random value to ETH_PHY_CNTL0, I get 0180/3300
as PHY ID.

For u-boot I found the following:

https://github.com/khadas/u-boot/blob/khadas-vim4-r-64bit/drivers/net/phy/amlogic.c

static struct phy_driver amlogic_internal_driver = {
	.name = "Meson GXL Internal PHY",
	.uid = 0x01803300,
	.mask = 0xfffffff0,
	.features = PHY_BASIC_FEATURES,
	.config = &meson_phy_config,
	.startup = &meson_aml_startup,
	.shutdown = &genphy_shutdown,
};

So it's the same PHY ID I'm seeing in Linux.

My best guess is that the following is the case:

The PHY compatible string in DT is the following in all cases:
compatible = "ethernet-phy-id0180.3301", "ethernet-phy-ieee802.3-c22";

Therefore id 0180/3301 is used even if the PHY reports something else.
Means it doesn't matter which value you write to ETH_PHY_CNTL0.

I reduced the compatible string to compatible = "ethernet-phy-ieee802.3-c22"
and this resulted in the actual PHY ID being used.
You could change the compatible in dts the same way for any g12a system
and I assume you would get 0180/3300 too.

Remaining question is why the value in ETH_PHY_CNTL0 is ignored.

> Neil
> 
>>
>>>     Andrew
>>
>> Heiner
> 

