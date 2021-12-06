Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3891E46A5A4
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 20:26:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348488AbhLFTaU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 14:30:20 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:60113 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1348479AbhLFTaU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 14:30:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638818810;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=j2+2C8h376mvTUb+qonvFMLJqYg1Qp0hgW+LfzSktbI=;
        b=adoNLSbqtG9ehJoZfxJYjUbpZpalaJGrxwvLXRVIvty4UXvIeKLEc9L+qsTZxz9h/YDoSd
        6Qpqr5m/9fqPhHEEXU4k/jlE8FHmK6POHzBwK/10D52I5XMA8rO1r/zIGy0BETuHBxebcp
        wBmq9EXXurqhaBYKtosoWA1+AQvI1PI=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-474-1WnvCh7cOhWEezfhb-7sVA-1; Mon, 06 Dec 2021 14:26:49 -0500
X-MC-Unique: 1WnvCh7cOhWEezfhb-7sVA-1
Received: by mail-wm1-f69.google.com with SMTP id n16-20020a05600c3b9000b003331973fdbbso366460wms.0
        for <netdev@vger.kernel.org>; Mon, 06 Dec 2021 11:26:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=j2+2C8h376mvTUb+qonvFMLJqYg1Qp0hgW+LfzSktbI=;
        b=FXl6B5DKPLboQEoQo7l02hQwQICD6k/rpVCJnSmAdONDdhAGKbMKbm++I5JfEaAUFo
         MfhxuAze6eXSNpLv2MaayK8nC3xFuo/BoZoh3vAjC9tcFFgPNcE+oRMRXjTU3C+4YMC5
         qGy4BprU7rUrf50PHLNUUtG+Au6ifYv1pNFxRgqGmBdg6gxzWbMtEXqTjIE34b+JLkJG
         zuCcx0uoeNaGwOMlFnrBRfUMLcPeB2qHu3x7VenzA+QRpVd6DCpYdt7njfp5x0uQRlHU
         F92o/k5OPQXgNth0vhyT3xP5FVxx7VW/2EwuOKLNRXU42/lGtZR9mF5gEwX/n6/0Y+FM
         PfCA==
X-Gm-Message-State: AOAM530JwPg39WztyfZ2KHFTr2C4EUS9sF3p46cpqd4yuayiAaTmejqE
        n7Fgo1LiKx3jmMhBYq5116B4Z2V5C2zAMRve9+lc38dmfv6MhVPY/u71ceI4B8l8al3QzyOuWb/
        NA9JgoUyh0Qr9VL35
X-Received: by 2002:adf:b34f:: with SMTP id k15mr47600422wrd.125.1638818808485;
        Mon, 06 Dec 2021 11:26:48 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyCLmuTUtdoEc+SFqZCphspCU8j34nMB4voWNdRS2/KJEzDwcTbppDV2mkgRZ0LlZmHYnSvSw==
X-Received: by 2002:adf:b34f:: with SMTP id k15mr47600392wrd.125.1638818808329;
        Mon, 06 Dec 2021 11:26:48 -0800 (PST)
Received: from localhost (net-37-182-17-175.cust.vodafonedsl.it. [37.182.17.175])
        by smtp.gmail.com with ESMTPSA id d2sm262144wmb.31.2021.12.06.11.26.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Dec 2021 11:26:47 -0800 (PST)
Date:   Mon, 6 Dec 2021 20:26:46 +0100
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        dsahern@kernel.org, brouer@redhat.com, echaudro@redhat.com,
        jasowang@redhat.com, alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, toke@redhat.com
Subject: Re: [PATCH v19 bpf-next 03/23] net: mvneta: update mb bit before
 passing the xdp buffer to eBPF layer
Message-ID: <Ya5j9mtNyuyNf/MF@lore-desk>
References: <cover.1638272238.git.lorenzo@kernel.org>
 <95151f4b8a25ce38243e82f0a82104d0f46fb33a.1638272238.git.lorenzo@kernel.org>
 <61ad7e4cbc69d_444e20888@john.notmuch>
 <Ya4oCkbOjBHFOHyS@lore-desk>
 <61ae427999a20_881820893@john.notmuch>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="z+c/5q1B95l8TIpi"
Content-Disposition: inline
In-Reply-To: <61ae427999a20_881820893@john.notmuch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--z+c/5q1B95l8TIpi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> Lorenzo Bianconi wrote:
> > > Lorenzo Bianconi wrote:
> > > > Update multi-buffer bit (mb) in xdp_buff to notify XDP/eBPF layer a=
nd
> > > > XDP remote drivers if this is a "non-linear" XDP buffer. Access
> > > > skb_shared_info only if xdp_buff mb is set in order to avoid possib=
le
> > > > cache-misses.
> > > >=20
> > > > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > >=20
> > > [...]
> > >=20
> > > > @@ -2320,8 +2325,12 @@ mvneta_swbm_build_skb(struct mvneta_port *pp=
, struct page_pool *pool,
> > > >  		      struct xdp_buff *xdp, u32 desc_status)
> > > >  {
> > > >  	struct skb_shared_info *sinfo =3D xdp_get_shared_info_from_buff(x=
dp);
> > > > -	int i, num_frags =3D sinfo->nr_frags;
> > > >  	struct sk_buff *skb;
> > > > +	u8 num_frags;
> > > > +	int i;
> > > > +
> > > > +	if (unlikely(xdp_buff_is_mb(xdp)))
> > > > +		num_frags =3D sinfo->nr_frags;
> > >=20
> > > Doesn't really need a respin IMO, but rather an observation. Its not
> > > obvious to me the unlikely/likely pair here is wanted. Seems it could
> > > be relatively common for some applications sending jumbo frames.
> > >=20
> > > Maybe worth some experimenting in the future.
> >=20
> > Probably for mvneta it will not make any difference but in general I tr=
ied to
> > avoid possible cache-misses here (accessing sinfo pointers). I will car=
ry out
> > some comparison to see if I can simplify the code.
>=20
> Agree, I'll predict for mvneta it doesn't make a difference either way and
> perhaps if you want to optimize small pkt benchmarks on a 100Gbps nic it =
would
> show a win.
>=20

actually it makes a slightly difference on mvneta as well (~45-50Kpps).
I will keep the code as it is for the moment.

Regards,
Lorenzo

--z+c/5q1B95l8TIpi
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCYa5j9gAKCRA6cBh0uS2t
rNQ/APwM/ONIGJlt0RvwLFIfYQFXW1qMz9A3sHq0MOKGV+YZZAEA4lPUxnYcZCph
ulFEG2pBcoqZcHbxICxCZnAdW5y32wA=
=L49r
-----END PGP SIGNATURE-----

--z+c/5q1B95l8TIpi--

