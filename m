Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 563511637FB
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 01:06:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727723AbgBSAGR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 19:06:17 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:33494 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726415AbgBSAGR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Feb 2020 19:06:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=EbptOgdB/q1QzORcIPJ5DSoP1e8Lu7kzA96imJ2Ki4I=; b=YY905mNCreZHRFwytkkcBOR9C
        GWfEJkm/4PEdLwe0JeuK84wqXKFTk/+vOsgI4mHVv0LxxczS8NeCSDnK3W9IQ5b5R4zGCtxNsXVKx
        u9WHgASuZHCch+mAX0n87UV0g7yaExw3ixYj/tVrgFxX9t8M2IThBnQTrFU/LutGZKi8nvb2Cpfl4
        k5LpDLJ1zl2XShWaWHLrdGUx94jpLcRuZycWaK/wt1eGjfTGqrlGoEwJyeN1DYqmz4Gc2oqCft/2M
        oQsVQEzK5s3LHITx8mkS37ZTKn56Hstip+Km4J2LTNfibHHQCGTVVMrCZWdSDbTYKjEEJEOaDuZVr
        eWyp94KjA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:53866)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1j4CsQ-00020o-Vg; Wed, 19 Feb 2020 00:06:10 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1j4CsP-0000rn-3o; Wed, 19 Feb 2020 00:06:05 +0000
Date:   Wed, 19 Feb 2020 00:06:05 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Dan Murphy <dmurphy@ti.com>
Cc:     Grygorii Strashko <grygorii.strashko@ti.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, andrew@lunn.ch,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2] net: phy: dp83867: Add speed optimization
 feature
Message-ID: <20200219000604.GO25745@shell.armlinux.org.uk>
References: <7569617d-f69f-9190-1223-77d3be637753@gmail.com>
 <c7a7bd71-3a1c-1cf3-5faa-204b10ea8b78@ti.com>
 <44499cb2-ec72-75a1-195b-fbadd8463e1c@ti.com>
 <6f800f83-0008-c138-c33a-c00a95862463@ti.com>
 <20200218162522.GH25745@shell.armlinux.org.uk>
 <1346e6b0-1d20-593f-d994-37de87ede891@ti.com>
 <20200218164928.GJ25745@shell.armlinux.org.uk>
 <cba40adb-38b9-2e66-c083-3ca7b570b927@ti.com>
 <20200218173353.GM25745@shell.armlinux.org.uk>
 <f5c42936-98a6-8221-a244-ed61840c9c81@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f5c42936-98a6-8221-a244-ed61840c9c81@ti.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 18, 2020 at 11:38:33AM -0600, Dan Murphy wrote:
> Russell
> 
> On 2/18/20 11:33 AM, Russell King - ARM Linux admin wrote:
> > As I mentioned, the PHY on either end of the link can be the one
> > which decides to downshift, and the partner PHY has no idea that
> > a downshift has happened.
> > 
> Exactly so we can only report that if the PHY on our end caused the
> downshift.  If this PHY does not cause the downshift then the message will
> not be presented even though a downshift occurred. So what is the value in
> presenting this message?

I think we are in agreement over questioning the value of reporting
the downshift!

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
