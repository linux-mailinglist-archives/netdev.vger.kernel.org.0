Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D937338ECBD
	for <lists+netdev@lfdr.de>; Mon, 24 May 2021 17:21:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234297AbhEXPWo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 May 2021 11:22:44 -0400
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:42283 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232746AbhEXPPE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 May 2021 11:15:04 -0400
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.west.internal (Postfix) with ESMTP id D17B04476;
        Mon, 24 May 2021 11:13:32 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Mon, 24 May 2021 11:13:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cerno.tech; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=BGa72Vj6zhdzVJ4MQX7Q91APrP9
        Unrjyy5c4SX8SOrc=; b=mWpDg5tBjU9621uQ54CKDVyw+Gv2TiI7f4GuNwXz1W3
        kXLLs4castuRfycfbqcuTHhumHK7HDqLFpKW8iOEQs+5O9LSKEYThwfdo5avZJgL
        fQ4BuowLt8t2P/+Cs/DiDlhnETvgH6Fc7sMwachowHcitst/Gy3BWxtr49vEILPn
        k8Xi5VFN5V4OTprAOrbYejPt6KkGvVlQbw7RS4OGwUXZ7XKQGnb975OmQRcupGpj
        EXzo3SknZvxfym9Sin4gzBUfWSdk2uQQjU8OrowDefsDc2TOVAbsy1XCw+4qXnhX
        u4r3vkhJ9N5mHrFfFSGiQkAVmKjClvuzRxYmcWmfYxQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=BGa72V
        j6zhdzVJ4MQX7Q91APrP9Unrjyy5c4SX8SOrc=; b=oJ3fWltJeZ+rjCRSXb30hz
        a1hWCac2qaRfPjbFIt8HtpCrYvdOnhgai9lZGyKGiASWteZIyLLQx3CySjYY2c9+
        i3kEt5DLNAk6NIyGNwT4Pf4LIE3PM+qSSIs2NxjluRw1UNJQdtoriOMuE5UhFe4i
        r7FD+Iblp1uHmzZu1CPuAySf/CHqmWmzxB4MLpjlUmN7css8ujLA4hPf3W8JIu1w
        kIKPoVYZgJdjkmkPS7W5dpFoqWCs+44FqAqrJ004J3x3rFh7EOnkgInSccn+13qG
        PRtP+om51wiicwnVC8O6llEDPusO3DZAK4VXZWLzSnRj8B/VPKhzhNYytZHKGBpg
        ==
X-ME-Sender: <xms:nMKrYAeDrLPsbckCZlfYi8A3JXhMYiXesiQWu5J57G7Shc-LSrhMgA>
    <xme:nMKrYCMwlqKesaxpCLvlHKhU2ofb0JUU1_2ZzebXE1Jl_KWI2XsqgGPOJ4pdP3o3j
    uD4nYie7xYtn04avQA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdejledgkeekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehgtderredttddvnecuhfhrohhmpeforgigihhm
    vgcutfhiphgrrhguuceomhgrgihimhgvsegtvghrnhhordhtvggthheqnecuggftrfgrth
    htvghrnhepleekgeehhfdutdeljefgleejffehfffgieejhffgueefhfdtveetgeehieeh
    gedunecukfhppeeltddrkeelrdeikedrjeeinecuvehluhhsthgvrhfuihiivgeptdenuc
    frrghrrghmpehmrghilhhfrhhomhepmhgrgihimhgvsegtvghrnhhordhtvggthh
X-ME-Proxy: <xmx:nMKrYBhJ1tpQmpXUYX6dQCBQgcjM4kKLZlLtE3Rlws5PCoL2GlUCKw>
    <xmx:nMKrYF8b7Cn0DEXJH0_-bdo7plvPfex_2lvq8nDqG-01aV2vqPwzbg>
    <xmx:nMKrYMvF9tN30CuUlWSkf9Z_9MEwi-5SdT213s88qxUBVEzSXKJjDw>
    <xmx:nMKrYIIy6EsRpwSp7yJS8oCOfb1sE7ue1Tc_AFvG7eylBTvIZdy1Ew>
Received: from localhost (lfbn-tou-1-1502-76.w90-89.abo.wanadoo.fr [90.89.68.76])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Mon, 24 May 2021 11:13:31 -0400 (EDT)
Date:   Mon, 24 May 2021 17:13:29 +0200
From:   Maxime Ripard <maxime@cerno.tech>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Doug Berger <opendmb@gmail.com>,
        bcm-kernel-feedback-list@broadcom.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Nicolas Saenz Julienne <nsaenz@kernel.org>
Subject: Re: Kernel Panic in skb_release_data using genet
Message-ID: <20210524151329.5ummh4dfui6syme3@gilmour>
References: <20210524130147.7xv6ih2e3apu2zvu@gilmour>
 <a53f6192-3520-d5f8-df4b-786b3e4e8707@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="wgtnyrrd22offedx"
Content-Disposition: inline
In-Reply-To: <a53f6192-3520-d5f8-df4b-786b3e4e8707@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--wgtnyrrd22offedx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Florian,

On Mon, May 24, 2021 at 07:49:25AM -0700, Florian Fainelli wrote:
> Hi Maxime,
>=20
> On 5/24/2021 6:01 AM, Maxime Ripard wrote:
> > Hi Doug, Florian,
> >=20
> > I've been running a RaspberryPi4 with a mainline kernel for a while,
> > booting from NFS. Every once in a while (I'd say ~20-30% of all boots),
> > I'm getting a kernel panic around the time init is started.
> >=20
> > I was debugging a kernel based on drm-misc-next-2021-05-17 today with
> > KASAN enabled and got this, which looks related:
>=20
> Is there a known good version that could be used for bisection or you
> just started to do this test and you have no reference point?

I've had this issue for over a year and never (I think?) got a good
version, so while it might be a regression, it's not a recent one.

> How stable in terms of clocking is the configuration that you are using?
> I could try to fire up a similar test on a Pi4 at home, or use one of
> our 72112 systems which is the closest we have to a Pi4 and see if that
> happens there as well.

I'm not really sure about the clocking. Is there any clock you want to
look at in particular?

My setup is fairly simple: the firmware and kernel are loaded over TFTP
and the rootfs is mounted over NFS, and the crash always occur around
init start, so I guess when it actually starts to transmit a decent
amount of data?

Maxime

--wgtnyrrd22offedx
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRcEzekXsqa64kGDp7j7w1vZxhRxQUCYKvCmQAKCRDj7w1vZxhR
xdujAQD/0Kymwp3S8g4TKdrzdqH41ouOvUVLq7pZGVM7OdEHDAD9ERamwnRIoYUx
mKWf46HXJAlF1yqaZ97ea5MrcHmbowo=
=r7lJ
-----END PGP SIGNATURE-----

--wgtnyrrd22offedx--
