Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A9AB3E0DBB
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 07:20:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231613AbhHEFUw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 01:20:52 -0400
Received: from pegase2.c-s.fr ([93.17.235.10]:34707 "EHLO pegase2.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231143AbhHEFUv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Aug 2021 01:20:51 -0400
Received: from localhost (mailhub3.si.c-s.fr [172.26.127.67])
        by localhost (Postfix) with ESMTP id 4GgGpp6YtZz9sX1;
        Thu,  5 Aug 2021 07:08:34 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from pegase2.c-s.fr ([172.26.127.65])
        by localhost (pegase2.c-s.fr [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id EUV2T3z4V6Op; Thu,  5 Aug 2021 07:08:34 +0200 (CEST)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
        by pegase2.c-s.fr (Postfix) with ESMTP id 4GgGpp5bkQz9sWW;
        Thu,  5 Aug 2021 07:08:34 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 9A6B38B7AE;
        Thu,  5 Aug 2021 07:08:34 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
        by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
        with ESMTP id PZ660VRD4lYy; Thu,  5 Aug 2021 07:08:34 +0200 (CEST)
Received: from [192.168.4.90] (unknown [192.168.4.90])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 349BC8B76A;
        Thu,  5 Aug 2021 07:08:34 +0200 (CEST)
Subject: Re: [PATCH v4 06/10] net/ps3_gelic: Cleanup debug code
To:     Geoff Levand <geoff@infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
References: <cover.1627068552.git.geoff@infradead.org>
 <8421aa2c148d840b11b7115208e5276017999c2a.1627068552.git.geoff@infradead.org>
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
Message-ID: <4b004fab-bf60-3e77-54f0-f2598ef81396@csgroup.eu>
Date:   Thu, 5 Aug 2021 07:08:35 +0200
User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <8421aa2c148d840b11b7115208e5276017999c2a.1627068552.git.geoff@infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: fr
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Le 23/07/2021 à 22:31, Geoff Levand a écrit :
> In an effort to make the PS3 gelic driver easier to maintain, change the
> gelic_card_enable_rxdmac routine to use the optimizer to remove
> debug code.
> 
> Signed-off-by: Geoff Levand <geoff@infradead.org>


WARNING:VSPRINTF_SPECIFIER_PX: Using vsprintf specifier '%px' potentially exposes the kernel memory 
layout, if you don't really need the address please consider using '%p'.
#38: FILE: drivers/net/ethernet/toshiba/ps3_gelic_net.c:171:
+		dev_err(dev, "%s:%d: head=%px\n", __func__, __LINE__,
+			card->rx_chain.head);


NOTE: For some of the reported defects, checkpatch may be able to
       mechanically convert to the typical style using --fix or --fix-inplace.

Commit 65f38d9720ac ("net/ps3_gelic: Cleanup debug code") has style problems, please review.

NOTE: Ignored message types: ARCH_INCLUDE_LINUX BIT_MACRO COMPARISON_TO_NULL DT_SPLIT_BINDING_PATCH 
EMAIL_SUBJECT FILE_PATH_CHANGES GLOBAL_INITIALISERS LINE_SPACING MULTIPLE_ASSIGNMENTS


> ---
>   drivers/net/ethernet/toshiba/ps3_gelic_net.c | 19 +++++++++----------
>   1 file changed, 9 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/net/ethernet/toshiba/ps3_gelic_net.c b/drivers/net/ethernet/toshiba/ps3_gelic_net.c
> index 54e50ad9e629..85fc1915c8be 100644
> --- a/drivers/net/ethernet/toshiba/ps3_gelic_net.c
> +++ b/drivers/net/ethernet/toshiba/ps3_gelic_net.c
> @@ -162,17 +162,16 @@ static void gelic_card_enable_rxdmac(struct gelic_card *card)
>   	struct device *dev = ctodev(card);
>   	int status;
>   
> -#ifdef DEBUG
> -	if (gelic_descr_get_status(card->rx_chain.head) !=
> -	    GELIC_DESCR_DMA_CARDOWNED) {
> -		printk(KERN_ERR "%s: status=%x\n", __func__,
> -		       be32_to_cpu(card->rx_chain.head->dmac_cmd_status));
> -		printk(KERN_ERR "%s: nextphy=%x\n", __func__,
> -		       be32_to_cpu(card->rx_chain.head->hw_regs.next_descr_addr));
> -		printk(KERN_ERR "%s: head=%p\n", __func__,
> -		       card->rx_chain.head);
> +	if (__is_defined(DEBUG) && (gelic_descr_get_status(card->rx_chain.head)
> +			!= GELIC_DESCR_DMA_CARDOWNED)) {
> +		dev_err(dev, "%s:%d: status=%x\n", __func__, __LINE__,
> +			be32_to_cpu(card->rx_chain.head->hw_regs.dmac_cmd_status));
> +		dev_err(dev, "%s:%d: nextphy=%x\n", __func__, __LINE__,
> +			be32_to_cpu(card->rx_chain.head->hw_regs.next_descr_addr));
> +		dev_err(dev, "%s:%d: head=%px\n", __func__, __LINE__,
> +			card->rx_chain.head);
>   	}
> -#endif
> +
>   	status = lv1_net_start_rx_dma(bus_id(card), dev_id(card),
>   		card->rx_chain.head->link.cpu_addr, 0);
>   
> 
