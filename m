Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA3182B2AA1
	for <lists+netdev@lfdr.de>; Sat, 14 Nov 2020 02:49:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726143AbgKNBsq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 20:48:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725981AbgKNBsp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Nov 2020 20:48:45 -0500
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8101EC0613D1;
        Fri, 13 Nov 2020 17:48:45 -0800 (PST)
Received: by mail-lj1-x230.google.com with SMTP id b17so13175259ljf.12;
        Fri, 13 Nov 2020 17:48:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UL5vLJE2EwlBtAIId0ThIAszpCR5aszIqn1/WM6ZNYY=;
        b=LLnal3+NOH3+DBWzveyOVYxEP5yBlG5fh/ftVANIRqcj+uL1Qav15WnlyIBsliwcwK
         vs0BFlZpwsG2ZPWVuH8/F+2XuytE+zyU2qTyRvJBNTzIDPMlSos9bell1T7sJsghtn0l
         6Vpm3Z05s8hnAW3IDLyxUbRuG1mBV1TFmCaIRrlUEb2QguycMVUeTWFV1gTaMbpfdUzp
         GjN+ulcG6r3E24+FBYA3Ak6Ovw0lmFsWHppf2E/t1rKugEXFZ3B7dQlesMcu2yxHM44e
         sOEIT6WKYuB55YNVVB4r+X+3BvRiu+3qimERKCMRL+W8iX+142DQuAbzI1HbbQ0MI3o3
         tjbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UL5vLJE2EwlBtAIId0ThIAszpCR5aszIqn1/WM6ZNYY=;
        b=eTpsLvaDnASuAmpj38+l6WFSQzo5Ilg3hm17BH7mY2qeZqAImOnPhL8kbrhwvpzyFF
         H8x5v0LuD3c4V1QxJOr0fCsCA+11wvsYZ3iEOierX4GAVHR1i6tJyCL9MyKOMvoLseFB
         kAUNK6xBtcIQCIXyG4xhIR0GynG7GcdyxQ6RbMcIpZFTs+p6WceN+tOA6zfmvxwI1LwE
         7EMQIQcVxdt+X94NexYe8K2NRLW/VDsddevBuu6atXJpOBSnPxAyeUYllsTS257fWoju
         7/Sif0HGDN+nHbngXQsZioRVUmuq2fwbQnDXrMgNT7MghUKEM5tzoS5L77omz6m3IxaC
         6S3g==
X-Gm-Message-State: AOAM533TdGG2S2BTEfLKNy8oSULQBJMO0/ZDzJxEjWrNSc3vvPwcWr4+
        +JCQqSzYwqPGos3m9mWGnj+qy5flLJtmFQbu8mPxOdzkckc=
X-Google-Smtp-Source: ABdhPJxlRTojrdWVPmz75QunsqAnFdY+qdH4gJbpSfbmqBfRSu3t+XaqIoOZVxoabpyIs1q1vxyvsOzJl/PuPz5b2TE=
X-Received: by 2002:a2e:1643:: with SMTP id 3mr2205871ljw.290.1605318522985;
 Fri, 13 Nov 2020 17:48:42 -0800 (PST)
MIME-Version: 1.0
References: <20201113083852.22294-1-glin@suse.com>
In-Reply-To: <20201113083852.22294-1-glin@suse.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 13 Nov 2020 17:48:31 -0800
Message-ID: <CAADnVQ+0m3OJs6eNOyZv4v0PrB3JDxkP=xCK5sbXQpJ9sWqBjw@mail.gmail.com>
Subject: Re: [PATCH RFC] bpf, x64: allow not-converged images when
 BPF_JIT_ALWAYS_ON is set
To:     Gary Lin <glin@suse.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, andreas.taschner@suse.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 13, 2020 at 12:40 AM Gary Lin <glin@suse.com> wrote:
>
> The x64 bpf jit expects the bpf images converge within the given passes.
> However there is a corner case:
>
>   l0:     ldh [4]
>   l1:     jeq #0x537d, l2, l40
>   l2:     ld [0]
>   l3:     jeq #0xfa163e0d, l4, l40
>   l4:     ldh [12]
>   l5:     ldx #0xe
>   l6:     jeq #0x86dd, l41, l7
>   l7:     jeq #0x800, l8, l41
>   l8:     ld [x+16]
>   l9:     ja 41
>
>     [... repeated ja 41 ]
>
>   l40:    ja 41
>   l41:    ret #0
>   l42:    ld #len
>   l43:    ret a
>
> The bpf program contains 32 "ja 41" and do_jit() only removes one "ja 41"
> right before "l41:  ret #0" for offset==0 in each pass, so
> bpf_int_jit_compile() needs to run do_jit() at least 32 times to
> eliminate those JMP instructions. Since the current max number of passes
> is 20, the bpf program couldn't converge within 20 passes and got rejected
> when BPF_JIT_ALWAYS_ON is set even though it's legit as a classic socket
> filter.
>
> A not-converged image may be not optimal but at least the bpf
> instructions are translated into x64 machine code. Maybe we could just
> issue a warning instead so that the program is still loaded and the user
> is also notified.

Non-convergence is not about being optimal. It's about correctness.
If size is different it likely means that at least one jump has the
wrong offset.

Bumping from 20 to 64 also won't solve it.
There could be a case where 64 isn't enough either.
One of the test_bpf.ko tests can hit any limit, iirc.

Also we've seen a case where JIT might never converge.
The iteration N can have size 40, iteration N+1 size 38, iteration N+2 size 40
and keep oscillating like this.

I think the fix could be is to avoid optimality in size when pass
number is getting large.
Like after pass > 10 BPF_JA could always use 32-bit offset regardless
of actual addrs[i + insn->off] - addrs[i]; difference.
There could be other solutions too.
