Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCEEA5E7AFD
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 14:40:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231341AbiIWMj7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 08:39:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231221AbiIWMj4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 08:39:56 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84E4136434;
        Fri, 23 Sep 2022 05:39:54 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id dv25so332408ejb.12;
        Fri, 23 Sep 2022 05:39:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date;
        bh=89Pdm3fZG43xqH8RcuQNWzoAkMrNr3sxzlCA4ZL7Hv8=;
        b=kp4FAFvavOGUoUQGNdmN/3zGrgkPFOEwxDLAACl7x88nEiPPkMYdjLI95SBpHT2ne8
         JYXwCaMq71SXZHXKzoPvjORR2EfMttUdPnBwkYxwp/szLoCj3pqOr5/ovkJ1zC+0MM6T
         2jAcQKLKFan4Y54bLA4glvpmlkpncZdZRVLSmcaY5VMlWtQY+czY2AHZP3S65GlgA8Rp
         4po86l/+iH6z/8E4GJPaNyrD6lcpOfR4rVx1WHNcxo3MMXav0JWqjyFJ7AEQJmX8j255
         pdlAiQNr9Vt7dYpZMCpxf25H6UarEM1hf+m2yPBkuxXWjntlNRgwn8GUMjkuzxGTxSTq
         P1dQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date;
        bh=89Pdm3fZG43xqH8RcuQNWzoAkMrNr3sxzlCA4ZL7Hv8=;
        b=7+5H8d15kgtNAHyFmAXFlp02fk7h6bYBUjR0zJiIiwZ7niBhjf3elLCNJ5RAeN12xQ
         JLemzHzJFS+cVEcFU03SLUSeS5g7SyK8f4OuABCjJOzlV4uNFEbh8Iw4nOvWTE+UU+Xz
         1ZxblD6Urs0+7tiI6ryUCWDEkLpxSCCWVoKV1ILWTinhQg0oF2ccpgPZSuxJ+hQpJGyX
         7Dt+Ttdw19o5x05wm5CeYuVN4MWni5QY0MMs4he8jpWDYqTxqUy4J3S0TbW85Hr3je1a
         nD7Nc2Ke9Yn3ZXFSWc1vpHBBgq2tbpTObf0puxSSHUCMYBaf76+nNyc+jge3jBbvljpB
         41pQ==
X-Gm-Message-State: ACrzQf0MRfqUoO4QZUQAieOm53GxOLkqnDz3yDA9RffVddfUGwpv8RYZ
        WXfJt/nhBnbCl5M985dXlSo=
X-Google-Smtp-Source: AMsMyM7vKpNILY1ysmbRJ1+H1iG6jmPCjjHfJEnkV/93ECAnZGfDDsJnKJP0zbe2EXz6X+/uc7DBlg==
X-Received: by 2002:a17:906:8466:b0:77b:43e9:48b5 with SMTP id hx6-20020a170906846600b0077b43e948b5mr6815720ejc.254.1663936792628;
        Fri, 23 Sep 2022 05:39:52 -0700 (PDT)
Received: from orome (p200300e41f201d00f22f74fffe1f3a53.dip0.t-ipconnect.de. [2003:e4:1f20:1d00:f22f:74ff:fe1f:3a53])
        by smtp.gmail.com with ESMTPSA id q8-20020a170906388800b0077958ddaec6sm3969303ejd.186.2022.09.23.05.39.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Sep 2022 05:39:51 -0700 (PDT)
Date:   Fri, 23 Sep 2022 14:39:49 +0200
From:   Thierry Reding <thierry.reding@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Jon Hunter <jonathanh@nvidia.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Bhadram Varka <vbhadram@nvidia.com>,
        devicetree@vger.kernel.org, linux-tegra@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next v4 9/9] stmmac: tegra: Add MGBE support
Message-ID: <Yy2pFfUWU7LwGG/m@orome>
References: <20220707074818.1481776-1-thierry.reding@gmail.com>
 <20220707074818.1481776-10-thierry.reding@gmail.com>
 <YxjIj1kr0mrdoWcd@orome>
 <64414eac-fa09-732e-6582-408cfb9d41dd@nvidia.com>
 <20220922083454.1b7936b2@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="PZUsOL4JDQ+8OvIb"
