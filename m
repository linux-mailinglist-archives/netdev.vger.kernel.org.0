Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81E7E2FE1D9
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 06:39:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727676AbhAUFhi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 00:37:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727395AbhAUFg0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jan 2021 00:36:26 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE07CC061799
        for <netdev@vger.kernel.org>; Wed, 20 Jan 2021 21:35:44 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id my11so4278618pjb.1
        for <netdev@vger.kernel.org>; Wed, 20 Jan 2021 21:35:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=FHfkPUjeYKhrToo3Nh9P9JPLmxhPJye9fFTgUCs7vMM=;
        b=dsusarCkuxyBFOHve/Jf03yS9sglsV3lX0Wbt6SwtqrG+d2EKq6aKhGUvu5aFtksWP
         qBISIo90Kzt2kGg88R+iaVoA91uSaddERJlI51TwGg4Y6+lyMme6h/Ky5ElBJBaS43AX
         goqGRgKFfXklcKfQug3l0Fcq2Y80qIMtrnhS6DlYRVlO+ylcmpoQP5k/JQUgsFlxeg1o
         achdjK9xvoeizWj9Uoi2cOTqqnhlJuq1wlbLube687LIRhx5K+MEu/dCTAMldA+FpdpL
         qM+1OxBhc5+1b8iAKaMvgANs3b7wwy45eZpUA1iYJ1pVQCLC0HJnqv9r4zM4WwoAcrTK
         6VVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=FHfkPUjeYKhrToo3Nh9P9JPLmxhPJye9fFTgUCs7vMM=;
        b=QU6NUYueKk+bk1GNn6oGdkwxtJfeLdrMmYOzWddk/UyNNRLyHc4/zfwdk+1pD4h3R3
         Ws3s8ad/2gsaQ9hYU/NfSWlcDgQXQe2dXxasmaCo3+t+JladFCRqe5LTEuabQBuzaMtx
         s90P+V0CClUiOZlszHik9YFD1F1vljp7W4GJ+sR5gqC2fsXdiDp6QGHw2dzjuEICXiNu
         oVA7Q4Z4F5z0LzIkKODLouEjoRilWWmeXjKnQlrD9Nn+/rnK7SnEXgeecP9JErBE+lXm
         uz6ePxQSfrGwWYg1R7SWc+OUkJAkoKejsbZ2eWrFgfvhQ+AkxRtfdXRVqQjJHpkfMjKd
         hd3A==
X-Gm-Message-State: AOAM531TQ6tEB2Ia2L7T4bxks2/ix/LiFrnfP/BJn64rC8vTgYX+HM0O
        etK52hpuwBJEPUYlkfGdFYM=
X-Google-Smtp-Source: ABdhPJyrsrlgKm0W0E5qFf6Fz4OCFJvruHCg/AGsu5+/h8QqiBJGuFYnpf9ze1C0WbZd90xGOwk0Fw==
X-Received: by 2002:a17:90b:313:: with SMTP id ay19mr6628478pjb.184.1611207344466;
        Wed, 20 Jan 2021 21:35:44 -0800 (PST)
Received: from pek-khao-d2.corp.ad.wrs.com (unknown-105-121.windriver.com. [147.11.105.121])
        by smtp.gmail.com with ESMTPSA id t8sm4002093pjm.45.2021.01.20.21.35.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jan 2021 21:35:43 -0800 (PST)
Date:   Thu, 21 Jan 2021 13:35:34 +0800
From:   Kevin Hao <haokexin@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     sundeep.lkml@gmail.com, davem@davemloft.net,
        netdev@vger.kernel.org, gakula@marvell.com, hkelam@marvell.com,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>
Subject: Re: [PATCH] Revert "octeontx2-pf: Use the napi_alloc_frag() to alloc
 the pool buffers"
Message-ID: <20210121053534.GA456120@pek-khao-d2.corp.ad.wrs.com>
References: <1611118955-13146-1-git-send-email-sundeep.lkml@gmail.com>
 <20210121042035.GA442272@pek-khao-d2.corp.ad.wrs.com>
 <20210120205914.4d382e23@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20210121050910.GB442272@pek-khao-d2.corp.ad.wrs.com>
 <20210120211320.61c612ee@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="SUOF0GtieIMvvwua"
Content-Disposition: inline
In-Reply-To: <20210120211320.61c612ee@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--SUOF0GtieIMvvwua
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 20, 2021 at 09:13:20PM -0800, Jakub Kicinski wrote:
> On Thu, 21 Jan 2021 13:09:10 +0800 Kevin Hao wrote:
> > On Wed, Jan 20, 2021 at 08:59:14PM -0800, Jakub Kicinski wrote:
> > > On Thu, 21 Jan 2021 12:20:35 +0800 Kevin Hao wrote: =20
> > > > Hmm, why not?
> > > >   buf =3D napi_alloc_frag(pool->rbsize + 128);
> > > >   buf =3D PTR_ALIGN(buf, 128); =20
> > >=20
> > > I'd keep the aligning in the driver until there are more users
> > > needing this but yes, I agree, aligning the page frag buffers=20
> > > seems like a much better fix. =20
> >=20
> > It seems that the DPAA2 driver also need this (drivers/net/ethernet/fre=
escale/dpaa2/dpaa2-eth.c):
> > 	/* Prepare the HW SGT structure */
> > 	sgt_buf_size =3D priv->tx_data_offset +
> > 		       sizeof(struct dpaa2_sg_entry) *  num_dma_bufs;
> > 	sgt_buf =3D napi_alloc_frag(sgt_buf_size + DPAA2_ETH_TX_BUF_ALIGN);
> > 	if (unlikely(!sgt_buf)) {
> > 		err =3D -ENOMEM;
> > 		goto sgt_buf_alloc_failed;
> > 	}
> > 	sgt_buf =3D PTR_ALIGN(sgt_buf, DPAA2_ETH_TX_BUF_ALIGN);
>=20
> We can fix them both up as a follow up in net-next, then?
>=20
> Let's keep the patch small and local for the fix.

OK, I will send a patch to align the buffer in the octeontx2 driver and then
introduce the napi_alloc_frag_align() for the net-next.

Thanks,
Kevin

--SUOF0GtieIMvvwua
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEHc6qFoLCZqgJD98Zk1jtMN6usXEFAmAJEqYACgkQk1jtMN6u
sXG8zwgArt49TlseQFLvfvKmtiHT9BVT4KWXsza+iLsXc1F09bBTeG8QTKeZPoYB
W+2bClcx728N/SWRWKPX9kTqGfZKh3Ynv9IJ3GnM8QqbZHOXoI5ANNx7U1JONLWx
lnw7rI2TQfuKsSKZsHmIW4Vl6MIkAs7gaeieKZYT69QosXYeblJVxKFAhFyYzif2
CORLkiphGewBk2+W0U3zVg+QDLon6eTpetqsjZOYJm2FHqIinT1d8c53b2+l5s6i
Kx+mwIdnPOGTuYlPcGaSnctLSXYrfItR+oornpTAa+ZYw4ZzH6un5OjtrjUvZBN9
c/As+Uj3OPtFTOCGM5uwZM+rirENAg==
=vQmQ
-----END PGP SIGNATURE-----

--SUOF0GtieIMvvwua--
