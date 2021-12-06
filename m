Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A594846A686
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 21:04:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349041AbhLFUHe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 15:07:34 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:43466 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1348859AbhLFUHd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 15:07:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638821044;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=homnGmGUR/BIFldb2E+WbiDxvtTVJPsIY0ZfkvjSS2w=;
        b=OR9DCluuX7JVYOPDFAhBxs6IkkKEIbH6PyCVb3ZgxRWqJ130D0o4+daytxC5pMJ2N8pPuW
        mFmpMPNKe1eRUpG9G7XEEhZTPFDyN52+a77jv20YdzHNBuyd9fePU5OwYjoi/6/rACQG3G
        OiufnWmjEQM9dkuwp5B4L8aM5oJfd8o=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-55-nx-5QLqcME6xA4gYygUAPg-1; Mon, 06 Dec 2021 15:04:02 -0500
X-MC-Unique: nx-5QLqcME6xA4gYygUAPg-1
Received: by mail-wm1-f69.google.com with SMTP id z138-20020a1c7e90000000b003319c5f9164so84035wmc.7
        for <netdev@vger.kernel.org>; Mon, 06 Dec 2021 12:04:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=homnGmGUR/BIFldb2E+WbiDxvtTVJPsIY0ZfkvjSS2w=;
        b=spEtsYwGTMXao/65dF6HM3HsjgfxF7mkU1p5dgGiOJeGfgBS4nT4dq3W1FmRISFLHM
         Y6xBTnmv/7O0I/ui/DC76vfHnG5vOaHVfbV3HVJjAMRIVGr1zEQFo0nrYN9Lkt1iX/lb
         j9fWy++r7X9FW9Ct/H6FGWJtUNdEQSGP6ejjHzmkRqdWW2Z6LD+plrw7fYpptR2K2W2N
         wz8ukHKyaDx96Oy46ZjGPsbDFiMM1XF0aVIQBfcBm6f69XlnHEEZIdJkx1nyItNtn/IW
         qpOw6qB92fWdvL/9xEtaWiNeNt73FBK8V2PQK8k+ihLC0jW87Dxtpxp8SHMeHSRjk5nG
         +4yQ==
X-Gm-Message-State: AOAM530Os4lVWtzLStR5IwdYGaykN2c55iKjQRc1DYEHCiWYzpCG01IV
        rrn/RWJWpL6tgWgCaOwMMJ/wSCV7HIvg/FJCfET6BV3DKPqSbC/0coWdGgIXOUPiFAbMVwX3bVx
        tYgAEcLdcDdHf7CRo
X-Received: by 2002:a7b:c38b:: with SMTP id s11mr904606wmj.29.1638821041057;
        Mon, 06 Dec 2021 12:04:01 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyB1+wLfulvJEFaUelODhZ83Wi1pEhYDJw/oaLSRjgW6VNto0HITHLLmqlrbrF7zEaZactGiA==
X-Received: by 2002:a7b:c38b:: with SMTP id s11mr904530wmj.29.1638821040465;
        Mon, 06 Dec 2021 12:04:00 -0800 (PST)
Received: from localhost (net-37-182-17-175.cust.vodafonedsl.it. [37.182.17.175])
        by smtp.gmail.com with ESMTPSA id x1sm12109403wru.40.2021.12.06.12.03.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Dec 2021 12:03:59 -0800 (PST)
Date:   Mon, 6 Dec 2021 21:03:58 +0100
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Zvi Effron <zeffron@riotgames.com>
Cc:     Jesper Dangaard Brouer <jbrouer@redhat.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, brouer@redhat.com, davem@davemloft.net,
        kuba@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        shayagr@amazon.com, john.fastabend@gmail.com, dsahern@kernel.org,
        echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, toke@redhat.com
Subject: Re: [PATCH v19 bpf-next 23/23] xdp: disable XDP_REDIRECT for xdp
 multi-buff
Message-ID: <Ya5srnSIkt+bgJaC@lore-desk>
References: <cover.1638272238.git.lorenzo@kernel.org>
 <df855fe05b80746fa7f657fce78b24d582f133cb.1638272239.git.lorenzo@kernel.org>
 <88f9b4e9-9074-a507-426d-7c947f1e2b13@redhat.com>
 <CAC1LvL1U1=Qb9Em5=uwC=RQw0pKPQ+dCdURgURbLgGAJkXm0eg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="qbA3iRlZxQw4vN4L"
Content-Disposition: inline
In-Reply-To: <CAC1LvL1U1=Qb9Em5=uwC=RQw0pKPQ+dCdURgURbLgGAJkXm0eg@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--qbA3iRlZxQw4vN4L
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Mon, Dec 6, 2021 at 11:11 AM Jesper Dangaard Brouer
> <jbrouer@redhat.com> wrote:
> >
> > On 30/11/2021 12.53, Lorenzo Bianconi wrote:
> > > XDP_REDIRECT is not fully supported yet for xdp multi-buff since not
> > > all XDP capable drivers can map non-linear xdp_frame in ndo_xdp_xmit
> > > so disable it for the moment.
> > >
> > > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > > ---
> > >   net/core/filter.c | 7 +++++++
> > >   1 file changed, 7 insertions(+)
> > >
> > > diff --git a/net/core/filter.c b/net/core/filter.c
> > > index b70725313442..a87d835d1122 100644
> > > --- a/net/core/filter.c
> > > +++ b/net/core/filter.c
> > > @@ -4189,6 +4189,13 @@ int xdp_do_redirect(struct net_device *dev, st=
ruct xdp_buff *xdp,
> > >       struct bpf_map *map;
> > >       int err;
> > >
> > > +     /* XDP_REDIRECT is not fully supported yet for xdp multi-buff s=
ince
> > > +      * not all XDP capable drivers can map non-linear xdp_frame in
> > > +      * ndo_xdp_xmit.
> > > +      */
> > > +     if (unlikely(xdp_buff_is_mb(xdp)))
> > > +             return -EOPNOTSUPP;
> > > +
> >
> > This approach also exclude 'cpumap' use-case, which you AFAIK have added
> > MB support for in this patchset.
> >
> > Generally this check is hopefully something we can remove again, once
> > drivers add MB ndo_xdp_xmit support.
> >
>=20
> What happens in the future when a new driver is added without (in its int=
ial
> version) MB ndo_xdp_xmit support? Is MB support for ndo_xdp_xmit going to=
 be a
> requirement for a driver (with ndo_xdp_xmit) to be accepted to the kernel?

I think the optimal solution would be export the driver XDP capabilities (A=
FAIK
there is an ogoing effort for this, but it is not available yet).

>=20
> I'm not arguing against removing this check in the future, I'm just wonde=
ring
> if we need a different mechanism than outright prohibiting XDP_REDIRECT w=
ith MB
> to protect against the redirected device not having MB support?
>=20
> >
> > >       ri->map_id =3D 0; /* Valid map id idr range: [1,INT_MAX[ */
> > >       ri->map_type =3D BPF_MAP_TYPE_UNSPEC;
> > >
> > >
> >
>=20

--qbA3iRlZxQw4vN4L
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCYa5srgAKCRA6cBh0uS2t
rBbMAQC+gqYQi8eaFZnyxyFJyEYU9JbyfPSutoB6IViPVE9OvgEAtddmv3l5L4SZ
kt82g41U8ODMemPqhlRNQZR1DlLiFwk=
=oZbs
-----END PGP SIGNATURE-----

--qbA3iRlZxQw4vN4L--

