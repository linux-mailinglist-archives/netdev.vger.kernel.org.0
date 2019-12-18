Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 888281248D8
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 15:00:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727053AbfLROAn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 09:00:43 -0500
Received: from first.geanix.com ([116.203.34.67]:41276 "EHLO first.geanix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726856AbfLROAn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Dec 2019 09:00:43 -0500
Received: from [192.168.100.95] (unknown [95.138.208.137])
        by first.geanix.com (Postfix) with ESMTPSA id C1D13443;
        Wed, 18 Dec 2019 13:59:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=geanix.com; s=first;
        t=1576677581; bh=kpjl5UVuOS2RgaKkro7UQ+7PFhpkcrQEPc0FaFCHp0c=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To;
        b=dCXOnTUPn/uimvnMaR1SbhLCxitxJD0ShivYjnDsdt1+VMifPpX8BJHUj/M2yZL2N
         mjxkgd+Nbcu4iXPZF27rDfOmJFun3iAQ/nJut4PuACNnjflZXfJtMLUYIwRb6M5oXa
         apdAehEV2gN+ELfRWOFYVlIyQYZCsvI0GppnA9TbyYwEgPZbi/oV26nbC5YKDIuS8a
         KGGyh7w1gVUEgAShVmggmCUydwR3ToRhFH1p+KbLiYIe6SuOGbczgkhjl7AhgXmdrc
         1fTuf7rHg8YKspN6L9cOhsiPaQ+d+fRO+9l2jFqGGpgHSM6KJQX73zdkYr+/sCIPAd
         dpdF4xXoAIWmw==
Subject: Re: [PATCH V2 1/2] can: flexcan: disable runtime PM if register
 flexcandev failed
To:     Joakim Zhang <qiangqing.zhang@nxp.com>,
        "mkl@pengutronix.de" <mkl@pengutronix.de>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>
Cc:     dl-linux-imx <linux-imx@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <20191210085721.9853-1-qiangqing.zhang@nxp.com>
From:   Sean Nyekjaer <sean@geanix.com>
Message-ID: <d51c46d8-33fa-a4e3-8626-ba3622bab7ee@geanix.com>
Date:   Wed, 18 Dec 2019 15:00:39 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20191210085721.9853-1-qiangqing.zhang@nxp.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US-large
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.1 required=4.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,URIBL_BLOCKED
        autolearn=disabled version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on 8b5b6f358cc9
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/12/2019 10.00, Joakim Zhang wrote:
> Had better disable runtime PM if register flexcandev failed.
> 
> Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
Tested-by: Sean Nyekjaer <sean@geanix.com>
> ------
> ChangeLog:
> 	V1->V2: *no change.
> ---
>   drivers/net/can/flexcan.c | 2 ++
>   1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
> index 3a754355ebe6..6c1ccf9f6c08 100644
> --- a/drivers/net/can/flexcan.c
> +++ b/drivers/net/can/flexcan.c
> @@ -1681,6 +1681,8 @@ static int flexcan_probe(struct platform_device *pdev)
>   	return 0;
>   
>    failed_register:
> +	pm_runtime_put_noidle(&pdev->dev);
> +	pm_runtime_disable(&pdev->dev);
>   	free_candev(dev);
>   	return err;
>   }
> 
