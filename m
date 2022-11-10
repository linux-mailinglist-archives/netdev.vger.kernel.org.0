Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B3E26239F7
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 03:48:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232297AbiKJCsA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 21:48:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230080AbiKJCr7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 21:47:59 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A49218383;
        Wed,  9 Nov 2022 18:47:58 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id m6-20020a17090a5a4600b00212f8dffec9so514801pji.0;
        Wed, 09 Nov 2022 18:47:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=q10kMqO7wD5+LyilXs9EBMLp1RqqU/ylxUmGyw7vlGQ=;
        b=AtmgnlBC58rSmGhdBV4pIDmSNRF+ii046j/0oo5rHVD/b8pzMUAg92oCSRQHGPxneP
         B64EA+RazQuqaCYoMpDYdko/hixkOY2UvBOE0gA/b5/Z7DZgOPQ+eLLzxLMs3Htcj9Wi
         l1yinHu6QGIK2Wq2F3K2DE8SqXej4IwtUGFgBjL1rTtL7ls7jc0S3jF1MZzPElgtpnof
         keuPjeqT0FmyP8FY3YZeR3iN2hRF22AmfBnVSXEH4noUoCvNJcfaqRDcPHTZLrl1vOCI
         0RrWZRzMwqMQj0bTC7tpw66Ck5pfQ9LmofSO6XqiefidlQUfgWIpEfdT097UyQIoBYkQ
         uatQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=q10kMqO7wD5+LyilXs9EBMLp1RqqU/ylxUmGyw7vlGQ=;
        b=SL6coFChFsmLuID3vc90OvQ/TZ3PJHrk4aZ6LpSBczYUf4hecq5D0TbmO3Anrdk2UD
         TSMUfjrpTQE/JP7aIAMGusDnm0rzr7Yxjj1xsNqN7lOjtB/bFwUeCcCUcqzPGAwMStgo
         QnAewpeEJjuJqWG6gQyefGI90W/Hrx+qHJHwwdQA/WBHKWoKJcub/wfEr4WbKud/pkfk
         KKQmQZe33+cLfb7+yu5GHwivL8bKOxQ2sHtS4m+3CAscMJQBeK+4lypq9EjMa9pbBY+b
         oK+/GMR9I5ER5dj3HoC9/x6zJs1had2acIDQNjxCMXaLJvLZa+55M5tz8b/5gVWww0iM
         l5yA==
X-Gm-Message-State: ACrzQf3sMh2r5umYNFqC5TIxV8x/rvZ6OuZVA4nS6r11We5xrd6Hk8fg
        FFPtEn4iXxuP4a1OvtVsdIw=
X-Google-Smtp-Source: AMsMyM7Q6GOgO8625CJmBv6MLgDZiliD84pRE6x81iRupjmdt0BBLRix7icwkCCWlCQ1o3E1f58fvg==
X-Received: by 2002:a17:90a:7301:b0:213:8a08:2f18 with SMTP id m1-20020a17090a730100b002138a082f18mr66039871pjk.50.1668048478022;
        Wed, 09 Nov 2022 18:47:58 -0800 (PST)
Received: from debian.me (subs02-180-214-232-25.three.co.id. [180.214.232.25])
        by smtp.gmail.com with ESMTPSA id s30-20020a17090a69a100b00217cdc4b0a5sm1905248pjj.16.2022.11.09.18.47.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Nov 2022 18:47:57 -0800 (PST)
Received: by debian.me (Postfix, from userid 1000)
        id 52682103F55; Thu, 10 Nov 2022 09:47:52 +0700 (WIB)
Date:   Thu, 10 Nov 2022 09:47:52 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Veerasenareddy Burru <vburru@marvell.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        lironh@marvell.com, aayarekar@marvell.com, sedara@marvell.com,
        sburla@marvell.com, linux-doc@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, Andrew Lunn <andrew@lunn.ch>,
        Lorenzo Bianconi <lorenzo@kernel.org>
Subject: Re: [PATCH net-next 1/8] octeon_ep_vf: Add driver framework and
 device initialization
Message-ID: <Y2xmWCJBiSsSDtMJ@debian.me>
References: <20221108204209.23071-1-vburru@marvell.com>
 <20221108204209.23071-2-vburru@marvell.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="FsnYKwZTeihymnoD"
Content-Disposition: inline
In-Reply-To: <20221108204209.23071-2-vburru@marvell.com>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--FsnYKwZTeihymnoD
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 08, 2022 at 12:41:52PM -0800, Veerasenareddy Burru wrote:
> Add driver framework and device setup and initialization for Octeon
> PCI Endpoint NIC VF.
>=20
> Add implementation to load module, initilaize, register network device,
> cleanup and unload module.
>

s/initilaize/initialize/

> diff --git a/Documentation/networking/device_drivers/ethernet/marvell/oct=
eon_ep_vf.rst b/Documentation/networking/device_drivers/ethernet/marvell/oc=
teon_ep_vf.rst
> new file mode 100644
> index 000000000000..258229610f3e
> --- /dev/null
> +++ b/Documentation/networking/device_drivers/ethernet/marvell/octeon_ep_=
vf.rst
> @@ -0,0 +1,19 @@
> +.. SPDX-License-Identifier: GPL-2.0+
> +
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +Linux kernel networking driver for Marvell's Octeon PCI Endpoint NIC VF
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +
> +Network driver for Marvell's Octeon PCI EndPoint NIC VF.
> +Copyright (c) 2020 Marvell International Ltd.
> +
> +Overview
> +=3D=3D=3D=3D=3D=3D=3D=3D
> +This driver implements networking functionality of Marvell's Octeon PCI
> +EndPoint NIC VF.
> +
> +Supported Devices
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +Currently, this driver support following devices:
> + * Network controller: Cavium, Inc. Device b203
> + * Network controller: Cavium, Inc. Device b403

As kernel test robot has reported [1], you need to add the doc to toctree
(index):

---- >8 ----

diff --git a/Documentation/networking/device_drivers/ethernet/index.rst b/D=
ocumentation/networking/device_drivers/ethernet/index.rst
index 5196905582c5b3..ccb7baf83b0ad9 100644
--- a/Documentation/networking/device_drivers/ethernet/index.rst
+++ b/Documentation/networking/device_drivers/ethernet/index.rst
@@ -39,6 +39,7 @@ Contents:
    intel/ice
    marvell/octeontx2
    marvell/octeon_ep
+   marvell/octeon_ep_vf
    mellanox/mlx5
    microsoft/netvsc
    neterion/s2io

Thanks.

[1] https://lore.kernel.org/linux-doc/202211092349.9UIWX9cD-lkp@intel.com/

--=20
An old man doll... just what I always wanted! - Clara

--FsnYKwZTeihymnoD
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCY2xmVAAKCRD2uYlJVVFO
o7j3AP9tA3GJnGjSmoMKusz6T2S1/dgLZDOiHmhW5JhENELb1gEA+J+e7LaF0bx0
M4WMyf2OipsDc/4KIJc1KERhqUEMjQk=
=VjA0
-----END PGP SIGNATURE-----

--FsnYKwZTeihymnoD--
