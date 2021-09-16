Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD61E40EB09
	for <lists+netdev@lfdr.de>; Thu, 16 Sep 2021 21:47:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234461AbhIPTsw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Sep 2021 15:48:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234490AbhIPTsn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Sep 2021 15:48:43 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41F2EC061574
        for <netdev@vger.kernel.org>; Thu, 16 Sep 2021 12:47:22 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id m3so21198210lfu.2
        for <netdev@vger.kernel.org>; Thu, 16 Sep 2021 12:47:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oRD/cMRbGRL8eW9YNojc5SAnY20xvnXQSyOWFqi/OgQ=;
        b=VVedPAhhXvqQiPi13tSyQOLX8u5tNTR/9Sk0cDvJUoqRmAyM4xwFgAcTzMuUX3x8Qm
         ZQSuXCv1rMT2Y3TZ2fWhNMyoutGjZ6WJE5Xps077l5ng1SPHi96pbXaQZWkufjbUsJ8E
         SwaYeBwWS7O0ujHzV9O6zJeM0kMWN0lvLs7ok=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oRD/cMRbGRL8eW9YNojc5SAnY20xvnXQSyOWFqi/OgQ=;
        b=nkZ0pmF6dUg1f+XaFIdywxN7ZHYzaUCAop9M6umeGKH9f/UtOwH7A3+/HOCNPPLJoC
         9w7NeR+9l1zzA0vunp20+4pHpwLfg3yWiO8QYEpfbFmcH/kpotWAxojW2UCAWfx1GOBA
         xKF09ut4unDnGbz5++Zi0XwJcbzCMVO/X/QqmLb4RG4r/onhqxzPVrsE3GoRIJAAVLL3
         EupKQczm7d/NLz9sfv6ItFQRWQxRUAy9KHG+uo+D9Z7mNFp8Zyp/Atv7awNogELEh4EC
         Y9bQn92uUqnVVTRQGHnjaymLB37r5+Ou6oiXDjHbvy/Ky92wiPqFsFN4W/wLpHjOCZ/i
         HzSA==
X-Gm-Message-State: AOAM532YrONJmd+1iKsdhwVCeQhVRANcWPOumSHqsaTEmYG0RAr01XFK
        YG4df4nNQZSY4IjxwcEe+12foqQHTb/f6Yakhy8=
X-Google-Smtp-Source: ABdhPJzHFxVO/tGjpCikfU7GI78u97doVMvMj7g/oclGp7X3yOhCTkM1t1qhObvLQ495ZfMn59gv4Q==
X-Received: by 2002:a05:651c:54e:: with SMTP id q14mr6255572ljp.426.1631821640148;
        Thu, 16 Sep 2021 12:47:20 -0700 (PDT)
Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com. [209.85.167.48])
        by smtp.gmail.com with ESMTPSA id h15sm446665ljc.96.2021.09.16.12.47.17
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Sep 2021 12:47:18 -0700 (PDT)
Received: by mail-lf1-f48.google.com with SMTP id t10so17282364lfd.8
        for <netdev@vger.kernel.org>; Thu, 16 Sep 2021 12:47:17 -0700 (PDT)
X-Received: by 2002:a05:6512:94e:: with SMTP id u14mr5248863lft.173.1631821637208;
 Thu, 16 Sep 2021 12:47:17 -0700 (PDT)
MIME-Version: 1.0
References: <20210915035227.630204-1-linux@roeck-us.net> <CAHk-=wjXr+NnNPTorhaW81eAbdF90foVo-5pQqRmXZi-ZGaX6Q@mail.gmail.com>
 <47fcc9cc-7d2e-bc79-122b-8eccfe00d8f3@roeck-us.net> <CAHk-=wgdEHPm6vGcJ_Zr-Q_p=Muv1Oby5H2+6QyPGxiZ7_Wv+w@mail.gmail.com>
 <20210915223342.GA1556394@roeck-us.net>
In-Reply-To: <20210915223342.GA1556394@roeck-us.net>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 16 Sep 2021 12:47:01 -0700
X-Gmail-Original-Message-ID: <CAHk-=wiQPjD_XKhVLyB4w2O6Rsi8mq256qVuhR8jMTSwrMPDqg@mail.gmail.com>
Message-ID: <CAHk-=wiQPjD_XKhVLyB4w2O6Rsi8mq256qVuhR8jMTSwrMPDqg@mail.gmail.com>
Subject: Re: [PATCH v2 0/4] Introduce and use absolute_pointer macro
To:     Guenter Roeck <linux@roeck-us.net>,
        Andreas Koensgen <ajk@comnets.uni-bremen.de>
Cc:     Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>,
        "James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>,
        Helge Deller <deller@gmx.de>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        alpha <linux-alpha@vger.kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-parisc@vger.kernel.org, Netdev <netdev@vger.kernel.org>,
        Sparse Mailing-list <linux-sparse@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 15, 2021 at 3:33 PM Guenter Roeck <linux@roeck-us.net> wrote:
>
> drivers/net/hamradio/6pack.c: In function 'sixpack_open':
> drivers/net/hamradio/6pack.c:71:41: error:
>         unsigned conversion from 'int' to 'unsigned char' changes value from '256' to '0'
>
> patch:
>         https://lore.kernel.org/lkml/20210909035743.1247042-1-linux@roeck-us.net/
> David says it is wrong, and I don't know the code well enough
> to feel comfortable touching that code. That may be a lost cause.
> "depends on BROKEN if ALPHA" may be appropriate here.

David is wrong.

The code here is bogus, and the docs clearly state that the transmit
data is in units of "10ms":

    https://www.linux-ax25.org/wiki/6PACK

and that

    #define SIXP_TXDELAY                    (HZ/4)  /* in 1 s */

is just wrong, and the actual *uses* of that TX timeout seems correct
for that 10ms value:

        mod_timer(&sp->tx_t, jiffies + ((when + 1) * HZ) / 100);

ie that "when" is clearly given in 100ths of a second, aka 10ms (ok,
that's mainly SIXP_SLOTTIME, with SIXP_TXDELAY being used mainly to
transfer the data to the other side).

So from everything I can see, your patch is correct.

Of course, to make things more confusing, the RESYNC_TIMEOUTs are
indeed given in ticks.

I spent too much time looking at this, but I'm going to apply that
patch. I suspect either nobody uses that driver any more, or the
TXDELAY values don't actually much matter, since they have clearly
been wrong and depended on random kernel configs for a long long time.

I think the most common HZ value on x86 tends to be the modern default
of 250Hz, so the old "HZ/4" means that most people got a TXDELAY of
620ms, rather than the traditional expected 250ms.

The fact that this shows up as an actual compile error on alpha is
just random luck, since alpha uses a 1024Hz clock. CONFIG_HZ_1000
isn't impossible on other platforms either, which happens to compile
cleanly, but causes that TXDELAY byte to sent out as 250, for a 2.5Hz
TX delay.

Of course, it is possible that it's the documentation that is wrong,
but considering that the documentation matches the code (see above on
that "((when + 1) * HZ)/100"), and matches the "it doesn't cause
compiler warnings", I think it's pretty clear that your patch is the
correct fix.

           Linus
