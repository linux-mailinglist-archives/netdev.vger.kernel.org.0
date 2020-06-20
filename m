Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B37B202027
	for <lists+netdev@lfdr.de>; Sat, 20 Jun 2020 05:21:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732597AbgFTDVA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jun 2020 23:21:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732271AbgFTDVA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jun 2020 23:21:00 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8AAFC06174E
        for <netdev@vger.kernel.org>; Fri, 19 Jun 2020 20:20:59 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8B5E2127853D0;
        Fri, 19 Jun 2020 20:20:59 -0700 (PDT)
Date:   Fri, 19 Jun 2020 20:20:58 -0700 (PDT)
Message-Id: <20200619.202058.334256505365421992.davem@davemloft.net>
To:     rmk+kernel@armlinux.org.uk
Cc:     antoine.tenart@bootlin.com, alexandre.belloni@bootlin.com,
        kuba@kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 2/4] net: mvpp2: add mvpp2_phylink_to_port()
 helper
From:   David Miller <davem@davemloft.net>
In-Reply-To: <E1jlwct-0005Hj-6W@rmk-PC.armlinux.org.uk>
References: <20200618153818.GD1551@shell.armlinux.org.uk>
        <E1jlwct-0005Hj-6W@rmk-PC.armlinux.org.uk>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 19 Jun 2020 20:20:59 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Russell King <rmk+kernel@armlinux.org.uk>
Date: Thu, 18 Jun 2020 16:38:51 +0100

> diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> index 7653277d03b7..8c8314715efd 100644
> --- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> +++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> @@ -4767,12 +4767,17 @@ static void mvpp2_port_copy_mac_addr(struct net_device *dev, struct mvpp2 *priv,
>  	eth_hw_addr_random(dev);
>  }
>  
> +static inline struct mvpp2_port *
> +mvpp2_phylink_to_port(struct phylink_config *config)
> +{
> +	return container_of(config, struct mvpp2_port, phylink_config);
> +}

Please don't use inline in foo.c files, thank you.
