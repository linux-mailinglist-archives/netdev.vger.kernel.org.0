Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6142B2F0EE0
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 10:17:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728401AbhAKJQw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 04:16:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728001AbhAKJQv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 04:16:51 -0500
Received: from mail-qk1-x730.google.com (mail-qk1-x730.google.com [IPv6:2607:f8b0:4864:20::730])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF669C0617A2
        for <netdev@vger.kernel.org>; Mon, 11 Jan 2021 01:16:10 -0800 (PST)
Received: by mail-qk1-x730.google.com with SMTP id d14so13964670qkc.13
        for <netdev@vger.kernel.org>; Mon, 11 Jan 2021 01:16:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fU7GH9LhkO3q58rwtJyvkvBoIzpRxN+MgLow1nbzzOs=;
        b=KV/W4TkVDv1dKMb+PQGRb4AZX/A7K1VuhTBpyuxT4wHjHJisP09LZdYiFhCWYD/dOR
         3OItl1/pOUZ5jeEvWZcXecEiqlQRDeWr/DcBV13JEckh8dzP0n74k5acinDTieaf/4y/
         4kNFVyX4Ps/idfQgk9zZF4/ndeXz3r6k5lT3NYqWC1lRsL0/B1I6Wiop5IAmeZ9eiemp
         xWd6z+xtdazwE+03DJOp+jhaJPsZxxLIBvvkDSYIwjoVGlmWqLdlDC0/vovsapxVKSwm
         QHzpEzP2J01MTb6wm6kn7HKM3ihdG6WMVzuhvn/jkq30a4vcaXVgdwM2zIsajjB3/jqY
         V+LQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fU7GH9LhkO3q58rwtJyvkvBoIzpRxN+MgLow1nbzzOs=;
        b=S0ECl+ub+CP7rDnFwPH39evoo2TJlk06J5BgP1TicHxhLM/x2YYdEg74KOD+b/UATS
         Stb7OeWDdjz5sKl5/HyGtjzvC3pkcFsg1uG2RA3+Jod9Kj1uLHLWNC5DPwGMmWsPCchq
         OLxAH05Hwrcrs0j/+eKrvvaBI3o9hWa6spsm98h3AAvoAjQ0hNILVzvfLjI+WAJK5KnI
         LJ9TKVCtjrsEAIIFzkKdktwekc3eBd0dZ8pgLnEUkSZGngPHdzVA3M7HT9xeMNBcpcju
         kLMWGGhuEHcdKKtDg57ikfJbzOIQHthFonyyRTvzfxw1wLodiHMQXrSVF11y8FXMJHhb
         LRYg==
X-Gm-Message-State: AOAM533WkZ37QshTRaabQsOBwxN6elCX+WzXmtScPt/sgoSH+qW/hvJ0
        j1An+5NU8dFde0b9H1MCHvly2ClVHm7Cjgie2ZBnUg==
X-Google-Smtp-Source: ABdhPJwbbIjmwetHH0GCBp0TCjbgD7zj06OWKV6/f1Ysv0jMf+ZhAh+8kUwh/YJDM+J6eaRv2DGqE8kYHyTUtYEm4DY=
X-Received: by 2002:a05:620a:713:: with SMTP id 19mr15861120qkc.424.1610356569698;
 Mon, 11 Jan 2021 01:16:09 -0800 (PST)
MIME-Version: 1.0
References: <000000000000588c2c05aa156b2b@google.com> <00000000000087569605b8928ce3@google.com>
In-Reply-To: <00000000000087569605b8928ce3@google.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Mon, 11 Jan 2021 10:15:58 +0100
Message-ID: <CACT4Y+a3Xe11dAkRAAewXQ7b=KzK1pk36Arwq=vCR7R-KQy9DQ@mail.gmail.com>
Subject: Re: kernel BUG at mm/vmalloc.c:LINE! (2)
To:     syzbot <syzbot+5f326d255ca648131f87@syzkaller.appspotmail.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>, andrii@kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Borislav Petkov <bp@alien8.de>, bpf <bpf@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        John Fastabend <john.fastabend@gmail.com>,
        jonathan.lemon@gmail.com, Martin KaFai Lau <kafai@fb.com>,
        KP Singh <kpsingh@chromium.org>,
        Jakub Kicinski <kuba@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>, Andy Lutomirski <luto@kernel.org>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        marekx.majtyka@intel.com, Ingo Molnar <mingo@kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Song Liu <songliubraving@fb.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Yonghong Song <yhs@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 10, 2021 at 10:34 PM syzbot
<syzbot+5f326d255ca648131f87@syzkaller.appspotmail.com> wrote:
>
> syzbot suspects this issue was fixed by commit:
>
> commit 537cf4e3cc2f6cc9088dcd6162de573f603adc29
> Author: Magnus Karlsson <magnus.karlsson@intel.com>
> Date:   Fri Nov 20 11:53:39 2020 +0000
>
>     xsk: Fix umem cleanup bug at socket destruct
>
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=139f3dfb500000
> start commit:   e87d24fc Merge branch 'net-iucv-fixes-2020-11-09'
> git tree:       net
> kernel config:  https://syzkaller.appspot.com/x/.config?x=61033507391c77ff
> dashboard link: https://syzkaller.appspot.com/bug?extid=5f326d255ca648131f87
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10d10006500000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=126c9eaa500000
>
> If the result looks correct, please mark the issue as fixed by replying with:
>
> #syz fix: xsk: Fix umem cleanup bug at socket destruct
>
> For information about bisection process see: https://goo.gl/tpsmEJ#bisection

FTR, the bisection log looks clean, but this does not look like the
fix for this. The reproducer does not destroy sockets.
