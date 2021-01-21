Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DD822FF312
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 19:25:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728253AbhAUSWE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 13:22:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733310AbhAUSTi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jan 2021 13:19:38 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD0B1C06174A
        for <netdev@vger.kernel.org>; Thu, 21 Jan 2021 10:18:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=n+7s1NqxCgqXJcbfxpzaNn6cyTg9f2ty1WaVqSroHUE=; b=C5cwTVIZtcI1L+vPDI+GhXsYz
        mS+hK6eec6X/LKTnMi/uMQF9FeUihvXgox4gpKqxAaCJMhGrq6RMy4JVEmNWc6j99bZGZfM5doTBZ
        YV5JMKC1gWCRIFyF282sD1HNUlWMX8S7egP2sNzUST06adftheesvM5Fny1+dp6ye/X0E0Rq6EhNM
        HB5BCWUM+hZ4QqsGyRA+cCMfTlLOsh6xEXSJK27x7JVzDdt2TfS4ygULVRzYNkBtd8GvHu1XQtk9m
        05b7kmbMyQZ1v/GUOmYMz6u5Q1QTaEIX8JVKaN3mYJmbnULOaSyfihyY0V6y8v1RjMSJCRxgwD5bd
        Xgzy6g5Xg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:50910)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1l2eXg-0001l4-Ry; Thu, 21 Jan 2021 18:18:48 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1l2eXf-0007Gr-HJ; Thu, 21 Jan 2021 18:18:47 +0000
Date:   Thu, 21 Jan 2021 18:18:47 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Richard Cochran <richardcochran@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: ethtool: allow MAC drivers to override
 ethtool get_ts_info
Message-ID: <20210121181847.GQ1551@shell.armlinux.org.uk>
References: <E1kyYfI-0004wl-Tf@rmk-PC.armlinux.org.uk>
 <20210114125506.GC3154@hoboy.vegasvil.org>
 <20210114132217.GR1551@shell.armlinux.org.uk>
 <20210114133235.GP1605@shell.armlinux.org.uk>
 <20210114172712.GA13644@hoboy.vegasvil.org>
 <20210114173111.GX1551@shell.armlinux.org.uk>
 <20210114223800.GR1605@shell.armlinux.org.uk>
 <20210121040451.GB14465@hoboy.vegasvil.org>
 <20210121102738.GN1551@shell.armlinux.org.uk>
 <20210121150611.GA20321@hoboy.vegasvil.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210121150611.GA20321@hoboy.vegasvil.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 21, 2021 at 07:06:11AM -0800, Richard Cochran wrote:
> On Thu, Jan 21, 2021 at 10:27:38AM +0000, Russell King - ARM Linux admin wrote:
> > As I already explained to you, you can *NOT* use kernel configuration
> > to make the choice.  ARM is a multi-platform kernel, and we will not
> > stand for platform choices dictated by kernel configuration options.
> 
> This has nothing to do with ARM as a platform.  The same limitation
> applies to x86 and all the rest.

You don't plainly don't understand, because you just called ARM a
platform. ARM isn't a platform, it's an architecture, which is a
totally different thing.

A platform is a device, like a phone, or a router, or a computer.
However, all platforms may have the same CPU architecture - that
being ARM.

ARM as an architecture is in the situation where distributions have
pushed hard for it to be like x86. You build one kernel for your
distribution, not multiple hardware specific kernels. That means,
there is one kernel configuration. Platform specifics are handled
through firmware such as device tree.

Having platform specific kernel configuration options, such as "we
want to use PHY timestamping" vs "we want to use MAC timestamping"
do not work in this environment.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
