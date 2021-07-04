Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2665B3BAD5D
	for <lists+netdev@lfdr.de>; Sun,  4 Jul 2021 16:19:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229614AbhGDOWJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Jul 2021 10:22:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229557AbhGDOWI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Jul 2021 10:22:08 -0400
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34E5BC061574;
        Sun,  4 Jul 2021 07:19:33 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id t17so27688529lfq.0;
        Sun, 04 Jul 2021 07:19:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PCBSufByfcBuxu42Hhqym+iec4NUyoJhudjS+EtmQwg=;
        b=u3nQeImVAAMU+HfMXD35lPs3EhIw5RnxiB21JdnTFyYPoqsJdT4EKcsOuyV7l+mm25
         Q2hDSGsgg7+AJP1Sbpjb2wtoBqGKVVasr6miQATotazQKSvdsktxuCwdciTLZazyZ8mm
         alnlF8d0MqLkSoxi+W9eU9HD6sQNap8LG5jgmyiRgMl3bmTPTWxQnRoJvTK5RffYSJpi
         6Bb+DpVoZYDoLXGDFo6sbjSxqTdiA+ZvbVcuxs8WkzZkNYF/cT2tA4neKEFquTVIb0QI
         3tS5FDo9dqUB+0aaSMaN7E7XPaPkosxfAyk3XS6lZ+Tb8Bf1ymypKvD2wAnKhKDTZ9lW
         hUdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PCBSufByfcBuxu42Hhqym+iec4NUyoJhudjS+EtmQwg=;
        b=O7YCBsXJHJJz3hU40oz/PzKXTuknp2cV7wIqM1dkKZFpUMYoRiBRtdzLpRd/9HJXah
         Mw3kjyzqub1ltV0q/PzXwWPxwBrgQ9HxlVMKl9iaFX6CX3QHqI70vIHZOOfzgbFhf9qq
         8o1/6k6PsbX1e8qIEBO7EUh3IFB+QGKWaBcXdKy+0ZEDEjb8QwM6/J+3yFVh1rwv1HGo
         y3O9rXBh72dpj4qPyaJnpa/rpnNLWCXdIw/nHzSRbLxoB7KzyrCIvQC4PAgWPI4pPEvq
         76F9EhcRTiTWz43dEqBLuWJg8RVXAhYDi2U7KADUOwOqLfbBkgk3VX8fxmILcYbNrx/V
         8Gtw==
X-Gm-Message-State: AOAM532QXtC1mluOmxThgwL5rDI7DZmd0+o55ufw3VlZz9VvHmcsEXY+
        s5UUCwcHOc7fQAAB3o1zKTIF6vOvfckepmfjl3Y=
X-Google-Smtp-Source: ABdhPJywhhhmHz2u9DiyEyyIWxkWZZALZh6PuqAYdqHoH0NAFNkOXIPL4tC+cP8datcGdfXxn/Yf5tkZnSOxibgsyo8=
X-Received: by 2002:a05:6512:3293:: with SMTP id p19mr7328076lfe.214.1625408371457;
 Sun, 04 Jul 2021 07:19:31 -0700 (PDT)
MIME-Version: 1.0
References: <20210701192044.78034-1-alexei.starovoitov@gmail.com>
 <20210701192044.78034-2-alexei.starovoitov@gmail.com> <20210702010455.3h4v5c4g7wx2aeth@kafai-mbp.dhcp.thefacebook.com>
