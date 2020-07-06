Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53FC4215E0E
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 20:13:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729692AbgGFSNi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 14:13:38 -0400
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:53335 "EHLO
        new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729622AbgGFSNi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 14:13:38 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id ED5E958023D;
        Mon,  6 Jul 2020 14:13:36 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 06 Jul 2020 14:13:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cerno.tech; h=
        date:from:to:cc:subject:message-id:mime-version:content-type; s=
        fm3; bh=+v/Te64vKu4e35ENQ/jK6ubbrXotygKRxSoJgsFaBMY=; b=qSy7OzOH
        skFlHeU9mi26Sma2rX0D/lgIfCCmui9NIvzQgMWug9tdsg6RIO1cZLqpjdwlhmzB
        5KivDkYhKbmi+Wo0kEIvgJ7/u4ISd/JPSAz14cB63lEUXYhlQFEPJ1xuNSKnF/Y2
        qpByMVOwDmJgXVa7CRM5SEf+GkyGBnslNoUoCqpSCMc9Qw8+1YLGN98sEL4jJ/VG
        uN7qMhfDu5+cDGOFlzqbTmXua69/vwUHB5cyE9ue9LlFDnYEWmL2G+ocDPAvFR8A
        gwbi8wMuLm5W/vQHq4alBcdWVKZuOBsNxCPrhPFIhTaA68X2q/0l6Uwcf5+GDJqy
        tbZw/+6MOKeI1w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:message-id
        :mime-version:subject:to:x-me-proxy:x-me-proxy:x-me-sender
        :x-me-sender:x-sasl-enc; s=fm3; bh=+v/Te64vKu4e35ENQ/jK6ubbrXoty
        gKRxSoJgsFaBMY=; b=qshJlZ0E5dHQkkrkVBROwDSY5Sgo3A2aErHKsBk4Qzhcr
        YwuFLcpq3tbOAjJDSQBmHDR6xZI/1CNCEffKHJUxCkzmx53vJLWlG1WdmkEXmPOD
        JfwLoYmaXaTcuR45TtB1ww+APCPkk8b6YtmvmF+w/VdCDOm1675nQNe0gWlxAK2m
        /Gd9KvUT4QKgNYiizc7yFmAfC52rbIbQVOKdX/S6Vor8Znp6GHXGU5Sq4jwTre1P
        FxtBFwbHScWLP1IFcoDIctKVuofwpIsDZ9BAn3TnMGziXoFlqCJ3z+uhNz3jMYsi
        DJ6Acx5FPad+2ZtZrUmjIPEXfcNXCVc/IRbnxdkEg==
X-ME-Sender: <xms:zWkDX3clahDmVS2Za88QRKWTl2jFfKPA9aUrGPYViYhe8ADoYyiMwg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrudefgdduvdegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfggtggusehgtderredttddvnecuhfhrohhmpeforgigihhmvgcu
    tfhiphgrrhguuceomhgrgihimhgvsegtvghrnhhordhtvggthheqnecuggftrfgrthhtvg
    hrnhepkeeffefgffeijeffveehkeffleejgeefvefhkedtteegvdefjeduveehhfetveej
    necuffhomhgrihhnpehkvghrnhgvlhdrohhrghdpsghoohhtlhhinhdrtghomhenucfkph
    epledtrdekledrieekrdejieenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhep
    mhgrihhlfhhrohhmpehmrgigihhmvgestggvrhhnohdrthgvtghh
X-ME-Proxy: <xmx:zWkDX9P5hF41A50xUPlgDeEOjXopXgSe8d_p3QdXha1TPnoEHGoE4Q>
    <xmx:zWkDXwhJ9vZX-1uH9isgRIGWZiQ4ejO47HRiIVneW_F2a0GCskxJqA>
    <xmx:zWkDX4-0vfTjH14CXWJMFhZ9q1I0n4BBtnRsNZ836qajUeJpYmg2IQ>
    <xmx:0GkDX5CDafBdVS4Q821QRHeAgSjerkAW00qSoNCP7YeICPRsL-z5Gg>
Received: from localhost (lfbn-tou-1-1502-76.w90-89.abo.wanadoo.fr [90.89.68.76])
        by mail.messagingengine.com (Postfix) with ESMTPA id 7C6193280064;
        Mon,  6 Jul 2020 14:13:33 -0400 (EDT)
Date:   Mon, 6 Jul 2020 20:13:31 +0200
From:   Maxime Ripard <maxime@cerno.tech>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Antoine =?utf-8?Q?T=C3=A9nart?= <antoine.tenart@bootlin.com>
Subject: PHY reset handling during DT parsing
Message-ID: <20200706181331.x2tn5cl5jn5kqmhx@gilmour.lan>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="2ftaacwvvl7mumne"
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--2ftaacwvvl7mumne
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

I came across an issue today on an Allwinner board, but I believe it's a
core issue.

That board is using the stmac driver together with a phy that happens to
have a reset GPIO, except that that GPIO will never be claimed, and the
PHY will thus never work.

You can find an example of such a board here:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/arch/arm/boot/dts/sun6i-a31-hummingbird.dts#n195

It looks like when of_mdiobus_register() will parse the DT, it will then
call of_mdiobus_register_phy() for each PHY it encounters [1].
of_mdiobus_register_phy() will then if the phy doesn't have an
ethernet-phy-id* compatible call get_phy_device() [2], and will later on
call phy_register_device [3].

get_phy_device() will then call get_phy_id() [4], that will try to
access the PHY through the MDIO bus [5].

The code that deals with the PHY reset line / GPIO is however only done
in mdiobus_device_register, called through phy_device_register. Since
this is happening way after the call to get_phy_device, our PHY might
still very well be in reset if the bootloader hasn't put it out of reset
and left it there.

I'm not entirely sure how to fix that though. I tried to fix it by
splitting away the gpio / reset code away from mdiobus_device_register
into a new function, and calling it before the first call to get_phy_id
so that we can put our phy out of reset, but it looks like the device
registration makes it more complicated than that. Any ideas?

Thanks!
Maxime

1: https://elixir.bootlin.com/linux/latest/source/drivers/of/of_mdio.c#L274
2: https://elixir.bootlin.com/linux/latest/source/drivers/of/of_mdio.c#L82
3: https://elixir.bootlin.com/linux/latest/source/drivers/of/of_mdio.c#L119
4: https://elixir.bootlin.com/linux/latest/source/drivers/net/phy/phy_device.c#L830
5: https://elixir.bootlin.com/linux/latest/source/drivers/net/phy/phy_device.c#L791

--2ftaacwvvl7mumne
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRcEzekXsqa64kGDp7j7w1vZxhRxQUCXwNpywAKCRDj7w1vZxhR
xU1lAQCR+4X7EF6qEnFyxVCuaNV/g3Bjlk5krQv8tSUb3DmQ+AEA2WAuzE9iBzzg
Awm1dmo/sBptpDkj+d3oPz4YqsFQvQw=
=Gsc3
-----END PGP SIGNATURE-----

--2ftaacwvvl7mumne--
