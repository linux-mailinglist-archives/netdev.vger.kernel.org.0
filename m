Return-Path: <netdev+bounces-10314-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5954172DD36
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 11:02:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 119172810E4
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 09:02:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C280566F;
	Tue, 13 Jun 2023 09:02:35 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F4E8210D
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 09:02:35 +0000 (UTC)
Received: from mail-vk1-xa2d.google.com (mail-vk1-xa2d.google.com [IPv6:2607:f8b0:4864:20::a2d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43B1310FC
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 02:02:29 -0700 (PDT)
Received: by mail-vk1-xa2d.google.com with SMTP id 71dfb90a1353d-4640f75d784so3901881e0c.0
        for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 02:02:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20221208.gappssmtp.com; s=20221208; t=1686646948; x=1689238948;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IwBARohfXJIkEwsEMMo8aAWiqSvLtM3z2mjs8+NCfXY=;
        b=jT1sJaKn2m880uxpJ5L5ArF3lDcj7fgCTwwBWF6RsaYqX7FePADgzH9Dm/QqjhTK+P
         DkQPUPzU0LxNoxMzS7NHCF9LCuhzZVIoDE2wJgz/RxHAjB3FwuKMnKsaB222ZRFhLIUu
         Ciykd3mFBTL1P7WKtcBDpCQWvECEdUtdaRqHsmBNHOaGKKf7ckFx8fnKMuWlHPX1DAFg
         l3FrMgVgKr1RRtnR5aQwYXQut1mIFSubWfpgQHY41fB/fjLHyTaHIBqSPhElGMgX2CHS
         MbpMz3ivQQDAA3XTNm+c5m5Vn8oEylxUVqdnXb74u+FwpQL9ps8VOpJtL3Q4VSJOGT4a
         U12Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686646948; x=1689238948;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IwBARohfXJIkEwsEMMo8aAWiqSvLtM3z2mjs8+NCfXY=;
        b=JikI/DhbL1DMWbFN53Nrl4cycvcIsevH/HgB3c/uAJe/ZEvoL1pEAeY5CGyGlPEda8
         lzG4QHjppR4S5gDU8oz0coCjCflzzopEbBqGmgkMwrKyM4grDS+w0vAQll6KLQpJfLVW
         Q9Fg4gnkPwUi0pWEBH+ecazcTBaq5jYBkGQqwTAS9dspOoV1Zo4qr79X6y1qrAtFDv7n
         4AW6aEBMOSOQvhR2TcSQmUKGqqBjggoBt6rTZ8L/EnXymixUFy5NhPry3+W4RiF72m+Y
         KgVjTbaM5BC/EvNJuWuq+HOkWdy7wZckSbfIrg2wJV+YTXK0tTWFKaPtwKQCHot8W8/M
         lavg==
X-Gm-Message-State: AC+VfDw3i39mJvdg/62fLuN+IaxmE50Q8H42g78O+IIYUD3avfdr2Qn2
	PIQ1Dpy0ktPEAgsxcXJzkw/zQY+9ubUOAoWyrKUR/g==
X-Google-Smtp-Source: ACHHUZ6FvJtsXqFfHNPsLThg02wzd2x38KBvekdtX3wtsD/RmYrGV5BDkoIlbcyJuuaGSsJlgYZLslwU2yK0B/59L/I=
X-Received: by 2002:a05:6122:d94:b0:458:8ee3:cad9 with SMTP id
 bc20-20020a0561220d9400b004588ee3cad9mr5032322vkb.8.1686646948353; Tue, 13
 Jun 2023 02:02:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230612092355.87937-1-brgl@bgdev.pl> <20230612092355.87937-16-brgl@bgdev.pl>
 <20230612210632.agp4ybeseujblao2@halaney-x13s>
In-Reply-To: <20230612210632.agp4ybeseujblao2@halaney-x13s>
From: Bartosz Golaszewski <brgl@bgdev.pl>
Date: Tue, 13 Jun 2023 11:02:17 +0200
Message-ID: <CAMRc=Mc0hJXSazCX-5DQL7LEZ7WkhmZURxK9Kiyf_bR2d+_S3g@mail.gmail.com>
Subject: Re: [PATCH 15/26] net: stmmac: dwmac-qcom-ethqos: add support for the
 optional phy-supply
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
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, Jun 12, 2023 at 11:06=E2=80=AFPM Andrew Halaney <ahalaney@redhat.co=
m> wrote:
>
> On Mon, Jun 12, 2023 at 11:23:44AM +0200, Bartosz Golaszewski wrote:
> > From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
> >
> > On sa8775p-ride we need to enable the power supply for the external PHY=
.
>
> Is this for the external phy? It doesn't seem like it from the board
> schematic I have... the regulator never makes it out of the black box tha=
t
> is the SIP/SOM if I'm reading right.
>
> My (poor) understanding was this was for the serdes phy that's doing the
> conversion to SGMII before hitting the board... good chance I'm wrong
> though.
>

No, you're right. In which case I think the regulator calls should be
moved into the serdes driver instead as phy-supply is defined as the
supply of the external PHY in stmmac bindings.

Bart

> >
> > Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
> > ---
> >  drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c | 5 +++++
> >  1 file changed, 5 insertions(+)
> >
> > diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c b/=
drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c
> > index 2f6b9b419601..21f329d2f7eb 100644
> > --- a/drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c
> > +++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c
> > @@ -8,6 +8,7 @@
> >  #include <linux/phy.h>
> >  #include <linux/phy/phy.h>
> >  #include <linux/property.h>
> > +#include <linux/regulator/consumer.h>
> >
> >  #include "stmmac.h"
> >  #include "stmmac_platform.h"
> > @@ -692,6 +693,10 @@ static int qcom_ethqos_probe(struct platform_devic=
e *pdev)
> >       if (ret)
> >               goto out_config_dt;
> >
> > +     ret =3D devm_regulator_get_enable_optional(dev, "phy");
> > +     if (ret < 0 && ret !=3D -ENODEV)
> > +             goto out_config_dt;
> > +
> >       ethqos->serdes_phy =3D devm_phy_optional_get(dev, "serdes");
> >       if (IS_ERR(ethqos->serdes_phy)) {
> >               ret =3D PTR_ERR(ethqos->serdes_phy);
> > --
> > 2.39.2
> >
>

