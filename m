Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 654352F0902
	for <lists+netdev@lfdr.de>; Sun, 10 Jan 2021 19:20:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726866AbhAJSSL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Jan 2021 13:18:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726559AbhAJSSK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Jan 2021 13:18:10 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A424C061794;
        Sun, 10 Jan 2021 10:17:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=8HYhH0GRjr45tIiMD5F9hZRaFo4XF1moOSQLZiV5T0w=; b=tJrXgLdc0zU35uXDSo01yrVad
        hrlEBWK6ixb6dwWlPYDQoty9KwGTB4ARzjIw5V3UOBe6ZPxDWMyJS/UtkOEAqDW8rA2p64pDsDRBa
        r6dYMHEoJ23QW2z3tmOBkad4KG2w0DT/BSu/H0AmzQ4rtyXmF5UysSrzoKm0DjgxPThOfkF+RxJeS
        1WnpkkV1uG+om8nxVTJdzCj2+Pgnkv2l00uVXRf722J1rjIxol4OaQBE9oE+08Ba6cn4EM++uHSYp
        +4ctMfViTUB11jxxVmifSPvV6lRUhccipfPOuqTwU4PeqzwgusJOagMNO6fGZScxbdngk1akMtqgn
        F18dpQfEA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:46254)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1kyfHM-00065x-NX; Sun, 10 Jan 2021 18:17:28 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1kyfHM-0004QP-0f; Sun, 10 Jan 2021 18:17:28 +0000
Date:   Sun, 10 Jan 2021 18:17:27 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     stefanc@marvell.com
Cc:     netdev@vger.kernel.org, thomas.petazzoni@bootlin.com,
        davem@davemloft.net, nadavh@marvell.com, ymarkman@marvell.com,
        linux-kernel@vger.kernel.org, kuba@kernel.org, mw@semihalf.com,
        andrew@lunn.ch, atenart@kernel.org
Subject: Re: [PATCH RFC net-next  00/19] net: mvpp2: Add TX Flow Control
 support
Message-ID: <20210110181727.GK1551@shell.armlinux.org.uk>
References: <1610292623-15564-1-git-send-email-stefanc@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1610292623-15564-1-git-send-email-stefanc@marvell.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Sun, Jan 10, 2021 at 05:30:04PM +0200, stefanc@marvell.com wrote:
> Armada hardware has a pause generation mechanism in GOP (MAC).
> GOP has to generate flow control frames based on an indication
> programmed in Ports Control 0 Register. There is a bit per port.
> However assertion of the PortX Pause bits in the ports control 0 register
> only sends a one time pause. To complement the function the GOP has
> a mechanism to periodically send pause control messages based on periodic counters.
> This mechanism ensures that the pause is effective as long as the Appropriate PortX Pause
> is asserted.

Can you ensure that your commit messages are consistently wrapped?
Some lines are wrapped others aren't.

> Problem is that Packet Processor witch actually can drop packets due to lack of resources

Does the packet processor engage in magic or witchcraft? I suppose
some would argue that firmware does "magic"! However, I think you
mean "which". :)

> not connected to the GOP flow control generation mechanism.
> To solve this issue Armada has firmware running on CM3 CPU dedectated for Flow Control
> support. Firmware monitors Packet Processor resources and asserts XON/XOFF by writing
> to Ports Control 0 Register.

What is the minimum firmware version that supports this?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
