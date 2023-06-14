Return-Path: <netdev+bounces-10617-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 68D3472F64D
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 09:29:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C5C8C281321
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 07:29:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 079B520FA;
	Wed, 14 Jun 2023 07:29:02 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF4097F
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 07:29:01 +0000 (UTC)
Received: from mail-ua1-x935.google.com (mail-ua1-x935.google.com [IPv6:2607:f8b0:4864:20::935])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1874E109
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 00:29:00 -0700 (PDT)
Received: by mail-ua1-x935.google.com with SMTP id a1e0cc1a2514c-784f7f7deddso785352241.3
        for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 00:29:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20221208.gappssmtp.com; s=20221208; t=1686727739; x=1689319739;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5CRRGmdvDVbIEVTAFye64zUK3XOXIsv8ssMpfcABwlc=;
        b=Nf0/wLoZ38LsOopYbyo0ezI8LUQxgJTAFLkmLtgB++4Cqtqg95I3NTpGl9TXnYDDkY
         wQhNpaGtN+5iKwyxA/Sc3yKL4QWEEoRYv1tUv0/rZ1jPqpc9h2liqXzIFsH7Mk0PzJ2D
         8Dt9l/8xaaR/qGP/pxdKD42jgFfMPgpFD59+6wt7ykOg3xU4OOQOIVjAB7xnsarGe2xV
         S1QJ6zDt5NlO/4rFM4tBxEctZeiRwHUUbqReFG2sT+6YQbOdFDmCmmmOhAPgpwdAefLP
         SOVujR+y+Jx1AZxSFRB5PTZR3D5aXGCdsLrtMDajNAzKERlzusmNmNlP39Tdtw7fIp0C
         Jqdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686727739; x=1689319739;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5CRRGmdvDVbIEVTAFye64zUK3XOXIsv8ssMpfcABwlc=;
        b=cA3BBbyr4L0fuQPlsOssHsSbCxn2KutOR95OmxqjjslLVY41xHCLVA8KNn5E2DQ4ZB
         2Y30m/rVUscTtPnSWmOE2khi+XMJDK6vhEnACglZtb6GfIqVHengSeT2ZeZ+Jp6Ssax/
         r5L6M+1pOECLKQ6DT2Kl6rvSlimo8Zg+cxaKROgmigkolvZt2Y/n1Nvbi2zmv/saSj2M
         0efi5s3wQ1U0VrRhTXJ1JNjv5XVW5O45+XGlmabBLD3siMaT+tL2SBgafPyfzaXSOZmn
         MilleJ512EsPa/LkiURFRyLcEUEH44/mH6QSZOvrh+3oUwOcmIslUZWtsRrtdcNYqtYB
         udfA==
X-Gm-Message-State: AC+VfDxg2JsRGKeFDN7LWwMZJHAsmVRw+97q/y54feTTnHqoDICfyY47
	WnB8dHxXiVo/hs3/2HRqhITL7o3Y+xrBQsyBFghuvA==
X-Google-Smtp-Source: ACHHUZ5IOUv06tiZXv2OeC2IVs2JPsy0d5AliyorYz0hKnjFQVcPktvrX5L1vFgxFRciusLts8S8bofr4NgaMAhMxQo=
X-Received: by 2002:a05:6102:ca:b0:43d:54e9:35fb with SMTP id
 u10-20020a05610200ca00b0043d54e935fbmr7796848vsp.14.1686727739229; Wed, 14
 Jun 2023 00:28:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230612092355.87937-1-brgl@bgdev.pl> <20230612092355.87937-21-brgl@bgdev.pl>
 <712b2650-f0c1-088a-612c-ef6d6bcc1eb0@linaro.org>
In-Reply-To: <712b2650-f0c1-088a-612c-ef6d6bcc1eb0@linaro.org>
From: Bartosz Golaszewski <brgl@bgdev.pl>
Date: Wed, 14 Jun 2023 09:28:48 +0200
Message-ID: <CAMRc=McvVwk_HGU_cRzJ_qsCriHKfq61qL7bbe10evr-Sp6YSA@mail.gmail.com>
Subject: Re: [PATCH 20/26] dt-bindings: net: qcom,ethqos: add description for sa8775p
To: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
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

On Wed, Jun 14, 2023 at 9:25=E2=80=AFAM Krzysztof Kozlowski
<krzysztof.kozlowski@linaro.org> wrote:
>
> On 12/06/2023 11:23, Bartosz Golaszewski wrote:
> > From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
> >
> > Add the compatible for the MAC controller on sa8775p platforms. This MA=
C
> > works with a single interrupt so add minItems to the interrupts propert=
y.
> > The fourth clock's name is different here so change it. Enable relevant
> > PHY properties.
> >
>
> I think the patch should be squashed with previous. Adding compatible to
> common snps,dwmac binding does not make sense on its own. It makes sense
> with adding compatible here.
>
> > Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
> > ---
> >  .../devicetree/bindings/net/qcom,ethqos.yaml       | 14 +++++++++++++-
> >  1 file changed, 13 insertions(+), 1 deletion(-)
> >
> > diff --git a/Documentation/devicetree/bindings/net/qcom,ethqos.yaml b/D=
ocumentation/devicetree/bindings/net/qcom,ethqos.yaml
> > index 60a38044fb19..b20847c275ce 100644
> > --- a/Documentation/devicetree/bindings/net/qcom,ethqos.yaml
> > +++ b/Documentation/devicetree/bindings/net/qcom,ethqos.yaml
> > @@ -20,6 +20,7 @@ properties:
> >    compatible:
> >      enum:
> >        - qcom,qcs404-ethqos
> > +      - qcom,sa8775p-ethqos
> >        - qcom,sc8280xp-ethqos
> >        - qcom,sm8150-ethqos
> >
> > @@ -32,11 +33,13 @@ properties:
> >        - const: rgmii
> >
> >    interrupts:
> > +    minItems: 1
> >      items:
> >        - description: Combined signal for various interrupt events
> >        - description: The interrupt that occurs when Rx exits the LPI s=
tate
> >
> >    interrupt-names:
> > +    minItems: 1
> >      items:
> >        - const: macirq
> >        - const: eth_lpi
> > @@ -49,11 +52,20 @@ properties:
> >        - const: stmmaceth
> >        - const: pclk
> >        - const: ptp_ref
> > -      - const: rgmii
> > +      - enum:
> > +          - rgmii
> > +          - phyaux
> >
> >    iommus:
> >      maxItems: 1
> >
> > +  phys: true
> > +
> > +  phy-supply: true
>
> Isn't this property of the phy?
>

It is, and as discussed elsewhere with Andrew, I will move it to the
SerDes PHY driver.

Bart

> > +
> > +  phy-names:
> > +    const: serdes
>
> Keep the phy-names after phys.
>
>
> Best regards,
> Krzysztof
>

