Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 579516CA21
	for <lists+netdev@lfdr.de>; Thu, 18 Jul 2019 09:42:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389214AbfGRHlP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jul 2019 03:41:15 -0400
Received: from metis.ext.pengutronix.de ([85.220.165.71]:46313 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726397AbfGRHlP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jul 2019 03:41:15 -0400
Received: from soja.hi.pengutronix.de ([2001:67c:670:100:3ad5:47ff:feaf:13da])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <o.rempel@pengutronix.de>)
        id 1ho12Q-00032b-3M; Thu, 18 Jul 2019 09:41:14 +0200
Subject: Re: [PATCH] net: ethernet: fix error return code in ag71xx_probe()
To:     Wei Yongjun <weiyongjun1@huawei.com>,
        Jay Cliburn <jcliburn@gmail.com>,
        Chris Snook <chris.snook@gmail.com>
Cc:     netdev@vger.kernel.org, kernel-janitors@vger.kernel.org
References: <20190717115215.22965-1-weiyongjun1@huawei.com>
From:   Oleksij Rempel <o.rempel@pengutronix.de>
Message-ID: <ec4fb148-7260-a89d-eaa2-b5bb7c01c530@pengutronix.de>
Date:   Thu, 18 Jul 2019 09:41:13 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190717115215.22965-1-weiyongjun1@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:3ad5:47ff:feaf:13da
X-SA-Exim-Mail-From: o.rempel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 17.07.19 13:52, Wei Yongjun wrote:
> Fix to return error code -ENOMEM from the dmam_alloc_coherent() error
> handling case instead of 0, as done elsewhere in this function.
> 
> Fixes: d51b6ce441d3 ("net: ethernet: add ag71xx driver")
> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>

Reviewed-by: Oleksij Rempel <o.rempel@pengutronix.de>

> ---
>   drivers/net/ethernet/atheros/ag71xx.c | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/atheros/ag71xx.c b/drivers/net/ethernet/atheros/ag71xx.c
> index 72a57c6cd254..446d62e93439 100644
> --- a/drivers/net/ethernet/atheros/ag71xx.c
> +++ b/drivers/net/ethernet/atheros/ag71xx.c
> @@ -1724,8 +1724,10 @@ static int ag71xx_probe(struct platform_device *pdev)
>   	ag->stop_desc = dmam_alloc_coherent(&pdev->dev,
>   					    sizeof(struct ag71xx_desc),
>   					    &ag->stop_desc_dma, GFP_KERNEL);
> -	if (!ag->stop_desc)
> +	if (!ag->stop_desc) {
> +		err = -ENOMEM;
>   		goto err_free;
> +	}
>   
>   	ag->stop_desc->data = 0;
>   	ag->stop_desc->ctrl = 0;
> 
> 
> 
> 

Kind regards,
Oleksij Rempel

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
