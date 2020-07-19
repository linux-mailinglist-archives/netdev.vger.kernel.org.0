Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 771BE2254C5
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 01:47:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726531AbgGSXr1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jul 2020 19:47:27 -0400
Received: from mx2.suse.de ([195.135.220.15]:34358 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726156AbgGSXr1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 19 Jul 2020 19:47:27 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 93240ACA0;
        Sun, 19 Jul 2020 23:47:31 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 6CA9D60743; Mon, 20 Jul 2020 01:47:24 +0200 (CEST)
Date:   Mon, 20 Jul 2020 01:47:24 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Govindarajulu Varadarajan <gvaradar@cisco.com>
Cc:     netdev@vger.kernel.org, edumazet@google.com,
        linville@tuxdriver.com, govind.varadar@gmail.com, benve@cisco.com
Subject: Re: [PATCH ethtool v2 1/2] ethtool: add support for get/set
 ethtool_tunable
Message-ID: <20200719234724.4dhsd547s7od4uyg@lion.mk-sys.cz>
References: <20200717145950.327680-1-gvaradar@cisco.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="ix2qorohhcsvlw4t"
Content-Disposition: inline
In-Reply-To: <20200717145950.327680-1-gvaradar@cisco.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--ix2qorohhcsvlw4t
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 17, 2020 at 07:59:49AM -0700, Govindarajulu Varadarajan wrote:
> Add support for ETHTOOL_GTUNABLE and ETHTOOL_STUNABLE options.
>=20
> Tested rx-copybreak on enic driver. Tested ETHTOOL_TUNNABLE_STRING

A typo: TUNNABLE -> TUNABLE

> options with test/debug changes in kernel.
>=20
> Signed-off-by: Govindarajulu Varadarajan <gvaradar@cisco.com>
> ---

This looks good to me but I'm still not happy with the string tunables
handling. The reason I asked about it was to find out if I missed some
important piece of information. But it doesn't seem to be the case so
that the situation looks like this:

  - there is no documentation telling us how they should work
  - there is no kernel or userspace code yet (except this patch)
  - there is no string tunable yet
  - we don't even know if there is ever going to be any
  - proposed code is inconsistent (it allows passing value to kernel
    which it would not be able to receive back from kernel)
  - it adds extra complexity to do_gtunable() and do_stunable()
    (special handling and allocating a new buffer in each iteration)
  - it's dead code anyway: the way the interface is designed, current
    ethtool cannot get/set future tunables it does not recognize)

Therefore I suggest to drop handling of string tunables until there is
actually a string tunable and we get (preferrably documented) consensus
on how the interface should behave. (Which may very well never happen.)

Michal

--ix2qorohhcsvlw4t
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEWN3j3bieVmp26mKO538sG/LRdpUFAl8U24YACgkQ538sG/LR
dpXJuwgAjqScqel2ppjVaxQGVCy3rglN4ZVvVMfo1l+LMYbd2FMhc2vQjgRKISO7
E67G+E8vZzwO5TGs8rcndthLMfeDcxGj8E6lN7rB3/03c2rrwtKLuIWHt8Ty+lu9
yvIAekMtsnYw9wjuXktez+YAlaZD+tQYWtIQljNokWnTyzCptCElj7uOIxLucE3T
El0XKbhj1mDSR4rBaH/jQJ3VZSr1dBUUsEaurrD1NQsLzlHPsIcoqQ6xfJc8LnFu
oOZEiUPDS1nB5G0OWFDALx8GdSEj2vrPpOcGfOD7198ld33VzSoIY5ujoc+jo2Kj
0djAyMMFx9aI4ddK5Rwj344G2j5t+Q==
=AXd7
-----END PGP SIGNATURE-----

--ix2qorohhcsvlw4t--
