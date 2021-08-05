Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01CCD3E0DBA
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 07:20:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234327AbhHEFUu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 01:20:50 -0400
Received: from pegase2.c-s.fr ([93.17.235.10]:34707 "EHLO pegase2.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231272AbhHEFUr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Aug 2021 01:20:47 -0400
Received: from localhost (mailhub3.si.c-s.fr [172.26.127.67])
        by localhost (Postfix) with ESMTP id 4GgGnB5Trbz9sWD;
        Thu,  5 Aug 2021 07:07:10 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from pegase2.c-s.fr ([172.26.127.65])
        by localhost (pegase2.c-s.fr [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id nodEyOwS5ctt; Thu,  5 Aug 2021 07:07:10 +0200 (CEST)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
        by pegase2.c-s.fr (Postfix) with ESMTP id 4GgGnB4NVLz9sSc;
        Thu,  5 Aug 2021 07:07:10 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 7507A8B7AE;
        Thu,  5 Aug 2021 07:07:10 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
        by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
        with ESMTP id PEs0Aku6uuXE; Thu,  5 Aug 2021 07:07:10 +0200 (CEST)
Received: from [192.168.4.90] (unknown [192.168.4.90])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 049D08B76A;
        Thu,  5 Aug 2021 07:07:09 +0200 (CEST)
Subject: Re: [PATCH v4 04/10] net/ps3_gelic: Add new macro BUG_ON_DEBUG
To:     Geoff Levand <geoff@infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
References: <cover.1627068552.git.geoff@infradead.org>
 <bc659850d4eec3b2358c1ccb0e00952ceaa6012f.1627068552.git.geoff@infradead.org>
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
Message-ID: <449b2569-5c6f-553d-1bcc-162acff96a1e@csgroup.eu>
Date:   Thu, 5 Aug 2021 07:07:11 +0200
User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <bc659850d4eec3b2358c1ccb0e00952ceaa6012f.1627068552.git.geoff@infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: fr
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Le 23/07/2021 à 22:31, Geoff Levand a écrit :
> Add a new preprocessor macro BUG_ON_DEBUG, that expands to BUG_ON when
> the preprocessor macro DEBUG is defined, or to WARN_ON when DEBUG is not
> defined.  Also, replace all occurrences of BUG_ON with BUG_ON_DEBUG.
> 

CHECK:MACRO_ARG_REUSE: Macro argument reuse '_cond' - possible side-effects?
#23: FILE: drivers/net/ethernet/toshiba/ps3_gelic_net.c:47:
+#define BUG_ON_DEBUG(_cond) do { \
+	if (__is_defined(DEBUG)) \
+		BUG_ON(_cond); \
+	else \
+		WARN_ON(_cond); \
+} while (0)

WARNING:AVOID_BUG: Avoid crashing the kernel - try using WARN_ON & recovery code rather than BUG() 
or BUG_ON()
#25: FILE: drivers/net/ethernet/toshiba/ps3_gelic_net.c:49:
+		BUG_ON(_cond); \


NOTE: For some of the reported defects, checkpatch may be able to
       mechanically convert to the typical style using --fix or --fix-inplace.

Commit e4fbd62abdcd ("net/ps3_gelic: Add new macro BUG_ON_DEBUG") has style problems, please review.

NOTE: Ignored message types: ARCH_INCLUDE_LINUX BIT_MACRO COMPARISON_TO_NULL DT_SPLIT_BINDING_PATCH 
EMAIL_SUBJECT FILE_PATH_CHANGES GLOBAL_INITIALISERS LINE_SPACING MULTIPLE_ASSIGNMENTS


> Signed-off-by: Geoff Levand <geoff@infradead.org>
> ---
>   drivers/net/ethernet/toshiba/ps3_gelic_net.c | 13 ++++++++++---
>   1 file changed, 10 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/ethernet/toshiba/ps3_gelic_net.c b/drivers/net/ethernet/toshiba/ps3_gelic_net.c
> index ded467d81f36..946e9bfa071b 100644
> --- a/drivers/net/ethernet/toshiba/ps3_gelic_net.c
> +++ b/drivers/net/ethernet/toshiba/ps3_gelic_net.c
> @@ -44,6 +44,13 @@ MODULE_AUTHOR("SCE Inc.");
>   MODULE_DESCRIPTION("Gelic Network driver");
>   MODULE_LICENSE("GPL");
>   
> +#define BUG_ON_DEBUG(_cond) do { \
> +	if (__is_defined(DEBUG)) \
> +		BUG_ON(_cond); \
> +	else \
> +		WARN_ON(_cond); \
> +} while (0)
> +
>   int gelic_card_set_irq_mask(struct gelic_card *card, u64 mask)
>   {
>   	struct device *dev = ctodev(card);
> @@ -505,7 +512,7 @@ static void gelic_descr_release_tx(struct gelic_card *card,
>   	struct sk_buff *skb = descr->skb;
>   	struct device *dev = ctodev(card);
>   
> -	BUG_ON(!(be32_to_cpu(descr->hw_regs.data_status) &
> +	BUG_ON_DEBUG(!(be32_to_cpu(descr->hw_regs.data_status) &
>   		GELIC_DESCR_TX_TAIL));
>   
>   	dma_unmap_single(dev, be32_to_cpu(descr->hw_regs.payload.dev_addr),
> @@ -1667,7 +1674,7 @@ static void gelic_card_get_vlan_info(struct gelic_card *card)
>   	}
>   
>   	if (card->vlan[GELIC_PORT_ETHERNET_0].tx) {
> -		BUG_ON(!card->vlan[GELIC_PORT_WIRELESS].tx);
> +		BUG_ON_DEBUG(!card->vlan[GELIC_PORT_WIRELESS].tx);
>   		card->vlan_required = 1;
>   	} else
>   		card->vlan_required = 0;
> @@ -1709,7 +1716,7 @@ static int ps3_gelic_driver_probe(struct ps3_system_bus_device *sb_dev)
>   	if (result) {
>   		dev_err(dev, "%s:%d: ps3_dma_region_create failed: %d\n",
>   			__func__, __LINE__, result);
> -		BUG_ON("check region type");
> +		BUG_ON_DEBUG("check region type");
>   		goto fail_dma_region;
>   	}
>   
> 
