Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5AFC686633
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 13:46:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230461AbjBAMqL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 07:46:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230245AbjBAMqK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 07:46:10 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 666A25BA2
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 04:46:07 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id n13so2827575plf.11
        for <netdev@vger.kernel.org>; Wed, 01 Feb 2023 04:46:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=fkTFIuSPLKfoCtXCCCEyL+yG+V8An1lDoLyWCS7QCCE=;
        b=mA4Ut5jbcgfFDPIma8gjZ/ALtxNk0qxYXRSplQ+1PZ27gYHRY8MUQ9yaB1G2bJ9qYy
         OjlHRtdx6ChK8qhX96A8+RNKb8BQeA7mRIndjrvkzMw1LVuTSXNNTMuopzazWvzQ9TYs
         RirB4uVo4tRbqoHUJKUsLj/CAs0Np8s2PO/wyV/79UHa1P2KFvehZf8YisTrTwZ41Aan
         BaKYGT6SyTcdSKyaoR9kEiksSv8YT1MIy0uOF71d1d/8FBEkGckQEg7Xj+K6H/P5jHE/
         dYgl9QNubSBQ0Ss72V2FOXH7E4hbahlOL2TJgtCo4uXk5t44NCSA+wjSS4+Fk6issw1Z
         JA/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fkTFIuSPLKfoCtXCCCEyL+yG+V8An1lDoLyWCS7QCCE=;
        b=PI4sHK+SJg2HTJsQBOMouWy+KfeTphNJ247Lsqbko4aI5B+doJ10oNDMdHRpLbWbVT
         EQHLLwviWUKdZFvvTEYwvg4SWxoqxlfiiRSZg4h6xTfRXdDoYDfV75HPNbEfNlCVwKdC
         /Lb/D3rg/U1dntWOBOVykaS31oPKNBLkyQyf1K+EjKxfPuDZAonoTP+anKzkgh1xnlHF
         kon+Jb4Ygqp6N4mqVDdiRyTVmjFCogQoXPxL+jIQszYC10/XvBn1CKxxHZpF53L57Bk0
         ftiULBdWUt9jNoxJpZkIWAIuFv2qoLBFyL0na0GceXf3ZrLqAXpIRiLE/SI9PQDKE6OC
         6oIw==
X-Gm-Message-State: AO0yUKWeHMrlfvdqhsK+vmyMk0oBXWCxoswzfrNRvPSNCSSzqxXqXj6Y
        951myeU7s3uBheKduladxzI=
X-Google-Smtp-Source: AK7set/+oQpZ3sqH5WEgSzWEjuYdwtIXqhHCYm96eYbih6oxEetY39DrwiJaHfMPJWJ5/5eWaj2RpA==
X-Received: by 2002:a05:6a20:8e22:b0:bc:3290:5759 with SMTP id y34-20020a056a208e2200b000bc32905759mr2910934pzj.34.1675255566873;
        Wed, 01 Feb 2023 04:46:06 -0800 (PST)
Received: from pek-khao-d2 (unknown-105-121.windriver.com. [147.11.105.121])
        by smtp.gmail.com with ESMTPSA id h10-20020a056a001a4a00b0058df440d51esm11315252pfv.193.2023.02.01.04.46.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Feb 2023 04:46:06 -0800 (PST)
Date:   Wed, 1 Feb 2023 20:45:58 +0800
From:   Kevin Hao <haokexin@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Kevin Hilman <khilman@baylibre.com>,
        Jerome Brunet <jbrunet@baylibre.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "open list:ARM/Amlogic Meson..." <linux-amlogic@lists.infradead.org>,
        Chris Healy <cphealy@gmail.com>
Subject: Re: [PATCH net] net: phy: meson-gxl: use MMD access dummy stubs for
 GXL, internal PHY
Message-ID: <Y9pfBpoZ4cezf6Bb@pek-khao-d2>
References: <23ecd290-56fb-699a-8722-f405b723b763@gmail.com>
 <20230131215528.7a791a54@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="Mk4AfqfvQZZ1jb0O"
Content-Disposition: inline
In-Reply-To: <20230131215528.7a791a54@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--Mk4AfqfvQZZ1jb0O
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 31, 2023 at 09:55:28PM -0800, Jakub Kicinski wrote:
> On Tue, 31 Jan 2023 22:03:21 +0100 Heiner Kallweit wrote:
> > Jerome provided the information that also the GXL internal PHY doesn't
> > support MMD register access and EEE. MMD reads return 0xffff, what
> > results in e.g. completely wrong ethtool --show-eee output.
> > Therefore use the MMD dummy stubs.
> >=20
> > Note: The Fixes tag references the commit that added the MMD dummy
> > access stubs.
> >=20
> > Fixes: 5df7af85ecd8 ("net: phy: Add general dummy stubs for MMD registe=
r access")
>=20
> Please make sure to CC the author. Adding Kevin Hao <haokexin@gmail.com>

The changes look fine to me, but the using of the "Fixes" tag seems a bit w=
eird.
The "Fixes" tag is used to specify the commit causing regression instead of=
 patch prerequisite.

Thanks,
Kevin


--Mk4AfqfvQZZ1jb0O
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEHc6qFoLCZqgJD98Zk1jtMN6usXEFAmPaXwYACgkQk1jtMN6u
sXGSEAf/aq9hSch/hWtBwo81OFaSkRoIMDg4Dc2g5ql9SQMc8Nxvd+o540SbCXuX
h988OPOrvw7JXUEswqX2GJMIwgJAYpDQsfmzkAkwszgMY4Vh8ZepoUvMQK6fjxUU
lipFEBekx5ZWL8WPQSbsXjx9TUvi30qTq3KIXc32UyBA/OqQDyrjOEv8LmaLlZj8
nJFeiF999+tvG7yXAmczxbsfvV2tl29FB/SwyTT2UsYeVuPp5klPkumyzHBmfCXg
tv7938MAL+5gF80jAUhbj4yaUPXhxGA0/DE4pv+9iV7eHDT2m4fWxrzISprylzzF
EbExviPu5xzwIzcJd3xdJo11wX60KA==
=YW6S
-----END PGP SIGNATURE-----

--Mk4AfqfvQZZ1jb0O--
