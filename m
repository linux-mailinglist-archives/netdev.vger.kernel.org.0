Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E85A618E13
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 03:17:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229461AbiKDCQ6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 22:16:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229611AbiKDCQu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 22:16:50 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6594A12B;
        Thu,  3 Nov 2022 19:16:50 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id l2so3617342pld.13;
        Thu, 03 Nov 2022 19:16:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=oHHHQvMpJw6zKzRYMRXkB6cWhlM08K92RpQqmEYbngM=;
        b=IX1j2f+N3vRH8n9ylksE02fOQjgqL9tT9tLDeRdh5JZNTK4MBz/C0fpA/Npbp2SP9o
         aYbyEyDRgCOGc7+OkzkVxvatOfsihDzQK9hioRQWnO+em659i4nfI8XHtuUEcNvvKacj
         EBF4XIH5c6YMuPbdvOPLa1OUl/H6M8Ve2mP1+b8V4qXZNFubRbSzlV8SJamQ1+hjQWvH
         2EVkWE3HU2daw2UIlpRTDNXwbaE4W28x3t+1D4NG6Lsx8HT6JJjrK2/XSzvu2vpOciPC
         b8OV/t5k5i3UKOskZ/KV4yk0JMt/2oAqPurTw6rmp2FFlfhwT8e4IKmUi6UoFIxnHhSz
         /VmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oHHHQvMpJw6zKzRYMRXkB6cWhlM08K92RpQqmEYbngM=;
        b=RvSXQP1tVouZsflCC/NHIHaNhRabEDbTSzwE/w6/YP8NHbL54BExSWk44ADE4WQlWX
         HecuVH37y8Nklx3eBy+HgAzcpy7AeP569RWj/8EASrIJfsazkNYkNzM1ozhPpTfrxR9j
         qTr4p0ZHZeb+YljyxsWLpaKmQM7t90dTaC4v9LIh/bren4rcZfT7CWRbEmcw+NpM6mUl
         jn5Gs2eZQwWk5/mL5o0n87fgkz5tooAHbkRwtsSe7e9+lMcviCRmiUm1zhaEWH6oxlYW
         E4KX3UzlycD0LE7BcUbIEPsq61RKcxpC5S7NtqOVzkeH4MAY3pIhslzE01KjjAkc+rT6
         RLuQ==
X-Gm-Message-State: ACrzQf3jRKvSJi72nOoN9rt4v2uauy1H/NWNkxFsSMaRxwcIANLP4lYs
        vV1T/FAPJ6+xhH4t2nsMJsw=
X-Google-Smtp-Source: AMsMyM63ZIvwtTaY/OxCzgXvLM0fe6rH3MSkt1ea+mkZUJIqFuOSENTEfQdTymO4iE8Idn7h0W9yQA==
X-Received: by 2002:a17:902:da8e:b0:187:5b6:1b9e with SMTP id j14-20020a170902da8e00b0018705b61b9emr33596236plx.113.1667528209921;
        Thu, 03 Nov 2022 19:16:49 -0700 (PDT)
Received: from debian.me (subs02-180-214-232-15.three.co.id. [180.214.232.15])
        by smtp.gmail.com with ESMTPSA id n17-20020a170903111100b00186b6a04636sm1289746plh.255.2022.11.03.19.16.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Nov 2022 19:16:49 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
        id C03D1103CC9; Fri,  4 Nov 2022 09:16:45 +0700 (WIB)
Date:   Fri, 4 Nov 2022 09:16:45 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Yang Li <yang.lee@linux.alibaba.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, richardcochran@gmail.com,
        netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Abaci Robot <abaci@linux.alibaba.com>
Subject: Re: [PATCH -next] net: ethernet: Simplify bool conversion
Message-ID: <Y2R2DWPxsp1RY5vO@debian.me>
References: <20221104010635.68515-1-yang.lee@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="3sAAvVH+6m1YNFqU"
Content-Disposition: inline
In-Reply-To: <20221104010635.68515-1-yang.lee@linux.alibaba.com>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--3sAAvVH+6m1YNFqU
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 04, 2022 at 09:06:35AM +0800, Yang Li wrote:
> ./drivers/net/ethernet/renesas/rcar_gen4_ptp.c:32:40-45: WARNING: convers=
ion to bool not needed here
>=20

Similar requested description change as [1].

[1]: https://lore.kernel.org/lkml/Y0LQF02sKheWtkD8@debian.me/

--=20
An old man doll... just what I always wanted! - Clara

--3sAAvVH+6m1YNFqU
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCY2R2AgAKCRD2uYlJVVFO
o3cEAP4j516Zbl/CYxnHmxJnjBVGC86IWvttidvm9Y0vjGcQOQEAiGpBTw0rBt3Q
u/QRl7PeeFNgegnoqzYTAQv8TOwa9QI=
=Tesb
-----END PGP SIGNATURE-----

--3sAAvVH+6m1YNFqU--
