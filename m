Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 486C7222C7C
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 22:09:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729662AbgGPUJU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 16:09:20 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:34172 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729048AbgGPUJT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jul 2020 16:09:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594930157;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ez9kSf3C99h3MbxOXeTKF0m1HHkl4jQ86xmI9lFRRtU=;
        b=I4kCBRfrradhxtkJZn26jcPlL93040oBR8MrLhGk6UoaheA1PxJUt4BmMzyrXGs3C9Jplr
        VaQGH2tYb8xnmr6DjYD0KfbCDAJhLNo1j0Xcyy7z7FCQwJiiN5/BTtLB/GPsfDZ/OWVV+f
        F6pa1qUINAwJvvnGhUbXuS6ECAJ3ZG0=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-404-Szn2kfhLOa2Zr3r1Ewbs8Q-1; Thu, 16 Jul 2020 16:09:15 -0400
X-MC-Unique: Szn2kfhLOa2Zr3r1Ewbs8Q-1
Received: by mail-wm1-f70.google.com with SMTP id c124so5356343wme.0
        for <netdev@vger.kernel.org>; Thu, 16 Jul 2020 13:09:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ez9kSf3C99h3MbxOXeTKF0m1HHkl4jQ86xmI9lFRRtU=;
        b=C5yA4024e3Djqg7GM2ou9+Nqa+kuGGwpplVkToLSEXQRO0iCoztoJZOssM+8PkOv97
         4wljqlMmTfp/zDpI6L7zwiPIT3wHQKggZTS8pZyOMW12SL6acO0VEnWmjOyoI8oJ0+tY
         Ebgt5vgT5+gITrUWSJmQkp6jW8NIn77BuNzrHDGvdpD12PfKNWwpqdlyrDI2iUldpztm
         O24e0klv0bOQE2EdIvcz1mEu9mqIMcvhctmjf28wopsi0xbGegEMEoSnTjLUot5MBRRo
         DHqfoaSKMlQlc9NeqC1N0Yh2eTzZnPH35LQ8WN4KoaistQ/N1mUN57adCeBSE8RDvCFq
         fSdQ==
X-Gm-Message-State: AOAM5335E+gMfc8HIzCv9EbGxL6mNBp0fewjSFcvUW9i5qGksrp/xqm0
        fpoJt+VEHlvDg6Kh0vSiSJR7C8LdA/1LRdYEXq4GRFywbpz82ED8qscmMji+KxX2sEWB2c2ZlRM
        2iSx2ayxoCPgJ/V9e
X-Received: by 2002:a1c:1bc4:: with SMTP id b187mr6118065wmb.105.1594930153991;
        Thu, 16 Jul 2020 13:09:13 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy0BayKJJx8tyF9sFuhtaRO6aybkj1qTN7Tatdq/i+X2iJesqBOHYObM2Z30+oiaJV+rkArbw==
X-Received: by 2002:a1c:1bc4:: with SMTP id b187mr6118044wmb.105.1594930153725;
        Thu, 16 Jul 2020 13:09:13 -0700 (PDT)
Received: from localhost ([151.48.133.17])
        by smtp.gmail.com with ESMTPSA id x18sm10820513wrq.13.2020.07.16.13.09.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jul 2020 13:09:12 -0700 (PDT)
Date:   Thu, 16 Jul 2020 22:09:09 +0200
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org,
        davem@davemloft.net, bpf@vger.kernel.org,
        ilias.apalodimas@linaro.org, brouer@redhat.com,
        echaudro@redhat.com, sameehj@amazon.com
Subject: Re: [PATCH 2/6] net: mvneta: move skb build after descriptors
 processing
Message-ID: <20200716200909.GJ2174@localhost.localdomain>
References: <cover.1594309075.git.lorenzo@kernel.org>
 <f5e95c08e22113d21e86662f1cf5ccce16ccbfca.1594309075.git.lorenzo@kernel.org>
 <20200715125844.567e5795@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20200716191251.GH2174@localhost.localdomain>
 <20200716124426.4f7c3a67@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="SLfjTIIQuAzj8yil"
Content-Disposition: inline
In-Reply-To: <20200716124426.4f7c3a67@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--SLfjTIIQuAzj8yil
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Thu, 16 Jul 2020 21:12:51 +0200 Lorenzo Bianconi wrote:
> > > > +static struct sk_buff *
> > > > +mvneta_swbm_build_skb(struct mvneta_port *pp, struct mvneta_rx_que=
ue *rxq,
> > > > +		      struct xdp_buff *xdp, u32 desc_status)
> > > > +{
> > > > +	struct skb_shared_info *sinfo =3D xdp_get_shared_info_from_buff(x=
dp);
> > > > +	int i, num_frags =3D sinfo->nr_frags;
> > > > +	skb_frag_t frags[MAX_SKB_FRAGS];
> > > > +	struct sk_buff *skb;
> > > > +
> > > > +	memcpy(frags, sinfo->frags, sizeof(skb_frag_t) * num_frags);
> > > > +
> > > > +	skb =3D build_skb(xdp->data_hard_start, PAGE_SIZE);
> > > > +	if (!skb)
> > > > +		return ERR_PTR(-ENOMEM);
> > > > +
> > > > +	page_pool_release_page(rxq->page_pool, virt_to_page(xdp->data));
> > > > +
> > > > +	skb_reserve(skb, xdp->data - xdp->data_hard_start);
> > > > +	skb_put(skb, xdp->data_end - xdp->data);
> > > > +	mvneta_rx_csum(pp, desc_status, skb);
> > > > +
> > > > +	for (i =3D 0; i < num_frags; i++) {
> > > > +		skb_add_rx_frag(skb, skb_shinfo(skb)->nr_frags,
> > > > +				frags[i].bv_page, frags[i].bv_offset,
> > > > +				skb_frag_size(&frags[i]), PAGE_SIZE);
> > > > +		page_pool_release_page(rxq->page_pool, frags[i].bv_page);
> > > > +	}
> > > > +
> > > > +	return skb;
> > > > +} =20
> > >=20
> > > Here as well - is the plan to turn more of this function into common
> > > code later on? Looks like most of this is not really driver specific.=
 =20
> >=20
> > I agree. What about adding it when other drivers will add multi-buff su=
pport?
> > (here we have even page_pool dependency)
>=20
> I guess that's okay on the condition that you're going to be the one
> adding the support to the next driver, or at least review it very
> closely to make sure it's done.

I am completely fine to work on it if I have the hw handy (or if someone el=
se
can test it) otherwise I will review the code :)

Regards,
Lorenzo

>=20
> In general vendors prove rather resistant to factoring code out,=20
> the snowflakes they feel they are.
>=20

--SLfjTIIQuAzj8yil
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCXxCz4gAKCRA6cBh0uS2t
rKYeAP9T+DbMpV8y5blKeFxebc+VsOhV9BX7DTvhxv2dTaQcPQEAz1I7ZrI8O+Ix
y1BTBeec7AxBIFs4X0hPIRHFwMYVAAs=
=xYTl
-----END PGP SIGNATURE-----

--SLfjTIIQuAzj8yil--

