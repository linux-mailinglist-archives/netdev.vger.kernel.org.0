Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 500963F9EE2
	for <lists+netdev@lfdr.de>; Fri, 27 Aug 2021 20:34:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230110AbhH0Sex (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Aug 2021 14:34:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229750AbhH0Sew (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Aug 2021 14:34:52 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99D18C061757;
        Fri, 27 Aug 2021 11:34:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=fI9yoLyUv5cPt2negSqTM3oknZHzA3osclLlMhP8NBs=; b=DVIjl0cTbl3/dLf8Wi/XqjBRt
        baty8HHpOPgKs/JDZ0ttz2k7jmYRUYxenz402Jgoqn2lDwdNX5K4doNCN0gOQi+bw5yUrko/9Un/b
        jCejtnjiegWe6pVUwqIs/2J+z2N/0zCscnzHBqZ51MUCnu92dbhZEjldAzDbp5gInppZOq2FjbNi6
        ebgTmYfAo993krOjG6n2glGNNFgxLItlIkPnG3E3r7CXt0l+xEeoaLp11q55Pagc0eoUNW7UH3ftv
        SM7+yxXQdS+d3BGmV3qPwMUO9vbXHi3ifIAqNoQxydLwsjaSt6nR24RAAP4SzduskcxSRmhWd+E9i
        8pQoOtUUg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:47762)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mJgfs-0001TX-3M; Fri, 27 Aug 2021 19:33:56 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mJgfr-00020X-Es; Fri, 27 Aug 2021 19:33:55 +0100
Date:   Fri, 27 Aug 2021 19:33:55 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Pali =?iso-8859-1?Q?Roh=E1r?= <pali@kernel.org>
Cc:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Vinod Koul <vkoul@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Rob Herring <robh@kernel.org>, linux-phy@lists.infradead.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] phy: marvell: phy-mvebu-a3700-comphy: Remove
 unsupported modes
Message-ID: <20210827183355.GV22278@shell.armlinux.org.uk>
References: <20210827092753.2359-1-pali@kernel.org>
 <20210827092753.2359-3-pali@kernel.org>
 <20210827132713.61ef86f0@thinkpad>
 <20210827182502.vdapjcqimq4ulkg2@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210827182502.vdapjcqimq4ulkg2@pali>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 27, 2021 at 08:25:02PM +0200, Pali Rohár wrote:
> cp110-comphy and a3700-comphy are just RPC drivers which calls SMC and
> relay on firmware support which implements real work. And both uses same
> RPC / SMC API. So merging drivers into one is possible.
> 
> But I do not think that it is a good idea that Linux kernel depends on
> some external firmware which implements RPC API for configuring HW.
> 
> Rather kernel should implements its native drivers without dependency on
> external firmware.
> 
> We know from history that kernel tried to avoid using x86 BIOS/firmware
> due to bugs and all functionality (re)-implemented itself without using
> firmware RPC functionality.

Not really an argument in this case. We're not talking about closed
source firmware.

> Kernel has already "hacks" in other drivers which are using these comphy
> drivers, just because older versions of firmware do not support all
> necessary functionality and upgrading this firmware is not easy step
> (and sometimes even not possible; e.g. when is cryptographically
> signed).

The kernel used to (and probably still does) contain code to configure
the comphys. Having worked on trying to get the 10G lanes stable on
Macchiatobin, I much prefer the existing solution where it's in the
ATF firmware. I've rebuilt the firmware several times during the course
of that.

The advantage is that fixing the setup of the COMPHY is done in one
place, and it fixes it not only for the kernel, but also for u-boot
and UEFI too. So rather than having to maintain three different
places for a particular board, we can maintain the parameters in one
place - in the ATF firmware.

The problem with the past has been that stuff gets accepted into the
kernel without the "full system" view and without regard for "should
this actually be done in the firmware". Then, when it's decided that
it really should be done in the firmware, we end up needing to keep
the old stuff in the kernel for compatibility with older firmware,
which incidentally may not be up to date.

If we were to drop the comphy setup from firmware, then we will need
a lot of additional properties in the kernel's DT and u-boot DT for
the comphy to configure it appropriately. And ACPI. I don't think
that scales very well, and is a recipe for things getting out of
step.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
