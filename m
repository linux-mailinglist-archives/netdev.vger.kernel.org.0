Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDF554C9482
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 20:40:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237004AbiCATkm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 14:40:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235860AbiCATkl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 14:40:41 -0500
Received: from mail-oo1-xc2c.google.com (mail-oo1-xc2c.google.com [IPv6:2607:f8b0:4864:20::c2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14E8565784
        for <netdev@vger.kernel.org>; Tue,  1 Mar 2022 11:39:59 -0800 (PST)
Received: by mail-oo1-xc2c.google.com with SMTP id x6-20020a4a4106000000b003193022319cso23674836ooa.4
        for <netdev@vger.kernel.org>; Tue, 01 Mar 2022 11:39:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iOuftU1chGXMf3eFiOe8yxe1FZrdlpvfysxHIVyleiw=;
        b=pUUy8AdZ8gUokOkQvTGeZJyMqxOmaQzKxO9YGhxdsUHJvTxK5Ojjx/Hirtfd2GqLl0
         f08asCK12JIjOPr5syWGB6KJJXmGID+hA5D+rg3LEI2GCYKV0zvhf/xCMkGSYTSnhIVG
         2amm71llK/Lv88CvvpLul4OH5mtR/2AEUSrWfNaNCUKpTypgY2v+cNp9KYwfC8wbFUqv
         dNbNDQM5VIk3wgcTRbWb22HijiJ97P4ochH0khPfKxYTZAUC0QGGTXLHdRdYGHepc/Zg
         jcpo4J0BTsgFhNTVrVxiYCnfAdrh6M4uY9GjsD610VDUI2VWZqInlZ7T6UlCNQO2ggIS
         GHOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iOuftU1chGXMf3eFiOe8yxe1FZrdlpvfysxHIVyleiw=;
        b=XpjyL8dfqtoAOSLlfqcuOsQD/0PBrYLx3eJYVZgre/WjzX7aqWWkL2jkfOrNdC8gBE
         fSqq/goL2qnzJBQJce7lRcon+ZKmSSfl6WeyoQHg863UsrUh7TiPOCPgaGVvXoZ5x+2w
         /uec6DwbDL0/KYJA+bUhLy9QH0g/K0pAUd36g7wFXkGgw6g8hqeq/UcGqAoa+AGvU3Pq
         Nl6lizUANCY2pHDZCWyLC3pZo5Ri32xS2GDvQW+Bz0fXR+b2zcHi+4urOrF4B3bSmOXM
         VezFKc4SQk2OM79/Mb+uGHnQ6emwIVFzL5zxBik4UPtFfnQhslIgQeNtbBUyAPFAXp+o
         lg6g==
X-Gm-Message-State: AOAM532ScmbAaU899MfmwdwPqkcEp2B/axq+EVIiaSXnf47VGgaPxhZz
        rts0998pUA4WNqB6ia/aXIWh9lk9kjT/SEC9B2elAg==
X-Google-Smtp-Source: ABdhPJz/qPuzEZTR9ZljdsTiZ+cLXv57fWdEG6zvfn3JtKxljL5qaf0Sq8My8qOZA9m/u6u+6gFx7s/axlGnWK6sASg=
X-Received: by 2002:a05:6870:4508:b0:d7:162f:6682 with SMTP id
 e8-20020a056870450800b000d7162f6682mr8083444oao.126.1646163598081; Tue, 01
 Mar 2022 11:39:58 -0800 (PST)
MIME-Version: 1.0
References: <20220126221725.710167-1-bhupesh.sharma@linaro.org>
 <20220126221725.710167-8-bhupesh.sharma@linaro.org> <Yfh4cahRIdkY4KWg@builder.lan>
In-Reply-To: <Yfh4cahRIdkY4KWg@builder.lan>
From:   Bhupesh Sharma <bhupesh.sharma@linaro.org>
Date:   Wed, 2 Mar 2022 01:09:47 +0530
Message-ID: <CAH=2NtzQk+sdBgMv5ZKPXQ1vWFrp3TOR1w2Ed1WEw_5U=1i65Q@mail.gmail.com>
Subject: Re: [PATCH 7/8] clk: qcom: gcc-sm8150: use runtime PM for the clock controller
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
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

HI Bjorn,

Thanks for the review. Sorry for the late reply.

On Tue, 1 Feb 2022 at 05:31, Bjorn Andersson <bjorn.andersson@linaro.org> wrote:
>
> On Wed 26 Jan 16:17 CST 2022, Bhupesh Sharma wrote:
>
> > On sm8150 emac clk registers are powered up by the GDSC power
> > domain. Use runtime PM calls to make sure that required power domain is
> > powered on while we access clock controller's registers.
> >
>
> Typically the GCC registers need only "cx" enabled for us to much around
> with its registers and I don't see you add any references to additional
> resources, so can you please elaborate on how this affects the state of
> the system to enable you to operate the emac registers?

Indeed. On second thought and further tests, I think we don't need
this change. Only keeping EMAC GDSC in ON state (always) should fix
the issue (added via [PATCH 8/8] in this series).

So, I will drop this from v2.

Regards,
Bhupesh

> > Cc: Stephen Boyd <sboyd@kernel.org>
> > Signed-off-by: Bhupesh Sharma <bhupesh.sharma@linaro.org>
> > ---
> >  drivers/clk/qcom/gcc-sm8150.c | 27 +++++++++++++++++++++++++--
> >  1 file changed, 25 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/clk/qcom/gcc-sm8150.c b/drivers/clk/qcom/gcc-sm8150.c
> > index ada755ad55f7..2e71afed81fd 100644
> > --- a/drivers/clk/qcom/gcc-sm8150.c
> > +++ b/drivers/clk/qcom/gcc-sm8150.c
> > @@ -5,6 +5,7 @@
> >  #include <linux/bitops.h>
> >  #include <linux/err.h>
> >  #include <linux/platform_device.h>
> > +#include <linux/pm_runtime.h>
> >  #include <linux/module.h>
> >  #include <linux/of.h>
> >  #include <linux/of_device.h>
> > @@ -3792,19 +3793,41 @@ static const struct of_device_id gcc_sm8150_match_table[] = {
> >  };
> >  MODULE_DEVICE_TABLE(of, gcc_sm8150_match_table);
> >
> > +static void gcc_sm8150_pm_runtime_disable(void *data)
> > +{
> > +     pm_runtime_disable(data);
> > +}
> > +
> >  static int gcc_sm8150_probe(struct platform_device *pdev)
> >  {
> >       struct regmap *regmap;
> > +     int ret;
> > +
> > +     pm_runtime_enable(&pdev->dev);
> > +
> > +     ret = devm_add_action_or_reset(&pdev->dev, gcc_sm8150_pm_runtime_disable, &pdev->dev);
> > +     if (ret)
> > +             return ret;
> > +
> > +     ret = pm_runtime_resume_and_get(&pdev->dev);
> > +     if (ret)
> > +             return ret;
> >
> >       regmap = qcom_cc_map(pdev, &gcc_sm8150_desc);
> > -     if (IS_ERR(regmap))
> > +     if (IS_ERR(regmap)) {
> > +             pm_runtime_put(&pdev->dev);
> >               return PTR_ERR(regmap);
> > +     }
> >
> >       /* Disable the GPLL0 active input to NPU and GPU via MISC registers */
> >       regmap_update_bits(regmap, 0x4d110, 0x3, 0x3);
> >       regmap_update_bits(regmap, 0x71028, 0x3, 0x3);
> >
> > -     return qcom_cc_really_probe(pdev, &gcc_sm8150_desc, regmap);
> > +     ret = qcom_cc_really_probe(pdev, &gcc_sm8150_desc, regmap);
> > +
> > +     pm_runtime_put(&pdev->dev);
> > +
> > +     return ret;
> >  }
> >
> >  static struct platform_driver gcc_sm8150_driver = {
> > --
> > 2.34.1
> >
