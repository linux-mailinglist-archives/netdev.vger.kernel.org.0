Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF0E353100D
	for <lists+netdev@lfdr.de>; Mon, 23 May 2022 15:19:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236032AbiEWNNX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 09:13:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235975AbiEWNMf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 09:12:35 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C0302C67F;
        Mon, 23 May 2022 06:12:33 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id c10so19095454edr.2;
        Mon, 23 May 2022 06:12:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=7NA2oe+MVM7ExjHQjWCs0WPJ0CBdjVVraxVqOmP4Fes=;
        b=cWAVdSaZXqJGz+OvDHUfqE01JxN72tuVNTGyDJG/XwACyy5uHOtfrYd3bahvHlGjar
         KzINXyw3H4tL6Ake6FKsbtO7F/yse6h77LrQ38UC12dKBH2v8NwTd7LBY6N0JCUkAqqH
         KlLH+X3+YvnJ3CixwM/G8TY45RTZD8UqLNMdg0daLYBi1pZfwhueqgwJ6+sPVCibOR9N
         rxpaR9w9jhFpSmJGefzqTtDCC4h2SMnIqJgN5fFQKBRG21ZQmEKRzlMEy8UTfo8ciRE3
         nAwYL6KH2XbR/6FcIxc5vy2QnmNFJNfF0bZ7NnZk0adNBiHt3UA1CPbg/DBLAWYnldh/
         E2hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=7NA2oe+MVM7ExjHQjWCs0WPJ0CBdjVVraxVqOmP4Fes=;
        b=SWNYq69etqMP/FrLV3vPC+c3kaFGObYcBlfQbdgRjbKSWX0M4MBdh0jUQZyupqjZ9w
         7Bl5tdVd9BYT8/tPSgSq6dM3hhHl4ttXX0Ia1mSYRBqvjjewyAteGGT7p0ijMm6pgCjf
         yZ3jHuIEyepAXJbMW1yAY8NKdx6Vm7FHJlnHzrm37cmpzRmWJEamSTiC28gBchu5ZlvF
         W/ckZmj3zLX05qy50TrK8ZkRb0PiA2pWzZH6ot601fw+46czVqXNjNu9T68tERJn8I5W
         KixDwiFWfeC7tooWczZD2jXoC90n6r2w8PUhluRTNWdWkzXQGKY3n2pfKrqm3G5DQ8t5
         ohoA==
X-Gm-Message-State: AOAM533Q+2NFWgwdUuqXCmfjtbziviqG5lHvgLXYR0qboUS2Wzzh48Aw
        zyTsj5YHGC3pz7jK9N1OqZs=
X-Google-Smtp-Source: ABdhPJzUoE4/x0Lb9cEwrCB6U8QMGVPzd8davX3nPNrRmeHUE4waHiTZbekOYW7zuT42kOklIF7Tvw==
X-Received: by 2002:a05:6402:206f:b0:42a:a8c1:1637 with SMTP id bd15-20020a056402206f00b0042aa8c11637mr23391901edb.302.1653311551744;
        Mon, 23 May 2022 06:12:31 -0700 (PDT)
Received: from krava (net-93-65-240-241.cust.vodafonedsl.it. [93.65.240.241])
        by smtp.gmail.com with ESMTPSA id jz27-20020a17090775fb00b006f3ef214e6dsm6076136ejc.211.2022.05.23.06.12.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 May 2022 06:12:31 -0700 (PDT)
From:   Jiri Olsa <olsajiri@gmail.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
Date:   Mon, 23 May 2022 15:12:28 +0200
To:     "Paul E. McKenney" <paulmck@kernel.org>
Cc:     Jiri Olsa <olsajiri@gmail.com>,
        Frederic Weisbecker <frederic@kernel.org>,
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
Message-ID: <YouIPHx2l0S3bMLv@krava>
References: <20220515203653.4039075-1-jolsa@kernel.org>
 <20220516042535.GV1790663@paulmck-ThinkPad-P17-Gen-1>
 <20220516114922.GA349949@lothringen>
 <YoN1WULUoKtMKx8v@krava>
 <20220518162118.GA2661055@paulmck-ThinkPad-P17-Gen-1>
 <YoYq/M6ZSQ+U2sar@krava>
 <20220519135439.GX1790663@paulmck-ThinkPad-P17-Gen-1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220519135439.GX1790663@paulmck-ThinkPad-P17-Gen-1>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 19, 2022 at 06:54:39AM -0700, Paul E. McKenney wrote:
