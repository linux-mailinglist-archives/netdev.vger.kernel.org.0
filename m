Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5512940890A
	for <lists+netdev@lfdr.de>; Mon, 13 Sep 2021 12:32:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239091AbhIMKdt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Sep 2021 06:33:49 -0400
Received: from mout.gmx.net ([212.227.17.21]:42875 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238846AbhIMKdr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Sep 2021 06:33:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1631529134;
        bh=wo/zYNHbmwqWHPTYaD4fECkvZkCdNhbPCdSJYZnhq6o=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=XpChBSD8F91ysTehBQS9ZVLVLeuttaE6lxQw5AZ6qcN9tI1ADR1TugDgtH9FO6f5f
         tNF160UTMI7xOBPklUVo3gqQk2HC24f0ZeHypSm8AfZfyU2b1PrOin2H7PcGNIUWSi
         6qDqlbU0mh2aq1CqHn1Xxfh9MIlPWzLBA8Vu9WCQ=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [46.223.119.124] ([46.223.119.124]) by web-mail.gmx.net
 (3c-app-gmx-bs55.server.lan [172.19.170.139]) (via HTTP); Mon, 13 Sep 2021
 12:32:14 +0200
MIME-Version: 1.0
Message-ID: <trinity-e5b95a34-015c-451d-bbfc-83bfb0bdecad-1631529134448@3c-app-gmx-bs55>
From:   Lino Sanfilippo <LinoSanfilippo@gmx.de>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Saravana Kannan <saravanak@google.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>, p.rosenberger@kunbus.com,
        woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        vivien.didelot@gmail.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Aw: Re: [PATCH 0/3] Fix for KSZ DSA switch shutdown
Content-Type: text/plain; charset=UTF-8
Date:   Mon, 13 Sep 2021 12:32:14 +0200
Importance: normal
Sensitivity: Normal
In-Reply-To: <20210912202913.mu3o5u2l64j7mpwe@skbuf>
References: <trinity-85ae3f9c-38f9-4442-98d3-bdc01279c7a8-1631193592256@3c-app-gmx-bs01>
 <20210909154734.ujfnzu6omcjuch2a@skbuf>
 <8498b0ce-99bb-aef9-05e1-d359f1cad6cf@gmx.de>
 <2b316d9f-1249-9008-2901-4ab3128eed81@gmail.com>
 <5b899bb3-ed37-19ae-8856-3dabce534cc6@gmx.de>
 <20210909225457.figd5e5o3yw76mcs@skbuf>
 <35466c02-16da-0305-6d53-1c3bbf326418@gmail.com> <YTtG3NbYjUbu4jJE@lunn.ch>
 <20210910145852.4te2zjkchnajb3qw@skbuf>
 <53f2509f-b648-b33d-1542-17a2c9d69966@gmx.de>
 <20210912202913.mu3o5u2l64j7mpwe@skbuf>
X-UI-Message-Type: mail
X-Priority: 3
X-Provags-ID: V03:K1:9oyu16jnUSyREoZM3DFHQ81KHcXAKv+ezBse+F+2s8njgqcNEidH7YPK94rsaGpBqTc4M
 eHWPiVCZt2WWQqAz7bO59hMV3OFQWuhiqce5awapeJNnT0KN807f68c3UuI8xKWY4u55/Yf+lkAW
 OiXy/vnDE3dLFMk36MB8ZFLXfSaMADXCemI130mH0RW7S6hzDSYQl8o9O8l7orCp59BfKs7cp2in
 0poA/W3psH/+EOR+s+Xy/zB7CIabsipG+gVBStVlaC8RZ+03nP25yZFdm56gpfuOajynPw9KsORz
 ew=
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:qZAHdwE3Gvk=:zHS5T2l3cjgNEzayb01Ueu
 kRo65Suo8OYlAyylZ3xyVbPBJx/KFplBZuyOR3Qoxpx/GnYY4d8OT2Xf6C/U2yu1iguL8nKAc
 jYFhBzQoflC7bvnpkWpNMf2xn20FPzoW+jo8Pl0MvdiH2c421OZVfyejX29Qi+PVRVMBc1dqx
 L0S9LP2gZFBooatvelmO1z+2fQgtJFlFnKeKGL24hYpyTr/ILSWu1XMcU6V8bK18ON+kX2fAN
 PY/HbvPUB1Cgyy4iYNn41AdG//K6cjQNORfVtBcviSxkwV5hWmEEnH9grsBExg377CiNEhw5/
 PSS637nUP5R/2AVuZZ3r4TLZRJVnvuzzpEULwqDRFJmBK0hZbvTIi/f6AAP+bjjPcq4A8pXkg
 tzgb2E2FVh2CN2J8QFVDR2xMKdKKhhHka/wSBt5rwfQR+auZaYC5cYKCV2h9JW+DW+Qtw7AJH
 oR8xk3HMJThCJvc2LkfnYj9XSBI7gMZCBWDf0HeAwDwCYz6vYMy9awlnB6SY+te8hfqkkHjoK
 s11XFbBP21xWhjg/s88b5UVFZo/P5sksmlBXVwXUoZKzGsgqAWjZNzoNhgqGldBPRcjQlt4h7
 LLDo3Xz5sm0Dj6j/Cq+nvQ7uy1slEyct33jc+6Ob4jynwnOGHsgnXBGToJtU30SKb1Kmo56l9
 3KeAPMlPjB1bOZOOeuCQL4S4eDUycOUNY7S5Y6bODnJIz9InzWk5zu/gTFJToecDSX3T4iVmU
 0uInVsHjoCiaGXUgrtCa2WB51OkLz3PGZLj9x6cYxj3yYhsaQ25fNe3ncEIMQwjfgIe/RniHr
 YsVMo2Z
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

> Gesendet: Sonntag, 12. September 2021 um 22:29 Uhr
> Von: "Vladimir Oltean" <olteanv@gmail.com>
> An: "Lino Sanfilippo" <LinoSanfilippo@gmx.de>
> Cc: "Andrew Lunn" <andrew@lunn.ch>, "Florian Fainelli" <f.fainelli@gmail=
.com>, "Saravana Kannan" <saravanak@google.com>, "Rafael J. Wysocki" <rafa=
el@kernel.org>, p.rosenberger@kunbus.com, woojung.huh@microchip.com, UNGLi=
nuxDriver@microchip.com, vivien.didelot@gmail.com, davem@davemloft.net, ku=
ba@kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
> Betreff: Re: [PATCH 0/3] Fix for KSZ DSA switch shutdown
>
> On Sun, Sep 12, 2021 at 10:19:24PM +0200, Lino Sanfilippo wrote:
> >
> > Hi,
> >
> > On 10.09.21 at 16:58, Vladimir Oltean wrote:
> > > On Fri, Sep 10, 2021 at 01:51:56PM +0200, Andrew Lunn wrote:
> > >>> It does not really scale but we also don't have that many DSA mast=
ers to
> > >>> support, I believe I can name them all: bcmgenet, stmmac, bcmsyspo=
rt, enetc,
> > >>> mv643xx_eth, cpsw, macb.
> > >>
> > >> fec, mvneta, mvpp2, i210/igb.
> > >
> > > I can probably double that list only with Freescale/NXP Ethernet
> > > drivers, some of which are not even submitted to mainline. To name s=
ome
> > > mainline drivers: gianfar, dpaa-eth, dpaa2-eth, dpaa2-switch, ucc_ge=
th.
> > > Also consider that DSA/switchdev drivers can also be DSA masters of
> > > their own, we have boards doing that too.
> > >
> > > Anyway, I've decided to at least try and accept the fact that DSA
> > > masters will unregister their net_device on shutdown, and attempt to=
 do
> > > something sane for all DSA switches in that case.
> > >
> > > Attached are two patches (they are fairly big so I won't paste them
> > > inline, and I would like initial feedback before posting them to the
> > > list).
> > >
> > > As mentioned in those patches, the shutdown ordering guarantee is st=
ill
> > > very important, I still have no clue what goes on there, what we nee=
d to
> > > do, etc.
> > >
> >
> > I tested these patches with my 5.10 kernel (based on Gregs 5.10.27 sta=
ble
> > kernel) and while I do not see the message "unregister_netdevice: wait=
ing
> > for eth0 to become free. Usage count =3D 2." any more the shutdown/reb=
oot hangs, too.
> > After a few attempts without any error messages on the console I was a=
ble to get a
> >  stack trace. Something still seems to go wrong in bcm2835_spi_shutdow=
n() (see attachment).
> > I have not had the time yet to investigate this further (or to test th=
e patches
> >  with a newer kernel).
>
> Could you post the full kernel output? The picture you've posted is
> truncated and only shows a WARN_ON in rpi_firmware_transaction and is
> probably a symptom and not the issue (which is above and not shown).
>

Unfortunately I dont see anything in the kernel log. The console output is=
 all I get,
thats why I made the photo.

Regards,
Lino


