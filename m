Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8752A6EAA7E
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 14:39:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232055AbjDUMjI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 08:39:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232012AbjDUMi7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 08:38:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1597AB77A
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 05:38:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9A6E165036
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 12:38:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C837DC433D2;
        Fri, 21 Apr 2023 12:38:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682080736;
        bh=w2ZG7c1Ez2SlwEH1DSCUu67QXabVDQ96BWHljhGIdCk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=QdWob22P1uEwuQvxR1AXq44d2L1mqMx1+F7X4z8nssfvf7N+HBkFJzHinQvavn3Je
         WmZY5HVU5bfFhguPCzfX/wrAX9nLb2kParz02a6+Q9ZsAjW1pGd78EjIPdMYM1tJAu
         jHmyRxC1+fLrhwnBDI29s7ognf/icLmxp/WYL5+7NeVthckHVYpbTqqq/e6HvF4F/l
         ZBQWcvXp6ARymkMc4sa7MNzuiu50WwPkn305dmhcWjw29yi6iLdvreL9DACTybh4+S
         W0yznHmBReYn85x9kZ9+v10hXMhmCWcwhSZP7JlCwpbjaFOvvd+svTzscBTnXhg2Vx
         XSGrLrVWSgaeA==
Date:   Fri, 21 Apr 2023 21:38:50 +0900
From:   Masami Hiramatsu (Google) <mhiramat@kernel.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, Steven Rostedt <rostedt@goodmis.org>,
        netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH net-next 0/2] DSA trace events
Message-Id: <20230421213850.5ca0b347e99831e534b79fe7@kernel.org>
In-Reply-To: <20230412095534.dh2iitmi3j5i74sv@skbuf>
References: <20230407141451.133048-1-vladimir.oltean@nxp.com>
        <d1e4a839-6365-44ef-b9ca-157a4c2d2180@lunn.ch>
        <20230412095534.dh2iitmi3j5i74sv@skbuf>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-10.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 12 Apr 2023 12:55:34 +0300
Vladimir Oltean <vladimir.oltean@nxp.com> wrote:

> On Wed, Apr 12, 2023 at 02:48:35AM +0200, Andrew Lunn wrote:
> > On Fri, Apr 07, 2023 at 05:14:49PM +0300, Vladimir Oltean wrote:
> > > This series introduces the "dsa" trace event class, with the following
> > > events:
> > > 
> > > $ trace-cmd list | grep dsa
> > > dsa
> > > dsa:dsa_fdb_add_hw
> > > dsa:dsa_mdb_add_hw
> > > dsa:dsa_fdb_del_hw
> > > dsa:dsa_mdb_del_hw
> > > dsa:dsa_fdb_add_bump
> > > dsa:dsa_mdb_add_bump
> > > dsa:dsa_fdb_del_drop
> > > dsa:dsa_mdb_del_drop
> > > dsa:dsa_fdb_del_not_found
> > > dsa:dsa_mdb_del_not_found
> > > dsa:dsa_lag_fdb_add_hw
> > > dsa:dsa_lag_fdb_add_bump
> > > dsa:dsa_lag_fdb_del_hw
> > > dsa:dsa_lag_fdb_del_drop
> > > dsa:dsa_lag_fdb_del_not_found
> > > dsa:dsa_vlan_add_hw
> > > dsa:dsa_vlan_del_hw
> > > dsa:dsa_vlan_add_bump
> > > dsa:dsa_vlan_del_drop
> > > dsa:dsa_vlan_del_not_found
> > > 
> > > These are useful to debug refcounting issues on CPU and DSA ports, where
> > > entries may remain lingering, or may be removed too soon, depending on
> > > bugs in higher layers of the network stack.
> > 
> > Hi Vladimir
> > 
> > I don't know anything about trace points. Should you Cc: 
> > 
> > Steven Rostedt <rostedt@goodmis.org> (maintainer:TRACING)
> > Masami Hiramatsu <mhiramat@kernel.org> (maintainer:TRACING)
> > 
> > to get some feedback from people who do?
> > 
> >    Andrew
> 
> I suppose I could.
> 
> Hi Steven, Masami, would you mind taking a look and letting me know
> if the trace API was used reasonably? The patches were merged as:
> https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/commit/?id=9538ebce88ffa074202d592d468521995cb1e714
> https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/commit/?id=02020bd70fa6abcb1c2a8525ce7c1500dd4f44a8
> but I can make incremental changes if necessary.

If the subsystem maintainers are OK for including this, it is OK.
But basically, since the event is exposed to userland and you may keep
these events maintained, you should carefully add the events.
If those are only for debugging (after debug, it will not be used
frequently), can you consider to use kprobe events?
'perf probe' command will also help you to trace local variables and
structure members as like gdb does.


Thank you,


-- 
Masami Hiramatsu (Google) <mhiramat@kernel.org>
