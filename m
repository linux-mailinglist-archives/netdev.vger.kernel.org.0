Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5430569A5A
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 08:19:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234435AbiGGGRj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 02:17:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229538AbiGGGRj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 02:17:39 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52A9325C73;
        Wed,  6 Jul 2022 23:17:38 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id ez10so468257ejc.13;
        Wed, 06 Jul 2022 23:17:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=W0DdNh2Nlih+PoWEnsFjxq96C2oblcrA+vaEVvT2h5A=;
        b=bq98yiS9d0TV4gBJFSzDNv9oiDpdXizSc6mRL7nniI3Git3V9BkZmwqtyvxqWlLTqz
         ha/YVJO4CI7ujkrWLrWmcjulxCMBe5v7i9saTV2n0zS4AsIocOGmMUOkYLcD/UcmczpS
         28yTpD43+oL2cZU5ifhhnW8rRIqCxfDW+XOIPIehWWrYVI9jhYrAXA+zkuggEOJmkNkn
         lUNHSb39yfRgiL4IB77Euy/3+jEvCdEjUCywLai5pRVCPZDyvqBSwYq1fvnqF++ZbA9O
         bpiivI9QEU21f4v/PHFdgMJR4p6V2zBNvW9DCjUPxMbmQYpmoBtsL9UiynopjbRoI26T
         ckrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=W0DdNh2Nlih+PoWEnsFjxq96C2oblcrA+vaEVvT2h5A=;
        b=Y0iq58MAK63RMtSnBRHQuz/ALNs+kFtJ5MZmUc6LIrgMiwuMeIwuu0Ydx8ofweEAvj
         6B0r9IsYEQ5V6KY3cWOV87kYTdHLp96ttk8rMQ29todoKBaMABIritGhUpQLkeHiL5oj
         78/KoZBA5bdtx7FiFbCh5OfX05AztOwV5snn7CSEWzWv8A1wrHqYgWiQcekXXaA32lGU
         +3ggnnCEP5QoEiIEIj+umSbN4jjoHEQ3DCsDrGtnTX17EaStCGt3SmWjqysr67P6tcZO
         M9iCreF1oWHw6NdtQaeR/Gi/DE8Lp4UW7Of4uWaNmiw0rye8UGeuF3CxvcVD9q8ob0i/
         NqcA==
X-Gm-Message-State: AJIora+xWVcTA1RLTr909f+IBgE6hvuXLICIgy8fnrMG1+v3QC72R0Vz
        EY7dbkjhCvo6nDXHLf3TCGU=
X-Google-Smtp-Source: AGRyM1uADo3+/TYlJy8uiHXMh+Q0C1jg74w9AB5BBSNjZSlH98pTuc+y5w/kwGDMFI5aghCDichuvw==
X-Received: by 2002:a17:907:1dea:b0:72a:6012:7bbc with SMTP id og42-20020a1709071dea00b0072a60127bbcmr36752207ejc.258.1657174656841;
        Wed, 06 Jul 2022 23:17:36 -0700 (PDT)
Received: from orome (p200300e41f12c800f22f74fffe1f3a53.dip0.t-ipconnect.de. [2003:e4:1f12:c800:f22f:74ff:fe1f:3a53])
        by smtp.gmail.com with ESMTPSA id v9-20020a170906292900b00722e50dab2csm1679540ejd.109.2022.07.06.23.17.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Jul 2022 23:17:35 -0700 (PDT)
Date:   Thu, 7 Jul 2022 08:17:34 +0200
From:   Thierry Reding <thierry.reding@gmail.com>
To:     Rob Herring <robh@kernel.org>
Cc:     Jon Hunter <jonathanh@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, devicetree@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        Bhadram Varka <vbhadram@nvidia.com>,
        linux-tegra@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH v3 5/9] dt-bindings: net: Add Tegra234 MGBE
Message-ID: <YsZ6fus1yNcf/H/Q@orome>
References: <20220706213255.1473069-1-thierry.reding@gmail.com>
 <20220706213255.1473069-6-thierry.reding@gmail.com>
 <1657169989.827036.709503.nullmailer@robh.at.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="IH1QUGKz42DBXVA0"
