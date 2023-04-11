Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0ACE86DCFF9
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 05:10:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229938AbjDKDK0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Apr 2023 23:10:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229690AbjDKDKY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Apr 2023 23:10:24 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEB361BC9;
        Mon, 10 Apr 2023 20:10:23 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id w11so7152968pjh.5;
        Mon, 10 Apr 2023 20:10:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1681182623;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Fr5kM0oUviyELrGpTYDxgL++MXitwM85P3aXWZ7MoWM=;
        b=Ufk3IYxFdJFmrsfN7T4uaEa8NkC/bFZgW5KWvIy13IaIxOA6o14BMsBunnXMZryCi1
         KHKUs1BkotmfO90GHMndYVcmMC0FJqmI9kBYLiPU3IfbW9Mktc/Sxq8DsN5NKxKj3DZi
         h2jjntSdDvupNkLrxLoLAmaTJXOzW9wcEwLUB78JQZl6K/bkXefKZ5J98AQHKZaXVYA5
         KOzVtttX1BgGrbN7H2aL8AAzCAx/7JAyW/YJXsSOUenf9KZ+ONyE7YZxowF2qd0oOLWS
         bcGlMSRgBK+P8oLWhHMP60SxgkqwOclrfG2pmoUWqXjUCFR6O0ZGRPVg546eBWrduqjm
         51Yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681182623;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Fr5kM0oUviyELrGpTYDxgL++MXitwM85P3aXWZ7MoWM=;
        b=JWuITNheX3sWY9lWeJJTIw8Ab/9uQ66/4IvJ1Rh3vjyYssK1vhXFE2Og3YNJMQrLZb
         c/APQSaZghuN+9i0Y0Jmc2SoU5t/JVWKt4w0pw7p8KLPDL3rlXXJ0YhyC84wRi6tCL99
         p9wvnodrDZWoG8KW8hCM09Jo5BsWQpEeWAWRrlgMOu2bUnfjLdSTQQK+e4M9iuW6WzkP
         OOuMlgnM6MlxGE4+Yk8CB4uai+stdQK0hAa02o1SwCkR6UG8ZJnR9NVAncMXCAChnXO5
         mbWBJ8/ZNO3tr43j3+L2UIpArrf8nGAkk2uTtFPTiTP8SzDLA2WNMYJl4/c9moKB0V0z
         kPdA==
X-Gm-Message-State: AAQBX9eaeiBX6lSQgSgDOMJYlb4Qm3r2scy4BtXA1BbtBODiTRv66e28
        Guwp5UVKaeF5Eze0INp+iPA=
X-Google-Smtp-Source: AKy350ZWCTqsclZTE/XYSMozScZ0L2mMJlp3KscYMFj7KkGxaQuHvcfyYb0oLOGJrooscDSKiR6Ciw==
X-Received: by 2002:a17:902:f544:b0:1a5:2b9b:67f7 with SMTP id h4-20020a170902f54400b001a52b9b67f7mr11177286plf.46.1681182623255;
        Mon, 10 Apr 2023 20:10:23 -0700 (PDT)
Received: from debian.me (subs02-180-214-232-80.three.co.id. [180.214.232.80])
        by smtp.gmail.com with ESMTPSA id c19-20020a170902849300b001a520f9071dsm5823271plo.7.2023.04.10.20.10.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Apr 2023 20:10:22 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
        id 5DF14106795; Tue, 11 Apr 2023 10:10:18 +0700 (WIB)
Date:   Tue, 11 Apr 2023 10:10:17 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Kal Conley <kal.conley@dectris.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH bpf-next v5 2/4] xsk: Support UMEM chunk_size > PAGE_SIZE
Message-ID: <ZDTPmTj6GqjurcNQ@debian.me>
References: <20230410120629.642955-1-kal.conley@dectris.com>
 <20230410120629.642955-3-kal.conley@dectris.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="9OqzVWC9R5WWCkWY"
