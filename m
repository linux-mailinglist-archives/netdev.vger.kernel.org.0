Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 717E62F45A3
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 09:00:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726475AbhAMH6f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 02:58:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726355AbhAMH6e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jan 2021 02:58:34 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7298C0617A2
        for <netdev@vger.kernel.org>; Tue, 12 Jan 2021 23:57:53 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id d4so620514plh.5
        for <netdev@vger.kernel.org>; Tue, 12 Jan 2021 23:57:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Ag+62l7FscdCqShN85Yyg8UEbvTrunYmqAUNYOOMZaU=;
        b=ScG6kcaYOyomiKjOExW4auylmfaUmWTsiyUx8XQdkjk39c3EFYUMGWckr/PsIPFrkK
         a4q7wEp7i/TSgDx2TAFetHzdGkIoF298gGW6DTS049jtRL7x2eUPky0HzM4z9rSQuOhc
         PbqkxaKGgv3Awqn+9gxoX85x833z4S2sxaSiGvYAZZhtdjouLm4mzmotdTH0iHwtGn08
         2kpKKgiQ4SsE/kYfN4la3lU1e/B/sFFXth/fWI6N6rSF+/TaXrMbF3b09MhcOXdtwnAI
         7OhpeB9Dbiip8EnocrY2D3e8lNbu9bszgWAfy8xdLTG8aqXZM5wcvrStfTN8+fDImIRT
         kSQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Ag+62l7FscdCqShN85Yyg8UEbvTrunYmqAUNYOOMZaU=;
        b=BZx8L9hRITGyoFrBPpXY81IjFJmwkTHE37TcSfR/iWJRuZXuWU8xSOMj7SuEL0M6CF
         mKK9md2q5ZlvGBU/VghmIVTECIVZZmlrCrxd2YwcYIoQdT/QBbkUeNoBTDU5MHwkKyi3
         +YVMjV8DpADWaxlGyjjntBoBtnxRsdySbQ9DX8F+5Mx/8rAkvfDHiJ3tBtxFvq3Q4QUq
         3rYJLFFqElU+jUxYuamGQbN7F5zOs/rFyt3iEQt7ATTfis2U0ldE/RLt7T4exGYHoI9y
         4S16kEpvUCgTZgy9teRw47fmPVUE1KrMr4TE4wyfENnORl7+Hrjkk234ctPapnEaXQvv
         3LlA==
X-Gm-Message-State: AOAM531JvvTWl0sdE1zYESRiPTh7/iXm7IQ9acxGu/wx5gyey5MOk76X
        n/NXUEKfeH1KbVF0iJOEbBBP
X-Google-Smtp-Source: ABdhPJzu/imbhYQOZBtY7gE6mBGdu17tt8EdtBeYAkmNu0v4xUipVh2ZHucbn6ns2Iq16EGDav71Pg==
X-Received: by 2002:a17:902:59c7:b029:de:25e7:2426 with SMTP id d7-20020a17090259c7b02900de25e72426mr927294plj.21.1610524672844;
        Tue, 12 Jan 2021 23:57:52 -0800 (PST)
Received: from thinkpad ([2409:4072:6199:4cc7:6c7e:de01:2568:5545])
        by smtp.gmail.com with ESMTPSA id gz2sm1579005pjb.2.2021.01.12.23.57.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jan 2021 23:57:52 -0800 (PST)
Date:   Wed, 13 Jan 2021 13:27:37 +0530
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     Qinglang Miao <miaoqinglang@huawei.com>
Cc:     Marc Kleine-Budde <mkl@pengutronix.de>,
        Thomas Kopp <thomas.kopp@microchip.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] can: mcp251xfd: fix wrong check in
 mcp251xfd_handle_rxif_one
Message-ID: <20210113075737.GA3763@thinkpad>
References: <20210113073100.79552-1-miaoqinglang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210113073100.79552-1-miaoqinglang@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 13, 2021 at 03:31:00PM +0800, Qinglang Miao wrote:
> If alloc_canfd_skb returns NULL, 'cfg' is an uninitialized
> variable, so we should check 'skb' rather than 'cfd' after
> calling alloc_canfd_skb(priv->ndev, &cfd).
> 
> Fixes: 55e5b97f003e ("can: mcp25xxfd: add driver for Microchip MCP25xxFD SPI CAN")
> Signed-off-by: Qinglang Miao <miaoqinglang@huawei.com>

Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

Thanks,
Mani

> ---
>  drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c b/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
> index 77129d5f4..792d55ba4 100644
> --- a/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
> +++ b/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
> @@ -1492,7 +1492,7 @@ mcp251xfd_handle_rxif_one(struct mcp251xfd_priv *priv,
>  	else
>  		skb = alloc_can_skb(priv->ndev, (struct can_frame **)&cfd);
>  
> -	if (!cfd) {
> +	if (!skb) {
>  		stats->rx_dropped++;
>  		return 0;
>  	}
> -- 
> 2.23.0
> 
