Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10A583E0D8C
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 07:10:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231326AbhHEFKS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 01:10:18 -0400
Received: from pegase2.c-s.fr ([93.17.235.10]:58145 "EHLO pegase2.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236923AbhHEFKQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Aug 2021 01:10:16 -0400
Received: from localhost (mailhub3.si.c-s.fr [172.26.127.67])
        by localhost (Postfix) with ESMTP id 4GgGrT41rxz9sX5;
        Thu,  5 Aug 2021 07:10:01 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from pegase2.c-s.fr ([172.26.127.65])
        by localhost (pegase2.c-s.fr [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id RK_JnrGWDhK7; Thu,  5 Aug 2021 07:10:01 +0200 (CEST)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
        by pegase2.c-s.fr (Postfix) with ESMTP id 4GgGrT31whz9sX3;
        Thu,  5 Aug 2021 07:10:01 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 4ED558B7AE;
        Thu,  5 Aug 2021 07:10:01 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
        by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
        with ESMTP id c2u6BzGfRwSQ; Thu,  5 Aug 2021 07:10:01 +0200 (CEST)
Received: from [192.168.4.90] (unknown [192.168.4.90])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id E8EA28B76A;
        Thu,  5 Aug 2021 07:10:00 +0200 (CEST)
Subject: Re: [PATCH v4 09/10] net/ps3_gelic: Add new routine
 gelic_work_to_card
To:     Geoff Levand <geoff@infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
References: <cover.1627068552.git.geoff@infradead.org>
 <5634f7c76a67345c9735e05b68228ea899a8bf9d.1627068552.git.geoff@infradead.org>
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
Message-ID: <b0ae0cf5-5ec3-6634-e67e-8a0f64e9065e@csgroup.eu>
Date:   Thu, 5 Aug 2021 07:10:02 +0200
User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <5634f7c76a67345c9735e05b68228ea899a8bf9d.1627068552.git.geoff@infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: fr
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Le 23/07/2021 à 22:31, Geoff Levand a écrit :
> Add new helper routine gelic_work_to_card that converts a work_struct
> to a gelic_card.
> 
> Signed-off-by: Geoff Levand <geoff@infradead.org>

Commit 3ffdbef9f86f ("net/ps3_gelic: Add new routine gelic_work_to_card") has no obvious style 
problems and is ready for submission.


> ---
>   drivers/net/ethernet/toshiba/ps3_gelic_net.c | 8 ++++++--
>   1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/toshiba/ps3_gelic_net.c b/drivers/net/ethernet/toshiba/ps3_gelic_net.c
> index 60fcca5d20dd..42f4de9ad5fe 100644
> --- a/drivers/net/ethernet/toshiba/ps3_gelic_net.c
> +++ b/drivers/net/ethernet/toshiba/ps3_gelic_net.c
> @@ -1420,6 +1420,11 @@ static const struct ethtool_ops gelic_ether_ethtool_ops = {
>   	.set_link_ksettings = gelic_ether_set_link_ksettings,
>   };
>   
> +static struct gelic_card *gelic_work_to_card(struct work_struct *work)
> +{
> +	return container_of(work, struct gelic_card, tx_timeout_task);
> +}
> +
>   /**
>    * gelic_net_tx_timeout_task - task scheduled by the watchdog timeout
>    * function (to be called not under interrupt status)
> @@ -1429,8 +1434,7 @@ static const struct ethtool_ops gelic_ether_ethtool_ops = {
>    */
>   static void gelic_net_tx_timeout_task(struct work_struct *work)
>   {
> -	struct gelic_card *card =
> -		container_of(work, struct gelic_card, tx_timeout_task);
> +	struct gelic_card *card = gelic_work_to_card(work);
>   	struct net_device *netdev = card->netdev[GELIC_PORT_ETHERNET_0];
>   	struct device *dev = ctodev(card);
>   
> 
