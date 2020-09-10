Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96A3A265001
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 21:58:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726805AbgIJT6k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 15:58:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725820AbgIJT5y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 15:57:54 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CCC7C061756;
        Thu, 10 Sep 2020 12:57:53 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id DF39412A3546A;
        Thu, 10 Sep 2020 12:41:04 -0700 (PDT)
Date:   Thu, 10 Sep 2020 12:57:50 -0700 (PDT)
Message-Id: <20200910.125750.498770212913076506.davem@davemloft.net>
To:     yoshihiro.shimoda.uh@renesas.com
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        kuba@kernel.org, Jisheng.Zhang@synaptics.com,
        netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v2 RESEND] net: phy: call phy_disable_interrupts() in
 phy_attach_direct() instead
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1599630194-3052-1-git-send-email-yoshihiro.shimoda.uh@renesas.com>
References: <1599630194-3052-1-git-send-email-yoshihiro.shimoda.uh@renesas.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Thu, 10 Sep 2020 12:41:05 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Date: Wed,  9 Sep 2020 14:43:14 +0900

> Since the micrel phy driver calls phy_init_hw() as a workaround,
> the commit 9886a4dbd2aa ("net: phy: call phy_disable_interrupts()
> in phy_init_hw()") disables the interrupt unexpectedly. So,
> call phy_disable_interrupts() in phy_attach_direct() instead.
> Otherwise, the phy cannot link up after the ethernet cable was
> disconnected.
> 
> Note that other drivers (like at803x.c) also calls phy_init_hw().
> So, perhaps, the driver caused a similar issue too.
> 
> Fixes: 9886a4dbd2aa ("net: phy: call phy_disable_interrupts() in phy_init_hw()")
> Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
> ---
>  Changes from v1:
>  - Fix build failure. I used two PCs: PC 1) for testing, PC 2) for
>    submitting patches. I tested on the PC 1. But, after that, I wrote
>    a patch on the PC2 again, and it seemed I didn't do a compile...
>    Today, I got some emails from kernel test bot. So, I realized
>    I had submitted an awful patch. To avoid such failure, I'll use
>    one PC only from now on.
> 

Applied and queued up for -stable, thanks.
