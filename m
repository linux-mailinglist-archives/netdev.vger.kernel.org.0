Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC05542BE7F
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 13:01:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232272AbhJMLDa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 07:03:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232870AbhJMLDV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Oct 2021 07:03:21 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7DB0C0612EF
        for <netdev@vger.kernel.org>; Wed, 13 Oct 2021 04:00:33 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1mabyZ-0005e3-LW; Wed, 13 Oct 2021 12:59:11 +0200
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1mabyL-0005Lr-7I; Wed, 13 Oct 2021 12:58:57 +0200
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1mabyL-0007HS-2y; Wed, 13 Oct 2021 12:58:57 +0200
Date:   Wed, 13 Oct 2021 12:58:56 +0200
From:   Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
To:     Bjorn Helgaas <helgaas@kernel.org>
Cc:     Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        linux-pci@vger.kernel.org, Alexander Duyck <alexanderduyck@fb.com>,
        Russell Currey <ruscur@russell.cc>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        oss-drivers@corigine.com, netdev@vger.kernel.org,
        Oliver O'Halloran <oohall@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Jiri Olsa <jolsa@redhat.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Paul Mackerras <paulus@samba.org>,
        Marco Chiappero <marco.chiappero@intel.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-scsi@vger.kernel.org, Michael Ellerman <mpe@ellerman.id.au>,
        Ido Schimmel <idosch@nvidia.com>, x86@kernel.org,
        qat-linux@intel.com, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Frederic Barrat <fbarrat@linux.ibm.com>,
        Fiona Trahe <fiona.trahe@intel.com>,
        Andrew Donnellan <ajd@linux.ibm.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Jack Xu <jack.xu@intel.com>, Borislav Petkov <bp@alien8.de>,
        Michael Buesch <m@bues.ch>, Jiri Pirko <jiri@nvidia.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Juergen Gross <jgross@suse.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        xen-devel@lists.xenproject.org, Vadym Kochan <vkochan@marvell.com>,
        MPT-FusionLinux.pdl@broadcom.com, linux-usb@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Zhou Wang <wangzhou1@hisilicon.com>,
        linux-crypto@vger.kernel.org, kernel@pengutronix.de,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Simon Horman <simon.horman@corigine.com>,
        Wojciech Ziemba <wojciech.ziemba@intel.com>,
        Tomaszx Kowalik <tomaszx.kowalik@intel.com>,
        linuxppc-dev@lists.ozlabs.org,
        Taras Chornyi <tchornyi@marvell.com>,
        linux-perf-users@vger.kernel.org
Subject: Re: [PATCH v6 00/11] PCI: Drop duplicated tracking of a pci_dev's
 bound driver
Message-ID: <20211013105856.yve6n5zu625im5fo@pengutronix.de>
References: <20211013085131.5htnch5p6zv46mzn@pengutronix.de>
 <20211013105428.GA1890798@bhelgaas>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="52e44hxpwffbx22b"
Content-Disposition: inline
In-Reply-To: <20211013105428.GA1890798@bhelgaas>
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--52e44hxpwffbx22b
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello,

On Wed, Oct 13, 2021 at 05:54:28AM -0500, Bjorn Helgaas wrote:
> On Wed, Oct 13, 2021 at 10:51:31AM +0200, Uwe Kleine-K=F6nig wrote:
> > On Tue, Oct 12, 2021 at 06:32:12PM -0500, Bjorn Helgaas wrote:
> > > diff --git a/drivers/misc/cxl/guest.c b/drivers/misc/cxl/guest.c
> > > index d997c9c3ebb5..7eb3706cf42d 100644
> > > --- a/drivers/misc/cxl/guest.c
> > > +++ b/drivers/misc/cxl/guest.c
> > > @@ -20,38 +20,38 @@ static void pci_error_handlers(struct cxl_afu *af=
u,
> > >  				pci_channel_state_t state)
> > >  {
> > >  	struct pci_dev *afu_dev;
> > > +	struct pci_driver *afu_drv;
> > > +	struct pci_error_handlers *err_handler;
> >=20
> > These two could be moved into the for loop (where afu_drv was with my
> > patch already). This is also possible in a few other drivers.
>=20
> That's true, they could.  I tried to follow the prevailing style in
> the file.  At least in cxl, I didn't see any other cases of
> declarations being in the minimal scope like that.

I don't care much, do whatever you consider nice. I'm happy you liked
the cleanup and that you took it.

Best regards
Uwe

--=20
Pengutronix e.K.                           | Uwe Kleine-K=F6nig            |
Industrial Linux Solutions                 | https://www.pengutronix.de/ |

--52e44hxpwffbx22b
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEfnIqFpAYrP8+dKQLwfwUeK3K7AkFAmFmu+0ACgkQwfwUeK3K
7AnoGgf+Org0o7CctF9VMJ1cRL0/n994P0Xf4J0pVgDihRJKx2m6225saLIOfR9c
tezswS1SpHGF0jh6VVcc26om68F6diINTuhV9HjdShrJ3OqoifBqUQ+ggPRWVaT5
KB06t/1umM6bzcXmVvhwDX4+amPeFwfSPynHBfhudbA6DLwhCVuJk+109EvvuLlm
u79Qp7+p4PyMwo699ubwQFekrSsf72gzSOfuRBPqHqx0SWbSUPlUyLyolxtsUD22
7/ex/TOt2JrmP7lFEfLhrONg7BvlEBUokQ5MGQqxdyP/djPUVbtDoM3iX0kC7x2A
Fa44dFbWF/D3+K4X5Cesu+BfzXP+rA==
=xGeM
-----END PGP SIGNATURE-----

--52e44hxpwffbx22b--
