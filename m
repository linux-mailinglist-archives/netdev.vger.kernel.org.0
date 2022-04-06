Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 083574F6695
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 19:19:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238741AbiDFRUv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 13:20:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238834AbiDFRUZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 13:20:25 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1CB2320DB6;
        Wed,  6 Apr 2022 08:18:23 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id k23so3728567wrd.8;
        Wed, 06 Apr 2022 08:18:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=U40qc6GQ+SYodTIzBOdqOZLwZjwjzDI8PPMpjuLO23M=;
        b=qGKYV5W384zdQNQ8zw1aGodGOdwK21gS5pz/8yEd9vW0X5PoY6zkvso/jy0OD2ZpMl
         R6cGMhidVv1PRHXyAaPP34WONoy9IJuyWOY3emvm4Pc+Qa0/ymhjs+k0p3UAMRjQ+bYP
         S1Rbh1ffDrpxOH/N0luR86LQVoWz3wpcez7Eu7PpGXY4HjxsXBn136wgErywTkxrbtL4
         gr0iQDR4xH6CCvfaUACbfC311BeaKXYn8VbIodSo173OK9I7wfNVegD4wBes3R2AfHCU
         AvEfr4/J7RLiLGyHmQC0ixgvXmzLB1h6SNh2w4lY9ytIRlqnH6/1n3XGymYCLzEFLco+
         GXAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=U40qc6GQ+SYodTIzBOdqOZLwZjwjzDI8PPMpjuLO23M=;
        b=O98jNvcPlf7gYGZn8jtRWy616QyxSuFE2WOM1fblkpojeVW9qBZZwnqas7P2hsOiAI
         DLD720cCJOsmSDbtBxbUa15osxmroKvigjrEO+a+j3qT6DyxMnOB4djwspzeEkLi6Gn9
         pG6UReDoTWR2thMae9YtEhfVQllFPakFnAcjccJfS4VgWWhdh/hfhRh7kBQl9si59LXu
         iuf2rCj4uf9+kdDuYg4XCRBrzXRFgJqM8e1Sgp7HdiCXe0ozCOPffqCzU0wxaVFZS0Gh
         QCx7bJLuv/5Ed1x3Fvr3jNYaFpZOpOy6dzq+zMtK7vwr7PxpacOcS35pkqH9Xgokzkk4
         VB4g==
X-Gm-Message-State: AOAM533hY4AvpUGioLtHhQjh1p/FIeu1gQ2HnSukaa7CfpRWhQX4CLVG
        pNQuZ9rjXTtSmLc6uCnGrJs=
X-Google-Smtp-Source: ABdhPJyCYjrUpOXRKUOMNlOKspcPqmHHJD1TpshBOnLqE/8upHaCgOAE57aqeMsyScW3cblgtmrGfw==
X-Received: by 2002:a5d:528b:0:b0:203:d928:834c with SMTP id c11-20020a5d528b000000b00203d928834cmr7312065wrv.500.1649258302003;
        Wed, 06 Apr 2022 08:18:22 -0700 (PDT)
Received: from orome (pd9e518f7.dip0.t-ipconnect.de. [217.229.24.247])
        by smtp.gmail.com with ESMTPSA id s10-20020adf978a000000b002060c258514sm10062623wrb.23.2022.04.06.08.18.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Apr 2022 08:18:20 -0700 (PDT)
Date:   Wed, 6 Apr 2022 17:18:18 +0200
From:   Thierry Reding <thierry.reding@gmail.com>
To:     Brian Silverman <bsilver16384@gmail.com>
Cc:     Brian Silverman <brian.silverman@bluerivertech.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Dan Murphy <dmurphy@ti.com>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:CAN NETWORK DRIVERS" <linux-can@vger.kernel.org>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        "open list:TEGRA ARCHITECTURE SUPPORT" <linux-tegra@vger.kernel.org>
Subject: Re: [RFC PATCH] can: m_can: Add driver for M_CAN hardware in NVIDIA
 devices
Message-ID: <Yk2vOj8wKi4FdPg2@orome>
References: <20220106002514.24589-1-brian.silverman@bluerivertech.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="BsOhgM1lSoA88Bvi"
Content-Disposition: inline
In-Reply-To: <20220106002514.24589-1-brian.silverman@bluerivertech.com>
User-Agent: Mutt/2.2.1 (c8109e14) (2022-02-19)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--BsOhgM1lSoA88Bvi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 05, 2022 at 04:25:09PM -0800, Brian Silverman wrote:
> It's a M_TTCAN with some NVIDIA-specific glue logic and clocks. The
> existing m_can driver works with it after handling the glue logic.
>=20
> The code is a combination of pieces from m_can_platform and NVIDIA's
> driver [1].
>=20
> [1] https://github.com/hartkopp/nvidia-t18x-can/blob/master/r32.2.1/nvidi=
a/drivers/net/can/mttcan/hal/m_ttcan.c
>=20
> Signed-off-by: Brian Silverman <brian.silverman@bluerivertech.com>
> ---
> I ran into bugs with the error handling in NVIDIA's m_ttcan driver, so I
> switched to m_can which has been much better. I'm looking for feedback
> on whether I should ensure rebasing hasn't broken anything, write up DT
> documentation, and submit this patch for real. The driver works great,
> but I've got some questions about submitting it.
>=20
> question: This has liberal copying of GPL code from NVIDIA's
> non-upstreamed m_ttcan driver. Is that OK?
>=20
> corollary: I don't know what any of this glue logic does. I do know the
> device doesn't work without it. I can't find any documentation of what
> these addresses do.
>=20
> question: There is some duplication between this and m_can_platform. It
> doesn't seem too bad to me, but is this the preferred way to do it or is
> there another alternative?
>=20
> question: Do new DT bindings need to be in the YAML format, or is the
> .txt one OK?
>=20
>  drivers/net/can/m_can/Kconfig       |  10 +
>  drivers/net/can/m_can/Makefile      |   1 +
>  drivers/net/can/m_can/m_can_tegra.c | 362 ++++++++++++++++++++++++++++
>  3 files changed, 373 insertions(+)
>  create mode 100644 drivers/net/can/m_can/m_can_tegra.c

