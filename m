Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12B1149B1A8
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 11:28:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352343AbiAYKZN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 05:25:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235222AbiAYKXC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 05:23:02 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32FF4C06173E
        for <netdev@vger.kernel.org>; Tue, 25 Jan 2022 02:23:00 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id p15so29547614ejc.7
        for <netdev@vger.kernel.org>; Tue, 25 Jan 2022 02:23:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mXvXXH5NkD3VAbxPYQLS+yBdXysPjN86vINvSbtOAUo=;
        b=pDneXHtftHaFd0QpxVSQgYZJ/r85V/t7o7isVF9jWMXmK6UBInq4U2qhRaHN9SwHWb
         +0+uu2yDz4gyvRd8ExR0Y5Gr6hHRYuo4GHXw+g4H8G7bB6zqppHg6WqlXl5CPg59NNdl
         6/qXOtTbqvTSRLzAgl1zCdDRoM9RZCFoQDlE/H8a4ZGMQWkqHsuSAFhM72EqI+RmXBxs
         9nIPmmd06u2ezVi3XwxyrvGbsohdc1lF/NPzkPidacBVKieVvp6qL2elTUErmY1JIANy
         e1NfXcC10p09JorqT1p5lV33SQaKg3ODW8x+wi8GN4EQbYUNiklzMJjHAiVmlss+XzGr
         OygQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mXvXXH5NkD3VAbxPYQLS+yBdXysPjN86vINvSbtOAUo=;
        b=IOF7j6OtzFmBpe3Tc4My8WrWL+XiBVX4VqyB9mCJr++Tzw7+1EpIC2FwdDUsFK29CX
         pUimK6CDHopT7wO8vjtsuBelgAA1JVg9WcG2F7aTnedfAHb3IcdqSCYp+gM4P1Gx2oW/
         hnxpAz4g1QzZDaOM91WF+/k9xPMgNCmafP7ExL7aJrd1Z+0vVgYJXANJMELwZyUdHHnw
         +juNOMqdP9rYr5YMHI4Q+anYd1l2aDGQyzrf7irzofIM+2cuJsllnM3bckqrZtZNSYeD
         NYN9CEPQXk+IQt4Jx3egzQMdNuSumgV16PrJ6+ShIQe+vjEt/0tuJucNuJayzhy6fz9/
         pVJg==
X-Gm-Message-State: AOAM532DVjSgbJqpW12Lfa+Cnd0j69tBGFh2V9S3olCDTFmDEkEj+dOR
        8SVt+FQiUJzzjCrkD8LME3nQVo4tP8GYZsGOoDSbiw==
X-Google-Smtp-Source: ABdhPJzZTQ34Sj6DntR4KEnfsahwcr2GjkI+X89p/KhV55EV9Ip8387kcoPafKP0Tf9qoGGj36xxE50nWLaCOxj2LZ8=
X-Received: by 2002:a17:907:3f93:: with SMTP id hr19mr16043123ejc.697.1643106178771;
 Tue, 25 Jan 2022 02:22:58 -0800 (PST)
MIME-Version: 1.0
References: <20220120070226.1492-1-biao.huang@mediatek.com> <20220120070226.1492-3-biao.huang@mediatek.com>
In-Reply-To: <20220120070226.1492-3-biao.huang@mediatek.com>
From:   Bartosz Golaszewski <brgl@bgdev.pl>
Date:   Tue, 25 Jan 2022 11:22:48 +0100
Message-ID: <CAMRc=McZTped08HwbM+pr-xtsDyddTLjpsCc_f7ucoDM2DNXaw@mail.gmail.com>
Subject: Re: [PATCH net-next v1 2/9] net: ethernet: mtk-star-emac: modify IRQ
 trigger flags
To:     Biao Huang <biao.huang@mediatek.com>
Cc:     David Miller <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Fabien Parent <fparent@baylibre.com>,
        Jakub Kicinski <kuba@kernel.org>, Felix Fietkau <nbd@nbd.name>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        devicetree <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        "moderated list:ARM/Mediatek SoC..." 
        <linux-mediatek@lists.infradead.org>,
        Yinghua Pan <ot_yinghua.pan@mediatek.com>,
        srv_heupstream@mediatek.com, Macpaul Lin <macpaul.lin@mediatek.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 20, 2022 at 8:02 AM Biao Huang <biao.huang@mediatek.com> wrote:
>
> If the flags in request_irq() is IRQF_TRIGGER_NONE, the trigger method
> is determined by "interrupt" property in dts.
> So, modify the flag from IRQF_TRIGGER_FALLING to IRQF_TRIGGER_NONE.
>
> Signed-off-by: Biao Huang <biao.huang@mediatek.com>
> Signed-off-by: Yinghua Pan <ot_yinghua.pan@mediatek.com>
> ---
>  drivers/net/ethernet/mediatek/mtk_star_emac.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/ethernet/mediatek/mtk_star_emac.c b/drivers/net/ethernet/mediatek/mtk_star_emac.c
> index 26f5020f2e9c..7c2af775d601 100644
> --- a/drivers/net/ethernet/mediatek/mtk_star_emac.c
> +++ b/drivers/net/ethernet/mediatek/mtk_star_emac.c
> @@ -959,7 +959,7 @@ static int mtk_star_enable(struct net_device *ndev)
>
>         /* Request the interrupt */
>         ret = request_irq(ndev->irq, mtk_star_handle_irq,
> -                         IRQF_TRIGGER_FALLING, ndev->name, ndev);
> +                         IRQF_TRIGGER_NONE, ndev->name, ndev);
>         if (ret)
>                 goto err_free_skbs;
>
> --
> 2.25.1
>

Reviewed-by: Bartosz Golaszewski <brgl@bgdev.pl>
