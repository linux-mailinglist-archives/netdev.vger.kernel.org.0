Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9013E586693
	for <lists+netdev@lfdr.de>; Mon,  1 Aug 2022 10:50:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230109AbiHAIu1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Aug 2022 04:50:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229920AbiHAIu0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Aug 2022 04:50:26 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA9FF6264
        for <netdev@vger.kernel.org>; Mon,  1 Aug 2022 01:50:23 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id a11so5423166wmq.3
        for <netdev@vger.kernel.org>; Mon, 01 Aug 2022 01:50:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:from:to:cc;
        bh=31O8ovLNtTNvEXUXIG07xH4GCHGVnpgSiTE7ih01mcI=;
        b=DEVZa/eNJ/hpFhH4u1Bs4bQp+4ZzM5ExT+7Ewp7B16j1EbDEf6ldaYV79hhefRl12K
         8RWl2VqNYaPc5GvZfjow5F7qnoqIeFVE65dWd7WsgGeaWfnx3Su1ab6fRZ9KDybec4UX
         5KA9zzSf+cjNV8RQHCGlbxdMRStGPxqLHoeli9UADZN9lSlKhf3zqGs2Ezu1AR+9oapr
         eRjLPE60/SiMRYPHSuqXdZVtZlPT5FZMmQbLeSGgMBF2M4wSo/JXj/fOU9II3hDjTn9w
         N+Chk96Dg3DwMR9TQI6iW69qU6hFeZ7SriOhqY741066BGXHvcFn2ZTUllyjVuQ7d48I
         fNug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:x-gm-message-state:from:to:cc;
        bh=31O8ovLNtTNvEXUXIG07xH4GCHGVnpgSiTE7ih01mcI=;
        b=u3Uis+nAQek6zkHlYqeORCWyrId3k6dIMoxSK9wbgIza1NiIuXUX+FAjyIchxa2ihL
         srbCTpVCKQCPaD06NBmxFy+ygFqrkBQbcCb3+17wkeK81vNa348V7xY0WiOn7HQIkRwX
         W/KpJ9plUpmVgLw/qbp40SQS5kIifAxnDysYnn++B+v2Q6vCcBAzo0RAAgxTBpd6Sx+U
         +LTH9ouQJqPTyNezystg8xDjEHfQGckFqq8w8ytbMtTDNlGYv0FwBV5bUojpdbjW9qyz
         znTBmUrJt6T2BnDkuJ8BiET3FUNGRQrky8tneJb0f/0TeeFyrzw30g67P3J3/WgEEJEj
         YzXA==
X-Gm-Message-State: AJIora/VY6Uen2Syfg5bZ65hp1BW/c4snVRQquN4QgdD9GgH3wtxbfiM
        E8ztxQjCiDzrZ6yPGRmNFbnLQA==
X-Google-Smtp-Source: AGRyM1v0rDwsCTzsOFZJWkATMcBdINS/2/Y+B2iG7/TtU913pUZQ3zG7JgtLkTnd3S6+dFK5HwIWWA==
X-Received: by 2002:a05:600c:2044:b0:3a3:15a1:ddfd with SMTP id p4-20020a05600c204400b003a315a1ddfdmr10506355wmg.3.1659343822506;
        Mon, 01 Aug 2022 01:50:22 -0700 (PDT)
Received: from localhost (laubervilliers-658-1-213-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.gmail.com with ESMTPSA id a1-20020adfe5c1000000b0021e491fd250sm4810200wrn.89.2022.08.01.01.50.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Aug 2022 01:50:21 -0700 (PDT)
References: <ca9560eb-af9c-3cfa-c35e-388e7e71aab7@gmail.com>
 <CAFBinCCMinq1U2Pqn2LPjC9c+HqfHjvW81b1ENMxdoGmB6byEw@mail.gmail.com>
 <88d6ef05-f77a-57a2-f34a-e3998a8d70d4@gmail.com>
 <CACdvmAgSvsYj6zorYDrBaEUvZzPi_c0XpVzx3fz8nHp8+TXMuQ@mail.gmail.com>
User-agent: mu4e 1.8.6; emacs 27.1
From:   Jerome Brunet <jbrunet@baylibre.com>
To:     Da Xue <da@lessconfused.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "open list:ARM/Amlogic Meson..." <linux-amlogic@lists.infradead.org>,
        "linux-rockchip@lists.infradead.org" 
        <linux-rockchip@lists.infradead.org>
Subject: Re: Meson GXL and Rockchip PHY based on same IP?
Date:   Mon, 01 Aug 2022 10:45:09 +0200
In-reply-to: <CACdvmAgSvsYj6zorYDrBaEUvZzPi_c0XpVzx3fz8nHp8+TXMuQ@mail.gmail.com>
Message-ID: <1jzggowdo5.fsf@starbuckisacylon.baylibre.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Mon 01 Aug 2022 at 03:09, Da Xue <da@lessconfused.com> wrote:

> On Sat, Jul 30, 2022 at 3:31 PM Heiner Kallweit <hkallweit1@gmail.com> wrote:
>>
>> On 30.07.2022 19:06, Martin Blumenstingl wrote:
>> > Hi Heiner,
>> >
>> > On Sat, Jul 30, 2022 at 5:59 PM Heiner Kallweit <hkallweit1@gmail.com> wrote:
>> >>
>> >> Meson GXL and Rockchip ethernet PHY drivers have quite something in common.
>> >> They share a number of non-standard registers, using the same bits
>> >> and same bank handling. This makes me think they they may be using
>> >> the same IP. However they have different quirk handling. But this
>> >> doesn't rule out that actually they would need the same quirk handling.
>> > You made me curious and I found the following public Microchip
>> > LAN83C185 datasheet: [0]
>> > Page 27 has a "SMI REGISTER MAPPING" which matches the definitions in
>> > meson-gxl.c.
>> > Also on page 33 the interrupt source bits are a 100% match with the
>> > INTSRC_* marcos in meson-gxl.c
>> >
>> Great, thanks for investigating!
>>
>> > Whether this means that:
>> > - Amlogic SoCs embed a LAN83C185
>> > - LAN83C185 is based on the same IP core (possibly not even designed
>> > by Amlogic or SMSC)
>> > - the SMI interface design is something that one hardware engineer
>> > brought from one company to another
>> > - ...something else
>> > is something I can't tell
>
> Per Jerome, both are OmniPHY IP.
>

I believe it to be the case, yes.

However, the version of the IP could be different.
The integration the SoC vendor did is very likely to be different too.

I'd be in favor of keeping things the way they are now.
I don't think merging the drivers now is really worth the effort.
With the uncertainty there is around SoC integration, It could bring more
problems that it solves down the line.

>
>> >
>> >
>> > Best regards,
>> > Martin
>> >
>> >
>> > [0] https://ww1.microchip.com/downloads/en/DeviceDoc/LAN83C185-Data-Sheet-DS00002808A.pdf
>>
>>
>> _______________________________________________
>> Linux-rockchip mailing list
>> Linux-rockchip@lists.infradead.org
>> http://lists.infradead.org/mailman/listinfo/linux-rockchip

