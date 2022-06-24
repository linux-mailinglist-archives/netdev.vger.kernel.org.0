Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3896559E74
	for <lists+netdev@lfdr.de>; Fri, 24 Jun 2022 18:22:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231452AbiFXQTf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jun 2022 12:19:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229598AbiFXQTd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jun 2022 12:19:33 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51BEA3C706;
        Fri, 24 Jun 2022 09:19:32 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id u15so5671608ejc.10;
        Fri, 24 Jun 2022 09:19:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ricq+0JGNrGAcgcMt4hFdqFNI3qZ/PX1ec96tksYHus=;
        b=eRxhCWkn13cUhuAtIMUKPlqbg7ZCfht/gpzbZID7uumdf1/NipqZ3RTpa1+8cP2P3a
         TLqYnWduW/JuTvG047izM0rviDRfNOKp7UtvFuqOriCz8TjvFf2vg8UsJMlVbshJLYQE
         QoqSLpqyzikDzRRiBd+t0ExSK1g/x6eBRDbfanBK5hibfYlwQx4nTzz2C54vyOgF9bYD
         NPRBb1xWQlYVRLM7YahsZxHzSUKgtCNv9eP2rCu9xo32Ey+Ut/2FkE7ajRl55+PgXj29
         fRyw0+t+F8HAYznY78ISNAQghny6potH7aqs9u2JqSk+DITbBsq1Xq0KXszQovg8CfwE
         lQ/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ricq+0JGNrGAcgcMt4hFdqFNI3qZ/PX1ec96tksYHus=;
        b=EGEmn6RyDk8dZR8toK55eTVOWvTyJfDzb/h5g1Ymc6UK1Gq8FJKuw5YGri9WGKFKZq
         Ed62x4lY8hFTWnkx/lpMce2lDSWmtgayfSHb8DlDqBODchaoG00h0l0adpOnc7vcdVZP
         gyfDISDQAMqZQjsikFWOHL9gac8B1+9HBdUpRuAlDZGZvawvw4mZ0iUq1iPr5HX+ssiE
         /324eeOT8WidgL85wWJpN9O+KijjFh/eMVUWmxqACQhTIF1SEhoLaANye1gu4rhoy7eq
         7wHx6yiHYDO8XUMvSRj7x5m0VCXSqRiJ182qz+f4hI1p2I3BVO6dZLlAFf5JpyMlheeo
         pPiw==
X-Gm-Message-State: AJIora8Rk2u3DrmwZaj3wg5KXgRMUFzMHZpnC8q0vLyMZI8d1J1sijzc
        SPEXD6n0leJCcqKZaIQZxog=
X-Google-Smtp-Source: AGRyM1vYSmRhC0W592gyOElmmpaOJAnjsQons5TuW0eJdafGDIjCh8LkM60zHMIHjI7y0j+CeZTjig==
X-Received: by 2002:a17:906:209:b0:712:12d8:b52b with SMTP id 9-20020a170906020900b0071212d8b52bmr14234350ejd.394.1656087570697;
        Fri, 24 Jun 2022 09:19:30 -0700 (PDT)
Received: from orome (p200300e41f12c800f22f74fffe1f3a53.dip0.t-ipconnect.de. [2003:e4:1f12:c800:f22f:74ff:fe1f:3a53])
        by smtp.gmail.com with ESMTPSA id p22-20020a170906839600b00711d5bc20d5sm1306237ejx.221.2022.06.24.09.19.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jun 2022 09:19:29 -0700 (PDT)
Date:   Fri, 24 Jun 2022 18:19:27 +0200
From:   Thierry Reding <thierry.reding@gmail.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     linux-tegra@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, vbhadram@nvidia.com,
        treding@nvidia.com, robh+dt@kernel.org, catalin.marinas@arm.com,
        krzysztof.kozlowski+dt@linaro.org, kuba@kernel.org,
        jonathanh@nvidia.com, will@kernel.org
