Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69B736DB3F9
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 21:16:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230045AbjDGTQr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 15:16:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229989AbjDGTQq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 15:16:46 -0400
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D5629028
        for <netdev@vger.kernel.org>; Fri,  7 Apr 2023 12:16:41 -0700 (PDT)
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com [209.85.219.71])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 0CA853F232
        for <netdev@vger.kernel.org>; Fri,  7 Apr 2023 19:16:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1680895000;
        bh=6sYEIBV5kXMam6UqwH6oM6O2pVhy0udkwjOT9QqT4is=;
        h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
         To:Cc:Content-Type;
        b=fhiy6iZH0KuXk0Xa0W+FN2+H1k8UGgOWYfoVufbuHsEDU3fMB78MuKQ8ecB4PR9rj
         GLyU19+Z5TgVUsmW1s5Y2zCbwgWVprFMq9bb8URGO9MCPNGrA4uNgRXY/UQD8RZY/e
         ClMhg1dI0IBrm5IdXvSNkmknWQaj8EY8whEF6xWVT7KMWcJ5cCF+7ILivI8GcdVrwr
         SWIAXbQigDBdPwAPp6B3JtHUze71pUdYC4UHtvtEOFw6KCMaKzjfUOLjXkpsnKlhV3
         sBb8Q5BLSXDAcZkYd+jJSce+0n7By5Z0HRXYOVgVWW+ubVYSdoFTJpBk81F6UbQuIN
         +bbH1kMwWi7Jw==
Received: by mail-qv1-f71.google.com with SMTP id j4-20020a0cc344000000b005e94fb0d2b0so41975qvi.4
        for <netdev@vger.kernel.org>; Fri, 07 Apr 2023 12:16:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680894999;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6sYEIBV5kXMam6UqwH6oM6O2pVhy0udkwjOT9QqT4is=;
        b=Rqm9jcyuU8h1gQXqgYqKBrAueDtcWlM+mwQjVBCKRH6vjK+Gn+Rl1NY6ptpVT4G47+
         wm2cR8X+yTl7ie/nlFyne04T1M7pB6m9DX25xBiIBObM/MKXKkwc5ik6r0lVSndLHczc
         IU3/x3NXdHnYOc5EvVLB4mn9Dp2b/sou3HV+aJRBFVciJumufuIwscqQks+fkRq0/xnM
         Y6B7FQMUKoqzafwO8U/MpQHmvft+ZwqN45xuzjhwI1t5VaU6diuHzPOdp+RK5N6ZiwNy
         0hunLhfSMV/Fh3MPzA7pP6nM3/eERkyKHXPQ/XDirLVNti0MSImu3qjHx+e0aDyKCFga
         7/6g==
X-Gm-Message-State: AAQBX9fO/PHXaScOm2z5UcbzbZ8759tBlbtRY40V6bdLkUytzWGLKEQd
        2NhvMs7ctpgMRZ0VAi1onHF36+llpfjz3tRA0G16ttwkUj4Ip/yULQI8Kxk4ZvNdUpu3TW4ghtt
        wI7QXpRC6e9mgMRxgooOReS6bQhgerd8jAUevyGGPpg7RWqR0dg==
X-Received: by 2002:ac8:59cf:0:b0:3bf:e265:9bf with SMTP id f15-20020ac859cf000000b003bfe26509bfmr1125150qtf.5.1680894999090;
        Fri, 07 Apr 2023 12:16:39 -0700 (PDT)
X-Google-Smtp-Source: AKy350azJsoHtLW5iJVxAs7mqBBFmK9URhRqiPq9rW03ZcwqNgq7AmVUNj2Sw8I4d2ImHV3rL/4EjmZmsUuSs4OrUPc=
X-Received: by 2002:ac8:59cf:0:b0:3bf:e265:9bf with SMTP id
 f15-20020ac859cf000000b003bfe26509bfmr1125140qtf.5.1680894998772; Fri, 07 Apr
 2023 12:16:38 -0700 (PDT)
MIME-Version: 1.0
References: <20230407110356.8449-1-samin.guo@starfivetech.com> <20230407110356.8449-7-samin.guo@starfivetech.com>
In-Reply-To: <20230407110356.8449-7-samin.guo@starfivetech.com>
From:   Emil Renner Berthing <emil.renner.berthing@canonical.com>
Date:   Fri, 7 Apr 2023 21:16:22 +0200
Message-ID: <CAJM55Z9LF+p-jWQkPzK=0ovfrXN0b-E5Ed49sbC9xOdrH5SuKA@mail.gmail.com>
Subject: Re: [-net-next v11 6/6] net: stmmac: starfive-dmac: Add phy interface settings
To:     Samin Guo <samin.guo@starfivetech.com>
Cc:     linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Emil Renner Berthing <kernel@esmil.dk>,
        Pedro Moreira <pmmoreir@synopsys.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Conor Dooley <conor@kernel.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Peter Geis <pgwipeout@gmail.com>,
        Yanhong Wang <yanhong.wang@starfivetech.com>,
        Tommaso Merciai <tomm.merciai@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Samin,

