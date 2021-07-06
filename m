Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 326753BDD44
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 20:33:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231435AbhGFSfF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 14:35:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231371AbhGFSfE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Jul 2021 14:35:04 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BF6EC06175F
        for <netdev@vger.kernel.org>; Tue,  6 Jul 2021 11:32:26 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1m0prl-0007tU-Bf; Tue, 06 Jul 2021 20:32:17 +0200
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1m0prk-0001yr-79; Tue, 06 Jul 2021 20:32:16 +0200
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1m0prk-0004ND-2r; Tue, 06 Jul 2021 20:32:16 +0200
Date:   Tue, 6 Jul 2021 20:32:15 +0200
From:   Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     nvdimm@lists.linux.dev, Alexey Kardashevskiy <aik@ozlabs.ru>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Samuel Iglesias Gonsalvez <siglesias@igalia.com>,
        Jens Taprogge <jens.taprogge@taprogge.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Jaroslav Kysela <perex@perex.cz>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Mike Christie <michael.christie@oracle.com>,
        Wei Liu <wei.liu@kernel.org>,
        Maxim Levitsky <maximlevitsky@gmail.com>,
        Samuel Holland <samuel@sholland.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        linux-acpi@vger.kernel.org, linux-pci@vger.kernel.org,
        xen-devel@lists.xenproject.org,
        Tomas Winkler <tomas.winkler@intel.com>,
        Julien Grall <jgrall@amazon.com>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Alex Elder <elder@kernel.org>, linux-parisc@vger.kernel.org,
        Geoff Levand <geoff@infradead.org>, linux-fpga@vger.kernel.org,
        linux-usb@vger.kernel.org, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        linux-kernel@vger.kernel.org, linux-spi@vger.kernel.org,
        Thorsten Scherer <t.scherer@eckelmann.de>,
        kernel@pengutronix.de, Jon Mason <jdmason@kudzu.us>,
        linux-ntb@googlegroups.com, Wu Hao <hao.wu@intel.com>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Krzysztof =?utf-8?Q?Wilczy=C5=84ski?= <kw@linux.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Manohar Vanga <manohar.vanga@gmail.com>,
        linux-wireless@vger.kernel.org,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        virtualization@lists.linux-foundation.org,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        target-devel@vger.kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        linux-i2c@vger.kernel.org,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Ira Weiny <ira.weiny@intel.com>, Helge Deller <deller@gmx.de>,
        =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        industrypack-devel@lists.sourceforge.net,
        linux-mips@vger.kernel.org, Len Brown <lenb@kernel.org>,
        alsa-devel@alsa-project.org, linux-arm-msm@vger.kernel.org,
        linux-media@vger.kernel.org, Maxime Ripard <mripard@kernel.org>,
        Johan Hovold <johan@kernel.org>, greybus-dev@lists.linaro.org,
        Bjorn Helgaas <bhelgaas@google.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-arm-kernel@lists.infradead.org,
        Johannes Thumshirn <morbidrsa@gmail.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Stephen Boyd <sboyd@kernel.org>,
        Cornelia Huck <cohuck@redhat.com>,
        Wolfram Sang <wsa@kernel.org>,
        Joey Pabalan <jpabalanb@gmail.com>,
        Yehezkel Bernat <YehezkelShB@gmail.com>,
        Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>,
        Bodo Stroesser <bostroesser@gmail.com>,
        Alison Schofield <alison.schofield@intel.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Tyrel Datwyler <tyreld@linux.ibm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Tom Rix <trix@redhat.com>, Jason Wang <jasowang@redhat.com>,
        SeongJae Park <sjpark@amazon.de>, linux-hyperv@vger.kernel.org,
        platform-driver-x86@vger.kernel.org, Frank Li <lznuaa@gmail.com>,
        netdev@vger.kernel.org, Qinglang Miao <miaoqinglang@huawei.com>,
        Jiri Slaby <jirislaby@kernel.org>,
        Rob Herring <robh@kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Mark Gross <mgross@linux.intel.com>,
        linux-staging@lists.linux.dev, Dexuan Cui <decui@microsoft.com>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Chen-Yu Tsai <wens@csie.org>, linux-input@vger.kernel.org,
        Matt Porter <mporter@kernel.crashing.org>,
        Allen Hubbe <allenbh@gmail.com>, Alex Dubov <oakad@yahoo.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Jiri Kosina <jikos@kernel.org>,
        Vladimir Zapolskiy <vz@mleia.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Ben Widawsky <ben.widawsky@intel.com>,
        Moritz Fischer <mdf@kernel.org>, linux-cxl@vger.kernel.org,
        Michael Buesch <m@bues.ch>,
        Dan Williams <dan.j.williams@intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Cristian Marussi <cristian.marussi@arm.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Martyn Welch <martyn@welchs.me.uk>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-mmc@vger.kernel.org, linux-sunxi@lists.linux.dev,
        Stefan Richter <stefanr@s5r6.in-berlin.de>,
        Sudeep Holla <sudeep.holla@arm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sven Van Asbroeck <TheSven73@gmail.com>, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        linux-remoteproc@vger.kernel.org,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Andreas Noever <andreas.noever@gmail.com>,
        linux-i3c@lists.infradead.org,
        linux1394-devel@lists.sourceforge.net,
        Lee Jones <lee.jones@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, linux-scsi@vger.kernel.org,
        Vishal Verma <vishal.l.verma@intel.com>,
        Russell King <linux@armlinux.org.uk>,
        Andy Gross <agross@kernel.org>, linux-serial@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Michael Jamet <michael.jamet@intel.com>,
        William Breathitt Gray <vilhelm.gray@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Hannes Reinecke <hare@suse.de>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Juergen Gross <jgross@suse.com>, linuxppc-dev@lists.ozlabs.org,
        Takashi Iwai <tiwai@suse.com>,
        Alexandre Bounine <alex.bou9@gmail.com>,
        Vinod Koul <vkoul@kernel.org>, Mark Brown <broonie@kernel.org>,
        Marc Zyngier <maz@kernel.org>, dmaengine@vger.kernel.org,
        Johannes Berg <johannes@sipsolutions.net>,
        Johannes Thumshirn <jth@kernel.org>,
        Maximilian Luz <luzmaximilian@gmail.com>
