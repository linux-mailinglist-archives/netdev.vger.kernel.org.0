Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A855C3A31BB
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 19:08:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230358AbhFJRJ6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 13:09:58 -0400
Received: from mail-pg1-f170.google.com ([209.85.215.170]:37717 "EHLO
        mail-pg1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230103AbhFJRJ5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 13:09:57 -0400
Received: by mail-pg1-f170.google.com with SMTP id t9so283508pgn.4
        for <netdev@vger.kernel.org>; Thu, 10 Jun 2021 10:07:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Tf6j48/EA7psoQT0Xa+Ykp/HBTN3iYdEAaBd6YZtNzA=;
        b=BQ5qUY2276upuseKeH0xi1cEhRtHiQIFJX1GijU6PYyl4Cthzv0BUWu+InvJdo0fyc
         nG8Pyy9LtiSpoNHDFjrgilIGZVKGi4qnfmsRJ1Ac9bjV3BFqIKua7PDRe5kS9WxvMPHF
         hGCQOxOSvU3j5mYsPkqMaz++wpX7b6l2jSRXE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Tf6j48/EA7psoQT0Xa+Ykp/HBTN3iYdEAaBd6YZtNzA=;
        b=axfG+3zEiUZ0OQBg+ReAFVxvk0KDxOOYkG3xZytfb0sTuLKPWLwZIPUCxkTSdAtR0c
         7tqyqjSVhp1XMcekpj/wQhpioXcBRIK76Kje47EZODq6exISnJKvU8lBF6nfwUtLBdHL
         nPbR23xhgxKiH8Yk0kP83fzpVYKt5OXNL/SLiqTzeS3v+A7qWb12UcqpO6fzfAIW2pkK
         G3AvPsmHD9f9Ndnz5tZa5ZbwZ5bM+1qm5MVhYnA2hzvKwOEIZrMZjrSajhYGtqt5Acw2
         vrdBO2IjOCDierJKINGqpldyx2Y8/UBXO5FWylE97i5tRPe1pKJgSMYaO+43jCUIm2Fy
         snyA==
X-Gm-Message-State: AOAM5330PntlDQr5O8HbhOHzautVOTVngDFxAi7+yh10tTQgWSCiTg4C
        pX5iHfYu3IwKozkUbU1mIA3IXQ==
X-Google-Smtp-Source: ABdhPJziHTvIoTI9UofEIJVEwXLrrUpuk8JpKcfTDvrABtGPTblS2hWs3BzfsL1cKX8HsFyFIrI8Eg==
X-Received: by 2002:a63:5d66:: with SMTP id o38mr5923418pgm.444.1623344804696;
        Thu, 10 Jun 2021 10:06:44 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id k25sm2852989pfk.33.2021.06.10.10.06.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Jun 2021 10:06:43 -0700 (PDT)
Date:   Thu, 10 Jun 2021 10:06:42 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Yonghong Song <yhs@fb.com>
Cc:     Dmitry Vyukov <dvyukov@google.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Kurt Manucredo <fuzzybritches0@gmail.com>,
        syzbot+bed360704c521841c85d@syzkaller.appspotmail.com,
        Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>, bpf <bpf@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Song Liu <songliubraving@fb.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        nathan@kernel.org, Nick Desaulniers <ndesaulniers@google.com>,
        Clang-Built-Linux ML <clang-built-linux@googlegroups.com>,
        linux-kernel-mentees@lists.linuxfoundation.org,
        Shuah Khan <skhan@linuxfoundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kernel Hardening <kernel-hardening@lists.openwall.com>,
        kasan-dev <kasan-dev@googlegroups.com>
Subject: Re: [PATCH v4] bpf: core: fix shift-out-of-bounds in ___bpf_prog_run
Message-ID: <202106101002.DF8C7EF@keescook>
References: <20210602212726.7-1-fuzzybritches0@gmail.com>
 <YLhd8BL3HGItbXmx@kroah.com>
 <87609-531187-curtm@phaethon>
 <6a392b66-6f26-4532-d25f-6b09770ce366@fb.com>
 <CAADnVQKexxZQw0yK_7rmFOdaYabaFpi2EmF6RGs5bXvFHtUQaA@mail.gmail.com>
 <CACT4Y+b=si6NCx=nRHKm_pziXnVMmLo-eSuRajsxmx5+Hy_ycg@mail.gmail.com>
 <202106091119.84A88B6FE7@keescook>
 <752cb1ad-a0b1-92b7-4c49-bbb42fdecdbe@fb.com>
 <CACT4Y+a592rxFmNgJgk2zwqBE8EqW1ey9SjF_-U3z6gt3Yc=oA@mail.gmail.com>
 <1aaa2408-94b9-a1e6-beff-7523b66fe73d@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1aaa2408-94b9-a1e6-beff-7523b66fe73d@fb.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 09, 2021 at 11:06:31PM -0700, Yonghong Song wrote:
> 
> 
> On 6/9/21 10:32 PM, Dmitry Vyukov wrote:
> > On Thu, Jun 10, 2021 at 1:40 AM Yonghong Song <yhs@fb.com> wrote:
> > > On 6/9/21 11:20 AM, Kees Cook wrote:
> > > > On Mon, Jun 07, 2021 at 09:38:43AM +0200, 'Dmitry Vyukov' via Clang Built Linux wrote:
> > > > > On Sat, Jun 5, 2021 at 9:10 PM Alexei Starovoitov
> > > > > <alexei.starovoitov@gmail.com> wrote:
> > > > > > On Sat, Jun 5, 2021 at 10:55 AM Yonghong Song <yhs@fb.com> wrote:
> > > > > > > On 6/5/21 8:01 AM, Kurt Manucredo wrote:
> > > > > > > > Syzbot detects a shift-out-of-bounds in ___bpf_prog_run()
> > > > > > > > kernel/bpf/core.c:1414:2.
> > > > > > > [...]
> > > > > > > 
> > > > > > > I think this is what happens. For the above case, we simply
> > > > > > > marks the dst reg as unknown and didn't fail verification.
> > > > > > > So later on at runtime, the shift optimization will have wrong
> > > > > > > shift value (> 31/64). Please correct me if this is not right
> > > > > > > analysis. As I mentioned in the early please write detailed
> > > > > > > analysis in commit log.
> > > > > > 
> > > > > > The large shift is not wrong. It's just undefined.
> > > > > > syzbot has to ignore such cases.
> > > > > 
> > > > > Hi Alexei,
> > > > > 
> > > > > The report is produced by KUBSAN. I thought there was an agreement on
> > > > > cleaning up KUBSAN reports from the kernel (the subset enabled on
> > > > > syzbot at least).
> > > > > What exactly cases should KUBSAN ignore?
> > > > > +linux-hardening/kasan-dev for KUBSAN false positive
> > > > 
> > > > Can check_shl_overflow() be used at all? Best to just make things
> > > > readable and compiler-happy, whatever the implementation. :)
> > > 
> > > This is not a compile issue. If the shift amount is a constant,
> > > compiler should have warned and user should fix the warning.
> > > 
> > > This is because user code has
> > > something like
> > >       a << s;
> > > where s is a unknown variable and
> > > verifier just marked the result of a << s as unknown value.
> > > Verifier may not reject the code depending on how a << s result
> > > is used.

Ah, gotcha: it's the BPF code itself that needs to catch it.

> > > If bpf program writer uses check_shl_overflow() or some kind
> > > of checking for shift value and won't do shifting if the
> > > shifting may cause an undefined result, there should not
> > > be any kubsan warning.

Right.

> > I guess the main question: what should happen if a bpf program writer
> > does _not_ use compiler nor check_shl_overflow()?

I think the BPF runtime needs to make such actions defined, instead of
doing a blind shift. It needs to check the size of the shift explicitly
when handling the shift instruction.

> If kubsan is not enabled, everything should work as expected even with
> shl overflow may cause undefined result.
> 
> if kubsan is enabled, the reported shift-out-of-bounds warning
> should be ignored. You could disasm the insn to ensure that
> there indeed exists a potential shl overflow.

Sure, but the point of UBSAN is to find and alert about undefined
behavior, so we still need to fix this.


-- 
Kees Cook
