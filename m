Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BB3F52B5E8
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 11:29:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233900AbiERJOf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 05:14:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233869AbiERJOe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 05:14:34 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84A67146404
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 02:14:33 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id y199so1570609pfb.9
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 02:14:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GjvQwPM1daZo8+jCqWpaTz2mh/pEzt/6tEe1yGu9dLM=;
        b=eQ6HR9gNmBjFbYML7Gui5OzZdhQ1ZJrrout1YiW/OYAgfXojWKCDuV86ePsOqi8nHc
         Q/zJMR8PLB4HUUvyQg60hVOtESQhHMagFOehN8Q+EZPU1tRYuO8ZMApeTCpvwtJHq/De
         I2AeL1NGadVpwvZU+UvRBmdFjJMVp+Wyrmw8BDFcLXdZAlyrOUA74BPZYYkT1C6LuOIm
         BOLQMyqpWZRz28NR53+azrOdFnIrUTeZ0IwvuFe0KwKlb7Q0ARYbekaBm3N4i61x5x9V
         +Ifyw1XogMpMIz4lWf9qMZRD3kLrTlp63mTXaxQHJ+9ErEVtg26/R+1HHAPNpPO8cg9i
         TLgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GjvQwPM1daZo8+jCqWpaTz2mh/pEzt/6tEe1yGu9dLM=;
        b=bKBWdNSwuH+Kwf49d80DteWEtiIn8UI6Xof8c9Ocdww5P4mRD9W+60s1tvVuyuwUnE
         Cwg9pPAjNRZ+2IgtAH8N4TvLiBbxtqlm9jCglEFrXzk13paOtgkXpLFwWLeQsYHQ6KsA
         Mljb6yccLnZs7fN3EUPmZW/TbLcXCT/MCRyn5JsHNDE2hgBzLXEA28Qo1yzRbKxL8/9e
         GWMUwc8OsYeHBVga0PcZOEv/mOXqW8AYo2QLoXtlzR+1lfnFoYQeE43s1WYYMfkpu8Ay
         WZgYxDunHxEExdeVSYuaQlp8zUutTC4z0G0CwmPamIUK6bGNiZGFCZOoZA5UPjtBzdSU
         MfOQ==
X-Gm-Message-State: AOAM530mcwayFKY98WFSAkS7qcRCOKXOgkkJSFj+28AMs6vak86YR6zP
        SwAI0FTQggNIebzPFGnJxi+zmn8dSxq/5d8YtnOCrA==
X-Google-Smtp-Source: ABdhPJympDV8mO/7wcUhujZ0IVK8Fi+T7b+h4c4ApG6fzgAOF2agcfhcnphsmdMxge90eiicfp3r24uSzxyxcZv9/dU=
X-Received: by 2002:a63:111f:0:b0:3da:ed0d:7623 with SMTP id
 g31-20020a63111f000000b003daed0d7623mr23285972pgl.586.1652865272760; Wed, 18
 May 2022 02:14:32 -0700 (PDT)
MIME-Version: 1.0
References: <20220518090738.2694556-1-yangyingliang@huawei.com>
In-Reply-To: <20220518090738.2694556-1-yangyingliang@huawei.com>
From:   Loic Poulain <loic.poulain@linaro.org>
Date:   Wed, 18 May 2022 11:13:56 +0200
Message-ID: <CAMZdPi9uvh4E70-AXpGrdzkgh35mfWQbhL8Kxw_o9_DsfL2gbw@mail.gmail.com>
Subject: Re: [PATCH -next] net: wwan: t7xx: use GFP_ATOMIC under spin lock in t7xx_cldma_gpd_set_next_ptr()
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     linux-kernel@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        haijun.liu@mediatek.com, chandrashekar.devegowda@intel.com,
        ricardo.martinez@linux.intel.com, davem@davemloft.net,
        kuba@kernel.org
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

Hi Yang,

On Wed, 18 May 2022 at 10:57, Yang Yingliang <yangyingliang@huawei.com> wrote:
>
> Sometimes t7xx_cldma_gpd_set_next_ptr() is called under spin lock,
> so add a parameter in t7xx_cldma_gpd_set_next_ptr() to make if it
> use GFP_ATOMIC flag.
>
> Fixes: 39d439047f1d ("net: wwan: t7xx: Add control DMA interface")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> ---
>  drivers/net/wwan/t7xx/t7xx_hif_cldma.c | 13 ++++++++-----
>  1 file changed, 8 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/net/wwan/t7xx/t7xx_hif_cldma.c b/drivers/net/wwan/t7xx/t7xx_hif_cldma.c
> index 0c52801ed0de..1fa9bb763831 100644
> --- a/drivers/net/wwan/t7xx/t7xx_hif_cldma.c
> +++ b/drivers/net/wwan/t7xx/t7xx_hif_cldma.c
> @@ -91,9 +91,12 @@ static void t7xx_cldma_gpd_set_next_ptr(struct cldma_gpd *gpd, dma_addr_t next_p
>  }
>
>  static int t7xx_cldma_alloc_and_map_skb(struct cldma_ctrl *md_ctrl, struct cldma_request *req,
> -                                       size_t size)
> +                                       size_t size, bool is_atomic)

Would be simpler to directly pass the gfp_mask as a parameter.


>  {
> -       req->skb = __dev_alloc_skb(size, GFP_KERNEL);
> +       if (is_atomic)
> +               req->skb = __dev_alloc_skb(size, GFP_ATOMIC);
> +       else
> +               req->skb = __dev_alloc_skb(size, GFP_KERNEL);
>         if (!req->skb)
>                 return -ENOMEM;
>
> @@ -174,7 +177,7 @@ static int t7xx_cldma_gpd_rx_from_q(struct cldma_queue *queue, int budget, bool
>                 spin_unlock_irqrestore(&queue->ring_lock, flags);
>                 req = queue->rx_refill;
>
> -               ret = t7xx_cldma_alloc_and_map_skb(md_ctrl, req, queue->tr_ring->pkt_size);
> +               ret = t7xx_cldma_alloc_and_map_skb(md_ctrl, req, queue->tr_ring->pkt_size, false);
>                 if (ret)
>                         return ret;
>
> @@ -402,7 +405,7 @@ static struct cldma_request *t7xx_alloc_rx_request(struct cldma_ctrl *md_ctrl, s
>         if (!req->gpd)
>                 goto err_free_req;
>
> -       val = t7xx_cldma_alloc_and_map_skb(md_ctrl, req, pkt_size);
> +       val = t7xx_cldma_alloc_and_map_skb(md_ctrl, req, pkt_size, false);
>         if (val)
>                 goto err_free_pool;
>
> @@ -801,7 +804,7 @@ static int t7xx_cldma_clear_rxq(struct cldma_ctrl *md_ctrl, int qnum)
>                 if (req->skb)
>                         continue;
>
> -               ret = t7xx_cldma_alloc_and_map_skb(md_ctrl, req, rxq->tr_ring->pkt_size);
> +               ret = t7xx_cldma_alloc_and_map_skb(md_ctrl, req, rxq->tr_ring->pkt_size, true);
>                 if (ret)
>                         break;
>
> --
> 2.25.1
>
