Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B2881B32B4
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 00:42:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726358AbgDUWl4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 18:41:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725850AbgDUWl4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Apr 2020 18:41:56 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2B80C0610D5;
        Tue, 21 Apr 2020 15:41:55 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id BCEF3128E6F27;
        Tue, 21 Apr 2020 15:41:54 -0700 (PDT)
Date:   Tue, 21 Apr 2020 15:41:53 -0700 (PDT)
Message-Id: <20200421.154153.172396683183248740.davem@davemloft.net>
To:     vee.khee.wong@intel.com
Cc:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, mcoquelin.stm32@gmail.com,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        boon.leong.ong@intel.com, weifeng.voon@intel.com
Subject: Re: [PATCH net-next 1/1] net: stmmac: Add support for VLAN
 promiscuous mode
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200420033359.11610-1-vee.khee.wong@intel.com>
References: <20200420033359.11610-1-vee.khee.wong@intel.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 21 Apr 2020 15:41:55 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wong Vee Khee <vee.khee.wong@intel.com>
Date: Mon, 20 Apr 2020 11:33:59 +0800

> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> index e6898fd5223f..80250c7be783 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> @@ -4877,7 +4877,6 @@ int stmmac_dvr_probe(struct device *device,
>  		}
>  	}
>  
> -	ndev->features |= ndev->hw_features | NETIF_F_HIGHDMA;
>  	ndev->watchdog_timeo = msecs_to_jiffies(watchdog);
>  #ifdef STMMAC_VLAN_TAG_USED
>  	/* Both mac100 and gmac support receive VLAN tag detection */
> @@ -4892,6 +4891,7 @@ int stmmac_dvr_probe(struct device *device,
>  			ndev->features |= NETIF_F_HW_VLAN_STAG_TX;
>  	}
>  #endif
> +	ndev->features |= ndev->hw_features | NETIF_F_HIGHDMA;
>  	priv->msg_enable = netif_msg_init(debug, default_msg_level);

This change has no effect, because hw_features does not change across
this code block you are moving the line across.

So please remove this part of the patch it is pointless and makes your
change harder to review.

