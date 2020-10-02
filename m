Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EF0F2817DD
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 18:26:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387929AbgJBQZ6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 12:25:58 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:21165 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1733260AbgJBQZ6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Oct 2020 12:25:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601655956;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=2thjc0jOZc2wNSYDU7OxC6DQ1HcNNnBeXmEt+DgH8zA=;
        b=IcFHdNz7ixQ5JpN5se03/4C6UnQESpP5p/5vr56yQPxGAR7dbeP+ag2ln8dlKek/Zrt3Hd
        67sEGHmxAlsI8/FcXb2ZNoANUvh14s8YSZvh1tPLxCi/qMDL3vvHUEh8kwYkK3jAYoKFZc
        bgyiCIIUPAfnOSg2Jax4PiG2igdnxsU=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-593-egtn1QubOfqfw1ATcU4rag-1; Fri, 02 Oct 2020 12:25:52 -0400
X-MC-Unique: egtn1QubOfqfw1ATcU4rag-1
Received: by mail-wm1-f70.google.com with SMTP id f2so698843wml.6
        for <netdev@vger.kernel.org>; Fri, 02 Oct 2020 09:25:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=2thjc0jOZc2wNSYDU7OxC6DQ1HcNNnBeXmEt+DgH8zA=;
        b=C/C73JyK4Nj/IK1gS7W5o3SRI5O0t7rcZRBSms5hK4RDT8tC2fGQhAqslSDgon5wDm
         0n68lBzi4THzKrj+Qvw06UwwrGLB7jUrRBc5QmH6cEH0sGKy2SfijBmLKR+JiSfUaJrc
         BymwreZwYAQiofEfXQhynea3Om5LClVh6LLGxZ9zTsc5e7wFUv7zvQZXEbxQ+t2CVHfp
         PThMq/z6cZ6Yi7beNXNkd0eIlWsVT4vlj+hxhhmKQV2d780LL6GaxaltQGLARMIdAtl6
         TvKsO2zeDzDqd86wl1PML+PqAKgqFuxb1/Z6TShhcBDGVerPi27FHT/nV9v/8qE0eooC
         P0HA==
X-Gm-Message-State: AOAM53231XWKcK/epiLPQuGR9XsinG2EMKQjHFrkFVM2l/JqxdS1xzcW
        /RgqWtoRCRnoIm/S7Iy+Xkosy+GwZxQE8pzJ/H1GSwHGkV+ZudRRZOxF/nt3nOIGG/nRle9HHmm
        aDu2Q9DcaA05wlyfb
X-Received: by 2002:a05:600c:2246:: with SMTP id a6mr3928580wmm.38.1601655950835;
        Fri, 02 Oct 2020 09:25:50 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw09mMdBzo0dLo73WitxHFIMrzDIqSoofuYfNWn7xPD31kI+g0go4yj9GtToowf56W+Q+nO+w==
X-Received: by 2002:a05:600c:2246:: with SMTP id a6mr3928544wmm.38.1601655950490;
        Fri, 02 Oct 2020 09:25:50 -0700 (PDT)
Received: from localhost ([176.207.245.61])
        by smtp.gmail.com with ESMTPSA id c25sm2292517wml.31.2020.10.02.09.25.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Oct 2020 09:25:49 -0700 (PDT)
Date:   Fri, 2 Oct 2020 18:25:46 +0200
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        sameehj@amazon.com, dsahern@kernel.org, brouer@redhat.com,
        echaudro@redhat.com
Subject: Re: [PATCH v4 bpf-next 06/13] bpf: introduce
 bpf_xdp_get_frags_{count, total_size} helpers
Message-ID: <20201002162546.GB40027@lore-desk>
References: <cover.1601648734.git.lorenzo@kernel.org>
 <deb81e4cf02db9a1da2b4088a49afd7acf8b82b6.1601648734.git.lorenzo@kernel.org>
 <5f7748fc80bd9_38b02081@john-XPS-13-9370.notmuch>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="UHN/qo2QbUvPLonB"
Content-Disposition: inline
In-Reply-To: <5f7748fc80bd9_38b02081@john-XPS-13-9370.notmuch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--UHN/qo2QbUvPLonB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> Lorenzo Bianconi wrote:
> > From: Sameeh Jubran <sameehj@amazon.com>
> >=20
> > Introduce the two following bpf helpers in order to provide some
> > metadata about a xdp multi-buff fame to bpf layer:
> >=20
> > - bpf_xdp_get_frags_count()
> >   get the number of fragments for a given xdp multi-buffer.
>=20
> Same comment as in the cover letter can you provide a use case
> for how/where I would use xdp_get_frags_count()? Is it just for
> debug? If its just debug do we really want a uapi helper for it.

