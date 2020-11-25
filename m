Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38DDD2C3E8F
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 11:57:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726903AbgKYK4D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Nov 2020 05:56:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726654AbgKYK4D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Nov 2020 05:56:03 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15638C0613D4
        for <netdev@vger.kernel.org>; Wed, 25 Nov 2020 02:56:03 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=[IPv6:::1])
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <a.fatoum@pengutronix.de>)
        id 1khsSt-0004DY-GD; Wed, 25 Nov 2020 11:55:59 +0100
Subject: Re: [PATCH] net: stmmac: fix incorrect merge of patch upstream
To:     Antonio Borneo <antonio.borneo@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     stable@vger.kernel.org,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <42960ede-9355-1277-9a6f-4eac3c22365c@pengutronix.de>
 <20201124223729.886992-1-antonio.borneo@st.com>
From:   Ahmad Fatoum <a.fatoum@pengutronix.de>
Message-ID: <3ba1c4b3-18a0-5448-2188-aa6e2802c57e@pengutronix.de>
Date:   Wed, 25 Nov 2020 11:55:52 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20201124223729.886992-1-antonio.borneo@st.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: a.fatoum@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On 24.11.20 23:37, Antonio Borneo wrote:
> Commit 757926247836 ("net: stmmac: add flexible PPS to dwmac
> 4.10a") was intended to modify the struct dwmac410_ops, but it got
> somehow badly merged and modified the struct dwmac4_ops.
> 
> Revert the modification in struct dwmac4_ops and re-apply it
> properly in struct dwmac410_ops.
> 
> Fixes: 757926247836 ("net: stmmac: add flexible PPS to dwmac 4.10a")
> Cc: stable@vger.kernel.org # v5.6+

I don't think extension of dwmac410_ops should be backported to stable.
It's a new feature and should go into net-next like any other.
The fix that could be backported is reverting the unintentional change
of dwmac4.

Cheers,
Ahmad

> Signed-off-by: Antonio Borneo <antonio.borneo@st.com>
> Reported-by: Ahmad Fatoum <a.fatoum@pengutronix.de>
> ---
> To: Alexandre Torgue <alexandre.torgue@st.com>
> To: Jose Abreu <joabreu@synopsys.com>
> To: "David S. Miller" <davem@davemloft.net>
> To: Jakub Kicinski <kuba@kernel.org>
> Cc: Maxime Coquelin <mcoquelin.stm32@gmail.com>
> Cc: netdev@vger.kernel.org
> Cc: linux-stm32@st-md-mailman.stormreply.com
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> In-Reply-To: <42960ede-9355-1277-9a6f-4eac3c22365c@pengutronix.de>
> ---
>  drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c b/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
> index 002791b77356..ced6d76a0d85 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
> @@ -1171,7 +1171,6 @@ const struct stmmac_ops dwmac4_ops = {
>  	.pcs_get_adv_lp = dwmac4_get_adv_lp,
>  	.debug = dwmac4_debug,
>  	.set_filter = dwmac4_set_filter,
> -	.flex_pps_config = dwmac5_flex_pps_config,
>  	.set_mac_loopback = dwmac4_set_mac_loopback,
>  	.update_vlan_hash = dwmac4_update_vlan_hash,
>  	.sarc_configure = dwmac4_sarc_configure,
> @@ -1213,6 +1212,7 @@ const struct stmmac_ops dwmac410_ops = {
>  	.pcs_get_adv_lp = dwmac4_get_adv_lp,
>  	.debug = dwmac4_debug,
>  	.set_filter = dwmac4_set_filter,
> +	.flex_pps_config = dwmac5_flex_pps_config,
>  	.set_mac_loopback = dwmac4_set_mac_loopback,
>  	.update_vlan_hash = dwmac4_update_vlan_hash,
>  	.sarc_configure = dwmac4_sarc_configure,
> 
> base-commit: 9bd2702d292cb7b565b09e949d30288ab7a26d51
> 

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
