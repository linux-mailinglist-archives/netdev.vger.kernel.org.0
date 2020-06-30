Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D63D20F2C1
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 12:31:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732521AbgF3Kbp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 06:31:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:52614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732238AbgF3Kbo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Jun 2020 06:31:44 -0400
Received: from localhost (fw-tnat.cambridge.arm.com [217.140.96.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5661020771;
        Tue, 30 Jun 2020 10:31:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593513103;
        bh=EqH2nGMcU9Sb0Kq3vXWL9ycwgwr+UuyAQkBZrQIcICA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vf7ejJWSl4ZfeteEaD86rXPRMQ/c/5puqzv7RFS327zwDfCY9e1RJaTmA3XH7Klh+
         9F+gI9Rjp5RHvnn0Nd8zT/NMB8UiBC+c90ZFOVBhMb4TPr78FoOSQZIX3rLaLBsRKx
         YbZNE+yUe/8PNfjB52VoyY8NmzucdcOqSbXNLADY=
Date:   Tue, 30 Jun 2020 11:31:41 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Greg KH <gregkh@linuxfoundation.org>, Takashi Iwai <tiwai@suse.de>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, nhorman@redhat.com,
        sassmann@redhat.com, Fred Oh <fred.oh@linux.intel.com>,
        lee.jones@linaro.org
Subject: Re: [net-next v4 10/12] ASoC: SOF: Introduce descriptors for SOF
 client
Message-ID: <20200630103141.GA5272@sirena.org.uk>
References: <20200521233437.GF17583@ziepe.ca>
 <7abfbda8-2b4b-5301-6a86-1696d4898525@linux.intel.com>
 <20200523062351.GD3156699@kroah.com>
 <57185aae-e1c9-4380-7801-234a13deebae@linux.intel.com>
 <20200524063519.GB1369260@kroah.com>
 <fe44419b-924c-b183-b761-78771b7d506d@linux.intel.com>
 <s5h5zcistpb.wl-tiwai@suse.de>
 <20200527071733.GB52617@kroah.com>
 <20200629203317.GM5499@sirena.org.uk>
 <20200629225959.GF25301@ziepe.ca>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="bp/iNruPH9dso1Pn"
Content-Disposition: inline
In-Reply-To: <20200629225959.GF25301@ziepe.ca>
X-Cookie: Walk softly and carry a megawatt laser.
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--bp/iNruPH9dso1Pn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 29, 2020 at 07:59:59PM -0300, Jason Gunthorpe wrote:
> On Mon, Jun 29, 2020 at 09:33:17PM +0100, Mark Brown wrote:
> > On Wed, May 27, 2020 at 09:17:33AM +0200, Greg KH wrote:

> > > Ok, that's good to hear.  But platform devices should never be showing
> > > up as a child of a PCI device.  In the "near future" when we get the
> > > virtual bus code merged, we can convert any existing users like this =
to
> > > the new code.

> > What are we supposed to do with things like PCI attached FPGAs and ASICs
> > in that case?  They can have host visible devices with physical
> > resources like MMIO ranges and interrupts without those being split up
> > neatly as PCI subfunctions - the original use case for MFD was such
> > ASICs, there's a few PCI drivers in there now.=20

> Greg has been pretty clear that MFD shouldn't have been used on top of
> PCI drivers.

The proposed bus lacks resource handling, an equivalent of
platform_get_resource() and friends for example, which would be needed
for use with physical devices.  Both that and the name suggest that it's
for virtual devices.

> In a sense virtual bus is pretty much MFD v2.

Copying in Lee since I'm not sure he's aware of this, it's quite a
recent thing...  MFD is a layer above AFAICT, it's not a bus but rather
a combination of helpers for registering subdevices and a place for
drivers for core functionality of devices which have multiple features.

The reason the MFDs use platform devices is that they end up having to
have all the features of platform devices - originally people were
making virtual buses for them but the code duplication is real so
everyone (including Greg) decided to just use what was there already.

--bp/iNruPH9dso1Pn
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAl77FIoACgkQJNaLcl1U
h9D5xQf/Zvz/1EGl9pnsXeFwL4gfvhIO78L2JdKTopOVxmy7G9U1NfRcBQzxWAiO
UdcO8crWix6I4OGsciUIk/cLMZGFyAok0XGsh2aBsP7ccBp+Bcky6+/AjYv70qXf
IWBoVCnuSvcvSwU0DFjn2wEiKsKmhTu9LglNgAOYK/z8FrzXBTBdXLuQn4FDOaPQ
C38CUkYaaBvaEwJMh3n1AHz+Fxx9ausTFLqiaLnOXmPBBwlNVWgpxnAypbUhk37a
bk9h2Li8Sngm/d+BHL9SkermlDGi9Mjk4jGMrBH7dYxwnvh9mPMyAmRBX7kauYOH
Ikmo4NiOrTvWc85hjj1dxJDsdnP7Rw==
=wONO
-----END PGP SIGNATURE-----

--bp/iNruPH9dso1Pn--
