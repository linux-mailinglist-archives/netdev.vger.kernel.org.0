Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9833D42BAF5
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 10:53:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238963AbhJMIz2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 04:55:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238891AbhJMIz1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Oct 2021 04:55:27 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25B89C061714
        for <netdev@vger.kernel.org>; Wed, 13 Oct 2021 01:53:24 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1maZzE-0007An-3c; Wed, 13 Oct 2021 10:51:44 +0200
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1maZz1-0005Il-VI; Wed, 13 Oct 2021 10:51:31 +0200
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1maZz1-0006zY-R9; Wed, 13 Oct 2021 10:51:31 +0200
Date:   Wed, 13 Oct 2021 10:51:31 +0200
From:   Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
To:     Bjorn Helgaas <helgaas@kernel.org>
Cc:     Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        linux-pci@vger.kernel.org, Alexander Duyck <alexanderduyck@fb.com>,
        Russell Currey <ruscur@russell.cc>, x86@kernel.org,
        qat-linux@intel.com, oss-drivers@corigine.com,
        Oliver O'Halloran <oohall@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Jiri Olsa <jolsa@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Marco Chiappero <marco.chiappero@intel.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-scsi@vger.kernel.org, Michael Ellerman <mpe@ellerman.id.au>,
        =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-wireless@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        Fiona Trahe <fiona.trahe@intel.com>,
        Andrew Donnellan <ajd@linux.ibm.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Simon Horman <simon.horman@corigine.com>,
        linuxppc-dev@lists.ozlabs.org,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Jack Xu <jack.xu@intel.com>, Borislav Petkov <bp@alien8.de>,
        Michael Buesch <m@bues.ch>, Jiri Pirko <jiri@nvidia.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Juergen Gross <jgross@suse.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        xen-devel@lists.xenproject.org, Vadym Kochan <vkochan@marvell.com>,
        MPT-FusionLinux.pdl@broadcom.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org,
        Wojciech Ziemba <wojciech.ziemba@intel.com>,
        linux-kernel@vger.kernel.org,
        Mathias Nyman <mathias.nyman@intel.com>,
        Zhou Wang <wangzhou1@hisilicon.com>,
        linux-crypto@vger.kernel.org, kernel@pengutronix.de,
        netdev@vger.kernel.org, Frederic Barrat <fbarrat@linux.ibm.com>,
        Paul Mackerras <paulus@samba.org>,
        Tomaszx Kowalik <tomaszx.kowalik@intel.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-perf-users@vger.kernel.org
Subject: Re: [PATCH v6 00/11] PCI: Drop duplicated tracking of a pci_dev's
 bound driver
Message-ID: <20211013085131.5htnch5p6zv46mzn@pengutronix.de>
References: <20211004125935.2300113-1-u.kleine-koenig@pengutronix.de>
 <20211012233212.GA1806189@bhelgaas>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="jgo3ssjhgqy54b4n"
Content-Disposition: inline
In-Reply-To: <20211012233212.GA1806189@bhelgaas>
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--jgo3ssjhgqy54b4n
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 12, 2021 at 06:32:12PM -0500, Bjorn Helgaas wrote:
> On Mon, Oct 04, 2021 at 02:59:24PM +0200, Uwe Kleine-K=F6nig wrote:
> > Hello,
> >=20
> > this is v6 of the quest to drop the "driver" member from struct pci_dev
> > which tracks the same data (apart from a constant offset) as dev.driver.
>=20
> I like this a lot and applied it to pci/driver for v5.16, thanks!
>=20
> I split some of the bigger patches apart so they only touched one
> driver or subsystem at a time.  I also updated to_pci_driver() so it
> returns NULL when given NULL, which makes some of the validations
> quite a bit simpler, especially in the PM code in pci-driver.c.

OK.

> Full interdiff from this v6 series:
>=20
> diff --git a/arch/x86/kernel/probe_roms.c b/arch/x86/kernel/probe_roms.c
> index deaaef6efe34..36e84d904260 100644
> --- a/arch/x86/kernel/probe_roms.c
> +++ b/arch/x86/kernel/probe_roms.c
> @@ -80,17 +80,15 @@ static struct resource video_rom_resource =3D {
>   */
>  static bool match_id(struct pci_dev *pdev, unsigned short vendor, unsign=
ed short device)
>  {
> +	struct pci_driver *drv =3D to_pci_driver(pdev->dev.driver);
>  	const struct pci_device_id *id;
> =20
>  	if (pdev->vendor =3D=3D vendor && pdev->device =3D=3D device)
>  		return true;
> =20
> -	if (pdev->dev.driver) {
> -		struct pci_driver *drv =3D to_pci_driver(pdev->dev.driver);
> -		for (id =3D drv->id_table; id && id->vendor; id++)
> -			if (id->vendor =3D=3D vendor && id->device =3D=3D device)
> -				break;
> -	}
> +	for (id =3D drv ? drv->id_table : NULL; id && id->vendor; id++)
> +		if (id->vendor =3D=3D vendor && id->device =3D=3D device)
> +			break;
> =20
>  	return id && id->vendor;
>  }
> diff --git a/drivers/misc/cxl/guest.c b/drivers/misc/cxl/guest.c
> index d997c9c3ebb5..7eb3706cf42d 100644
> --- a/drivers/misc/cxl/guest.c
> +++ b/drivers/misc/cxl/guest.c
> @@ -20,38 +20,38 @@ static void pci_error_handlers(struct cxl_afu *afu,
>  				pci_channel_state_t state)
>  {
>  	struct pci_dev *afu_dev;
> +	struct pci_driver *afu_drv;
> +	struct pci_error_handlers *err_handler;

These two could be moved into the for loop (where afu_drv was with my
patch already). This is also possible in a few other drivers.

Best regards
Uwe

--=20
Pengutronix e.K.                           | Uwe Kleine-K=F6nig            |
Industrial Linux Solutions                 | https://www.pengutronix.de/ |

--jgo3ssjhgqy54b4n
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEfnIqFpAYrP8+dKQLwfwUeK3K7AkFAmFmng8ACgkQwfwUeK3K
7AmPuQgAk6Dld3vvwdriW0ibspNDJTGfUcre3doNKax+JiXCiHbUthkO3jZ7kx1f
rTKn9F/GlIOEH1uZZZPonJEaOLwVQmJz3OF8+BKCx7g1+0AqtNe2WefCf4Jl6ajR
fuBtbNjjaCmBXFqToERlpAsB8kRfNy8Y5V7a/XqiX7ZDLiXle3V2AbuQVi5Ikmhp
S72E0TV74YTVv77LeVSAA8275wN0GVI3gVT9F7w9ja0BjrapAALEVsk/s9pAl3Zq
j9D63evuObSQ8ILnNmMOldPueBNZBIGCrXPD/EWKYWXjfstcmZUQtQqvyF6lK9ww
AubKoQZ72JnZiuJZzVyJCsmBBRo2Vw==
=Gp6y
-----END PGP SIGNATURE-----

--jgo3ssjhgqy54b4n--
