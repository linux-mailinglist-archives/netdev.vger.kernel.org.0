Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C58DB38B0A2
	for <lists+netdev@lfdr.de>; Thu, 20 May 2021 15:56:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236481AbhETN5o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 May 2021 09:57:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:33688 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232178AbhETN5j (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 May 2021 09:57:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 58C1960FE5;
        Thu, 20 May 2021 13:56:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621518977;
        bh=oWI0CzskyFFWD7HQmO6O8g09ywYvI6L/xj9NzKlEn0I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BW/xsRk8YiQ+JS2qpdsxiYiLQrr3vMBc3D0vtWxJf7lBLq0m5TjNwwtUbonl/1DTM
         Rpck5F2POmkrkWVbrMhWkHql/bFdaKzCU79L22qN4vCLjeng+E+xiHhxHAck4pK0Yg
         TyYXkIHTvWK4w7MHOXtflxiRIoZjoUIv6lHeSvLXQsANKXe1+Ha5i6WqGxWIs9qA7s
         TTngB8ZCOezkfWwj84lfqCjfjexpcPlP/eT992PR+vgLo4arTaSGuBVjvc7q9MEH+O
         nU8RiuqcJ50z8GGy4em2z93lr5Kh9y57EvVObzfkVvATyDZGr70rDSDG/7bnAl0geH
         Cy0stkbU6IV4Q==
Date:   Thu, 20 May 2021 14:56:15 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        linux-spi@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH net-next] net: dsa: sja1105: adapt to a SPI controller
 with a limited max transfer size
Message-ID: <20210520135615.GB3962@sirena.org.uk>
References: <20210520135031.2969183-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="cvVnyQ+4j833TQvp"
Content-Disposition: inline
In-Reply-To: <20210520135031.2969183-1-olteanv@gmail.com>
X-Cookie: Offer void where prohibited by law.
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--cvVnyQ+4j833TQvp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, May 20, 2021 at 04:50:31PM +0300, Vladimir Oltean wrote:

> Only that certain SPI controllers, such as the spi-sc18is602 I2C-to-SPI
> bridge, cannot keep the chip select asserted for that long.
> The spi_max_transfer_size() and spi_max_message_size() functions are how
> the controller can impose its hardware limitations upon the SPI
> peripheral driver.

You should respect both, frankly I don't see any advantage to using
cs_change for something like this - just do a bunch of async SPI
transfers and you'll get the same effect in terms of being able to keep
the queue for the controller primed with more robust support since it's
not stressing edge cases.  cs_change is more for doing things that are
just very non-standard.

--cvVnyQ+4j833TQvp
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmCman4ACgkQJNaLcl1U
h9DGKgf+NlDwQaPvJzLOJ7P64ThCwxkJPyx9M9hlG5tGrcZOzrlVSfR66KNswJQ/
R6o5BbSe/RMC2PbGdyN5fVDmQM6PPvT9TaQKuEQ6LhRoNRNsPBdZwWy+QqBNU4gq
6g09yTQ28KWC3TyBw+CO3MEtm6CrWejkWDhYaLLtytcQ1qmOmx8PHyNgtGip+Gb7
UDzS3FB9p2DML8VfXZXA63jg4v1nHnN00vzDOPpT0OhhoxmgH1eK5bfLcKBYNzuD
SPOqbKLqq6z8+9bPkxDEWSf8PpAIQX9KCA/U4mQctiF6ob/oxoMPI5y5kQWA8v7P
/svc3WEWNDyJaoesoTHAg1I29NQr9g==
=doSf
-----END PGP SIGNATURE-----

--cvVnyQ+4j833TQvp--
