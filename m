Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 889F4343E83
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 11:55:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230320AbhCVKzX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 06:55:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:57616 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230293AbhCVKzG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Mar 2021 06:55:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C1B956191F;
        Mon, 22 Mar 2021 10:55:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616410505;
        bh=sBEVRtDSTxe0WuT8RPrnMFt+2BQK5Vh/XhTj5EwDsOM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Zk717Y47xuc95xk+TI5dDukstFCr9Q3wSkyWsddUtQqj+ml69gZxG8DLlUCbz1peA
         mZeykmkZq8tdlz2Z2udxQNMmCyIzqRNC1B19rGjL9IdkhMnQKdIx2QUYrzqXkkHMad
         gsPmZLOFF2QE1P/qpPQmJ7v6rnM9VmQHyWeo6k8zkU1N8h9rXFBRiog6db3+iRd0eH
         P3h2LzAYV0ZStRBeZ56RFoqCI+h+QRYQJ69M42x1kae4xyz1wp/NCqbQzbCD+ZZdpE
         PlWvlYjWU7e682wIrQlQgb/qbZlVcV6czza0rYdFuNNf2+8rRTiKAHl7x77IRwJExh
         0Gu4VbyHRxzPQ==
Date:   Mon, 22 Mar 2021 12:55:01 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     netdev@vger.kernel.org, Karsten Keil <isdn@linux-pingi.de>,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 1/5] misdn: avoid -Wempty-body warning
Message-ID: <YFh3heNXq6mqYqzI@unreal>
References: <20210322104343.948660-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210322104343.948660-1-arnd@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 22, 2021 at 11:43:31AM +0100, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> gcc warns about a pointless condition:
> 
> drivers/isdn/hardware/mISDN/hfcmulti.c: In function 'hfcmulti_interrupt':
> drivers/isdn/hardware/mISDN/hfcmulti.c:2752:17: error: suggest braces around empty body in an 'if' statement [-Werror=empty-body]
>  2752 |                 ; /* external IRQ */
> 
> Change this as suggested by gcc, which also fits the style of the
> other conditions in this function.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  drivers/isdn/hardware/mISDN/hfcmulti.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/isdn/hardware/mISDN/hfcmulti.c b/drivers/isdn/hardware/mISDN/hfcmulti.c
> index 7013a3f08429..8ab0fde758d2 100644
> --- a/drivers/isdn/hardware/mISDN/hfcmulti.c
> +++ b/drivers/isdn/hardware/mISDN/hfcmulti.c
> @@ -2748,8 +2748,9 @@ hfcmulti_interrupt(int intno, void *dev_id)
>  		if (hc->ctype != HFC_TYPE_E1)
>  			ph_state_irq(hc, r_irq_statech);
>  	}
> -	if (status & V_EXT_IRQSTA)
> -		; /* external IRQ */
> +	if (status & V_EXT_IRQSTA) {
> +		/* external IRQ */
> +	}

Any reason do not delete this hunk?

>  	if (status & V_LOST_STA) {
>  		/* LOST IRQ */
>  		HFC_outb(hc, R_INC_RES_FIFO, V_RES_LOST); /* clear irq! */
> -- 
> 2.29.2
> 
