Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17090423A98
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 11:32:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237872AbhJFJef (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 05:34:35 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:27041 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230394AbhJFJee (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Oct 2021 05:34:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633512762;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ECWtJ9QunQv65wT2NBwXFG9aqNsz/pIxF2+1QOW9wjA=;
        b=Pky/zpLPt2S8lWu43L7lHD0YXGJ9rVfBueLM73kbu22HTL4MjItzwvfxwjW9fCsJ4xVHlI
        WN/+am1xpWCWS4ZG5z6Kmsq13dzJ4PDdDm7FmhjIAXwLG8cApviXFo+cO+6g89cQ9uf8GZ
        W9G7EY9+OfhqwW5q84sgEsQdtaiNU44=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-41-o24FW8fVPIa7wdAccA8Pvg-1; Wed, 06 Oct 2021 05:32:40 -0400
X-MC-Unique: o24FW8fVPIa7wdAccA8Pvg-1
Received: by mail-ed1-f72.google.com with SMTP id 2-20020a508e02000000b003d871759f5dso2069131edw.10
        for <netdev@vger.kernel.org>; Wed, 06 Oct 2021 02:32:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ECWtJ9QunQv65wT2NBwXFG9aqNsz/pIxF2+1QOW9wjA=;
        b=gDlFvcRjlCT6tyXhXOa057ByM5TmRDfhBvIMAhqNyY7YfP58QleaGYV6cpoeVtLd9v
         Dl6OkcP6trQpw9kkMl3nWBkem/3gGWnJOTAarSnaG4LcF4m7NeAs1a2jMTHQs0RJW1+w
         GSIFtZppmzMNkktzyUhPdGrmEGiQlVQWPQjP6X9fv33P46Is9yI2ZlRq6UvIVQQF97Dd
         vJ5cOyPB4T8uVt0K5skIKpUPIQ02/s0zKDQpGXueFv4dNhXr4CqceNtS5+Ps4rJ+1rTE
         tnDmyvtr3rJMadFXnEGB7fA3vRoVe9+vSjfxb3GvycRnNxtHl9INh4F54dPmbKyCm2wo
         G8Dw==
X-Gm-Message-State: AOAM531TgwlYJ5zFEdyO/gFd7SjfWA3y0FGIT+S4h9o5+gv8R9b+gbE4
        GYoLf0HWs6/ceIaUxa4cq8Q9WO7YResY5j1gFHdOUN5Srz5DfbdOIYGomvCnpa3J/YxP0H1ufp2
        L8jxOkVtgujpIJ3df
X-Received: by 2002:a05:6402:2345:: with SMTP id r5mr23107525eda.202.1633512759420;
        Wed, 06 Oct 2021 02:32:39 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwb2h3XjvEjOiYMPuThj33eVzgF4sHQOJ008r2ma1zLc9i0RRK6Xywd9T4NbpEbKL9DwY6ZNg==
X-Received: by 2002:a05:6402:2345:: with SMTP id r5mr23107502eda.202.1633512759227;
        Wed, 06 Oct 2021 02:32:39 -0700 (PDT)
Received: from localhost (net-130-25-199-50.cust.vodafonedsl.it. [130.25.199.50])
        by smtp.gmail.com with ESMTPSA id rv25sm5944673ejb.21.2021.10.06.02.32.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Oct 2021 02:32:38 -0700 (PDT)
Date:   Wed, 6 Oct 2021 11:32:36 +0200
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, shayagr@amazon.com,
        John Fastabend <john.fastabend@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Saeed Mahameed <saeed@kernel.org>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        tirthendu.sarkar@intel.com
Subject: Re: [PATCH v14 bpf-next 00/18] mvneta: introduce XDP multi-buffer
 support
Message-ID: <YV1tNFy971iqq0Ay@lore-desk>
References: <cover.1631289870.git.lorenzo@kernel.org>
 <20210916095539.4696ae27@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CACAyw9-8t8RpJgJUTd7u6bOLnJ1xQsgK7z37QrL9T1FUaJ7WNQ@mail.gmail.com>
 <87v92jinv7.fsf@toke.dk>
 <CACAyw99S9v658UyiKz3ad4kja7rDNfYv+9VOXZHCUOtam_C8Wg@mail.gmail.com>
 <CAADnVQ+XXGUxzqMdbPMYf+t_ViDkqvGDdogrmv-wH-dckzujLw@mail.gmail.com>
 <20210929122229.1d0c4960@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <87mtnvi0bc.fsf@toke.dk>
 <YVbO/kit/mjWTrv6@lore-desk>
 <20211001113528.79f35460@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="dJuMWhS9OkhSNQ/M"
Content-Disposition: inline
In-Reply-To: <20211001113528.79f35460@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--dJuMWhS9OkhSNQ/M
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Fri, 1 Oct 2021 11:03:58 +0200 Lorenzo Bianconi wrote:
> > Can you please check if the code above is aligned to current requiremen=
ts or if
> > it is missing something?
> > If this code it is fine, I guess we have two option here:
> > - integrate the commits above in xdp multi-buff series (posting v15) an=
d work on
> >   the verfier code in parallel (if xdp_mb_pointer helper is not require=
d from day0)
> > - integrate verfier changes in xdp multi-buff series, drop bpf_xdp_load=
_bytes
> >   helper (probably we will still need bpf_xdp_store_bytes) and introduce
> >   bpf_xdp_pointer as new ebpf helper.
>=20
> It wasn't clear to me that we wanted bpf_xdp_load_bytes() to exist.
> But FWIW no preference here.
>=20

ack, same here. Any other opinion about it?

Regards,
Lorenzo

--dJuMWhS9OkhSNQ/M
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCYV1tNAAKCRA6cBh0uS2t
rG9nAQDzRFQNbjpBmGFTPDTbGEDK2wN/GbIWFg9xqUtOkdPHJgD/clbax0bO8iir
IHebO6l7i4OZq1Wi3wYrxjIRmdc4pgw=
=i6/e
-----END PGP SIGNATURE-----

--dJuMWhS9OkhSNQ/M--

