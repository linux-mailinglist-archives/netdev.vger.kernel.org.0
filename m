Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB743437A79
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 17:58:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233305AbhJVQBD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 12:01:03 -0400
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:59451 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230187AbhJVQBC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Oct 2021 12:01:02 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id E547C3200E89;
        Fri, 22 Oct 2021 11:58:42 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Fri, 22 Oct 2021 11:58:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cerno.tech; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=zEIfPWjC1VRIzhusY9qghkL4o/n
        u0PM64bV+mIwscgw=; b=cJHrlNX4WIG8HzPsb+Vzc44mV4VW3xcvqufYD96EYmz
        c6mzZQ8w5Kj/ay7Wpfa7k2wBpcwFQS/Vyl0hfV8kYXmtK729ApBqMfDFEjtZQeCS
        SNrWa4fujoDT+68MuiFlkF6I4/U9eXDZeASWEcY6jtLNRJ5VQ62lh0gxBcKR/Jly
        JCfr3vKSJgAjKDUTSwNxS+dPu4Pe3H9asOUBZzicpIjsPhdcRLb8JalQJjPXXSg/
        8xo++OIH6xVlmzfOKiRjumVHHROo6vbBph4k4DTp++iyUwB3o3SIdusRydJyzm2o
        mlnWaU94BOWBSXPlecqPo7tdC7sAHxitaSpccHOnIQw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=zEIfPW
        jC1VRIzhusY9qghkL4o/nu0PM64bV+mIwscgw=; b=Hk/SoJZKCwILwaYo8MsWQL
        rTAQreCBMZBNo3nCLYJ/Ph3axPpPkORRKrdPCcUreyqgfyOJt17To2gDrQP6kb7+
        +8mQ9pnx7ancWQgMr2FGLRL8Fgdtp8Ac/BfX8MgKOmU/8gDuJahkRB2wgACx3xAy
        CxC8FgUPI4HAycaCFPKqeHYCs+yjeriLUeik637D0+5SpVCt0TPfSnzQLkSZVw1v
        pLMl4RTvjvPcPW3bNp1+DPBEzS05IJA0TCJ3D9sw7jDwvzm/GC9GPXn+hBBuXrop
        +Q59XpQBOLt+kaLb1XzRmccOyWK9aIJ++yUjVX6khI6/ZVwRmXnHIpMwcd1OxTAA
        ==
X-ME-Sender: <xms:st9yYSZotTOASdA1mlv-PHt9Q3RxXTvXRpgW26aSIo_dd_XYZLkOvQ>
    <xme:st9yYVaYzT4sAGjAAMdcQHZdjNUvaHVlbiAmRfjMEHsVfixc0QFBIpCo4nk_ToDD_
    YDWUrV6KPn612quBN4>
X-ME-Received: <xmr:st9yYc94D2_YOVU256AGFI4fnhEDa9RrgxV2zWDn35NFRHN3lArV9pC5JvHo8QYbs1zIy_E6iBJP3g5VGgbASdZWyj3qHJctxHAgcmLq>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrvddvkedgjedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehgtderredttddvnecuhfhrohhmpeforgigihhm
    vgcutfhiphgrrhguuceomhgrgihimhgvsegtvghrnhhordhtvggthheqnecuggftrfgrth
    htvghrnhephffhueefgfekvdevfeeludduudduveeuveetlefgjeekleehtefhleeuheej
    vdevnecuffhomhgrihhnpehprghsthgvsghinhdrtghomhenucevlhhushhtvghrufhiii
    gvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehmrgigihhmvgestggvrhhnohdrthgv
    tghh
X-ME-Proxy: <xmx:st9yYUrW11UWm3y8X50t34eDuEnfdtu-FzECZntIA5_xYNU1jOfTfw>
    <xmx:st9yYdp96GucPFIQG0h_UD_K4teSSHK9Nwu_KOtZ1u4GL28OUKofPA>
    <xmx:st9yYSQO7mTGbAtvPSZqcpNBoI3oKCGyZ8eLc87expLpftTRh72mtg>
    <xmx:st9yYem-aGEZjRm1gKlQwBKgaGZZrukZsndhZjZwMjIv_X90ZE6bIw>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 22 Oct 2021 11:58:41 -0400 (EDT)
Date:   Fri, 22 Oct 2021 17:58:39 +0200
From:   Maxime Ripard <maxime@cerno.tech>
To:     Stefan Wahren <stefan.wahren@i2se.com>
Cc:     Doug Berger <opendmb@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, bcm-kernel-feedback-list@broadcom.com,
        Nicolas Saenz Julienne <nsaenz@kernel.org>
Subject: Re: GENET and UNIMAC MDIO probe issue?
Message-ID: <20211022155839.ptgazrgyvemfa23q@gilmour>
References: <20211022143337.jorflirdb6ctc5or@gilmour>
 <150dcf36-959c-36e3-3b35-74b7ec1db774@i2se.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="2dmyzyaamcsvo2ao"
Content-Disposition: inline
In-Reply-To: <150dcf36-959c-36e3-3b35-74b7ec1db774@i2se.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--2dmyzyaamcsvo2ao
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Stefan,

On Fri, Oct 22, 2021 at 05:35:50PM +0200, Stefan Wahren wrote:
> Hi Maxime,
>=20
> Am 22.10.21 um 16:33 schrieb Maxime Ripard:
> > Hi Florian, Doug,
> >
> > I'm currently trying to make the RaspberryPi CM4 IO board probe its
> > ethernet controller, and it looks like genet doesn't manage to find its
> > PHY and errors out with:
> >
> > [    3.240435] libphy: Fixed MDIO Bus: probed
> > [    3.248849] bcmgenet fd580000.ethernet: GENET 5.0 EPHY: 0x0000
> > [    3.259118] libphy: bcmgenet MII bus: probed
> > [    3.278420] mdio_bus unimac-mdio--19: MDIO device at address 1 is mi=
ssing.
> > [    3.285661] unimac-mdio unimac-mdio.-19: Broadcom UniMAC MDIO bus
> >
> > ....
> >
> > [   13.082281] could not attach to PHY
> > [   13.089762] bcmgenet fd580000.ethernet eth0: failed to connect to PHY
> > [   74.739621] could not attach to PHY
> > [   74.746492] bcmgenet fd580000.ethernet eth0: failed to connect to PHY
> >
> > Here's the full boot log:
> > https://pastebin.com/8RhuezSn
>=20
> looks like you are using the vendor DTB, please use the upstream DTB
> from linux-next:
>=20
> bcm2711-rpi-cm4-io.dtb

I thought upstream_kernel would be enough, but following your message
I forced it using device_tree, and indeed it works.

But I'm confused now, I don't have any other DTB for the CM4 on that
boot partition, where is that other device tree coming from?

Maxime
--2dmyzyaamcsvo2ao
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRcEzekXsqa64kGDp7j7w1vZxhRxQUCYXLfrwAKCRDj7w1vZxhR
xT9zAP9/gDBsjBQ5G7bfBymy2PwCUCF3Q2xTb8FKk99lFV9NHQEAq26KVMN0PbHh
9kLUXzpAuDmAQldhDDmmjFondmdswQ0=
=bRSK
-----END PGP SIGNATURE-----

--2dmyzyaamcsvo2ao--
