Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0394923D81A
	for <lists+netdev@lfdr.de>; Thu,  6 Aug 2020 10:43:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728669AbgHFIne (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Aug 2020 04:43:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727768AbgHFInc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Aug 2020 04:43:32 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A450C061574
        for <netdev@vger.kernel.org>; Thu,  6 Aug 2020 01:43:32 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id r2so38091408wrs.8
        for <netdev@vger.kernel.org>; Thu, 06 Aug 2020 01:43:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=urzeHCcm6K9XhQ4DTjdXcMx1gCVB7hAPwo7rpbCj1hk=;
        b=opxlIC9v+wiIQhTSQcaMlTQDE58v57GGFz5A9bGSDE2PHbr09FH8+H62WZnlT0VDx4
         E5fbsLO472fTJ7Es/Br8A1yyfwmn6OD+69yPkwZtQGbtYEOurK1B+rk5nfqsNZm3lFsU
         vI+/PUEK2idY7rmFk5yB0TCV/3LjYMamJknRk4A6RLGbLnjjMKF96TJYgYzvcp+OnK9g
         Q0jYmTzSiUUyWfTTd5FshgaA89QSggb3Dhehe1FOYZeczmnEdlncWzUnubHMFdkx7Fg0
         /QqJRei+Q1ymQ/iXGcQUskLtrboDtA16ar+0Z/nVI8l5ludqLLfCYbNMUP1ODzltjb5l
         K47w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=urzeHCcm6K9XhQ4DTjdXcMx1gCVB7hAPwo7rpbCj1hk=;
        b=WJM3Iu5yowPG0gjEmqOk+Tz9QQwa8IwKz+Ha92aqWmgstrZP5iacaBU2zFpnDs2HD9
         aGKTPY8c7aReUuNOEoH2fyqHP7/R7aOU5Pjzq7C7nS6bQGz0Vuzuk66nnBems/eDWk7J
         d6h9E907yvA62EKorh2zD51dRbCsu4esyZKZW9pyWrSUHpjU6vTgsAbCIx1IfHBT/g+2
         utesXfkk9OrgzVVGEor4cl4waCl98BCtzi+/U9Ip2vgpya9XE58S8cKt3lFVk42Ojsff
         PHSzKMKJ62pGWkrqvAMGPaTMFvkSMQSQH/dKaVvofaFxsHM1StnsULYqzPhJThv143IX
         40RQ==
X-Gm-Message-State: AOAM5336IR271vXmrRyr8Yp+oSbx7/NjgBjnSDnDEFHiN2/Cp5wpP82F
        the2Pw85YOzRNTIIW5IpXqegO610NATETPanCKA=
X-Google-Smtp-Source: ABdhPJy+7NNjOh33qMpG+sJTalrTxVeTAX8ySPJHWaNIj1LwpcaBtrJAHB02ZesjX107wd6HK3Sck0DHwv6a40Ulzao=
X-Received: by 2002:adf:df89:: with SMTP id z9mr6373067wrl.395.1596703410648;
 Thu, 06 Aug 2020 01:43:30 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1596468610.git.lucien.xin@gmail.com> <7ba2ca17347249b980731e7a76ba3e24a9e37720.1596468610.git.lucien.xin@gmail.com>
 <CAPA1RqCz=h-RBu-md1rJ5WLWsr9LLqO8bK9D=q6_vzYMz7564A@mail.gmail.com>
In-Reply-To: <CAPA1RqCz=h-RBu-md1rJ5WLWsr9LLqO8bK9D=q6_vzYMz7564A@mail.gmail.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Thu, 6 Aug 2020 16:55:15 +0800
Message-ID: <CADvbK_dSnrBkw_hJV8LVCEs9D-WB+h2QC3JghLCxVwV5PW9YYA@mail.gmail.com>
Subject: Re: [PATCH net 1/2] ipv6: add ipv6_dev_find()
To:     Hideaki Yoshifuji <hideaki.yoshifuji@miraclelinux.com>,
        David Ahern <dsahern@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, davem <davem@davemloft.net>,
        Jon Maloy <jon.maloy@ericsson.com>,
        Ying Xue <ying.xue@windriver.com>,
        tipc-discussion@lists.sourceforge.net,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 6, 2020 at 10:50 AM Hideaki Yoshifuji
<hideaki.yoshifuji@miraclelinux.com> wrote:
>
> Hi,
>
> 2020=E5=B9=B48=E6=9C=884=E6=97=A5(=E7=81=AB) 0:35 Xin Long <lucien.xin@gm=
ail.com>:
> >
> > This is to add an ip_dev_find like function for ipv6, used to find
> > the dev by saddr.
> >
> > It will be used by TIPC protocol. So also export it.
> >
> > Signed-off-by: Xin Long <lucien.xin@gmail.com>
> > ---
> >  include/net/addrconf.h |  2 ++
> >  net/ipv6/addrconf.c    | 39 +++++++++++++++++++++++++++++++++++++++
> >  2 files changed, 41 insertions(+)
> >
> > diff --git a/include/net/addrconf.h b/include/net/addrconf.h
> > index 8418b7d..ba3f6c15 100644
> > --- a/include/net/addrconf.h
> > +++ b/include/net/addrconf.h
> > @@ -97,6 +97,8 @@ bool ipv6_chk_custom_prefix(const struct in6_addr *ad=
dr,
> >
> >  int ipv6_chk_prefix(const struct in6_addr *addr, struct net_device *de=
v);
> >
> > +struct net_device *ipv6_dev_find(struct net *net, const struct in6_add=
r *addr);
> > +
>
> How do we handle link-local addresses?
This is what "if (!result)" branch meant to do:

+       if (!result) {
+               struct rt6_info *rt;
+
+               rt =3D rt6_lookup(net, addr, NULL, 0, NULL, 0);
+               if (rt) {
+                       dev =3D rt->dst.dev;
+                       ip6_rt_put(rt);
+               }
+       } else {
+               dev =3D result->idev->dev;
+       }

Thanks.

>
> --yoshfuji
>
> >  struct inet6_ifaddr *ipv6_get_ifaddr(struct net *net,
> >                                      const struct in6_addr *addr,
> >                                      struct net_device *dev, int strict=
);
> > diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
> > index 840bfdb..857d6f9 100644
> > --- a/net/ipv6/addrconf.c
> > +++ b/net/ipv6/addrconf.c
> > @@ -1983,6 +1983,45 @@ int ipv6_chk_prefix(const struct in6_addr *addr,=
 struct net_device *dev)
> >  }
> >  EXPORT_SYMBOL(ipv6_chk_prefix);
> >
> > +/**
> > + * ipv6_dev_find - find the first device with a given source address.
> > + * @net: the net namespace
> > + * @addr: the source address
> > + *
> > + * The caller should be protected by RCU, or RTNL.
> > + */
> > +struct net_device *ipv6_dev_find(struct net *net, const struct in6_add=
r *addr)
> > +{
> > +       unsigned int hash =3D inet6_addr_hash(net, addr);
> > +       struct inet6_ifaddr *ifp, *result =3D NULL;
> > +       struct net_device *dev =3D NULL;
> > +
> > +       rcu_read_lock();
> > +       hlist_for_each_entry_rcu(ifp, &inet6_addr_lst[hash], addr_lst) =
{
> > +               if (net_eq(dev_net(ifp->idev->dev), net) &&
> > +                   ipv6_addr_equal(&ifp->addr, addr)) {
> > +                       result =3D ifp;
> > +                       break;
> > +               }
> > +       }
> > +
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
> > +       rcu_read_unlock();
> > +
> > +       return dev;
> > +}
> > +EXPORT_SYMBOL(ipv6_dev_find);
> > +
> >  struct inet6_ifaddr *ipv6_get_ifaddr(struct net *net, const struct in6=
_addr *addr,
> >                                      struct net_device *dev, int strict=
)
> >  {
> > --
> > 2.1.0
> >
