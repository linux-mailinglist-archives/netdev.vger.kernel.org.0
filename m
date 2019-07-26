Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73942766B8
	for <lists+netdev@lfdr.de>; Fri, 26 Jul 2019 14:57:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727081AbfGZM5T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jul 2019 08:57:19 -0400
Received: from relay11.mail.gandi.net ([217.70.178.231]:42517 "EHLO
        relay11.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726863AbfGZM5R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jul 2019 08:57:17 -0400
Received: from localhost (lfbn-1-17395-211.w86-250.abo.wanadoo.fr [86.250.200.211])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay11.mail.gandi.net (Postfix) with ESMTPSA id A0EAA100002;
        Fri, 26 Jul 2019 12:57:15 +0000 (UTC)
Date:   Fri, 26 Jul 2019 14:57:15 +0200
From:   Antoine Tenart <antoine.tenart@bootlin.com>
To:     Matteo Croce <mcroce@redhat.com>
Cc:     netdev@vger.kernel.org,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Stefan Chulski <stefanc@marvell.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next] mvpp2: document HW checksum behaviour
Message-ID: <20190726125715.GB5031@kwain>
References: <20190725231546.23878-1-mcroce@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190725231546.23878-1-mcroce@redhat.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Matteo,

On Fri, Jul 26, 2019 at 01:15:46AM +0200, Matteo Croce wrote:
> The hardware can only offload checksum calculation on first port due to
> the Tx FIFO size limitation. Document this in a comment.
> 
> Fixes: 576193f2d579 ("net: mvpp2: jumbo frames support")
> Signed-off-by: Matteo Croce <mcroce@redhat.com>

Looks good. Please note there's a similar code path in the probe. You
could also add a comment there (or move this check/comment in a common
place).

Thanks!
Antoine

> ---
>  drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> index d8e5241097a9..2f7286bd203b 100644
> --- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> +++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> @@ -843,7 +843,10 @@ static int mvpp2_bm_update_mtu(struct net_device *dev, int mtu)
>  		/* Add port to new short & long pool */
>  		mvpp2_swf_bm_pool_init(port);
>  
> -		/* Update L4 checksum when jumbo enable/disable on port */
> +		/* Update L4 checksum when jumbo enable/disable on port.
> +		 * Only port 0 supports hardware checksum offload due to
> +		 * the Tx FIFO size limitation.
> +		 */
>  		if (new_long_pool == MVPP2_BM_JUMBO && port->id != 0) {
>  			dev->features &= ~(NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM);
>  			dev->hw_features &= ~(NETIF_F_IP_CSUM |
> -- 
> 2.21.0
> 

-- 
Antoine Ténart, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