Content-Disposition: inline
In-Reply-To: <20220922083454.1b7936b2@kernel.org>
User-Agent: Mutt/2.2.7 (2022-08-07)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--PZUsOL4JDQ+8OvIb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 22, 2022 at 08:34:54AM -0700, Jakub Kicinski wrote:
> On Thu, 22 Sep 2022 16:05:22 +0100 Jon Hunter wrote:
> > On 07/09/2022 17:36, Thierry Reding wrote:
> > > On Thu, Jul 07, 2022 at 09:48:18AM +0200, Thierry Reding wrote: =20
> > >> From: Bhadram Varka <vbhadram@nvidia.com>
> > >>
> > >> Add support for the Multi-Gigabit Ethernet (MGBE/XPCS) IP found on
> > >> NVIDIA Tegra234 SoCs.
> > >>
> > >> Signed-off-by: Bhadram Varka <vbhadram@nvidia.com>
> > >> Signed-off-by: Thierry Reding <treding@nvidia.com>
> > >> ---
> > >> Note that this doesn't have any dependencies on any of the patches
> > >> earlier in the series, so this can be applied independently.
> >
> > > Patches 1-8 of this have already been applied to the Tegra tree. Are
> > > there any more comments on this or can this be merged as well?
> > >=20
> > >  From a Tegra point of view this looks good, so:
> > >=20
> > > Acked-by: Thierry Reding <treding@nvidia.com> =20
> >=20
> > Acked-by: Jon Hunter <jonathanh@nvidia.com>
> >=20
> > Please can we queue this for v6.1? I have added the stmmac maintainers=
=20
> > to the email, but not sure if you can pick this up?
>=20
> Could you repost it independently of the series so that it can go thru
> the net auto-checkers? It should be able to make 6.1 pretty comfortably.

Done. Let me know if there's anything in the patch that needs more work.
For the auto-checkers, do they send out notifications if they find
anything or can I monitor them manually somewhere? Are all of those
reported in the patchwork checks?

Thierry

--PZUsOL4JDQ+8OvIb
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEiOrDCAFJzPfAjcif3SOs138+s6EFAmMtqRUACgkQ3SOs138+
s6HOew/+J/mhrRPu0C8SXCR2BYLpMLikcrSFxQLijLEa1YNMZ/YEYo5LtRGV67En
DlHrxTpoO1aZ/6V/ok5Wp3bacorcQJnAauajCqsLWTzK5gmsdTRREHuLwL6WYgQE
VloXZLx+W4U4ukQd9L8QiO092YMp1sqWNy7XcyoKukNWhO7lQS1SFR+FQK9QoRLj
NRtuOBmn6A+ifc7vXHoMHa6jg2chLJu8H5rnFXy9jTIoEcPwtxq60kwpWtk/xmc8
qhXbqbk6ZMGC7El49GDWZhbUbmAmmsL7+BIV2ywNklAc2npFkbTTioQedy0TuA5I
M0XJgkCwDsmiChAlAYIuyVttprUIrO2jvLpMCEx1CwVhAUXsqaymfiZ/M7UZ/oAA
O4K2HkFRlMxXSt8+0zrcCVlR/RNqLgDH5lmaDVsTsPIt4+mpJ9U/HRSofaPKSxEl
6czO+ZYrxlkQ2RpRHFKfC29ZWjgyZH3UMgidN5sNlMfLSXrdHjtul+5o7CM/YhBl
ci9N0lSDhlPbZyRTxxpL9399Sa/cUPeX+Fj7A0Gu3y2b4spo+jLfCGbFJDuFMzmO
N5xmJ/O7f6cMbmopGQob2c4pRaf6YHsk+8m7aDi/3Z6k8w2ywq55eoKftTF5tcxf
0VcN1pxfspDAqTTlKkKWiJRZVSanwwL9132rx0JIDi/Uw1ysOo8=
=sVdn
-----END PGP SIGNATURE-----

--PZUsOL4JDQ+8OvIb--
