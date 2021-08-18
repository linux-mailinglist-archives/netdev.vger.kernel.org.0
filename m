Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51F443F04F2
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 15:37:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237104AbhHRNiJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 09:38:09 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:45604 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237243AbhHRNiI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Aug 2021 09:38:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629293853;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3nkORLO/atfa6K6RRE8EvWi5+jxgYR6p0inhWO+j+Yk=;
        b=SzLC9M+TLoWN8iDfCkc6KoJ4eh2vok279hzJrTSNBQ0cd34/27zeEGyF9C6G+otjbC3xbD
        b3fNtZGUnq+CtFQXwGEBXoBGkSkkJ1k6Er8/1qKDAcGGwUHtqCj1BLZprgAtkFaVwTXTYt
        zcCHS0f+/cTLFKgqdhwE1hY0nMCRK8A=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-173-w0PLdIXnNE2yhQx9bfj9Fw-1; Wed, 18 Aug 2021 09:37:30 -0400
X-MC-Unique: w0PLdIXnNE2yhQx9bfj9Fw-1
Received: by mail-wm1-f71.google.com with SMTP id j33-20020a05600c1c21b02902e6828f7a20so740839wms.7
        for <netdev@vger.kernel.org>; Wed, 18 Aug 2021 06:37:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=3nkORLO/atfa6K6RRE8EvWi5+jxgYR6p0inhWO+j+Yk=;
        b=DNuxk5TxJ5hnWtH9paLDxEPbjtzmNQhpYHCtuPWrwWM1wL+rXLgX5N17vZCnghgf73
         iDS59mF7aoEg8lIILmM8BMV63tesLT0PBgo6cj02xMe640L/274Qchpjo/SUl/lKGddt
         JLrHzBsTKTw0GG67Zj3xkiV9cCBxLx3uSeQqctQNPNYMdVtIG01BJx/z4/2yERH5q4qn
         qVOXDacHG87/qVrg9L8rgB6XkpTqOoKcTDxrXs5/x0+NAN+6XGkGnFRwaSiAiFWn1bRW
         VeL/Ledd9Nwvb8iVpi9HGQaP7ZyVgmFVz2P69RPK1CBK/PAxpXFFz9G5cVHd77jLx9Bp
         C7rQ==
X-Gm-Message-State: AOAM531XqdLYpOdls2NKoWLxfnKMS8C0/8tByO4k4agi14d9U1buEY6G
        AYP7I3F6lkp5PA3yOis8fCZ/tDVSLjIqP5Ew9K926CNbaYiSHC/Fut6cFEnuA5dmjnBGj5l+Twp
        uZ7GZVUjai6y3rx+K
X-Received: by 2002:a5d:658e:: with SMTP id q14mr10743878wru.142.1629293848999;
        Wed, 18 Aug 2021 06:37:28 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy6GaFTVTpQDUTjLLN4+PIKc8xkR614JF/2mBb8xZBdKkNDvWyGROPFvGTiY5cTfSEY1cxN5w==
X-Received: by 2002:a5d:658e:: with SMTP id q14mr10743850wru.142.1629293848825;
        Wed, 18 Aug 2021 06:37:28 -0700 (PDT)
Received: from localhost (net-47-53-237-136.cust.vodafonedsl.it. [47.53.237.136])
        by smtp.gmail.com with ESMTPSA id e3sm5980178wro.15.2021.08.18.06.37.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Aug 2021 06:37:28 -0700 (PDT)
Date:   Wed, 18 Aug 2021 15:37:25 +0200
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        john.fastabend@gmail.com, dsahern@kernel.org, brouer@redhat.com,
        echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com
Subject: Re: [PATCH v11 bpf-next 17/18] net: xdp: introduce
 bpf_xdp_adjust_data helper
Message-ID: <YR0NFQCsNH3x6kfx@lore-desk>
References: <cover.1628854454.git.lorenzo@kernel.org>
 <9696df8ef1cf6c931ae788f40a42b9278c87700b.1628854454.git.lorenzo@kernel.org>
 <87czqbq6ic.fsf@toke.dk>
 <YR0BYiQFvI8cmOJU@lore-desk>
 <878s0yrjso.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="TDUwvGzpyHhvnaRL"
Content-Disposition: inline
In-Reply-To: <878s0yrjso.fsf@toke.dk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--TDUwvGzpyHhvnaRL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> Lorenzo Bianconi <lorenzo.bianconi@redhat.com> writes:
>=20
> >> Lorenzo Bianconi <lorenzo@kernel.org> writes:
> >>=20
> > [...]
> >> > + *	Description
> >> > + *		For XDP frames split over multiple buffers, the
> >> > + *		*xdp_md*\ **->data** and*xdp_md *\ **->data_end** pointers
> >> > + *		will point to the start and end of the first fragment only.
> >> > + *		This helper can be used to access subsequent fragments by
> >> > + *		moving the data pointers. To use, an XDP program can call
> >> > + *		this helper with the byte offset of the packet payload that
> >> > + *		it wants to access; the helper will move *xdp_md*\ **->data**
> >> > + *		and *xdp_md *\ **->data_end** so they point to the requested
> >> > + *		payload offset and to the end of the fragment containing this
> >> > + *		byte offset, and return the byte offset of the start of the
> >> > + *		fragment.
> >>=20
> >> This comment is wrong now :)
> >
> > actually we are still returning the byte offset of the start of the fra=
gment
> > (base_offset).
>=20
> Hmm, right, I was looking at the 'return 0':
>=20
> > +BPF_CALL_2(bpf_xdp_adjust_data, struct xdp_buff *, xdp, u32, offset)
> > +{
> > +	struct skb_shared_info *sinfo =3D xdp_get_shared_info_from_buff(xdp);
> > +	u32 base_offset =3D xdp->mb.headlen;
> > +	int i;
> > +
> > +	if (!xdp_buff_is_mb(xdp) || offset > sinfo->xdp_frags_size)
> > +		return -EINVAL;
> > +
> > +	if (offset < xdp->mb.headlen) {
> > +		/* linear area */
> > +		xdp->data =3D xdp->data_hard_start + xdp->mb.headroom;
> > +		xdp->data_end =3D xdp->data + xdp->mb.headlen;
> > +		return 0;
> > +	}
>=20
> But I guess that's an offset; but that means the helper is not doing
> what it says it's doing if it's within the first fragment. That should
> probably be made consistent... :)

ack, right. I will fix it in v12, thanks.

Regards,
Lorenzo

>=20
> -Toke
>=20

--TDUwvGzpyHhvnaRL
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCYR0NEgAKCRA6cBh0uS2t
rH2CAP9C4l1kLYUsnnwq2eF5rOQRodchxqXO2DF0PVG1UEJqQwEAv+B2SSnbBjOa
5LFTThnRjThl/amR/tGBBW4dvUO+QwA=
=VZ5A
-----END PGP SIGNATURE-----

--TDUwvGzpyHhvnaRL--

