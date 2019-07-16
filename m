Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED78A6AF0A
	for <lists+netdev@lfdr.de>; Tue, 16 Jul 2019 20:47:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728772AbfGPSq7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jul 2019 14:46:59 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:44116 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387773AbfGPSqw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jul 2019 14:46:52 -0400
Received: by mail-pf1-f196.google.com with SMTP id t16so9521323pfe.11
        for <netdev@vger.kernel.org>; Tue, 16 Jul 2019 11:46:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=PdG0Hdy4kUF1vNp70B1fm6NDyRSJQdtEoyDsUyLFi94=;
        b=dmMkHQo9IniciAwKAMxr0u85jWCSvyb5BF57+I4CD3SZq9AT5BU5o2HZO4fS84Qgrb
         x4dLWUS32mTEUlCn5agl3nUCtKJ2BiYYgquJpGEVAqF+/lZwg41ad0k1NH/k0y7e+3YR
         RXTcC5Vge/zfplv3AXO+eEIhtj5K1O5b0vSbM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=PdG0Hdy4kUF1vNp70B1fm6NDyRSJQdtEoyDsUyLFi94=;
        b=GB13zxfg1W0ajI0voT2Cxz921TU9DceLSreAYITfkaI2kF56OcN/at2sNpXfQPCiL+
         wY9fh3ycahMaBuwi9M+alwnMo/jVrw4DOGKwzg3Rxx+2bg5+csSM2kfpYTcuKbF5kU9e
         RPzqjCFNCQyRTIhl0Mgl8R2I2rJSNgJm2sEIb0OKhNg48cZ2LfAWlCOecrr8pMgTvY5c
         R3Ppzn6TbaPOKRusPCiNCMSbCScJ+6XzDQtIoccSfcFkAiT0EZY9vpjE+tWLDXxbnhm9
         3apSqWgBoGiSm2GBDrZTvMBHSTthYiL7K6waaPYQNU+vWvRhIlUUl3tsvQqomLjXlJ4W
         H+Fg==
X-Gm-Message-State: APjAAAUndSb4OMCqqiMFnzq2GtKVxY2ZUzovr/1B+tPxoM+oVf6WasaO
        UY9GxC+6PntmUJrMM9mHQ2Q=
X-Google-Smtp-Source: APXvYqwkKBelwwXf63Pw3fAr18WLABRKFaDv/myKEWHJ+6vqtjhnwmRdixzh6Ckd3GBE6woFO+E/Pw==
X-Received: by 2002:a17:90a:b387:: with SMTP id e7mr39873248pjr.113.1563302811662;
        Tue, 16 Jul 2019 11:46:51 -0700 (PDT)
Received: from localhost ([2620:15c:6:12:9c46:e0da:efbf:69cc])
        by smtp.gmail.com with ESMTPSA id f19sm28628190pfk.180.2019.07.16.11.46.50
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 16 Jul 2019 11:46:50 -0700 (PDT)
Date:   Tue, 16 Jul 2019 14:46:49 -0400
From:   Joel Fernandes <joel@joelfernandes.org>
To:     "Paul E. McKenney" <paulmck@linux.ibm.com>
Cc:     linux-kernel@vger.kernel.org,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Borislav Petkov <bp@alien8.de>, c0d1n61at3@gmail.com,
        "David S. Miller" <davem@davemloft.net>, edumazet@google.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Josh Triplett <josh@joshtriplett.org>, keescook@chromium.org,
        kernel-hardening@lists.openwall.com, kernel-team@android.com,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-pm@vger.kernel.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        neilb@suse.com, netdev@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>, Pavel Machek <pavel@ucw.cz>,
        peterz@infradead.org, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>,
        rcu@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        Tejun Heo <tj@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, will@kernel.org,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>
Subject: Re: [PATCH 2/9] rcu: Add support for consolidated-RCU reader
 checking (v3)
Message-ID: <20190716184649.GA130463@google.com>
References: <20190715143705.117908-1-joel@joelfernandes.org>
 <20190715143705.117908-3-joel@joelfernandes.org>
 <20190716183833.GD14271@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190716183833.GD14271@linux.ibm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 16, 2019 at 11:38:33AM -0700, Paul E. McKenney wrote:
