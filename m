Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CE26529B68
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 09:49:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239194AbiEQHtl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 03:49:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240976AbiEQHtj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 03:49:39 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80A5445042;
        Tue, 17 May 2022 00:49:38 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id r30so5799973wra.13;
        Tue, 17 May 2022 00:49:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=WTGEJWoQ+KMazLH3yrW+72dqg/PgbNlHkEqCaVYjBog=;
        b=S3tFYVXPftNGoe5TTjpXm86BtSRghMjVlXdOUH2GD46ypvT1ThoEiwVTzn7hgCGpJk
         +nHv0D//dyxLGIkqyM81f3shdBf/VjFq0DIkE9F9u2HKyakKyu/E+jPaM3Z/3vskPz9z
         CGZmze3XBYZgRhfGtTfYZjC01r8YvACZ9Gb9j6c81Uy9iRMyFcqaPIcPOP5hIoGVePTW
         dFewKBjJ38Ksu+dAIpzjG2FomSnV8cEFnnXxyMf5qbB0BBSK2O/Dhl2GsowhnjvunWpW
         tx3yeC92V1dHnI4zakpxXu8sJtW4pnncqdJNE28QdzM2I2bFkORTcquXiL3OeNiVxnql
         tl1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=WTGEJWoQ+KMazLH3yrW+72dqg/PgbNlHkEqCaVYjBog=;
        b=iL6buniMRSDpD2xPO5RjodaB9AYGzA0MIVtAWmdhuj82DMnJiujvz+Yp4iGpPaUQvh
         GvsDA75HIHSq8xnY/9cRI6DGEq5J15NRKedpWHERfe6KchdTaonPFrLTMDu42G1p5/Kv
         d3p9muqnUgsy0+mfhLK1pNdDMaOnSzOvJH/estgGQAdnYEAy78nwAQrov5ToIryetXFI
         WJxr0V7Xkp9MNRV6h9SgnpBUU6GEd3KSZl+4vdFOdeBQfb0XeCZBy4wdzZorp9ChCNsX
         N4EGPYBtZOdtcUq5mfBxrgn7q3Rrg4dlXyzX+O0F4LRVckzMYHKqTasKXr2FnLSSpa5X
         9iTw==
X-Gm-Message-State: AOAM532TTcurBjozB4OYhATmKnItdFGfhqz5jOZ32RBADQBlCulnBAFY
        esacUuQCoJrX0dZ3J2JeL4A=
X-Google-Smtp-Source: ABdhPJwJinC9xx8aL+n7AyfzFJtP5Esjdc5ojELdSIdDtMIUyooc4KUFhKwdwVHaXenKsX4dnQ61gA==
X-Received: by 2002:a5d:4988:0:b0:20d:9b8:e560 with SMTP id r8-20020a5d4988000000b0020d09b8e560mr6820985wrq.33.1652773776628;
        Tue, 17 May 2022 00:49:36 -0700 (PDT)
Received: from krava ([193.85.244.190])
        by smtp.gmail.com with ESMTPSA id m26-20020a7bce1a000000b003942a244f3fsm1200543wmc.24.2022.05.17.00.49.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 May 2022 00:49:36 -0700 (PDT)
From:   Jiri Olsa <olsajiri@gmail.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
Date:   Tue, 17 May 2022 09:49:33 +0200
To:     Yonghong Song <yhs@fb.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        "Paul E. McKenney" <paulmck@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH bpf-next 1/2] cpuidle/rcu: Making arch_cpu_idle and
 rcu_idle_exit noinstr
Message-ID: <YoNTjXBDLQe9xj27@krava>
References: <20220515203653.4039075-1-jolsa@kernel.org>
 <5b4bd044-ba88-649b-9b85-e08e175691f9@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5b4bd044-ba88-649b-9b85-e08e175691f9@fb.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 16, 2022 at 07:54:37PM -0700, Yonghong Song wrote:
> 
> 
> On 5/15/22 1:36 PM, Jiri Olsa wrote:
> > Making arch_cpu_idle and rcu_idle_exit noinstr. Both functions run
> > in rcu 'not watching' context and if there's tracer attached to
> > them, which uses rcu (e.g. kprobe multi interface) it will hit RCU
> > warning like:
> > 
> >    [    3.017540] WARNING: suspicious RCU usage
> >    ...
> >    [    3.018363]  kprobe_multi_link_handler+0x68/0x1c0
> >    [    3.018364]  ? kprobe_multi_link_handler+0x3e/0x1c0
> >    [    3.018366]  ? arch_cpu_idle_dead+0x10/0x10
> >    [    3.018367]  ? arch_cpu_idle_dead+0x10/0x10
> >    [    3.018371]  fprobe_handler.part.0+0xab/0x150
> >    [    3.018374]  0xffffffffa00080c8
> >    [    3.018393]  ? arch_cpu_idle+0x5/0x10
> >    [    3.018398]  arch_cpu_idle+0x5/0x10
> >    [    3.018399]  default_idle_call+0x59/0x90
> >    [    3.018401]  do_idle+0x1c3/0x1d0
> > 
> > The call path is following:
> > 
> > default_idle_call
> >    rcu_idle_enter
> >    arch_cpu_idle
> >    rcu_idle_exit
> > 
> > The arch_cpu_idle and rcu_idle_exit are the only ones from above
> > path that are traceble and cause this problem on my setup.
> > 
> > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > ---
> >   arch/x86/kernel/process.c | 2 +-
> >   kernel/rcu/tree.c         | 2 +-
> >   2 files changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
> > index b370767f5b19..1345cb0124a6 100644
> > --- a/arch/x86/kernel/process.c
> > +++ b/arch/x86/kernel/process.c
> > @@ -720,7 +720,7 @@ void arch_cpu_idle_dead(void)
> >   /*
> >    * Called from the generic idle code.
> >    */
> > -void arch_cpu_idle(void)
> > +void noinstr arch_cpu_idle(void)
> 
> noinstr includes a lot of attributes:
> 
> #define noinstr                                                         \
>         noinline notrace __attribute((__section__(".noinstr.text")))    \
>         __no_kcsan __no_sanitize_address __no_profile __no_sanitize_coverage
> 
> should we use notrace here?

hm right, so notrace should be enough for our case (kprobe_multi)
which is based on ftrace/fprobe jump

noinstr (among other things) adds the function also the kprobes
blacklist, which will prevent standard kprobes to attach

ASAICS standard kprobes use rcu in probe path as well, like in
opt_pre_handler function

so I think we should go with noinstr

jirka

> 
> >   {
> >   	x86_idle();
> >   }
> > diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
> > index a4b8189455d5..20d529722f51 100644
> > --- a/kernel/rcu/tree.c
> > +++ b/kernel/rcu/tree.c
> > @@ -896,7 +896,7 @@ static void noinstr rcu_eqs_exit(bool user)
> >    * If you add or remove a call to rcu_idle_exit(), be sure to test with
> >    * CONFIG_RCU_EQS_DEBUG=y.
> >    */
> > -void rcu_idle_exit(void)
> > +void noinstr rcu_idle_exit(void)
> >   {
> >   	unsigned long flags;
