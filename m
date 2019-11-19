Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA92910104F
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 01:41:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726994AbfKSAlY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 19:41:24 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:40585 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726809AbfKSAlY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Nov 2019 19:41:24 -0500
Received: by mail-pg1-f194.google.com with SMTP id e17so3085690pgd.7;
        Mon, 18 Nov 2019 16:41:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=VhycBUBk52oH8Q0uHteGPnTBWRxOGi22wCEAjXZ7q4E=;
        b=OGvEwx/jF362jbt4QLy5C+CcKvcX+0Luf/w7YPOfsos8KP0iPO0vnuavA1+DVlgJAb
         AIg7Bcx0KOYMvTRFdnMquBjqp7aO37bpWiJHuKgT6XDnCxGHh5ZVmrN6/t4Nc3mJUaa8
         w4kItdPmwcrkV6r4phzeYVwyM0SZ1B6DzdEL2KCv6IjlxkMRjmKJBeFTKrMm9JMJHiB2
         WB2/lIwCum5Tjljuho//j8iXsMjYuPE30xjEnpzn0yNtVGQmB1wCR/hb5FZ4hEEe5bTk
         jjXWk1KNBbhDRwqrwSz8P30uFW5DNxLS4DVP6/2+e0CFJUs8/spedCQwgozx65+E2Ans
         1e4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=VhycBUBk52oH8Q0uHteGPnTBWRxOGi22wCEAjXZ7q4E=;
        b=pNd/YCT+b7lWsJ14XL1Nhi4TbO6Q4WCEqni4RFHJEWCnP0Q23EnpqaZ5hr2QcOaQnd
         +nicvQxxASDTO5PZrUYNw5LozGmnFyswUu0Z3/UO8aHT9pxlPPX+hakzzr4iuJEAg9lc
         WnreFdjvHz3QjGowaX1R9unDFI+tcM0NaYaIJHHyFInvmAgOJuN9DFVQYlvjINA+tu6Q
         PhZPRZUE3/1A8eEAiQxwQqiTkgRsVQcrVgCXsSpV3qryFHBCx1ZmuQJ5u6Id1j0HhIuj
         KDkYXwPhrPaayGcghowjM5JX5HPiTqLZJdZ3GC6jKmoJJe36gKzDCWgaxcBztZoSWGm3
         C2vA==
X-Gm-Message-State: APjAAAXO2eSEN3UEg6ED3wKxtGq98KEavTb6C7qPnxaHKNLgxil6oTAj
        +LHPJIaQz+FkWw27JAL00dw=
X-Google-Smtp-Source: APXvYqx7cbZwsqcAnJabZDyjIHRiMhmcgRkk02vYONsF9R0zMO8Je0yZdAJHIWWVaDzyxZo1pD4xrg==
X-Received: by 2002:a63:1c5c:: with SMTP id c28mr2288735pgm.241.1574124083207;
        Mon, 18 Nov 2019 16:41:23 -0800 (PST)
Received: from localhost ([2401:fa00:8f:203:250d:e71d:5a0a:9afe])
        by smtp.gmail.com with ESMTPSA id h2sm4281561pgj.45.2019.11.18.16.41.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Nov 2019 16:41:21 -0800 (PST)
Date:   Tue, 19 Nov 2019 09:41:19 +0900
From:   Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
To:     Petr Mladek <pmladek@suse.com>
Cc:     Qian Cai <cai@lca.pw>,
        Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Michal Hocko <mhocko@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>, davem@davemloft.net,
        netdev@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/skbuff: silence warnings under memory pressure
Message-ID: <20191119004119.GC208047@google.com>
References: <20190904064144.GA5487@jagdpanzerIV>
 <20190904065455.GE3838@dhcp22.suse.cz>
 <20190904071911.GB11968@jagdpanzerIV>
 <20190904074312.GA25744@jagdpanzerIV>
 <1567599263.5576.72.camel@lca.pw>
 <20190904144850.GA8296@tigerII.localdomain>
 <1567629737.5576.87.camel@lca.pw>
 <20190905113208.GA521@jagdpanzerIV>
 <1573751570.5937.122.camel@lca.pw>
 <20191118152738.az364dczadskgimc@pathway.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191118152738.az364dczadskgimc@pathway.suse.cz>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On (19/11/18 16:27), Petr Mladek wrote:
> > > @@ -2027,8 +2027,11 @@ asmlinkage int vprintk_emit(int facility, int level,
> > >  	pending_output = (curr_log_seq != log_next_seq);
> > >  	logbuf_unlock_irqrestore(flags);
> > >  
> > > +	if (!pending_output)
> > > +		return printed_len;
> > > +
> > >  	/* If called from the scheduler, we can not call up(). */
> > > -	if (!in_sched && pending_output) {
> > > +	if (!in_sched) {
> > >  		/*
> > >  		 * Disable preemption to avoid being preempted while holding
> > >  		 * console_sem which would prevent anyone from printing to
> > > @@ -2043,10 +2046,11 @@ asmlinkage int vprintk_emit(int facility, int level,
> > >  		if (console_trylock_spinning())
> > >  			console_unlock();
> > >  		preempt_enable();
> > > -	}
> > >  
> > > -	if (pending_output)
> > > +		wake_up_interruptible(&log_wait);
> 
> I do not like this. As a result, normal printk() will always deadlock
> in the scheduler code, including WARN() calls. The chance of the
> deadlock is small now. It happens only when there is another
> process waiting for console_sem.

Why would it *always* deadlock? If this is the case, why we don't *always*
deadlock doing the very same wake_up_process() from console_unlock()?

	-ss
