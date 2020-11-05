Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B2D02A768D
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 05:42:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730361AbgKEEl6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 23:41:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728784AbgKEEl5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 23:41:57 -0500
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8953C0613CF
        for <netdev@vger.kernel.org>; Wed,  4 Nov 2020 20:41:55 -0800 (PST)
Received: by mail-io1-xd44.google.com with SMTP id o11so465397ioo.11
        for <netdev@vger.kernel.org>; Wed, 04 Nov 2020 20:41:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Duq9dQW5Jzdb3ujMdT0fiNUQPULoX6VzrLszCWfIuRA=;
        b=mj7WaTYLQl8Z8R2+cxErwAk6QYCYtuk0BSwcy4Vo6G0ibhWEaIHAlS9ZYRLPxt+FCx
         Ehwxe3anN94g13po/UTX3cYHwWT4ZbCnWjCnCH9k2rHZXv4p+2T1zSd7KTQhEGsiNqDL
         z/BB4MVSBP/8yJStYTBVtCP72D+noVuyGO1qFuFka+VAnKVKL7lF5R7BrKeFDZdfiZOn
         sHHoU8m7LaCUdbERPUlYZ0YudsrKxdNhNthytEuK4SJiXAsU99bI537BL0UE9YN0cWNy
         sDTdTQWAMMIEftHdjNxEL+SE6RyqW9gln7MNiTb2LiXaDtzkU65EEilv3cmgskHuQ5vN
         JKmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Duq9dQW5Jzdb3ujMdT0fiNUQPULoX6VzrLszCWfIuRA=;
        b=i/lpT5NeMuPDqMpo2UUBeiLHFWNxq0ExLoNIft9e6eCmOPBI9M7E1a12VMaShmaqi4
         YU66hnKh9SUVPcoNuGjcfHbbXfzSt2n8EbqJsWcbABC/5LhJEXDWTrtWkxU7mDHwA1+q
         IjkcUHXUDzalr4M1ttpHWgHsSP+HsbDznGye8LVh8ydRy/GQrJE9FJHamJLHYHQ6wU20
         QWj60eiqSgGyDQk5ZX15PrPEJZJsvAHMDGiUf5HakUOHlhlu93h/IHjEEaN3qL46Sx8g
         RNnkAf2v6FoZcvJM3w751enXO6TzMWFG3kkbhefvLzyZHNvsNLBcKaxncETwG5ykJSWV
         Ot2Q==
X-Gm-Message-State: AOAM533TUkblKC5xorHl9mcoGv0e83+tGw8oy0BSR5IW9jbzZQrMhfXC
        se1oY6v1kf7Oj2cnBo/zTJFv1idu6ADdJZoWRn6zlg==
X-Google-Smtp-Source: ABdhPJx1PyyQdfrnX4KUFq0a8rT1VNgnT1Ph8zJ9ue/a9y+4slW5/MkhfLkG8nrxOVPwFfwBEqkdYaKGgzycLmiPxEY=
X-Received: by 2002:a02:cc77:: with SMTP id j23mr722712jaq.20.1604551314784;
 Wed, 04 Nov 2020 20:41:54 -0800 (PST)
MIME-Version: 1.0
References: <20200909062613.18604-1-lina.wang@mediatek.com>
 <20200915073006.GR20687@gauss3.secunet.de> <1600160722.5295.15.camel@mbjsdccf07>
 <20200915093230.GS20687@gauss3.secunet.de> <1600172260.2494.2.camel@mbjsdccf07>
 <20200917074637.GV20687@gauss3.secunet.de> <1600341549.32639.5.camel@mbjsdccf07>
 <1604547381.23648.14.camel@mbjsdccf07>
In-Reply-To: <1604547381.23648.14.camel@mbjsdccf07>
From:   =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>
Date:   Wed, 4 Nov 2020 20:41:43 -0800
Message-ID: <CANP3RGfvadfLabY9vVFxcWioEBUURRSx3GHgbO2KHO180wX=bw@mail.gmail.com>
Subject: Re: [PATCH] xfrm:fragmented ipv4 tunnel packets in inner interface
To:     "lina.wang" <lina.wang@mediatek.com>
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        "David S . Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Linux NetDev <netdev@vger.kernel.org>,
        Kernel hackers <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        Lorenzo Colitti <lorenzo@google.com>,
        Greg Kroah-Hartman <gregkh@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 4, 2020 at 7:53 PM lina.wang <lina.wang@mediatek.com> wrote:
>
> Besides several operators donot fragment packets even DF bit is not set,
> and instead just drop packets which they think big, maybe they have a
> consideration--- fragmentation is expensive for both the router that
> fragments and for the host that reassembles.
>
> BTW, ipv6 has the different behaviour when it meets such scenary, which
> is what we expected,ipv4 should follow the same thing. otherwise,
> packets are drop, it is a serious thing, and there is no hints. What we
> do is just fragmenting smaller packets, or is it possible to give us
> some flag or a sysctl to allow us to change the behaviour?
>
> On Thu, 2020-09-17 at 19:19 +0800, lina.wang wrote:
> > But it is not just one operator's broken router or misconfigured
> > router.In the whole network, it is common to meet that router will drop
> > bigger packet silently.I think we should make code more compatible.and
> > the scenary is wifi calling, which mostly used udp,you know, udp
> > wouldnot retransmit.It is serious when packet is dropped
> >
> > On Thu, 2020-09-17 at 09:46 +0200, Steffen Klassert wrote:
> > > On Tue, Sep 15, 2020 at 08:17:40PM +0800, lina.wang wrote:
> > > > We didnot get the router's log, which is some operator's.Actually, after
> > > > we patched, there is no such issue. Sometimes,router will return
> > > > packet-too-big, most of times nothing returned,dropped silently
> > >
> > > This looks like a broken router, we can't fix that in the code.
> > >
> > > > On Tue, 2020-09-15 at 11:32 +0200, Steffen Klassert wrote:
> > > > > On Tue, Sep 15, 2020 at 05:05:22PM +0800, lina.wang wrote:
> > > > > >
> > > > > > Yes, DF bit is not set.
> > > > >
> > > > > ...
> > > > >
> > > > > > Those two packets are fragmented to one big udp packet, which payload is 1516B.
> > > > > > After getting rid of tunnel header, it is also a udp packet, which payload is
> > > > > > 1466 bytes.It didnot get any response for this packet.We guess it is dropped
> > > > > > by router. Because if we reduced the length, it got response.
> > > > >
> > > > > If the DF bit is not set, the router should fragment the packet. If it
> > > > > does not do so, it is misconfigured. Do you have access to that router?

I'm afraid I don't really understand the exact scenario from the
description of the patch.

However... a few questions come to mind.
(a) why not set the DF flag, does the protocol require > mtu udp frames
(b) what is the mtu of the inner tunnel device, and what is the mtu on
the route through the device?
- shouldn't we be udp fragmenting to the route/device mtu?
maybe stuff is simply misconfigured...
