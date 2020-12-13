Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 682722D8D16
	for <lists+netdev@lfdr.de>; Sun, 13 Dec 2020 13:26:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406666AbgLMMXv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Dec 2020 07:23:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406648AbgLMMXu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Dec 2020 07:23:50 -0500
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FDE2C0613CF
        for <netdev@vger.kernel.org>; Sun, 13 Dec 2020 04:23:10 -0800 (PST)
Received: by mail-wm1-x343.google.com with SMTP id v14so11328394wml.1
        for <netdev@vger.kernel.org>; Sun, 13 Dec 2020 04:23:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=VpNaJIF1gVm7wAAIVm6axPOkrQe+rV4XZ7Wh+XSF2ko=;
        b=K3+g7uu0rD19U9j6l3Vy5kog46jb6SeXMF9/S/pfzzAoovBvJdtLTQ6JbZQRi+tldp
         +Zy06GzPuY8rXRaBKRndv25k05gTCjKPImLXaBB5/pAepq81sPmGQvZZTJUZkGjSjLr1
         jrMKiy1XQ9Sv0s2Dh9ZrQzA1e8hypa0SpDaVaQrWTWTnnMYh2xTrCmoD6w+pl90uTCeL
         WEO4UUyTtxt3bz7OZ/ADXywvX8A3bgtyb+t2eHAVRv3tPf6ZFBtmfE4fA52Nk5Eeli2s
         GcZ4zcUKviUX8Hb+1rK6cCjroqdzy38XL6/E1F/fVijH7Pb7VHKpqqAXQTzAqOzXw7Qq
         /Pwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to:user-agent;
        bh=VpNaJIF1gVm7wAAIVm6axPOkrQe+rV4XZ7Wh+XSF2ko=;
        b=naiv90R7WVI4voNUFMQj8HmzTKwMz0NE6Ku7RAj5GbFzRDjA/25mn70Rx+tdPpmx2+
         2LqwbOezSYwpdQWDVdS0UQiShYXKtOPWuK1xf057q80H1XKqb8glZP1y53N/gghwFPwW
         Wrh4f71i7nQRi/+zvuV0QeOfA2B8AU7BRVbV5I7ELasF/BfLd06gEaCZae6KRPBsDt8y
         6E1TjJwIfW5o4EOk8j6Pp3GXdcOmbQSM6KUDY74a7rTSRbcu6knSAlC8CbYD/Rxzdcvd
         P3BJCAma2yyGxYuXDydae0U0mOJPvIh/RBxB0xcYHyyuqw/snnMgMJTrV0rEDfnOSqtF
         8RDQ==
X-Gm-Message-State: AOAM530ustJS1C9F+keTHvICpUyJhprazgWWbzx3pr6Sb33dXRmrm+Wt
        IOe4aw328de78e7L02RKQGo=
X-Google-Smtp-Source: ABdhPJxN49MtKiyCtH8f2aSmZEKkOfwFV/yJni+cmaAvRZuJxVslqRey0nHDFfLXjW0ubO531DRDaA==
X-Received: by 2002:a1c:2d8a:: with SMTP id t132mr23190011wmt.128.1607862188809;
        Sun, 13 Dec 2020 04:23:08 -0800 (PST)
Received: from gmail.com ([81.168.73.77])
        by smtp.gmail.com with ESMTPSA id q15sm25585127wrw.75.2020.12.13.04.23.07
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 13 Dec 2020 04:23:08 -0800 (PST)
Date:   Sun, 13 Dec 2020 12:23:05 +0000
From:   Martin Habets <habetsm.xilinx@gmail.com>
To:     Ivan Babrou <ivan@cloudflare.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        kernel-team <kernel-team@cloudflare.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next] sfc: backport XDP EV queue sharing from the
 out-of-tree driver
Message-ID: <20201213122305.kpg5tb6dppq3ow42@gmail.com>
Mail-Followup-To: Ivan Babrou <ivan@cloudflare.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        kernel-team <kernel-team@cloudflare.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
References: <CABWYdi0+PRk8h-Az=b3GqNDO=m6RZgqDL27tgwo3yMK_05OLAw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABWYdi0+PRk8h-Az=b3GqNDO=m6RZgqDL27tgwo3yMK_05OLAw@mail.gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 10, 2020 at 04:18:53PM -0800, Ivan Babrou wrote:
> Queue sharing behaviour already exists in the out-of-tree sfc driver,
> available under xdp_alloc_tx_resources module parameter.

This comment is not relevant for in-tree patches. I'd also like to
make clear that we never intend to upstream any module parameters.

> This avoids the following issue on machines with many cpus:
> 
> Insufficient resources for 12 XDP event queues (24 other channels, max 32)
> 
> Which in turn triggers EINVAL on XDP processing:
> 
> sfc 0000:86:00.0 ext0: XDP TX failed (-22)

The code changes themselves are good.
The real limit that is hit here is with the number of MSI-X interrupts.
Reducing the number of event queues needed also reduces the number of
interrupts required, so this is a good thing.
Another way to get around this issue is to increase the number of
MSI-X interrupts allowed bu the NIC using the sfboot tool.

Best regards,
Martin

> Signed-off-by: Ivan Babrou <ivan@cloudflare.com>
> ---
>  drivers/net/ethernet/sfc/efx_channels.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/sfc/efx_channels.c
> b/drivers/net/ethernet/sfc/efx_channels.c
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
>   unsigned int n_channels = parallelism;
>   int vec_count;
> + int tx_per_ev;
>   int n_xdp_tx;
>   int n_xdp_ev;
> 
> @@ -149,9 +151,9 @@ static int efx_allocate_msix_channels(struct efx_nic *efx,
>   * multiple tx queues, assuming tx and ev queues are both
>   * maximum size.
>   */
> -
> + tx_per_ev = EFX_MAX_EVQ_SIZE / EFX_TXQ_MAX_ENT(efx);
>   n_xdp_tx = num_possible_cpus();
> - n_xdp_ev = DIV_ROUND_UP(n_xdp_tx, EFX_MAX_TXQ_PER_CHANNEL);
> + n_xdp_ev = DIV_ROUND_UP(n_xdp_tx, tx_per_ev);
> 
>   vec_count = pci_msix_vec_count(efx->pci_dev);
>   if (vec_count < 0)
> --
> 2.29.2

-- 
Martin Habets <habetsm.xilinx@gmail.com>
