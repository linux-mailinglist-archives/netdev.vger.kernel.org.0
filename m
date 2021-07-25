Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B8633D4F75
	for <lists+netdev@lfdr.de>; Sun, 25 Jul 2021 20:22:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231156AbhGYRln convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sun, 25 Jul 2021 13:41:43 -0400
Received: from pegase1.c-s.fr ([93.17.236.30]:15863 "EHLO pegase1.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229825AbhGYRlm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 25 Jul 2021 13:41:42 -0400
Received: from localhost (mailhub3.si.c-s.fr [192.168.12.233])
        by localhost (Postfix) with ESMTP id 4GXrxZ71FkzBCTP;
        Sun, 25 Jul 2021 20:22:10 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from pegase1.c-s.fr ([192.168.12.234])
        by localhost (pegase1.c-s.fr [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id kcwmj6KcnYOR; Sun, 25 Jul 2021 20:22:10 +0200 (CEST)
Received: from vm-hermes.si.c-s.fr (vm-hermes.si.c-s.fr [192.168.25.253])
        by pegase1.c-s.fr (Postfix) with ESMTP id 4GXrxZ64yVzBCTJ;
        Sun, 25 Jul 2021 20:22:10 +0200 (CEST)
Received: by vm-hermes.si.c-s.fr (Postfix, from userid 33)
        id 2BE91293; Sun, 25 Jul 2021 20:27:28 +0200 (CEST)
Received: from 37-165-12-41.coucou-networks.fr
 (37-165-12-41.coucou-networks.fr [37.165.12.41]) by messagerie.c-s.fr (Horde
 Framework) with HTTP; Sun, 25 Jul 2021 20:27:28 +0200
Date:   Sun, 25 Jul 2021 20:27:28 +0200
Message-ID: <20210725202728.Horde.h18tJbMCDL-jDvRqhxi5iQ1@messagerie.c-s.fr>
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
To:     Geoff Levand <geoff@infradead.org>
Cc:     linuxppc-dev@lists.ozlabs.org, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH v4 08/10] net/ps3_gelic: Rename no to descr_count
References: <cover.1627068552.git.geoff@infradead.org>
 <07e42ec30037d514c1d63f33efe4642364d89802.1627068552.git.geoff@infradead.org>
In-Reply-To: <07e42ec30037d514c1d63f33efe4642364d89802.1627068552.git.geoff@infradead.org>
User-Agent: Internet Messaging Program (IMP) H5 (6.2.3)
Content-Type: text/plain; charset=UTF-8; format=flowed; DelSp=Yes
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Geoff Levand <geoff@infradead.org> a écrit :

> In an effort to make the PS3 gelic driver easier to maintain, rename
> the gelic_card_init_chain parameter 'no' to 'descr_count'.

Not sure you really need a so long name. 'count' should be good enough.

Read https://www.kernel.org/doc/html/latest/process/coding-style.html#naming

>
> Signed-off-by: Geoff Levand <geoff@infradead.org>
> ---
>  drivers/net/ethernet/toshiba/ps3_gelic_net.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/net/ethernet/toshiba/ps3_gelic_net.c  
> b/drivers/net/ethernet/toshiba/ps3_gelic_net.c
> index e55aa9fecfeb..60fcca5d20dd 100644
> --- a/drivers/net/ethernet/toshiba/ps3_gelic_net.c
> +++ b/drivers/net/ethernet/toshiba/ps3_gelic_net.c
> @@ -325,7 +325,7 @@ static void gelic_card_free_chain(struct  
> gelic_card *card,
>   * @card: card structure
>   * @chain: address of chain
>   * @start_descr: address of descriptor array
> - * @no: number of descriptors
> + * @descr_count: number of descriptors
>   *
>   * we manage a circular list that mirrors the hardware structure,
>   * except that the hardware uses bus addresses.
> @@ -334,16 +334,16 @@ static void gelic_card_free_chain(struct  
> gelic_card *card,
>   */
>  static int gelic_card_init_chain(struct gelic_card *card,
>  	struct gelic_descr_chain *chain, struct gelic_descr *start_descr,
> -	int no)
> +	int descr_count)
>  {
>  	int i;
>  	struct gelic_descr *descr;
>  	struct device *dev = ctodev(card);
>
>  	descr = start_descr;
> -	memset(descr, 0, sizeof(*descr) * no);
> +	memset(descr, 0, sizeof(*descr) *descr_count);

You forgot the space after the *

Christophe

>
> -	for (i = 0; i < no; i++, descr++) {
> +	for (i = 0; i < descr_count; i++, descr++) {
>  		descr->link.size = sizeof(struct gelic_hw_regs);
>  		gelic_descr_set_status(descr, GELIC_DESCR_DMA_NOT_IN_USE);
>  		descr->link.cpu_addr =
> @@ -361,7 +361,7 @@ static int gelic_card_init_chain(struct gelic_card *card,
>  	start_descr->prev = (descr - 1);
>
>  	descr = start_descr;
> -	for (i = 0; i < no; i++, descr++) {
> +	for (i = 0; i < descr_count; i++, descr++) {
>  		descr->hw_regs.next_descr_addr =
>  			cpu_to_be32(descr->next->link.cpu_addr);
>  	}
> --
> 2.25.1


