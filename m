Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F19FE28EFA6
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 11:53:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730846AbgJOJxQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Oct 2020 05:53:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727165AbgJOJxP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Oct 2020 05:53:15 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32531C061755;
        Thu, 15 Oct 2020 02:53:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=dbmxkwYLeu14/trY1roq3k5j51cj5RLgD2hpnhpCK2o=; b=MGcuj9nZfh5vwyvI5PFOeDKax
        MlpEaCmW/IPzj/OA2fFvrcZqSBAQcOuMPa03BhUV6ZbecBgLtiv1gxXFuYV3o5dHKd3osnZA52kUt
        ka+3vXNgiMIKDnYIc/k+80HBYNsKc8/t2AA/t7C7h0qoeS/upy5XfPA8z75W0kO5mGy+3jRRKvc89
        sj6I4flJyey9bXQTL7wt84RcIDWnbTKKefizDm3nGPLVgJZzquYJGAfN3z+Fso75lRmlNOORGaSHN
        DkCf6Gg1orSkT4uSJOSDZqTbwplNRX9oJEk1YSUKwyX+UKLTumE/nj26eCftOdKQcxfcDRSWED3RE
        +AKn1vY2Q==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:46250)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1kSzwc-0008Mq-DT; Thu, 15 Oct 2020 10:53:10 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1kSzwZ-00005L-B1; Thu, 15 Oct 2020 10:53:07 +0100
Date:   Thu, 15 Oct 2020 10:53:07 +0100
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
Message-ID: <20201015095307.GS1551@shell.armlinux.org.uk>
References: <20201008154601.1901004-1-arnd@arndb.de>
 <20201008154601.1901004-4-arnd@arndb.de>
 <CACRpkdbc-Y6M+q8f7VEiee41ChUtP_5ygy_YN-wi873a+bN3yQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdbc-Y6M+q8f7VEiee41ChUtP_5ygy_YN-wi873a+bN3yQ@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 15, 2020 at 09:53:29AM +0200, Linus Walleij wrote:
> On Thu, Oct 8, 2020 at 5:46 PM Arnd Bergmann <arnd@arndb.de> wrote:
> 
> > With Arm EBSA110 gone, nothing uses it any more, so the corresponding
> > code and the Kconfig option can be removed.
> >
> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> 
> Very nice cleanup.
> Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
> 
> At some point we should do a retrospect about how hard it really is for
> us to get rid of some really annoying core legacy codepaths and the best
> strategy for doing so, even though this took 11+ years as Thomas
> says it still looks like a solid path to move over to a generic framework,
> only it requires enough gritty people (like you) to hang around and do the
> work piece by piece.

Don't be misled. It was not a matter of "enough gritty people", it
was a matter that EBSA110 was blocking it.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
