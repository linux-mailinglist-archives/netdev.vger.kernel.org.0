Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6E734C94AC
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 20:44:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236255AbiCATpS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 14:45:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231577AbiCATpR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 14:45:17 -0500
Received: from mail-oo1-xc33.google.com (mail-oo1-xc33.google.com [IPv6:2607:f8b0:4864:20::c33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F09AE580CA
        for <netdev@vger.kernel.org>; Tue,  1 Mar 2022 11:44:35 -0800 (PST)
Received: by mail-oo1-xc33.google.com with SMTP id k13-20020a4a948d000000b003172f2f6bdfso23677317ooi.1
        for <netdev@vger.kernel.org>; Tue, 01 Mar 2022 11:44:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1uzo2Ip3l9Z2WQS9kRS2aI5MRe3AqAqtHQ4fqs0dZqM=;
        b=j+4eI4mL8Io4pIpAK1lB2FDt4unR4+dJaAUcY/Ewwp0MUPjXgCmMEWHzcv9mFI3hJV
         vsBIhtV0uj3na59CjWp0U7657THTQVG6F/IOtlGEPGWk7V4axGAm0IHZGINRt4SsHJl2
         9R3/Z2mavRX91oq19CYyBKM/yv2xNxpxlJCKKYrqbLchAcgcgcfWVaQPAMsjhN2ZP3tT
         zDJsd4yJPLcClsEOnzBHhUSS/XiDkZRztOdmAdNZA2Ag+40kkSMVfMwriqEj745RH90V
         9x3oA3nXFSRlaAkrDAEnhUQwYGXPVylQ9gzhT8be9YcvvUxEpxowei3QfMWFQT7MJRBe
         qHkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1uzo2Ip3l9Z2WQS9kRS2aI5MRe3AqAqtHQ4fqs0dZqM=;
        b=YyNGWRDXC0HY9udn2QfRo0ztRRgvikkZoTUKZebB8RkuAf09bDoM8zdze/7drBX8p8
         tur9dfcnUygHW4OLiwFKCTyiweBw3Hx9mUbPlGGpcFlESmjjQyaddBMe0Xc5zAL80XN8
         9ZHWK558UscyW/r9zG87nINr5ENYwFzHVjYjQgWVOBqz0O0Z0by8VAE4642WVdS9iFSR
         4S5o5vCJ32/5TS3t0h0X1zhqUuZKTFN/3GDPmGgJxmJokcu+1FWdmFF5+k3W1lh5DklI
         ZAOEi/GDi6x/ouTub3yalpvTLINHOAgVt6mQValDxvEi8SMS5JkND13Ml1HYzsQRdKzb
         L4SQ==
X-Gm-Message-State: AOAM5315jTbdeupBrnWby3ZlGrbHBxq7aBrwmo69z90rvCnHPkmCxgcT
        dDgrZIrHPyPqgfWmu2nZlOegZH+thN7DdS8FeQwgcA==
X-Google-Smtp-Source: ABdhPJyEUajenDJbWbNCZz42qYV3Igx3HUl6FSLFUPlIyhD+EGMYK6EzbuBvtIdRnbAST4QpaJIH5PqobnizZtwZDXI=
X-Received: by 2002:a05:6870:434f:b0:bf:9f2a:26f0 with SMTP id
 x15-20020a056870434f00b000bf9f2a26f0mr5166687oah.40.1646163874720; Tue, 01
 Mar 2022 11:44:34 -0800 (PST)
MIME-Version: 1.0
References: <20220126221725.710167-1-bhupesh.sharma@linaro.org>
 <20220126221725.710167-9-bhupesh.sharma@linaro.org> <Yfh5Pjpw693ZMteC@builder.lan>
In-Reply-To: <Yfh5Pjpw693ZMteC@builder.lan>
From:   Bhupesh Sharma <bhupesh.sharma@linaro.org>
Date:   Wed, 2 Mar 2022 01:14:23 +0530
Message-ID: <CAH=2Ntw7niiKSS-Nw6QKO+3JCGwvqv71ycZpCOb5fRjYh-dPmQ@mail.gmail.com>
Subject: Re: [PATCH 8/8] clk: qcom: gcc-sm8150: Use PWRSTS_ON (only) as a
 workaround for emac gdsc
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

On Tue, 1 Feb 2022 at 05:35, Bjorn Andersson <bjorn.andersson@linaro.org> wrote:
>
> On Wed 26 Jan 16:17 CST 2022, Bhupesh Sharma wrote:
>
> > EMAC GDSC currently has issues (seen on SA8155p-ADP) when its
> > turn'ed ON, once its already in OFF state. So, use PWRSTS_ON
> > state (only) as a workaround for now.
> >
> > Cc: Bjorn Andersson <bjorn.andersson@linaro.org>
> > Cc: Stephen Boyd <sboyd@kernel.org>
> > Signed-off-by: Bhupesh Sharma <bhupesh.sharma@linaro.org>
> > ---
> >  drivers/clk/qcom/gcc-sm8150.c | 6 +++++-
> >  1 file changed, 5 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/clk/qcom/gcc-sm8150.c b/drivers/clk/qcom/gcc-sm8150.c
> > index 2e71afed81fd..fd7e931d3c09 100644
> > --- a/drivers/clk/qcom/gcc-sm8150.c
> > +++ b/drivers/clk/qcom/gcc-sm8150.c
> > @@ -3449,12 +3449,16 @@ static struct clk_branch gcc_video_xo_clk = {
> >       },
> >  };
> >
> > +/* To Do: EMAC GDSC currently has issues when its turn'ed ON, once
> > + * its already in OFF state. So use PWRSTS_ON state (only) as a
> > + * workaround for now.
>
> So you're not able to turn on the GDSC after turning it off?

Indeed. On the SM8150 platform (SA8155p ADP board), what I am
observing is that the
ethernet interface CLKs (RGMII clock etc) cannot be turned on once the
EMAC GDSC is moved
from an OFF to ON state. This is because the EMAC GDSC cannot be
properly turned ON once it is
in the OFF state.

So, basically if we leave the EMAC GDSC on from boot (which is default
bootloader setting), the eth interface
can always come up fine and it can also be used for traffic tx/rx.

> > + */
> >  static struct gdsc emac_gdsc = {
> >       .gdscr = 0x6004,
> >       .pd = {
> >               .name = "emac_gdsc",
> >       },
> > -     .pwrsts = PWRSTS_OFF_ON,
> > +     .pwrsts = PWRSTS_ON,
>
> Doesn't this tell the gdsc driver that the only state supported is "on"
> and hence prohibit you from turning it on in the first place?

That's correct indeed.  Without this hack in place, the EMAC GDSC is not able to
switch from an OFF to ON state, so when the 'eth' interface is turned
up it fails (as RGMII CLK is unavailable):

qcom-ethqos 20000.ethernet eth0: PHY [stmmac-0:07] driver [Micrel
KSZ9031 Gigabit PHY] (irq=150)
<..snip..>
qcom-ethqos 20000.ethernet: Failed to reset the dma
qcom-ethqos 20000.ethernet eth0: stmmac_hw_setup: DMA engine
initialization failed
qcom-ethqos 20000.ethernet eth0: stmmac_open: Hw setup failed

> >       .flags = POLL_CFG_GDSCR,
>
> You could add ALWAYS_ON to .flags, but we need a better description of
> the actual problem that you're working around.

I agree. Let me add the above 'stmmac dma reset' issue while
describing the workaround in the next version of the patch.

Regards,
Bhupesh

> >  };
> >
> > --
> > 2.34.1
> >
