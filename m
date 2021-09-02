Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA0433FF5B7
	for <lists+netdev@lfdr.de>; Thu,  2 Sep 2021 23:39:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347487AbhIBVko (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Sep 2021 17:40:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347069AbhIBVkn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Sep 2021 17:40:43 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 712F7C061575;
        Thu,  2 Sep 2021 14:39:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=V1+vIKjg/39N9wEqABCFQYZvJXbwgTWmoMxbO0j5aDk=; b=CN3i3OWLNd1CWwwDit/hAwsGP
        4cTjFplU/3UT0XEuH7nXlWiVvI3lF334gGhyLFPFGycKRTk0udNezn46YD02UsPcQW1Be89YE0bv5
        BtUE8s44GNx7pQgjA9CqHR9WUttGFV12H5/KsHIcHFHAR+GBQzf7DSPJXohYqZQ91L+nINAH+VvGe
        Ofelk+ncqgkEporAWT5xcpwgO6egn4qUBKVMI9WnAAAuv+19beLr3het2Mb8XlqVWcQZ96D0G9LZl
        VeuWS+N2e4zAiWoKo2T2Zdxs0WlLvbWuHtbZf7vM+D9cEhikVMjHCUS6spWvLzZD73YVtWQGys1Yx
        2eiAVnlOA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:48114)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mLuQv-00024z-Uj; Thu, 02 Sep 2021 22:39:41 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mLuQu-0008Fl-QW; Thu, 02 Sep 2021 22:39:40 +0100
Date:   Thu, 2 Sep 2021 22:39:40 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        netdev@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Alvin =?utf-8?Q?=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        kernel-team <kernel-team@android.com>,
        Len Brown <lenb@kernel.org>
Subject: Re: [RFC PATCH net-next 0/3] Make the PHY library stop being so
 greedy when binding the generic PHY driver
Message-ID: <20210902213940.GP22278@shell.armlinux.org.uk>
References: <20210901225053.1205571-1-vladimir.oltean@nxp.com>
 <20210902121927.GE22278@shell.armlinux.org.uk>
 <20210902123532.ruvuecxoig67yv5v@skbuf>
 <YTEvFR2WGQmG3h/C@lunn.ch>
 <20210902203248.dy5b6ismgb55s5cd@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210902203248.dy5b6ismgb55s5cd@skbuf>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 02, 2021 at 11:32:48PM +0300, Vladimir Oltean wrote:
> But these patches also solve DSA's issue with the circular dependency
> between the switch and its internal PHYs, and nobody seems to have asked
> the most important question: why?

Surely you specified that in your cover message and in the patch
that actually fixes the problem, as one always should do.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
