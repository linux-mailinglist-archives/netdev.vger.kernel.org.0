Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 090AE2DAC53
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 12:48:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728801AbgLOLrG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 06:47:06 -0500
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:41463 "EHLO
        new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728646AbgLOLqv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Dec 2020 06:46:51 -0500
X-Greylist: delayed 511 seconds by postgrey-1.27 at vger.kernel.org; Tue, 15 Dec 2020 06:46:50 EST
Received: from compute7.internal (compute7.nyi.internal [10.202.2.47])
        by mailnew.nyi.internal (Postfix) with ESMTP id 5371A580397;
        Tue, 15 Dec 2020 06:37:13 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute7.internal (MEProxy); Tue, 15 Dec 2020 06:37:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cerno.tech; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=AFuIKgjw3WQKcS4EGTNGDedZlPw
        i+JZ5/cwhmXUQG3o=; b=WUkXbOedEpV8dAFGuREzjepXVrcDhZVExqGy1m5ttCI
        bwpO7qdL/dGLJh2DU9hjqyCEwB1aWMNRpHj+2dpvNVeCen3gD9RIAWYLsRAvfFrG
        cRwGH0Qg1ZwwaFXuHajTFtKx4T2rT1h7ewenLiJIM3BcJUGaKWeE1dg+rrpG8MlN
        0XXltan4TaUWaUvDXE4qUvuH4ZDiSJIa8rXm1AtogOl2ZIT45q4wXJXO/cR/tpqw
        zRQCp2HDwi7lJs9hHdCVMSYy1sXg9Mg+IbMqh4ks8UEMxIkIXv5UAMNY2wb/0VxY
        /A878nE31KqgB+IFtvEEDFlLPd2ecJImpc2TlDMDMdA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=AFuIKg
        jw3WQKcS4EGTNGDedZlPwi+JZ5/cwhmXUQG3o=; b=f9S7kxHEYpCdmnSvZBuQhD
        87kV0YBwQyoWt7zomfzEmARxlaxPJ49EKzmLodh6wGEEn+MSmOT4mJ62VeFWmCNs
        7iVK1pnRJZkF+ivl5wre8j1LkcBdfmbh3Pe+jS/IUCURyo6lT1KHB+BUpSiu4n6E
        VQYYTI5j9Iek9DFduMuWoHja7LKn7RvvmweNAi/8wt9+6PCtqZxxfxo8cQo6ekVu
        pphqro4Y8IBk0nW2KilobmYLatY4uTwwzOp5UMhr1KvQHWbo5s5adknHw9oq2G6g
        3weZK6pfefvNWryvyhpfuk2yAhg/Oj1cZNSyp51zOOi3FjpLWpg2RNI9HPc1GkmQ
        ==
X-ME-Sender: <xms:55_YX5f1uKhCu56Y0ngVe5i-ahM42v2ZydGG8Eltm9QOTXKf2HsrLA>
    <xme:55_YX8dEmWu574qhQng5KVbB8LSwDVW6QgRGhX2BZ5N5L_9TxJTE6jibE_wtkx8r8
    aGl2-g3uzcxm2oeXvo>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudeltddgfeduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehgtderredttddvnecuhfhrohhmpeforgigihhm
    vgcutfhiphgrrhguuceomhgrgihimhgvsegtvghrnhhordhtvggthheqnecuggftrfgrth
    htvghrnhepleekgeehhfdutdeljefgleejffehfffgieejhffgueefhfdtveetgeehieeh
    gedunecukfhppeeltddrkeelrdeikedrjeeinecuvehluhhsthgvrhfuihiivgeptdenuc
    frrghrrghmpehmrghilhhfrhhomhepmhgrgihimhgvsegtvghrnhhordhtvggthh
X-ME-Proxy: <xmx:55_YX0OyFFbMBxpeIViMmsm2umf673uJEMqKmQu44mjA8oD8FMWCSQ>
    <xmx:55_YX7IOBeNB0Gi1cesJ5_Fve0qr3kHrQMSEPjaeAyLAYb6whmjGDg>
    <xmx:55_YX9F2TUSKM0JRMtTFHldH8s2Wt9n988T0vov75o7_FrnbYVncLg>
    <xmx:6Z_YX5l1ml92QtphuwX0y2pfzP7Fb_rRPzMRvS43Q55xC_L_cNmaJg>
Received: from localhost (lfbn-tou-1-1502-76.w90-89.abo.wanadoo.fr [90.89.68.76])
        by mail.messagingengine.com (Postfix) with ESMTPA id 805E71080064;
        Tue, 15 Dec 2020 06:37:11 -0500 (EST)
Date:   Tue, 15 Dec 2020 12:37:10 +0100
From:   Maxime Ripard <maxime@cerno.tech>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        davem@davemloft.net, kuba@kernel.org, wens@csie.org,
        jernej.skrabec@siol.net, timur@kernel.org,
        song.bao.hua@hisilicon.com, f.fainelli@gmail.com, leon@kernel.org,
        hkallweit1@gmail.com, wangyunjian@huawei.com, sr@denx.de,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] net: allwinner: Fix some resources leak in the error
 handling path of the probe and in the remove function
Message-ID: <20201215113710.wh4ezrvmqbpxd5yi@gilmour>
References: <20201214202117.146293-1-christophe.jaillet@wanadoo.fr>
 <20201215085655.ddacjfvogc3e33vz@gilmour>
 <20201215091153.GH2809@kadam>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="3jnlnqak5zfuvw2l"
Content-Disposition: inline
In-Reply-To: <20201215091153.GH2809@kadam>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--3jnlnqak5zfuvw2l
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 15, 2020 at 12:11:53PM +0300, Dan Carpenter wrote:
> On Tue, Dec 15, 2020 at 09:56:55AM +0100, Maxime Ripard wrote:
> > Hi,
> >=20
> > On Mon, Dec 14, 2020 at 09:21:17PM +0100, Christophe JAILLET wrote:
> > > 'irq_of_parse_and_map()' should be balanced by a corresponding
> > > 'irq_dispose_mapping()' call. Otherwise, there is some resources leak=
s.
> >=20
> > Do you have a source to back that? It's not clear at all from the
> > documentation for those functions, and couldn't find any user calling it
> > from the ten-or-so random picks I took.
>=20
> It looks like irq_create_of_mapping() needs to be freed with
> irq_dispose_mapping() so this is correct.

The doc should be updated first to make that clear then, otherwise we're
going to fix one user while multiples will have poped up

Maxime

--3jnlnqak5zfuvw2l
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRcEzekXsqa64kGDp7j7w1vZxhRxQUCX9if5gAKCRDj7w1vZxhR
xcrsAQCAqxdmtzOx5x2uljGYBPES+hoL5VtWTPYJ7galIKwmeQD9FLlD8pXyN4+t
mmaQfNPJYJvD1vLewe+K5RjOzDRO3wA=
=v6FU
-----END PGP SIGNATURE-----

--3jnlnqak5zfuvw2l--
