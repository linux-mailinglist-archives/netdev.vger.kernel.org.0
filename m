Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A803F4C945B
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 20:33:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235896AbiCATeD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 14:34:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232547AbiCATeD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 14:34:03 -0500
Received: from mail-oo1-xc29.google.com (mail-oo1-xc29.google.com [IPv6:2607:f8b0:4864:20::c29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5482F506E3
        for <netdev@vger.kernel.org>; Tue,  1 Mar 2022 11:33:21 -0800 (PST)
Received: by mail-oo1-xc29.google.com with SMTP id w3-20020a4ac183000000b0031d806bbd7eso7959654oop.13
        for <netdev@vger.kernel.org>; Tue, 01 Mar 2022 11:33:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=s09G3d2GZOsH48PQv3S0tWQ6hmH5JZ2SdoKpay6rqJk=;
        b=yGFDknXS4dWn2kPPs0YZ8VbbVl2xu4WwKbWtmFZwNpzY+jQAwuvKvp4uLHvBrvVuEg
         AlKf+kfvQOC4Rzn8CwYOFhbXgSU3kysY+DRRHlzgLiVlSVF1sZ0JDrv5gChtiTZ4BqnG
         vvps1rxy/SoW6ruB6OiysBYvDt5ka0OFCU2v6sCCP4o+OumiZLJD+fCcFhBRWJk8B+0J
         F9RScnKJ7Bj2uKeTP5Xjxy8ND8HAlQGEaBFaRcxnWZHm+HSv3kzH4Hz+v9w+Yr6VkA5C
         CRbr5gxZJT95C1iyLZQN901rnnugXmgDVZ5wTJHOiGTcxE1Lzd8LLnkUtEpz9hPpTJ/E
         FUqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=s09G3d2GZOsH48PQv3S0tWQ6hmH5JZ2SdoKpay6rqJk=;
        b=SerTQ8fe6DE0MojX3/RyEIw8TC3g7/iBDDSOkJLY1xK3+Tw7JwsUiNRBcAolo6hMgi
         pYWcOf8s4E731/0o1NNDJudfEdrHWAGy+J2BEkvNZsd2KZiw3HErU4sAzbIF4tqRWO1P
         WfjcnXx59Uq9on6S+Vlm1mEFGEfaPem1EGV0ZAyEnqGCt+OsSfvOP0rOLqIIYvUWaxTQ
         VLk+8RWjm21f6hLxPE+ZNpykXNnOcY6/t7R49MnD6TJpa33zbpjx30AkwQN3p1xPsE8f
         uQLk8hCW6GIxrMHWnOyIXVzdrM7C+Jy1WUdPqTTuD+RcHihkalv0NN0HcXzvZyyd+5Zj
         TebA==
X-Gm-Message-State: AOAM533e8CXxLRcyTXVofn2qSAQ3BeW/OpmlH7Saph+9+k2AOqaO2iKd
        7mDdjo9s6QOCK/92sSS4q4pvTUOKTLcIrVLSyEpLHg==
X-Google-Smtp-Source: ABdhPJwmfh2OsG89bUC0V88Pv5V+OirryKxA4WtgkuShXLUTWTDEFELIRd0Zf5/QIovCeCns4PvvaTR8bV0kSRfkf3g=
X-Received: by 2002:a05:6870:4508:b0:d7:162f:6682 with SMTP id
 e8-20020a056870450800b000d7162f6682mr8063116oao.126.1646163200654; Tue, 01
 Mar 2022 11:33:20 -0800 (PST)
MIME-Version: 1.0
References: <20220126221725.710167-1-bhupesh.sharma@linaro.org>
 <20220126221725.710167-4-bhupesh.sharma@linaro.org> <Yfh6RSTegg2n5xuy@builder.lan>
In-Reply-To: <Yfh6RSTegg2n5xuy@builder.lan>
From:   Bhupesh Sharma <bhupesh.sharma@linaro.org>
Date:   Wed, 2 Mar 2022 01:03:09 +0530
Message-ID: <CAH=2Ntzk0NJOy-8GD-8E+X2e2Rx9xOn_8uwU_m6VpE85_yVKNw@mail.gmail.com>
Subject: Re: [PATCH 3/8] clk: qcom: gcc: Add PCIe, EMAC and UFS GDSCs for SM8150
To:     Bjorn Andersson <bjorn.andersson@linaro.org>
Cc:     linux-arm-msm@vger.kernel.org, bhupesh.linux@gmail.com,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        robh+dt@kernel.org, agross@kernel.org, sboyd@kernel.org,
        tdas@codeaurora.org, mturquette@baylibre.com,
        linux-clk@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Bjorn,

On Tue, 1 Feb 2022 at 05:39, Bjorn Andersson <bjorn.andersson@linaro.org> wrote:
>
> On Wed 26 Jan 16:17 CST 2022, Bhupesh Sharma wrote:
>
> > This adds the PCIe, EMAC and UFS GDSC structures for
> > SM8150. The GDSC will allow the respective system to be
> > brought out of reset.
> >
> > Cc: Stephen Boyd <sboyd@kernel.org>
> > Signed-off-by: Bhupesh Sharma <bhupesh.sharma@linaro.org>
> > ---
> >  drivers/clk/qcom/gcc-sm8150.c               | 74 +++++++++++++++++----
> >  include/dt-bindings/clock/qcom,gcc-sm8150.h |  9 ++-
> >  2 files changed, 69 insertions(+), 14 deletions(-)
> >
> > diff --git a/drivers/clk/qcom/gcc-sm8150.c b/drivers/clk/qcom/gcc-sm8150.c
> > index 245794485719..ada755ad55f7 100644
> > --- a/drivers/clk/qcom/gcc-sm8150.c
> > +++ b/drivers/clk/qcom/gcc-sm8150.c
> > @@ -3448,22 +3448,67 @@ static struct clk_branch gcc_video_xo_clk = {
> >       },
> >  };
> >
> > +static struct gdsc emac_gdsc = {
> > +     .gdscr = 0x6004,
> > +     .pd = {
> > +             .name = "emac_gdsc",
> > +     },
> > +     .pwrsts = PWRSTS_OFF_ON,
> > +     .flags = POLL_CFG_GDSCR,
> > +};
> > +
> > +static struct gdsc pcie_0_gdsc = {
> > +     .gdscr = 0x6b004,
> > +     .pd = {
> > +             .name = "pcie_0_gdsc",
> > +     },
> > +     .pwrsts = PWRSTS_OFF_ON,
> > +     .flags = POLL_CFG_GDSCR,
> > +};
> > +
> > +static struct gdsc pcie_1_gdsc = {
> > +     .gdscr = 0x8d004,
> > +     .pd = {
> > +             .name = "pcie_1_gdsc",
> > +     },
> > +     .pwrsts = PWRSTS_OFF_ON,
> > +     .flags = POLL_CFG_GDSCR,
> > +};
> > +
> > +static struct gdsc ufs_card_gdsc = {
> > +     .gdscr = 0x75004,
> > +     .pd = {
> > +             .name = "ufs_card_gdsc",
> > +     },
> > +     .pwrsts = PWRSTS_OFF_ON,
> > +     .flags = POLL_CFG_GDSCR,
> > +};
> > +
> > +static struct gdsc ufs_phy_gdsc = {
> > +     .gdscr = 0x77004,
> > +     .pd = {
> > +             .name = "ufs_phy_gdsc",
> > +     },
> > +     .pwrsts = PWRSTS_OFF_ON,
> > +     .flags = POLL_CFG_GDSCR,
> > +};
> > +
> >  static struct gdsc usb30_prim_gdsc = {
> > -             .gdscr = 0xf004,
> > -             .pd = {
> > -                     .name = "usb30_prim_gdsc",
> > -             },
> > -             .pwrsts = PWRSTS_OFF_ON,
> > -             .flags = POLL_CFG_GDSCR,
> > +     .gdscr = 0xf004,
> > +     .pd = {
> > +             .name = "usb30_prim_gdsc",
> > +     },
> > +     .pwrsts = PWRSTS_OFF_ON,
> > +     .flags = POLL_CFG_GDSCR,
> >  };
> >
> >  static struct gdsc usb30_sec_gdsc = {
> > -             .gdscr = 0x10004,
> > -             .pd = {
> > -                     .name = "usb30_sec_gdsc",
> > -             },
> > -             .pwrsts = PWRSTS_OFF_ON,
> > -             .flags = POLL_CFG_GDSCR,
> > +     .gdscr = 0x10004,
> > +     .pd = {
> > +             .name = "usb30_sec_gdsc",
> > +     },
> > +     .pwrsts = PWRSTS_OFF_ON,
> > +     .flags = POLL_CFG_GDSCR,
> >  };
> >
> >  static struct clk_regmap *gcc_sm8150_clocks[] = {
> > @@ -3714,6 +3759,11 @@ static const struct qcom_reset_map gcc_sm8150_resets[] = {
> >  };
> >
> >  static struct gdsc *gcc_sm8150_gdscs[] = {
> > +     [EMAC_GDSC] = &emac_gdsc,
> > +     [PCIE_0_GDSC] = &pcie_0_gdsc,
> > +     [PCIE_1_GDSC] = &pcie_1_gdsc,
> > +     [UFS_CARD_GDSC] = &ufs_card_gdsc,
> > +     [UFS_PHY_GDSC] = &ufs_phy_gdsc,
> >       [USB30_PRIM_GDSC] = &usb30_prim_gdsc,
> >       [USB30_SEC_GDSC] = &usb30_sec_gdsc,
> >  };
> > diff --git a/include/dt-bindings/clock/qcom,gcc-sm8150.h b/include/dt-bindings/clock/qcom,gcc-sm8150.h
> > index 3e1a91876610..35d80ae411a0 100644
> > --- a/include/dt-bindings/clock/qcom,gcc-sm8150.h
> > +++ b/include/dt-bindings/clock/qcom,gcc-sm8150.h
> > @@ -241,7 +241,12 @@
> >  #define GCC_USB_PHY_CFG_AHB2PHY_BCR                          28
> >
> >  /* GCC GDSCRs */
> > -#define USB30_PRIM_GDSC                     4
> > -#define USB30_SEC_GDSC                                               5
>
> These constants goes into .dtb files as numbers (4 and 5), changing them
> will cause annoying-to-debug bugs in the transition while people still
> are testing a new kernel with last weeks dtb.
>
> So please add the new constants without affecting these numbers.
>
> Rest looks good.

Ack. I will fix this in v2.

Regards,
Bhupesh

> > +#define EMAC_GDSC                                            0
> > +#define PCIE_0_GDSC                                          1
> > +#define      PCIE_1_GDSC                                             2
> > +#define UFS_CARD_GDSC                                                3
> > +#define UFS_PHY_GDSC                                         4
> > +#define USB30_PRIM_GDSC                                              5
> > +#define USB30_SEC_GDSC                                               6
> >
> >  #endif
> > --
> > 2.34.1
> >
