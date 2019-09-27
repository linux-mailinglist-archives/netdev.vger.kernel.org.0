Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F450C0C55
	for <lists+netdev@lfdr.de>; Fri, 27 Sep 2019 22:01:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727093AbfI0UBN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Sep 2019 16:01:13 -0400
Received: from proxima.lasnet.de ([78.47.171.185]:51977 "EHLO
        proxima.lasnet.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725802AbfI0UBN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Sep 2019 16:01:13 -0400
Received: from localhost.localdomain (p200300E9D742D296A393C26E681B47E6.dip0.t-ipconnect.de [IPv6:2003:e9:d742:d296:a393:c26e:681b:47e6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: stefan@datenfreihafen.org)
        by proxima.lasnet.de (Postfix) with ESMTPSA id 890E7C1B22;
        Fri, 27 Sep 2019 22:01:10 +0200 (CEST)
Subject: Re: [PATCH] ieee802154: ca8210: prevent memory leak
To:     Navid Emamdoost <navid.emamdoost@gmail.com>
Cc:     emamd001@umn.edu, smccaman@umn.edu, kjlu@umn.edu,
        Harry Morris <h.morris@cascoda.com>,
        Alexander Aring <alex.aring@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wpan@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20190917224713.26371-1-navid.emamdoost@gmail.com>
From:   Stefan Schmidt <stefan@datenfreihafen.org>
Message-ID: <cda67450-267f-3c94-68b6-73ea8c4dfe2f@datenfreihafen.org>
Date:   Fri, 27 Sep 2019 22:01:08 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.0
MIME-Version: 1.0
In-Reply-To: <20190917224713.26371-1-navid.emamdoost@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello.

On 18.09.19 00:47, Navid Emamdoost wrote:
> In ca8210_probe the allocated pdata needs to be assigned to
> spi_device->dev.platform_data before calling ca8210_get_platform_data.
> Othrwise when ca8210_get_platform_data fails pdata cannot be released.
> 
> Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
> ---
>   drivers/net/ieee802154/ca8210.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ieee802154/ca8210.c b/drivers/net/ieee802154/ca8210.c
> index b188fce3f641..229d70a897ca 100644
> --- a/drivers/net/ieee802154/ca8210.c
> +++ b/drivers/net/ieee802154/ca8210.c
> @@ -3152,12 +3152,12 @@ static int ca8210_probe(struct spi_device *spi_device)
>   		goto error;
>   	}
>   
> +	priv->spi->dev.platform_data = pdata;
>   	ret = ca8210_get_platform_data(priv->spi, pdata);
>   	if (ret) {
>   		dev_crit(&spi_device->dev, "ca8210_get_platform_data failed\n");
>   		goto error;
>   	}
> -	priv->spi->dev.platform_data = pdata;
>   
>   	ret = ca8210_dev_com_init(priv);
>   	if (ret) {
> 

As Harry seems to be unavailable I am taking this patch directly.


This patch has been applied to the wpan tree and will be
part of the next pull request to net. Thanks!

regards
Stefan Schmidt
