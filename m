Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E002241B793
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 21:30:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242495AbhI1TcH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 15:32:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229678AbhI1TcG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Sep 2021 15:32:06 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C8E4C06161C
        for <netdev@vger.kernel.org>; Tue, 28 Sep 2021 12:30:26 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1mVInV-0002NN-Sw; Tue, 28 Sep 2021 21:29:49 +0200
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1mVInI-0003R4-Vh; Tue, 28 Sep 2021 21:29:36 +0200
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1mVInI-00068D-TU; Tue, 28 Sep 2021 21:29:36 +0200
Date:   Tue, 28 Sep 2021 21:29:36 +0200
From:   Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
To:     Bjorn Helgaas <helgaas@kernel.org>
Cc:     Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <uwe@kleine-koenig.org>,
        Oliver O'Halloran <oohall@gmail.com>,
        Russell Currey <ruscur@russell.cc>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-pci@vger.kernel.org, Alexander Duyck <alexanderduyck@fb.com>,
        oss-drivers@corigine.com, Paul Mackerras <paulus@samba.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Michael Ellerman <mpe@ellerman.id.au>,
        =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Vadym Kochan <vkochan@marvell.com>, Michael Buesch <m@bues.ch>,
        Jiri Pirko <jiri@nvidia.com>,
        Salil Mehta <salil.mehta@huawei.com>, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Taras Chornyi <tchornyi@marvell.com>,
        Zhou Wang <wangzhou1@hisilicon.com>,
        linux-crypto@vger.kernel.org, kernel@pengutronix.de,
        Simon Horman <simon.horman@corigine.com>,
        linuxppc-dev@lists.ozlabs.org,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH v4 4/8] PCI: replace pci_dev::driver usage that gets the
 driver name
Message-ID: <20210928192936.w5umyzivi4hs6q3r@pengutronix.de>
References: <20210927204326.612555-5-uwe@kleine-koenig.org>
 <20210928171759.GA704204@bhelgaas>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="3jbimpqsr3sfse6m"
Content-Disposition: inline
In-Reply-To: <20210928171759.GA704204@bhelgaas>
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--3jbimpqsr3sfse6m
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello,

On Tue, Sep 28, 2021 at 12:17:59PM -0500, Bjorn Helgaas wrote:
> [+to Oliver, Russell for eeh_driver_name() question below]
>=20
> On Mon, Sep 27, 2021 at 10:43:22PM +0200, Uwe Kleine-K=F6nig wrote:
> > From: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>
> >=20
> > struct pci_dev::driver holds (apart from a constant offset) the same
> > data as struct pci_dev::dev->driver. With the goal to remove struct
> > pci_dev::driver to get rid of data duplication replace getting the
> > driver name by dev_driver_string() which implicitly makes use of struct
> > pci_dev::dev->driver.
>=20
> When you repost to fix the build issue, can you capitalize the subject
> line to match the other?

Yes, sure.

> Also, would you mind using "pci_dev.driver" instead of
> "pci_dev::driver"?  AFAIK, the "::" operator is not actually part of
> C, so I think it's more confusing than useful.

pci_dev.driver doesn't work either in C because pci_dev is a type and
not a variable. This is probably subjective, but for me pci_dev.driver
looks definitively stranger than pci_dev::driver. And :: is at least not
unseen in the kernel commit logs. (git log --grep=3D::)
But if you insist I can change to .

