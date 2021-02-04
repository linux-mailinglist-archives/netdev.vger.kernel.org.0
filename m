Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80DD930FD65
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 20:56:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239670AbhBDTyl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 14:54:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239500AbhBDTwa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Feb 2021 14:52:30 -0500
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94B95C061788
        for <netdev@vger.kernel.org>; Thu,  4 Feb 2021 11:51:57 -0800 (PST)
Received: by mail-lf1-x130.google.com with SMTP id f1so6405622lfu.3
        for <netdev@vger.kernel.org>; Thu, 04 Feb 2021 11:51:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FToFoRW57QEfMw0vp233PBaMzzSywEYZZwEWphiSDG8=;
        b=ABi2tO0tBxJZnGfCaPaqkq/u8P+eQGwDQnVphpXksukz3TmQZt9E9TiVZy1p7uj66y
         qQEVgjjAEjFyh66Updzzpfz9STCrXpmifd8ycnk8KZx2pG0geKmzXEC5/BqnRise+H5l
         xdEH+CYmH0wGBFhNHE+1aDgoEUqbGI2T6aBYQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FToFoRW57QEfMw0vp233PBaMzzSywEYZZwEWphiSDG8=;
        b=d8JcOsayGBFnzhhD3JOKhKYaKWsxh7Ks/yqK2j2vGy6cGM8XzQWJAmhb5E2l9AStmS
         zDRr+s+f+vIiE14KOIrnHfu9SpD5Y9smFmcympZ3lI4+V1WUOXjXbJjtsqx57q7XKmEF
         EmmVIQlNRzrq+UZbKpdiL55sKEkBRelo/GhPcI0+w/8ur6sL9k4be648J0wV9wYRMkej
         dMdxYURJCelp9d32MPKMxKwOVh04bA26jCXSkEREusCy4uhqXLpfmL4WJBFmZKZMorcX
         67g26l0HBvAe2zV48NVdHCw8GpwKx5iiDxb2Jxwy7mQ7sh9tYFxEJ+a/H7wbUJrVqRm5
         jEGQ==
X-Gm-Message-State: AOAM532JkydSESl3j5vLFXynL3lVviqtowl6UQpeNO1Cms4aUTeEYdxI
        rvCrf3j+rQQ0kEuiNVXFb8Bq406fkjHlAFbu7KsEvQ==
X-Google-Smtp-Source: ABdhPJw6yc26ixa+BNP3THtxCTWaeQD524mnhSMrIKSYnAhxtWx3VpBmUou9Z3mhYHUs2DgfYkVuuxjVCVG8de8YSi0=
X-Received: by 2002:a05:6512:3904:: with SMTP id a4mr526525lfu.340.1612468315961;
 Thu, 04 Feb 2021 11:51:55 -0800 (PST)
MIME-Version: 1.0
References: <CABWYdi3HjduhY-nQXzy2ezGbiMB1Vk9cnhW2pMypUa+P1OjtzQ@mail.gmail.com>
 <CABWYdi27baYc3ShHcZExmmXVmxOQXo9sGO+iFhfZLq78k8iaAg@mail.gmail.com>
 <YBrTaVVfWu2R0Hgw@hirez.programming.kicks-ass.net> <CABWYdi2ephz57BA8bns3reMGjvs5m0hYp82+jBLZ6KD3Ba6zdQ@mail.gmail.com>
 <20210203190518.nlwghesq75enas6n@treble> <CABWYdi1ya41Ju9SsHMtRQaFQ=s8N23D3ADn6OV6iBwWM6H8=Zw@mail.gmail.com>
 <20210203232735.nw73kugja56jp4ls@treble> <CABWYdi1zd51Jb35taWeGC-dR9SChq-4ixvyKms3KOKgV0idfPg@mail.gmail.com>
 <20210204001700.ry6dpqvavcswyvy7@treble>
In-Reply-To: <20210204001700.ry6dpqvavcswyvy7@treble>
From:   Ivan Babrou <ivan@cloudflare.com>
Date:   Thu, 4 Feb 2021 11:51:44 -0800
Message-ID: <CABWYdi2GsFW9ExXAQ55tvr+K86eY15T1XFoZDDBro9hJK5Gpqg@mail.gmail.com>
Subject: Re: BUG: KASAN: stack-out-of-bounds in unwind_next_frame+0x1df5/0x2650
To:     Josh Poimboeuf <jpoimboe@redhat.com>
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

