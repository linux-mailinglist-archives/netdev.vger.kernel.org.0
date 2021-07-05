Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95A453BC142
	for <lists+netdev@lfdr.de>; Mon,  5 Jul 2021 17:52:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231937AbhGEPzf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Jul 2021 11:55:35 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:36439 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231804AbhGEPze (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Jul 2021 11:55:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625500376;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dEh8stYYZ2foilZ3cO0bL/2Roij0onX80vay7qnQ6aI=;
        b=iN3uuevS6ZuWrR05orxn9HPi4gD7iey+1WllF1iJJgUAGcduy4EEhljV99eSNvEMM3p8eK
        h2oRk19wuCMXRbYttJ/qVm55g5xTkLgy2JLcAwFi+WU4zuAUVp4TWaEMPcA2j5nggzSdTO
        fMXzOxfCHgXF7A4yJT6d2QZ1OZXJcL4=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-245-VZAZPv5pNwujtin-Po4SBA-1; Mon, 05 Jul 2021 11:52:54 -0400
X-MC-Unique: VZAZPv5pNwujtin-Po4SBA-1
Received: by mail-wm1-f72.google.com with SMTP id p3-20020a05600c3583b02901f55d71e34aso127892wmq.4
        for <netdev@vger.kernel.org>; Mon, 05 Jul 2021 08:52:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=dEh8stYYZ2foilZ3cO0bL/2Roij0onX80vay7qnQ6aI=;
        b=VRkw5ngqLT/Ka74GdoEeHFGkfL1s0A5mYnQpecEIra2jnWzsBmX8CRiUHAd4I9qPG1
         4KHWpQcZI81AP7KeemOH9+iGe7nU0B9Bpf0YCJgqusaHUIDXrwHXU68HNMfiLHRsyX4x
         ZAPbV8nSXPtiEJXlNhFjpgBVfxmImOaLVE5HbnoEpvC0K6GbvgkZYzVnT/8PTfb5H774
         hmsHaG6G/Ad5mkGiNhGn2x50WCN60HT3cfD5AaPItkuIBABUHt9hllhKutpTJFn8ibHf
         5aQuZiZg29mc6mSS60rYNP194R0rnmK366hg4Ozzj/YWOUZRcsw2o+xh7ciNNF1RC6DJ
         fkbg==
X-Gm-Message-State: AOAM533Jso4sK9s++1T0SV9r1cRGU10xVHxCmwLzQ1HrT9DMmuKL6Anl
        SXqkrGWOVWsjZpc5wjE8My9TsIiNap45APNjizYs3QNXIdm+JQZFZeoaNr3f9Quk81G+7Y9mYTh
        kk1viRX4LuLdf9Ru9
X-Received: by 2002:adf:e0c8:: with SMTP id m8mr16563258wri.261.1625500373901;
        Mon, 05 Jul 2021 08:52:53 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxjEtlhy0I2Uz3Reb4pUWHS/B8+/3lQ4F2NRMuqjqRoHdf/RDowI35G0QKfJ3A5/bnZjDrgFg==
X-Received: by 2002:adf:e0c8:: with SMTP id m8mr16563236wri.261.1625500373757;
        Mon, 05 Jul 2021 08:52:53 -0700 (PDT)
Received: from localhost (net-93-71-3-244.cust.vodafonedsl.it. [93.71.3.244])
        by smtp.gmail.com with ESMTPSA id m12sm12347627wms.24.2021.07.05.08.52.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jul 2021 08:52:53 -0700 (PDT)
Date:   Mon, 5 Jul 2021 17:52:49 +0200
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
Message-ID: <YOMq0WRu4lsGZJk2@lore-desk>
References: <cover.1623674025.git.lorenzo@kernel.org>
 <1316f3ef2763ff4c02244fb726c61568c972514c.1623674025.git.lorenzo@kernel.org>
 <CAKgT0Ue7TsgwbQF+mfeDB-18Q-R29YZWe=y6Kgeg0xxbwds=vw@mail.gmail.com>
 <YNsVcy8e4Mgyg7g3@lore-desk>
 <CAKgT0Ucg5RbzKt63u5RfXee94kd+1oJ+o_qgUwCwnVCoQjDdPw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="0qMdxdKSAGrx78aQ"
Content-Disposition: inline
In-Reply-To: <CAKgT0Ucg5RbzKt63u5RfXee94kd+1oJ+o_qgUwCwnVCoQjDdPw@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--0qMdxdKSAGrx78aQ
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

Hi Alex,

Reviewing the code to address this comment I think I spotted a corner case
where we can't use this approach. Whenever we run dev_map_bpf_prog_run()
we loose mb info converting xdp_frame to xdp_buff since
xdp_convert_frame_to_buff() does not copy it and we have no xdp_rxq_info th=
ere.
Do you think we should add a rxq_info there similar to what we did for cpum=
ap?
I think it is better to keep the previous approach since it seems cleaner a=
nd
reusable in the future. What do you think?

Regards,
Lorenzo

>=20
> As far as the addition of flags there is still time for that later as
> we still have the 32b of unused space after frame_sz.
>=20

--0qMdxdKSAGrx78aQ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCYOMqzgAKCRA6cBh0uS2t
rO9nAP9zW261Mv7p2dqc+SDvIMQuXIZgDE9Nl3M5GN+BO0JRfwD+Nv93OUFrG72w
K2PepSTwN5BvD72mdcAK3T/U31nB7QA=
=Hcyh
-----END PGP SIGNATURE-----

--0qMdxdKSAGrx78aQ--

