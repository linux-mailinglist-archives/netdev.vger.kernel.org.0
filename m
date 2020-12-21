Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E59752E0078
	for <lists+netdev@lfdr.de>; Mon, 21 Dec 2020 19:54:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726759AbgLUSwi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Dec 2020 13:52:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:52586 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725818AbgLUSwh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Dec 2020 13:52:37 -0500
Date:   Mon, 21 Dec 2020 18:51:40 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608576716;
        bh=YkdUJqE0UIpHET+IcPL1+UgnebkbGvIwmn1cUuRAHqw=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=PPuUblpLuOc1RSKrGcqCxeAYBiCDVP04QbB2xwERZ46f97Dbr4rG2NHcPg2eWhh+s
         25fc68oQk+EkXqjdRNXf8d+7OlRu8O0Ba0QIsPur/VgL0jHbF9/lljutpft9IQdqPG
         9zWT54tu8QKq3QSCLp0RfdMFSG5xj58AXFRDxyiN++cCxXswTLTbBf9rFK1RHMia1Z
         9ILGRXgag4/cVkVuIAqUcbp4Ahk9FBNyWjrQOhh8YO7oVyaNWMzigv1ZlzIqByTZ+z
         +KiIelx9q3Rrjz6T9L9whT8X1q/f4MN3iPOYx13C+wfBLu2sUzTbU/WoHXHqNiJNfF
         0o+63uGLtoe/A==
From:   Mark Brown <broonie@kernel.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        alsa-devel@alsa-project.org, Kiran Patil <kiran.patil@intel.com>,
        linux-rdma <linux-rdma@vger.kernel.org>,
        Shiraz Saleem <shiraz.saleem@intel.com>,
        Martin Habets <mhabets@solarflare.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Fred Oh <fred.oh@linux.intel.com>,
        Dave Ertman <david.m.ertman@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Leon Romanovsky <leonro@nvidia.com>,
        David Miller <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Parav Pandit <parav@mellanox.com>, lee.jones@linaro.org
Subject: Re: [resend/standalone PATCH v4] Add auxiliary bus support
Message-ID: <20201221185140.GD4521@sirena.org.uk>
References: <20201217211937.GA3177478@piout.net>
 <X9xV+8Mujo4dhfU4@kroah.com>
 <20201218131709.GA5333@sirena.org.uk>
 <20201218140854.GW552508@nvidia.com>
 <20201218155204.GC5333@sirena.org.uk>
 <20201218162817.GX552508@nvidia.com>
 <20201218180310.GD5333@sirena.org.uk>
 <20201218184150.GY552508@nvidia.com>
 <20201218203211.GE5333@sirena.org.uk>
 <20201218205856.GZ552508@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="a2FkP9tdjPU2nyhF"
Content-Disposition: inline
In-Reply-To: <20201218205856.GZ552508@nvidia.com>
X-Cookie: Remember: use logout to logout.
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--a2FkP9tdjPU2nyhF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 18, 2020 at 04:58:56PM -0400, Jason Gunthorpe wrote:
> On Fri, Dec 18, 2020 at 08:32:11PM +0000, Mark Brown wrote:
>=20
> > Historically people did try to create custom bus types, as I have
> > pointed out before there was then pushback that these were duplicating
> > the platform bus so everything uses platform bus.

> Yes, I vaugely remember..

> I don't know what to say, it seems Greg doesn't share this view of
> platform devices as a universal device.

He did at the time, he seems to have changed his mind at some point for
unclear reasons=20

> Reading between the lines, I suppose things would have been happier
> with some kind of inheritance scheme where platform device remained as
> only instantiated directly in board files, while drivers could bind to
> OF/DT/ACPI/FPGA/etc device instantiations with minimal duplication &
> boilerplate.

Like I said in my previous message that is essentially what we have now.
It's not worded in quite that way but it's how all the non-enumerable
buses work. =20

BTW I did have a bit of a scan through some of the ACPI devices and for
a good proportion of them it seems fairly clear that they are not
platform devices at all - they were mostly interacting with ACPI
firmware functionality rather than hardware, something you can't really
do with FDT at all.

> > I can't tell the difference between what it's doing and what SOF is
> > doing, the code I've seen is just looking at the system it's running
> > on and registering a fixed set of client devices.  It looks slightly
> > different because it's registering a device at a time with some wrapper
> > functions involved but that's what the code actually does.

> SOF's aux bus usage in general seems weird to me, but if you think
> it fits the mfd scheme of primarily describing HW to partition vs
> describing a SW API then maybe it should use mfd.

> The only problem with mfd as far as SOF is concerned was Greg was not
> happy when he saw PCI stuff in the MFD subsystem.

This is a huge part of the problem here - there's no clearly articulated
logic, it's all coming back to these sorts of opinion statements about
specific cases which aren't really something you can base anything on.
Personally I'm even struggling to identify a practical problem that
we're trying to solve here.  Like Alexandre says what would an
mfd_driver actually buy us?

> MFD still doesn't fit what mlx5 and others in the netdev area are
> trying to do. Though it could have been soe-horned it would have been
> really weird to create a platform device with an empty HW resource
> list. At a certain point the bus type has to mean *something*!

I have some bad news for you about the hardware description problem
space.  Among other things we have a bunch of platform devices that
don't have any resources exposed through the resource API but are still
things like chips on a board, doing some combination of exposing
resources for other devices (eg, a fixed voltage regulator) and
consuming things like clocks or GPIOs that don't appear in the resource
API.  We *could* make a new bus type and move all these things over to
that but it is not clear what the upside of doing that would be,
especially given the amount of upheval it would generate and the
classification issues that will inevitably result.

--a2FkP9tdjPU2nyhF
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAl/g7rsACgkQJNaLcl1U
h9DSKggAhfCDV1DtqQcqFWmEf71EctSZmBw/wFXh4jJLz2YiDQfdfb47IE0G77QQ
mVgjLvUJc8cnyNASB6688PiDZAs9dbuZtQXSFNHfZ9xUAlLJrBzTln5F2zIb2Al9
9KdOuFf8ba1yQbSYM0//mj9QOzGqYKijeENExwvY68n8MyZRK1OkZoY450GPkzo2
A2x7daMtTh7jXg7sSVedM2UYENxmoR9SCZLQWH7iR4rXD7sDGRR2CqT5x6Br45/3
VPJvjJAn/EkCpIj9EDwICvC5ux6aXTG9yQVB4NfiQ2V7vR5Bm0MjfgHoF3mVdOPH
p6HNRk3s5haMLHRwy/HCxJkyKJQ4qA==
=A+iW
-----END PGP SIGNATURE-----

--a2FkP9tdjPU2nyhF--
