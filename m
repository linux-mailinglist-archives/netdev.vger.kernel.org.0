Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52E9848CC41
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 20:47:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344973AbiALTqr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 14:46:47 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:34778 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1357108AbiALTpG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 Jan 2022 14:45:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=+PIw2F9Pxe9m/og1B2EVUD67ui08c2oSdDdwW2s8nEk=; b=r20G8jm19XPvotYa9kp2u67Txn
        4VIDZ/Q3ZzpvcGImKcxwS3jWGsKZQ5phG66lMS57QXgFp2dg8nZeUWaobUG2EAqjd5x8NmQ2wSQJD
        alCJd6cbphiGaJ1nN/ytHbaxoE2IY3D+hUjmyrmBwW5lrIWA9v+FuqcrNsUFiLqEjsEw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1n7jYI-001EGf-QF; Wed, 12 Jan 2022 20:44:58 +0100
Date:   Wed, 12 Jan 2022 20:44:58 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Robert Hancock <robert.hancock@calian.com>
Cc:     "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "radhey.shyam.pandey@xilinx.com" <radhey.shyam.pandey@xilinx.com>,
        "michal.simek@xilinx.com" <michal.simek@xilinx.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "ariane.keller@tik.ee.ethz.ch" <ariane.keller@tik.ee.ethz.ch>
Subject: Re: [PATCH net v2 2/9] net: axienet: Wait for PhyRstCmplt after core
 reset
Message-ID: <Yd8vukDquQLHYAXR@lunn.ch>
References: <20220112173700.873002-1-robert.hancock@calian.com>
 <20220112173700.873002-3-robert.hancock@calian.com>
 <Yd8o6P6Pp7V7S+oL@lunn.ch>
 <d0b00b8c96be17e6ad636f5a74ebfb170a603eac.camel@calian.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d0b00b8c96be17e6ad636f5a74ebfb170a603eac.camel@calian.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > Is this bit guaranteed to be clear before you start waiting for it?
> 
> The documentation for the IP core ( 
> https://www.xilinx.com/content/dam/xilinx/support/documentation/ip_documentation/axi_ethernet/v7_2/pg138-axi-ethernet.pdf
>  ) states for the phy_rst_n output signal: "This active-Low reset is held
> active for 10 ms after power is applied and during any reset. After the reset
> goes inactive, the PHY cannot be accessed for an additional 5 ms." The
> PhyRstComplt bit definition mentions "This signal does not transition to 1 for
> 5 ms after PHY_RST_N transitions to 1". Given that a reset of the core has just
> been completed above, the PHY reset should at least have been initiated as
> well, so it should be sufficient to just wait for the bit to become 1 at this
> point.

Great, thanks for checking.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
