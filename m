Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54B37637CD3
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 16:22:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229757AbiKXPWI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 10:22:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230129AbiKXPVr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 10:21:47 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B4146931B
        for <netdev@vger.kernel.org>; Thu, 24 Nov 2022 07:21:01 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id o5-20020a17090a678500b00218cd5a21c9so1861716pjj.4
        for <netdev@vger.kernel.org>; Thu, 24 Nov 2022 07:21:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=zSlUTYPd+pJN7wFCNJIa6eMB3Jz/xspqbbk0gvL1wh0=;
        b=Ls8rwVxES8IDTBG9P3GAO90Eu1D8+2389UEWrU956wf1OBg6/T+s/V1MfijlcWFSlJ
         ZoszntezzTWPQ/VJI40QlhnYMOEwqMkUspkRyUbY0B3RKhdRr0jg8kMRKgITBIlwrOkz
         pCXPYHya15a3JbS3Juo1+GEHKUXXrKUjX4CLRqyJ2/jZSkK6mfSG+vTdlG8YY2JrVnee
         z9GXEkOQ6FnPa7nhVeaKIncpjLfq6A5elhcFg2l3Y3MctMh+W93xw+zR9wiSlTTM1EFK
         RGXuZm3UJUW0auqQKwXF1gt4bPtxpfxh00PoPnmMRat1VY2F5OniMUOSKd5MbezxCEtg
         rZRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zSlUTYPd+pJN7wFCNJIa6eMB3Jz/xspqbbk0gvL1wh0=;
        b=Ge4nL3C6Eq8LZRYdEv4ZPpbgj/st4/OM9aUKEKOlawxymjWO2yJXRSaZTfirN+gpsz
         0OdAGGiQVWQjaAqNncGQr++M81HxXxLyhqCLI3NolznU6oQhwsGWbtG3rs4D97gcUb0n
         I1L7ZyP4apsSuaRuk/Q6kCTiF10FCaAphKRSsIGpdFC+vTNy6v7jDyZuZjgAlsmn7ANs
         iOhIgEljbD58DplMPq2BuMFJIpMKVIoJYv8cetA7tiIVORNPQXSIiKjIegLjSbCRTV5f
         JUR6OZbIFzXIEdvnNVzbfSRdjM4b3ozIVUf7RCedbtbcNSGoiSP4EXp9h50Wi1IZt0qu
         StKw==
X-Gm-Message-State: ANoB5pn9JviMb5TwgqqiFw5RYWQaji9ZhdneTt83IgJPofIg8W8/LYlx
        rhwfPb/QtqqLUWxa3Nwyt289pDKg4woQ+pKAtN4uD8Z2
X-Google-Smtp-Source: AA0mqf76eT7gxedZ2wQ2IajBgJIT7ULMPQ6ipOGdi2D8oio0O3PkudkSJMkizz+erwOo0LMDlD1mpbHuzpQXx71Q/Es=
X-Received: by 2002:a17:90a:7c43:b0:213:ecb5:c4fe with SMTP id
 e3-20020a17090a7c4300b00213ecb5c4femr35781204pjl.179.1669303260703; Thu, 24
 Nov 2022 07:21:00 -0800 (PST)
MIME-Version: 1.0
References: <CAOiHx==ddZr6mvvbzgoAwwhJW76qGNVOcNsTG-6m79Ch+=aA5Q@mail.gmail.com>
 <Y39me56NhhPYewYK@shredder> <CAOiHx=kRew115+43rkPioe=wWNg1TNx5u9F3+frNkOK1M9PySw@mail.gmail.com>
 <CAOiHx=n2O1m24ZbMRbfD1=PCs-yYajpjNWR1y1oBP8Rz-8wA5A@mail.gmail.com> <Y3+Evdg9ODFVM9/w@shredder>
In-Reply-To: <Y3+Evdg9ODFVM9/w@shredder>
From:   Jonas Gorski <jonas.gorski@gmail.com>
Date:   Thu, 24 Nov 2022 16:20:49 +0100
Message-ID: <CAOiHx=mi-M+dWj-Y1ZZJ_xSY_-n0=xy9u1Gmx3Yw=zJHeuiS+A@mail.gmail.com>
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

