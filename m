Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4A01549C33
	for <lists+netdev@lfdr.de>; Mon, 13 Jun 2022 20:54:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244838AbiFMSxO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jun 2022 14:53:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245615AbiFMSw7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jun 2022 14:52:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9F4CF45F2
        for <netdev@vger.kernel.org>; Mon, 13 Jun 2022 08:55:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8C4AEB810F1
        for <netdev@vger.kernel.org>; Mon, 13 Jun 2022 15:55:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51366C34114
        for <netdev@vger.kernel.org>; Mon, 13 Jun 2022 15:55:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655135715;
        bh=96uADGK4WW9tvEHdake0hlfuLyDhycDoU8FtI4Ox2iU=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=fdKnRJ4DKbJgz2SnaTGERjp8eww2Wie0zmZ+HHHP/RcuYwW5UOJSXmPoNpbqOFgki
         LqNygVNhSPHPFsORMfKQxW6iBjwVpIpWWpQDJtc03uO5Yid6R8DEBWTit6vCxArgRd
         e3vzt5tBgEmVOMTFOlHVCIOnKc0Ihc4JQywS7wZVgiqOYjDvY5wGtQxFsFAget4O+e
         ddXbzcIdi1HnccuJaZDqLVBrXzsTX67EQfvQO4qKuT9yk+D11Z5rJTWs9lDPujgoUo
         gHB5vT7+BtpZJzAl0LhEOCnywfuIgT+ZuJS74cHgM6f7uP0xojutCvxjP+G0N4Pan5
         MNSiWlCTrs8NA==
Received: by mail-vk1-f178.google.com with SMTP id x190so2777056vkc.9
        for <netdev@vger.kernel.org>; Mon, 13 Jun 2022 08:55:15 -0700 (PDT)
X-Gm-Message-State: AJIora8oeTmK6VXdzZc5ixC/T4MBWlo+NIxxiuAkBY7qe8MbaGJi/hMD
        HIgmfx//0l+fPbXqsa9buoSyPSUqC4nF8U1d9Q==
X-Google-Smtp-Source: AGRyM1tW3OHjYxrXG8WGrNmYm37atG9IvxY31C3r7UA6s5Q9P9aIHu8SsAH8M4PxT5+M5t4RWMv8vd3hKvk6bqwu0x0=
X-Received: by 2002:ac5:c4d8:0:b0:368:9f90:50a5 with SMTP id
 a24-20020ac5c4d8000000b003689f9050a5mr318079vkl.14.1655135714245; Mon, 13 Jun
 2022 08:55:14 -0700 (PDT)
MIME-Version: 1.0
References: <20220609161457.69614-1-jean-philippe@linaro.org>
In-Reply-To: <20220609161457.69614-1-jean-philippe@linaro.org>
From:   Rob Herring <robh@kernel.org>
Date:   Mon, 13 Jun 2022 09:55:02 -0600
X-Gmail-Original-Message-ID: <CAL_JsqJT2v-4-s+nP-UTHYjGSx9gANbRKgmPgsi9aQ0JCUaMxA@mail.gmail.com>
Message-ID: <CAL_JsqJT2v-4-s+nP-UTHYjGSx9gANbRKgmPgsi9aQ0JCUaMxA@mail.gmail.com>
Subject: Re: [PATCH] amd-xgbe: Use platform_irq_count()
To:     Jean-Philippe Brucker <jean-philippe@linaro.org>
Cc:     Thomas Lendacky <thomas.lendacky@amd.com>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Lad, Prabhakar" <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Marc Zyngier <maz@kernel.org>, netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 9, 2022 at 10:20 AM Jean-Philippe Brucker
<jean-philippe@linaro.org> wrote:
>
> The AMD XGbE driver currently counts the number of interrupts assigned
> to the device by inspecting the pdev->resource array. Since commit
> a1a2b7125e10 ("of/platform: Drop static setup of IRQ resource from DT
> core") removed IRQs from this array, the driver now attempts to get all
> interrupts from 1 to -1U and gives up probing once it reaches an invalid
> interrupt index.
>
> Obtain the number of IRQs with platform_irq_count() instead.
>
> Fixes: a1a2b7125e10 ("of/platform: Drop static setup of IRQ resource from DT core")
> Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
> ---
>  drivers/net/ethernet/amd/xgbe/xgbe-platform.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-platform.c b/drivers/net/ethernet/amd/xgbe/xgbe-platform.c
> index 4ebd2410185a..4d790a89fe77 100644
> --- a/drivers/net/ethernet/amd/xgbe/xgbe-platform.c
> +++ b/drivers/net/ethernet/amd/xgbe/xgbe-platform.c
> @@ -338,7 +338,7 @@ static int xgbe_platform_probe(struct platform_device *pdev)
>                  *   the PHY resources listed last
>                  */
>                 phy_memnum = xgbe_resource_count(pdev, IORESOURCE_MEM) - 3;
> -               phy_irqnum = xgbe_resource_count(pdev, IORESOURCE_IRQ) - 1;
> +               phy_irqnum = platform_irq_count(pdev) - 1;
>                 dma_irqnum = 1;
>                 dma_irqend = phy_irqnum;
>         } else {
> @@ -348,7 +348,7 @@ static int xgbe_platform_probe(struct platform_device *pdev)
>                 phy_memnum = 0;
>                 phy_irqnum = 0;
>                 dma_irqnum = 1;
> -               dma_irqend = xgbe_resource_count(pdev, IORESOURCE_IRQ);
> +               dma_irqend = platform_irq_count(pdev);

This is some ugly code... This clause is for 'old style' DT (which
actually looks more correct to me then 'new style' which seems
influenced by ACPI). Is there a need to continue carrying support for
old DTs? How many users of Seattle with DT are there?

In any case, that's all a separate change on top of this I think.

Acked-by: Rob Herring <robh@kernel.org>

Rob
