Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0694E1E1EF5
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 11:45:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731820AbgEZJpW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 05:45:22 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:55976 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728686AbgEZJpW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 May 2020 05:45:22 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 791CE1C02C0; Tue, 26 May 2020 11:45:19 +0200 (CEST)
Date:   Tue, 26 May 2020 11:45:18 +0200
From:   Pavel Machek <pavel@denx.de>
To:     "Rafael J. Wysocki" <rafael@kernel.org>
Cc:     Krzysztof =?utf-8?Q?Wilczy=C5=84ski?= <kw@linux.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <lenb@kernel.org>, Kevin Hilman <khilman@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Johan Hovold <johan@kernel.org>, Alex Elder <elder@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Felipe Balbi <balbi@kernel.org>,
        Julian Wiedmann <jwi@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        John Stultz <john.stultz@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        greybus-dev@lists.linaro.org, netdev <netdev@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>,
        Linux PM <linux-pm@vger.kernel.org>,
        linux-s390@vger.kernel.org,
        "open list:TARGET SUBSYSTEM" <linux-scsi@vger.kernel.org>,
        "open list:ULTRA-WIDEBAND (UWB) SUBSYSTEM:" 
        <linux-usb@vger.kernel.org>
Subject: Re: [PATCH 2/8] ACPI: PM: Use the new device_to_pm() helper to
 access struct dev_pm_ops
Message-ID: <20200526094518.GA4600@amd>
References: <20200525182608.1823735-1-kw@linux.com>
 <20200525182608.1823735-3-kw@linux.com>
 <CAJZ5v0jQUmdDYmJsP43Ja3urpVLUxe-yD_Hm_Jd2LtCoPiXsrQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="bg08WKrSYDhXBjb5"
Content-Disposition: inline
In-Reply-To: <CAJZ5v0jQUmdDYmJsP43Ja3urpVLUxe-yD_Hm_Jd2LtCoPiXsrQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--bg08WKrSYDhXBjb5
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue 2020-05-26 10:37:36, Rafael J. Wysocki wrote:
> On Mon, May 25, 2020 at 8:26 PM Krzysztof Wilczy=C5=84ski <kw@linux.com> =
wrote:
> >
> > Use the new device_to_pm() helper to access Power Management callbacs
> > (struct dev_pm_ops) for a particular device (struct device_driver).
> >
> > No functional change intended.
> >
> > Signed-off-by: Krzysztof Wilczy=C5=84ski <kw@linux.com>
> > ---
> >  drivers/acpi/device_pm.c | 5 +++--
> >  1 file changed, 3 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/acpi/device_pm.c b/drivers/acpi/device_pm.c
> > index 5832bc10aca8..b98a32c48fbe 100644
> > --- a/drivers/acpi/device_pm.c
> > +++ b/drivers/acpi/device_pm.c
> > @@ -1022,9 +1022,10 @@ static bool acpi_dev_needs_resume(struct device =
*dev, struct acpi_device *adev)
> >  int acpi_subsys_prepare(struct device *dev)
> >  {
> >         struct acpi_device *adev =3D ACPI_COMPANION(dev);
> > +       const struct dev_pm_ops *pm =3D driver_to_pm(dev->driver);
>=20
> I don't really see a reason for this change.
>=20
> What's wrong with the check below?

Duplicated code. Yes, compiler can sort it out, but... new version
looks better to me.

Best regards,
								pavel

> >
> > -       if (dev->driver && dev->driver->pm && dev->driver->pm->prepare)=
 {
> > -               int ret =3D dev->driver->pm->prepare(dev);
> > +       if (pm && pm->prepare) {
> > +               int ret =3D pm->prepare(dev);



--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--bg08WKrSYDhXBjb5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl7M5S0ACgkQMOfwapXb+vJLqgCcCbDmh7NooqBM+qslb58avjsp
78cAn1mUUlj/BAfzgJELHWPID2a0mmvg
=+Cmh
-----END PGP SIGNATURE-----

--bg08WKrSYDhXBjb5--
