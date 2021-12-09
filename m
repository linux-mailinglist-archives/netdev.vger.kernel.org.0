Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67B5146F271
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 18:47:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241534AbhLIRvS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 12:51:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230002AbhLIRvS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Dec 2021 12:51:18 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35EC1C061746
        for <netdev@vger.kernel.org>; Thu,  9 Dec 2021 09:47:44 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id x10so4761553edd.5
        for <netdev@vger.kernel.org>; Thu, 09 Dec 2021 09:47:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:to:cc:subject:references:mime-version
         :content-disposition:in-reply-to;
        bh=vN6gd7Lg48ezwcTMXTgWLvg8TnvhVNZFdbDCJJrn8N8=;
        b=j26BFhCBr1+8CildLPsLPXLUaTAdzM3RgvQoSRpgVi9BF0kAbqjn0GJx9MG2pZrtyG
         aE4YnRdsQ9VDa5Wx6gV8Fl06mCxBgoWQYV7YgNazGtHrruOVMsySzBRQAbh28d+LnyhK
         vxTN1D5DcmWYIM2cXDBycCXGx1qpbbUIMdlv4b+0SNhExd0IgOI+px8b3FXFThsMs3UD
         y/9w2BYG0Tez5E62tP7eXS2hRUF2KRYwkODEET23Wb5u1uUhEvIePDagmRErz/Hif3lZ
         UFBqWXr6Ufu/JcH0t7NS8JnAxmjACeJMSLDSsWB+PmUBFRXuVcxkx7Wyfk+5FYbg2xOg
         31UA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:to:cc:subject:references
         :mime-version:content-disposition:in-reply-to;
        bh=vN6gd7Lg48ezwcTMXTgWLvg8TnvhVNZFdbDCJJrn8N8=;
        b=zbsBaqzN6THPmRGpV0jM9HhAC7WhX7VZVWluBsgHrczIhOlLli42u9MFJ3deyRa1mW
         ZN9jWsA0IFdDKKEG9T2K9XUoALHfnpikaNRzXJUh+++fqgyQAkm2rOJ4bFn6RWlQQNdU
         m8V4cWZIxJmMe0q+MP6Zr8qtKiJfPuVSfcECmhgy4EcKdHdBgd6qTYnJ+oqboXY8TNzF
         AHbz71LKHWODTRAcnWWqOeVZg8HS6zKrZGi0tR6W6bokuEh7Q/g+pDncJl/Ul7B+a+fJ
         6tUnDXmnWnnergBBrpjFN7xp7h23+AV5q1eApfEkCno7ua1NVX7N/yaNyb2f1GNp3nBH
         vdKQ==
X-Gm-Message-State: AOAM533hb8QplYo/FXuOU818oRrhgxhilRyA6PvG6YZ5wDQyq/69XRIC
        TDW8MQU4pX/7H7a2XLWJ9hQ=
X-Google-Smtp-Source: ABdhPJxOP6SeSVaIIHvG242Y4XPnct1BpQA4JXQNCWZ66yxugSFw6U93Y4xBr6riZ4UxB0efXoqDCQ==
X-Received: by 2002:a17:906:dc91:: with SMTP id cs17mr17382091ejc.461.1639071882006;
        Thu, 09 Dec 2021 09:44:42 -0800 (PST)
