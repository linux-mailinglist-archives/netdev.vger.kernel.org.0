Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BF6633FA29
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 21:56:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233285AbhCQU4C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 16:56:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:46490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233443AbhCQUzr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Mar 2021 16:55:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3309264E90;
        Wed, 17 Mar 2021 20:55:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616014546;
        bh=8YHIy2QJi0Zbnx676evVVkiFT4TAs3P+dNjW2VdjjY4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=j/NREaNObGhuCT7gWW8ChdtLt63hXPXIvf2zC/G9cSWGW/JgIAzi6lYKt3hLJfpEG
         hQrw8seR3wePUKUt4+1rOVdW16PMnPzALHoEdTR0wV6zfFQvfDKumpDO8c4Q1gT8KP
         6DSMJ85gp6wDzmLWGXcm2sy+r9aUJGVVThh7kFgQQnbB5l1P0gcuKUCBrXjIKbdEog
         5vMjmUIBGo0SCzLXQZxz4jz+Y8qG+6mM5025rEsV4fu/XPfclMUxNVSRy4AaNBFkOC
         r11ZVNpLFMdV/HiLv0C4cnR0+K6BzyOMQDhd5xrtNIO7EdlV0ghztnfmHld4wGsBL9
         TpXUHdUm686Vw==
Date:   Wed, 17 Mar 2021 13:55:44 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ong Boon Leong <boon.leong.ong@intel.com>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2 1/1] net: stmmac: add per-queue TX & RX
 coalesce ethtool support
Message-ID: <20210317135544.3da32504@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210317010123.6304-2-boon.leong.ong@intel.com>
References: <20210317010123.6304-1-boon.leong.ong@intel.com>
        <20210317010123.6304-2-boon.leong.ong@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 17 Mar 2021 09:01:23 +0800 Ong Boon Leong wrote:
> Extending the driver to support per-queue RX and TX coalesce settings in
> order to support below commands:
> 
> To show per-queue coalesce setting:-
>  $ ethtool --per-queue <DEVNAME> queue_mask <MASK> --show-coalesce
> 
> To set per-queue coalesce setting:-
>  $ ethtool --per-queue <DEVNAME> queue_mask <MASK> --coalesce \
>      [rx-usecs N] [rx-frames M] [tx-usecs P] [tx-frames Q]
> 
> Signed-off-by: Ong Boon Leong <boon.leong.ong@intel.com>

Acked-by: Jakub Kicinski <kuba@kernel.org>

> +	if (queue < tx_cnt) {
> +		ec->tx_coalesce_usecs = priv->tx_coal_timer[queue];
> +		ec->tx_max_coalesced_frames = priv->tx_coal_frames[queue];
> +	} else {
> +		ec->tx_coalesce_usecs = 0;
> +		ec->tx_max_coalesced_frames = 0;

nit: I think the struct is initialized to 0 so there is no need to set
it explicitly.
