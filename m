Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB77F243D0B
	for <lists+netdev@lfdr.de>; Thu, 13 Aug 2020 18:13:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726546AbgHMQNf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Aug 2020 12:13:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726167AbgHMQNe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Aug 2020 12:13:34 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41E8FC061757
        for <netdev@vger.kernel.org>; Thu, 13 Aug 2020 09:13:34 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id 9so5163280wmj.5
        for <netdev@vger.kernel.org>; Thu, 13 Aug 2020 09:13:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=uNtpikjN5hkd0GhY+r23eU7dwsydeFA2mxTgwagKD18=;
        b=RTZpt5pgVN93t1zNpXz4l8CyGQBA/tqiHavHH3YcodidZPD/kIwMFAJ8uMbOh8ZK6K
         /gN2gjq1UJIpriebOOpO35qlSbmu/7KMfeYmOtBnoMcoiPEn7sTVmE2M7PdzIgUPKbR8
         0PPLgW9hyJorFrRA8Xv2XGLUB3qgbVRth4gMcjVgFgun1Pvio083nQ9uOWzNEn5mHA8C
         2ix9VhBBIz3PSIGU+fJeDuDZz/BpCoiuzy6SOdDaepG+qN0bS9aOTsmbF3A6VpxRDgmW
         Ojy0GjccE74iFTfqu81HfAopDop+BBWlcEIyQ+ynChIpvmgctKz2CVHBTaXTtxo2j21K
         /V0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=uNtpikjN5hkd0GhY+r23eU7dwsydeFA2mxTgwagKD18=;
        b=gSFPUEuRj9UXWFCCvRg0nPLXC+vYQQViqSx/LszbuKe7/qnKfBXcFIIK01cAYsZD0/
         vCDVpz2/3gO8FTGtxCaEm/dRjm9DHtFiwxeVVyWUPko7A1ZU6nXPfHeAYpOgJVK5fCjG
         jGuoFU7J5Jwb3KxVDE+H3dGlaaJioBS/0X8LEyWy9w+SV5nO9OsYEXXN18bBdoYfrmkV
         AWer04N4v4Wy3snKfz+j+aUDuJ79bksX1szi3VmAINvepo2hJKVWyfG+vaM/IoP4e6S6
         BN90Uryb1WQqbIArY1WCb4dY3j7reirfRsSbHWYK0GuCb4OfGPqqGyfN8/YtS1s0HgOx
         wRXQ==
X-Gm-Message-State: AOAM531KUBZTUvChXb3gwxbbEo4OgmZa9Nn46mgrv+vHV4y556glJNwa
        t+OWwwXzxba7T4kHwKaF55dHzH+LCjKgrDmn8S8=
X-Google-Smtp-Source: ABdhPJxtFwQig3coQy7/cipS78Uk/t5kKv7ZB2nG9mtekBCcICaT81d7Kb4E/tpbxQIRtNSydRie0uhpc2meRt14lNo=
X-Received: by 2002:a1c:3dc3:: with SMTP id k186mr4942467wma.122.1597335212822;
 Thu, 13 Aug 2020 09:13:32 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1596468610.git.lucien.xin@gmail.com> <7ba2ca17347249b980731e7a76ba3e24a9e37720.1596468610.git.lucien.xin@gmail.com>
 <CAPA1RqCz=h-RBu-md1rJ5WLWsr9LLqO8bK9D=q6_vzYMz7564A@mail.gmail.com>
 <CADvbK_dSnrBkw_hJV8LVCEs9D-WB+h2QC3JghLCxVwV5PW9YYA@mail.gmail.com>
 <1f510387-b612-6cb4-8ee6-ff52f6ff6796@gmail.com> <CAPA1RqAFkQG-LBTcj80nt4CbWnE7ni+wgCBJU3-up7ROoR9-3w@mail.gmail.com>
 <CADvbK_eEQJUEZuJh4TwxFedR3qawt0HTyQ28rVeZVzecLk5_Ow@mail.gmail.com> <CAPA1RqCaAB5R9Foz8rZHmAWtTQeKy8j-wVrOQ4XA6fGNxA307w@mail.gmail.com>
In-Reply-To: <CAPA1RqCaAB5R9Foz8rZHmAWtTQeKy8j-wVrOQ4XA6fGNxA307w@mail.gmail.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Fri, 14 Aug 2020 00:25:48 +0800
Message-ID: <CADvbK_do4gfPHvKt7gah5McipW4pFcLC2RKiaZ07Un9HLVJX=g@mail.gmail.com>
Subject: Re: [PATCH net 1/2] ipv6: add ipv6_dev_find()
To:     Hideaki Yoshifuji <hideaki.yoshifuji@miraclelinux.com>
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

