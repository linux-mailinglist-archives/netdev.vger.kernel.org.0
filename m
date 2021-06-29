Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9514E3B732A
	for <lists+netdev@lfdr.de>; Tue, 29 Jun 2021 15:25:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234015AbhF2N1x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Jun 2021 09:27:53 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:20650 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233740AbhF2N1w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Jun 2021 09:27:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624973124;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=gDdP+4K8K9Y+KgRJvzSza5P+wZ5QtvP5Ddc18bELaNY=;
        b=RdT23yJ+7rHbBRYGsZbU2+rP6/cmTerlB91FKDPAWbj08SxMeyH2rK8Rmxado7LjZaE/ZY
        AUuYPC7KXzQdBV5K03MdiQ9/YMfDL/tIOBMdm/eTZaOBGyeFVB0TxrA3cwj4XhGqlf1W01
        7zeXZBuia8oJi7iP4FVFbjl2rq4Vdrc=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-397-az6QgTURNouxMyTT3M0Orw-1; Tue, 29 Jun 2021 09:25:22 -0400
X-MC-Unique: az6QgTURNouxMyTT3M0Orw-1
Received: by mail-wm1-f71.google.com with SMTP id n129-20020a1cbd870000b02901ed2c72a2aeso1605982wmf.4
        for <netdev@vger.kernel.org>; Tue, 29 Jun 2021 06:25:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=gDdP+4K8K9Y+KgRJvzSza5P+wZ5QtvP5Ddc18bELaNY=;
        b=MaAKmhlXJdbGVUEJ8gWz3Ac7LVb9WAJ7vBc5IKZRMRysuzOQ2828XOhGmy3He6i1Dn
         u6IZ6O9unYD5LbtNVpAdv7trGVgYRLt6hUrJjfIG4gb+qTQCCov+LEK4xohNnDcPzoAW
         WItWMoli7XpoOgslhnxknCWygRuS2w0g4VeBzHmWaFXT7+2mH+CNn52j+SkEjfndR38n
         xNaO0pTLbkcyqLcJWdrxtsEUpjV20F/MMW/37rcctSPcisiE5uBn4dsGh/8oEA629GkZ
         xEuM4FyjnlhE3xdvLwRcOPte8ekWwiaadn+H1Sm7UcY7fWvfho0YEt5F85XMUcHyuMor
         TAAQ==
X-Gm-Message-State: AOAM532iei7mb0w6vgzkQj3hglhCt5fgUdaT1XJf0CnadiQhd6pIfPZb
        osEf0wPJYc/s1043ymb0uiWHPhlVQ4AyNV034Lr2t4m+C5nqMvqSX//GHQGDdEVp0TUtDdtekHQ
        gSi+EazEGCQs5Bvno
X-Received: by 2002:a5d:6547:: with SMTP id z7mr5460160wrv.27.1624973121839;
        Tue, 29 Jun 2021 06:25:21 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzaXRrasrTdpN6XxNUwgp9N80ps3VxZjpoZ8HDqsygPgFNk1LZ06cilM4FNpOZUUTt2zyOVGg==
X-Received: by 2002:a5d:6547:: with SMTP id z7mr5460133wrv.27.1624973121710;
        Tue, 29 Jun 2021 06:25:21 -0700 (PDT)
Received: from localhost (net-130-25-105-72.cust.vodafonedsl.it. [130.25.105.72])
        by smtp.gmail.com with ESMTPSA id k6sm16354667wms.8.2021.06.29.06.25.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Jun 2021 06:25:21 -0700 (PDT)
Date:   Tue, 29 Jun 2021 15:25:18 +0200
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, bpf <bpf@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, shayagr@amazon.com,
        "Jubran, Samih" <sameehj@amazon.com>,
        John Fastabend <john.fastabend@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Saeed Mahameed <saeed@kernel.org>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Tirthendu <tirthendu.sarkar@intel.com>
Subject: Re: [PATCH v9 bpf-next 02/14] xdp: introduce flags field in
 xdp_buff/xdp_frame
Message-ID: <YNsfPsG2+X6xxnE6@lore-desk>
References: <cover.1623674025.git.lorenzo@kernel.org>
 <1316f3ef2763ff4c02244fb726c61568c972514c.1623674025.git.lorenzo@kernel.org>
 <CAKgT0Ue7TsgwbQF+mfeDB-18Q-R29YZWe=y6Kgeg0xxbwds=vw@mail.gmail.com>
 <YNsVcy8e4Mgyg7g3@lore-desk>
 <CAKgT0Ucg5RbzKt63u5RfXee94kd+1oJ+o_qgUwCwnVCoQjDdPw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="OwQ1CcrQXpOb47nY"
Content-Disposition: inline
In-Reply-To: <CAKgT0Ucg5RbzKt63u5RfXee94kd+1oJ+o_qgUwCwnVCoQjDdPw@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--OwQ1CcrQXpOb47nY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Tue, Jun 29, 2021 at 5:43 AM Lorenzo Bianconi
> <lorenzo.bianconi@redhat.com> wrote:
> >
> > > On Mon, Jun 14, 2021 at 5:50 AM Lorenzo Bianconi <lorenzo@kernel.org>=
 wrote:
> > > >
> > > > Introduce flags field in xdp_frame/xdp_buffer data structure
> > > > to define additional buffer features. At the moment the only
> > > > supported buffer feature is multi-buffer bit (mb). Multi-buffer bit
> > > > is used to specify if this is a linear buffer (mb =3D 0) or a multi=
-buffer
> > > > frame (mb =3D 1). In the latter case the shared_info area at the en=
d of
> > > > the first buffer will be properly initialized to link together
> > > > subsequent buffers.
> > > >
> > > > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > >
> > > Instead of passing this between buffers and frames I wonder if this
> > > wouldn't be better to place in something like the xdp_mem_info
> > > structure since this is something that would be specific to how the
> > > device is handling memory anyway. You could probably split the type
> > > field into a 16b type and a 16b flags field. Then add your bit where 0
> > > is linear/legacy and 1 is scatter-gather/multi-buffer.
> > >
> >
> > ack, this should be fine but I put the flag field in xdp_buff/xdp_frame
> > in order to reuse it for some xdp hw-hints (e.g rx checksum type).
> > We can put it in xdp_mem_info too but I guess it would be less intuitiv=
e, what
> > do you think?
>=20
> I think it makes the most sense in xdp_mem_info. It already tells us
> what to expect in some respect in regards to memory layout as it tells
> us if we are dealing with shared pages or whole pages and how to
> recycle them. I would think that applies almost identically to
> scatter-gather XDP the same way.
>=20
> As far as the addition of flags there is still time for that later as
> we still have the 32b of unused space after frame_sz.

ack, I am fine with it. If everybody agree, I will fix it in v10.

Regards,
Lorenzo

>=20

--OwQ1CcrQXpOb47nY
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCYNsfOQAKCRA6cBh0uS2t
rCYqAQCeZ4QyxMKeJMz1c27Yth/dSbC7IZuTvGXJpl/quunfNAEA6dkmbgvPN4c8
r+N6RvZmy59pX71L1sC08hRr4DLj+wg=
=1fSm
-----END PGP SIGNATURE-----

--OwQ1CcrQXpOb47nY--

