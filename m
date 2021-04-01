Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C13BC352085
	for <lists+netdev@lfdr.de>; Thu,  1 Apr 2021 22:19:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235593AbhDAUTf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Apr 2021 16:19:35 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:59160 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234496AbhDAUTd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Apr 2021 16:19:33 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lS3mq-00EOPJ-6z; Thu, 01 Apr 2021 22:19:28 +0200
Date:   Thu, 1 Apr 2021 22:19:28 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ioana Ciornei <ciorneiioana@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        ruxandra.radulescu@nxp.com, Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: Re: [PATCH net-next 2/3] dpaa2-eth: add rx copybreak support
Message-ID: <YGYq0E/vZe65R7kk@lunn.ch>
References: <20210401163956.766628-1-ciorneiioana@gmail.com>
 <20210401163956.766628-3-ciorneiioana@gmail.com>
 <YGYVx+OxaSey3qNJ@lunn.ch>
 <20210401201350.vxyivlvvur6iqdp4@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210401201350.vxyivlvvur6iqdp4@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 01, 2021 at 11:13:50PM +0300, Ioana Ciornei wrote:
> On Thu, Apr 01, 2021 at 08:49:43PM +0200, Andrew Lunn wrote:
> > Hi Ioana
> > 
> > > +#define DPAA2_ETH_DEFAULT_COPYBREAK	512
> > 
> > This is quite big. A quick grep suggest other driver use 256.
> > 
> > Do you have some performance figures for this? 
> > 
> 
> Hi Andrew,
> 
> Yes, I did some tests which made me end up with this default value.
> 
> A bit about the setup - a LS2088A SoC, 8 x Cortex A72 @ 1.8GHz, IPfwd
> zero loss test @ 20Gbit/s throughput.  I tested multiple frame sizes to
> get an idea where is the break even point.
> 
> Here are 2 sets of results, (1) is the baseline and (2) is just
> allocating a new skb for all frames sizes received (as if the copybreak
> was even to the MTU). All numbers are in Mpps.
> 
>          64   128    256   512  640   768   896
> 
> (1)     3.23  3.23  3.24  3.21  3.1  2.76  2.71
> (2)     3.95  3.88  3.79  3.62  3.3  3.02  2.65
> 
> It seems that even for 512 bytes frame sizes it's comfortably better when
> allocating a new skb. After that, we see diminishing rewards or even worse.

Nice. If you need to respin, consider putting this in patch 0/3.

      Andrew
