Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BE2D481819
	for <lists+netdev@lfdr.de>; Thu, 30 Dec 2021 02:32:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234012AbhL3Bc4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Dec 2021 20:32:56 -0500
Received: from relay027.a.hostedemail.com ([64.99.140.27]:35244 "EHLO
        relay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S232755AbhL3Bcz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Dec 2021 20:32:55 -0500
Received: from omf15.hostedemail.com (a10.router.float.18 [10.200.18.1])
        by unirelay06.hostedemail.com (Postfix) with ESMTP id 1774221CAE;
        Thu, 30 Dec 2021 01:32:53 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf15.hostedemail.com (Postfix) with ESMTPA id 94E241D;
        Thu, 30 Dec 2021 01:32:45 +0000 (UTC)
Message-ID: <7d75e12a4eb373a5a7e90161049a0eccb6b8c63c.camel@perches.com>
Subject: Re: [PATCH net-next] net: lantiq_etop: make alignment match open
 parenthesis
From:   Joe Perches <joe@perches.com>
To:     Aleksander Jan Bajkowski <olek2@wp.pl>, davem@davemloft.net,
        kuba@kernel.org, jgg@ziepe.ca, rdunlap@infradead.org,
        arnd@arndb.de, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Wed, 29 Dec 2021 17:32:49 -0800
In-Reply-To: <20211229233952.5306-1-olek2@wp.pl>
References: <20211229233952.5306-1-olek2@wp.pl>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.40.4-1ubuntu2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 94E241D
X-Spam-Status: No, score=-2.45
X-Stat-Signature: ugi1zfnfjgfu1e5fce45qctnn7i343up
X-Rspamd-Server: rspamout06
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX19GDPUs0SQdv6Ag6oO5BybgfbmLTPSqIlg=
X-HE-Tag: 1640827965-739717
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2021-12-30 at 00:39 +0100, Aleksander Jan Bajkowski wrote:
> checkpatch.pl complains as the following:
> 
> Alignment should match open parenthesis
[]
> diff --git a/drivers/net/ethernet/lantiq_etop.c b/drivers/net/ethernet/lantiq_etop.c
[]
> @@ -111,9 +111,9 @@ ltq_etop_alloc_skb(struct ltq_etop_chan *ch)
>  	ch->skb[ch->dma.desc] = netdev_alloc_skb(ch->netdev, MAX_DMA_DATA_LEN);
>  	if (!ch->skb[ch->dma.desc])
>  		return -ENOMEM;
> -	ch->dma.desc_base[ch->dma.desc].addr = dma_map_single(&priv->pdev->dev,
> -		ch->skb[ch->dma.desc]->data, MAX_DMA_DATA_LEN,
> -		DMA_FROM_DEVICE);
> +	ch->dma.desc_base[ch->dma.desc].addr =
> +		dma_map_single(&priv->pdev->dev, ch->skb[ch->dma.desc]->data,
> +			       MAX_DMA_DATA_LEN, DMA_FROM_DEVICE);
>  	ch->dma.desc_base[ch->dma.desc].addr =
>  		CPHYSADDR(ch->skb[ch->dma.desc]->data);

Unassociated trivia:

ch->dma.desc_base[ch->dma.desc].addr is the target of consecutive assignments.

That looks very odd.

Isn't the compiler allowed to toss/throw away the first assignment?


