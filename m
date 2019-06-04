Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C653B34F4A
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 19:48:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726406AbfFDRsG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 13:48:06 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:38718 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726293AbfFDRsG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 13:48:06 -0400
Received: by mail-pf1-f194.google.com with SMTP id a186so12425380pfa.5
        for <netdev@vger.kernel.org>; Tue, 04 Jun 2019 10:48:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=WO/pU2tXKcWaOz/Mz8XljUSgZVyxjPQIhAnHQSTWhKk=;
        b=xswXLDjNe6Jf8a386sadmYdZwL+QReS4MtQ+UfRYLrhTIRzkvqzQ03azY36uhAFiZ6
         VUlZKPeFui2lSXPN/A1Ld5L6ikHcGCXM0hfmX2/Daawvc4dvYRdpTQNj2TB11YyjMros
         4yJDUHelpg3r8bdjufBbLRnEpioOFwufDjlJU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=WO/pU2tXKcWaOz/Mz8XljUSgZVyxjPQIhAnHQSTWhKk=;
        b=nmzSnLweJvinKvVcGDaBJoyco2t5BCBO37fKqrmNNueEmHAz5L1XT8fTP8+4KNMpiW
         T8T4hhj5t8DTsCfmzlWw4UQBCFK/cmmTidIToWs9DkO8NVQhe2unVLgSW7WiBYkdYXFu
         19oNJsy6mU8ka79Og8lDIuDsImupJ2OqJEFgJFmmYeD3iFChxsnUe8s69pcCCzhQ/uR3
         Thc8a1f72vPiSsdbxAKsMFr+aU8tGfPHvSMDG6+GSVkb8S0WNt/5s5ZYaEA1ZYLYnkRR
         m9tWqt1X3ev0HgCqVY7x2RouGMC3j2PxbGgEL+FgnF69HC+GZm795qnSdNWL1R38ZB1H
         ECvw==
X-Gm-Message-State: APjAAAXj1mm0BUT5cguYzIhrAGvqND9Os6G+ndCPNG9ZrHBFGswk5gFa
        /9aGvwDUgFlvxSuj+FLpiPMr1w==
X-Google-Smtp-Source: APXvYqx8jMof6CsO9RKVykzVQR/GUv12PGEyjyOIN6xEEzRdygdf09yxJH05WCP0zIpQf4tWt1xQtQ==
X-Received: by 2002:a62:5487:: with SMTP id i129mr38037550pfb.68.1559670484899;
        Tue, 04 Jun 2019 10:48:04 -0700 (PDT)
Received: from localhost ([2620:15c:6:12:9c46:e0da:efbf:69cc])
        by smtp.gmail.com with ESMTPSA id v4sm24304610pff.45.2019.06.04.10.48.03
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 04 Jun 2019 10:48:03 -0700 (PDT)
Date:   Tue, 4 Jun 2019 13:48:02 -0400
From:   Joel Fernandes <joel@joelfernandes.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Borislav Petkov <bp@alien8.de>,
        "David S. Miller" <davem@davemloft.net>, edumazet@google.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Josh Triplett <josh@joshtriplett.org>, keescook@chromium.org,
        kernel-hardening@lists.openwall.com,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-pm@vger.kernel.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        neilb@suse.com, netdev@vger.kernel.org, oleg@redhat.com,
        "Paul E. McKenney" <paulmck@linux.ibm.com>,
        Pavel Machek <pavel@ucw.cz>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, rcu@vger.kernel.org,
        Tejun Heo <tj@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>
Subject: Re: [RFC 1/6] rcu: Add support for consolidated-RCU reader checking
Message-ID: <20190604174802.GB228607@google.com>
References: <20190601222738.6856-1-joel@joelfernandes.org>
 <20190601222738.6856-2-joel@joelfernandes.org>
 <20190603080128.GA3436@hirez.programming.kicks-ass.net>
 <20190603141847.GA94186@google.com>
 <20190604065358.73347ced@oasis.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190604065358.73347ced@oasis.local.home>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 04, 2019 at 06:53:58AM -0400, Steven Rostedt wrote:
