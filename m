Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D4334033DB
	for <lists+netdev@lfdr.de>; Wed,  8 Sep 2021 07:35:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344569AbhIHFgl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Sep 2021 01:36:41 -0400
Received: from wnew3-smtp.messagingengine.com ([64.147.123.17]:36739 "EHLO
        wnew3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234655AbhIHFgk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Sep 2021 01:36:40 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.west.internal (Postfix) with ESMTP id 53E722B00211;
        Wed,  8 Sep 2021 01:35:31 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Wed, 08 Sep 2021 01:35:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cerno.tech; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=GMMTgRFqoDWXrlsxTrcsveKldCO
        7Mc0t0dXFf3Rc3U4=; b=O/Db1L6fnLndSCQj7k2aLqShkJ/VlsBKvKJxE6D9aCE
        cezsm1nPQMCBTUGQDREIXtMAhuZ0ufn6z1zqIVnqwLiJrhXTjvz0QYgbb2Oo4SSa
        PH4izzLG2Xq0H8OrG+EtTqWuBpEkqCmKFxpEcxwBaZdQ/FaYbwHp4D2TSnu3GRZl
        VOQ3s2XmQ799fKMwEheIrPFLQyJucR8PCAZ92oje0buBJHVf8PrRnWNuqmyx8Xmn
        BkT1r3/HFKt/I38kPbupVF4vBNJUsYWr+lU27f0/SkHH/sgCiAiMlYS3UrmCCTtq
        F8hHYmaaIArEy19IDAsD0Ys+D3GwTiwdaIWEyax1VCw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=GMMTgR
        FqoDWXrlsxTrcsveKldCO7Mc0t0dXFf3Rc3U4=; b=Zw0okaIuvQg6L27q0/g0O9
        4usEwjINfX35xsw6/1YEsLLwkh7DDXmJAiix01Mht849vxaQFyyQW5Tl/q4PR0SD
        5K7JimbyHzxRYyWK6iffNMZjvVY90ogwIdFQeto3pz1Ou0PnIcxMBSKXgD2zUtKs
        zLyt/pYr8p7GyetchZwJSCgtzHs/z0M//2JEquHBjtqAwevnU8KacxF2GkVFaRjp
        jLztHMU5w2Ed+KPnCqVwMeQCXb41w7pkbCuAhZ2QO1tUm5m9MbgHsEmAml83B5EK
        WK1buTm1KoG5Sgr/pwnEdzJMpOJqThaXoD20UNwVtZK08O2nqFzF4BLj+odgorqw
        ==
X-ME-Sender: <xms:oks4YSvI5jmbp7jiaSR06ZOdjWhsytNr6U2hpxqChQfYs61uDTUniA>
    <xme:oks4YXf4sxiwkmNvjVdSd5zr3oe0InsigaWB-U5-dpBsvwzNDWOAhKdJlnkk9uzuf
    _7w-BmfBe6Oqop7FV4>
X-ME-Received: <xmr:oks4YdwM8GyvndKnn0TT7xOIZjR_eMT5NRkhynIdzjV8mZEe2cy9qa5XwaZXXXaURAVoCR1l78FPZ5qtgnWi992OSisZttjutuk8>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrudefiedgleegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehgtderredttddvnecuhfhrohhmpeforgigihhm
    vgcutfhiphgrrhguuceomhgrgihimhgvsegtvghrnhhordhtvggthheqnecuggftrfgrth
    htvghrnhepleekgeehhfdutdeljefgleejffehfffgieejhffgueefhfdtveetgeehieeh
    gedunecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepmh
    grgihimhgvsegtvghrnhhordhtvggthh
X-ME-Proxy: <xmx:oks4YdONdvU54Byu9PvijwK2-p7IT6kiY1sSaEJCbNQNdMScTWflrw>
    <xmx:oks4YS-5rfsO0TvWOZVxeTMX6uHV1wa0ou4KrgvnnNej5zEYPIqNXw>
    <xmx:oks4YVWvkjey5J8TF-dBXjaUH3SQ_tv2fns8fyyf2LqLVihPvlsVkQ>
    <xmx:oks4YVbJ5sC-PhJd23yCHOIWr1whksTz9nSP9-OyB4EqwFLHXbfJXloRDNU>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 8 Sep 2021 01:35:29 -0400 (EDT)
Date:   Wed, 8 Sep 2021 07:35:27 +0200
From:   Maxime Ripard <maxime@cerno.tech>
To:     Samuel Holland <samuel@sholland.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Chen-Yu Tsai <wens@csie.org>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Guo Ren <guoren@kernel.org>, devicetree@vger.kernel.org,
        netdev@vger.kernel.org, linux-sunxi@lists.linux.dev,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dt-bindings: net: sun8i-emac: Add compatible for D1
Message-ID: <20210908053527.fzoa3b4bfr4uo6tb@gilmour>
References: <20210908030240.9007-1-samuel@sholland.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="ik7vtjftu7yl4fsr"
Content-Disposition: inline
In-Reply-To: <20210908030240.9007-1-samuel@sholland.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--ik7vtjftu7yl4fsr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 07, 2021 at 10:02:40PM -0500, Samuel Holland wrote:
> The D1 SoC contains EMAC hardware which is compatible with the A64 EMAC.
> Add the new compatible string, with the A64 as a fallback.
>=20
> Signed-off-by: Samuel Holland <samuel@sholland.org>

Acked-by: Maxime Ripard <maxime@cerno.tech>

Maxime

--ik7vtjftu7yl4fsr
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRcEzekXsqa64kGDp7j7w1vZxhRxQUCYThLmgAKCRDj7w1vZxhR
xTgxAPoCxJsim0qsvjpeCUFgsfq8yKZtsvaz5Y3r3YaCL/RBBAD/RDXUQbq/mjBe
KZGg3exMO76p7nDt3qWta29TvBYiPwA=
=gFwk
-----END PGP SIGNATURE-----

--ik7vtjftu7yl4fsr--
