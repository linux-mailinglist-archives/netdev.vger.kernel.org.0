Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 730412D2979
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 12:06:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729092AbgLHLDB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 06:03:01 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:52759 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728679AbgLHLDA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Dec 2020 06:03:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607425293;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=r6tl16/T16Owlv0b8ZYHHxKv6uyIto/4HnR46qZYsk0=;
        b=Qmh9gb0ZOYlEd8FxZyzh82oY1lZXC5w/I8fmDQTj0DDyFMbI+bw2/6+YgotFCD0S0H3rWy
        bMJlPG0GTz2W4tVjPbNXHPSvFCu8tygUYCSzmRmvjaLgd7LS1S5wG5YtSDVjqB4sD6rhF7
        fgWn80QxUzFlVVHvmd/mz2wJPoJtRWY=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-320-OY49W_dfPiGMH3cJ0HLBMA-1; Tue, 08 Dec 2020 06:01:30 -0500
X-MC-Unique: OY49W_dfPiGMH3cJ0HLBMA-1
Received: by mail-ed1-f70.google.com with SMTP id u18so7250736edy.5
        for <netdev@vger.kernel.org>; Tue, 08 Dec 2020 03:01:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=r6tl16/T16Owlv0b8ZYHHxKv6uyIto/4HnR46qZYsk0=;
        b=gRIGrxdqOgeinsJLti1h0KaZFocXLUTTkVt9Exm1ZLdDXHNURyLSH/NARW7Iqwd1LE
         66/SnUCOE9vvQrNSqvOvXi8dJIF8VEUHB8gY/Yl0DUVCJU7/LPMWsLRXtbtQpIcxJLgI
         oCj3QWL7QadD7bwWkY8Xul/OSBs/RTZTj0D6NadlA63tNp/nhexnRU4PDn7Nod3MqxYZ
         EpaHRmAHW9i5pk1mKq7JMTBSiM4mssBYo0aEzUvY6fIfVy+3pD2iPeBaOh6Xqc14Xvnl
         2eLn45kIlVlRP5tHftbnEeH+MUjDTXKktC1xdD/UO1Z1y67Wgs3HMaTUkrzxrI3ZTyHU
         JKKw==
X-Gm-Message-State: AOAM532Gez/sUAjsyMyiH73LCeq17GhOF7Kwi3vpjj5QuMvtHUWIr0eC
        fIXcNe1op5yUuLgHCukt2uYzok6qXcx4QTq7NNK+W6js0OO60IVbpFQiImSm1N1+tspTtuM+Yjf
        vwPUJV+nrlZZLGdWD
X-Received: by 2002:a05:6402:310f:: with SMTP id dc15mr24041781edb.225.1607425289353;
        Tue, 08 Dec 2020 03:01:29 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwG4xlw7b582cpOp3fjUAZztoSrppVXSJKEEsCz8sh/46t8pLvfLddlMNUSqz1aJ1q4xaEuPQ==
X-Received: by 2002:a05:6402:310f:: with SMTP id dc15mr24041759edb.225.1607425289001;
        Tue, 08 Dec 2020 03:01:29 -0800 (PST)
Received: from localhost ([151.66.8.153])
        by smtp.gmail.com with ESMTPSA id b14sm16450265edm.68.2020.12.08.03.01.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Dec 2020 03:01:28 -0800 (PST)
Date:   Tue, 8 Dec 2020 12:01:25 +0100
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        sameehj@amazon.com, john.fastabend@gmail.com, dsahern@kernel.org,
        brouer@redhat.com, echaudro@redhat.com, jasowang@redhat.com
Subject: Re: [PATCH v5 bpf-next 03/14] xdp: add xdp_shared_info data structure
Message-ID: <20201208110125.GC36228@lore-desk>
References: <cover.1607349924.git.lorenzo@kernel.org>
 <21d27f233e37b66c9ad4073dd09df5c2904112a4.1607349924.git.lorenzo@kernel.org>
 <5465830698257f18ae474877648f4a9fe2e1eefe.camel@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="eRtJSFbw+EEWtPj3"
Content-Disposition: inline
In-Reply-To: <5465830698257f18ae474877648f4a9fe2e1eefe.camel@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--eRtJSFbw+EEWtPj3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Mon, 2020-12-07 at 17:32 +0100, Lorenzo Bianconi wrote:
> > Introduce xdp_shared_info data structure to contain info about
> > "non-linear" xdp frame. xdp_shared_info will alias skb_shared_info
> > allowing to keep most of the frags in the same cache-line.
> > Introduce some xdp_shared_info helpers aligned to skb_frag* ones
> >=20
>=20
> is there or will be a more general purpose use to this xdp_shared_info
> ? other than hosting frags ?

