Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA13F4AFD0F
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 20:16:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232526AbiBITOu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 14:14:50 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:39020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232118AbiBITOq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 14:14:46 -0500
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02D07C00F639;
        Wed,  9 Feb 2022 11:14:40 -0800 (PST)
Received: by mail-wm1-x333.google.com with SMTP id r131so2099212wma.1;
        Wed, 09 Feb 2022 11:14:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=53AqFhwrg5sf39zbHRlZ7vehLvu2fcixViHXJDSalrM=;
        b=jsWd78AlHH12GCKj2sM1lGyk7uPOeN2Hbv9zgbd6Jh90rE/VED+SCZQ7MvUbRIpQGQ
         toDPAuiewlaGeRaYS8OpYAyIo1BRtg9ObuFi66RmkKYrzvRv3f5QIyZwjYyPuwXxwpOO
         wLXL+aKLyYGe6lUnUuzrFLCypTXYJlj0JcfbJAaiM0DDX+gySER0xQduBFYIxFFt19pQ
         cLtKzBzncDDqs9mQM+qiR/kcl5dWTIxgfOXz2Be2VG6ssBsjvkqgsjGlwBXcoLt5Pie0
         /c9bNrxQltcrKUb24wOJFNrN/p6/GrgN6uBaqTcJAynAOoi2goC8YCjpHmekvKJj0rbE
         fsMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=53AqFhwrg5sf39zbHRlZ7vehLvu2fcixViHXJDSalrM=;
        b=cqxw5GPMUzs6sCcP49x0HD1VhkIdJr4qPNYRpbPZTMwoKHLcmsqIPGMGfnBe8LNBjD
         zeht2ctojXPSmLxb0f5dB47I/T+N6DUVIvj3y7Gzp/xQAXKOruZwMD/HRPzXfjL5ZzNz
         zFzEWtI/P8N/fQ+htotRx3tBCCYBkF+CzRHy3kmNZABRk14CTAl8+9q7vdc7LdcabzCd
         7R6uEUl2Z/+A4SBREwVzk75zKCl8/KgGhYyQW+wU+46Z79//8/5oD6QvOB01pg2AFP7I
         oCAjDJ4AbaUq7sgk8/Ta4mp3dXPTqE3JyJ8pd7oMIl1SN/kWuXHzEB7+MCTMowITLVID
         pNRQ==
X-Gm-Message-State: AOAM530Wha2/VNScR42hkXWxMQlbETLFBBjE/mIh9cU3ay0++1HatCZ2
        vvKL75JbG8+Q2vkhm43KK2Y=
X-Google-Smtp-Source: ABdhPJwhmM58FyRk4hJCT5mMbz2jGwH5dhixXieg1tw4oT6/MTcNt7zs5Z0qZofSAHx3/kkf3YsMcw==
X-Received: by 2002:a05:600c:2944:: with SMTP id n4mr3393140wmd.190.1644434071348;
        Wed, 09 Feb 2022 11:14:31 -0800 (PST)
Received: from krava ([83.240.63.12])
        by smtp.gmail.com with ESMTPSA id l10sm19669970wry.79.2022.02.09.11.14.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Feb 2022 11:14:30 -0800 (PST)
Date:   Wed, 9 Feb 2022 20:14:28 +0100
From:   Jiri Olsa <olsajiri@gmail.com>
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
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 2/8] bpf: Add bpf_get_func_ip kprobe helper for fprobe
 link
Message-ID: <YgQSlAIdjyC/FOgy@krava>
References: <20220202135333.190761-1-jolsa@kernel.org>
 <20220202135333.190761-3-jolsa@kernel.org>
 <CAEf4Bzbrj01RJq7ArAo-kX-+8rPx9j5OH1OvGHxVJxiq8rn3FA@mail.gmail.com>
 <YgPXVXJnPKQ7lOi9@krava>
 <CAEf4BzYxtoE8Gu62oNSdVxvsv2K_5CPSdGS3Qd0Jgaegvw7sfw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzYxtoE8Gu62oNSdVxvsv2K_5CPSdGS3Qd0Jgaegvw7sfw@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 09, 2022 at 08:05:05AM -0800, Andrii Nakryiko wrote:
