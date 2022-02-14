Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12FD24B529D
	for <lists+netdev@lfdr.de>; Mon, 14 Feb 2022 15:02:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354832AbiBNOCJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Feb 2022 09:02:09 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354863AbiBNOCI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Feb 2022 09:02:08 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B438949FA2
        for <netdev@vger.kernel.org>; Mon, 14 Feb 2022 06:01:59 -0800 (PST)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1nJbu2-0007Aw-Jd; Mon, 14 Feb 2022 15:00:30 +0100
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1nJbu1-00GYgZ-R1; Mon, 14 Feb 2022 15:00:29 +0100
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1nJbu0-0038OM-4h; Mon, 14 Feb 2022 15:00:28 +0100
Date:   Mon, 14 Feb 2022 15:00:27 +0100
From:   Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     Andrew Lunn <andrew@lunn.ch>, Ulf Hansson <ulf.hansson@linaro.org>,
        Vignesh Raghavendra <vigneshr@ti.com>, kvm@vger.kernel.org,
        "Rafael J. Wysocki" <rafael@kernel.org>, linux-iio@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Amit Kucheria <amitk@kernel.org>, alsa-devel@alsa-project.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Guenter Roeck <groeck@chromium.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        linux-mtd@lists.infradead.org, linux-i2c@vger.kernel.org,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        linux-phy@lists.infradead.org,
        Oleksij Rempel <linux@rempel-privat.de>,
        Lee Jones <lee.jones@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Peter Korsgaard <peter@korsgaard.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        Kamal Dasu <kdasu.kdev@gmail.com>,
        Jiri Slaby <jirislaby@kernel.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        bcm-kernel-feedback-list@broadcom.com,
        linux-serial@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Zhang Rui <rui.zhang@intel.com>,
        platform-driver-x86@vger.kernel.org, linux-pwm@vger.kernel.org,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Corey Minyard <minyard@acm.org>, linux-pm@vger.kernel.org,
        John Garry <john.garry@huawei.com>,
        William Breathitt Gray <vilhelm.gray@gmail.com>,
        Mark Gross <markgross@kernel.org>, linux-gpio@vger.kernel.org,
        Alex Williamson <alex.williamson@redhat.com>,
        Mark Brown <broonie@kernel.org>,
        linux-mediatek@lists.infradead.org,
        Eric Auger <eric.auger@redhat.com>,
        Takashi Iwai <tiwai@suse.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        openipmi-developer@lists.sourceforge.net,
        Jaroslav Kysela <perex@perex.cz>,
        Benson Leung <bleung@chromium.org>,
        linux-arm-kernel@lists.infradead.org,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        Mun Yew Tham <mun.yew.tham@intel.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Cornelia Huck <cohuck@redhat.com>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-spi@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, Vinod Koul <vkoul@kernel.org>,
        Zha Qipeng <qipeng.zha@intel.com>,
        Richard Weinberger <richard@nod.at>,
        Niklas =?utf-8?Q?S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>,
        Brian Norris <computersforpeace@gmail.com>,
        netdev@vger.kernel.org
Subject: Re: [PATCH v2 1/2] platform: make platform_get_irq_optional()
 optional
Message-ID: <20220214140027.npw6ddrxklarb6wp@pengutronix.de>
References: <20220212201631.12648-1-s.shtylyov@omp.ru>
 <20220212201631.12648-2-s.shtylyov@omp.ru>
 <20220214071351.pcvstrzkwqyrg536@pengutronix.de>
 <CAMuHMdWi8gno_FBbc=AwsdRtDJik8_bANjQrrRtUOOBRjFN=KA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="mxy3a336cmbyaspi"
Content-Disposition: inline
In-Reply-To: <CAMuHMdWi8gno_FBbc=AwsdRtDJik8_bANjQrrRtUOOBRjFN=KA@mail.gmail.com>
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--mxy3a336cmbyaspi
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello Geert,

On Mon, Feb 14, 2022 at 10:01:14AM +0100, Geert Uytterhoeven wrote:
> Also IMHO, the dummy value handling is a red herring.  Contrary to
> optional clocks and resets, a missing optional interrupt does not
> always mean there is nothing to do: in case of polling, something
> else must definitely be done.=20

Note this is exactly why I don't like this change. I'd even go so far
and claim that "a missing optional interrupt hardly ever means there is
nothing to do".

> So even if request_irq() would accept a dummy interrupt zero and just
> do nothing, it would give the false impression that that is all there
> is to do, while an actual check for zero with polling code handling
> may still need to be present, thus leading to more not less bugs.

Yes, a dummy irq value will just not be possible.

Best regards
Uwe

--=20
Pengutronix e.K.                           | Uwe Kleine-K=F6nig            |
Industrial Linux Solutions                 | https://www.pengutronix.de/ |

--mxy3a336cmbyaspi
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEfnIqFpAYrP8+dKQLwfwUeK3K7AkFAmIKYHgACgkQwfwUeK3K
7AkfUwf+PjHT71nPQKjE5hOrUJs08gV3dPyFE+Lky6h3jHjtzp+VwX3waHB3n4Iy
r1fdR+06wiK9BWaTD2PdT8FdEYo9n0yQlTx+03PQXtLFnutK7QSb0fBMQs7sVAfa
nxp4CK8a1wlf0mzj1zSaeiGm6BYTsoJxoblrZ8hWbpbiVfhF6Eo5zXr0toHMI0WF
QOhqgWNpQjHlpU+2paIvbOnBpNxJaXj3cycd6036NHAFQvZN5xrDdqHa+By0jeU0
bm8NmjRjwHCqvhBpRYUglt+KhyRYWWTC/83WFKviLwnPV7tnkh5ZhJE50aUUp1Lr
hyNbZjQKG8NIOTLNKMgY4nM0uni8jg==
=vr2/
-----END PGP SIGNATURE-----

--mxy3a336cmbyaspi--
