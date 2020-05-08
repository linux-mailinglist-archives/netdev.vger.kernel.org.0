Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60DF51CA2A8
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 07:30:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725937AbgEHFaX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 01:30:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725875AbgEHFaX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 May 2020 01:30:23 -0400
Received: from mail-qt1-x844.google.com (mail-qt1-x844.google.com [IPv6:2607:f8b0:4864:20::844])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB9A7C05BD43
        for <netdev@vger.kernel.org>; Thu,  7 May 2020 22:30:22 -0700 (PDT)
Received: by mail-qt1-x844.google.com with SMTP id h26so362962qtu.8
        for <netdev@vger.kernel.org>; Thu, 07 May 2020 22:30:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=8Twha4r7DnWpU5y1uh8/ygFgFxB6QBolAggUkORRRac=;
        b=kVY4d9jF1HmknnubpQVrunfmu8qIfzSojBk6loFj0wKuignRCNGDAfnLYJxfdTKLT9
         BqX455HsQjgwaRRvZd2+SjAY37ZSDs3r2ERyyVFMQP458ry/mulA8DzN7nLXg/NKVg1v
         Izun5U/c7o5heGB5/hpgFjmMHVc4M5RM37c3/KgVH5U2jIWbul8t0uLH1zyNesaQO3L3
         ezKI2m1VvENbSJ5nIjvMGp+M5hgNquy9gUciDcvSZwsZgb1Fy1LMPB7um7381Uq8FEib
         HnXX75k7L1s0uBmrxemH7nM+5XGr4mvgAG17KQ0Ox6NWZ65V7TfvhbKvkGv5BnXQwE3+
         rHzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=8Twha4r7DnWpU5y1uh8/ygFgFxB6QBolAggUkORRRac=;
        b=SvCyZ89Jk8Vxf3m98Ycc6/PX6ISVsXPvBAqSHGwKYZs1GYGM6YMoZLr6LYxgmTuMS7
         bCpV8sbrW4sGBkm8RK6lA1F0mvcF4mCtLaw2rTLoNHdeROiJAF1urGHIWXNE5frZ3iNq
         X0QkshPmYX8GueW+5Z2nEYii2UB5hy6jF1FZ7mZSfR8SfGZkpMi3ryoZCFsmi8EJLn9R
         VScsLO6ufWVYyEGVQPkL3oAn3StB5WG4vCSmm0ttTpwfUVoVhqgj1MdL/Pd2hoMvS4ND
         T2v3f1fDhX+OXccCtmkCOQgfqIVAIGX4+fs0E4FtR5/uC6nVzv+k1hWkl9eUvwZ31/IQ
         OZrA==
X-Gm-Message-State: AGi0PuZx3u8tLx6lQ0W7SkzwFY+A4LHXUosspI1f/+tXVdrkwnu1vlea
        /wPbG5Do0I8sH9/SVrQ0Gn0=
X-Google-Smtp-Source: APiQypI4yaGgS4+56ZimT0w5YlhV1BgU2Po8TMR3iM/GN4RlybCHnEuBhAUPccw4km8t4qjLjYlgbg==
X-Received: by 2002:ac8:6159:: with SMTP id d25mr1190500qtm.70.1588915822086;
        Thu, 07 May 2020 22:30:22 -0700 (PDT)
Received: from pek-khao-d2.corp.ad.wrs.com (unknown-105-123.windriver.com. [147.11.105.123])
        by smtp.gmail.com with ESMTPSA id v2sm619695qth.66.2020.05.07.22.30.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 May 2020 22:30:21 -0700 (PDT)
Date:   Fri, 8 May 2020 13:30:15 +0800
From:   Kevin Hao <haokexin@gmail.com>
To:     Sunil Kovvuri <sunil.kovvuri@gmail.com>
Cc:     Linux Netdev List <netdev@vger.kernel.org>,
        Sunil Goutham <sgoutham@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        hariprasad <hkelam@marvell.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] octeontx2-pf: Use the napi_alloc_frag() to alloc the
 pool buffers
Message-ID: <20200508053015.GB3222151@pek-khao-d2.corp.ad.wrs.com>
References: <20200508040728.24202-1-haokexin@gmail.com>
 <CA+sq2CfMoOhrVz7tMkKiM3BwAgoyMj6i2RWz0JWwvpBMCO3Whg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="3uo+9/B/ebqu+fSQ"
Content-Disposition: inline
In-Reply-To: <CA+sq2CfMoOhrVz7tMkKiM3BwAgoyMj6i2RWz0JWwvpBMCO3Whg@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--3uo+9/B/ebqu+fSQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 08, 2020 at 10:18:27AM +0530, Sunil Kovvuri wrote:
> On Fri, May 8, 2020 at 9:43 AM Kevin Hao <haokexin@gmail.com> wrote:
> >
> > In the current codes, the octeontx2 uses its own method to allocate
> > the pool buffers, but there are some issues in this implementation.
> > 1. We have to run the otx2_get_page() for each allocation cycle and
> >    this is pretty error prone. As I can see there is no invocation
> >    of the otx2_get_page() in otx2_pool_refill_task(), this will leave
> >    the allocated pages have the wrong refcount and may be freed wrongly.
>=20
> Thanks for pointing, will fix.
>=20
> > 2. It wastes memory. For example, if we only receive one packet in a
> >    NAPI RX cycle, and then allocate a 2K buffer with otx2_alloc_rbuf()
> >    to refill the pool buffers and leave the remain area of the allocated
> >    page wasted. On a kernel with 64K page, 62K area is wasted.
> >
> > IMHO it is really unnecessary to implement our own method for the
> > buffers allocate, we can reuse the napi_alloc_frag() to simplify
> > our code.
> >
> > Signed-off-by: Kevin Hao <haokexin@gmail.com>
>=20
> Have you measured performance with and without your patch ?

I will do performance compare later. But I don't think there will be measur=
able
difference.

> I didn't use napi_alloc_frag() as it's too costly, if in one NAPI
> instance driver
> receives 32 pkts, then 32 calls to napi_alloc_frag() and updates to page =
ref
> count per fragment etc are costly.

No, the page ref only be updated at the page allocation and all the space a=
re
used. In general, the invocation of napi_alloc_frag() will not cause the up=
date
of the page ref. So in theory, the count of updating page ref should be red=
uced
by using of napi_alloc_frag() compare to the current otx2 implementation.

Thanks,
Kevin

> When traffic rate is less then it
> may not matter
> much.
>=20
> Thanks,
> Sunil.

--3uo+9/B/ebqu+fSQ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEHc6qFoLCZqgJD98Zk1jtMN6usXEFAl607mcACgkQk1jtMN6u
sXGR/Qf/V1TmW4Q7zG57kgJjHWXTai8WhGbHoiQ/hU6nvkcQFXFyuf5L7J7mQdcr
Pl9d/PIKEmq1kq2R4CX5pyhzXDu2gvomtPCswm7fhOEDSHcBpsRuHQLkQSihVG0T
Ox6C6tyGCxi9cMCp++K6rRXgkxT8qgpAacBLOCmAj+oLFXAtxirxKhR+9V9AdKHt
qMCvvlBNtg7wX17ZmcCEiwerLJV3Ght2Q+Iy9kxfqKmuqJXhbzf5f80hqX+gH1bB
RbFI56jt8i1ZyYzJKR7jKBYU3rgnTnm7TgBj8WJMf1e1oJKh6O5cPzWmsNWD66uv
6Xi6K1pOp+VSANkP57xdFtD7agqatw==
=dV6V
-----END PGP SIGNATURE-----

--3uo+9/B/ebqu+fSQ--
