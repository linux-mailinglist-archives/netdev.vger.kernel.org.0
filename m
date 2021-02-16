Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15B9031CFFE
	for <lists+netdev@lfdr.de>; Tue, 16 Feb 2021 19:16:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230362AbhBPSP7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 13:15:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229907AbhBPSP5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Feb 2021 13:15:57 -0500
Received: from mail-qk1-x729.google.com (mail-qk1-x729.google.com [IPv6:2607:f8b0:4864:20::729])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA3B7C061574
        for <netdev@vger.kernel.org>; Tue, 16 Feb 2021 10:15:16 -0800 (PST)
Received: by mail-qk1-x729.google.com with SMTP id z190so4386842qka.9
        for <netdev@vger.kernel.org>; Tue, 16 Feb 2021 10:15:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TIaOcjadSpBzzJCMnARKl1ZXAgu2yuZpBTm/4wzkXqs=;
        b=bUK55NBg5Uh81hVcSU2sx1CX7JZR04xf76FPXqIDHyXehqyY+Zi1t+aliIoc/R5e9n
         1joKE4tLAiSsbda18uhNJUsQXDlVmCaDe5LQSoBHbUyMpg77caNQ5W1ra4dKhaDZBktx
         VPJxl8d9MSR5AiuIsbMihyOpi7z1uhO7E5X1FlIYnQEyqGxuwfODwFoLCYY0wiHDv0tZ
         BjGXEOU9v4skzIhJX/4FwlXpHP9O0gJaA1Nk1bip/oEhnJPqaCYK9wTYhui/kwJ2gMnB
         L3yPj7cgrwYoZzgVPIY8k4QeZN0B6q8nVoYwZMFUyo1dOlfxRk5zhJf9+y1OIl75SS9u
         6Wmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TIaOcjadSpBzzJCMnARKl1ZXAgu2yuZpBTm/4wzkXqs=;
        b=hKweLVe/6WJrjvTX7NYHa3dis86Eo8+6ydxNF5+k8wR7HDJoOtfi9UISUnhQxSzbQc
         pezu3xQZ3czTIkCSNPtuL/DX3RP1z8RuCxSvUVjYFuow04s2DBS5+5gbDviExsjvUAOl
         iGLMxVJLZJGOAQF9QDFNzU2rG/oy30MCi0O6hCQWCVL021mLAnJ+KKJZOz3jp+S80huk
         PfRN+WuqzTQMaeXDqgq0vA4X+PG9wkiuXTXU7pg4+MbQJk52vjF4hnsxlzp6/GYUKzrw
         rSgRRWnCkmxFeXqaKpuKhjxZkaahKE63DIGPB2YRKYXYLflMSvIvq0grcbpKoN4SC3+N
         YoLQ==
X-Gm-Message-State: AOAM533BtJH+0J3+MdMV7IMr2/gT5gLFc/D8kFQabWf9yu0uN95cEcAI
        XrckeIczjHb9tWSNmfLPfX76Ce/t83Zismj0TfbPIA==
X-Google-Smtp-Source: ABdhPJx9CBWtac4HspbzcTYOQ1TnC76W0LcibcCfR7hsLxW0NwuUWBBzvVZcKgqQObAoTPTG+lZGt0bHLSm2KXN0I7Q=
X-Received: by 2002:a05:620a:1351:: with SMTP id c17mr21197159qkl.350.1613499315616;
 Tue, 16 Feb 2021 10:15:15 -0800 (PST)
MIME-Version: 1.0
References: <0000000000000be4d705bb68dfa7@google.com> <20210216172817.GA14978@arm.com>
 <CAHmME9q2-wbRmE-VgSoW5fxjGQ9kkafYH-X5gSVvgWESo5rm4Q@mail.gmail.com>
 <CAHmME9ob9g-pcsKU2=n2SOzjNwyGh9+dL-WGpQn4Da+DD4dPzA@mail.gmail.com> <20210216180143.GB14978@arm.com>
In-Reply-To: <20210216180143.GB14978@arm.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Tue, 16 Feb 2021 19:15:04 +0100
Message-ID: <CACT4Y+ZH4ViZix7qyPPXtcgaanimm8CmSu1J8qhqpEedxC=fmQ@mail.gmail.com>
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

On Tue, Feb 16, 2021 at 7:01 PM Catalin Marinas <catalin.marinas@arm.com> wrote:
>
> On Tue, Feb 16, 2021 at 06:50:20PM +0100, Jason A. Donenfeld wrote:
> > On Tue, Feb 16, 2021 at 6:46 PM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> > > On Tue, Feb 16, 2021 at 6:28 PM Catalin Marinas <catalin.marinas@arm.com> wrote:
> > > > >  hlist_add_head include/linux/list.h:883 [inline]
> > > > >  enqueue_timer+0x18/0xc0 kernel/time/timer.c:581
> > > > >  mod_timer+0x14/0x20 kernel/time/timer.c:1106
> > > > >  mod_peer_timer drivers/net/wireguard/timers.c:37 [inline]
> > > > >  wg_timers_any_authenticated_packet_traversal+0x68/0x90 drivers/net/wireguard/timers.c:215
> > >
> > > The line of hlist_add_head that it's hitting is:
> > >
> > > static inline void hlist_add_head(struct hlist_node *n, struct hlist_head *h)
> > > {
> > >        struct hlist_node *first = h->first;
> > >        WRITE_ONCE(n->next, first);
> > >        if (first)
> > >
> > > So that means it's the dereferencing of h that's a problem. That comes from:
> > >
> > > static void enqueue_timer(struct timer_base *base, struct timer_list *timer,
> > >                          unsigned int idx, unsigned long bucket_expiry)
> > > {
> > >
> > >        hlist_add_head(&timer->entry, base->vectors + idx);
> > >
> > > That means it concerns base->vectors + idx, not the timer_list object
> > > that wireguard manages. That's confusing. Could that imply that the
> > > bug is in freeing a previous timer without removing it from the timer
> > > lists, so that it winds up being in base->vectors?
>
> Good point, it's indeed likely that the timer list is messed up already,
> just an unlucky encounter in the wireguard code.
>
> > Digging around on syzkaller, it looks like there's a similar bug on
> > jbd2, concerning iptunnels's allocation:
> >
> > https://syzkaller.appspot.com/text?tag=CrashReport&x=13afb19cd00000
> [...]
> > It might not actually be a wireguard bug?
>
> I wonder whether syzbot reported similar issues with
> CONFIG_KASAN_SW_TAGS. It shouldn't be that different from the HW_TAGS
> but at least we can rule out qemu bugs with the MTE emulation.

+Eric