Received: from Ansuel-xps. (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.gmail.com with ESMTPSA id hq9sm241242ejc.119.2021.12.09.09.44.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Dec 2021 09:44:41 -0800 (PST)
Message-ID: <61b24089.1c69fb81.c8040.164b@mx.google.com>
X-Google-Original-Message-ID: <YbJAhjo/hVzRIIF2@Ansuel-xps.>
Date:   Thu, 9 Dec 2021 18:44:38 +0100
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [RFC PATCH net-next 0/7] DSA master state tracking
References: <20211208223230.3324822-1-vladimir.oltean@nxp.com>
 <61b17299.1c69fb81.8ef9.8daa@mx.google.com>
 <20211209142830.yh3j6gv7kskfif5w@skbuf>
 <61b21641.1c69fb81.d27e9.02a0@mx.google.com>
 <20211209173316.qkm5kuroli7nmtwd@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211209173316.qkm5kuroli7nmtwd@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 09, 2021 at 05:33:17PM +0000, Vladimir Oltean wrote:
> On Thu, Dec 09, 2021 at 03:44:14PM +0100, Ansuel Smith wrote:
> > On Thu, Dec 09, 2021 at 02:28:30PM +0000, Vladimir Oltean wrote:
> > > On Thu, Dec 09, 2021 at 04:05:59AM +0100, Ansuel Smith wrote:
> > > > On Thu, Dec 09, 2021 at 12:32:23AM +0200, Vladimir Oltean wrote:
> > > > > This patch set is provided solely for review purposes (therefore not to
> > > > > be applied anywhere) and for Ansuel to test whether they resolve the
> > > > > slowdown reported here:
> > > > > https://patchwork.kernel.org/project/netdevbpf/cover/20211207145942.7444-1-ansuelsmth@gmail.com/
> > > > > 
> > > > > It does conflict with net-next due to other patches that are in my tree,
> > > > > and which were also posted here and would need to be picked ("Rework DSA
> > > > > bridge TX forwarding offload API"):
> > > > > https://patchwork.kernel.org/project/netdevbpf/cover/20211206165758.1553882-1-vladimir.oltean@nxp.com/
> > > > > 
> > > > > Additionally, for Ansuel's work there is also a logical dependency with
> > > > > this series ("Replace DSA dp->priv with tagger-owned storage"):
> > > > > https://patchwork.kernel.org/project/netdevbpf/cover/20211208200504.3136642-1-vladimir.oltean@nxp.com/
> > > > > 
> > > > > To get both dependency series, the following commands should be sufficient:
> > > > > git b4 20211206165758.1553882-1-vladimir.oltean@nxp.com
> > > > > git b4 20211208200504.3136642-1-vladimir.oltean@nxp.com
> > > > > 
> > > > > where "git b4" is an alias in ~/.gitconfig:
> > > > > [b4]
> > > > > 	midmask = https://lore.kernel.org/r/%25s
> > > > > [alias]
> > > > > 	b4 = "!f() { b4 am -t -o - $@ | git am -3; }; f"
> > > > > 
> > > > > The patches posted here are mainly to offer a consistent
> > > > > "master_up"/"master_going_down" chain of events to switches, without
> > > > > duplicates, and always starting with "master_up" and ending with
> > > > > "master_going_down". This way, drivers should know when they can perform
> > > > > Ethernet-based register access.
> > > > > 
> > > > > Vladimir Oltean (7):
> > > > >   net: dsa: only bring down user ports assigned to a given DSA master
> > > > >   net: dsa: refactor the NETDEV_GOING_DOWN master tracking into separate
> > > > >     function
> > > > >   net: dsa: use dsa_tree_for_each_user_port in
> > > > >     dsa_tree_master_going_down()
> > > > >   net: dsa: provide switch operations for tracking the master state
> > > > >   net: dsa: stop updating master MTU from master.c
> > > > >   net: dsa: hold rtnl_mutex when calling dsa_master_{setup,teardown}
> > > > >   net: dsa: replay master state events in
> > > > >     dsa_tree_{setup,teardown}_master
> > > > > 
> > > > >  include/net/dsa.h  |  8 +++++++
> > > > >  net/dsa/dsa2.c     | 52 ++++++++++++++++++++++++++++++++++++++++++++--
> > > > >  net/dsa/dsa_priv.h | 11 ++++++++++
> > > > >  net/dsa/master.c   | 29 +++-----------------------
> > > > >  net/dsa/slave.c    | 32 +++++++++++++++-------------
> > > > >  net/dsa/switch.c   | 29 ++++++++++++++++++++++++++
> > > > >  6 files changed, 118 insertions(+), 43 deletions(-)
> > > > > 
> > > > > -- 
> > > > > 2.25.1
> > > > > 
> > > > 
> > > > I applied this patch and it does work correctly. Sadly the problem is
> > > > not solved and still the packet are not tracked correctly. What I notice
> > > > is that everything starts to work as soon as the master is set to
> > > > promiiscuous mode. Wonder if we should track that event instead of
> > > > simple up?
> > > > 
> > > > Here is a bootlog [0]. I added some log when the function timeouts and when
> > > > master up is actually called.
> > > > Current implementation for this is just a bool that is set to true on
> > > > master up and false on master going down. (final version should use
> > > > locking to check if an Ethernet transation is in progress)
> > > > 
> > > > [0] https://pastebin.com/7w2kgG7a
> > > 
> > > This is strange. What MAC DA do the ack packets have? Could you give us
> > > a pcap with the request and reply packets (not necessarily now)?
> > 
> > If you want I can give you a pcap from a router bootup to the setup with
> > no ethernet cable attached. I notice the switch sends some packet at the
> > bootup for some reason but they are not Ethernet mdio packet or other
> > type. It seems they are not even tagged (doesn't have qca tag) as the
> > header mode is disabled by default)
> > Let me know if you need just a pcap for the Ethernet mdio transaction or
> > from a bootup. I assume it would be better from a bootup? (they are not
> > tons of packet and the mdio Ethernet ones are easy to notice.)
> 
> Anything that contains some request and response packets should do, as
> long as they're relatively easy to spot. But as stated, this can wait
> for a while, I don't think that promiscuity is the issue, after your
> second reply.
>

Ok will send a pcap. Any preferred way to send it?

> > > Can you try to set ".promisc_on_master = true" in qca_netdev_ops?
> > 
> > I already tried and here [0] is a log. I notice with promisc_on_master
> > the "eth0 entered promiscuous mode" is missing. Is that correct?
> > Unless I was tired and misread the code, the info should be printed
> > anyway. Also looking at the comments for promisc_on_master I don't think
> > that should be applied to this tagger.
> > 
> > [0] https://pastebin.com/MN2ttVpr
> 
> It isn't missing, it's right there on line 11.

Oww didn't notice that!

> I think the problem is that we also need to track the operstate of the
> master (netif_oper_up via NETDEV_CHANGE) before declaring it as good to go.
> You can see that this is exactly the line after which the timeouts disappear:
> 
> [    7.146901] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
> 
> I didn't really want to go there, because now I'm not sure how to
> synthesize the information for the switch drivers to consume it.
> Anyway I've prepared a v2 patchset and I'll send it out very soon.

Wonder if we should leave the driver decide when it's ready by parsing
the different state? (And change
the up ops to something like a generic change?)

-- 
	Ansuel
