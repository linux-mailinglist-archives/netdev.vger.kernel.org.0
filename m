Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FC576CF1A7
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 20:05:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229968AbjC2SFB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 14:05:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229909AbjC2SE7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 14:04:59 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 657C05264
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 11:04:54 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id r29so16618873wra.13
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 11:04:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680113093;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=KtcfMeR6JsK/ohHsKigxpHUI7/Wye0XruGbtWcUv7Oc=;
        b=K/7LvcqNZLihJNNDYkxGRe7xK0ljMFDUuttYBiPZCAN75UiCaONgiHQxYkVhWMY2kg
         lKCHhLrKkMcCBNU+1CL93NvVZapruIeA6ioQG+fV3hls6jGfzavHSmCupF6PIHNTqTVv
         vTz+hYdlyakKrsi8T9EFgqnxO7DF4opGJNE0zhFVnFg+HJVir3qTBq0eaP3QZoha6kY5
         52nNtvxgzg6uaP7eeE4duX5jEOZ1iqxuRABd72MVlXbzpkFn/7cWXljP+aoi5pHDe4Yd
         hAuU0QPlo2byQJ06BRZWVmGod0KwyvPOVmx+yrOhVwpvShlxVEd953vHBpZgo3H9cV5U
         mNaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680113093;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KtcfMeR6JsK/ohHsKigxpHUI7/Wye0XruGbtWcUv7Oc=;
        b=THPD73IRoM3GhDhqCOLLHEuCOyoHflljx+Okyaea/oW/VJgyAGSyG0YX2f04nP1soZ
         /6ed6Ztm5FhnqDTTqoX37V7OCNIw+LuBt8fi/UtyiR/q/p4J7Tt7FGJHHSNOntxqbIuv
         3tHTlk9nYOX99fk5rCV3tI3XX8a9BPJ+69c1BVThysnGAMrTH+cqbX4RJRsvhKPCD2Kx
         rwXWcOaOdoIzLPHa0hmayxW1bHF0xKwCwP8+k/F8hTC6VBMqzeqzdn/5xKs+uet0F4Ld
         wTUm+XAjadBGRCkOgDisyfSSIyuoQsdRzGHlJ/Dn6PwNdfWaesjNUx/PWauhdQ8rGYVl
         WZ1w==
X-Gm-Message-State: AAQBX9dLoHhzEGRIY9Qaze7x+Xjs+HlL4n0jIUlZckfub8US6qUuthAl
        JYlbzJo7LntId3/N0gdWBYf7/+SQU8G99CM1HG5x3g==
X-Google-Smtp-Source: AKy350apuid2c1v0d8ghzoDWeoKrqmDRDu9lZcUXGbMQYG7R5i/8vpaOWW8MowDPvQ1geBytZHu1YfNNKktLGYH5NMo=
X-Received: by 2002:adf:f14b:0:b0:2e4:abb1:3e87 with SMTP id
 y11-20020adff14b000000b002e4abb13e87mr42744wro.2.1680113092851; Wed, 29 Mar
 2023 11:04:52 -0700 (PDT)
MIME-Version: 1.0
References: <20230323062451.2925996-1-danishanwar@ti.com> <20230323062451.2925996-6-danishanwar@ti.com>
 <20230327210429.GD3158115@p14s> <08cdd2b7-5152-8dec-aea2-ce286f8b97fb@ti.com>
In-Reply-To: <08cdd2b7-5152-8dec-aea2-ce286f8b97fb@ti.com>
From:   Mathieu Poirier <mathieu.poirier@linaro.org>
Date:   Wed, 29 Mar 2023 12:04:42 -0600
Message-ID: <CANLsYkwO62JH0TgOLwt08n8WdM_KsNYBCvUBOEsaxikJRfut0A@mail.gmail.com>
Subject: Re: [EXTERNAL] Re: [PATCH v5 5/5] soc: ti: pruss: Add helper
 functions to get/set PRUSS_CFG_GPMUX
To:     Md Danish Anwar <a0501179@ti.com>
Cc:     MD Danish Anwar <danishanwar@ti.com>,
        "Andrew F. Davis" <afd@ti.com>, Suman Anna <s-anna@ti.com>,
        Roger Quadros <rogerq@kernel.org>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Tero Kristo <kristo@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Santosh Shilimkar <ssantosh@kernel.org>,
        Nishanth Menon <nm@ti.com>, linux-remoteproc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, srk@ti.com, devicetree@vger.kernel.org,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 28 Mar 2023 at 05:28, Md Danish Anwar <a0501179@ti.com> wrote:
