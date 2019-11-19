Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6E491028BB
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 16:58:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728226AbfKSP6c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 10:58:32 -0500
Received: from mail-qv1-f68.google.com ([209.85.219.68]:37942 "EHLO
        mail-qv1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727728AbfKSP6b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 10:58:31 -0500
Received: by mail-qv1-f68.google.com with SMTP id q19so8312693qvs.5
        for <netdev@vger.kernel.org>; Tue, 19 Nov 2019 07:58:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lca.pw; s=google;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1z5z/i+3LcTUqYQxh88HeAp06C7NWtljha+VhmnIoik=;
        b=q0/4rbRZzWyL2IQLLIRg9XxI7yVsxFhM0SqLGtUDlDWUnV4Cx9fQki4nQnyOu4FNdz
         MgQNxzZhvmeNQ4vxKWKJtCQDbUTdNBQ/xV4ZzzAuYYpG7kI4kzg88KFEjKB1OOop5/MM
         dmXWHVVk0f4IFEfTzJxC6wcIumqRKUt94xq2t5M1QrFtdREOzai+F5k09z+z/k7Jqu2c
         BbEiwmnIPaHiEI7Zt/2/+6F59OuFSlOgnOLvgDI/i2RqODvIB0JSGBdy0iHPtmZxlA3s
         3kg9/g+NZCqZF2g4heUVMqHBqHVmvfVaEeVCQXYnhyuzSasBKFdARpAUYdnI1+guGW/u
         oDwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1z5z/i+3LcTUqYQxh88HeAp06C7NWtljha+VhmnIoik=;
        b=FEj0YK4cWkDpfqxCihjUfHpuEee1nUL/Q/O5R0QVlQRdvZAO6WqHndjjbNx3Xd1JId
         /YdTKBarNgrYl3Aw3bivsVllbv6fGR1a5aNliaTJwjwOHmfI26b2W/aCyqL+1K/UZ6LU
         1OKFzJgSVJebgL/h/zM0tcRyVCQ5chxmgNpC2mZ8NMUyJih/2zFuoVZQvyTHKjEUkibr
         OX1xHfsVcfxWrves225xCKxS9AWkWNyefn4Ggq7VJ72Vp7ROyy45KGtV0YYyeoeDsDjp
         2GRqpdBMO0Z94rMB1Z6RSq5GqEiKMQhsdklRx/xu7ZkI5TPTRQQAR80tZwrRZhT674Em
         luaA==
X-Gm-Message-State: APjAAAXNcPCejjEwcSZUteEMbcU3J6d3W39TzdoEKR9zsiWylaC2CT5k
        /YAsT7B6aV+Xu1rxNjNK1SLW0w==
X-Google-Smtp-Source: APXvYqzQs4PHJxtGOjF5LF5GaxORkXbZEPYtAW8Ec/ZJQGupHFmldpVxF1PjfxTctBnYnLVlTTelSQ==
X-Received: by 2002:ad4:4dce:: with SMTP id cw14mr20727040qvb.185.1574179109802;
        Tue, 19 Nov 2019 07:58:29 -0800 (PST)
Received: from dhcp-41-57.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id i10sm11536583qtj.19.2019.11.19.07.58.28
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 19 Nov 2019 07:58:29 -0800 (PST)
Message-ID: <1574179107.9585.1.camel@lca.pw>
Subject: Re: [PATCH] net/skbuff: silence warnings under memory pressure
From:   Qian Cai <cai@lca.pw>
To:     Petr Mladek <pmladek@suse.com>,
        Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Michal Hocko <mhocko@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>, davem@davemloft.net,
        netdev@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Date:   Tue, 19 Nov 2019 10:58:27 -0500
In-Reply-To: <20191119094134.6hzbjc7l5ite6bpg@pathway.suse.cz>
References: <20190904065455.GE3838@dhcp22.suse.cz>
         <20190904071911.GB11968@jagdpanzerIV> <20190904074312.GA25744@jagdpanzerIV>
         <1567599263.5576.72.camel@lca.pw>
         <20190904144850.GA8296@tigerII.localdomain>
         <1567629737.5576.87.camel@lca.pw> <20190905113208.GA521@jagdpanzerIV>
         <1573751570.5937.122.camel@lca.pw>
         <20191118152738.az364dczadskgimc@pathway.suse.cz>
         <20191119004119.GC208047@google.com>
         <20191119094134.6hzbjc7l5ite6bpg@pathway.suse.cz>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.22.6 (3.22.6-10.el7) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2019-11-19 at 10:41 +0100, Petr Mladek wrote:
> On Tue 2019-11-19 09:41:19, Sergey Senozhatsky wrote:
> > On (19/11/18 16:27), Petr Mladek wrote:
> > > > > @@ -2027,8 +2027,11 @@ asmlinkage int vprintk_emit(int facility, int level,
> > > > >  	pending_output = (curr_log_seq != log_next_seq);
> > > > >  	logbuf_unlock_irqrestore(flags);
> > > > >  
> > > > > +	if (!pending_output)
> > > > > +		return printed_len;
> > > > > +
> > > > >  	/* If called from the scheduler, we can not call up(). */
> > > > > -	if (!in_sched && pending_output) {
> > > > > +	if (!in_sched) {
> > > > >  		/*
> > > > >  		 * Disable preemption to avoid being preempted while holding
> > > > >  		 * console_sem which would prevent anyone from printing to
> > > > > @@ -2043,10 +2046,11 @@ asmlinkage int vprintk_emit(int facility, int level,
> > > > >  		if (console_trylock_spinning())
> > > > >  			console_unlock();
> > > > >  		preempt_enable();
> > > > > -	}
> > > > >  
> > > > > -	if (pending_output)
> > > > > +		wake_up_interruptible(&log_wait);
> > > 
> > > I do not like this. As a result, normal printk() will always deadlock
> > > in the scheduler code, including WARN() calls. The chance of the
> > > deadlock is small now. It happens only when there is another
> > > process waiting for console_sem.
> > 
> > Why would it *always* deadlock? If this is the case, why we don't *always*
> > deadlock doing the very same wake_up_process() from console_unlock()?
> 
> I speak about _normal_ printk() and not about printk_deferred().
> 
> wake_up_process() is called in console_unlock() only when
> sem->wait_list is not empty, see up() in kernel/locking/semaphore.c.
> printk() itself uses console_trylock() and does not wait.
> 
> I believe that this is the rason why printk_sched() was added
> so late in 2012. It was more than 10 years after adding
> the semaphore into console_unlock(). IMHO, the deadlock
> was rare. Of course, it was also hard to debug but it
> would not take 10 years.

I would not be surprise that those potential deadlocks have been existed even
for 10 years. Not only that it is difficult to debug, but also when eventually
someone had reported them, subsystem developers could still "kick balls" like
where it had been observed for the last a few months, and no progress could be
done for those as eventually life is too short and the reporters have to give
up.
