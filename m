Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16D1EFE366
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 17:53:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727615AbfKOQxm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Nov 2019 11:53:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:58930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727528AbfKOQxm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 Nov 2019 11:53:42 -0500
Received: from localhost.localdomain (unknown [77.139.212.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0CE732072A;
        Fri, 15 Nov 2019 16:53:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573836821;
        bh=dhpQAd1wI7Vbx+a/v2d+VUEvfobnlGWvVpdmry/2YxQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HDThjwJXbWqRYpOKdZwTv92zMsfIcBusZBhIYcMF41Y+v0YXITVcOwGUUxswn8cVg
         VWN8hy5pnfPYPQx2ZfLVW1azfWzl7ccqLchlqOkZfSRPd6T0a2qLVnHoCyd7dC9WjI
         3hvWrsPQCeycu88jUNWFK7f5qAoMGZDC+DP3JeOI=
Date:   Fri, 15 Nov 2019 18:53:31 +0200
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        netdev@vger.kernel.org, davem@davemloft.net,
        thomas.petazzoni@bootlin.com, matteo.croce@redhat.com
Subject: Re: [PATCH net-next 2/3] net: page_pool: add the possibility to sync
 DMA memory for non-coherent devices
Message-ID: <20191115165331.GA2518@localhost.localdomain>
References: <6BF4C165-2AA2-49CC-B452-756CD0830129@gmail.com>
 <20191114185326.GA43048@PC192.168.49.172>
 <3648E256-C048-4F74-90FB-94D184B26499@gmail.com>
 <20191114204227.GA43707@PC192.168.49.172>
 <ECC7645D-082A-4590-9339-C45949E10C4D@gmail.com>
 <20191114224309.649dfacb@carbon>
 <20191115070551.GA99458@apalos.home>
 <20191115074743.GB10037@localhost.localdomain>
 <20191115080352.GA45399@PC192.168.49.172>
 <86A76A45-2CF5-46C4-A7CF-0EC3CB79944B@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="bg08WKrSYDhXBjb5"
Content-Disposition: inline
In-Reply-To: <86A76A45-2CF5-46C4-A7CF-0EC3CB79944B@gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--bg08WKrSYDhXBjb5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

[...]

> > > >=20
> > > > Okay, then i guess the flag is a better fit for this.
> > > > The only difference would be that the sync semantics will be
> > > > done on 'per
> > > > packet' basis,  instead of 'per pool', but that should be fine
> > > > for our cases.
> > >=20
> > > Ack, fine for me.
> > > Do you think when checking for PP_FLAG_DMA_SYNC_DEV we should even
> > > verify
> > > PP_FLAG_DMA_MAP? Something like:
> > >=20
> > > if ((pool->p.flags & (PP_FLAG_DMA_MAP | PP_FLAG_DMA_SYNC_DEV)) =3D=3D
> > >     (PP_FLAG_DMA_MAP | PP_FLAG_DMA_SYNC_DEV))
> > > 	page_pool_dma_sync_for_device();
> > >=20
> > > Regards,
> > > Lorenzo
> >=20
> > I think it's better to do the check once on the pool registration and
> > maybe
> > refuse to allocate the pool? Syncing without mapping doesn't really make
> > sense
>=20
> +1.

ack, will post v3 soon.

Regards,
Lorenzo

> --=20
> Jonathan

--bg08WKrSYDhXBjb5
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCXc7YCQAKCRA6cBh0uS2t
rP1DAQDRJISMz09MFKLL6wxOTw+SyetQs6N12aOZxFM1xn4NTgEAk0mFInLNmWR5
TcE7Zfwe5XUxIP641Qa7Sa00knJLFwU=
=ccg5
-----END PGP SIGNATURE-----

--bg08WKrSYDhXBjb5--
