Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C59D8234D85
	for <lists+netdev@lfdr.de>; Sat,  1 Aug 2020 00:27:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726281AbgGaW06 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 18:26:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726118AbgGaW05 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jul 2020 18:26:57 -0400
Received: from mail-oi1-x241.google.com (mail-oi1-x241.google.com [IPv6:2607:f8b0:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1D73C06174A
        for <netdev@vger.kernel.org>; Fri, 31 Jul 2020 15:26:57 -0700 (PDT)
Received: by mail-oi1-x241.google.com with SMTP id l84so15508031oig.10
        for <netdev@vger.kernel.org>; Fri, 31 Jul 2020 15:26:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FH9gjtmSiRltkA36HoQ0xGcAadV6i+IfskzMERku0cA=;
        b=UJnchkU/2xIseLL59Vio66qninSZcDk2y6kU4W2c+W3/yEra1ggT1hl3h72A608KAg
         H+V0hsKk/+6Lz63NosC31n3O9NvbzUpt0twfUFu+zm0ZnrIDvcWiDYhQXLN7hLbVqf/k
         LDCwNbk5co5XAEoFBZyDc+m3VvpqA0i4Xj7vD1WH0mr81G56H/G0GIbVahcuFpAKjCWJ
         c1jZ+96Tv/ju/B2G5VXqe7eyMNs8kSjctNbz45IHzsAwW536/Kf7IMfwDRAWARHvWs+w
         XzvU6vPlcxT9D6XPVYfFx1+xdHcdHpc18LimauLPLMneXmT9oRtgzvRx5tKmq8pC+0mW
         3JRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FH9gjtmSiRltkA36HoQ0xGcAadV6i+IfskzMERku0cA=;
        b=gxMGtFtY2im5tArGs/zjZmAa0bt54I48BwVQQQtrVN5gnuEwkyf0AxddxGuIA3zycy
         i3e3tdhOMl1NJDBK7noT0630cuaotLMkc79mpiOBy/AX3gDNkeZSM9q1PBkMwyjxdFx+
         9RK1vDYorS+PI353vUGJEawY3orMLnDJOVDRYFrDAohoZFsNY6akpV+myoP4V9/h7KBY
         j6f1tu8i0u8DoaQBEakM+P3cq9HPk/eBj6zDVlIbX+p98hBVD1guNSuqEUVi1Cbhmizg
         GdzvamDl9/e9e821eq0IoWSD/LQG1ZsDjUV+z/o3BU4h6U2b2cL4O+sYAfet0/bdbSQ8
         xRLw==
X-Gm-Message-State: AOAM533ybQjF9UjEo76UcM7WcPFGQ4Rt50KRu3xcMx4TArto60v/l94V
        ZCcGBg8a9Zjytw1/v/p1FOfRxCR0/M4ofaJEXU0groyM
X-Google-Smtp-Source: ABdhPJw7JwCuALhZjI8ydlX4fCaX3jx8nQtuFxdOM+aWUmjGo2oOf8s96HJBpwZsL5ERhQoaZ1eLx+1dAQz8etPNP8k=
X-Received: by 2002:aca:724f:: with SMTP id p76mr4651192oic.35.1596234416898;
 Fri, 31 Jul 2020 15:26:56 -0700 (PDT)
MIME-Version: 1.0
References: <CAKA6ep+EFNOYY8k8PFP9kf_F5GY+5g8qu_LphEAX6N7iEFTs9Q@mail.gmail.com>
 <20200729114317.GA2120829@shredder> <a7652bf8-e7fc-a76f-0fa7-2457128e2abc@gmail.com>
In-Reply-To: <a7652bf8-e7fc-a76f-0fa7-2457128e2abc@gmail.com>
From:   Ashutosh Grewal <ashutoshgrewal@gmail.com>
Date:   Fri, 31 Jul 2020 15:26:46 -0700
Message-ID: <CAKA6ep+B0FhsPiCJG7CqH6ndM7tQ31pTqtVR95fHGSLaAdBf2w@mail.gmail.com>
Subject: Re: Bug: ip utility fails to show routes with large # of multipath next-hops
To:     David Ahern <dsahern@gmail.com>
Cc:     Ido Schimmel <idosch@idosch.org>, davem@davemloft.net,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks Ido and David for your confirmation and insight.

-- Ashutosh

On Wed, Jul 29, 2020 at 8:17 AM David Ahern <dsahern@gmail.com> wrote:
>
> On 7/29/20 5:43 AM, Ido Schimmel wrote:
> > On Tue, Jul 28, 2020 at 05:52:44PM -0700, Ashutosh Grewal wrote:
> >> Hello David and all,
> >>
> >> I hope this is the correct way to report a bug.
> >
> > Sure
> >
> >>
> >> I observed this problem with 256 v4 next-hops or 128 v6 next-hops (or
> >> 128 or so # of v4 next-hops with labels).
> >>
> >> Here is an example -
> >>
> >> root@a6be8c892bb7:/# ip route show 2.2.2.2
> >> Error: Buffer too small for object.
> >> Dump terminated
> >>
> >> Kernel details (though I recall running into the same problem on 4.4*
> >> kernel as well) -
> >> root@ubuntu-vm:/# uname -a
> >> Linux ch1 5.4.0-33-generic #37-Ubuntu SMP Thu May 21 12:53:59 UTC 2020
> >> x86_64 x86_64 x86_64 GNU/Linux
> >>
> >> I think the problem may be to do with the size of the skbuf being
> >> allocated as part of servicing the netlink request.
> >>
> >> static int netlink_dump(struct sock *sk)
> >> {
> >>   <snip>
> >>
> >>                 skb = alloc_skb(...)
> >
> > Yes, I believe you are correct. You will get an skb of size 4K and it
> > can't fit the entire RTA_MULTIPATH attribute with all the nested
> > nexthops. Since it's a single attribute it cannot be split across
> > multiple messages.
>
> yep, well known problem.
>
> >
> > Looking at the code, I think a similar problem was already encountered
> > with IFLA_VFINFO_LIST. See commit c7ac8679bec9 ("rtnetlink: Compute and
> > store minimum ifinfo dump size").
> >
> > Maybe we can track the maximum number of IPv4/IPv6 nexthops during
> > insertion and then consult it to adjust 'min_dump_alloc' for
> > RTM_GETROUTE.
>
> That seems better than the current design for GETLINK which walks all
> devices to determine max dump size. Not sure how you will track that
> efficiently though - add is easy, delete is not.
>
> >
> > It's a bit complicated for IPv6 because you can append nexthops, but I
> > believe anyone using so many nexthops is already using RTA_MULTIPATH to
> > insert them, so we can simplify.
>
> I hope so.
>
> >
> > David, what do you think? You have a better / simpler idea? Maybe one
> > day everyone will be using the new nexthop API and this won't be needed
> > :)
>
> exactly. You won't have this problem with separate nexthops since each
> one is small (< 4k) and the group (multipath) is a set of ids, not the
> full set of attributes.
