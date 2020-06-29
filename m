Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0144920E1C7
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 23:59:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390061AbgF2U7P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 16:59:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:52208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389610AbgF2U7N (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Jun 2020 16:59:13 -0400
Received: from localhost (fw-tnat.cambridge.arm.com [217.140.96.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BEF0E206F1;
        Mon, 29 Jun 2020 20:59:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593464352;
        bh=VR65r4FkcTnO0p6gPR+7EyK7Y7dTKwlSpV8Y/vR5Q/8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rt+31gnhKhhk+MqHAEyRpSj4qKy8mh0Cr8Pkm9+3OkOTD+kbfNuJ+qMWz96LLBqZW
         Zlhp5rihhVG/0oZTTstSgKSQU12tZno4+phGf28uxoEqnFI43DfD4i2asH11jzPD/Q
         S77FbENZWxRlgf78qLXr5LAjv+nFS1gUQuKoXTp0=
Date:   Mon, 29 Jun 2020 21:59:10 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Cc:     Jason Gunthorpe <jgg@ziepe.ca>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        davem@davemloft.net, gregkh@linuxfoundation.org,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Fred Oh <fred.oh@linux.intel.com>
Subject: Re: [net-next v4 10/12] ASoC: SOF: Introduce descriptors for SOF
 client
Message-ID: <20200629205910.GO5499@sirena.org.uk>
References: <20200520070227.3392100-1-jeffrey.t.kirsher@intel.com>
 <20200520070227.3392100-11-jeffrey.t.kirsher@intel.com>
 <20200520125437.GH31189@ziepe.ca>
 <08fa562783e8a47f857d7f96859ab3617c47e81c.camel@linux.intel.com>
 <20200521233437.GF17583@ziepe.ca>
 <7abfbda8-2b4b-5301-6a86-1696d4898525@linux.intel.com>
 <20200522145542.GI17583@ziepe.ca>
 <6e129db7-2a76-bc67-0e56-2abb4d9761a3@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="zBPbvmIlJjvpbu6L"
Content-Disposition: inline
In-Reply-To: <6e129db7-2a76-bc67-0e56-2abb4d9761a3@linux.intel.com>
X-Cookie: Real programs don't eat cache.
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--zBPbvmIlJjvpbu6L
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, May 22, 2020 at 10:33:20AM -0500, Pierre-Louis Bossart wrote:
> On 5/22/20 9:55 AM, Jason Gunthorpe wrote:

> > Maybe not great, but at least it is consistent with all the lifetime
> > models and the operation of the driver core.

> I agree your comments are valid ones, I just don't have a solution to be
> fully compliant with these models and report failures of the driver probe
> for a child device due to configuration issues (bad audio topology, etc).

> My understanding is that errors on probe are explicitly not handled in the
> driver core, see e.g. comments such as:

It's just not an error for a child device to not instantiate, we don't
even know if the driver is loaded yet.  The parent really should not
care if the child is there or not.

> > > PCI device creates an audio card represented as a platform device. When the
> > > card registration fails, typically due to configuration issues, the PCI
> > > probe still completes. That's really confusing and the source of lots of
> > > support questions. If we use these virtual bus extensions to stpo abusing
> > > platform devices, it'd be really nice to make those unreported probe
> > > failures go away.

> > I think you need to address this in some other way that is hot plug
> > safe.

> > Surely you can make this failure visible to users in some other way?

> Not at the moment, no. there are no failures reported in dmesg, and the user
> does not see any card created. This is a silent error.

If we're failing to do something we should report it.  This includes
deferred probe failures.

--zBPbvmIlJjvpbu6L
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAl76Vh0ACgkQJNaLcl1U
h9DwOwf+ObKC0aouXliS3999VTEqRR7fUh9j3rNU8fltTUx60q7nD/GFAVyemiAB
8tctlZT8zed7lcw9i1pQfDHls/T9f2EQy5uG/bJyTxwBirFXsjCrdI8lmjYs00gR
i/sQ6fdeJ8IWptXGdYMN5/nGBYFfYKAXPy9Ne43RlLWHGrPUWWg6iGHz9bGi0cMQ
d6XSSJlLjUH1sdB+DIYNZpEB82yjWYpWstDIgOSZVyXWaB03+4DmramvN7HHOiD2
8YnlFNPYc2GQacJTiRoOpXJAUvqab5b/tGrFyLdPFtXB6J2vZfJdCGB/fmmDqgZD
fLmTzjGq+8s+/Anxyi+0T1rNwf3O4w==
=BEZq
-----END PGP SIGNATURE-----

--zBPbvmIlJjvpbu6L--
