Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA80E75083
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 16:03:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387674AbfGYODz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jul 2019 10:03:55 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:47001 "EHLO
        relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727136AbfGYODy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jul 2019 10:03:54 -0400
X-Originating-IP: 92.137.69.152
Received: from localhost (alyon-656-1-672-152.w92-137.abo.wanadoo.fr [92.137.69.152])
        (Authenticated sender: alexandre.belloni@bootlin.com)
        by relay4-d.mail.gandi.net (Postfix) with ESMTPSA id 7D0B5E0021;
        Thu, 25 Jul 2019 14:03:52 +0000 (UTC)
Date:   Thu, 25 Jul 2019 16:03:51 +0200
From:   Alexandre Belloni <alexandre.belloni@bootlin.com>
To:     Claudiu Manoil <claudiu.manoil@nxp.com>
Cc:     "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        UNGLinuxDriver@microchip.com
Subject: Re: [PATCH net] ocelot: Cancel delayed work before wq destruction
Message-ID: <20190725140351.GT24911@piout.net>
References: <1564061598-4440-1-git-send-email-claudiu.manoil@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1564061598-4440-1-git-send-email-claudiu.manoil@nxp.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 25/07/2019 16:33:18+0300, Claudiu Manoil wrote:
> Make sure the delayed work for stats update is not pending before
> wq destruction.
> This fixes the module unload path.
> The issue is there since day 1.
> 
> Fixes: a556c76adc05 ("net: mscc: Add initial Ocelot switch support")
> 
> Signed-off-by: Claudiu Manoil <claudiu.manoil@nxp.com>
Reviewed-by: Alexandre Belloni <alexandre.belloni@bootlin.com>

> ---
>  drivers/net/ethernet/mscc/ocelot.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
> index b71e4ecbe469..6932e615d4b0 100644
> --- a/drivers/net/ethernet/mscc/ocelot.c
> +++ b/drivers/net/ethernet/mscc/ocelot.c
> @@ -1818,6 +1818,7 @@ EXPORT_SYMBOL(ocelot_init);
>  
>  void ocelot_deinit(struct ocelot *ocelot)
>  {
> +	cancel_delayed_work(&ocelot->stats_work);
>  	destroy_workqueue(ocelot->stats_queue);
>  	mutex_destroy(&ocelot->stats_lock);
>  	ocelot_ace_deinit();
> -- 
> 2.17.1
> 

-- 
Alexandre Belloni, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
