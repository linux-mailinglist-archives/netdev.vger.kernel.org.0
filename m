Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3AE84AF49A
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 16:01:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235416AbiBIPBr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 10:01:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235398AbiBIPBo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 10:01:44 -0500
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11BECC05CB89;
        Wed,  9 Feb 2022 07:01:47 -0800 (PST)
Received: by mail-ej1-x636.google.com with SMTP id m4so8100830ejb.9;
        Wed, 09 Feb 2022 07:01:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=jA5A5o2lDwo4xmcSKwgw5QFTRfSshuwgrBOtx9w8wW0=;
        b=oHB9Bl14ynHGMQS/2x+Xnz+WvVHpuvm2CfVVTeaO78huvnBTFbI4omugptd0yE6Ivi
         WpMa3g4stuxYpvzidNuEnc7EkLjjk7ODv7wh+6bvBLW2gtUqSWVcF9+R6Gokb+Zq5QFB
         5g7X3vxfZeF9bXPjjSs/3BOuNOyjkr+vrM5GcI9m0OoR2xGCz9mDt1JcIrxJTnYM1eYZ
         4Kg9Prv3kha3wUxMOMPP+OAnefXjkTGNQyhE9w2wDW86ySWLhDNiguaQiE6eida4DEG4
         jvgwKXSUM3yYJb/2HESLDdTx/uIYhQNt2eP3txuXfFcRQmfFa/VnneDFROs9EiYrcvKv
         DDTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=jA5A5o2lDwo4xmcSKwgw5QFTRfSshuwgrBOtx9w8wW0=;
        b=CuOYNMu72NVC3V1k91hMoMetaHYx1UaX9IMxdRRhheyVyxPWw4KgwcGyP3p0A++klD
         SBiqOf9ylHUPK6KAyyZryIh+SXvaqZRyzLXrKfJgqa3wIMLoLF6Of8IqPQYpEWNKMnuf
         T5FawkquQ66NcJLAEJPHdSjPBEg03/3KXpCi7XsaDT2jNxpOIdlTPXV7p0843vlJct7C
         rcqtb9zJwQD/cZ7gRt3Qjd+TQ+gBYPC+DJHnOJWq6RrIX/eKmVJLp4z+zk7iEqLhUOWI
         lvVtzYAGwlI9ek1SLrUCS1M8Zvadg2lRioraFug5WpK6U2oZylCd2xSg+pgK+bZFdl2t
         4cMw==
X-Gm-Message-State: AOAM531ZxpwfVGAgoPA1vJw5a9iQfeUNsGY32lhyxTt/KZ8Xm6NkiTZP
        fEGtSUqt/J4MPS1B+RAk+I0=
X-Google-Smtp-Source: ABdhPJyJsyybi7jGr1+ecbHvUQGTWRUEGcnpPGhDFUL1sJSdbcND/VwhBv+HRJyc6t3YjijS+tFSkg==
X-Received: by 2002:a17:907:984e:: with SMTP id jj14mr2258755ejc.223.1644418905306;
        Wed, 09 Feb 2022 07:01:45 -0800 (PST)
Received: from krava ([2a00:102a:5010:3235:47fb:6193:ef68:761d])
        by smtp.gmail.com with ESMTPSA id s16sm2227842edt.91.2022.02.09.07.01.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Feb 2022 07:01:44 -0800 (PST)
Date:   Wed, 9 Feb 2022 16:01:41 +0100
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
Message-ID: <YgPXVXJnPKQ7lOi9@krava>
References: <20220202135333.190761-1-jolsa@kernel.org>
 <20220202135333.190761-3-jolsa@kernel.org>
 <CAEf4Bzbrj01RJq7ArAo-kX-+8rPx9j5OH1OvGHxVJxiq8rn3FA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4Bzbrj01RJq7ArAo-kX-+8rPx9j5OH1OvGHxVJxiq8rn3FA@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 07, 2022 at 10:59:18AM -0800, Andrii Nakryiko wrote:
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

ugh, it is.. I'm not sure we want #ifdef CONFIG_X86 in here,
or some arch_* specific function?

jirka

> inlining whole more and more. It's just a complication in verifier
> without clear real-world benefits. We are clearly prematurely
> optimizing here. In practice you'll just call bpf_get_func_ip() once
> and that's it. Function call overhead will be negligible compare to
> other *userful* work you'll be doing in your BPF program.
> 
> 
> > +
> > +                       new_prog = bpf_patch_insn_data(env, i + delta, insn_buf, 1);
> > +                       if (!new_prog)
> > +                               return -ENOMEM;
> > +
> > +                       env->prog = prog = new_prog;
> > +                       insn      = new_prog->insnsi + i + delta;
> > +                       continue;
> > +               }
> > +
> >  patch_call_imm:
> >                 fn = env->ops->get_func_proto(insn->imm, env->prog);
> >                 /* all functions that have prototype and verifier allowed
> > diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
> > index a2024ba32a20..28e59e31e3db 100644
> > --- a/kernel/trace/bpf_trace.c
> > +++ b/kernel/trace/bpf_trace.c
> > @@ -1036,6 +1036,19 @@ static const struct bpf_func_proto bpf_get_func_ip_proto_kprobe = {
> >         .arg1_type      = ARG_PTR_TO_CTX,
> >  };
> >
> > +BPF_CALL_1(bpf_get_func_ip_fprobe, struct pt_regs *, regs)
> > +{
> > +       /* This helper call is inlined by verifier. */
> > +       return regs->ip;
> > +}
> > +
> > +static const struct bpf_func_proto bpf_get_func_ip_proto_fprobe = {
> > +       .func           = bpf_get_func_ip_fprobe,
> > +       .gpl_only       = false,
> > +       .ret_type       = RET_INTEGER,
> > +       .arg1_type      = ARG_PTR_TO_CTX,
> > +};
> > +
> >  BPF_CALL_1(bpf_get_attach_cookie_trace, void *, ctx)
> >  {
> >         struct bpf_trace_run_ctx *run_ctx;
> > @@ -1279,7 +1292,8 @@ kprobe_prog_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
> >                 return &bpf_override_return_proto;
> >  #endif
> >         case BPF_FUNC_get_func_ip:
> > -               return &bpf_get_func_ip_proto_kprobe;
> > +               return prog->expected_attach_type == BPF_TRACE_FPROBE ?
> > +                       &bpf_get_func_ip_proto_fprobe : &bpf_get_func_ip_proto_kprobe;
> >         case BPF_FUNC_get_attach_cookie:
> >                 return &bpf_get_attach_cookie_proto_trace;
> >         default:
> > --
> > 2.34.1
> >
