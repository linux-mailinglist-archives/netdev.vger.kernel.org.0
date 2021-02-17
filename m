Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3207931D566
	for <lists+netdev@lfdr.de>; Wed, 17 Feb 2021 07:39:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231496AbhBQGiC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Feb 2021 01:38:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231446AbhBQGh6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Feb 2021 01:37:58 -0500
Received: from mail-qv1-xf36.google.com (mail-qv1-xf36.google.com [IPv6:2607:f8b0:4864:20::f36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F8B4C061756
        for <netdev@vger.kernel.org>; Tue, 16 Feb 2021 22:37:18 -0800 (PST)
Received: by mail-qv1-xf36.google.com with SMTP id g3so5832938qvl.2
        for <netdev@vger.kernel.org>; Tue, 16 Feb 2021 22:37:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ugTQaAHGFRc8CPFFaoP0oTLZDH3L7/TR0bJ/954bT1w=;
        b=v8HGgPjVyadQVfPmCx53Cywv+tY+/NwgMZesn4Cct7G8jWSbvOzSIGB/hxY7I+rWGA
         oPcjS0UokMyi6R8y8MHOZwg3JJF+o1joKHa5yfpiRZu3x83CxzklWCWA6FeIJMTnAWwa
         1cjF4Jz6JHzpRx+OJw9YQp+P/pzawTcePep9dRvCNXkqQ93Db2OxFXqsn6ONhV/ZhD5h
         LlmUlWKOvNF0oDynmUvZ9R0CzNkbwPNwrbf4RrBCl8bFgVu/3tJJoxyj+NXRObkpv9Vz
         kWZpDzE7jiCSXPhk9ngfm93euWFpMKJ6F/jAnHNWbm3d3fpjYzoY5Zjx0x6kDOPhJSDe
         ZsqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ugTQaAHGFRc8CPFFaoP0oTLZDH3L7/TR0bJ/954bT1w=;
        b=taLBp8aUlozKGKlHVYDM2cQrEabn1wcMLK9I92GMCoOLizS1dEz7H9hDAPs/WQxW1H
         kF0OXLhXCgM0BNx6hzsfLj65/glOwXsvUn46p4YO5fvd/XYUdgoer8arMU2yav4hgdUl
         +sv7EmA9Gd5qfFHtwK6X7ZDdJVx/BBPO0TAjVGrAh9jE4BIPgs37SKhEz92ni+9m4Dyd
         wgmSVgRtF7kx5o8m/EHDT8CpMvf/v/+CRYcYr9sWMhJKhuLDzgH+KfW9FBVc6p3IvUn2
         FOMnAcG84RU2jrVFshUOqnBFeEcNhLVWcv2TgISYpTeI/a0mBClNxOjuZ1sC0LlS2Vhk
         gu/w==
X-Gm-Message-State: AOAM532kYCslKm1uv9t8Vqwomqo+uNlAHpCXV1GYvP3Ix+df5ghMWMY8
        RiILxW7bW28TyasFKQSKFGbUuv3bh5XZsnbDama7tA==
X-Google-Smtp-Source: ABdhPJziFbydIqs9spoKH8g+9HfptYXkPclDT0RznHkiHmn/kvucRG/COOeZ+TcnMFsCaeIlanv6uAAeyMTjEF5z1HE=
X-Received: by 2002:a0c:8304:: with SMTP id j4mr23007277qva.18.1613543837440;
 Tue, 16 Feb 2021 22:37:17 -0800 (PST)
MIME-Version: 1.0
References: <0000000000000be4d705bb68dfa7@google.com> <20210216172817.GA14978@arm.com>
 <CAHmME9q2-wbRmE-VgSoW5fxjGQ9kkafYH-X5gSVvgWESo5rm4Q@mail.gmail.com>
 <CAHmME9ob9g-pcsKU2=n2SOzjNwyGh9+dL-WGpQn4Da+DD4dPzA@mail.gmail.com>
 <20210216180143.GB14978@arm.com> <CACT4Y+ZH4ViZix7qyPPXtcgaanimm8CmSu1J8qhqpEedxC=fmQ@mail.gmail.com>
In-Reply-To: <CACT4Y+ZH4ViZix7qyPPXtcgaanimm8CmSu1J8qhqpEedxC=fmQ@mail.gmail.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Wed, 17 Feb 2021 07:37:06 +0100
Message-ID: <CACT4Y+bXSn+gh-AbVJmDvLOoG84Za6=bBGaXb=VnQFvosbbG+A@mail.gmail.com>
Subject: Re: KASAN: invalid-access Write in enqueue_timer
To:     Catalin Marinas <catalin.marinas@arm.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Netdev <netdev@vger.kernel.org>,
        syzbot <syzbot+95c862be69e37145543f@syzkaller.appspotmail.com>,
        Mark Brown <broonie@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Mark Rutland <mark.rutland@arm.com>, mbenes@suse.cz,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Will Deacon <will@kernel.org>, Ard Biesheuvel <ardb@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 16, 2021 at 7:15 PM Dmitry Vyukov <dvyukov@google.com> wrote:
> > On Tue, Feb 16, 2021 at 06:50:20PM +0100, Jason A. Donenfeld wrote:
> > > On Tue, Feb 16, 2021 at 6:46 PM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> > > > On Tue, Feb 16, 2021 at 6:28 PM Catalin Marinas <catalin.marinas@arm.com> wrote:
> > > > > >  hlist_add_head include/linux/list.h:883 [inline]
> > > > > >  enqueue_timer+0x18/0xc0 kernel/time/timer.c:581
> > > > > >  mod_timer+0x14/0x20 kernel/time/timer.c:1106
> > > > > >  mod_peer_timer drivers/net/wireguard/timers.c:37 [inline]
> > > > > >  wg_timers_any_authenticated_packet_traversal+0x68/0x90 drivers/net/wireguard/timers.c:215
> > > >
> > > > The line of hlist_add_head that it's hitting is:
> > > >
> > > > static inline void hlist_add_head(struct hlist_node *n, struct hlist_head *h)
> > > > {
> > > >        struct hlist_node *first = h->first;
> > > >        WRITE_ONCE(n->next, first);
> > > >        if (first)
> > > >
> > > > So that means it's the dereferencing of h that's a problem. That comes from:
> > > >
> > > > static void enqueue_timer(struct timer_base *base, struct timer_list *timer,
> > > >                          unsigned int idx, unsigned long bucket_expiry)
> > > > {
> > > >
> > > >        hlist_add_head(&timer->entry, base->vectors + idx);
> > > >
> > > > That means it concerns base->vectors + idx, not the timer_list object
> > > > that wireguard manages. That's confusing. Could that imply that the
> > > > bug is in freeing a previous timer without removing it from the timer
> > > > lists, so that it winds up being in base->vectors?
> >
> > Good point, it's indeed likely that the timer list is messed up already,
> > just an unlucky encounter in the wireguard code.
> >
> > > Digging around on syzkaller, it looks like there's a similar bug on
> > > jbd2, concerning iptunnels's allocation:
> > >
> > > https://syzkaller.appspot.com/text?tag=CrashReport&x=13afb19cd00000
> > [...]
> > > It might not actually be a wireguard bug?
> >
> > I wonder whether syzbot reported similar issues with
> > CONFIG_KASAN_SW_TAGS. It shouldn't be that different from the HW_TAGS
> > but at least we can rule out qemu bugs with the MTE emulation.
>
> +Eric

I've seen some similar reports on other syzkaller instances. They all
have similar alloc/free stacks, but different access stacks.
This does not seem to be wireguard nor arm/mte related. It seems that
something released the device prematurely, and then some innocent code
gets a use-after-free.
