Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F35E19CF5B
	for <lists+netdev@lfdr.de>; Fri,  3 Apr 2020 06:36:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730889AbgDCEgQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Apr 2020 00:36:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:41198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725851AbgDCEgQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 Apr 2020 00:36:16 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C5BAE2063A;
        Fri,  3 Apr 2020 04:36:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585888575;
        bh=byoj0iOToaAWYh4X7UpbWQ4AlmV82wfYO9qZNoc0RYE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=apdFQpotFUkLFwF5qUsjNWvcUM/JdCXWUdeUfs0qUNTeqGJOCzBVYk8bMzeeS76RZ
         jXxwZsd7nJvM0d3ah+89gw/8ezXbzYkTzrZgqyMD4iif+QMLrUAFaFcZ25kqxCinJJ
         Ew1RAWdzZzqOq16dw1U5FcdgBiwgvLKUfEd4hoog=
Date:   Fri, 3 Apr 2020 07:36:11 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        itayav@mellanox.com
Subject: Re: [PATCH net] net/sched: Don't print dump stack in event of
 transmission timeout
Message-ID: <20200403043611.GC80989@unreal>
References: <20200402152336.538433-1-leon@kernel.org>
 <20200402.180218.940555077368617365.davem@davemloft.net>
 <CAM_iQpWvkTTRwV5-tj1Hj_a8hG2X-udU0BG2VXDbukuKFeN=JA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAM_iQpWvkTTRwV5-tj1Hj_a8hG2X-udU0BG2VXDbukuKFeN=JA@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 02, 2020 at 09:30:15PM -0700, Cong Wang wrote:
> On Thu, Apr 2, 2020 at 6:02 PM David Miller <davem@davemloft.net> wrote:
> >
> > From: Leon Romanovsky <leon@kernel.org>
> > Date: Thu,  2 Apr 2020 18:23:36 +0300
> >
> > > In event of transmission timeout, the drivers are given an opportunity
> > > to recover and continue to work after some in-house cleanups.
> > >
> > > Such event can be caused by HW bugs, wrong congestion configurations
> > > and many more other scenarios. In such case, users are interested to
> > > get a simple  "NETDEV WATCHDOG ... " print, which points to the relevant
> > > netdevice in trouble.
> > >
> > > The dump stack printed later was added in the commit b4192bbd85d2
> > > ("net: Add a WARN_ON_ONCE() to the transmit timeout function") to give
> > > extra information, like list of the modules and which driver is involved.
> > >
> > > While the latter is already printed in "NETDEV WATCHDOG ... ", the list
> > > of modules rarely needed and can be collected later.
> > >
> > > So let's remove the WARN_ONCE() and make dmesg look more user-friendly in
> > > large cluster setups.
> >
> > Software bugs play into these situations and on at least two or three
> > occasions I know that the backtrace hinted at the cause of the bug.
> >
>
> I don't see how a timer stack trace could help to debug this issue
> in any scenario, the messages out of this stack trace are indeed
> helpful.
>
> On the other hand, a stack trace does help to get some attention
> via ABRT, but at least for us we now use rasdaemon to capture
> this, so I am 100% fine to remove this stack trace.

Thanks

>
> Thanks.
