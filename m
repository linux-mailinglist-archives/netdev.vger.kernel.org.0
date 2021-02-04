Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 880D930FC09
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 19:57:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239452AbhBDS4I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 13:56:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239294AbhBDSmW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Feb 2021 13:42:22 -0500
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 561A7C061793
        for <netdev@vger.kernel.org>; Thu,  4 Feb 2021 10:41:32 -0800 (PST)
Received: by mail-lj1-x22e.google.com with SMTP id l12so4669509ljc.3
        for <netdev@vger.kernel.org>; Thu, 04 Feb 2021 10:41:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QilnL1GiLc35zL0JKgGqLLH0jCvxrl7AURnizvwxOrk=;
        b=wwOS3lN7TXu7QWeoGhYz2RQIaOHUMrxwlkR7ONEgKZc8tcuOjeXZTXB1WKjKgAsbTt
         yBmSE3VnOWAKWOMUea3DJjb2qXnmzvGek24oz8Rn6MMVgsK6wQrdn+irVG6eFfiwAFAq
         /d6esWbvjJAsIQ26Ihjbz7XJe2at9o+eKRRE8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QilnL1GiLc35zL0JKgGqLLH0jCvxrl7AURnizvwxOrk=;
        b=B333uBVcMj6vUYQpL5aN1t8zoo/STuujU+54woQ+KxAFTxBSs8l6FbjKrS12Wz/U0N
         lu/mm13/guRRzmFGSc2VWhYvV1XtksBJliCDjNIYYrVSjLjJ1Q+IAP/lDyq4FbIAQbbK
         QvVTTE8iZvFYT9P3UBDLMWezM4LqvW3lzvNLgMG9mzo8W7U0uLL91DmZZJD6WOt1KBRc
         TlFc0XboPPDEkomG2K04mFs1mrLy6q/BXCtOyljyH/WsHZPUwW9FhwDhDwlPQt/DpMVM
         3asdi78OQftL1aV8cLW/xYKIqcFKOjsKqmnatuTUjh0+fPfMVc2NrSfRBSmTnHRCRj7m
         I/rw==
X-Gm-Message-State: AOAM5333pg/DzaHr/VJtiRhQ8lGkToq+sdf6QtcRuHI/7r8ofHS8ZuLM
        /7FRXT/NqN/4XRTarZ9waQ2gb1KD+qKOFMPqIhnd3g==
X-Google-Smtp-Source: ABdhPJwJtrhYEdPaQdR6fHW3cU2NP6bOoOiL2TtDHuAX1Y9bu5c2RTiAw480hYJajzznm79yfeZHPAMVBc9ok0h1jMo=
X-Received: by 2002:a2e:9b57:: with SMTP id o23mr427754ljj.314.1612464090601;
 Thu, 04 Feb 2021 10:41:30 -0800 (PST)
MIME-Version: 1.0
References: <CABWYdi3HjduhY-nQXzy2ezGbiMB1Vk9cnhW2pMypUa+P1OjtzQ@mail.gmail.com>
 <CABWYdi27baYc3ShHcZExmmXVmxOQXo9sGO+iFhfZLq78k8iaAg@mail.gmail.com>
 <20210203214448.2703930e@oasis.local.home> <20210204030948.dmsmwyw6fu5kzgey@treble>
In-Reply-To: <20210204030948.dmsmwyw6fu5kzgey@treble>
From:   Ivan Babrou <ivan@cloudflare.com>
Date:   Thu, 4 Feb 2021 10:41:18 -0800
Message-ID: <CABWYdi15x=-2qenWSdX_ONSha_Pz7GFJrx8axN6CJS5cWxTTSg@mail.gmail.com>
Subject: Re: BUG: KASAN: stack-out-of-bounds in unwind_next_frame+0x1df5/0x2650
To:     Josh Poimboeuf <jpoimboe@redhat.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        kernel-team <kernel-team@cloudflare.com>,
        Ignat Korchagin <ignat@cloudflare.com>,
        Hailong liu <liu.hailong6@zte.com.cn>,
        Andrey Ryabinin <aryabinin@virtuozzo.com>,
        Alexander Potapenko <glider@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Miroslav Benes <mbenes@suse.cz>,
        Julien Thierry <jthierry@redhat.com>,
        Jiri Slaby <jirislaby@kernel.org>, kasan-dev@googlegroups.com,
        linux-mm@kvack.org, linux-kernel <linux-kernel@vger.kernel.org>,
        Alasdair Kergon <agk@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com,
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
        bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 3, 2021 at 7:10 PM Josh Poimboeuf <jpoimboe@redhat.com> wrote:

> This line gives a big clue:
>
>   [160676.608966][    C4] RIP: 0010:0xffffffffc17d814c
>
> That address, without a function name, most likely means that it was
> running in some generated code (mostly likely BPF) when it got
> interrupted.

We do have eBPF/XDP in our environment.

> Right now, the ORC unwinder tries to fall back to frame pointers when it
> encounters generated code:
>
>         orc = orc_find(state->signal ? state->ip : state->ip - 1);
>         if (!orc)
>                 /*
>                  * As a fallback, try to assume this code uses a frame pointer.
>                  * This is useful for generated code, like BPF, which ORC
>                  * doesn't know about.  This is just a guess, so the rest of
>                  * the unwind is no longer considered reliable.
>                  */
>                 orc = &orc_fp_entry;
>                 state->error = true;
>         }
>
> Because the ORC unwinder is guessing from that point onward, it's
> possible for it to read the KASAN stack redzone, if the generated code
> hasn't set up frame pointers.  So the best fix may be for the unwinder
> to just always bypass KASAN when reading the stack.
>
> The unwinder has a mechanism for detecting and warning about
> out-of-bounds, and KASAN is short-circuiting that.
>
> This should hopefully get rid of *all* the KASAN unwinder warnings, both
> crypto and networking.

It definitely worked on my dm-crypt case, and I've tried it without
your previous AVX related patch. I will apply it to our tree and
deploy to the staging KASAN environment to see how it fares with
respect to networking stacks. Feel free to ping me if I don't get back
to you with the results on Monday.

Thanks for looking into this!
