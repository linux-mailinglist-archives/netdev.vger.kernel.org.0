Return-Path: <netdev+bounces-9691-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4373372A329
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 21:34:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9AC75281A1D
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 19:34:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E11ED1D2D6;
	Fri,  9 Jun 2023 19:34:09 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 669EA408E7
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 19:34:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D79B9C433D2;
	Fri,  9 Jun 2023 19:34:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686339247;
	bh=UOspDcDfDFm6QPopNaAEG0ZWyNsc8e+X/dvLCTYWW0M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tQhS0eRyklovhz/AoC7U2GE5HgQOiLjzRFTt+o3ZaiC9tr6qYM1CkWJP4Qlm+9q3T
	 RU7NiJBJajGB8cdlIO6VDE/oX6e9S0Psnue96fn9fVTt/qm9oYckEGCvjh7fupaWJb
	 z5B6WvqusQ2SyRSWlfR/INpEVwIo9Ih/tAm7bAMMapz7rWhm4weStrlmQBdfYBR0b+
	 A6VdWdYb/CqXYW+7MhULJgXactJgbkDgDdeGCGzcJC15rZOgeFhyKlcCqSMS6Zz6OU
	 DHBLH7R2RphkCQgxo65P81CvZPnd18r6ml2ajIJ50/vxrLThnaYzMLgIyTwYakVJ6k
	 3grAPwoG3v1wg==
Date: Fri, 9 Jun 2023 20:34:01 +0100
From: Mark Brown <broonie@kernel.org>
To: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc: Raymond Hackley <raymondhackley@protonmail.com>, davem@davemloft.net,
	devicetree@vger.kernel.org, edumazet@google.com,
	jk@codeconstruct.com.au, kuba@kernel.org, lgirdwood@gmail.com,
	linux-kernel@vger.kernel.org, michael@walle.cc,
	netdev@vger.kernel.org, pabeni@redhat.com, robh+dt@kernel.org,
	u.kleine-koenig@pengutronix.de
Subject: Re: [PATCH v2 2/2] NFC: nxp-nci: Add pad supply voltage pvdd-supply
Message-ID: <a3d2dd4f-38ce-40ca-9085-893f808f817b@sirena.org.uk>
References: <20230609154033.3511-1-raymondhackley@protonmail.com>
 <20230609154200.3620-1-raymondhackley@protonmail.com>
 <e2bb439c-9b72-991b-00f6-0b5e7602efd9@linaro.org>
 <20230609173935.84424-1-raymondhackley@protonmail.com>
 <7ad5d027-9b15-f59e-aa76-17e498cb7aba@linaro.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="fhm/1UM3KQHYSisd"
Content-Disposition: inline
In-Reply-To: <7ad5d027-9b15-f59e-aa76-17e498cb7aba@linaro.org>
X-Cookie: Tom's hungry, time to eat lunch.


--fhm/1UM3KQHYSisd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jun 09, 2023 at 09:29:51PM +0200, Krzysztof Kozlowski wrote:
> On 09/06/2023 19:40, Raymond Hackley wrote:
> > On Friday, June 9th, 2023 at 3:46 PM, Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org> wrote:

> > Second condition regulator_is_enabled(pvdd) is to make sure that pvdd is
> > disabled with balance.

> So you have buggy code and to hide the bug you add checks? No, make the
> code correct so the check is not needed.

Specifically your driver should only ever call regulator_disable() to
balance out regulator_enable() calls it made itself and it should know
how many of those it has done.  regulator_is_enabled() should only ever
be used during probe if for some reason it is important to figure out if
the device is already powered for startup, this should be very unusual.
If something else enabled the regualtor then whatever did that needs to
undo those enables, not another driver.

--fhm/1UM3KQHYSisd
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmSDfqgACgkQJNaLcl1U
h9ABiwf9Hutr2zJvx9D17c4xS1JOiT2t+PozkRvq6t8oWu82/GhSKzCEl4qiJ48j
KG9Dyy6j44XBO2sjM4X0ge6gjX7+3TPcFRd4WC5VtqmqNgyKQviRk8KBPT7g+9Le
tA5btQ5ytvDJRNhvlAqi8FxkwAt3P+6DPVZGosDcJcaDwHa936TM1SAZnx6TP7y4
vc0etFHfMt/+xL9hMRqxlCyL+dPo45wdsNOibWJu9mF15yDfDdJLfWW+d8qbRu9r
V2o7YSG0k0Ukxpj5fgBiBgWfAsYKmYVzg15gTazoop0PHUGtonXk14vZt5bQQGkV
s3SCRrQAOCNB7v0yl5nhK87ypCx31Q==
=365c
-----END PGP SIGNATURE-----

--fhm/1UM3KQHYSisd--

