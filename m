Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B557130AE47
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 18:46:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232313AbhBARp2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 12:45:28 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:36299 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229607AbhBARnI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Feb 2021 12:43:08 -0500
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.nyi.internal (Postfix) with ESMTP id 7BE0E5C014E;
        Mon,  1 Feb 2021 12:41:59 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Mon, 01 Feb 2021 12:41:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=MTDcHQ
        TsWuXtmV8ysfUn2XU/N9exN9G1OmWTIXEMS1w=; b=lwdf0Qi4seOd20llfWyW7K
        Vv1f63hY7mkBrrB4RYuWEjjn+EjHhg3Fyp1XR48A3WPCLTGnpMuzhO7S8v+T/2u0
        oE/GJ4fZCO2OeYTwmJj8Al0EBYw133OkGPz3jznvJ+LX9o4+0ze51pSkC7UOoL3L
        Fi+sp8LX1fd5jpJcpK+2lx/KNn+/qgm6cbwR/kNWTW3KfchUpMdl04mT6okHX/P7
        5nCP2QKU7QaXQvE/NPoBKPiGFQm73qMQsJ/qKpTKrvw8ePaCOEkp95KWLbGEH5GI
        f3yfrF7tDZ95T1thbVoH/rqjCG0BUeV9jOzOMDGbPdY/JaBmKld+7arrJ75W1TAA
        ==
X-ME-Sender: <xms:Zz0YYMM2MYupSqGVxcoCxp-VieuAWqC2BPVrZHgYkOGbar6RklGDrg>
    <xme:Zz0YYHRug66fOZGwOXrC4PozIu0HO67p_wvI3njNtSjofm7O3SMBVrTb_dpn7Xno7
    iTOFHcq3eYWH_w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfeekgddutdegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpedtffekkeefudffveegueejffejhfetgfeuuefgvedtieehudeuueekhfduheel
    teenucfkphepkeegrddvvdelrdduheefrdeggeenucevlhhushhtvghrufhiiigvpedtne
    curfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:Zz0YYCbytqkzmKHPYF9nrvCRHzX6tPsnd4ksDh2lUS_pGhxnUBpS9A>
    <xmx:Zz0YYM01TYH6Ftww-Z_bVWWv5eQz9fCc22IzrRJScDdAbyfPIX3A-g>
    <xmx:Zz0YYKUesP9SZFYIu_F_7V5uFkPSiGjdbbgVdjBbp67mJqpbemzr-Q>
    <xmx:Zz0YYFlBqbIVyUVXvJacd7RUSiShpOyfpYBxx3VRO2OY_4brGOd-2w>
Received: from localhost (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id AEC39108005B;
        Mon,  1 Feb 2021 12:41:58 -0500 (EST)
Date:   Mon, 1 Feb 2021 19:41:55 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Simon Horman <simon.horman@netronome.com>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>, netdev@vger.kernel.org,
        oss-drivers@netronome.com,
        Baowen Zheng <baowen.zheng@corigine.com>,
        Louis Peens <louis.peens@netronome.com>
Subject: Re: [PATCH RFC net-next] net/sched: act_police: add support for
 packet-per-second policing
Message-ID: <20210201174155.GA3454089@shredder.lan>
References: <20210125151819.8313-1-simon.horman@netronome.com>
 <20210128161933.GA3285394@shredder.lan>
 <20210201123116.GA25935@netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210201123116.GA25935@netronome.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 01, 2021 at 01:31:17PM +0100, Simon Horman wrote:
> On Thu, Jan 28, 2021 at 06:19:33PM +0200, Ido Schimmel wrote:
> > On Mon, Jan 25, 2021 at 04:18:19PM +0100, Simon Horman wrote:
> > > From: Baowen Zheng <baowen.zheng@corigine.com>
> > > 
> > > Allow a policer action to enforce a rate-limit based on packets-per-second,
> > > configurable using a packet-per-second rate and burst parameters. This may
> > > be used in conjunction with existing byte-per-second rate limiting in the
> > > same policer action.
> > 
> > Hi Simon,
> > 
> > Any reason to allow metering based on both packets and bytes at the same
> > action versus adding a mode (packets / bytes) parameter? You can then
> > chain two policers if you need to rate limit based on both. Something
> > like:
> > 
> > # tc filter add dev tap1 ingress pref 1 matchall \
> > 	action police rate 1000Mbit burst 128k conform-exceed drop/pipe \
> > 	action police pkts_rate 3000 pkts_burst 1000
> > 
> > I'm asking because the policers in the Spectrum ASIC are built that way
> > and I also don't remember seeing such a mixed mode online.
> 
> Hi Ido,
> 
> sorry for missing this email until you pointed it out to me in another
> thread.

Hi,

No problem. There were (are?) some issues with netdev mails lately.

> 
> We did consider this question during development and our conclusion was
> that it was useful as we do have use-cases which call for both to be used
> and it seems nice to allow lower layers to determine the order in which the
> actions are applied to satisfied the user's more general request for both -

The lower layer need to respect whatever is implemented in the software
data path, but with this approach it is not clear which limit is imposed
first. One needs to check act_police's code for that. With the more
discrete approach (two actions), user is in complete control.

There is also an issue of visibility into how many packets were dropped
due to which limit. With this approach both drops are squashed to the
same counter. In the hardware offload case, I assume this would entail
reading the drop counters of two different policers which might not be
atomic (at least on Spectrum).

> it should be no surprise that we plan to provide a hardware offload of this
> feature. 

Sure. I assumed this was the intention. With Netronome hardware, would
such an action be translated into two actions / two policers?

> It also seems to offer nice code re-use.

Yes, the diff is nice, but I do not think it would be much worse if rate
and bandwidth limiting were made to be mutually exclusive.

> We did also try to examine the performance impact of this change on
> existing use-cases and it appeared to be negligible/within noise of
> our measurements.
> 
> > > e.g.
> > > tc filter add dev tap1 parent ffff: u32 match \
> > >               u32 0 0 police pkts_rate 3000 pkts_burst 1000
> > > 
> > > Testing was unable to uncover a performance impact of this change on
> > > existing features.
> > > 
> > > Signed-off-by: Baowen Zheng <baowen.zheng@corigine.com>
> > > Signed-off-by: Simon Horman <simon.horman@netronome.com>
> > > Signed-off-by: Louis Peens <louis.peens@netronome.com>
> > > ---
> > >  include/net/sch_generic.h      | 15 ++++++++++++++
> > >  include/net/tc_act/tc_police.h |  4 ++++
> > >  include/uapi/linux/pkt_cls.h   |  2 ++
> > >  net/sched/act_police.c         | 37 +++++++++++++++++++++++++++++++---
> > >  net/sched/sch_generic.c        | 32 +++++++++++++++++++++++++++++
> > >  5 files changed, 87 insertions(+), 3 deletions(-)
> > 
> > The intermediate representation in include/net/flow_offload.h needs to
> > carry the new configuration so that drivers will be able to veto
> > unsupported configuration.
