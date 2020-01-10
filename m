Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A90541369F8
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 10:27:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726916AbgAJJ1J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 04:27:09 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:38720 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726641AbgAJJ1I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jan 2020 04:27:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=IzR1/pMpb7xjBse9eoQEK3YZKw0Lok5VBxQSI7WIc6k=; b=BVajm4eCcvvAJo9qHJEAuImMT
        7fyt0bnzQ7uxEw1FX1Nht3pjiOFE2cT1ZSf6O1Fj3z6v/KOKGYkfmXikGZjImlg8mHqfZMzNVpqjb
        MPAAkvzC65+OgwChxY4SvyxNggWuuIZUsKQcTjliBL4lI4XHKfE7ibw4RPwLltNe+spHAP+SkCO8U
        9/TsmpE76HHJRdAz97nbBINNVmGhlzsb5xVIa1+ZbGlwyriAWspwyFum960oaPfjStesYikrAQLm+
        /S1RDcwrhuX91Tk+Yx1rdAEq2imnkCV6gMOo6CzqYpdoOGVhYLw+4mTpV738cRwBzJmaBVIczrVat
        Vx6Z/Av4w==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:53020)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1ipqZK-00028S-Oa; Fri, 10 Jan 2020 09:27:02 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1ipqZI-0001O5-NZ; Fri, 10 Jan 2020 09:27:00 +0000
Date:   Fri, 10 Jan 2020 09:27:00 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     =?utf-8?B?0b3SieG2rOG4s+KEoA==?= <vtol@gmx.net>
Cc:     Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org
Subject: Re: [drivers/net/phy/sfp] intermittent failure in state machine
 checks
Message-ID: <20200110092700.GX25745@shell.armlinux.org.uk>
References: <513d6fe7-65b2-733b-1d17-b3a40b8161cf@gmx.net>
 <20200109155809.GQ25745@shell.armlinux.org.uk>
 <bb2c2eed-5efa-00f6-0e52-1326669c1b0d@gmx.net>
 <20200109174322.GR25745@shell.armlinux.org.uk>
 <acd4d7e4-7f8e-d578-c9c9-b45f062f4fe2@gmx.net>
 <7ebee7c5-4bf3-134d-bc57-ea71e0bdfc60@gmx.net>
 <20200109215903.GV25745@shell.armlinux.org.uk>
 <c7b4bec1-3f1f-8a34-cf22-8fb1f68914f3@gmx.net>
 <20200109231034.GW25745@shell.armlinux.org.uk>
 <727cea4e-9bff-efd2-3939-437038a322ad@gmx.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <727cea4e-9bff-efd2-3939-437038a322ad@gmx.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 09, 2020 at 11:50:14PM +0000, ѽ҉ᶬḳ℠ wrote:
> 
> On 09/01/2020 23:10, Russell King - ARM Linux admin wrote:
> > 
> > Please don't use mii-tool with SFPs that do not have a PHY; the "PHY"
> > registers are emulated, and are there just for compatibility. Please
> > use ethtool in preference, especially for SFPs.
> 
> Sure, just ethtool is not much of help for this particular matter, all there
> is ethtool -m and according to you the EEPROM dump is not to be relied on.

How about just "ethtool eth2" ?

> > CONFIG_DEBUG_GPIO is not the same as having debugfs support enabled.
> > If debugfs is enabled, then gpiolib will provide the current state
> > of gpios through debugfs.  debugfs is normally mounted on
> > /sys/kernel/debug, but may not be mounted by default depending on
> > policy.  Looking in /proc/filesystems will tell you definitively
> > whether debugfs is enabled or not in the kernel.
> debugsfs is mounted but ls -af /sys/kernel/debug/gpio only producing
> (oddly):
> 
> /sys/kernel/debug/gpio

Try "cat /sys/kernel/debug/gpio"

> > So, if that is correct...
> > 
> > Current OpenWRT is derived from 4.19-stable kernels, which include
> > experimental patches picked at some point from my "phy" branch, and
> > TOS is derived from OpenWRT.
> 
> This may not be correct since there are not many device targets in OpenWrt
> that feature a SFP cage (least as of today), the Turris Omnia might even be
> the sole one.

It isn't; there are definitely platforms that run OpenWRT that also
have SFP cages (even a pair of them) and that make use of this code.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
