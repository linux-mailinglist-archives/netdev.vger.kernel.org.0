Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DFAC559E6F
	for <lists+netdev@lfdr.de>; Fri, 24 Jun 2022 18:22:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231488AbiFXQWD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jun 2022 12:22:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229598AbiFXQWD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jun 2022 12:22:03 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DD4356756;
        Fri, 24 Jun 2022 09:22:02 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id t5so5775553eje.1;
        Fri, 24 Jun 2022 09:22:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=IZW2pT7Y1PlJtZTT1KeQ7+S8Oay6FOqebmbNuSNNNlY=;
        b=QCOs9yiK7UIpiQqxyiQWztc/NGleizowx11M/398B80qoRS+/Uo9uc5VOCirYNqw2/
         Gm3o2HHamRP6zLmklhWTtb/3gW9sIU7xnWLdw1ZULefIS7uHeqYzHpAgm1hYyUqKuvOk
         ftVngW86ofgh7z4pwiaVRHLrq1hPysFfeJppUjemW60SJ9sL/5PG3reD/26EwuL4YBoi
         EFw+MR7g3uzvDFW7hGopL27AsJD3R1ZODJMqPyq2ZxPs72uGaZxdnjz8EKr2wZt7I1a2
         E3vIlff5UY2xfNApP49wbYzkB7GcecnrPwiaPqxrdkjQnOw1SNFFSIqiMSje1Ku/ySIY
         EAYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=IZW2pT7Y1PlJtZTT1KeQ7+S8Oay6FOqebmbNuSNNNlY=;
        b=3idllwQPeg+QHJeHAT6DHGLhFVgKKf4+sEL6kkfKBRD5U7osBboI3zMBJ8sRMAr5ej
         jS6lHnN/nUI5NECYGfSTTKOEhJnP1hr720m3H+Cpf6Z6Eud5/vlJO8AuVPwYFlW8hCmX
         2dnskmAGxUOg/sxHt484ka+078abqRx0snT7lJ4Bj/uFqoJcGGxU3OuCLeMD6n1dpkG2
         UHFexN6vLLJGfTHUGXqiqaM/8DIB51jX0HsMSgYz6ie4HZfNOqSQSBXv7swVwzMdE+wr
         mOCKw7AsaYDP5KMFCVj8Dzf4Hqzdhuqr8s+iDh4l3Y21lOr01kKZnZwzDVDvXiaFz6ip
         SQNQ==
X-Gm-Message-State: AJIora+cWmmdgoGs256LyxZzSuQaYXAac47uVPeXlG2tnjPDHJ98pry6
        PKyeAul3h0kKxf96oz7oOKg=
X-Google-Smtp-Source: AGRyM1szrUBh0WA1OG2b/WfcGqlM0v8kIHkxOWsSPykep/TaE5WgOlfsNh9qzuJUvF8KNnHQIshDOg==
X-Received: by 2002:a17:907:1c0b:b0:711:cc52:2920 with SMTP id nc11-20020a1709071c0b00b00711cc522920mr14445838ejc.301.1656087720853;
        Fri, 24 Jun 2022 09:22:00 -0700 (PDT)
Received: from orome (p200300e41f12c800f22f74fffe1f3a53.dip0.t-ipconnect.de. [2003:e4:1f12:c800:f22f:74ff:fe1f:3a53])
        by smtp.gmail.com with ESMTPSA id l4-20020aa7d944000000b00435b4775d94sm2394144eds.73.2022.06.24.09.21.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jun 2022 09:21:59 -0700 (PDT)
Date:   Fri, 24 Jun 2022 18:21:58 +0200
From:   Thierry Reding <thierry.reding@gmail.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     Bhadram Varka <vbhadram@nvidia.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-tegra@vger.kernel.org,
        robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        jonathanh@nvidia.com, kuba@kernel.org, catalin.marinas@arm.com,
        will@kernel.org, Thierry Reding <treding@nvidia.com>
Subject: Re: [PATCH net-next v1 2/9] dt-bindings: Add Tegra234 MGBE clocks
 and resets
Message-ID: <YrXkpiaxqjzJdaL9@orome>
References: <20220623074615.56418-1-vbhadram@nvidia.com>
 <20220623074615.56418-2-vbhadram@nvidia.com>
 <53e8aa2f-f5f6-43d9-c167-ec5c5818dfb0@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="j7YpGeEo8VO5okh2"
