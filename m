Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA3A1483AE6
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 04:17:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232508AbiADDRc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jan 2022 22:17:32 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:49016 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231345AbiADDRb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jan 2022 22:17:31 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7CF51611E2;
        Tue,  4 Jan 2022 03:17:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05BEAC36AEF;
        Tue,  4 Jan 2022 03:17:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641266250;
        bh=N5aXv+g7yyoC2VpWDcYgU1XVT6uLufQ66vuWLo0gKIs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=TDTSJ9mmX4Vb6JZx5S5sW+uOZdLDRoB+5jHX1Ez6JcWBdxItH1nF3PnAh83rmqbvV
         ADPQzlyJrqtZqQFnvwu6qub2j0Y6MRAhFUX1fZInYpmbWrBjJAa8wzqTwWPGBAnEM7
         mVgcIh4FdgoaNbxdtNneLmB/zLFZ5kW01sXCG8uhokOL3zZUoJJgnHRzuk3b011ROx
         yiOt7x805ycxbMgxm2+qva1i8Zvo65/6K9yI2BwDEzxZbZc1KXyQIm41S0H1FkX28A
         XypVPW+VFfWPX19lTidL5pBcUqRloEFIuchr/OOvZ5X98sGAoBDXUP92e+vfaCQG3G
         nPwm5R/Ln8XGQ==
Date:   Mon, 3 Jan 2022 19:17:29 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sam Ravnborg <sam@ravnborg.org>
Cc:     Miaoqian Lin <linmq006@gmail.com>, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 1/1] Revert "net: phy: fixed_phy: Fix NULL vs
 IS_ERR() checking in __fixed_phy_register"
Message-ID: <20220103191515.66280992@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20220102113557.302941-2-sam@ravnborg.org>
References: <20220102113557.302941-1-sam@ravnborg.org>
        <20220102113557.302941-2-sam@ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun,  2 Jan 2022 12:35:57 +0100 Sam Ravnborg wrote:
> This reverts commit b45396afa4177f2b1ddfeff7185da733fade1dc3.
> 
> With the referenced patch applied the following error was seen
> in the kernel log:
> 
> 	fec 2188000.ethernet: broken fixed-link specification
> 	fec: probe of 2188000.ethernet failed with error -22
> 
> The problem is that the implementation makes the
> link-gpios node mandatory - which is not the case.
> 
> fixed_phy_get_gpiod() may return -EPROBE_DEFER so this code needs
> to use IS_ERR() check and the original code was fine.
> 
> Fixes: b45396afa417 ("net: phy: fixed_phy: Fix NULL vs IS_ERR() checking in __fixed_phy_register")
> Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
> Cc: Miaoqian Lin <linmq006@gmail.com>
> Cc: Jakub Kicinski <kuba@kernel.org>

This patch didn't register in patchwork for some reason, I applied 
a very similar patch from Florian instead:

https://patchwork.kernel.org/project/netdevbpf/patch/20220103193453.1214961-1-f.fainelli@gmail.com/

Not sure why patchwork and lore did not see your posting, sorry :S
