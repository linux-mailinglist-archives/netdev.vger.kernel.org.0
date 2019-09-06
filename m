Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B38E0AC0E8
	for <lists+netdev@lfdr.de>; Fri,  6 Sep 2019 21:51:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731421AbfIFTvl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Sep 2019 15:51:41 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:35866 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726462AbfIFTvk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Sep 2019 15:51:40 -0400
Received: by mail-pf1-f193.google.com with SMTP id y22so5237879pfr.3;
        Fri, 06 Sep 2019 12:51:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=eGYgkRZj0NcCUP7h3iCHHFaAC43wNkWYu1G5sWIpzZk=;
        b=dPHHuipONUA43OXAQtslB0Nstvm9jMsRi2Xwq5hH50w+aW+QvRYutnw/fm+ZG7i0Uh
         DN6bxh04bPtnh8H+Jckkkjt4tqsrPRncv8LEM/2gGHj3+qgg1UfQcoX+NCedbCemX2hf
         4pPzfsgB+v74/bibFiX73cVqf4tuH5FLNbguQx/Q9kKkjKrICJwZQoTaocu/szf93MIG
         2lt4YqC8QUHBNGVldvYf3HiwJK+S5FJD4dDZozPpjAoh3EhBHkaSGy5yErN0Yiy3xoV4
         fL9Lae/0xrXM1b2WJpTV85MiqBJnBZVNqs+EIjH4ORfj2WDZz5fD77nv4S9gbuWKmMtq
         4tXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=eGYgkRZj0NcCUP7h3iCHHFaAC43wNkWYu1G5sWIpzZk=;
        b=pM/zZqd4c2lZbg9IMX9O5ZAofFFJswtj55o2+i3KA8Uylyose98mURroklCX4Jb4//
         R1yIJmz3/ZsFWG6Fc/ecRH8yHN2za5o1tsRc39EYlHQbvvYbhIjzDtsAQ24r2vK8DoJY
         hE2aTboIp+9dnFl7jIOKgimQBUoU/qufkBBKBytBlMR+B1u5iM0wvJq1tB8DKjnGnvIt
         U5mpeQxCTe2Z/gNlN2mE3hpFZXxuAbUwx8n2RWZV52UMuHNpiz4mJM3CUM2nnpS0+vAC
         ScU1E/b5DJ/nZKRz6oh7dvH2E/DOGc0W9IvTeFOVTgoGBLwLM70U+PWYuTLoN04k+q2s
         68Qw==
X-Gm-Message-State: APjAAAXXjnDboY2pYWDUk+jGHTYdI/61JWUw3UgZ6cqJpj9cbKJWCKZw
        O/8MqurgPrCWNrxdHgKsTdg=
X-Google-Smtp-Source: APXvYqxeaSSe8RWvGTP+Hhm0gpdZ9DLJYGvzAcdEP1AdGCDSVlIYbrpuZpy0V2v4ywX7STgoWPxd+A==
X-Received: by 2002:a63:30c6:: with SMTP id w189mr9157795pgw.398.1567799499643;
        Fri, 06 Sep 2019 12:51:39 -0700 (PDT)
Received: from localhost ([121.137.63.184])
        by smtp.gmail.com with ESMTPSA id q4sm7413899pfh.115.2019.09.06.12.51.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Sep 2019 12:51:38 -0700 (PDT)
From:   Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
X-Google-Original-From: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Date:   Sat, 7 Sep 2019 04:51:35 +0900
To:     Petr Mladek <pmladek@suse.com>
Cc:     Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>, Qian Cai <cai@lca.pw>,
        davem@davemloft.net, Eric Dumazet <eric.dumazet@gmail.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Michal Hocko <mhocko@kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] net/skbuff: silence warnings under memory pressure
Message-ID: <20190906195135.GA69785@tigerII.localdomain>
References: <20190904061501.GB3838@dhcp22.suse.cz>
 <20190904064144.GA5487@jagdpanzerIV>
 <20190904065455.GE3838@dhcp22.suse.cz>
 <20190904071911.GB11968@jagdpanzerIV>
 <20190904074312.GA25744@jagdpanzerIV>
 <1567599263.5576.72.camel@lca.pw>
 <20190904144850.GA8296@tigerII.localdomain>
 <1567629737.5576.87.camel@lca.pw>
 <20190905113208.GA521@jagdpanzerIV>
 <20190906145533.4uw43a5pvsawmdov@pathway.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190906145533.4uw43a5pvsawmdov@pathway.suse.cz>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On (09/06/19 16:55), Petr Mladek wrote:
> > I think we can queue significantly much less irq_work-s from printk().
> > 
> > Petr, Steven, what do you think?
> > 
> > Something like this. Call wake_up_interruptible(), switch to
> > wake_up_klogd() only when called from sched code.
> 
> Replacing irq_work_queue() with wake_up_interruptible() looks
> dangerous to me.
> 
> As a result, all "normal" printk() calls from the scheduler
> code will deadlock. There is almost always a userspace
> logger registered.

I don't see why all printk()-s should deadlock.

A "normal" printk() call will deadlock only when scheduler calls
"normal" printk() under rq or pi locks. But this is illegal anyway,
because console_sem up() calls wake_up_process() - the same function
wake_up_interruptible() calls. IOW "normal" printk() calls from
scheduler end up in scheduler, via console_sem->sched chain. We
already execute wake_up_process()->try_to_wake_up() in printk(),
even when a non-LOGLEVEL_SCHED printk() comes from scheduler.

What am I missing something?

	-ss
