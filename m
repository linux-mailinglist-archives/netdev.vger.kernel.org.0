Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2D1E46D91C
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 18:01:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237459AbhLHREi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 12:04:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232702AbhLHREi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 12:04:38 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16826C061746
        for <netdev@vger.kernel.org>; Wed,  8 Dec 2021 09:01:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 62A23CE2262
        for <netdev@vger.kernel.org>; Wed,  8 Dec 2021 17:01:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D4C5C00446;
        Wed,  8 Dec 2021 17:01:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638982861;
        bh=Sb5T4fYGyfgleJTZXUYFhnM6YrPwzpMkQSlC49BmOlQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=vLv9wa4y14Hd9bTBXvG1Yf34g6UYSrAu3IZHHImKcVMEps7doBrA/vHkXwXoBXGmO
         VJvqvhL+NxDzD8RgkdgsOiB6cqNtPQS4Y7YWbl8n0WjblFlvP1ZSlHgFhZSkVmK9D/
         W9ZrY4VUUlGZGY1s+h0FWJZ/eXGI5gMX1gTAiy4XfevNMXisR1wFXcMINTaLDFvv1G
         QZhjZtQSoyxk+I+P7rxxvj2EmroJIqnYp0iRxwtS+aYBS67NmNpBG3m2HcotdjiH8i
         evIPjrf4Zp6uHtMJWPoov5Fuh3ghQgpGw0a+lKn2b2sBUHKmsgoo3nQk+83AhR5Rmx
         WeUesxHnNMP9Q==
Date:   Wed, 8 Dec 2021 18:00:57 +0100
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Holger Brunck <holger.brunck@hitachienergy.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>
Subject: Re: [v3 2/2] dsa: mv88e6xxx: make serdes SGMII/Fiber output
 amplitude configurable
Message-ID: <20211208180057.7fb10a17@thinkpad>
In-Reply-To: <20211208164932.6ojxt64j3v34477k@skbuf>
References: <20211207190730.3076-1-holger.brunck@hitachienergy.com>
        <20211207190730.3076-2-holger.brunck@hitachienergy.com>
        <20211207202733.56a0cf15@thinkpad>
        <AM6PR0602MB3671CC1FE1D6685FE2A503A6F76F9@AM6PR0602MB3671.eurprd06.prod.outlook.com>
        <20211208162852.4d7361af@thinkpad>
        <AM6PR0602MB36717361A85C1B0CA8FE94D0F76F9@AM6PR0602MB3671.eurprd06.prod.outlook.com>
        <20211208171720.6a297011@thinkpad>
        <20211208172104.75e32a6b@thinkpad>
        <20211208164131.fy2h652sgyvhm7jx@skbuf>
        <20211208164932.6ojxt64j3v34477k@skbuf>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 8 Dec 2021 18:49:32 +0200
Vladimir Oltean <olteanv@gmail.com> wrote:

> On Wed, Dec 08, 2021 at 06:41:31PM +0200, Vladimir Oltean wrote:
> > On Wed, Dec 08, 2021 at 05:21:04PM +0100, Marek Beh=C3=BAn wrote: =20
> > > Hello Vladimir, =20
> > > > > > but the mv88e6xxx driver also drives switches that allow changi=
ng serdes
> > > > > > modes. There does not need be dedicated TX amplitude register f=
or each serdes
> > > > > > mode, the point is that we may want to declare different amplit=
udes for
> > > > > > different modes.
> > > > > >
> > > > > > So the question is: if we go with your binding proposal for the=
 whole mv88e6xxx
> > > > > > driver, and in the future someone will want to declare differen=
t amplitudes for
> > > > > > different modes on another model, would he need to deprecate yo=
ur binding or
> > > > > > would it be easy to extend?
> > > > > > =20
> > > > >
> > > > > ok I see. So if I follow your proposal in my case it would be som=
ething like:
> > > > > serdes-sgmii-tx-amplitude-millivolt to start with ?
> > > > >
> > > > > I can do that. Andrew what do you think? =20
> > > >
> > > > Or maybe two properties:
> > > >   serdes-tx-amplitude-millivolt =3D <700 1000 1100>;
> > > >   serdes-tx-amplitude-modes =3D "sgmii", "2500base-x", "10gbase-r";
> > > > ?
> > > >
> > > > If
> > > >   serdes-tx-amplitude-modes
> > > > is omitted, then
> > > >   serdes-tx-amplitude-millivolt
> > > > should only contain one value, and this is used for all serdes mode=
s.
> > > >
> > > > This would be compatible with your change. You only need to define =
the
> > > > bidning for now, your code can stay the same - you don't need to add
> > > > support for multiple values or for the second property now, it can =
be
> > > > done later when needed. But the binding should be defined to support
> > > > those different modes. =20
> > >
> > > Vladimir, can you send your thoughts about this proposal? We are tryi=
ng
> > > to propose binding for defining serdes TX amplitude. =20
> >=20
> > I don't have any specific concern here. It sounds reasonable for
> > different data rates to require different transmitter configurations.
> > Having separate "serdes-tx-amplitude-millivolt" and "serdes-tx-amplitud=
e-modes"
> > properties sounds okay, although I think a prefix with "-names" at the
> > end is more canonical ("pinctrl-names", "clock-names", "reg-names" etc),
> > so maybe "serdes-tx-amplitude-millivolt-names"?
> > Maybe we could name the first element "default", and just the others
> > would be named after a phy-mode. This way, if a specific TX amplitude is
> > found in the device tree for the currently operating PHY mode, it can be
> > used, otherwise the default (first) amplitude can be used. =20
>=20
> Also, maybe drop the "serdes-" prefix? The property will sit under a
> SERDES lane node, so it would be a bit redundant?

Hmm. Holger's proposal adds the property into the port node, not SerDes
lane node. mv88e6xxx does not define bindings for SerDes lane nodes
(yet).
