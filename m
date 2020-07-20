Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 533EA226CFE
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 19:15:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730464AbgGTROg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 13:14:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728831AbgGTROf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 13:14:35 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48C40C061794;
        Mon, 20 Jul 2020 10:14:35 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id f5so21056918ljj.10;
        Mon, 20 Jul 2020 10:14:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=zRASbYWI3QCU6glmbpAmqa3993LVW3W4JSyWjFpNXzE=;
        b=TuYUvW7wDgoLGgvNvoyJZzYvosNMBdw0FJXNNotx5jWagckwqOCpQs/NII3wDvglLT
         TGOtQcn2qbiEIzVQDg+Ved7KCEL5b8eS4rVOC29geKJ0Ww0ZTD42SSOY83bpCkpTqISD
         /HbMgdEzQ8pHzyGrgRKrO6FuLQODxeSLZYEiHipz/zYu2vrk5iqX/1y4LtNtr40hUK6f
         eTQJBzSlapYve9vj4QDameWgqzwBRCm1L2oyTc403d+UjzpH6N3wxKka76vEzuooMRcR
         ofiLl8g+dpWIacvMhMybme1Yy2DkSGfJCwbkGbhKygfL9Eax9bdcfQJakh4yw5a5xmQ5
         KKDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zRASbYWI3QCU6glmbpAmqa3993LVW3W4JSyWjFpNXzE=;
        b=GJCYFhX4/5z5572NTxfhXyLvyGiVEHUGxpouV0Rj2HTn+CWEUJIUDKbmiTtI1NIHs6
         2xRey9B1YJhUm0OV/c4muAp+uii7fuIE1ILqc1QeZn5IwFK5ZIfSfjKxv/PZIk78pMlH
         QPwFsJNpRKRIZbsmtzZNzbP92XBeV43MJks7JB+afC/TBUZyrEGb1lSdUCEXLrgGovJA
         hGURDTMYJDmGDl09BkhFU78RagOKkkFY0iNo1SvzjZw8IQCykan6D03Ed5jdgSas3JHA
         aXkF+BMssks+tthl8rb7SRwc0BL4AvItf0DnHngQ6WH8giNc6sRCcp5s3kbnZCnVSl/o
         09YA==
X-Gm-Message-State: AOAM530kbU5Ct6W6J7jEl+dnjb31qg4Qn6czmmENoz+q6y+N9F/9VL1u
        oBusU5rJdSkirBiYiCT/4L7Cd/94IqI=
X-Google-Smtp-Source: ABdhPJwoWCYprZ2pwfnR6mqaEJhhscTDhrWMKtXGm30xJacgJmOtYSZPIUSfU6t2NifNaexznAlbPw==
X-Received: by 2002:a2e:a373:: with SMTP id i19mr10515397ljn.206.1595265273538;
        Mon, 20 Jul 2020 10:14:33 -0700 (PDT)
Received: from wasted.omprussia.ru ([2a00:1fa0:46f5:8d4:6fdd:f49:d446:d065])
        by smtp.gmail.com with ESMTPSA id w4sm3338334ljw.16.2020.07.20.10.14.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Jul 2020 10:14:32 -0700 (PDT)
Subject: Re: [PATCH/RFC v2] net: ethernet: ravb: exit if hardware is
 in-progress in tx timeout
To:     Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        davem@davemloft.net, kuba@kernel.org
Cc:     dirk.behme@de.bosch.com, Shashikant.Suguni@in.bosch.com,
        netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org
References: <1595246298-29260-1-git-send-email-yoshihiro.shimoda.uh@renesas.com>
From:   Sergei Shtylyov <sergei.shtylyov@gmail.com>
Message-ID: <7d37c358-fab9-8ec1-6fff-688d33898b09@gmail.com>
Date:   Mon, 20 Jul 2020 20:14:31 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1595246298-29260-1-git-send-email-yoshihiro.shimoda.uh@renesas.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello!

On 7/20/20 2:58 PM, Yoshihiro Shimoda wrote:

> According to the report of [1], this driver is possible to cause
> the following error in ravb_tx_timeout_work().
> 
> ravb e6800000.ethernet ethernet: failed to switch device to config mode

   Hmm, maybe we need a larger timeout there? The current one amounts to only
~100 ms for all cases (maybe we should parametrize the timeout?)...
  
> This error means that the hardware could not change the state
> from "Operation" to "Configuration" while some tx and/or rx queue
> are operating. After that, ravb_config() in ravb_dmac_init() will fail,

   Are we seeing double messages from ravb_config()? I think we aren't...

> and then any descriptors will be not allocaled anymore so that NULL
> pointer dereference happens after that on ravb_start_xmit().
> 
> To fix the issue, the ravb_tx_timeout_work() should check
> the return value of ravb_stop_dma() whether this hardware can be
> re-initialized or not. If ravb_stop_dma() fails, ravb_tx_timeout_work()
> re-enables TX and RX and just exits.
> 
> [1]
> https://lore.kernel.org/linux-renesas-soc/20200518045452.2390-1-dirk.behme@de.bosch.com/
> 
> Reported-by: Dirk Behme <dirk.behme@de.bosch.com>
> Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>

   Assuming the comment below is fixed:

Reviewed-by: Sergei Shtylyov <sergei.shtylyov@gmail.com>

> ---
>  Changes from RFC v1:
>  - Check the return value of ravb_stop_dma() and exit if the hardware
>    condition can not be initialized in the tx timeout.
>  - Update the commit subject and description.
>  - Fix some typo.
>  https://patchwork.kernel.org/patch/11570217/
> 
>  Unfortunately, I still didn't reproduce the issue yet. So, I still
>  marked RFC on this patch.

    I think the Bosch people should test this patch, as they reported the kernel oops...

> 
>  drivers/net/ethernet/renesas/ravb_main.c | 14 +++++++++++++-
>  1 file changed, 13 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
> index a442bcf6..500f5c1 100644
> --- a/drivers/net/ethernet/renesas/ravb_main.c
> +++ b/drivers/net/ethernet/renesas/ravb_main.c
> @@ -1458,7 +1458,18 @@ static void ravb_tx_timeout_work(struct work_struct *work)
>  		ravb_ptp_stop(ndev);
>  
>  	/* Wait for DMA stopping */
> -	ravb_stop_dma(ndev);
> +	if (ravb_stop_dma(ndev)) {
> +		/* If ravb_stop_dma() fails, the hardware is still in-progress
> +		 * as "Operation" mode for TX and/or RX. So, this should not

   s/in-progress as "Operation" mode/operating/.

> +		 * call the following functions because ravb_dmac_init() is
> +		 * possible to fail too. Also, this should not retry
> +		 * ravb_stop_dma() again and again here because it's possible
> +		 * to wait forever. So, this just re-enables the TX and RX and
> +		 * skip the following re-initialization procedure.
> +		 */
> +		ravb_rcv_snd_enable(ndev);
> +		goto out;
> +	}
>  
>  	ravb_ring_free(ndev, RAVB_BE);
>  	ravb_ring_free(ndev, RAVB_NC);
> @@ -1467,6 +1478,7 @@ static void ravb_tx_timeout_work(struct work_struct *work)
>  	ravb_dmac_init(ndev);

   BTW, that one also may fail...

>  	ravb_emac_init(ndev);
>  
> +out:
>  	/* Initialise PTP Clock driver */
>  	if (priv->chip_id == RCAR_GEN2)
>  		ravb_ptp_init(ndev, priv->pdev);
> 

