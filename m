Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76A812414F0
	for <lists+netdev@lfdr.de>; Tue, 11 Aug 2020 04:26:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728080AbgHKC0K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Aug 2020 22:26:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726446AbgHKC0J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Aug 2020 22:26:09 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B03BCC06174A
        for <netdev@vger.kernel.org>; Mon, 10 Aug 2020 19:26:08 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id a5so11075299ioa.13
        for <netdev@vger.kernel.org>; Mon, 10 Aug 2020 19:26:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=miraclelinux-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=9SOrV2/8V5gyDhn+8/dt+KdOHyKJs/Z329oLpMgUcfw=;
        b=D4AQ4sCfwyy8LLaYsuCfNrFky4RlfUsHnO8gWDS2q4bayQK5biHKHpCpaD5ZPxifMy
         WcbDl6fWN/bddSgpNt89HgzMEK2l3OFZxr00mSImpRfHFCdzY/sTFcZAzbko+I+s1eu7
         HtgF4vV+vunmiEoSZ4tOx+69GjB/e84YQJ0yI5G9gYRu4ceqrs7HcdZ9aMJ8h8x0GgWt
         YMwAuTOoSOhFFvXZ3yC/iv6DiXJxjMJBBgGDaNBelIZqdeGmxPmNjTKdEnCPfgqUgRww
         cT2yftbj12uhwIe/eU19cdh2hi0VLKCutMeVAYrv18ALO/VXyOH+JCCi5p0IBt5Lcseb
         OBkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=9SOrV2/8V5gyDhn+8/dt+KdOHyKJs/Z329oLpMgUcfw=;
        b=aVOQURKIfSGSXo7hNpri3uq3B2veYJ66ffXNW127iRwB6vAs37chusy070eKfFvON/
         /x7K5stL5cVsbeXD0xztGyQufkszralqBsAvTygWJO+hrXwdggKyqW2E5L+g8PpL6lo9
         rr6vWt63igt6hPqwPddP1Sjg0l7RLOTUmv0/VvFcS8Xc4rTwPhuy9zy3wP3OPt5BbPFH
         +4QX753ebgJ7HlSvE1hGco0Yn6+96IeGm0Q++gfMdpO6r1eSTUsuf/n8NNNf2npjqBly
         hKB57W5Yt2MVkAWerIOeHHwFhjJ6VFVDlwr0pxjpCSdGussIsTCILFnmpLd+56f8JeYN
         1n+g==
X-Gm-Message-State: AOAM5300hInklNt/rtimF410j/2ycStzNMT9EpIP1EKOWAQqVe6ENPBt
        +z07mSCuoY1GVJnftc3bQkK1TOhwLYUPZRFYLcE9Gg==
X-Google-Smtp-Source: ABdhPJxIYzxh7ALEys0DQa3JDe3Y3P4HDTp3RXj+pUmwLjuAcJcxJwKtawaBrgG+jR+AZm/WbixOZO8gVLHJbBEOyhU=
X-Received: by 2002:a05:6638:1690:: with SMTP id f16mr23653640jat.91.1597112767499;
 Mon, 10 Aug 2020 19:26:07 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1596468610.git.lucien.xin@gmail.com> <7ba2ca17347249b980731e7a76ba3e24a9e37720.1596468610.git.lucien.xin@gmail.com>
 <CAPA1RqCz=h-RBu-md1rJ5WLWsr9LLqO8bK9D=q6_vzYMz7564A@mail.gmail.com>
 <CADvbK_dSnrBkw_hJV8LVCEs9D-WB+h2QC3JghLCxVwV5PW9YYA@mail.gmail.com>
 <1f510387-b612-6cb4-8ee6-ff52f6ff6796@gmail.com> <CAPA1RqAFkQG-LBTcj80nt4CbWnE7ni+wgCBJU3-up7ROoR9-3w@mail.gmail.com>
 <CADvbK_eEQJUEZuJh4TwxFedR3qawt0HTyQ28rVeZVzecLk5_Ow@mail.gmail.com>
In-Reply-To: <CADvbK_eEQJUEZuJh4TwxFedR3qawt0HTyQ28rVeZVzecLk5_Ow@mail.gmail.com>
From:   Hideaki Yoshifuji <hideaki.yoshifuji@miraclelinux.com>
Date:   Tue, 11 Aug 2020 11:25:30 +0900
Message-ID: <CAPA1RqCaAB5R9Foz8rZHmAWtTQeKy8j-wVrOQ4XA6fGNxA307w@mail.gmail.com>
Subject: Re: [PATCH net 1/2] ipv6: add ipv6_dev_find()
To:     Xin Long <lucien.xin@gmail.com>
Cc:     David Ahern <dsahern@gmail.com>,
        network dev <netdev@vger.kernel.org>,
        davem <davem@davemloft.net>, Ying Xue <ying.xue@windriver.com>,
        tipc-discussion@lists.sourceforge.net,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>, jmaloy@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

