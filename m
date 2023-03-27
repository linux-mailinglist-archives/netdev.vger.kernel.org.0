Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E8666CA45B
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 14:45:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232260AbjC0MpK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 08:45:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230351AbjC0MpI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 08:45:08 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BACFA40DF;
        Mon, 27 Mar 2023 05:45:06 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id gp15-20020a17090adf0f00b0023d1bbd9f9eso11721841pjb.0;
        Mon, 27 Mar 2023 05:45:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679921106;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=CfnHyaaBH+Lk9iWABIQalbJ32qbFAoxiTvidJWprhp8=;
        b=NNxARsSVi+Vf8UNk8EQ9Q9/8OjYeMe26RXINidqLbbXrCuOsIJdftNQ8upuPFiTPLc
         zfTeZzaKBWmwc+pLglgVnBP6OH2OixtLKlDz7gdjv6WGv/QooAQlBR3sK3OgP+9FXfvJ
         sxTCa4DSP+5rxehV3A3qADQefIuOG4Ak99AMU07TYrf3f1hYapnS3wSRSTxceInhdCpX
         VJTPhIFVzxZgOnpsrX7fmrEUmK3aJqnUtErZfTNAf42RFrZjb0m6fWxw9ogK34CWaaSb
         I5srQiYz805zdd1hg0zWrvUf8iyRtQaS7nLa29U8JGPSwmlJKu0lhmHwmAwwLBvM3FK6
         iyIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679921106;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CfnHyaaBH+Lk9iWABIQalbJ32qbFAoxiTvidJWprhp8=;
        b=uT4h4LQABPjyvV9DifsoVhDiOTLrMLzp78PBQYspBG3HVfz5ycXat5UO1TQMIDJ03T
         zVE2R9ha6tIUCZnsmfE2dO0k/VGN7KkNl4zEYp/TIN3zC8MzDAQPZFC2rXF4mW22Ffc+
         kTDH15AzA+WWp94KZkJdHFgejy1QUcYSWUXfRyfi0MJBgqQqk1+rs439+Gm+5iF/boXc
         VzfGtVmUTWA+cqeawKA3KjDl9AyWEobrX+YmrhdeBEHMTbzE3UbjZVXD/v4RTKJD1w8j
         y83oWbHiMX8dtH6Py5mUDC2t/72HnPu3uMFBNnmQWudkFvLAUC+XnS8T/NsDRHAz4AQG
         GJBg==
X-Gm-Message-State: AAQBX9eHey9sMB9u6sx2DtT8GUAXFioMKMwzTW/nN6rWf+w4tVUY3tjA
        FCmek3XLGw+RfznJsnvchPM=
X-Google-Smtp-Source: AKy350a354fPptjXr9CCSC0YCaAVEB1MwOJCcjrJDLqV5X6Lj0XRJ5MmqLZMXVU25Yk8sR1peeymTQ==
X-Received: by 2002:a17:902:ec91:b0:1a1:dd3a:7509 with SMTP id x17-20020a170902ec9100b001a1dd3a7509mr14214042plg.48.1679921106075;
        Mon, 27 Mar 2023 05:45:06 -0700 (PDT)
Received: from debian.me (subs03-180-214-233-75.three.co.id. [180.214.233.75])
        by smtp.gmail.com with ESMTPSA id d9-20020a170902854900b0019c61616f82sm19084100plo.230.2023.03.27.05.45.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Mar 2023 05:45:05 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
        id 2CC41106758; Mon, 27 Mar 2023 19:45:00 +0700 (WIB)
Date:   Mon, 27 Mar 2023 19:44:59 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Donald Hunter <donald.hunter@gmail.com>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Cc:     donald.hunter@redhat.com
Subject: Re: [PATCH net-next v5 6/7] docs: netlink: document struct support
 for genetlink-legacy
Message-ID: <ZCGPy+90DsRpsicj@debian.me>
References: <20230327083138.96044-1-donald.hunter@gmail.com>
 <20230327083138.96044-7-donald.hunter@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="nh5IJXJhvW4Mxisv"
Content-Disposition: inline
In-Reply-To: <20230327083138.96044-7-donald.hunter@gmail.com>
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


--nh5IJXJhvW4Mxisv
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 27, 2023 at 09:31:37AM +0100, Donald Hunter wrote:
> diff --git a/Documentation/userspace-api/netlink/genetlink-legacy.rst b/D=
ocumentation/userspace-api/netlink/genetlink-legacy.rst
> index 3bf0bcdf21d8..b8fdcf7f6615 100644
> --- a/Documentation/userspace-api/netlink/genetlink-legacy.rst
> +++ b/Documentation/userspace-api/netlink/genetlink-legacy.rst
> @@ -162,9 +162,77 @@ Other quirks (todo)
>  Structures
>  ----------
> =20
> -Legacy families can define C structures both to be used as the contents
> -of an attribute and as a fixed message header. The plan is to define
> -the structs in ``definitions`` and link the appropriate attrs.
> +Legacy families can define C structures both to be used as the contents =
of
> +an attribute and as a fixed message header. Structures are defined in
> +``definitions``  and referenced in operations or attributes. Note that
> +structures defined in YAML are implicitly packed according to C
> +conventions. For example, the following struct is 4 bytes, not 6 bytes:
> +
> +.. code-block:: c
> +
> +  struct {
> +          u8 a;
> +          u16 b;
> +          u8 c;
> +  }
> +
> +Any padding must be explicitly added and C-like languages should infer t=
he
> +need for explicit padding from whether the members are naturally aligned.
> +
> +Here is the struct definition from above, declared in YAML:
> +
> +.. code-block:: yaml
> +
> +  definitions:
> +    -
> +      name: message-header
> +      type: struct
> +      members:
> +        -
> +          name: a
> +          type: u8
> +        -
> +          name: b
> +          type: u16
> +        -
> +          name: c
> +          type: u8
> +

Nit: The indentation for code-block codes should be relative to
code-block:: declaration (e.g. if it starts from column 4, the first
column of code is also at 4).

> +Fixed Headers
> +~~~~~~~~~~~~~
> +
> +Fixed message headers can be added to operations using ``fixed-header``.
> +The default ``fixed-header`` can be set in ``operations`` and it can be =
set
> +or overridden for each operation.
> +
> +.. code-block:: yaml
> +
> +  operations:
> +    fixed-header: message-header
> +    list:
> +      -
> +        name: get
> +        fixed-header: custom-header
> +        attribute-set: message-attrs
> +
> +Attributes
> +~~~~~~~~~~
> +
> +A ``binary`` attribute can be interpreted as a C structure using a
> +``struct`` property with the name of the structure definition. The
> +``struct`` property implies ``sub-type: struct`` so it is not necessary =
to
> +specify a sub-type.
> +
> +.. code-block:: yaml
> +
> +  attribute-sets:
> +    -
> +      name: stats-attrs
> +      attributes:
> +        -
> +          name: stats
> +          type: binary
> +          struct: vport-stats
> =20
>  Multi-message DO
>  ----------------

Otherwise LGTM, thanks!

Reviewed-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--nh5IJXJhvW4Mxisv
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZCGPxwAKCRD2uYlJVVFO
o7dAAP9Kl/eouvxC4qUIM4eux+mH7G2CdpTE5COhvkjWprES6QEAmcdj2JAO+3BF
lYWIetPQF8ppzikEZ8Np6UDuXZInfAQ=
=Sjt1
-----END PGP SIGNATURE-----

--nh5IJXJhvW4Mxisv--
