Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24E1B1D8022
	for <lists+netdev@lfdr.de>; Mon, 18 May 2020 19:29:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728376AbgERR3p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 13:29:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:57624 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726958AbgERR3p (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 May 2020 13:29:45 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 35A6E20715;
        Mon, 18 May 2020 17:29:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589822984;
        bh=GbXVQnZpxLekbr4Sys/mEjkMWI6UHS1T656yS2bb/X0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=mftvPHjdu02ZEoh0elInaEV+MZn8AWq6UqwXtOCCN9GDBWYEcNN3Ukr5HegRQomBs
         4Io8aZAeFvrx8INCKRzKMhizd1JCNRXv7u+kqHeood9e1SWdemVNKDaMzYuZcAYFP3
         Ernsfy58FoZX+ZJnF8DLU5mRWSEdL4YGAQIvVn0g=
Date:   Mon, 18 May 2020 10:29:42 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Marek Vasut <marex@denx.de>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Lukas Wunner <lukas@wunner.de>, Petr Stetiar <ynezz@true.cz>,
        YueHaibing <yuehaibing@huawei.com>
Subject: Re: [PATCH V6 16/20] net: ks8851: Implement register, FIFO, lock
 accessor callbacks
Message-ID: <20200518102942.0d368e70@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <ecd84056-ef96-423e-7f14-1dc89fa378a4@denx.de>
References: <20200517003354.233373-1-marex@denx.de>
        <20200517003354.233373-17-marex@denx.de>
        <20200518093422.38a52ca7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <ecd84056-ef96-423e-7f14-1dc89fa378a4@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 18 May 2020 19:06:45 +0200 Marek Vasut wrote:
> On 5/18/20 6:34 PM, Jakub Kicinski wrote:
> > On Sun, 17 May 2020 02:33:50 +0200 Marek Vasut wrote:  
> >> The register and FIFO accessors are bus specific, so is locking.
> >> Implement callbacks so that each variant of the KS8851 can implement
> >> matching accessors and locking, and use the rest of the common code.
> >>
> >> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> >> Signed-off-by: Marek Vasut <marex@denx.de>
> >> Cc: David S. Miller <davem@davemloft.net>
> >> Cc: Lukas Wunner <lukas@wunner.de>
> >> Cc: Petr Stetiar <ynezz@true.cz>
> >> Cc: YueHaibing <yuehaibing@huawei.com>  
> > 
> > drivers/net/ethernet/micrel/ks8851.c:138: warning: Function parameter or member '____cacheline_aligned' not described in 'ks8851_net'
> > drivers/net/ethernet/micrel/ks8851.c:138: warning: Function parameter or member 'tx_space' not described in 'ks8851_net'
> > drivers/net/ethernet/micrel/ks8851.c:138: warning: Function parameter or member 'lock' not described in 'ks8851_net'
> > drivers/net/ethernet/micrel/ks8851.c:138: warning: Function parameter or member 'unlock' not described in 'ks8851_net'
> > drivers/net/ethernet/micrel/ks8851.c:138: warning: Function parameter or member 'rdreg16' not described in 'ks8851_net'
> > drivers/net/ethernet/micrel/ks8851.c:138: warning: Function parameter or member 'wrreg16' not described in 'ks8851_net'
> > drivers/net/ethernet/micrel/ks8851.c:138: warning: Function parameter or member 'rdfifo' not described in 'ks8851_net'
> > drivers/net/ethernet/micrel/ks8851.c:138: warning: Function parameter or member 'wrfifo' not described in 'ks8851_net'
> > drivers/net/ethernet/micrel/ks8851.c:138: warning: Function parameter or member 'start_xmit' not described in 'ks8851_net'
> > drivers/net/ethernet/micrel/ks8851.c:138: warning: Function parameter or member 'rx_skb' not described in 'ks8851_net'
> > drivers/net/ethernet/micrel/ks8851.c:138: warning: Function parameter or member 'flush_tx_work' not described in 'ks8851_net'
> > drivers/net/ethernet/micrel/ks8851.c:163: warning: Function parameter or member 'spi_xfer1' not described in 'ks8851_net_spi'
> > drivers/net/ethernet/micrel/ks8851.c:163: warning: Function parameter or member 'spi_xfer2' not described in 'ks8851_net_spi'
> > drivers/net/ethernet/micrel/ks8851.c:561: warning: Function parameter or member 'ks' not described in 'ks8851_rx_skb_spi'
> > drivers/net/ethernet/micrel/ks8851.c:570: warning: Function parameter or member 'ks' not described in 'ks8851_rx_skb'  
> 
> A lot of those were there already before this series 

I know, 4 out of the 15 above.

> they are in fact fixed by this series. The result builds clean with W=1 .

Excellent, fixing things is appreciated! It'd be great if new
warnings did not intermittently exist mid-series.
