Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85A9B2FBD5
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 14:58:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727001AbfE3M6l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 08:58:41 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:41438 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726015AbfE3M6k (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 May 2019 08:58:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=xB8+uSAdIi4vE4Eke8RLPhwzB3Hq8CNeR8jI1cAMG4Y=; b=au90tRQVfIG3mn4gw9H55zbnEe
        2X/auosHq6eeIf3yI8q9MoXw6bsCpn+t+hQuP4nMOsfZAU3LJLwuxeCEpqFbkIy5EbfQ7UQJg5x46
        hn1FMNgYEko9UF2kViIYhRyXeXVgyfJl3zpWoGGZxey0OkaZYCr2oONQjsUf+qWzxJl0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hWKdc-0006T7-PS; Thu, 30 May 2019 14:58:32 +0200
Date:   Thu, 30 May 2019 14:58:32 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Biao Huang <biao.huang@mediatek.com>
Cc:     Jose Abreu <joabreu@synopsys.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mediatek@lists.infradead.org, yt.shen@mediatek.com,
        jianguo.zhang@mediatek.com, boon.leong.ong@intel.com
Subject: Re: [PATCH 3/4] net: stmmac: modify default value of tx-frames
Message-ID: <20190530125832.GB22727@lunn.ch>
References: <1559206484-1825-1-git-send-email-biao.huang@mediatek.com>
 <1559206484-1825-4-git-send-email-biao.huang@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1559206484-1825-4-git-send-email-biao.huang@mediatek.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 30, 2019 at 04:54:43PM +0800, Biao Huang wrote:
> the default value of tx-frames is 25, it's too late when
> passing tstamp to stack, then the ptp4l will fail:
> 
> ptp4l -i eth0 -f gPTP.cfg -m
> ptp4l: selected /dev/ptp0 as PTP clock
> ptp4l: port 1: INITIALIZING to LISTENING on INITIALIZE
> ptp4l: port 0: INITIALIZING to LISTENING on INITIALIZE
> ptp4l: port 1: link up
> ptp4l: timed out while polling for tx timestamp
> ptp4l: increasing tx_timestamp_timeout may correct this issue,
>        but it is likely caused by a driver bug
> ptp4l: port 1: send peer delay response failed
> ptp4l: port 1: LISTENING to FAULTY on FAULT_DETECTED (FT_UNSPECIFIED)
> 
> ptp4l tests pass when changing the tx-frames from 25 to 1 with
> ethtool -C option.
> It should be fine to set tx-frames default value to 1, so ptp4l will pass
> by default.

Hi Biao

What does this do to the number of interrupts? Do we get 25 times more
interrupts? Have you done any performance tests to see if this causes
performance regressions?

	    Andrew
