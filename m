Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87524FF5C3
	for <lists+netdev@lfdr.de>; Sat, 16 Nov 2019 22:14:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727741AbfKPVOa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Nov 2019 16:14:30 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:53952 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727485AbfKPVOa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Nov 2019 16:14:30 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 16535151A21BC;
        Sat, 16 Nov 2019 13:14:30 -0800 (PST)
Date:   Sat, 16 Nov 2019 13:14:29 -0800 (PST)
Message-Id: <20191116.131429.2205837170380620136.davem@davemloft.net>
To:     chenwandun@huawei.com
Cc:     joabreu@synopsys.com, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: stmmac: remove variable 'ret' set but not used
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1573876246-139122-1-git-send-email-chenwandun@huawei.com>
References: <1573876246-139122-1-git-send-email-chenwandun@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 16 Nov 2019 13:14:30 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Chen Wandun <chenwandun@huawei.com>
Date: Sat, 16 Nov 2019 11:50:46 +0800

> Fixes gcc '-Wunused-but-set-variable' warning:
> 
> drivers/net/ethernet/stmicro/stmmac/stmmac_main.c: In function stmmac_rx_buf1_len:
> drivers/net/ethernet/stmicro/stmmac/stmmac_main.c:3460:6: warning: variable ret set but not used [-Wunused-but-set-variable]
> 
> Signed-off-by: Chen Wandun <chenwandun@huawei.com>
> ---
>  drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> index 39b4efd..7003a30 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> @@ -3457,7 +3457,7 @@ static unsigned int stmmac_rx_buf1_len(struct stmmac_priv *priv,
>  				       struct dma_desc *p,
>  				       int status, unsigned int len)
>  {
> -	int ret, coe = priv->hw->rx_csum;
> +	int coe = priv->hw->rx_csum;
>  	unsigned int plen = 0, hlen = 0;

You are breaking the reverse christmas tree ordering of the local
variables here, please don't do that.
