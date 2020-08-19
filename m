Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D98024A387
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 17:50:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728688AbgHSPt5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 11:49:57 -0400
Received: from mail.nic.cz ([217.31.204.67]:56678 "EHLO mail.nic.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728393AbgHSPtx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Aug 2020 11:49:53 -0400
Received: from dellmb.labs.office.nic.cz (unknown [IPv6:2001:1488:fffe:6:8982:ed8c:62b1:c0c8])
        by mail.nic.cz (Postfix) with ESMTPSA id 1F1BC140A06;
        Wed, 19 Aug 2020 17:49:51 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nic.cz; s=default;
        t=1597852191; bh=Rn+sxIeboYm+ATRMcSL3QpW20wrtGFDPuYxlRQe+ZdE=;
        h=Date:From:To;
        b=Ln7mKmZE2T3QdbBY6a5PxzhdycFDteYWwbQ1Vx5RSBK4csEmiQsNJyaWt2hyFfLec
         W4oQka5+Lyq5LAP9oGmtzbyK5i43DNxuv9OFmcOZt5XyaHI5iSURvzj3lm6mz+XtTa
         QmoDpZiUXNpEf+Zs9ICm4BWSlBoJCpc0CZm4tpr8=
Date:   Wed, 19 Aug 2020 17:49:50 +0200
From:   Marek =?ISO-8859-1?Q?Beh=FAn?= <marek.behun@nic.cz>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        Baruch Siach <baruch@tkos.co.il>,
        Chris Healy <cphealy@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org
Subject: Re: [PATCH RFC russell-king 0/4] Support for RollBall 10G copper
 SFP modules
Message-ID: <20200819174950.3a00d71a@dellmb.labs.office.nic.cz>
In-Reply-To: <20200818163415.GE1551@shell.armlinux.org.uk>
References: <20200810220645.19326-1-marek.behun@nic.cz>
        <20200817134909.GY1551@shell.armlinux.org.uk>
        <20200818154305.2b7e191c@dellmb.labs.office.nic.cz>
        <20200818150834.GC1551@shell.armlinux.org.uk>
        <20200818173055.01e4bf01@dellmb.labs.office.nic.cz>
        <20200818153649.GD1551@shell.armlinux.org.uk>
        <20200818174724.02ea4ab8@dellmb.labs.office.nic.cz>
        <20200818163415.GE1551@shell.armlinux.org.uk>
X-Mailer: Claws Mail 3.17.6 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-100.0 required=5.9 tests=SHORTCIRCUIT,
        USER_IN_WHITELIST shortcircuit=ham autolearn=disabled version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.nic.cz
X-Virus-Scanned: clamav-milter 0.102.2 at mail
X-Virus-Status: Clean
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 18 Aug 2020 17:34:15 +0100
Russell King - ARM Linux admin <linux@armlinux.org.uk> wrote:

> On Tue, Aug 18, 2020 at 05:47:24PM +0200, Marek Beh=FAn wrote:
> > On Tue, 18 Aug 2020 16:36:49 +0100
> > Russell King - ARM Linux admin <linux@armlinux.org.uk> wrote:
> >  =20
> > > On Tue, Aug 18, 2020 at 05:30:55PM +0200, Marek Beh=FAn wrote: =20
> > > > On Tue, 18 Aug 2020 16:08:35 +0100
> > > > Russell King - ARM Linux admin <linux@armlinux.org.uk> wrote:
> > > >    =20
> > > > > > Otherwise it looks nice. I will test this. On what branch
> > > > > > does this apply?     =20
> > > > >=20
> > > > > My unpublished tip of the universe development.  Here's a
> > > > > version on the clearfog branch:   =20
> > > >=20
> > > > Russell, it seems you do not have commit
> > > >=20
> > > > e11703330a5d ("net: phy: marvell10g: support XFI rate matching
> > > > mode")
> > > >=20
> > > > in that branch.   =20
> > >=20
> > > I don't.  That commit is in 5.9-rc1, I'm based on 5.8 at the
> > > moment.=20
> >=20
> > I am reworking it so that it applies on top of master together with
> > your other commits from clearfog branch. =20
>=20
> If it works for you, I'll rework my branches to adopt this approach.
>=20

Russell,

if you have time please rebase your work on top of Linus' master or
net-next.

Btw one of your patches in clearfog branch breaks mvneta
(although there are other patches which fix this break).
Check this out:
  patch
      net: mvneta: move 1ms clock control into mac_prepare/mac_finish
  removes definition of variables new_clk and gmac_clk in
  mvneta_mac_config, but does not remove one instance of usage, which
  can be seen in subsequent patch
      net: mvneta: convert to phylink pcs operations
  this is fixed by patch
      net: mvneta: split out GMAC
  where all of this is moved to mvgmac.c file.
I found out because I did not apply the last patch for some reason
(maybe it didn't apply on Linus' master or something, I don't remember),
and it failed to compile.

http://git.arm.linux.org.uk/cgit/linux-arm.git/commit/?h=3Dclearfog&id=3Dca=
096c11e6798b1f4da8466ab0c3bf42b6e9fb81
http://git.arm.linux.org.uk/cgit/linux-arm.git/commit/?h=3Dclearfog&id=3D1e=
345c538cc73d0b0a63c01a13e69a865905b7ae
http://git.arm.linux.org.uk/cgit/linux-arm.git/commit/?h=3Dclearfog&id=3Ddc=
33cc833537d06b198c9226d4a230cfc33569a6

I have just sent patches that add 88E6393X switch to mv88e6xxx driver,
since I am testing these SFPs on a Marvell Customer Reference Board
containing this switch.

The board also contains the other PHY supported by the marvell10g PHY
driver, 88E2110, so I will test my changes also on this PHY.

I am waiting for newer documentation for 88E3110, since the one I have
is outdated and does not contain descriptions on how to resolve USXGMII
auto-negotiation, which I would also like to add.

Marek
