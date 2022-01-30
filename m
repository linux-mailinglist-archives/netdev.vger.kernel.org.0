Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD4734A3400
	for <lists+netdev@lfdr.de>; Sun, 30 Jan 2022 05:42:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354207AbiA3Em3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Jan 2022 23:42:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239246AbiA3Em2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Jan 2022 23:42:28 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3FF9C061714
        for <netdev@vger.kernel.org>; Sat, 29 Jan 2022 20:42:27 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id z14-20020a17090ab10e00b001b6175d4040so9119889pjq.0
        for <netdev@vger.kernel.org>; Sat, 29 Jan 2022 20:42:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/RlZxzhLjgBqPfluKYPf4iCBFPcBUjdCQsee63uJEYo=;
        b=mA0Wt/y2lGhsvJEmfEg3FPAnZubxI62GVjD7LwXpuqc+kH8EKZIn71j+QWe0XPb59q
         B5NG0NgcMD6GIfpSZs3hbKXiwtgfQq3au73pMyfUUUdynLoU7t9HjXXfzMtF25L15aOj
         QzrisfG4fKoxO6X/Tkj3c7Zww4g+e5NksxLy5DunK7s3QhcV9eD3q4wqoij+zQRH59on
         eHT3styCNUWNo6T6o0fKFXtWh6E4imh1MM+REkoCe4vFeRPBbCKOiOZPEtE1aS0VyZOa
         B8+lVWi58kHkOP/Q8bBasZYX0ko4dCyBAMeqnkrdwNENVQA2yBhmAm7jvPXr4Q1o4hrB
         dPXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/RlZxzhLjgBqPfluKYPf4iCBFPcBUjdCQsee63uJEYo=;
        b=I4IhLcLfWJdqtlufDZNhWWofKd3GY8p69iCx+TheRDxFC6u1W5hpTqV5J++gk3AawW
         fdzdxGkNBZ95eBIUv7oeRm5NI0ESq8Qx4XINEBe3fkBVKmr55KiFcVdWuj+TO30BOu+K
         oEb6yrHJSQPHoOWib5vMiaSjqyRCATEHJkALUFjN/HMute+pOZnGjC/pQqQAyvXBIIBg
         TpyMLTmmLEiWEXm2TpvV6b+SRl8ArgkwxuN9cuwqW2dgFkzvKMvUq1/c7x1AhuuILfqE
         HKUoLshUTxdGePgZLrbrq03mWPM4ZIFnRYkAQ8Kk/lOLBZhf3NqFIrCfj5HrKNVLELHI
         gC2w==
X-Gm-Message-State: AOAM533YIUrjCYbEFTXj2ovLgRbRxq1BhSqS2MV+QIooQv6e/iVZz1ZD
        2ujuN8lZxn73xf1usMWEq4joewHg8yqGdAarmMQI+2obrlE9r6G0
X-Google-Smtp-Source: ABdhPJyGTYH2q04Vc+tFoFY0UTb53HvqmYrYI2+9L1w9IdalHvqw48ArIv9cMWz+wo3OkFRyk/odOwbV2Oi0F18Ap5c=
X-Received: by 2002:a17:902:da89:: with SMTP id j9mr15007507plx.66.1643517747306;
 Sat, 29 Jan 2022 20:42:27 -0800 (PST)
MIME-Version: 1.0
References: <20220105031515.29276-1-luizluca@gmail.com> <20220105031515.29276-12-luizluca@gmail.com>
 <87ee5fd80m.fsf@bang-olufsen.dk> <trinity-ea8d98eb-9572-426a-a318-48406881dc7e-1641822815591@3c-app-gmx-bs62>
 <87r19e5e8w.fsf@bang-olufsen.dk> <trinity-4b35f0dc-6bc6-400a-8d4e-deb26e626391-1641926734521@3c-app-gmx-bap14>
 <87v8ynbylk.fsf@bang-olufsen.dk> <trinity-d858854a-ff84-4b28-81f4-f0becc878017-1642089370117@3c-app-gmx-bap49>
 <CAJq09z7jC8EpJRGF2NLsSLZpaPJMyc_TzuPK_BJ3ct7dtLu+hw@mail.gmail.com> <CAJq09z5sJJO_1ogPi5+PhHkBS9ry5_oYctMhxu68GRNqEr3xLw@mail.gmail.com>
