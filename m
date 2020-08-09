Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45E6E24001B
	for <lists+netdev@lfdr.de>; Sun,  9 Aug 2020 23:11:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726479AbgHIVLC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Aug 2020 17:11:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726323AbgHIVLC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Aug 2020 17:11:02 -0400
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com [IPv6:2607:f8b0:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E98EC061756
        for <netdev@vger.kernel.org>; Sun,  9 Aug 2020 14:11:02 -0700 (PDT)
Received: by mail-ot1-x344.google.com with SMTP id k12so5839233otr.1
        for <netdev@vger.kernel.org>; Sun, 09 Aug 2020 14:11:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc;
        bh=tnbivf37AkNCQVT58esYATu/95sstFUYuxjUNu7Ss5U=;
        b=if9LZNmswMqNSDNjRnAe7BzYcfdfdPfY/UTCTGO12pXE7jGXG0Uzt19NXvm3Yvepgb
         f5eQ2rA5KFZ0oogvymGDpeyhd5rxsdfBQd68KZFCMCypqlsXjcpUHT5ZweduRTJ8luZh
         oQKTsvLRVcOL1o5ln2oIhUfENZIGoGx6PC02TluupCEryEVGeLmMu5Y2IuZLJTh0xE6n
         DAIdvbgtpieuQU+JPSwX1NFuKU3l1eBDVk51PaDSyriw5tE/9zRZo7HgzRZqO8Pgxqlq
         EAqvGMXEGtBHErbJ7nKkKsF+ic+Lul+8m615B9nKI2d5hfBglqrzyCCVvA+56MvV+epm
         FckQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc;
        bh=tnbivf37AkNCQVT58esYATu/95sstFUYuxjUNu7Ss5U=;
        b=MIhLc7q6UIEo3e93esqV75fPDmkDWfnWcuq+QMD8RCy2LEviSKcwIbzBh5KO08zng6
         EDKDEJlA/eZ4W+nIUEShEJAuMpDXhhLN6/Bn3UcCVNdB84clyVzXDdHucZg9XRmzU8FM
         OSvfrwRftYRM3zIRiwBw4hH2NVM2IvLDNMuMLs82JilZ4VMvRsjmNvt6IlU5Mml4p3OG
         ENkHHD0OGHwHvcNx0Ki0Cz/SAVNoIWOcbILz3A2BrD81MHO7JUsk7psWY+Ghr4kGRrZq
         k7BDT4UgCXQ8Ei/YruCeKaotjwSzLKGprov04p0AXZ34sBIuPNiaoFth7ZOiYJQK9BnW
         s5NA==
X-Gm-Message-State: AOAM530es2RSHtQxZmJz061ItUNMWDXbdPJZTg2HXT3j8gva5qxWYRlV
        1uVom5zwjli+3VoWwG52r7k9nwsgWAFDgSnTxog=
X-Google-Smtp-Source: ABdhPJzRMCqq3OmeLtberub962oQKz7v0XINoJbh9rCsKirHKQjvTxNp0kGipwDlGxazv9XEW3ZYnXMWZCXfY0nJfBw=
X-Received: by 2002:a9d:7997:: with SMTP id h23mr22401916otm.28.1597007461607;
 Sun, 09 Aug 2020 14:11:01 -0700 (PDT)
MIME-Version: 1.0
References: <CA+icZUVnsmf1kXPYFYufStQ_MxnLuxL+EWfDS2wQy1VbAEMwkA@mail.gmail.com>
In-Reply-To: <CA+icZUVnsmf1kXPYFYufStQ_MxnLuxL+EWfDS2wQy1VbAEMwkA@mail.gmail.com>
Reply-To: sedat.dilek@gmail.com
From:   Sedat Dilek <sedat.dilek@gmail.com>
Date:   Sun, 9 Aug 2020 23:10:50 +0200
Message-ID: <CA+icZUVfauaXK0aEDkPPvurM_1M6h_T_iiM9gXixdg_-qustgQ@mail.gmail.com>
Subject: Re: [DRAFT PATCH] random32: make prandom_u32() output unpredictable
To:     George Spelvin <lkml@sdf.org>
Cc:     Amit Klein <aksecurity@gmail.com>, Willy Tarreau <w@1wt.eu>,
        Eric Dumazet <edumazet@google.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Andy Lutomirski <luto@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

+ CC:netdev

( Just FYI: Build and boot on bare metal. )

- Sedat -

On Sun, Aug 9, 2020 at 11:01 PM Sedat Dilek <sedat.dilek@gmail.com> wrote:
>
> Hi George,
>
> I have tried your patch on top of Linux v5.8 with...
>
> commit f227e3ec3b5c ("random32: update the net random state on
> interrupt and activity")
>
> ...reverted.
> This was a bit tricky - what was your base?
>
> Applied the typo fix from Randy - will a v2 follow?
>
> Why DRAFT and not RFC?
>
> Please drop the CC:stable - it's a DRAFT.
>
> Other Linux stable like linux-5.7.y include...
>
> commit c0842fbc1b18c7a044e6ff3e8fa78bfa822c7d1a
> random32: move the pseudo-random 32-bit definitions to prandom.h
>
> commit 585524081ecdcde1c719e63916c514866d898217
> random: random.h should include archrandom.h, not the other way around
>
> ...linux-5.8.y stable will follow.
>
> Isn't the move to prandom.h making your patch easier to apply?
>
> In a second build I applied the snippet from Willy.
>
> What do you mean by...?
>
> [ quote ]
> I wonder if, on general principles, it would be better to use a more
> SipHash style mixing in of the sample:
>     m = get_cycles();
>     v3 ^= m;
>     SIPROUND(v0, v1, v2, v3);
>     SIPROUND(v0, v1, v2, v3);
>     v0 ^= m;
>
> Not sure if it's worth the extra register (and associated spill/fill).
> [ /quote ]
>
> Have you a snippet for testing?
>
> Thanks.
>
> Regards,
> - Sedat -