Content-Disposition: inline
In-Reply-To: <1657169989.827036.709503.nullmailer@robh.at.kernel.org>
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


--IH1QUGKz42DBXVA0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 06, 2022 at 10:59:49PM -0600, Rob Herring wrote:
> On Wed, 06 Jul 2022 23:32:51 +0200, Thierry Reding wrote:
> > From: Bhadram Varka <vbhadram@nvidia.com>
> >=20
> > Add device-tree binding documentation for the Multi-Gigabit Ethernet
> > (MGBE) controller found on NVIDIA Tegra234 SoCs.
> >=20
> > Signed-off-by: Jon Hunter <jonathanh@nvidia.com>
> > Signed-off-by: Bhadram Varka <vbhadram@nvidia.com>
> > Signed-off-by: Thierry Reding <treding@nvidia.com>
> > ---
> > Changes in v3:
> > - add macsec and macsec-ns interrupt names
> > - improve mdio bus node description
> > - drop power-domains description
> > - improve bindings title
> >=20
> > Changes in v2:
> > - add supported PHY modes
> > - change to dual license
> >=20
> >  .../bindings/net/nvidia,tegra234-mgbe.yaml    | 169 ++++++++++++++++++
> >  1 file changed, 169 insertions(+)
> >  create mode 100644 Documentation/devicetree/bindings/net/nvidia,tegra2=
34-mgbe.yaml
> >=20
>=20
> My bot found errors running 'make DT_CHECKER_FLAGS=3D-m dt_binding_check'
> on your patch (DT_CHECKER_FLAGS is new in v5.13):
>=20
> yamllint warnings/errors:
>=20
> dtschema/dtc warnings/errors:
> Error: Documentation/devicetree/bindings/net/nvidia,tegra234-mgbe.example=
=2Edts:53.34-35 syntax error
> FATAL ERROR: Unable to parse input tree

This is an error that you'd get if patch 3 is not applied. Not sure if I
managed to confuse the bot somehow, but I cannot reproduce this if I
apply the series on top of v5.19-rc1 or linux-next.

Thierry

--IH1QUGKz42DBXVA0
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEiOrDCAFJzPfAjcif3SOs138+s6EFAmLGen4ACgkQ3SOs138+
s6FYxBAAmOYj/ns1ubKnCj7pVeO/iwdfR+znP55JlzlOfwEeSZBl9aSkFBBj2TPR
aQufVYo3CsZHD0gXb2zK9xnsDEabMhTvl1c5sKiLzqz2FDAMS/RAHWaQ4GKPRcVb
MhjL35JzprD7yGEYhRNUELKyDYasBEpr9e0gb3qUsT2DWWspmKWXi/nmwJbGkyOj
aiXtulSG+IN72L6HDbjaYNQrf9GBo2aYlnFLjfrRMLgISpazBiLu9ChFV5xnv0Uj
/X4GA0G33ubimhkPocEKy/Ufn5oQ7NNmDmCOr5fAbcUYM9HGZLX0WSKZxIv485yP
MjM6jZIhCdKipYuc4coKrjUxlEDDl9MhyHB6K400e9TWSyInuKmztZS7Z/p1Cd3A
hHZx23tB/2H6velKnHn7jM65E8isNdOtXw3eNks72tpFdMev0V4WZiPCfySN+HHc
TpEsyKzwzWMhwlbWr8FzO7bFkRVpxvmWny6lXGUefK1MVgpW2nXcfKxz7c1K6Vf6
EsygIByNj0iX7quwJRr/BYrvjLFhtKIOTBOlvsL4WXWs/h6FQx2SF7cV6SbclnvC
5+92+exaYU5WhwmTFf0DTwsWOJFTMUfLltwC/r4ImSb0Bwvg65HumzdrT8Mp3LVi
iZ1UnhmUmis95ObzYZWdOFIXpIyebQdCSUg0hQ29VmFacBv328U=
=6hTZ
-----END PGP SIGNATURE-----

--IH1QUGKz42DBXVA0--
