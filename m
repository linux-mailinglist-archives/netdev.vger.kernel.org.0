Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 869E75481D6
	for <lists+netdev@lfdr.de>; Mon, 13 Jun 2022 10:28:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240010AbiFMISq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jun 2022 04:18:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239994AbiFMISl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jun 2022 04:18:41 -0400
Received: from mail-oa1-x33.google.com (mail-oa1-x33.google.com [IPv6:2001:4860:4864:20::33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F8E71A059
        for <netdev@vger.kernel.org>; Mon, 13 Jun 2022 01:18:37 -0700 (PDT)
Received: by mail-oa1-x33.google.com with SMTP id 586e51a60fabf-1011df6971aso5034304fac.1
        for <netdev@vger.kernel.org>; Mon, 13 Jun 2022 01:18:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=r9lylKfLW5KqwRE2TZyd6KzB07M4dsbMFdDT/CPoKLU=;
        b=LuXMelbuenKMJnJjVTFTnVVXPKTbA8iy7WOWb1v336Y/N3yvXd4tdKHzn2r0sgNiTN
         CGmNsmvgiJ26pupolIrmlEgRcnND3C3ws4MrjnUjRVVg7I1orVgoNDZkjjai6jFZKoPj
         55nlZbeCkMs6QHZ3QuHJxEsIwhJeBT7u+FyO1hk5Jei6Z/Yw/gxzWm5dhkM8gnviyc6R
         dbfeeuk3ZKHVVFyW7vw0oas+PpCYsSkYIqrtsZV8idRevFDq5TK93V5g5hZwq6PQ7rss
         Zjf6I2Zp7sZUUoR1+x/XR9Tr4I+Jk3LGKkf8YEY2xmhuLTLpW61HEKLg2OErtfG/ych7
         xDRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=r9lylKfLW5KqwRE2TZyd6KzB07M4dsbMFdDT/CPoKLU=;
        b=equbwKCdvIG+cG3AR6pP3jiqiB37G000BZxuudjNBRy31qAsrHNKcU/SqqZ44yfk4e
         BQCxAHZIXj8OgcET4TUO5BCG2S8x+WR3bN/av0rHVwHAYZBIHvV9c4DDBVSA4gzAXmSu
         LQfAU+4odpoQoqVOobZeE5amhHksfV0XPioiNxQFeq8GBnz26WZkkszgWRdpM22nA4CC
         U0nMRuQ6VJgwuTx0h8nul2M23aDD1O8TVzhvB0yQBEHXtcyoneURUvKvRCl0PbnbWHTa
         fOKjy/2GhjVD3KBY2LUL+zECm8IIscYITVe1ts3aE5OonYyF2Ze38NgMi/KMk7gggnVe
         Ofaw==
X-Gm-Message-State: AOAM5321SjsDVxWnHbQ5VzbXCkZEjQvN2s+p3a18+84nWa+368um8wbp
        2D8Y+GwqDs8OXACZLcee+39LBdd+7I4lLJNazZrFUw==
X-Google-Smtp-Source: ABdhPJzeK2WsGmCofjO54ShNyBFri3x+iX1vc631M7eLZXpX8TwF/4sDoxrfDuseTKTscPYSN7G6ndFiRpmmYKQXiMc=
X-Received: by 2002:a05:6870:3116:b0:fe:1586:5922 with SMTP id
 v22-20020a056870311600b000fe15865922mr6734781oaa.285.1655108316343; Mon, 13
 Jun 2022 01:18:36 -0700 (PDT)
MIME-Version: 1.0
References: <20220613034202.3777248-1-andy.chiu@sifive.com> <20220613034202.3777248-2-andy.chiu@sifive.com>
In-Reply-To: <20220613034202.3777248-2-andy.chiu@sifive.com>
From:   Andy Chiu <andy.chiu@sifive.com>
Date:   Mon, 13 Jun 2022 16:18:25 +0800
Message-ID: <CABgGipVn+=SqHGJzyRfBwFYVa+KgVWUCSD3sDKpqsZ6FPppNfQ@mail.gmail.com>
Subject: Re: [PATCH net-next 1/2] net: axienet: make the 64b addresable DMA
 depends on 64b archectures
To:     radhey.shyam.pandey@xilinx.com, davem@davemloft.net,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, pabeni@redhat.com,
        michal.simek@xilinx.com, netdev@vger.kernel.org
Cc:     linux-arm-kernel@lists.infradead.org, Max Hsu <max.hsu@sifive.com>,
        Greentime Hu <greentime.hu@sifive.com>
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

Reviewed-by: Greentime Hu <greentime.hu@sifive.com>

On Mon, Jun 13, 2022 at 11:45 AM Andy Chiu <andy.chiu@sifive.com> wrote:
>
> Currently it is not safe to config the IP as 64-bit addressable on 32-bit
> archectures, which cannot perform a double-word store on its descriptor
> pointers. The pointer is 64-bit wide if the IP is configured as 64-bit,
> and the device would process the partially updated pointer on some
> states if the pointer was updated via two store-words. To prevent such
> condition, we force a probe fail if we discover that the IP has 64-bit
> capability but it is not running on a 64-Bit kernel.
>
> This is a series of patch (1/2). The next patch must be applied in order
> to make 64b DMA safe on 64b archectures.
>
> Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
> Reported-by: Max Hsu <max.hsu@sifive.com>
> ---
>  drivers/net/ethernet/xilinx/xilinx_axienet.h  | 36 +++++++++++++++++++
>  .../net/ethernet/xilinx/xilinx_axienet_main.c | 28 +++------------
>  2 files changed, 40 insertions(+), 24 deletions(-)
>
> diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet.h b/drivers/net/ethernet/xilinx/xilinx_axienet.h
> index 4225efbeda3d..6c95676ba172 100644
> --- a/drivers/net/ethernet/xilinx/xilinx_axienet.h
> +++ b/drivers/net/ethernet/xilinx/xilinx_axienet.h
> @@ -547,6 +547,42 @@ static inline void axienet_iow(struct axienet_local *lp, off_t offset,
>         iowrite32(value, lp->regs + offset);
>  }
>
> +/**
> + * axienet_dma_out32 - Memory mapped Axi DMA register write.
> + * @lp:                Pointer to axienet local structure
> + * @reg:       Address offset from the base address of the Axi DMA core
> + * @value:     Value to be written into the Axi DMA register
> + *
> + * This function writes the desired value into the corresponding Axi DMA
> + * register.
> + */
> +
> +static inline void axienet_dma_out32(struct axienet_local *lp,
> +                                    off_t reg, u32 value)
> +{
> +       iowrite32(value, lp->dma_regs + reg);
> +}
> +
> +#ifdef CONFIG_64BIT
> +static void axienet_dma_out_addr(struct axienet_local *lp, off_t reg,
> +                                dma_addr_t addr)
> +{
> +       axienet_dma_out32(lp, reg, lower_32_bits(addr));
> +
> +       if (lp->features & XAE_FEATURE_DMA_64BIT)
> +               axienet_dma_out32(lp, reg + 4, upper_32_bits(addr));
> +}
> +
> +#else /* CONFIG_64BIT */
> +
> +static void axienet_dma_out_addr(struct axienet_local *lp, off_t reg,
> +                                dma_addr_t addr)
> +{
> +       axienet_dma_out32(lp, reg, lower_32_bits(addr));
> +}
> +
> +#endif /* CONFIG_64BIT */
> +
>  /* Function prototypes visible in xilinx_axienet_mdio.c for other files */
>  int axienet_mdio_enable(struct axienet_local *lp);
>  void axienet_mdio_disable(struct axienet_local *lp);
> diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
> index 93c9f305bba4..fa7bcd2c1892 100644
> --- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
> +++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
> @@ -133,30 +133,6 @@ static inline u32 axienet_dma_in32(struct axienet_local *lp, off_t reg)
>         return ioread32(lp->dma_regs + reg);
>  }
>
> -/**
> - * axienet_dma_out32 - Memory mapped Axi DMA register write.
> - * @lp:                Pointer to axienet local structure
> - * @reg:       Address offset from the base address of the Axi DMA core
> - * @value:     Value to be written into the Axi DMA register
> - *
> - * This function writes the desired value into the corresponding Axi DMA
> - * register.
> - */
> -static inline void axienet_dma_out32(struct axienet_local *lp,
> -                                    off_t reg, u32 value)
> -{
> -       iowrite32(value, lp->dma_regs + reg);
> -}
> -
> -static void axienet_dma_out_addr(struct axienet_local *lp, off_t reg,
> -                                dma_addr_t addr)
> -{
> -       axienet_dma_out32(lp, reg, lower_32_bits(addr));
> -
> -       if (lp->features & XAE_FEATURE_DMA_64BIT)
> -               axienet_dma_out32(lp, reg + 4, upper_32_bits(addr));
> -}
> -
>  static void desc_set_phys_addr(struct axienet_local *lp, dma_addr_t addr,
>                                struct axidma_bd *desc)
>  {
> @@ -2061,6 +2037,10 @@ static int axienet_probe(struct platform_device *pdev)
>                         iowrite32(0x0, desc);
>                 }
>         }
> +       if (!IS_ENABLED(CONFIG_64BIT) && lp->features & XAE_FEATURE_DMA_64BIT) {
> +               dev_err(&pdev->dev, "64-bit addressable DMA is not compatible with 32-bit archecture\n");
> +               goto cleanup_clk;
> +       }
>
>         ret = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(addr_width));
>         if (ret) {
> --
> 2.36.0
>
