Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8201746A59D
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 20:24:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234018AbhLFT1s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 14:27:48 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:30933 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244157AbhLFT1r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 14:27:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638818657;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=S3rsO42uHxO9mNNGJSnr2GiWnzfE46YS1E4UgACqwYA=;
        b=CcTfE3iK62tbQzghHpeKCz9u/G2evUZFojwXY4VSJWVUnpGDnW9uwHrv3/EsJgOIE/zuuO
        hDT7C6fl9khDpOcvHWIEElJXYSQlQaSxDN1fNx8wI7ZxlVsmbq0yYaMuw/FYVmYFlAdWxl
        56ITUIjbfJMTLQh4ms7q63yCkRycAuw=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-402-yMAFvkkNO8G8utk8gEdEYA-1; Mon, 06 Dec 2021 14:24:16 -0500
X-MC-Unique: yMAFvkkNO8G8utk8gEdEYA-1
Received: by mail-wr1-f70.google.com with SMTP id d18-20020adfe852000000b001985d36817cso2276616wrn.13
        for <netdev@vger.kernel.org>; Mon, 06 Dec 2021 11:24:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=S3rsO42uHxO9mNNGJSnr2GiWnzfE46YS1E4UgACqwYA=;
        b=48eHBlRyV2wBneadcNRb8b++7R/PSLF/6pdj3P7rsUQ3XDvyCpU9MTAUqECitln1uj
         dKywtJvbDHaigA4Zpxj9AgQU61tsCxmLCECFWrYfAehi4tykrNJotTpAT9sDq8jJTQSX
         a4yKl0GmIClizincinoXnEb+X2Ac6rIFXWmOKrEOfdmIL9ObFj1dOtsKRW3rEkNYc4in
         L39v26sMLfoyEjvoU6l9mB7asnxtJsl/86ikTlzJKhpE26PhfKjbDh36Z6iDmkV07ueg
         u6bf8rrktMENA8DJOhN/7fmZ5cnMx/jNba6i7bx6c+uDnmq0gqMvRW04j8SSD+a2sXiD
         YqqA==
X-Gm-Message-State: AOAM5332eM56FvdvvQvwSkAKXPy2/BxDrSxnoQ1B3OiCzoPXEIbuA6qc
        xBQJ1IYyV0rDmHmfrwkJokScoxuwwWLj0Kt9Fx3QXWfmrg+YABZbdJqcluLy9AXexVDwDYjv2nx
        8I7B57222k6ne00Uk
X-Received: by 2002:adf:df89:: with SMTP id z9mr44888560wrl.336.1638818655369;
        Mon, 06 Dec 2021 11:24:15 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxkykkLv6o5dlmxLy6TABKOGT4fSijPZX62+4gZUbqIgsOj+57hhPoOPtVAVvSCg8C2puncXQ==
X-Received: by 2002:adf:df89:: with SMTP id z9mr44888543wrl.336.1638818655167;
        Mon, 06 Dec 2021 11:24:15 -0800 (PST)
Received: from localhost (net-37-182-17-175.cust.vodafonedsl.it. [37.182.17.175])
        by smtp.gmail.com with ESMTPSA id z5sm322570wmp.26.2021.12.06.11.24.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Dec 2021 11:24:14 -0800 (PST)
Date:   Mon, 6 Dec 2021 20:24:12 +0100
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Jesper Dangaard Brouer <jbrouer@redhat.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, brouer@redhat.com, davem@davemloft.net,
        kuba@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        shayagr@amazon.com, john.fastabend@gmail.com, dsahern@kernel.org,
        echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, toke@redhat.com
Subject: Re: [PATCH v19 bpf-next 23/23] xdp: disable XDP_REDIRECT for xdp
 multi-buff
Message-ID: <Ya5jXHfwQltzCUns@lore-desk>
References: <cover.1638272238.git.lorenzo@kernel.org>
 <df855fe05b80746fa7f657fce78b24d582f133cb.1638272239.git.lorenzo@kernel.org>
 <88f9b4e9-9074-a507-426d-7c947f1e2b13@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="xMO+1iV3FO7CJ/V+"
Content-Disposition: inline
In-Reply-To: <88f9b4e9-9074-a507-426d-7c947f1e2b13@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--xMO+1iV3FO7CJ/V+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On 30/11/2021 12.53, Lorenzo Bianconi wrote:
> > XDP_REDIRECT is not fully supported yet for xdp multi-buff since not
> > all XDP capable drivers can map non-linear xdp_frame in ndo_xdp_xmit
> > so disable it for the moment.
> >=20
> > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > ---
> >   net/core/filter.c | 7 +++++++
> >   1 file changed, 7 insertions(+)
> >=20
> > diff --git a/net/core/filter.c b/net/core/filter.c
> > index b70725313442..a87d835d1122 100644
> > --- a/net/core/filter.c
> > +++ b/net/core/filter.c
> > @@ -4189,6 +4189,13 @@ int xdp_do_redirect(struct net_device *dev, stru=
ct xdp_buff *xdp,
> >   	struct bpf_map *map;
> >   	int err;
> > +	/* XDP_REDIRECT is not fully supported yet for xdp multi-buff since
> > +	 * not all XDP capable drivers can map non-linear xdp_frame in
> > +	 * ndo_xdp_xmit.
> > +	 */
> > +	if (unlikely(xdp_buff_is_mb(xdp)))
> > +		return -EOPNOTSUPP;
> > +
>=20
> This approach also exclude 'cpumap' use-case, which you AFAIK have added =
MB
> support for in this patchset.

ack, right. We can exclude CPUMAPs here.

>=20
> Generally this check is hopefully something we can remove again, once
> drivers add MB ndo_xdp_xmit support.

right.

Regards,
Lorenzo

>=20
>=20
> >   	ri->map_id =3D 0; /* Valid map id idr range: [1,INT_MAX[ */
> >   	ri->map_type =3D BPF_MAP_TYPE_UNSPEC;
> >=20
>=20

--xMO+1iV3FO7CJ/V+
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCYa5jXAAKCRA6cBh0uS2t
rNe0AP453sRneFopaL4JgS2CYBt61jkitTgmCgWwV+6FxiqDogD/WR821V1zz0zS
buRHjHLZY/SErVp+4xvt3vcEuKLlkA8=
=5Yr3
-----END PGP SIGNATURE-----

--xMO+1iV3FO7CJ/V+--

