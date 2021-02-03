Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C08A030E167
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 18:50:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232109AbhBCRr6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 12:47:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231263AbhBCRry (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Feb 2021 12:47:54 -0500
Received: from mail-lj1-x235.google.com (mail-lj1-x235.google.com [IPv6:2a00:1450:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84CD8C061786
        for <netdev@vger.kernel.org>; Wed,  3 Feb 2021 09:47:08 -0800 (PST)
Received: by mail-lj1-x235.google.com with SMTP id v15so26327248ljk.13
        for <netdev@vger.kernel.org>; Wed, 03 Feb 2021 09:47:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0Sd7lpuzzYzAe84omnrWYz0GYPR/9/jZDwcpOZKoCos=;
        b=rAHCkrSCSvsO3i942zxFGAk0xb59fBgQ9tJbci20Qr8DGAfbkfFqUS0o0lV+OAJMgn
         JOSqWMGKZzFwQMVac947lcIMwL6Tc5F0tVcjRhUHs9tzA6STcT7JKCU3wT2IirVckFFg
         v7A4WB7VsSJXr/haxcAPud+QTaGWwMHaudZig=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0Sd7lpuzzYzAe84omnrWYz0GYPR/9/jZDwcpOZKoCos=;
        b=nJb/A+eK1QQUNKPkcd5vyNoSRiXTvRuMrVy3sd+9cIecEeXcFEXOtp6s/bQpCvdrse
         A82UywwoM/3sIpqJaaOCAarvjyTwXK8QDRPAwrPckuFmTmChEKNM6i8NJrB1v/udjjak
         B1iSLa//3Oz2iYXUm7joyum/lSaNz8DhbUp9GQaQbh6EOeI8n45HkQoHQhcnHt9d6iW5
         E9sDd0iuO4nTQib5IkeeBWDK7dDELH1XAYFzWOWpkPONM+tP50/twOtekXbW5LNnHUFD
         7E3mM3pAqUTsBmfAPkz3IhgeYLyX10zTupeQKjpyCSnmm8ltmqk/iSjwQc/b2pU4MdlP
         6u7w==
X-Gm-Message-State: AOAM5317S6vDAqn1axjbMq6pQWCy/EjaLn7W8iGlaw40TgLnL3gCFwJl
        tYwlqMAP/OZND9xhthXrfSGxVcOUZ2ToTsWweJBFKQ==
X-Google-Smtp-Source: ABdhPJzdVb3Jed1F5NgGdDtfAd5oNibLzyOzFOWG4eVNHu9dYMCxEE44x+nn5372HQ8P/nr1dxBBfvSeiQCWg8NBeQU=
X-Received: by 2002:a2e:9cc8:: with SMTP id g8mr2376414ljj.479.1612374426835;
 Wed, 03 Feb 2021 09:47:06 -0800 (PST)
MIME-Version: 1.0
References: <CABWYdi3HjduhY-nQXzy2ezGbiMB1Vk9cnhW2pMypUa+P1OjtzQ@mail.gmail.com>
 <CABWYdi27baYc3ShHcZExmmXVmxOQXo9sGO+iFhfZLq78k8iaAg@mail.gmail.com> <YBrTaVVfWu2R0Hgw@hirez.programming.kicks-ass.net>
In-Reply-To: <YBrTaVVfWu2R0Hgw@hirez.programming.kicks-ass.net>
From:   Ivan Babrou <ivan@cloudflare.com>
Date:   Wed, 3 Feb 2021 09:46:55 -0800
Message-ID: <CABWYdi2ephz57BA8bns3reMGjvs5m0hYp82+jBLZ6KD3Ba6zdQ@mail.gmail.com>
Subject: Re: BUG: KASAN: stack-out-of-bounds in unwind_next_frame+0x1df5/0x2650
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     kernel-team <kernel-team@cloudflare.com>,
        Ignat Korchagin <ignat@cloudflare.com>,
        Hailong liu <liu.hailong6@zte.com.cn>,
        Andrey Ryabinin <aryabinin@virtuozzo.com>,
        Alexander Potapenko <glider@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Miroslav Benes <mbenes@suse.cz>,
        Julien Thierry <jthierry@redhat.com>,
        Jiri Slaby <jirislaby@kernel.org>, kasan-dev@googlegroups.com,
        linux-mm@kvack.org, linux-kernel <linux-kernel@vger.kernel.org>,
        Alasdair Kergon <agk@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Robert Richter <rric@kernel.org>,
        "Joel Fernandes (Google)" <joel@joelfernandes.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        bpf@vger.kernel.org, Alexey Kardashevskiy <aik@ozlabs.ru>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Can you pretty please not line-wrap console output? It's unreadable.

GMail doesn't make it easy, I'll send a link to a pastebin next time.
Let me know if you'd like me to regenerate the decoded stack.

> > edfd9b7838ba5e47f19ad8466d0565aba5c59bf0 is the first bad commit
> > commit edfd9b7838ba5e47f19ad8466d0565aba5c59bf0
>
> Not sure what tree you're on, but that's not the upstream commit.

I mentioned that it's a rebased core-static_call-2020-10-12 tag and
added a link to the upstream hash right below.

> > Author: Steven Rostedt (VMware) <rostedt@goodmis.org>
> > Date:   Tue Aug 18 15:57:52 2020 +0200
> >
> >     tracepoint: Optimize using static_call()
> >
>
> There's a known issue with that patch, can you try:
>
>   http://lkml.kernel.org/r/20210202220121.435051654@goodmis.org

I've tried it on top of core-static_call-2020-10-12 tag rebased on top
of v5.9 (to make it reproducible), and the patch did not help. Do I
need to apply the whole series or something else?
