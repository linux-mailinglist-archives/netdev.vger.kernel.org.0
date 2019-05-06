Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23EFE14A57
	for <lists+netdev@lfdr.de>; Mon,  6 May 2019 14:55:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726379AbfEFMzi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 May 2019 08:55:38 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:55727 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725852AbfEFMzi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 May 2019 08:55:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=BgoSaHcSVXeUVaFDGwlvfT0vdS0WcIHzaajAD/u3L3U=; b=Q6xiMyQ3DRmztW7tLFke5nxDPs
        moHuR1ihA/uJVKKZ+h6SOxFgybRSOYuvPuvFTFi7nYmUB4w5BNEXV5FP7QYdcqc8AHEIEtJ00cxPo
        /t6oxbTjyYW24CWKqlegJGmQfEJ3z5OzlHUFM+SA9vhrEHjcjrmU5mZ9gcZbFKwpSPMA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hNd9P-0004hc-JZ; Mon, 06 May 2019 14:55:23 +0200
Date:   Mon, 6 May 2019 14:55:23 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ruslan Babayev <ruslan@babayev.com>
Cc:     linux@armlinux.org.uk, f.fainelli@gmail.com, hkallweit1@gmail.com,
        mika.westerberg@linux.intel.com, wsa@the-dreams.de,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-acpi@vger.kernel.org, xe-linux-external@cisco.com
Subject: Re: [PATCH net-next 2/2] net: phy: sfp: enable i2c-bus detection on
 ACPI based systems
Message-ID: <20190506125523.GA15291@lunn.ch>
References: <20190505220524.37266-3-ruslan@babayev.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190505220524.37266-3-ruslan@babayev.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, May 05, 2019 at 03:05:23PM -0700, Ruslan Babayev wrote:
> Lookup I2C adapter using the "i2c-bus" device property on ACPI based
> systems similar to how it's done with DT.
> 
> An example DSD describing an SFP on an ACPI based system:
> 
> Device (SFP0)
> {
>     Name (_HID, "PRP0001")
>     Name (_DSD, Package ()
>     {
>         ToUUID ("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
>         Package () {
>             Package () { "compatible", "sff,sfp" },
>             Package () { "i2c-bus", \_SB.PCI0.RP01.I2C.MUX.CH0 },
>         },
>     })
> }

Hi Ruslan

So this gives you the I2C bus. But what about the 6 GPIOs? And the
maximum power property? You are defining the ACPI interface which from
now on everybody has to follow. So it would be good to make it
complete. ACPI also seems to be poorly documented. There does not
appear to be anything like Documentation/devicetree. So having one
patch, with a good commit message, which implements everything makes
it easier for those that follow.

This appears to be enough to get a very minimal SFP instantiated. But
then what?  How are you using it? How do you instantiate a Phylink
instance for the MAC? How do you link the SFP to the Phylink?

Before accepting this patch, i would like to know more about the
complete solution.

Thanks
	Andrew
