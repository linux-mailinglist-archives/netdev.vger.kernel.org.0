Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B79E36EC48
	for <lists+netdev@lfdr.de>; Thu, 29 Apr 2021 16:22:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240110AbhD2OW4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Apr 2021 10:22:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235277AbhD2OWz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Apr 2021 10:22:55 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5843CC06138B;
        Thu, 29 Apr 2021 07:22:09 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id k14so17214120wrv.5;
        Thu, 29 Apr 2021 07:22:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=qDWlTWZN3YRYxgpxukOp3NqceBd1We39+J5PingM1kw=;
        b=V3GKt1Y2QrlJVQqxNA27KIVl/j9xHN51tKLu1hVtuTo/97E8TnGBanQiq35H5PmpbX
         UW+IV242Bi3McG8gOfuYhdZjy1jl9YwgPH4MMzlRsgZAoBTMsWl89zFbADvSO6Nlrpgx
         mYJBP7PlxCEFCi9XxiyS2l+JwlVXkP8yzErGRFGv9+yAS2AB7owF332pEqr9P6qeAezo
         /kaCHYRQ2UqT3mUstWFHkqwk7er19ijvbuJsb30yKTmfcf8F3ntk7IiucBIKrgqfr7p6
         cMuTY5iSrX9dFx0WBPIurzg39PWkzXrTlkOCinKxS9RVl3LeVrrfg9fJV6wpyxKZByg6
         0EMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qDWlTWZN3YRYxgpxukOp3NqceBd1We39+J5PingM1kw=;
        b=bxODPCrkVovnEvXNCRrwL3n5qQT76Rhoy3YL0QNCyAKP1kky61y4SyWcXKUBZAcOxH
         nmjoTlFWoZxXBQ8M+YXYujIrxdlCRB1aIqXRL472/+RBrC0C0Lm2b70ZzuAdyGFUMmVf
         HRQ5tBlp3UQpUGdfUjI5y1muUfM5C916gZ3NCwJUVBqnHl1NQdHMsJ8LFXX4Ia0rba7p
         nKtCgmPE+bjR/2afLsgBdAhwCN5rcQt5Vg3lRZrkC0YJTMvCreWOcwSEcaQFyF/QrUnF
         MEXEUE+YSYGKEMJgU6El7+e/onUPJEtWbHK2z3l7Ag3k+QN5zzDPx8f821kHegw7LigG
         meVQ==
X-Gm-Message-State: AOAM531+dgS0R9ReoEIoFo6aXktVXaFhpCMe3NAQCxgpz2WaqCQ/3qVG
        SK9QSI/AJtctLTUXTVkljrZSExr5bbCcAA==
X-Google-Smtp-Source: ABdhPJw2A1vmsqY0F3Yn3gwmSWt4UmANo+G+jd0yB9Y/p7/rWIyJ+UIDVp8/gaFchABkQQMljDTxlA==
X-Received: by 2002:a5d:53c9:: with SMTP id a9mr70098wrw.108.1619706128110;
        Thu, 29 Apr 2021 07:22:08 -0700 (PDT)
Received: from [192.168.1.122] (cpc159425-cmbg20-2-0-cust403.5-4.cable.virginm.net. [86.7.189.148])
        by smtp.gmail.com with ESMTPSA id v4sm192184wme.14.2021.04.29.07.22.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Apr 2021 07:22:07 -0700 (PDT)
Subject: Re: [PATCH] sfc: adjust efx->xdp_tx_queue_count with the real number
 of initialized queues
To:     Ignat Korchagin <ignat@cloudflare.com>, habetsm.xilinx@gmail.com,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     kernel-team@cloudflare.com, stable@vger.kernel.org
References: <20210427210938.661700-1-ignat@cloudflare.com>
From:   Edward Cree <ecree.xilinx@gmail.com>
Message-ID: <a56546ee-87a1-f13d-8b2f-25497828f299@gmail.com>
Date:   Thu, 29 Apr 2021 15:22:06 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20210427210938.661700-1-ignat@cloudflare.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 27/04/2021 22:09, Ignat Korchagin wrote:
> efx->xdp_tx_queue_count is initially initialized to num_possible_cpus() and is
> later used to allocate and traverse efx->xdp_tx_queues lookup array. However,
> we may end up not initializing all the array slots with real queues during
> probing. This results, for example, in a NULL pointer dereference, when running
> "# ethtool -S <iface>", similar to below
...
> diff --git a/drivers/net/ethernet/sfc/efx_channels.c b/drivers/net/ethernet/sfc/efx_channels.c
> index 1bfeee283ea9..a3ca406a3561 100644
> --- a/drivers/net/ethernet/sfc/efx_channels.c
> +++ b/drivers/net/ethernet/sfc/efx_channels.c
> @@ -914,6 +914,8 @@ int efx_set_channels(struct efx_nic *efx)
>  			}
>  		}
>  	}
> +	if (xdp_queue_number)
Wait, why is this guard condition needed?
What happens if we had nonzero efx->xdp_tx_queue_count initially, but we end up
 with no TXQs available for XDP at all (so xdp_queue_number == 0)?

-ed
> +		efx->xdp_tx_queue_count = xdp_queue_number;
>  
>  	rc = netif_set_real_num_tx_queues(efx->net_dev, efx->n_tx_channels);
>  	if (rc)
> 

