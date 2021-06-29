Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 171D93B7243
	for <lists+netdev@lfdr.de>; Tue, 29 Jun 2021 14:45:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233692AbhF2Mrb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Jun 2021 08:47:31 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:44190 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232685AbhF2Mra (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Jun 2021 08:47:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624970703;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xIjW/V4kVWn/MdXXf2UdvAErF5+HSdnEQLS6aNgfUT0=;
        b=RoFYQg2VTG0z0lEDUgHq24RvKLjlo6T8XZnQF0zB2H/WEonSGXNeuF8kVxGkNORoivbxUu
        uKx0tkJ5BYT19KGWermztjpNfpJFMzfhO7GotVeCUa/+YfPm10PQF5Q3FgEQuLuNumqtkU
        Xe1D9UxmD40qZT8rfMvK3slN5M4nr54=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-204-ndE3Jx6fO9-9pQFHfVGiOw-1; Tue, 29 Jun 2021 08:45:00 -0400
X-MC-Unique: ndE3Jx6fO9-9pQFHfVGiOw-1
Received: by mail-wm1-f72.google.com with SMTP id t82-20020a1cc3550000b02901ee1ed24f94so1237765wmf.9
        for <netdev@vger.kernel.org>; Tue, 29 Jun 2021 05:45:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xIjW/V4kVWn/MdXXf2UdvAErF5+HSdnEQLS6aNgfUT0=;
        b=DYH9DZRyGMC4WBIGeKi0ZrnmzfcNZWNXNId8WpMSNvP6YOp2Vp+YWgZ+gmQCsTNfcW
         Ryjdunb8Zh/V3nP4Vgcq3bAF5tI27VPYQLpuMoFJBOUjk0/MVNlzY+Y76Raxdye1fOwt
         H5VB7f4JzBl+hEeadvwqQ9/NuMgr0ebeRBw5mSH+yGdpKadLmV7Yl5TLthn8Y/1arR7M
         4KraCs8HKdGfq1Ds6q0RtWfoSyigC+EikDa8hpFmCj4Tk2acz5xQzE/J9tiaRNxVSTtl
         +WSFiyMBhMiPEnxJ2bNYBvPzUxzaIkaN7ugyqOc9NyTf1TFSpg8Ya7pomTzV1rxliM4b
         HP4w==
X-Gm-Message-State: AOAM530JpbfrkzrEN/4/iCp019HPoltrDHRd8nsfCqY4dMI4naFkmm9P
        XbDWY0ueIVT5vnQR9I9DFgc1Qqk+5ojfX7mrqGM1JNZRTKYlYSPmcVhE0Vnmc3XggSXiDyHvpZ9
        UrplKqR1Gt87DtdFS
X-Received: by 2002:a5d:5742:: with SMTP id q2mr13942847wrw.256.1624970699912;
        Tue, 29 Jun 2021 05:44:59 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyotqRFyli+/8rVZrv9pvFzSzm2HLFibGkrDpQKFRn5/xEi7IrLcvCjXFQPc3qOoI6HNGSmcQ==
X-Received: by 2002:a5d:5742:: with SMTP id q2mr13942835wrw.256.1624970699730;
        Tue, 29 Jun 2021 05:44:59 -0700 (PDT)
Received: from localhost (net-130-25-105-72.cust.vodafonedsl.it. [130.25.105.72])
        by smtp.gmail.com with ESMTPSA id u12sm18900267wrq.50.2021.06.29.05.44.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Jun 2021 05:44:59 -0700 (PDT)
Date:   Tue, 29 Jun 2021 14:44:56 +0200
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
Subject: Re: [PATCH v9 bpf-next 01/14] net: skbuff: add data_len field to
 skb_shared_info
Message-ID: <YNsVyBw5i4hAHRN8@lore-desk>
References: <cover.1623674025.git.lorenzo@kernel.org>
 <8ad0d38259a678fb42245368f974f1a5cf47d68d.1623674025.git.lorenzo@kernel.org>
 <CAKgT0UcwYHXosz-XuQximak63=ugb9thEc=dkUUZzDpoPCH+Qg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="TnpqoEfdeJq0NZsS"
Content-Disposition: inline
In-Reply-To: <CAKgT0UcwYHXosz-XuQximak63=ugb9thEc=dkUUZzDpoPCH+Qg@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--TnpqoEfdeJq0NZsS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Mon, Jun 14, 2021 at 5:50 AM Lorenzo Bianconi <lorenzo@kernel.org> wro=
te:
> >
> > data_len field will be used for paged frame len for xdp_buff/xdp_frame.
> > This is a preliminary patch to properly support xdp-multibuff
> >
> > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > ---
> >  include/linux/skbuff.h | 5 ++++-
> >  1 file changed, 4 insertions(+), 1 deletion(-)
> >
> > diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> > index dbf820a50a39..332ec56c200d 100644
> > --- a/include/linux/skbuff.h
> > +++ b/include/linux/skbuff.h
> > @@ -522,7 +522,10 @@ struct skb_shared_info {
> >         struct sk_buff  *frag_list;
> >         struct skb_shared_hwtstamps hwtstamps;
> >         unsigned int    gso_type;
> > -       u32             tskey;
> > +       union {
> > +               u32     tskey;
> > +               u32     data_len;
> > +       };
> >
>=20
> Rather than use the tskey field why not repurpose the gso_size field?
> I would think in the XDP paths that the gso fields would be unused
> since LRO and HW_GRO would be incompatible with XDP anyway.
>=20

ack, I agree. I will fix it in v10.

Regards,
Lorenzo

--TnpqoEfdeJq0NZsS
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCYNsVxQAKCRA6cBh0uS2t
rEmgAP9KZXucmbMs8RGZQqN1U14pzi2BrPVzx7MbkYu4b1UwjwD+MRc5OwyXRxU2
KxbPHqzyhcEiQqaZ4ETD/w8rIWaUwAU=
=T+wb
-----END PGP SIGNATURE-----

--TnpqoEfdeJq0NZsS--

