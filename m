Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56D771E4B3A
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 18:58:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390809AbgE0Q6b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 12:58:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387845AbgE0Q6a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 12:58:30 -0400
Received: from mail-lf1-x141.google.com (mail-lf1-x141.google.com [IPv6:2a00:1450:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94673C03E97D
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 09:58:30 -0700 (PDT)
Received: by mail-lf1-x141.google.com with SMTP id z206so11246428lfc.6
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 09:58:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=w9MKpYnxpfJKots1bXz63ocLI6CVWW9hUZPLoxfB1jA=;
        b=XbQ3fvEB53fGXaf1DIDucrqXiY4jPiTPl8B15j/JPNw1Dd7hmIpnx6rwj+JIuR1EeM
         RdMZf0uGNc6ju67CbI53gAFdngrriOqJ41v7MwQ/vFkHv7Fv1oSl8vf3gDsgONjgAFSd
         +3GEAfJiukAv8A6H/aB17gshkZIxjR+QeXqQW6Op5pmoNOKcCKNQUw8Q+RYR+z6BM3PQ
         YfBKELnCuA1iFvaSEb6uB7tv48dFqpIBGFjkcNna/mJjGa+loiceOow8Ul3ZxvlhuGMj
         tAIGCXc98rZgBPjF/9Lw3aq4Bh6o2rDoNPUJZCsSmal5vsnHtZ/Lhaj/QzIuOv8mD+iz
         OyMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=w9MKpYnxpfJKots1bXz63ocLI6CVWW9hUZPLoxfB1jA=;
        b=pvxlTuNvPPAEedV6MXXNfYKTZyxX3ar+7tvPS0vLpMvNlyDGtb+MkAAw7XNJMBr/rP
         ZICWkJXTIvAcGqnHBnM5OHuUPtxqEMb5AhApvy3fufFHVomjqunvqD+dYuRZyILQozbj
         tWeSLmDd3tgCY/4g59prd09y+AhTsaOHK9a2vf05nM84K5jgP0ZMkf3Moa7SgBIvRby3
         dLMWgSLHuzYCC89u9/zGACRC9YpKT96ROhA15RwYq35AtZxsHMKiow2V/v1+gTWP5D1i
         VC1zAISpOi4GOJGBSnQw/RJoO+OTKFNmo3jU8r0YqnXTNdVmvnSi31JteGhttbPhTRLG
         1WqA==
X-Gm-Message-State: AOAM531LRt0RibnV//1LkqXdYYXOkKGmrW56lByDcfh7x+1fadXSFb+p
        cQo0/h4unGjke+dICN4KYsw+bU71pJt7j98OJ8c=
X-Google-Smtp-Source: ABdhPJxuC2Hqqr2g4hHXOF0o43ocVX4W49dSEXD0h7t42vZQpMfNKUt6xHFp6MlelHDHrOeWDVTxck03nNt6V+Odw9g=
X-Received: by 2002:ac2:53a6:: with SMTP id j6mr3558749lfh.73.1590598709022;
 Wed, 27 May 2020 09:58:29 -0700 (PDT)
MIME-Version: 1.0
References: <CAG_fn=W55uuPbpvjzCphgiMbmhnFmmWY=KcOGvmUv14_JOGc5g@mail.gmail.com>
 <20181213115936.GG21324@unicorn.suse.cz> <20181213122004.GH21324@unicorn.suse.cz>
 <CAG_fn=VSEw2NvrE=GE4f4H6CAD-6BjUQvz3W06nLmF8tg7CfBA@mail.gmail.com>
 <def5d586-3a8c-01b7-c6dd-bc284336b76e@iogearbox.net> <7bf9e46f-93a1-b6ff-7e75-53ace009c77c@iogearbox.net>
 <CAG_fn=WrWLC7v8btiZfRSSj1Oj6WymLmwWq4x1Ss3rQ4P0cOOA@mail.gmail.com> <CAG_fn=W_BCW5OvP2tayQLcrTuiXCXDBYDYSJ7U6xHftDFyLu3A@mail.gmail.com>
In-Reply-To: <CAG_fn=W_BCW5OvP2tayQLcrTuiXCXDBYDYSJ7U6xHftDFyLu3A@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 27 May 2020 09:58:17 -0700
Message-ID: <CAADnVQ+GFuDkx+xW42wL60=W4bz5C8Q-pNNP+f2txy_hY-TeUA@mail.gmail.com>
Subject: Re: Self-XORing BPF registers is undefined behavior
To:     Alexander Potapenko <glider@google.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Michal Kubecek <mkubecek@suse.cz>,
        Alexei Starovoitov <ast@kernel.org>,
        Dmitriy Vyukov <dvyukov@google.com>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 27, 2020 at 8:52 AM Alexander Potapenko <glider@google.com> wrote:
>
> This basically means that BPF's output register was uninitialized when
> ___bpf_prog_run() returned.
>
> When I replace the lines initializing registers A and X in net/core/filter.c:
>
> -               *new_insn++ = BPF_ALU32_REG(BPF_XOR, BPF_REG_A, BPF_REG_A);
> -               *new_insn++ = BPF_ALU32_REG(BPF_XOR, BPF_REG_X, BPF_REG_X);
>
> with
>
> +               *new_insn++ = BPF_MOV32_IMM(BPF_REG_A, 0);
> +               *new_insn++ = BPF_MOV32_IMM(BPF_REG_X, 0);
>
> , the bug goes away, therefore I think it's being caused by XORing the
> initially uninitialized registers with themselves.
>
> kernel/bpf/core.c:1408, where the uninitialized value was stored to
> memory, points to the "ALU(ADD,  +)" macro in ___bpf_prog_run().
> But the debug info seems to be incorrect here: if I comment this line
> out and unroll the macro manually, KMSAN points to "ALU(SUB,  -)".
> Most certainly it's actually one of the XOR instruction declarations.
>
> Do you think it makes sense to use the UB-proof BPF_MOV32_IMM
> instructions to initialize the registers?

I think it's better for UBsan to get smarter about xor-ing.
