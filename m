Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C263763A4B2
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 10:20:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230113AbiK1JU6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 04:20:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229845AbiK1JU5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 04:20:57 -0500
Received: from out5-smtp.messagingengine.com (out5-smtp.messagingengine.com [66.111.4.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB484140F1
        for <netdev@vger.kernel.org>; Mon, 28 Nov 2022 01:20:56 -0800 (PST)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 59CAD5C0175;
        Mon, 28 Nov 2022 04:20:56 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Mon, 28 Nov 2022 04:20:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; t=1669627256; x=1669713656; bh=95h1/F9yyQ0vuDfCCc00fzXWpItq
        op4IGd1n6LsJBWw=; b=A1y84baYTmJaLx8aPEcFXfjZXRWqH/7tU3aFz7qbYENs
        DI4tPmx1idA5bLRbFIvlU3+8ZfxugK7LoNoWql6oTrJLLBzZDFtkKQiPxK5WhCF6
        CCkcUXAGKenBsWuuHCu2MiAjDzTtgN1C44Ep2SItwYn+DjjK5vSqmaOUiVATmaB3
        ayi5HKFQQDxeo5LByFyVPnnr9hqpxAtudRv6XtGp+KwKwprqoPKoLQ9Jc/QwXNwi
        woPXaGcS6NOWEOSAMhscyzqFOZRAHBiAcQTBuglsWYd3VV6wmg51fQZ6f1EjmaQO
        /w3LHnArw3GaBYEem62hJoXjwCzbviILjbKRNVng0g==
X-ME-Sender: <xms:eH2EYwcI1-336D9UDLZsITmAtaZxW23NSbo25Oz27CrHi4ng9j0tHQ>
    <xme:eH2EYyPRLjZXffVWP39YaHp7QO-hSpg9rXnuQcyFRNWa43_oiMP9rtRgeO74y1aWQ
    duEU-XenUSlxLc>
X-ME-Received: <xmr:eH2EYxjWeD9nKH60wZv7uMSJDmVfZs1wIsBqxAsnjT1U7hGCYq52iAcyg8lQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvgedrjedvgddtfecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpeehhfdtjedviefffeduuddvffegteeiieeguefgudffvdfftdefheeijedthfej
    keenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuihiivgeptd
    enucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:eH2EY18k0AmqR5XT3cTNTP-9UxvVi3-av_ybYZKJmSuhBYx2BpRzzw>
    <xmx:eH2EY8uaJFRww7oHOwWtoB-Eoq5ziCAzMX1GuAvzcHP8Xk68oQmclA>
    <xmx:eH2EY8HmsvRsufV5HM395jdTZdlkOukExKmUUXUh78IYTdG2oLH1Xw>
    <xmx:eH2EY2WXw7SAdmkcvDZ6cCNS__T2Zakdvf-Avj_GY24W93C3W50nQw>
Feedback-ID: i494840e7:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 28 Nov 2022 04:20:55 -0500 (EST)
Date:   Mon, 28 Nov 2022 11:20:53 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Yang Yingliang <yangyingliang@huawei.com>,
        Leon Romanovsky <leon@kernel.org>, netdev@vger.kernel.org,
        jiri@nvidia.com, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com
Subject: Re: [PATCH net] net: devlink: fix UAF in
 devlink_compat_running_version()
Message-ID: <Y4R9dT4QXgybUzdO@shredder>
References: <20221122121048.776643-1-yangyingliang@huawei.com>
 <Y3zdaX1I0Y8rdSLn@unreal>
 <e311b567-8130-15de-8dbb-06878339c523@huawei.com>
 <Y30dPRzO045Od2FA@unreal>
 <20221122122740.4b10d67d@kernel.org>
 <405f703b-b97e-afdd-8d5f-48b8f99d045d@huawei.com>
 <Y33OpMvLcAcnJ1oj@unreal>
 <fa1ab2fb-37ce-a810-8a3f-b71d902e8ff0@huawei.com>
 <Y35x9oawn/i+nuV3@shredder>
 <20221123181800.1e41e8c8@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221123181800.1e41e8c8@kernel.org>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 23, 2022 at 06:18:00PM -0800, Jakub Kicinski wrote:
> On Wed, 23 Nov 2022 21:18:14 +0200 Ido Schimmel wrote:
> > > I used the fix code proposed by Jakub, but it didn't work correctly, so
> > > I tried to correct and improve it, and need some devlink helper.
> > > 
> > > Anyway, it is a nsim problem, if we want fix this without touch devlink,
> > > I think we can add a 'registered' field in struct nsim_dev, and it can be
> > > checked in nsim_get_devlink_port() like this:  
> > 
> > I read the discussion and it's not clear to me why this is a netdevsim
> > specific problem. The fundamental problem seems to be that it is
> > possible to hold a reference on a devlink instance before it's
> > registered and that devlink_free() will free the instance regardless of
> > its current reference count because it expects devlink_unregister() to
> > block. In this case, the instance was never registered, so
> > devlink_unregister() is not called.
> > 
> > ethtool was able to get a reference on the devlink instance before it
> > was registered because netdevsim registers its netdevs before
> > registering its devlink instance. However, netdevsim is not the only one
> > doing this: funeth, ice, prestera, mlx4, mlxsw, nfp and potentially
> > others do the same thing.
> > 
> > When you think about it, it's strange that it's even possible for
> > ethtool to reach the driver when the netdev used in the request is long
> > gone, but it's not holding a reference on the netdev (it's holding a
> > reference on the devlink instance instead) and
> > devlink_compat_running_version() is called without RTNL.
> 
> Indeed. We did a bit of a flip-flop with the devlink locking rules
> and the fact that the instance is reachable before it is registered 
> is a leftover from a previous restructuring :(
> 
> Hence my preference to get rid of the ordering at the driver level 
> than to try to patch it up in the code. Dunno if that's convincing.

I don't have a good solution, but changing all the drivers to register
their netdevs after the devlink instance is going to be quite painful
and too big for 'net'. I feel like the main motivation for this is the
ethtool compat stuff, which is not very convincing IMO. I'm quite happy
with the current flow where drivers call devlink_register() at the end
of their probe.

Regarding a solution for the current crash, assuming we agree it's not a
netdevsim specific problem, I think the current fix [1] is OK. Note that
while it fixes the crash, it potentially creates other (less severe)
problems. After user space receives RTM_NEWLINK notification it will
need to wait for a certain period of time before issuing
'ETHTOOL_GDRVINFO' as otherwise it will not get the firmware version. I
guess it's not a big deal for drivers that only register one netdev
since they will very quickly follow with devlink_register(), but the
race window is larger for drivers that need to register many netdevs,
for either physical switch or eswitch ports.

Long term, we either need to find a way to make the ethtool compat stuff
work correctly or just get rid of it and have affected drivers implement
the relevant ethtool operations instead of relying on devlink.

[1] https://lore.kernel.org/netdev/20221122121048.776643-1-yangyingliang@huawei.com/