> On Wed, Feb 9, 2022 at 7:01 AM Jiri Olsa <olsajiri@gmail.com> wrote:
> >
> > On Mon, Feb 07, 2022 at 10:59:18AM -0800, Andrii Nakryiko wrote:
> > > On Wed, Feb 2, 2022 at 5:53 AM Jiri Olsa <jolsa@redhat.com> wrote:
> > > >
> > > > Adding support to call get_func_ip_fprobe helper from kprobe
> > > > programs attached by fprobe link.
> > > >
> > > > Also adding support to inline it, because it's single load
> > > > instruction.
> > > >
> > > > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > > > ---
> > > >  kernel/bpf/verifier.c    | 19 ++++++++++++++++++-
> > > >  kernel/trace/bpf_trace.c | 16 +++++++++++++++-
> > > >  2 files changed, 33 insertions(+), 2 deletions(-)
> > > >
> > > > diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> > > > index 1ae41d0cf96c..a745ded00635 100644
> > > > --- a/kernel/bpf/verifier.c
> > > > +++ b/kernel/bpf/verifier.c
> > > > @@ -13625,7 +13625,7 @@ static int do_misc_fixups(struct bpf_verifier_env *env)
> > > >                         continue;
> > > >                 }
> > > >
> > > > -               /* Implement bpf_get_func_ip inline. */
> > > > +               /* Implement tracing bpf_get_func_ip inline. */
> > > >                 if (prog_type == BPF_PROG_TYPE_TRACING &&
> > > >                     insn->imm == BPF_FUNC_get_func_ip) {
> > > >                         /* Load IP address from ctx - 16 */
> > > > @@ -13640,6 +13640,23 @@ static int do_misc_fixups(struct bpf_verifier_env *env)
> > > >                         continue;
> > > >                 }
> > > >
> > > > +               /* Implement kprobe/fprobe bpf_get_func_ip inline. */
> > > > +               if (prog_type == BPF_PROG_TYPE_KPROBE &&
> > > > +                   eatype == BPF_TRACE_FPROBE &&
> > > > +                   insn->imm == BPF_FUNC_get_func_ip) {
> > > > +                       /* Load IP address from ctx (struct pt_regs) ip */
> > > > +                       insn_buf[0] = BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1,
> > > > +                                                 offsetof(struct pt_regs, ip));
> > >
> > > Isn't this architecture-specific? I'm starting to dislike this
> >
> > ugh, it is.. I'm not sure we want #ifdef CONFIG_X86 in here,
> > or some arch_* specific function?
> 
> 
> So not inlining it isn't even considered? this function will be called
> once or at most a few times per BPF program invocation. Anyone calling
> it in a tight loop is going to use it very-very suboptimally (and even
> then useful program logic will dominate). There is no point in
> inlining it.

I agree that given its usage pattern there won't be too much gain,
on the other hand it's simple verifier code changing call/load/ret
into simple load, so I thought why not.. also there are just few
helpers we can inline so easily

but yea.. I can't think of any sane usage of this helper that inlining
would matter for.. which doesn't mean there isn't one ;-)

jirka

> 
> >
> > jirka
> >
> > > inlining whole more and more. It's just a complication in verifier
> > > without clear real-world benefits. We are clearly prematurely
> > > optimizing here. In practice you'll just call bpf_get_func_ip() once
> > > and that's it. Function call overhead will be negligible compare to
> > > other *userful* work you'll be doing in your BPF program.
> > >
> > >
> > > > +
> > > > +                       new_prog = bpf_patch_insn_data(env, i + delta, insn_buf, 1);
> > > > +                       if (!new_prog)
> > > > +                               return -ENOMEM;
> > > > +
> > > > +                       env->prog = prog = new_prog;
> > > > +                       insn      = new_prog->insnsi + i + delta;
> > > > +                       continue;
> > > > +               }
> > > > +
> > > >  patch_call_imm:
> > > >                 fn = env->ops->get_func_proto(insn->imm, env->prog);
> > > >                 /* all functions that have prototype and verifier allowed
> > > > diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
> > > > index a2024ba32a20..28e59e31e3db 100644
> > > > --- a/kernel/trace/bpf_trace.c
> > > > +++ b/kernel/trace/bpf_trace.c
> > > > @@ -1036,6 +1036,19 @@ static const struct bpf_func_proto bpf_get_func_ip_proto_kprobe = {
> > > >         .arg1_type      = ARG_PTR_TO_CTX,
> > > >  };
> > > >
> > > > +BPF_CALL_1(bpf_get_func_ip_fprobe, struct pt_regs *, regs)
> > > > +{
> > > > +       /* This helper call is inlined by verifier. */
> > > > +       return regs->ip;
> > > > +}
> > > > +
> > > > +static const struct bpf_func_proto bpf_get_func_ip_proto_fprobe = {
> > > > +       .func           = bpf_get_func_ip_fprobe,
> > > > +       .gpl_only       = false,
> > > > +       .ret_type       = RET_INTEGER,
> > > > +       .arg1_type      = ARG_PTR_TO_CTX,
> > > > +};
> > > > +
> > > >  BPF_CALL_1(bpf_get_attach_cookie_trace, void *, ctx)
> > > >  {
> > > >         struct bpf_trace_run_ctx *run_ctx;
> > > > @@ -1279,7 +1292,8 @@ kprobe_prog_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
> > > >                 return &bpf_override_return_proto;
> > > >  #endif
> > > >         case BPF_FUNC_get_func_ip:
> > > > -               return &bpf_get_func_ip_proto_kprobe;
> > > > +               return prog->expected_attach_type == BPF_TRACE_FPROBE ?
> > > > +                       &bpf_get_func_ip_proto_fprobe : &bpf_get_func_ip_proto_kprobe;
> > > >         case BPF_FUNC_get_attach_cookie:
> > > >                 return &bpf_get_attach_cookie_proto_trace;
> > > >         default:
> > > > --
> > > > 2.34.1
> > > >
