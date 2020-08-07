Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1CA823E7C5
	for <lists+netdev@lfdr.de>; Fri,  7 Aug 2020 09:19:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726683AbgHGHTM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Aug 2020 03:19:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725805AbgHGHTI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Aug 2020 03:19:08 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95AB7C061574
        for <netdev@vger.kernel.org>; Fri,  7 Aug 2020 00:19:08 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id a14so704344wra.5
        for <netdev@vger.kernel.org>; Fri, 07 Aug 2020 00:19:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=d2T3t9Lmip1QSDYwISNFv4oDhCFreV7+ybaIsFva4kc=;
        b=S6jUyYGtTWAGs9N6MOWwZZDHBMGf+CKcmvgcJKcy03/3nFDtNSXsZFxy6Hpl+4TcBP
         F03iRVcIe7JyE8wRoB9/9VbO/uUMAJgm8bJwePe3hBIYsmn7Nfhej5Ka8+oGGipTOHq6
         wgCiesbyRlDGWBrhEpXtyuDZTEBfdeLc40YD5ArgKAYtkEWsWVyuptfvVdX7kGYVUABM
         owq0eIjQqRchDtyuV1Ihu2nth4x3lvAqqp+LGNpmEa+8QCi2A4mgPdz05bl9Eh6MdSCZ
         wWz30gBPzFFMxtkA2K06N79jZYJRDlfuUn4oLWFcdvVWJYYClvlcT61XwczE/el75wkm
         5sTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=d2T3t9Lmip1QSDYwISNFv4oDhCFreV7+ybaIsFva4kc=;
        b=oJFutHapD5lNVSqhHZIX1yxoAjJSkW15tbVZVzo4ncWAlhoWpA/4CRjXKl4eQ0mSwV
         yIjxO8Z8NzQdyxKkyeF/uJjMrD+mHNizBjw4fD9WmXdoyxSDYWkhYTtzuKnZBf4uROiu
         F13XQ7fZO4Z1mZBbnljQP1Gab4mKIMLjtCgNdPWEKuIEN1A/YPUEEMZGIZJd5+so9uZO
         F9X4FRwJFbhsBsr9IvJs6ZiCXxV4eurGPZgIT2gY8wMjSRUzMUBg7n72kLk3Hn+7QiHQ
         B1F0pEfHRy6RB6mFKe7CopAcoJ/zahCK9sfdcPEIcSd6YYbU/0FmWBhU62YW3B0fjMZV
         OR3A==
X-Gm-Message-State: AOAM532Ze3yjtfMczf59aWvVo12yiFNoAsKU5gp1OY/j/GymAZqWzz/z
        uKk2J6Df1UMpyL4bjwqEeiZw+9zdThyCUw8QfrY+HtFiX+8=
X-Google-Smtp-Source: ABdhPJyHsW0q5++Rz1EhEe9OOA/wEeiAlIuH6k+8Gs+yKaXLwYQYu5ihQ9I+ijplJf3iixQMEOZ2naS89PzU1rAimGw=
X-Received: by 2002:adf:df89:: with SMTP id z9mr10810430wrl.395.1596784747339;
 Fri, 07 Aug 2020 00:19:07 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1596468610.git.lucien.xin@gmail.com> <7ba2ca17347249b980731e7a76ba3e24a9e37720.1596468610.git.lucien.xin@gmail.com>
 <CAPA1RqCz=h-RBu-md1rJ5WLWsr9LLqO8bK9D=q6_vzYMz7564A@mail.gmail.com>
 <CADvbK_dSnrBkw_hJV8LVCEs9D-WB+h2QC3JghLCxVwV5PW9YYA@mail.gmail.com> <1f510387-b612-6cb4-8ee6-ff52f6ff6796@gmail.com>
In-Reply-To: <1f510387-b612-6cb4-8ee6-ff52f6ff6796@gmail.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Fri, 7 Aug 2020 15:30:58 +0800
Message-ID: <CADvbK_f+NK9Zf+t-7xfzA7T8Xftw+CdoEW6jy=V6TDqT6PQ_AA@mail.gmail.com>
Subject: Re: [PATCH net 1/2] ipv6: add ipv6_dev_find()
To:     David Ahern <dsahern@gmail.com>, Ying Xue <ying.xue@windriver.com>
Cc:     Hideaki Yoshifuji <hideaki.yoshifuji@miraclelinux.com>,
        network dev <netdev@vger.kernel.org>,
        davem <davem@davemloft.net>, Jon Maloy <jon.maloy@ericsson.com>,
        tipc-discussion@lists.sourceforge.net,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 6, 2020 at 10:03 PM David Ahern <dsahern@gmail.com> wrote:
>
> On 8/6/20 2:55 AM, Xin Long wrote:
> > On Thu, Aug 6, 2020 at 10:50 AM Hideaki Yoshifuji
> > <hideaki.yoshifuji@miraclelinux.com> wrote:
> >>
> >> Hi,
> >>
> >> 2020=E5=B9=B48=E6=9C=884=E6=97=A5(=E7=81=AB) 0:35 Xin Long <lucien.xin=
@gmail.com>:
> >>>
> >>> This is to add an ip_dev_find like function for ipv6, used to find
> >>> the dev by saddr.
> >>>
> >>> It will be used by TIPC protocol. So also export it.
> >>>
> >>> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> >>> ---
> >>>  include/net/addrconf.h |  2 ++
> >>>  net/ipv6/addrconf.c    | 39 +++++++++++++++++++++++++++++++++++++++
> >>>  2 files changed, 41 insertions(+)
> >>>
> >>> diff --git a/include/net/addrconf.h b/include/net/addrconf.h
> >>> index 8418b7d..ba3f6c15 100644
> >>> --- a/include/net/addrconf.h
> >>> +++ b/include/net/addrconf.h
> >>> @@ -97,6 +97,8 @@ bool ipv6_chk_custom_prefix(const struct in6_addr *=
addr,
> >>>
> >>>  int ipv6_chk_prefix(const struct in6_addr *addr, struct net_device *=
dev);
> >>>
> >>> +struct net_device *ipv6_dev_find(struct net *net, const struct in6_a=
ddr *addr);
> >>> +
> >>
> >> How do we handle link-local addresses?
> > This is what "if (!result)" branch meant to do:
> >
> > +       if (!result) {
> > +               struct rt6_info *rt;
> > +
> > +               rt =3D rt6_lookup(net, addr, NULL, 0, NULL, 0);
> > +               if (rt) {
> > +                       dev =3D rt->dst.dev;
> > +                       ip6_rt_put(rt);
> > +               }
> > +       } else {
> > +               dev =3D result->idev->dev;
> > +       }
> >
>
> the stated purpose of this function is to find the netdevice to which an
> address is attached. A route lookup should not be needed. Walking the
> address hash list finds the address and hence the netdev or it does not.
Hi, David,
Sorry. it does. I misunderstood the code in __ip_dev_find().
I will delete the rt6_lookup() part from ipv6_dev_find().

Also for the compatibility, tipc part should change to:
@@ -741,10 +741,8 @@ static int tipc_udp_enable(struct net *net,
struct tipc_bearer *b,
                struct net_device *dev;

               dev =3D ipv6_dev_find(net, &local.ipv6);
               if (!dev)
                      ub->ifindex =3D dev->ifindex;

as when dev is not found from the hash list, it should fall back to
the old tipc code.

Ying, what do you think?
