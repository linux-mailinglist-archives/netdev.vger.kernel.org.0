Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB86D638B09
	for <lists+netdev@lfdr.de>; Fri, 25 Nov 2022 14:19:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229628AbiKYNTQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Nov 2022 08:19:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230003AbiKYNSj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Nov 2022 08:18:39 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E0783AC25;
        Fri, 25 Nov 2022 05:18:32 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id d20so3964548plr.10;
        Fri, 25 Nov 2022 05:18:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=sh9egS0q+jRg9Hr2Ro/e6B2QhTBDAhypQLkflwvcJNk=;
        b=Rpzc/NsTqHs4XOAB/dF3gMa16VVDD+lE5xLNqaNXYYii4RC/qcb60y73FIzIiRNJyd
         Efs7ZyaBHbAaQ8+Po7w3KZ4+jHdUSuKGYwrEgJjidWJIImcr2Y/LpklCMdIEiYF9h+wS
         IeJEc3/ETLEHyMNFs/1NUaMBJ2jA9Wb7gSC5ObO5ut88pTWj4BtOIhEmotKZD+F+xCtU
         CMtPlikUUzQOAb6fFAlXktXMlpKJ8LBydG+cvW6cbGB9EwITouzeKKvgOau/siq332cH
         S32ETH3CCBaqlJV2MQm/djlvIbrKHXOQ8gvUkWmliovoFVI0XQ0J+5KHeu6RJ7sPQ/Zn
         M+RA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sh9egS0q+jRg9Hr2Ro/e6B2QhTBDAhypQLkflwvcJNk=;
        b=S8lp6LkvPD9yRlGlKdeVZz24Vd2V2HuP+AFtapLQj0lN5Bcq4dUPXne+QNTNJZ8u6j
         oXjOLb0+XbdU/SyvHD6rAIWyayUNGKFHQ5UyKlY003vTBk9gyJ5BPJkRPGsmTtS8Ie7N
         e74ZcYIqW+rXc7qnjkfWc4LkAfRptSPfO/I3tIcyUGeGTikCHMvDKICuFpxkEVUPOg9v
         6PyVhkykifdMMapFk6iZKpIZSPGkEONdtmNQfacFpz2BczmZaSTbLpktSCAM/pb5+Ypq
         Z7VQ2KbxJsuUdmFSSzMxa/gV8w+xfL6mRqzHN59bWJfXfZfBZJ/9axvvCiFzFeBQote/
         ASeA==
X-Gm-Message-State: ANoB5plFuA94PHNKzrlRuBxrmbs+6YfCqg6t+8zmtxm6963xrq/JKcua
        D+gWqTPRYnskRz2ZvPJtmRw=
X-Google-Smtp-Source: AA0mqf6nvJOtY9EwK/QFM9i9Xj3TwTjEXaJBMK5hXnYovhvuY0t1PXQXVtB8+GkfgXUguaXthwd8Jw==
X-Received: by 2002:a17:902:b78b:b0:186:e2c3:91c6 with SMTP id e11-20020a170902b78b00b00186e2c391c6mr18331913pls.27.1669382311025;
        Fri, 25 Nov 2022 05:18:31 -0800 (PST)
Received: from debian.me (subs02-180-214-232-12.three.co.id. [180.214.232.12])
        by smtp.gmail.com with ESMTPSA id f2-20020a17090ac28200b00213a9e1f863sm2917128pjt.4.2022.11.25.05.18.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Nov 2022 05:18:30 -0800 (PST)
Received: by debian.me (Postfix, from userid 1000)
        id 7204F1032A4; Fri, 25 Nov 2022 20:18:26 +0700 (WIB)
Date:   Fri, 25 Nov 2022 20:18:26 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Shuah Khan <shuah@kernel.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] selftests/tls: Fix tls selftests dependency to correct
 algorithm
Message-ID: <Y4DAosu+ahAWpqrr@debian.me>
References: <20221125121905.88292-1-tianjia.zhang@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="FFvArqS5lY3fuL30"
Content-Disposition: inline
In-Reply-To: <20221125121905.88292-1-tianjia.zhang@linux.alibaba.com>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--FFvArqS5lY3fuL30
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 25, 2022 at 08:19:05PM +0800, Tianjia Zhang wrote:
> Commit d2825fa9365d ("crypto: sm3,sm4 - move into crypto directory") moves
> the SM3 and SM4 stand-alone library and the algorithm implementation for
> the Crypto API into the same directory, and the corresponding relationship
> of Kconfig is modified, CONFIG_CRYPTO_SM3/4 corresponds to the stand-alone
> library of SM3/4, and CONFIG_CRYPTO_SM3/4_GENERIC corresponds to the
> algorithm implementation for the Crypto API. Therefore, it is necessary
> for this module to depend on the correct algorithm.
>=20

I feel a rather confused. What about below?

```
Commit <commit> moves SM3 and SM4 algorithm implementations from
stand-alone library to crypto API. The corresponding configuration
options for the API version (generic) are CONFIG_CRYPTO_SM3_GENERIC and
CONFIG_CRYPTO_SM4_GENERIC, respectively.

Replace option selected in selftests configuration from the library version
to the API version.
```

> Fixes: d2825fa9365d ("crypto: sm3,sm4 - move into crypto directory")
> Cc: Jason A. Donenfeld <Jason@zx2c4.com>
> Cc: stable@vger.kernel.org # v5.19+
> Signed-off-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
> ---
>  tools/testing/selftests/net/config | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/tools/testing/selftests/net/config b/tools/testing/selftests=
/net/config
> index ead7963b9bf0..bd89198cd817 100644
> --- a/tools/testing/selftests/net/config
> +++ b/tools/testing/selftests/net/config
> @@ -43,5 +43,5 @@ CONFIG_NET_ACT_TUNNEL_KEY=3Dm
>  CONFIG_NET_ACT_MIRRED=3Dm
>  CONFIG_BAREUDP=3Dm
>  CONFIG_IPV6_IOAM6_LWTUNNEL=3Dy
> -CONFIG_CRYPTO_SM4=3Dy
> +CONFIG_CRYPTO_SM4_GENERIC=3Dy
>  CONFIG_AMT=3Dm

You mean the correct algo option is CONFIG_CRYPTO_SM4_GENERIC, right?

--=20
An old man doll... just what I always wanted! - Clara

--FFvArqS5lY3fuL30
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCY4DAmgAKCRD2uYlJVVFO
o7jsAPwJXlW94Bdpkl3DdQ06mf2SmEZpwOw/nm18Cb/VgMiGVgEA3jMOxgyJv+n1
AUocNbw9UZDY4GEUxCAwW20s9MSiZgo=
=qUZX
-----END PGP SIGNATURE-----

--FFvArqS5lY3fuL30--
