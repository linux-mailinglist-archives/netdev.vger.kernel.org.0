Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 386E9469B7D
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 16:14:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347146AbhLFPRk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 10:17:40 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:55863 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1347364AbhLFPOp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 10:14:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638803471;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=I8YVfdsVmuWFyLTwXYbNGyLU3lEs0YzOVf+e12QlznI=;
        b=Yg87Z3uCBWG42kdyedP07glpxn69W3QxdH47aHmQFQg4O1yERVxjFxsxthJYZxjue3Y4yE
        xzbZlfxDV6Rniza4itRAc8wnYFSwdEsQjOVnxR/77jVeIwPj4H64NU0o9//aqA2ASI7L+P
        lob3ry0Zirv0mEKfW+6+BJ7Km8vNlCo=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-122-LdTKNJNpMVaCeZD4WsAxMA-1; Mon, 06 Dec 2021 10:11:10 -0500
X-MC-Unique: LdTKNJNpMVaCeZD4WsAxMA-1
Received: by mail-wm1-f70.google.com with SMTP id m14-20020a05600c3b0e00b0033308dcc933so34075wms.7
        for <netdev@vger.kernel.org>; Mon, 06 Dec 2021 07:11:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=I8YVfdsVmuWFyLTwXYbNGyLU3lEs0YzOVf+e12QlznI=;
        b=BFSkponYWDvJ+UX3ns+dO+WuI+nZAIQBIXFUOU4W23LkIshGW3e2lxzN26Sx6X491f
         65+9GtrjT6mPAECH2CDq6qRnnxDsTd5N8n2rTbqYiLtSmcIAQoFPWGIC+zcB85RloWeB
         nZSlUTnZUD5v6l1jrD9rmb3BT0OdgUxlM02Ez/UZCd2e1eAYWN6vB7synLY4n2r/pLeN
         xLeryARu21tFaP2uOmdosrKfSF0gdeICkcE7o3Q6ADngyH7pnkfYq6vw+TvB9aYmcON5
         ZOyhQ27Rze1hv7Uyj0DsvuG4iN0YD1HwPDcmDQIaSZQSZ3HsP/ZO+IN3iPeXN7JoM2FH
         Cyww==
X-Gm-Message-State: AOAM532rEztwlqFlIF8pDLO76aiEOWZpsr5Nyr410OXrgyKco6NA624R
        90jwOOX29TD9lG6FYuSfjS2kfZsg3xcaypfgh8Tjy8IA/Tc3GKGONEqkv4CR+SO40lH6NR3DQZh
        ZARTI3puHIEeLV/G/
X-Received: by 2002:a5d:4b06:: with SMTP id v6mr43958079wrq.194.1638803468850;
        Mon, 06 Dec 2021 07:11:08 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxHmPtlb6i24RSULyO8F8snPKQnyrJ8mLFAu6nVynyOYjz4anUxoe3aA4azwqGWtWAr2wuDxA==
X-Received: by 2002:a5d:4b06:: with SMTP id v6mr43958045wrq.194.1638803468689;
        Mon, 06 Dec 2021 07:11:08 -0800 (PST)
Received: from localhost (net-37-182-17-175.cust.vodafonedsl.it. [37.182.17.175])
        by smtp.gmail.com with ESMTPSA id t11sm11906945wrz.97.2021.12.06.07.11.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Dec 2021 07:11:08 -0800 (PST)
Date:   Mon, 6 Dec 2021 16:11:06 +0100
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        dsahern@kernel.org, brouer@redhat.com, echaudro@redhat.com,
        jasowang@redhat.com, alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, toke@redhat.com
Subject: Re: [PATCH v19 bpf-next 03/23] net: mvneta: update mb bit before
 passing the xdp buffer to eBPF layer
Message-ID: <Ya4oCkbOjBHFOHyS@lore-desk>
References: <cover.1638272238.git.lorenzo@kernel.org>
 <95151f4b8a25ce38243e82f0a82104d0f46fb33a.1638272238.git.lorenzo@kernel.org>
 <61ad7e4cbc69d_444e20888@john.notmuch>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="S7WehjOHIu6+ZNCa"
Content-Disposition: inline
In-Reply-To: <61ad7e4cbc69d_444e20888@john.notmuch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--S7WehjOHIu6+ZNCa
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> Lorenzo Bianconi wrote:
> > Update multi-buffer bit (mb) in xdp_buff to notify XDP/eBPF layer and
> > XDP remote drivers if this is a "non-linear" XDP buffer. Access
> > skb_shared_info only if xdp_buff mb is set in order to avoid possible
> > cache-misses.
> >=20
> > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
>=20
> [...]
>=20
> > @@ -2320,8 +2325,12 @@ mvneta_swbm_build_skb(struct mvneta_port *pp, st=
ruct page_pool *pool,
> >  		      struct xdp_buff *xdp, u32 desc_status)
> >  {
> >  	struct skb_shared_info *sinfo =3D xdp_get_shared_info_from_buff(xdp);
> > -	int i, num_frags =3D sinfo->nr_frags;
> >  	struct sk_buff *skb;
> > +	u8 num_frags;
> > +	int i;
> > +
> > +	if (unlikely(xdp_buff_is_mb(xdp)))
> > +		num_frags =3D sinfo->nr_frags;
>=20
> Doesn't really need a respin IMO, but rather an observation. Its not
> obvious to me the unlikely/likely pair here is wanted. Seems it could
> be relatively common for some applications sending jumbo frames.
>=20
> Maybe worth some experimenting in the future.

Probably for mvneta it will not make any difference but in general I tried =
to
avoid possible cache-misses here (accessing sinfo pointers). I will carry o=
ut
some comparison to see if I can simplify the code.

Regards,
Lorenzo

>=20
> > =20
> >  	skb =3D build_skb(xdp->data_hard_start, PAGE_SIZE);
> >  	if (!skb)
> > @@ -2333,6 +2342,9 @@ mvneta_swbm_build_skb(struct mvneta_port *pp, str=
uct page_pool *pool,
> >  	skb_put(skb, xdp->data_end - xdp->data);
> >  	skb->ip_summed =3D mvneta_rx_csum(pp, desc_status);
> > =20
> > +	if (likely(!xdp_buff_is_mb(xdp)))
> > +		goto out;
> > +
> >  	for (i =3D 0; i < num_frags; i++) {
> >  		skb_frag_t *frag =3D &sinfo->frags[i];
>=20

--S7WehjOHIu6+ZNCa
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCYa4oCgAKCRA6cBh0uS2t
rLqjAP9t3XmU/u/EawcvBisua/InTVuCECfa4euaDMInORkC9AEAh5gKETMpz8xF
6x5+vxGNkdNsvJdJ0Zk3mr8KCcCOtQg=
=Fm4y
-----END PGP SIGNATURE-----

--S7WehjOHIu6+ZNCa--

