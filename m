Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E9225E71A9
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 03:59:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232118AbiIWB74 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 21:59:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231854AbiIWB7y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 21:59:54 -0400
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E58E814F3
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 18:59:52 -0700 (PDT)
Received: by mail-yb1-xb2d.google.com with SMTP id e187so15273737ybh.10
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 18:59:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=DyJ5vyws2ZLZ8hWhmSaGs9IbqDPq0Ui75fNEM2wPyVg=;
        b=Tvy5mUlG6Xj1zHxJPqw3ORpCL/8KJ2GGzqeZ2yNK8nQd9JEgRhQ+l0lBNNV3IVv1p6
         ADQ01SZR2XB42VxSebniM7pmw1znrLJFXKxmyi0QVedornAU8hjxlAJNJUw2/s+3NeyI
         b74dkXaWxeIChX6LNTqk/V9YF9F4ayjwUyEIWB+nJsbKaETgycHwHyVamfmH75oKfb4e
         F9gLa5uePGc/0bipWuI7P244rZKVLqMtpPQniChSpfPpSi9LCEBFLDW1TL1Iwn0Jz0zM
         SaLrphn3JUDLRu6Xy2hRr00oqTW7Dc+ghUw09Wa4Shw87LHfas0FV9W5+GoJdYPtQvk5
         5mLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=DyJ5vyws2ZLZ8hWhmSaGs9IbqDPq0Ui75fNEM2wPyVg=;
        b=IZecpqvfDHBQV+MxGafFdXw8DIF+asC4/0Ei1xHMJD9lSrzYozzQNauVasQkogpQ/W
         ghyBnvmIuhTS9F0DajQOjQsUNIpCi9o9aK4X1xzTzIT4Mf4ekAWMSYknth3SkCUvENh4
         nAvl3EhiVPZydR/YIMBEjBD1PX3jLlzj10EIISl+d36h8JOEQMuFseaCZ63ROOkZ6qa1
         mWEAR9C5Ja8jLv2ZQWDB5qh9OgQIZxkn/W5Z/5Rslx2gD+WpgwsGvs9+p2m0OL28npuM
         2yl9yfrIgNUuYpLavh//Lx4Gs/omrOiA3ElD8j0FDRKm/ytgH5Q2Iea6Tdwc6G17aJY+
         3kdw==
X-Gm-Message-State: ACrzQf2OYnBgSht+nE73wece7AcLhQpihwndCHSnKNjz1+yJ4lt5Gw9K
        XeiLvFuyRWPozy9jUylw3NIR2H6z02gmihE5SnmlVg==
X-Google-Smtp-Source: AMsMyM6F+LBgR9yjQn2ljA3KeuTKOpSxCXc+A5EDlhcoy5W2yqxDd2OedKUidF2dASw2HBrzSsVS8WeuJO3Uur7SK2Y=
X-Received: by 2002:a25:c704:0:b0:6b0:3b4d:2d32 with SMTP id
 w4-20020a25c704000000b006b03b4d2d32mr7235707ybe.2.1663898391278; Thu, 22 Sep
 2022 18:59:51 -0700 (PDT)
MIME-Version: 1.0
References: <20220922225616.3054840-1-kafai@fb.com> <20220922225642.3058176-1-kafai@fb.com>
 <CAADnVQK4fVZ0KdWkV7MfP_F3As7cme46SoR30YU0bk0zAfpOrA@mail.gmail.com> <99e23c92-b1dc-db45-73f7-c210eb1debc8@linux.dev>
In-Reply-To: <99e23c92-b1dc-db45-73f7-c210eb1debc8@linux.dev>
From:   Hao Luo <haoluo@google.com>
Date:   Thu, 22 Sep 2022 18:59:40 -0700
Message-ID: <CA+khW7hsDgDRevwLsataPMDUMq-R5jaYfKZwxgm+EaocZjxxGA@mail.gmail.com>
Subject: Re: [PATCH bpf-next 4/5] bpf: Stop bpf_setsockopt(TCP_CONGESTION) in
 init ops to recur itself
