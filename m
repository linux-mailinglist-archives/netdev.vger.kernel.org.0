Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DFB94331E4
	for <lists+netdev@lfdr.de>; Mon,  3 Jun 2019 16:18:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727429AbfFCOSv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 10:18:51 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:44450 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726968AbfFCOSu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jun 2019 10:18:50 -0400
Received: by mail-pf1-f195.google.com with SMTP id t16so1886152pfe.11
        for <netdev@vger.kernel.org>; Mon, 03 Jun 2019 07:18:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=wino6sk3VdZE6+hAQNM1PvtsWBqO77h9pHog6R+saB4=;
        b=ILFGoBB8mLMqVVtS8/R/M5XmKpli9djqbjha1UCLJ1dh/6QP3UUReHWHDiD4kff4T7
         9/EuFMLCU7KEekS2AIMDnGtUJRZ7MQJimC/aYCot7tPs1eoHEET2YsyCOXT26R5TB610
         BnMntKUbojtA1j1WCh9KSm7cLhDJ39hgwOFSU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=wino6sk3VdZE6+hAQNM1PvtsWBqO77h9pHog6R+saB4=;
        b=bLHrpyICIa+Q4KimuA59kHD6ptogP12xTv+QSnNT1qLYTmW9SFiwZlBZUL6df//BmI
         H8hhoPxPkS1tpo1r2zohMwOzJ4eyEKg7gCazycMpwRQrcj8gMnjlGWa1Wf8SAjaH5XkS
         WRP+VB2hQd4LQHjTUXJZ7OWnYiMTnzoaXej4mMo1+yRmZab/LjLVOm4zq/R3y9bcL3XP
         enL0A9Av9fvBxkbDkqRTZz2N9infufuKxOjdkiIbWqUGf3c0RrvIjpQNiEEBiWD6XBrf
         ijDTNDid5pVhF0LWWkZowDRockpF/2ygnG6NngJcCsr3s9+98WrZ/pej4o54T1iHWhQn
         gHkA==
X-Gm-Message-State: APjAAAWYwjIIMIzOdNTEgBmF9iCiDfE2rvxkjx7uyZaacG7ReZ2tQpUn
        XIIj96ZfW9YkVv/LWsmIIn7+MQ==
X-Google-Smtp-Source: APXvYqyKAjR/D78/kGgs8thHzTfUR/LOLb5cBxjo6X/LlWYPb4MJB9cnaSwLt+1e5dELPHpdsRQU0Q==
X-Received: by 2002:a63:6157:: with SMTP id v84mr14697278pgb.36.1559571529472;
        Mon, 03 Jun 2019 07:18:49 -0700 (PDT)
Received: from localhost ([2620:15c:6:12:9c46:e0da:efbf:69cc])
        by smtp.gmail.com with ESMTPSA id d2sm13148346pfh.115.2019.06.03.07.18.48
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 03 Jun 2019 07:18:48 -0700 (PDT)
Date:   Mon, 3 Jun 2019 10:18:47 -0400
From:   Joel Fernandes <joel@joelfernandes.org>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     linux-kernel@vger.kernel.org,
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
        Steven Rostedt <rostedt@goodmis.org>,
        Tejun Heo <tj@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>
Subject: Re: [RFC 1/6] rcu: Add support for consolidated-RCU reader checking
Message-ID: <20190603141847.GA94186@google.com>
References: <20190601222738.6856-1-joel@joelfernandes.org>
 <20190601222738.6856-2-joel@joelfernandes.org>
 <20190603080128.GA3436@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190603080128.GA3436@hirez.programming.kicks-ass.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 03, 2019 at 10:01:28AM +0200, Peter Zijlstra wrote:
