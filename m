Return-Path: <netdev+bounces-10614-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 94F3A72F5E8
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 09:18:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C68A71C2090C
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 07:18:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B31F817D7;
	Wed, 14 Jun 2023 07:18:37 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A75927F
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 07:18:37 +0000 (UTC)
Received: from mail-vs1-xe34.google.com (mail-vs1-xe34.google.com [IPv6:2607:f8b0:4864:20::e34])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 533FA211B
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 00:18:20 -0700 (PDT)
Received: by mail-vs1-xe34.google.com with SMTP id ada2fe7eead31-43f5273cd82so22154137.3
        for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 00:18:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20221208.gappssmtp.com; s=20221208; t=1686727098; x=1689319098;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xWqp8+3MZcT/Qp4VzgeJFqfoJNX477ShUvbIsRioGOw=;
        b=MiCweefJaq2Rs0ySFI2YdvxxsjV+Tz+OX0tIhBr/LjFZitS74y2nNqvs6OlVYfv2jN
         8TF3c2dxnGSXewEgziDxxbGNEAnZHZn17Mpg64TaHDAiU1cGkGg4iqGJxKPkx4PfEDz7
         KgL1Ar+uP+3WBeEroqFl9aFVrIg3ymtIz/BO8L5owGvjmGkDYaxmc/a4rm+TAAJ2rnMN
         QI8mHooJ381PRQHeI+j+kss74OjpD5qy4bTJOiYXPctm9TY6m94Sf9fKLUVN5zq4rxGW
         lLNG1Osegk5tDnCL6bDzlbg/Gw9QfrZ4AJGg2r5xjkl/OWBmXvF9U9VG53qDFVbRGx+Q
         SOLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686727098; x=1689319098;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xWqp8+3MZcT/Qp4VzgeJFqfoJNX477ShUvbIsRioGOw=;
        b=YS3vkpaA2uZM84sGgGFN9bX4dUX2HDHZPLkdgh9CT7oNT0YWCDVvvsxfCMvsX1lgLD
         ypExn/jcjA4SE0SsLH3SDc/c6BQS9X60PIlPcguVTMx5SCJScAm4+TFRk0e/4Zytg6vZ
         PMrXt8NVdEMgY2jzWo3QdoArpALF+EsmcyBsX/9Op1JZ3gV0V6ACA5RPR8Fh6iBCVaNZ
         QshtN5kB8DKAxsX6UkSZCrQGd1ZVlMnWbU1jEifGnWPZ5DbiuXHaYg1w6ueMxznLaFv6
         9W2WYpx7KkPMqi7yXbcPYZhYn82rNb1+EV/YvrrZSmfqPKZ6PkYidFWAdM3wmTrq+0RI
         hHiA==
X-Gm-Message-State: AC+VfDx+hRsHQMZhco8eHqoCoxJ/g5J2Os4WOIJHBLAzf8XAQIJrxOfy
	B7uuyBumssczKBnyDtQkkaHGYJAF1qvdSDnnhgVlpg==
X-Google-Smtp-Source: ACHHUZ5/lIGOUl/l3ycPBA6fbzQyMwAzSP8rc7XBTn1VRb2W3EotcDSLMNZEqinAXiE/Za/C+5sDlrb/IA4v9qkeWCA=
X-Received: by 2002:a67:b401:0:b0:434:7856:bf9f with SMTP id
 x1-20020a67b401000000b004347856bf9fmr6830203vsl.12.1686727097789; Wed, 14 Jun
 2023 00:18:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230612092355.87937-1-brgl@bgdev.pl> <20230612092355.87937-4-brgl@bgdev.pl>
 <7fe7078e-404d-28e5-0dd1-53b7f9cd7626@linaro.org>
