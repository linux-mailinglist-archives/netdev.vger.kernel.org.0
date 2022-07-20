Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6726A57BC49
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 19:06:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237538AbiGTRG3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 13:06:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237864AbiGTRG1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 13:06:27 -0400
Received: from mail-qk1-x736.google.com (mail-qk1-x736.google.com [IPv6:2607:f8b0:4864:20::736])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75E3A6BC1A;
        Wed, 20 Jul 2022 10:06:26 -0700 (PDT)
Received: by mail-qk1-x736.google.com with SMTP id g1so13343452qki.7;
        Wed, 20 Jul 2022 10:06:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=c5dtfvo8X5iwM555XYGNyX8BDWpR76NHDGfyCA16UfI=;
        b=gXnjZIAPvttLh4w+Ab05XIAYC8D5DFsAcn3ijUuLc+GSaiv8d+uPgFpGnvwgzTS/B3
         rk2QbOkRfYBeLjblewcyl0Vb+S5PgQDkx3FIdSvkuq9BA0tsTAZGZM4defJCc6/5eI0l
         G4ECM2998z3lFf5BU+LDBrtFc51bW3sjaGP+oqBRHoO7lFKGHq4j80vF9X43peS43iqa
         FUBHW0bYtFMPCIRWJIpJpLIpWdOTHNEIfAA+fQwwUnPPqzuuIvUxzM0I9vzqRRgF3ei0
         vzhw+Xp5jt42ygTQE7MFdspXgtuGzh2oSrTfPAI37A0raDJWGQsjyDo2k1a1jM9Hbw2h
         Sdgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=c5dtfvo8X5iwM555XYGNyX8BDWpR76NHDGfyCA16UfI=;
        b=oqBqUzsJbfKuSC1mXeMnrd0EIQWe3vX8NLWYNDPFPL6pzv7iiBB2G2p6hBg0elyG80
         enw1Lna4Adg27Jnm5zi8sRdwlSYSXD/gGIhBqTuMkygOTSkgK+wbpAvsaQlYQZ8AXkC9
         ztrf1rjtnFGc0bZetuVZWjRiVP4SyEJZpwL3HSok91Sb3L8sW/4/Ue1sw7pOcsx0R8KB
         jKCznIYPjPBwbOwBvjFir4a5aRcmclLTu+iMRhS1S7u+WmsWqLeRBCm4wJj41Suvh95v
         259BEZpMNtbvwaeJGPk73f2wScZXi/FFozghYb1cGSXv1kOVMXuSpp3++gLgeOiQh0jA
         Hxfg==
X-Gm-Message-State: AJIora+VhkK8tzENF4lcsZkY8tMPxwRC5tUuGDx4CDN3rMq5kCgrnLKh
        7W4VdEvyIWT1K/WwIWx/x+U=
X-Google-Smtp-Source: AGRyM1uF7lm4SkCoCmiO9CDgTxUf5JkUnMZTBFaY3XD4jl+P4Tu0b4B+1O9aO2TfDEiT41gMmb4a7A==
X-Received: by 2002:a37:b802:0:b0:6b5:8330:55a with SMTP id i2-20020a37b802000000b006b58330055amr25801868qkf.778.1658336785340;
        Wed, 20 Jul 2022 10:06:25 -0700 (PDT)
Received: from localhost ([2601:4c1:c100:1230:8a38:8fe4:50f8:8b83])
        by smtp.gmail.com with ESMTPSA id u11-20020a05620a0c4b00b006b4689e3425sm16467626qki.129.2022.07.20.10.06.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jul 2022 10:06:25 -0700 (PDT)
Date:   Wed, 20 Jul 2022 10:06:24 -0700
From:   Yury Norov <yury.norov@gmail.com>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     linux-kernel@vger.kernel.org,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Alexey Klimov <aklimov@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Ben Segall <bsegall@google.com>,
        Christoph Lameter <cl@linux.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Dennis Zhou <dennis@kernel.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Eric Dumazet <edumazet@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Ingo Molnar <mingo@redhat.com>,
        Isabella Basso <isabbasso@riseup.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Juergen Gross <jgross@suse.com>,
        Juri Lelli <juri.lelli@redhat.com>,
        KP Singh <kpsingh@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Mel Gorman <mgorman@suse.de>, Miroslav Benes <mbenes@suse.cz>,
        Nathan Chancellor <nathan@kernel.org>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Song Liu <songliubraving@fb.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Tejun Heo <tj@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Valentin Schneider <vschneid@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Vlastimil Babka <vbabka@suse.cz>, Yonghong Song <yhs@fb.com>,
        linux-mm@kvack.org, netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH 08/16] smp: optimize smp_call_function_many_cond() for
 more
Message-ID: <Ytg2EA+2XtzPiyBE@yury-laptop>
References: <20220718192844.1805158-1-yury.norov@gmail.com>
 <20220718192844.1805158-9-yury.norov@gmail.com>
 <YtXQom+a5C+iXSvm@worktop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YtXQom+a5C+iXSvm@worktop.programming.kicks-ass.net>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 18, 2022 at 11:29:06PM +0200, Peter Zijlstra wrote:
> On Mon, Jul 18, 2022 at 12:28:36PM -0700, Yury Norov wrote:
> 
> > ---
> >  kernel/smp.c | 6 +++++-
> >  1 file changed, 5 insertions(+), 1 deletion(-)
> > 
> > diff --git a/kernel/smp.c b/kernel/smp.c
> > index 7ed2b9b12f74..f96fdf944b4a 100644
> > --- a/kernel/smp.c
> > +++ b/kernel/smp.c
> > @@ -942,7 +942,11 @@ static void smp_call_function_many_cond(const struct cpumask *mask,
> >  
> >  	if (run_remote) {
> >  		cfd = this_cpu_ptr(&cfd_data);
> > -		cpumask_and(cfd->cpumask, mask, cpu_online_mask);
> > +		if (mask == cpu_online_mask)
> > +			cpumask_copy(cfd->cpumask, cpu_online_mask);
> > +		else
> > +			cpumask_and(cfd->cpumask, mask, cpu_online_mask);
> > +
> 
> Or... you could optimize cpumask_and() to detect the src1p == src2p case?

This is not what I would consider as optimization. For vast majority
of users this check is useless because they know for sure that
cpumasks are different.

For this case I can invent something like cpumask_and_check_eq(), so
that there'll be minimal impact on user code. (Suggestions for a better
name are very welcome.)

Thanks,
Yury
