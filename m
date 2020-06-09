Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C9841F351A
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 09:41:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726965AbgFIHlQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jun 2020 03:41:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:45358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726404AbgFIHlP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Jun 2020 03:41:15 -0400
Received: from localhost (unknown [151.48.128.87])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6CC4D2081A;
        Tue,  9 Jun 2020 07:41:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591688475;
        bh=QcmI30qSxZifxh5xML+gGikq+0x1Nw1MdPX5TCA5sic=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=X4lOu/Dc7ZHqJ8c8BVBqLTCDDsb5SQOyGr3944CP49HppKrHRoi05nnZ5gBBWpDaH
         myOAeX6N5ZUT5sIF0jIdzLMZi/mQkG7gFxg0OH+kvn5d2VaM6O8QhN69UguMKZGeM/
         INJjpdPqLTuc4jQQVU6Hzslf91Kio/PDANzqnWko=
Date:   Tue, 9 Jun 2020 09:41:10 +0200
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        thomas.petazzoni@bootlin.com, lorenzo.bianconi@redhat.com,
        brouer@redhat.com
Subject: Re: [PATCH net] net: mvneta: do not redirect frames during
 reconfiguration
Message-ID: <20200609074110.GA2067@localhost.localdomain>
References: <fd076dae0536d823e136ab4c114346602e02b6d7.1591653494.git.lorenzo@kernel.org>
 <20200608231015.GH1022955@lunn.ch>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="ibTvN161/egqYuK8"
Content-Disposition: inline
In-Reply-To: <20200608231015.GH1022955@lunn.ch>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--ibTvN161/egqYuK8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Tue, Jun 09, 2020 at 12:02:39AM +0200, Lorenzo Bianconi wrote:
> > Disable frames injection in mvneta_xdp_xmit routine during hw
> > re-configuration in order to avoid hardware hangs
>=20
> Hi Lorenzo
>=20
> Why does mvneta_tx() also not need the same protection?
>=20
>     Andrew

Hi Andrew,

So far I have not been able to trigger the issue in the legacy tx path.
I hit the problem adding the capability to attach an eBPF program to CPUMAP
entries [1]. In particular I am redirecting traffic to mvneta and concurren=
tly
attaching/removing a XDP program to/from it.
I am not sure this can occur running mvneta_tx().
Moreover it seems a common pattern for .ndo_xdp_xmit() in other drivers
(e.g ixgbe, bnxt, mlx5)

Regards,
Lorenzo

[1] https://patchwork.ozlabs.org/project/netdev/cover/cover.1590960613.git.=
lorenzo@kernel.org/

--ibTvN161/egqYuK8
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCXt89EwAKCRA6cBh0uS2t
rOx+AQC+0fLmDvdpIIyE3hEO0zLOTTOncdvibkxHrE70rJtF1AEA8tETubun6QbR
IB1es8y5S51m4fslombynBupK5Sr3g8=
=4/NO
-----END PGP SIGNATURE-----

--ibTvN161/egqYuK8--
