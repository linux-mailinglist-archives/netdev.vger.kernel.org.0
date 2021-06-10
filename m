Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E281C3A2406
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 07:33:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229910AbhFJFez (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 01:34:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229634AbhFJFeh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 01:34:37 -0400
Received: from mail-qv1-xf2e.google.com (mail-qv1-xf2e.google.com [IPv6:2607:f8b0:4864:20::f2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 867C2C061574
        for <netdev@vger.kernel.org>; Wed,  9 Jun 2021 22:32:38 -0700 (PDT)
Received: by mail-qv1-xf2e.google.com with SMTP id w9so14086085qvi.13
        for <netdev@vger.kernel.org>; Wed, 09 Jun 2021 22:32:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OaVwnGtK9jh2uHt5Ipx2vrWPn+KDUOXrS2y79saIzrk=;
        b=LVuckSqOTYzxTsUyz/Dn8mquXY7TuARv2fApO1OjzaIq/krnrR5d5ShV+lUflmO6Fz
         sSGKHXNWk/tgIIIHDNg+pGfzKn7Ij6Zvcuw47GW8BrKJG1Pwv/sW2vav62DwI37IgXoh
         6CDEJwoa3NhF5YygebCPdY/XS9lc9Qax0HWp5bhaOBYgSmfN9pehgzm+Niu7t8fS7ioW
         HNf0bjXiJcDigUzABktmGUNYqmhaPmJt91XrVmsJJan64o6ItFsbHqRGu/2doopvFRuN
         4pghcbCmmzTM30tSHsmXGlf293hIE0belEUweoRZkaLT9l7XbckAnVFMsZTl56EwNiCK
         9LoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OaVwnGtK9jh2uHt5Ipx2vrWPn+KDUOXrS2y79saIzrk=;
        b=n9FplYonYxjtTpWPPSQ3Q6j6Xtajf6P+vMqhfHRNhqV063LFK7pl/vfwF+f6ibNZUm
         rpHpd1iqnPW6Zh4YD4Vnrt50RE10xH8UlVeL/MNpOJPAxFAs1r8dkHM0oRXgwqrpxQLX
         5uyaEgrKEJvJPP3HcgfKKv+GjFFEMXrmlHuoenc4Xd6TFmmzaZFzitCQHkjeqQIz73+u
         GB3T5gt3G/70JCa6ryqPYVWLBe2W28QRDtfGJ1aVC0QOPZsx69VC/y6XUatgF+GkVsEx
         ndtYSN6EFb6r+rHu9h3VfmCuLoB5ucj7TnLIS2wW9BugMNJ5XS1NvI7S58s18aMMWJ7u
         icAg==
X-Gm-Message-State: AOAM533md4UeFYVro3b1AtiSjU18SVLSFkrvqt4dBU5Ki2fui+wQ7Ef0
        rhmtEiBTZP+tm/csyxzJMxxo7duxrAIbW/+hBU+suQ==
X-Google-Smtp-Source: ABdhPJwu7pmXAMs2V9ZXOoDK5dq+cT/fCHwSY6uePqbHFnmbXsUP9knMcgVtIw6TjYPoFfcTLio3a7Cw5RC0WPxmb2I=
X-Received: by 2002:a0c:d610:: with SMTP id c16mr3488166qvj.13.1623303156474;
 Wed, 09 Jun 2021 22:32:36 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000c2987605be907e41@google.com> <20210602212726.7-1-fuzzybritches0@gmail.com>
 <YLhd8BL3HGItbXmx@kroah.com> <87609-531187-curtm@phaethon>
 <6a392b66-6f26-4532-d25f-6b09770ce366@fb.com> <CAADnVQKexxZQw0yK_7rmFOdaYabaFpi2EmF6RGs5bXvFHtUQaA@mail.gmail.com>
 <CACT4Y+b=si6NCx=nRHKm_pziXnVMmLo-eSuRajsxmx5+Hy_ycg@mail.gmail.com>
 <202106091119.84A88B6FE7@keescook> <752cb1ad-a0b1-92b7-4c49-bbb42fdecdbe@fb.com>
In-Reply-To: <752cb1ad-a0b1-92b7-4c49-bbb42fdecdbe@fb.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Thu, 10 Jun 2021 07:32:24 +0200
Message-ID: <CACT4Y+a592rxFmNgJgk2zwqBE8EqW1ey9SjF_-U3z6gt3Yc=oA@mail.gmail.com>
Subject: Re: [PATCH v4] bpf: core: fix shift-out-of-bounds in ___bpf_prog_run
To:     Yonghong Song <yhs@fb.com>
Cc:     Kees Cook <keescook@chromium.org>,
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
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 10, 2021 at 1:40 AM Yonghong Song <yhs@fb.com> wrote:
> On 6/9/21 11:20 AM, Kees Cook wrote:
> > On Mon, Jun 07, 2021 at 09:38:43AM +0200, 'Dmitry Vyukov' via Clang Built Linux wrote:
> >> On Sat, Jun 5, 2021 at 9:10 PM Alexei Starovoitov
> >> <alexei.starovoitov@gmail.com> wrote:
> >>> On Sat, Jun 5, 2021 at 10:55 AM Yonghong Song <yhs@fb.com> wrote:
> >>>> On 6/5/21 8:01 AM, Kurt Manucredo wrote:
> >>>>> Syzbot detects a shift-out-of-bounds in ___bpf_prog_run()
> >>>>> kernel/bpf/core.c:1414:2.
> >>>>
> >>>> This is not enough. We need more information on why this happens
> >>>> so we can judge whether the patch indeed fixed the issue.
> >>>>
> >>>>>
> >>>>> I propose: In adjust_scalar_min_max_vals() move boundary check up to avoid
> >>>>> missing them and return with error when detected.
> >>>>>
> >>>>> Reported-and-tested-by: syzbot+bed360704c521841c85d@syzkaller.appspotmail.com
> >>>>> Signed-off-by: Kurt Manucredo <fuzzybritches0@gmail.com>
> >>>>> ---
> >>>>>
> >>>>> https://syzkaller.appspot.com/bug?id=edb51be4c9a320186328893287bb30d5eed09231
> >>>>>
> >>>>> Changelog:
> >>>>> ----------
> >>>>> v4 - Fix shift-out-of-bounds in adjust_scalar_min_max_vals.
> >>>>>        Fix commit message.
> >>>>> v3 - Make it clearer what the fix is for.
> >>>>> v2 - Fix shift-out-of-bounds in ___bpf_prog_run() by adding boundary
> >>>>>        check in check_alu_op() in verifier.c.
> >>>>> v1 - Fix shift-out-of-bounds in ___bpf_prog_run() by adding boundary
> >>>>>        check in ___bpf_prog_run().
> >>>>>
> >>>>> thanks
> >>>>>
> >>>>> kind regards
> >>>>>
> >>>>> Kurt
> >>>>>
> >>>>>    kernel/bpf/verifier.c | 30 +++++++++---------------------
> >>>>>    1 file changed, 9 insertions(+), 21 deletions(-)
> >>>>>
> >>>>> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> >>>>> index 94ba5163d4c5..ed0eecf20de5 100644
> >>>>> --- a/kernel/bpf/verifier.c
> >>>>> +++ b/kernel/bpf/verifier.c
> >>>>> @@ -7510,6 +7510,15 @@ static int adjust_scalar_min_max_vals(struct bpf_verifier_env *env,
> >>>>>        u32_min_val = src_reg.u32_min_value;
> >>>>>        u32_max_val = src_reg.u32_max_value;
> >>>>>
> >>>>> +     if ((opcode == BPF_LSH || opcode == BPF_RSH || opcode == BPF_ARSH) &&
> >>>>> +                     umax_val >= insn_bitness) {
> >>>>> +             /* Shifts greater than 31 or 63 are undefined.
> >>>>> +              * This includes shifts by a negative number.
> >>>>> +              */
> >>>>> +             verbose(env, "invalid shift %lld\n", umax_val);
> >>>>> +             return -EINVAL;
> >>>>> +     }
> >>>>
> >>>> I think your fix is good. I would like to move after
> >>>
> >>> I suspect such change will break valid programs that do shift by register.
> >>>
> >>>> the following code though:
> >>>>
> >>>>           if (!src_known &&
> >>>>               opcode != BPF_ADD && opcode != BPF_SUB && opcode != BPF_AND) {
> >>>>                   __mark_reg_unknown(env, dst_reg);
> >>>>                   return 0;
> >>>>           }
> >>>>
> >>>>> +
> >>>>>        if (alu32) {
> >>>>>                src_known = tnum_subreg_is_const(src_reg.var_off);
> >>>>>                if ((src_known &&
> >>>>> @@ -7592,39 +7601,18 @@ static int adjust_scalar_min_max_vals(struct bpf_verifier_env *env,
> >>>>>                scalar_min_max_xor(dst_reg, &src_reg);
> >>>>>                break;
> >>>>>        case BPF_LSH:
> >>>>> -             if (umax_val >= insn_bitness) {
> >>>>> -                     /* Shifts greater than 31 or 63 are undefined.
> >>>>> -                      * This includes shifts by a negative number.
> >>>>> -                      */
> >>>>> -                     mark_reg_unknown(env, regs, insn->dst_reg);
> >>>>> -                     break;
> >>>>> -             }
> >>>>
> >>>> I think this is what happens. For the above case, we simply
> >>>> marks the dst reg as unknown and didn't fail verification.
> >>>> So later on at runtime, the shift optimization will have wrong
> >>>> shift value (> 31/64). Please correct me if this is not right
> >>>> analysis. As I mentioned in the early please write detailed
> >>>> analysis in commit log.
> >>>
> >>> The large shift is not wrong. It's just undefined.
> >>> syzbot has to ignore such cases.
> >>
> >> Hi Alexei,
> >>
> >> The report is produced by KUBSAN. I thought there was an agreement on
> >> cleaning up KUBSAN reports from the kernel (the subset enabled on
> >> syzbot at least).
> >> What exactly cases should KUBSAN ignore?
> >> +linux-hardening/kasan-dev for KUBSAN false positive
> >
> > Can check_shl_overflow() be used at all? Best to just make things
> > readable and compiler-happy, whatever the implementation. :)
>
> This is not a compile issue. If the shift amount is a constant,
> compiler should have warned and user should fix the warning.
>
> This is because user code has
> something like
>      a << s;
> where s is a unknown variable and
> verifier just marked the result of a << s as unknown value.
> Verifier may not reject the code depending on how a << s result
> is used.
>
> If bpf program writer uses check_shl_overflow() or some kind
> of checking for shift value and won't do shifting if the
> shifting may cause an undefined result, there should not
> be any kubsan warning.

I guess the main question: what should happen if a bpf program writer
does _not_ use compiler nor check_shl_overflow()?