In-Reply-To: <20210702010455.3h4v5c4g7wx2aeth@kafai-mbp.dhcp.thefacebook.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Sun, 4 Jul 2021 07:19:19 -0700
Message-ID: <CAADnVQKYGBdZJiMsxMVRX8axEbH_Uh+HekcECpiZqU2oWeWv2Q@mail.gmail.com>
Subject: Re: [PATCH v4 bpf-next 1/9] bpf: Introduce bpf timers.
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 1, 2021 at 6:05 PM Martin KaFai Lau <kafai@fb.com> wrote:
>
> On Thu, Jul 01, 2021 at 12:20:36PM -0700, Alexei Starovoitov wrote:
> [ ... ]
>
> > +BPF_CALL_3(bpf_timer_set_callback, struct bpf_timer_kern *, timer, void *, callback_fn,
> > +        struct bpf_prog *, prog)
> > +{
> > +     struct bpf_hrtimer *t;
> > +     struct bpf_prog *prev;
> > +     int ret = 0;
> > +
> > +     if (in_nmi())
> > +             return -EOPNOTSUPP;
> > +     ____bpf_spin_lock(&timer->lock); /* including irqsave */
> > +     t = timer->timer;
> > +     if (!t) {
> > +             ret = -EINVAL;
> > +             goto out;
> > +     }
> > +     if (!atomic64_read(&(t->map->usercnt))) {
> > +             /* maps with timers must be either held by user space
> > +              * or pinned in bpffs. Otherwise timer might still be
> > +              * running even when bpf prog is detached and user space
> > +              * is gone, since map_release_uref won't ever be called.
> > +              */
> > +             ret = -EPERM;
> > +             goto out;
> > +     }
> > +     prev = t->prog;
> > +     if (prev != prog) {
> > +             if (prev)
> > +                     /* Drop prev prog refcnt when swapping with new prog */
> > +                     bpf_prog_put(prev);
> > +             /* Bump prog refcnt once. Every bpf_timer_set_callback()
> > +              * can pick different callback_fn-s within the same prog.
> > +              */
> > +             bpf_prog_inc(prog);
> I think prog->aux->refcnt could be zero here when the bpf prog
> is making its final run and before the rcu grace section ended,
> so bpf_prog_inc_not_zero() should be used here.

good point.
What should be the failure mode?
Return the error from the helper and set the prog/callback to NULL?

> > +             t->prog = prog;
> > +     }
> > +     t->callback_fn = callback_fn;
> > +out:
> > +     ____bpf_spin_unlock(&timer->lock); /* including irqrestore */
> > +     return ret;
> > +}
> > +
>
> [ ... ]
>
> > @@ -5837,6 +5906,8 @@ record_func_map(struct bpf_verifier_env *env, struct bpf_call_arg_meta *meta,
> >           func_id != BPF_FUNC_map_pop_elem &&
> >           func_id != BPF_FUNC_map_peek_elem &&
> >           func_id != BPF_FUNC_for_each_map_elem &&
> > +         func_id != BPF_FUNC_timer_init &&
> > +         func_id != BPF_FUNC_timer_set_callback &&
> It seems checking the posion map_ptr_state is not needed.
> Is this change needed?

+1. Leftover from earlier versions.

> [ ... ]
>
> > @@ -12584,6 +12662,46 @@ static int do_misc_fixups(struct bpf_verifier_env *env)
> >                       continue;
> >               }
> >
> > +             if (insn->imm == BPF_FUNC_timer_set_callback) {
> > +                     /* There is no need to do:
> > +                      *     aux = &env->insn_aux_data[i + delta];
> > +                      *     if (bpf_map_ptr_poisoned(aux)) return -EINVAL;
> > +                      * for bpf_timer_set_callback(). If the same callback_fn is shared
> > +                      * by different timers in different maps the poisoned check
> > +                      * will return false positive.
> > +                      *
> > +                      * The verifier will process callback_fn as many times as necessary
> > +                      * with different maps and the register states prepared by
> > +                      * set_timer_callback_state will be accurate.
> > +                      *
> > +                      * The following use case is valid:
> > +                      *   map1 is shared by prog1, prog2, prog3.
> > +                      *   prog1 calls bpf_timer_init for some map1 elements
> > +                      *   prog2 calls bpf_timer_set_callback for some map1 elements.
> > +                      *     Those that were not bpf_timer_init-ed will return -EINVAL.
> > +                      *   prog3 calls bpf_timer_start for some map1 elements.
> > +                      *     Those that were not both bpf_timer_init-ed and
> > +                      *     bpf_timer_set_callback-ed will return -EINVAL.
> > +                      */
> > +                     struct bpf_insn ld_addrs[2] = {
> > +                             BPF_LD_IMM64(BPF_REG_3, (long)prog),
> The "prog" pointer value is used here.
>
> > +                     };
> > +
> > +                     insn_buf[0] = ld_addrs[0];
> > +                     insn_buf[1] = ld_addrs[1];
> > +                     insn_buf[2] = *insn;
> > +                     cnt = 3;
> > +
> > +                     new_prog = bpf_patch_insn_data(env, i + delta, insn_buf, cnt);
> > +                     if (!new_prog)
> > +                             return -ENOMEM;
> > +
> > +                     delta    += cnt - 1;
> > +                     env->prog = prog = new_prog;
> After bpf_patch_insn_data(), a new prog may be allocated.
> Is the above old "prog" pointer value updated accordingly?
> I could have missed something.

excellent catch. The patching of prog can go bad either here
or later if patching of some other insn happened to change prog.
I'll try to switch to dynamic prog fetching via ksym.
The timers won't work in the interpreted mode though.
But that's better trade-off than link-list of insns to patch with a prog
after all of bpf_patch_insn_data are done?
Some other way to fix this issue?
