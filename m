Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C878402AFB
	for <lists+netdev@lfdr.de>; Tue,  7 Sep 2021 16:45:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243978AbhIGOqn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Sep 2021 10:46:43 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:45218 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242953AbhIGOql (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Sep 2021 10:46:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631025935;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=jQty+6+MfzqLCOg7CeWYHT/3nN8vGq/pDTFW/sye+0U=;
        b=cCymXV4UncfUXFYsf1lrv4dcpH0K87zevATJatuqk86gcQMyERCGwCgqZxdJKsbmdxjRBJ
        vrF3qyz+jt/g0A/TNaWPBhcV09vHCwypE8watXuut3LwFoxQFFUkAKUcoVqdAe+EhIf74C
        mgR2uMD5Sho/hvstV0C/sKH9qDeKUeo=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-229-JaO4aI6nMlSklGaBI5ASZA-1; Tue, 07 Sep 2021 10:45:33 -0400
X-MC-Unique: JaO4aI6nMlSklGaBI5ASZA-1
Received: by mail-ej1-f72.google.com with SMTP id x6-20020a170906710600b005c980192a39so3817687ejj.9
        for <netdev@vger.kernel.org>; Tue, 07 Sep 2021 07:45:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=jQty+6+MfzqLCOg7CeWYHT/3nN8vGq/pDTFW/sye+0U=;
        b=lUN+78F1PyGfF2wdfUMUGNWo0VAiONrzOoidS8kpi2a/fMxYmr78e7BnpcZ03K8v24
         deTdm3pSR8W6napOMbYpWcG060AA2BeF9dmEdWBqMdyuN7rAXNGWq+TuemxZcWS9/Pv8
         OeCqxAAu1beha73tDhFlcYPJB7AY7DjM3REUfLl3GsVCpYvq5UG7qTk51f3iw9qHOpQO
         Ch9Y8VfeRicnS1059OosGMokVk0dZkhuMeVX4J6xkDUkGxottetjoPSt0WAyNzHM/tZ/
         fbRBZuUPy4JB1dpnb84y/Ht3+bTdYlZBGUM28uNwBHWqEFZXB5CV5aGmuJEq4uj0bfWB
         e8sw==
X-Gm-Message-State: AOAM5339+9qnZthTWSt5coJ4njUSGDXLsV2xBIFAu1uQMCh6dXGuiWXD
        7qRJEadqWGqy+TLx043hHA6KheC/v7ksyEjyj71bgA+dYN8NSG5Q1jRzoAwrxw1poNtzrQ4U86t
        fu1u2YsURikT7aYDK
X-Received: by 2002:a17:906:9a04:: with SMTP id ai4mr19289049ejc.453.1631025932620;
        Tue, 07 Sep 2021 07:45:32 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyD6Zt21EZyon8zzg/dsWd/SYUL34f7BbtmxzOSh51T1whm0ZwxEUzw8Idq3BNXc1vwqEQRKg==
X-Received: by 2002:a17:906:9a04:: with SMTP id ai4mr19289034ejc.453.1631025932428;
        Tue, 07 Sep 2021 07:45:32 -0700 (PDT)
Received: from localhost (net-37-116-49-210.cust.vodafonedsl.it. [37.116.49.210])
        by smtp.gmail.com with ESMTPSA id o3sm5650449eju.123.2021.09.07.07.45.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Sep 2021 07:45:31 -0700 (PDT)
Date:   Tue, 7 Sep 2021 16:45:28 +0200
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Jesper Dangaard Brouer <jbrouer@redhat.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, brouer@redhat.com, davem@davemloft.net,
        kuba@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        shayagr@amazon.com, john.fastabend@gmail.com, dsahern@kernel.org,
        echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, toke@redhat.com
Subject: Re: [PATCH v13 bpf-next 01/18] net: skbuff: add size metadata to
 skb_shared_info for xdp
Message-ID: <YTd7CGY9Dwm/2cfm@lore-desk>
References: <cover.1631007211.git.lorenzo@kernel.org>
 <1721d45800a333a46c2cdde0fd25eb6f02f49ecf.1631007211.git.lorenzo@kernel.org>
 <2bfd067e-a5aa-29ad-7b3c-0f8af61422ad@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="jqAO9cbFCjSYMUs/"
Content-Disposition: inline
In-Reply-To: <2bfd067e-a5aa-29ad-7b3c-0f8af61422ad@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--jqAO9cbFCjSYMUs/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

>=20
>=20
> On 07/09/2021 14.35, Lorenzo Bianconi wrote:
> > Introduce xdp_frags_tsize field in skb_shared_info data structure
> > to store xdp_buff/xdp_frame truesize (xdp_frags_tsize will be used
> > in xdp multi-buff support). In order to not increase skb_shared_info
> > size we will use a hole due to skb_shared_info alignment.
> > Introduce xdp_frags_size field in skb_shared_info data structure
> > reusing gso_type field in order to store xdp_buff/xdp_frame paged size.
> > xdp_frags_size will be used in xdp multi-buff support.
> >=20
> > Acked-by: John Fastabend <john.fastabend@gmail.com>
> > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > ---
> >   include/linux/skbuff.h | 6 +++++-
> >   1 file changed, 5 insertions(+), 1 deletion(-)
> >=20
> > diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> > index 6bdb0db3e825..1abeba7ef82e 100644
> > --- a/include/linux/skbuff.h
> > +++ b/include/linux/skbuff.h
> > @@ -522,13 +522,17 @@ struct skb_shared_info {
> >   	unsigned short	gso_segs;
> >   	struct sk_buff	*frag_list;
> >   	struct skb_shared_hwtstamps hwtstamps;
> > -	unsigned int	gso_type;
> > +	union {
> > +		unsigned int	gso_type;
> > +		unsigned int	xdp_frags_size;
> > +	};
> >   	u32		tskey;
> >   	/*
> >   	 * Warning : all fields before dataref are cleared in __alloc_skb()
> >   	 */
> >   	atomic_t	dataref;
> > +	unsigned int	xdp_frags_tsize;
>=20
> I wonder if we could call this variable: xdp_frags_truesize.
>=20
> As while reviewing patches I had to focus my eyes extra hard to tell the
> variables xdp_frags_size and xdp_frags_tsize from each-other.

sure, I will fix it in v14.

Regards,
Lorenzo

>=20
> --Jesper
>=20

--jqAO9cbFCjSYMUs/
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCYTd7BQAKCRA6cBh0uS2t
rOW5AQDXMXO66ZR4ItlOwKtUjh04SlRjEBaHcBXLEsTP/AfT+QEAsCofK2JIL/0h
nUPEKBnr/UC+mgutSe/w51eSeqhpaAA=
=v7tK
-----END PGP SIGNATURE-----

--jqAO9cbFCjSYMUs/--

