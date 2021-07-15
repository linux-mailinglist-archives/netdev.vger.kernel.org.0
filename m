Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEB853CAFA7
	for <lists+netdev@lfdr.de>; Fri, 16 Jul 2021 01:27:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231995AbhGOXaF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Jul 2021 19:30:05 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:52166 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231849AbhGOXaD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Jul 2021 19:30:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626391628;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=w9epcCncX7pIRpKtwldnqCbWmt/pqBMs8IQPo5QzMxo=;
        b=V/ccfcrDf6GNcYcVdRsYXWYIWetw8+VRlQCDJWLumDhBsf7AOyAAXX5jAu1jhBG7tsxTyD
        2RJ3/0YQoLpnF0pbloWJkUEEIMJmNSOQ4kDhXE6fAOJhpz6ryqXRNJF3jePhWdVecekEcE
        gpRI+bIgXIJy4M0dxSokkNb6keMEd9w=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-564-BHYhZIpsNcWYxifZ40ZFiQ-1; Thu, 15 Jul 2021 19:27:07 -0400
X-MC-Unique: BHYhZIpsNcWYxifZ40ZFiQ-1
Received: by mail-ed1-f71.google.com with SMTP id p13-20020a05640210cdb029039560ff6f46so3922031edu.17
        for <netdev@vger.kernel.org>; Thu, 15 Jul 2021 16:27:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=w9epcCncX7pIRpKtwldnqCbWmt/pqBMs8IQPo5QzMxo=;
        b=qnLYYqzp3szW1qhGwKBcSn87Ra3imidPLyfmGN4FYG8BYLhUrhz8NwlKTpxw+lIycy
         u2B3GImNa3NhWN98GErQ2vwUzyNQMdlBfyXc/RB50lxPEYMs7H1GXk/QQGl/bAqN5s4N
         tVMxoRopdoRJZBEfjZfIMf4N31qlOoYIBnQM+vUwr50WvakOvByqvT8y6TtaC2xuhZ75
         x1QLD/1W8GfM/wCgaeBRAHzGgMccu3FTZ9xkYAtxVXN5uYKFPOuCHyd3SqvqlsFbmyZI
         hm9v3fzvKOq4Yv74dOpopsIPafdR7X7GtU1Npi0G9LVmW+WFFyVkBomtvMl73dOPpp72
         0DMw==
X-Gm-Message-State: AOAM532V38/Lt+Qw9O1JWsjUYxFM2xPPSSdoCLK75Vrx3Q8fAnoVT+hs
        lSVqBNzk6OJt9Qr48uqclT+WkoPojvpxtDPw+e8E+eB3NqnWZ3rRpFGcWX6SoX86pMns/qYE0XH
        qN+mkERJt5NFDrenR
X-Received: by 2002:a17:906:55cd:: with SMTP id z13mr7878567ejp.99.1626391626086;
        Thu, 15 Jul 2021 16:27:06 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxo2D82Sxy6qGjmM6T4PXF6XSGLBWA0ZKMQWB8WdNW78ZtARAsQEs5j87nnXNnNM1lYewGtVg==
X-Received: by 2002:a17:906:55cd:: with SMTP id z13mr7878538ejp.99.1626391625865;
        Thu, 15 Jul 2021 16:27:05 -0700 (PDT)
Received: from localhost (net-188-216-29-9.cust.vodafonedsl.it. [188.216.29.9])
        by smtp.gmail.com with ESMTPSA id m12sm2311265ejd.21.2021.07.15.16.27.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Jul 2021 16:27:05 -0700 (PDT)
Date:   Fri, 16 Jul 2021 01:27:01 +0200
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, alexander.duyck@gmail.com,
        brouer@redhat.com, echaudro@redhat.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, toke@redhat.com
Subject: Re: [PATCH bpf-next 2/2] net: xdp: add xdp_update_skb_shared_info
 utility routine
