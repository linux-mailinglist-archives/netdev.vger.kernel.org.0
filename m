Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E4D22F08DD
	for <lists+netdev@lfdr.de>; Sun, 10 Jan 2021 18:44:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727005AbhAJRoc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Jan 2021 12:44:32 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:60054 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726855AbhAJRob (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 10 Jan 2021 12:44:31 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kyekk-00HLbU-KM; Sun, 10 Jan 2021 18:43:46 +0100
Date:   Sun, 10 Jan 2021 18:43:46 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Stefan Chulski <stefanc@marvell.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "thomas.petazzoni@bootlin.com" <thomas.petazzoni@bootlin.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Nadav Haklai <nadavh@marvell.com>,
        Yan Markman <ymarkman@marvell.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "mw@semihalf.com" <mw@semihalf.com>,
        "rmk+kernel@armlinux.org.uk" <rmk+kernel@armlinux.org.uk>,
        "atenart@kernel.org" <atenart@kernel.org>
Subject: Re: [EXT] Re: [PATCH RFC net-next  03/19] net: mvpp2: add CM3 SRAM
 memory map
Message-ID: <X/s80rM1HBFrkHyl@lunn.ch>
References: <1610292623-15564-1-git-send-email-stefanc@marvell.com>
 <1610292623-15564-4-git-send-email-stefanc@marvell.com>
 <X/szqUG3nr/FrZXS@lunn.ch>
 <CO6PR18MB387341801046DE9663E2FD85B0AC9@CO6PR18MB3873.namprd18.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CO6PR18MB387341801046DE9663E2FD85B0AC9@CO6PR18MB3873.namprd18.prod.outlook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > Should there be -EPROBE_DEFER handling in here somewhere? The SRAM is a
> > device, so it might not of been probed yet?
> 

> No, firmware probed during bootloader boot and we can use SRAM. SRAM
> memory can be safely used.

A previous patch added:

+               CP11X_LABEL(cm3_sram): cm3@220000 {
+                       compatible = "mmio-sram";
+                       reg = <0x220000 0x800>;
+                       #address-cells = <1>;
+                       #size-cells = <1>;
+                       ranges = <0 0x220000 0x800>;
+               };
+

So it looks like the SRAM is a device, in the linux driver model. And
there is a driver for this, driver/misc/sram.c. How do you know this
device has been probed before the Ethernet driver?

       Andrew
