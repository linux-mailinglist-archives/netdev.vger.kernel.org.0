Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD38C1ED5C9
	for <lists+netdev@lfdr.de>; Wed,  3 Jun 2020 20:06:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726565AbgFCSGU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jun 2020 14:06:20 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:35308 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726370AbgFCSGT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Jun 2020 14:06:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=RTd4cybYUcbTjHhAV3/c/LY8bqCfpTYji+h/c0zkD1E=; b=hZc5RWi2EvmHgKSunhM+aQhNqy
        XMJrsqQuj2IoQ30HVJlKzuLxoQgcuJM3sl4KOfb9mXuqCbHiszKYQ322JF25igmLCXQwfI4Xz5/Vm
        a88vyDaWo2XdYFwXXlOSL6B2HwEXG0lMr/CIl+VnQu29YPU7YRrK91NUOh/+Yn49Yd18=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jgXmJ-0044i4-ND; Wed, 03 Jun 2020 20:06:15 +0200
Date:   Wed, 3 Jun 2020 20:06:15 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Roelof Berg <rberg@berg-solutions.de>
Cc:     David Miller <davem@davemloft.net>,
        Bryan Whitehead <bryan.whitehead@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lan743x: Added fixed link and RGMII support / debugging
Message-ID: <20200603180615.GB971209@lunn.ch>
References: <20200529193003.3717-1-rberg@berg-solutions.de>
 <20200601.115136.1314501977250032604.davem@davemloft.net>
 <D784BC1B-D14C-4FE4-8FD8-76BEBE60A39D@berg-solutions.de>
 <20200603155927.GC869823@lunn.ch>
 <42337EA1-C7D1-46C6-815F-C619B27A4E77@berg-solutions.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <42337EA1-C7D1-46C6-815F-C619B27A4E77@berg-solutions.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 03, 2020 at 06:33:28PM +0200, Roelof Berg wrote:
> Ok, let's proceed :) The code runs well, dmesg looks good, ip addr shows me a link up, speed/duplex looks ok. But it does not transfer any data.
> 
> Debugging steps (A/B versions):
> - Check clocks with oscilloscope (10/100/1000)
> - Dump actual register settings
> - Trace Phy-Phy autonegotiation and ensure that our patch catches up the result

Adding #define DEBUG to the top of drivers/net/phy/phy.c will get you
some debug info.

What PHY is being used?
Is it using RGMII?

If it looks like the PHY and the MAC are happy, just that frames are
not being transferred between them, it could be RGMII delays.

    Andrew
