Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39A5C1AB852
	for <lists+netdev@lfdr.de>; Thu, 16 Apr 2020 08:43:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408413AbgDPGnk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Apr 2020 02:43:40 -0400
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:43551 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2408168AbgDPGnf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Apr 2020 02:43:35 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id B09DC716
        for <netdev@vger.kernel.org>; Thu, 16 Apr 2020 02:43:34 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Thu, 16 Apr 2020 02:43:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cerno.tech; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=eYZf6ks0Ag4vWkdY+FBeNSBOYxZ
        kZ9RWoI7L/wXDw/Q=; b=pG92PCpDKEaySEE6b3KK5owRlyOg6omtcBJRh6H2P9g
        A4+dSJ8ZhNWYumPEo8RSeGX3Y1ofqBKY5EwBKyaQ4uWCzw59hiXAUOxV0z1366xq
        iuHHZUldbuzXYDjsaxnBz0RsGbyN9Oo/wuSRdS/D5gtGdR/DOID4nUO++5rp07K7
        LG4gEmPTqHamlJRrP5V34H6lR2pNC4zXGMW/GSE2CyOUmLq5FhAQ7reYixyNSF9S
        Sk3l1mb29qIgPDMYY0/5m7I+DShBoF71j+C3gAVSuV2Nq12oir1/bimsDQytaFI9
        rw3mdDAsOxKY1bvJX6PjvfGpx+6c3IrKClpgJXpZ0wA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=eYZf6k
        s0Ag4vWkdY+FBeNSBOYxZkZ9RWoI7L/wXDw/Q=; b=l64IWX/+vA9VeLpOG1WZTj
        ijXTy0PKYwRcQ3emfKH8ndi4IhCr3cOvCULhf1E42CRBXKpjYi5qDcvNtB6qgGf+
        lv3nXzFTFD+OHHaD1wEnsEZwqThXxc1+YhEpR7nR350GKhV8Ag64FpjMoTuPfieQ
        RptpRB+FxDQEUPlU2ERlyzkONSFHPg2nfQrtLJtZJX5hqB32R9yC2uz0K0i4PVJk
        JjW1TJxb+0ntZ9AlrLd35o4UV3bA2pIC1p/4F8WnzbBCgWDyMFveqMBEj+Aavlzi
        7tu8vov8sxab33Sbtow1Xp/rmgo+4obBCTPSZjQ7+yshI8w+SjlTgdc+EeFzSGQg
        ==
X-ME-Sender: <xms:lv6XXilC_YkXBe8Whsvt2G22oEeAuDFQSZ3UWUNh7FSCbrDfPP1wPA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrfeeggdduudduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehgtderredttddvnecuhfhrohhmpeforgigihhm
    vgcutfhiphgrrhguuceomhgrgihimhgvsegtvghrnhhordhtvggthheqnecukfhppeeltd
    drkeelrdeikedrjeeinecuvehluhhsthgvrhfuihiivgepvdenucfrrghrrghmpehmrghi
    lhhfrhhomhepmhgrgihimhgvsegtvghrnhhordhtvggthh
X-ME-Proxy: <xmx:lv6XXs8DNqkoD8oaar1Oa6VtWtbSbtjIxDb06r-1-r0UqXRJEyp5ow>
    <xmx:lv6XXuEqgLxDNfR7AN2ETjZKblc1TySK-wXnqkVNgEpW8MrGU-fNWA>
    <xmx:lv6XXrLmph0NLlZB1jZgiUgujM5VNmiM_hVIy7JwI1EqnH7IxzlEcQ>
    <xmx:lv6XXq_chfg60EabnQfNPaCcJFdNHe1CgBQWMWOoQoLAvoxS-7erCg>
Received: from localhost (lfbn-tou-1-1502-76.w90-89.abo.wanadoo.fr [90.89.68.76])
        by mail.messagingengine.com (Postfix) with ESMTPA id D7E56306005F;
        Thu, 16 Apr 2020 02:43:33 -0400 (EDT)
Date:   Thu, 16 Apr 2020 08:43:32 +0200
From:   Maxime Ripard <maxime@cerno.tech>
To:     Rob Herring <robh@kernel.org>
Cc:     devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Stephen Boyd <sboyd@kernel.org>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Sam Ravnborg <sam@ravnborg.org>, Vinod Koul <vkoul@kernel.org>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Jonathan Cameron <jic23@kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        Pavel Machek <pavel@ucw.cz>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Lee Jones <lee.jones@linaro.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Heiko Stuebner <heiko@sntech.de>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Fabio Estevam <festevam@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-clk@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-i2c@vger.kernel.org,
        linux-hwmon@vger.kernel.org, linux-iio@vger.kernel.org,
        linux-input@vger.kernel.org, linux-leds@vger.kernel.org,
        linux-media@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-mtd@lists.infradead.org, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-gpio@vger.kernel.org, linux-pwm@vger.kernel.org,
        linux-remoteproc@vger.kernel.org, linux-riscv@lists.infradead.org,
        linux-rtc@vger.kernel.org, linux-serial@vger.kernel.org,
        alsa-devel@alsa-project.org, linux-spi@vger.kernel.org
Subject: Re: [PATCH 2/2] dt-bindings: Remove cases of 'allOf' containing a
 '$ref'
Message-ID: <20200416064332.cbtmgnbwjityninz@gilmour.lan>
References: <20200416005549.9683-1-robh@kernel.org>
 <20200416005549.9683-2-robh@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="wl56qmwukpbi7dfb"
Content-Disposition: inline
In-Reply-To: <20200416005549.9683-2-robh@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--wl56qmwukpbi7dfb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Apr 15, 2020 at 07:55:49PM -0500, Rob Herring wrote:
> json-schema versions draft7 and earlier have a weird behavior in that
> any keywords combined with a '$ref' are ignored (silently). The correct
> form was to put a '$ref' under an 'allOf'. This behavior is now changed
> in the 2019-09 json-schema spec and '$ref' can be mixed with other
> keywords. The json-schema library doesn't yet support this, but the
> tooling now does a fixup for this and either way works.
>
> This has been a constant source of review comments, so let's change this
> treewide so everyone copies the simpler syntax.
>
> Signed-off-by: Rob Herring <robh@kernel.org>

For allwinner,
Acked-by: Maxime Ripard <mripard@kernel.org>

Maxime

--wl56qmwukpbi7dfb
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRcEzekXsqa64kGDp7j7w1vZxhRxQUCXpf+lAAKCRDj7w1vZxhR
xfXZAP9GMb4mpNd2CMjZwk5BxMrLzEIpKJTiQ4orqceXOWVHrwEA79RK8mnQLFzA
6mFAQXdPtJjk58zdTQSSSDo30M+OtQk=
=foV0
-----END PGP SIGNATURE-----

--wl56qmwukpbi7dfb--
