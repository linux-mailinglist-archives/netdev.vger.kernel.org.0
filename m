Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7173A6186A3
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 18:52:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231736AbiKCRwr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 13:52:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230473AbiKCRwq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 13:52:46 -0400
Received: from wout1-smtp.messagingengine.com (wout1-smtp.messagingengine.com [64.147.123.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08E64B4E;
        Thu,  3 Nov 2022 10:52:45 -0700 (PDT)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id 461D93200805;
        Thu,  3 Nov 2022 13:52:43 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Thu, 03 Nov 2022 13:52:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; t=1667497962; x=1667584362; bh=/jl6iy49gLxL3OPiwyn4XeKNHfG6
        xbi+bJ/ciZbyZA8=; b=QGP52SJRBMNSAg3g5OYqX4Egb+NRp6yOkpi+D2ZDl2jr
        quA3BWYUowucf+XGBHEAfQ58WFvh5hDpvnRqkT84mIgSI1/KL0z2E4Pm+mZqo1Ls
        Ot3s6pmaVI6OzFOmCaXVEdJysEN7mmW8g/xU7gutqJkCnZosDd3WGco/aP7m2JZR
        B9gVNoW8armmum6yRew1EUOxS8rKH+0C3yJ+Zst6JcU1eHrRbQ81JY+snyDf1qiL
        7psccSKpzKAxBTFBfuKhqGFJE0OpUDttqWlkKblFWZG44Rcub944ABvFu4Po/TZi
        7P6KZbY+alCJbaRjR2Q2TOOMRQCJqhFyjtsI2n0Zhw==
X-ME-Sender: <xms:6f9jY-vLKWKGirAscceibg1va3_4zvlzOnrPbo4WzBzgBkfntRpV2A>
    <xme:6f9jYzcRm2etw4Vhm1POJunQoXMjhKObO7HRcUDLiBpCWOW37ldtkuf0hzFe9zXRe
    QplfLYfxh_Lv4Q>
X-ME-Received: <xmr:6f9jY5wWkvYKfzKNKw60TsVqSTY9ywyB8hZ-riP_nbmG8G6ycpoowfVszaVeNgsostXhSLj6QWVJFPEO7DGPffzqjUWavA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvgedrudelgddutdduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcu
    ufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrth
    htvghrnhepvddufeevkeehueegfedtvdevfefgudeifeduieefgfelkeehgeelgeejjeeg
    gefhnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepih
    guohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:6f9jY5M0N6EI6kyCV5XwpfaOLIObBDFjuh2HHqapPSfHGczBu5HUgA>
    <xmx:6f9jY-84hWs54ecc36CR4gOoqpfhsTo-F2x2B-1argPcFn_J-5gtkA>
    <xmx:6f9jYxWUGrj1ObH3jwX_PJHfrgnVQsfcRexpYfnUv8LsAgRIVzmqkQ>
    <xmx:6v9jYweBDjkIUBwIp4-Wee-Yg9sQRZCPa2alWJsTLPXA3-Y7nstNUQ>
Feedback-ID: i494840e7:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 3 Nov 2022 13:52:40 -0400 (EDT)
Date:   Thu, 3 Nov 2022 19:52:31 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Roman Gushchin <roman.gushchin@linux.dev>,
        Andrew Lunn <andrew@lunn.ch>,
        Andy Ren <andy.ren@getcruise.com>, netdev@vger.kernel.org,
        richardbgobert@gmail.com, davem@davemloft.net,
        wsa+renesas@sang-engineering.com, edumazet@google.com,
        petrm@nvidia.com, pabeni@redhat.com, corbet@lwn.net,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <sthemmin@microsoft.com>
Subject: Re: [PATCH net-next v2] netconsole: Enable live renaming for network
 interfaces used by netconsole
Message-ID: <Y2P/33wfWmQ/xC3n@shredder>
References: <20221102002420.2613004-1-andy.ren@getcruise.com>
 <Y2G+SYXyZAB/r3X0@lunn.ch>
 <20221101204006.75b46660@kernel.org>
 <Y2KlfhfijyNl8yxT@P9FQF9L96D.corp.robot.car>
 <20221102125418.272c4381@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221102125418.272c4381@kernel.org>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 02, 2022 at 12:54:18PM -0700, Jakub Kicinski wrote:
> On Wed, 2 Nov 2022 10:14:38 -0700 Roman Gushchin wrote:
> > > Agreed. BTW I wonder if we really want to introduce a netconsole
> > > specific uAPI for this or go ahead with something more general.  
> > 
> > Netconsole is a bit special because it brings an interface up very early.
> > E.g. in our case without the netconsole the renaming is happening before
> > the interface is brought up.
> > 
> > I wonder if the netconsole-specific flag should allow renaming only once.
> >  
> > > A sysctl for global "allow UP rename"?  
> > 
> > This will work for us, but I've no idea what it will break for other users
> > and how to check it without actually trying to break :) And likely we won't
> > learn about it for quite some time, asssuming they don't run net-next.
> 
> Then again IFF_LIVE_RENAME_OK was added in 5.2 so quite a while back.
> 
> > > We added the live renaming for failover a while back and there were 
> > > no reports of user space breaking as far as I know. So perhaps nobody
> > > actually cares and we should allow renaming all interfaces while UP?
> > > For backwards compat we can add a sysctl as mentioned or a rtnetlink 
> > > "I know what I'm doing" flag? 
> > > 
> > > Maybe print an info message into the logs for a few releases to aid
> > > debug?
> > > 
> > > IOW either there is a reason we don't allow rename while up, and
> > > netconsole being bound to an interface is immaterial. Or there is 
> > > no reason and we should allow all.  
> > 
> > My understanding is that it's not an issue for the kernel, but might be
> > an issue for some userspace apps which do not expect it.
> 
> There are in-kernel notifier users which could cache the name on up /
> down. But yes, the user space is the real worry.
> 
> > If you prefer to go with the 'global sysctl' approach, how the path forward
> > should look like?
> 
> That's the question. The sysctl would really just be to cover our back
> sides, and be able to tell the users "you opted in by setting that
> sysctl, we didn't break backward compat". But practically speaking, 
> its a different entity that'd be flipping the sysctl (e.g. management
> daemon) and different entity that'd be suffering (e.g. routing daemon).
> So the sysctl doesn't actually help anyone :/
> 
> So maybe we should just risk it and wonder about workarounds once
> complains surface, if they do. Like generate fake down/up events.
> Or create some form of "don't allow live renames now" lock-like
> thing a process could take.
> 
> Adding a couple more CCs and if nobody screams at us I vote we just
> remove the restriction instead of special casing.

Tried looking at history.git to understand the reasoning behind this
restriction. I guess it's because back then it was only possible via
IOCTL and user space wouldn't be notified about such a change. Nowadays
user space gets a notification regardless of the administrative state of
the netdev (see rtnetlink_event()). At least in-kernel listeners to
NETDEV_CHANGENAME do not seem to care if the netdev is administratively
up or not. So, FWIW, the suggested approach sounds sane to me.
