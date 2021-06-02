Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D5EB398C38
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 16:14:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231872AbhFBOQE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 10:16:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231846AbhFBOO2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Jun 2021 10:14:28 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA205C061761;
        Wed,  2 Jun 2021 07:12:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=FzJfBljo4B8RxU2ilIDhSLr34HFST0rQLNCYNw/HW+w=; b=L9vjUarjZTu6NzihPxyvfr9SrD
        cXp2K8L/lswul4alVU9a5KXYcmiYKaI0pVqEPrOTObk1bWVjIa727CcohFhQnptUDt9rVM7+wZokD
        bdiAP5TkdYqfBQHbyzuL3QwjL5RpkYojkJ5M5vFeN5hhURZOWxGVnCDXhqvgtesERKVZoPVmmu+1u
        zvBuQ/5U6yi+c+8BHLKEGRhN8+mOxmjvdNXmQvv5K7kABrgsWq6TQpgiZuniSUsdWGatjG0TQN4HN
        iyi9j9XYfQaN+mhBZrOglYAeu1Bmuw53jmWdaNNlHNX9gCtb8Ta+n9yUYscEboZQaYK4WTzPQHe3/
        3aLE6Hfw==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1loRbc-002uVV-R0; Wed, 02 Jun 2021 14:12:31 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id D44963002A3;
        Wed,  2 Jun 2021 16:12:30 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id B760020223DA5; Wed,  2 Jun 2021 16:12:30 +0200 (CEST)
Date:   Wed, 2 Jun 2021 16:12:30 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>,
        Mel Gorman <mgorman@suse.de>, bristot <bristot@redhat.com>,
        Borislav Petkov <bp@alien8.de>, x86 <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Jens Axboe <axboe@kernel.dk>,
        Alasdair Kergon <agk@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>,
        dm-devel <dm-devel@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Jason Wessel <jason.wessel@windriver.com>,
        Daniel Thompson <daniel.thompson@linaro.org>,
        Douglas Anderson <dianders@chromium.org>,
        acme <acme@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Pavel Machek <pavel@ucw.cz>, Will Deacon <will@kernel.org>,
        Waiman Long <longman@redhat.com>,
        Boqun Feng <boqun.feng@gmail.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Davidlohr Bueso <dave@stgolabs.net>,
        paulmck <paulmck@kernel.org>,
        Josh Triplett <josh@joshtriplett.org>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        "Joel Fernandes, Google" <joel@joelfernandes.org>,
        John Stultz <john.stultz@linaro.org>,
        Stephen Boyd <sboyd@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-block <linux-block@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        linux-usb <linux-usb@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        cgroups <cgroups@vger.kernel.org>,
        kgdb-bugreport <kgdb-bugreport@lists.sourceforge.net>,
        linux-perf-users <linux-perf-users@vger.kernel.org>,
        linux-pm <linux-pm@vger.kernel.org>, rcu <rcu@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>, KVM list <kvm@vger.kernel.org>
Subject: Re: [PATCH 4/6] sched: Add get_current_state()
Message-ID: <YLeRzlEmbdsMrFcG@hirez.programming.kicks-ass.net>
References: <20210602131225.336600299@infradead.org>
 <20210602133040.461908001@infradead.org>
 <1731339790.5856.1622642489232.JavaMail.zimbra@efficios.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1731339790.5856.1622642489232.JavaMail.zimbra@efficios.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 02, 2021 at 10:01:29AM -0400, Mathieu Desnoyers wrote:
> ----- On Jun 2, 2021, at 9:12 AM, Peter Zijlstra peterz@infradead.org wrote:
> 
> > Remove yet another few p->state accesses.
> 
> [...]
> 
> > 
> > --- a/include/linux/sched.h
> > +++ b/include/linux/sched.h
> > @@ -212,6 +212,8 @@ struct task_group;
> > 
> > #endif
> > 
> > +#define get_current_state()	READ_ONCE(current->state)
> 
> Why use a macro rather than a static inline here ?

Mostly to be consistent, all that state stuff is macros. I suppose we
could try and make them inlines at the end or so -- if the header maze
allows.
