Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41A6C226957
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 18:30:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732513AbgGTQBT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 12:01:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732504AbgGTQBQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 12:01:16 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BBD1C0619D2;
        Mon, 20 Jul 2020 09:01:16 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id d7so91827plq.13;
        Mon, 20 Jul 2020 09:01:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=blhYAOxQCphYO3jI+YeVotO7czKJYFL74Ds0qrEVcIc=;
        b=fWrhvXKAg1kJChsxZ1jYIUSTKtg4gaaEQr5sl+NGPsKkCdDrgp83AO1GIKz4DuZGhE
         KGH7Q8vahRQI/SxukHnIsj9ps1FiAhvX2ZafHZE3uW7fltcpqOsH2pV+vKQNCVgZFxND
         cKFkJh9reCXNTEXlUVGy5DlKupLJNCDqefq2S5AF5yN2Cc5XZQpsRFigdijhyMpLltqy
         y/fKQs4YYznv7ieD7x3qJUwRV0dBkU9EjUaUC45nrnyOjDePQ74zxkCOGIEEVvaI3rHk
         ndrCU6p1a0DYlMWliEV5CVyVO/N0sSO7qzqMd/SKZbh4YwHiSYLKRU3klEEp4bSr20oG
         DCRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=blhYAOxQCphYO3jI+YeVotO7czKJYFL74Ds0qrEVcIc=;
        b=pzo4cY22iygPhhewLaWmPwxsR9tWZMV/2aDf9smxrV0wShSD8uTZs+2VgnpRVHDmJI
         i73iUhmWrb++QRsOXkJ0LBDxIY3h8Ts+lJgNYJDLk7+08M5+ItunoA4VIQRrA42Rhrnn
         5ZEya43tCaIxC5foLM+cL3jDm4Y1iP2/nAWmymyE0iaMw7d08KvmOrQfTJxRiyDZeW+L
         yrX07l38EOlkqGtFqeYfDN6wxPL2cqkYOsGOnEzmqFPWeyaO9TZVLZl0vX8gaVY6Syw1
         yw12fDWAlYfIonmOUyMFMtxPRTien4OnCEFDl8qM10r05H4JUsvEB+zZ59VgBqLobMJz
         EMJg==
X-Gm-Message-State: AOAM533lbQjQkwz9L04q80vrZ1/sMNp6AJpI7n4HW8DD/0iBfA0nv/35
        HSIZo7bQyuAaXYyxL9xps1tlVr4wOLA=
X-Google-Smtp-Source: ABdhPJykF07itmKHQRGZ+7zqDGPw/ug1gO4hOMWPJh1NTIHSGdsUBYkFE4J79KpNyZsOyW09xbvz6w==
X-Received: by 2002:a17:90a:d30e:: with SMTP id p14mr45550pju.173.1595260875400;
        Mon, 20 Jul 2020 09:01:15 -0700 (PDT)
Received: from [192.168.219.16] (ip72-219-184-175.oc.oc.cox.net. [72.219.184.175])
        by smtp.gmail.com with ESMTPSA id x23sm17040539pfn.4.2020.07.20.09.01.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Jul 2020 09:01:14 -0700 (PDT)
Subject: Re: [PATCH net] net: bcmgenet: fix error returns in bcmgenet_probe()
To:     Zhang Changzhong <zhangchangzhong@huawei.com>,
        f.fainelli@gmail.com, davem@davemloft.net, kuba@kernel.org
Cc:     bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1595229523-9725-1-git-send-email-zhangchangzhong@huawei.com>
From:   Doug Berger <opendmb@gmail.com>
Message-ID: <08bdec5c-b62c-07b3-35c1-9dd15478de81@gmail.com>
Date:   Mon, 20 Jul 2020 09:04:15 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1595229523-9725-1-git-send-email-zhangchangzhong@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/20/2020 12:18 AM, Zhang Changzhong wrote:
> The driver forgets to call clk_disable_unprepare() in error path after
> a success calling for clk_prepare_enable().
> 
> Fix to goto err_clk_disable if clk_prepare_enable() is successful.
> 
> Fixes: 99d55638d4b0 ("net: bcmgenet: enable NETIF_F_HIGHDMA flag")
> Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
> ---
>  drivers/net/ethernet/broadcom/genet/bcmgenet.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
> index 368e05b..903811e 100644
> --- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
> +++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
> @@ -3988,7 +3988,7 @@ static int bcmgenet_probe(struct platform_device *pdev)
>  	if (err)
>  		err = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32));
>  	if (err)
> -		goto err;
> +		goto err_clk_disable;
>  
>  	/* Mii wait queue */
>  	init_waitqueue_head(&priv->wq);
> 
Acked-by: Doug Berger <opendmb@gmail.com>

Thanks!
