Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4FFA017ED65
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 01:48:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727550AbgCJAsS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 20:48:18 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:34202 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727287AbgCJAsS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Mar 2020 20:48:18 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 57F1415A0069C;
        Mon,  9 Mar 2020 17:48:17 -0700 (PDT)
Date:   Mon, 09 Mar 2020 17:48:16 -0700 (PDT)
Message-Id: <20200309.174816.1763845933351180364.davem@davemloft.net>
To:     andre.przywara@arm.com
Cc:     radhey.shyam.pandey@xilinx.com, michal.simek@xilinx.com,
        hancock@sedsystems.ca, netdev@vger.kernel.org,
        rmk+kernel@arm.linux.org.uk, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, andrew@lunn.ch
Subject: Re: [PATCH v2 06/14] net: axienet: Factor out TX descriptor chain
 cleanup
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200309181851.190164-7-andre.przywara@arm.com>
References: <20200309181851.190164-1-andre.przywara@arm.com>
        <20200309181851.190164-7-andre.przywara@arm.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 09 Mar 2020 17:48:17 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andre Przywara <andre.przywara@arm.com>
Date: Mon,  9 Mar 2020 18:18:43 +0000

> -static void axienet_start_xmit_done(struct net_device *ndev)
> +static int axienet_free_tx_chain(struct net_device *ndev, u32 first_bd,
> +				 int nr_bds, u32 *sizep)
>  {
> -	u32 size = 0;
> -	u32 packets = 0;
>  	struct axienet_local *lp = netdev_priv(ndev);
> +	int max_bds = (nr_bds != -1) ? nr_bds : lp->tx_bd_num;
>  	struct axidma_bd *cur_p;
> -	unsigned int status = 0;
> +	unsigned int status;
> +	int i;

Please use reverse christms tree ordering for local variable
declarations.

> +static void axienet_start_xmit_done(struct net_device *ndev)
> +{
> +	u32 size = 0;
> +	u32 packets = 0;
> +	struct axienet_local *lp = netdev_priv(ndev);

Likewise.
