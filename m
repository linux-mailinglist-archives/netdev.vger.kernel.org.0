Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78E2241B323
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 17:41:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241687AbhI1Png (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 11:43:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241652AbhI1Pnd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Sep 2021 11:43:33 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5EAAC06161C;
        Tue, 28 Sep 2021 08:41:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=gEqaAtXioo2FwTuFrHkB+GPobkG1HZy9wNfU3a0tY14=; b=AOKwRVZgUda+mGFdDQDdc+wOPN
        5pZO0SlRH+RqGp2oEsVJzKCDIzWDsHp8cmduPanzYl+XwTbNR/zqF/wir1MjcOqASOet9I7qMvXdy
        WKV8JtBh18ub5B2JcD4SMRZP9XtLB86vnQbKTA096qpqxhdOgO0xwrvxfb4m9PXiPyt4n95g6d4yQ
        fEcnD3lV3A7yYOoWr9Zok9+I3T5zVv9pNfYwZt14tPpDnh4w9o9xEDAWTugq3cv7sTUcaFnkEtVbp
        GARnE5OVgXWWDSoicg9YaUzgyPi5c2wWxZczmx7qE62Zkb6UFGlHns3JXjPhlme5tXY79HF+o+yDp
        UTqUMrCQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:54832)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mVFEi-0001H0-45; Tue, 28 Sep 2021 16:41:40 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mVFEe-0001rm-PR; Tue, 28 Sep 2021 16:41:36 +0100
Date:   Tue, 28 Sep 2021 16:41:36 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Pavel Skripkin <paskripkin@gmail.com>,
        Yanfei Xu <yanfei.xu@windriver.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        andrew@lunn.ch, hkallweit1@gmail.com, davem@davemloft.net,
        kuba@kernel.org, p.zabel@pengutronix.de,
        syzbot+398e7dc692ddbbb4cfec@syzkaller.appspotmail.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Dongliang Mu <mudongliangabcd@gmail.com>
Subject: Re: [PATCH] net: mdiobus: Fix memory leak in __mdiobus_register
Message-ID: <YVM3sFBIHzEnshvd@shell.armlinux.org.uk>
References: <20210928092657.GI2048@kadam>
 <6f90fa0f-6d3b-0ca7-e894-eb971b3b69fa@gmail.com>
 <20210928103908.GJ2048@kadam>
 <63b18426-c39e-d898-08fb-8bfd05b7be9e@gmail.com>
 <20210928105943.GL2083@kadam>
 <283d01f0-d5eb-914e-1bd2-baae0420073c@gmail.com>
 <f587da4b-09dd-4c32-4ee4-5ec8b9ad792f@gmail.com>
 <20210928113055.GN2083@kadam>
 <YVMRWNDZDUOvQjHL@shell.armlinux.org.uk>
 <20210928135207.GP2083@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210928135207.GP2083@kadam>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 28, 2021 at 04:52:07PM +0300, Dan Carpenter wrote:
> On Tue, Sep 28, 2021 at 01:58:00PM +0100, Russell King (Oracle) wrote:
> >
> > This thread seems to be getting out of hand.
> 
> The thread was closed.  We need to revert Yanfei's patch and apply
> Pavel's patch.  He's going to resend.
> 
> > So, I would suggest a simple fix is to set bus->state to
> > MDIOBUS_UNREGISTERED immediately _after_ the successful
> > device_register().
> 
> Not after.  It has to be set to MDIOBUS_UNREGISTERED if device_register()
> fails, otherwise there will still be a leak.

Ah yes, you are correct - the device name may not be freed. Also...

 * NOTE: _Never_ directly free @dev after calling this function, even
 * if it returned an error! Always use put_device() to give up your
 * reference instead.

So yes, we must set to MDIOBUS_UNREGISTERED even if device_register()
fails.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
