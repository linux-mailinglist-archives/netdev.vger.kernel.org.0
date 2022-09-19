Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5C0C5BD84E
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 01:33:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229846AbiISXdR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 19:33:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229863AbiISXdI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 19:33:08 -0400
Received: from wout4-smtp.messagingengine.com (wout4-smtp.messagingengine.com [64.147.123.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B2364F3A0
        for <netdev@vger.kernel.org>; Mon, 19 Sep 2022 16:33:05 -0700 (PDT)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id D72613200413;
        Mon, 19 Sep 2022 19:33:02 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Mon, 19 Sep 2022 19:33:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        invisiblethingslab.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to; s=fm2; t=1663630382; x=
        1663716782; bh=sPAQpBuT7DX/lS7+acc/WtdRkKeL6R3TMHiLOl+w4tY=; b=m
        Vd6slNt65xIsHqtglp3hdsadw9lSQeYd0+CyRJCK/LtUxBhuq6fGjwADWRWeVrQ9
        1py8PrsiIdWulP0BLiLKic7lzDYEhpzvCxfLLtyuVSCA7jzAbQRe1u4MTDGmkEqj
        Vw1EJXPUEcjyjnEFgzRAIXCpLY4dnwUBJX9njHeoY3D7qcZzLW0Bq8TPHGaynwlq
        KtEnHgStfVVmBKn6e0fk57BiVMYZE3wFVjbgFN9cBO98fdEx2d8F7FT2pQcmVpXC
        pgtrRU9lwWB5wzs8oCS2NOVpGf0f6NgmReKYNRHx7gmeSY9TgdTb8m9WufVGPIio
        OOsRbpIpnNG1B1km+pK9w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; t=1663630382; x=1663716782; bh=sPAQpBuT7DX/lS7+acc/WtdRkKeL
        6R3TMHiLOl+w4tY=; b=KqkDgd/qSeq2+spD9+IBUbKo10/GuXRMFhkG1t9Mom5Z
        0Jphwrq/t6v36FYAusrcFUjR6iC7qNknOtsdqxSFdfN4ohY+JeNXne4cW8nX+gxk
        6onMhgm1gAgBAlDeMYwqvpDGggfANBSrCfLq+dmMKOYkW5C5Hn4QA7oldvmSLJuu
        1Yq/EcwrRomaBgJaZSBMf2BDOrx5e9QWUuQ693Im7pYCJ6SfCKqjdxH3sdz/di1p
        tO1fZHZc4z55PXxYMZ1EQQus+HU99LWNkbBoCJERWEQplPW9gcwQKhh+bCtRE5TH
        k86pz7ZVrT9WW491oPOfDobzY3TOuG+03YGsVX4L4w==
X-ME-Sender: <xms:LvwoY8GVoUeNd9FlYmqtZOrKlSmOBnD_-ET9kdeBcl_B5SneZyEfQA>
    <xme:LvwoY1VFOmDYDmw9zsjdnOpkheBRShb56jfwNBetIUT9bgcqTNQMiWroqRIESvvK9
    C1TShBSXpYQWw8>
X-ME-Received: <xmr:LvwoY2I71urqkU1LvveFJDPQbJYTusKLS7dqSVJn_IWmp8xQtBAhRUwWtJct>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrfedvkedgvdefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggujgesghdtreertddtjeenucfhrhhomhepffgvmhhi
    ucforghrihgvucfqsggvnhhouhhruceouggvmhhisehinhhvihhsihgslhgvthhhihhngh
    hslhgrsgdrtghomheqnecuggftrfgrthhtvghrnhepvdejteegkefhteduhffgteffgeff
    gfduvdfghfffieefieekkedtheegteehffelnecuvehluhhsthgvrhfuihiivgeptdenuc
    frrghrrghmpehmrghilhhfrhhomhepuggvmhhisehinhhvihhsihgslhgvthhhihhnghhs
    lhgrsgdrtghomh
X-ME-Proxy: <xmx:LvwoY-HAzHVNvziwCiMWaMLXzmCUWjLnFlotTnFMUMpE2OA4TzEo9g>
    <xmx:LvwoYyUKKEdNzUfbY5CmFmpj_Bf4NuaacQ1-9npbLQYqyTBWVQM5TA>
    <xmx:LvwoYxMsLDZ2pG-EDLye_AkxelKM8QU6VneVWPtATcWUhBZ1NZBjAw>
    <xmx:LvwoY7ei9u9VWN5v0e3sPor6FsGJlD31fzB881TCcLrZu-la0qMRlA>
Feedback-ID: iac594737:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 19 Sep 2022 19:33:01 -0400 (EDT)
Date:   Mon, 19 Sep 2022 19:32:57 -0400
From:   Demi Marie Obenour <demi@invisiblethingslab.com>
To:     Elliott Mitchell <ehem+xen@m5p.com>
Cc:     Xen developer discussion <xen-devel@lists.xenproject.org>,
        netdev@vger.kernel.org
Subject: Re: Layer 3 (point-to-point) netfront and netback drivers
Message-ID: <Yyj8K0OL/M2L/Ts1@itl-email>
References: <YycSD/wJ9pL0VsFD@itl-email>
 <YyjVQxmIujBMzME3@mattapan.m5p.com>
 <Yyjh+EfCbiAI4vqi@itl-email>
 <Yyj5d0uTeXLGmvLK@mattapan.m5p.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="Xuc8mAzzLN+qoJxE"
Content-Disposition: inline
In-Reply-To: <Yyj5d0uTeXLGmvLK@mattapan.m5p.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--Xuc8mAzzLN+qoJxE
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Date: Mon, 19 Sep 2022 19:32:57 -0400
From: Demi Marie Obenour <demi@invisiblethingslab.com>
To: Elliott Mitchell <ehem+xen@m5p.com>
Cc: Xen developer discussion <xen-devel@lists.xenproject.org>,
	netdev@vger.kernel.org
Subject: Re: Layer 3 (point-to-point) netfront and netback drivers

On Mon, Sep 19, 2022 at 04:21:27PM -0700, Elliott Mitchell wrote:
> On Mon, Sep 19, 2022 at 05:41:05PM -0400, Demi Marie Obenour wrote:
> > On Mon, Sep 19, 2022 at 01:46:59PM -0700, Elliott Mitchell wrote:
> > > On Sun, Sep 18, 2022 at 08:41:25AM -0400, Demi Marie Obenour wrote:
> > > > How difficult would it be to provide layer 3 (point-to-point) versi=
ons
> > > > of the existing netfront and netback drivers?  Ideally, these would
> > > > share almost all of the code with the existing drivers, with the on=
ly
> > > > difference being how they are registered with the kernel.  Advantag=
es
> > > > compared to the existing drivers include less attack surface (since=
 the
> > > > peer is no longer network-adjacent), slightly better performance, a=
nd no
> > > > need for ARP or NDP traffic.
> > >=20
> > > I've actually been wondering about a similar idea.  How about breaking
> > > the entire network stack off and placing /that/ in a separate VM?
> >=20
> > This is going to be very hard to do without awesome but difficult
> > changes to applications.  Switching to layer 3 links is a much smaller
> > change that should be transparent to applications.
>=20
> Indeed for ones which modify network settings, but not for ones which
> merely use the sockets API.  Isn't this the same issue for what you're
> suggesting?

No.  What I am referring to is having netfront and netback carry IP
packets instead of Ethernet frames.  This is transparent to applications
that use the sockets API.  What you are talking about, if I understand
correctly, requires changing the implementation of the sockets API,
which is much harder.

> > > The other use is network cards which are increasingly able to handle =
more
> > > of the network stack.  The Linux network team have been resistant to
> > > allowing more offloading, so perhaps it is time to break *everything*
> > > off.
> >=20
> > Do you have any particular examples?  The only one I can think of is
> > that Linux is not okay with TCP offload engines.
>=20
> That is precisely what I was thinking of.  While I understand the desire
> for control, when it comes down to it a network card which lies could
> simply transparently proxy everything.  Anything not protected by
> cryptography is vulnerable, so worrying about raw packets doesn't seem
> useful.

IIRC the problems with TCP offload engines are that they do not support
all of Linux=E2=80=99s features (such as netfilter), require invasive hooks=
 so
that various configuration can be handled using standard Linux tools,
and have closed-source firmware with substantial remote attack surface.

> > > I'm unsure the benefits would justify the effort, but I keep thinking=
 of
> > > this as the solution to some interesting issues.  Filtering becomes m=
ore
> > > interesting, but BPF could work across VMs.
> >=20
> > Classic BPF perhaps, but eBPF's attack surface is far too large for this
> > to be viable.  Unprivileged eBPF is already disabled by default.
>=20
> I was thinking of classic BPF.  If everything below the sockets layer
> was in a separate VM, filtering rules could still work by pushing BPF
> rules to the other side.
>=20
>=20
> Your idea is to push less into a separate VM than I was thinking.  I
> wanted to bring up it might be worthwhile pushing more.  If your project
> launches I imagine eventually you'll be trying to encompass more, so it
> may be easier to consider what the future will hold.

I don=E2=80=99t actually plan to go beyond this, although you are of course=
 free
to do so.  This change is simply to reduce attack surface and complexity
in Qubes OS, which uses layer 2 links where layer 3 links would do.  I
am hoping this is just a matter of how the netback and netfront drivers
register with Linux.  I also don=E2=80=99t have the time to implement the c=
hange
right now.  My question is about what the change would involve.
--=20
Sincerely,
Demi Marie Obenour (she/her/hers)
Invisible Things Lab

--Xuc8mAzzLN+qoJxE
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEdodNnxM2uiJZBxxxsoi1X/+cIsEFAmMo/CwACgkQsoi1X/+c
IsHOOg/+KqLw+taYcsMHLuXvlNlifovgaaztkj6UMVN1i6d06lqX/ts1cWHztq4n
+ANyU9y9Z3uKRx/DvFqpiaNnnF6T5v3qEjxd4/dljQVrP5NGHgrJacUHBqmUnNp6
k50ONZBp5kDUjZpA/InekCmKGezVwIhamC2brbi+V74Cs5ILP29HWFXaa+ZoU4lc
kwvCpViNjFmHIUzYq22a3PQJ7whZVU0w5oe5yEXGNO5ISKjoajiSpCmqWZRwShgZ
IJuyMSnXjkZEQ6iQ35e4YGi4lBRSLPlF5qrgIxgLoqWU0sveBN/0y6LT3bWSdfLo
y6xDkBOEyUh6c+TesqO5OdW8zS3B8S94SiqW148ZQTpNZx3qERILtgjvjaVHV/rr
Q80k2nlrt85UwHHoHvVSzfkJoAnuNKBisQkxx5ZB6/fUPP0PVYWkKBFCKv5CNfXr
9cMxSuiyGYt+/xBoDPwc0w7p7bmfAQuYQGdPwo8nYMF8cg4K/c74wTGWTm//aARJ
PYclKujh3N4rdHM/7sjSLuKpc3BdFh8rbSV/R6bpzGTqt5CHy5Ue+gN51V2kfWIu
0V3uXW+OO5/7VbngyshxXDvEtjNO4hm0suRqoj/2THsiA/Q7gWkXW8t3OHOCjSmx
/JvPxYLOPLyS6/9MBtk2aDbixS2Y6YK8lBZkOhm3kp4j77sFYPI=
=kwTi
-----END PGP SIGNATURE-----

--Xuc8mAzzLN+qoJxE--