Subject: Re: (subset) [PATCH net-next v1 3/9] dt-bindings: memory: Add
 Tegra234 MGBE memory clients
Message-ID: <YrXkDylsf5JSklSz@orome>
References: <20220623074615.56418-1-vbhadram@nvidia.com>
 <20220623074615.56418-3-vbhadram@nvidia.com>
 <165608679241.23612.13616476913302198468.b4-ty@linaro.org>
 <d0bc0054-4457-bd56-161b-19808c65c0e9@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="Bcv3WXIFwInsOvvQ"
Content-Disposition: inline
In-Reply-To: <d0bc0054-4457-bd56-161b-19808c65c0e9@linaro.org>
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


--Bcv3WXIFwInsOvvQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 24, 2022 at 06:10:54PM +0200, Krzysztof Kozlowski wrote:
> On 24/06/2022 18:06, Krzysztof Kozlowski wrote:
> > On Thu, 23 Jun 2022 13:16:09 +0530, Bhadram Varka wrote:
> >> From: Thierry Reding <treding@nvidia.com>
> >>
> >> Add the memory client and stream ID definitions for the MGBE hardware
> >> found on Tegra234 SoCs.
> >>
> >>
> >=20
> > Applied, thanks!
> >=20
> > [3/9] dt-bindings: memory: Add Tegra234 MGBE memory clients
> >       https://git.kernel.org/krzk/linux-mem-ctrl/c/f35756b5fc488912b8bc=
5f5686e4f236d00923d7
> >=20
>=20
> Hmm, actually now I think you might need it for DTS, although there was
> no cover letter here explaining merging/dependencies...
>=20
> I could provide you a tag with it or opposite (take a tag with only the
> header).

I can pick this up into the Tegra tree where I already carry an earlier
patch for Tegra234 GPCDMA that you had acked. That works better for this
model since, as you said, this is needed as a dependency for the DTS
files.

Thierry

--Bcv3WXIFwInsOvvQ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEiOrDCAFJzPfAjcif3SOs138+s6EFAmK15A8ACgkQ3SOs138+
s6F4aw/9F6xVeKGoS+LCN6kuUthd8eX5662IvuX6Usc3LK+EuUkGMGbCr0+Dc7Xn
90ao9Pp8kFYw30M81Us20Eu9ZDTgoON9klXCPYsN7D1o4lHwaz/akvJQRMJxqhnl
EfNvD/XgoUdpI2GvgRIGSh3qV0PL8B+uq7X1KpMGAlHlNyrb/KskxlvrwSEkCdtV
ZjGZbnJSt8yGcRJggxwZQQss/JorAdQKTwcqmOpR8cKCkWqCv3TxaxsRvNZYX5pt
JoxFow2fW6qfHUju0oHaMQmpzfehnaxzwPn4GLlSCj5CACcOSKrpH+ND+EXbeU+l
krVowQBz49gWpja9IR721nofk3D+GKgDHtHvKIkQQObP6CyHZHCE7APNEQEHulSi
pVYouza9d0vlQy8xXxq+D2BnrPO0pFRuPksWkl9WFNNPfYtfqDWjo/5Vo+GNxcpT
P0fI0ITYq85slCHfJKPhRYLfJfMnEEsYvqMZDI0sakpZaXNJSclnPVtZwoE/yI88
aKyQwJi8wiSUTW9bk+2tb9Pi238OCGCBmm6U4ECEBWGWIjDmN7f30D78xayiW4gb
jcrrvnhvFytNx1fYhKUZmep1SB2fUO6TlA6g1uHEkv4ogDMWV8ltaMHJ0gurBK/M
m/oicnimEqafyLgWMm/M0vEQyigusaUeWAtoPUM3+/C2J0FsW3M=
=cVYG
-----END PGP SIGNATURE-----

--Bcv3WXIFwInsOvvQ--
