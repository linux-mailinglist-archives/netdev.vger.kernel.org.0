Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24E39278892
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 14:57:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729516AbgIYM4R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 08:56:17 -0400
Received: from mx2.suse.de ([195.135.220.15]:50524 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728968AbgIYM4P (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Sep 2020 08:56:15 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 0AB59AB9F;
        Fri, 25 Sep 2020 12:56:13 +0000 (UTC)
Date:   Fri, 25 Sep 2020 14:56:08 +0200
From:   Petr Tesarik <ptesarik@suse.cz>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        netdev@vger.kernel.org
Subject: Re: RTL8402 stops working after hibernate/resume
Message-ID: <20200925145608.66a89e73@ezekiel.suse.cz>
In-Reply-To: <20200925115241.3709caf6@ezekiel.suse.cz>
References: <20200715102820.7207f2f8@ezekiel.suse.cz>
        <d742082e-42a1-d904-8a8f-4583944e88e1@gmail.com>
        <20200716105835.32852035@ezekiel.suse.cz>
        <e1c7a37f-d8d0-a773-925c-987b92f12694@gmail.com>
        <20200903104122.1e90e03c@ezekiel.suse.cz>
        <7e6bbb75-d8db-280d-ac5b-86013af39071@gmail.com>
        <20200924211444.3ba3874b@ezekiel.suse.cz>
        <a10f658b-7fdf-2789-070a-83ad5549191a@gmail.com>
        <20200925093037.0fac65b7@ezekiel.suse.cz>
        <20200925105455.50d4d1cc@ezekiel.suse.cz>
        <aa997635-a5b5-75e3-8a30-a77acb2adf35@gmail.com>
        <20200925115241.3709caf6@ezekiel.suse.cz>
Organization: SUSE Linux, s.r.o.
X-Mailer: Claws Mail 3.17.6 (GTK+ 2.24.32; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/b8LGBPor=EJGIBwVHH63w9T";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/b8LGBPor=EJGIBwVHH63w9T
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 25 Sep 2020 11:52:41 +0200
Petr Tesarik <ptesarik@suse.cz> wrote:

> On Fri, 25 Sep 2020 11:44:09 +0200
> Heiner Kallweit <hkallweit1@gmail.com> wrote:
>=20
> > On 25.09.2020 10:54, Petr Tesarik wrote: =20
>[...]
> > > Does it make sense to bisect the change that broke the driver for me,=
 or should I rather dispose of this waste^Wlaptop in an environmentally fri=
endly manner? I mean, would you eventually accept a workaround for a few ma=
chines with a broken BIOS?
> > >    =20
> > If the workaround is small and there's little chance to break other stu=
ff: then usually yes.
> > If you can spend the effort to bisect the issue, this would be apprecia=
ted. =20
>=20
> OK, then I'm going to give it a try.

Done. The system freezes when this commit is applied:

commit 9f0b54cd167219266bd3864570ae8f4987b57520
Author: Heiner Kallweit <hkallweit1@gmail.com>
Date:   Wed Jun 17 22:55:40 2020 +0200

    r8169: move switching optional clock on/off to pll power functions
   =20
    Relevant chip clocks are disabled in rtl_pll_power_down(), therefore
    move calling clk_disable_unprepare() there. Similar for enabling the
    clock.
   =20
    Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
    Signed-off-by: David S. Miller <davem@davemloft.net>

I cannot be sure this is related to the malfunction after resume reported e=
arlier, but it again touches the suspend/resume path...

Anything else I should try?

Petr T

--Sig_/b8LGBPor=EJGIBwVHH63w9T
Content-Type: application/pgp-signature
Content-Description: Digitální podpis OpenPGP

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEHl2YIZkIo5VO2MxYqlA7ya4PR6cFAl9t6OgACgkQqlA7ya4P
R6f6Jwf+OYYjG9d0GqcIPETy5IMvFCl47Tnl61MWxOR58sGTaPo6RRZuisVR/bDQ
NwmDp86CQsFATRftz+BWyxjU751zlpW7EIGvFWAGQ5hi/pbF3Pac+FRH87T3fMJC
/0g1Cznz6E/c9zlt98MYyVjmyrEAwWvdAddWNdtYFaGt0gWSwFWitCN7Bhc5DTlw
tmaPJ6TjFKs8FhVKZXAurVy0MjWRn2T5ER9VeaCA163DlJyIm3hxDYynaIuSaLqP
pXYNrXjxvhJmej9jCnaiR0NRje9nd1XhOEelM0PX+1adZG/SQMKqJ+E1KlMx4Opp
3l1DBFb4/cRRtIVSmDJUiXAvu6y0OQ==
=gefK
-----END PGP SIGNATURE-----

--Sig_/b8LGBPor=EJGIBwVHH63w9T--