> On Mon, 3 Jun 2019 10:18:47 -0400
> Joel Fernandes <joel@joelfernandes.org> wrote:
> 
> > On Mon, Jun 03, 2019 at 10:01:28AM +0200, Peter Zijlstra wrote:
> > > On Sat, Jun 01, 2019 at 06:27:33PM -0400, Joel Fernandes (Google) wrote:  
> > > > +#define list_for_each_entry_rcu(pos, head, member, cond...)		\
> > > > +	if (COUNT_VARGS(cond) != 0) {					\
> > > > +		__list_check_rcu_cond(0, ## cond);			\
> > > > +	} else {							\
> > > > +		__list_check_rcu();					\
> > > > +	}								\
> > > > +	for (pos = list_entry_rcu((head)->next, typeof(*pos), member);	\
> > > > +		&pos->member != (head);					\
> > > >  		pos = list_entry_rcu(pos->member.next, typeof(*pos), member))
> > > >  
> > > >  /**
> > > > @@ -621,7 +648,12 @@ static inline void hlist_add_behind_rcu(struct hlist_node *n,
> > > >   * the _rcu list-mutation primitives such as hlist_add_head_rcu()
> > > >   * as long as the traversal is guarded by rcu_read_lock().
> > > >   */
> > > > +#define hlist_for_each_entry_rcu(pos, head, member, cond...)		\
> > > > +	if (COUNT_VARGS(cond) != 0) {					\
> > > > +		__list_check_rcu_cond(0, ## cond);			\
> > > > +	} else {							\
> > > > +		__list_check_rcu();					\
> > > > +	}								\
> > > >  	for (pos = hlist_entry_safe (rcu_dereference_raw(hlist_first_rcu(head)),\
> > > >  			typeof(*(pos)), member);			\
> > > >  		pos;							\  
> > > 
> > > 
> > > This breaks code like:
> > > 
> > > 	if (...)
> > > 		list_for_each_entry_rcu(...);
> > > 
> > > as they are no longer a single statement. You'll have to frob it into
> > > the initializer part of the for statement.  
> > 
> > Thanks a lot for that. I fixed it as below (diff is on top of the patch):
> > 
> > If not for that '##' , I could have abstracted the whole if/else
> > expression into its own macro and called it from list_for_each_entry_rcu() to
> > keep it more clean.
> > 
> > ---8<-----------------------
> > 
> > diff --git a/include/linux/rculist.h b/include/linux/rculist.h
> > index b641fdd9f1a2..cc742d294bb0 100644
> > --- a/include/linux/rculist.h
> > +++ b/include/linux/rculist.h
> > @@ -371,12 +372,15 @@ static inline void list_splice_tail_init_rcu(struct list_head *list,
> >   * as long as the traversal is guarded by rcu_read_lock().
> >   */
> >  #define list_for_each_entry_rcu(pos, head, member, cond...)		\
> > -	if (COUNT_VARGS(cond) != 0) {					\
> > -		__list_check_rcu_cond(0, ## cond);			\
> > -	} else {							\
> > -		__list_check_rcu();					\
> > -	}								\
> > -	for (pos = list_entry_rcu((head)->next, typeof(*pos), member);	\
> > +	for (								\
> > +	     ({								\
> > +		if (COUNT_VARGS(cond) != 0) {				\
> > +			__list_check_rcu_cond(0, ## cond);		\
> > +		} else {						\
> > +			__list_check_rcu_nocond();			\
> > +		}							\
> > +	      }),							\
> 
> For easier to read I would do something like this:
> 
> #define check_rcu_list(cond)						\
> 	({								\
> 		if (COUNT_VARGS(cond) != 0)				\
> 			__list_check_rcu_cond(0, ## cond);		\
> 		else							\
> 			__list_check_rcu_nocond();			\
> 	})
> 
> #define list_for_each_entry_rcu(pos, head, member, cond...)		\
> 	for (check_rcu_list(cond),					\

Yes, already doing it this way as I replied to Peter here:
https://lore.kernel.org/patchwork/patch/1082846/#1278489

Thanks!

 - Joel


