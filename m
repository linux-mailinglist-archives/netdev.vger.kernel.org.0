Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA4F13DC5DF
	for <lists+netdev@lfdr.de>; Sat, 31 Jul 2021 14:10:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232905AbhGaMKY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Jul 2021 08:10:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233002AbhGaMKX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 31 Jul 2021 08:10:23 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF6CBC0613D5
        for <netdev@vger.kernel.org>; Sat, 31 Jul 2021 05:10:16 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1m9nnU-0007Ot-05; Sat, 31 Jul 2021 14:08:56 +0200
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1m9nnD-0007eB-Mm; Sat, 31 Jul 2021 14:08:39 +0200
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1m9nnD-0001LE-Jt; Sat, 31 Jul 2021 14:08:39 +0200
Date:   Sat, 31 Jul 2021 14:08:36 +0200
From:   Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
To:     Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc:     Bjorn Helgaas <bhelgaas@google.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-pci@vger.kernel.org, Alexander Duyck <alexanderduyck@fb.com>,
        Russell Currey <ruscur@russell.cc>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        oss-drivers@corigine.com, Oliver O'Halloran <oohall@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Jiri Olsa <jolsa@redhat.com>,
        linux-perf-users@vger.kernel.org,
        Stefano Stabellini <sstabellini@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-scsi@vger.kernel.org, Michael Ellerman <mpe@ellerman.id.au>,
        Ido Schimmel <idosch@nvidia.com>, x86@kernel.org,
        qat-linux@intel.com,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-wireless@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Fiona Trahe <fiona.trahe@intel.com>,
        Andrew Donnellan <ajd@linux.ibm.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        Simon Horman <simon.horman@corigine.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Michael Buesch <m@bues.ch>,
        Jiri Pirko <jiri@nvidia.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andy Shevchenko <andriy.shevchenko@intel.com>,
        Juergen Gross <jgross@suse.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        xen-devel@lists.xenproject.org, Vadym Kochan <vkochan@marvell.com>,
        MPT-FusionLinux.pdl@broadcom.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org,
        Wojciech Ziemba <wojciech.ziemba@intel.com>,
        linux-kernel@vger.kernel.org, Taras Chornyi <tchornyi@marvell.com>,
        Zhou Wang <wangzhou1@hisilicon.com>,
        linux-crypto@vger.kernel.org, kernel@pengutronix.de,
        netdev@vger.kernel.org, Frederic Barrat <fbarrat@linux.ibm.com>,
        Paul Mackerras <paulus@samba.org>,
        linuxppc-dev@lists.ozlabs.org,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH v1 4/5] PCI: Adapt all code locations to not use struct
 pci_dev::driver directly
Message-ID: <20210731120836.vegno6voijvlflws@pengutronix.de>
References: <20210729203740.1377045-1-u.kleine-koenig@pengutronix.de>
 <20210729203740.1377045-5-u.kleine-koenig@pengutronix.de>
 <2b5e8cb5-fac2-5da2-f87b-d287d2c5ea81@oracle.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="rawlqk3jhoxts24y"
Content-Disposition: inline
In-Reply-To: <2b5e8cb5-fac2-5da2-f87b-d287d2c5ea81@oracle.com>
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--rawlqk3jhoxts24y
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello Boris,

On Fri, Jul 30, 2021 at 04:37:31PM -0400, Boris Ostrovsky wrote:
> On 7/29/21 4:37 PM, Uwe Kleine-K=F6nig wrote:
> > --- a/drivers/pci/xen-pcifront.c
> > +++ b/drivers/pci/xen-pcifront.c
> > @@ -599,12 +599,12 @@ static pci_ers_result_t pcifront_common_process(i=
nt cmd,
> >  	result =3D PCI_ERS_RESULT_NONE;
> > =20
> >  	pcidev =3D pci_get_domain_bus_and_slot(domain, bus, devfn);
> > -	if (!pcidev || !pcidev->driver) {
> > +	pdrv =3D pci_driver_of_dev(pcidev);
> > +	if (!pcidev || !pdrv) {
>=20
> If pcidev is NULL we are dead by the time we reach 'if' statement.

Oh, you're right. So this needs something like:

	if (!pcidev || !(pdrv =3D pci_driver_of_dev(pcidev)))

or repeating the call to pci_driver_of_dev for each previous usage of
pdev->driver.

If there are no other preferences I'd got with the first approach for
v2.

Best regards and thanks for catching,
Uwe

--=20
Pengutronix e.K.                           | Uwe Kleine-K=F6nig            |
Industrial Linux Solutions                 | https://www.pengutronix.de/ |

--rawlqk3jhoxts24y
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEfnIqFpAYrP8+dKQLwfwUeK3K7AkFAmEFPUEACgkQwfwUeK3K
7AlQoAgAidQUuX/L2YhXMvP0F+SSjym4ILhKdbRYnWojo/QbFUE8WbOQueAZA76q
NW0vq2X07i0bUwTfbZoOgqSFvMfXJiETcN9R48epPUGWS2IT17NE8EgtH+/srht0
sGGI7bia2a1L++nruccUllCf1qMfngKRQUhatVOPYqIs2dX3ijjjpSAxHh8L+gjC
nOMgWu7lZm7QQawBjQGfirpYGBUFdAh3odwm/JHN7+cZKC6dbhLYGm2WS8db1bCI
4k4EO2RpSeuZb9XaFPq9DEWy1exgtgjnmKt3Szrp31/xWizjhMEOrZVWfWD1bjUa
rWcmnDR4bm4Fz/MdVFhjJq2XJQoIDw==
=2o5y
-----END PGP SIGNATURE-----

--rawlqk3jhoxts24y--
