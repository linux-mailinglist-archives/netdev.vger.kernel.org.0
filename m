Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5303845D30E
	for <lists+netdev@lfdr.de>; Thu, 25 Nov 2021 03:15:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238540AbhKYCSW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 21:18:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:42666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238802AbhKYCQV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Nov 2021 21:16:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7C8F4610FB;
        Thu, 25 Nov 2021 02:13:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637806390;
        bh=m9FcDsm/lGhALtGhZnts3c26K04Oz4Z+dAoew+wyt08=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=cemXlSvSTyjwXHhRstTO+WqwyBsKNbNg5h29un7VflWajXKixtsYVUoGBtpnerTDe
         qLdAhLQElJNnRsUjQK4cUj2aih4je/9HNXMyLuUfz4a5b7XnDYaQUSLW8kbSKNfcR0
         tsp2fDcNBvFXI3lR6p7ZaBg2cBHpzQfvdCkgmEl+BJj354eohDT1xAyEKMv7BevYl4
         Eo/swfHn2m/zb9zdjo8DP0C9elk+z18Hjmb6HFC79Zdl4F74qrBIr/kcG8xtAMXmvM
         noanjxKPQ7SMEAl7bfoNDks9ZbajpdlMP8eR7k39o1cSzb6IrsWyg6nAWwzIzSHW+X
         BO8CqiFvNh8hQ==
Date:   Wed, 24 Nov 2021 18:13:09 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     xiangxia.m.yue@gmail.com
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next] veth: use ethtool_sprintf instead of snprintf
Message-ID: <20211124181309.32cd739e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211125015438.5355-1-xiangxia.m.yue@gmail.com>
References: <20211125015438.5355-1-xiangxia.m.yue@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 25 Nov 2021 09:54:38 +0800 xiangxia.m.yue@gmail.com wrote:
>  		for (i = 0; i < dev->real_num_rx_queues; i++) {
> -			for (j = 0; j < VETH_RQ_STATS_LEN; j++) {
> -				snprintf(p, ETH_GSTRING_LEN,
> -					 "rx_queue_%u_%.18s",
> -					 i, veth_rq_stats_desc[j].desc);
> -				p += ETH_GSTRING_LEN;
> -			}
> +			for (j = 0; j < VETH_RQ_STATS_LEN; j++)
> +				ethtool_sprintf(&p, "rx_queue_%u_%.18s",
> +						i, veth_rq_stats_desc[j].desc);
>  		}
>  		for (i = 0; i < dev->real_num_tx_queues; i++) {
> -			for (j = 0; j < VETH_TQ_STATS_LEN; j++) {
> -				snprintf(p, ETH_GSTRING_LEN,
> -					 "tx_queue_%u_%.18s",
> -					 i, veth_tq_stats_desc[j].desc);
> -				p += ETH_GSTRING_LEN;
> -			}
> +			for (j = 0; j < VETH_TQ_STATS_LEN; j++)
> +				ethtool_sprintf(&p, "tx_queue_%u_%.18s",
> +						i, veth_tq_stats_desc[j].desc);
>  		}

You can drop the brackets from the outside for as well.
