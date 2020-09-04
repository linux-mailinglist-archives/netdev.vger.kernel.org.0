Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0364625D30C
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 09:54:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729851AbgIDHyr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Sep 2020 03:54:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:54020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726151AbgIDHyq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Sep 2020 03:54:46 -0400
Received: from localhost (unknown [151.66.86.87])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 757F3206A5;
        Fri,  4 Sep 2020 07:54:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599206086;
        bh=73lKRVfJ/rpz6cddiuQ+4cCkIdxHssgvQFs+/VrA49w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MR5LNOGK4FKu6c4JCxsOM1/KA9hWGmTSbW/xhIob2Q7SmOUAVdnohaN3JhKKGRrie
         s5ZSW2MoTqJR9Nhd4oE2RQRRJsNhiYZ02Hslt/0+LtavYsmT+qP+GxHQrDn87PUILY
         gur5IAHkRwr2DCZN2kdlgaHcLPQxQIghEy8vujuU=
Date:   Fri, 4 Sep 2020 09:54:41 +0200
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, davem@davemloft.net,
        lorenzo.bianconi@redhat.com, echaudro@redhat.com,
        sameehj@amazon.com, kuba@kernel.org, john.fastabend@gmail.com,
        daniel@iogearbox.net, ast@kernel.org, shayagr@amazon.com,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>
Subject: Re: [PATCH v2 net-next 2/9] xdp: initialize xdp_buff mb bit to 0 in
 all XDP drivers
Message-ID: <20200904075441.GD2884@lore-desk>
References: <cover.1599165031.git.lorenzo@kernel.org>
 <05822dfe200c5d581d6a6cad89c1b63bb7a1c566.1599165031.git.lorenzo@kernel.org>
 <20200904093542.4dc43682@carbon>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="rz+pwK2yUstbofK6"
Content-Disposition: inline
In-Reply-To: <20200904093542.4dc43682@carbon>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--rz+pwK2yUstbofK6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Thu,  3 Sep 2020 22:58:46 +0200
> Lorenzo Bianconi <lorenzo@kernel.org> wrote:
>=20
> > diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/ne=
t/ethernet/intel/ixgbe/ixgbe_main.c
> > index 0b675c34ce49..20c8fd3cd4a3 100644
> > --- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> > +++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> > @@ -2298,6 +2298,7 @@ static int ixgbe_clean_rx_irq(struct ixgbe_q_vect=
or *q_vector,
> >  #if (PAGE_SIZE < 8192)
> >  	xdp.frame_sz =3D ixgbe_rx_frame_truesize(rx_ring, 0);
> >  #endif
> > +	xdp.mb =3D 0;
> > =20
> >  	while (likely(total_rx_packets < budget)) {
> >  		union ixgbe_adv_rx_desc *rx_desc;
>=20
> In this ixgbe driver you are smart and init the xdp.mb bit outside the
> (like xdp.frame_sz, when frame_sz is constant).   This is a nice
> optimization, but the driver developer that adds XDP multi-buffer
> support must remember to reset it.  The patch itself is okay, it is
> just something to keep in-mind when reviewing/changing drivers.

yes, I have just decided to avoid unnecessary instructions for the moment.

Regards,
Lorenzo

>=20
> --=20
> Best regards,
>   Jesper Dangaard Brouer
>   MSc.CS, Principal Kernel Engineer at Red Hat
>   LinkedIn: http://www.linkedin.com/in/brouer
>=20

--rz+pwK2yUstbofK6
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCX1HyvgAKCRA6cBh0uS2t
rFqvAQCgLw4dWMz9aljcKTss6TRqgt9F4OO2vo5SJMNudbPIEQEAoblSeRiLgC9N
utf0lHJ8YbCnnbvOB8DzxnVz53xAPgQ=
=iTva
-----END PGP SIGNATURE-----

--rz+pwK2yUstbofK6--