> On Thu, May 19, 2022 at 01:33:16PM +0200, Jiri Olsa wrote:
> > On Wed, May 18, 2022 at 09:21:18AM -0700, Paul E. McKenney wrote:
> > > On Tue, May 17, 2022 at 12:13:45PM +0200, Jiri Olsa wrote:
> > > > On Mon, May 16, 2022 at 01:49:22PM +0200, Frederic Weisbecker wrote:
> > > > > On Sun, May 15, 2022 at 09:25:35PM -0700, Paul E. McKenney wrote:
> > > > > > On Sun, May 15, 2022 at 10:36:52PM +0200, Jiri Olsa wrote:
> > > > > > > Making arch_cpu_idle and rcu_idle_exit noinstr. Both functions run
> > > > > > > in rcu 'not watching' context and if there's tracer attached to
> > > > > > > them, which uses rcu (e.g. kprobe multi interface) it will hit RCU
> > > > > > > warning like:
> > > > > > > 
> > > > > > >   [    3.017540] WARNING: suspicious RCU usage
> > > > > > >   ...
> > > > > > >   [    3.018363]  kprobe_multi_link_handler+0x68/0x1c0
> > > > > > >   [    3.018364]  ? kprobe_multi_link_handler+0x3e/0x1c0
> > > > > > >   [    3.018366]  ? arch_cpu_idle_dead+0x10/0x10
> > > > > > >   [    3.018367]  ? arch_cpu_idle_dead+0x10/0x10
> > > > > > >   [    3.018371]  fprobe_handler.part.0+0xab/0x150
> > > > > > >   [    3.018374]  0xffffffffa00080c8
> > > > > > >   [    3.018393]  ? arch_cpu_idle+0x5/0x10
> > > > > > >   [    3.018398]  arch_cpu_idle+0x5/0x10
> > > > > > >   [    3.018399]  default_idle_call+0x59/0x90
> > > > > > >   [    3.018401]  do_idle+0x1c3/0x1d0
> > > > > > > 
> > > > > > > The call path is following:
> > > > > > > 
> > > > > > > default_idle_call
> > > > > > >   rcu_idle_enter
> > > > > > >   arch_cpu_idle
> > > > > > >   rcu_idle_exit
> > > > > > > 
> > > > > > > The arch_cpu_idle and rcu_idle_exit are the only ones from above
> > > > > > > path that are traceble and cause this problem on my setup.
> > > > > > > 
> > > > > > > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > > > > > 
> > > > > > From an RCU viewpoint:
> > > > > > 
> > > > > > Reviewed-by: Paul E. McKenney <paulmck@kernel.org>
> > > > > > 
> > > > > > [ I considered asking for an instrumentation_on() in rcu_idle_exit(),
> > > > > > but there is no point given that local_irq_restore() isn't something
> > > > > > you instrument anyway. ]
> > > > > 
> > > > > So local_irq_save() in the beginning of rcu_idle_exit() is unsafe because
> > > > > it is instrumentable by the function (graph)  tracers and the irqsoff tracer.
> > > > > 
> > > > > Also it calls into lockdep that might make use of RCU.
> > > > > 
> > > > > That's why rcu_idle_exit() is not noinstr yet. See this patch:
> > > > > 
> > > > > https://lore.kernel.org/lkml/20220503100051.2799723-4-frederic@kernel.org/
> > > > 
> > > > I see, could we mark it at least with notrace meanwhile?
> > > 
> > > For the RCU part, how about as follows?
> > > 
> > > If this approach is reasonable, my guess would be that Frederic will pull
> > > it into his context-tracking series, perhaps using a revert of this patch
> > > to maintain sanity in the near term.
> > > 
> > > If this approach is unreasonable, well, that is Murphy for you!
> > 
> > I checked and it works in my test ;-)
> 
> Whew!!!  One piece of the problem might be solved, then.  ;-)
> 
> > > For the x86 idle part, my feeling is still that the rcu_idle_enter()
> > > and rcu_idle_exit() need to be pushed deeper into the code.  Perhaps
> > > an ongoing process as the idle loop continues to be dug deeper?
> > 
> > for arch_cpu_idle with noinstr I'm getting this W=1 warning:
> > 
> > vmlinux.o: warning: objtool: arch_cpu_idle()+0xb: call to {dynamic}() leaves .noinstr.text section
> > 
> > we could have it with notrace if that's a problem
> 
> I would be happy to queue the arch_cpu_idle() portion of your patch on
> -rcu, if that would move things forward.  I suspect that additional
> x86_idle() surgery is required, but maybe I am just getting confused
> about what the x86_idle() function pointer can point to.  But it looks
> to me like these need further help:
> 
> o	static void amd_e400_idle(void)
> 	Plus things it calls, like tick_broadcast_enter() and
> 	tick_broadcast_exit().
> 
> o	static __cpuidle void mwait_idle(void)
> 
> So it might not be all that much additional work, even if I have avoided
> confusion about what the x86_idle() function pointer can point to.  But
> I do not trust my ability to test this accurately.

same here ;-) you're right, there will be other places based
on x86_idle function pointer.. I'll check it, but perhaps we
could address that when someone reports that

jirka
