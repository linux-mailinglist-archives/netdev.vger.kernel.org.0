Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05169157BE
	for <lists+netdev@lfdr.de>; Tue,  7 May 2019 04:38:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726381AbfEGCiY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 May 2019 22:38:24 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:56447 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726181AbfEGCiY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 May 2019 22:38:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=skvNpO0zX4GPyRd+jUiVZhghKIV6JCNA6t+XLkt7Xgc=; b=MJOagZXDuuoE7EUinW89m7vNvB
        0z0j6lBWk/wscM30KRmuqvRs5tlm0OV2nTJSj3TOHCrXpWninS1t7Rm6udzmJbiRdiqJSGp5SzQN4
        tOprsYUPvURP30Fj5WHyOGFTCozX+PnWop2/TosXXHogaahEeKbTSAu/ln0IMtM2XfI0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hNpzg-0003JU-VM; Tue, 07 May 2019 04:38:12 +0200
Date:   Tue, 7 May 2019 04:38:12 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     20190505220524.37266-2-ruslan@babayev.com
Cc:     linux@armlinux.org.uk, f.fainelli@gmail.com, hkallweit1@gmail.com,
        mika.westerberg@linux.intel.com, wsa@the-dreams.de,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-acpi@vger.kernel.org, xe-linux-external@cisco.com
Subject: Re: [PATCH RFC v2 net-next 2/2] net: phy: sfp: enable i2c-bus
 detection on ACPI based systems
Message-ID: <20190507023812.GA12262@lunn.ch>
References: <20190505220524.37266-2-ruslan@babayev.com>
 <20190507003557.40648-3-ruslan@babayev.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190507003557.40648-3-ruslan@babayev.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 06, 2019 at 05:35:57PM -0700, Ruslan Babayev wrote:
> Lookup I2C adapter using the "i2c-bus" device property on ACPI based
> systems similar to how it's done with DT.
> 
> An example DSD describing an SFP on an ACPI based system:
> 
> Device (SFP0)
> {
>     Name (_HID, "PRP0001")
>     Name (_CRS, ResourceTemplate()
>     {
>         GpioIo(Exclusive, PullDefault, 0, 0, IoRestrictionNone,
>                "\\_SB.PCI0.RP01.GPIO", 0, ResourceConsumer)
>             { 0, 1, 2, 3, 4 }
>     })
>     Name (_DSD, Package ()
>     {
>         ToUUID ("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
>         Package () {
>             Package () { "compatible", "sff,sfp" },
>             Package () { "i2c-bus", \_SB.PCI0.RP01.I2C.MUX.CH0 },
>             Package () { "maximum-power-milliwatt", 1000 },
>             Package () { "tx-disable-gpios", Package () { ^SFP0, 0, 0, 1} },
>             Package () { "reset-gpio",       Package () { ^SFP0, 0, 1, 1} },
>             Package () { "mod-def0-gpios",   Package () { ^SFP0, 0, 2, 1} },
>             Package () { "tx-fault-gpios",   Package () { ^SFP0, 0, 3, 0} },
>             Package () { "los-gpios",        Package () { ^SFP0, 0, 4, 1} },
>         },

As i said before, i know ~0 about ACPI. Does devm_gpiod_get() just
work for ACPI?

Thanks
	Andrew
