Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F1E9637B90
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 15:40:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229590AbiKXOkf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 09:40:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229576AbiKXOkd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 09:40:33 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E602A6AEFF
        for <netdev@vger.kernel.org>; Thu, 24 Nov 2022 06:40:31 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id io19so1612918plb.8
        for <netdev@vger.kernel.org>; Thu, 24 Nov 2022 06:40:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=eoWCpd+4bmCnUHawZ6JSeu6lu/h4p5oZ56Z1Bd/uZb8=;
        b=oXKS7j8hbZb6hCU/pQEueRPPUe+DtbMLZtT/BWR2w3do0Rv0RB+fymNQuuhFRtxSMz
         lwlbql/f4CR1HBcptJzl4wpZhlt4ifTjD7xkSUXEUDRym4D5XEGExW8i1g0mhK772mps
         Lmvsy3zEd80VjGYA2vxVrktV+nSn+jovwXNX0ZoKMQ2koI0Y23xDGof1R2Q8a2ss9aBv
         UACvpKq+qUQMyhtLaNshFBBEmcIILe2nh4ErAMXkX7azxuw2cRUske8nHSPML4EeFbXX
         vVqu2yO7ILyE8OgxF/46l0bB1f3irHnGax97ZAQb07RXdF5CgOaTzlDXPoOEBAO9IbCB
         rzgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eoWCpd+4bmCnUHawZ6JSeu6lu/h4p5oZ56Z1Bd/uZb8=;
        b=Z9YS+ul7R6qR/2EpYBuPxPWeAFV4fwU6ccuku5EYnqNnoqLr3tTmBHw1iy1vYP5RJS
         47nAA/5mQdqhf1F1nWq2Z6ftaiISMigyx8NTo5mB1zxckE5I+r0PkwMDTQV7/j20DHa9
         BWqKIZgivpsZ5wFcO6Wdf48yg4Z6eq3wIFvtdYXFTXyg2x8P8jo9Tqxmultt2mx7E2EB
         1Y1e1+P6AHIaxmzRaZj7AaLghLDjwjznHGRyDXwYnaQy8tPKxaleUOZuOGq379e+eFV0
         2Y2N9bso3RfGwS+HWtQ034i2Cmh3gs5zehvgI1CIEPo5an+bo68sYv8/77D+//fRFKoo
         aYdw==
X-Gm-Message-State: ANoB5pmEg6Est0AWBcxn6nn1YNSVmn9JwRiEvyZZ9Y20JReWBcfnpFQR
        QnoC2tRmzbATNSJPEEaBqrvmW5V+dFwrf8gJRiJbbUqigbM=
X-Google-Smtp-Source: AA0mqf40FDaGfPRo3E/QOrmOz4zPhPFQiyv9Q+ZvjZOdsk1ej/1kmtd+erScnn7n5c8HOW29BvbiK068PfReSsYJ/oo=
X-Received: by 2002:a17:902:ce90:b0:186:b46d:da5e with SMTP id
 f16-20020a170902ce9000b00186b46dda5emr14115417plg.92.1669300831310; Thu, 24
 Nov 2022 06:40:31 -0800 (PST)
MIME-Version: 1.0
References: <CAOiHx==ddZr6mvvbzgoAwwhJW76qGNVOcNsTG-6m79Ch+=aA5Q@mail.gmail.com>
 <Y39me56NhhPYewYK@shredder> <CAOiHx=kRew115+43rkPioe=wWNg1TNx5u9F3+frNkOK1M9PySw@mail.gmail.com>
In-Reply-To: <CAOiHx=kRew115+43rkPioe=wWNg1TNx5u9F3+frNkOK1M9PySw@mail.gmail.com>
From:   Jonas Gorski <jonas.gorski@gmail.com>
Date:   Thu, 24 Nov 2022 15:40:19 +0100
Message-ID: <CAOiHx=n2O1m24ZbMRbfD1=PCs-yYajpjNWR1y1oBP8Rz-8wA5A@mail.gmail.com>
Subject: Re: RTM_DELROUTE not sent anymore when deleting (last) nexthop of
 routes in 6.1
