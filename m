Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54CE34355D4
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 00:23:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230325AbhJTWZ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 18:25:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:34494 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229695AbhJTWZ2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Oct 2021 18:25:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D0233611CC;
        Wed, 20 Oct 2021 22:23:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634768594;
        bh=tV/jzjZVd+TTWP4dZhLqe0+DKedLHbFCVKkqvVau0iQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=thYcDGW8laFmpm9dwFcHDZPQUE+zaUSAmCnwckEJru/KgM4y8dnUawhl+KfGQhnuB
         QzcuS/su6kCx+XzRk2X+luuqbcH9ibTBWZRReKR/y2eDpmaqFcrWwgmykAfZNs+3ob
         FzAS35HCFx/6MmujmA9iKLp3MeAwQxy0YIXfD8XPxzY1a15Kobjpe+hwkKsn803KrI
         jTPcXwesGQa6Gz7uX/B7jKWCdrtecxiiamU+DR6QWYaxDnyNpf+Sj8GIKVdFefiXov
         x+48W574+EBad1Sb4ro6wOoLB2RB3L7VmX+J/OPqfJ6vWXZPxhYiyhRX9mDx9Y8L+W
         QpqHHPQh5bM5w==
Date:   Wed, 20 Oct 2021 15:23:12 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Claudiu Manoil <claudiu.manoil@nxp.com>,
        Tim Gardner <tim.gardner@canonical.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Po Liu <po.liu@nxp.com>
Subject: Re: [PATCH][linux-next] net: enetc: unmap DMA in enetc_send_cmd()
Message-ID: <20211020152312.6a7a9ffb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <AM9PR04MB8397F300DECD3C44D2EBD07796BD9@AM9PR04MB8397.eurprd04.prod.outlook.com>
References: <20211019181950.14679-1-tim.gardner@canonical.com>
        <AM9PR04MB8397F300DECD3C44D2EBD07796BD9@AM9PR04MB8397.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 19 Oct 2021 19:47:17 +0000 Claudiu Manoil wrote:
> > I am curious why you do not need to call dma_sync_single_for_device()
> > before enetc_send_cmd()
> > in order to flush the contents of CPU cache to RAM. Is it because
> > __GFP_DMA marks
> > that page as uncached ? Or is it because of the SOC this runs on ?
> >   
> 
> Not sure how it works like this, but I think dma_alloc_coherent() should have
> been used here instead of the kmalloc + dma_map scheme.

Using dma_alloc_coherent() seems simpler and more correct, 
let's do that instead.
