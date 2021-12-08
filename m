Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9583F46D6F4
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 16:29:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233622AbhLHPcc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 10:32:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbhLHPcc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 10:32:32 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D3B5C061746
        for <netdev@vger.kernel.org>; Wed,  8 Dec 2021 07:29:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 2B804CE2204
        for <netdev@vger.kernel.org>; Wed,  8 Dec 2021 15:28:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72474C00446;
        Wed,  8 Dec 2021 15:28:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638977336;
        bh=LiTE1vK9sK0G4NstxPlLQgAfrPae3AxY8i0b6G/GWsQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=meZpQXNBVQPiRN+bbNQYdj4tyKupmtxf2kNnepmf6xMLSN4XlQfIcAWJrXqQ2rUkt
         Soahv1glb/hYQbxDjNkjGmUCEcDkOkwaaR4SEbvf4GuxnqDkaAQF0AFPi9UAzgOL7A
         9Amu0AWUPja4ncZb8hH2vv7deJ0kQS0qW9Cwvsj1NbfVxSxkKq22HoUe5tlVYHDcje
         o0aKAZjP2sAS+CRlepDJgI36+ExfEsZOR+IF06nicEn86IufS11lhHS2I5q3DncQEZ
         OrgaiUmkWp5rzDdYmFgessaCi2ONn/o2uaSHFhrBkqqOE413XewrJngCGB3RUg1jOr
         oO5AnZAsSZNoQ==
Date:   Wed, 8 Dec 2021 16:28:52 +0100
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Holger Brunck <holger.brunck@hitachienergy.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>
Subject: Re: [v3 2/2] dsa: mv88e6xxx: make serdes SGMII/Fiber output
 amplitude configurable
Message-ID: <20211208162852.4d7361af@thinkpad>
In-Reply-To: <AM6PR0602MB3671CC1FE1D6685FE2A503A6F76F9@AM6PR0602MB3671.eurprd06.prod.outlook.com>
References: <20211207190730.3076-1-holger.brunck@hitachienergy.com>
        <20211207190730.3076-2-holger.brunck@hitachienergy.com>
        <20211207202733.56a0cf15@thinkpad>
        <AM6PR0602MB3671CC1FE1D6685FE2A503A6F76F9@AM6PR0602MB3671.eurprd06.prod.outlook.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 8 Dec 2021 12:29:13 +0000
Holger Brunck <holger.brunck@hitachienergy.com> wrote:

> Hi Marek,
>=20
> > > The mv88e6352, mv88e6240 and mv88e6176  have a serdes interface. This
> > > patch allows to configure the output swing to a desired value in the
> > > devicetree node of the port. As the chips only supports eight
> > > dedicated values we return EINVAL if the value in the DTS does not ma=
tch.
> > >
> > > CC: Andrew Lunn <andrew@lunn.ch>
> > > CC: Jakub Kicinski <kuba@kernel.org>
> > > CC: Marek Beh=C3=BAn <kabel@kernel.org>
> > > Signed-off-by: Holger Brunck <holger.brunck@hitachienergy.com> =20
> >=20
> > Holger, Andrew,
> >=20
> > there is another issue with this, which I only realized yesterday. What=
 if the
> > different amplitude needs to be set only for certain SerDes modes?
> >=20
> > I am bringing this up because I discovered that on Turris Mox we need to
> > increase SerDes output amplitude when A3720 SOC is connected directly to
> > 88E6141 switch, but only for 2500base-x mode. For 1000base-x, the defau=
lt
> > amplitude is okay. (Also when the SOC is connected to 88E6190, the ampl=
itude
> > does not need to be changed at all.)
> >  =20
>=20
> on my board I have a fixed link connected with SGMII and there is no dedi=
cated
> value given in the manual.
>=20
> > I plan to solve this in the comphy driver, not in device-tree.
> >=20
> > But if the solution is to be done in DTS, shouldn't there be a possibil=
ity to define
> > the amplitude for a specific serdes mode only?
> >=20
> > For example
> >   serdes-2500base-x-tx-amplitude-millivolt
> > or
> >   serdes-tx-amplitude-millivolt-2500base-x
> > or
> >   serdes-tx-amplitude-millivolt,2500base-x
> > ?
> >=20
> > What do you think?
> >  =20
>=20
> in the data sheet for the MV6352 I am using there are no dedicated values=
 stated for
> different modes at all, they can be chosen arbitrary. So in my case I thi=
nk it makes
> sense to keep it as it is for now. Other driver may have other needs and =
may enhance
> this later on.

Hi Holger,

but the mv88e6xxx driver also drives switches that allow changing
serdes modes. There does not need be dedicated TX amplitude register for
each serdes mode, the point is that we may want to declare different
amplitudes for different modes.

So the question is: if we go with your binding proposal for the whole
mv88e6xxx driver, and in the future someone will want to declare
different amplitudes for different modes on another model, would he
need to deprecate your binding or would it be easy to extend?

Marek
