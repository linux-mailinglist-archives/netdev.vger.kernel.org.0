Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 474254B42AA
	for <lists+netdev@lfdr.de>; Mon, 14 Feb 2022 08:19:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241300AbiBNHQA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Feb 2022 02:16:00 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:35416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241273AbiBNHPx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Feb 2022 02:15:53 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7785D58E4D
        for <netdev@vger.kernel.org>; Sun, 13 Feb 2022 23:15:45 -0800 (PST)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1nJVZ0-0006l6-Nq; Mon, 14 Feb 2022 08:14:22 +0100
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1nJVYf-00GV12-4n; Mon, 14 Feb 2022 08:14:00 +0100
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1nJVYd-002oWn-E1; Mon, 14 Feb 2022 08:13:59 +0100
Date:   Mon, 14 Feb 2022 08:13:51 +0100
From:   Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
To:     Sergey Shtylyov <s.shtylyov@omp.ru>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        linux-kernel@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Jiri Slaby <jirislaby@kernel.org>, linux-iio@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Amit Kucheria <amitk@kernel.org>, alsa-devel@alsa-project.org,
        Liam Girdwood <lgirdwood@gmail.com>,
        linux-phy@lists.infradead.org,
        Thierry Reding <thierry.reding@gmail.com>,
        linux-mtd@lists.infradead.org, linux-i2c@vger.kernel.org,
        linux-gpio@vger.kernel.org,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Guenter Roeck <groeck@chromium.org>, linux-spi@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        openipmi-developer@lists.sourceforge.net,
        Peter Korsgaard <peter@korsgaard.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
        kvm@vger.kernel.org, Kamal Dasu <kdasu.kdev@gmail.com>,
        Richard Weinberger <richard@nod.at>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        bcm-kernel-feedback-list@broadcom.com,
        linux-serial@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Zhang Rui <rui.zhang@intel.com>,
        Jaroslav Kysela <perex@perex.cz>,
        platform-driver-x86@vger.kernel.org, linux-pwm@vger.kernel.org,
        Zha Qipeng <qipeng.zha@intel.com>,
        Corey Minyard <minyard@acm.org>, linux-pm@vger.kernel.org,
        John Garry <john.garry@huawei.com>,
        William Breathitt Gray <vilhelm.gray@gmail.com>,
        Mark Gross <markgross@kernel.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Mark Brown <broonie@kernel.org>,
        linux-mediatek@lists.infradead.org,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Takashi Iwai <tiwai@suse.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Benson Leung <bleung@chromium.org>,
        linux-arm-kernel@lists.infradead.org,
        Mun Yew Tham <mun.yew.tham@intel.com>,
        Eric Auger <eric.auger@redhat.com>, netdev@vger.kernel.org,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Cornelia Huck <cohuck@redhat.com>, linux-mmc@vger.kernel.org,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        linux-renesas-soc@vger.kernel.org, Vinod Koul <vkoul@kernel.org>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Niklas =?utf-8?Q?S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>,
        Brian Norris <computersforpeace@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH v2 1/2] platform: make platform_get_irq_optional()
 optional
Message-ID: <20220214071351.pcvstrzkwqyrg536@pengutronix.de>
References: <20220212201631.12648-1-s.shtylyov@omp.ru>
 <20220212201631.12648-2-s.shtylyov@omp.ru>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="r3c6abkz2rpak4yl"
Content-Disposition: inline
In-Reply-To: <20220212201631.12648-2-s.shtylyov@omp.ru>
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


--r3c6abkz2rpak4yl
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Feb 12, 2022 at 11:16:30PM +0300, Sergey Shtylyov wrote:
> This patch is based on the former Andy Shevchenko's patch:
>=20
> https://lore.kernel.org/lkml/20210331144526.19439-1-andriy.shevchenko@lin=
ux.intel.com/
>=20
> Currently platform_get_irq_optional() returns an error code even if IRQ
> resource simply has not been found.  It prevents the callers from being
> error code agnostic in their error handling:
>=20
> 	ret =3D platform_get_irq_optional(...);
> 	if (ret < 0 && ret !=3D -ENXIO)
> 		return ret; // respect deferred probe
> 	if (ret > 0)
> 		...we get an IRQ...
>=20
> All other *_optional() APIs seem to return 0 or NULL in case an optional
> resource is not available.  Let's follow this good example, so that the
> callers would look like:
>=20
> 	ret =3D platform_get_irq_optional(...);
> 	if (ret < 0)
> 		return ret;
> 	if (ret > 0)
> 		...we get an IRQ...
>=20
> Reported-by: Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
> Signed-off-by: Sergey Shtylyov <s.shtylyov@omp.ru>

While this patch is better than v1, I still don't like it for the
reasons discussed for v1. (i.e. 0 isn't usable as a dummy value which I
consider the real advantage for the other _get_optional() functions.)

Apart from that, I think the subject is badly chosen. With "Make
somefunc() optional" I would expect that you introduce a Kconfig symbol
that results in the function not being available when disabled.

Best regards
Uwe

--=20
Pengutronix e.K.                           | Uwe Kleine-K=F6nig            |
Industrial Linux Solutions                 | https://www.pengutronix.de/ |

--r3c6abkz2rpak4yl
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEfnIqFpAYrP8+dKQLwfwUeK3K7AkFAmIKASwACgkQwfwUeK3K
7Ak1DAf/fgLBIz9p8Vx2hzG+I8aYoNMAmPLmUfMeIR1DWaBc26HTbyTBn6pFRiPZ
rztM2uc+royoY44/mp4H89WkPzZ0/v3AlRkdqI8UBny0ZKRbNtMfzL6f7wyVik5C
rxqc7EgXLRk2/0IxTohA6bwj7Vczei9NwYndm+QrxDHjmY5Dq95rdvxv9+8iaa9y
gLQ2x91x4bybaKnKVe36f5JfLeMhS9kLuCx82Wi1yqPK4UQQ6R/+QEE0zGS8QNHP
vMasmLHge9XqVx/c0SuPcLVZ/uRatkzzuqf1rY75peyQp4YpDDdkhkTws4kcVC22
lVFz9FjvbtVS4nxvPxNwZAnvq9sPaQ==
=UfDO
-----END PGP SIGNATURE-----

--r3c6abkz2rpak4yl--
