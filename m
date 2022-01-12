Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1916948CDFE
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 22:46:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233729AbiALVpu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 16:45:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230245AbiALVpq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 16:45:46 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2A93C06173F;
        Wed, 12 Jan 2022 13:45:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AA6BCB8211C;
        Wed, 12 Jan 2022 21:45:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6540C36AE5;
        Wed, 12 Jan 2022 21:45:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642023943;
        bh=Rl4cYWMV8h1J8XxpmCmzqZfaoBMwLhpNARBfd20DoT4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Khszb13U1jmu+m7bsIzdnnnT1iCYGXg5GGE42/oJuMQsK9Yn6UuauPQmmihxCed8g
         I1F6FNxWdahiv8HObXLZ1MgG9aNbNh1vuWd5lPBPEE8jOf+os+a0Eg3ZNc61OeDpAd
         oG1pZPxuhBAj0VIDmNNIk5GiF3ZYFM98qq+jWT/t93oYg9ih3f230JowrUn42Y60WL
         bkt6CNPh+5WsNOS7M+9MpTJWTFF/zRWDIyY+MuNMqob1T2eWMhLpwtYRPlw8g7cffu
         gO+N6rZqa7cTguyMABuPC7x4dDwKst9lAVidnA7ik+1nWq+j4fbnhftwUHOLMDmzq6
         MQ+g/36gi+i7A==
Date:   Wed, 12 Jan 2022 21:45:25 +0000
From:   Mark Brown <broonie@kernel.org>
To:     Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
        <u.kleine-koenig@pengutronix.de>
Cc:     Geert Uytterhoeven <geert@linux-m68k.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        KVM list <kvm@vger.kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>, linux-iio@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Amit Kucheria <amitk@kernel.org>,
        ALSA Development Mailing List <alsa-devel@alsa-project.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        Guenter Roeck <groeck@chromium.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        MTD Maling List <linux-mtd@lists.infradead.org>,
        Linux I2C <linux-i2c@vger.kernel.org>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        linux-phy@lists.infradead.org, netdev@vger.kernel.org,
        linux-spi <linux-spi@vger.kernel.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        openipmi-developer@lists.sourceforge.net,
        Khuong Dinh <khuong@os.amperecomputing.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
        Kamal Dasu <kdasu.kdev@gmail.com>,
        Lee Jones <lee.jones@linaro.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        bcm-kernel-feedback-list <bcm-kernel-feedback-list@broadcom.com>,
        "open list:SERIAL DRIVERS" <linux-serial@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Zhang Rui <rui.zhang@intel.com>,
        Jaroslav Kysela <perex@perex.cz>,
        Linux PWM List <linux-pwm@vger.kernel.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Robert Richter <rric@kernel.org>,
        Saravanan Sekar <sravanhome@gmail.com>,
        Corey Minyard <minyard@acm.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        John Garry <john.garry@huawei.com>,
        Peter Korsgaard <peter@korsgaard.com>,
        William Breathitt Gray <vilhelm.gray@gmail.com>,
        Mark Gross <markgross@kernel.org>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Sebastian Reichel <sre@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Takashi Iwai <tiwai@suse.com>,
        platform-driver-x86@vger.kernel.org,
        Benson Leung <bleung@chromium.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        linux-edac@vger.kernel.org, Tony Luck <tony.luck@intel.com>,
        Mun Yew Tham <mun.yew.tham@intel.com>,
        Eric Auger <eric.auger@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        Vinod Koul <vkoul@kernel.org>,
        James Morse <james.morse@arm.com>,
        Zha Qipeng <qipeng.zha@intel.com>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Richard Weinberger <richard@nod.at>,
        Niklas =?iso-8859-1?Q?S=F6derlund?= 
        <niklas.soderlund@ragnatech.se>,
        linux-mediatek@lists.infradead.org,
        Brian Norris <computersforpeace@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 1/2] platform: make platform_get_irq_optional() optional
Message-ID: <Yd9L9SZ+g13iyKab@sirena.org.uk>
References: <20220110195449.12448-1-s.shtylyov@omp.ru>
 <20220110195449.12448-2-s.shtylyov@omp.ru>
 <20220110201014.mtajyrfcfznfhyqm@pengutronix.de>
 <YdyilpjC6rtz6toJ@lunn.ch>
 <CAMuHMdWK3RKVXRzMASN4HaYfLckdS7rBvSopafq+iPADtGEUzA@mail.gmail.com>
 <20220112085009.dbasceh3obfok5dc@pengutronix.de>
 <CAMuHMdWsMGPiQaPS0-PJ_+Mc5VQ37YdLfbHr_aS40kB+SfW-aw@mail.gmail.com>
 <20220112213121.5ruae5mxwj6t3qiy@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="bKSGz4pQDpFpvPus"
Content-Disposition: inline
In-Reply-To: <20220112213121.5ruae5mxwj6t3qiy@pengutronix.de>
X-Cookie: Bridge ahead.  Pay troll.
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--bKSGz4pQDpFpvPus
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 12, 2022 at 10:31:21PM +0100, Uwe Kleine-K=F6nig wrote:
> On Wed, Jan 12, 2022 at 11:27:02AM +0100, Geert Uytterhoeven wrote:

(Do we really need *all* the CCs here?)

> That convinces me, that platform_get_irq_optional() is a bad name. The
> only difference to platform_get_irq is that it's silent. And returning
> a dummy irq value (which would make it aligned with the other _optional
> functions) isn't possible.

There is regulator_get_optional() which is I believe the earliest of
these APIs, it doesn't return a dummy either (and is silent too) - this
is because regulator_get() does return a dummy since it's the vastly
common case that regulators must be physically present and them not
being found is due to there being an error in the system description.
It's unfortunate that we've ended up with these two different senses for
_optional(), people frequently get tripped up by it.

> > To me it sounds much more logical for the driver to check if an
> > optional irq is non-zero (available) or zero (not available), than to
> > sprinkle around checks for -ENXIO. In addition, you have to remember
> > that this one returns -ENXIO, while other APIs use -ENOENT or -ENOSYS
> > (or some other error code) to indicate absence. I thought not having
> > to care about the actual error code was the main reason behind the
> > introduction of the *_optional() APIs.

> No, the main benefit of gpiod_get_optional() (and clk_get_optional()) is
> that you can handle an absent GPIO (or clk) as if it were available.

Similarly for the regulator API, kind of.

--bKSGz4pQDpFpvPus
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmHfS/QACgkQJNaLcl1U
h9BO/wf/X52fQIYQFCYJDsHS4pHQDXMDv8aCyyoEen4dO7d7t6fuflAYrOGj/MXP
UkHWhHmjH5EJrD5XQQmsOLQV5qXKD/mmvAuXQzNA/aUITdBah/r9xt3Y2nYb4+zR
Nm3ZzFmvTZVLATEdRt39LZxBwD/gCkwQpEd1tSBKsiNsq2k9eyGs6zff3Aj5xUzC
+9zfg/GCQOESdU+jRATqvdl69QGdA5N6dPgzgIQEtecGNmx02jn8bEqmaN0SX1NZ
zQXn1ChOAI4lWDhW4uAEnD4aF8hUN//xR2DiHIjNuGFgb7vTKdJgbI0iG2iH30Nm
zgsgo5YMgTHurpX6yL8pMaJC54r/Pg==
=MHmO
-----END PGP SIGNATURE-----

--bKSGz4pQDpFpvPus--