To:     Martin KaFai Lau <martin.lau@linux.dev>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 22, 2022 at 6:12 PM Martin KaFai Lau <martin.lau@linux.dev> wrote:
>
> On 9/22/22 5:12 PM, Alexei Starovoitov wrote:
[...]
> > Instead of adding 4 bytes for enum in patch 3
> > (which will be 8 bytes due to alignment)
> > and abusing bpf_cookie here
> > (which struct_ops bpf prog might eventually read and be surprised
> > to find sk pointer in there)
> > how about adding 'struct task_struct *saved_current' as another arg
> > to bpf_tramp_run_ctx ?
> > Always store the current task in there in prog_entry_struct_ops
> > and then compare it here in this specialized bpf_init_ops_setsockopt?
> >
> > Or maybe always check in enter_prog_struct_ops:
> > if (container_of(current->bpf_ctx, struct bpf_tramp_run_ctx,
> > run_ctx)->saved_current == current) // goto out since recursion?
> > it will prevent issues in case we don't know about and will
> > address the good recursion case as explained in patch 1?
> > I'm assuming 2nd ssthresh runs in a different task..
> > Or is it actually the same task?
>
> The 2nd ssthresh() should run in the same task but different sk.  The
> first ssthresh(sk[1]) was run in_task() context and then got
> interrupted.  The softirq then handles the rcv path which just happens
> to also call ssthresh(sk[2]) in the unlikely pkt-loss case. It is like
> ssthresh(sk[1]) => softirq => ssthresh(sk[2]).
>
> The tcp-cc ops can recur but cannot recur on the same sk because it
> requires to hold the sk lock, so the patch remembers what was the
> previous sk to ensure it does not recur on the same sk.  Then it needs
> to peek into the previous run ctx which may not always be
> bpf_trump_run_ctx.  eg. a cg bpf prog (with bpf_cg_run_ctx) can call
> bpf_setsockopt(TCP_CONGESTION, "a_bpf_tcp_cc") which then will call the
> a_bpf_tcp_cc->init().  It needs a bpf_run_ctx_type so it can safely peek
> the previous bpf_run_ctx.
>
> Since struct_ops is the only one that needs to peek into the previous
> run_ctx (through tramp_run_ctx->saved_run_ctx),  instead of adding 4
> bytes to the bpf_run_ctx, one idea just came to my mind is to use one
> bit in the tramp_run_ctx->saved_run_ctx pointer itsef.  Something like
> this if it reuses the bpf_cookie (probably missed some int/ptr type
> casting):
>
> #define BPF_RUN_CTX_STRUCT_OPS_BIT 1UL
>
> u64 notrace __bpf_prog_enter_struct_ops(struct bpf_prog *prog,
>                                      struct bpf_tramp_run_ctx *run_ctx)
>          __acquires(RCU)
> {
>         rcu_read_lock();
>         migrate_disable();
>
>         run_ctx->saved_run_ctx = bpf_set_run_ctx((&run_ctx->run_ctx) |
>                                         BPF_RUN_CTX_STRUCT_OPS_BIT);
>
>          return bpf_prog_start_time();
> }
>
> BPF_CALL_5(bpf_init_ops_setsockopt, struct sock *, sk, int, level,
>             int, optname, char *, optval, int, optlen)
> {
>         /* ... */
>         if (unlikely((run_ctx->saved_run_ctx &
>                         BPF_RUN_CTX_STRUCT_OPS_BIT) && ...) {
>                 /* ... */
>                 if (bpf_cookie == (uintptr_t)sk)
>                         return -EBUSY;
>         }
>
> }

If I understand correctly, the purpose of adding a field in run_ctx is
to tell the enclosing type from a generic bpf_run_ctx.

In the following lines:

> >> +       if (unlikely(run_ctx->saved_run_ctx &&
> >> +                    run_ctx->saved_run_ctx->type == BPF_RUN_CTX_TYPE_STRUCT_OPS)) {
> >> +               saved_run_ctx = (struct bpf_tramp_run_ctx *)run_ctx->saved_run_ctx;

the enclosing type of run_ctx->saved_run_ctx is a bpf_tramp_run_ctx,
so we can safely type cast it and further check sk.

The best way I can come up with is also what Martin thinks, maybe
encoding the type information in the lower bits of the saved_run_ctx
field.

Hao
