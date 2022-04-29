Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE39851402B
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 03:17:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353891AbiD2BVB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 21:21:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353899AbiD2BU7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 21:20:59 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F148A27D7;
        Thu, 28 Apr 2022 18:17:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=O9pUYhhH3JjB4bYekaDZNfAjeT/hCD3xZYJMBVY/T/M=; b=bftl6e4qZsIoErRIgXmGOj/NPT
        0qG6PYkJlvp59JBGHrEngE0vsNggUacvelu46RvmaMfPdtR1MTEwywmIJ2gXQMTxceju31QP3C4yC
        VwLSB1GsFhY5sg/GncOkUuHEsRwbaYsKxfQYOhl8VfP3KaeENbREJ1hg14TMA25bC93g=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nkFGK-000P75-Dh; Fri, 29 Apr 2022 03:17:36 +0200
Date:   Fri, 29 Apr 2022 03:17:36 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        michal.simek@xilinx.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        git@xilinx.com, Shravya Kumbham <shravya.kumbham@xilinx.com>
Subject: Re: [PATCH 2/2] net: emaclite: Add error handling for
 of_address_to_resource()
Message-ID: <Yms8sJzJe6Cl2x7J@lunn.ch>
References: <1651163278-12701-1-git-send-email-radhey.shyam.pandey@xilinx.com>
 <1651163278-12701-3-git-send-email-radhey.shyam.pandey@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1651163278-12701-3-git-send-email-radhey.shyam.pandey@xilinx.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 28, 2022 at 09:57:58PM +0530, Radhey Shyam Pandey wrote:
> From: Shravya Kumbham <shravya.kumbham@xilinx.com>
> 
> check the return value of of_address_to_resource() and also add
> missing of_node_put() for np and npp nodes.
> 
> Addresses-Coverity: Event check_return value.
> Signed-off-by: Shravya Kumbham <shravya.kumbham@xilinx.com>
> Signed-off-by: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
> ---
>  drivers/net/ethernet/xilinx/xilinx_emaclite.c |   15 ++++++++++++---
>  1 files changed, 12 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/ethernet/xilinx/xilinx_emaclite.c b/drivers/net/ethernet/xilinx/xilinx_emaclite.c
> index f9cf86e..c281423 100644
> --- a/drivers/net/ethernet/xilinx/xilinx_emaclite.c
> +++ b/drivers/net/ethernet/xilinx/xilinx_emaclite.c
> @@ -803,7 +803,7 @@ static int xemaclite_mdio_write(struct mii_bus *bus, int phy_id, int reg,
>  static int xemaclite_mdio_setup(struct net_local *lp, struct device *dev)
>  {
>  	struct mii_bus *bus;
> -	int rc;
> +	int rc, ret;
>  	struct resource res;
>  	struct device_node *np = of_get_parent(lp->phy_node);
>  	struct device_node *npp;

Reverse Chritmas tree is messed up here, but you could make it a bet
less messed up by moving rc, ret further down.

     Andrew
