Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34BEF29101C
	for <lists+netdev@lfdr.de>; Sat, 17 Oct 2020 08:27:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436629AbgJQG1V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Oct 2020 02:27:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:59028 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2409924AbgJQG1V (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 17 Oct 2020 02:27:21 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 257BA207E8;
        Sat, 17 Oct 2020 01:38:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602898681;
        bh=PhsdafJrgsIf2YW8s3loh0qRmGkgtLChSRoH2dvLnp0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=KQM/SBxxw6NALI3LhHgAsdEwhEsClUuOF8WpRs7h5i9AODnvc9XU0R0cUMa3dzCpg
         F1Jz+Ug8wrl572tRnX5943tQqWinQthPLXjkLbafeeJgfeynQOp5yLUErnM2zpUX6z
         MZHwh4odSc3ilr19mV3Wld9BIldBmh/EvEVh4T1M=
Date:   Fri, 16 Oct 2020 18:37:59 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Hemant Kumar <hemantk@codeaurora.org>
Cc:     Loic Poulain <loic.poulain@linaro.org>, davem@davemloft.net,
        netdev@vger.kernel.org, manivannan.sadhasivam@linaro.org,
        eric.dumazet@gmail.com
Subject: Re: [PATCH v6 2/3] net: Add mhi-net driver
Message-ID: <20201016183759.7fa7c0ef@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <ec86ae1d-5e64-85d3-090f-5f74649561f3@codeaurora.org>
References: <1602840007-27140-1-git-send-email-loic.poulain@linaro.org>
        <1602840007-27140-2-git-send-email-loic.poulain@linaro.org>
        <ec86ae1d-5e64-85d3-090f-5f74649561f3@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Please trim your replies.

On Fri, 16 Oct 2020 17:52:28 -0700 Hemant Kumar wrote:
> > +#include <linux/if_arp.h>
> > +#include <linux/mhi.h>
> > +#include <linux/mod_devicetable.h>
> > +#include <linux/module.h>
> > +#include <linux/netdevice.h>
> > +#include <linux/skbuff.h>
> > +#include <linux/u64_stats_sync.h>
> > +
> > +#define MIN_MTU		ETH_MIN_MTU
> > +#define MAX_MTU		0xffff  
> uci driver patch series would take care of this :)

References? What's the UCI patch series?

> > +	if (mhi_queue_is_full(mdev, DMA_TO_DEVICE))
> > +		netif_stop_queue(ndev);  
> is it possible to enable flow control on tx queue if mhi_queue_skb 
> returns non zero value and return NETDEV_TX_BUSY instead of dropping 
> packet at MHI layer ? If this is possible you dont need to export new 
> API as well.

That's not the preferred implementation. Drivers should stop the queues
in advance to avoid requeuing to the qdiscs.

> > +	ndev->tx_queue_len = 1000;  
> some of the above parameters can go in to driver data specific to sw and 
> hw channels.

Really curious to hear what you're talking about here.

Is this already in tree? Was netdev CCed on it?
