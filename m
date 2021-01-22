Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 413703006C0
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 16:10:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729233AbhAVPJt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 10:09:49 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:47396 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729072AbhAVPC4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jan 2021 10:02:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611327689;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=BKzcxPUR2jhhc0R2WEFUXJm7hKrjjWAOGp3ZV18Fm8U=;
        b=DOTX/oNGf9tqWnwTLTeZUFHdGe5QXj03U/Dpwj+WC4VDy7owy4y0nYR0JIPXZVf6u+c4mL
        wkppZJGTv9/cgKiUks2SY8XDCNm/D/x19PYszBBZIF8VLqGqSdVpP5XSBZzFm44etPDVGn
        WiuWR8D0XrQJHz26KnJfQCaG462uOZ0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-432-Q2OnEu_tO7WNHpoNSVMMJA-1; Fri, 22 Jan 2021 10:01:27 -0500
X-MC-Unique: Q2OnEu_tO7WNHpoNSVMMJA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 70D94806661;
        Fri, 22 Jan 2021 15:01:25 +0000 (UTC)
Received: from fuller.cnet (ovpn-112-4.gru2.redhat.com [10.97.112.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2B3365DA33;
        Fri, 22 Jan 2021 15:01:18 +0000 (UTC)
Received: by fuller.cnet (Postfix, from userid 1000)
        id 0DA054178901; Fri, 22 Jan 2021 12:00:01 -0300 (-03)
Date:   Fri, 22 Jan 2021 12:00:00 -0300
From:   Marcelo Tosatti <mtosatti@redhat.com>
To:     Frederic Weisbecker <frederic@kernel.org>
Cc:     Alex Belits <abelits@marvell.com>,
        Prasun Kapoor <pkapoor@marvell.com>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "trix@redhat.com" <trix@redhat.com>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "nitesh@redhat.com" <nitesh@redhat.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "will@kernel.org" <will@kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "leon@sidebranch.com" <leon@sidebranch.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "pauld@redhat.com" <pauld@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [EXT] Re: [PATCH v5 9/9] task_isolation: kick_all_cpus_sync:
 don't kick isolated cpus
Message-ID: <20210122150000.GA69079@fuller.cnet>
References: <8d887e59ca713726f4fcb25a316e1e932b02823e.camel@marvell.com>
 <3236b13f42679031960c5605be20664e90e75223.camel@marvell.com>
 <20201123222907.GC1751@lothringen>
 <c65ac23c1c408614110635c33eaf4ace98da4343.camel@marvell.com>
 <20201123232106.GD1751@lothringen>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201123232106.GD1751@lothringen>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 24, 2020 at 12:21:06AM +0100, Frederic Weisbecker wrote:
> On Mon, Nov 23, 2020 at 10:39:34PM +0000, Alex Belits wrote:
> > 
> > On Mon, 2020-11-23 at 23:29 +0100, Frederic Weisbecker wrote:
> > > External Email
> > > 
> > > -------------------------------------------------------------------
> > > ---
> > > On Mon, Nov 23, 2020 at 05:58:42PM +0000, Alex Belits wrote:
> > > > From: Yuri Norov <ynorov@marvell.com>
> > > > 
> > > > Make sure that kick_all_cpus_sync() does not call CPUs that are
> > > > running
> > > > isolated tasks.
> > > > 
> > > > Signed-off-by: Yuri Norov <ynorov@marvell.com>
> > > > [abelits@marvell.com: use safe task_isolation_cpumask()
> > > > implementation]
> > > > Signed-off-by: Alex Belits <abelits@marvell.com>
> > > > ---
> > > >  kernel/smp.c | 14 +++++++++++++-
> > > >  1 file changed, 13 insertions(+), 1 deletion(-)
> > > > 
> > > > diff --git a/kernel/smp.c b/kernel/smp.c
> > > > index 4d17501433be..b2faecf58ed0 100644
> > > > --- a/kernel/smp.c
> > > > +++ b/kernel/smp.c
> > > > @@ -932,9 +932,21 @@ static void do_nothing(void *unused)
> > > >   */
> > > >  void kick_all_cpus_sync(void)
> > > >  {
> > > > +	struct cpumask mask;
> > > > +
> > > >  	/* Make sure the change is visible before we kick the cpus */
> > > >  	smp_mb();
> > > > -	smp_call_function(do_nothing, NULL, 1);
> > > > +
> > > > +	preempt_disable();
> > > > +#ifdef CONFIG_TASK_ISOLATION
> > > > +	cpumask_clear(&mask);
> > > > +	task_isolation_cpumask(&mask);
> > > > +	cpumask_complement(&mask, &mask);
> > > > +#else
> > > > +	cpumask_setall(&mask);
> > > > +#endif
> > > > +	smp_call_function_many(&mask, do_nothing, NULL, 1);
> > > > +	preempt_enable();
> > > 
> > > Same comment about IPIs here.
> > 
> > This is different from timers. The original design was based on the
> > idea that every CPU should be able to enter kernel at any time and run
> > kernel code with no additional preparation. Then the only solution is
> > to always do full broadcast and require all CPUs to process it.
> > 
> > What I am trying to introduce is the idea of CPU that is not likely to
> > run kernel code any soon, and can afford to go through an additional
> > synchronization procedure on the next entry into kernel. The
> > synchronization is not skipped, it simply happens later, early in
> > kernel entry code.

Perhaps a bitmask of pending flushes makes more sense? 
static_key_enable IPIs is one of the users, but for its case it would 
be necessary to differentiate between in-kernel mode and out of kernel 
mode atomically (since i-cache flush must be performed if isolated CPU 
is in kernel mode).

> Ah I see, this is ordered that way:
> 
> ll_isol_flags = ISOLATED
> 
>          CPU 0                                CPU 1
>     ------------------                       -----------------
>                                             // kernel entry
>     data_to_sync = 1                        ll_isol_flags = ISOLATED_BROKEN
>     smp_mb()                                smp_mb()
>     if ll_isol_flags(CPU 1) == ISOLATED     READ data_to_sync
>          smp_call(CPU 1)

Since isolated mode with syscalls is a desired feature, having a
separate atomic with in_kernel_mode = 0/1 (that is set/cleared 
on kernel entry / kernel exit, while on TIF_TASK_ISOLATION), would be
necessary (and a similar race-free logic as above).

> You should document that, ie: explain why what you're doing is safe.
> 
> Also Beware though that the data to sync in question doesn't need to be visible
> in the entry code before task_isolation_kernel_enter(). You need to audit all
> the callers of kick_all_cpus_sync().

Cscope tag: flush_icache_range
   #   line  filename / context / line
   1     96  arch/arc/kernel/jump_label.c <<arch_jump_label_transform>>
             flush_icache_range(entry->code, entry->code + JUMP_LABEL_NOP_SIZE);

This case would be OK for delayed processing before kernel entry, as long as
no code before task_isolation_kernel_enter can be modified (which i am
not sure about).

But:

  36     28  arch/ia64/include/asm/cacheflush.h <<flush_icache_user_page>>
             flush_icache_range(_addr, _addr + (len)); \

Is less certain.

Alex do you recall if arch_jump_label_transform was the only offender or 
there were others as well? (suppose handling only the ones which matter
in production at the moment, and later fixing individual ones makes most
sense).



