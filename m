Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D931257154
	for <lists+netdev@lfdr.de>; Mon, 31 Aug 2020 02:53:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726454AbgHaAx0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Aug 2020 20:53:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726179AbgHaAxZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Aug 2020 20:53:25 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F1E1C061573;
        Sun, 30 Aug 2020 17:53:25 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id v16so2255641plo.1;
        Sun, 30 Aug 2020 17:53:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=X45EOoAWX3kkjqs2e6aqIghhHeWnUZteS9Fizm9cPiQ=;
        b=koAC/mKnHGdd/BcHmKoKrnwAMo0c6HewQKtK5yyYIRFo27lok7o5mw6PmcfOEzBiKf
         frQ7OpoqK4IfT9vf7zQMmld6RAlFjRUrHdCOn+Entn8lsOYJNSnDNBE7VhnTZ0WoMPtl
         jpHPS9xtQa4ffyCRWlaPPpR67S5B2LpkAYhR0JaY+cETc97qXMxJFSh/0FEKjBplr5KQ
         Dzfh/iX4hgUn0xqaVDigQN4BT0nTZJ3U+Ll0umqYV1r2NjGcqC/Lmx5mODjfqergObRG
         oQ5QpaY7dbtSq8bUFOG/8A6Aq7ncQsMfx3Q6oXjVgCoirtQ5VFYzoXR/f9J7ivMxL5qo
         R/hQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=X45EOoAWX3kkjqs2e6aqIghhHeWnUZteS9Fizm9cPiQ=;
        b=LWVrpbim+G5Fyr+1ruQKlCNUqFLZEnh5cjG8R3ABru/545D46xhrT1sN+xi6JCdvgt
         UF8RiMDrOiDUjJ0DaBj4pit+PMzC5zRgMvzNj8sh84JdaTBNkl4xKnPV8mx8V5pAxf7U
         uu/dSZDcu+c2UoHCmVEOJ6+1ii0reLuGgt8q1M3OzyZppeOypK0vQkwVYM4LgXPnjnFy
         i3dsyH9fDZgWXQVnztleixkimlVFcSLsgU2vWCzpfYCvhWjs3Gx2IutoSmoiudYOmsF/
         6OOMD0EBIV8Z6hhNLL/h8tBSIpY2HSvEG1cbOgrFpR41sTYXtu6j14zq4oDEJrVt+K0A
         gxoA==
X-Gm-Message-State: AOAM531jrXQ017VgK0ObfQo+d2kAiMBknA3Src4UNdxpeBjdgNGcPt28
        SvjGSZrxHjZgwl5Bk+shsPE=
X-Google-Smtp-Source: ABdhPJy7+KnlLvKus9BEYPWcxWzqWS3MEXF69cWMmdt3c9EM0JtY/2MunCt/zc/I3YRMPN21ljkwxg==
X-Received: by 2002:a17:90a:de81:: with SMTP id n1mr4611679pjv.92.1598835204725;
        Sun, 30 Aug 2020 17:53:24 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:5a56])
        by smtp.gmail.com with ESMTPSA id go12sm5046481pjb.2.2020.08.30.17.53.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 Aug 2020 17:53:23 -0700 (PDT)
Date:   Sun, 30 Aug 2020 17:53:21 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     "Paul E. McKenney" <paulmck@kernel.org>
Cc:     davem@davemloft.net, daniel@iogearbox.net, josef@toxicpanda.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH bpf-next] bpf: Fix build without BPF_SYSCALL, but with
 BPF_JIT.
Message-ID: <20200831005321.75g5pw2xi4gyrb2i@ast-mbp.dhcp.thefacebook.com>
References: <20200830204328.50419-1-alexei.starovoitov@gmail.com>
 <20200830220313.GV2855@paulmck-ThinkPad-P72>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200830220313.GV2855@paulmck-ThinkPad-P72>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 30, 2020 at 03:03:13PM -0700, Paul E. McKenney wrote:
> On Sun, Aug 30, 2020 at 01:43:28PM -0700, Alexei Starovoitov wrote:
> > From: Alexei Starovoitov <ast@kernel.org>
> > 
> > When CONFIG_BPF_SYSCALL is not set, but CONFIG_BPF_JIT=y
> > the kernel build fails:
> > In file included from ../kernel/bpf/trampoline.c:11:
> > ../kernel/bpf/trampoline.c: In function ‘bpf_trampoline_update’:
> > ../kernel/bpf/trampoline.c:220:39: error: ‘call_rcu_tasks_trace’ undeclared
> > ../kernel/bpf/trampoline.c: In function ‘__bpf_prog_enter_sleepable’:
> > ../kernel/bpf/trampoline.c:411:2: error: implicit declaration of function ‘rcu_read_lock_trace’
> > ../kernel/bpf/trampoline.c: In function ‘__bpf_prog_exit_sleepable’:
> > ../kernel/bpf/trampoline.c:416:2: error: implicit declaration of function ‘rcu_read_unlock_trace’
> > 
> > Add these functions to rcupdate_trace.h.
> > The JIT won't call them and BPF trampoline logic won't be used without BPF_SYSCALL.
> > 
> > Reported-by: kernel test robot <lkp@intel.com>
> > Fixes: 1e6c62a88215 ("bpf: Introduce sleepable BPF programs")
> > Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> 
> A couple of nits below, but overall:
> 
> Acked-by: Paul E. McKenney <paulmck@kernel.org>
> 
> > ---
> >  include/linux/rcupdate_trace.h | 14 +++++++++++++-
> >  1 file changed, 13 insertions(+), 1 deletion(-)
> > 
> > diff --git a/include/linux/rcupdate_trace.h b/include/linux/rcupdate_trace.h
> > index d9015aac78c6..334840f4f245 100644
> > --- a/include/linux/rcupdate_trace.h
> > +++ b/include/linux/rcupdate_trace.h
> > @@ -82,7 +82,19 @@ static inline void rcu_read_unlock_trace(void)
> >  void call_rcu_tasks_trace(struct rcu_head *rhp, rcu_callback_t func);
> >  void synchronize_rcu_tasks_trace(void);
> >  void rcu_barrier_tasks_trace(void);
> > -
> > +#else
> 
> This formulation is a bit novel for RCU.  Could we therefore please add
> a comment something like this?
> 
> // The BPF JIT forms these addresses even when it doesn't call these
> // functions, so provide definitions that result in runtime errors.

ok. will add.
The root of the problem is:
obj-$(CONFIG_BPF_JIT) += trampoline.o
obj-$(CONFIG_BPF_JIT) += dispatcher.o
There is a number of functions that arch/x86/net/bpf_jit_comp.c is
using from these two files, but none of them will be used when
only cBPF is on (which is the case for BPF_SYSCALL=n BPF_JIT=y).
Don't confuse cBPF with eBPF ;)

This patch is imo the lesser of three evils. The other two:
- some serious refactoring of trampoline.c and dipsatcher.c into
  multiple files
- add 'depends on BPF_SYSCALL' to 'config BPF_JIT' in net/Kconfig

> 
> > +static inline void call_rcu_tasks_trace(struct rcu_head *rhp, rcu_callback_t func)
> > +{
> > +	BUG();
> > +}
> > +static inline void rcu_read_lock_trace(void)
> > +{
> > +	BUG();
> > +}
> > +static inline void rcu_read_unlock_trace(void)
> > +{
> > +	BUG();
> > +}
> 
> People have been moving towards one-liner for things like these last two:
> 
> static inline void rcu_read_lock_trace(void) { BUG(); }
> static inline void rcu_read_unlock_trace(void) { BUG(); }

sure. will respin.