Content-Disposition: inline
In-Reply-To: <53e8aa2f-f5f6-43d9-c167-ec5c5818dfb0@linaro.org>
User-Agent: Mutt/2.2.6 (2022-06-05)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--j7YpGeEo8VO5okh2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 24, 2022 at 06:02:58PM +0200, Krzysztof Kozlowski wrote:
> On 23/06/2022 09:46, Bhadram Varka wrote:
> > From: Thierry Reding <treding@nvidia.com>
> >=20
> > Add the clocks and resets used by the MGBE Ethernet hardware found on
> > Tegra234 SoCs.
> >=20
> > Signed-off-by: Thierry Reding <treding@nvidia.com>
> > Signed-off-by: Bhadram Varka <vbhadram@nvidia.com>
> > ---
> >  include/dt-bindings/clock/tegra234-clock.h | 101 +++++++++++++++++++++
> >  include/dt-bindings/reset/tegra234-reset.h |   8 ++
> >  2 files changed, 109 insertions(+)
> >=20
> > diff --git a/include/dt-bindings/clock/tegra234-clock.h b/include/dt-bi=
ndings/clock/tegra234-clock.h
> > index bd4c3086a2da..bab85d9ba8cd 100644
> > --- a/include/dt-bindings/clock/tegra234-clock.h
> > +++ b/include/dt-bindings/clock/tegra234-clock.h
> > @@ -164,10 +164,111 @@
> >  #define TEGRA234_CLK_PEX1_C5_CORE		225U
> >  /** @brief PLL controlled by CLK_RST_CONTROLLER_PLLC4_BASE */
> >  #define TEGRA234_CLK_PLLC4			237U
> > +/** @brief RX clock recovered from MGBE0 lane input */
>=20
> The IDs should be abstract integer incremented by one, without any
> holes. I guess the issue was here before, so it's fine but I'll start
> complaining at some point :)

These IDs originate from firmware and therefore are more like hardware
IDs rather than an arbitrary enumeration. These will be used directly in
IPC calls with the firmware to reference individual clocks and resets.

We've adopted these 1:1 in order to avoid adding an extra level of
indirection (via some lookup table) in the kernel.

Thierry

--j7YpGeEo8VO5okh2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEiOrDCAFJzPfAjcif3SOs138+s6EFAmK15KYACgkQ3SOs138+
s6GZrBAAvdVy6k9waK79sgT+nnevfX0LJBLc/wZxC+HnGUilZtdkaIOOtPBUcW+K
EYVLkOnphholpRvp8od96Ox827wQ0YgKUyAqig5IkMlzb82g4Ru5MBnF3KefYkQw
aH4r981BEvAZWTHBs9qLVEos69O1Em+sAEM2iVXHSbix5Rn/QWMLsNODtdl9EDMz
CZYvJRytUrG+6jimjwqTuocl09v2lrNzKeomWppGbtvE1IsibiRgLyiUc5LYUZ9U
x7UheFrBZji67LX32afJnZzCnzpVHXysq8/vkvmOBhg97kxV0lWub/P/qXwzHppG
7ckqcpGuTlLgVRkHcwOC/bZR6phesXtOWgm0ZX26Ury8pqfLmd79w07oIeUZidd3
sF6I9axbArySqI4Lu2Rjo798Royc8TO4kuEQiH1jfdw4weSgxK0rg1Ox0IcR2SqZ
swXjOBxYogPLUw5X5WHmBJYIS3d9X7qFa+zMeGhDmD+zOsFpN/1pr+GOFrQPwzyt
xyh1OdjuAj3R/Gxoajp7jeAT+54NW3bgkJJsxwOTJ0gKNCPiGEN3KtYKEMAWmqmS
zFyz3bQ5tRF6Qu0y+YHIJGhAA+w11QHqP19Xcj28i7MQywqfLNs3LEhz8WS0EZ7A
ySB0czlEx8U7jtyER6wzn9SnC0YtVV9u4xAbZgx1MyV9MFfxEV4=
=Medi
-----END PGP SIGNATURE-----

--j7YpGeEo8VO5okh2--
