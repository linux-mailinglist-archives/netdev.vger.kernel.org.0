Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33F31326CA3
	for <lists+netdev@lfdr.de>; Sat, 27 Feb 2021 11:17:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230014AbhB0KRT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Feb 2021 05:17:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:60302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229795AbhB0KRS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 27 Feb 2021 05:17:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CF8A164EAF;
        Sat, 27 Feb 2021 10:16:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614420998;
        bh=/FHmPWlGWrwSdh5UjgqtYpQhEj1XpPSCWtTxf/ad+TY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=I/w0hhMNnN4nV2zHT2GRm27SnczzZ4aZT1tzRtDYBFdlPfehFckswNFZqOLsIFBy7
         O3z0YyiNqvs0aPx0efdePw1q8JLOxhVXtlESgpRQH6DCdJ5sk+gktdRcyvD2zF7I9T
         P/030tPSwhZPUdvbqOGgegon9ui5g1ct62GuFSfU8NT5gtAKW12Na1aMBYExDF/30E
         BTiDPU3hARwaysy3gxuieNiTj9EzbkSshWNP5qO51XOQd2lwZKkV6aMHE4CNfOr/rg
         SG3YBVPEPgurbqsvR5bu2I7er+UN4wb42Nf7j7h8Ub8Qq3waEvYQ9MV6hXX78lXi1R
         /n7KSS4KKDCxw==
Date:   Sat, 27 Feb 2021 11:16:33 +0100
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, davem@davemloft.net,
        kuba@kernel.org, ast@kernel.org, lorenzo.bianconi@redhat.com,
        brouer@redhat.com, toke@redhat.com, freysteinn.alfredsson@kau.se
Subject: Re: [PATCH bpf-next] bpf: devmap: move drop error path to devmap for
 XDP_REDIRECT
Message-ID: <YDocAXK6K4bg/olY@lore-desk>
References: <76469732237ce6d6cc6344c9500f9e32a123a56e.1613569803.git.lorenzo@kernel.org>
 <c3b56d02-e415-b6e9-2c22-9c3d341e07e9@iogearbox.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="jrXVF1sZRQ+5Wg7a"
Content-Disposition: inline
In-Reply-To: <c3b56d02-e415-b6e9-2c22-9c3d341e07e9@iogearbox.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--jrXVF1sZRQ+5Wg7a
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On 2/17/21 2:56 PM, Lorenzo Bianconi wrote:
> > We want to change the current ndo_xdp_xmit drop semantics because
> > it will allow us to implement better queue overflow handling.
> > This is working towards the larger goal of a XDP TX queue-hook.
> > Move XDP_REDIRECT error path handling from each XDP ethernet driver to
> > devmap code. According to the new APIs, the driver running the
> > ndo_xdp_xmit pointer, will break tx loop whenever the hw reports a tx
> > error and it will just return to devmap caller the number of successful=
ly
> > transmitted frames. It will be devmap responsability to free dropped fr=
ames.
> > Move each XDP ndo_xdp_xmit capable driver to the new APIs:
> > - veth
> > - virtio-net
> > - mvneta
> > - mvpp2
> > - socionext
> > - amazon ena
> > - bnxt
> > - freescale (dpaa2, dpaa)
> > - xen-frontend
> > - qede
> > - ice
> > - igb
> > - ixgbe
> > - i40e
> > - mlx5
> > - ti (cpsw, cpsw-new)
> > - tun
> > - sfc
>=20
> I presume for a number of these drivers the refactoring changes were just=
 compile-
> tested due to lack of HW, right? If so, please also Cc related driver mai=
ntainers
> aside from the few of us, so they have a chance to review & ACK the patch=
 if it looks
> good to them. I presume Ed saw it by accident, but for others it might ea=
sily get
> lost in the daily mail flood.

Hi Daniel,

ack, I will do in v2.

>=20
> > More details about the new ndo_xdp_xmit design can be found here [0].
> >=20
> > [0] https://github.com/xdp-project/xdp-project/blob/master/areas/core/r=
edesign01_ndo_xdp_xmit.org
>=20
> I'd probably move this below the "---" if it's not essential to the commi=
t itself or
> rather take relevant parts out and move it into the commit desc so it doe=
sn't get
> lost for future ref given things could likely reschuffle inside the repo =
in the future,
> just a nit.

ack, I will do in v2.

Regards,
Lorenzo

>=20
> > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>

--jrXVF1sZRQ+5Wg7a
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCYDob/AAKCRA6cBh0uS2t
rCqcAQDocUCSq5PVOaycLfFtjGUMi47NXBJLlSRgJZBikGCzfAD9HyEdlFH6pcID
EHR71FlKV5ErhPNpOx3RIeNUxw9bqA0=
=LlGh
-----END PGP SIGNATURE-----

--jrXVF1sZRQ+5Wg7a--
