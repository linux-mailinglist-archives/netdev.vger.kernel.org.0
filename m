Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 304BF39E5FF
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 19:56:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231246AbhFGR6S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 13:58:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:47800 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231220AbhFGR6R (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Jun 2021 13:58:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6933D610A8;
        Mon,  7 Jun 2021 17:56:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623088585;
        bh=FxlPlGwzOH68vLMvGAmu0DApAPfPqgM1WS9nhpC1Qys=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ceqn3Md5mBq7rpR+DevcxNZ2ndKbBJVYkLBgt0mvuCNQkp0UgZk+H6wgOG5IAUNuK
         keJEnYh3XAWwmudcCOn6Nnj8KOuUnt7KLJYf2loRTzh2Pe1iwdtERBxu9+blDE2z8y
         0zj4FUE/nVSAhtp8WpTGFOkiDg+XJJ6bTMx2SdAgzIanTQIP8shVTAFCqh8QzqnKJQ
         kpHiIRHAFOitnqaBzfK0ghJACJauCkHRX8SER0GWoU3jUn70e/r4KcnldnRWFIOyiY
         ybESfpuU6MgTd7gkKhzkGT6w/pw2lI7AOPE7lJXR9zf80fcc1xdzm8UhZOf+ROPqq2
         wwijnNTTjm2fw==
Date:   Mon, 7 Jun 2021 18:56:11 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        linux-spi@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH v3 net-next 1/2] net: dsa: sja1105: send multiple
 spi_messages instead of using cs_change
Message-ID: <20210607175611.GD10625@sirena.org.uk>
References: <20210520211657.3451036-1-olteanv@gmail.com>
 <20210520211657.3451036-2-olteanv@gmail.com>
 <20210524083529.GA4318@sirena.org.uk>
 <20210524130212.g6jcf7y4grc64mki@skbuf>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="jL2BoiuKMElzg3CS"
Content-Disposition: inline
In-Reply-To: <20210524130212.g6jcf7y4grc64mki@skbuf>
X-Cookie: I never did it that way before.
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--jL2BoiuKMElzg3CS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, May 24, 2021 at 04:02:12PM +0300, Vladimir Oltean wrote:
> On Mon, May 24, 2021 at 09:35:29AM +0100, Mark Brown wrote:

> > This is not the case, spi_message_max_size() is a limit on the size of a
> > spi_message.

> That is true, although it doesn't mean much, since in the presence of
> cs_change, a spi_message has no correspondent in the physical world
> (i.e. you can't look at a logic analyzer dump and say "this spi_message
> was from this to this point"), and that is the problem really.

It may affect how things are implemented by the driver, for example if
the driver can send a command stream to the hardware the limit might be
due to that command stream.  There is no need or expectation for drivers
to pattern match what the're being asked to do and parse out something
that should be a string of messages from the spi_message they get, it is
expected that client drivers should split things up naturally.

> Describing the controller's inability to send more than N SPI words with
> continuous chip select using spi_message_max_size() is what seems flawed
> to me, but it's what we have, and what I've adapted to.

I can't entirely parse that but the limit here isn't to do with how long
chip select is asserted for.

--jL2BoiuKMElzg3CS
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmC+XboACgkQJNaLcl1U
h9DdMwf+L2U5OSSMrunBQzsZp+5RREPvEx2yKgVRob8DbI9vMpxB3aKbxV5ID0qC
QRcbIwIC1O4GhLEKVmLM76uNZ0gEd0bUbR5ckMPSAUqhKttwQj0oZpmqEhEp5TSS
nJG7DqGvnBPzyFoSWhX6yYPi+MIW12afAqp+yekYEi5BoAnPmrvUK6m8TVDqTxDr
7ubMMg79xYyR8yiHLSd2l4ets49nH5ziAi1NTxr1eAQaiQf6SJLVI8fVFooAbxKY
0UwEJcCxbsrQCXO7MluffsJSwbecF6hgkYpckVTmhX26+fo6Edc6cTU8MQyWib4a
IjfuVJJPQSzq8dBe9RhQXSvjjfuIYg==
=AiGc
-----END PGP SIGNATURE-----

--jL2BoiuKMElzg3CS--
