Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1E06411181
	for <lists+netdev@lfdr.de>; Mon, 20 Sep 2021 11:01:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234554AbhITJCZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Sep 2021 05:02:25 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:41537 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231731AbhITJCY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Sep 2021 05:02:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632128457;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ju367aRX9daAFB55Pl+E11CkvQ2XuQw+N3D3dliMf0E=;
        b=g8sGNXoq2Co1QxKVElX9uPD7+bfkPFM8Lq4UexiQQ5A9vixEStFSjKL7RbfksuByPNuf4c
        OB3MQ0dp5KEMLuDHFnzWukLLTqTRGrnWeXTd/KJy61lZZZQTKv+Y1bdLSYIBU/lm4CAfiK
        Zv17zW+ikVumlUXnmuCSb/9r9ND2V8Y=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-331-NSpm71DKNIG8ij83Oh8PKQ-1; Mon, 20 Sep 2021 05:00:55 -0400
X-MC-Unique: NSpm71DKNIG8ij83Oh8PKQ-1
Received: by mail-wm1-f71.google.com with SMTP id n3-20020a7bcbc3000000b0030b68c4de38so2460317wmi.8
        for <netdev@vger.kernel.org>; Mon, 20 Sep 2021 02:00:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ju367aRX9daAFB55Pl+E11CkvQ2XuQw+N3D3dliMf0E=;
        b=rDYtAtZYm9dpnv7dyYebDmKWHMo/QCVlbFAwDmwjAFL5cuJ7vUhpDy46LbEiz40tFv
         iasWYAz3BxqUax4ZkB65cwfIFFWgz7aVCdsaBKM2Y++2pLEH+PPZ7fAnfrWP+3eWvvVP
         dq3fA3QkWh2TLxD19V5aokbLMVqViQ1+VLOC4ZPCzol69a457x8uKUuZ+zxOecn7QgxT
         sOyAOajQSmDOXeoZsDakYsv5Jyx2WfbcoeFzgOJ3gX8n45GBaTkA6dijMNmWxnTNM56e
         UF8DTrpEVc8kKFDkK6pf6FWGqLzO5WfKnMmeq6nDeH6GD1WqKEA4srtvr/RthG1+pGfU
         BDCA==
X-Gm-Message-State: AOAM531e9iKNywyXU0QQe+bAw+oI6lJgioNHPLPAumZAfNBGDfyo3eMP
        A2i2B6kEdPkBYGn3WyLZPzdS3iH51y9elejBxHkNxqxspqXbtlzWXFFIKYarvnyOxZC5j1lT9xC
        Ii6YBjhRGYpOXmLkE
X-Received: by 2002:a5d:6ca2:: with SMTP id a2mr26826209wra.291.1632128454752;
        Mon, 20 Sep 2021 02:00:54 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxNcljVIFqRYAqHd7LWRT6RWEaunVjTAB8yjK3pe7IEWKWVvNLdXBuwNOzXSVIkngtq2cCoBA==
X-Received: by 2002:a5d:6ca2:: with SMTP id a2mr26826160wra.291.1632128454511;
        Mon, 20 Sep 2021 02:00:54 -0700 (PDT)
Received: from localhost (net-130-25-199-50.cust.vodafonedsl.it. [130.25.199.50])
        by smtp.gmail.com with ESMTPSA id h18sm14969558wrb.33.2021.09.20.02.00.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Sep 2021 02:00:54 -0700 (PDT)
Date:   Mon, 20 Sep 2021 11:00:52 +0200
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Shay Agroskin <shayagr@amazon.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, john.fastabend@gmail.com,
        dsahern@kernel.org, brouer@redhat.com, echaudro@redhat.com,
        jasowang@redhat.com, alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, toke@redhat.com
Subject: Re: [PATCH v14 bpf-next 03/18] net: mvneta: update mb bit before
 passing the xdp buffer to eBPF layer
Message-ID: <YUhNxKE3bde3MbVl@lore-desk>
References: <cover.1631289870.git.lorenzo@kernel.org>
 <f11d8399e17bc82f9ffcb613da0a457a96f56fec.1631289870.git.lorenzo@kernel.org>
 <pj41zlh7ef8xgt.fsf@u570694869fb251.ant.amazon.com>
 <YUhIQEIJxLRPpaRP@lore-desk>
 <pj41zlee9j8wkf.fsf@u570694869fb251.ant.amazon.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="Tvov7bkZFn1T08h3"
