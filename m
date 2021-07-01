Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F06653B9824
	for <lists+netdev@lfdr.de>; Thu,  1 Jul 2021 23:27:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234325AbhGAV3k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Jul 2021 17:29:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234255AbhGAV3k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Jul 2021 17:29:40 -0400
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE808C061764
        for <netdev@vger.kernel.org>; Thu,  1 Jul 2021 14:27:08 -0700 (PDT)
Received: by mail-lj1-x22e.google.com with SMTP id e3so1978482ljo.6
        for <netdev@vger.kernel.org>; Thu, 01 Jul 2021 14:27:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tNdovWONAJS2tmla2jBCM5Itz2o4pqMUjGORL+HptVU=;
        b=kNiciE1LKvyy4oLjI1gsH75NPWT6lqeO2ZobdhJ5FuiJiASUJ7WhGVQDwXaox9IWqb
         sDgEKqepnkz0avDsZjGb+wr7h1FJIbDfaJgCBQcMvoxv/JHElZ1uM8YB/OlBkN7Hb3ET
         LBQVxNBuUUY9VM792HIoU+GSfrsx25WYxwp0cBnAfsnuoE4xcH2oOczPgX+fo6tnFnAZ
         4kvCLLgpPwVT3pjSRLLIzng4lnnAvcymVtaINT3OoysXzgyPMLo5eVUmRBjqInnBBcm2
         tZqZPjzh3Si96zFD0tXxg0mHQuSh+MfZkJjsk/rx1tcifTze5i/LCy16p29HVp2l3527
         Igrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tNdovWONAJS2tmla2jBCM5Itz2o4pqMUjGORL+HptVU=;
        b=obv00mFExftzd9zxQfnGk/f7O4Q5h9cw7j+8t0DLthdBeXTNlzramEHLJo+Sb6dzeT
         I2c5MhpXWzifndfGZdJH7kY63ok/aZWnxgISexhHpO9CasnGew7UiwEmfVmMKeMwt5pI
         R/ZB4qyrCHICn1X018NQIASTFCR961EW2XKv87GE9wESo6qVedIrb21Dk5BP1RJpUH5L
         l/qKHp08SHvGqdgJd2/LGNAd1AExoNtDmALYwodfvwSdopksDHsKU2/VemgwuEL0uU55
         YaG92T1LCdBEqObcoMx3JpQ66tNXoVL1r5dzHxzBiCDoFVz7A2y/J5xCMoutX8gW/2Sl
         mBrw==
X-Gm-Message-State: AOAM533GDWaLXOtsn7c1uToehqurzehHhR+cg4xooDyWWulavT2P2kk6
        wmGNZ0RTXtjQSuhLQtkRLzFOejXTwMNq41a++Axq+g==
X-Google-Smtp-Source: ABdhPJwFqmciUVS+yaaqjQV5c2F883P7rLgFT4w/dpSTBGNG7drC0d+KS7wtsp1DcNlNLXKew0OzKqYf8TbyEYWqdWU=
X-Received: by 2002:a05:651c:305:: with SMTP id a5mr1167662ljp.337.1625174826795;
 Thu, 01 Jul 2021 14:27:06 -0700 (PDT)
MIME-Version: 1.0
References: <a8ff6511e4740cff2bb549708b98fb1e6dd7e070.1625172036.git.christophe.jaillet@wanadoo.fr>
In-Reply-To: <a8ff6511e4740cff2bb549708b98fb1e6dd7e070.1625172036.git.christophe.jaillet@wanadoo.fr>
From:   Catherine Sullivan <csully@google.com>
Date:   Thu, 1 Jul 2021 14:26:30 -0700
Message-ID: <CAH_-1qyRsfFzm_F26WV4wSjMojTVQSdahASWTKXb7VgQPHHUNA@mail.gmail.com>
Subject: Re: [PATCH net-next v2] gve: Simplify code and axe the use of a
 deprecated API
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     Sagi Shahar <sagis@google.com>, Jon Olson <jonolson@google.com>,
        David Miller <davem@davemloft.net>, kuba@kernel.org,
        David Awogbemila <awogbemila@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Yangchun Fu <yangchun@google.com>,
        Bailey Forrest <bcf@google.com>, Kuo Zhao <kuozhao@google.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 1, 2021 at 1:41 PM Christophe JAILLET
<christophe.jaillet@wanadoo.fr> wrote:
>
> The wrappers in include/linux/pci-dma-compat.h should go away.
>
> Replace 'pci_set_dma_mask/pci_set_consistent_dma_mask' by an equivalent
> and less verbose 'dma_set_mask_and_coherent()' call.
>
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

Reviewed-by: Catherine Sullivan <csully@google.com>

> ---
> If needed, see post from Christoph Hellwig on the kernel-janitors ML:
>    https://marc.info/?l=kernel-janitors&m=158745678307186&w=4
>
> v2: Unchanged
>     This patch was previously 3/3 of a serie
> ---
>  drivers/net/ethernet/google/gve/gve_main.c | 9 +--------
>  1 file changed, 1 insertion(+), 8 deletions(-)
>
> diff --git a/drivers/net/ethernet/google/gve/gve_main.c b/drivers/net/ethernet/google/gve/gve_main.c
> index c03984b26db4..099a2bc5ae67 100644
> --- a/drivers/net/ethernet/google/gve/gve_main.c
> +++ b/drivers/net/ethernet/google/gve/gve_main.c
> @@ -1477,19 +1477,12 @@ static int gve_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
>
>         pci_set_master(pdev);
>
> -       err = pci_set_dma_mask(pdev, DMA_BIT_MASK(64));
> +       err = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64));
>         if (err) {
>                 dev_err(&pdev->dev, "Failed to set dma mask: err=%d\n", err);
>                 goto abort_with_pci_region;
>         }
>
> -       err = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(64));
> -       if (err) {
> -               dev_err(&pdev->dev,
> -                       "Failed to set consistent dma mask: err=%d\n", err);
> -               goto abort_with_pci_region;
> -       }
> -
>         reg_bar = pci_iomap(pdev, GVE_REGISTER_BAR, 0);
>         if (!reg_bar) {
>                 dev_err(&pdev->dev, "Failed to map pci bar!\n");
> --
> 2.30.2
>

Thanks!
