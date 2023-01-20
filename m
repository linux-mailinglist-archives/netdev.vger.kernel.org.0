Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 918C3675225
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 11:13:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229609AbjATKNw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 05:13:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229562AbjATKNv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 05:13:51 -0500
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09EC88B745
        for <netdev@vger.kernel.org>; Fri, 20 Jan 2023 02:13:49 -0800 (PST)
Received: by mail-wm1-x32b.google.com with SMTP id k16so3608800wms.2
        for <netdev@vger.kernel.org>; Fri, 20 Jan 2023 02:13:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:in-reply-to:date
         :subject:cc:to:from:user-agent:references:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZVqcL0xW73wfQaxg9BxXn6+FdbbVO9Jjcbrhv1lAVJM=;
        b=nP8F9V6I+nC+ktL0lcFHv1x8AM9DurCmr2R+AlrEcUPcfdwOlWEvjtwfxy0xdy0iHp
         sm+nrGdBenRnhI+qFB5nHnEW1Z3CS+dk87FH2536OM6F6wUFZHwQAD4IsA2rBet+/RY+
         JZlA1QaBtN5ROIQavstC1G9LDHc9UVn5y3LPe7oSDywadz2e76ZX+b2h3Mhqo02moVo1
         a1vsZmNE4vunQwWMJ9NfehDRM1qFagcQvomiUaYV70gCEHV2MDvmCPEuLg2UOz2hF3FT
         QkGXqHyoxoYhNuQqsIkfxI+POSLgYMqgd/s/muUTZXeWGf3FeN6tNISjjSsEwaeOrLMd
         bTnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:in-reply-to:date
         :subject:cc:to:from:user-agent:references:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ZVqcL0xW73wfQaxg9BxXn6+FdbbVO9Jjcbrhv1lAVJM=;
        b=iddYsjAKTmPxfKYX53ambScgsriEyVtq//6wfRUIj1j4TFpWM0Ql7rM0xq09bh7IPR
         8sxANgJ3OK5Kj1T5Ha74gbGq4DEaei6MZwjjWCBheQ0x+fZFCY+RQYoa6Q/8sDSffx8d
         tPNxhJCN7lrdBBZT3XJCcCN/PcTEh80lth8gQ1zo0LrlaqlN6z/rjAyfx50V6vhJpZPE
         /IskdamcAAcdUulKpHpw9aRxKFWTZh7MynXewRGjW3+LelRZ88WIJoOtYmwp2HEM7b0w
         G+OTZSUvh6n3iK0PZR6XaH8FGTgVQTEUQTqpMzPBJCAjq7ZkXpON+o+F6M1bxa7t+yRQ
         y7Qw==
X-Gm-Message-State: AFqh2krxvQEgfDcXeqT6eaKAVTKH3qdNEWfqxOxqaU7AIrRIxG4lqKBU
        mhiaP0pe8A+yJwmTEopIwz6Hxw==
X-Google-Smtp-Source: AMrXdXt3XUbsefby5PW8M8bCChp15hd4F7Z4dOjg6DN8aEsIIlSHZgKQB98OXMJnLhY7l5dwWgIepw==
X-Received: by 2002:a05:600c:3555:b0:3da:f4d4:4c2 with SMTP id i21-20020a05600c355500b003daf4d404c2mr13290243wmq.37.1674209627458;
        Fri, 20 Jan 2023 02:13:47 -0800 (PST)
