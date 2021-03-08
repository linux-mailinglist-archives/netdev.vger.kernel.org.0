Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F90333160E
	for <lists+netdev@lfdr.de>; Mon,  8 Mar 2021 19:30:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229730AbhCHS31 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Mar 2021 13:29:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231254AbhCHS3B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Mar 2021 13:29:01 -0500
Received: from mout-p-101.mailbox.org (mout-p-101.mailbox.org [IPv6:2001:67c:2050::465:101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDBCFC06174A
        for <netdev@vger.kernel.org>; Mon,  8 Mar 2021 10:29:00 -0800 (PST)
Received: from smtp2.mailbox.org (smtp2.mailbox.org [80.241.60.241])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-101.mailbox.org (Postfix) with ESMTPS id 4DvRgY4wpDzQjwp;
        Mon,  8 Mar 2021 19:28:57 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mailbox.org; h=
        content-transfer-encoding:content-type:content-type:mime-version
        :references:in-reply-to:message-id:subject:subject:from:from
        :date:date:received; s=mail20150812; t=1615228132; bh=xe3cIOx7yk
        5hGgWBHXhtvAV+EMp6+77X4FIRKW11beM=; b=dQvE9TqvzIDA4VAFIQWGoR0n8m
        c3DlRuPvXviWpdSV5ImU3lvMh6i4gXYHzCqro7eGX+ynkmODsPsIbwGVoBuZuEzu
        7moTwprSesraYVB9kqVpuKk7o3PXDw2Rm72wNepgzsDzYS/xlMO8Jv/1ZxYojqcm
        exjXX6KWML1rBoY9QXs1yfP7cfSqaPdfTvMkP47LZ07vYBrhlnM2qZ2Za9jwToa1
        WEORBOFHmvWXbMC0u/ijI/sYxu93u9WrrC8V10MbWloQ+h3ZORMPZY7NOYfZGCBA
        rQ7iGuH1AZUiolLAfKrFxU3+4G8qU6CdeQtK+ceJWSbmjz6xhN7x5+fzUEVQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
        t=1615228133;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6wTcrrq3uEtYYMJGRkofwY/gJu+CXcCgsaup1py6NVo=;
        b=fN3PP/oQ0Fc+0XZG18N631AofsCNKhYED9sw+N/e5qVAOg4WQGdy8yPdTxWxaoE4eX8OzU
        H9gFpSV/V7uAWix5zc3NGjq71ybt3jMPu+fdKp2ZP4GQLRrVPZmOPc7xoHLgh0HrPKQe8k
        UBYubNzqb/OBkn4uiEfD3ztl1hle8fg0Fa6e0nk8fdgMlvphZC6NR9SkjMOwtOckwRu0+A
        Weg/8GEyMKQC5rKKinbjEwdpk1KxbgcBi3mYahKBC54k2DDER6U+IkkbNLo7NI4kBMapck
        dQensBWSz4S3sME1d3xJ74Z5YoDJThXsNzV4EOuCJZVH8NHyMvBNmLTaL01QUA==
X-Virus-Scanned: amavisd-new at heinlein-support.de
Received: from smtp2.mailbox.org ([80.241.60.241])
        by spamfilter01.heinlein-hosting.de (spamfilter01.heinlein-hosting.de [80.241.56.115]) (amavisd-new, port 10030)
        with ESMTP id 4QII7ZAtGOro; Mon,  8 Mar 2021 19:28:52 +0100 (CET)
Date:   Mon, 8 Mar 2021 19:28:49 +0100
From:   "Erhard F." <erhard_f@mailbox.org>
To:     "Ahmed S. Darwish" <a.darwish@linutronix.de>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: seqlock lockdep false positives?
Message-ID: <20210308192849.153454f7@yea>
In-Reply-To: <YESayEskbtjEWjFd@lx-t490>
References: <20210303164035.1b9a1d07@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <YESayEskbtjEWjFd@lx-t490>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-MBO-SPAM-Probability: 
X-Rspamd-Score: -3.49 / 15.00 / 15.00
X-Rspamd-Queue-Id: AB4CD180D
X-Rspamd-UID: 4b7a61
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 7 Mar 2021 10:20:08 +0100
"Ahmed S. Darwish" <a.darwish@linutronix.de> wrote:

> @Erhard, can you please try below patch? Just want to confirm if this
> theory has any validity to it:
> 
> diff --git a/drivers/net/ethernet/realtek/8139too.c b/drivers/net/ethernet/realtek/8139too.c
> index 1e5a453dea14..c0dbb0418e9d 100644
> --- a/drivers/net/ethernet/realtek/8139too.c
> +++ b/drivers/net/ethernet/realtek/8139too.c
> @@ -715,6 +715,11 @@ static const unsigned int rtl8139_rx_config =
>  static const unsigned int rtl8139_tx_config =
>  	TxIFG96 | (TX_DMA_BURST << TxDMAShift) | (TX_RETRY << TxRetryShift);
> 
> +#if BITS_PER_LONG==32 && defined(CONFIG_SMP)
> +static struct lock_class_key rx_stats_key;
> +static struct lock_class_key tx_stats_key;
> +#endif
> +
>  static void __rtl8139_cleanup_dev (struct net_device *dev)
>  {
>  	struct rtl8139_private *tp = netdev_priv(dev);
> @@ -794,8 +799,17 @@ static struct net_device *rtl8139_init_board(struct pci_dev *pdev)
> 
>  	pci_set_master (pdev);
> 
> -	u64_stats_init(&tp->rx_stats.syncp);
> -	u64_stats_init(&tp->tx_stats.syncp);
> +#if BITS_PER_LONG==32 && defined(CONFIG_SMP)
> +	dev_warn(d, "Manually intializing tx/rx stats sequence counters\n");
> +
> +	tp->rx_stats.syncp.seq.sequence = 0;
> +	lockdep_set_class_and_name(&tp->rx_stats.syncp.seq,
> +				   &rx_stats_key, "RX stats");
> +
> +	tp->tx_stats.syncp.seq.sequence = 0;
> +	lockdep_set_class_and_name(&tp->tx_stats.syncp.seq,
> +				   &tx_stats_key, "TX stats");
> +#endif

Hi Ahmed!

With your patch on top of 5.12-rc2 the lockdep splat is gone in the kernel dmesg and I only get:

[...]
8139too: 8139too Fast Ethernet driver 0.9.28
8139too 0000:00:0f.0: Manually intializing tx/rx stats sequence counters
8139too 0000:00:0f.0 eth0: RealTek RTL8139 at 0x(ptrval), 00:30:1b:2f:2c:58, IRQ 18
[...]

Trying Peter's patch next.
