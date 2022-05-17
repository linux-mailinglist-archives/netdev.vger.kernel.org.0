Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9CB8529CEC
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 10:51:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243772AbiEQIvb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 04:51:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243124AbiEQIv3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 04:51:29 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9190E286F4
        for <netdev@vger.kernel.org>; Tue, 17 May 2022 01:51:27 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id nk9-20020a17090b194900b001df2fcdc165so1841306pjb.0
        for <netdev@vger.kernel.org>; Tue, 17 May 2022 01:51:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sITgGmSknmUwCrGdSkCcyHvs7kMsznwbXUVx3rgwA6w=;
        b=GW+7gR+6zhQUbQ+nxzCOIOMiu6xhVGn/4TDA0vIHIO0EJSMDyebKgTQXzM/60/i5qv
         Ab8I0b2Bot7YWCtn6wwb7HgnXua4e7HYoJtSCNZWmHpVgYpb6zukxneL8O2TyWjRil67
         qG2qH2Gv5guKJ/7t0Q32UKrGhhvuVub+Hd7Fdfup+IlgKiehsvii6invFaOFl7gxuQlp
         5hRizkh5yp7j6RxowuxP7yKL2Eim9S0AJDd8BIILTvBmok7IqbOriNJ6iFrNLcY/WI/w
         0YQJoxXkY0lCTox7lmGZZcwhQMe1Sn4xPhEZ1O2qlrCdxLWgvP99xBoMj0zqQIs2t+1e
         crRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sITgGmSknmUwCrGdSkCcyHvs7kMsznwbXUVx3rgwA6w=;
        b=SqpecGPtoU3yztiPC99NGWOzzxzJa4pEAWW2Z0kx6nbJyoHLLR5VCJyy8EzSKLQOiO
         EXhtpqK+rVg7brzYYhxpuQyEQ5nzM5AMeAk5rdqujXheMsorrGdvPUM4cc/HgYgy1oQY
         aYyqb82nuvC7RviaF6gXTGkB0agvQ1dIFlXWCqeECTmZBIqZqlbVl+bkiFQ/tbMYHEdz
         DQ33xOXLHCCZ27iyIHbUHqZhSmA5BQnjoGhICaFlRGrCyXgg09unBGiSYms85nG1pxhG
         RXKBeLAZEWtyTalrOwD7XZke7HUVLgkWqHTAYNQzjNMckkKPDx9GSVWoBL4ZKRiNBFD+
         vwxA==
X-Gm-Message-State: AOAM531wfEI8XqH0m0W7PJiahhKLUAANmSvEv3YpBT+mIWyF+yoYxS0b
        d0XoaGuq4eKFPcZCE6goWpyflyJ9CkXoPbFinrBgZQ==
X-Google-Smtp-Source: ABdhPJzlssZXL1ayCYqQOI6GR8vdor5jTA9hXniYeDzpBXJKwJ2ywgy5pWV0P0l0XzFpWvXboKEO0eQSsbacUIsHoJM=
X-Received: by 2002:a17:902:f814:b0:161:505d:a4f4 with SMTP id
 ix20-20020a170902f81400b00161505da4f4mr14276821plb.6.1652777486978; Tue, 17
 May 2022 01:51:26 -0700 (PDT)
MIME-Version: 1.0
References: <20220517064821.3966990-1-william.xuanziyang@huawei.com>
In-Reply-To: <20220517064821.3966990-1-william.xuanziyang@huawei.com>
From:   Loic Poulain <loic.poulain@linaro.org>
Date:   Tue, 17 May 2022 10:50:51 +0200
Message-ID: <CAMZdPi-ibG9O9C2m3qVeEAbO6=TLA-8jZzX9Gbm2MQOwT_1vPg@mail.gmail.com>
Subject: Re: [PATCH net-next v2] net: wwan: t7xx: fix GFP_KERNEL usage in
 spin_lock context
To:     Ziyang Xuan <william.xuanziyang@huawei.com>
Cc:     chandrashekar.devegowda@intel.com, linuxwwan@intel.com,
        chiranjeevi.rapolu@linux.intel.com, haijun.liu@mediatek.com,
        m.chetan.kumar@linux.intel.com, ricardo.martinez@linux.intel.com,
        ryazanov.s.a@gmail.com, johannes@sipsolutions.net,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org
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

Hi Ziyang,

On Tue, 17 May 2022 at 08:30, Ziyang Xuan <william.xuanziyang@huawei.com> wrote:
>
> t7xx_cldma_clear_rxq() call t7xx_cldma_alloc_and_map_skb() in spin_lock
> context, But __dev_alloc_skb() in t7xx_cldma_alloc_and_map_skb() uses
> GFP_KERNEL, that will introduce scheduling factor in spin_lock context.
>
> Because t7xx_cldma_clear_rxq() is called after stopping CLDMA, so we can
> remove the spin_lock from t7xx_cldma_clear_rxq().
>
> Fixes: 39d439047f1d ("net: wwan: t7xx: Add control DMA interface")
> Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
> ---

You should normally indicate what changed in this v2.

>  drivers/net/wwan/t7xx/t7xx_hif_cldma.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/net/wwan/t7xx/t7xx_hif_cldma.c b/drivers/net/wwan/t7xx/t7xx_hif_cldma.c
> index 46066dcd2607..7493285a9606 100644
> --- a/drivers/net/wwan/t7xx/t7xx_hif_cldma.c
> +++ b/drivers/net/wwan/t7xx/t7xx_hif_cldma.c
> @@ -782,10 +782,12 @@ static int t7xx_cldma_clear_rxq(struct cldma_ctrl *md_ctrl, int qnum)
>         struct cldma_queue *rxq = &md_ctrl->rxq[qnum];
>         struct cldma_request *req;
>         struct cldma_gpd *gpd;
> -       unsigned long flags;
>         int ret = 0;
>
> -       spin_lock_irqsave(&rxq->ring_lock, flags);
> +       /* CLDMA has been stopped. There is not any CLDMA IRQ, holding
> +        * ring_lock is not needed.

If it makes sense to explain why we don't need locking, the next
sentence is not needed:


>  Thus we can use functions that may
> +        * introduce scheduling.
> +        */
>         t7xx_cldma_q_reset(rxq);
>         list_for_each_entry(req, &rxq->tr_ring->gpd_ring, entry) {
>                 gpd = req->gpd;
> @@ -808,7 +810,6 @@ static int t7xx_cldma_clear_rxq(struct cldma_ctrl *md_ctrl, int qnum)
>
>                 t7xx_cldma_gpd_set_data_ptr(req->gpd, req->mapped_buff);
>         }
> -       spin_unlock_irqrestore(&rxq->ring_lock, flags);
>
>         return ret;
>  }
> --
> 2.25.1
>
