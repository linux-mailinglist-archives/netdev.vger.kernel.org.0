Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 732DD1E1794
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 00:06:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729342AbgEYWGZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 18:06:25 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:48716 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725964AbgEYWGZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 May 2020 18:06:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=ow3dZQ2RXenNVR51hDz4u+NA9VDE7EFzuyxjx0sN4LE=; b=pJkePhU68g1t0lsMDAcs5xkv4u
        A+5tyJ2gHeR2GfyXEeRtnri5YRxTJmvK1uf8XxVL0m96RfAsyY1DhaWDMEmJRtCVdLFgoGN+qBzdy
        /r3qOu7cGLGRre2vtL3Z4bLy1KIMML/KE7w/Ttt61mCGi45Kg3AQFiCfTCOlu7UENi6Q=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jdLEc-003EJX-9T; Tue, 26 May 2020 00:06:14 +0200
Date:   Tue, 26 May 2020 00:06:14 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jeremy Linton <jeremy.linton@arm.com>
Cc:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        netdev@vger.kernel.org, davem@davemloft.net, f.fainelli@gmail.com,
        hkallweit1@gmail.com, madalin.bucur@oss.nxp.com,
        calvin.johnson@oss.nxp.com, linux-kernel@vger.kernel.org
Subject: Re: [RFC 04/11] net: phy: Handle c22 regs presence better
Message-ID: <20200525220614.GC768009@lunn.ch>
References: <20200522213059.1535892-1-jeremy.linton@arm.com>
 <20200522213059.1535892-5-jeremy.linton@arm.com>
 <20200523183731.GZ1551@shell.armlinux.org.uk>
 <f85e4d86-ff58-0ed2-785b-c51626916140@arm.com>
 <20200525100612.GM1551@shell.armlinux.org.uk>
 <63ca13e3-11ea-3ddf-e1c7-90597d4a5f8c@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <63ca13e3-11ea-3ddf-e1c7-90597d4a5f8c@arm.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Yes, we know even for the NXP reference hardware, one of the phy's doesn't
> probe out correctly because it doesn't respond to the ieee defined
> registers. I think at this point, there really isn't anything we can do
> about that unless we involve the (ACPI) firmware in currently nonstandard
> behaviors.
> 
> So, my goals here have been to first, not break anything, and then do a
> slightly better job finding phy's that are (mostly?) responding correctly to
> the 802.3 spec. So we can say "if you hardware is ACPI conformant, and you
> have IEEE conformant phy's you should be ok". So, for your example phy, I
> guess the immediate answer is "use DT" or "find a conformant phy", or even
> "abstract it in the firmware and use a mailbox interface".
 
Hi Jeremy

You need to be careful here, when you say "use DT". With a c45 PHY
of_mdiobus_register_phy() calls get_phy_device() to see if the device
exists on the bus. So your changes to get_phy_device() etc, needs to
continue to find devices it used to find, even if they are not fully
complient to 802.3.

	  Andrew
 