On Wed, Feb 3, 2021 at 4:17 PM Josh Poimboeuf <jpoimboe@redhat.com> wrote:
>
> On Wed, Feb 03, 2021 at 03:30:35PM -0800, Ivan Babrou wrote:
> > > > > Can you recreate with this patch, and add "unwind_debug" to the cmdline?
> > > > > It will spit out a bunch of stack data.
> > > >
> > > > Here's the three I'm building:
> > > >
> > > > * https://github.com/bobrik/linux/tree/ivan/static-call-5.9
> > > >
> > > > It contains:
> > > >
> > > > * v5.9 tag as the base
> > > > * static_call-2020-10-12 tag
> > > > * dm-crypt patches to reproduce the issue with KASAN
> > > > * x86/unwind: Add 'unwind_debug' cmdline option
> > > > * tracepoint: Fix race between tracing and removing tracepoint
> > > >
> > > > The very same issue can be reproduced on 5.10.11 with no patches,
> > > > but I'm going with 5.9, since it boils down to static call changes.
> > > >
> > > > Here's the decoded stack from the kernel with unwind debug enabled:
> > > >
> > > > * https://gist.github.com/bobrik/ed052ac0ae44c880f3170299ad4af56b
> > > >
> > > > See my first email for the exact commands that trigger this.
> > >
> > > Thanks.  Do you happen to have the original dmesg, before running it
> > > through the post-processing script?
> >
> > Yes, here it is:
> >
> > * https://gist.github.com/bobrik/8c13e6a02555fb21cadabb74cdd6f9ab
>
> It appears the unwinder is getting lost in crypto code.  No idea what
> this has to do with static calls though.  Or maybe you're seeing
> multiple issues.
>
> Does this fix it?
>
>
> diff --git a/arch/x86/crypto/Makefile b/arch/x86/crypto/Makefile
> index a31de0c6ccde..36c55341137c 100644
> --- a/arch/x86/crypto/Makefile
> +++ b/arch/x86/crypto/Makefile
> @@ -2,7 +2,14 @@
>  #
>  # x86 crypto algorithms
>
> -OBJECT_FILES_NON_STANDARD := y
> +OBJECT_FILES_NON_STANDARD_sha256-avx2-asm.o            := y
> +OBJECT_FILES_NON_STANDARD_sha512-ssse3-asm.o           := y
> +OBJECT_FILES_NON_STANDARD_sha512-avx-asm.o             := y
> +OBJECT_FILES_NON_STANDARD_sha512-avx2-asm.o            := y
> +OBJECT_FILES_NON_STANDARD_crc32c-pcl-intel-asm_64.o    := y
> +OBJECT_FILES_NON_STANDARD_camellia-aesni-avx2-asm_64.o := y
> +OBJECT_FILES_NON_STANDARD_sha1_avx2_x86_64_asm.o       := y
> +OBJECT_FILES_NON_STANDARD_sha1_ni_asm.o                        := y
>
>  obj-$(CONFIG_CRYPTO_GLUE_HELPER_X86) += glue_helper.o
>
> diff --git a/arch/x86/crypto/aesni-intel_avx-x86_64.S b/arch/x86/crypto/aesni-intel_avx-x86_64.S
> index 5fee47956f3b..59c36b88954f 100644
> --- a/arch/x86/crypto/aesni-intel_avx-x86_64.S
> +++ b/arch/x86/crypto/aesni-intel_avx-x86_64.S
> @@ -237,8 +237,8 @@ define_reg j %j
>  .noaltmacro
>  .endm
>
> -# need to push 4 registers into stack to maintain
> -STACK_OFFSET = 8*4
> +# need to push 5 registers into stack to maintain
> +STACK_OFFSET = 8*5
>
>  TMP1 =   16*0    # Temporary storage for AAD
>  TMP2 =   16*1    # Temporary storage for AES State 2 (State 1 is stored in an XMM register)
> @@ -257,6 +257,8 @@ VARIABLE_OFFSET = 16*8
>
>  .macro FUNC_SAVE
>          #the number of pushes must equal STACK_OFFSET
> +       push    %rbp
> +       mov     %rsp, %rbp
>          push    %r12
>          push    %r13
>          push    %r14
> @@ -271,12 +273,14 @@ VARIABLE_OFFSET = 16*8
>  .endm
>
>  .macro FUNC_RESTORE
> +        add     $VARIABLE_OFFSET, %rsp
>          mov     %r14, %rsp
>
>          pop     %r15
>          pop     %r14
>          pop     %r13
>          pop     %r12
> +       pop     %rbp
>  .endm
>
>  # Encryption of a single block
>

This patch seems to fix the following warning:

[  147.995699][    C0] WARNING: stack going in the wrong direction? at
glue_xts_req_128bit+0x21f/0x6f0 [glue_helper]

Or at least I cannot see it anymore when combined with your other
patch, not sure if it did the trick by itself.

This sounds like a good reason to send them both.
