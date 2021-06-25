Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79D333B4791
	for <lists+netdev@lfdr.de>; Fri, 25 Jun 2021 18:49:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229975AbhFYQvX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Jun 2021 12:51:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229586AbhFYQvV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Jun 2021 12:51:21 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 649E0C061574;
        Fri, 25 Jun 2021 09:49:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=kwgIfr/lhJ0ryHMTahUJt0vf/j0H30v0H27zweCUKY4=; b=RmM6MYi8CJXQUpD5jBXg6mQqx
        I6hvx10q1MZOSwQlQgYTsD+Y7zeyGwCQGmlq8VnNQ7eYpdRf61PMb7VF06+h5Zzk1s1eExAcx7F6W
        52XOWHkYUlq+/8ACcAwwuSJ4vWwZjd5DY2/kccT8XM3IvOSBCQxXebA95AjQAUnZoJiLHSXb4A/rS
        9N1kXxmj/EB4DuwGMRSzl7D1ZR1Yf8+zZPG2+fgDH10cSZ0N/S1xJYLwTJHY3pkm1JsCi18XsJTz1
        OGi2pz/aWCYPWyYS5LXNHvh2lmykl+VfwXH2psA3GVWeyU7BAOA05rufDlX/xABQx6qoV1gwfFpu9
        062j/bl1A==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:45354)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1lwp0R-00010f-V9; Fri, 25 Jun 2021 17:48:40 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1lwp0M-0006pT-SI; Fri, 25 Jun 2021 17:48:35 +0100
Date:   Fri, 25 Jun 2021 17:48:34 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     "Voon, Weifeng" <weifeng.voon@intel.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "Ling, Pei Lee" <pei.lee.ling@intel.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        "Ong, Boon Leong" <boon.leong.ong@intel.com>,
        Wong Vee Khee <vee.khee.wong@linux.intel.com>,
        "Wong, Vee Khee" <vee.khee.wong@intel.com>,
        "Tan, Tee Min" <tee.min.tan@intel.com>,
        "Sit, Michael Wei Hong" <michael.wei.hong.sit@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next V1 3/4] net: stmmac: Reconfigure the PHY WOL
 settings in stmmac_resume()
Message-ID: <20210625164834.GY22278@shell.armlinux.org.uk>
References: <20210621094536.387442-1-pei.lee.ling@intel.com>
 <20210621094536.387442-4-pei.lee.ling@intel.com>
 <YNCOqGCDgSOy/yTP@lunn.ch>
 <CH0PR11MB53806E2DC74B2B9BE8F84D7088089@CH0PR11MB5380.namprd11.prod.outlook.com>
 <YNONPZAfmdyBMoL5@lunn.ch>
 <CH0PR11MB538084AFEA548F4B453C624F88079@CH0PR11MB5380.namprd11.prod.outlook.com>
 <YNSLQpNsNhLkK8an@lunn.ch>
 <CH0PR11MB53806D16AF301F16A298C70C88069@CH0PR11MB5380.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CH0PR11MB53806D16AF301F16A298C70C88069@CH0PR11MB5380.namprd11.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 25, 2021 at 03:58:17PM +0000, Voon, Weifeng wrote:
> > > No, the interrupt will not be discarded. If the PHY is in interrupt
> > > mode, the interrupt handler will triggers and ISR will clear the WOL
> > status bit.
> > > The condition here is when the PHY is in polling mode, the PHY driver
> > > does not have any other mechanism to clear the WOL interrupt status bit.
> > > Hence, we need to go through the PHY set_wol() again.
> > 
> > I would say you have a broken setup. If you are explicitly using the
> > interrupt as a wakeup source, you need to be servicing the interrupt. You
> > cannot use polled mode.
>  
> Sorry for the confusion. But I would like to clarify the I should use the
> term of "WOL event status" rather than "WOL interrupt status". 
> For interrupt mode, clearing the "WOL interrupt status" register will auto
> clear the "WOL event status".
> For polling mode, the phy driver can manually clear the "WOL event status" by
> setting 1 to "Clear WOL Status" bit.  

If WOL raises an interrupt signal from the PHY, but the PHY interrupt
signal is not wired, how does the wakeup happen? What is the PHY
interrupt wired to?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
