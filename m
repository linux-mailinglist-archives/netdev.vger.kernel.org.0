Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA2503F4EA3
	for <lists+netdev@lfdr.de>; Mon, 23 Aug 2021 18:44:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230154AbhHWQpK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Aug 2021 12:45:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:39036 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229454AbhHWQpJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Aug 2021 12:45:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 55BF6610F8;
        Mon, 23 Aug 2021 16:44:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629737066;
        bh=7w5FXWeb8P/JBu4RqLDy7fzGAXbval5K4YO4wkz3Tn8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=QRPsy8S1buyVDP9dLd+eDgJJ0x7b+mpjd+QiKp17gSoCfIyr9cTC4G+Px9ZSVsWbl
         OdMipVIHQKzyX4St+fNM8uMsktO3/osoQjVeJb+ijLUj8UaVHBY/dPo+oZdngbIXh0
         ep3Odv0n41HiNoR6MKshMxFAVDF3GuvV55qj3gaFSjUPLv194qHl5K/prEJ2Jauk+C
         e7gxbFkoiMd3hTXRZB1zMeM+AORbj1pyS+jfibY7MCqLj9NvEk/Y1qiEDIlMLsUvUO
         1HifTcI35mpL7oJFxzbg1laOWr4bUQKUdazBHG6sSSPv2vX4rvZJvnGTTJXsBfuyAM
         O0suswGiISgGQ==
Date:   Mon, 23 Aug 2021 09:44:25 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Michael Riesch <michael.riesch@wolfvision.net>
Cc:     netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-rockchip@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>
Subject: Re: [PATCH] net: stmmac: dwmac-rk: fix unbalanced pm_runtime_enable
 warnings
Message-ID: <20210823094425.78d7a73e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210823143754.14294-1-michael.riesch@wolfvision.net>
References: <20210823143754.14294-1-michael.riesch@wolfvision.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 23 Aug 2021 16:37:54 +0200 Michael Riesch wrote:
> In the commit to be reverted, support for power management was
> introduced to the Rockchip glue code. Later, power management support
> was introduced to the stmmac core code, resulting in multiple
> invocations of pm_runtime_{enable,disable,get_sync,put_sync}.

Can we get a Fixes tag? I.e. reference to the earliest commit where 
the warning can be triggered?

> The multiple invocations happen in rk_gmac_powerup and
> stmmac_{dvr_probe, resume} as well as in rk_gmac_powerdown and
> stmmac_{dvr_remove, suspend}, respectively, which are always called
> in conjunction.
