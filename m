Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 879084A3813
	for <lists+netdev@lfdr.de>; Sun, 30 Jan 2022 19:37:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354682AbiA3SgG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Jan 2022 13:36:06 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:58484 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241414AbiA3SgF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Jan 2022 13:36:05 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 8EA40CE0FF6;
        Sun, 30 Jan 2022 18:36:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC96FC340E4;
        Sun, 30 Jan 2022 18:36:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643567761;
        bh=XvEsj4rrUwXADRhJ97QndmfLlrAeesLHInND6jQHj6U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EUd3dA60AJ0QmVZVjmjaJkNE7z52ATs8rV4XHXLVwJzf6dFXzKoOI3j0RDSgSB3hV
         MPIJkn95zFtuZOuzinFSwwD3vHeQ0D1pRXuD1gZVVEai865OwLjqFCOVa0doL0Je1W
         PfgAy/LYX2UaiVmfONvvts6DizDsqfppgClcEP0SSLg8ea9MAgeZRo9AIrMV5ez9fc
         lvX0/Qkm00/GNxuhzP95Y9bxS1Nx30S5A+UtHXo6Ryqymgo4X5EeiK4e3IMzAy385p
         qohMwgvrfIobZfiPWjNZEliAx2NZmutWWwK7ATL5WWkKZhK4hGROgzVKXQR3mTzcMk
         qnQVMo3a8/mlw==
Date:   Sun, 30 Jan 2022 20:35:57 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Joseph CHAMG <josright123@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, joseph_chang@davicom.com.tw,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, andy.shevchenko@gmail.com,
        andrew@lunn.ch
Subject: Re: [PATCH v16, 2/2] net: Add dm9051 driver
Message-ID: <YfbajbH86Q/enthp@unreal>
References: <20220129164346.5535-1-josright123@gmail.com>
 <20220129164346.5535-3-josright123@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220129164346.5535-3-josright123@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 30, 2022 at 12:43:46AM +0800, Joseph CHAMG wrote:
> Add davicom dm9051 spi ethernet driver, The driver work for the
> device platform which has the spi master
> 
> Signed-off-by: Joseph CHAMG <josright123@gmail.com>
> ---
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: Leon Romanovsky <leon@kernel.org>
> Cc: andy Shevchenko <andy.shevchenko@gmail.com>

<...>

> +static int dm9051_probe(struct spi_device *spi)
> +{
> +	struct device *dev = &spi->dev;
> +	struct net_device *ndev;
> +	struct board_info *db;
> +	int ret = 0;

<...>

> +	kthread_init_worker(&db->kw);
> +	kthread_init_work(&db->kw_rxctrl, dm9051_rxctl_delay);
> +	kthread_init_work(&db->kw_tx, dm9051_tx_delay);
> +
> +	db->kwr_task_kw = kthread_run(kthread_worker_fn, &db->kw, "dm9051");

It is very unlikely that simple driver like this will need kthreads, does it really need?

Thanks
