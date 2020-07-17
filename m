Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF0012241C5
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 19:28:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727883AbgGQR1Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 13:27:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726668AbgGQR1Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jul 2020 13:27:25 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99941C0619D2;
        Fri, 17 Jul 2020 10:27:24 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id f2so11959893wrp.7;
        Fri, 17 Jul 2020 10:27:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Uv/mehhqSy3DaoKMUHPQC+Xg+wYizrO+P1oEDPd1R5Y=;
        b=kVZwjpajXWhE3Tq9GOL4jqxnYJRO/FK2GgA1oiuf6uPwe3ilTYUd/lypogr2w1FeTh
         7CKsOxRqgLV+9kX3EcRSUAt30lIVsC8Q80ilT6qsf/dlwYx6FO0/j571sY+82fx/LrN1
         mN9i4tfWOkCKpg7CBEhefo/WM8z0K0pOQV4ugNnzGILBtnLPn4/kWKHdxk73vDRTuJiH
         BIOK/Mtfnjndb2DLRmo8K23JCcDwWm/4u/Wdn95S34wRy/DpoDTle3nRWcglWq+JPLtw
         nAmHPjjQNRrFDjZPYrs0NWyLbin3Ex8oRhyKG578JBjetfCFHetuWZ7v9cxWcOKXzwk2
         8aAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Uv/mehhqSy3DaoKMUHPQC+Xg+wYizrO+P1oEDPd1R5Y=;
        b=hg30df7w1A1OCWOjvBQBlc8Fma1UDkYTKcq2D1cF6ECwOJsKUtjjqIsX+qwP5jpIHi
         1oH7BMyZtqYPeN1QTw+jeCIv7iLLsN8SvEUbVzHBtJPUPkgDDVpqotzfCrf4feKq1CAN
         rAsPHWM+ACLLN/WGIYrwJ7daqELO1Q6juqH7bfmwYGB5EZKR2lx6oD0H2V4yQ2tOfVGA
         Zx2Xjb9WYnx0of3glS2fjSeoY1xn+sCPzuXfhX4NdsBmVdNyMGJqHNw0RDBuKXizMEre
         ppa92HHA9RD8OFgjZ/HrbyglJ6k3C18pEgvm9ANGxSh6pOEolAmLvVScRGnNVXl2cO/8
         b66w==
X-Gm-Message-State: AOAM532uQQeoWOLaFbEO4Xqko8M3fHYpoYFZkBaDY3+9ZyxgaKaj+bNW
        VjwOmdSBc0yINqivsvJp1neiJ4l3tkQ=
X-Google-Smtp-Source: ABdhPJzuWUhay96eHMlekR318s1wqVyttXpYIA4Tx9T9DkN1wUZXOq9L0CiquPlDvdCkiIjEj26QoQ==
X-Received: by 2002:adf:e801:: with SMTP id o1mr11618071wrm.54.1595006843074;
        Fri, 17 Jul 2020 10:27:23 -0700 (PDT)
Received: from [10.230.191.242] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 33sm17001764wri.16.2020.07.17.10.27.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Jul 2020 10:27:22 -0700 (PDT)
Subject: Re: [PATCH net-next] net: bcmgenet: fix error returns in
 bcmgenet_probe()
To:     Zhang Changzhong <zhangchangzhong@huawei.com>,
        f.fainelli@gmail.com, davem@davemloft.net, kuba@kernel.org
Cc:     bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1594973982-27988-1-git-send-email-zhangchangzhong@huawei.com>
From:   Doug Berger <opendmb@gmail.com>
Message-ID: <8bdd1465-fcaf-4946-3ee9-baeec765247d@gmail.com>
Date:   Fri, 17 Jul 2020 10:30:18 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1594973982-27988-1-git-send-email-zhangchangzhong@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/17/2020 1:19 AM, Zhang Changzhong wrote:
> The driver forgets to call clk_disable_unprepare() in error path after
> a success calling for clk_prepare_enable().
> 
> Fix to goto err_clk_disable if clk_prepare_enable() is successful.
> 
> Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
> ---
>  drivers/net/ethernet/broadcom/genet/bcmgenet.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
> index ee84a26..23df6f2 100644
> --- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
> +++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
> @@ -4016,7 +4016,7 @@ static int bcmgenet_probe(struct platform_device *pdev)
>  	if (err)
>  		err = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32));
>  	if (err)
> -		goto err;
> +		goto err_clk_disable;
Please split this clause out as a separate pull-request with this fixes tag:
Fixes: 99d55638d4b0 ("net: bcmgenet: enable NETIF_F_HIGHDMA flag")

>  
>  	/* Mii wait queue */
>  	init_waitqueue_head(&priv->wq);
> @@ -4028,14 +4028,14 @@ static int bcmgenet_probe(struct platform_device *pdev)
>  	if (IS_ERR(priv->clk_wol)) {
>  		dev_dbg(&priv->pdev->dev, "failed to get enet-wol clock\n");
>  		err = PTR_ERR(priv->clk_wol);
> -		goto err;
> +		goto err_clk_disable;
>  	}
>  
>  	priv->clk_eee = devm_clk_get_optional(&priv->pdev->dev, "enet-eee");
>  	if (IS_ERR(priv->clk_eee)) {
>  		dev_dbg(&priv->pdev->dev, "failed to get enet-eee clock\n");
>  		err = PTR_ERR(priv->clk_eee);
> -		goto err;
> +		goto err_clk_disable;
>  	}
>  
>  	/* If this is an internal GPHY, power it on now, before UniMAC is
> 
Please split these changes into a pull-request with fixes tag:
Fixes: c80d36ff63a5 ("net: bcmgenet: Use devm_clk_get_optional() to get
the clocks")

Resubmit the pull-requests with [PATCH net].
That will make them easier to apply to stable branches.

Otherwise:
Acked-by: Doug Berger <opendmb@gmail.com>

Thanks!