> On Sat, Jun 01, 2019 at 06:27:33PM -0400, Joel Fernandes (Google) wrote:
> > +#define list_for_each_entry_rcu(pos, head, member, cond...)		\
> > +	if (COUNT_VARGS(cond) != 0) {					\
> > +		__list_check_rcu_cond(0, ## cond);			\
> > +	} else {							\
> > +		__list_check_rcu();					\
> > +	}								\
> > +	for (pos = list_entry_rcu((head)->next, typeof(*pos), member);	\
> > +		&pos->member != (head);					\
> >  		pos = list_entry_rcu(pos->member.next, typeof(*pos), member))
> >  
> >  /**
> > @@ -621,7 +648,12 @@ static inline void hlist_add_behind_rcu(struct hlist_node *n,
> >   * the _rcu list-mutation primitives such as hlist_add_head_rcu()
> >   * as long as the traversal is guarded by rcu_read_lock().
> >   */
> > +#define hlist_for_each_entry_rcu(pos, head, member, cond...)		\
> > +	if (COUNT_VARGS(cond) != 0) {					\
> > +		__list_check_rcu_cond(0, ## cond);			\
> > +	} else {							\
> > +		__list_check_rcu();					\
> > +	}								\
> >  	for (pos = hlist_entry_safe (rcu_dereference_raw(hlist_first_rcu(head)),\
> >  			typeof(*(pos)), member);			\
> >  		pos;							\
> 
> 
> This breaks code like:
> 
> 	if (...)
> 		list_for_each_entry_rcu(...);
> 
> as they are no longer a single statement. You'll have to frob it into
> the initializer part of the for statement.

Thanks a lot for that. I fixed it as below (diff is on top of the patch):

If not for that '##' , I could have abstracted the whole if/else
expression into its own macro and called it from list_for_each_entry_rcu() to
keep it more clean.

---8<-----------------------

diff --git a/include/linux/rculist.h b/include/linux/rculist.h
index b641fdd9f1a2..cc742d294bb0 100644
--- a/include/linux/rculist.h
+++ b/include/linux/rculist.h
@@ -371,12 +372,15 @@ static inline void list_splice_tail_init_rcu(struct list_head *list,
  * as long as the traversal is guarded by rcu_read_lock().
  */
 #define list_for_each_entry_rcu(pos, head, member, cond...)		\
-	if (COUNT_VARGS(cond) != 0) {					\
-		__list_check_rcu_cond(0, ## cond);			\
-	} else {							\
-		__list_check_rcu();					\
-	}								\
-	for (pos = list_entry_rcu((head)->next, typeof(*pos), member);	\
+	for (								\
+	     ({								\
+		if (COUNT_VARGS(cond) != 0) {				\
+			__list_check_rcu_cond(0, ## cond);		\
+		} else {						\
+			__list_check_rcu_nocond();			\
+		}							\
+	      }),							\
+	     pos = list_entry_rcu((head)->next, typeof(*pos), member);	\
 		&pos->member != (head);					\
 		pos = list_entry_rcu(pos->member.next, typeof(*pos), member))
 
@@ -649,12 +653,15 @@ static inline void hlist_add_behind_rcu(struct hlist_node *n,
  * as long as the traversal is guarded by rcu_read_lock().
  */
 #define hlist_for_each_entry_rcu(pos, head, member, cond...)		\
-	if (COUNT_VARGS(cond) != 0) {					\
-		__list_check_rcu_cond(0, ## cond);			\
-	} else {							\
-		__list_check_rcu();					\
-	}								\
-	for (pos = hlist_entry_safe (rcu_dereference_raw(hlist_first_rcu(head)),\
+	for (								\
+	     ({								\
+		if (COUNT_VARGS(cond) != 0) {				\
+			__list_check_rcu_cond(0, ## cond);		\
+		} else {						\
+			__list_check_rcu_nocond();			\
+		}							\
+	     }),							\
+	     pos = hlist_entry_safe (rcu_dereference_raw(hlist_first_rcu(head)),\
 			typeof(*(pos)), member);			\
 		pos;							\
 		pos = hlist_entry_safe(rcu_dereference_raw(hlist_next_rcu(\
-- 
2.22.0.rc1.311.g5d7573a151-goog

