Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E84E8B9D6
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 15:17:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728994AbfHMNRP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 09:17:15 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:56762 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728796AbfHMNRP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Aug 2019 09:17:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=lDlcKH+jpyMIdatKAOyBrbLs0vonOISA/RCsgldAZeo=; b=kokfadnCz4inebHrhjOWc3X1mw
        75FZkVRIPPpya5H51KrVLEZSNkr2OAA1bWYBxgen/oHhROrMEZg5VZesVQreHFoCaZxFr8ahOWg5a
        GCPrLUUE2cjokcuhlcN3XpnV+ZwG2LnbLX7XlELoHIev2CwhWUXMbDzPk9UlbqNG4fdE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hxWfi-0001HZ-Ii; Tue, 13 Aug 2019 15:17:06 +0200
Date:   Tue, 13 Aug 2019 15:17:06 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Antoine Tenart <antoine.tenart@bootlin.com>
Cc:     Igor Russkikh <Igor.Russkikh@aquantia.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "sd@queasysnail.net" <sd@queasysnail.net>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "thomas.petazzoni@bootlin.com" <thomas.petazzoni@bootlin.com>,
        "alexandre.belloni@bootlin.com" <alexandre.belloni@bootlin.com>,
        "allan.nielsen@microchip.com" <allan.nielsen@microchip.com>,
        "camelia.groza@nxp.com" <camelia.groza@nxp.com>,
        Simon Edelhaus <Simon.Edelhaus@aquantia.com>,
        Pavel Belous <Pavel.Belous@aquantia.com>
Subject: Re: [PATCH net-next v2 6/9] net: macsec: hardware offloading
 infrastructure
Message-ID: <20190813131706.GE15047@lunn.ch>
References: <20190808140600.21477-1-antoine.tenart@bootlin.com>
 <20190808140600.21477-7-antoine.tenart@bootlin.com>
 <e96fa4ae-1f2c-c1be-b2d8-060217d8e151@aquantia.com>
 <20190813085817.GA3200@kwain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190813085817.GA3200@kwain>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 13, 2019 at 10:58:17AM +0200, Antoine Tenart wrote:
> I think this question is linked to the use of a MACsec virtual interface
> when using h/w offloading. The starting point for me was that I wanted
> to reuse the data structures and the API exposed to the userspace by the
> s/w implementation of MACsec. I then had two choices: keeping the exact
> same interface for the user (having a virtual MACsec interface), or
> registering the MACsec genl ops onto the real net devices (and making
> the s/w implementation a virtual net dev and a provider of the MACsec
> "offloading" ops).
> 
> The advantages of the first option were that nearly all the logic of the
> s/w implementation could be kept and especially that it would be
> transparent for the user to use both implementations of MACsec.

Hi Antoine

We have always talked about offloading operations to the hardware,
accelerating what the linux stack can do by making use of hardware
accelerators. The basic user API should not change because of
acceleration. Those are the general guidelines.

It would however be interesting to get comments from those who did the
software implementation and what they think of this architecture. I've
no personal experience with MACSec, so it is hard for me to say if the
current architecture makes sense when using accelerators.

	Andrew
