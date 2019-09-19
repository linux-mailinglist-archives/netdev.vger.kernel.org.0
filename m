Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A9F9B7D4D
	for <lists+netdev@lfdr.de>; Thu, 19 Sep 2019 16:56:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390787AbfISO4q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Sep 2019 10:56:46 -0400
Received: from proxima.lasnet.de ([78.47.171.185]:50660 "EHLO
        proxima.lasnet.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728720AbfISO4q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Sep 2019 10:56:46 -0400
Received: from localhost.localdomain (p200300E9D7197E1C5D26FA1D92192C91.dip0.t-ipconnect.de [IPv6:2003:e9:d719:7e1c:5d26:fa1d:9219:2c91])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: stefan@datenfreihafen.org)
        by proxima.lasnet.de (Postfix) with ESMTPSA id 00C25C11CD;
        Thu, 19 Sep 2019 16:56:43 +0200 (CEST)
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
Message-ID: <5c53dd25-80de-86ce-5072-bdb6a54835bd@datenfreihafen.org>
Date:   Thu, 19 Sep 2019 16:56:43 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190917224713.26371-1-navid.emamdoost@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Harry.

On 18.09.19 00:47, Navid Emamdoost wrote:
> In ca8210_probe the allocated pdata needs to be assigned to
> spi_device->dev.platform_data before calling ca8210_get_platform_data. 
> Othrwise when ca8210_get_platform_data fails pdata cannot be released.
> 
> Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
> ---
>  drivers/net/ieee802154/ca8210.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ieee802154/ca8210.c b/drivers/net/ieee802154/ca8210.c
> index b188fce3f641..229d70a897ca 100644
> --- a/drivers/net/ieee802154/ca8210.c
> +++ b/drivers/net/ieee802154/ca8210.c
> @@ -3152,12 +3152,12 @@ static int ca8210_probe(struct spi_device *spi_device)
>  		goto error;
>  	}
>  
> +	priv->spi->dev.platform_data = pdata;
>  	ret = ca8210_get_platform_data(priv->spi, pdata);
>  	if (ret) {
>  		dev_crit(&spi_device->dev, "ca8210_get_platform_data failed\n");
>  		goto error;
>  	}
> -	priv->spi->dev.platform_data = pdata;
>  
>  	ret = ca8210_dev_com_init(priv);
>  	if (ret) {
> 

Could you review this patch for the ca8210 driver?

regards
Stefan Schmidt
