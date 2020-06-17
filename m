Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA1B01FC847
	for <lists+netdev@lfdr.de>; Wed, 17 Jun 2020 10:06:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726605AbgFQIGZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 04:06:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725846AbgFQIGX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jun 2020 04:06:23 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BD5AC061573
        for <netdev@vger.kernel.org>; Wed, 17 Jun 2020 01:06:22 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id a9so1725015ljn.6
        for <netdev@vger.kernel.org>; Wed, 17 Jun 2020 01:06:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=B8LNN6Key20EYI/bB3vo69b/z88FxbacidLE9gQ/PO0=;
        b=gty2LTq8LIIitTgkm67ANWqmB0dOZ6TGHwFh/AcZm4sCzo3sre0dXiEn7UU03Wfpfn
         ehodgHzHJi10ucYm5wrSsHeeNbPvyFBlyjxT6AP1UCOA684FK0yUpADp3aByvC2ZL8f2
         SfTbFQPofYfbXTSDd8YA31tuXV/JT1W4+417XPi2qoexnvoEVrSNoj6RL3rNFUVgISEe
         TSxxVezaIRDhQVPGrqiUgrsfkhzwR2jvsKsm/P18Me2nTdngBWSrSMOpbvFwtx2YUbv8
         yGR/KZfoLETulI1EDJOpRycpKHyHRqLHi2OJWIw29oqYYBoDrx0jPSVe4HbYb55DAUfx
         mTow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=B8LNN6Key20EYI/bB3vo69b/z88FxbacidLE9gQ/PO0=;
        b=XDH+PQu/Xfn6wdH7WgfYhrTVZd6EZXCqK3x1RXchxDkuRprZODqzTnpr8y52tYqrWv
         M6M3mrdJTDZmVlESPR8okVeu/l0OsMVb11WLCYKTuzxjMmQT2i2UckaS+G42NooyPieQ
         fRbkm/Vwg3MDojx8FpQbQVxjzvOpJrRGwRAvEFOyLtgrk3APmxrJUn7H4Bnz75+40fs3
         UsZhYdH61wC/wSwI23dopM2KSIEHtpK2KZiYnu/Y3MwTGynUs6fZfFhXto9lgW3GCPo6
         cHaanVgLqQfM1JdsrAazjhQQX5Ey6+N4r6tZWndn8X7S+qWSPsYY0OgtkYJAPMwz+S2N
         5/qA==
X-Gm-Message-State: AOAM532P/09iN80l99fhQUxJfVLQMw/nrfqRjgjZaUzpW8Gxel2jefyp
        kOJ1sysne4tkdVoBgLZ+/mzePXRCepznGwC9edyNTA==
X-Google-Smtp-Source: ABdhPJzVjkoKFfgYq0VUL081DtlYxM4GLBlKbvA+KFUlVDXpBSnJMvcpjCTjhLelKo7Qhtv9bzcsOfLs3il9Er9e7m8=
X-Received: by 2002:a2e:974a:: with SMTP id f10mr3549742ljj.283.1592381180662;
 Wed, 17 Jun 2020 01:06:20 -0700 (PDT)
MIME-Version: 1.0
References: <20200602205456.2392024-1-linus.walleij@linaro.org>
 <20200603135244.GA869823@lunn.ch> <CACRpkdbu4O_6SvgTU3A5mYVrAn-VWpr9=0LD+M+LduuqVnjsnA@mail.gmail.com>
 <20200604005407.GA977471@lunn.ch> <CACRpkdZvf4qnhQK=dqF4Shv0Q0nkVqTFcZS_5Zg8PrO+iCjxoQ@mail.gmail.com>
 <CA+h21hqNq6Xk5bMBsB884GZdH9h4pALr7nkn8yG+a16cXqfJsg@mail.gmail.com>
In-Reply-To: <CA+h21hqNq6Xk5bMBsB884GZdH9h4pALr7nkn8yG+a16cXqfJsg@mail.gmail.com>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Wed, 17 Jun 2020 10:06:08 +0200
Message-ID: <CACRpkda9kJUFwx-ASQfO-ThhgbV2fmT_tqT8zH0W_Jm23ZTVMg@mail.gmail.com>
Subject: Re: [net-next PATCH 1/5] net: dsa: tag_rtl4_a: Implement Realtek 4
 byte A tag
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        DENG Qingfang <dqfext@gmail.com>,
        Mauri Sandberg <sandberg@mailfence.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 4, 2020 at 1:23 PM Vladimir Oltean <olteanv@gmail.com> wrote:

> In the code you pointed to, there is a potentially relevant comment:
>
> 1532//CPU tag: Realtek Ethertype==0x8899(2 bytes)+protocol==0x9(4
> MSB)+priority(2 bits)+reserved(4 bits)+portmask(6 LSB)
>
> https://svn.dd-wrt.com/browser/src/linux/universal/linux-3.2/drivers/net/ethernet/raeth/rb/rtl_multicast_snooping.c#L1527
> https://svn.dd-wrt.com/browser/src/linux/universal/linux-3.2/drivers/net/ethernet/raeth/rb/rtl_multicast_snooping.c#L5224
>
> This strongly indicates to me that the insertion tag is the same as
> the extraction tag.

This code is a problem because it is Realtek-development style.
This style seems to be that the hardware people write the drivers
using copy/paste from the previous ASIC and ship is as soon as
possible. Keep this in mind.

The above tag is using protocol 9 and is actually even documented
in a PDF I have for RTL8306. The problem is that the RTL8366RB
(I suspect also RTL8366S) uses protocol "a" (as in hex 10).
Which is of course necessarily different.

I have *really* tried to figure out how the bits in protocol a works
when transmissing from the CPU port to any switch port.

When nothing else worked, I just tried all bit combinations with
0xannp where a is protocol and p is port. I looped through all
values several times trying to get a response from ping.

So this is really how far I can get right now, even with brute
force.

> It is completely opaque to me why in patch "[net-next PATCH 2/5] net:
> dsa: rtl8366rb: Support the CPU DSA tag" you are _disabling_ the
> injection of these tags via RTL8368RB_CPU_INSTAG. I think it's natural
> that the switch drops these packets when CPU tag insertion is
> disabled.

This is another Realtek-ism where they managed to invert the
meaning of a bit.

Bit 15 in register 0x0061 (RTL8368RB_CPU_CTRL_REG) can
be set to 1 and then the special (custom) CPU tag 0x8899
protocol a will be DISABLED. This value Realtek calls
"RTL8368RB_CPU_INSTAG" which makes you think that
the tag will be inserted, it is named "instag" right? But that
is not how it works.

That bit needs to be set to 0 to insert the tag and 1 to disable
insertion of the tag.

For this reason the patch also renames this bit to
RTL8368RB_CPU_NO_TAG which is more to the point.

Yours,
Linus Walleij
