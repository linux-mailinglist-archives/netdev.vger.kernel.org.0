Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1D5D1DB752
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 16:45:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726754AbgETOps (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 10:45:48 -0400
Received: from mx2.suse.de ([195.135.220.15]:56556 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726510AbgETOpr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 May 2020 10:45:47 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 4275AAB5C;
        Wed, 20 May 2020 14:45:48 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 25BD2604F6; Wed, 20 May 2020 16:45:44 +0200 (CEST)
Date:   Wed, 20 May 2020 16:45:44 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     netdev@vger.kernel.org
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        David Jander <david@protonic.nl>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, Russell King <linux@armlinux.org.uk>,
        mkl@pengutronix.de, Marek Vasut <marex@denx.de>,
        Christian Herber <christian.herber@nxp.com>
Subject: Re: [PATCH net-next v3 1/2] ethtool: provide UAPI for PHY Signal
 Quality Index (SQI)
Message-ID: <20200520144544.GB8771@lion.mk-sys.cz>
References: <20200520062915.29493-1-o.rempel@pengutronix.de>
 <20200520062915.29493-2-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="cvVnyQ+4j833TQvp"
Content-Disposition: inline
In-Reply-To: <20200520062915.29493-2-o.rempel@pengutronix.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--cvVnyQ+4j833TQvp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 20, 2020 at 08:29:14AM +0200, Oleksij Rempel wrote:
> Signal Quality Index is a mandatory value required by "OPEN Alliance
> SIG" for the 100Base-T1 PHYs [1]. This indicator can be used for cable
> integrity diagnostic and investigating other noise sources and
> implement by at least two vendors: NXP[2] and TI[3].
>=20
> [1] http://www.opensig.org/download/document/218/Advanced_PHY_features_fo=
r_automotive_Ethernet_V1.0.pdf
> [2] https://www.nxp.com/docs/en/data-sheet/TJA1100.pdf
> [3] https://www.ti.com/product/DP83TC811R-Q1
>=20
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> ---

This looks good to me, there is just one thing I'm not sure about:

> diff --git a/include/linux/phy.h b/include/linux/phy.h
> index 59344db43fcb1..950ba479754bd 100644
> --- a/include/linux/phy.h
> +++ b/include/linux/phy.h
> @@ -706,6 +706,8 @@ struct phy_driver {
>  			    struct ethtool_tunable *tuna,
>  			    const void *data);
>  	int (*set_loopback)(struct phy_device *dev, bool enable);
> +	int (*get_sqi)(struct phy_device *dev);
> +	int (*get_sqi_max)(struct phy_device *dev);
>  };
>  #define to_phy_driver(d) container_of(to_mdio_common_driver(d),		\
>  				      struct phy_driver, mdiodrv)

I'm not sure if it's a good idea to define two separate callbacks. It
means adding two pointers instead of one (for every instance of the
structure, not only those implementing them), doing two calls, running
the same checks twice, locking twice, checking the result twice.

Also, passing a structure pointer would mean less code changed if we
decide to add more related state values later.

What do you think?

If you don't agree, I have no objections so

Reviewed-by: Michal Kubecek <mkubecek@suse.cz>

Michal

--cvVnyQ+4j833TQvp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEWN3j3bieVmp26mKO538sG/LRdpUFAl7FQpIACgkQ538sG/LR
dpV0dgf9EtLDViFGNOKw6wA8VFfIA2ANEsV19HAMn4YfQZ8pORVhIoJsKw8sAK64
l9xidgkJ+CuzNSzsynX7a1jQc8inPdZ2qNsQwi6f6q/5ndtGoGtieEvMU+4EvlnN
J0DehPfI9geLnzz7PjTuCYVbhBryTZoi0+otYDPPS1b1xhKlPdnNBHjnK2bsTrO4
7ysx/iQT4PRhuy8R7+1c3BwHKpq0Ofhk3zFZtrIahQF4dUIcNFSec+Hs5LEb9wwt
w96SKsAhwpgUeqMs/+eHHNIbjGQtrM42Kl2oA0MIUqW72rVETsnmlVyZH8gJVwWo
mgAqSTHL0MtZKJR0/Guq+4KM1AVKsQ==
=uNvL
-----END PGP SIGNATURE-----

--cvVnyQ+4j833TQvp--