Received: from localhost (laubervilliers-658-1-213-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.gmail.com with ESMTPSA id k10-20020a05600c1c8a00b003db2dbbd710sm2039409wms.25.2023.01.20.02.13.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Jan 2023 02:13:46 -0800 (PST)
References: <d75ef7df-a645-7fdd-491a-f89f70dbea01@gmail.com>
 <Y8Qwk5H8Yd7qiN0j@lunn.ch>
 <03ea260e-f03c-d9d7-6f5f-ff72836f5739@gmail.com>
 <51abd8ca-8172-edfa-1c18-b1e48231f316@linaro.org>
 <6de25c61-c187-fb88-5bd7-477b1db1510e@gmail.com>
 <e75ed56f-ba25-f337-e879-33cc2a784740@gmail.com>
User-agent: mu4e 1.8.10; emacs 28.2
From:   Jerome Brunet <jbrunet@baylibre.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
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
Subject: Re: [PATCH net-next] net: phy: meson-gxl: support more
 G12A-internal PHY versions
Date:   Fri, 20 Jan 2023 11:01:56 +0100
In-reply-to: <e75ed56f-ba25-f337-e879-33cc2a784740@gmail.com>
Message-ID: <1jo7qtwm1z.fsf@starbuckisacylon.baylibre.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Thu 19 Jan 2023 at 23:42, Heiner Kallweit <hkallweit1@gmail.com> wrote:

> On 15.01.2023 21:38, Heiner Kallweit wrote:
>> On 15.01.2023 19:43, Neil Armstrong wrote:
>>> Hi Heiner,
>>>
>>> Le 15/01/2023 =C3=A0 18:09, Heiner Kallweit a =C3=A9crit=C2=A0:
>>>> On 15.01.2023 17:57, Andrew Lunn wrote:
>>>>> On Sun, Jan 15, 2023 at 04:19:37PM +0100, Heiner Kallweit wrote:
>>>>>> On my SC2-based system the genphy driver was used because the PHY
>>>>>> identifies as 0x01803300. It works normal with the meson g12a
>>>>>> driver after this change.
>>>>>> Switch to PHY_ID_MATCH_MODEL to cover the different sub-versions.
>>>>>
>>>>> Hi Heiner
>>>>>
>>>>> Are there any datasheets for these devices? Anything which documents
>>>>> the lower nibble really is a revision?
>>>>>
>>>>> I'm just trying to avoid future problems where we find it is actually
>>>>> a different PHY, needs its own MATCH_EXACT entry, and then we find we
>>>>> break devices using 0x01803302 which we had no idea exists, but got
>>>>> covered by this change.
>>>>>
>>>> The SC2 platform inherited a lot from G12A, therefore it's plausible
>>>> that it's the same PHY. Also the vendor driver for SC2 gives a hint
>>>> as it has the following compatible for the PHY:
>>>>
>>>> compatible =3D "ethernet-phy-id0180.3301", "ethernet-phy-ieee802.3-c22=
";
>>>>
>>>> But you're right, I can't say for sure as I don't have the datasheets.
>>>
>>> On G12A (& GXL), the PHY ID is set in the MDIO MUX registers,
>>> please see:
>>> https://elixir.bootlin.com/linux/latest/source/drivers/net/mdio/mdio-mu=
x-meson-g12a.c#L36
>>>
>>> So you should either add support for the PHY mux in SC2 or check
>>> what is in the ETH_PHY_CNTL0 register.
>>>
>> Thanks for the hint. I just checked and reading back ETH_PHY_CNTL0 at the
>> end of g12a_enable_internal_mdio() gives me the expected result of 0x330=
10180.
>> But still the PHY reports 3300.
>> Even if I write some other random value to ETH_PHY_CNTL0, I get 0180/3300
>> as PHY ID.
>>=20
>> For u-boot I found the following:
>>=20
>> https://github.com/khadas/u-boot/blob/khadas-vim4-r-64bit/drivers/net/ph=
y/amlogic.c
>>=20
>> static struct phy_driver amlogic_internal_driver =3D {
>> 	.name =3D "Meson GXL Internal PHY",
>> 	.uid =3D 0x01803300,
>> 	.mask =3D 0xfffffff0,
>> 	.features =3D PHY_BASIC_FEATURES,
>> 	.config =3D &meson_phy_config,
>> 	.startup =3D &meson_aml_startup,
>> 	.shutdown =3D &genphy_shutdown,
>> };
>>=20
>> So it's the same PHY ID I'm seeing in Linux.
>>=20
>> My best guess is that the following is the case:
>>=20
>> The PHY compatible string in DT is the following in all cases:
>> compatible =3D "ethernet-phy-id0180.3301", "ethernet-phy-ieee802.3-c22";
>>=20
>> Therefore id 0180/3301 is used even if the PHY reports something else.
>> Means it doesn't matter which value you write to ETH_PHY_CNTL0.
>>=20
>> I reduced the compatible string to compatible =3D "ethernet-phy-ieee802.=
3-c22"
>> and this resulted in the actual PHY ID being used.
>> You could change the compatible in dts the same way for any g12a system
>> and I assume you would get 0180/3300 too.
>>=20
>> Remaining question is why the value in ETH_PHY_CNTL0 is ignored.
>>=20
>
> I think I found what's going on. The PHY ID written to SoC register
> ETH_PHY_CNTL0 isn't effective immediately. It takes a PHY soft reset befo=
re
> it reports the new PHY ID. Would be good to have a comment in the
> g12a mdio mux code mentioning this constraint.
>
> I see no easy way to trigger a soft reset early enough. Therefore it's in=
deed
> the simplest option to specify the new PHY ID in the compatible.

This is because (I guess) the PHY only picks ups the ID from the glue
when it powers up. After that the values are ignored.

Remember the PHY is a "bought" IP, the glue/mux provides the input
settings required by the PHY provider.

Best would be to trigger an HW reset of PHY from glue after setting the
register ETH_PHY_CNTL0.

Maybe this patch could help : ?
https://gitlab.com/jbrunet/linux/-/commit/ccbb07b0c9eb2de26818eb4f8aa1fd0e5=
b31e6db.patch

I tried this when we debugged the connectivity issue on the g12 earlier
this spring. I did not send it because the problem was found to be in
stmmac.

