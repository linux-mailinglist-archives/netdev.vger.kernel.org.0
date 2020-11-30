Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7DBA2C8DA8
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 20:04:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388258AbgK3TEc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 14:04:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387684AbgK3TEb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 14:04:31 -0500
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 428FEC0613CF
        for <netdev@vger.kernel.org>; Mon, 30 Nov 2020 11:03:51 -0800 (PST)
Received: by mail-ej1-x643.google.com with SMTP id lt17so23920009ejb.3
        for <netdev@vger.kernel.org>; Mon, 30 Nov 2020 11:03:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=NFMSkMtM0hdGsoed0E27t2Q2Zk5qzOyq5mYOVSO+rG8=;
        b=ihVV2/a5k1dpMTTnkwGCqyswRGT6cu0A9sYascR2hTjpsw2X+kgvt5kNzHel1o88rB
         To6koRGlExPNq+fAIkhL59pbh4jAK4YBTRvfir/PVCt7jur8WSyTybaEa4AC5kMdfj3C
         d5Bbt+OYxXihmkKk8JziVTjQZV1aQakm4CHcd+rLHzTTxFjvms7lX6bbIZuYfFDEoyfl
         QCrqUVrVuqcSSAZiJh/U5s1Ps7VtbeHrpjunLC6dshZtCuK/me6Gk0GYQEaKM1YbWW0U
         ZE3ssQqYe/LdoM/C5z2rfZRxwGXq+9BXRWyY2kONWKvZtV8zzvq1epJlmWpJpibNvopw
         uwcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=NFMSkMtM0hdGsoed0E27t2Q2Zk5qzOyq5mYOVSO+rG8=;
        b=MdabdBWIqEkYFbN7TXod03iRubB9ZZLLf1sLBs0v77as/kG50WXP09WcNehOENZkbv
         hV4mk0q2fbi8n12kotKdnfMvEa5MhoS+GvsTWfXDxSlAmfgTmKDz1ZGtNotHkz5eqxBP
         +y2VW2L7hUw7DqVitDWS+aCRTeAPoik1fZfoLdlWxw8wJNau8oW4RH5i3DEF+ySJsZJf
         LGik2E3Kle+NPv1h3cUcoYa47DRQliYoQujxsAkiBxlMxXhredIWIlr+Ih+8pj5nq//W
         9R98wOL8r8TAi1qrvinqWl3AzaNQ2DKzYPbKgCxLIen4O/1M259UpkUjJQTQP2rGgzOO
         osbQ==
X-Gm-Message-State: AOAM530FpG+XWSfzuwQ+2FUwOqoNzC9gM1GuGMmkkJffUhiSSMzPN182
        NltjLWt2oWLp1HIzwu9fKCc=
X-Google-Smtp-Source: ABdhPJx2JPxjOq/g8S0qxQJ/0hAO3mQTl29/fRrxo+LuJNYqohMl7psABMPoCmh5Y18FE4O21uZExA==
X-Received: by 2002:a17:906:6a45:: with SMTP id n5mr16299669ejs.514.1606763029924;
        Mon, 30 Nov 2020 11:03:49 -0800 (PST)
Received: from skbuf ([188.25.2.120])
        by smtp.gmail.com with ESMTPSA id b21sm208379edr.53.2020.11.30.11.03.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Nov 2020 11:03:49 -0800 (PST)
Date:   Mon, 30 Nov 2020 21:03:48 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        netdev <netdev@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Jiri Benc <jbenc@redhat.com>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: Correct usage of dev_base_lock in 2020
Message-ID: <20201130190348.ayg7yn5fieyr4ksy@skbuf>
References: <20201129182435.jgqfjbekqmmtaief@skbuf>
 <20201129205817.hti2l4hm2fbp2iwy@skbuf>
 <20201129211230.4d704931@hermes.local>
 <CANn89iKyyCwiKHFvQMqmeAbaR9SzwsCsko49FP+4NBW6+ZXN4w@mail.gmail.com>
 <20201130101405.73901b17@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
 <20201130184828.x56bwxxiwydsxt3k@skbuf>
 <b8136636-b729-a045-6266-6e93ba4b83f4@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b8136636-b729-a045-6266-6e93ba4b83f4@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 30, 2020 at 08:00:40PM +0100, Eric Dumazet wrote:
