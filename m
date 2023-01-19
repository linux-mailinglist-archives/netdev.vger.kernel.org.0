Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07DD167467E
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 23:58:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230369AbjASW6j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 17:58:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230318AbjASW5i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 17:57:38 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B2C248A09
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 14:42:58 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id mp20so9586173ejc.7
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 14:42:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:references:cc:to:from
         :content-language:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wp1oH3VUeR8ctDbrH8Su2X852AptYELpIhyYkwz3XhU=;
        b=fgBrJZbIA/l4ZBuwloIrwqfNZDxDJ6pT5E0y/03G4LSnHeQyhmYY2Dn31ZQSuZNq7c
         5xAbt6XeL21Tyxdia6IsElgzdkWGVu+OW3/TEgB3++PMxS95NMje7CDNJoMMeQ9sCBJN
         RbFu55SK7eGr8ldGitcj7LULi9nN6Yn5+uT3q0utpjcCT3+6eDtZn6D1u2KCukWLtdzr
         JP0ty3lusp4xI3TB656j84TrZReZt8YypJMxDGX+gcYFtJBhaMyrUrMz872fkdOLEmQE
         Hq9TblLX/a7VexOVuDhZ+Ma57LW4BxqnYpXTVvx4EywQHVDkvETPDCrvqb/TbyLtSdpB
         fkGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:references:cc:to:from
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wp1oH3VUeR8ctDbrH8Su2X852AptYELpIhyYkwz3XhU=;
        b=yoKJ7RFFRxawF2ybZUhI9gvMj0jVsDVl38LTk1evyWkLPmRIth48n/KhHYUmHDuVRb
         f4fyDQAkb5snqL77Bz9JV4loOB4xRCP5CaN/PPAYkFMbpIyfPBWbRqI6yo7dMAaGM28f
         p7DFf61uPiUG7HF469BMNMST+5wh1DFNd60NBvAHKzZZDfdP8lP5Ak2H85fedPBfkuAm
         RDMX/A87zQ/GJAxgj8BSXGlE6VJILhI+Zv82wviq2BjbGaiVSYTfcN3tltpKwCQRBfun
         sQ9FtUvgDoARrNS25RFUsMyqqEF5MeoMKoKiBGS0glc1Kw8s+lZhFkKZzKSKw68NWbnK
         k5aA==
X-Gm-Message-State: AFqh2koYe7+8nadT8FM3Sts2+xHwRaLSxVY/0FCtkp3rD/9UVAYTFHZz
        hJ+K/7KEhvLyDt0L16bFEwE=
X-Google-Smtp-Source: AMrXdXsmxFZd/rHacNHGgaNO0QgicI8Ygk33pTya8486hCbXBRvtbb9wFn//Xw+vipC4b2R7t75KSA==
X-Received: by 2002:a17:906:6a27:b0:872:8c97:db27 with SMTP id qw39-20020a1709066a2700b008728c97db27mr14876851ejc.69.1674168176978;
        Thu, 19 Jan 2023 14:42:56 -0800 (PST)
Received: from ?IPV6:2a01:c23:c477:4300:3c6e:3915:fc5a:2ff1? (dynamic-2a01-0c23-c477-4300-3c6e-3915-fc5a-2ff1.c23.pool.telefonica.de. [2a01:c23:c477:4300:3c6e:3915:fc5a:2ff1])
        by smtp.googlemail.com with ESMTPSA id 9-20020a170906218900b0084cb4d37b8csm17043453eju.141.2023.01.19.14.42.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Jan 2023 14:42:56 -0800 (PST)
Message-ID: <e75ed56f-ba25-f337-e879-33cc2a784740@gmail.com>
Date:   Thu, 19 Jan 2023 23:42:54 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Content-Language: en-US
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Neil Armstrong <neil.armstrong@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Jerome Brunet <jbrunet@baylibre.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc:     Russell King - ARM Linux <linux@armlinux.org.uk>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Kevin Hilman <khilman@baylibre.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "open list:ARM/Amlogic Meson..." <linux-amlogic@lists.infradead.org>
References: <d75ef7df-a645-7fdd-491a-f89f70dbea01@gmail.com>
 <Y8Qwk5H8Yd7qiN0j@lunn.ch> <03ea260e-f03c-d9d7-6f5f-ff72836f5739@gmail.com>
 <51abd8ca-8172-edfa-1c18-b1e48231f316@linaro.org>
 <6de25c61-c187-fb88-5bd7-477b1db1510e@gmail.com>
