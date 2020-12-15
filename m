Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAEBC2DB460
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 20:17:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731828AbgLOTRl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 14:17:41 -0500
Received: from wnew2-smtp.messagingengine.com ([64.147.123.27]:35425 "EHLO
        wnew2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731613AbgLOTRS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Dec 2020 14:17:18 -0500
X-Greylist: delayed 478 seconds by postgrey-1.27 at vger.kernel.org; Tue, 15 Dec 2020 14:17:13 EST
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.west.internal (Postfix) with ESMTP id BE7FB8EE;
        Tue, 15 Dec 2020 14:08:19 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Tue, 15 Dec 2020 14:08:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cerno.tech; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=dWCDLul9MYH7RotH8Fgke92fWSv
        SFd1KDNhizpPiBj0=; b=BQGtCAgB4FQ2bNAoERgLZgnZMC2kA//av80NLUSKqll
        RIuS3vrYeSbPhPAK5nAC7bnAFCGuLJhaJ3qJ2eaxOnJD7FMU/J38MnK4W2hr3iCh
        mc2+rPlFYRyqWfrdCVrKQw/e8g3EtiGCto8ERdFC5bgp8SkXAjMxkMAN90dMzNIe
        9XP4c1NLlP0GI8TvOguMXb9cgw2kS/XlctgxREz9thMsHVhR2VGDIXCKOlOsRmqw
        hiKlK80FX2Vy5+YMx8BZRnRI+VYxuG+rq7712dY8MJjTYnOu7MnrdYL2NBNEfGYl
        Sd6kwkFGRLRmIscZpwGnJZlCZxaeq+uATSNkLiCLJWg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=dWCDLu
        l9MYH7RotH8Fgke92fWSvSFd1KDNhizpPiBj0=; b=JKg7XgYmKzawST57za4gtI
        Dk2kWuEXLU1RyyBi+Yb6XAgDOL7Vr6GdtEzm4ucjTEHYHps8OOBEZnuhn5y2b8Qi
        DnESSfnaTTd1Y7VIzOxCwdvfUKmoCyqawoLLhbY+eyM/jYKEGmwTlib+l8h3t3tw
        DFvwuVFV5KP++ehGlVbxMebr95Y12kSyhYGsbXPcQKu0ymLUxq6pkAatbfB+OgL0
        HVxQQZaRAlVkWYsrzI2u5iMBVx0Sd+riMXTMYWNWBWNFzoYV9vvk+xLFwTsuvtby
        8L+jmiIiVIrN7oI8asEROMLv/bRxfHlkoj80/50rkZZ3BhKAKQqJ9weUZki61oOw
        ==
X-ME-Sender: <xms:oAnZXxPo6cxU9x_ZC6rjIWlvEPQwY6ElUvY6YoerOIqLxXSfRP_oBw>
    <xme:oAnZXwTPR5NDGwMKkg_5wBrhml3yEouIvKulmlvp8_a_EZotdbXGYaGY0cOtY2duL
    RDob9xiK8kkPf3r-xM>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudeltddguddvfecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujgesghdtreertddtudenucfhrhhomhepofgrgihi
    mhgvucftihhprghrugcuoehmrgigihhmvgestggvrhhnohdrthgvtghhqeenucggtffrrg
    htthgvrhhnpeduvdduhfekkeehgffftefflefgffdtheffudffgeevteffheeuiedvvdej
    vdfgveenucfkphepledtrdekledrieekrdejieenucevlhhushhtvghrufhiiigvpedtne
    curfgrrhgrmhepmhgrihhlfhhrohhmpehmrgigihhmvgestggvrhhnohdrthgvtghh
X-ME-Proxy: <xmx:oAnZXzDGP5jhHoZo5UoLFpK8fbopbLmVSUoPwkU-zKkyzgHwsP8Tvg>
    <xmx:oAnZX_ghCkwipCtOa3r3oEOzg9atxqVsN8JmbMrwwEX9k7CJ_DbgQQ>
    <xmx:oAnZX8M8vg-WU-YE15kwAZnrv7tdDHW_bgA0Y4WdEkKo3Vq2o0Zh9A>
    <xmx:ownZX4vuwBGYZFzIteSHmsOfEzB2L6BPzQx43HNBjOaNiy6bBh487NvsE2g>
Received: from localhost (lfbn-tou-1-1502-76.w90-89.abo.wanadoo.fr [90.89.68.76])
        by mail.messagingengine.com (Postfix) with ESMTPA id ACA0A1080067;
        Tue, 15 Dec 2020 14:08:16 -0500 (EST)
Date:   Tue, 15 Dec 2020 20:08:15 +0100
From:   Maxime Ripard <maxime@cerno.tech>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     Dan Carpenter <dan.carpenter@oracle.com>, davem@davemloft.net,
        kuba@kernel.org, wens@csie.org, jernej.skrabec@siol.net,
        timur@kernel.org, song.bao.hua@hisilicon.com, f.fainelli@gmail.com,
        leon@kernel.org, hkallweit1@gmail.com, wangyunjian@huawei.com,
        sr@denx.de, linux-arm-kernel@lists.infradead.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] net: allwinner: Fix some resources leak in the error
 handling path of the probe and in the remove function
