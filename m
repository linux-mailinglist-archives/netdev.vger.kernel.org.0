Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 936FE246852
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 16:27:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728849AbgHQO1r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 10:27:47 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:41488 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728465AbgHQO1q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 Aug 2020 10:27:46 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1597674465; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=6e6Bqrm2jR07xHEe5aaNgE6JVEUspYK2v6jUh9M+BAk=; b=SYKOmfYArmo3c2YJJlvAnAt/G8xJiIIyqxIZc31fzZwbJ4CMwoWdakEovYlxH2fOGFTOhOPE
 +4RHZgDqQEnA7ETPdbjoz5tHzRNzMf18IlNk+REarLMSfZNbh6wtSddRIu8J8zIx9aMmyMSi
 H3MY8aQWjgB0+pVSO9eS2uJI6pg=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n09.prod.us-east-1.postgun.com with SMTP id
 5f3a93b3247ccc308ca301cd (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 17 Aug 2020 14:26:59
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id BBF7BC433CB; Mon, 17 Aug 2020 14:26:58 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 527C0C433C6;
        Mon, 17 Aug 2020 14:26:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 527C0C433C6
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Tang Bin <tangbin@cmss.chinamobile.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        ath10k@lists.infradead.org,
        Zhang Shengju <zhangshengju@cmss.chinamobile.com>
Subject: Re: [PATCH] ath10k: fix the status check and wrong return
References: <20200814144844.1920-1-tangbin@cmss.chinamobile.com>
Date:   Mon, 17 Aug 2020 17:26:54 +0300
In-Reply-To: <20200814144844.1920-1-tangbin@cmss.chinamobile.com> (Tang Bin's
        message of "Fri, 14 Aug 2020 22:48:44 +0800")
Message-ID: <87y2mdjqkx.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tang Bin <tangbin@cmss.chinamobile.com> writes:

> In the function ath10k_ahb_clock_init(), devm_clk_get() doesn't
> return NULL. Thus use IS_ERR() and PTR_ERR() to validate
> the returned value instead of IS_ERR_OR_NULL().

Why? What's the benefit of this patch? Or what harm does
IS_ERR_OR_NULL() create?

> Signed-off-by: Zhang Shengju <zhangshengju@cmss.chinamobile.com>
> Signed-off-by: Tang Bin <tangbin@cmss.chinamobile.com>
> ---
>  drivers/net/wireless/ath/ath10k/ahb.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath10k/ahb.c b/drivers/net/wireless/ath/ath10k/ahb.c
> index ed87bc00f..ea669af6a 100644
> --- a/drivers/net/wireless/ath/ath10k/ahb.c
> +++ b/drivers/net/wireless/ath/ath10k/ahb.c
> @@ -87,24 +87,24 @@ static int ath10k_ahb_clock_init(struct ath10k *ar)
>  	dev = &ar_ahb->pdev->dev;
>  
>  	ar_ahb->cmd_clk = devm_clk_get(dev, "wifi_wcss_cmd");
> -	if (IS_ERR_OR_NULL(ar_ahb->cmd_clk)) {
> +	if (IS_ERR(ar_ahb->cmd_clk)) {
>  		ath10k_err(ar, "failed to get cmd clk: %ld\n",
>  			   PTR_ERR(ar_ahb->cmd_clk));
> -		return ar_ahb->cmd_clk ? PTR_ERR(ar_ahb->cmd_clk) : -ENODEV;
> +		return PTR_ERR(ar_ahb->cmd_clk);
>  	}

devm_clk_get() can return NULL if CONFIG_HAVE_CLK is disabled:

static inline struct clk *devm_clk_get(struct device *dev, const char *id)
{
	return NULL;
}

-- 
https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