Subject: Re: [PATCH net-next] net: phy: meson-gxl: support more G12A-internal
 PHY versions
In-Reply-To: <6de25c61-c187-fb88-5bd7-477b1db1510e@gmail.com>
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

On 15.01.2023 21:38, Heiner Kallweit wrote:
> On 15.01.2023 19:43, Neil Armstrong wrote:
>> Hi Heiner,
>>
>> Le 15/01/2023 à 18:09, Heiner Kallweit a écrit :
>>> On 15.01.2023 17:57, Andrew Lunn wrote:
>>>> On Sun, Jan 15, 2023 at 04:19:37PM +0100, Heiner Kallweit wrote:
>>>>> On my SC2-based system the genphy driver was used because the PHY
>>>>> identifies as 0x01803300. It works normal with the meson g12a
>>>>> driver after this change.
>>>>> Switch to PHY_ID_MATCH_MODEL to cover the different sub-versions.
>>>>
>>>> Hi Heiner
>>>>
>>>> Are there any datasheets for these devices? Anything which documents
>>>> the lower nibble really is a revision?
>>>>
>>>> I'm just trying to avoid future problems where we find it is actually
>>>> a different PHY, needs its own MATCH_EXACT entry, and then we find we
>>>> break devices using 0x01803302 which we had no idea exists, but got
>>>> covered by this change.
>>>>
>>> The SC2 platform inherited a lot from G12A, therefore it's plausible
>>> that it's the same PHY. Also the vendor driver for SC2 gives a hint
>>> as it has the following compatible for the PHY:
>>>
>>> compatible = "ethernet-phy-id0180.3301", "ethernet-phy-ieee802.3-c22";
>>>
>>> But you're right, I can't say for sure as I don't have the datasheets.
>>
>> On G12A (& GXL), the PHY ID is set in the MDIO MUX registers,
>> please see:
>> https://elixir.bootlin.com/linux/latest/source/drivers/net/mdio/mdio-mux-meson-g12a.c#L36
>>
>> So you should either add support for the PHY mux in SC2 or check
>> what is in the ETH_PHY_CNTL0 register.
>>
> Thanks for the hint. I just checked and reading back ETH_PHY_CNTL0 at the
> end of g12a_enable_internal_mdio() gives me the expected result of 0x33010180.
> But still the PHY reports 3300.
> Even if I write some other random value to ETH_PHY_CNTL0, I get 0180/3300
> as PHY ID.
> 
> For u-boot I found the following:
> 
> https://github.com/khadas/u-boot/blob/khadas-vim4-r-64bit/drivers/net/phy/amlogic.c
> 
> static struct phy_driver amlogic_internal_driver = {
> 	.name = "Meson GXL Internal PHY",
> 	.uid = 0x01803300,
> 	.mask = 0xfffffff0,
> 	.features = PHY_BASIC_FEATURES,
> 	.config = &meson_phy_config,
> 	.startup = &meson_aml_startup,
> 	.shutdown = &genphy_shutdown,
> };
> 
> So it's the same PHY ID I'm seeing in Linux.
> 
> My best guess is that the following is the case:
> 
> The PHY compatible string in DT is the following in all cases:
> compatible = "ethernet-phy-id0180.3301", "ethernet-phy-ieee802.3-c22";
> 
> Therefore id 0180/3301 is used even if the PHY reports something else.
> Means it doesn't matter which value you write to ETH_PHY_CNTL0.
> 
> I reduced the compatible string to compatible = "ethernet-phy-ieee802.3-c22"
> and this resulted in the actual PHY ID being used.
> You could change the compatible in dts the same way for any g12a system
> and I assume you would get 0180/3300 too.
> 
> Remaining question is why the value in ETH_PHY_CNTL0 is ignored.
> 

I think I found what's going on. The PHY ID written to SoC register
ETH_PHY_CNTL0 isn't effective immediately. It takes a PHY soft reset before
it reports the new PHY ID. Would be good to have a comment in the
g12a mdio mux code mentioning this constraint.

I see no easy way to trigger a soft reset early enough. Therefore it's indeed
the simplest option to specify the new PHY ID in the compatible.

