Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 430CDCC6FB
	for <lists+netdev@lfdr.de>; Sat,  5 Oct 2019 02:47:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730770AbfJEAqS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Oct 2019 20:46:18 -0400
Received: from mga18.intel.com ([134.134.136.126]:56782 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727647AbfJEAqS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Oct 2019 20:46:18 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Oct 2019 17:46:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,258,1566889200"; 
   d="asc'?scan'208";a="222324030"
Received: from sranders-mobl2.amr.corp.intel.com ([10.251.5.129])
  by fmsmga002.fm.intel.com with ESMTP; 04 Oct 2019 17:46:16 -0700
Message-ID: <cd1712dc03721a01ac786ec878701a1823027434.camel@intel.com>
Subject: Re: [RFC 04/20] RDMA/irdma: Add driver framework definitions
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leon@kernel.org>,
        "dledford@redhat.com" <dledford@redhat.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Mustafa Ismail <mustafa.ismail@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Shiraz Saleem <shiraz.saleem@intel.com>
Date:   Fri, 04 Oct 2019 17:46:15 -0700
In-Reply-To: <20191004234519.GF13974@mellanox.com>
References: <20190926164519.10471-1-jeffrey.t.kirsher@intel.com>
         <20190926164519.10471-5-jeffrey.t.kirsher@intel.com>
         <20190926173046.GB14368@unreal>
         <04e8a95837ba8f6a0b1d001dff2e905f5c6311b4.camel@intel.com>
         <20191004234519.GF13974@mellanox.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-31JrZf1yK5lAQWNSDlMW"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--=-31JrZf1yK5lAQWNSDlMW
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2019-10-04 at 23:45 +0000, Jason Gunthorpe wrote:
> On Fri, Oct 04, 2019 at 01:12:22PM -0700, Jeff Kirsher wrote:
>=20
> > > > +	if (ldev->version.major !=3D I40E_CLIENT_VERSION_MAJOR ||
> > > > +	    ldev->version.minor !=3D I40E_CLIENT_VERSION_MINOR) {
> > > > +		pr_err("version mismatch:\n");
> > > > +		pr_err("expected major ver %d, caller specified
> > > > major
> > > > ver %d\n",
> > > > +		       I40E_CLIENT_VERSION_MAJOR, ldev-
> > > > >version.major);
> > > > +		pr_err("expected minor ver %d, caller specified
> > > > minor
> > > > ver %d\n",
> > > > +		       I40E_CLIENT_VERSION_MINOR, ldev-
> > > > >version.minor);
> > > > +		return -EINVAL;
> > > > +	}
> > >=20
> > > This is can't be in upstream code, we don't support out-of-tree
> > > modules,
> > > everything else will have proper versions.
> >=20
> > Who is the "we" in this context?
>=20
> Upstream sensibility - if we start doing stuff like this then we will
> end up doing it everwhere.

I see you cut out the part of my response about Linux distributions
disagreeing with this stance.

>=20
> > you support out-of-tree drivers, they do exist and this code would
> > ensure that if a "out-of-tree" driver is loaded, the driver will do a
> > sanity check to ensure the RDMA driver will work.
>=20
> I don't see how this is any different from any of the other myriad of
> problems out of tree modules face.=20
>=20
> Someone providing out of tree modules has to provide enough parts of
> their driver so that it only consumes the stable ABI from the distro
> kernel.
>=20
> Pretty normal stuff really.

Your right, if the dependency was reversed and the out-of-tree (OOT) driver
was dependent upon the RDMA driver, but in this case it is not.  The LAN
driver does not "need" the RDMA driver to work.  So the RDMA driver should
at least check that the LAN driver loaded has the required version to work.

This line of thinking, "marries" the in-kernel RDMA driver with the in-
kernel LAN driver(s) so the end users and Linux distro's can not choose to
upgrade or use any other driver than what comes with the kernel.  I totally
agree that any out-of-tree (OOT) driver needs to make sure they have all
kernel ABI's figured out for whatever kernel they are being installed on.=
=20
But what is the problem with the in-kernel RDMA driver to do it's own
checks to ensure the driver it is dependent upon meets its minimum
requirements?

Similar checks are done in the Intel LAN driver to ensure the firmware is
of a certain level, which is no different than what is being done here.

--=-31JrZf1yK5lAQWNSDlMW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEiTyZWz+nnTrOJ1LZ5W/vlVpL7c4FAl2X59cACgkQ5W/vlVpL
7c7wsg//V/WTg5IWRBsx9NMkSbE7kaky1PNfZY/YeqAJRaFRHn+1akabNgDs9FUM
Tvs82OrU8NPwIynEAY/RYo7nH6MFEJ3xedAZcAkOyv1aUzCfBJ2YIcr59iQ3ZhEV
jlW9PyGg2qD9YblEAZ8D/xLSLMY32N9qDHH7mAlJOKVLrTMrwnB0DB63VsoBaVz0
9b9roAdDDJUEiOABxjiv5SHlCdodfxSFQbtmDd5z23DUH7rctuKd1yIzrajeHLvh
SVirOl7r5L+hRjE2evjK87gW/jhGKthf0z2tG8z3Isgh6GsmeIbkZ97QqaSDPVuT
jNfhVCI8BIGKqFkkqemsNMc7KdxN7nFDfXAMN3WWKR6mctVEDpVK3lhL5JOGB21h
+ikeo2V69kOaCzAJXEOTHoRCkdAYSfaMU+jrjmhZIAlh2lg7DEcHXrYrhBYJRmSB
7/lQpDk3NbGhvai4D0QZxohpm6QN2QEMjz/AOH6g/dIwlLu8FpU9qU8cnPD8Wejw
YdgAYFI6UBf9jP3M/xGBIIXGSmTSFZgqVYFiYZfcXOltCURpvZjCjsnMXPBAg0Sl
kn8BYI/kJ+o1TZTwU/sdNmQWHoW+RyLU9RaT9l9wiF2A9lSeMoyUWB3jfCiqVKnd
98B/5jBXhELgY4vbLPs5Mn99TvDd7FjP3adeaX+lBPny69TNzCY=
=M1uO
-----END PGP SIGNATURE-----

--=-31JrZf1yK5lAQWNSDlMW--

