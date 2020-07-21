Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30825227AC5
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 10:35:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727048AbgGUIf3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 04:35:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725984AbgGUIf3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jul 2020 04:35:29 -0400
Received: from proxima.lasnet.de (proxima.lasnet.de [IPv6:2a01:4f8:121:31eb:3::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B7F0C061794
        for <netdev@vger.kernel.org>; Tue, 21 Jul 2020 01:35:29 -0700 (PDT)
Received: from localhost.localdomain (p200300e9d73716cc9f1a64b6f5045be6.dip0.t-ipconnect.de [IPv6:2003:e9:d737:16cc:9f1a:64b6:f504:5be6])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: stefan@datenfreihafen.org)
        by proxima.lasnet.de (Postfix) with ESMTPSA id 0122FC0476;
        Tue, 21 Jul 2020 10:35:26 +0200 (CEST)
Subject: Re: [PATCH net] ieee802154: fix one possible memleak in
 ca8210_dev_com_init
To:     Liu Jian <liujian56@huawei.com>, h.morris@cascoda.com,
        alex.aring@gmail.com, davem@davemloft.net, kuba@kernel.org,
        marcel@holtmann.or, netdev@vger.kernel.org
References: <20200720143315.40523-1-liujian56@huawei.com>
From:   Stefan Schmidt <stefan@datenfreihafen.org>
Message-ID: <23cf1224-5335-7a00-6f9d-d83e5e91df3d@datenfreihafen.org>
Date:   Tue, 21 Jul 2020 10:35:25 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200720143315.40523-1-liujian56@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello.

On 20.07.20 16:33, Liu Jian wrote:
> We should call destroy_workqueue to destroy mlme_workqueue in error branch.
> 
> Fixes: ded845a781a5 ("ieee802154: Add CA8210 IEEE 802.15.4 device driver")
> Signed-off-by: Liu Jian <liujian56@huawei.com>
> ---
>   drivers/net/ieee802154/ca8210.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/ieee802154/ca8210.c b/drivers/net/ieee802154/ca8210.c
> index e04c3b60cae7..4eb64709d44c 100644
> --- a/drivers/net/ieee802154/ca8210.c
> +++ b/drivers/net/ieee802154/ca8210.c
> @@ -2925,6 +2925,7 @@ static int ca8210_dev_com_init(struct ca8210_priv *priv)
>   	);
>   	if (!priv->irq_workqueue) {
>   		dev_crit(&priv->spi->dev, "alloc of irq_workqueue failed!\n");
> +		destroy_workqueue(priv->mlme_workqueue);
>   		return -ENOMEM;
>   	}

For ieee802154 patches please keep the linux-wpan list in CC. This 
allows me to track patches with patchwork. Applied this one manually.

This patch has been applied to the wpan tree and will be
part of the next pull request to net. Thanks!

regards
Stefan Schmidt
