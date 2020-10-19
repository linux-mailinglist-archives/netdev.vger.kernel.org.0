Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1C0029312B
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 00:22:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728844AbgJSWWB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 18:22:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728386AbgJSWWB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Oct 2020 18:22:01 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 330BAC0613CE
        for <netdev@vger.kernel.org>; Mon, 19 Oct 2020 15:22:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=5PO86Zr88F0Fnk+CGMKrRv8Xg89gFWnynN6gPPhdl7E=; b=qYoKLhF203CIcy42d0mKHPKR4
        4ZK4gEZoW3Yw1h//9CAj7eoFVLHlCUaeo8M7zXvWfHZa8fBNW3MliC/DXaxM/+k6TWIRmeyThBiA7
        qnAPNqJbuRuCyT5cRAaB95YyBOJUKHqahIkuZ9c9JbPqV8l+PKltHwhNrsdVxKBE3v5k5AwhcZ/t5
        AR+LhzyqXjhmW7CfK0nYusCOE5WpULKXXjT9HVWE8qhkkJr5icIAr9x9yP3eJhBv7SkLJHm5gd9R8
        QwUfd4qmFn/VI2JteeHhBQZrzYuhGgzSbh8k6QFsT9L4mzRN5gZPslgh5AqPB4QehoYGFy7d6FnBw
        Q7prGAaeQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:48406)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1kUdXQ-0006RE-Gw; Mon, 19 Oct 2020 23:21:56 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1kUdXN-0004cH-LX; Mon, 19 Oct 2020 23:21:53 +0100
Date:   Mon, 19 Oct 2020 23:21:53 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Robert Hancock <robert.hancock@calian.com>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH] net: phy: marvell: add special handling of Finisar
 modules with 81E1111
Message-ID: <20201019222153.GZ1551@shell.armlinux.org.uk>
References: <20201019204913.467287-1-robert.hancock@calian.com>
 <20201019210852.GW1551@shell.armlinux.org.uk>
 <30161ca241d03c201e801af7089dada5b6481c24.camel@calian.com>
 <20201019214536.GX139700@lunn.ch>
 <1f3243e15a8600dd9876b97410b450029674c50c.camel@calian.com>
 <20201019221232.GB139700@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201019221232.GB139700@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 20, 2020 at 12:12:32AM +0200, Andrew Lunn wrote:
> > The auto-negotiation is a bit of a weird thing in this case, as there
> > are two negotiations occurring, the 1000BaseX between the PCS/PMA PHY
> > and the module PHY, and the 1000BaseT between the module PHY and the
> > copper link partner. I believe the 88E1111 has some smarts to delay the
> > copper negotiation until it gets the advertisement over 1000BaseX, uses
> > those to figure out its advertisement, and then uses the copper link
> > partner's response to determine the 1000BaseX response.
> 
> But as far as i know you can only report duplex and pause over
> 1000BaseX, not speed, since it is always 1G.

That is correct.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
