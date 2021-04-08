Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C562135871F
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 16:26:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231901AbhDHO1D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 10:27:03 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:22815 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231672AbhDHO1B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Apr 2021 10:27:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617892010;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ZPPXCqUH2YaZouzTX5dPV4yeZl8bVZubonzlPAdH16c=;
        b=impuefhFsXQ9U3MqbJZH34f/bNi6BfWwuCb0xuXd3i9Ut5PmTHIboaFd3/nqnr8595h7Rb
        QUkRsFT1xXT3Ilb5p5XNa3X2+JtQIkohq2uGNETuPAve/9i/SWTei8Pvd/QKmaD6rzv7Nj
        rUrJzyjjp3rKHc0RMylc0KDwOZEQjcA=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-477-nYuW-CdmOoiuqmT9nJhRlA-1; Thu, 08 Apr 2021 10:26:48 -0400
X-MC-Unique: nYuW-CdmOoiuqmT9nJhRlA-1
Received: by mail-ed1-f72.google.com with SMTP id f9so1119822edd.13
        for <netdev@vger.kernel.org>; Thu, 08 Apr 2021 07:26:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ZPPXCqUH2YaZouzTX5dPV4yeZl8bVZubonzlPAdH16c=;
        b=jFfDLyDM7u/2Tyh82DWUxxtQda6t30QlOy9rQORm1ZUCoqiF5ptlldwJMilaF1MK9j
         5VuSPXEH0BBSUuSRaTcn3zFKoBrciByq2e/5bYpp9AEfVmbRVkKDTz6kUCInO+O955tl
         e3g4aoYMvKnbAkNAaCFTmH8c6JnYNJRb6oiKiVAVr1ln6xjoRaazkVl+CVVS6oVeNvcl
         A2yITenOXeDs0fLfFV/9dtqGrSVmw8RA3qScmBhmY5BD63SFOcOsoeYlIJNngY28YMLf
         TrieaMPbxU1wpmjwZeasViwoRMD1WUJ5nV/y2ZrBRY3Sx+GKErAxmi32lzPBGnfdy0V1
         +hIQ==
X-Gm-Message-State: AOAM531Uf25Vi5/Iia9Y1CY8HzBTNmbwxWXH9Z/PHKreSQus/B+4E/60
        Sc3mI7wlfYKZ+PnPifrmB56lHALdyEmxugHzalL+yGtwRpQvbP8+Qn9+5FaJieVQ99c+SJRAh6o
        d00ynKWcNsO83VV4Y
X-Received: by 2002:aa7:c40b:: with SMTP id j11mr11799140edq.141.1617892006975;
        Thu, 08 Apr 2021 07:26:46 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzEUVOS+fvRHofzI4gbGg29BS0jOh6L5q7YT3gR5MWXNiexkSvlZhe9KOrufVlX5ExNWXCjZA==
X-Received: by 2002:aa7:c40b:: with SMTP id j11mr11799109edq.141.1617892006798;
        Thu, 08 Apr 2021 07:26:46 -0700 (PDT)
Received: from localhost ([151.66.38.94])
        by smtp.gmail.com with ESMTPSA id w13sm11171127edc.81.2021.04.08.07.26.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Apr 2021 07:26:46 -0700 (PDT)
Date:   Thu, 8 Apr 2021 16:26:43 +0200
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        sameehj@amazon.com, john.fastabend@gmail.com, dsahern@kernel.org,
        brouer@redhat.com, echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com
Subject: Re: [PATCH v8 bpf-next 02/14] xdp: add xdp_shared_info data structure
Message-ID: <YG8So5DfxBr10I+Y@lore-desk>
References: <cover.1617885385.git.lorenzo@kernel.org>
 <b204c5d4514134e1b2de9c1959da71514d1f1340.1617885385.git.lorenzo@kernel.org>
 <20210408133922.qa7stbwue44nfvcv@skbuf>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="XdTjWIYUUV0Cdz8G"
Content-Disposition: inline
In-Reply-To: <20210408133922.qa7stbwue44nfvcv@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--XdTjWIYUUV0Cdz8G
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> Hi Lorenzo,
>=20
> On Thu, Apr 08, 2021 at 02:50:54PM +0200, Lorenzo Bianconi wrote:
> > Introduce xdp_shared_info data structure to contain info about
> > "non-linear" xdp frame. xdp_shared_info will alias skb_shared_info
> > allowing to keep most of the frags in the same cache-line.
> > Introduce some xdp_shared_info helpers aligned to skb_frag* ones
> >=20
> > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > ---
>=20
> Would you mind updating all drivers that use skb_shared_info, such as
> enetc, and not just mvneta? At the moment I get some build warnings:
>=20
> drivers/net/ethernet/freescale/enetc/enetc.c: In function =E2=80=98enetc_=
xdp_frame_to_xdp_tx_swbd=E2=80=99:
> drivers/net/ethernet/freescale/enetc/enetc.c:888:9: error: assignment to =
=E2=80=98struct skb_shared_info *=E2=80=99 from incompatible pointer type =
=E2=80=98struct xdp_shared_info *=E2=80=99 [-Werror=3Dincompatible-pointer-=
types]
>   888 |  shinfo =3D xdp_get_shared_info_from_frame(xdp_frame);
>       |         ^
> drivers/net/ethernet/freescale/enetc/enetc.c: In function =E2=80=98enetc_=
map_rx_buff_to_xdp=E2=80=99:
> drivers/net/ethernet/freescale/enetc/enetc.c:975:9: error: assignment to =
=E2=80=98struct skb_shared_info *=E2=80=99 from incompatible pointer type =
=E2=80=98struct xdp_shared_info *=E2=80=99 [-Werror=3Dincompatible-pointer-=
types]
>   975 |  shinfo =3D xdp_get_shared_info_from_buff(xdp_buff);
>       |         ^
> drivers/net/ethernet/freescale/enetc/enetc.c: In function =E2=80=98enetc_=
add_rx_buff_to_xdp=E2=80=99:
> drivers/net/ethernet/freescale/enetc/enetc.c:982:35: error: initializatio=
n of =E2=80=98struct skb_shared_info *=E2=80=99 from incompatible pointer t=
ype =E2=80=98struct xdp_shared_info *=E2=80=99 [-Werror=3Dincompatible-poin=
ter-types]
>   982 |  struct skb_shared_info *shinfo =3D xdp_get_shared_info_from_buff=
(xdp_buff);
>       |                                   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>=20

Hi Vladimir,

Ack, I will fix it in v9; enetc was not compiled on my machine, thanks for =
pointing
this out :)

Regards,
Lorenzo

--XdTjWIYUUV0Cdz8G
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCYG8SoAAKCRA6cBh0uS2t
rPEiAP4jW8692U3LmXa0+GxYqJN0tUZmtluhi82wBbyPy0pJYgD8D87Y11ATM2Eu
wzdGIhHJwIks83IBORfnle74eO4FEwE=
=eYc2
-----END PGP SIGNATURE-----

--XdTjWIYUUV0Cdz8G--

