Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AE06559E80
	for <lists+netdev@lfdr.de>; Fri, 24 Jun 2022 18:27:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231207AbiFXQYm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jun 2022 12:24:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230197AbiFXQYj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jun 2022 12:24:39 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B376609EC;
        Fri, 24 Jun 2022 09:24:37 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id f190so1329532wma.5;
        Fri, 24 Jun 2022 09:24:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Fz3eKb7QtxlKCXajNfxmGqshZRvTbTcL6Dlx0Eq94Vc=;
        b=btEo+IaaLOmM5IDhiHneLo+Jhd0TtBY/zedbRBf4x0Hkp08O/+LN+yLpIjBgDSnnQv
         oauriEUxZkBn8b9ys1HGRkese3qecvUI3KpKmsQUgm/o2L+YOntawK2yNjkVcGUyQE8t
         pgzjdds1RNLCJXd825jlf2Q5+18toptKkCWRmiVU2MhMQO5Ls5C4o6GipmdeIVlPFAtF
         4ogTM50JRgp94RIHfwmWF2jJCWrLytSuBvB3nYMxDWAGjWOJX427Gyjo8N/D5z21x8NA
         ZFqUQOjqsM4CJn2x0dSmlcpmY4yRFE4cgVwP8BnCfJ57sBZ0tJ3YNSi3uikNOPYp4yz3
         6XEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Fz3eKb7QtxlKCXajNfxmGqshZRvTbTcL6Dlx0Eq94Vc=;
        b=LP+DODJQy+HMvmbXLlILfMqrlPojgjfHROrnOzruFi2+ch71wPFQ5wQMIhgbc+fV8k
         v++FIrbsRfkE0Yb2Jjw7t2rwPyjw5xDzY9uqFTZcUE59QLfu2Hns6lYcDZ6qw5WCdPAo
         PNVw+bqoHMSsfoOYc9Evbk5XT7Q1+KViK1uLAdGn/GBwlil85yH5OQNrsHnR2337IJoI
         vkgL3BO8e40SVz2sIcEP/PaIrjF2swqi0nPveYPH+3XGyuGdL/gFmd1aAK00bkW5P1rf
         42ZBTQmPpFl0K3X7fel4/NhP6Ya7Ri54wV7URn7pJsuyfAdvESTnp4M6yNJYorGHkuU/
         N0KA==
X-Gm-Message-State: AJIora9uA60Dvctc8in/peG3EEN6CfXe6dSTW1uBjNFNriTKl2l6GQZA
        MICD723fvCNk0MQWfJr183M=
X-Google-Smtp-Source: AGRyM1uT1+JWnJa68qcJli/mDCcqnzkgkEDjQbEtNWBf+Tu/i4XL4QFKDBcT0v5e0QCX5TOBNzL3wA==
X-Received: by 2002:a7b:c5da:0:b0:39c:542a:a07b with SMTP id n26-20020a7bc5da000000b0039c542aa07bmr4904884wmk.83.1656087875442;
        Fri, 24 Jun 2022 09:24:35 -0700 (PDT)
Received: from orome (p200300e41f12c800f22f74fffe1f3a53.dip0.t-ipconnect.de. [2003:e4:1f12:c800:f22f:74ff:fe1f:3a53])
        by smtp.gmail.com with ESMTPSA id f8-20020a1cc908000000b0039c99f61e5bsm6963003wmb.5.2022.06.24.09.24.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jun 2022 09:24:34 -0700 (PDT)
Date:   Fri, 24 Jun 2022 18:24:32 +0200
From:   Thierry Reding <thierry.reding@gmail.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     linux-tegra@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, vbhadram@nvidia.com,
        treding@nvidia.com, robh+dt@kernel.org, catalin.marinas@arm.com,
        krzysztof.kozlowski+dt@linaro.org, kuba@kernel.org,
        jonathanh@nvidia.com, will@kernel.org
Subject: Re: (subset) [PATCH net-next v1 4/9] memory: tegra: Add MGBE memory
 clients for Tegra234
Message-ID: <YrXlQJ1qzsZZrx7Q@orome>
References: <20220623074615.56418-1-vbhadram@nvidia.com>
 <20220623074615.56418-4-vbhadram@nvidia.com>
 <165608679241.23612.16454571226827958210.b4-ty@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="ELvShlyS5h/f0Ju7"
Content-Disposition: inline
In-Reply-To: <165608679241.23612.16454571226827958210.b4-ty@linaro.org>
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


--ELvShlyS5h/f0Ju7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 24, 2022 at 06:06:35PM +0200, Krzysztof Kozlowski wrote:
> On Thu, 23 Jun 2022 13:16:10 +0530, Bhadram Varka wrote:
> > From: Thierry Reding <treding@nvidia.com>
> >=20
> > Tegra234 has multiple network interfaces with each their own memory
> > clients and stream IDs to allow for proper isolation.
> >=20
> >=20
>=20
> Applied, thanks!
>=20
> [4/9] memory: tegra: Add MGBE memory clients for Tegra234
>       https://git.kernel.org/krzk/linux-mem-ctrl/c/6b36629c85dc7d4551e57e=
92a3e970d099333e4e

Ah yes, you'll need the dt-bindings header for this driver bit as well.
If you don't mind I could pick all of these up into the Tegra tree and
resolve the dependencies there, then send a pull request for the memory
tree that incorporates the dt-bindings branch as a dependency.

That way you don't have to worry about this at all. We might also get
another set of similar changes for PCI or USB during this cycle, so it'd
certainly be easier to collect all of these in a central place.

Thierry

--ELvShlyS5h/f0Ju7
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEiOrDCAFJzPfAjcif3SOs138+s6EFAmK15UAACgkQ3SOs138+
s6GY0w//Z2YQbjVYoy/R8sVrEOOoRQ4RDJWm6hiI5p3x64fDoBOUjpfziT28nPfE
V3OUcPMmf/V8p9ddhu7TqWwgtAIil3Y1ZkwYrm0iddv0jnNNDcT3WbeqPZXlKtUr
u7DvsRF3Pv/dMjFKyEPwf9rOvZgGDvycRbXiA7uosQUzUuot+7AxSXe5cToXvZtB
HwR5OQ3ZFcpstHaBfK/5mjC+fRaVCLl0MOXdBf4vIcO/cXAW/wATWp6YTxDwlZ4Q
S7FqxPIqlsXYbPkHL33MOhjWevKiZYQd6Q/ed1ywP9I/yEwou+bbGQ1gz2GAvADp
Hl/mJgTvYq7vnc/6rmjqlq2Es8Uy6quonzNHkgAKJxUGXTQyJHoA7mUr3o4GABD5
t3h+WqpFc41ApVSjpGnwdDXaCTGKor+5NIQCsqiNxfhKZ6OhQ5Q31T/4sll6tLOs
ZkzfNP/56TfTOqCsHRVqAn94EgOM1NNs5OnJw8L4fGoGgeinM0OXl5DEn5GUyRM4
1qhTyBLHczLqwLAeOjeoeQI4bd+wkQkWuIDSKwAh2Y5PUMtmcMUGcMFD1CUzR1Kd
PugLU/05tM7SScvIzIkzB29o7AQHNiFI3IKJjs1l7+e39PXRcnBMM8Wu+kvaF7Dz
mABmCkPW7g1cHuhuJ1IrMROXPeS+5GrLdNe4yCdQa9UabzS+U+U=
=HAdh
-----END PGP SIGNATURE-----

--ELvShlyS5h/f0Ju7--
