Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37BCD230AB3
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 14:55:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729549AbgG1Myy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 08:54:54 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:58954 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728604AbgG1Myy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 08:54:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595940892;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=SnIKWXiwvJb0HP6T4otIzgOvg5AF2J/y3MucPtT9UoA=;
        b=I8cDwtjL0OP94Huhdp52NlRxkvokDjrjPX5wE+2tbQLfs03vSNu0VXanaRNskhH9W2aZmI
        yBFBsop8L938mwJnFmS0kkifBlUDqRdWJxMfbSShoASrleCEvECHeWu1PvdKYkhG5g0ZuZ
        A85ZNT4NkfKDri9luOlC0G0nr7j0vG8=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-255-KU9hxXiyMqGn0mvr0z_gvg-1; Tue, 28 Jul 2020 08:54:50 -0400
X-MC-Unique: KU9hxXiyMqGn0mvr0z_gvg-1
Received: by mail-wr1-f71.google.com with SMTP id b13so2531109wrq.19
        for <netdev@vger.kernel.org>; Tue, 28 Jul 2020 05:54:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=SnIKWXiwvJb0HP6T4otIzgOvg5AF2J/y3MucPtT9UoA=;
        b=B/TYU4hqNdKLbLJ/4rfPFygihVfZrTBgV01tnhKNMhcjVa1E4+gqVxqpEbSD5W3TUM
         FyGDqEvShr3iizeaWdIAvu961RrKYF2q6bVZyZbG/I+37nd+dRTyx3+3AUaL3rjHLJdR
         mjwPAArO369CJUnEpZsTkpgYXSPupm8Vkb1EVRqCa+XGgcrP+bKV8ljdn2mLGWHcuZ0U
         8iV5Cpllju56Qi9VRb20cQeDsHUHqi5wbRCQsPWiQl0SQ7sreIIvNF9km1HMQ4ipPU/q
         XaM2xn4inGPQOqLMENWVOCbQPB7QmU9tMmngiZ/qQwLTK5P4Lhi/DvJKL5rnRjoF4x/a
         XoKQ==
X-Gm-Message-State: AOAM531yhxaUyuMAboREE2+wt9plBcr7NsupjM6EgxEwjTCek6CtTcZ9
        GdnDeHgjM3Pd8K4OfFezjoRRmTAZhmghw6QmNpOu0Kp+I55YV+u7JdTJdBdEloYy7ZEYZRgKkCi
        J8YP+9cFUQwtUdwXW
X-Received: by 2002:a7b:c95a:: with SMTP id i26mr4160361wml.106.1595940880996;
        Tue, 28 Jul 2020 05:54:40 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwr6tKQDzt9dg0D8UR/jxhjl/RfCFK5VYKiyGLzWUTHH9WOu8mxoU8YOUXn3S1bd3i/aBYwSg==
X-Received: by 2002:a7b:c95a:: with SMTP id i26mr4160332wml.106.1595940880759;
        Tue, 28 Jul 2020 05:54:40 -0700 (PDT)
Received: from localhost ([151.48.137.169])
        by smtp.gmail.com with ESMTPSA id a134sm4356280wmd.17.2020.07.28.05.54.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jul 2020 05:54:36 -0700 (PDT)
Date:   Tue, 28 Jul 2020 14:54:33 +0200
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     sameehj@amazon.com, davem@davemloft.net, netdev@vger.kernel.org,
        dwmw@amazon.com, zorik@amazon.com, matua@amazon.com,
        saeedb@amazon.com, msw@amazon.com, aliguori@amazon.com,
        nafea@amazon.com, gtzalik@amazon.com, netanel@amazon.com,
        alisaidi@amazon.com, benh@amazon.com, akiyano@amazon.com,
        ndagan@amazon.com, ast@kernel.org, daniel@iogearbox.net,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        john.fastabend@gmail.com, kpsingh@chromium.org, kuba@kernel.org,
        hawk@kernel.org, shayagr@amazon.com, lorenzo@kernel.org
Subject: Re: [PATCH RFC net-next 0/2] XDP multi buffer helpers
Message-ID: <20200728125433.GB286429@lore-desk>
References: <20200727125653.31238-1-sameehj@amazon.com>
 <20200728123327.GB25823@ranger.igk.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="xgyAXRrhYN0wYx8y"
Content-Disposition: inline
In-Reply-To: <20200728123327.GB25823@ranger.igk.intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--xgyAXRrhYN0wYx8y
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Mon, Jul 27, 2020 at 12:56:51PM +0000, sameehj@amazon.com wrote:
> > From: Sameeh Jubran <sameehj@amazon.com>
> >=20
> > This series is based on the series that Lorenzo sent [0].
>=20
> What is your final design for multi buffer support in XDP?
> Why don't you provide a single RFC that is fully functional but instead
> you're sending a bunch of separate RFCs?

Hi Maciej,

IMO the buffer layout is defined now (we will use the trailing part of the
"linear" area of the xdp_buff to store references for subsequent buffers li=
ke
we already do for skb).
What is not defined yet are the metadata (e.g. number of frames, total leng=
th, ..)
we want to pass to the bpf layer. This is the main reason why I sent this s=
eries
[1] as RFC, I want to collect feedbacks about this approach. For the moment=
 (at
least in my series) mb in xdp_buff is just used to indicate if this is a
multi-buff xdp_buff.

>=20
> IMHO it's a weird strategy. Not sure what others think about.
>=20

we did not coordinate, sorry for the noise.

Regards,
Lorenzo

[1] https://patchwork.ozlabs.org/project/netdev/cover/cover.1595503780.git.=
lorenzo@kernel.org/

> >=20
> > This series simply adds new bpf helpers for xdp mb support as well as
> > introduces a sample program that uses them.
> >=20
> > [0] - [RFC net-next 00/22] Introduce mb bit in xdp_buff/xdp_frame
>=20
> Direct link wouldn't hurt I guess :) Please also include all the previous
> discussions that took place on mailing list around this topic. This will
> make reviewers life easier I suppose. As I asked above, I'm not sure
> what's your final design for this feature.
>=20
> >=20
> > Sameeh Jubran (2):
> >   xdp: helpers: add multibuffer support
> >   samples/bpf: add bpf program that uses xdp mb helpers
> >=20
> >  include/uapi/linux/bpf.h       |  13 +++
> >  net/core/filter.c              |  60 ++++++++++++++
> >  samples/bpf/Makefile           |   3 +
> >  samples/bpf/xdp_mb_kern.c      |  66 ++++++++++++++++
> >  samples/bpf/xdp_mb_user.c      | 174 +++++++++++++++++++++++++++++++++=
++++++++
> >  tools/include/uapi/linux/bpf.h |  13 +++
> >  6 files changed, 329 insertions(+)
> >  create mode 100644 samples/bpf/xdp_mb_kern.c
> >  create mode 100644 samples/bpf/xdp_mb_user.c
> >=20
> > --=20
> > 2.16.6
> >=20
>=20

--xgyAXRrhYN0wYx8y
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCXyAgBgAKCRA6cBh0uS2t
rM7MAP45b9pMLmGhw/e6jc3lgkfC+D+cTI64lbemH8kuex7oVgEA/t6C/xLDj5Ri
6Hr0EZjrphIMUO+lkx4nACc24tJbCAM=
=NE+A
-----END PGP SIGNATURE-----

--xgyAXRrhYN0wYx8y--

