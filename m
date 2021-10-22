Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DC7B437912
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 16:33:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233097AbhJVOgA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 10:36:00 -0400
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:52021 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232949AbhJVOf7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Oct 2021 10:35:59 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id 876D43200A2F;
        Fri, 22 Oct 2021 10:33:41 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Fri, 22 Oct 2021 10:33:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cerno.tech; h=
        date:from:to:cc:subject:message-id:mime-version:content-type; s=
        fm1; bh=la47Egwy6Y/rRPx3RH82DEySo4XXahG+teKFgq7ZosY=; b=A3JnhrLt
        Bezz1ZX8ytp6kDztCHRLcDzy3PydIli1Q9Xr6H26BzRj6Y1v+zxdjyb5Ihx6OYGh
        tpWAtDp1JSdn6oU+h35toQY5LZLkB52dZEhI9LSZEaQtlpmAC15nRrT1XxRV5ZBp
        GLpS1lbjUwZ3uFfkh1UldBwq8YV0wBaejSxMsEE9Ck34VgxKC1Mvm8I9lOIkrpbC
        2jOayUUnlKyv/3mCfZy4n11A9LcCnnVYlTD1tUyd6vaizXbRVDE1C8bPe9fx4KMA
        BncF4p17zeHUnyeUsmllzXMREZTkVt1BbqrJjnRZi+JOSeN2GWfoDgXJ79l4AEPz
        GfRWfCtSXPAYfA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:message-id
        :mime-version:subject:to:x-me-proxy:x-me-proxy:x-me-sender
        :x-me-sender:x-sasl-enc; s=fm1; bh=la47Egwy6Y/rRPx3RH82DEySo4XXa
        hG+teKFgq7ZosY=; b=SEMzn2BMINSVzAF+703koNzKCwxR8UBH7eS+yuTbb3LOw
        9oMK6YnupNrzc9P5s6Zt5dXU6il2+YI1tJRIFsfJCW48oGnqlrvxKtiIVgcMqrsP
        NpMmzODSKo6UOe13C8h0g3ViUOWSoNiatjRg3i3coPt656yaOo5wuuRW2i2+8kRI
        SFI/+MNg3ypMbgxM3An8bTzZoHeYvH6zx8zT6us2b0drZY/b5ZgRUSj7pQyj4O6K
        MnRc1BuF/tgtRZ4ZP+aJsHvJ82wyH+krIvz+SgpqYzhXMnvg26ZrBC1p/LQHuoUE
        PuTF9WZLDvVvBI5H4Tc+m66xbK07Zs7pP1Forn5LA==
X-ME-Sender: <xms:xMtyYaeKdic_3mD06wqfFaiwZTkWGvlOML6Sm0L0Nkp3vq5I-iMe9Q>
    <xme:xMtyYUMv9TmHxdJsCHCaG4KLcqnne6ekE0lvcx9Sf3fUkJkI2Hpig1CT6MTqvhYLm
    UDqi2uiztDF_dIaCGE>
X-ME-Received: <xmr:xMtyYbip_5gnF5LJNI5nlp1LXeegLYJhvaKaqpSaWWMIL3kOUEeiuIGj5ccGDETnbaXzhyjCCuibI7RmqRDNCWEiUqjb_iebwVHbLlme>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrvddvkedgjedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfggtggusehgtderredttddvnecuhfhrohhmpeforgigihhmvgcu
    tfhiphgrrhguuceomhgrgihimhgvsegtvghrnhhordhtvggthheqnecuggftrfgrthhtvg
    hrnhepuefgueelvedvjeejfeeltedtgffhkeevgfeugfelgeekjeetgeetkeefleffffek
    necuffhomhgrihhnpehprghsthgvsghinhdrtghomhdpkhgvrhhnvghlrdhorhhgnecuve
    hluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepmhgrgihimhgv
    segtvghrnhhordhtvggthh
X-ME-Proxy: <xmx:xMtyYX__2SH1B3ij1GANHUUdheUrNHXXaoUa73LlKIqZ9gPmA72JTQ>
    <xmx:xMtyYWuntSw_AHHeYT9XwFrt0pfXmiZNUAoNJhzINpxksHMLRTXX9A>
    <xmx:xMtyYeEGTd_06q2Xu2MguJ35S8dMS76quo8Hll4k22AG3c6rdFWiCA>
    <xmx:xctyYYJrFzut8Iiv2Gybu1uZWCyUoY5ZVecrHSvZoSZciwa1PnawaA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 22 Oct 2021 10:33:40 -0400 (EDT)
Date:   Fri, 22 Oct 2021 16:33:37 +0200
From:   Maxime Ripard <maxime@cerno.tech>
To:     Doug Berger <opendmb@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, bcm-kernel-feedback-list@broadcom.com,
        Nicolas Saenz Julienne <nsaenz@kernel.org>,
        Stefan Wahren <stefan.wahren@i2se.com>
Subject: GENET and UNIMAC MDIO probe issue?
Message-ID: <20211022143337.jorflirdb6ctc5or@gilmour>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="gwmvh4j2paigd32i"
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--gwmvh4j2paigd32i
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Florian, Doug,

I'm currently trying to make the RaspberryPi CM4 IO board probe its
ethernet controller, and it looks like genet doesn't manage to find its
PHY and errors out with:

[    3.240435] libphy: Fixed MDIO Bus: probed
[    3.248849] bcmgenet fd580000.ethernet: GENET 5.0 EPHY: 0x0000
[    3.259118] libphy: bcmgenet MII bus: probed
[    3.278420] mdio_bus unimac-mdio--19: MDIO device at address 1 is missing.
[    3.285661] unimac-mdio unimac-mdio.-19: Broadcom UniMAC MDIO bus

....

[   13.082281] could not attach to PHY
[   13.089762] bcmgenet fd580000.ethernet eth0: failed to connect to PHY
[   74.739621] could not attach to PHY
[   74.746492] bcmgenet fd580000.ethernet eth0: failed to connect to PHY

Here's the full boot log:
https://pastebin.com/8RhuezSn

It looks like it's related to the following bugzilla entry:
https://bugzilla.kernel.org/show_bug.cgi?id=213485

However, that commit has been merged for a while apparently, and even
next-20211022 shows that behavior, both with the drivers built-in or as
modules. The other suggested fix to set probe_type to
PROBE_FORCE_SYNCHRONOUS doesn't seem to fix it either.

Maxime

--gwmvh4j2paigd32i
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRcEzekXsqa64kGDp7j7w1vZxhRxQUCYXLLvAAKCRDj7w1vZxhR
xfoKAPoDjeCSlyj1tImOb/wINm56CRX1zGyedJ3J5PgCIWAevQEAmhhE916Ghqyz
f1++UC8xjpTnoqAhFv7QCgwrxyLPlQU=
=ryie
-----END PGP SIGNATURE-----

--gwmvh4j2paigd32i--
