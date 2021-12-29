Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 928B6480E52
	for <lists+netdev@lfdr.de>; Wed, 29 Dec 2021 01:48:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238061AbhL2AsW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Dec 2021 19:48:22 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:52902 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232172AbhL2AsV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Dec 2021 19:48:21 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7390DB80E71;
        Wed, 29 Dec 2021 00:48:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9F6DC36AE7;
        Wed, 29 Dec 2021 00:48:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640738899;
        bh=5HGImFJh4OU1O1/jkG5ZRkqRPVGbrKjR/0JU+I+ljLg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=VO0Sd2aQ0WXwVjMEGkQ4JWYNtguGzCnPIfLTVP1C+Vm1IcrXs4TNMmbAMOSAGW6xH
         RoUtnqJmGDtn7xliaqc+YWp2QYqtmfB7OrH88TThlekGdG94nvAeKKrWsHPF2Vemmq
         mKE5/lkxopyRDZKRzEPjGGBNgHF2R632V+T6FqxdeyVlVj+KG+ePkFds6B0uLjxXVj
         JJPanCmM26oiRilRHcIII6ZHeJMhdU3x7Xg5S8s2YI0xLqxP60TUk24xKHGWSgE1sN
         q0p6HUWEc+/5w9pAJS6s1wQrnTxtC6IEpiqopfUnZUXWY0ERVh3JDclKwsXvw6DK27
         +foTrfAa7ZPtg==
Date:   Tue, 28 Dec 2021 16:48:17 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     conleylee@foxmail.com
Cc:     davem@davemloft.net, mripard@kernel.org, wens@csie.org,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5] sun4i-emac.c: add dma support
Message-ID: <20211228164817.1297c1c9@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <tencent_A7052D6C7B1E2AEFA505D7A52E5B974D8508@qq.com>
References: <tencent_95A0609A0DC523F7DDAE60A8746EABAA8905@qq.com>
        <tencent_A7052D6C7B1E2AEFA505D7A52E5B974D8508@qq.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 28 Dec 2021 19:42:04 +0800 conleylee@foxmail.com wrote:
> +static void free_emac_dma_req(struct emac_dma_req *req)

emac_free_dma_req

> +prepare_err:
> +	dma_unmap_single(db->dev, rxbuf, count, DMA_FROM_DEVICE);
> +    return ret;

incorrect whitespace here

> @@ -599,12 +721,25 @@ static void emac_rx(struct net_device *dev)
>  			if (!skb)
>  				continue;
>  			skb_reserve(skb, 2);
> -			rdptr = skb_put(skb, rxlen - 4);
>  
>  			/* Read received packet from RX SRAM */
>  			if (netif_msg_rx_status(db))
>  				dev_dbg(db->dev, "RxLen %x\n", rxlen);
>  
> +			rdptr = skb_put(skb, rxlen - 4);

no reason to move this line
