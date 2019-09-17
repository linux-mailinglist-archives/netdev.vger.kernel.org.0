Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A96CB47E8
	for <lists+netdev@lfdr.de>; Tue, 17 Sep 2019 09:12:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404437AbfIQHM2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Sep 2019 03:12:28 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44520 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387879AbfIQHM1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Sep 2019 03:12:27 -0400
Received: from mail-wr1-f71.google.com ([209.85.221.71])
        by youngberry.canonical.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <marcelo.cerri@canonical.com>)
        id 1iA7ez-0008Ho-Ls
        for netdev@vger.kernel.org; Tue, 17 Sep 2019 07:12:25 +0000
Received: by mail-wr1-f71.google.com with SMTP id v18so933803wro.16
        for <netdev@vger.kernel.org>; Tue, 17 Sep 2019 00:12:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=3mJ7H9Vd/KYYHK2hKEza3o32eBLR4dUC6S3+MRraUY0=;
        b=ARWFZrcH3DAnOZlMd5hVRIZS5u6LmzMVxUOfO5a3ETD4sJB2x/mGyd1+L7V15i2Z8Q
         tjTEgnAYJlRntTZ74aJvmNxD79laKY1KrU9U8RPmVaamDQ5MmUYsbLLIRAyW96qXcafr
         yqW4Z3qRbEOJ7IxnhFFVPA5zqSMiT6Vkst/ls5sTWxP9UG3YzYVFiR/nJpZavGeS3zU2
         2FPp4KafgN0ulTS74iomWUSIz9rnghVvMhnGhMgllCXOB1A3too2Bm0oJtQ97/91nt9R
         IaqkHhs/98YEisRyzeA9x2ry/YGSPycX/3aC117pNuAgUwOVBA5yGBJumngRApesYy9W
         L3tA==
X-Gm-Message-State: APjAAAXObCHXiHni9kHlkRCZ2whbE2MDXkjRliSoogCVQSGau1r/K00n
        nuoyYtxGfnoWhFPEr7blXldZaXHECxxAVnMsLgjekvRfHQFK92rCrcQ72QUpuDV1fwFqTrgQ9YS
        q6dlcVv2vQxDXXfY+c8mmcT4J9AOCEJk5
X-Received: by 2002:a05:6000:110f:: with SMTP id z15mr1536461wrw.328.1568704345357;
        Tue, 17 Sep 2019 00:12:25 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzNNylg8z2QXdHZ6GX64UAW0YItRdOYiMPBiABGeWFNQO1sX9E5y78KYLlTPB8RardpZerdyQ==
X-Received: by 2002:a05:6000:110f:: with SMTP id z15mr1536441wrw.328.1568704345031;
        Tue, 17 Sep 2019 00:12:25 -0700 (PDT)
Received: from gallifrey (static-dcd-cqq-121001.business.bouyguestelecom.com. [212.194.121.1])
        by smtp.gmail.com with ESMTPSA id l13sm1267363wmj.25.2019.09.17.00.12.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Sep 2019 00:12:23 -0700 (PDT)
Date:   Tue, 17 Sep 2019 04:12:22 -0300
From:   Marcelo Henrique Cerri <marcelo.cerri@canonical.com>
To:     shuah <shuah@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] selftests/net: replace AF_MAX with INT_MAX in socket.c
Message-ID: <20190917071222.6nfzmcxt4kxzgpki@gallifrey>
References: <20190916150337.18049-1-marcelo.cerri@canonical.com>
 <212adcf8-566e-e06d-529f-f0ac18bd6a35@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="sjt5zxil7puotrgx"
Content-Disposition: inline
In-Reply-To: <212adcf8-566e-e06d-529f-f0ac18bd6a35@kernel.org>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--sjt5zxil7puotrgx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

So the problem arises because the headers we have in userspace might
be older and not match what we have in the kernel. In that case, the
actual value of AF_MAX in the userspace headers might be a valid
protocol family in the new kernel.

That happens relatively often for us because we support different
kernel versions at the same time in a given Ubuntu series.

An alternative is to use the headers we have in the kernel tree, but I
believe that might cause other issues.

On Mon, Sep 16, 2019 at 10:09:13AM -0600, shuah wrote:
> On 9/16/19 9:03 AM, Marcelo Henrique Cerri wrote:
> > Use INT_MAX instead of AF_MAX, since libc might have a smaller value
> > of AF_MAX than the kernel, what causes the test to fail.
> >=20
> > Signed-off-by: Marcelo Henrique Cerri <marcelo.cerri@canonical.com>
> > ---
> >   tools/testing/selftests/net/socket.c | 6 +++++-
> >   1 file changed, 5 insertions(+), 1 deletion(-)
> >=20
> > diff --git a/tools/testing/selftests/net/socket.c b/tools/testing/selft=
ests/net/socket.c
> > index afca1ead677f..10e75ba90124 100644
> > --- a/tools/testing/selftests/net/socket.c
> > +++ b/tools/testing/selftests/net/socket.c
> > @@ -6,6 +6,7 @@
> >   #include <sys/types.h>
> >   #include <sys/socket.h>
> >   #include <netinet/in.h>
> > +#include <limits.h>
> >   struct socket_testcase {
> >   	int	domain;
> > @@ -24,7 +25,10 @@ struct socket_testcase {
> >   };
> >   static struct socket_testcase tests[] =3D {
> > -	{ AF_MAX,  0,           0,           -EAFNOSUPPORT,    0 },
> > +	/* libc might have a smaller value of AF_MAX than the kernel
> > +	 * actually supports, so use INT_MAX instead.
> > +	 */
> > +	{ INT_MAX, 0,           0,           -EAFNOSUPPORT,    0  },
> >   	{ AF_INET, SOCK_STREAM, IPPROTO_TCP, 0,                1  },
> >   	{ AF_INET, SOCK_DGRAM,  IPPROTO_TCP, -EPROTONOSUPPORT, 1  },
> >   	{ AF_INET, SOCK_DGRAM,  IPPROTO_UDP, 0,                1  },
> >=20
>=20
> What failure are you seeing? It sounds arbitrary to use INT_MAX
> instead of AF_MAX. I think it is important to understand the
> failure first.
>=20
> Please note that AF_MAX is widely used in the kernel.
>=20
> thanks,
> -- Shuah

--=20
Regards,
Marcelo


--sjt5zxil7puotrgx
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEDWI6S4SUeUOX/xHQzxpLxzTV7UcFAl2Ah1YACgkQzxpLxzTV
7Ufo+gf8DIFj52cwhgSs/1wvN9sW40b15Wsaj2kzqF0UVueUb5nzGg5z8CYnW1wX
z+GLzbXJrts8i4PLO1UTcgPPTUXb3CJOyT5jZRehx1fN0fmMHr3DLmHhbRtz+m4G
IIHrcJxCk5vrH9LmXMFSUK42C7olzihTBDATk9sQ0drHvf7LV0cpRtqlY0i4tEwm
KnMVdTfjQLjCYcaAmvXr5X5EcdY9C1JsFnTjlrHbGSEiSp3Wrvxlal2FdMHRFXfe
sbYKKu2CCfob6EIFMyX6v6+DGdghrhNcx65DYgzPCXWX4TmPANGDqiPrEl/1sQow
nwCqqWSH0dNbaJyyAGtmfgZOLPGzyw==
=ikQl
-----END PGP SIGNATURE-----

--sjt5zxil7puotrgx--
