Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16ECE6D90F9
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 10:00:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235463AbjDFIAo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 04:00:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235162AbjDFIAk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 04:00:40 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2CE2E62;
        Thu,  6 Apr 2023 01:00:38 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id eh3so147227535edb.11;
        Thu, 06 Apr 2023 01:00:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680768037;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CQH+iRWXQXzrMch9aFmJkKfa79kh+f41Jg9zUvyUDYc=;
        b=IzH1LBufvIiF5rjtHs2OViOTXLaUQ/nT0dvzEtNTVKku7M2CyskBPXnebDVe/qA0aR
         FusvQs0umKVGxpL/VTQ0zwtxVwYQPwvXR2akjtb/iV1UkJZYhJlzwof2ojROi0PmDAJG
         jvbqQ9+83P9+lvKfeB9y/itUyMR5fqY/xoRvOLFVcd8DzX6Ug/KMAag65CqjQgsStuTc
         FO5wHPzoDfkHBSjioRBu5486GaRhP2qMTsgc210CuUEMvdXz+HT3YunOSDi9a/Oy9GIb
         8fu52k0CNbdwc/s3N6aDZnO84/uixLGPYXKSKmfMV2POalKrRWGUYRhL2F0SeI9ItmvP
         SS8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680768037;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CQH+iRWXQXzrMch9aFmJkKfa79kh+f41Jg9zUvyUDYc=;
        b=5Abx5pe6n5EWTtYAiP42uAPLN4Ljwyp2PttL5l5E9Mwk31t4Kbwn76NOsKMU7tFnh5
         w3tBxdbfYeK/V6FWrMx1LQ9yf5hitJHNm90oGckjxiy0XmJSVi9qAutP792lkEs+U4Dg
         L8zl2RdwTR9zAQuPdfz+T4bFpuIGFAzhb0R0858WtXD19NcPsWMp966I6rRpvBtS2DXC
         wyuWHqWe6dzZfU+L9h63UIj9T3BW0rPkiKAszHFTZiAQktNQx82EK1O5Nd2kcs4g9S8B
         X7kAbP1Kj9Kv4Cc8dpXn8S1bbDLr0CjizNg2uWOPzgYUPvGEw8av7opSGJJEFae2xwW2
         /QsA==
X-Gm-Message-State: AAQBX9dax8qyvgkXQ7uCKChe1DyLqg/m+OXxFyWXRq/+oLS3H6cLRSDT
        I1lazfbmv1tgdlRqYmpFfT4=
X-Google-Smtp-Source: AKy350Zln1rHkseAywxn36shRvYFdkWQ7QSVBFsGgDypBCXbFctm0iaYDiDxGcFUUhAKWrU2spc3MA==
X-Received: by 2002:a17:906:fa9b:b0:945:d94e:7054 with SMTP id lt27-20020a170906fa9b00b00945d94e7054mr6300868ejb.36.1680768036990;
        Thu, 06 Apr 2023 01:00:36 -0700 (PDT)
Received: from orome (p200300e41f1c0800f22f74fffe1f3a53.dip0.t-ipconnect.de. [2003:e4:1f1c:800:f22f:74ff:fe1f:3a53])
        by smtp.gmail.com with ESMTPSA id xf4-20020a17090731c400b00938041aef83sm452290ejb.169.2023.04.06.01.00.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Apr 2023 01:00:36 -0700 (PDT)
Date:   Thu, 6 Apr 2023 10:00:34 +0200
From:   Thierry Reding <thierry.reding@gmail.com>
To:     Rob Herring <robh@kernel.org>
Cc:     "Rafael J. Wysocki" <rafael@kernel.org>,
        Len Brown <lenb@kernel.org>,
        Marcelo Schmitt <marcelo.schmitt1@gmail.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Michael Hennerich <Michael.Hennerich@analog.com>,
        Jonathan Cameron <jic23@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jiri Slaby <jirislaby@kernel.org>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Marc Zyngier <maz@kernel.org>, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-staging@lists.linux.dev,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-serial@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-acpi@vger.kernel.org, devicetree@vger.kernel.org,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Jacob Keller <jacob.e.keller@intel.com>
Subject: Re: [PATCH v2 04/10] serial: 8250_tegra: Add explicit include for
 of.h
Message-ID: <ZC58Ikn9_BUFg_-h@orome>
References: <20230329-acpi-header-cleanup-v2-0-c902e581923b@kernel.org>
 <20230329-acpi-header-cleanup-v2-4-c902e581923b@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="E3hFsuwxav/nr+wF"
Content-Disposition: inline
In-Reply-To: <20230329-acpi-header-cleanup-v2-4-c902e581923b@kernel.org>
User-Agent: Mutt/2.2.10 (2023-03-25)
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--E3hFsuwxav/nr+wF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 05, 2023 at 03:27:18PM -0500, Rob Herring wrote:
> With linux/acpi.h no longer implicitly including of.h, add an explicit
> include of of.h to fix the following error:
>=20
> drivers/tty/serial/8250/8250_tegra.c:68:15: error: implicit declaration o=
f function 'of_alias_get_id' [-Werror=3Dimplicit-function-declaration]
>=20
> Reviewed-by: Jon Hunter <jonathanh@nvidia.com>
> Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
> Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Rob Herring <robh@kernel.org>
> ---
>  drivers/tty/serial/8250/8250_tegra.c | 1 +
>  1 file changed, 1 insertion(+)

Acked-by: Thierry Reding <treding@nvidia.com>

--E3hFsuwxav/nr+wF
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEiOrDCAFJzPfAjcif3SOs138+s6EFAmQufCIACgkQ3SOs138+
s6F+KA/7Bm/KfMbX17OH6FnJh9eMe6ljjpv/iZNRAm7bGZO0mhFGi50XBZsNztqA
VNB3JF2eIsl5fLvZBh3scXkKTB1CEYLOAuhQtUehAXCTDLIgRUn9IzRjit6RBnnU
XTeYRtdEyWtdS90j2nK0edHGOcfOMxYyn1UV/Whtawnx16Ub/ZdIHmTvg454Upqd
2Dv4LpcZIfLFJdPl5B+bYP/Q6Dg9mLDYr7U5V2zxziaDKMOb2L7gN5GMOCL0S+rw
9yHOVa0YxfP6B1zvUjJ8xW0e0XPcRO2f1zApQ0SYpN9DVyKozeB1/U+itoq2wkXS
zVAYUCydZ7TGrFL/NkksLddPwzdLiLeAVDTjwHadnaQERW8NGQkN0Dy+GKSGFFAo
Vsd3TxyP107px9msXa9QHVlPnC2mVgwkg5ZJeWRonPo5lFTC/XpbPe1pnbtn3yjg
o+CKRA75MyFgOIytYdgGK/3/9OJu85zmc0WEQy+0kJnnjLe45y7V7tpMHObl3dGa
KqGTSfMmnf3G7cFAfE1PDdOh/vMO/z2oCc0XR9GdAsEbTXd2E0lrGuw5zrbZYWLO
CeYAiWdsUDmqLEWwKwUT04Z9315lKkJvueZGXfxlGtsz/1j7jVDeC7lUl0u9zt9h
pEq0jCI12awFhFZmUO+3w5b9DBTnKowjD+JwRlg+hs5o0OD1d88=
=T9ol
-----END PGP SIGNATURE-----

--E3hFsuwxav/nr+wF--
