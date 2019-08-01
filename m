Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CABB27D632
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 09:18:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730700AbfHAHSE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Aug 2019 03:18:04 -0400
Received: from relay12.mail.gandi.net ([217.70.178.232]:39435 "EHLO
        relay12.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730513AbfHAHSE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Aug 2019 03:18:04 -0400
Received: from localhost (lfbn-1-17395-211.w86-250.abo.wanadoo.fr [86.250.200.211])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay12.mail.gandi.net (Postfix) with ESMTPSA id 109E220000C;
        Thu,  1 Aug 2019 07:18:01 +0000 (UTC)
Date:   Thu, 1 Aug 2019 09:18:01 +0200
From:   Antoine Tenart <antoine.tenart@bootlin.com>
To:     Matteo Croce <mcroce@redhat.com>
Cc:     netdev@vger.kernel.org,
        Miquel Raynal <miquel.raynal@free-electrons.com>,
        linux-kernel@vger.kernel.org,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH net] mvpp2: fix panic on module removal
Message-ID: <20190801071801.GF3579@kwain>
References: <20190731183116.4791-1-mcroce@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190731183116.4791-1-mcroce@redhat.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Matteo,

On Wed, Jul 31, 2019 at 08:31:16PM +0200, Matteo Croce wrote:
> 
> diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> index c51f1d5b550b..5002d51fc9d6 100644
> --- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> +++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> @@ -5760,7 +5760,6 @@ static int mvpp2_remove(struct platform_device *pdev)
>  	mvpp2_dbgfs_cleanup(priv);
>  
>  	flush_workqueue(priv->stats_queue);
> -	destroy_workqueue(priv->stats_queue);
>  
>  	fwnode_for_each_available_child_node(fwnode, port_fwnode) {
>  		if (priv->port_list[i]) {
> @@ -5770,6 +5769,8 @@ static int mvpp2_remove(struct platform_device *pdev)
>  		i++;
>  	}

Shouldn't you also move flush_workqueue() here?

> +	destroy_workqueue(priv->stats_queue);
> +
>  	for (i = 0; i < MVPP2_BM_POOLS_NUM; i++) {
>  		struct mvpp2_bm_pool *bm_pool = &priv->bm_pools[i];

Thanks!
Antoine

-- 
Antoine Ténart, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