In-Reply-To: <7fe7078e-404d-28e5-0dd1-53b7f9cd7626@linaro.org>
From: Bartosz Golaszewski <brgl@bgdev.pl>
Date: Wed, 14 Jun 2023 09:18:06 +0200
Message-ID: <CAMRc=MdwqF9_LM2BeVOtx+DaKv8Cv8Bp-cP=sE-RBO=UoosSLg@mail.gmail.com>
Subject: Re: [PATCH 03/26] phy: qcom: add the SGMII SerDes PHY driver
To: Konrad Dybcio <konrad.dybcio@linaro.org>
Cc: Vinod Koul <vkoul@kernel.org>, Bhupesh Sharma <bhupesh.sharma@linaro.org>, 
	Andy Gross <agross@kernel.org>, Bjorn Andersson <andersson@kernel.org>, 
	"David S . Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Rob Herring <robh+dt@kernel.org>, 
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>, Conor Dooley <conor+dt@kernel.org>, 
	Kishon Vijay Abraham I <kishon@kernel.org>, Giuseppe Cavallaro <peppe.cavallaro@st.com>, 
	Alexandre Torgue <alexandre.torgue@foss.st.com>, Jose Abreu <joabreu@synopsys.com>, 
	netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org, 
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-phy@lists.infradead.org, linux-arm-kernel@lists.infradead.org, 
	linux-stm32@st-md-mailman.stormreply.com, 
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, Jun 12, 2023 at 11:45=E2=80=AFAM Konrad Dybcio <konrad.dybcio@linar=
o.org> wrote:
>
>
>
> On 12.06.2023 11:23, Bartosz Golaszewski wrote:
> > From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
> >
> > Implement support for the SGMII/SerDes PHY present on various Qualcomm
> > platforms.
> >
> > Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
> > ---
> > +static const struct regmap_config qcom_dwmac_sgmii_phy_regmap_cfg =3D =
{
> > +     .reg_bits               =3D 32,
> > +     .val_bits               =3D 32,
> > +     .reg_stride             =3D 4,
> > +     .use_relaxed_mmio       =3D true,
> > +     .disable_locking        =3D true,
> The last two are rather brave, no?
>

We don't need locking because all callbacks are already protected by
the phy subsystem with a mutex and I don't really see anything that
would make it dangerous to use relaxed semantics in this driver. It's
just basic configuration.

Bart

> Konrad
> > +};
> > +
> > +static int qcom_dwmac_sgmii_phy_probe(struct platform_device *pdev)
> > +{
> > +     struct qcom_dwmac_sgmii_phy_data *data;
> > +     struct device *dev =3D &pdev->dev;
> > +     struct phy_provider *provider;
> > +     struct clk *refclk;
> > +     void __iomem *base;
> > +     struct phy *phy;
> > +
> > +     data =3D devm_kzalloc(dev, sizeof(*data), GFP_KERNEL);
> > +     if (!data)
> > +             return -ENOMEM;
> > +
> > +     base =3D devm_platform_ioremap_resource(pdev, 0);
> > +     if (IS_ERR(base))
> > +             return PTR_ERR(base);
> > +
> > +     data->regmap =3D devm_regmap_init_mmio(dev, base,
> > +                                          &qcom_dwmac_sgmii_phy_regmap=
_cfg);
> > +     if (IS_ERR(data->regmap))
> > +             return PTR_ERR(data->regmap);
> > +
> > +     phy =3D devm_phy_create(dev, NULL, &qcom_dwmac_sgmii_phy_ops);
> > +     if (IS_ERR(phy))
> > +             return PTR_ERR(phy);
> > +
> > +     refclk =3D devm_clk_get_enabled(dev, "sgmi_ref");
> > +     if (IS_ERR(refclk))
> > +             return PTR_ERR(refclk);
> > +
> > +     provider =3D devm_of_phy_provider_register(dev, of_phy_simple_xla=
te);
> > +     if (IS_ERR(provider))
> > +             return PTR_ERR(provider);
> > +
> > +     phy_set_drvdata(phy, data);
> > +     platform_set_drvdata(pdev, data);
> > +
> > +     return 0;
> > +}
> > +
> > +static const struct of_device_id qcom_dwmac_sgmii_phy_of_match[] =3D {
> > +     { .compatible =3D "qcom,sa8775p-dwmac-sgmii-phy" },
> > +     { },
> > +};
> > +MODULE_DEVICE_TABLE(of, qcom_dwmac_sgmii_phy_of_match);
> > +
> > +static struct platform_driver qcom_dwmac_sgmii_phy_driver =3D {
> > +     .probe  =3D qcom_dwmac_sgmii_phy_probe,
> > +     .driver =3D {
> > +             .name   =3D "qcom-dwmac-sgmii-phy",
> > +             .of_match_table =3D qcom_dwmac_sgmii_phy_of_match,
> > +     }
> > +};
> > +
> > +module_platform_driver(qcom_dwmac_sgmii_phy_driver);
> > +
> > +MODULE_DESCRIPTION("Qualcomm DWMAC SGMII PHY driver");
> > +MODULE_LICENSE("GPL");

