Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 420582DC2A5
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 16:03:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726109AbgLPPDB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 10:03:01 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:29673 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725960AbgLPPDB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Dec 2020 10:03:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608130894;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1GIMEy555LrXTK2JeKKUT47UhhinK/3sfNIlltcGZSo=;
        b=b16qIGgaisSll5YxrUFIlXXxIL87tnCAntxHHJ0JX6lPrjaCkzNK53frSaCbuVR43fWyyF
        sHD6UM6moe8cjktpzxh5PGBFSMzNFhz8dnuXiXe1Qi1rvp10gfHfaCzUTSDRaClt+zVyM6
        g5InLGllXDJzAgx6Q2KzIe37XE02h1A=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-140-L2RkS5NGO8q1c2Yc-ETLPw-1; Wed, 16 Dec 2020 10:01:31 -0500
X-MC-Unique: L2RkS5NGO8q1c2Yc-ETLPw-1
Received: by mail-ej1-f71.google.com with SMTP id q11so7464165ejd.0
        for <netdev@vger.kernel.org>; Wed, 16 Dec 2020 07:01:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1GIMEy555LrXTK2JeKKUT47UhhinK/3sfNIlltcGZSo=;
        b=c3Z7nCdYwb6ycYPNcZP9B6QiBqduA/o/k9n2iyhaUnPPgbYUieXulqOgI5OIMIJmSG
         1u6ZW9PkhMYKSUBQNdpip5bZSo6+6hTxJbt8DF5bZddVSkiMYuhpyubWYld1he/LPFZ4
         PDRs6FaHvaHrYkXnoINfGtlS0I70IPxGkLUmugD+a9MpVfzov8vNbWzCyo+wWhfyvD33
         yBSMRHT7xCnNs8OBm0xjyaF227pBBGFwTloUNtUa7z2vHR/5AcOS6eTjCOgXHtd4e9FI
         mvH35pkcoDayjaHH3yDpOx7x+1CPaKEeqETHdjgy+746/Bt6au4F607YawarFjLvlBLU
         pY9Q==
X-Gm-Message-State: AOAM530yO147jsHLq316QffNgJrKQ2wgfR2ZYbPuSPLPafbB+6R+05QL
        7Pfp6ZL56x2MKEJtTj1xZ8EDyQ2qCft4ltaFJwNdnPj2JQVgwkDPY15Cc1IDAJ9NpQ1NJL0uxDu
        W3CWKjYoKMXP7Rxcn
X-Received: by 2002:aa7:d3cc:: with SMTP id o12mr35459212edr.235.1608130890554;
        Wed, 16 Dec 2020 07:01:30 -0800 (PST)
X-Google-Smtp-Source: ABdhPJw+ppgQgQIfddDV6Qp/mkWMvLmQWfS3ZQQ8FhVeqUjKTiP+jW46IAjOjc/jdJ60Y4OhGo1OFg==
X-Received: by 2002:aa7:d3cc:: with SMTP id o12mr35459185edr.235.1608130890375;
        Wed, 16 Dec 2020 07:01:30 -0800 (PST)
Received: from localhost ([151.66.8.153])
        by smtp.gmail.com with ESMTPSA id v16sm20755452eds.64.2020.12.16.07.01.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Dec 2020 07:01:29 -0800 (PST)
Date:   Wed, 16 Dec 2020 16:01:26 +0100
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, alexander.duyck@gmail.com,
        saeed@kernel.org
Subject: Re: [PATCH v3 bpf-next 2/2] net: xdp: introduce xdp_prepare_buff
 utility routine
Message-ID: <20201216150126.GD2036@lore-desk>
References: <cover.1607794551.git.lorenzo@kernel.org>
 <71d5ae9f810c2c80f1cb09e304330be0b5ce5345.1607794552.git.lorenzo@kernel.org>
 <20201215123643.GA23785@ranger.igk.intel.com>
 <20201215134710.GB5477@lore-desk>
 <20201216095240.43867406@carbon>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="PHCdUe6m4AxPMzOu"
Content-Disposition: inline
In-Reply-To: <20201216095240.43867406@carbon>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--PHCdUe6m4AxPMzOu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Tue, 15 Dec 2020 14:47:10 +0100
> Lorenzo Bianconi <lorenzo.bianconi@redhat.com> wrote:
>=20
> > [...]
> > > >  	xdp_act =3D bpf_prog_run_xdp(xdp_prog, &xdp);
> > > > diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.c b/drivers/=
net/ethernet/intel/i40e/i40e_txrx.c
> > > > index 4dbbbd49c389..fcd1ca3343fb 100644
> > > > --- a/drivers/net/ethernet/intel/i40e/i40e_txrx.c
> > > > +++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
> > > > @@ -2393,12 +2393,12 @@ static int i40e_clean_rx_irq(struct i40e_ri=
ng *rx_ring, int budget)
> > > > =20
> > > >  		/* retrieve a buffer from the ring */
> > > >  		if (!skb) {
> > > > -			xdp.data =3D page_address(rx_buffer->page) +
> > > > -				   rx_buffer->page_offset;
> > > > -			xdp.data_meta =3D xdp.data;
> > > > -			xdp.data_hard_start =3D xdp.data -
> > > > -					      i40e_rx_offset(rx_ring);
> > > > -			xdp.data_end =3D xdp.data + size;
> > > > +			unsigned int offset =3D i40e_rx_offset(rx_ring); =20
> > >=20
> > > I now see that we could call the i40e_rx_offset() once per napi, so c=
an
> > > you pull this variable out and have it initialized a single time? App=
lies
> > > to other intel drivers as well. =20
> >
> > ack, fine. I will fix in v4.
>=20
> Be careful with the Intel drivers.  They have two modes (at compile
> time) depending on PAGE_SIZE in system.  In one of the modes (default
> one) you can place init of xdp.frame_sz outside the NAPI loop and init a
> single time.  In the other mode you cannot, and it becomes dynamic per
> packet.  Intel review this carefully, please!

ack. Actully I kept the xdp.frame_sz configuration in the NAPI loop but
an Intel review will be nice.

Regards,
Lorenzo

>=20
> --=20
> Best regards,
>   Jesper Dangaard Brouer
>   MSc.CS, Principal Kernel Engineer at Red Hat
>   LinkedIn: http://www.linkedin.com/in/brouer
>=20

--PHCdUe6m4AxPMzOu
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCX9ohQQAKCRA6cBh0uS2t
rAZBAP9K3NxFjHXswfCbUN2yMWC9FK8XWIQP6bHuS49LNRqaJwD8CXM6uGSMFKEf
qHcax5l5w1QtnYKAhJuzmyWlyHdPcAA=
=nNMV
-----END PGP SIGNATURE-----

--PHCdUe6m4AxPMzOu--

