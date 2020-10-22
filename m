Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7156629662A
	for <lists+netdev@lfdr.de>; Thu, 22 Oct 2020 22:50:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S371940AbgJVUuY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Oct 2020 16:50:24 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:53594 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S371931AbgJVUuX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Oct 2020 16:50:23 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id B536D1C0B8A; Thu, 22 Oct 2020 22:50:19 +0200 (CEST)
Date:   Thu, 22 Oct 2020 22:50:19 +0200
From:   Pavel Machek <pavel@ucw.cz>
To:     Pavel Pisa <pisa@cmp.felk.cvut.cz>
Cc:     linux-can@vger.kernel.org, devicetree@vger.kernel.org,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Wolfgang Grandegger <wg@grandegger.com>,
        David Miller <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>, mark.rutland@arm.com,
        Carsten Emde <c.emde@osadl.org>, armbru@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Marin Jerabek <martin.jerabek01@gmail.com>,
        Ondrej Ille <ondrej.ille@gmail.com>,
        Jiri Novak <jnovak@fel.cvut.cz>,
        Jaroslav Beran <jara.beran@gmail.com>,
        Petr Porazil <porazil@pikron.com>,
        Drew Fustini <pdp7pdp7@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [PATCH v6 5/6] can: ctucanfd: CTU CAN FD open-source IP core -
 platform/SoC support.
Message-ID: <20201022205019.GA17917@duo.ucw.cz>
References: <cover.1603354744.git.pisa@cmp.felk.cvut.cz>
 <2a90e1a7d57f0fec42604cd399acf25af5689148.1603354744.git.pisa@cmp.felk.cvut.cz>
 <20201022114306.GA31933@duo.ucw.cz>
 <202010221806.19253.pisa@cmp.felk.cvut.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="x+6KMIRAuhnl3hBn"
Content-Disposition: inline
In-Reply-To: <202010221806.19253.pisa@cmp.felk.cvut.cz>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--x+6KMIRAuhnl3hBn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > > +++ b/drivers/net/can/ctucanfd/Kconfig
> > > @@ -21,4 +21,15 @@ config CAN_CTUCANFD_PCI
> > >  	  PCIe board with PiKRON.com designed transceiver riser shield is
> > > available at https://gitlab.fel.cvut.cz/canbus/pcie-ctu_can_fd .
> > >
> > > +config CAN_CTUCANFD_PLATFORM
> > > +	tristate "CTU CAN-FD IP core platform (FPGA, SoC) driver"
> > > +	depends on OF || COMPILE_TEST
> > > +	help
> >
> > This is likely wrong, as it can enable config of CAN_CTUCANFD=3DM,
> > CAN_CTUCANFD_PLATFORM=3Dy, right?
>=20
> My original code has not || COMPILE_TEST alternative.
>=20
> But I have been asked to add it
>=20
> On Sunday 16 of August 2020 01:28:13 Randy Dunlap wrote:
> > Can this be
> >         depends on OF || COMPILE_TEST
> > ?
>=20
> I have send discussion later that I am not sure if it is right
> but followed suggestion. If there is no other reply now,
> I would drop || COMPILE_TEST. I believe that then it is correct
> for regular use. I ma not sure about all consequences of COMPILE_TEST
> missing.

COMPILE_TEST is not a problem. But you need to make this depend on
main CONFIG_ option to disallow CAN_CTUCANFD=3DM,
CAN_CTUCANFD_PLATFORM=3Dy combination.

> > > @@ -8,3 +8,6 @@ ctucanfd-y :=3D ctu_can_fd.o ctu_can_fd_hw.o
> > >
> > >  obj-$(CONFIG_CAN_CTUCANFD_PCI) +=3D ctucanfd_pci.o
> > >  ctucanfd_pci-y :=3D ctu_can_fd_pci.o
> > > +
> > > +obj-$(CONFIG_CAN_CTUCANFD_PLATFORM) +=3D ctucanfd_platform.o
> > > +ctucanfd_platform-y +=3D ctu_can_fd_platform.o
> >
> > Can you simply add right object files directly?
>=20
> This is more tough question. We have kept sources
> as ctu_can_fd.c, ctu_can_fd_hw.c etc. to produce
> final ctucanfd.ko which matches device tree entry etc.
> after name simplification now...
> So we move from underscores to ctucanfd on more places.
> So yes, we can rename ctu_can_fd.c to ctucanfd_drv.c + others
> keep final ctucanfd.ko and change to single file based objects
> ctucanfd_platform.c and ctucanfd_pci.c
>=20
> If you think that it worth to be redone, I would do that.
> It would disrupt sources history, may it be blames, merging
> etc... but I would invest effort into it if asked for.

git can handle renames. Or you can use the new names for module
names...?

Best regards,
							Pavel

--=20
http://www.livejournal.com/~pavelmachek

--x+6KMIRAuhnl3hBn
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCX5HwiwAKCRAw5/Bqldv6
8otNAKCRHncA0/7cMK6P5zN9pp3Zg3XgBQCbBmonFCAxsSs65RLBG4AHYrIZnbk=
=sINk
-----END PGP SIGNATURE-----

--x+6KMIRAuhnl3hBn--