On Thu, 24 Nov 2022 at 15:50, Ido Schimmel <idosch@idosch.org> wrote:
>
> On Thu, Nov 24, 2022 at 03:40:19PM +0100, Jonas Gorski wrote:
> > On Thu, 24 Nov 2022 at 15:15, Jonas Gorski <jonas.gorski@gmail.com> wrote:
> > >
> > > Hi Ido,
> > >
> > > On Thu, 24 Nov 2022 at 13:41, Ido Schimmel <idosch@idosch.org> wrote:
> > > >
> > > > On Thu, Nov 24, 2022 at 10:20:00AM +0100, Jonas Gorski wrote:
> > > > > Hello,
> > > > >
> > > > > when an IPv4 route gets removed because its nexthop was deleted, the
> > > > > kernel does not send a RTM_DELROUTE netlink notifications anymore in
> > > > > 6.1. A bisect lead me to 61b91eb33a69 ("ipv4: Handle attempt to delete
> > > > > multipath route when fib_info contains an nh reference"), and
> > > > > reverting it makes it work again.
> > > > >
> > > >
> > > > Are you running an upstream kernel?
> > >
> > > Okay, after having a second look, you are right, and I got myself
> > > confused by IPv6 generating RTM_DELROUTE notifications, but which is
> > > besides the point.
> > >
> > > The point where it fails is that FRR tries to delete its route(s), and
> > > fails to do so with this commit applied (=> RTM_DELROUTE goes
> > > missing), then does the RTM_DELNEXTHOP.
> > >
> > > So while there is indeed no RTM_DELROUTE generated in response to the
> > > kernel, it was generated when FRR was successfully deleting its routes
> > > before.
> > >
> > > Not sure if this already qualifies as breaking userspace though, but
> > > it's definitely something that used to work with 6.0 and before, and
> > > does not work anymore now.
> > >
> > > The error in FRR log is:
> > >
> > > [YXPF5-B2CE0] netlink_route_multipath_msg_encode: RTM_DELROUTE
> > > 10.0.1.0/24 vrf 0(254)
> > > [HYEHE-CQZ9G] nl_batch_send: netlink-dp (NS 0), batch size=44, msg cnt=1
> > > [XS99C-X3KS5] netlink-dp (NS 0): error: No such process
> > > type=RTM_DELROUTE(25), seq=22, pid=2419702167
> > >
> > > with the revert it succeeds.
> > >
> > > I'll see if I can get a better idea of the actual netlink message sent.
> >
> > Okay, found the knob:
> >
> > nlmsghdr [len=44 type=(25) DELROUTE flags=(0x0401)
> > {REQUEST,(ATOMIC|CREATE)} seq=22 pid=2185212923]
> >   rtmsg [family=(2) AF_INET dstlen=24 srclen=0 tos=0 table=254
> > protocol=(186) UNKNOWN scope=(0) UNIVERSE type=(0) UNSPEC flags=0x0000
> > {}]
> >     rta [len=8 (payload=4) type=(1) DST]
> >       10.0.1.0
> >     rta [len=8 (payload=4) type=(6) PRIORITY]
> >       20
>
> The route is deleted with only prefix information (NH_ID not specified).
> Matches this comment and the code:
> https://github.com/FRRouting/frr/blob/master/zebra/rt_netlink.c#L2091
>
> > netlink-dp (NS 0): error: No such process type=RTM_DELROUTE(25),
> > seq=22, pid=2185212923
> >
> > The route was created via
> >
> > nlmsghdr [len=52 type=(24) NEWROUTE flags=(0x0501)
> > {REQUEST,DUMP,(ROOT|REPLACE|CAPPED),(ATOMIC|CREATE)} seq=18
> > pid=2185212923]
> >  rtmsg [family=(2) AF_INET dstlen=24 srclen=0 tos=0 table=254
> > protocol=(186) UNKNOWN scope=(0) UNIVERSE type=(1) UNICAST
> > flags=0x0000 {}]
> >     rta [len=8 (payload=4) type=(1) DST]
> >       10.0.1.0
> >     rta [len=8 (payload=4) type=(6) PRIORITY]
> >        20
> >      rta [len=8 (payload=4) type=(30) NH_ID]
> >      18
>
> Here the nexthop ID is obviously present.
>
> Let me try to fix it and add a test for this flow.
>
> Thanks for all the details!

You are welcome, and thanks for the quick response!

We have an integration test using FRR that got broken by this, so I
can also easily test anything you throw at me (assuming CET working
hours).

Regards
Jonas
