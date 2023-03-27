Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1ED06CA46A
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 14:46:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232391AbjC0MqJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 08:46:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232458AbjC0MqH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 08:46:07 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF92F4229;
        Mon, 27 Mar 2023 05:46:00 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id z19so8328181plo.2;
        Mon, 27 Mar 2023 05:46:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679921160;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Z95aEC3VowwbDydXMkdkVBsYGJB/RdmoSRYksYBwCmM=;
        b=iC524/hFn4xLAwZrIRXhkLBBCiMnoQtpV6Um5x7iT2zYbtAdzrXM1idf9KqgEC5tpi
         sjMG92hJHDJIgpJq4nPuDGw8pk+74byqa3FA/g4sbKo5cWZNmhNKMmZjwL/8n/MYb4fq
         ku3FQcffzWt+b1phUIgAmCuMVq+d1i8+SXt0G5jSPiR43URa+td6C7+GXZx6avqa9Hha
         cDPkvH2FcpFgqpp2D0orbAVXUDBlLU+qqQHDFHZV1Qz/pELHkppQcE8zDrUs2ao1nxaW
         IR9g08TTS/L4dzlQ75UsrjEEMTiOmx6P4mAOX97V/dSPW0cwUoTdcSIVPK6SU+muI6Bn
         3Yog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679921160;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Z95aEC3VowwbDydXMkdkVBsYGJB/RdmoSRYksYBwCmM=;
        b=k7JxQucROkaRNtBGM4kA1sLq1h127uWVtOvWZwZgDSYvQM7kCJWYOlmOEkbchlpyLZ
         0CgJ1J0jS0P/tcApcxNao9mvuefNfE19htTzlRGzRdd3MQBwSfYkX3BNubPDCAeUPrvs
         W4TJ8juZxu8UHo251Pi3QdoLETRmNsgoxYy7TOLL39+Xurf+3l3QEMwwvI0+vRyy7YBk
         O8dDDcWyl2PS0X3Nnkc7A1R22z0blC2qJOrT9B/nHkzlR20Zg3PEVfXpN39idHhd7sB2
         Fz6T6/iEUIGr4vWrcyj8+yGOQ7g22RlMGircWuMv0BEbDEw6mJBfPK8JRdz7VEtEtQfz
         4v9g==
X-Gm-Message-State: AAQBX9dQu55xkmusUJdK7lqVtfKcE8t0fVCuZ0lU6/H2HJo+OV2PwsRV
        ifRjsfV+JFX0rt0D3fAYUE0=
X-Google-Smtp-Source: AKy350ap62ppG0s042u8UkoazwzjutGDLV0pH53h92KIDUg+pCCsJVSVbtR9cNBD52rlGVoz3Zco5g==
X-Received: by 2002:a17:903:22cb:b0:19e:2eb5:712d with SMTP id y11-20020a17090322cb00b0019e2eb5712dmr12810061plg.25.1679921160122;
        Mon, 27 Mar 2023 05:46:00 -0700 (PDT)
Received: from debian.me (subs03-180-214-233-75.three.co.id. [180.214.233.75])
        by smtp.gmail.com with ESMTPSA id jl1-20020a170903134100b0019cc3d0e1basm19072705plb.112.2023.03.27.05.45.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Mar 2023 05:45:59 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
        id 7470310676A; Mon, 27 Mar 2023 19:45:55 +0700 (WIB)
Date:   Mon, 27 Mar 2023 19:45:55 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Donald Hunter <donald.hunter@gmail.com>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Cc:     donald.hunter@redhat.com
Subject: Re: [PATCH net-next v5 7/7] docs: netlink: document the sub-type
 attribute property
Message-ID: <ZCGQA0KVFGIDd/D6@debian.me>
References: <20230327083138.96044-1-donald.hunter@gmail.com>
 <20230327083138.96044-8-donald.hunter@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="Jyw3odFogf5C948k"
Content-Disposition: inline
In-Reply-To: <20230327083138.96044-8-donald.hunter@gmail.com>
X-Spam-Status: No, score=1.3 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--Jyw3odFogf5C948k
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 27, 2023 at 09:31:38AM +0100, Donald Hunter wrote:
> diff --git a/Documentation/userspace-api/netlink/genetlink-legacy.rst b/D=
ocumentation/userspace-api/netlink/genetlink-legacy.rst
> index b8fdcf7f6615..802875a37a27 100644
> --- a/Documentation/userspace-api/netlink/genetlink-legacy.rst
> +++ b/Documentation/userspace-api/netlink/genetlink-legacy.rst
> @@ -234,6 +234,20 @@ specify a sub-type.
>            type: binary
>            struct: vport-stats
> =20
> +C Arrays
> +--------
> +
> +Legacy families also use ``binary`` attributes to encapsulate C arrays. =
The
> +``sub-type`` is used to identify the type of scalar to extract.
> +
> +.. code-block:: yaml
> +
> +  attributes:
> +    -
> +      name: ports
> +      type: binary
> +      sub-type: u32
> +
>  Multi-message DO
>  ----------------
> =20
> diff --git a/Documentation/userspace-api/netlink/specs.rst b/Documentatio=
n/userspace-api/netlink/specs.rst
> index a22442ba1d30..2e4acde890b7 100644
> --- a/Documentation/userspace-api/netlink/specs.rst
> +++ b/Documentation/userspace-api/netlink/specs.rst
> @@ -254,6 +254,16 @@ rather than depend on what is specified in the spec =
file.
>  The validation policy in the kernel is formed by combining the type
>  definition (``type`` and ``nested-attributes``) and the ``checks``.
> =20
> +sub-type
> +~~~~~~~~
> +
> +Legacy families have special ways of expressing arrays. ``sub-type`` can=
 be
> +used to define the type of array members in case array members are not
> +fully defined as attributes (in a bona fide attribute space). For instan=
ce
> +a C array of u32 values can be specified with ``type: binary`` and
> +``sub-type: u32``. Binary types and legacy array formats are described in
> +more detail in :doc:`genetlink-legacy`.
> +
>  operations
>  ----------
> =20

The doc LGTM, thanks!

Reviewed-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--Jyw3odFogf5C948k
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZCGQAwAKCRD2uYlJVVFO
o1MnAP4rOEY7nSKNdMH5vlinFXqYjWK2Ku/hN3TLluUC3zmlXgD/TCylLQvuSbtE
VDUuakivWm2rZWtG/PkZZdnAKHpAtwQ=
=Mzyw
-----END PGP SIGNATURE-----

--Jyw3odFogf5C948k--
