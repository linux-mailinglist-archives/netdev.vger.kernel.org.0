Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 038E824A6AF
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 21:17:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726995AbgHSTRK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 15:17:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:58922 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726731AbgHSTRF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Aug 2020 15:17:05 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6B4592078D;
        Wed, 19 Aug 2020 19:17:03 +0000 (UTC)
Date:   Wed, 19 Aug 2020 15:17:01 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Jesse Brandeburg <jesse.brandeburg@intel.com>
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        linux- stable <stable@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        Masami Hiramatsu <masami.hiramatsu@linaro.org>,
        Leo Yan <leo.yan@linaro.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>, <lkft-triage@lists.linaro.org>,
        LTP List <ltp@lists.linux.it>
Subject: Re: NETDEV WATCHDOG: WARNING: at net/sched/sch_generic.c:442
 dev_watchdog
Message-ID: <20200819151701.747769ce@oasis.local.home>
In-Reply-To: <20200819102909.000016ac@intel.com>
References: <CA+G9fYtS_nAX=sPV8zTTs-nOdpJ4uxk9sqeHOZNuS4WLvBcPGg@mail.gmail.com>
        <20200819125732.1c296ce7@oasis.local.home>
        <20200819102909.000016ac@intel.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 19 Aug 2020 10:29:09 -0700
Jesse Brandeburg <jesse.brandeburg@intel.com> wrote:


> What I don't understand in the stack trace is this:
> > > [  107.654661] Call Trace:
> > > [  107.657735]  <IRQ>
> > > [  107.663155]  ? ftrace_graph_caller+0xc0/0xc0
> > > [  107.667929]  call_timer_fn+0x3b/0x1b0
> > > [  107.672238]  ? netif_carrier_off+0x70/0x70
> > > [  107.677771]  ? netif_carrier_off+0x70/0x70
> > > [  107.682656]  ? ftrace_graph_caller+0xc0/0xc0
> > > [  107.687379]  run_timer_softirq+0x3e8/0xa10
> > > [  107.694653]  ? call_timer_fn+0x1b0/0x1b0
> > > [  107.699382]  ? trace_event_raw_event_softirq+0xdd/0x150
> > > [  107.706768]  ? ring_buffer_unlock_commit+0xf5/0x210
> > > [  107.712213]  ? call_timer_fn+0x1b0/0x1b0
> > > [  107.716625]  ? __do_softirq+0x155/0x467  
> 
> 
> If the carrier was turned off by something, that could cause the stack
> to timeout since it appears the driver didn't call this itself after
> finishing all transmits like it normally would have.
> 
> Is the trace above correct? Usually the ? indicate unsure backtrace due
> to missing symbols, right?

The "?" means that there wasn't a stack frame to confirm that this was
the true call stack. What happens is that the scan of the stack will
look for any address in the stack that is for a function. If it finds
one, it will print it and add a "?" to that address. Basically, those
functions with the "?" are just addresses found in the stack but was not
part of a stack frame link.

-- Steve
