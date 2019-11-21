Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0EFD8104EF6
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 10:15:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727282AbfKUJPX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 04:15:23 -0500
Received: from mx2.suse.de ([195.135.220.15]:44446 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726132AbfKUJPX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Nov 2019 04:15:23 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 92B8CB11E;
        Thu, 21 Nov 2019 09:15:20 +0000 (UTC)
Date:   Thu, 21 Nov 2019 10:15:18 +0100
From:   Petr Mladek <pmladek@suse.com>
To:     Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Cc:     Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Qian Cai <cai@lca.pw>, Steven Rostedt <rostedt@goodmis.org>,
        Michal Hocko <mhocko@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>, davem@davemloft.net,
        netdev@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/skbuff: silence warnings under memory pressure
Message-ID: <20191121091518.vcohlxzsri2gv4p3@pathway.suse.cz>
References: <20190904144850.GA8296@tigerII.localdomain>
 <1567629737.5576.87.camel@lca.pw>
 <20190905113208.GA521@jagdpanzerIV>
 <1573751570.5937.122.camel@lca.pw>
 <20191118152738.az364dczadskgimc@pathway.suse.cz>
 <20191119004119.GC208047@google.com>
 <20191119094134.6hzbjc7l5ite6bpg@pathway.suse.cz>
 <20191120013005.GA3191@tigerII.localdomain>
 <20191120161334.p63723g4jyk6k7p3@pathway.suse.cz>
 <20191121010527.GB191121@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191121010527.GB191121@google.com>
User-Agent: NeoMutt/20170912 (1.9.0)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu 2019-11-21 10:05:27, Sergey Senozhatsky wrote:
> On (19/11/20 17:13), Petr Mladek wrote:
> [..]
> > It is the first time that I hear about problem caused by the
> > irq_work(). But we deal with deadlocks caused by wake_up() for years.
> > It would be like replacing a lightly dripping tap with a heavily
> > dripping one.
> > 
> > I see reports with WARN() from scheduler code from time to time.
> > I would get reports about silent death instead.
> 
> Just curious, how many of those WARN() come under rq lock or pi_lock?
> // this is real question

I guess that all SCHED_WARN_ON() would stop working.

I am not 100% sure but I think that all WARN_ON*() in
set_task_cpu(), finish_task_switch(), migrate_tasks()
are affected.

I have seen many reports with the WARN() from
native_smp_send_reschedule() about offline CPU.

Best Regards,
Petr
