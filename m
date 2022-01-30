Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD3184A332A
	for <lists+netdev@lfdr.de>; Sun, 30 Jan 2022 02:54:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353735AbiA3ByP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Jan 2022 20:54:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353724AbiA3ByO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Jan 2022 20:54:14 -0500
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55BDBC061714
        for <netdev@vger.kernel.org>; Sat, 29 Jan 2022 17:54:14 -0800 (PST)
Received: by mail-pf1-x42c.google.com with SMTP id a19so3689661pfx.4
        for <netdev@vger.kernel.org>; Sat, 29 Jan 2022 17:54:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uuv/aA7Fv1K1L0839tgYMOIoHNyD2R5i/0C4RiyS+JU=;
        b=RrW68omIJIwLn/zYuINSuv6awci546gaG8ib6h8dWI9nNdR7fu8jXloawXKLPyN7AH
         peNG5plCbpSgjJTdMuMZWptr69EnOdDELQWJ433RKv4l88b1rCSV/1Nhm+U9sRIY2UuR
         LGfxTL1O3M5z9/EiEOtm+huBLNUfkQGcj4+ovd5dmv+7LNfydjTUAZP7QUoj+c7LdmeO
         FLJvGfdt+HGnE1heYd9GVl2YJOXvrLUVLm5b3tZkqkdsI/W8JxDzi5Yb+c/YxyACMd+g
         SDyP+vJcq2xypRfIIoBbX/urZq082ITjk0rfK+PIVQnlAGYEbTRBU2zwEHbjUbGt2r0C
         KwiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uuv/aA7Fv1K1L0839tgYMOIoHNyD2R5i/0C4RiyS+JU=;
        b=eAL5I7qU3bAxLy0bD4tANfeLNDOXVeInOeeo1vcycNF7vmvSjMKs+lrKYLKHt/VNMu
         rlRZs1t88tX5meiy4W+7JGlN27UWJ8WKpzZkSCp8ZVp3lMKDtBJzPNiCffVqre6xNLch
         CP8OpzXVhu3Z8PFSveEAHw0YYsPcNagf8SwkFr5vB2ZOdkUpbY0FlJfUhpkD/EIG5sBs
         XixT3bOhbDAS7C5LFXVZIPQ3sBnc9frkHlJorgqPhDH9+wAOy8GJYWGT4CwfTHUb4HF+
         hMUjtDTQDHWfxxsrFj/0mdkJTV6uWtuw+Z06+HXgMmTHimI59z7F7v8MOaxPRhKo+HRu
         LqlQ==
X-Gm-Message-State: AOAM530Fs0GSXzf2A/xdNkR2X9+Km0y2KJEe096eaBGlQGJL+EfiMSFh
        zI5nS7iqpUu0pYXWLZDa4Xo2zXK61o1nW+Xkv4ppI5s4itib94Yo
X-Google-Smtp-Source: ABdhPJwTm7GcMDchie3o7KWO7sCHt+CggxltjsgSRWxc22HrYihifwPH4SF6OAxP7VL0s+bCIrFkEbVC0eKSkTwYFZE=
X-Received: by 2002:a62:190b:: with SMTP id 11mr13884948pfz.77.1643507653796;
 Sat, 29 Jan 2022 17:54:13 -0800 (PST)
MIME-Version: 1.0
References: <20220105031515.29276-1-luizluca@gmail.com> <20220105031515.29276-12-luizluca@gmail.com>
 <87ee5fd80m.fsf@bang-olufsen.dk> <trinity-ea8d98eb-9572-426a-a318-48406881dc7e-1641822815591@3c-app-gmx-bs62>
 <87r19e5e8w.fsf@bang-olufsen.dk> <trinity-4b35f0dc-6bc6-400a-8d4e-deb26e626391-1641926734521@3c-app-gmx-bap14>
 <87v8ynbylk.fsf@bang-olufsen.dk> <trinity-d858854a-ff84-4b28-81f4-f0becc878017-1642089370117@3c-app-gmx-bap49>
 <CAJq09z7jC8EpJRGF2NLsSLZpaPJMyc_TzuPK_BJ3ct7dtLu+hw@mail.gmail.com>
In-Reply-To: <CAJq09z7jC8EpJRGF2NLsSLZpaPJMyc_TzuPK_BJ3ct7dtLu+hw@mail.gmail.com>
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
Date:   Sat, 29 Jan 2022 22:54:02 -0300
Message-ID: <CAJq09z5sJJO_1ogPi5+PhHkBS9ry5_oYctMhxu68GRNqEr3xLw@mail.gmail.com>
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

> I suggested it might be checksum problem because I'm also affected. In
> my case, I have an mt7620a SoC connected to the rtl8367s switch. The
> OS offloads checksum to HW but the mt7620a cannot calculate the
> checksum with the (EtherType) Realtek CPU Tag in place. I'll try to
> move the CPU tag to test if the mt7620a will then digest the frame
> correctly.

I implemented a new DSA tag (rtl8_4t, with "t" as in trailing) that
puts the DSA tag before the Ethernet CRC (the switch supports both).
With no tag in the mac layer, mediatek correctly calculated the ip
checksum. However, mediatek SoC included the extra bytes from the DSA
tag in the TCP checksum, even if they are after the ip length.

This is the packet leaving the OS:

0000   04 0e 3c fc 4f aa 50 d4 f7 33 15 8a 08 00 45 10
0010   00 3c 00 00 40 00 40 06 b7 58 c0 a8 01 01 c0 a8
0020   01 02 00 16 a1 50 80 da 39 e9 b2 2a 23 cf a0 12
0030   fe 88 83 82 00 00 02 04 05 b4 04 02 08 0a 01 64
0040   fb 28 66 42 e0 79 01 03 03 03 88 99 04 00 00 20
0050   00 08

TCP checksum is at 0x0032 with 0x8382 is the tcp checksum
DSA Tag is at 0x4a with 8899040000200008

This is what arrived at the other end:

0000   04 0e 3c fc 4f aa 50 d4 f7 33 15 8a 08 00 45 10
0010   00 3c 00 00 40 00 40 06 b7 58 c0 a8 01 01 c0 a8
0020   01 02 00 16 a1 50 80 da 39 e9 b2 2a 23 cf a0 12
0030   fe 88 c3 e8 00 00 02 04 05 b4 04 02 08 0a 01 64
0040   fb 28 66 42 e0 79 01 03 03 03

TCP checksum is 0xc3e8, but the correct one should be 0x50aa
If you calculate tcp checksum including 8899040000200008, you'll get exactly
0xc3e8 (I did the math).

So, If we use a trailing DSA tag, we can leave the IP checksum offloading on
and just turn off the TCP checksum offload. Is it worth it?

Is it still interesting to have the rtl8_4t merged?

Regards,