>
>
> On 11/30/20 7:48 PM, Vladimir Oltean wrote:
> > On Mon, Nov 30, 2020 at 10:14:05AM -0800, Jakub Kicinski wrote:
> >> On Mon, 30 Nov 2020 11:41:10 +0100 Eric Dumazet wrote:
> >>>> So dev_base_lock dates back to the Big Kernel Lock breakup back in Linux 2.4
> >>>> (ie before my time). The time has come to get rid of it.
> >>>>
> >>>> The use is sysfs is because could be changed to RCU. There have been issues
> >>>> in the past with sysfs causing lock inversions with the rtnl mutex, that
> >>>> is why you will see some trylock code there.
> >>>>
> >>>> My guess is that dev_base_lock readers exist only because no one bothered to do
> >>>> the RCU conversion.
> >>>
> >>> I think we did, a long time ago.
> >>>
> >>> We took care of all ' fast paths' already.
> >>>
> >>> Not sure what is needed, current situation does not bother me at all ;)
> >>
> >> Perhaps Vladimir has a plan to post separately about it (in that case
> >> sorry for jumping ahead) but the initial problem was procfs which is
> >> (hopefully mostly irrelevant by now, and) taking the RCU lock only
> >> therefore forcing drivers to have re-entrant, non-sleeping
> >> .ndo_get_stats64 implementations.
> >
> > Right, the end reason why I'm even looking at this is because I want to
> > convert all callers of dev_get_stats to use sleepable context and not
> > atomic. This makes it easier to gather statistics from devices that have
> > a firmware, or off-chip devices behind a slow bus like SPI.
> >
> > Like Jakub pointed out, some places call dev_get_stats while iterating
> > through the list of network interfaces - one would be procfs, but not
> > only. These callers are pure readers, so they use RCU protection. But
> > that gives us atomic context when calling dev_get_stats. The naive
> > solution is to convert all those callers to hold the RTNL mutex, which
> > is the writer-side protection for the network interface lists, and which
> > is sleepable. In fact I do have a series of 8 patches where I get that
> > done. But there are some weirder cases, such as the bonding driver,
> > where I need to do this:
> >
> > -----------------------------[cut here]-----------------------------
> > From 369a0e18a2446cda8ff52d72c02aa144ae6687ec Mon Sep 17 00:00:00 2001
> > From: Vladimir Oltean <vladimir.oltean@nxp.com>
> > Date: Mon, 30 Nov 2020 02:39:46 +0200
> > Subject: [PATCH] net: bonding: retrieve device statistics under RTNL, not RCU
> >
> > In the effort of making .ndo_get_stats64 be able to sleep, we need to
> > ensure the callers of dev_get_stats do not use atomic context.
> >
> > The bonding driver uses an RCU read-side critical section to ensure the
> > integrity of the list of network interfaces, because the driver iterates
> > through all net devices in the netns to find the ones which are its
> > configured slaves. We still need some protection against an interface
> > registering or deregistering, and the writer-side lock, the RTNL mutex,
> > is fine for that, because it offers sleepable context.
> >
> > We are taking the RTNL this way (checking for rtnl_is_locked first)
> > because the RTNL is not guaranteed to be held by all callers of
> > ndo_get_stats64, in fact there will be work in the future that will
> > avoid as much RTNL-holding as possible.
> >
> > Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> > ---
> >  drivers/net/bonding/bond_main.c | 18 +++++++-----------
> >  include/net/bonding.h           |  1 -
> >  2 files changed, 7 insertions(+), 12 deletions(-)
> >
> > diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
> > index e0880a3840d7..1d44534e95d2 100644
> > --- a/drivers/net/bonding/bond_main.c
> > +++ b/drivers/net/bonding/bond_main.c
> > @@ -3738,21 +3738,17 @@ static void bond_get_stats(struct net_device *bond_dev,
> >  			   struct rtnl_link_stats64 *stats)
> >  {
> >  	struct bonding *bond = netdev_priv(bond_dev);
> > +	bool rtnl_locked = rtnl_is_locked();
> >  	struct rtnl_link_stats64 temp;
> >  	struct list_head *iter;
> >  	struct slave *slave;
> > -	int nest_level = 0;
> >
> > +	if (!rtnl_locked)
> > +		rtnl_lock();
>
> Gosh, do not do that.
>
> Convert the bonding ->stats_lock to a mutex instead.
>
> Adding more reliance to RTNL is not helping cases where
> access to stats should not be blocked by other users of RTNL (which can be abused)

I can't, Eric. The bond_for_each_slave() macro needs protection against
net devices being registered and unregistered.
