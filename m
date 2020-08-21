Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 938FD24CD01
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 06:51:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726189AbgHUEvn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 00:51:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725270AbgHUEvk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Aug 2020 00:51:40 -0400
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com [IPv6:2607:f8b0:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B121C061385;
        Thu, 20 Aug 2020 21:51:40 -0700 (PDT)
Received: by mail-ot1-x344.google.com with SMTP id 93so689243otx.2;
        Thu, 20 Aug 2020 21:51:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=q8QxRXvkJ8p6P97NeMKahPx4fdfAIwJIkjZuT2Ywx28=;
        b=H80+FIKlm8uK4cAiZJu1VEHeAn1fD99gJP1Yl6ixnbOMPdy95JrYOx2FlLuaCRDvjc
         OYpvhzzxmgT0NC9UIg4d9TY3Mc3RgH8mZWgvVcPSyEESyXt48mG+CfCxXLZ6E66frr0A
         yJOPq2bMOMIxMDDnBnkccQY3TgzV49NU3pJYlb8tYEsr5vfqbobsZ74NyHhWjQbxS9qd
         lIqpOHgh4xfJCdBpcqxdXMZrZpeHTSwQt7uJtBt9Spe8KrAFPXjKHH35inSat6PM4w0y
         SBJJUXoMKKMeeXCHEi5sGfPJ4Or9oY19B0YIGC1V0m1dEndch/ZFNDzkok0uvuJHlhAo
         8bag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=q8QxRXvkJ8p6P97NeMKahPx4fdfAIwJIkjZuT2Ywx28=;
        b=EK5gf3RLlwqsjBmpnnyOAWUhwGTYBCqPOQomhsX+bodgXZu3ed+RoPX8SOJyVWuId+
         eA/SXtu6r6VbJhqdJOTSXOTxHe6Qt+FN0aeegqTqEJB6TW1dqXFL7+zPgzHTsrhnu2pR
         hDyj0pDjb5Oc7SHz2ggSZEiUTizRraaNwpDWprFh9InVg/S0MzBthcXTci/vIPD6AQgR
         w49Bi4hE9qDqwf6Y58pxV4FFqvjLD0At0fGSIdracw2Y4uOW8Sqbu5mm5iWAZttGjI/7
         TrkTV8D/NERBMUJ6jxeMQpfbF0bbR6LlWpsfMiPabiX5lFg1hNxWqO3Rhb6zDU8u1u1F
         kERA==
X-Gm-Message-State: AOAM532vxW0MYdpXXpGMw9ktK36J36f8sfLgztmPMap8ecWUS0X3IfxW
        M4oecuYX1WnPzo1vRD2Z1tgj9Bxm5TQ=
X-Google-Smtp-Source: ABdhPJwNl2KqLei73IsLbNGyjeci3XN51y8vkXWW1n+8GV1C66+InYR9ftkXJ9fKAZ9HmlK8RJt77A==
X-Received: by 2002:a05:6830:1218:: with SMTP id r24mr807291otp.179.1597985499443;
        Thu, 20 Aug 2020 21:51:39 -0700 (PDT)
Received: from localhost.localdomain (cpe-24-31-245-230.kc.res.rr.com. [24.31.245.230])
        by smtp.gmail.com with ESMTPSA id x143sm150300oia.12.2020.08.20.21.51.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Aug 2020 21:51:38 -0700 (PDT)
Subject: Re: [PATCH] rtlwifi: switch from 'pci_' to 'dma_' API
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        pkshih@realtek.com, kvalo@codeaurora.org, davem@davemloft.net,
        kuba@kernel.org, straube.linux@gmail.com, zhengbin13@huawei.com
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
References: <20200820144604.144521-1-christophe.jaillet@wanadoo.fr>
From:   Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <e0f88024-0124-f425-850e-242027198d44@lwfinger.net>
Date:   Thu, 20 Aug 2020 23:51:37 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200820144604.144521-1-christophe.jaillet@wanadoo.fr>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/20/20 9:46 AM, Christophe JAILLET wrote:
> The wrappers in include/linux/pci-dma-compat.h should go away.
> 
> The patch has been generated with the coccinelle script below and has been
> hand modified to replace GFP_ with a correct flag.
> It has been compile tested.
> 
> The only file where some GFP_ flags are updated is 'pci.c'.
> 
> When memory is allocated in '_rtl_pci_init_tx_ring()' and
> '_rtl_pci_init_rx_ring()' GFP_KERNEL can be used because both functions are
> called from a probe function and no spinlock is taken.
> 
> The call chain is:
>    rtl_pci_probe
>      --> rtl_pci_init
>        --> _rtl_pci_init_trx_ring
>          --> _rtl_pci_init_rx_ring
>          --> _rtl_pci_init_tx_ring
> 
> 
> @@
> @@
> -    PCI_DMA_BIDIRECTIONAL
> +    DMA_BIDIRECTIONAL
> 
> @@
> @@
> -    PCI_DMA_TODEVICE
> +    DMA_TO_DEVICE
> 
> @@
> @@
> -    PCI_DMA_FROMDEVICE
> +    DMA_FROM_DEVICE
> 
> @@
> @@
> -    PCI_DMA_NONE
> +    DMA_NONE
> 
> @@
> expression e1, e2, e3;
> @@
> -    pci_alloc_consistent(e1, e2, e3)
> +    dma_alloc_coherent(&e1->dev, e2, e3, GFP_)
> 
> @@
> expression e1, e2, e3;
> @@
> -    pci_zalloc_consistent(e1, e2, e3)
> +    dma_alloc_coherent(&e1->dev, e2, e3, GFP_)
> 
> @@
> expression e1, e2, e3, e4;
> @@
> -    pci_free_consistent(e1, e2, e3, e4)
> +    dma_free_coherent(&e1->dev, e2, e3, e4)
> 
> @@
> expression e1, e2, e3, e4;
> @@
> -    pci_map_single(e1, e2, e3, e4)
> +    dma_map_single(&e1->dev, e2, e3, e4)
> 
> @@
> expression e1, e2, e3, e4;
> @@
> -    pci_unmap_single(e1, e2, e3, e4)
> +    dma_unmap_single(&e1->dev, e2, e3, e4)
> 
> @@
> expression e1, e2, e3, e4, e5;
> @@
> -    pci_map_page(e1, e2, e3, e4, e5)
> +    dma_map_page(&e1->dev, e2, e3, e4, e5)
> 
> @@
> expression e1, e2, e3, e4;
> @@
> -    pci_unmap_page(e1, e2, e3, e4)
> +    dma_unmap_page(&e1->dev, e2, e3, e4)
> 
> @@
> expression e1, e2, e3, e4;
> @@
> -    pci_map_sg(e1, e2, e3, e4)
> +    dma_map_sg(&e1->dev, e2, e3, e4)
> 
> @@
> expression e1, e2, e3, e4;
> @@
> -    pci_unmap_sg(e1, e2, e3, e4)
> +    dma_unmap_sg(&e1->dev, e2, e3, e4)
> 
> @@
> expression e1, e2, e3, e4;
> @@
> -    pci_dma_sync_single_for_cpu(e1, e2, e3, e4)
> +    dma_sync_single_for_cpu(&e1->dev, e2, e3, e4)
> 
> @@
> expression e1, e2, e3, e4;
> @@
> -    pci_dma_sync_single_for_device(e1, e2, e3, e4)
> +    dma_sync_single_for_device(&e1->dev, e2, e3, e4)
> 
> @@
> expression e1, e2, e3, e4;
> @@
> -    pci_dma_sync_sg_for_cpu(e1, e2, e3, e4)
> +    dma_sync_sg_for_cpu(&e1->dev, e2, e3, e4)
> 
> @@
> expression e1, e2, e3, e4;
> @@
> -    pci_dma_sync_sg_for_device(e1, e2, e3, e4)
> +    dma_sync_sg_for_device(&e1->dev, e2, e3, e4)
> 
> @@
> expression e1, e2;
> @@
> -    pci_dma_mapping_error(e1, e2)
> +    dma_mapping_error(&e1->dev, e2)
> 
> @@
> expression e1, e2;
> @@
> -    pci_set_dma_mask(e1, e2)
> +    dma_set_mask(&e1->dev, e2)
> 
> @@
> expression e1, e2;
> @@
> -    pci_set_consistent_dma_mask(e1, e2)
> +    dma_set_coherent_mask(&e1->dev, e2)
> 
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---
> If needed, see post from Christoph Hellwig on the kernel-janitors ML:
>     https://marc.info/?l=kernel-janitors&m=158745678307186&w=4
> ---
>   drivers/net/wireless/realtek/rtlwifi/pci.c    | 116 +++++++++---------
>   .../wireless/realtek/rtlwifi/rtl8188ee/hw.c   |   9 +-
>   .../wireless/realtek/rtlwifi/rtl8188ee/trx.c  |  13 +-
>   .../wireless/realtek/rtlwifi/rtl8192ce/trx.c  |  14 +--
>   .../wireless/realtek/rtlwifi/rtl8192de/trx.c  |  12 +-
>   .../wireless/realtek/rtlwifi/rtl8192ee/trx.c  |  13 +-
>   .../wireless/realtek/rtlwifi/rtl8192se/trx.c  |  12 +-
>   .../wireless/realtek/rtlwifi/rtl8723ae/trx.c  |  14 +--
>   .../wireless/realtek/rtlwifi/rtl8723be/hw.c   |   9 +-
>   .../wireless/realtek/rtlwifi/rtl8723be/trx.c  |  13 +-
>   .../wireless/realtek/rtlwifi/rtl8821ae/hw.c   |   9 +-
>   .../wireless/realtek/rtlwifi/rtl8821ae/trx.c  |  13 +-
>   12 files changed, 115 insertions(+), 132 deletions(-)

Tested-by: Larry Finger <Larry.Finger@lwfinger.net> for rtl8821ae.

Larry