Message-ID: <YPDERccoAaRRlydI@lore-desk>
References: <cover.1625828537.git.lorenzo@kernel.org>
 <16f4244f5a506143f5becde501f1ecb120255b42.1625828537.git.lorenzo@kernel.org>
 <60ec8dfeb42aa_50e1d20857@john-XPS-13-9370.notmuch>
 <YOykin2acwjMjfRj@lore-desk>
 <60ef76e5d2379_5a0c12081c@john-XPS-13-9370.notmuch>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="FAWGCPAtKe2MqBX0"
Content-Disposition: inline
In-Reply-To: <60ef76e5d2379_5a0c12081c@john-XPS-13-9370.notmuch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--FAWGCPAtKe2MqBX0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> Lorenzo Bianconi wrote:
> > > Lorenzo Bianconi wrote:
> > > > Introduce xdp_update_skb_shared_info routine to update frags array
> > > > metadata from a given xdp_buffer/xdp_frame. We do not need to reset
> > > > frags array since it is already initialized by the driver.
> > > > Rely on xdp_update_skb_shared_info in mvneta driver.
> > >=20
> > > Some more context here would really help. I had to jump into the mvne=
ta
> > > driver to see what is happening.
> >=20
> > Hi John,
> >=20
> > ack, you are right. I will add more context next time. Sorry for the no=
ise.
> >=20
> > >=20
> > > So as I read this we have a loop processing the descriptor in
> > > mvneta_rx_swbm()
> > >=20
> > >  mvneta_rx_swbm()
> > >    while (rx_proc < budget && rx_proc < rx_todo) {
> > >      if (rx_status & MVNETA_RXD_FIRST_DESC) ...
> > >      else {
> > >        mvneta_swbm_add_rx_fragment()
> > >      }
> > >      ..
> > >      if (!rx_status & MVNETA_RXD_LAST_DESC)
> > >          continue;
> > >      ..
> > >      if (xdp_prog)
> > >        mvneta_run_xdp(...)
> > >    }
> > >=20
> > > roughly looking like above. First question, do you ever hit
> > > !MVNETA_RXD_LAST_DESC today? I assume this is avoided by hardware
> > > setup when XDP is enabled, otherwise _run_xdp() would be
> > > broken correct? Next question, given last descriptor bit
> > > logic whats the condition to hit the code added in this patch?
> > > wouldn't we need more than 1 descriptor and then we would
> > > skip the xdp_run... sorry lost me and its probably easier
> > > to let you give the flow vs spending an hour trying to
> > > track it down.
> >=20
> > I will point it out in the new commit log, but this is a preliminary pa=
tch for
> > xdp multi-buff support. In the current codebase xdp_update_skb_shared_i=
nfo()
> > is run just when the NIC is not running in XDP mode (please note
> > mvneta_swbm_add_rx_fragment() is run even if xdp_prog is NULL).
> > When we add xdp multi-buff support, xdp_update_skb_shared_info() will r=
un even
> > in XDP mode since we will remove the MTU constraint.
> >=20
> > In the current codebsae the following condition can occur in non-XDP mo=
de if
> > the packet is split on 3 or more descriptors (e.g. MTU 9000):
> >=20
> > if (!(rx_status & MVNETA_RXD_LAST_DESC))
> >    continue;
>=20
> But, as is there is no caller of xdp_update_skb_shared_info() so
> I think we should move the these two patches into the series with
> the multibuf support.

mvneta is currently using it building the skb in mvneta_swbm_build_skb()
running in non-xdp mode but I am fine merging this series in the
multi-buff one.

>=20
> >=20
> > >=20
> > > But, in theory as you handle a hardware discriptor you can build
> > > up a set of pages using them to create a single skb rather than a
> > > skb per descriptor. But don't we know if pfmemalloc should be
> > > done while we are building the frag list? Can't se just set it
> > > vs this for loop in xdp_update_skb_shared_info(),
> >=20
> > I added pfmemalloc code in xdp_update_skb_shared_info() in order to reu=
se it
> > for the xdp_redirect use-case (e.g. whenever we redirect a xdp multi-bu=
ff
> > in a veth or in a cpumap). I have a pending patch where I am using
> > xdp_update_skb_shared_info in __xdp_build_skb_from_frame().
>=20
> OK, but it adds an extra for loop and the related overhead. Can
> we avoid this overhead and just set it from where we first
> know we have a compound page. Or carry some bit through and
> do a simpler check,
>=20
>  if (pfmemalloc_needed) skb->pfmemalloc =3D true;
>=20
> I guess in the case here its building the skb so performance is maybe
> not as critical, but if it gets used in the redirect case then we
> shouldn't be doing unnecessary for loops.