Content-Disposition: inline
In-Reply-To: <pj41zlee9j8wkf.fsf@u570694869fb251.ant.amazon.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--Tvov7bkZFn1T08h3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

>=20
> Lorenzo Bianconi <lorenzo.bianconi@redhat.com> writes:
>=20
> > >=20
> > > Lorenzo Bianconi <lorenzo@kernel.org> writes:
> > >=20
> > > > ...
> > > > diff --git a/drivers/net/ethernet/marvell/mvneta.c
> > > > b/drivers/net/ethernet/marvell/mvneta.c
> > > > index 9d460a270601..0c7b84ca6efc 100644
> > > > --- a/drivers/net/ethernet/marvell/mvneta.c
> > > > +++ b/drivers/net/ethernet/marvell/mvneta.c
> > > > ...
> > > > @@ -2320,8 +2325,12 @@ mvneta_swbm_build_skb(struct > mvneta_port
> > > *pp,
> > > > struct page_pool *pool,
> > > >  		      struct xdp_buff *xdp, u32 desc_status)
> > > >  {
> > > >  	struct skb_shared_info *sinfo =3D >
> > > xdp_get_shared_info_from_buff(xdp);
> > > > -	int i, num_frags =3D sinfo->nr_frags;
> > > >  	struct sk_buff *skb;
> > > > +	u8 num_frags;
> > > > +	int i;
> > > > +
> > > > +	if (unlikely(xdp_buff_is_mb(xdp)))
> > > > +		num_frags =3D sinfo->nr_frags;
> > >=20
> > > Hi,
> > > nit, it seems that the num_frags assignment can be moved after the
> > > other
> > > 'if' condition you added (right before the 'for' for num_frags), or
> > > even be
> > > eliminated completely so that sinfo->nr_frags is used directly.
> > > Either way it looks like you can remove one 'if'.
> > >=20
> > > Shay
> >=20
> > Hi Shay,
> >=20
> > we can't move nr_frags assignement after build_skb() since this field
> > will be
> > overwritten by that call.
> >=20
> > Regards,
> > Lorenzo
> >=20
>=20
> Sorry, silly mistake of me.
>=20
> Guess this assignment can be done anyway since there doesn't seem to be n=
ew
> cache misses introduced by it.
> Anyway, nice catch, sorry for misleading you

actually we probably have a cache miss in this case for the single-buffer u=
se case
since skb_shared_info will not be in the same cache-line.

Regards,
Lorenzo

>=20
> > >=20
> > > >  	skb =3D build_skb(xdp->data_hard_start, PAGE_SIZE);
> > > >  	if (!skb)
> > > > @@ -2333,6 +2342,9 @@ mvneta_swbm_build_skb(struct > mvneta_port
> > > *pp,
> > > > struct page_pool *pool,
> > > >  	skb_put(skb, xdp->data_end - xdp->data);
> > > >  	skb->ip_summed =3D mvneta_rx_csum(pp, desc_status);
> > > > +	if (likely(!xdp_buff_is_mb(xdp)))
> > > > +		goto out;
> > > > +
> > > >  	for (i =3D 0; i < num_frags; i++) {
> > > >  		skb_frag_t *frag =3D &sinfo->frags[i];
> > > >   @@ -2341,6 +2353,7 @@ mvneta_swbm_build_skb(struct >
> > > mvneta_port *pp,
> > > > struct page_pool *pool,
> > > >  				skb_frag_size(frag), PAGE_SIZE);
> > > >  	}
> > > > +out:
> > > >  	return skb;
> > > >  }
> > >=20
>=20

--Tvov7bkZFn1T08h3
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCYUhNxAAKCRA6cBh0uS2t
rIGCAQCakzPGt+lCzTB99QrjLZqskd6wxv2K/et0+2lpidBr7AEAvzAzE9ZRJbxt
om6PYHwYYWa/iCuuxSLUiNa/vAJ9NQA=
=skGR
-----END PGP SIGNATURE-----

--Tvov7bkZFn1T08h3--

