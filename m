Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C73F10CAB0
	for <lists+netdev@lfdr.de>; Thu, 28 Nov 2019 15:53:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726773AbfK1Ow7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Nov 2019 09:52:59 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:59364 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726446AbfK1Ow6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Nov 2019 09:52:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=NGylHzPIXkw1Am/2gMfVIehuMuf/ARavlgeMprXQiyM=; b=ZipJOp8lAgpH5pTviCz7fzk2RK
        DI1N1nJ0H+/QgiAakL+FDA0Y8yfRfMRAdQFe66IW5z65HRJPWpyk99/Mc1oMXkutfrRcdXfiVOu4F
        BRRXVyFjqMvsYXfejCZtBzljGoNqRfwQBOw3VDCbdMzr0WSN1EPSd7hZhNM2+pptGbj8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iaL9y-0003sE-VK; Thu, 28 Nov 2019 15:52:46 +0100
Date:   Thu, 28 Nov 2019 15:52:46 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Milind Parab <mparab@cadence.com>
Cc:     "Nicolas.Ferre@microchip.com" <Nicolas.Ferre@microchip.com>,
        "antoine.tenart@bootlin.com" <antoine.tenart@bootlin.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dhananjay Vilasrao Kangude <dkangude@cadence.com>,
        Parshuram Raju Thombare <pthombar@cadence.com>,
        "rmk+kernel@arm.linux.org.uk" <rmk+kernel@arm.linux.org.uk>
Subject: Re: [PATCH 2/3] net: macb: add support for C45 MDIO read/write
Message-ID: <20191128145246.GD3420@lunn.ch>
References: <1574759354-102696-1-git-send-email-mparab@cadence.com>
 <1574759389-103118-1-git-send-email-mparab@cadence.com>
 <20191126143717.GP6602@lunn.ch>
 <19694e5a-17df-608f-5db7-5da288e5e7cd@microchip.com>
 <20191127185129.GU6602@lunn.ch>
 <BY5PR07MB65147759BC70B370E6834451D3470@BY5PR07MB6514.namprd07.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BY5PR07MB65147759BC70B370E6834451D3470@BY5PR07MB6514.namprd07.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> This patch doesn't affect current C22 operation of the driver. 
> However if a user selects C45 on incompatible MAC (there are old MAC, prior to Release1p10, released 10th April 2003) MDIO operations may fails.

How do they fail? Lockup the chip and require a cold boot? Timeout
after 10ms and return -ETIMEOUT?

Currently, there is nothing stopping a C45 access to happen. There has
been talk of making the probe for C45 PHYs the same as C22, scan the
bus. I guess that would be implemented by adding a flag to each MDIO
bus driver indicating it supports C45. All 32 addresses would then be
probed using C45 as well as C22. So we need to be sure it is safe to
use C45 on these older devices.

      Andrew
