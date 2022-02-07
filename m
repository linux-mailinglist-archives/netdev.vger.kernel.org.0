Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0741B4ACAD3
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 22:01:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232326AbiBGVBm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 16:01:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231667AbiBGVBl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 16:01:41 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61EBFC06173B;
        Mon,  7 Feb 2022 13:01:41 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id y9so6529477pjf.1;
        Mon, 07 Feb 2022 13:01:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FwnKbpTkC/zdPmCdqrahzy52SJ9rfemmtNQ6qp1un1k=;
        b=mdBf/hKJ/7B7hDsVbKCWNpdxhMkuPUxF+0PCUNUeV4B7/F0tSXEYtNLmofwufiy7PF
         33C0zLeSB9ip82NjcKe5b1K+LgbtzGt5ubSD3HtaVAgQWZXb9eCelUPgZo0tNeCcouzO
         RQ748JIssLc69N49BLL6f88Ob9HZCEhToJOrFQdxPUlpAD4rySIQ7JwxmsOoYigL7BP0
         YF25ZKf41yAUP7rj+PW/q/iI2ZXn4C5q4GgH1HUUF9Yjx7zTBYNdANKIxcInlwmvDcVo
         ubTnKttmQg1Exb5/EzkpePJSqpT1AANZxtpl5ligRT14obtT866fOsKHNfXrwGpoQF71
         RA2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FwnKbpTkC/zdPmCdqrahzy52SJ9rfemmtNQ6qp1un1k=;
        b=wwyYQ68IuZlo5uasQKyKsMpsno3So6nQknmhVFlfEwicGLLmi6RsNOV32frrCMGxZF
         /rTDzQv+JqDxmAjXF/E6V02QYR8xBY8DcdNUi8Uqjg/F7JIocY6QzVbnAEf6lnt5T/48
         j45e9VvM1psNnz/k+tT9jkEXJUDP2hPxQvAGXX5kPyghtujls1Bh0kh0ahxpZgMcikt7
         PXtUBDQQ1YSNDxqrpZNhDP8gbMEnxmBW26DIyqj6OyuXKsPp1GlZQP7y2KDkhVDng0aw
         oUT8qzl6A6FVTrwLaufaH7GYDjDoT8zK99TmpbVpx8p8UmtfGaVSM12BJpxwtIXBzUD/
         ywRg==
X-Gm-Message-State: AOAM532MeyiAbcukS6wI4Fe+HpJt+caXpdqubUdMbcISNly9cQC77Nyh
        kUA4VkcVSbudyijY+4N/aymtnqhI317316uHaOI=
X-Google-Smtp-Source: ABdhPJzzqnbfte/UsO4CxN7j1V9c+CNHc+B9dLja6d189I3omGBCC6NXzrh0VaXli8IsejwWZzNN9DCp76ionhJwrFQ=
X-Received: by 2002:a17:902:ced1:: with SMTP id d17mr1249891plg.78.1644267700768;
 Mon, 07 Feb 2022 13:01:40 -0800 (PST)
MIME-Version: 1.0
References: <20220202135333.190761-1-jolsa@kernel.org> <20220202135333.190761-3-jolsa@kernel.org>
 <CAEf4Bzbrj01RJq7ArAo-kX-+8rPx9j5OH1OvGHxVJxiq8rn3FA@mail.gmail.com>
In-Reply-To: <CAEf4Bzbrj01RJq7ArAo-kX-+8rPx9j5OH1OvGHxVJxiq8rn3FA@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Mon, 7 Feb 2022 13:01:29 -0800
Message-ID: <CAADnVQ+qRY6ykHUumAhFo4gH8JaurcEkMwC_LOqmrRiqAE7GoA@mail.gmail.com>
Subject: Re: [PATCH 2/8] bpf: Add bpf_get_func_ip kprobe helper for fprobe link
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Jiri Olsa <jolsa@redhat.com>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Jiri Olsa <olsajiri@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 7, 2022 at 10:59 AM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Wed, Feb 2, 2022 at 5:53 AM Jiri Olsa <jolsa@redhat.com> wrote:
> >
> > Adding support to call get_func_ip_fprobe helper from kprobe
> > programs attached by fprobe link.
> >
> > Also adding support to inline it, because it's single load
> > instruction.
> >
> > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > ---
> >  kernel/bpf/verifier.c    | 19 ++++++++++++++++++-
> >  kernel/trace/bpf_trace.c | 16 +++++++++++++++-
> >  2 files changed, 33 insertions(+), 2 deletions(-)
> >
> > diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> > index 1ae41d0cf96c..a745ded00635 100644
> > --- a/kernel/bpf/verifier.c
> > +++ b/kernel/bpf/verifier.c
> > @@ -13625,7 +13625,7 @@ static int do_misc_fixups(struct bpf_verifier_env *env)
> >                         continue;
> >                 }
> >
> > -               /* Implement bpf_get_func_ip inline. */
> > +               /* Implement tracing bpf_get_func_ip inline. */
> >                 if (prog_type == BPF_PROG_TYPE_TRACING &&
> >                     insn->imm == BPF_FUNC_get_func_ip) {
> >                         /* Load IP address from ctx - 16 */
> > @@ -13640,6 +13640,23 @@ static int do_misc_fixups(struct bpf_verifier_env *env)
> >                         continue;
> >                 }
> >
> > +               /* Implement kprobe/fprobe bpf_get_func_ip inline. */
> > +               if (prog_type == BPF_PROG_TYPE_KPROBE &&
> > +                   eatype == BPF_TRACE_FPROBE &&
> > +                   insn->imm == BPF_FUNC_get_func_ip) {
> > +                       /* Load IP address from ctx (struct pt_regs) ip */
> > +                       insn_buf[0] = BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1,
> > +                                                 offsetof(struct pt_regs, ip));
>
> Isn't this architecture-specific? I'm starting to dislike this
> inlining whole more and more. It's just a complication in verifier
> without clear real-world benefits. We are clearly prematurely
> optimizing here. In practice you'll just call bpf_get_func_ip() once
> and that's it. Function call overhead will be negligible compare to
> other *userful* work you'll be doing in your BPF program.

We should be doing inlining when we can.
Every bit of performance matters.
