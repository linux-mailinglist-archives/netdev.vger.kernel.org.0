Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A4AB1ED46B
	for <lists+netdev@lfdr.de>; Wed,  3 Jun 2020 18:33:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726108AbgFCQdl convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 3 Jun 2020 12:33:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725961AbgFCQdl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jun 2020 12:33:41 -0400
Received: from wp148.webpack.hosteurope.de (wp148.webpack.hosteurope.de [IPv6:2a01:488:42:1000:50ed:849b::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82C02C08C5C0;
        Wed,  3 Jun 2020 09:33:41 -0700 (PDT)
Received: from ip1f126570.dynamic.kabel-deutschland.de ([31.18.101.112] helo=roelofs-mbp.fritz.box); authenticated
        by wp148.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        id 1jgWKX-0000yV-TV; Wed, 03 Jun 2020 18:33:29 +0200
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.80.23.2.2\))
Subject: Re: [PATCH] lan743x: Added fixed link and RGMII support / debugging
From:   Roelof Berg <rberg@berg-solutions.de>
In-Reply-To: <20200603155927.GC869823@lunn.ch>
Date:   Wed, 3 Jun 2020 18:33:28 +0200
Cc:     David Miller <davem@davemloft.net>,
        Bryan Whitehead <bryan.whitehead@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <42337EA1-C7D1-46C6-815F-C619B27A4E77@berg-solutions.de>
References: <20200529193003.3717-1-rberg@berg-solutions.de>
 <20200601.115136.1314501977250032604.davem@davemloft.net>
 <D784BC1B-D14C-4FE4-8FD8-76BEBE60A39D@berg-solutions.de>
 <20200603155927.GC869823@lunn.ch>
To:     Andrew Lunn <andrew@lunn.ch>
X-Mailer: Apple Mail (2.3608.80.23.2.2)
X-bounce-key: webpack.hosteurope.de;rberg@berg-solutions.de;1591202021;3b61a3d8;
X-HE-SMSGID: 1jgWKX-0000yV-TV
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ok, let's proceed :) The code runs well, dmesg looks good, ip addr shows me a link up, speed/duplex looks ok. But it does not transfer any data.

Debugging steps (A/B versions):
- Check clocks with oscilloscope (10/100/1000)
- Dump actual register settings
- Trace Phy-Phy autonegotiation and ensure that our patch catches up the result

Research topic:
I will also look if in my test hardware uses distinct MDIO traces or in-band MDIO (MDIO via MII). Would inband MDIO need the autosense feature to talk to the phy before phy-phy auto negotiation is complete ? E.g. for triggering phy-phy autoneg ? And is this (inband mdio) maybe the reason why the may-phy autosense feature exists in the silicon ?

Thanks,
Roelof

> Am 03.06.2020 um 17:59 schrieb Andrew Lunn <andrew@lunn.ch>:
> 
> On Wed, Jun 03, 2020 at 04:52:32PM +0200, Roelof Berg wrote:
>> TEST REPORT: BROKEN PATCH
>> 
>> Thanks to everyone for working on the fixed link feature of lan743x eth driver.
>> 
> 
>> I received more test hardware today, and one piece of hardware
>> (EVBlan7430) becomes incompatible by the patch. We need to roll back
>> for now. Sorry.
> 
> Hi Roelof
> 
> We have a bit of time to fix this, before it becomes too critical.
> So lets try to fix it.
> 
> How did it break?
> 
>    Thanks
> 	Andrew
> 