> On Mon, Jul 15, 2019 at 10:36:58AM -0400, Joel Fernandes (Google) wrote:
> > This patch adds support for checking RCU reader sections in list
> > traversal macros. Optionally, if the list macro is called under SRCU or
> > other lock/mutex protection, then appropriate lockdep expressions can be
> > passed to make the checks pass.
> > 
> > Existing list_for_each_entry_rcu() invocations don't need to pass the
> > optional fourth argument (cond) unless they are under some non-RCU
> > protection and needs to make lockdep check pass.
> > 
> > Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
> 
> Now that I am on the correct version, again please fold in the checks
> for the extra argument.  The ability to have an optional argument looks
> quite helpful, especially when compared to growing the RCU API!

I did fold this and replied with a pull request URL based on /dev branch. But
we can hold off on the pull requests until we decide on the below comments:

> A few more things below.
> > ---
> >  include/linux/rculist.h  | 28 ++++++++++++++++++++-----
> >  include/linux/rcupdate.h |  7 +++++++
> >  kernel/rcu/Kconfig.debug | 11 ++++++++++
> >  kernel/rcu/update.c      | 44 ++++++++++++++++++++++++----------------
> >  4 files changed, 67 insertions(+), 23 deletions(-)
> > 
> > diff --git a/include/linux/rculist.h b/include/linux/rculist.h
> > index e91ec9ddcd30..1048160625bb 100644
> > --- a/include/linux/rculist.h
> > +++ b/include/linux/rculist.h
> > @@ -40,6 +40,20 @@ static inline void INIT_LIST_HEAD_RCU(struct list_head *list)
> >   */
> >  #define list_next_rcu(list)	(*((struct list_head __rcu **)(&(list)->next)))
> >  
> > +/*
> > + * Check during list traversal that we are within an RCU reader
> > + */
> > +
> > +#ifdef CONFIG_PROVE_RCU_LIST
> 
> This new Kconfig option is OK temporarily, but unless there is reason to
> fear malfunction that a few weeks of rcutorture, 0day, and -next won't
> find, it would be better to just use CONFIG_PROVE_RCU.  The overall goal
> is to reduce the number of RCU knobs rather than grow them, must though
> history might lead one to believe otherwise.  :-/

If you want, we can try to drop this option and just use PROVE_RCU however I
must say there may be several warnings that need to be fixed in a short
period of time (even a few weeks may be too short) considering the 1000+
uses of RCU lists.

But I don't mind dropping it and it may just accelerate the fixing up of all
callers.

