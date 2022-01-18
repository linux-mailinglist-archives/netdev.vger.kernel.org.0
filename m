Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C5C249227B
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 10:19:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345554AbiARJTG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jan 2022 04:19:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345549AbiARJTE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jan 2022 04:19:04 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A536DC06173E
        for <netdev@vger.kernel.org>; Tue, 18 Jan 2022 01:19:03 -0800 (PST)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1n9kdD-0006Nd-T3; Tue, 18 Jan 2022 10:18:23 +0100
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1n9kdA-00Ayd5-Tc; Tue, 18 Jan 2022 10:18:20 +0100
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1n9kd9-0003a7-SE; Tue, 18 Jan 2022 10:18:19 +0100
Date:   Tue, 18 Jan 2022 10:18:19 +0100
From:   Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Andrew Lunn <andrew@lunn.ch>, Ulf Hansson <ulf.hansson@linaro.org>,
        Vignesh Raghavendra <vigneshr@ti.com>, kvm@vger.kernel.org,
        "Rafael J. Wysocki" <rafael@kernel.org>, linux-iio@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Amit Kucheria <amitk@kernel.org>, alsa-devel@alsa-project.org,
        Liam Girdwood <lgirdwood@gmail.com>,
        Guenter Roeck <groeck@chromium.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        linux-mtd@lists.infradead.org, linux-i2c@vger.kernel.org,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        linux-phy@lists.infradead.org, Lee Jones <lee.jones@linaro.org>,
        Khuong Dinh <khuong@os.amperecomputing.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        Kamal Dasu <kdasu.kdev@gmail.com>,
        Jiri Slaby <jirislaby@kernel.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Tony Luck <tony.luck@intel.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        bcm-kernel-feedback-list@broadcom.com,
        linux-serial@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Zhang Rui <rui.zhang@intel.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        platform-driver-x86@vger.kernel.org, linux-pwm@vger.kernel.org,
        Robert Richter <rric@kernel.org>,
        Saravanan Sekar <sravanhome@gmail.com>,
        Corey Minyard <minyard@acm.org>, linux-pm@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        John Garry <john.garry@huawei.com>,
        Peter Korsgaard <peter@korsgaard.com>,
        William Breathitt Gray <vilhelm.gray@gmail.com>,
        Mark Gross <markgross@kernel.org>, linux-gpio@vger.kernel.org,
        Alex Williamson <alex.williamson@redhat.com>,
        Mark Brown <broonie@kernel.org>,
        Borislav Petkov <bp@alien8.de>,
        Eric Auger <eric.auger@redhat.com>,
        Takashi Iwai <tiwai@suse.com>,
        Jaroslav Kysela <perex@perex.cz>,
        openipmi-developer@lists.sourceforge.net,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Benson Leung <bleung@chromium.org>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        linux-arm-kernel@lists.infradead.org, linux-edac@vger.kernel.org,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        Richard Weinberger <richard@nod.at>,
        Mun Yew Tham <mun.yew.tham@intel.com>,
        Hans de Goede <hdegoede@redhat.com>, netdev@vger.kernel.org,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Cornelia Huck <cohuck@redhat.com>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-spi@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, Vinod Koul <vkoul@kernel.org>,
        James Morse <james.morse@arm.com>,
        Zha Qipeng <qipeng.zha@intel.com>,
        Sebastian Reichel <sre@kernel.org>,
        Niklas =?utf-8?Q?S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>,
        linux-mediatek@lists.infradead.org,
        Brian Norris <computersforpeace@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 1/2] platform: make platform_get_irq_optional() optional
 (summary)
Message-ID: <20220118091819.zzxpffrxbckoxiys@pengutronix.de>
References: <20220110195449.12448-1-s.shtylyov@omp.ru>
 <20220110195449.12448-2-s.shtylyov@omp.ru>
 <20220115183643.6zxalxqxrhkfgdfq@pengutronix.de>
 <YeQpWu2sUVOSaT9I@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="4nmi7jsy4ulpuolr"
Content-Disposition: inline
In-Reply-To: <YeQpWu2sUVOSaT9I@kroah.com>
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--4nmi7jsy4ulpuolr
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Jan 16, 2022 at 03:19:06PM +0100, Greg Kroah-Hartman wrote:
> On Sat, Jan 15, 2022 at 07:36:43PM +0100, Uwe Kleine-K=F6nig wrote:
> > A possible compromise: We can have both. We rename
> > platform_get_irq_optional() to platform_get_irq_silent() (or
> > platform_get_irq_silently() if this is preferred) and once all users are
> > are changed (which can be done mechanically), we reintroduce a
> > platform_get_irq_optional() with Sergey's suggested semantic (i.e.
> > return 0 on not-found, no error message printking).
>=20
> Please do not do that as anyone trying to forward-port an old driver
> will miss the abi change of functionality and get confused.  Make
> build-breaking changes, if the way a function currently works is
> changed in order to give people a chance.

Fine for me. I assume this is a Nack for Sergey's patch?

Best regards
Uwe

--=20
Pengutronix e.K.                           | Uwe Kleine-K=F6nig            |
Industrial Linux Solutions                 | https://www.pengutronix.de/ |

--4nmi7jsy4ulpuolr
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEfnIqFpAYrP8+dKQLwfwUeK3K7AkFAmHmhdgACgkQwfwUeK3K
7AlOfwf/RajwcOGZOaXu4/Hu0uIDDH01Izth3e7+cbt0DvzofBxZhrwLi6+7R8Ii
FDvio63jvvz41IZoKpB3Sp3cJe6N5nHxfoeVbVFx1oDC5ZSb3xpzIKBpz6usYWSK
mpEzG1FLl/zHhNcFBvzOrkoJNhHOKKqTkCMQ9+SMFB2QpzY2GlhGyeloYsR5wRlS
36dfdheA3MnzMe+YgqcykvdU78oW4Ajcnq+31xfkY4u4FtLXz44Pz4j32buAaqtw
/Ryrr0NnSSAdwMkNMebBf3XX8emOhXd3w/ActLJA50YN3K1ePF1ViBaNwB6wIGGA
DmnwP6lCav2JoRm3yOWVlcLDeltVJA==
=IrhS
-----END PGP SIGNATURE-----

--4nmi7jsy4ulpuolr--
