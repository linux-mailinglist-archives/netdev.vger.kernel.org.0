Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 288303C64E2
	for <lists+netdev@lfdr.de>; Mon, 12 Jul 2021 22:22:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235032AbhGLUZb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Jul 2021 16:25:31 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:26775 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230284AbhGLUZb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Jul 2021 16:25:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626121361;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=QLVajR1p0RtrxcjNuIlLy6HV0BPtmRAaoUU0t0wKSj8=;
        b=BwSkLvngTDuEQNXFLFdaMPC2P1UdcWie5ciMIUGd83sJsLB8uIMwx1VCMUtUjBiISTWaoE
        jJAdY+EeY9VDhzpE/gvdQc4ICI1jrucA+mlQqXrQsFDNMJExfLnNLC3wV4DX8eiDTsj0oM
        kIFJk8KCs5i7VFfwcUxwHzGaLJwd1do=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-21-bq76HKbgNduNhW5JtKmh3g-1; Mon, 12 Jul 2021 16:22:40 -0400
X-MC-Unique: bq76HKbgNduNhW5JtKmh3g-1
Received: by mail-ed1-f69.google.com with SMTP id s6-20020a0564020146b029039578926b8cso10727372edu.20
        for <netdev@vger.kernel.org>; Mon, 12 Jul 2021 13:22:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=QLVajR1p0RtrxcjNuIlLy6HV0BPtmRAaoUU0t0wKSj8=;
        b=nOAw+y/XwyRHR6SCKJWB7DlaqI2EVPO0eIfkS2DggLHKOtZWx166X8IvVQVXkYdrgq
         0mbmDuO7zV9LCveaM1YX01pzolR03eXqFlN+6y03S2Qmp4w3Wngcu7APAB43kuupwv6H
         miiumqP58MreFWWDtsLh6X9NpWxHoY+gTZ9Dq4L0VEBLegozUjGHafJZoDiIoJiTttlZ
         /vObarhgGBUh0ZKPKkpTCyFjwULcld6WSpaDUp0/IaGYwJKDBVK2irAE10wLIC6YixJL
         ink3XRhzWIy/jYKAE1CttiTao8ssFv0lz1LDk1x5fuHWdNMiZ8BZobTNreejsNKjlmO8
         7s9g==
X-Gm-Message-State: AOAM5320ofFoNMP3sMo8xFI4VnRXZ3sTMJbEZJNd8M4gkwWlBfLzVGLF
        NchkKo/zwvOy/CtYLw9QIKN6dog1VF1L5draTIpzwkAGrb5O6qyE7Ete5Th48KCVyjYtJ5kldsn
        lWi6vlrIUHuBaDoUC
X-Received: by 2002:a05:6402:3481:: with SMTP id v1mr802358edc.235.1626121359123;
        Mon, 12 Jul 2021 13:22:39 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyqEXqlAY4g3B27LW7S0tQ+Fm1et1P2D+DhGlhmCGcYwwhpKPtMDCX8rdwfPUhnx5QACKfhIg==
X-Received: by 2002:a05:6402:3481:: with SMTP id v1mr802341edc.235.1626121358872;
        Mon, 12 Jul 2021 13:22:38 -0700 (PDT)
Received: from localhost (net-188-216-29-9.cust.vodafonedsl.it. [188.216.29.9])
        by smtp.gmail.com with ESMTPSA id q9sm6976661ejf.70.2021.07.12.13.22.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jul 2021 13:22:38 -0700 (PDT)
Date:   Mon, 12 Jul 2021 22:22:34 +0200
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, alexander.duyck@gmail.com,
        brouer@redhat.com, echaudro@redhat.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, toke@redhat.com
Subject: Re: [PATCH bpf-next 2/2] net: xdp: add xdp_update_skb_shared_info
 utility routine
Message-ID: <YOykin2acwjMjfRj@lore-desk>
References: <cover.1625828537.git.lorenzo@kernel.org>
 <16f4244f5a506143f5becde501f1ecb120255b42.1625828537.git.lorenzo@kernel.org>
 <60ec8dfeb42aa_50e1d20857@john-XPS-13-9370.notmuch>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="Zn+z8MWS16IBtto7"
Content-Disposition: inline
In-Reply-To: <60ec8dfeb42aa_50e1d20857@john-XPS-13-9370.notmuch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--Zn+z8MWS16IBtto7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> Lorenzo Bianconi wrote:
> > Introduce xdp_update_skb_shared_info routine to update frags array
> > metadata from a given xdp_buffer/xdp_frame. We do not need to reset
> > frags array since it is already initialized by the driver.
> > Rely on xdp_update_skb_shared_info in mvneta driver.
>=20
> Some more context here would really help. I had to jump into the mvneta
> driver to see what is happening.

Hi John,

ack, you are right. I will add more context next time. Sorry for the noise.

>=20
> So as I read this we have a loop processing the descriptor in
> mvneta_rx_swbm()
>=20
>  mvneta_rx_swbm()
>    while (rx_proc < budget && rx_proc < rx_todo) {
>      if (rx_status & MVNETA_RXD_FIRST_DESC) ...
>      else {
>        mvneta_swbm_add_rx_fragment()
>      }
>      ..
>      if (!rx_status & MVNETA_RXD_LAST_DESC)
>          continue;
>      ..
>      if (xdp_prog)
>        mvneta_run_xdp(...)
>    }
>=20
> roughly looking like above. First question, do you ever hit
> !MVNETA_RXD_LAST_DESC today? I assume this is avoided by hardware
> setup when XDP is enabled, otherwise _run_xdp() would be
> broken correct? Next question, given last descriptor bit
> logic whats the condition to hit the code added in this patch?
> wouldn't we need more than 1 descriptor and then we would
> skip the xdp_run... sorry lost me and its probably easier
> to let you give the flow vs spending an hour trying to
> track it down.

