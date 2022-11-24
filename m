Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88640637BD3
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 15:51:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229866AbiKXOvJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 09:51:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229889AbiKXOuw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 09:50:52 -0500
Received: from out5-smtp.messagingengine.com (out5-smtp.messagingengine.com [66.111.4.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4334D13F488
        for <netdev@vger.kernel.org>; Thu, 24 Nov 2022 06:50:46 -0800 (PST)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id F0A745C00CE;
        Thu, 24 Nov 2022 09:50:42 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Thu, 24 Nov 2022 09:50:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; t=1669301442; x=1669387842; bh=rUOnuzlGDJa8ettx+Lmo48fYOj8l
        xj1yyuiOUeOeEf0=; b=mTa3TnKP4YTL0NUQnnwMJv//s+lM+aWDv0nuayj6noxd
        rfIaYoaoeQpa3ieYXho68ILqcvzCHQjC6/k2wKH6gNgghFynxz+rSH8kfM1Um131
        +B65SFOL5o0V+oFvsxrQYAyq35goNJd6YlgN2nupZIJmU1rT6Slbz/hQIgPWal9L
        Bf/jD/+sR6JNLH1KDwVKN+1D4Vw32Ul21J2cKCc1x7284H0NQdDgWjVdV8Nj/dYR
        jSyOkNV2iqSq/yLGaJzzO35ps+jkGwVuesiJ0y/fepzVkjIUCrewukm0ZzIZ7/fC
        YOH9/iz57J1zmzxzlox8DWowasff1R0F98g2maFTpQ==
X-ME-Sender: <xms:woR_Yx18-IjfJ49JLt8dWLQKJ207_P3afofAtpWuqeh4e1Ft00nqxQ>
    <xme:woR_Y4ECAWpAh8bXVv7zP4UexSSXmofM8nE1j13ccOkupO-eh2NR4KZ9QHBhpCReH
    fnv2xKWy7795GU>
X-ME-Received: <xmr:woR_Yx5P-i7NA8R5FB4L9X_Vcm8jrTfYiav_l5KmTTXAuTXxi0dmR8hg1iP-uAzu1jqo076fpvBUo33iswTQjePB87c>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvgedrieefgdeilecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpefhffejgefhjeehjeevheevhfetveevfefgueduueeivdeijeeihfegheeljefg
    ueenucffohhmrghinhepghhithhhuhgsrdgtohhmnecuvehluhhsthgvrhfuihiivgeptd
    enucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:woR_Y-0PNBwy7ucqXv9gpqzlzKncHKIRdOjOVlAp59dxq_Gwsp0aYw>
    <xmx:woR_Y0F6OTlOJjQQySe0PdU7kHptWcD3eqbHhJ2BCmU1cwU-Ho_q7A>
    <xmx:woR_Y_8PIpTchbkgCI3RYtkYHLn_sCCH8LLDXa5QH1YAyosASD6g4A>
    <xmx:woR_Y_PxCr-ZXgI5QnnzyjsH1gOYqlH_fBpSZ2wQUR9N-y-lGQf7ug>
Feedback-ID: i494840e7:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 24 Nov 2022 09:50:42 -0500 (EST)
Date:   Thu, 24 Nov 2022 16:50:37 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Jonas Gorski <jonas.gorski@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        David Ahern <dsahern@kernel.org>
Subject: Re: RTM_DELROUTE not sent anymore when deleting (last) nexthop of
 routes in 6.1
Message-ID: <Y3+Evdg9ODFVM9/w@shredder>
References: <CAOiHx==ddZr6mvvbzgoAwwhJW76qGNVOcNsTG-6m79Ch+=aA5Q@mail.gmail.com>
 <Y39me56NhhPYewYK@shredder>
 <CAOiHx=kRew115+43rkPioe=wWNg1TNx5u9F3+frNkOK1M9PySw@mail.gmail.com>
 <CAOiHx=n2O1m24ZbMRbfD1=PCs-yYajpjNWR1y1oBP8Rz-8wA5A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOiHx=n2O1m24ZbMRbfD1=PCs-yYajpjNWR1y1oBP8Rz-8wA5A@mail.gmail.com>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 24, 2022 at 03:40:19PM +0100, Jonas Gorski wrote:
> On Thu, 24 Nov 2022 at 15:15, Jonas Gorski <jonas.gorski@gmail.com> wrote:
> >
> > Hi Ido,
> >
> > On Thu, 24 Nov 2022 at 13:41, Ido Schimmel <idosch@idosch.org> wrote:
> > >
> > > On Thu, Nov 24, 2022 at 10:20:00AM +0100, Jonas Gorski wrote:
> > > > Hello,
> > > >
> > > > when an IPv4 route gets removed because its nexthop was deleted, the
> > > > kernel does not send a RTM_DELROUTE netlink notifications anymore in
> > > > 6.1. A bisect lead me to 61b91eb33a69 ("ipv4: Handle attempt to delete
> > > > multipath route when fib_info contains an nh reference"), and
> > > > reverting it makes it work again.
> > > >
> > >
> > > Are you running an upstream kernel?
> >
> > Okay, after having a second look, you are right, and I got myself
> > confused by IPv6 generating RTM_DELROUTE notifications, but which is
> > besides the point.
> >
> > The point where it fails is that FRR tries to delete its route(s), and
> > fails to do so with this commit applied (=> RTM_DELROUTE goes
> > missing), then does the RTM_DELNEXTHOP.
> >
> > So while there is indeed no RTM_DELROUTE generated in response to the
> > kernel, it was generated when FRR was successfully deleting its routes
> > before.
> >
> > Not sure if this already qualifies as breaking userspace though, but
> > it's definitely something that used to work with 6.0 and before, and
> > does not work anymore now.
> >
> > The error in FRR log is:
> >
> > [YXPF5-B2CE0] netlink_route_multipath_msg_encode: RTM_DELROUTE
> > 10.0.1.0/24 vrf 0(254)
> > [HYEHE-CQZ9G] nl_batch_send: netlink-dp (NS 0), batch size=44, msg cnt=1
> > [XS99C-X3KS5] netlink-dp (NS 0): error: No such process
> > type=RTM_DELROUTE(25), seq=22, pid=2419702167
> >
> > with the revert it succeeds.
> >
> > I'll see if I can get a better idea of the actual netlink message sent.
> 
> Okay, found the knob:
> 
> nlmsghdr [len=44 type=(25) DELROUTE flags=(0x0401)
> {REQUEST,(ATOMIC|CREATE)} seq=22 pid=2185212923]
>   rtmsg [family=(2) AF_INET dstlen=24 srclen=0 tos=0 table=254
> protocol=(186) UNKNOWN scope=(0) UNIVERSE type=(0) UNSPEC flags=0x0000
> {}]
>     rta [len=8 (payload=4) type=(1) DST]
>       10.0.1.0
>     rta [len=8 (payload=4) type=(6) PRIORITY]
>       20

The route is deleted with only prefix information (NH_ID not specified).
Matches this comment and the code:
https://github.com/FRRouting/frr/blob/master/zebra/rt_netlink.c#L2091

> netlink-dp (NS 0): error: No such process type=RTM_DELROUTE(25),
> seq=22, pid=2185212923
> 
> The route was created via
> 
> nlmsghdr [len=52 type=(24) NEWROUTE flags=(0x0501)
> {REQUEST,DUMP,(ROOT|REPLACE|CAPPED),(ATOMIC|CREATE)} seq=18
> pid=2185212923]
>  rtmsg [family=(2) AF_INET dstlen=24 srclen=0 tos=0 table=254
> protocol=(186) UNKNOWN scope=(0) UNIVERSE type=(1) UNICAST
> flags=0x0000 {}]
>     rta [len=8 (payload=4) type=(1) DST]
>       10.0.1.0
>     rta [len=8 (payload=4) type=(6) PRIORITY]
>        20
>      rta [len=8 (payload=4) type=(30) NH_ID]
>      18

Here the nexthop ID is obviously present.

Let me try to fix it and add a test for this flow.

Thanks for all the details!

> 
> and for completion the nexthop is created via:
> 
> nlmsghdr [len=48 type=(104) NEWNEXTHOP flags=(0x0501)
> {REQUEST,DUMP,(ROOT|REPLACE|CAPPED),(ATOMIC|CREATE)} seq=17
> pid=2185212923]
>    nhm [family=(2) AF_INET scope=(0) UNIVERSE protocol=(11) ZEBRA
> flags=0x00000000 {}]
>     rta [len=8 (payload=4) type=(1) ID]
>       18
>     rta [len=8 (payload=4) type=(6) GATEWAY]
>       10.0.0.1
>     rta [len=8 (payload=4) type=(5) OIF]
>       62
> 
> 
> Regards
> Jonas
