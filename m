Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69511216F6A
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 16:54:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728209AbgGGOyr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jul 2020 10:54:47 -0400
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:46913 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727987AbgGGOyr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jul 2020 10:54:47 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id B06515803FE;
        Tue,  7 Jul 2020 10:54:45 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Tue, 07 Jul 2020 10:54:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cerno.tech; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:content-transfer-encoding:in-reply-to; s=fm3; bh=z
        2MF8pM2yUhzEcAqtjG/BkSK1B6kF9HAsHHt2JjHLuc=; b=eYlXbUd5rBjRoIDgO
        Ac1T/2aLAw3Q7djwyIkgIQ/pwVqIVfIr2z3WJZY83Ya0wIMTDJMeKhrCKphOlErR
        V2MsPmOGqgtYqbSaGYLuK6TBmynzFgX9JdllVSJwGFQSk7rpTIotuH5S8SL8rKL4
        pmD+QLJYk+pgiFf6h/4DeCPq+HjqSLpuSLVB24wq2EUcw0w3AtZVdV2mObZm2gJ7
        QQgUrDhFXoVDICgURqP+h9AyRL+ITGkxU1KSlVzfbUyhEJ2mKi6VxPjWFNE0piTb
        Nq1P/0BsYEjwNgMyN6c3kR8fMn3Y91s7lBagBdWjLLntZ1DMW0BwNkqqWC6LobKL
        5bmzg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; bh=z2MF8pM2yUhzEcAqtjG/BkSK1B6kF9HAsHHt2JjHL
        uc=; b=VbRropztsuRUvmMR9Gly4Ig+dMb6KjWmOw2v3I0f1QAeuwbUXldQAq90s
        kHUlIlURW7q75/piHuxcm+p+gHG1KJpvhnVKJ1QTV7BVfFKBaQXulFEnLRRz1sfo
        w712f9lYvchiGBW1Oum6uVwAAamdRdfJdQ1sFvTzsGoF+qZxvXK87SbASKRXjXlT
        kICpquzxdrebQvZCSCZXdh75HOjQgycyHjFCJl+m/b7L0xRlzQsjAx1DGnkAJD2h
        ilpv/yWO0UQQdMQ5LEp7EIHfJxfilPbf6xT4Z+4jSDj9N55eRg7nIadZxtPZxDpz
        8aAtT+i1PT9+RlPSWz7z41eLamY+Q==
X-ME-Sender: <xms:sowEX1H0QJAO5L6cQdGRPW-LnVtsIsmhFw_xM7wuzo6UH2e2NttRyA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrudehgdejiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggugfgjsehtqhertddttddvnecuhfhrohhmpeforgigihhm
    vgcutfhiphgrrhguuceomhgrgihimhgvsegtvghrnhhordhtvggthheqnecuggftrfgrth
    htvghrnhepkeeileetveejffegueetjeeigffgfefgkeeuueetfffhheegveefhfekheev
    kedunecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphepledtrdekledrieekrd
    ejieenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehm
    rgigihhmvgestggvrhhnohdrthgvtghh
X-ME-Proxy: <xmx:sowEX6Xoyoe1WyG76_Fdw1UgpF3BMlNJ3TroWzGckBq2lM8_EFtnZQ>
    <xmx:sowEX3Kk5aNbOepYGJDA63OeocgrY_RWrDJFTFeVNPnWJpFA64VTQA>
    <xmx:sowEX7HcgNQ5LdORDRy3MJdTydZuCOFXpwzXoW97cbmOzMk5ISi5jA>
    <xmx:tYwEX3qN7uPJP8D3PESct64wdCiMceepEpRSQre8v34RdO7iicEFkw>
Received: from localhost (lfbn-tou-1-1502-76.w90-89.abo.wanadoo.fr [90.89.68.76])
        by mail.messagingengine.com (Postfix) with ESMTPA id 3D704328006F;
        Tue,  7 Jul 2020 10:54:42 -0400 (EDT)
Date:   Tue, 7 Jul 2020 16:54:40 +0200
From:   Maxime Ripard <maxime@cerno.tech>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Antoine =?utf-8?Q?T=C3=A9nart?= <antoine.tenart@bootlin.com>
Subject: Re: PHY reset handling during DT parsing
Message-ID: <20200707145440.teimwt6kmsnyi5dz@gilmour.lan>
References: <20200706181331.x2tn5cl5jn5kqmhx@gilmour.lan>
 <20200707141918.GA928075@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20200707141918.GA928075@lunn.ch>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

On Tue, Jul 07, 2020 at 04:19:18PM +0200, Andrew Lunn wrote:
> On Mon, Jul 06, 2020 at 08:13:31PM +0200, Maxime Ripard wrote:
> > I came across an issue today on an Allwinner board, but I believe it's a
> > core issue.
> >=20
> > That board is using the stmac driver together with a phy that happens to
> > have a reset GPIO, except that that GPIO will never be claimed, and the
> > PHY will thus never work.
> >=20
> > You can find an example of such a board here:
> > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree=
/arch/arm/boot/dts/sun6i-a31-hummingbird.dts#n195
> >=20
> > It looks like when of_mdiobus_register() will parse the DT, it will then
> > call of_mdiobus_register_phy() for each PHY it encounters [1].
> > of_mdiobus_register_phy() will then if the phy doesn't have an
> > ethernet-phy-id* compatible call get_phy_device() [2], and will later on
> > call phy_register_device [3].
> >=20
> > get_phy_device() will then call get_phy_id() [4], that will try to
> > access the PHY through the MDIO bus [5].
> >=20
> > The code that deals with the PHY reset line / GPIO is however only done
> > in mdiobus_device_register, called through phy_device_register. Since
> > this is happening way after the call to get_phy_device, our PHY might
> > still very well be in reset if the bootloader hasn't put it out of reset
> > and left it there.
>=20
> Hi Maxime
>=20
> If you look at the history of this code,
>=20
> commit bafbdd527d569c8200521f2f7579f65a044271be
> Author: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
> Date:   Mon Dec 4 13:35:05 2017 +0100
>=20
>     phylib: Add device reset GPIO support
>=20
> you will see there is an assumption the PHY can be detected while in
> reset. The reset was originally handled inside the at803x PHY driver
> probe function, before it got moved into the core.
>=20
> What you are asking for it reasonable, but you have some history to
> deal with, changing some assumptions as to what the reset is all
> about.

Thanks for the pointer.

It looks to me from the commit log that the assumption was that a
bootloader could leave the PHY into reset though?

It starts with:

> The PHY devices sometimes do have their reset signal (maybe even power
> supply?) tied to some GPIO and sometimes it also does happen that a
> boot loader does not leave it deasserted.

This is exactly the case I was discussing. The bootloader hasn't used
the PHY, and thus the PHY reset signal is still asserted?

Maxime
