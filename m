Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1806680E72
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 14:05:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237011AbjA3NFn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 08:05:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230197AbjA3NFi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 08:05:38 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07F071ABF4;
        Mon, 30 Jan 2023 05:05:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9EBF4B810A2;
        Mon, 30 Jan 2023 13:05:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 957ADC433D2;
        Mon, 30 Jan 2023 13:05:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675083927;
        bh=hostjZC2cEK6LQ7/wLXYkG/d8rmJJWmNJeHg4Ky6HiI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=i+/EzoL/ErHS0sycIQKw8F9/zjfidNjF7sAEoPDorZnBCw0uhB7nuIdlz4cxtnwob
         TnhjatbH398JUB6IHc4lLBfORlb8qhO0BFKFIyPJO9kSUDqCnp/FfAoXF+KF3cYUsf
         Dv4ezOLYtzH3Hrgjz/u2KU/6jQ4PL4nHzEk/kGu8=
Date:   Mon, 30 Jan 2023 14:05:22 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Nikita Zhandarovich <n.zhandarovich@fintech.ru>
Cc:     stable@vger.kernel.org, Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>,
        Ryder Lee <ryder.lee@mediatek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        lvc-project@linuxtesting.org
Subject: Re: [PATCH 5.10 1/1] mt76: fix mt7615_init_tx_queues() return value
Message-ID: <Y9fAkt/5BRist//g@kroah.com>
References: <20230130123655.86339-1-n.zhandarovich@fintech.ru>
 <20230130123655.86339-2-n.zhandarovich@fintech.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230130123655.86339-2-n.zhandarovich@fintech.ru>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 30, 2023 at 04:36:55AM -0800, Nikita Zhandarovich wrote:
> mt7615_init_tx_queues() returns 0 regardless of how final
> mt7615_init_tx_queue() performs. If mt7615_init_tx_queue() fails (due to
> memory issues, for instance), parent function will still erroneously
> return 0.
> 
> This change takes into account ret value of mt7615_init_tx_queue()
> when finishing up mt7615_init_tx_queues().
> 
> Fixes: 04b8e65922f6 ("mt76: add mac80211 driver for MT7615 PCIe-based chipsets")
> Signed-off-by: Nikita Zhandarovich <n.zhandarovich@fintech.ru>
> 
>  drivers/net/wireless/mediatek/mt76/mt7615/dma.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

What is the git commit id of this upstream?

And I can't apply this as-is for the obvious reason it would mess up the
changelog, how did you create this?

confused,

greg k-h