I have no a strong opinion on it, I guess we can just drop this helper,
but I am not the original author of the patch :)

>=20
> >=20
> > * bpf_xdp_get_frags_total_size()
> >   get the total size of fragments for a given xdp multi-buffer.
>=20
> This is awkward IMO. If total size is needed it should return total size
> in all cases not just in the mb case otherwise programs will have two
> paths the mb path and the non-mb path. And if you have mixed workload
> the branch predictor will miss? Plus its extra instructions to load.

ack, I am fine to make the helper reporing to total size instead of paged o=
nes
(we can compute it if we really need it)

>=20
> And if its useful for something beyond just debug and its going to be
> read every packet or something I think we should put it in the metadata
> so that its not hidden behind a helper which likely will show up as
> overhead on a 40+gbps nic. The use case I have in mind is counting
> bytes maybe sliced by IP or protocol. Here you will always read it
> and I don't want code with a if/else stuck in the middle when if
> we do it right we have a single read.

do you mean xdp_frame or data_meta area? As explained in the cover-letter we
choose this approach to save space in xdp_frame.

>=20
> >=20
> > Signed-off-by: Sameeh Jubran <sameehj@amazon.com>
> > Co-developed-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > ---
> >  include/uapi/linux/bpf.h       | 14 ++++++++++++
> >  net/core/filter.c              | 42 ++++++++++++++++++++++++++++++++++
> >  tools/include/uapi/linux/bpf.h | 14 ++++++++++++
> >  3 files changed, 70 insertions(+)
> >=20
> > diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> > index 4f556cfcbfbe..0715995eb18c 100644
> > --- a/include/uapi/linux/bpf.h
> > +++ b/include/uapi/linux/bpf.h
> > @@ -3668,6 +3668,18 @@ union bpf_attr {
> >   * 	Return
> >   * 		The helper returns **TC_ACT_REDIRECT** on success or
> >   * 		**TC_ACT_SHOT** on error.
> > + *
> > + * int bpf_xdp_get_frags_count(struct xdp_buff *xdp_md)
> > + *	Description
> > + *		Get the number of fragments for a given xdp multi-buffer.
> > + *	Return
> > + *		The number of fragments
> > + *
> > + * int bpf_xdp_get_frags_total_size(struct xdp_buff *xdp_md)
> > + *	Description
> > + *		Get the total size of fragments for a given xdp multi-buffer.
>=20
> Why just fragments? Will I have to also add the initial frag0 to it
> or not. I think the description is a bit ambiguous.
>=20
> > + *	Return
> > + *		The total size of fragments for a given xdp multi-buffer.
> >   */
>=20
> [...]
>=20
> > +const struct bpf_func_proto bpf_xdp_get_frags_count_proto =3D {
> > +	.func		=3D bpf_xdp_get_frags_count,
> > +	.gpl_only	=3D false,
> > +	.ret_type	=3D RET_INTEGER,
> > +	.arg1_type	=3D ARG_PTR_TO_CTX,
> > +};
> > +
> > +BPF_CALL_1(bpf_xdp_get_frags_total_size, struct  xdp_buff*, xdp)
> > +{
> > +	struct skb_shared_info *sinfo;
> > +	int nfrags, i, size =3D 0;
> > +
> > +	if (likely(!xdp->mb))
> > +		return 0;
> > +
> > +	sinfo =3D xdp_get_shared_info_from_buff(xdp);
> > +	nfrags =3D min_t(u8, sinfo->nr_frags, MAX_SKB_FRAGS);
> > +
> > +	for (i =3D 0; i < nfrags; i++)
> > +		size +=3D skb_frag_size(&sinfo->frags[i]);
>=20
> Wont the hardware just know this? I think walking the frag list
> just to get the total seems wrong. The hardware should have a
> total_len field somewhere we can just read no? If mvneta doesn't
> know the total length that seems like a driver limitation and we
> shouldn't encode it in the helper.

I have a couple of patches to improve this (not posted yet):
- https://github.com/LorenzoBianconi/bpf-next/commit/ff9b3a74a105b64947931f=
83fe86a4b8b1808103
- https://github.com/LorenzoBianconi/bpf-next/commit/712e67333cbc5f6304122b=
1009cdae1e18e6eb26

Regards,
Lorenzo

>=20
> > +
> > +	return size;
> > +}
>=20

--UHN/qo2QbUvPLonB
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCX3dUhwAKCRA6cBh0uS2t
rM4vAP4id18LdrEI6kWXVfPh3a6IvbnFgO+KlQbJdlFdBOpj9gEA3TZvCr8Xya1I
Fdf3cdROwvLEBs5vkGX6ui7KT7vKwgs=
=hgJ1
-----END PGP SIGNATURE-----

--UHN/qo2QbUvPLonB--