Subject: Re: [PATCH v2 4/4] bus: Make remove callback return void
Message-ID: <20210706183215.tcd7i4pwz2gxtxtb@pengutronix.de>
References: <20210706154803.1631813-1-u.kleine-koenig@pengutronix.de>
 <20210706154803.1631813-5-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="q2vlxiybuwkj6z7s"
Content-Disposition: inline
In-Reply-To: <20210706154803.1631813-5-u.kleine-koenig@pengutronix.de>
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--q2vlxiybuwkj6z7s
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello,

v1 was acked by some more after I stopped looking in my mailbox while
preparing v2:

On Tue, Jul 06, 2021 at 05:48:03PM +0200, Uwe Kleine-K=F6nig wrote:
> The driver core ignores the return value of this callback because there
> is only little it can do when a device disappears.
>=20
> This is the final bit of a long lasting cleanup quest where several
> buses were converted to also return void from their remove callback.
> Additionally some resource leaks were fixed that were caused by drivers
> returning an error code in the expectation that the driver won't go
> away.
>=20
> With struct bus_type::remove returning void it's prevented that newly
> implemented buses return an ignored error code and so don't anticipate
> wrong expectations for driver authors.
>=20
> Acked-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk> (For ARM, Am=
ba and related parts)
> Acked-by: Mark Brown <broonie@kernel.org>
> Acked-by: Chen-Yu Tsai <wens@csie.org> (for drivers/bus/sunxi-rsb.c)
> Acked-by: Pali Roh=E1r <pali@kernel.org>
> Acked-by: Mauro Carvalho Chehab <mchehab@kernel.org> (for drivers/media)
> Acked-by: Hans de Goede <hdegoede@redhat.com> (For drivers/platform)
> Acked-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
> Acked-By: Vinod Koul <vkoul@kernel.org>
> Acked-by: Juergen Gross <jgross@suse.com> (For Xen)
> Acked-by: Lee Jones <lee.jones@linaro.org> (For drivers/mfd)
> Acked-by: Johannes Thumshirn <jth@kernel.org> (For drivers/mcb)
> Acked-by: Johan Hovold <johan@kernel.org>
> Acked-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org> (For drive=
rs/slimbus)
> Acked-by: Kirti Wankhede <kwankhede@nvidia.com> (For drivers/vfio)
> Acked-by: Maximilian Luz <luzmaximilian@gmail.com>
> Acked-by: Heikki Krogerus <heikki.krogerus@linux.intel.com> (For ulpi and=
 typec)
> Acked-by: Samuel Iglesias Gons=E1lvez <siglesias@igalia.com> (For ipack)
> Reviewed-by: Tom Rix <trix@redhat.com> (For fpga)
> Acked-by: Geoff Levand <geoff@infradead.org> (For ps3)

Acked-by: Yehezkel Bernat <YehezkelShB@gmail.com> (For thunderbolt)
Reviewed-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Acked-by: Alexander Shishkin <alexander.shishkin@linux.intel.com> (For inte=
l_th)
Acked-by: Dominik Brodowski <linux@dominikbrodowski.net> (For pcmcia)

> Signed-off-by: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>

Best regards
Uwe

--=20
Pengutronix e.K.                           | Uwe Kleine-K=F6nig            |
Industrial Linux Solutions                 | https://www.pengutronix.de/ |

--q2vlxiybuwkj6z7s
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEfnIqFpAYrP8+dKQLwfwUeK3K7AkFAmDkoawACgkQwfwUeK3K
7AkRFgf/Qj+Sw4DQa5XQzuIke1atkI5Z9SH6bby9lfgLCjU/9fFWokjZXUFUlHEd
p6KCgzwG5JD4RoIVKyntr/S7rR3FlCH5aMtgDi4xzKWybmOwAdP5XCSzU6ois1Cd
G76Gg954N8CBAyFE6c0p18Fu1R1fscGQQDIF6yrUJ6p9WbpckBTw8xuX/AOicKcu
r9s0okuUVqJmb0eM1Io+LGgjIvSLaUPl2lFnllwI6ztli3Wwo3NhHhy0iFZN9q1n
IAXVYkylaIeq6hoC+Fo0NN0/ZNZRsV+s2qlzlaQkj8zQmyYqfN369rEDpTajwdlU
JoOxFMsceOjeYMAEfCEfUeEBRom3lw==
=mbzo
-----END PGP SIGNATURE-----

--q2vlxiybuwkj6z7s--
