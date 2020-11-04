Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B28BA2A64B5
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 13:54:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729782AbgKDMyB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 07:54:01 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:21642 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729783AbgKDMyB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 07:54:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604494438;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=U3GfiVmojJ/giml1Tqa4nmxIiU4dmaRVwJTGJun6v7A=;
        b=H53uoGXgB5T858glinYI8OwBhp63a8C9rWPnOSG0tpFoKDfBPIzHTaxNQeKcYVUZjtwyd8
        VsvewDnoPVCBu0OPhEPbjEzhCTErxbVVIxkIKvT49teztv82YZy7f7gj8OKB7W9AjiqQbE
        UYA5zFt8vZb4rMszrpFsEIYf/Vs4lhU=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-24-Vkqcwv_sOTC9Sz0M96stRQ-1; Wed, 04 Nov 2020 07:53:54 -0500
X-MC-Unique: Vkqcwv_sOTC9Sz0M96stRQ-1
Received: by mail-wm1-f71.google.com with SMTP id y187so1179088wmy.3
        for <netdev@vger.kernel.org>; Wed, 04 Nov 2020 04:53:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=U3GfiVmojJ/giml1Tqa4nmxIiU4dmaRVwJTGJun6v7A=;
        b=HLql2NlNHix0GTb45/2prg9v2rBuQEy21Bi7IGfevgNAFDpskdd3Cqx1TKR7dirTTZ
         PjEviYTkry9+5bbgrnWRX4jsjcQBOFZmWg18WWQrc4U/uqcsm2Y6a/jBbQuLwUDM6cXh
         rfiQsFzfvvL3/TlGcX6A5702E87EO9r3uORV4CASe7lYNcileqwNknQ9aLmcJcr+dVF7
         qPp5VQ0XmoVGwnjmYmT1Tbr6N+ryKXbuYoJey+RSFFHgO8Z1uR1VMZZ5dGKvwcM0Z3/0
         OLRTqCcKzC2zmCn+mvzy28+GcuePRZwC1s9AziwbUha5KvwSG+cBwPlZLkCv17OEBu/0
         4zOg==
X-Gm-Message-State: AOAM531ki8xe4ObVFKwHHWsz9A7mzBrTESK30MPAFsx7aQqBAc+Rm2d6
        UK2GC62DxppMOvKjL8MxU9JFtAeB6qkOd1ubb7N5UrJNA5wyMAMkG/7geUZtmOQ/oKvMCCC4Tr8
        zx79Xzjfw87Wrev7Z
X-Received: by 2002:a1c:2d8f:: with SMTP id t137mr4373166wmt.26.1604494433176;
        Wed, 04 Nov 2020 04:53:53 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwqhue0FYtSpv7hREqFpU9VyHO+M/sHtBrZN1EZbG/t1LwNg38tJ9Yv3FhYG32ejNKMr9khhA==
X-Received: by 2002:a1c:2d8f:: with SMTP id t137mr4373147wmt.26.1604494432988;
        Wed, 04 Nov 2020 04:53:52 -0800 (PST)
Received: from localhost ([151.66.8.153])
        by smtp.gmail.com with ESMTPSA id a128sm2080408wmf.5.2020.11.04.04.53.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2020 04:53:52 -0800 (PST)
Date:   Wed, 4 Nov 2020 13:53:48 +0100
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        ilias.apalodimas@linaro.org, Ioana Ciornei <ioana.ciornei@nxp.com>,
        Ioana Radulescu <ruxandra.radulescu@nxp.com>
Subject: Re: [PATCH v3 net-next 1/5] net: xdp: introduce bulking for xdp tx
 return path
Message-ID: <20201104125348.GB11993@lore-desk>
References: <cover.1604484917.git.lorenzo@kernel.org>
 <5ef0c2886518d8ae1577c8b60ea6ef55d031673e.1604484917.git.lorenzo@kernel.org>
 <20201104121158.597fa64d@carbon>
 <20201104111902.GA11993@lore-desk>
 <20201104132834.07fc3dfd@carbon>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="QTprm0S8XgL7H0Dt"
Content-Disposition: inline
In-Reply-To: <20201104132834.07fc3dfd@carbon>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--QTprm0S8XgL7H0Dt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Wed, 4 Nov 2020 12:19:02 +0100
> Lorenzo Bianconi <lorenzo.bianconi@redhat.com> wrote:
>=20
> > > On Wed,  4 Nov 2020 11:22:54 +0100
> > > Lorenzo Bianconi <lorenzo@kernel.org> wrote:
> > >  =20
> >=20
> > [...]
> >=20
> > > > +/* XDP bulk APIs introduce a defer/flush mechanism to return
> > > > + * pages belonging to the same xdp_mem_allocator object
> > > > + * (identified via the mem.id field) in bulk to optimize
> > > > + * I-cache and D-cache.
> > > > + * The bulk queue size is set to 16 to be aligned to how
> > > > + * XDP_REDIRECT bulking works. The bulk is flushed when =20
> > >=20
> > > If this is connected, then why have you not redefined DEV_MAP_BULK_SI=
ZE?
> > >=20
> > > Cc. DPAA2 maintainers as they use this define in their drivers.
> > > You want to make sure this driver is flexible enough for future chang=
es.
> > >=20
> > > Like:
> > >=20
> > > diff --git a/include/net/xdp.h b/include/net/xdp.h
> > > index 3814fb631d52..44440a36f96f 100644
> > > --- a/include/net/xdp.h
> > > +++ b/include/net/xdp.h
> > > @@ -245,6 +245,6 @@ bool xdp_attachment_flags_ok(struct xdp_attachmen=
t_info *info,
> > >  void xdp_attachment_setup(struct xdp_attachment_info *info,
> > >                           struct netdev_bpf *bpf);
> > > =20
> > > -#define DEV_MAP_BULK_SIZE 16
> > > +#define DEV_MAP_BULK_SIZE XDP_BULK_QUEUE_SIZE =20
> >=20
> > my idea was to address it in a separated patch, but if you prefer I can=
 merge
> > this change in v4

sure, will do in v4.

Regards,
Lorenzo

>=20
> Please merge in V4.  As this patch contains the explanation, and we
> want to avoid too much churn (remember our colleagues need to backport
> and review this).
>=20
> --=20
> Best regards,
>   Jesper Dangaard Brouer
>   MSc.CS, Principal Kernel Engineer at Red Hat
>   LinkedIn: http://www.linkedin.com/in/brouer
>=20

--QTprm0S8XgL7H0Dt
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCX6KkWQAKCRA6cBh0uS2t
rJUnAP9J5wjqs75zYlgbQ24TkJx8NSzweAzGYMQBt1gMf5tQkQEAoz/fT9pUm+1D
dTIddZzlYGfm0TUgPT/SDrOU91LYnQg=
=MpCz
-----END PGP SIGNATURE-----

--QTprm0S8XgL7H0Dt--

