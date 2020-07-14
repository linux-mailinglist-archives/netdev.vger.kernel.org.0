Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2213221EAFD
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 10:09:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726609AbgGNIJj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 04:09:39 -0400
Received: from mail-oi1-f194.google.com ([209.85.167.194]:36962 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725793AbgGNIJi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jul 2020 04:09:38 -0400
Received: by mail-oi1-f194.google.com with SMTP id 12so13268749oir.4;
        Tue, 14 Jul 2020 01:09:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kQd/3+NgYL5ETBCqN/I6t615NftKK//t8YpCv8X+l+8=;
        b=L79lDTg5z+Wr8CrXu4B47bF4ahswvDDmZ0H/Qy/qa9Fo+XQYlDPLw9aqaQLZXqLQ/2
         BXkk5/b/9JWNo8aBf0dZ3bNGBz4QCNYoh39pOIiaOfd3ojyTvKUSv+mlF7ByXRarB0m8
         p0IAsFE2pP+t9NzaUcaeflghIosdBFVXGqkWBwHUvJ+Lx0uG0zmNGOE4sjXI288H39Uh
         nlIDJJuACYfyKEH7+Qbu/2M2dlJodA+RM0CPznBlF4DI0GnyzJ25FjpDRzQ/ztIB5iNg
         Izob0WAA1Jw3mXmTKFcyRFd5nkxWo6o3s7QU0ChSVQsC+i0MeScSD5jVw49BJULxQXF6
         jSfA==
X-Gm-Message-State: AOAM532Ka1CwR5iO1M7/Vtqob7jdCvTCM6mtMQPM80OJ6rhifWZK1L+J
        35UC956Ic405nS9CHgjg1s+levydKxXA/lvt4PY=
X-Google-Smtp-Source: ABdhPJz7hdIV/baG1FFq5NebTyyKrvGlXKfMdm90XT59CL4jYHtqaTc+X/vLw/NAnF5ngIMw26ZC9YKmVtr4fJbw2xI=
X-Received: by 2002:aca:ac10:: with SMTP id v16mr2565069oie.153.1594714176638;
 Tue, 14 Jul 2020 01:09:36 -0700 (PDT)
MIME-Version: 1.0
References: <1594676120-5862-1-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <1594676120-5862-3-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
In-Reply-To: <1594676120-5862-3-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Tue, 14 Jul 2020 10:09:25 +0200
Message-ID: <CAMuHMdV4zzrk_=-2Cmgq8=PKTeU457iveJ58gYekJ-Z8SXqaCQ@mail.gmail.com>
Subject: Re: [PATCH 2/9] iommu/ipmmu-vmsa: Hook up R8A774E1 DT matching code
To:     Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Cc:     Vinod Koul <vkoul@kernel.org>, Rob Herring <robh+dt@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Joerg Roedel <joro@8bytes.org>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        dmaengine <dmaengine@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        Linux IOMMU <iommu@lists.linux-foundation.org>,
        netdev <netdev@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Prabhakar <prabhakar.csengg@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Prabhakar,

On Mon, Jul 13, 2020 at 11:35 PM Lad Prabhakar
<prabhakar.mahadev-lad.rj@bp.renesas.com> wrote:
> From: Marian-Cristian Rotariu <marian-cristian.rotariu.rb@bp.renesas.com>
>
> Add support for RZ/G2H (R8A774E1) SoC IPMMUs.
>
> Signed-off-by: Marian-Cristian Rotariu <marian-cristian.rotariu.rb@bp.renesas.com>
> Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>

Thanks for your patch!

> --- a/drivers/iommu/ipmmu-vmsa.c
> +++ b/drivers/iommu/ipmmu-vmsa.c
> @@ -751,6 +751,7 @@ static const struct soc_device_attribute soc_rcar_gen3[] = {
>  static const struct soc_device_attribute soc_rcar_gen3_whitelist[] = {
>         { .soc_id = "r8a774b1", },
>         { .soc_id = "r8a774c0", },
> +       { .soc_id = "r8a774e1", },

Adding an entry to soc_rcar_gen3_whitelist[] doesn't do anything, unless
you also add the same entry to soc_rcar_gen3[].

>         { .soc_id = "r8a7795", .revision = "ES3.*" },
>         { .soc_id = "r8a77961", },
>         { .soc_id = "r8a77965", },
> @@ -963,6 +964,9 @@ static const struct of_device_id ipmmu_of_ids[] = {
>         }, {
>                 .compatible = "renesas,ipmmu-r8a774c0",
>                 .data = &ipmmu_features_rcar_gen3,
> +       }, {
> +               .compatible = "renesas,ipmmu-r8a774e1",
> +               .data = &ipmmu_features_rcar_gen3,
>         }, {
>                 .compatible = "renesas,ipmmu-r8a7795",
>                 .data = &ipmmu_features_rcar_gen3,

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
