Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA48610283F
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 16:40:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728106AbfKSPkD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 10:40:03 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:58820 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727505AbfKSPkD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 10:40:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574178002;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=DzgsKL37q1Wdl79gJu9Kvyc0hNyjuuod1WbPJh4SwKM=;
        b=GBdLa6Mc4URmSqYnGhgiG7rPOII+5rbGH2IKvtDRQ5rRWGQEul127XF2ZRJae3tl2qDCRI
        /dsaDkD3qNuA+t6CbYvMiTJXabtiG0mKuh9O/ZczkI64oTux5dXqQMkqcBLN4eBV1N4zh1
        7XfFei9yJiAejRQzLMvH49NtMgMIcSY=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-237-JMyYs1kwMBC0Qwj0fODgfg-1; Tue, 19 Nov 2019 10:38:32 -0500
X-MC-Unique: JMyYs1kwMBC0Qwj0fODgfg-1
Received: by mail-wm1-f70.google.com with SMTP id y133so2446359wmd.8
        for <netdev@vger.kernel.org>; Tue, 19 Nov 2019 07:38:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=xi73gLE1nyomaFPvjmdpS68gt8I25Vk9EcDuHkx/tiw=;
        b=bndEMRNqwMQ4cFVqGErkwT94IwBF6Dna5lDrVMIS0fMiG6yYMqaqVNEVLuE/xH7NQi
         alf5k9/tWbxI6oer0PYkSRqvSr+N8Et/uIKnmYLC89ZLeC9gpQyfP3z10C33FRT+4cNF
         r6gGjC2BienfRiH8Irv/uH3/nPEkEj8u0F5FxTGsjQWDwD27tcnp/cuInPcnnGJIinMs
         YsgkVK94Btp2Ddi+XGlvyM1jTdz/ICRIq+agyqOwI9zl1D0+LayqimwftGs0ApxfFlY2
         EWZvlmnFAQtoSvVqzHovTnhc2U+Lvjq5VW3UBzNJFSD6E0D+ckNAaTh6LNkAcnvid8mL
         fwZA==
X-Gm-Message-State: APjAAAVv//deSOMSSMkZYPxM4laz8Q+woiAZMVDQ0bMY8W4GO+5igjzz
        rlMokKaH+le7Gny8QAoAU7k/OaL1u900fSMcVr5ZKqHBy4fs5W4dN6PZ7TQy6aWz8ps2gmO7gIp
        oZXt9gv2cDwKcCccw
X-Received: by 2002:a05:6000:10c5:: with SMTP id b5mr39976273wrx.121.1574177911745;
        Tue, 19 Nov 2019 07:38:31 -0800 (PST)
X-Google-Smtp-Source: APXvYqzJ1i7HWhK2centwxuI3YvYXzQnZbYiKA6QWxb+v4ib/adkERMfv8iAPcVkIkO2UEoiRO8SpQ==
X-Received: by 2002:a05:6000:10c5:: with SMTP id b5mr39976230wrx.121.1574177911454;
        Tue, 19 Nov 2019 07:38:31 -0800 (PST)
Received: from localhost.localdomain ([77.139.212.74])
        by smtp.gmail.com with ESMTPSA id f188sm3512382wmf.3.2019.11.19.07.38.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Nov 2019 07:38:30 -0800 (PST)
Date:   Tue, 19 Nov 2019 17:38:27 +0200
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org,
        davem@davemloft.net, ilias.apalodimas@linaro.org,
        mcroce@redhat.com, jonathan.lemon@gmail.com
Subject: Re: [PATCH v4 net-next 3/3] net: mvneta: get rid of huge dma sync in
 mvneta_rx_refill
Message-ID: <20191119153827.GE3449@localhost.localdomain>
References: <cover.1574083275.git.lorenzo@kernel.org>
 <7bd772e5376af0c55e7319b7974439d4981aa167.1574083275.git.lorenzo@kernel.org>
 <20191119123850.5cd60c0e@carbon>
 <20191119121911.GC3449@localhost.localdomain>
 <20191119155143.0683f754@carbon>
MIME-Version: 1.0
In-Reply-To: <20191119155143.0683f754@carbon>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Mimecast-Spam-Score: 0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="2hMgfIw2X+zgXrFs"
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--2hMgfIw2X+zgXrFs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

[...]
> > > > -=09=09page_pool_recycle_direct(rxq->page_pool,
> > > > -=09=09=09=09=09 virt_to_head_page(xdp->data));
> > > > +=09=09__page_pool_put_page(rxq->page_pool,
> > > > +=09=09=09=09     virt_to_head_page(xdp->data),
> > > > +=09=09=09=09     xdp->data_end - xdp->data_hard_start,
> > > > +=09=09=09=09     true); =20
> > >=20
> > > This does beg for the question: Should we create an API wrapper for
> > > this in the header file?
> > >=20
> > > But what to name it?
> > >=20
> > > I know Jonathan doesn't like the "direct" part of the  previous funct=
ion
> > > name page_pool_recycle_direct.  (I do considered calling this 'napi'
> > > instead, as it would be inline with networking use-cases, but it seem=
ed
> > > limited if other subsystem end-up using this).
> > >=20
> > > Does is 'page_pool_put_page_len' sound better?
> > >=20
> > > But I want also want hide the bool 'allow_direct' in the API name.
> > > (As it makes it easier to identify users that uses this from softirq)
> > >=20
> > > Going for 'page_pool_put_page_len_napi' starts to be come rather long=
. =20
> >=20
> > What about removing the second 'page'? Something like:
> > - page_pool_put_len_napi()
>=20
> Well, we (unfortunately) already have page_pool_put(), which is used
> for refcnt on the page_pool object itself.

__page_pool_put_page(pp, data, len, true) is a more generic version of
page_pool_recycle_direct where we can specify even the length. So what abou=
t:

- page_pool_recycle_len_direct
- page_pool_recycle_len_napi

Regards,
Lorenzo

>=20
> --=20
> Best regards,
>   Jesper Dangaard Brouer
>   MSc.CS, Principal Kernel Engineer at Red Hat
>   LinkedIn: http://www.linkedin.com/in/brouer
>=20

--2hMgfIw2X+zgXrFs
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCXdQMcAAKCRA6cBh0uS2t
rEu2APwPIlf6Zw4NUGutChH9q/nqOvI000E9Aij308E+p3K4bwD/Rm9lsbgcv1Pl
EVmLPqS0ln7WjBY30eCBHJj3m47CqAA=
=NmDZ
-----END PGP SIGNATURE-----

--2hMgfIw2X+zgXrFs--

