Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A53D2916CC
	for <lists+netdev@lfdr.de>; Sun, 18 Oct 2020 11:52:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726310AbgJRJvy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Oct 2020 05:51:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725320AbgJRJvx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Oct 2020 05:51:53 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3363DC061755;
        Sun, 18 Oct 2020 02:51:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=qEMPtsMLmphrg8Ai/5Jx8LIQzpGt/vPBENY1d0RHC0E=; b=Lcf4K01IIvsr9y0KWAyBU51kL
        tBL6KBpVPqVkHgTKZ8NomGJTe0GNS4C7pFwC22oHL20kyd6gBm2HOhmjqwLjR1cEbFQf+7z6ngNT/
        yWNSWU3RKHlTp60XJzKTHAFdkMEw3CNV0oAD1Ij+wRmggkUZpZ9I5NXABiCqfoKe2SYalm2m1gfMv
        lMqRrXmJ/Yepa8+lc+QPNQmmsPQ3L4FlNdKxjrGwqPqeagjoYs1u3hMW1Fl0Nq2A+gHW+aJIOWHl5
        GP44LwSAJ3TOpXTgLfqAJC6MsPO8dh3wlkt+tCOQkq9/WlMBajs7v0eYzw4fTWRz9k/7DT/epZdA9
        nOo7Ap+lA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:47782)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1kU5Lq-0004Al-VS; Sun, 18 Oct 2020 10:51:43 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1kU5Lm-00039F-1K; Sun, 18 Oct 2020 10:51:38 +0100
Date:   Sun, 18 Oct 2020 10:51:38 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        John Stultz <john.stultz@linaro.org>,
        Stephen Boyd <sboyd@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 3/3] timekeeping: remove arch_gettimeoffset
Message-ID: <20201018095137.GV1551@shell.armlinux.org.uk>
References: <20201008154601.1901004-1-arnd@arndb.de>
 <20201008154601.1901004-4-arnd@arndb.de>
 <CACRpkdbc-Y6M+q8f7VEiee41ChUtP_5ygy_YN-wi873a+bN3yQ@mail.gmail.com>
 <20201015095307.GS1551@shell.armlinux.org.uk>
 <CACRpkdaOuMHfqrToVPRVW1zEYDY6H-gPm1QkR2CydtbLj-7csw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdaOuMHfqrToVPRVW1zEYDY6H-gPm1QkR2CydtbLj-7csw@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 15, 2020 at 02:38:07PM +0200, Linus Walleij wrote:
> On Thu, Oct 15, 2020 at 11:53 AM Russell King - ARM Linux admin
> <linux@armlinux.org.uk> wrote:
> 
> > Don't be misled. It was not a matter of "enough gritty people", it
> > was a matter that EBSA110 was blocking it.
> 
> I remember that EBSA110 was quite different in that it had this
> especially limited PIT timer, true that. At one point I even read
> up on the details of it and then forgot them :/

Yes, it was so basic that it required software to reprogram it on every
interrupt - it had no sensible periodic mode. The side effect of which
was that unless done carefully, your timekeeping varied all over the
place (so much that ntpd was not happy.) The final implementation made
ntpd really quite happy on the machine despite the timer's weirdness,
up until Linux stopped allowing interrupts to be nested. At that point,
it was back to utterly crap timekeeping.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
