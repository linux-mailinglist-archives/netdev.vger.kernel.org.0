Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5202B1E63D7
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 16:24:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391165AbgE1OYR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 10:24:17 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:20219 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2390932AbgE1OYO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 May 2020 10:24:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590675852;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=In6GoXTiMdc0MJ7F77e757rpqZbk9KAlth6ltHeXK0M=;
        b=WaJyiTLGMg520h/Rk7g+cGp1rzSFzFueYxrE8PPkbRjX7UcbjeO3RdDeMvgCvJubB0hiuf
        HPhZziTV915M/J6WSbdC4N8RtFor0N5M59CdXkN3AsmURlUm67i7j+v4Vy5uZBsLSfrqIY
        JJzeEgsThBK9EhywfDeeHvowWH1tmw0=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-189-BaqOEZfSOJm46SF8O2jK2A-1; Thu, 28 May 2020 10:24:07 -0400
X-MC-Unique: BaqOEZfSOJm46SF8O2jK2A-1
Received: by mail-wr1-f71.google.com with SMTP id y7so12637073wrd.12
        for <netdev@vger.kernel.org>; Thu, 28 May 2020 07:24:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=In6GoXTiMdc0MJ7F77e757rpqZbk9KAlth6ltHeXK0M=;
        b=PShdyKiQYUIsdSJQ4De+9K9PRQqE8pxxF9sCkstKhxru67nfJcQDZuYXjkFR1pLaYS
         eBFS7YrLPljVIqfAz9vk/Uoz3hcNSjM2/5J6MOdrYzxpzOaEp7qTdbzhxFN5VkuHSyG+
         LIpzHDAKO6JKCOMjhSuw1iiEKL9FsYGmRR/ce/xO9NzvSggemFz0ZGIxZ60MT52u0nSa
         MUsAX0frcQt/rX1U1Aqa96jYCJxvKlg4rFYJs+YcsU5iqlp1mfVvXsXe6sQ2CvMsJvgP
         ubKWqKTvWN78R6Uxmd05a13j+sXE/9Ixr3If9RHrD8RQz9feXDBkn1XjlPFTyISCduVP
         QuYw==
X-Gm-Message-State: AOAM531a5tm3IuDKgF6+SOJmd2VcU0Xzh7HZRJOG8AYTq/WEcZm/gqs0
        Foipg7aEOGspbBdKHc32ffYFxzTf/5/KL34zCRHKU80UmL+ltmeOnWocYTcI34AvnjYLT+ru4QW
        Zqh9W/mJsWqKYGMLA
X-Received: by 2002:a7b:cbc5:: with SMTP id n5mr3690770wmi.110.1590675846498;
        Thu, 28 May 2020 07:24:06 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxjexmuhY2Pb7v0a4PCBlZ+UbRzjziFNM6Ul5rqjOrq5kMZcTjmPcgeHwIqgFAWo9SKiTpwXg==
X-Received: by 2002:a7b:cbc5:: with SMTP id n5mr3690736wmi.110.1590675846089;
        Thu, 28 May 2020 07:24:06 -0700 (PDT)
Received: from localhost ([151.48.140.19])
        by smtp.gmail.com with ESMTPSA id d13sm6501605wmb.39.2020.05.28.07.24.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 May 2020 07:24:04 -0700 (PDT)
Date:   Thu, 28 May 2020 16:24:00 +0200
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@kernel.org, davem@davemloft.net,
        brouer@redhat.com, dsahern@kernel.org, toshiaki.makita1@gmail.com
Subject: Re: [PATCH v2 bpf-next] xdp: introduce convert_to_xdp_buff utility
 routine
Message-ID: <20200528142400.GC5419@localhost.localdomain>
References: <80a0128d78f6c77210a8cccf7c5a78f53c45e7d3.1590571528.git.lorenzo@kernel.org>
 <20200528140419.GB24961@pc-9.home>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="V88s5gaDVPzZ0KCq"
