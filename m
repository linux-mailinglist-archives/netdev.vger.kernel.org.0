Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59454529F2E
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 12:18:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344005AbiEQKSE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 06:18:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344390AbiEQKQv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 06:16:51 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 526794C7A1;
        Tue, 17 May 2022 03:13:50 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id g12so6404808edq.4;
        Tue, 17 May 2022 03:13:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=pcZRdurBSN4nJPC8w1CaK4NSR1CQaP6KW/Ui8E5bIkg=;
        b=EXz7bbzqjPPM2JEaA3Cof1ejuwXtUYJBP4fAvxFiFqmmKgDlPvnTbPGOYS0/RyEJao
         3y/0Z4Patjm+EcQMpZO6jkjCIMzDhYeicRRbHGmzYDcDRqp/Rko6fYpRsjxYzjAcgN/U
         34I51QD1n+GyPfB1bBPLL4PoCeh0xwsQv0hvfDPE92ZPvioSjdcwf46Gu4ACKZVh8BU2
         j8do3nRQ/Shn2cq9DMV7fwq4A7RTAWgF/V2ced9sjFncBK1/0pvqQeTcxVh7EeLaPeWO
         UO/4xATFinSmw7z+ulZ/sGShvbWukkKXvZujIUcSEyFboFOfzdBhktOdBuV7WT9NnBJW
         hN4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=pcZRdurBSN4nJPC8w1CaK4NSR1CQaP6KW/Ui8E5bIkg=;
        b=6Rn1hYsf4FlctBMu2wweWGLBl1ObbbSYiIGOTvrgJEWX7iWRqfYlZZzHYAbsYqkhko
         9tmElW4u8S+SLVJfsAwGRRnE3uUxkaR3CEJ3UGQnkgoTbelwcP0xZLCMaOs4t0FmoIvV
         JtGAWjuQpoSAGah/9r2++erjBHWQL288qBVS2GM+krPaK9ggvbclltgb+eDzUcvTgMkT
         YyB0p+ndPGdU33EgC+mmVjWwNvGOXU6AbHSfza48Ej4M8I3rwoj3PkS+MUw8MGfkv0zY
         PGw78LbwTyK+fvkaJ43X+bsLnLY+u47Bs/2N4ZBQyBoR3eNNnurn7b1kSCQhUuDT3JpK
         GXHQ==
X-Gm-Message-State: AOAM530FimGyyncrXJHx5QIpB9dpV2GxVHnHgAHX54+nJnB0ZR7Kh/sm
        exyh0/JVHI/E7mIJZVumNyc=
X-Google-Smtp-Source: ABdhPJzU9534uohCsOtM++1lYyJGdQ9OYTEWax6NEX51VUdc+bPDRH3fyPitWL0JtHRFK7JLtbu08g==
X-Received: by 2002:a05:6402:2d6:b0:42a:bb5f:a7d2 with SMTP id b22-20020a05640202d600b0042abb5fa7d2mr6565732edx.96.1652782428912;
        Tue, 17 May 2022 03:13:48 -0700 (PDT)
Received: from krava ([193.85.244.190])
        by smtp.gmail.com with ESMTPSA id eg16-20020a056402289000b0042abb914d6asm1929187edb.69.2022.05.17.03.13.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 May 2022 03:13:48 -0700 (PDT)
From:   Jiri Olsa <olsajiri@gmail.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
Date:   Tue, 17 May 2022 12:13:45 +0200
To:     Frederic Weisbecker <frederic@kernel.org>
Cc:     "Paul E. McKenney" <paulmck@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH bpf-next 1/2] cpuidle/rcu: Making arch_cpu_idle and
 rcu_idle_exit noinstr
Message-ID: <YoN1WULUoKtMKx8v@krava>
References: <20220515203653.4039075-1-jolsa@kernel.org>
 <20220516042535.GV1790663@paulmck-ThinkPad-P17-Gen-1>
 <20220516114922.GA349949@lothringen>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220516114922.GA349949@lothringen>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 16, 2022 at 01:49:22PM +0200, Frederic Weisbecker wrote:
> On Sun, May 15, 2022 at 09:25:35PM -0700, Paul E. McKenney wrote:
> > On Sun, May 15, 2022 at 10:36:52PM +0200, Jiri Olsa wrote:
> > > Making arch_cpu_idle and rcu_idle_exit noinstr. Both functions run
> > > in rcu 'not watching' context and if there's tracer attached to
> > > them, which uses rcu (e.g. kprobe multi interface) it will hit RCU
> > > warning like:
> > > 
> > >   [    3.017540] WARNING: suspicious RCU usage
> > >   ...
> > >   [    3.018363]  kprobe_multi_link_handler+0x68/0x1c0
> > >   [    3.018364]  ? kprobe_multi_link_handler+0x3e/0x1c0
> > >   [    3.018366]  ? arch_cpu_idle_dead+0x10/0x10
> > >   [    3.018367]  ? arch_cpu_idle_dead+0x10/0x10
> > >   [    3.018371]  fprobe_handler.part.0+0xab/0x150
> > >   [    3.018374]  0xffffffffa00080c8
> > >   [    3.018393]  ? arch_cpu_idle+0x5/0x10
> > >   [    3.018398]  arch_cpu_idle+0x5/0x10
> > >   [    3.018399]  default_idle_call+0x59/0x90
> > >   [    3.018401]  do_idle+0x1c3/0x1d0
> > > 
> > > The call path is following:
> > > 
> > > default_idle_call
> > >   rcu_idle_enter
> > >   arch_cpu_idle
> > >   rcu_idle_exit
> > > 
> > > The arch_cpu_idle and rcu_idle_exit are the only ones from above
> > > path that are traceble and cause this problem on my setup.
> > > 
> > > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > 
> > From an RCU viewpoint:
> > 
> > Reviewed-by: Paul E. McKenney <paulmck@kernel.org>
> > 
> > [ I considered asking for an instrumentation_on() in rcu_idle_exit(),
> > but there is no point given that local_irq_restore() isn't something
> > you instrument anyway. ]
> 
> So local_irq_save() in the beginning of rcu_idle_exit() is unsafe because
> it is instrumentable by the function (graph)  tracers and the irqsoff tracer.
> 
> Also it calls into lockdep that might make use of RCU.
> 
> That's why rcu_idle_exit() is not noinstr yet. See this patch:
> 
> https://lore.kernel.org/lkml/20220503100051.2799723-4-frederic@kernel.org/

I see, could we mark it at least with notrace meanwhile?

jirka