>
>
>
> On 28/03/23 02:34, Mathieu Poirier wrote:
> > On Thu, Mar 23, 2023 at 11:54:51AM +0530, MD Danish Anwar wrote:
> >> From: Tero Kristo <t-kristo@ti.com>
> >>
> >> Add two new helper functions pruss_cfg_get_gpmux() & pruss_cfg_set_gpmux()
> >> to get and set the GP MUX mode for programming the PRUSS internal wrapper
> >> mux functionality as needed by usecases.
> >>
> >> Co-developed-by: Suman Anna <s-anna@ti.com>
> >> Signed-off-by: Suman Anna <s-anna@ti.com>
> >> Signed-off-by: Tero Kristo <t-kristo@ti.com>
> >> Co-developed-by: Grzegorz Jaszczyk <grzegorz.jaszczyk@linaro.org>
> >> Signed-off-by: Grzegorz Jaszczyk <grzegorz.jaszczyk@linaro.org>
> >> Signed-off-by: Puranjay Mohan <p-mohan@ti.com>
> >> Signed-off-by: MD Danish Anwar <danishanwar@ti.com>
> >> Reviewed-by: Roger Quadros <rogerq@kernel.org>
> >> ---
> >>  drivers/soc/ti/pruss.c           | 44 ++++++++++++++++++++++++++++++++
> >>  include/linux/remoteproc/pruss.h | 30 ++++++++++++++++++++++
> >>  2 files changed, 74 insertions(+)
> >>
> >> diff --git a/drivers/soc/ti/pruss.c b/drivers/soc/ti/pruss.c
> >> index ac415442e85b..3aa3c38c6c79 100644
> >> --- a/drivers/soc/ti/pruss.c
> >> +++ b/drivers/soc/ti/pruss.c
> >> @@ -239,6 +239,50 @@ int pruss_cfg_xfr_enable(struct pruss *pruss, enum pru_type pru_type,
> >>  }
> >>  EXPORT_SYMBOL_GPL(pruss_cfg_xfr_enable);
> >>
> >> +/**
> >> + * pruss_cfg_get_gpmux() - get the current GPMUX value for a PRU device
> >> + * @pruss: pruss instance
> >> + * @pru_id: PRU identifier (0-1)
> >> + * @mux: pointer to store the current mux value into
> >> + *
> >> + * Return: 0 on success, or an error code otherwise
> >> + */
> >> +int pruss_cfg_get_gpmux(struct pruss *pruss, enum pruss_pru_id pru_id, u8 *mux)
> >> +{
> >> +    int ret = 0;
> >> +    u32 val;
> >> +
> >> +    if (pru_id < 0 || pru_id >= PRUSS_NUM_PRUS)
> >> +            return -EINVAL;
> >> +
> >> +    ret = pruss_cfg_read(pruss, PRUSS_CFG_GPCFG(pru_id), &val);
> >> +    if (!ret)
> >> +            *mux = (u8)((val & PRUSS_GPCFG_PRU_MUX_SEL_MASK) >>
> >> +                        PRUSS_GPCFG_PRU_MUX_SEL_SHIFT);
> >
> > What happens if @mux is NULL?
>
> @mux being null may result in some error here. I will add NULL check for mux
> before storing the value in mux.
>

It will result in a kernel panic.

> I will modify the above if condition to have NULL check for mux as well.
> The if condition will look like below.
>
>         if (pru_id < 0 || pru_id >= PRUSS_NUM_PRUS || !mux)
>                 return -EINVAL;
>

That will be fine.

> Please let me know if this looks OK.
>
> >
> > Thanks,
> > Mathieu
> >
> >
> >> +    return ret;
> >> +}
> >> +EXPORT_SYMBOL_GPL(pruss_cfg_get_gpmux);
> >> +
> >> +/**
> >> + * pruss_cfg_set_gpmux() - set the GPMUX value for a PRU device
> >> + * @pruss: pruss instance
> >> + * @pru_id: PRU identifier (0-1)
> >> + * @mux: new mux value for PRU
> >> + *
> >> + * Return: 0 on success, or an error code otherwise
> >> + */
> >> +int pruss_cfg_set_gpmux(struct pruss *pruss, enum pruss_pru_id pru_id, u8 mux)
> >> +{
> >> +    if (mux >= PRUSS_GP_MUX_SEL_MAX ||
> >> +        pru_id < 0 || pru_id >= PRUSS_NUM_PRUS)
> >> +            return -EINVAL;
> >> +
> >> +    return pruss_cfg_update(pruss, PRUSS_CFG_GPCFG(pru_id),
> >> +                            PRUSS_GPCFG_PRU_MUX_SEL_MASK,
> >> +                            (u32)mux << PRUSS_GPCFG_PRU_MUX_SEL_SHIFT);
> >> +}
> >> +EXPORT_SYMBOL_GPL(pruss_cfg_set_gpmux);
> >> +
> >>  static void pruss_of_free_clk_provider(void *data)
> >>  {
> >>      struct device_node *clk_mux_np = data;
> >> diff --git a/include/linux/remoteproc/pruss.h b/include/linux/remoteproc/pruss.h
> >> index bb001f712980..42f1586c62ac 100644
> >> --- a/include/linux/remoteproc/pruss.h
> >> +++ b/include/linux/remoteproc/pruss.h
> >> @@ -16,6 +16,24 @@
> >>
> >>  #define PRU_RPROC_DRVNAME "pru-rproc"
> >>
> >> +/*
> >> + * enum pruss_gp_mux_sel - PRUSS GPI/O Mux modes for the
> >> + * PRUSS_GPCFG0/1 registers
> >> + *
> >> + * NOTE: The below defines are the most common values, but there
> >> + * are some exceptions like on 66AK2G, where the RESERVED and MII2
> >> + * values are interchanged. Also, this bit-field does not exist on
> >> + * AM335x SoCs
> >> + */
> >> +enum pruss_gp_mux_sel {
> >> +    PRUSS_GP_MUX_SEL_GP = 0,
> >> +    PRUSS_GP_MUX_SEL_ENDAT,
> >> +    PRUSS_GP_MUX_SEL_RESERVED,
> >> +    PRUSS_GP_MUX_SEL_SD,
> >> +    PRUSS_GP_MUX_SEL_MII2,
> >> +    PRUSS_GP_MUX_SEL_MAX,
> >> +};
> >> +
> >>  /*
> >>   * enum pruss_gpi_mode - PRUSS GPI configuration modes, used
> >>   *                   to program the PRUSS_GPCFG0/1 registers
> >> @@ -110,6 +128,8 @@ int pruss_cfg_gpimode(struct pruss *pruss, enum pruss_pru_id pru_id,
> >>  int pruss_cfg_miirt_enable(struct pruss *pruss, bool enable);
> >>  int pruss_cfg_xfr_enable(struct pruss *pruss, enum pru_type pru_type,
> >>                       bool enable);
> >> +int pruss_cfg_get_gpmux(struct pruss *pruss, enum pruss_pru_id pru_id, u8 *mux);
> >> +int pruss_cfg_set_gpmux(struct pruss *pruss, enum pruss_pru_id pru_id, u8 mux);
> >>
> >>  #else
> >>
> >> @@ -152,6 +172,16 @@ static inline int pruss_cfg_xfr_enable(struct pruss *pruss,
> >>      return ERR_PTR(-EOPNOTSUPP);
> >>  }
> >>
> >> +static inline int pruss_cfg_get_gpmux(struct pruss *pruss, enum pruss_pru_id pru_id, u8 *mux)
> >> +{
> >> +    return ERR_PTR(-EOPNOTSUPP);
> >> +}
> >> +
> >> +static inline int pruss_cfg_set_gpmux(struct pruss *pruss, enum pruss_pru_id pru_id, u8 mux)
> >> +{
> >> +    return ERR_PTR(-EOPNOTSUPP);
> >> +}
> >> +
> >>  #endif /* CONFIG_TI_PRUSS */
> >>
> >>  #if IS_ENABLED(CONFIG_PRU_REMOTEPROC)
> >> --
> >> 2.25.1
> >>
>
> --
> Thanks and Regards,
> Danish.
