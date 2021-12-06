Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E23C46A598
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 20:23:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348455AbhLFT0n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 14:26:43 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:23991 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1348180AbhLFT0m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 14:26:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638818593;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dGoGIzzP2SmsxbyOR0K7PNjZ4Q2mqMhmxBKUDjQ7WpY=;
        b=IVtl+QWFa3VadDKWjOmsEjaTZFVrX1g2j/FIZQqdWI9I5zURQGbkqme43ll/yIZviimkES
        gg0UQtFXvQuYP9FWsOqKpAOesPPg5yjtUPuS2dm+g85LHCjmkcXG5TCELhYSpyvw3pDl4h
        l2KgynTTWRKSf5j9SsZMzwjVYlbIt+k=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-576-7bTYjcJ2NSye6aE2UwlO3Q-1; Mon, 06 Dec 2021 14:23:11 -0500
X-MC-Unique: 7bTYjcJ2NSye6aE2UwlO3Q-1
Received: by mail-wm1-f70.google.com with SMTP id o18-20020a05600c511200b00332fa17a02eso339264wms.5
        for <netdev@vger.kernel.org>; Mon, 06 Dec 2021 11:23:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=dGoGIzzP2SmsxbyOR0K7PNjZ4Q2mqMhmxBKUDjQ7WpY=;
        b=c0CT1lBK1a4QDwXInBYgnd/5zZiuqpIRnYkENpXzk8lSb1jI51d9SD8WJafR3NM2F9
         DuY+4avMVbPPigKYFaHI6HXPovh7sqoLZPVEYuthMz1AVttP4qRPRlfXr2lnZZrx5+6U
         5WWJ12fQBcWt9pAQUM+dWt3uvtsHkLH/hzNpFkOoMixMLNs11pgOh3l+iS21EtJczIfP
         N2SfRO/7swfIqck8JphMCWq3VgVHt7Z2vbDZjgr7/hIrKlxIoo7S9DLB1cGdSlPko3zP
         f+0QuukxdTaX09cplwwEndlvW5x0GPDD0an7bhZUnAtGoF8nMX+Yn8soaSlvjdcuT3rZ
         OZdw==
X-Gm-Message-State: AOAM5309HvJHJY7vuS6CNN0RzjStBinXVLnRVB2qPA0NLiG7rUNr/Yvt
        GFmr5/pd1NEnEEKzhP3FgeJsEZJvcxs6VwuPssmazcKyr9QM5hzonnN+Db5YaQJpmfw8W23LNXc
        DFKlp+912eUMcYB7s
X-Received: by 2002:a05:600c:282:: with SMTP id 2mr636055wmk.91.1638818590572;
        Mon, 06 Dec 2021 11:23:10 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyDWjftM8Hklgj8tHmWgliadb70riGh7J0GbZeqXPm49cYaAyr0v92m99wFyP649qtFNRxFLA==
X-Received: by 2002:a05:600c:282:: with SMTP id 2mr636030wmk.91.1638818590344;
        Mon, 06 Dec 2021 11:23:10 -0800 (PST)
Received: from localhost (net-37-182-17-175.cust.vodafonedsl.it. [37.182.17.175])
        by smtp.gmail.com with ESMTPSA id l1sm1095161wrn.15.2021.12.06.11.23.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Dec 2021 11:23:09 -0800 (PST)
Date:   Mon, 6 Dec 2021 20:23:07 +0100
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        dsahern@kernel.org, brouer@redhat.com, echaudro@redhat.com,
        jasowang@redhat.com, alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, toke@redhat.com
Subject: Re: [PATCH v19 bpf-next 19/23] bpf: generalise tail call map
 compatibility check
Message-ID: <Ya5jG4DaiDTq7AvL@lore-desk>
References: <cover.1638272238.git.lorenzo@kernel.org>
 <15afc316a8727f171fd6e9ec93ab95ad23857b33.1638272239.git.lorenzo@kernel.org>
 <61ae4b768d787_8818208f@john.notmuch>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="Lo6xeZLWogwSCFsT"
Content-Disposition: inline
In-Reply-To: <61ae4b768d787_8818208f@john.notmuch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--Lo6xeZLWogwSCFsT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> > From: Toke Hoiland-Jorgensen <toke@redhat.com>
> >=20
> > The check for tail call map compatibility ensures that tail calls only
> > happen between maps of the same type. To ensure backwards compatibility=
 for
> > XDP multi-buffer we need a similar type of check for cpumap and devmap
> > programs, so move the state from bpf_array_aux into bpf_map, add xdp_mb=
 to
> > the check, and apply the same check to cpumap and devmap.
> >=20
> > Co-developed-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > Signed-off-by: Toke Hoiland-Jorgensen <toke@redhat.com>
> > ---
>=20
> ...
>=20
> > -bool bpf_prog_array_compatible(struct bpf_array *array, const struct b=
pf_prog *fp);
> > +static inline bool map_type_contains_progs(struct bpf_map *map)
>=20
> Maybe map_type_check_needed()? Just noticing that devmap doesn't contain
> progs.

ack, I am fine with it. Toke?

>=20
> > +{
> > +	return map->map_type =3D=3D BPF_MAP_TYPE_PROG_ARRAY ||
> > +	       map->map_type =3D=3D BPF_MAP_TYPE_DEVMAP ||
> > +	       map->map_type =3D=3D BPF_MAP_TYPE_CPUMAP;
> > +}
> > +
> > +bool bpf_prog_map_compatible(struct bpf_map *map, const struct bpf_pro=
g *fp);
> >  int bpf_prog_calc_tag(struct bpf_prog *fp);
>=20
> Otherwise LGTM.
>=20

--Lo6xeZLWogwSCFsT
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCYa5jGwAKCRA6cBh0uS2t
rK5tAP9KJ2QiYDo5fYwzY0cMnSgoZXRicdepnymj8o4ZeKQuxgD+KeuzF1iS2010
BnmRX9pXfv9r2sD6pbjC6N6c2AzJbAA=
=LxUW
-----END PGP SIGNATURE-----

--Lo6xeZLWogwSCFsT--