Content-Disposition: inline
In-Reply-To: <20230410120629.642955-3-kal.conley@dectris.com>
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


--9OqzVWC9R5WWCkWY
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 10, 2023 at 02:06:27PM +0200, Kal Conley wrote:
> diff --git a/Documentation/networking/af_xdp.rst b/Documentation/networki=
ng/af_xdp.rst
> index 247c6c4127e9..ea65cd882af6 100644
> --- a/Documentation/networking/af_xdp.rst
> +++ b/Documentation/networking/af_xdp.rst
> @@ -105,12 +105,13 @@ with AF_XDP". It can be found at https://lwn.net/Ar=
ticles/750845/.
>  UMEM
>  ----
> =20
> -UMEM is a region of virtual contiguous memory, divided into
> -equal-sized frames. An UMEM is associated to a netdev and a specific
> -queue id of that netdev. It is created and configured (chunk size,
> -headroom, start address and size) by using the XDP_UMEM_REG setsockopt
> -system call. A UMEM is bound to a netdev and queue id, via the bind()
> -system call.
> +UMEM is a region of virtual contiguous memory divided into equal-sized
> +frames. This is the area that contains all the buffers that packets can
> +reside in. A UMEM is associated with a netdev and a specific queue id of
> +that netdev. It is created and configured (start address, size,
> +chunk size, and headroom) by using the XDP_UMEM_REG setsockopt system
> +call. A UMEM is bound to a netdev and queue id via the bind() system
> +call.
> =20
>  An AF_XDP is socket linked to a single UMEM, but one UMEM can have
>  multiple AF_XDP sockets. To share an UMEM created via one socket A,
> @@ -418,14 +419,21 @@ negatively impact performance.
>  XDP_UMEM_REG setsockopt
>  -----------------------
> =20
> -This setsockopt registers a UMEM to a socket. This is the area that
> -contain all the buffers that packet can reside in. The call takes a
> -pointer to the beginning of this area and the size of it. Moreover, it
> -also has parameter called chunk_size that is the size that the UMEM is
> -divided into. It can only be 2K or 4K at the moment. If you have an
> -UMEM area that is 128K and a chunk size of 2K, this means that you
> -will be able to hold a maximum of 128K / 2K =3D 64 packets in your UMEM
> -area and that your largest packet size can be 2K.
> +This setsockopt registers a UMEM to a socket. The call takes a pointer
> +to the beginning of this area and the size of it. Moreover, there is a
> +parameter called chunk_size that is the size that the UMEM is divided
> +into. The chunk size limits the maximum packet size that can be sent or
> +received. For example, if you have a UMEM area that is 128K and a chunk
> +size of 2K, then you will be able to hold a maximum of 128K / 2K =3D 64
> +packets in your UMEM. In this case, the maximum packet size will be 2K.
> +
> +Valid chunk sizes range from 2K to 64K. However, in aligned mode, the
> +chunk size must also be a power of two. Additionally, the chunk size
> +must not exceed the size of a page (usually 4K). This limitation is
> +relaxed for UMEM areas allocated with HugeTLB pages, in which case
> +chunk sizes up to 64K are allowed. Note, this only works with hugepages
> +allocated from the kernel's persistent pool. Using Transparent Huge
> +Pages (THP) has no effect on the maximum chunk size.
> =20
>  There is also an option to set the headroom of each single buffer in
>  the UMEM. If you set this to N bytes, it means that the packet will

The doc LGTM, thanks!

For the doc part,

Reviewed-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--9OqzVWC9R5WWCkWY
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZDTPkgAKCRD2uYlJVVFO
o3DuAP4tlywqhtl/QdcE2djG+9hk9ce1dD+2SekZvB5G7BGI9AD/TpH4G3qVXPp2
nEk8xfF+vZ1spVb5PJEuW78SQSo+0A0=
=xQi5
-----END PGP SIGNATURE-----

--9OqzVWC9R5WWCkWY--
