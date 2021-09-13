Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4F2C4089C2
	for <lists+netdev@lfdr.de>; Mon, 13 Sep 2021 13:01:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239374AbhIMLCw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Sep 2021 07:02:52 -0400
Received: from mout.gmx.net ([212.227.17.21]:50721 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239199AbhIMLCv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Sep 2021 07:02:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1631530880;
        bh=eIrDTDkLPLTBW/OcC8PfuBR6yO+OBkLQE9VB9awYepM=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=Ax96FlymwFLUehBPWfR+PSxLnv14Blz0tb1Y/R71C/MyDzgQN5ZAZYLxZVPInqshc
         qU5ZXil34LbRBOi+o2Bw6Qeht3eNSGR773vcFX1WFOvOx7tdEAZwadTe0aIc7I7jHY
         MVFzcucv18GKxKPf473r6lZcCRgWNtUmhRbwCtQQ=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [46.223.119.124] ([46.223.119.124]) by web-mail.gmx.net
 (3c-app-gmx-bs55.server.lan [172.19.170.139]) (via HTTP); Mon, 13 Sep 2021
 13:01:20 +0200
MIME-Version: 1.0
Message-ID: <trinity-6fefc142-df4d-47af-b2bd-84c8212e5b1c-1631530880741@3c-app-gmx-bs55>
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
Date:   Mon, 13 Sep 2021 13:01:20 +0200
Importance: normal
Sensitivity: Normal
In-Reply-To: <20210913104400.oyib42rfq5x2vc56@skbuf>
References: <8498b0ce-99bb-aef9-05e1-d359f1cad6cf@gmx.de>
 <2b316d9f-1249-9008-2901-4ab3128eed81@gmail.com>
 <5b899bb3-ed37-19ae-8856-3dabce534cc6@gmx.de>
 <20210909225457.figd5e5o3yw76mcs@skbuf>
 <35466c02-16da-0305-6d53-1c3bbf326418@gmail.com> <YTtG3NbYjUbu4jJE@lunn.ch>
 <20210910145852.4te2zjkchnajb3qw@skbuf>
 <53f2509f-b648-b33d-1542-17a2c9d69966@gmx.de>
 <20210912202913.mu3o5u2l64j7mpwe@skbuf>
 <trinity-e5b95a34-015c-451d-bbfc-83bfb0bdecad-1631529134448@3c-app-gmx-bs55>
 <20210913104400.oyib42rfq5x2vc56@skbuf>
X-UI-Message-Type: mail
X-Priority: 3
X-Provags-ID: V03:K1:iHqwnknc+/nK4ZdMIEpsKSBGr11E6sx9g/rX5WpEh2NjIqIeWmNUCNu58tsVnoEavMmTP
 dqMf3MNmPLD1LLIDngNxsABl3IISsGl4QxKmoPnYZCH35A76RQ4crnE4RMr1oFfOQmD691WJW1yF
 nF2fSn7f9HQQ0xQvmktxmJ0yqjkvvK1hO4mjWgIEuc59x72ngr3tDHMvCE+9IQiVtqYQUZc4E57F
 cbD0HzOvsasJV4AWIsm7NanRnxgIHIH9XwwdX4NuzzgVCuVzBEjVrzZBva3oJeCI3qm2vPmpFLol
 xA=
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:x0t9OFEPTCY=:DezfFcSw/K7QJf2k7pGXpe
 Lbh5qXNK+rYUCoipxnFsV/fgsgqCCDVfeqlarKhIMIkFtyHQZWs4xB0fBqurDT7SKNO0lkoa1
 Kz0YHBri/ygYqVRjJUFIK3fUUu+Lec+AqVNnqvphCxVGpycOiH49tLtGt1dp/sGOJ7+3MZ8up
 eeMQJ7mFyVULnT7YfqIw2nndm3/9q80tMHs5c/IW88FQjBIm5URxQmlqCwogwTweiE/ZWsmEE
 F4CR0xDKgiNzn2JO7FhKgB+CwYoAhx04nu+EJztSz/qidMk9RLgTTJImDPkkgT8rtOPp3YkGw
 IadmhbD+WNllpKPibFl65Gn5yo/fAv5L+tj9ClZxNPy/7ejE6mcxPJuKWAhuJilfTgA+e6OS4
 V7iLq31zDN7y6zdMU1G33ivPDVZuG+oXguL7yOLPHJS4RWE610s5Xfr6Dw10jevgJB1QPW33m
 z88855p6aWioEYA/ZXvBk5o7mq2VaTXqrp3kItrrOtiAbHtKkFlj+P7yFUm09QcakHpKoLleN
 rCStxJP5GPQHBLE85mMZ4xPR5Fv0zH3d3/rkZpNZpEk14F8ezeKFXdbTDKUiMumQXPdUOJcNy
 A37AfMjpJUyVqtvwWs5QFdeFpvmKG+RqCLUBzonlquHkddko4EH50VM8Xngmh6xpXBYshQPcb
 jsZs3I3iSDbnaoRtCLb99PBat19JpLCV2qg5ht612j7S/Q+U+59sXW6HMuiPj+sqbYXlMx1lX
 GeHwrIMm2Aaog8ENCGh8LcNPk/lFeL5T2JPHf/L2WgmMNZOrptxueNzdL9rGvr67+od+Hl+ft
 BcnQD6L
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> Gesendet: Montag, 13. September 2021 um 12:44 Uhr
> Von: "Vladimir Oltean" <olteanv@gmail.com>
> An: "Lino Sanfilippo" <LinoSanfilippo@gmx.de>
> Cc: "Andrew Lunn" <andrew@lunn.ch>, "Florian Fainelli" <f.fainelli@gmail=
.com>, "Saravana Kannan" <saravanak@google.com>, "Rafael J. Wysocki" <rafa=
el@kernel.org>, p.rosenberger@kunbus.com, woojung.huh@microchip.com, UNGLi=
nuxDriver@microchip.com, vivien.didelot@gmail.com, davem@davemloft.net, ku=
ba@kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
> Betreff: Re: [PATCH 0/3] Fix for KSZ DSA switch shutdown
>
> On Mon, Sep 13, 2021 at 12:32:14PM +0200, Lino Sanfilippo wrote:
> > Hi,
> >
> > > Gesendet: Sonntag, 12. September 2021 um 22:29 Uhr
> > > Von: "Vladimir Oltean" <olteanv@gmail.com>
> > > An: "Lino Sanfilippo" <LinoSanfilippo@gmx.de>
> > > Cc: "Andrew Lunn" <andrew@lunn.ch>, "Florian Fainelli" <f.fainelli@g=
mail.com>, "Saravana Kannan" <saravanak@google.com>, "Rafael J. Wysocki" <=
rafael@kernel.org>, p.rosenberger@kunbus.com, woojung.huh@microchip.com, U=
NGLinuxDriver@microchip.com, vivien.didelot@gmail.com, davem@davemloft.net=
, kuba@kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
> > > Betreff: Re: [PATCH 0/3] Fix for KSZ DSA switch shutdown
> > >
> > > On Sun, Sep 12, 2021 at 10:19:24PM +0200, Lino Sanfilippo wrote:
> > > >
> > > > Hi,
> > > >
> > > > On 10.09.21 at 16:58, Vladimir Oltean wrote:
> > > > > On Fri, Sep 10, 2021 at 01:51:56PM +0200, Andrew Lunn wrote:
> > > > >>> It does not really scale but we also don't have that many DSA =
masters to
> > > > >>> support, I believe I can name them all: bcmgenet, stmmac, bcms=
ysport, enetc,
> > > > >>> mv643xx_eth, cpsw, macb.
> > > > >>
> > > > >> fec, mvneta, mvpp2, i210/igb.
> > > > >
> > > > > I can probably double that list only with Freescale/NXP Ethernet
> > > > > drivers, some of which are not even submitted to mainline. To na=
me some
> > > > > mainline drivers: gianfar, dpaa-eth, dpaa2-eth, dpaa2-switch, uc=
c_geth.
> > > > > Also consider that DSA/switchdev drivers can also be DSA masters=
 of
> > > > > their own, we have boards doing that too.
> > > > >
> > > > > Anyway, I've decided to at least try and accept the fact that DS=
A
> > > > > masters will unregister their net_device on shutdown, and attemp=
t to do
> > > > > something sane for all DSA switches in that case.
> > > > >
> > > > > Attached are two patches (they are fairly big so I won't paste t=
hem
> > > > > inline, and I would like initial feedback before posting them to=
 the
> > > > > list).
> > > > >
> > > > > As mentioned in those patches, the shutdown ordering guarantee i=
s still
> > > > > very important, I still have no clue what goes on there, what we=
 need to
> > > > > do, etc.
> > > > >
> > > >
> > > > I tested these patches with my 5.10 kernel (based on Gregs 5.10.27=
 stable
> > > > kernel) and while I do not see the message "unregister_netdevice: =
waiting
> > > > for eth0 to become free. Usage count =3D 2." any more the shutdown=
/reboot hangs, too.
> > > > After a few attempts without any error messages on the console I w=
as able to get a
> > > >  stack trace. Something still seems to go wrong in bcm2835_spi_shu=
tdown() (see attachment).
> > > > I have not had the time yet to investigate this further (or to tes=
t the patches
> > > >  with a newer kernel).
> > >
> > > Could you post the full kernel output? The picture you've posted is
> > > truncated and only shows a WARN_ON in rpi_firmware_transaction and i=
s
> > > probably a symptom and not the issue (which is above and not shown).
> > >
> >
> > Unfortunately I dont see anything in the kernel log. The console outpu=
t is all I get,
> > thats why I made the photo.
>
> To clarify, are you saying nothing above this line gets printed? Because
> the part of the log you've posted in the picture is pretty much
> unworkable:
>
> [   99.375389] [<bf0dc56c>] (bcm2835_spi_shutdown [spi_bcm2835]) from [<=
c0863ca0>] (platform_drv_shutdown+0x2c/0x30)
>
> How do you access the device's serial console? Use a program with a
> scrollback buffer like GNU screen or something.
>

Ah no, this is not over a serial console. This is what I see via hdmi. I d=
o not have a working serial connection yet.
Sorry I know this trace part is not very useful, I will try to get a full =
dump.