Sorry for the late reply, I completely missed this. I think along with
the DT bindings it'd be great if you could provide DT updates for the
platform that you tested this on so we can get that upstream as well.

I don't know much about CAN so I can't comment on those pieces, so just
a few thoughts on the integration bits.

> diff --git a/drivers/net/can/m_can/m_can_tegra.c b/drivers/net/can/m_can/=
m_can_tegra.c
[...]
> +static int m_can_tegra_probe(struct platform_device *pdev)
> +{
[...]
> +	ret =3D clk_set_parent(can_clk, pclk);
> +	if (ret) {
> +		goto probe_fail;
> +	}
> +
> +	ret =3D fwnode_property_read_u32(dev_fwnode(&pdev->dev), "can-clk-rate"=
, &rate);
> +	if (ret) {
> +		goto probe_fail;
> +	}
> +
> +	new_rate =3D clk_round_rate(can_clk, rate);
> +	if (!new_rate)
> +		dev_warn(&pdev->dev, "incorrect CAN clock rate\n");
> +
> +	ret =3D clk_set_rate(can_clk, new_rate > 0 ? new_rate : rate);
> +	if (ret) {
> +		goto probe_fail;
> +	}
> +
> +	ret =3D clk_set_rate(host_clk, new_rate > 0 ? new_rate : rate);
> +	if (ret) {
> +		goto probe_fail;
> +	}
> +
> +	if (core_clk) {
> +		ret =3D fwnode_property_read_u32(dev_fwnode(&pdev->dev), "core-clk-rat=
e", &rate);
> +		if (ret) {
> +			goto probe_fail;
> +		}
> +		new_rate =3D clk_round_rate(core_clk, rate);
> +		if (!new_rate)
> +			dev_warn(&pdev->dev, "incorrect CAN_CORE clock rate\n");
> +
> +		ret =3D clk_set_rate(core_clk, new_rate > 0 ? new_rate : rate);
> +		if (ret) {
> +			goto probe_fail;
> +		}
> +	}

Can all of this clock setup not be simplified by using the standard
assigned-clocks, assigned-clock-parent and assigned-clock-rates DT
properties?

> +
> +	res =3D platform_get_resource_byname(pdev, IORESOURCE_MEM, "m_can");
> +	addr =3D devm_ioremap_resource(&pdev->dev, res);
> +	if (IS_ERR(addr)) {
> +		ret =3D PTR_ERR(addr);
> +		goto probe_fail;
> +	}
> +
> +	irq =3D platform_get_irq_byname(pdev, "int0");
> +	if (irq < 0) {
> +		ret =3D -ENODEV;
> +		goto probe_fail;
> +	}

If there's only one of these, it doesn't make much sense to name them.
But perhaps this can be discussed when reviewing the DT bindings.

[...]
> +static const struct of_device_id m_can_of_table[] =3D {
> +	{ .compatible =3D "nvidia,tegra194-m_can", .data =3D NULL },

We typically name the compatible string after the IP block name. The TRM
references this as simply "CAN", so I think "nvidia,tegra194-can" would
be more in line with what we use for existing Tegra hardware.

Thierry

--BsOhgM1lSoA88Bvi
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEiOrDCAFJzPfAjcif3SOs138+s6EFAmJNrzgACgkQ3SOs138+
s6H85hAAjpQPOGIqFtsZNbZ6ZNiio0A9LQhmCQTjcW2fIixt0g7Yqk4Hn8Df1FAg
fJibRWvhio+Yor4JWUIP9NsntbgywoKoUSO1rX+LX66KP0Q23laOft/oYZc3soAu
kVBeL4JsvcwJOKY1K/smty4OY2zC6G4fojBdYnc6kQhoFyTKxER9Tx6/RTRgDz/n
8vbWejOjxEgrAJpJ+a/xKPCDf8N0qfXLITcdT2v29HAorgL8QmTnYZ3ky2ROMEKn
BD08Dw14Fe45NCm98H/ACd4sFBuLKmaB2B9P+XlZVO4z8LDxAvpdHPoghD/nfGTa
IV0RlDYgwpsq+hfwkucjNaznaQxK7uIYobCp8jqZXdqkxNELRCa+W/4Fk64b3oHQ
f0r9HJWDFRkU/8XWFP2fxNvP52HhM1bAJIgoO/F2xLprgIjcniQCT1wbuGBkICxM
g0mf7W0pbzHT2drCnaolNNTB2Zugey5ulbf0pFe88x9taFr2H0P3anEVJyasMJM/
u0PFhTxcSd4osAV/eWNDYv4qE2pVASHt7TssKpPfiNdcu8+7BT0zKqqZfSG+NoLC
Buh5kX8GP+hFpj1E8eQZfTztaL1R3dsJRCRB0i/V7do2KpSnTxUoC0XVVNBdevJZ
OXzSVUXyfKhEnAsmp5It1Eso1iVTmMA5iO80O4T+ynxbK0DYfbw=
=Nf/A
-----END PGP SIGNATURE-----

--BsOhgM1lSoA88Bvi--