Message-ID: <20201215190815.6efzcqko55womf6b@gilmour>
References: <20201214202117.146293-1-christophe.jaillet@wanadoo.fr>
 <20201215085655.ddacjfvogc3e33vz@gilmour>
 <20201215091153.GH2809@kadam>
 <20201215113710.wh4ezrvmqbpxd5yi@gilmour>
 <54194e3e-5eb1-d10c-4294-bac8f3933f47@wanadoo.fr>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="np4pkv32spdrwk7i"
Content-Disposition: inline
In-Reply-To: <54194e3e-5eb1-d10c-4294-bac8f3933f47@wanadoo.fr>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--np4pkv32spdrwk7i
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 15, 2020 at 07:18:48PM +0100, Christophe JAILLET wrote:
> Le 15/12/2020 =E0 12:37, Maxime Ripard a =E9crit=A0:
> > On Tue, Dec 15, 2020 at 12:11:53PM +0300, Dan Carpenter wrote:
> > > On Tue, Dec 15, 2020 at 09:56:55AM +0100, Maxime Ripard wrote:
> > > > Hi,
> > > >=20
> > > > On Mon, Dec 14, 2020 at 09:21:17PM +0100, Christophe JAILLET wrote:
> > > > > 'irq_of_parse_and_map()' should be balanced by a corresponding
> > > > > 'irq_dispose_mapping()' call. Otherwise, there is some resources =
leaks.
> > > >=20
> > > > Do you have a source to back that? It's not clear at all from the
> > > > documentation for those functions, and couldn't find any user calli=
ng it
> > > > from the ten-or-so random picks I took.
> > >=20
> > > It looks like irq_create_of_mapping() needs to be freed with
> > > irq_dispose_mapping() so this is correct.
> >=20
> > The doc should be updated first to make that clear then, otherwise we're
> > going to fix one user while multiples will have poped up
> >=20
> > Maxime
> >=20
>=20
> Hi,
>=20
> as Dan explained, I think that 'irq_dispose_mapping()' is needed because =
of
> the 'irq_create_of_mapping()" within 'irq_of_parse_and_map()'.
>=20
> As you suggest, I'll propose a doc update to make it clear and more future
> proof.

Thanks :)

And if you feel like it, a coccinelle script would be awesome too so
that other users get fixed over time

Maxime

--np4pkv32spdrwk7i
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRcEzekXsqa64kGDp7j7w1vZxhRxQUCX9kJngAKCRDj7w1vZxhR
xR6iAQCYBl0k0FS3O7aaMjiuDMcw+buQelECZ8B6EltdifEEfAD/a3yu9LamvXJd
ZntPs+j60NZcjdM7PuWbJiXL+590ig8=
=++pp
-----END PGP SIGNATURE-----

--np4pkv32spdrwk7i--
