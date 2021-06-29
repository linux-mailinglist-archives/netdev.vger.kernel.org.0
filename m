Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 174443B787D
	for <lists+netdev@lfdr.de>; Tue, 29 Jun 2021 21:18:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234907AbhF2TUq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Jun 2021 15:20:46 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:47369 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233943AbhF2TUo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Jun 2021 15:20:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624994297;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=IqdDEOpnK3NKWLa8ezHVVL8U7Yuv2knGXjAeUbjwxys=;
        b=hOa0d7d8Cx7pf/fOdN8EzS8R9i3m5+DJ4UXw3d7BCFUGo7B12yqlLtFHifpw0rgsfdTKeb
        LstHmO0q99RHezU0D8oUEJwpZay+VELwy6m/P3bFxrhcXle/1fs4+wgcoaPBv7L/U1BmQd
        75F13tyZOIQg86buM9XUKaMddtKg4ZY=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-592-EhQ3IBsBMXODs6dICqVbHQ-1; Tue, 29 Jun 2021 15:18:14 -0400
X-MC-Unique: EhQ3IBsBMXODs6dICqVbHQ-1
Received: by mail-ed1-f69.google.com with SMTP id p13-20020a05640210cdb029039560ff6f46so4279795edu.17
        for <netdev@vger.kernel.org>; Tue, 29 Jun 2021 12:18:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=IqdDEOpnK3NKWLa8ezHVVL8U7Yuv2knGXjAeUbjwxys=;
        b=qrIN3CJ20bAxeIjdIT2KjP8IwZti3m+lqXl5tueXPUh7s746GkUr+Z7qKz4aFBcBqA
         d8xeqKYkZDxX4zrxtqjd5lrPebpGmpcrSbj7jHtEsifj+CZQ7ZkHqfOeP0Vcedmn3Rk9
         kL6X9+Ir8EtjfCP1URYFASd3jZa5+tniWNx02/tMfTBK15e7PG2JtKYqCxRQRKWWX8+g
         aN254Dh+RKCtvVDcXQ1NnQ5n0PPjGWn8DxfhfIUpLr73eyRMT/y02LOPYJ4ji5S/cBjm
         YoI+zWaGELv2LWd8JdZ1SE2BgM45EW/6CPhOm3QBnr7Llk+pypBHw9ZKwMxUO+gymiJB
         yHPA==
X-Gm-Message-State: AOAM5309VG1ruG39ewtUTb2pgKhqF1SeHJwjK46+Lpqp4nCCO4/bxc8c
        h2PK5JORqdtDTrbnJwh94fvbKK3BJAIZX3f0AGORNAeUhjR+sod/bxRmjgKuTtNfocmEhbJivw0
        /Ga3Y+G2zS56a6mxm
X-Received: by 2002:a17:906:5d1:: with SMTP id t17mr9312193ejt.320.1624994293520;
        Tue, 29 Jun 2021 12:18:13 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzlk8OzUQ1l5pgK2pv5qrOaH1T+7hSakRLbpDQfCO0FsuMl+BXv48QoVJizMEr8wVhX0apmWg==
X-Received: by 2002:a17:906:5d1:: with SMTP id t17mr9312177ejt.320.1624994293320;
        Tue, 29 Jun 2021 12:18:13 -0700 (PDT)
Received: from localhost (net-130-25-105-72.cust.vodafonedsl.it. [130.25.105.72])
        by smtp.gmail.com with ESMTPSA id og26sm8825532ejc.52.2021.06.29.12.18.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Jun 2021 12:18:12 -0700 (PDT)
Date:   Tue, 29 Jun 2021 21:18:09 +0200
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Jesper Dangaard Brouer <jbrouer@redhat.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        bpf <bpf@vger.kernel.org>, Netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
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
Message-ID: <YNtx8aBMM7/8b1lb@lore-desk>
References: <cover.1623674025.git.lorenzo@kernel.org>
 <8ad0d38259a678fb42245368f974f1a5cf47d68d.1623674025.git.lorenzo@kernel.org>
 <CAKgT0UcwYHXosz-XuQximak63=ugb9thEc=dkUUZzDpoPCH+Qg@mail.gmail.com>
 <YNsVyBw5i4hAHRN8@lore-desk>
 <20210629100852.56d995a6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAKgT0Ue1HKMpsBtoW=js2oMRAhcqSrAfTTmPC8Wc97G6=TiaZg@mail.gmail.com>
 <20210629113714.6d8e2445@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <e0b50540-0055-1f5c-af5f-0cd26616693a@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="6C7xQUoMCT1UaPk3"
Content-Disposition: inline
In-Reply-To: <e0b50540-0055-1f5c-af5f-0cd26616693a@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--6C7xQUoMCT1UaPk3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

>=20
> On 29/06/2021 20.37, Jakub Kicinski wrote:
> > On Tue, 29 Jun 2021 11:18:38 -0700 Alexander Duyck wrote:
> > > On Tue, Jun 29, 2021 at 10:08 AM Jakub Kicinski <kuba@kernel.org> wro=
te:
> > > > > ack, I agree. I will fix it in v10.
> > > > Why is XDP mb incompatible with LRO? I thought that was one of the =
use
> > > > cases (mentioned by Willem IIRC).
> > > XDP is meant to be a per packet operation with support for TX and
> > > REDIRECT, and LRO isn't routable. So we could put together a large LRO
> > > frame but we wouldn't be able to break it apart again. If we allow
> > > that then we are going to need a ton more exception handling added to
> > > the XDP paths.
> > >=20
> > > As far as GSO it would require setting many more fields in order to
> > > actually make it offloadable by any hardware.
> > It would require more work, but TSO seems to be explicitly stated
> > as what the series builds towards (in the cover letter). It's fine
> > to make choices we'd need to redo later, I guess, I'm just trying
> > to understand the why.
>=20
> This is also my understanding that LRO and TSO is what this patchset is
> working towards.
>=20
> Sorry, I don't agree or understand this requested change.
>=20
>=20

My understanding here is to use gso_size to store paged length of the
xdp multi-buffer. When converting the xdp_frame to a skb we will need
to overwrite it to support gro/lro. Is my understanding correct?

Regards,
Lorenzo

--6C7xQUoMCT1UaPk3
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCYNtx7wAKCRA6cBh0uS2t
rH/UAPwNEZ4DDX3WqxSWMTWy1OOH6l9pB0wd1UVwORqh4iBoUQEAnkjE2TT5F3KA
AOiKWMPB6kUrags5y7wvAi82DQNFbQ8=
=3YJx
-----END PGP SIGNATURE-----

--6C7xQUoMCT1UaPk3--

