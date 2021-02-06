Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12F45311CA8
	for <lists+netdev@lfdr.de>; Sat,  6 Feb 2021 11:46:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229631AbhBFKos (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Feb 2021 05:44:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbhBFKop (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Feb 2021 05:44:45 -0500
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFE92C06174A;
        Sat,  6 Feb 2021 02:44:04 -0800 (PST)
Received: by mail-wr1-x432.google.com with SMTP id g10so10697261wrx.1;
        Sat, 06 Feb 2021 02:44:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=xFEpllDF6MNsO1AqczcedeO+z4wSQaZT1NtWeiz+bgc=;
        b=RT5xbVswQP5ylNw9crSnReWgiQDEbo4aBxM6hnujbUDTsVzB87EdPRIthroD0xOymX
         wwLJOt7f4PeQx4Xvht03/2l7UWePsnWey23JbTRN2XWMj8Hxf8hZ4vvx1qUSIr+Mi/S/
         Q9XuR5nCDBOthv6nESHVLDaCPI4lxG41ocfb+9emM4944IBRFsG4H0pW60IVgUpfqYnM
         cBKfj+y/QYLTdh920Ie6iR3NfxTZSi49gaWZ+YhTA9QRdBKufys3C58jmx55Ir2PSxrk
         0lhe3HX1tF0c+QTQRLQN/PV/ScIg9D5JwgaUKJXvAEE/nHvCTNe3Ss/DgctxHDVuPbmv
         EYYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to:user-agent;
        bh=xFEpllDF6MNsO1AqczcedeO+z4wSQaZT1NtWeiz+bgc=;
        b=pWNa32+KiumKtJe36TBlMPtUKITnTNjTfOH7L2Px3Oc9ignCDhPNZVfoO2VU+sv5Hq
         DpcEJ2XqX8AX7C0/RDQp/+TuXgTFRDAUNvhHLcPoyjzX8j7ugr+SkOijSU0WAEF6q/f2
         l6/0pKp8cULjG/osggn2q5/NAXHfRzSanW4VjBBm6gLPa9FEdO00oRiB73nECkyz4wBn
         dIPGhhUhGdgtLCzRKW2kN8He/5b8zjoBOiPSdONtDHVeoHTxoKHcVnJMokxXm8ssBaBg
         WyVaIqrTozz0fe9R/yfTwYDnYeLTBaVSrs9NoXKGIIvyXnapwz/t7mCclYoP6pu9AIFd
         ntHg==
X-Gm-Message-State: AOAM530hyRIXauV4ckDnVAT570W6nYmw7TfqSNiske1/OINhs1mjvru2
        0qYN49PkpGL8tRNCY77Kkrk=
X-Google-Smtp-Source: ABdhPJyoj0pjg6BU+8jb78JLyBwPz/rhrgqgJDT4cmirOykWwQnfr/ojzVw0ZbRAVpEYRohji6lNFA==
X-Received: by 2002:a5d:6c66:: with SMTP id r6mr9567421wrz.86.1612608243570;
        Sat, 06 Feb 2021 02:44:03 -0800 (PST)
Received: from gmail.com ([81.168.73.77])
        by smtp.gmail.com with ESMTPSA id z1sm15688206wru.70.2021.02.06.02.44.01
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 06 Feb 2021 02:44:02 -0800 (PST)
Date:   Sat, 6 Feb 2021 10:43:59 +0000
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
Message-ID: <20210206104359.hzvwdty6pqt4u52z@gmail.com>
Mail-Followup-To: Ivan Babrou <ivan@cloudflare.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@cloudflare.com, Edward Cree <ecree.xilinx@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>
References: <20210120212759.81548-1-ivan@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210120212759.81548-1-ivan@cloudflare.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 20, 2021 at 01:27:59PM -0800, Ivan Babrou wrote:
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
