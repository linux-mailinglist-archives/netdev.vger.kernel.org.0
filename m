Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 116DA3CCFE3
	for <lists+netdev@lfdr.de>; Mon, 19 Jul 2021 11:04:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235328AbhGSIWl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Jul 2021 04:22:41 -0400
Received: from mout.gmx.net ([212.227.17.21]:35513 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235073AbhGSIWk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Jul 2021 04:22:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1626685395;
        bh=hgrS4whYS4mlBgjCJJ3krDPj9t9aNc71BUlz4g1F6FU=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=OjiOCYEGAblNtLZA2LfU5MKYKfYvgZkOI2V+efNdUVRaFLdXbOOwFfPzGC+Ss/HoM
         aj+nHOhS8nGl9ao0SAckj/FAOKii+/IB21IczzqACldribc1YO7OzZZ1psBM47JAxA
         7yXhTK7VV45tTk5eTcVKT8SSCGZHYnRugyFMi5Ds=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [87.130.101.138] ([87.130.101.138]) by web-mail.gmx.net
 (3c-app-gmx-bap33.server.lan [172.19.172.103]) (via HTTP); Mon, 19 Jul 2021
 10:20:13 +0200
MIME-Version: 1.0
Message-ID: <trinity-e0322d42-d4ca-43a6-96d6-cfe89112ad9e-1626682813094@3c-app-gmx-bap33>
From:   Lino Sanfilippo <LinoSanfilippo@gmx.de>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, woojung.huh@microchip.com,
        UNGLinuxDriver@microchip.com, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Aw: Re: [PATCH 2/2] net: dsa: tag_ksz: dont let the hardware
 process the layer 4 checksum
Content-Type: text/plain; charset=UTF-8
Date:   Mon, 19 Jul 2021 10:20:13 +0200
Importance: normal
Sensitivity: Normal
In-Reply-To: <20210715143648.yutq6vceoblnhhfp@skbuf>
References: <20210714191723.31294-1-LinoSanfilippo@gmx.de>
 <20210714191723.31294-3-LinoSanfilippo@gmx.de>
 <20210714194812.stay3oqyw3ogshhj@skbuf> <YO9F2LhTizvr1l11@lunn.ch>
 <20210715065455.7nu7zgle2haa6wku@skbuf> <YPAzZXaC/En3s4ly@lunn.ch>
 <20210715143648.yutq6vceoblnhhfp@skbuf>
X-UI-Message-Type: mail
X-Priority: 3
X-Provags-ID: V03:K1:oyX0+TuW8PHL+WK/JEozk6jlWR2O/yBuSlUBcGgGWhBxNvMorJ0I01RBiHgA50eYXf8E8
 8sgNFp+WL6gbGwdyFBwyhFH4Ts381FPUkIMPfHIFAqJ8tC7CDwHr1JQH2gjUMBT1BHMK2jbyKNl1
 QPHt+BBnzcEbKXxy8Taqp5ShQ3wJ8Fkz4pEaGcD6hieK9aaGYKHhN4qg7Dpko3IUGgJj6h96lwkl
 7y/cSU7rk2a5BDjeROD+oAJB2GF4sZ7kf2CQmEUyoSDBohoDpmvHmbDyDB+Isqg1xruY1Kq0JLw+
 dY=
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:UrWgcxsN8To=:J4sw6C5qkIfBDmaTLY6kFg
 EkTgLaC4xKg6kQTcwnhoK/ud0HXNmD7R5bpeMUU7lHmCqEigX4+ZvHh/kbgk1diF+QmNF28dg
 O637nOtUORnFfMSXhRsQhjPOzwJXvuASxeI6DGqH0XFPAEc8/A+EOhcViRws0uZ3OWxvU4UlS
 1uWWgeDagQ4MrBAMOf8kEn6KIYi7LVcfHGHy7+QhC+NwTNBoYwrR+vjxjkaw7vA6FnqczN2VC
 ctvf4jJr236Mk+Qf2UpCZW+Szwn8hON7Cxldg3Tm76UUZ6QCdl9jQRyfbg0gLPeAWhXBTqCTi
 h/PylXplAfWWFym4Emh5iXsGLU8jF8UpBzDsXVYK8J9qZVeV2KlwGC+fbbgb7s5+lCnz0ZATT
 OoxgLY7DNCWUwJ0cvVa6vnh+Kt9M8vLnVHbuELY9nOp/Oqd5o32XJHrpwA0MiFRDsfWcWKxU6
 HlqE0Ce5cE7bzbEflOM6xD/75tmZCXJEioBf9+ED519gH81TGVfgYP4swb6+B2eYxsvcDBeU/
 qbe0IIC1QyNyYPzfjySNUFdXf4vemlEXILsc2oZ4UA6zJxNvA+MCb02PcYIeaJC+3NM2/FRJJ
 aucRfPUnUQDRhK7UC59wn6/l/LwJv/S+ETOEtiezdQxcbFKuF0Ge8qDtDdtjqNwA/LWC8pJmm
 miNL7IAbbp+TBDDJpzY6U9pzqGg8eRnDoos8Z1kas4H5AFDMWXjWHgqh03iTKoK/0FF0gfukL
 X9Wv2Or/KIhj++KJaJaMpuhPftmoaOvEkbWE10TPmM2fQtOmLFZES21jMlrKWhaPqEHv5O3WB
 CcukA53MmfbJlgSwN3n2SPaF0U5lQ==
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

> Gesendet: Donnerstag, 15. Juli 2021 um 16:36 Uhr
> Von: "Vladimir Oltean" <olteanv@gmail.com>
> An: "Andrew Lunn" <andrew@lunn.ch>
> Cc: "Lino Sanfilippo" <LinoSanfilippo@gmx.de>, woojung.huh@microchip.com=
, UNGLinuxDriver@microchip.com, vivien.didelot@gmail.com, f.fainelli@gmail=
.com, davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org, linux-=
kernel@vger.kernel.org
> Betreff: Re: [PATCH 2/2] net: dsa: tag_ksz: dont let the hardware proces=
s the layer 4 checksum
>
> On Thu, Jul 15, 2021 at 03:08:53PM +0200, Andrew Lunn wrote:
> > > - If we inherit NETIF_F_HW_CSUM from the master for tail taggers, it=
 is
> > >   actively detrimential to keep this feature enabled, as proven my L=
ino.
> > >   As for header taggers, I fail to see how this would be helpful, si=
nce
> > >   the DSA master would always fail to see the real IP header (it has
> > >   been pushed to the right by the DSA tag), and therefore, the DSA
> > >   master offload would be effectively bypassed.
> >
> > The Marvell MACs know about DSA and should be able to perform hardware
> > checksumming. It is a long time since i looked at how this works, but
> > i think there is a field in the descriptor which gets set with the
> > offset to the IP header, so it work for DSA as well as EDSA.
> >
> > I _think_ Broadcom MACs also know about Broadcom tags and can do the
> > right thing.
> >
> > So we need to be a bit careful here to prevent performance regressions
> > for same vendor MAC+Switch combinations.
>
> Tell me more (show me some code). Do Marvell Ethernet controllers which
> support TX checksumming with Marvell switches do different things
> depending on whether DSA or EDSA is used? Because we can currently
> toggle between DSA and EDSA at runtime.
>
> This new information means we can only accept Lino's patch 2/2 as-is for
> the "net" tree, otherwise we will introduce regressions one way or
> another. It will only be a partial fix for the particular case of KSZ
> switches which probably have no DSA master counterpart to support TX
> checksumming.
>

Should I then resend the series with patch 1 handling the NETIF_F_SG and
NETIF_F_FRAGLIST flags (i.e. deleting them if tailroom is needed) in
dsa_slave_setup_tagger() as you suggested and patch 2 as it is?

Regards,
Lino