Content-Disposition: inline
In-Reply-To: <20200528140419.GB24961@pc-9.home>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--V88s5gaDVPzZ0KCq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Wed, May 27, 2020 at 11:28:03AM +0200, Lorenzo Bianconi wrote:
> > Introduce convert_to_xdp_buff utility routine to initialize xdp_buff
> > fields from xdp_frames ones. Rely on convert_to_xdp_buff in veth xdp
> > code
> >=20
> > Suggested-by: Jesper Dangaard Brouer <brouer@redhat.com>
> > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > ---
> > Changes since v1:
> > - rely on frame->data pointer to compute xdp->data_hard_start one
> > ---
> >  drivers/net/veth.c |  6 +-----
> >  include/net/xdp.h  | 10 ++++++++++
> >  2 files changed, 11 insertions(+), 5 deletions(-)
> >=20
> > diff --git a/drivers/net/veth.c b/drivers/net/veth.c
> > index b586d2fa5551..9f91e79b7823 100644
> > --- a/drivers/net/veth.c
> > +++ b/drivers/net/veth.c
> > @@ -575,11 +575,7 @@ static struct sk_buff *veth_xdp_rcv_one(struct vet=
h_rq *rq,
> >  		struct xdp_buff xdp;
> >  		u32 act;
> > =20
> > -		xdp.data_hard_start =3D hard_start;
> > -		xdp.data =3D frame->data;
> > -		xdp.data_end =3D frame->data + frame->len;
> > -		xdp.data_meta =3D frame->data - frame->metasize;
> > -		xdp.frame_sz =3D frame->frame_sz;
> > +		convert_to_xdp_buff(frame, &xdp);
> >  		xdp.rxq =3D &rq->xdp_rxq;
> > =20
> >  		act =3D bpf_prog_run_xdp(xdp_prog, &xdp);
> > diff --git a/include/net/xdp.h b/include/net/xdp.h
> > index 90f11760bd12..df99d5d267b2 100644
> > --- a/include/net/xdp.h
> > +++ b/include/net/xdp.h
> > @@ -106,6 +106,16 @@ void xdp_warn(const char *msg, const char *func, c=
onst int line);
> > =20
> >  struct xdp_frame *xdp_convert_zc_to_xdp_frame(struct xdp_buff *xdp);
> > =20
> > +static inline
> > +void convert_to_xdp_buff(struct xdp_frame *frame, struct xdp_buff *xdp)
> > +{
> > +	xdp->data_hard_start =3D frame->data - frame->headroom - sizeof(*fram=
e);
> > +	xdp->data =3D frame->data;
> > +	xdp->data_end =3D frame->data + frame->len;
> > +	xdp->data_meta =3D frame->data - frame->metasize;
> > +	xdp->frame_sz =3D frame->frame_sz;
> > +}
>=20
> From an API PoV, could we please prefix these with xdp_*(). Looks like th=
ere
> is also convert_to_xdp_frame() as an outlier in there, but lets clean the=
se
> up once in the tree to avoid getting this more messy and harder to fix la=
ter
> on. How about:
>=20
>   - xdp_convert_frame_to_buff()
>   - xdp_convert_buff_to_frame()
>=20
> This will have both more self-documented and makes it obvious from where =
to
> where we convert something.

ack fine to me, I will fix it in v3.

Regards,
Lorenzo

>=20
> Thanks,
> Daniel
>=20

--V88s5gaDVPzZ0KCq
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCXs/JfQAKCRA6cBh0uS2t
rKMaAQCI7TIMXSUK0csUVw4DkA0aRD/C9qcRKqmUpB/u3+krBQD9F36IL0K89ftC
wEwFTP6ULZKu22dbLepilOUaPvm61A4=
=/Lre
-----END PGP SIGNATURE-----

--V88s5gaDVPzZ0KCq--

