Return-Path: <netdev+bounces-10304-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AECAD72DB95
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 09:53:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E8A091C20B75
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 07:53:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F2D05669;
	Tue, 13 Jun 2023 07:53:07 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87F6F323C
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 07:53:07 +0000 (UTC)
Received: from mail-vk1-xa2f.google.com (mail-vk1-xa2f.google.com [IPv6:2607:f8b0:4864:20::a2f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CD2010DE
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 00:53:05 -0700 (PDT)
Received: by mail-vk1-xa2f.google.com with SMTP id 71dfb90a1353d-46e28685090so100788e0c.0
        for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 00:53:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20221208.gappssmtp.com; s=20221208; t=1686642784; x=1689234784;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ksmnYzaAZG4SFOtuZwLT0Gj07ow0mCiA7tlTY9FP1/Y=;
        b=d/XOUvzXq7CkULBNjOF5cPQ9T8PQ4GUN2VTUb4tV5GYUOU/bcCMFJER5wRcTiOAxaO
         VEqeTPG5/GSimPhYdVoDC/uqRBqssvbhFmMqZ2UPpATKuDu0zcPmCBugjzLiimaHg+0O
         9wZ1rW7T5SAVt/6r/SykeSUB1kSjjeu1v/QF9yZNVYeWYL/CqPipZS2RqbveG9GDYWQl
         3yZcujcboW/sNqe2RjBd/XPxGCpKyPsA5S0Wt8H20ztGP/P8e2a+LHAM1iWQz7y5UEUU
         byzRaCp7blF315uAiXD/wO22ggP+a/pLSa4fq9EoyeAoPW6lXUTFE4Oe4EeVpTJurQyN
         Z0bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686642784; x=1689234784;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ksmnYzaAZG4SFOtuZwLT0Gj07ow0mCiA7tlTY9FP1/Y=;
        b=e3CWmXC1ZAlm1nnKDZx4ptTLw9giiPflkdBKZT53u/P/CXEvrapBgxgQxpf/6EN857
         MKzPaOkROJI2GLKbQJOz7Xsfx+tRVHMTJwlPMoOu+TxZD+Qld4nlLhO8yiAbEudUGWQq
         jSldkjcs9SQZj3MHzO9aOH8O/mpBXXtaTlyPfRvH1H6w4GoAplZq8FyunmZFrrK23/aQ
         bDEWaCjqcdA9X1M/Y+t5m/4RcQT0uFP/MWrQqsHcPFHTp6zK/RoYBU2ykYg99GI/IF3N
         n/cSbbAUkYkxOqErD4vRmfQqPGpXW5q6V4QSUW0oeNY0wYRPE52mZ6Ys/aYIWoUvTjw1
         0v2w==
X-Gm-Message-State: AC+VfDwPe6+mpPry6nJyj15WJGlx0pNHZbxdR63QVnvs2E32zfFQr6zx
	Ua1bmo+YHEBd0ZHC7hTa7438hBaZ6ejR6tp0GPX/aQ==
X-Google-Smtp-Source: ACHHUZ7i+EBDY2WITwEIRgKogtaSChdc3S4PwWz2Qp9PZP5xCpoeIGDCpD2gClqT3kwLonr4MotjvY3YKsBM2PtVtCk=
X-Received: by 2002:a1f:bd58:0:b0:46d:fd21:76fb with SMTP id
 n85-20020a1fbd58000000b0046dfd2176fbmr580943vkf.10.1686642784529; Tue, 13 Jun
 2023 00:53:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230612092355.87937-1-brgl@bgdev.pl> <20230612092355.87937-13-brgl@bgdev.pl>
 <20230612203255.72t52ucry7zzq3em@halaney-x13s>
In-Reply-To: <20230612203255.72t52ucry7zzq3em@halaney-x13s>
From: Bartosz Golaszewski <brgl@bgdev.pl>
Date: Tue, 13 Jun 2023 09:52:53 +0200
Message-ID: <CAMRc=MfmzWDZuXpb4ySxi0Xu6EWVuEZ4ReaEYbo4KCMme-+G4A@mail.gmail.com>
Subject: Re: [PATCH 12/26] net: stmmac: dwmac-qcom-ethqos: add support for the
 optional serdes phy
To: Andrew Halaney <ahalaney@redhat.com>
Cc: Vinod Koul <vkoul@kernel.org>, Bhupesh Sharma <bhupesh.sharma@linaro.org>, 
	Andy Gross <agross@kernel.org>, Bjorn Andersson <andersson@kernel.org>, 
	Konrad Dybcio <konrad.dybcio@linaro.org>, "David S . Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Rob Herring <robh+dt@kernel.org>, 
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

On Mon, Jun 12, 2023 at 10:33=E2=80=AFPM Andrew Halaney <ahalaney@redhat.co=
m> wrote:
>
> On Mon, Jun 12, 2023 at 11:23:41AM +0200, Bartosz Golaszewski wrote:
> > From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
> >
> > On sa8775p platforms, there's a SGMII SerDes PHY between the MAC and
> > external PHY that we need to enable and configure.
> >
> > Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
> > ---
> >  .../stmicro/stmmac/dwmac-qcom-ethqos.c        | 37 +++++++++++++++++++
> >  1 file changed, 37 insertions(+)
> >
> > diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c b/=
drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c
> > index 8ed05f29fe8b..3438b6229351 100644
> > --- a/drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c
> > +++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c
> > @@ -6,6 +6,7 @@
> >  #include <linux/of_device.h>
> >  #include <linux/platform_device.h>
> >  #include <linux/phy.h>
> > +#include <linux/phy/phy.h>
> >  #include <linux/property.h>
> >
> >  #include "stmmac.h"
> > @@ -93,6 +94,7 @@ struct qcom_ethqos {
> >
> >       unsigned int rgmii_clk_rate;
> >       struct clk *rgmii_clk;
> > +     struct phy *serdes_phy;
> >       unsigned int speed;
> >
> >       const struct ethqos_emac_por *por;
> > @@ -566,6 +568,30 @@ static void ethqos_fix_mac_speed(void *priv, unsig=
ned int speed)
> >       ethqos_configure(ethqos);
> >  }
> >
> > +static int qcom_ethqos_serdes_powerup(struct net_device *ndev, void *p=
riv)
> > +{
> > +     struct qcom_ethqos *ethqos =3D priv;
> > +     int ret;
> > +
> > +     ret =3D phy_set_speed(ethqos->serdes_phy, ethqos->speed);
> > +     if (ret)
> > +             return ret;
> > +
> > +     ret =3D phy_init(ethqos->serdes_phy);
> > +     if (ret)
> > +             return ret;
> > +
> > +     return phy_power_on(ethqos->serdes_phy);
>
> The docs say (phy.rst):
>
>     The general order of calls should be::
>
>         [devm_][of_]phy_get()
>         phy_init()
>         phy_power_on()
>         [phy_set_mode[_ext]()]
>         ...
>         phy_power_off()
>         phy_exit()
>         [[of_]phy_put()]
>
>     Some PHY drivers may not implement :c:func:`phy_init` or :c:func:`phy=
_power_on`,
>     but controllers should always call these functions to be compatible w=
ith other
>     PHYs. Some PHYs may require :c:func:`phy_set_mode <phy_set_mode_ext>`=
, while
>     others may use a default mode (typically configured via devicetree or=
 other
>     firmware). For compatibility, you should always call this function if=
 you know
>     what mode you will be using. Generally, this function should be calle=
d after
>     :c:func:`phy_power_on`, although some PHY drivers may allow it at any=
 time.
>
> Not really dictating you need to do that order, but if possible I think
> calling phy_set_speed after init + power_on is more generic. Not sure if
> that plays nice with the phy driver in this series or not.
>
> Otherwise, I think this looks good.
>

I had to rework the PHY driver code a bit for this order to work but
it'll be good now in v2.

Thanks!
Bart

> > +}
> > +
> > +static void qcom_ethqos_serdes_powerdown(struct net_device *ndev, void=
 *priv)
> > +{
> > +     struct qcom_ethqos *ethqos =3D priv;
> > +
> > +     phy_power_off(ethqos->serdes_phy);
> > +     phy_exit(ethqos->serdes_phy);
> > +}
> > +
> >  static int ethqos_clks_config(void *priv, bool enabled)
> >  {
> >       struct qcom_ethqos *ethqos =3D priv;
> > @@ -651,6 +677,12 @@ static int qcom_ethqos_probe(struct platform_devic=
e *pdev)
> >       if (ret)
> >               goto out_config_dt;
> >
> > +     ethqos->serdes_phy =3D devm_phy_optional_get(dev, "serdes");
> > +     if (IS_ERR(ethqos->serdes_phy)) {
> > +             ret =3D PTR_ERR(ethqos->serdes_phy);
> > +             goto out_config_dt;
> > +     }
> > +
> >       ethqos->speed =3D SPEED_1000;
> >       ethqos_update_rgmii_clk(ethqos, SPEED_1000);
> >       ethqos_set_func_clk_en(ethqos);
> > @@ -666,6 +698,11 @@ static int qcom_ethqos_probe(struct platform_devic=
e *pdev)
> >       if (of_device_is_compatible(np, "qcom,qcs404-ethqos"))
> >               plat_dat->rx_clk_runs_in_lpi =3D 1;
> >
> > +     if (ethqos->serdes_phy) {
> > +             plat_dat->serdes_powerup =3D qcom_ethqos_serdes_powerup;
> > +             plat_dat->serdes_powerdown  =3D qcom_ethqos_serdes_powerd=
own;
> > +     }
> > +
> >       ret =3D stmmac_dvr_probe(dev, plat_dat, &stmmac_res);
> >       if (ret)
> >               goto out_config_dt;
> > --
> > 2.39.2
> >
>