I do not have other use-cases at the moment other than multi-buff but in
theory it is possible I guess.
The reason we introduced it is to have most of the frags in the first
shared_info cache-line to avoid cache-misses.

>=20
> > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > ---
> >  drivers/net/ethernet/marvell/mvneta.c | 62 +++++++++++++++--------
> > ----
> >  include/net/xdp.h                     | 52 ++++++++++++++++++++--
> >  2 files changed, 82 insertions(+), 32 deletions(-)
> >=20
> > diff --git a/drivers/net/ethernet/marvell/mvneta.c
> > b/drivers/net/ethernet/marvell/mvneta.c
> > index 1e5b5c69685a..d635463609ad 100644
> > --- a/drivers/net/ethernet/marvell/mvneta.c
> > +++ b/drivers/net/ethernet/marvell/mvneta.c
> > @@ -2033,14 +2033,17 @@ int mvneta_rx_refill_queue(struct mvneta_port
> > *pp, struct mvneta_rx_queue *rxq)
> > =20
>=20
> [...]
>=20
> >  static void
> > @@ -2278,7 +2281,7 @@ mvneta_swbm_add_rx_fragment(struct mvneta_port
> > *pp,
> >  			    struct mvneta_rx_desc *rx_desc,
> >  			    struct mvneta_rx_queue *rxq,
> >  			    struct xdp_buff *xdp, int *size,
> > -			    struct skb_shared_info *xdp_sinfo,
> > +			    struct xdp_shared_info *xdp_sinfo,
> >  			    struct page *page)
> >  {
> >  	struct net_device *dev =3D pp->dev;
> > @@ -2301,13 +2304,13 @@ mvneta_swbm_add_rx_fragment(struct
> > mvneta_port *pp,
> >  	if (data_len > 0 && xdp_sinfo->nr_frags < MAX_SKB_FRAGS) {
> >  		skb_frag_t *frag =3D &xdp_sinfo->frags[xdp_sinfo-
> > >nr_frags++];
> > =20
> > -		skb_frag_off_set(frag, pp->rx_offset_correction);
> > -		skb_frag_size_set(frag, data_len);
> > -		__skb_frag_set_page(frag, page);
> > +		xdp_set_frag_offset(frag, pp->rx_offset_correction);
> > +		xdp_set_frag_size(frag, data_len);
> > +		xdp_set_frag_page(frag, page);
> > =20
>=20
> why three separate setters ? why not just one=20
> xdp_set_frag(page, offset, size) ?

to be aligned with skb_frags helpers, but I guess we can have a single help=
er,
I do not have a strong opinion on it

>=20
> >  		/* last fragment */
> >  		if (len =3D=3D *size) {
> > -			struct skb_shared_info *sinfo;
> > +			struct xdp_shared_info *sinfo;
> > =20
> >  			sinfo =3D xdp_get_shared_info_from_buff(xdp);
> >  			sinfo->nr_frags =3D xdp_sinfo->nr_frags;
> > @@ -2324,10 +2327,13 @@ static struct sk_buff *
> >  mvneta_swbm_build_skb(struct mvneta_port *pp, struct mvneta_rx_queue
> > *rxq,
> >  		      struct xdp_buff *xdp, u32 desc_status)
> >  {

[...]

> > =20
> > -static inline struct skb_shared_info *
> > +struct xdp_shared_info {
>=20
> xdp_shared_info is a bad name, we need this to have a specific purpose=20
> xdp_frags should the proper name, so people will think twice before
> adding weird bits to this so called shared_info.

I named the struct xdp_shared_info to recall skb_shared_info but I guess
xdp_frags is fine too. Agree?

>=20
> > +	u16 nr_frags;
> > +	u16 data_length; /* paged area length */
> > +	skb_frag_t frags[MAX_SKB_FRAGS];
>=20
> why MAX_SKB_FRAGS ? just use a flexible array member=20
> skb_frag_t frags[];=20
>=20
> and enforce size via the n_frags and on the construction of the
> tailroom preserved buffer, which is already being done.
>=20
> this is waste of unnecessary space, at lease by definition of the
> struct, in your use case you do:
> memcpy(frag_list, xdp_sinfo->frags, sizeof(skb_frag_t) * num_frags);
> And the tailroom space was already preserved for a full skb_shinfo.
> so i don't see why you need this array to be of a fixed MAX_SKB_FRAGS
> size.

In order to avoid cache-misses, xdp_shared info is built as a variable
on mvneta_rx_swbm() stack and it is written to "shared_info" area only on t=
he
last fragment in mvneta_swbm_add_rx_fragment(). I used MAX_SKB_FRAGS to be
aligned with skb_shared_info struct but probably we can use even a smaller =
value.
Another approach would be to define two different struct, e.g.

stuct xdp_frag_metadata {
	u16 nr_frags;
	u16 data_length; /* paged area length */
};

struct xdp_frags {
	skb_frag_t frags[MAX_SKB_FRAGS];
};

and then define xdp_shared_info as

struct xdp_shared_info {
	stuct xdp_frag_metadata meta;
	skb_frag_t frags[];
};

In this way we can probably optimize the space. What do you think?

>=20
> > +};
> > +
> > +static inline struct xdp_shared_info *
> >  xdp_get_shared_info_from_buff(struct xdp_buff *xdp)
> >  {
> > -	return (struct skb_shared_info *)xdp_data_hard_end(xdp);
> > +	BUILD_BUG_ON(sizeof(struct xdp_shared_info) >
> > +		     sizeof(struct skb_shared_info));
> > +	return (struct xdp_shared_info *)xdp_data_hard_end(xdp);
> > +}
> > +
>=20
> Back to my first comment, do we have plans to use this tail room buffer
> for other than frag_list use cases ? what will be the buffer format
> then ? should we push all new fields to the end of the xdp_shared_info
> struct ? or deal with this tailroom buffer as a stack ?=20
> my main concern is that for drivers that don't support frag list and
> still want to utilize the tailroom buffer for other usecases they will
> have to skip the first sizeof(xdp_shared_info) so they won't break the
> stack.

for the moment I do not know if this area is used for other purposes.
Do you think there are other use-cases for it?

>=20
> > +static inline struct page *xdp_get_frag_page(const skb_frag_t *frag)
> > +{
> > +	return frag->bv_page;
> > +}
> > +
> > +static inline unsigned int xdp_get_frag_offset(const skb_frag_t
> > *frag)
> > +{
> > +	return frag->bv_offset;
> > +}
> > +
> > +static inline unsigned int xdp_get_frag_size(const skb_frag_t *frag)
> > +{
> > +	return frag->bv_len;
> > +}
> > +
> > +static inline void *xdp_get_frag_address(const skb_frag_t *frag)
> > +{
> > +	return page_address(xdp_get_frag_page(frag)) +
> > +	       xdp_get_frag_offset(frag);
> > +}
> > +
> > +static inline void xdp_set_frag_page(skb_frag_t *frag, struct page
> > *page)
> > +{
> > +	frag->bv_page =3D page;
> > +}
> > +
> > +static inline void xdp_set_frag_offset(skb_frag_t *frag, u32 offset)
> > +{
> > +	frag->bv_offset =3D offset;
> > +}
> > +
> > +static inline void xdp_set_frag_size(skb_frag_t *frag, u32 size)
> > +{
> > +	frag->bv_len =3D size;
> >  }
> > =20
> >  struct xdp_frame {
> > @@ -120,12 +164,12 @@ static __always_inline void
> > xdp_frame_bulk_init(struct xdp_frame_bulk *bq)
> >  	bq->xa =3D NULL;
> >  }
> > =20
> > -static inline struct skb_shared_info *
> > +static inline struct xdp_shared_info *
> >  xdp_get_shared_info_from_frame(struct xdp_frame *frame)
> >  {
> >  	void *data_hard_start =3D frame->data - frame->headroom -
> > sizeof(*frame);
> > =20
> > -	return (struct skb_shared_info *)(data_hard_start + frame-
> > >frame_sz -
> > +	return (struct xdp_shared_info *)(data_hard_start + frame-
> > >frame_sz -
> >  				SKB_DATA_ALIGN(sizeof(struct
> > skb_shared_info)));
> >  }
> > =20
>=20
> need a comment here why we preserve the size of skb_shared_info, yet
> the usable buffer is of type xdp_shared_info.

ack, I will add it in v6.

Regards,
Lorenzo

>=20

--eRtJSFbw+EEWtPj3
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCX89dAgAKCRA6cBh0uS2t
rIZHAP4zHQAEvQWXmL+hIIzScpOXfI+6MPhSKxwUcyMA1b5EjAEAzsrFZXrHryT+
Fvp6bBAO5h8fcEXJ5uliMZfg9KD2zgg=
=ViiS
-----END PGP SIGNATURE-----

--eRtJSFbw+EEWtPj3--

