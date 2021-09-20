Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A32BD411118
	for <lists+netdev@lfdr.de>; Mon, 20 Sep 2021 10:38:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234000AbhITIiy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Sep 2021 04:38:54 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:42522 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233670AbhITIix (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Sep 2021 04:38:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632127046;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=gYgK4jQ8dPS3k+veeE2Irpao848Z+jPaY59OoYwZ+eU=;
        b=SfrLVvdNEdjxY5XKzoz2alei07xwQI1ikwhAHc1ykF1poR2nsplX16bp7/D+/GJ2tqt8kv
        B/YSVXlKaw4C5QlN9P13qk7iyS7KjLq4HP2jkgkQMav9x86e3yydhP1r+Ls/Svkblsmr5+
        OuaTU5d4B56xL+GNLSeQKZ7tbr/ClQA=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-215-_mxZrKxJMS-qs6nJAF8KyA-1; Mon, 20 Sep 2021 04:37:24 -0400
X-MC-Unique: _mxZrKxJMS-qs6nJAF8KyA-1
Received: by mail-wr1-f70.google.com with SMTP id x2-20020a5d54c2000000b0015dfd2b4e34so5541190wrv.6
        for <netdev@vger.kernel.org>; Mon, 20 Sep 2021 01:37:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=gYgK4jQ8dPS3k+veeE2Irpao848Z+jPaY59OoYwZ+eU=;
        b=zvj7i5lJ8dIH1ZDZS20QHccSp5xKxiaNYZYbWaH7+nPWH4VX4V4gWF+aS5TObeYchO
         1VBxcYSl0XzF1mzJaWRiSbuvbzDuJsbhxagKpx7Hcai/S7/MiyX47OrPBLu/jah9rNop
         Ubpdtn59zGzQIjBD+/sTfTZPQhZ+mgj5+VJm5uRkkpZCs4wWwU7wuJAD+W/kQxQGFR7S
         dd5mwv4ufOGFFgn1hLV2sTi8b13/7JM8Q9RdZf7bNXeOp3Rmrn/SzhMGtEuZRaDsJ8rD
         hCyswEduS03/lMSC+GPXF2IqQZaZxeeKIQmDxvMbrntKcqDCaDiSRoFhuypzystPPpE5
         Kh+g==
X-Gm-Message-State: AOAM532OVynBVlpTQXcpew6RctmdxhXy41JIy6VGE4PvvS0AEBa7BEQ7
        xQKLKDedY5otc3FTUirdRBs7N6F4avxQiRMRWOUu/5Ui1cbxQ2vTmhsRl6nVCywubCxAbXGWjeu
        GEHjJG8ZS7tI9JCQq
X-Received: by 2002:adf:ce84:: with SMTP id r4mr27299089wrn.107.1632127042930;
        Mon, 20 Sep 2021 01:37:22 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwd1Bt0lR/J03gYLONSFIiyXq88wd4UjJM1kSbjxwss+8NsZAob8n+sZWyu1UUFeKW8+CxLag==
X-Received: by 2002:adf:ce84:: with SMTP id r4mr27299064wrn.107.1632127042741;
        Mon, 20 Sep 2021 01:37:22 -0700 (PDT)
Received: from localhost (net-130-25-199-50.cust.vodafonedsl.it. [130.25.199.50])
        by smtp.gmail.com with ESMTPSA id c8sm7924480wru.30.2021.09.20.01.37.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Sep 2021 01:37:22 -0700 (PDT)
Date:   Mon, 20 Sep 2021 10:37:20 +0200
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
Message-ID: <YUhIQEIJxLRPpaRP@lore-desk>
References: <cover.1631289870.git.lorenzo@kernel.org>
 <f11d8399e17bc82f9ffcb613da0a457a96f56fec.1631289870.git.lorenzo@kernel.org>
 <pj41zlh7ef8xgt.fsf@u570694869fb251.ant.amazon.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="UA4i3FwRTjGeOf5o"
Content-Disposition: inline
In-Reply-To: <pj41zlh7ef8xgt.fsf@u570694869fb251.ant.amazon.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--UA4i3FwRTjGeOf5o
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

>=20
> Lorenzo Bianconi <lorenzo@kernel.org> writes:
>=20
> > ...
> > diff --git a/drivers/net/ethernet/marvell/mvneta.c
> > b/drivers/net/ethernet/marvell/mvneta.c
> > index 9d460a270601..0c7b84ca6efc 100644
> > --- a/drivers/net/ethernet/marvell/mvneta.c
> > +++ b/drivers/net/ethernet/marvell/mvneta.c
> > ...
> > @@ -2320,8 +2325,12 @@ mvneta_swbm_build_skb(struct mvneta_port *pp,
> > struct page_pool *pool,
> >  		      struct xdp_buff *xdp, u32 desc_status)
> >  {
> >  	struct skb_shared_info *sinfo =3D  xdp_get_shared_info_from_buff(xdp);
> > -	int i, num_frags =3D sinfo->nr_frags;
> >  	struct sk_buff *skb;
> > +	u8 num_frags;
> > +	int i;
> > +
> > +	if (unlikely(xdp_buff_is_mb(xdp)))
> > +		num_frags =3D sinfo->nr_frags;
>=20
> Hi,
> nit, it seems that the num_frags assignment can be moved after the other
> 'if' condition you added (right before the 'for' for num_frags), or even =
be
> eliminated completely so that sinfo->nr_frags is used directly.
> Either way it looks like you can remove one 'if'.
>=20
> Shay

Hi Shay,

we can't move nr_frags assignement after build_skb() since this field will =
be
overwritten by that call.

Regards,
Lorenzo

>=20
> >  	skb =3D build_skb(xdp->data_hard_start, PAGE_SIZE);
> >  	if (!skb)
> > @@ -2333,6 +2342,9 @@ mvneta_swbm_build_skb(struct mvneta_port *pp,
> > struct page_pool *pool,
> >  	skb_put(skb, xdp->data_end - xdp->data);
> >  	skb->ip_summed =3D mvneta_rx_csum(pp, desc_status);
> > +	if (likely(!xdp_buff_is_mb(xdp)))
> > +		goto out;
> > +
> >  	for (i =3D 0; i < num_frags; i++) {
> >  		skb_frag_t *frag =3D &sinfo->frags[i];
> >   @@ -2341,6 +2353,7 @@ mvneta_swbm_build_skb(struct mvneta_port *pp,
> > struct page_pool *pool,
> >  				skb_frag_size(frag), PAGE_SIZE);
> >  	}
> > +out:
> >  	return skb;
> >  }
>=20

--UA4i3FwRTjGeOf5o
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCYUhIQAAKCRA6cBh0uS2t
rBmfAP9w7lk5Q/MjTbSdfWiCIoBslUWDYZoNKZLUsiloEYcpOQD8DwKzOQI+Z7T0
mSjfB0Y7aaF77m96RBnLiVxBv6e0WQY=
=GN9Z
-----END PGP SIGNATURE-----

--UA4i3FwRTjGeOf5o--