I will point it out in the new commit log, but this is a preliminary patch =
for
xdp multi-buff support. In the current codebase xdp_update_skb_shared_info()
is run just when the NIC is not running in XDP mode (please note
mvneta_swbm_add_rx_fragment() is run even if xdp_prog is NULL).
When we add xdp multi-buff support, xdp_update_skb_shared_info() will run e=
ven
in XDP mode since we will remove the MTU constraint.

In the current codebsae the following condition can occur in non-XDP mode if
the packet is split on 3 or more descriptors (e.g. MTU 9000):

if (!(rx_status & MVNETA_RXD_LAST_DESC))
   continue;

>=20
> But, in theory as you handle a hardware discriptor you can build
> up a set of pages using them to create a single skb rather than a
> skb per descriptor. But don't we know if pfmemalloc should be
> done while we are building the frag list? Can't se just set it
> vs this for loop in xdp_update_skb_shared_info(),

I added pfmemalloc code in xdp_update_skb_shared_info() in order to reuse it
for the xdp_redirect use-case (e.g. whenever we redirect a xdp multi-buff
in a veth or in a cpumap). I have a pending patch where I am using
xdp_update_skb_shared_info in __xdp_build_skb_from_frame().

>=20
> > +	for (i =3D 0; i < nr_frags; i++) {
> > +		struct page *page =3D skb_frag_page(&sinfo->frags[i]);
> > +
> > +		page =3D compound_head(page);
> > +		if (page_is_pfmemalloc(page)) {
> > +			skb->pfmemalloc =3D true;
> > +			break;
> > +		}
> > +	}
> > +}
>=20
> ...
>=20
> > diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethern=
et/marvell/mvneta.c
> > index 361bc4fbe20b..abf2e50880e0 100644
> > --- a/drivers/net/ethernet/marvell/mvneta.c
> > +++ b/drivers/net/ethernet/marvell/mvneta.c
> > @@ -2294,18 +2294,29 @@ mvneta_swbm_add_rx_fragment(struct mvneta_port =
*pp,
> >  	rx_desc->buf_phys_addr =3D 0;
> > =20
> >  	if (data_len > 0 && xdp_sinfo->nr_frags < MAX_SKB_FRAGS) {
> > -		skb_frag_t *frag =3D &xdp_sinfo->frags[xdp_sinfo->nr_frags++];
> > +		skb_frag_t *frag =3D &xdp_sinfo->frags[xdp_sinfo->nr_frags];
> > =20
> >  		skb_frag_off_set(frag, pp->rx_offset_correction);
> >  		skb_frag_size_set(frag, data_len);
> >  		__skb_frag_set_page(frag, page);
> > +		/* We don't need to reset pp_recycle here. It's already set, so
> > +		 * just mark fragments for recycling.
> > +		 */
> > +		page_pool_store_mem_info(page, rxq->page_pool);
> > +
> > +		/* first fragment */
> > +		if (!xdp_sinfo->nr_frags)
> > +			xdp_sinfo->gso_type =3D *size;
>=20
> Would be nice to also change 'int size' -> 'unsigned int size' so the
> types matched. Presumably you really can't have a negative size.
>=20

ack

> Also how about giving gso_type a better name. xdp_sinfo->size maybe?

I did it in this way in order to avoid adding a union in skb_shared_info.
What about adding an inline helper to set/get it? e.g.

static inline u32 xdp_get_data_len(struct skb_shared_info *sinfo)
{
    return sinfo->gso_type;
}

static inline void xdp_set_data_len(struct skb_shared_info *sinfo, u32 data=
len)
{
    sinfo->gso_type =3D datalen;
}

Regards,
Lorenzo

>=20
>=20
> > +		xdp_sinfo->nr_frags++;
> > =20
> >  		/* last fragment */
> >  		if (len =3D=3D *size) {
> >  			struct skb_shared_info *sinfo;
> > =20
> >  			sinfo =3D xdp_get_shared_info_from_buff(xdp);
> > +			sinfo->xdp_frags_tsize =3D xdp_sinfo->nr_frags * PAGE_SIZE;
> >  			sinfo->nr_frags =3D xdp_sinfo->nr_frags;
> > +			sinfo->gso_type =3D xdp_sinfo->gso_type;
> >  			memcpy(sinfo->frags, xdp_sinfo->frags,
> >  			       sinfo->nr_frags * sizeof(skb_frag_t));
> >  		}
>=20
> Thanks,
> John
>=20

--Zn+z8MWS16IBtto7
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCYOykiAAKCRA6cBh0uS2t
rEE8APwNM04D/W+zHhHwuPtCDbsKIY77qSQYWFUXZWRQ0Ji0zAD6AlzHnSol1aA9
KGjvchrxRBy/2W1QMWBoJdC27cCbPA4=
=JMAG
-----END PGP SIGNATURE-----

--Zn+z8MWS16IBtto7--

