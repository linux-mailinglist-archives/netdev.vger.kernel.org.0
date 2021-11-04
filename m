Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D149445373
	for <lists+netdev@lfdr.de>; Thu,  4 Nov 2021 13:59:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231613AbhKDNC1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Nov 2021 09:02:27 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:46826 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230091AbhKDNC0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Nov 2021 09:02:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=qUQyBRAgGmRlb0+C03q/ctsuzfX/uEhANwydd0iDgN8=; b=DR
        L0yMOeYxW8plL2J6VYC5lIOiSnKkoEFOat5lpZqxwXHT8wyjgkZwOkB513lpQPRd9OKTPVRLLghMv
        D8JbWp/89sTd5KELaQV/aFNdiNgIh3tlBByWAZ1Hc4fEFcypgZFWQpqgoD96ba5UrQMDzEUe0t0xP
        AlgiWgWKuFFHkwE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1micL9-00CaoT-Qb; Thu, 04 Nov 2021 13:59:35 +0100
Date:   Thu, 4 Nov 2021 13:59:35 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Wells Lu =?utf-8?B?5ZGC6Iqz6aiw?= <wells.lu@sunplus.com>
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        Wells Lu <wellslutw@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "p.zabel@pengutronix.de" <p.zabel@pengutronix.de>
Subject: Re: [PATCH 2/2] net: ethernet: Add driver for Sunplus SP7021
Message-ID: <YYPZN9hPBJTBzVUl@lunn.ch>
References: <cover.1635936610.git.wells.lu@sunplus.com>
 <650ec751dd782071dd56af5e36c0d509b0c66d7f.1635936610.git.wells.lu@sunplus.com>
 <d0217eed-a8b7-8eb9-7d50-4bf69cd38e03@infradead.org>
 <159ab76ac7114da983332aadc6056c08@sphcmbx02.sunplus.com.tw>
 <YYLjaYCQHzqBzN1l@lunn.ch>
 <36d5bc6d40734ae0a9c1fb26d258f49f@sphcmbx02.sunplus.com.tw>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <36d5bc6d40734ae0a9c1fb26d258f49f@sphcmbx02.sunplus.com.tw>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 04, 2021 at 05:31:57AM +0000, Wells Lu 呂芳騰 wrote:
> Hi,
> 
> Thanks a lot for review.
> 
> > 
> > > config NET_VENDOR_SUNPLUS
> > > 	bool "Sunplus devices"
> > > 	default y
> > > 	depends on ARCH_SUNPLUS
> > 
> > Does it actually depend on ARCH_SUNPLUS? What do you make use of?
> 
> ARCH_SUNPLUS will be defined for Sunplus family series SoC.
> Ethernet devices of Sunplus are designed and used for Sunplus SoC.
> So far, only two SoC of Sunplus have the network device.
> I'd like to show up the selection only for Sunplus SoC.

So it does not actually depend on ARCH_SUNPLUS. There are a few cases
where drivers have needed to call into arch specific code, which stops
them building for any other arch.

> > Ideally, you want it to also build with COMPILE_TEST, so that the driver gets
> > build by 0-day and all the other build bots.
> 
> I am not sure if this is mandatory or not.
> Should I add COMPILE_TEST as below?
> 
> 	depends on ARCH_SUNPLUS | COMPILE_TEST

Yes.

> Yes, the device is now only for Sunplus SP7021 SoC.
> Devices in each SoC may have a bit difference because of adding new 
> function or improving something.

If it will compile with COMPILE_TEST on x86, mips, etc, you should
allow it to compile with COMPILE_TEST. You get better compile testing
that way.

     Andrew
