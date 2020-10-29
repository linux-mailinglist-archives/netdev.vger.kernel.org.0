Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF8CD29E907
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 11:32:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726765AbgJ2Kcn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 06:32:43 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:38819 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726112AbgJ2Kcm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 06:32:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603967516;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=i23ClnnyN49Bs0oQkdNz5ufbZvaJbHZARzUfXComFHM=;
        b=bAAZFTuI4y4yVN681Rx+eMPh7i3Sz2y6Rm03ep6dhVjHQiP7dqaCdIKy4ucZben06mckSC
        W64ClfuM4F1A5Qls86kkJUCpOyVFnYW51k9FBDRPh0IhEY3YRfux9VNKryu7kahjTXXBtk
        wE0dENKfhIoBiE8eDXY5ny4x3ldWyrw=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-421-4nHatndSO8CUzmTSHRNk-w-1; Thu, 29 Oct 2020 06:31:54 -0400
X-MC-Unique: 4nHatndSO8CUzmTSHRNk-w-1
Received: by mail-wm1-f70.google.com with SMTP id 13so951984wmf.0
        for <netdev@vger.kernel.org>; Thu, 29 Oct 2020 03:31:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=i23ClnnyN49Bs0oQkdNz5ufbZvaJbHZARzUfXComFHM=;
        b=QqI3+ahtsgXAMj2i2HXU4DutyZ61tIRvVdPriE8Cn6h8HIHu9wOSLYzc9JeeYKzgMd
         UHVr8RoLm0tPiFSRZX2ro4FYW21MfocrfcK80i+1dk69KOKhTKt2C9l+imyc/tHRS9tu
         DkWPQBi8lmohm6CxHm4n3nO+5GANmtklMMkf/SOTgWRXiO1wb88rfeIbADX+JH1qdLYb
         N6FnE4Zj4WWY8FfImOYszmyRpz/jAwseYFyG+rOgObY3pNAtmx6MckEBDR2EtNbViL7I
         uArqQCD1J6KyT1WkmtvF/ngXB4UpG5sBgtvKSorkAlHAFos8ASdEVI85CfhevlbfRXLz
         5kqw==
X-Gm-Message-State: AOAM530v4kDzr7lHc6niKpHAKiKfL04Fmgqz+tzstzZLI+O+8REUDBOt
        ybyHjzzsvpOEux4HHqFQGthBH7LzqX0/9r9VM6tzTBPAmOw8bSWNMmWJgZcL7e9jRXdTi86sJju
        CSxS/ot8l1p4vdVlj
X-Received: by 2002:a5d:48c2:: with SMTP id p2mr4624781wrs.366.1603967512653;
        Thu, 29 Oct 2020 03:31:52 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy6oeHJAySSImb1xyc8uQK3sXMWtfk43cxoaHH1j1eERXIPshAEEX5yo3EzVkpnZbA6eAIHEA==
X-Received: by 2002:a5d:48c2:: with SMTP id p2mr4624755wrs.366.1603967512446;
        Thu, 29 Oct 2020 03:31:52 -0700 (PDT)
Received: from localhost ([151.66.29.159])
        by smtp.gmail.com with ESMTPSA id x1sm4190106wrl.41.2020.10.29.03.31.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2020 03:31:51 -0700 (PDT)
Date:   Thu, 29 Oct 2020 11:31:48 +0100
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        ilias.apalodimas@linaro.org
Subject: Re: [PATCH net-next 2/4] net: page_pool: add bulk support for
 ptr_ring
Message-ID: <20201029103148.GA15697@lore-desk>
References: <cover.1603824486.git.lorenzo@kernel.org>
 <cd58ca966fbe11cabbd6160decea6ce748ebce9f.1603824486.git.lorenzo@kernel.org>
 <20201029111329.79b86c00@carbon>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="UugvWAfsgieZRqgk"
Content-Disposition: inline
In-Reply-To: <20201029111329.79b86c00@carbon>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--UugvWAfsgieZRqgk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Tue, 27 Oct 2020 20:04:08 +0100
> Lorenzo Bianconi <lorenzo@kernel.org> wrote:
>=20
> > +void page_pool_put_page_bulk(struct page_pool *pool, void **data,
> > +			     int count)
> > +{
> > +	struct page *page_ring[XDP_BULK_QUEUE_SIZE];
>=20
> Maybe we could reuse the 'data' array instead of creating a new array
> (2 cache-lines long) for the array of pages?

I agree, I will try to reuse the data array for that

>=20
> > +	int i, len =3D 0;
> > +
> > +	for (i =3D 0; i < count; i++) {
> > +		struct page *page =3D virt_to_head_page(data[i]);
> > +
> > +		if (unlikely(page_ref_count(page) !=3D 1 ||
> > +			     !pool_page_reusable(pool, page))) {
> > +			page_pool_release_page(pool, page);
> > +			put_page(page);
> > +			continue;
> > +		}
> > +
> > +		if (pool->p.flags & PP_FLAG_DMA_SYNC_DEV)
> > +			page_pool_dma_sync_for_device(pool, page, -1);
>=20
> Here we sync the entire DMA area (-1), which have a *huge* cost for
> mvneta (especially on EspressoBin HW).  For this xdp_frame->len is
> unfortunately not enough.  We will need the *maximum* length touch by
> (1) CPU and (2) remote device DMA engine.  DMA-TX completion knows the
> length for (2).  The CPU length (1) is max of original xdp_buff size
> and xdp_frame->len, because BPF-helpers could have shrinked the size.
> (tricky part is that xdp_frame->len isn't correct in-case of header
> adjustments, thus like mvneta_run_xdp we to calc dma_sync size, and
> store this in xdp_frame, maybe via param to xdp_do_redirect). Well, not
> sure if it is too much work to transfer this info, for this use-case.

I was thinking about that but I guess point (1) is tricky since "cpu length"
can be changed even in the middle by devmaps or cpumaps (not just in the dr=
iver
rx napi loop). I guess we can try to address this point in a subsequent ser=
ies.
Agree?

Regards,
Lorenzo

>=20
> > +
> > +		page_ring[len++] =3D page;
>=20
> > +	}
> > +
> > +	page_pool_ring_lock(pool);
> > +	for (i =3D 0; i < len; i++) {
> > +		if (__ptr_ring_produce(&pool->ring, page_ring[i]))
> > +			page_pool_return_page(pool, page_ring[i]);
> > +	}
> > +	page_pool_ring_unlock(pool);
> > +}
> > +EXPORT_SYMBOL(page_pool_put_page_bulk);
>=20
>=20
>=20
> --=20
> Best regards,
>   Jesper Dangaard Brouer
>   MSc.CS, Principal Kernel Engineer at Red Hat
>   LinkedIn: http://www.linkedin.com/in/brouer
>=20

--UugvWAfsgieZRqgk
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCX5qaEQAKCRA6cBh0uS2t
rMB1APsHlY9DgZ6UUlRWPu0CuQqAE2a2+cAVKEjopWKiSVMc4gEAitWZ+HVdtm2x
8oU/bTR7UYzMb0UTwdiLEn982BdxWAI=
=Pl//
-----END PGP SIGNATURE-----

--UugvWAfsgieZRqgk--

