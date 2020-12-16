Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC22E2DBC83
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 09:19:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725845AbgLPIS7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 03:18:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725274AbgLPIS7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Dec 2020 03:18:59 -0500
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D75B8C0613D6;
        Wed, 16 Dec 2020 00:18:18 -0800 (PST)
Received: by mail-wm1-x330.google.com with SMTP id 3so1520187wmg.4;
        Wed, 16 Dec 2020 00:18:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=OsOzas/w/eSfqOtHOGgepo3zxkPHG/qg3EkWGzcgIY8=;
        b=WesLM46cYqkvDM11I0wuqigkm5AWitGsfCK7aWBAgxMicsGw6+HNROPhOlCWYL+iEJ
         WiDhj9N+GG03RaFy4poJjsDtzf5XwkjDgOeeSXXsgOENSBA0pG/eWY3o9XGRIcLeqfHS
         pHW2ts22TPRs1ra5hjHSqEov/Qw+eMVbMcueZ3mMZA+P7+NDc5eYsAsMVme8AQUKKqgN
         Cfpkb245c7TRWR+rVWSEUYIk1KBXNRIiE/TRkSNy8TZtNiXW5V4gEP87FX/2DodreYcB
         M/rDiCOCjxyhJfLX/aOklf0FK8yTfNrMMEDlP+FCURLVxfr7HRP2DQk6Ke6JsFAq5bqJ
         Nejw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to:user-agent;
        bh=OsOzas/w/eSfqOtHOGgepo3zxkPHG/qg3EkWGzcgIY8=;
        b=sD57vdezXni8rOh4zHo1BIeHATw/d14GscKaAV7dLiNDh+AkTKY4kP0bF8Ck3S2mYl
         IU4WOuvH/XPIkYWzEa5QdIxIfS6PbSQiwbemjtef2P5+R/yjcDcGyQCRU3Q8QUvLUOsA
         qW05ea2LJv3fDbzHF06VN9+twdrgntVArzh2Qld5JfWAKjfn/K0lwENUmu0cy4YMoKLo
         IXKzT8C4SpSHPAxl3kqtgM6SWUVTcRXJto59MYHwwXy4xAnfHPH+FyzGzjaxNNduwSeR
         NZ84by2u9AZrirWR/mehRZIdItdDwLYO3DrEUMUwYlrZ9hZLPcquYRz+h+9RjV97D1tH
         aJ5Q==
X-Gm-Message-State: AOAM532EtyOZkg2TnhANbrOxNLLLOJLIK8uxXsUucfjfdxx4kSo5gGxx
        2XOy0hQw58gY8Byt8WbInU8=
X-Google-Smtp-Source: ABdhPJzHeFoP5KZ4/1PKPsAcS1CL9F0trZ83qjPMopC7aPN6AW/HZ02O8UE++K+AEq681Fu5ROling==
X-Received: by 2002:a1c:6208:: with SMTP id w8mr2068448wmb.96.1608106697688;
        Wed, 16 Dec 2020 00:18:17 -0800 (PST)
Received: from gmail.com ([81.168.73.77])
        by smtp.gmail.com with ESMTPSA id i16sm1908890wrx.89.2020.12.16.00.18.16
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 16 Dec 2020 00:18:17 -0800 (PST)
Date:   Wed, 16 Dec 2020 08:18:14 +0000
From:   Martin Habets <habetsm.xilinx@gmail.com>
To:     Ivan Babrou <ivan@cloudflare.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, kernel-team@cloudflare.com,
        Edward Cree <ecree.xilinx@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>
Subject: Re: [PATCH net-next] sfc: reduce the number of requested xdp ev
 queues
Message-ID: <20201216081814.jcwq6xzdxur5xm4l@gmail.com>
Mail-Followup-To: Ivan Babrou <ivan@cloudflare.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@cloudflare.com, Edward Cree <ecree.xilinx@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>
References: <20201215012907.3062-1-ivan@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201215012907.3062-1-ivan@cloudflare.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 14, 2020 at 05:29:06PM -0800, Ivan Babrou wrote:
> Without this change the driver tries to allocate too many queues,
> breaching the number of available msi-x interrupts on machines
> with many logical cpus and default adapter settings:
> 
> Insufficient resources for 12 XDP event queues (24 other channels, max 32)
> 
> Which in turn triggers EINVAL on XDP processing:
> 
> sfc 0000:86:00.0 ext0: XDP TX failed (-22)
> 
> Signed-off-by: Ivan Babrou <ivan@cloudflare.com>

Acked-by: Martin Habets <habetsm.xilinx@gmail.com>

> ---
>  drivers/net/ethernet/sfc/efx_channels.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/sfc/efx_channels.c b/drivers/net/ethernet/sfc/efx_channels.c
> index a4a626e9cd9a..1bfeee283ea9 100644
> --- a/drivers/net/ethernet/sfc/efx_channels.c
> +++ b/drivers/net/ethernet/sfc/efx_channels.c
> @@ -17,6 +17,7 @@
>  #include "rx_common.h"
>  #include "nic.h"
>  #include "sriov.h"
> +#include "workarounds.h"
>  
>  /* This is the first interrupt mode to try out of:
>   * 0 => MSI-X
> @@ -137,6 +138,7 @@ static int efx_allocate_msix_channels(struct efx_nic *efx,
>  {
>  	unsigned int n_channels = parallelism;
>  	int vec_count;
> +	int tx_per_ev;
>  	int n_xdp_tx;
>  	int n_xdp_ev;
>  
> @@ -149,9 +151,9 @@ static int efx_allocate_msix_channels(struct efx_nic *efx,
>  	 * multiple tx queues, assuming tx and ev queues are both
>  	 * maximum size.
>  	 */
> -
> +	tx_per_ev = EFX_MAX_EVQ_SIZE / EFX_TXQ_MAX_ENT(efx);
>  	n_xdp_tx = num_possible_cpus();
> -	n_xdp_ev = DIV_ROUND_UP(n_xdp_tx, EFX_MAX_TXQ_PER_CHANNEL);
> +	n_xdp_ev = DIV_ROUND_UP(n_xdp_tx, tx_per_ev);
>  
>  	vec_count = pci_msix_vec_count(efx->pci_dev);
>  	if (vec_count < 0)
> -- 
> 2.29.2

-- 
Martin Habets <habetsm.xilinx@gmail.com>
