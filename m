Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 501AB3C9D9D
	for <lists+netdev@lfdr.de>; Thu, 15 Jul 2021 13:16:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241864AbhGOLTR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Jul 2021 07:19:17 -0400
Received: from mout.gmx.net ([212.227.17.20]:36537 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241852AbhGOLTR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Jul 2021 07:19:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1626347772;
        bh=TLXUsDdT2Ni6P1bd2RJdAeMmR/wZbLbHTRLAmPJxv9U=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=HBxW61sAJodPP7wxHBOZdiu36Jbz9H+AMbkbpijQprGXDaTmY7QuXjxCAhpxzsikX
         Iz22GxP85dV0s5RnKDUPPj7ZKwxdstEPALAbBg5MCzfwMmHJLNqu5vvwDHbx7H2Z5i
         5+4DaiJyCwJJDLid9wJU72zKRJVDrz1/czbUsDPE=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [87.130.101.138] ([87.130.101.138]) by web-mail.gmx.net
 (3c-app-gmx-bap31.server.lan [172.19.172.101]) (via HTTP); Thu, 15 Jul 2021
 13:16:12 +0200
MIME-Version: 1.0
Message-ID: <trinity-84a570e8-7b5f-44f7-b10c-169d4307d653-1626347772540@3c-app-gmx-bap31>
From:   Lino Sanfilippo <LinoSanfilippo@gmx.de>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, woojung.huh@microchip.com,
        UNGLinuxDriver@microchip.com, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Aw: Re: [PATCH 2/2] net: dsa: tag_ksz: dont let the hardware
 process the layer 4 checksum
Content-Type: text/plain; charset=UTF-8
Date:   Thu, 15 Jul 2021 13:16:12 +0200
Importance: normal
Sensitivity: Normal
In-Reply-To: <20210715065455.7nu7zgle2haa6wku@skbuf>
References: <20210714191723.31294-1-LinoSanfilippo@gmx.de>
 <20210714191723.31294-3-LinoSanfilippo@gmx.de>
 <20210714194812.stay3oqyw3ogshhj@skbuf> <YO9F2LhTizvr1l11@lunn.ch>
 <20210715065455.7nu7zgle2haa6wku@skbuf>
X-UI-Message-Type: mail
X-Priority: 3
X-Provags-ID: V03:K1:CxxzBKXA9/qQJnsYgLSgPmS6MXvvV0h4Kj1Fl2Xg5dCkDIN0g9efjUiBvzt36HXv+xA71
 N+F2XpU2MS7kk1PaxtzWsfM1ujMmwTGnIvVypWa+rT6BogXiXuuMnYaDCOO6xGRNXHhzzLA+SLUQ
 TUWaCLO4wsAq9HmQr0kLPMxGTh8mflK+ATN3HHxkOw5Ghgn880EOViy5cu36EupiTcGBZxDt/jsF
 WnEOYl8AXNCetaMGN09GT1Q41h5IyxQdxY35Wxp2v+pI/m/QcN6P3UBPDDnd2FMBdEZx2JQNWuZb
 Cg=
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:tFCbLYKOsxI=:hcAc+94wjwYA1qNadjyAij
 PL8NfrQtYM5aC7v4qjlz7YdGgnglSoobRAWrEdqWWH9WS8R54gLaKaED+Jm/7WRnCqiuKtr3V
 WC4JVQ3nyFcA9F4njhgwFG2JOXBjORL4K2iByBtzbeecwprA6hadRlRK3nYxl/H7CVbqPliAd
 cuqqJT+llBhKpxZrVnvrOZqsSA9JW/cBchm0I1Q5aoS2yjoYmWDYTRLcLtYSLDFVMOosdIUzl
 i23W+0yxIDqMX227rC8et2tuVKixVBA/JJiGTamSxjMbE6BfCA54sU7668wFRMLi0njTHMjNn
 0adz+KyNvpA3yKJslSK8yl5O7hYbEXInAyh7HtHuJ40rGYH48MqitNsK8p52HmeT9mH4uOQbQ
 PRv0B8/2fwEoBplb33wqORf4CmRJcGWmUv3RV2pWAZ9BR5NWVMFinYno8GQY3nQVW14mM18c5
 91HVTAjl85WbKKasm1T69ii62szoq+gSBO17rDqgCZVCahknT3e+iYKLFmENayUdvBpmXKfPm
 8y+WL69RWGthcWJBLl4HWrTG/nO1AK6a67QqVLBxhRmE6JA610dOB9pGa+XgWvGuaJTt7nYjF
 raD1109waV1BFEuYTj6n9MdAextpFmgtUM4bb2BCq0PtHbhXQYkIsktzBIGjAk1uBJZR8jdZT
 H/X4U6rJaMhHp+M85WoBWHB6UT0C9Gk7DRLXD3vaarVRkHFpy2wgUpV2I2AOcvU2z9GVbpKLJ
 9hcMOWcvclLSqruz+i2HIG+GX0ZrPe5siIsEOSuP/1M9IJBVJRkbDAcWFkHSPaDFPXDlkabe0
 J5AR9JhoDTV4deyi7u3zgN1jkOqGNZfsYSKYLM1ix1oxkACZ7o=
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vladimir,

> Gesendet: Donnerstag, 15. Juli 2021 um 08:54 Uhr
> Von: "Vladimir Oltean" <olteanv@gmail.com>
> An: "Andrew Lunn" <andrew@lunn.ch>
> Cc: "Lino Sanfilippo" <LinoSanfilippo@gmx.de>, woojung.huh@microchip.com=
, UNGLinuxDriver@microchip.com, vivien.didelot@gmail.com, f.fainelli@gmail=
.com, davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org, linux-=
kernel@vger.kernel.org
> Betreff: Re: [PATCH 2/2] net: dsa: tag_ksz: dont let the hardware proces=
s the layer 4 checksum
>
> On Wed, Jul 14, 2021 at 10:15:20PM +0200, Andrew Lunn wrote:
> > On Wed, Jul 14, 2021 at 10:48:12PM +0300, Vladimir Oltean wrote:
> > > Hi Lino,
> > >
> > > On Wed, Jul 14, 2021 at 09:17:23PM +0200, Lino Sanfilippo wrote:
> > > > If the checksum calculation is offloaded to the network device (e.=
g due to
> > > > NETIF_F_HW_CSUM inherited from the DSA master device), the calcula=
ted
> > > > layer 4 checksum is incorrect. This is since the DSA tag which is =
placed
> > > > after the layer 4 data is seen as a part of the data portion and t=
hus
> > > > errorneously included into the checksum calculation.
> > > > To avoid this, always calculate the layer 4 checksum in software.
> > > >
> > > > Signed-off-by: Lino Sanfilippo <LinoSanfilippo@gmx.de>
> > > > ---
> > >
> > > This needs to be solved more generically for all tail taggers. Let m=
e
> > > try out a few things tomorrow and come with a proposal.
> >
> > Maybe the skb_linearize() is also a generic problem, since many of the
> > tag drivers are using skb_put()? It looks like skb_linearize() is
> > cheap because checking if the skb is already linear is cheap. So maybe
> > we want to do it unconditionally?
>
> Yeah, but we should let the stack deal with both issues in validate_xmit=
_skb().
> There is a skb_needs_linearize() call which returns false because the
> DSA interface inherits NETIF_F_SG from the master via dsa_slave_create()=
:
>
> 	slave_dev->features =3D master->vlan_features | NETIF_F_HW_TC;
>
> Arguably that's the problem right there, we shouldn't inherit neither
> NETIF_F_HW_CSUM nor NETIF_F_SG from the list of features inheritable by
> 8021q uppers.
>
> - If we inherit NETIF_F_SG we obligate ourselves to call skb_linearize()
>   for tail taggers on xmit. DSA probably doesn't break anything for
>   header taggers though even if the xmit skb is paged, since the DSA
>   header would always be part of the skb head, so this is a feature we
>   could keep for them.
> - If we inherit NETIF_F_HW_CSUM from the master for tail taggers, it is
>   actively detrimential to keep this feature enabled, as proven my Lino.
>   As for header taggers, I fail to see how this would be helpful, since
>   the DSA master would always fail to see the real IP header (it has
>   been pushed to the right by the DSA tag), and therefore, the DSA
>   master offload would be effectively bypassed. So no point, really, in
>   inheriting it in the first place in any situation.
>
> Lino, to fix these bugs by letting validate_xmit_skb() know what works
> for DSA and what doesn't, could you please:
>
> (a) move the current slave_dev->features assignment to
>     dsa_slave_setup_tagger()? We now support changing the tagging
>     protocol at runtime, and everything that depends on what the tagging
>     protocol is (in this case, tag_ops->needed_headroom vs
>     tag_ops->needed_tailroom) should be put in that function.
> (b) unconditionally clear NETIF_F_HW_CSUM from slave_dev->features,
>     after inheriting the vlan_features from the master?
> (c) clear NETIF_F_SG from slave_dev->features if we have a non-zero
>     tag_ops->needed_tailroom?
>

Sure, I will test this solution. But I think NETIF_F_FRAGLIST should also =
be
cleared in this case, right?


Regards,
Lino
