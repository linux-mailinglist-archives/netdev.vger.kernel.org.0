Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5399116BE48
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 11:09:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729959AbgBYKJD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 05:09:03 -0500
Received: from frisell.zx2c4.com ([192.95.5.64]:58811 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729129AbgBYKJD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Feb 2020 05:09:03 -0500
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id d66c8548;
        Tue, 25 Feb 2020 10:05:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=bMG3a8sETAFevA+RrkHwTbqJF4k=; b=tuTxGH
        wrdaV6dHFYM1sfCD2lgenrCr2sIS4fI8ONgYGlT8HU/Pjh2/XeqoG6FUR7UYzWgr
        CU8NaYNpLND2rmT2wHojH0PTFjmUD7hT7Ry2dvF3TZ/xLha/KqpfFCSf+S+L5CLU
        xVtVBQXuCgU9vThFW6Y+D/tPqYThlXnpUVEn2kCGZz5k+U8sncwOSa4bjhYnJYWk
        ibPUjc+4P5NT7rLRri7fIhbQ7RtSs2fZ92qKSnOUGQN01ZskpZl7JiivgiDOhzPZ
        jqKCm097vS2cYmlvis5k8sh0KfgLpPjeUsMmYFjO82TJcCerTVbL+KFjkmXcxnU3
        h/0iZnHS9GLePBKQ==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id d1f191ff (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO);
        Tue, 25 Feb 2020 10:05:30 +0000 (UTC)
Received: by mail-ot1-f44.google.com with SMTP id r27so11541373otc.8;
        Tue, 25 Feb 2020 02:09:01 -0800 (PST)
X-Gm-Message-State: APjAAAXPUkT6CYNljQlMZYl1A3tiHhS8R0D4W7P8CtLxsbRGq4VwjYsJ
        LfWdO+X7WOkFR56jnqmBEjTZQd3OoLZJU64Nfto=
X-Google-Smtp-Source: APXvYqyH6FyTD1BglsITNbf1R40BsS3/QdM1a7nYQiUam5fFt2VuAFypr29/4UNOs4hsUsYffLXzwJybJ3XWivHpwE4=
X-Received: by 2002:a9d:6a53:: with SMTP id h19mr45381243otn.120.1582625340064;
 Tue, 25 Feb 2020 02:09:00 -0800 (PST)
MIME-Version: 1.0
References: <20200225063930.106436-1-chenzhou10@huawei.com> <CAHmME9rWq+jJk5s+OoQ+MFMg74=b-a+LtJFjNWqLg6fcreLKbA@mail.gmail.com>
In-Reply-To: <CAHmME9rWq+jJk5s+OoQ+MFMg74=b-a+LtJFjNWqLg6fcreLKbA@mail.gmail.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Tue, 25 Feb 2020 18:08:48 +0800
X-Gmail-Original-Message-ID: <CAHmME9pr0CEiztk11GMJS3MFhQkAmeUPkM-uHR06_ataw+SpBg@mail.gmail.com>
Message-ID: <CAHmME9pr0CEiztk11GMJS3MFhQkAmeUPkM-uHR06_ataw+SpBg@mail.gmail.com>
Subject: Re: [PATCH -next] drivers: net: WIREGUARD depends on IPV6
To:     Chen Zhou <chenzhou10@huawei.com>
Cc:     David Miller <davem@davemloft.net>, jiri@mellanox.com,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 25, 2020 at 2:52 PM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
> On 2/25/20, Chen Zhou <chenzhou10@huawei.com> wrote:
> > If CONFIG_IPV6 is n, build fails:
> >
> > drivers/net/wireguard/device.o: In function `wg_xmit':
> > device.c:(.text+0xb2d): undefined reference to `icmpv6_ndo_send'
> > make: *** [vmlinux] Error 1
> >
> > Set WIREGUARD depending on IPV6 to fix this.
> >
> > Reported-by: Hulk Robot <hulkci@huawei.com>
> > Signed-off-by: Chen Zhou <chenzhou10@huawei.com>
> > ---
> >  drivers/net/Kconfig | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
> > index 25a8f93..824292e 100644
> > --- a/drivers/net/Kconfig
> > +++ b/drivers/net/Kconfig
> > @@ -74,7 +74,7 @@ config DUMMY
> >  config WIREGUARD
> >       tristate "WireGuard secure network tunnel"
> >       depends on NET && INET
> > -     depends on IPV6 || !IPV6
> > +     depends on IPV6
>
> Thanks for reporting the breakage. However, this is not the correct
> fix, as wireguard should work without IPv6. Rather, the recent icmp
> fixes changed something. I'll investigate why when I'm off the road in
> several hours.

Off the road. Fix posted to mailing list:
https://lore.kernel.org/netdev/20200225100535.45146-1-Jason@zx2c4.com/
