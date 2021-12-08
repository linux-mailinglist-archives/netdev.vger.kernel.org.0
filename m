Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BD9E46DADA
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 19:16:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238741AbhLHSTe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 13:19:34 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:38598 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238716AbhLHSTd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 13:19:33 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 737BDCE22FC
        for <netdev@vger.kernel.org>; Wed,  8 Dec 2021 18:16:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E86AC00446;
        Wed,  8 Dec 2021 18:15:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638987358;
        bh=DxXp9TNtsh/+7SU7F3+djzl1vTNmrpXi3EUFDNy8eoE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=cYYxHIAtXrU84LNJcUlQ3TnhBg1RGYL+5RMwEMzReeFs52AaP3N2Pd/z6gBgC/hfU
         7db7X05jsr8KZ3KUHWusIRMGpmrswB5lWgGDeAmAYhtAupd8V1JESD3VW06OcLPeL5
         HPODarsZxdj/QIirjr/go9zQMjrQDxdJOgyhWOqvXk/em6XS/buN60CE1V9gWSeXna
         ki8X8K14AvBqfALPWfeLbks0+yakmZ2GEUJUaEjqqsmRyo86H81pXCbRkkc7iIioAx
         VN2WH2uQIH4s73+QathiIhzTBlJdS1F/wVD5qL2D064vwSAwg8qC1wZPYKGguMqyCB
         brkIoO64/gDGw==
Date:   Wed, 8 Dec 2021 19:15:54 +0100
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        Holger Brunck <holger.brunck@hitachienergy.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [v3 2/2] dsa: mv88e6xxx: make serdes SGMII/Fiber output
 amplitude configurable
Message-ID: <20211208191554.3ac7fd0b@thinkpad>
In-Reply-To: <YbDxpJH3GgPDge+O@lunn.ch>
References: <AM6PR0602MB3671CC1FE1D6685FE2A503A6F76F9@AM6PR0602MB3671.eurprd06.prod.outlook.com>
        <20211208162852.4d7361af@thinkpad>
        <AM6PR0602MB36717361A85C1B0CA8FE94D0F76F9@AM6PR0602MB3671.eurprd06.prod.outlook.com>
        <20211208171720.6a297011@thinkpad>
        <20211208172104.75e32a6b@thinkpad>
        <20211208164131.fy2h652sgyvhm7jx@skbuf>
        <20211208164932.6ojxt64j3v34477k@skbuf>
        <20211208180057.7fb10a17@thinkpad>
        <20211208171909.3hvre5blb734ueyu@skbuf>
        <20211208183626.4e475b0d@thinkpad>
        <YbDxpJH3GgPDge+O@lunn.ch>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 8 Dec 2021 18:55:48 +0100
Andrew Lunn <andrew@lunn.ch> wrote:

> On Wed, Dec 08, 2021 at 06:36:26PM +0100, Marek Beh=C3=BAn wrote:
> > On Wed, 8 Dec 2021 19:19:09 +0200
> > Vladimir Oltean <olteanv@gmail.com> wrote:
> >  =20
> > > On Wed, Dec 08, 2021 at 06:00:57PM +0100, Marek Beh=C3=BAn wrote: =20
> > > > > Also, maybe drop the "serdes-" prefix? The property will sit unde=
r a
> > > > > SERDES lane node, so it would be a bit redundant?   =20
> > > >=20
> > > > Hmm. Holger's proposal adds the property into the port node, not Se=
rDes
> > > > lane node. mv88e6xxx does not define bindings for SerDes lane nodes
> > > > (yet).   =20
> > >=20
> > > We need to be careful about that. You're saying that there chances of
> > > there being a separate SERDES driver for mv88e6xxx in the future? =20
> >=20
> > I don't think so. Although Russell is working on rewriting the SerDes
> > code to new Phylink API, the SerDes code will always be a part of
> > mv88e6xxx driver, I think. =20
>=20
> In theory, the 6352 family uses standard c22 layout for its SERDES. It
> might be possible to use generic code for that. But given the
> architecture, i expect such a change would have the mv88e6xxx
> instantiate such generic code, not use an external device.
>=20
> For the 6390 family the SERDES and the MAC are pretty intertwined, and
> it is not a 1:1 mapping. It might be possible to make use of shared
> code, but i've much doubt it will be a separate device.
>=20
> I would put the properties in the port nodes, next to phy-mode,
> phy-handle, etc.
>=20
> Where it might get interesting is the 10G modes, where there are 4
> lanes. Is it possible to configure the voltage for each lane? Or is it
> one setting for all 4 lanes? I've not looked at the data sheet, so i
> cannot answer this.
> y
>     Andrew

The FS for PHY and Serdes for 6390X does not document TX amplitude
registers. Release notes document some additional registers, or mention
how to change frequency, but do not document the registers explicitly.

So we don't know currently how to change TX amplitude on those
switches. But I guess I could find out the same way I found out about
88E6393X frequency change from undocumented register. Or if some vendor
needs it, they can ask Marvell which registers they should use to
change TX amplitude.

I personally don't have any device with these switches though.

Marek
