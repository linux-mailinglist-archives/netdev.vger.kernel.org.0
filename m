Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EFF547562E
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 11:24:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241620AbhLOKX7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 05:23:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233789AbhLOKX7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Dec 2021 05:23:59 -0500
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08829C06173E
        for <netdev@vger.kernel.org>; Wed, 15 Dec 2021 02:23:59 -0800 (PST)
Received: by mail-yb1-xb34.google.com with SMTP id v203so53823596ybe.6
        for <netdev@vger.kernel.org>; Wed, 15 Dec 2021 02:23:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7JPx/hvRiMhPdRg3HEKBMA0HGei7FmGK+wM4FfH5TmA=;
        b=VpARRK46dwJXPC68Az6RTpD8Dwpauk4WSZi5Fi24CvaIJmlmxbiH8cHLUndFONrRSO
         kHrNo7YbDblB+5+mfa1FK44DojSteQvlz59/vp5yqMi2gIWmsuv2nggN9bcuQoNbZ5Xh
         zeco7HvUS4QvbwnsdrZWkdmdjr5I8D9lMUWE/916sNr/3QnTW73dfFNaE/6iN7fLUF+W
         okQYaSoltuv6X9IIaOC9H+7TLqspGZGYHCgK90Io5JUg3DPMGpqoI6PnmRTRr2oDqiU2
         dy/ZXxwLIuvVOxsVFCbfnWb/NTJDx21ZVYbELYKfhxyAReIyVTNkA7w0saZ+h2ByhPTU
         2smg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7JPx/hvRiMhPdRg3HEKBMA0HGei7FmGK+wM4FfH5TmA=;
        b=YeLVLN2agUfnz5ljSs8MVFFjq5t0j73wezZHAFFa/j48VIeZ4Eq3foXWIDmi/pQukt
         XZZNrPqOxc2Po7afZhg6OVX8qx1R8nq3VLYPGtO08QCVNR9TUUcfpENNjarykl+vZdCX
         X3Ih9mPC+zpeDs66IfkWb7Yi+kad4xvkwztW6py5nAo+NgUWpVogNLv17NpuxH33ReY2
         dMyS9Cx8PFgi3In9DjBxBaqc4uqU3858ILY58Cl0vdsZ9eqyZ/GTK3tdKh5E/5I4inV6
         qcffdfnPDqtI1+Gfd7KPW9RXivxC0034ZcvK8jfgbi5Qc09MFjG9qf56ZLqH98LPOexu
         aRuw==
X-Gm-Message-State: AOAM53041oJBgUWfMvlYY2XEAZ0IZLfMbtVGDWOF1rkPbtGwMlpf7ikU
        IrKdnQ0zpl5i/mlQl0S9NLgO0hcmOLLQEV7aMyLrPQ==
X-Google-Smtp-Source: ABdhPJz3yqWllE5qwHc0qz4zxdDO2+vjFjoCrIQMsIF8XavkNyJE1YDAk48WjIAO14WuvE8zuzz4ZXjZLmV8U7pI23s=
X-Received: by 2002:a25:760d:: with SMTP id r13mr5391301ybc.296.1639563837878;
 Wed, 15 Dec 2021 02:23:57 -0800 (PST)
MIME-Version: 1.0
References: <0b6c06487234b0fb52b7a2fbd2237af42f9d11a6.1639560869.git.geert+renesas@glider.be>
 <CANn89iKdorp0Ki0KFf6LAdjtKOm2np=vYY_YtkmJCoGfet1q-g@mail.gmail.com> <CAMuHMdWQZA_fS-pr+4wVYtZ6h9Bx4PJ_92qpDNZ2kdjpzj+DHQ@mail.gmail.com>
In-Reply-To: <CAMuHMdWQZA_fS-pr+4wVYtZ6h9Bx4PJ_92qpDNZ2kdjpzj+DHQ@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 15 Dec 2021 02:23:46 -0800
Message-ID: <CANn89iJ-uGzpbAhNjT=fGfDYTjpxo335yhKbqUKwSUPOwPZqWw@mail.gmail.com>
Subject: Re: [PATCH -next] lib: TEST_REF_TRACKER should depend on REF_TRACKER
 instead of selecting it
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 15, 2021 at 2:10 AM Geert Uytterhoeven <geert@linux-m68k.org> wrote:
>
> Hi Eric,
>
> On Wed, Dec 15, 2021 at 10:51 AM Eric Dumazet <edumazet@google.com> wrote:
> > On Wed, Dec 15, 2021 at 1:36 AM Geert Uytterhoeven
> > <geert+renesas@glider.be> wrote:
> > > TEST_REF_TRACKER selects REF_TRACKER, thus enabling an optional feature
> > > the user may not want to have enabled.  Fix this by making the test
> > > depend on REF_TRACKER instead.
> >
> > I do not understand this.
>
> The issue is that merely enabling tests should not enable optional
> features, to prevent unwanted features sneaking into a product.

if you do not want the feature, just say no ?

# CONFIG_TEST_REF_TRACKER is not set
# CONFIG_NET_DEV_REFCNT_TRACKER is not set
# CONFIG_NET_NS_REFCNT_TRACKER is not set


> If tests depend on features, all tests for features that are enabled can
> still be enabled (e.g. made modular, so they can be loaded when needed).
>
> > How can I test this infra alone, without any ref_tracker being selected ?
> >
> > I have in my configs
> >
> > CONFIG_TEST_REF_TRACKER=m
> > # CONFIG_NET_DEV_REFCNT_TRACKER is not set
> > # CONFIG_NET_NS_REFCNT_TRACKER is not set
> >
> > This should work.
>
> So you want to test the reference tracker, without having any actual
> users of the reference tracker enabled?

Yes, I fail to see the problem you have with this.

lib/ref_tracker.c is not adding intrusive features like KASAN.

>
> Perhaps REF_TRACKER should become visible, cfr. CRC32 and
> the related CRC32_SELFTEST?

I can not speak for CRC32.

My point is that I sent a series, I wanted this series to be bisectable.

When the test was added, I wanted to be able to use it right away.
(like compile it, and run it)

>
> > I would not have sent patches built around ref_tracker if I had no
> > ways of testing the base infrastructure.
>
> > > --- a/lib/Kconfig.debug
> > > +++ b/lib/Kconfig.debug
> > > @@ -2114,8 +2114,7 @@ config BACKTRACE_SELF_TEST
> > >
> > >  config TEST_REF_TRACKER
> > >         tristate "Self test for reference tracker"
> > > -       depends on DEBUG_KERNEL && STACKTRACE_SUPPORT
> > > -       select REF_TRACKER
> > > +       depends on DEBUG_KERNEL && STACKTRACE_SUPPORT && REF_TRACKER
> > >         help
> > >           This option provides a kernel module performing tests
> > >           using reference tracker infrastructure.
>
> Gr{oetje,eeting}s,
>
>                         Geert
>
> --
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org
>
> In personal conversations with technical people, I call myself a hacker. But
> when I'm talking to journalists I just say "programmer" or something like that.
>                                 -- Linus Torvalds
