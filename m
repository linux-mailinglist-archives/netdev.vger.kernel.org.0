Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FFEB1F9AD9
	for <lists+netdev@lfdr.de>; Mon, 15 Jun 2020 16:51:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730637AbgFOOvU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jun 2020 10:51:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730565AbgFOOvT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jun 2020 10:51:19 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53AB5C061A0E
        for <netdev@vger.kernel.org>; Mon, 15 Jun 2020 07:51:19 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id f185so15137036wmf.3
        for <netdev@vger.kernel.org>; Mon, 15 Jun 2020 07:51:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=SODCNVj36cZ8E6crrEPHTef7Q60DB1EXFszRkCsani8=;
        b=2CExaOcVtXojsFho7pktHVPNKRfpCxb+pcEckuQuVRI5klTcBy8EYgwGqiV4TzswgA
         J+RrI2sTteS6VDfjvGvvUVdsUjzURD4L8MhpA6zyZRqJyJLNmCT64InCDPOsW7f8YA6V
         ncRwVgj9ZaiuMIeL8alzWOKq8FB+Ao/WdIKBKeqJr1htZoGzT7qZXIJbg5oOVokU2azK
         3n78OoJ8Fgmf8D6h3Rr4sHMmUKaIZu97PGiIT2k7aCkXU2GTIcUpscOErHjdcgUilFEI
         mpZTYEr9Lai262qpMN55Wlxf5y7ZO6dp1aLLjx7g4btbXP8l+R7U/DRxlcHLp0zdFiFD
         DD7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=SODCNVj36cZ8E6crrEPHTef7Q60DB1EXFszRkCsani8=;
        b=D6dP6HvM51+gyqBTPVypjMFiCxGadgHdqOzMOOgO1/upz9aUKeFh7uSKEiqozyXg+W
         jwY7TNU4ZFkepQd5/bEsxVIdOit2zLh8fH8Wstv2Pf3wJSDealGn/JFd69ZRXI9pfXo2
         ncXNh8XIbZXhW6o0wV7WfRt05W1Juhvq5OrZ1XJrTiQRjgtiVnOQTHEa1YHgRlN2eCFl
         NrKcEScDEcFxLcLVPGXMUU4IDxFTc1z6kKQeRt0Feeo45NhS0uml3f8Zju2UvlzVRVYl
         kmBAbsubybDs2/F1GjlcCAa3Vh6YbyWDM4WLCQ2aUZ99C2Wi4CCr+Ya9uaQ5acid6bi9
         awIQ==
X-Gm-Message-State: AOAM5306yRp1e5izZJuv1Vv1+lm6kJIdgcr846qO/kh1RC6wGbCFvsmu
        VC56u7MDMATVr3ib/WOKDN+oDA==
X-Google-Smtp-Source: ABdhPJzN8kmlF73V9EHcxDHlEvqsJj6dgvAkFQGqsO2iswQaIGfHCsfSu4NdAKicu9baouvx6HPHOw==
X-Received: by 2002:a1c:9804:: with SMTP id a4mr13392322wme.109.1592232678071;
        Mon, 15 Jun 2020 07:51:18 -0700 (PDT)
Received: from Red ([2a01:cb1d:3d5:a100:2e56:dcff:fed2:c6d6])
        by smtp.googlemail.com with ESMTPSA id q5sm24693834wrm.62.2020.06.15.07.51.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Jun 2020 07:51:17 -0700 (PDT)
Date:   Mon, 15 Jun 2020 16:51:15 +0200
From:   LABBE Corentin <clabbe@baylibre.com>
To:     Charles Keepax <ckeepax@opensource.cirrus.com>
Cc:     davem@davemloft.net, nicolas.ferre@microchip.com, kuba@kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] net: macb: Only disable NAPI on the actual error path
Message-ID: <20200615145115.GA23038@Red>
References: <20200615131854.12187-1-ckeepax@opensource.cirrus.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200615131854.12187-1-ckeepax@opensource.cirrus.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 15, 2020 at 02:18:54PM +0100, Charles Keepax wrote:
> A recent change added a disable to NAPI into macb_open, this was
> intended to only happen on the error path but accidentally applies
> to all paths. This causes NAPI to be disabled on the success path, which
> leads to the network to no longer functioning.
> 
> Fixes: 014406babc1f ("net: cadence: macb: disable NAPI on error")
> Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
> ---
>  drivers/net/ethernet/cadence/macb_main.c | 9 ++++-----
>  1 file changed, 4 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
> index 5b9d7c60eebc0..67933079aeea5 100644
> --- a/drivers/net/ethernet/cadence/macb_main.c
> +++ b/drivers/net/ethernet/cadence/macb_main.c
> @@ -2565,15 +2565,14 @@ static int macb_open(struct net_device *dev)
>  	if (bp->ptp_info)
>  		bp->ptp_info->ptp_init(dev);
>  
> +	return 0;
> +
>  napi_exit:
>  	for (q = 0, queue = bp->queues; q < bp->num_queues; ++q, ++queue)
>  		napi_disable(&queue->napi);
>  pm_exit:
> -	if (err) {
> -		pm_runtime_put_sync(&bp->pdev->dev);
> -		return err;
> -	}
> -	return 0;
> +	pm_runtime_put_sync(&bp->pdev->dev);
> +	return err;
>  }
>  
>  static int macb_close(struct net_device *dev)
> -- 
> 2.11.0
> 

Shame on me to not have see this.

With the fix it works.
Tested-by: Corentin Labbe <clabbe@baylibre.com>
Tested-on: qemu-xilinx-zynq-a9