In-Reply-To: <CAJq09z5sJJO_1ogPi5+PhHkBS9ry5_oYctMhxu68GRNqEr3xLw@mail.gmail.com>
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
Date:   Sun, 30 Jan 2022 01:42:15 -0300
Message-ID: <CAJq09z4tpxjog2XusyFvvTcr+S6XX24r_QBLW9Sov1L1Tebb5A@mail.gmail.com>
Subject: Re: Re: Re: Re: [PATCH net-next v4 11/11] net: dsa: realtek:
 rtl8365mb: multiple cpu ports, non cpu extint
To:     Frank Wunderlich <frank-w@public-files.de>
Cc:     =?UTF-8?Q?Alvin_=C5=A0ipraga?= <ALSI@bang-olufsen.dk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "olteanv@gmail.com" <olteanv@gmail.com>,
        "arinc.unal@arinc9.com" <arinc.unal@arinc9.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > I suggested it might be checksum problem because I'm also affected. In
> > my case, I have an mt7620a SoC connected to the rtl8367s switch. The
> > OS offloads checksum to HW but the mt7620a cannot calculate the
> > checksum with the (EtherType) Realtek CPU Tag in place. I'll try to
> > move the CPU tag to test if the mt7620a will then digest the frame
> > correctly.
>
> I implemented a new DSA tag (rtl8_4t, with "t" as in trailing) that
> puts the DSA tag before the Ethernet CRC (the switch supports both).
> With no tag in the mac layer, mediatek correctly calculated the ip
> checksum. However, mediatek SoC included the extra bytes from the DSA
> tag in the TCP checksum, even if they are after the ip length.
>
> This is the packet leaving the OS:
>
> 0000   04 0e 3c fc 4f aa 50 d4 f7 33 15 8a 08 00 45 10
> 0010   00 3c 00 00 40 00 40 06 b7 58 c0 a8 01 01 c0 a8
> 0020   01 02 00 16 a1 50 80 da 39 e9 b2 2a 23 cf a0 12
> 0030   fe 88 83 82 00 00 02 04 05 b4 04 02 08 0a 01 64
> 0040   fb 28 66 42 e0 79 01 03 03 03 88 99 04 00 00 20
> 0050   00 08
>
> TCP checksum is at 0x0032 with 0x8382 is the tcp checksum
> DSA Tag is at 0x4a with 8899040000200008
>
> This is what arrived at the other end:
>
> 0000   04 0e 3c fc 4f aa 50 d4 f7 33 15 8a 08 00 45 10
> 0010   00 3c 00 00 40 00 40 06 b7 58 c0 a8 01 01 c0 a8
> 0020   01 02 00 16 a1 50 80 da 39 e9 b2 2a 23 cf a0 12
> 0030   fe 88 c3 e8 00 00 02 04 05 b4 04 02 08 0a 01 64
> 0040   fb 28 66 42 e0 79 01 03 03 03
>
> TCP checksum is 0xc3e8, but the correct one should be 0x50aa
> If you calculate tcp checksum including 8899040000200008, you'll get exactly
> 0xc3e8 (I did the math).
>
> So, If we use a trailing DSA tag, we can leave the IP checksum offloading on
> and just turn off the TCP checksum offload. Is it worth it?

No, IP checksum is always done in SW.

> Is it still interesting to have the rtl8_4t merged?

Maybe it is. It has uncovered a problem. The case of trailing tags
seems to be unsolvable even with csum_start. AFAIK, the driver must
cksum from "skb->csum_start up to the end". When the switch is using
an incompatible tag, we have:

slave(): my features copied from master tells me I can offload
checksum. Do nothing
tagger(): add tag to the end of skb
master(): Offloading HW, chksum from csum_start until the end,
including the added tag
switch(): remove the tag, forward to the network
remove_client(): I got a packet with a broken checksum.

ndo_features_check() will not help because, either in HW or SW, it is
expected to calculate the checksum up to the end. However, there is no
csum_end or csum_len. I don't know if HW offloading will support some
kind of csum_end but it would not be a problem in SW (considering
skb_checksum_help() is adapted to something like skb_checksum_trimmed
without the clone).

That amount of bytes to ignore at the end is a complex question: the
driver either needs some hint (like it happens with skb->csum_offset)
to know where transport payload ends or the taggers (or the dsa) must
save the amount of extra bytes (or which tags were added) in the
sbk_buff. With that info, the driver can check if HW will work with a
different csum_start / csum_end or if only a supported tag is in use.

In my case, using an incompatible tailing tag, I just made it work
hacking dsa and forcing slave interfaces to disable offloading. This
way, checksum is calculated before any tag is added and offloading is
skipped. But it is not a real solution.

Regards,

Luiz,
