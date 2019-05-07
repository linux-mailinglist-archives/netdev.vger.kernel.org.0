Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B342F16B9C
	for <lists+netdev@lfdr.de>; Tue,  7 May 2019 21:44:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726521AbfEGTn7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 May 2019 15:43:59 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:33610 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726360AbfEGTn7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 May 2019 15:43:59 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 676D614B8AF42;
        Tue,  7 May 2019 12:43:58 -0700 (PDT)
Date:   Tue, 07 May 2019 12:43:58 -0700 (PDT)
Message-Id: <20190507.124358.1158001675039394639.davem@davemloft.net>
To:     maxime.chevallier@bootlin.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        antoine.tenart@bootlin.com, thomas.petazzoni@bootlin.com,
        gregory.clement@bootlin.com, miquel.raynal@bootlin.com,
        nadavh@marvell.com, stefanc@marvell.com, mw@semihalf.com,
        linux@armlinux.org.uk, linux-arm-kernel@lists.infradead.org,
        jakub.kicinski@netronome.com
Subject: Re: [PATCH net] net: mvpp2: cls: Add missing NETIF_F_NTUPLE flag
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190507123635.17782-1-maxime.chevallier@bootlin.com>
References: <20190507123635.17782-1-maxime.chevallier@bootlin.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 07 May 2019 12:43:58 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxime Chevallier <maxime.chevallier@bootlin.com>
Date: Tue,  7 May 2019 14:36:35 +0200

> Now that the mvpp2 driver supports classification offloading, we must
> add the NETIF_F_NTUPLE to the features list.
> 
> Fixes: 90b509b39ac9 ("net: mvpp2: cls: Add Classification offload support")
> Reported-by: Jakub Kicinski <jakub.kicinski@netronome.com>
> Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
> ---
> Hello David,
> 
> This patch applies on top of a commit 90b509b39ac9, which is in net-next
> but hasn't made it to -net yet.
> 
> Thanks,
> 
> Maxime
> 
>  drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> index 25fbed2b8d94..1f164c893936 100644
> --- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> +++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> @@ -5040,8 +5040,10 @@ static int mvpp2_port_probe(struct platform_device *pdev,
>  	dev->hw_features |= features | NETIF_F_RXCSUM | NETIF_F_GRO |
>  			    NETIF_F_HW_VLAN_CTAG_FILTER;
>  
> -	if (mvpp22_rss_is_supported())
> +	if (mvpp22_rss_is_supported()) {
>  		dev->hw_features |= NETIF_F_RXHASH;
> +		dev->features |= NETIF_F_NTUPLE;
> +	}

As Jakub said, this definitely looks like a typo and this should
be hw_features.
