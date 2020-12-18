Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D72422DE8B2
	for <lists+netdev@lfdr.de>; Fri, 18 Dec 2020 19:06:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728326AbgLRSEG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Dec 2020 13:04:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:47408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725766AbgLRSEG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Dec 2020 13:04:06 -0500
Date:   Fri, 18 Dec 2020 18:03:10 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608314605;
        bh=FkUoSS1XA/fvcfYoGeT7JpiQyIA2Fo3T+sJ2XEZSLaw=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=vBlfg0MwKW270LXGfrZkKmF/HDxuLBQ3qvI+ZLjeS0L/BqO/maY80b990QQIyWH3x
         GAGvZgjDLAggmWs7x9ExGnAACvu0jyphastaI5fxVpno8mdKP4wk0jHWYOTmbEjjDu
         e7L+AAfqxItRHVuyllwhleMlWSnYKJRG2zV4/Mz0ixnfVuzEIz6zGV2OWykCzsCFTc
         IyEcBvmsfCxIWuWxhR9f5z2nmFkwQakYggOhoRhNFhm1S529GZY2dfL62VeZmfe89M
         d4KuFB3bYT21V9m2KOQYGX/SPMHUwOc5cJD/fasUASfO83K+X7oaIv2bd1P38hiX06
         xl7PQzyddmU/g==
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
Message-ID: <20201218180310.GD5333@sirena.org.uk>
References: <160695681289.505290.8978295443574440604.stgit@dwillia2-desk3.amr.corp.intel.com>
 <X8ogtmrm7tOzZo+N@kroah.com>
 <CAPcyv4iLG7V9JT34La5PYfyM9378acbLnkShx=6pOmpPK7yg3A@mail.gmail.com>
 <X8usiKhLCU3PGL9J@kroah.com>
 <20201217211937.GA3177478@piout.net>
 <X9xV+8Mujo4dhfU4@kroah.com>
 <20201218131709.GA5333@sirena.org.uk>
 <20201218140854.GW552508@nvidia.com>
 <20201218155204.GC5333@sirena.org.uk>
 <20201218162817.GX552508@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="gE7i1rD7pdK0Ng3j"
Content-Disposition: inline
In-Reply-To: <20201218162817.GX552508@nvidia.com>
X-Cookie: Password:
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--gE7i1rD7pdK0Ng3j
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 18, 2020 at 12:28:17PM -0400, Jason Gunthorpe wrote:
> On Fri, Dec 18, 2020 at 03:52:04PM +0000, Mark Brown wrote:
> > On Fri, Dec 18, 2020 at 10:08:54AM -0400, Jason Gunthorpe wrote:

> > > I thought the recent LWN article summed it up nicely, auxillary bus is
> > > for gluing to subsystems together using a driver specific software API
> > > to connect to the HW, MFD is for splitting a physical HW into disjoint
> > > regions of HW.

> > This conflicts with the statements from Greg about not using the
> > platform bus for things that aren't memory mapped or "direct firmware",
> > a large proportion of MFD subfunctions are neither at least in so far as
> > I can understand what direct firmware means.

> I assume MFD will keep existing and it will somehow stop using
> platform device for the children it builds.

If it's not supposed to use platform devices so I'm assuming that the
intention is that it should use aux devices, otherwise presumably it'd
be making some new clone of the platform bus but I've not seen anyone
suggesting this.

> That doesn't mean MFD must use aux device, so I don't see what you
> mean by conflicts?

I was excluding the possibility that we have to make a third bus which
clones platform bus which nobody has been visibly suggesting.

> If someone has a PCI device and they want to split it up, they should
> choose between aux device and MFD (assuming MFD gets fixed, as Greg
> has basically blanket NAK'd adding more of them to MFD as is)

It is unclear to me how one is intended to choose between these
approaches, especially for systems that have a range of subdevices with
a range of characteristics.

> > To be honest I don't find the LWN article clarifies things particularly
> > here, the rationale appears to involve some misconceptions about what
> > MFDs look like.  It looks like it assumes that MFD functions have
> > physically separate register sets for example which is not a reliable
> > feature of MFDs, nor is the assumption that there's no shared
> > functionality which appears to be there.  It also appears to assume that

> I think the MFD cell model is probably the deciding feature. If that
> cell description scheme suites the device, and it is very HW focused,
> then MFD is probably the answer.

> The places I see aux device being used are a terrible fit for the cell
> idea. If there are MFD drivers that are awkardly crammed into that
> cell description then maybe they should be aux devices?

When you say the MFD cell model it's not clear what you mean - I *think*
you're referring to the idea of the subdevices getting all the
information they need to talk to the hardware from the device resources.
That's actually relatively uncommon with I2C/SPI MFDs, usually there's
at least some element of just knowing what's going on and the mfd_cells
are to some extent just a list of things to register rather than a model
of anything.

Look at something like wm8994 for example - the subdevices just know
which addresses in the device I2C/SPI regmap to work with but some of
them have interrupts passed through to them (and could potentially also
have separate subdevices for clocks and pinctrl).  These subdevices are
not memory mapped, not enumerated by firmware and the hardware has
indistinct separation of functions in the register map compared to how
Linux models the chips.

> > > Maybe there is some overlap, but if you want to add HW representations
> > > to the general auxillary device then I think you are using it for the
> > > wrong thing.

> > Even for the narrowest use case for auxiliary devices that I can think
> > of I think the assumption that nobody will ever design something which
> > can wire an interrupt intended to be serviced by a subfunction is a bit
> > optimistic. =20

> mlx5, for example, uses interrupts but an aux device is not assigned
> an exclusive MSI interrupt list.

> These devices have a very dynamic interrupt scheme, pre-partitioning
> the MSI vector table is completely the wrong API.

I'm not saying dynamic interrupt schemes or event queues from firmware
can't exist, I'm saying not all interrupt schemes are dynamic.

--gE7i1rD7pdK0Ng3j
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAl/c7t4ACgkQJNaLcl1U
h9DZ9ggAhWS2GLzG19WitcNZFN865NLdPy+QPB5dNfJqSEWdIANmNlivsdyHbIae
pMP4f/TZReaOIA0LD4bUZuAoDdQobMvxI7Mg1Y7qg1wy5+SA2dGRJYUsYCNaGQs+
clPY3qNsHgcmbUNVbbZjSpxY3sLSpStsSeQb22JGqc9438HQ26c8xAj7/wbiUyjU
N8PozJPh+++afQFAP+hgWux0THNNrDTKlAZMZOD7AL1o/2M4Z2EHx5Lu3/XXJXaO
ihRdaMWFrQ9p7vCoZkutTw8wnoMhqxnST4EP1ZejtWNQZcXqf5wdTm/hDBTzgKmx
fe4rfElBhVvfORw9UTYh3Bjkit+xNQ==
=Im3G
-----END PGP SIGNATURE-----

--gE7i1rD7pdK0Ng3j--
