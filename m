Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EABB5637B2A
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 15:16:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229689AbiKXOQA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 09:16:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbiKXOP7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 09:15:59 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06E8DC6BDB
        for <netdev@vger.kernel.org>; Thu, 24 Nov 2022 06:15:58 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id w129so1733299pfb.5
        for <netdev@vger.kernel.org>; Thu, 24 Nov 2022 06:15:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ZWz/SqOMhhPSreZC09r6NiI7szXI6QdjCAkYb0Lrj3E=;
        b=USmdN/8ucGJWPFG1kCQuGN5b9sjRxzputMrcghPz4oqGCtd1f9d47ZxUnjMeZ2bJmq
         ef1bFY+Yk7brnBY+qtitvQjdnJrnIp0fy5DdyQ4GOl+qSqmfwn7UAznu5X/BQSyuukgx
         H/mGc4w3618IxKYBU+ERTLHMYyPStx7StXMa5gy6Ak3YKIU3e8f9LoiHcsTz1C4wYXIN
         I0mqw6vr59PohyEdP/S0sAlUEE0KVV3vp+fRXo7Z7mPL1E26lOaWmVkQVB6xGKPN0dED
         +hMYJwPCC8gxOyPbWu1zYlSCtq/JDlPm1vKZaUqa7I7mjYIGjLdOapYnE4wxvbFVHD6y
         Usjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZWz/SqOMhhPSreZC09r6NiI7szXI6QdjCAkYb0Lrj3E=;
        b=QNjgdubSZIRPYtqY39WEF0Kzo+RqjffY/hIAR7Cd06pqmiqMGPyXK08WCN7evgTzdY
         fzlZgY18Ba9VYTiSW7JxxOZQejsPjIJGw26+IZhSzNc2RWwJy/A9v4G89twFxmFMrZPv
         WrLTqO5UwdYv6Vl9wFLuUhlX42aIVUXPuXfCg0t3Bg2rWofRZGX/2CfeHEjBGXoZZVAQ
         bfXAlE7ntMYH/mf6OOjbzScWwE9jZLj2SGw5ykv+wUb1GFuG2mKMaEPpr+eswTnrQt0u
         BJm7jh1EGs5uk4Q+N6GBObFAryjWOm+2JIYtbBdEj6U7nV4fd1JpEvBRwh5yloeGC+La
         Ww0Q==
X-Gm-Message-State: ANoB5pkz9zyAwIbTa9SYwdeM0VxFsH5VxAkDhoXbve/d/orq1dNyM1vH
        CTtaAUf2OOu+ogMGp6qKj9TUfAMgCzhhpk4Sor4/idecQIM=
X-Google-Smtp-Source: AA0mqf4SmTVpzjaOQkvSjteo7/oZejO6bAtvm5oUaAOW5HOuZUvN6yxsF5N5WOinovl97rM86UQdadlQbd7nPQEySyg=
X-Received: by 2002:a63:4d09:0:b0:477:7dc8:57a8 with SMTP id
 a9-20020a634d09000000b004777dc857a8mr11989498pgb.506.1669299357439; Thu, 24
 Nov 2022 06:15:57 -0800 (PST)
MIME-Version: 1.0
References: <CAOiHx==ddZr6mvvbzgoAwwhJW76qGNVOcNsTG-6m79Ch+=aA5Q@mail.gmail.com>
 <Y39me56NhhPYewYK@shredder>
In-Reply-To: <Y39me56NhhPYewYK@shredder>
From:   Jonas Gorski <jonas.gorski@gmail.com>
Date:   Thu, 24 Nov 2022 15:15:46 +0100
Message-ID: <CAOiHx=kRew115+43rkPioe=wWNg1TNx5u9F3+frNkOK1M9PySw@mail.gmail.com>
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

Hi Ido,

On Thu, 24 Nov 2022 at 13:41, Ido Schimmel <idosch@idosch.org> wrote:
>
> On Thu, Nov 24, 2022 at 10:20:00AM +0100, Jonas Gorski wrote:
> > Hello,
> >
> > when an IPv4 route gets removed because its nexthop was deleted, the
> > kernel does not send a RTM_DELROUTE netlink notifications anymore in
> > 6.1. A bisect lead me to 61b91eb33a69 ("ipv4: Handle attempt to delete
> > multipath route when fib_info contains an nh reference"), and
> > reverting it makes it work again.
> >
> > It can be reproduced by doing the following and listening to netlink
> > (e.g. via ip monitor)
> >
> > ip a a 172.16.1.1/24 dev veth1
> > ip nexthop add id 100 via 172.16.1.2 dev veth1
> > ip route add 172.16.101.0/24 nhid 100
> > ip nexthop del id 100
> >
> > where the nexthop del will trigger a RTM_DELNEXTHOP message, but no
> > RTM_DELROUTE, but the route is gone afterwards anyways.
>
> I tried the reproducer and I get the same notifications in ip monitor
> regardless of whether 61b91eb33a69 is reverted or not.
>
> Looking at the code and thinking about it, I don't think we ever
> generated RTM_DELROUTE notifications when IPv4 routes were flushed (to
> avoid a notification storm).
>
> Are you running an upstream kernel?

Okay, after having a second look, you are right, and I got myself
confused by IPv6 generating RTM_DELROUTE notifications, but which is
besides the point.

The point where it fails is that FRR tries to delete its route(s), and
fails to do so with this commit applied (=> RTM_DELROUTE goes
missing), then does the RTM_DELNEXTHOP.

So while there is indeed no RTM_DELROUTE generated in response to the
kernel, it was generated when FRR was successfully deleting its routes
before.

Not sure if this already qualifies as breaking userspace though, but
it's definitely something that used to work with 6.0 and before, and
does not work anymore now.

The error in FRR log is:

[YXPF5-B2CE0] netlink_route_multipath_msg_encode: RTM_DELROUTE
10.0.1.0/24 vrf 0(254)
[HYEHE-CQZ9G] nl_batch_send: netlink-dp (NS 0), batch size=44, msg cnt=1
[XS99C-X3KS5] netlink-dp (NS 0): error: No such process
type=RTM_DELROUTE(25), seq=22, pid=2419702167

with the revert it succeeds.

I'll see if I can get a better idea of the actual netlink message sent.

Regards
Jonas
