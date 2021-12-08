Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2411146D8EA
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 17:51:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234670AbhLHQzI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 11:55:08 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:55102 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234333AbhLHQzI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 11:55:08 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 97D99B821C7
        for <netdev@vger.kernel.org>; Wed,  8 Dec 2021 16:51:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5FFBC00446;
        Wed,  8 Dec 2021 16:51:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638982294;
        bh=j+dFgcjZ2EJ7I6xIeY0hvOAKHVD/v7ArjbOzM9jgKDA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=BiZNjRGFtfk78LVv8aX1U9myRy22Jmpw8amIrGqy14UaYVK8Z7znn1GeDKUnLqOtY
         Iux36jjvOVpsle3KrEaGKJuvcb+mHrvY/9VZmbAyiXZSaazSb6cVFokzMoNqKu1yLi
         I+UkKVguIEVFR2SV9zqPJqw54KtCjFIHz3EiL4Mxx+C0rtaR2Y7KZ4eD9DRGb06Ezn
         TnlvNvHhP8rATok8r2lU3kqaO8+3gwGDW9+wvtSLnwSca1dpkCBrfkLHEME9toAfV+
         MYUlFu5+rvOkZupg7bz82KrJiuVjWEbXDIinYFZHvvY1RQJ+6fFVgZdpJIJT0Vh2BL
         3ac65H/2dKgQg==
Date:   Wed, 8 Dec 2021 17:51:29 +0100
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Holger Brunck <holger.brunck@hitachienergy.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>
Subject: Re: [v3 2/2] dsa: mv88e6xxx: make serdes SGMII/Fiber output
 amplitude configurable
Message-ID: <20211208175129.40aab780@thinkpad>
In-Reply-To: <20211208164131.fy2h652sgyvhm7jx@skbuf>
References: <20211207190730.3076-1-holger.brunck@hitachienergy.com>
        <20211207190730.3076-2-holger.brunck@hitachienergy.com>
        <20211207202733.56a0cf15@thinkpad>
        <AM6PR0602MB3671CC1FE1D6685FE2A503A6F76F9@AM6PR0602MB3671.eurprd06.prod.outlook.com>
        <20211208162852.4d7361af@thinkpad>
        <AM6PR0602MB36717361A85C1B0CA8FE94D0F76F9@AM6PR0602MB3671.eurprd06.prod.outlook.com>
        <20211208171720.6a297011@thinkpad>
        <20211208172104.75e32a6b@thinkpad>
        <20211208164131.fy2h652sgyvhm7jx@skbuf>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 8 Dec 2021 18:41:31 +0200
Vladimir Oltean <olteanv@gmail.com> wrote:

> On Wed, Dec 08, 2021 at 05:21:04PM +0100, Marek Beh=C3=BAn wrote:
> > Hello Vladimir, =20
> > > > > but the mv88e6xxx driver also drives switches that allow changing=
 serdes
> > > > > modes. There does not need be dedicated TX amplitude register for=
 each serdes
> > > > > mode, the point is that we may want to declare different amplitud=
es for
> > > > > different modes.
> > > > >
> > > > > So the question is: if we go with your binding proposal for the w=
hole mv88e6xxx
> > > > > driver, and in the future someone will want to declare different =
amplitudes for
> > > > > different modes on another model, would he need to deprecate your=
 binding or
> > > > > would it be easy to extend?
> > > > > =20
> > > >
> > > > ok I see. So if I follow your proposal in my case it would be somet=
hing like:
> > > > serdes-sgmii-tx-amplitude-millivolt to start with ?
> > > >
> > > > I can do that. Andrew what do you think? =20
> > >
> > > Or maybe two properties:
> > >   serdes-tx-amplitude-millivolt =3D <700 1000 1100>;
> > >   serdes-tx-amplitude-modes =3D "sgmii", "2500base-x", "10gbase-r";
> > > ?
> > >
> > > If
> > >   serdes-tx-amplitude-modes
> > > is omitted, then
> > >   serdes-tx-amplitude-millivolt
> > > should only contain one value, and this is used for all serdes modes.
> > >
> > > This would be compatible with your change. You only need to define the
> > > bidning for now, your code can stay the same - you don't need to add
> > > support for multiple values or for the second property now, it can be
> > > done later when needed. But the binding should be defined to support
> > > those different modes. =20
> >
> > Vladimir, can you send your thoughts about this proposal? We are trying
> > to propose binding for defining serdes TX amplitude. =20
>=20
> I don't have any specific concern here. It sounds reasonable for
> different data rates to require different transmitter configurations.
> Having separate "serdes-tx-amplitude-millivolt" and "serdes-tx-amplitude-=
modes"
> properties sounds okay, although I think a prefix with "-names" at the
> end is more canonical ("pinctrl-names", "clock-names", "reg-names" etc),
> so maybe "serdes-tx-amplitude-millivolt-names"?
> Maybe we could name the first element "default", and just the others
> would be named after a phy-mode. This way, if a specific TX amplitude is
> found in the device tree for the currently operating PHY mode, it can be
> used, otherwise the default (first) amplitude can be used.

Yes, the pair
  serdes-tx-amplitude-millivolt
  serdes-tx-amplitude-millivolt-names
is the best.

If the second is not defined, the first should contain only one value,
and that is used as default.

If multiple values are defined, but "default" is not, the driver should
set default value as the default value of the corresponding register.

The only remaining question is this: I need to implement this also for
comphy driver. In this case, the properties should be defined in the
comphy node, not in the MAC node. But the comphy also supports PCIe,
USB3 and SATA modes. We don't have strings for them. So this will need
to be extended in the future.

But for now this proposal seems most legit. I think the properties
should be defined in common PHY bindings, and other bindings should
refer to them via $ref.

Marek
