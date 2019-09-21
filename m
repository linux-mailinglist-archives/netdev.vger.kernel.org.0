Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11CEEB9DB4
	for <lists+netdev@lfdr.de>; Sat, 21 Sep 2019 13:52:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407581AbfIULwx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Sep 2019 07:52:53 -0400
Received: from proxima.lasnet.de ([78.47.171.185]:59247 "EHLO
        proxima.lasnet.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405770AbfIULwx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Sep 2019 07:52:53 -0400
Received: from localhost.localdomain (unknown [IPv6:2003:e9:d742:d2ca:2f74:a255:7f82:cac1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: stefan@datenfreihafen.org)
        by proxima.lasnet.de (Postfix) with ESMTPSA id 5EE4AC18BE;
        Sat, 21 Sep 2019 13:52:48 +0200 (CEST)
Subject: Re: [PATCH] ieee802154: mcr20a: simplify a bit
 'mcr20a_handle_rx_read_buf_complete()'
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        liuxuenetmail@gmail.com, alex.aring@gmail.com, davem@davemloft.net
Cc:     linux-wpan@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
References: <20190920194533.5886-1-christophe.jaillet@wanadoo.fr>
From:   Stefan Schmidt <stefan@datenfreihafen.org>
Message-ID: <388f335a-a9ae-7230-1713-a1ecb682fecf@datenfreihafen.org>
Date:   Sat, 21 Sep 2019 13:52:11 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190920194533.5886-1-christophe.jaillet@wanadoo.fr>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Xue.

On 20.09.19 21:45, Christophe JAILLET wrote:
> Use a 'skb_put_data()' variant instead of rewritting it.
> The __skb_put_data variant is safe here. It is obvious that the skb can
> not overflow. It has just been allocated a few lines above with the same
> 'len'.
> 
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---
>  drivers/net/ieee802154/mcr20a.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ieee802154/mcr20a.c b/drivers/net/ieee802154/mcr20a.c
> index 17f2300e63ee..8dc04e2590b1 100644
> --- a/drivers/net/ieee802154/mcr20a.c
> +++ b/drivers/net/ieee802154/mcr20a.c
> @@ -800,7 +800,7 @@ mcr20a_handle_rx_read_buf_complete(void *context)
>  	if (!skb)
>  		return;
>  
> -	memcpy(skb_put(skb, len), lp->rx_buf, len);
> +	__skb_put_data(skb, lp->rx_buf, len);
>  	ieee802154_rx_irqsafe(lp->hw, skb, lp->rx_lqi[0]);
>  
>  	print_hex_dump_debug("mcr20a rx: ", DUMP_PREFIX_OFFSET, 16, 1,
> 

Could you please review and ACK this? If you are happy I will take it
through my tree.

regards
Stefan Schmidt
