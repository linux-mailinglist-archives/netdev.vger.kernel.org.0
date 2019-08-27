Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18C9D9F6E2
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 01:27:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726077AbfH0X1T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 19:27:19 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:35994 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725997AbfH0X1S (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Aug 2019 19:27:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=N8xeuJbKEW2IcMDIXKqx8vJN56eyQQyLNAntSh+6OPQ=; b=4MC7bEWgeKwZ/eh1rAmmKugUni
        CI0FcqCQKDnvmKUCj0UbAUtIpNAMXcpJ7v3dwEjmzhdlR8fNv6A4wK79MhtPQkK2dE4m1jrzteKKg
        ssWHuSczjy29WhecyD+nLp2YJzq5czoz73gJrU+BOL2dgFqdkCvAQKg5G6dzX6aOwPbk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1i2krp-0007LM-Pz; Wed, 28 Aug 2019 01:27:13 +0200
Date:   Wed, 28 Aug 2019 01:27:13 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Chun-Hao Lin <hau@realtek.com>
Subject: Re: [PATCH net-next 1/4] r8169: prepare for adding RTL8125 support
Message-ID: <20190827232713.GE26248@lunn.ch>
References: <55099fc6-1e29-4023-337c-98fc04189e5e@gmail.com>
 <66ac2b09-ea87-a4ba-f6f3-1885e9587298@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <66ac2b09-ea87-a4ba-f6f3-1885e9587298@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 27, 2019 at 08:41:00PM +0200, Heiner Kallweit wrote:
> This patch prepares the driver for adding RTL8125 support:
> - change type of interrupt mask to u32
> - restrict rtl_is_8168evl_up to RTL8168 chip versions
> - factor out reading MAC address from registers
> - re-add function rtl_get_events
> - move disabling interrupt coalescing to RTL8169/RTL8168 init
> - read different register for PCI commit
> - don't use bit LastFrag in tx descriptor after send, RTL8125 clears it

Hi Heiner

That is a lot of changes in one patch. Although there is no planned
functional change, r8169 has a habit of breaking. Having lots of small
changes would help tracking down which change caused a breakage, via a
git bisect.

So you might want to consider splitting this up into a number of small
patches.

	Andrew