doing so every driver will need to take care of it building the xdp_buff.
Does it work to do it since probably multi-buff is not critical for
performance?
In order to support xdp_redirect we need to save this info in
xdp_buff/xdp_frame, maybe in the flag field added in xdp multi-buff series.

>=20
> >=20
> > >=20
> > > > +	for (i =3D 0; i < nr_frags; i++) {
> > > > +		struct page *page =3D skb_frag_page(&sinfo->frags[i]);
> > > > +
> > > > +		page =3D compound_head(page);
> > > > +		if (page_is_pfmemalloc(page)) {
> > > > +			skb->pfmemalloc =3D true;
> > > > +			break;
> > > > +		}
> > > > +	}
> > > > +}
> > >=20
> > > ...
> > >=20
> > > > diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/et=
hernet/marvell/mvneta.c
> > > > index 361bc4fbe20b..abf2e50880e0 100644
> > > > --- a/drivers/net/ethernet/marvell/mvneta.c
> > > > +++ b/drivers/net/ethernet/marvell/mvneta.c
> > > > @@ -2294,18 +2294,29 @@ mvneta_swbm_add_rx_fragment(struct mvneta_p=
ort *pp,
> > > >  	rx_desc->buf_phys_addr =3D 0;
> > > > =20
> > > >  	if (data_len > 0 && xdp_sinfo->nr_frags < MAX_SKB_FRAGS) {
> > > > -		skb_frag_t *frag =3D &xdp_sinfo->frags[xdp_sinfo->nr_frags++];
> > > > +		skb_frag_t *frag =3D &xdp_sinfo->frags[xdp_sinfo->nr_frags];
> > > > =20
> > > >  		skb_frag_off_set(frag, pp->rx_offset_correction);
> > > >  		skb_frag_size_set(frag, data_len);
> > > >  		__skb_frag_set_page(frag, page);
> > > > +		/* We don't need to reset pp_recycle here. It's already set, so
> > > > +		 * just mark fragments for recycling.
> > > > +		 */
> > > > +		page_pool_store_mem_info(page, rxq->page_pool);
> > > > +
> > > > +		/* first fragment */
> > > > +		if (!xdp_sinfo->nr_frags)
> > > > +			xdp_sinfo->gso_type =3D *size;
> > >=20
> > > Would be nice to also change 'int size' -> 'unsigned int size' so the
> > > types matched. Presumably you really can't have a negative size.
> > >=20
> >=20
> > ack
> >=20
> > > Also how about giving gso_type a better name. xdp_sinfo->size maybe?
> >=20
> > I did it in this way in order to avoid adding a union in skb_shared_inf=
o.
> > What about adding an inline helper to set/get it? e.g.
>=20
> What was wrong with the union?

Alex requested to use gso_* fields already there (the union was in the prev=
ious
version I sent).

Regards,
Lorenzo

>=20
> >=20
> > static inline u32 xdp_get_data_len(struct skb_shared_info *sinfo)
> > {
> >     return sinfo->gso_type;
> > }
> >=20
> > static inline void xdp_set_data_len(struct skb_shared_info *sinfo, u32 =
datalen)
> > {
> >     sinfo->gso_type =3D datalen;
> > }
> >=20
> > Regards,
> > Lorenzo
>=20

--FAWGCPAtKe2MqBX0
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCYPDEQwAKCRA6cBh0uS2t
rDF/AQCYsZJhONbBM9aRXq4M6+nqcTk2AoqFKaghrzcowmwYwwEAzvQXsuVaDvYU
BIixs2QgtsAsvA3fwHDAjjXfOFNEWQU=
=Xa+N
-----END PGP SIGNATURE-----

--FAWGCPAtKe2MqBX0--

