Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BAF32DE3E9
	for <lists+netdev@lfdr.de>; Fri, 18 Dec 2020 15:21:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727874AbgLROVF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Dec 2020 09:21:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:56124 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727404AbgLROVE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Dec 2020 09:21:04 -0500
Date:   Fri, 18 Dec 2020 14:20:09 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608301223;
        bh=Twtxz3CdLx+TMONIubg7E6ojPF7qRVa0EUIUWEAZg2Y=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=lqR2VgQmrIuYy0qdUnNvVSdt+33BYqPw/41xKPo1cyRqzCvQXlJ/JtodgYR7ircIL
         8nRUeE+1kQOYWlil+nxLXQXcV8JU6V0aGGvCaTI4l+ueNJJgFsIYmxV0fgw0MfuL2N
         rMEw8iiY5v6Z/k+FmYGdJrqSQQs5WZwNFBcFa7T4rOJ6cM5roMaQ8gOtq79Vh8hmu2
         5csun4QlvrYTAcbQori5UZ7EZfAlsVEeN+rdisvB4v4gVsHSfuinNCams2Yk3+oNrx
         IlwJPsCsxv/cNb936aK1/TU5jIPUHStg4Q3S0x83xQMsWpSOB/cdJuyjpDgdK+xjpv
         /fVYRQT0J6DpQ==
From:   Mark Brown <broonie@kernel.org>
To:     Dan Williams <dan.j.williams@intel.com>
Cc:     Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        alsa-devel@alsa-project.org, Kiran Patil <kiran.patil@intel.com>,
        linux-rdma <linux-rdma@vger.kernel.org>,
        Shiraz Saleem <shiraz.saleem@intel.com>,
        Martin Habets <mhabets@solarflare.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Fred Oh <fred.oh@linux.intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Dave Ertman <david.m.ertman@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Leon Romanovsky <leonro@nvidia.com>,
        David Miller <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Parav Pandit <parav@mellanox.com>, lee.jones@linaro.org
Subject: Re: [resend/standalone PATCH v4] Add auxiliary bus support
Message-ID: <20201218142009.GB5333@sirena.org.uk>
References: <160695681289.505290.8978295443574440604.stgit@dwillia2-desk3.amr.corp.intel.com>
 <X8ogtmrm7tOzZo+N@kroah.com>
 <CAPcyv4iLG7V9JT34La5PYfyM9378acbLnkShx=6pOmpPK7yg3A@mail.gmail.com>
 <X8usiKhLCU3PGL9J@kroah.com>
 <20201217211937.GA3177478@piout.net>
 <CAPcyv4h-jg0dxKZ89yYnHsTEDj7jLWDBhBVTgEC77tLLsz92pw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="IiVenqGWf+H9Y6IX"
Content-Disposition: inline
In-Reply-To: <CAPcyv4h-jg0dxKZ89yYnHsTEDj7jLWDBhBVTgEC77tLLsz92pw@mail.gmail.com>
X-Cookie: Password:
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--IiVenqGWf+H9Y6IX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 17, 2020 at 06:39:55PM -0800, Dan Williams wrote:

> There is room for documentation improvement here. I realize reading it
> back now that much of the justification for "why not platform bus?"
> happened on the list, but only a small mention made it into the

It wasn't clear from the list discussions either TBH, or at least the
bits I happened to see (I did miss several versions of this).

> document. It turns out that platform-bus has some special integrations
> and hacks with platform-firmware implementations. For example, the
> ACPI companion magic

Could you be more specific about the problems that these cause for users
of the bus?

>                      and specific platform firmware integrations in
> platform_match(). It's also an awkward bus name to use because these

Going through a bunch of possible firmware interfaces is standard for
buses that can't be enumerated, SPI has almost exactly the same code for
example.  Again, I'm not clear what problem this causes?

> devices do not belong to the platform. The platform bus is for devices
> that do not have an enumeration mechanism besides board files or
> firmware descriptions.

This is the one thing I was getting from what I did see, it was an
abstraction thing.  I'm still unclear what the abstraction is supposed
to be - I had thought that it was supposed to be purely for MMIO devices
but in a parallel reply Greg is suggesting that it applies to at least
"firmware direct" devices which I guess is things enumerated by board
files or firmware but that makes things even less clear for me as it's
kind of random if people try to describe the internals of devices in DT
or not, and ACPI goes the other way and doesn't really describe some
things that physically exist.

> > We already have a bunch of drivers in tree that have to share a state
> > and register other drivers from other subsystems for the same device.
> > How is the auxiliary bus different?
>=20
> There's also custom subsystem buses that do this. Why not other
> alternatives? They didn't capture the simultaneous mindshare of RDMA,
> SOF, and NETDEV developers. Personally my plans for using

At least in the case of SOF they were getting active pushback from
somewhere telling them not to use MFD.

> auxiliary-bus do not map cleanly to anything else in the tree. I want
> to use it for attaching an NPEM driver (Native PCIE Enclosure
> Management) to any PCI device driver that opts-in, but it would be
> overkill to go create an "npem" bus for this.

This is why everyone is using platform devices here - people were making
custom buses but people (including Greg!) pointed out that these were
just carbon copies of the platform bus.

--IiVenqGWf+H9Y6IX
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAl/cupgACgkQJNaLcl1U
h9D+3Af/cJECsvChdGecO5/0wRbeZDfopKmuaCEBnnT9BfHNPXohXL5Vf/tnSgr1
+EXf6ehtmxNg/UlEs2l4uqVHQyZ3g8zDX1M1zynfBfHtyLSm5wlW30hxtsPhyeMt
+VqcRxwWqUC2jLzBD5Aob+3AF5UYnZhh4kqkZ4Ow2UxTcXlDJ5GUn40UvaOkF8Tq
uzilWabfZOPRyqwVYQ/s4oRqa9NlokjAWkiLOEChZtA9vOsZ0Gpfm+HLC4EC0ajI
Eu6rfbm5s1YD7zqC2nSaG8ALGMDg/yjrc9aVVM5+nf3vJns3z6U0ityhhR6EaCi1
9dcy2WqWnZC2M2OdkAaaW4Q27F5tOQ==
=h7cR
-----END PGP SIGNATURE-----

--IiVenqGWf+H9Y6IX--
