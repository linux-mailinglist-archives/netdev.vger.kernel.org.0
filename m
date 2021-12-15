Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B60974755E3
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 11:11:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241532AbhLOKK4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 05:10:56 -0500
Received: from mail-ua1-f54.google.com ([209.85.222.54]:47041 "EHLO
        mail-ua1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232230AbhLOKKz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Dec 2021 05:10:55 -0500
Received: by mail-ua1-f54.google.com with SMTP id 30so39987378uag.13;
        Wed, 15 Dec 2021 02:10:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sUjqJXn9TZhfsyUeiypVIcQNCzl9zaIMs6UO0a7iDk0=;
        b=ByU/qKiUNToU9nZxofK/i8xm3DgBSQi/zCnE2zTcgc/sW+FPsRQs/NWksZNDJR6vC4
         YHTGXNLSGhX6vwR1H7NnjQKBTc7jWBLckkFqqj//MstwekZtZy8cAMcShzk5sGT21lZD
         3zedVmz8NHlZpuTbVoa4nFneUH8kndxz4SVN1XebS5nV2f0ZVvTRDYmwyYRskBOw7sUB
         2KaedHsDiuWddFvekb3GsDsEH5556K0ualKqOZ7UFEKhWP4xsC7DTSXAwDwQEA+5LCsP
         GYE1ofCYK3tYKbe+RAmfTO3m+p9SIdlkxfQDUEbIhDZKwB0zZH1aBt3WIYZkK8M40DT4
         sNQQ==
X-Gm-Message-State: AOAM531EolweboXCPTUJZDQnWwjx2wEmYBsEEoDs8vExMYbJjk/aJRC2
        3HFo6f9dQRJoS6Hz89lIZbzKOixZInGrzA==
X-Google-Smtp-Source: ABdhPJwd4TmaZicOxuITqg5zhCmE6HB8S3VzKQy17meUe5VnPwkBgS9xAMdXaEqzk6jIZM8u8isaYg==
X-Received: by 2002:ab0:74c1:: with SMTP id f1mr9028457uaq.109.1639563054887;
        Wed, 15 Dec 2021 02:10:54 -0800 (PST)
Received: from mail-ua1-f43.google.com (mail-ua1-f43.google.com. [209.85.222.43])
        by smtp.gmail.com with ESMTPSA id v17sm303218vsa.22.2021.12.15.02.10.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Dec 2021 02:10:54 -0800 (PST)
Received: by mail-ua1-f43.google.com with SMTP id i6so39986064uae.6;
        Wed, 15 Dec 2021 02:10:54 -0800 (PST)
X-Received: by 2002:a05:6102:3232:: with SMTP id x18mr2381011vsf.38.1639563054185;
 Wed, 15 Dec 2021 02:10:54 -0800 (PST)
MIME-Version: 1.0
References: <0b6c06487234b0fb52b7a2fbd2237af42f9d11a6.1639560869.git.geert+renesas@glider.be>
 <CANn89iKdorp0Ki0KFf6LAdjtKOm2np=vYY_YtkmJCoGfet1q-g@mail.gmail.com>
In-Reply-To: <CANn89iKdorp0Ki0KFf6LAdjtKOm2np=vYY_YtkmJCoGfet1q-g@mail.gmail.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Wed, 15 Dec 2021 11:10:42 +0100
X-Gmail-Original-Message-ID: <CAMuHMdWQZA_fS-pr+4wVYtZ6h9Bx4PJ_92qpDNZ2kdjpzj+DHQ@mail.gmail.com>
Message-ID: <CAMuHMdWQZA_fS-pr+4wVYtZ6h9Bx4PJ_92qpDNZ2kdjpzj+DHQ@mail.gmail.com>
Subject: Re: [PATCH -next] lib: TEST_REF_TRACKER should depend on REF_TRACKER
 instead of selecting it
To:     Eric Dumazet <edumazet@google.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Eric,

On Wed, Dec 15, 2021 at 10:51 AM Eric Dumazet <edumazet@google.com> wrote:
> On Wed, Dec 15, 2021 at 1:36 AM Geert Uytterhoeven
> <geert+renesas@glider.be> wrote:
> > TEST_REF_TRACKER selects REF_TRACKER, thus enabling an optional feature
> > the user may not want to have enabled.  Fix this by making the test
> > depend on REF_TRACKER instead.
>
> I do not understand this.

The issue is that merely enabling tests should not enable optional
features, to prevent unwanted features sneaking into a product.
If tests depend on features, all tests for features that are enabled can
still be enabled (e.g. made modular, so they can be loaded when needed).

> How can I test this infra alone, without any ref_tracker being selected ?
>
> I have in my configs
>
> CONFIG_TEST_REF_TRACKER=m
> # CONFIG_NET_DEV_REFCNT_TRACKER is not set
> # CONFIG_NET_NS_REFCNT_TRACKER is not set
>
> This should work.

So you want to test the reference tracker, without having any actual
users of the reference tracker enabled?

Perhaps REF_TRACKER should become visible, cfr. CRC32 and
the related CRC32_SELFTEST?

> I would not have sent patches built around ref_tracker if I had no
> ways of testing the base infrastructure.

> > --- a/lib/Kconfig.debug
> > +++ b/lib/Kconfig.debug
> > @@ -2114,8 +2114,7 @@ config BACKTRACE_SELF_TEST
> >
> >  config TEST_REF_TRACKER
> >         tristate "Self test for reference tracker"
> > -       depends on DEBUG_KERNEL && STACKTRACE_SUPPORT
> > -       select REF_TRACKER
> > +       depends on DEBUG_KERNEL && STACKTRACE_SUPPORT && REF_TRACKER
> >         help
> >           This option provides a kernel module performing tests
> >           using reference tracker infrastructure.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