On Tue, Aug 11, 2020 at 10:26 AM Hideaki Yoshifuji
<hideaki.yoshifuji@miraclelinux.com> wrote:
>
> Hi,
>
> 2020=E5=B9=B48=E6=9C=889=E6=97=A5(=E6=97=A5) 19:52 Xin Long <lucien.xin@g=
mail.com>:
> >
> > On Fri, Aug 7, 2020 at 5:26 PM Hideaki Yoshifuji
> > <hideaki.yoshifuji@miraclelinux.com> wrote:
> > >
> > > Hi,
> > >
> > > 2020=E5=B9=B48=E6=9C=886=E6=97=A5(=E6=9C=A8) 23:03 David Ahern <dsahe=
rn@gmail.com>:
> > > >
> > > > On 8/6/20 2:55 AM, Xin Long wrote:
> > > > > On Thu, Aug 6, 2020 at 10:50 AM Hideaki Yoshifuji
> > > > > <hideaki.yoshifuji@miraclelinux.com> wrote:
> > > > >>
> > > > >> Hi,
> > > > >>
> > > > >> 2020=E5=B9=B48=E6=9C=884=E6=97=A5(=E7=81=AB) 0:35 Xin Long <luci=
en.xin@gmail.com>:
> > > > >>>
> > > > >>> This is to add an ip_dev_find like function for ipv6, used to f=
ind
> > > > >>> the dev by saddr.
> > > > >>>
> > > > >>> It will be used by TIPC protocol. So also export it.
> > > > >>>
> > > > >>> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> > > > >>> ---
> > > > >>>  include/net/addrconf.h |  2 ++
> > > > >>>  net/ipv6/addrconf.c    | 39 ++++++++++++++++++++++++++++++++++=
+++++
> > > > >>>  2 files changed, 41 insertions(+)
> > > > >>>
> > > > >>> diff --git a/include/net/addrconf.h b/include/net/addrconf.h
> > > > >>> index 8418b7d..ba3f6c15 100644
> > > > >>> --- a/include/net/addrconf.h
> > > > >>> +++ b/include/net/addrconf.h
> > > > >>> @@ -97,6 +97,8 @@ bool ipv6_chk_custom_prefix(const struct in6_=
addr *addr,
> > > > >>>
> > > > >>>  int ipv6_chk_prefix(const struct in6_addr *addr, struct net_de=
vice *dev);
> > > > >>>
> > > > >>> +struct net_device *ipv6_dev_find(struct net *net, const struct=
 in6_addr *addr);
> > > > >>> +
> > > > >>
> > > > >> How do we handle link-local addresses?
> > > > > This is what "if (!result)" branch meant to do:
> > > > >
> > > > > +       if (!result) {
> > > > > +               struct rt6_info *rt;
> > > > > +
> > > > > +               rt =3D rt6_lookup(net, addr, NULL, 0, NULL, 0);
> > > > > +               if (rt) {
> > > > > +                       dev =3D rt->dst.dev;
> > > > > +                       ip6_rt_put(rt);
> > > > > +               }
> > > > > +       } else {
> > > > > +               dev =3D result->idev->dev;
> > > > > +       }
> > > > >
> > > >
> > > > the stated purpose of this function is to find the netdevice to whi=
ch an
> > > > address is attached. A route lookup should not be needed. Walking t=
he
> > > > address hash list finds the address and hence the netdev or it does=
 not.
> > > >
> > > >
> > >
> > > User supplied scope id which should be set for link-local addresses
> > > in TIPC_NLA_UDP_LOCAL attribute must be honored when we
> > > check the address.
> > Hi, Hideaki san,
> >
> > Sorry for not understanding your comment earlier.
> >
> > The bad thing is tipc in iproute2 doesn't seem able to set scope_id.
>
> I looked into the iproute2 code quickly and I think it should; it uses
> getaddrinfo(3) and it will fill if you say "fe80::1%eth0" or something
> like that.... OR, fix the bug.
right, thanks.

>
> > I saw many places in kernel doing this check:
> >
> >                          if (__ipv6_addr_needs_scope_id(atype) &&
> >                              !ip6->sin6_scope_id) { return -EINVAL; }
> >
> > Can I ask why scope id is needed for link-local addresses?
> > and is that for link-local addresses only?
>
> Because we distinguish link-local scope addresses on different interfaces=
.
> On the other hand, we do not distinguish global scope addresses on
> different interfaces.
okay.

>
> >
> > >
> > > ipv6_chk_addr() can check if the address and supplied ifindex is a va=
lid
> > > local address.  Or introduce an extra ifindex argument to ipv6_dev_fi=
nd().
> > Yeah, but if scope id means ifindex for  link-local addresses, ipv6_dev=
_find()
> > would be more like a function to validate the address with right scope =
id.
> >
>
> I think we should find a net_device with a specific "valid" (non-tentativ=
e)
> address here, and your initial implementation is not enough because it do=
es
> not reject tentative addresses.  I'd recommend using generic ipv6_chk_add=
r()
> inside.
ipv6_chk_addr() is calling ipv6_chk_addr_and_flags(), which traverses
the addr hash list again. So I'm thinking to reuse the code of
ipv6_chk_addr_and_flags(), and do:

+static struct net_device *
+__ipv6_chk_addr_and_flags(struct net *net, const struct in6_addr *addr,
+                         const struct net_device *dev, bool skip_dev_check=
,
+                         int strict, u32 banned_flags)
 {
        unsigned int hash =3D inet6_addr_hash(net, addr);
        const struct net_device *l3mdev;
@@ -1926,12 +1918,29 @@ int ipv6_chk_addr_and_flags(struct net *net,
const struct in6_addr *addr,
                    (!dev || ifp->idev->dev =3D=3D dev ||
                     !(ifp->scope&(IFA_LINK|IFA_HOST) || strict))) {
                        rcu_read_unlock();
-                       return 1;
+                       return ifp->idev->dev;
                }
        }

        rcu_read_unlock();
-       return 0;
+       return NULL;
+}

and change these functions to :

int ipv6_chk_addr_and_flags(struct net *net, const struct in6_addr *addr,
                            const struct net_device *dev, bool skip_dev_che=
ck,
                            int strict, u32 banned_flags)
{
        return __ipv6_chk_addr_and_flags(net, addr, dev, skip_dev_check,
                                         strict, banned_flags) ? 1 : 0;
}
EXPORT_SYMBOL(ipv6_chk_addr_and_flags);

struct net_device *ipv6_dev_find(struct net *net, const struct in6_addr *ad=
dr,
                                 struct net_device *dev)
{
        return __ipv6_chk_addr_and_flags(net, addr, NULL, 0, 1,
                                         IFA_F_TENTATIVE);
}
EXPORT_SYMBOL(ipv6_dev_find);

what do you think?