> > diff --git a/arch/powerpc/include/asm/ppc-pci.h b/arch/powerpc/include/=
asm/ppc-pci.h
> > index 2b9edbf6e929..e8f1795a2acf 100644
> > --- a/arch/powerpc/include/asm/ppc-pci.h
> > +++ b/arch/powerpc/include/asm/ppc-pci.h
> > @@ -57,7 +57,14 @@ void eeh_sysfs_remove_device(struct pci_dev *pdev);
> > =20
> >  static inline const char *eeh_driver_name(struct pci_dev *pdev)
> >  {
> > -	return (pdev && pdev->driver) ? pdev->driver->name : "<null>";
> > +	if (pdev) {
> > +		const char *drvstr =3D dev_driver_string(&pdev->dev);
> > +
> > +		if (strcmp(drvstr, ""))
> > +			return drvstr;
> > +	}
> > +
> > +	return "<null>";
>=20
> Can we just do this?
>=20
>   if (pdev)
>     return dev_driver_string(&pdev->dev);
>=20
>   return "<null>";

Works for me, too. It behaves a bit differerently than my suggestion
(which nearly behaves identical to the status quo), but only in some
degenerated cases.

> I think it's more complicated than it's worth to include a strcmp().
> It's possible this will change those error messages about "Might be
> infinite loop in %s driver", but that doesn't seem like a huge deal.
>=20
> I moved Oliver to "to:" and added Russell in case they object.
>=20
> >  }
> > =20
> >  #endif /* CONFIG_EEH */
> > diff --git a/drivers/bcma/host_pci.c b/drivers/bcma/host_pci.c
> > index 69c10a7b7c61..0973022d4b13 100644
> > --- a/drivers/bcma/host_pci.c
> > +++ b/drivers/bcma/host_pci.c
> > @@ -175,9 +175,10 @@ static int bcma_host_pci_probe(struct pci_dev *dev,
> >  	if (err)
> >  		goto err_kfree_bus;
> > =20
> > -	name =3D dev_name(&dev->dev);
> > -	if (dev->driver && dev->driver->name)
> > -		name =3D dev->driver->name;
> > +	name =3D dev_driver_string(&dev->dev);
> > +	if (!strcmp(name, ""))
> > +		name =3D dev_name(&dev->dev);
> >  	err =3D pci_request_regions(dev, name);
>=20
> Again seems more complicated than it's worth to me.  This is in the
> driver's .probe() method, so really_probe() has already set
> "dev->driver =3D drv", which means dev->driver is always set to
> &bcma_pci_bridge_driver here, and bcma_pci_bridge_driver.name is
> always "bcma-pci-bridge".
>=20
> Almost all callers of pci_request_regions() just hardcode the driver
> name or use a DRV_NAME #define
>=20
> So I think we should just do:
>=20
>   err =3D pci_request_regions(dev, "bcma-pci-bridge");

Yes, looks right. I'd put this in a separate patch.

> >  	if (err)
> >  		goto err_pci_disable;
> > [...]
> > diff --git a/drivers/ssb/pcihost_wrapper.c b/drivers/ssb/pcihost_wrappe=
r.c
> > index 410215c16920..4938ed5cfae5 100644
> > --- a/drivers/ssb/pcihost_wrapper.c
> > +++ b/drivers/ssb/pcihost_wrapper.c
> > @@ -78,9 +78,11 @@ static int ssb_pcihost_probe(struct pci_dev *dev,
> >  	err =3D pci_enable_device(dev);
> >  	if (err)
> >  		goto err_kfree_ssb;
> > -	name =3D dev_name(&dev->dev);
> > -	if (dev->driver && dev->driver->name)
> > -		name =3D dev->driver->name;
> > +
> > +	name =3D dev_driver_string(&dev->dev);
> > +	if (*name =3D=3D '\0')
> > +		name =3D dev_name(&dev->dev);
> > +
> >  	err =3D pci_request_regions(dev, name);
>=20
> Also seems like more trouble than it's worth.  This one is a little
> strange but is always called for either b43_pci_bridge_driver or
> b44_pci_driver, both of which have .name set, so I think we should
> simply do:
>=20
>   err =3D pci_request_regions(dev, dev_driver_string(&dev->dev));

yes, agreed, too.

Best regards
Uwe

--=20
Pengutronix e.K.                           | Uwe Kleine-K=F6nig            |
Industrial Linux Solutions                 | https://www.pengutronix.de/ |

--3jbimpqsr3sfse6m
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEfnIqFpAYrP8+dKQLwfwUeK3K7AkFAmFTbR0ACgkQwfwUeK3K
7AkC6Af/ZPcvEOEpmwUpNE9viOQkpwE5r7inA2n8+IzHLf0m7dP7WazFs81CvS6i
HZGQD4L2Ry5WlRHlPAXPVD6fMnoM5OT8vhqQKktvBdtYQ9wlPJlrdQHuIk9ifD/z
YfkGM/W3gd2V9nA+yxomM57MDRBHhFkjK05VcBnGFO5hXGIyV3gSS/RgIWKPGXuW
mYyO5SgEEQrK5uOf8gnokzmOE5aHgYZ9bhMUZKk01a1d5vI44/QZf1cLlrHRyamS
3jeLoyS7nE9+wcMnKG67Qir5YuB99CLu21yGHqDMOQLzZ9FNjVUO682GRS/gnblZ
IJlg24PzVAR9Feb4374crlRgTrq3+w==
=LLP8
-----END PGP SIGNATURE-----

--3jbimpqsr3sfse6m--
