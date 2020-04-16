Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 946FA1AB843
	for <lists+netdev@lfdr.de>; Thu, 16 Apr 2020 08:42:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408275AbgDPGmw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Apr 2020 02:42:52 -0400
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:42021 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2407813AbgDPGmr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Apr 2020 02:42:47 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id 6D75382F
        for <netdev@vger.kernel.org>; Thu, 16 Apr 2020 02:42:45 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Thu, 16 Apr 2020 02:42:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cerno.tech; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=qCRyzl00MQBivzL68vkel39NEbd
        7kC6dFuyLRxBAey0=; b=Mz6xjOhoyl6u3JLJF3XNH/WDRWC0mCT6w/uiIwB8GXd
        UpxsH9oudz3X48RMKQfGJbGVDAHug8ZXney1LdfZdZRq90LqW1W0/A6iVYMtK1mN
        EU59olTzwMNiYltMNJBPysQF0H63fbn5e/tsDm+LApzpl9Y1Sw18AZHKdzIsmaEf
        9+M1vvWOyW669ZVwQQ7awZo8Cj7vc6UYa6yBhQm8s+v3rqgHnFf6xakj6sV5HtJy
        j8vNj53XWuWvnoqroGZji7jvJbTKs9v3cgxRMfEEZdJgii7uQdjwtKHH0A6lf3I6
        8ffKsfT/ph6VFQvi+fA3JKKLi4LFnglOMoqGVSlscBQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=qCRyzl
        00MQBivzL68vkel39NEbd7kC6dFuyLRxBAey0=; b=tDpkfAjKToGh8h447tKOF2
        X2xIgDbW/MQENCQcfijaBDeF5K/urFF+R0tGVcRr9w2UCaM3LF//6wZYA3gLxs2F
        GpMtDMnjswNlZ1I/xR/jp09V08VkYewHcaTczvg9j4+5xeQsaNmx+me6Hl8RUUP3
        yoRDHF1FNxd7/1KEBjPHyCsZKU6HN6SJYjrDyiVSpkPBsO9DylyW3lE6tknrdQhK
        iiIyvjj1EAtHc7EfFU/rnrgS275sG+eJnCf3C+ZDvjNgeENDlM02/bxXHcNDQ23b
        Iu0Ywvs0blINcWXlCqYRaSiwi+51AJIhh6dg3dWC77P9lDZ8dPpmiuv1vINlnKng
        ==
X-ME-Sender: <xms:ZP6XXubrbnjaJmDSAezS58ctt5QLXiiKB16wiiRZgidQqqTsYRUGFQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrfeeggdduudduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehgtderredttddvnecuhfhrohhmpeforgigihhm
    vgcutfhiphgrrhguuceomhgrgihimhgvsegtvghrnhhordhtvggthheqnecukfhppeeltd
    drkeelrdeikedrjeeinecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghi
    lhhfrhhomhepmhgrgihimhgvsegtvghrnhhordhtvggthh
X-ME-Proxy: <xmx:ZP6XXloKWHxYHVVtgychG4-zVR4rGuvZo3AsOX95y52vtdgzm-bBdQ>
    <xmx:ZP6XXj8xbGOWEWwK16jziTD8-LvUHMqFqGXmTErw041UfL8daCHx8g>
    <xmx:ZP6XXk-bYqDqnEgl0VlPtnIwAfVzY1fE1L5l2axMcTQVVPs_tPcM1g>
    <xmx:Zf6XXrwRCa4DD8fs1yxzZL2I7hCOqk_LaiZIxH0yE-ppqefVyaQ0-A>
Received: from localhost (lfbn-tou-1-1502-76.w90-89.abo.wanadoo.fr [90.89.68.76])
        by mail.messagingengine.com (Postfix) with ESMTPA id 59AE0328005E;
        Thu, 16 Apr 2020 02:42:44 -0400 (EDT)
Date:   Thu, 16 Apr 2020 08:42:42 +0200
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
Subject: Re: [PATCH 1/2] dt-bindings: Clean-up schema indentation formatting
Message-ID: <20200416064242.azdjulo76ymwgpfq@gilmour.lan>
References: <20200416005549.9683-1-robh@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="s675c5ai5d6avmtq"
Content-Disposition: inline
In-Reply-To: <20200416005549.9683-1-robh@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--s675c5ai5d6avmtq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Apr 15, 2020 at 07:55:48PM -0500, Rob Herring wrote:
> Fix various inconsistencies in schema indentation. Most of these are
> list indentation which should be 2 spaces more than the start of the
> enclosing keyword. This doesn't matter functionally, but affects running
> scripts which do transforms on the schema files.
>
> Signed-off-by: Rob Herring <robh@kernel.org>

For allwinner,
Acked-by: Maxime Ripard <mripard@kernel.org>

Thanks!
Maxime

--s675c5ai5d6avmtq
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRcEzekXsqa64kGDp7j7w1vZxhRxQUCXpf+YgAKCRDj7w1vZxhR
xZmqAPwLCqvPnd6KBgcsRgWmwe8BxcsE0xhduyc59wNSaliiHQEAhUMizDtya0EL
yGrmpfvuS8/nRsvbMHGM2twyMWfc6QE=
=F+e6
-----END PGP SIGNATURE-----

--s675c5ai5d6avmtq--