2020=E5=B9=B48=E6=9C=889=E6=97=A5(=E6=97=A5) 19:52 Xin Long <lucien.xin@gma=
il.com>:
>
> On Fri, Aug 7, 2020 at 5:26 PM Hideaki Yoshifuji
> <hideaki.yoshifuji@miraclelinux.com> wrote:
> >
> > Hi,
> >
> > 2020=E5=B9=B48=E6=9C=886=E6=97=A5(=E6=9C=A8) 23:03 David Ahern <dsahern=
@gmail.com>:
> > >
> > > On 8/6/20 2:55 AM, Xin Long wrote:
> > > > On Thu, Aug 6, 2020 at 10:50 AM Hideaki Yoshifuji
> > > > <hideaki.yoshifuji@miraclelinux.com> wrote:
> > > >>
> > > >> Hi,
> > > >>
> > > >> 2020=E5=B9=B48=E6=9C=884=E6=97=A5(=E7=81=AB) 0:35 Xin Long <lucien=
.xin@gmail.com>:
> > > >>>
> > > >>> This is to add an ip_dev_find like function for ipv6, used to fin=
d
> > > >>> the dev by saddr.
> > > >>>
> > > >>> It will be used by TIPC protocol. So also export it.
> > > >>>
> > > >>> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> > > >>> ---
> > > >>>  include/net/addrconf.h |  2 ++
> > > >>>  net/ipv6/addrconf.c    | 39 ++++++++++++++++++++++++++++++++++++=
+++
> > > >>>  2 files changed, 41 insertions(+)
> > > >>>
> > > >>> diff --git a/include/net/addrconf.h b/include/net/addrconf.h
> > > >>> index 8418b7d..ba3f6c15 100644
> > > >>> --- a/include/net/addrconf.h
> > > >>> +++ b/include/net/addrconf.h
> > > >>> @@ -97,6 +97,8 @@ bool ipv6_chk_custom_prefix(const struct in6_ad=
dr *addr,
> > > >>>
> > > >>>  int ipv6_chk_prefix(const struct in6_addr *addr, struct net_devi=
ce *dev);
> > > >>>
> > > >>> +struct net_device *ipv6_dev_find(struct net *net, const struct i=
n6_addr *addr);
> > > >>> +
> > > >>
> > > >> How do we handle link-local addresses?
> > > > This is what "if (!result)" branch meant to do:
> > > >
> > > > +       if (!result) {
> > > > +               struct rt6_info *rt;
> > > > +
> > > > +               rt =3D rt6_lookup(net, addr, NULL, 0, NULL, 0);
> > > > +               if (rt) {
> > > > +                       dev =3D rt->dst.dev;
> > > > +                       ip6_rt_put(rt);
> > > > +               }
> > > > +       } else {
> > > > +               dev =3D result->idev->dev;
> > > > +       }
> > > >
> > >
> > > the stated purpose of this function is to find the netdevice to which=
 an
> > > address is attached. A route lookup should not be needed. Walking the
> > > address hash list finds the address and hence the netdev or it does n=
ot.
> > >
> > >
> >
> > User supplied scope id which should be set for link-local addresses
> > in TIPC_NLA_UDP_LOCAL attribute must be honored when we
> > check the address.
> Hi, Hideaki san,
>
> Sorry for not understanding your comment earlier.
>
> The bad thing is tipc in iproute2 doesn't seem able to set scope_id.

I looked into the iproute2 code quickly and I think it should; it uses
getaddrinfo(3) and it will fill if you say "fe80::1%eth0" or something
like that.... OR, fix the bug.

> I saw many places in kernel doing this check:
>
>                          if (__ipv6_addr_needs_scope_id(atype) &&
>                              !ip6->sin6_scope_id) { return -EINVAL; }
>
> Can I ask why scope id is needed for link-local addresses?
> and is that for link-local addresses only?

Because we distinguish link-local scope addresses on different interfaces.
On the other hand, we do not distinguish global scope addresses on
different interfaces.

>
> >
> > ipv6_chk_addr() can check if the address and supplied ifindex is a vali=
d
> > local address.  Or introduce an extra ifindex argument to ipv6_dev_find=
().
> Yeah, but if scope id means ifindex for  link-local addresses, ipv6_dev_f=
ind()
> would be more like a function to validate the address with right scope id=
.
>

I think we should find a net_device with a specific "valid" (non-tentative)
address here, and your initial implementation is not enough because it does
not reject tentative addresses.  I'd recommend using generic ipv6_chk_addr(=
)
inside.

> Thanks for your reviewing.
