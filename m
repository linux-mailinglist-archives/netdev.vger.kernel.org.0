Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2B482AAE8B
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 01:30:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728904AbgKIAad (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Nov 2020 19:30:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727929AbgKIAac (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Nov 2020 19:30:32 -0500
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0654AC0613CF;
        Sun,  8 Nov 2020 16:30:31 -0800 (PST)
Received: by mail-ed1-x542.google.com with SMTP id b9so6918708edu.10;
        Sun, 08 Nov 2020 16:30:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=JurcRPrcIia1xYhtooKFGvN+DdkV7N/wIh6mdo97K14=;
        b=IzdyZ0+fc0iUE8Se9WFcRy0WUdixo3Pc9uCXryaWjBWkGFlvXCv2Xbhfb1Ql7QuHZJ
         hZDB179jrKUUwJ+rb5ragsDa7WK2EfvR/M++M2eEVvgV0Xt7QaS1MH8k5t25tjcscM+Z
         olJbe18AevzZqQreK7Mp4sie2Yqda/HnE2gBgrDL3edMEuD+zrwk/rff4s4slOiC9lyD
         Se8MhzS89KXk2MiNuUhxzMzChF/mMgeil29G5zuEu4zZ1SXoLAk0Qj8sEHbLqDmB3hpV
         TpKcmsculWjnzXQhlEQ3uIdWhDBCIsVh49ISU+6fi5hAbjjuPrsMDXtwFEysvKAlqWgc
         KRLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=JurcRPrcIia1xYhtooKFGvN+DdkV7N/wIh6mdo97K14=;
        b=NAmji1AnckHmLGxWIcbJCJk63jPVjETtmBkgBLj5BnONBcaQxQDlxAAz4rPyYLYT6X
         ioLJaa23U+utqcJxnzsZaUDN50k5V/HARCdYSFFPs27JBbLx2m9iXBZ3EXOFuysyG+qg
         r4jego8jKBoRXjo1wv6EGdVKhvl44GsCwNdD+y2uMXz+tWXY/DqPkZ2UQUPUrlcBlx1x
         jxsLjyQ6p8RCdGcTNXdRCwLHiAXA8U0B84Rb2DItbYy7XQix+aLMEn2dJ9j7TYpw0fv1
         ziqg51eKHcbTZuuJjSYy9Jg5UKJ/XT289mBZ9vJn8uNW24FJeCbExm7K9KmxPnxFQc0S
         xtwA==
X-Gm-Message-State: AOAM532MiyZySR7ujDi5oTtWHcdYikxIIBzyXABcy1pzjSNcMflEiL3E
        E4xU+DnIqsIsz51hAN2DIBs=
X-Google-Smtp-Source: ABdhPJz3uk1Z5FVc2QFPlKv4ULqqnn2X79C/vuvnthYqgPl+3KzwA+OG5g5C/HTEkLT/iQMeCuAlnw==
X-Received: by 2002:a05:6402:181a:: with SMTP id g26mr13436504edy.8.1604881829738;
        Sun, 08 Nov 2020 16:30:29 -0800 (PST)
Received: from skbuf ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id c3sm7500251edl.60.2020.11.08.16.30.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Nov 2020 16:30:29 -0800 (PST)
Date:   Mon, 9 Nov 2020 02:30:28 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     DENG Qingfang <dqfext@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>, linux-kernel@vger.kernel.org,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Marek Behun <marek.behun@nic.cz>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>
Subject: Re: [RFC PATCH net-next 3/3] net: dsa: listen for
 SWITCHDEV_{FDB,DEL}_ADD_TO_DEVICE on foreign bridge neighbors
Message-ID: <20201109003028.melbgstk4pilxksl@skbuf>
References: <20201108131953.2462644-1-olteanv@gmail.com>
 <20201108131953.2462644-4-olteanv@gmail.com>
 <CALW65jb+Njb3WkY-TUhsHh1YWEzfMcXoRAXshnT8ke02wc10Uw@mail.gmail.com>
 <20201108172355.5nwsw3ek5qg6z7yx@skbuf>
 <20201108235939.GC1417181@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201108235939.GC1417181@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 09, 2020 at 12:59:39AM +0100, Andrew Lunn wrote:
> On Sun, Nov 08, 2020 at 07:23:55PM +0200, Vladimir Oltean wrote:
> > On Sun, Nov 08, 2020 at 10:09:25PM +0800, DENG Qingfang wrote:
> > > Can it be turned off for switches that support SA learning from CPU?
> > 
> > Is there a good reason I would add another property per switch and not
> > just do it unconditionally?
> 
> Just throwing out ideas, i've no idea if they are relevant. I wonder
> if we can get into issues with fast ageing with a topology change?  We
> don't have too much control over the hardware. I think some devices
> just flush everything, or maybe just one port. So we have different
> life times for CPU port database entries and user port database
> entries?

A quick scan for "port_fast_age" did not find any implementers who do
not act upon the "port" argument.

> We might also run into bugs with flushing removing static database
> entries which should not be. But that would be a bug.

I can imagine that happening, when there are multiple bridges spanning a
DSA switch, each bridge also contains a "foreign" interface, and the 2
bridging domains service 2 stations that have the same MAC address. In
that case, since the fdb_add and fdb_del are not reference-counted on
the shared DSA CPU port, we would indeed trigger this bug.

I was on the fence on whether to include the reference counting patch I
have for host MDBs, and to make these addresses refcounted as well.
What do you think?

> Also, dumping the database might run into bugs since we have not had
> entries for the CPU port before.

I don't see what conditions can make this happen.

> We also need to make sure the static entries get removed correctly
> when a host moves. The mv88e6xxx will not replace a static entry with
> a dynamically learned one. It will probably rise an ATU violation
> interrupt that frames have come in the wrong port.

This is a good one. Currently every implementer of .port_fdb_add assumes
a static entry is what we want, but that is not the case here. We want
an entry that can expire or the switch can move it to a different port
when there is evidence that it's wrong. Should we add more arguments to
the API?

> What about switches which do not implement port_fdb_add? Do these
> patches at least do something sensible?

dsa_slave_switchdev_event
-> dsa_slave_switchdev_event_work
   -> dsa_port_fdb_add
      -> dsa_port_notify(DSA_NOTIFIER_FDB_ADD)
         -> dsa_switch_fdb_add
            -> if (!ds->ops->port_fdb_add) return -EOPNOTSUPP;
   -> an error is printed with dev_dbg, and
      dsa_fdb_offload_notify(switchdev_work) is not called.

On dsa_port_fdb_del error, there is also an attempt to call dev_close()
on error, but only on user ports, which the CPU port is not.

So, we do something almost sensible, but mostly by mistake it seems.

I think the simplest would be to simply avoid all this nonsense right
away in dsa_slave_switchdev_event:

diff --git a/net/dsa/slave.c b/net/dsa/slave.c
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -2188,6 +2188,9 @@ static int dsa_slave_switchdev_event(struct notifier_block *unused,
 			dp = p->dp->cpu_dp;
 		}
 
+		if (!dp->ds->ops->port_fdb_add || !dp->ds->ops->port_fdb_del)
+			return NOTIFY_DONE;
+
 		switchdev_work = kzalloc(sizeof(*switchdev_work), GFP_ATOMIC);
 		if (!switchdev_work)
 			return NOTIFY_BAD;