> > +#define __list_check_rcu(dummy, cond, ...)				\
> > +	({								\
> > +	RCU_LOCKDEP_WARN(!cond && !rcu_read_lock_any_held(),		\
> > +			 "RCU-list traversed in non-reader section!");	\
> > +	 })
> > +#else
> > +#define __list_check_rcu(dummy, cond, ...) ({})
> > +#endif
> > +
> >  /*
> >   * Insert a new entry between two known consecutive entries.
> >   *
> > @@ -343,14 +357,16 @@ static inline void list_splice_tail_init_rcu(struct list_head *list,
> >   * @pos:	the type * to use as a loop cursor.
> >   * @head:	the head for your list.
> >   * @member:	the name of the list_head within the struct.
> > + * @cond:	optional lockdep expression if called from non-RCU protection.
> >   *
> >   * This list-traversal primitive may safely run concurrently with
> >   * the _rcu list-mutation primitives such as list_add_rcu()
> >   * as long as the traversal is guarded by rcu_read_lock().
> >   */
> > -#define list_for_each_entry_rcu(pos, head, member) \
> > -	for (pos = list_entry_rcu((head)->next, typeof(*pos), member); \
> > -		&pos->member != (head); \
> > +#define list_for_each_entry_rcu(pos, head, member, cond...)		\
> > +	for (__list_check_rcu(dummy, ## cond, 0),			\
> > +	     pos = list_entry_rcu((head)->next, typeof(*pos), member);	\
> > +		&pos->member != (head);					\
> >  		pos = list_entry_rcu(pos->member.next, typeof(*pos), member))
> >  
> >  /**
> > @@ -616,13 +632,15 @@ static inline void hlist_add_behind_rcu(struct hlist_node *n,
> >   * @pos:	the type * to use as a loop cursor.
> >   * @head:	the head for your list.
> >   * @member:	the name of the hlist_node within the struct.
> > + * @cond:	optional lockdep expression if called from non-RCU protection.
> >   *
> >   * This list-traversal primitive may safely run concurrently with
> >   * the _rcu list-mutation primitives such as hlist_add_head_rcu()
> >   * as long as the traversal is guarded by rcu_read_lock().
> >   */
> > -#define hlist_for_each_entry_rcu(pos, head, member)			\
> > -	for (pos = hlist_entry_safe (rcu_dereference_raw(hlist_first_rcu(head)),\
> > +#define hlist_for_each_entry_rcu(pos, head, member, cond...)		\
> > +	for (__list_check_rcu(dummy, ## cond, 0),			\
> > +	     pos = hlist_entry_safe (rcu_dereference_raw(hlist_first_rcu(head)),\
> >  			typeof(*(pos)), member);			\
> >  		pos;							\
> >  		pos = hlist_entry_safe(rcu_dereference_raw(hlist_next_rcu(\
> > diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
> > index 8f7167478c1d..f3c29efdf19a 100644
> > --- a/include/linux/rcupdate.h
> > +++ b/include/linux/rcupdate.h
> > @@ -221,6 +221,7 @@ int debug_lockdep_rcu_enabled(void);
> >  int rcu_read_lock_held(void);
> >  int rcu_read_lock_bh_held(void);
> >  int rcu_read_lock_sched_held(void);
> > +int rcu_read_lock_any_held(void);
> >  
> >  #else /* #ifdef CONFIG_DEBUG_LOCK_ALLOC */
> >  
> > @@ -241,6 +242,12 @@ static inline int rcu_read_lock_sched_held(void)
> >  {
> >  	return !preemptible();
> >  }
> > +
> > +static inline int rcu_read_lock_any_held(void)
> > +{
> > +	return !preemptible();
> > +}
> > +
> >  #endif /* #else #ifdef CONFIG_DEBUG_LOCK_ALLOC */
> >  
> >  #ifdef CONFIG_PROVE_RCU
> > diff --git a/kernel/rcu/Kconfig.debug b/kernel/rcu/Kconfig.debug
> > index 5ec3ea4028e2..7fbd21dbfcd0 100644
> > --- a/kernel/rcu/Kconfig.debug
> > +++ b/kernel/rcu/Kconfig.debug
> > @@ -8,6 +8,17 @@ menu "RCU Debugging"
> >  config PROVE_RCU
> >  	def_bool PROVE_LOCKING
> >  
> > +config PROVE_RCU_LIST
> > +	bool "RCU list lockdep debugging"
> > +	depends on PROVE_RCU
> 
> This must also depend on RCU_EXPERT.  

Sure.

> > +	default n
> > +	help
> > +	  Enable RCU lockdep checking for list usages. By default it is
> > +	  turned off since there are several list RCU users that still
> > +	  need to be converted to pass a lockdep expression. To prevent
> > +	  false-positive splats, we keep it default disabled but once all
> > +	  users are converted, we can remove this config option.
> > +
> >  config TORTURE_TEST
> >  	tristate
> >  	default n
> > diff --git a/kernel/rcu/update.c b/kernel/rcu/update.c
> > index 9dd5aeef6e70..b7a4e3b5fa98 100644
> > --- a/kernel/rcu/update.c
> > +++ b/kernel/rcu/update.c
> > @@ -91,14 +91,18 @@ module_param(rcu_normal_after_boot, int, 0);
> >   * Similarly, we avoid claiming an SRCU read lock held if the current
> >   * CPU is offline.
> >   */
> > +#define rcu_read_lock_held_common()		\
> > +	if (!debug_lockdep_rcu_enabled())	\
> > +		return 1;			\
> > +	if (!rcu_is_watching())			\
> > +		return 0;			\
> > +	if (!rcu_lockdep_current_cpu_online())	\
> > +		return 0;
> 
> Nice abstraction of common code!

Thanks!