If you're respinning this series anyway, please use "net: stmmac:
dwmac-starfive:" to match the filename.

On Fri, 7 Apr 2023 at 13:05, Samin Guo <samin.guo@starfivetech.com> wrote:
>
> dwmac supports multiple modess. When working under rmii and rgmii,
> you need to set different phy interfaces.
>
> According to the dwmac document, when working in rmii, it needs to be
> set to 0x4, and rgmii needs to be set to 0x1.
>
> The phy interface needs to be set in syscon, the format is as follows:
> starfive,syscon: <&syscon, offset, shift>
>
> Tested-by: Tommaso Merciai <tomm.merciai@gmail.com>
> Signed-off-by: Samin Guo <samin.guo@starfivetech.com>
> ---
>  .../ethernet/stmicro/stmmac/dwmac-starfive.c  | 48 +++++++++++++++++++
>  1 file changed, 48 insertions(+)
>
> diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-starfive.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-starfive.c
> index 4963d4008485..d6a1eddb51e8 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/dwmac-starfive.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-starfive.c
> @@ -13,6 +13,10 @@
>
>  #include "stmmac_platform.h"
>
> +#define STARFIVE_DWMAC_PHY_INFT_RGMII  0x1
> +#define STARFIVE_DWMAC_PHY_INFT_RMII   0x4
> +#define STARFIVE_DWMAC_PHY_INFT_FIELD  0x7U
> +
>  struct starfive_dwmac {
>         struct device *dev;
>         struct clk *clk_tx;
> @@ -46,6 +50,46 @@ static void starfive_dwmac_fix_mac_speed(void *priv, unsigned int speed)
>                 dev_err(dwmac->dev, "failed to set tx rate %lu\n", rate);
>  }
>
> +static int starfive_dwmac_set_mode(struct plat_stmmacenet_data *plat_dat)
> +{
> +       struct starfive_dwmac *dwmac = plat_dat->bsp_priv;
> +       struct regmap *regmap;
> +       unsigned int args[2];
> +       unsigned int mode;
> +       int err;
> +
> +       switch (plat_dat->interface) {
> +       case PHY_INTERFACE_MODE_RMII:
> +               mode = STARFIVE_DWMAC_PHY_INFT_RMII;
> +               break;
> +
> +       case PHY_INTERFACE_MODE_RGMII:
> +       case PHY_INTERFACE_MODE_RGMII_ID:
> +               mode = STARFIVE_DWMAC_PHY_INFT_RGMII;
> +               break;
> +
> +       default:
> +               dev_err(dwmac->dev, "unsupported interface %d\n",
> +                       plat_dat->interface);
> +               return -EINVAL;
> +       }
> +
> +       regmap = syscon_regmap_lookup_by_phandle_args(dwmac->dev->of_node,
> +                                                     "starfive,syscon",
> +                                                     2, args);
> +       if (IS_ERR(regmap))
> +               return dev_err_probe(dwmac->dev, PTR_ERR(regmap), "syscon regmap failed\n");

This message is a bit misleading. It's not actually that the regmap
failed, but getting/looking up the regmap failed.

> +       /* args[0]:offset  args[1]: shift */
> +       err = regmap_update_bits(regmap, args[0],
> +                                STARFIVE_DWMAC_PHY_INFT_FIELD << args[1],
> +                                mode << args[1]);
> +       if (err)
> +               return dev_err_probe(dwmac->dev, err, "error setting phy mode\n");
> +
> +       return 0;
> +}
> +
>  static int starfive_dwmac_probe(struct platform_device *pdev)
>  {
>         struct plat_stmmacenet_data *plat_dat;
> @@ -91,6 +135,10 @@ static int starfive_dwmac_probe(struct platform_device *pdev)
>         plat_dat->bsp_priv = dwmac;
>         plat_dat->dma_cfg->dche = true;
>
> +       err = starfive_dwmac_set_mode(plat_dat);
> +       if (err)
> +               return err;
> +
>         err = stmmac_dvr_probe(&pdev->dev, plat_dat, &stmmac_res);
>         if (err) {
>                 stmmac_remove_config_dt(pdev, plat_dat);
> --
> 2.17.1
>
>
> _______________________________________________
> linux-riscv mailing list
> linux-riscv@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-riscv
