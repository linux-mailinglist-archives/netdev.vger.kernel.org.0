Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8BDAAC1E7
	for <lists+netdev@lfdr.de>; Fri,  6 Sep 2019 23:17:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390876AbfIFVRg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Sep 2019 17:17:36 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:41508 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732588AbfIFVRg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Sep 2019 17:17:36 -0400
Received: by mail-qt1-f193.google.com with SMTP id j10so8807378qtp.8
        for <netdev@vger.kernel.org>; Fri, 06 Sep 2019 14:17:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lca.pw; s=google;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KH2KM3AxaNxDfikJW3s2OI5HLlEQIpgR2HO2RNdIwJQ=;
        b=lxuHvaTgGzySasvfmE+zrfBd04thDMbIuR5Ckmjnj0FASAFn3jzKRQkkMniznIHGuu
         HnvEB7JQQCYNEFYZcarpvD2SN6lVyaZMk3/7+08Bneq+FJcf21D2d85fkp3qc2eRI8Nv
         CS6bgUREEMFD5bcPzZKrzqRRoZwjMHTHGH6C5acZA0DNK6933vsozwjNvo4F6K6nlbD/
         ozB4KgdnDvHu+o6VfENxQTvLiXXfdhojPqmes3QqFXmfjzNFOOViIB3llNkhDWnEf0qJ
         EE3R4b0NMI4faEF6LHZjCG2cCCATP/GcjlWYmiIVLOlufKCGvpIVx0XybdceTvGBpLWr
         1Itg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KH2KM3AxaNxDfikJW3s2OI5HLlEQIpgR2HO2RNdIwJQ=;
        b=IfJ6uDwl3Y0ieY5m/S4EP1ARyR41zETGyxlCCOUBB6DS8Wn9OjmDGDeV3f3ttnonho
         Wnpp83zbKPTXf+iktk1nSX5lUSAX9rkddiBxb5m4cYXPP0VmNlCwyxrtSyEI1QYr88Ks
         dCX2DvkF37dDVmb8d262O+dod1slSHSvP+ch8eiTZOhHmX/OhfOIsZDYkEvrOve3oGJH
         j7RiWS7Jx3zqMFRgJWuVPmMNzkCrRnODdA3ljfUlnpPXE7UBUvuejeSaJQSSjJ08vmW1
         KTOfNqqEalRp1lAdwVg2f3aWFgN1eg9iCrwxsz8VU3qoJzC2Kv5M3u8uQ9ajDWomfiv2
         Zjdg==
X-Gm-Message-State: APjAAAWq/2BAECC48J2aI56qXqRef9tZV9jYFiULSmBVAUrafdLxuHuj
        LmbnJoQGkDDrpMT7nDfl89XMrg==
X-Google-Smtp-Source: APXvYqykWMJGC4WBJ7KYNk5n5eG2BjjJPxU8wawDh2GhocFTjSs4UJhyG5sFCP6hwBG0GPPCx3q5YQ==
X-Received: by 2002:ac8:2d2c:: with SMTP id n41mr11412578qta.335.1567804654971;
        Fri, 06 Sep 2019 14:17:34 -0700 (PDT)
Received: from dhcp-41-57.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id x33sm1049112qtd.79.2019.09.06.14.17.33
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 06 Sep 2019 14:17:34 -0700 (PDT)
Message-ID: <1567804651.5576.114.camel@lca.pw>
Subject: Re: [PATCH] net/skbuff: silence warnings under memory pressure
From:   Qian Cai <cai@lca.pw>
To:     Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Petr Mladek <pmladek@suse.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Michal Hocko <mhocko@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>, davem@davemloft.net,
        netdev@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Date:   Fri, 06 Sep 2019 17:17:31 -0400
In-Reply-To: <20190906043224.GA18163@jagdpanzerIV>
References: <20190904061501.GB3838@dhcp22.suse.cz>
         <20190904064144.GA5487@jagdpanzerIV> <20190904065455.GE3838@dhcp22.suse.cz>
         <20190904071911.GB11968@jagdpanzerIV> <20190904074312.GA25744@jagdpanzerIV>
         <1567599263.5576.72.camel@lca.pw>
         <20190904144850.GA8296@tigerII.localdomain>
         <1567629737.5576.87.camel@lca.pw> <20190905113208.GA521@jagdpanzerIV>
         <1567699393.5576.96.camel@lca.pw> <20190906043224.GA18163@jagdpanzerIV>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.22.6 (3.22.6-10.el7) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2019-09-06 at 13:32 +0900, Sergey Senozhatsky wrote:
> On (09/05/19 12:03), Qian Cai wrote:
> > > ---
> > > diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
> > > index cd51aa7d08a9..89cb47882254 100644
> > > --- a/kernel/printk/printk.c
> > > +++ b/kernel/printk/printk.c
> > > @@ -2027,8 +2027,11 @@ asmlinkage int vprintk_emit(int facility, int level,
> > >  	pending_output = (curr_log_seq != log_next_seq);
> > >  	logbuf_unlock_irqrestore(flags);
> > >  
> > > +	if (!pending_output)
> > > +		return printed_len;
> > > +
> > >  	/* If called from the scheduler, we can not call up(). */
> > > -	if (!in_sched && pending_output) {
> > > +	if (!in_sched) {
> > >  		/*
> > >  		 * Disable preemption to avoid being preempted while holding
> > >  		 * console_sem which would prevent anyone from printing to
> > > @@ -2043,10 +2046,11 @@ asmlinkage int vprintk_emit(int facility, int level,
> > >  		if (console_trylock_spinning())
> > >  			console_unlock();
> > >  		preempt_enable();
> > > -	}
> > >  
> > > -	if (pending_output)
> > > +		wake_up_interruptible(&log_wait);
> > > +	} else {
> > >  		wake_up_klogd();
> > > +	}
> > >  	return printed_len;
> > >  }
> > >  EXPORT_SYMBOL(vprintk_emit);
> > > ---
> 
> Qian Cai, any chance you can test that patch?

So far as good, but it is hard to tell if this really nail the issue down. I'll
leave it running over the weekend and report back if it occurs again.
