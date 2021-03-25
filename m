Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2CC33485FF
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 01:44:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239356AbhCYAoD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 20:44:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:49180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239355AbhCYAnd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Mar 2021 20:43:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4F51D61A24;
        Thu, 25 Mar 2021 00:43:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616633013;
        bh=c5IzrFH0/FrC5gYB9fsdz9kH5W+cKUSGX677vNQjhKA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=r4g0FUKq6O1A+WJUWd4EK0waeh63wKVzU+MPtfG30/00mZ6ZPlWioagb0JLpwA1cS
         7C6rFWWCVqP95v9+1/G3idz+h2eijIqBylsOCrkYsZ0AUh3SM/WDfUgD+S4XxCT6NO
         8OJJRPPIbpcQjTTDGxKJBkie9DinneiI7/eWB4b3NkjppONlZCvp3aYqZH4FmgpNTd
         AaupMIwCC0zjQEwJnJt+HgPczXvo1/KCj5+rIYMi3hOyHpGGgxtCN2jB34gnaCshqV
         PcVeWWmpqdxL9p6cKMg2xhpbb3W8AjeAjvYPclg8ZQLckGXpw3zL3P7nSkjqE9mWae
         yeYAtvbWjMwaQ==
Date:   Thu, 25 Mar 2021 01:43:28 +0100
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Rob Herring <robh@kernel.org>, devicetree@vger.kernel.org,
        pali@kernel.org
Subject: Re: [PATCH net-next 0/2] dt-bindings: define property describing
 supported ethernet PHY modes
Message-ID: <20210325014328.6ce00864@thinkpad>
In-Reply-To: <5fc6fea9-d4c1-bb7e-8f0d-da38c7147825@gmail.com>
References: <20210324103556.11338-1-kabel@kernel.org>
        <e4e088a4-1538-1e7d-241d-e43b69742811@gmail.com>
        <20210325000007.19a38bce@thinkpad>
        <755130b4-2fab-2b53-456f-e2304b1922f2@gmail.com>
        <20210325004525.734f3040@thinkpad>
        <5fc6fea9-d4c1-bb7e-8f0d-da38c7147825@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 24 Mar 2021 17:11:25 -0700
Florian Fainelli <f.fainelli@gmail.com> wrote:

> On 3/24/2021 4:45 PM, Marek Beh=C3=BAn wrote:
> > On Wed, 24 Mar 2021 16:16:41 -0700
> > Florian Fainelli <f.fainelli@gmail.com> wrote:
> >  =20
> >> On 3/24/2021 4:00 PM, Marek Beh=C3=BAn wrote: =20
> >>> On Wed, 24 Mar 2021 14:19:28 -0700
> >>> Florian Fainelli <f.fainelli@gmail.com> wrote:
> >>>    =20
> >>>>> Another problem is that if lower modes are supported, we should
> >>>>> maybe use them in order to save power.     =20
> >>>>
> >>>> That is an interesting proposal but if you want it to be truly valua=
ble,
> >>>> does not that mean that an user ought to be able to switch between a=
ny
> >>>> of the supported PHY <=3D> MAC interfaces at runtime, and then within
> >>>> those interfaces to the speeds that yield the best power savings?   =
=20
> >>>
> >>> If the code determines that there are multiple working configurations,
> >>> it theoretically could allow the user to switch between them.
> >>>
> >>> My idea was that this should be done by kernel, though.
> >>>
> >>> But power saving is not the main problem I am trying to solve.
> >>> What I am trying to solve is that if a board does not support all mod=
es
> >>> supported by the MAC and PHY, because they are not wired or something,
> >>> we need to know about that so that we can select the correct mode for
> >>> PHYs that change this mode at runtime.   =20
> >>
> >> OK so the runtime part comes from plugging in various SFP modules into=
 a
> >> cage but other than that, for a "fixed" link such as a SFF or a solder=
ed
> >> down PHY, do we agree that there would be no runtime changing of the
> >> 'phy-mode'? =20
> >=20
> > No, we do not. The PHY can be configured (by strapping pins or by
> > sw) to change phy-mode depending on the autonegotiated copper speed.
> >=20
> > So if you plug in an ethernet cable where on the otherside is only 1g
> > capable device, the PHY will change mode to sgmii. But if you then plug
> > a 5g capable device, the PHY will change mode to 5gbase-r.
> >=20
> > This happens if the PHY is configured into one of these changing
> > configurations. It can also be configured to USXGMII, or 10GBASER with
> > rate matching.
> >=20
> > Not many MACs in kernel support USXGMII currently.
> >=20
> > And if you use rate matching mode, and the copper side is
> > linked in lower speed (2.5g for example), and the MAC will start
> > sending too many packets, the internal buffer in the PHY is only 16 KB,
> > so it will fill up quickly. So you need pause frames support. But this
> > is broken for speeds <=3D 1g, according to erratum.
> >=20
> > So you really want to change modes. The rate matching mode is
> > basically useless. =20
>=20
> OK, so whenever there is a link change you are presumably reading the
> mode in which the PHY has been reconfigured to, asking the MAC to
> configured itself appropriately based on that, and if there is no
> intersection, error out?

No. At initialization I tell the PHY to change between
  10gbase-r / 5gbase-r / 2500base-x / sgmii
according to the copper side. The PHY will do this alone on change on
copper side. I don't need to do this.

(This already works with current version of marvell10g driver - but
 kernel is not configuring this, it has to be configure via strapping
 pins.)

But I can tell the PHY at initialization to change instead between
  xaui / 5gbase-r / 2500base-x / sgmii
Again the PHY will do this on its own whenever speed on the copper side
changes.

But I need to know which of this settings I should use.

Marek
