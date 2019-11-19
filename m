Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE911102C16
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 19:56:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727148AbfKSS4F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 13:56:05 -0500
Received: from mail-ot1-f68.google.com ([209.85.210.68]:42558 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726892AbfKSS4F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 13:56:05 -0500
Received: by mail-ot1-f68.google.com with SMTP id b16so18855818otk.9;
        Tue, 19 Nov 2019 10:56:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CCMimOxx1V+1wuiFXabtOOmc4F+FlW5VrFGeJkEeb3g=;
        b=WU1aFvI96hM19+44aW8xWwhcFV+VkO2FaTZ3uvCD27r1LUKpWEDyf1yGPotkI04iXN
         oNyYacW2JY+SfP1HYc7Kl80zpQVgSlvXwgQfNGlsbeyd1jpTUsu5h0GiPwFMsODOcN0Y
         rFrafl2QQYOemVJgvUdjFycGnj3V0/bK0gUjlFm50I8ozVDDgqJRIZvEoE+VNEubJmTf
         +aY79/rc4k1cwjzSBG6I2KgOFrGff44FedjAk6KVaW3k/6mBT19XOfRxCBN81+jy1RDV
         +Vn3cv7dV/IqxYupuw5WPiQPOYjnbn2E05UpywBZilGvX3uBXuuh92wpNnZk+n4BvjZV
         Akyg==
X-Gm-Message-State: APjAAAWRMWOWL8YAuNzq/kefTSi0ThdW0F9peTufJIxeJeS0xoEsGKxm
        lB041ecFtv6LQlXceQriXnMR+EH0IsWy89bmsUc=
X-Google-Smtp-Source: APXvYqx9RerZ121T3Eq7XBfWuQsji+hUcMrbDd/mvJJNzps0Zuxlx3QL2Akjf/eIrhg+NcOQ2gFiiv9G2SJxxaTwvN8=
X-Received: by 2002:a9d:5511:: with SMTP id l17mr4972413oth.145.1574189764218;
 Tue, 19 Nov 2019 10:56:04 -0800 (PST)
MIME-Version: 1.0
References: <20191119112524.24841-1-geert+renesas@glider.be> <1afede33-897b-8718-d977-351357dffe4f@gmail.com>
In-Reply-To: <1afede33-897b-8718-d977-351357dffe4f@gmail.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Tue, 19 Nov 2019 19:55:53 +0100
Message-ID: <CAMuHMdW+Lkj1VRbS-1Qw8YsbPYueFrM770eBRv=e_sTg8vbiVg@mail.gmail.com>
Subject: Re: [PATCH] mdio_bus: Fix init if CONFIG_RESET_CONTROLLER=n
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Geert Uytterhoeven <geert+renesas@glider.be>,
        YueHaibing <yuehaibing@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Florian,

On Tue, Nov 19, 2019 at 7:05 PM Florian Fainelli <f.fainelli@gmail.com> wrote:
> On 11/19/19 3:25 AM, Geert Uytterhoeven wrote:
> > Commit 1d4639567d970de0 ("mdio_bus: Fix PTR_ERR applied after
> > initialization to constant") accidentally changed a check from -ENOTSUPP
> > to -ENOSYS, causing failures if reset controller support is not enabled.
> > E.g. on r7s72100/rskrza1:
> >
> >     sh-eth e8203000.ethernet: MDIO init failed: -524
> >     sh-eth: probe of e8203000.ethernet failed with error -524
> >
> > Fixes: 1d4639567d970de0 ("mdio_bus: Fix PTR_ERR applied after initialization to constant")
> > Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
>
> This has been fixed in the "net" tree with:
>
> https://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git/commit/?id=075e238d12c21c8bde700d21fb48be7a3aa80194

Ah, hadn't seen that one.

However, that one (a) keeps the unneeded check for -ENOSYS, and (b)
carries a wrong Fixes tag.

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