To:     Ido Schimmel <idosch@idosch.org>
Cc:     Network Development <netdev@vger.kernel.org>,
        David Ahern <dsahern@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 24 Nov 2022 at 15:15, Jonas Gorski <jonas.gorski@gmail.com> wrote:
>
> Hi Ido,
>
> On Thu, 24 Nov 2022 at 13:41, Ido Schimmel <idosch@idosch.org> wrote:
> >
> > On Thu, Nov 24, 2022 at 10:20:00AM +0100, Jonas Gorski wrote:
> > > Hello,
> > >
> > > when an IPv4 route gets removed because its nexthop was deleted, the
> > > kernel does not send a RTM_DELROUTE netlink notifications anymore in
> > > 6.1. A bisect lead me to 61b91eb33a69 ("ipv4: Handle attempt to delete
> > > multipath route when fib_info contains an nh reference"), and
> > > reverting it makes it work again.
> > >
> >
> > Are you running an upstream kernel?
>
> Okay, after having a second look, you are right, and I got myself
> confused by IPv6 generating RTM_DELROUTE notifications, but which is
> besides the point.
>
> The point where it fails is that FRR tries to delete its route(s), and
> fails to do so with this commit applied (=> RTM_DELROUTE goes
> missing), then does the RTM_DELNEXTHOP.
>
> So while there is indeed no RTM_DELROUTE generated in response to the
> kernel, it was generated when FRR was successfully deleting its routes
> before.
>
> Not sure if this already qualifies as breaking userspace though, but
> it's definitely something that used to work with 6.0 and before, and
> does not work anymore now.
>
> The error in FRR log is:
>
> [YXPF5-B2CE0] netlink_route_multipath_msg_encode: RTM_DELROUTE
> 10.0.1.0/24 vrf 0(254)
> [HYEHE-CQZ9G] nl_batch_send: netlink-dp (NS 0), batch size=44, msg cnt=1
> [XS99C-X3KS5] netlink-dp (NS 0): error: No such process
> type=RTM_DELROUTE(25), seq=22, pid=2419702167
>
> with the revert it succeeds.
>
> I'll see if I can get a better idea of the actual netlink message sent.

Okay, found the knob:

nlmsghdr [len=44 type=(25) DELROUTE flags=(0x0401)
{REQUEST,(ATOMIC|CREATE)} seq=22 pid=2185212923]
  rtmsg [family=(2) AF_INET dstlen=24 srclen=0 tos=0 table=254
protocol=(186) UNKNOWN scope=(0) UNIVERSE type=(0) UNSPEC flags=0x0000
{}]
    rta [len=8 (payload=4) type=(1) DST]
      10.0.1.0
    rta [len=8 (payload=4) type=(6) PRIORITY]
      20
netlink-dp (NS 0): error: No such process type=RTM_DELROUTE(25),
seq=22, pid=2185212923

The route was created via

nlmsghdr [len=52 type=(24) NEWROUTE flags=(0x0501)
{REQUEST,DUMP,(ROOT|REPLACE|CAPPED),(ATOMIC|CREATE)} seq=18
pid=2185212923]
 rtmsg [family=(2) AF_INET dstlen=24 srclen=0 tos=0 table=254
protocol=(186) UNKNOWN scope=(0) UNIVERSE type=(1) UNICAST
flags=0x0000 {}]
    rta [len=8 (payload=4) type=(1) DST]
      10.0.1.0
    rta [len=8 (payload=4) type=(6) PRIORITY]
       20
     rta [len=8 (payload=4) type=(30) NH_ID]
     18

and for completion the nexthop is created via:

nlmsghdr [len=48 type=(104) NEWNEXTHOP flags=(0x0501)
{REQUEST,DUMP,(ROOT|REPLACE|CAPPED),(ATOMIC|CREATE)} seq=17
pid=2185212923]
   nhm [family=(2) AF_INET scope=(0) UNIVERSE protocol=(11) ZEBRA
flags=0x00000000 {}]
    rta [len=8 (payload=4) type=(1) ID]
      18
    rta [len=8 (payload=4) type=(6) GATEWAY]
      10.0.0.1
    rta [len=8 (payload=4) type=(5) OIF]
      62


Regards
Jonas
