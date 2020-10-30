Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE5712A0901
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 16:01:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726813AbgJ3PBu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 11:01:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726691AbgJ3PBu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Oct 2020 11:01:50 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 270F0C0613D5
        for <netdev@vger.kernel.org>; Fri, 30 Oct 2020 08:01:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=qTamfvc9bl8x721EWWvU55KILuhSYGz7vEiw/2lF/6Y=; b=cY8s81lnH0lHtCmTAvGiM0gor
        joUsdMl2Gq3vwDacykurHRwI8xAifjfWQiOppLZa+llWoZPxyLTecfb7StRevoubs66aTVP9gB2VY
        NhecEGAPmFMgbOz8DG3+HaZK1Rej7evPEnITNwYct5PM4PzA6ECTXpEaWTs/16LWv2p4wnlx3z3O0
        MmA1nrCBI5K8Q+fDHFwdUBS6RP1VcRIy/aDhrDpGebsPns/9oVmokZ9JIoQGLygUTqyX7yKxCVUdE
        oMBEsy76dlHkYL1iJ+NmS1cWkTkIYbokNc3lSKpJ1OkuMn1zZ5uPdeB4hSyDBYgE/J8tbuUqGN6de
        mcA1Ql7VA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:52926)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1kYVuP-0006AU-6i; Fri, 30 Oct 2020 15:01:41 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1kYVuM-0007FU-7P; Fri, 30 Oct 2020 15:01:38 +0000
Date:   Fri, 30 Oct 2020 15:01:38 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH net-next v2 0/5] Support for RollBall 10G copper SFP
 modules
Message-ID: <20201030150138.GB1551@shell.armlinux.org.uk>
References: <20201029222509.27201-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20201029222509.27201-1-kabel@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A general point: please have me in the To: line rather than the Cc:
line so that I can find emails better; I've just spent quite a while
trying to find this series you posted last night amongst all the
other emails that I'm Cc'd on.

(The difference between To: and Cc: is that you expect those in the To:
header to be the primary recipients who you expect action from, and
those in the Cc: to be secondary recipients for information.)

https://blog.thedigitalgroup.com/to-vs-cc-vs-bcc-how-to-use-them-correctly
https://www.writebetteremails.com/to-cc.htm
https://thinkproductive.co.uk/email-using-cc-bcc-to/
... etc ...

Thanks.

On Thu, Oct 29, 2020 at 11:25:04PM +0100, Marek Behún wrote:
> Hello,
> 
> this is v2 of series adding support for RollBall/Hilink SFP modules.
> 
> Checked with:
>   checkpatch.pl --max-line-length=80
> 
> Changes from v1:
> - wrapped to 80 columns as per Russell's request
> - initialization of RollBall MDIO I2C protocol moved from sfp.c to
>   mdio-i2c.c as per Russell's request
> - second patch removes the 802.3z check also from phylink_sfp_config
>   as suggested by Russell
> - creation/destruction of mdiobus for SFP now occurs before probing
>   for PHY/after releasing PHY (as suggested by Russell)
> - the last patch became a little simpler after the above was done
> 
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: Russell King <rmk+kernel@armlinux.org.uk>
> 
> Marek Behún (5):
>   net: phy: mdio-i2c: support I2C MDIO protocol for RollBall SFP modules
>   net: phylink: allow attaching phy for SFP modules on 802.3z mode
>   net: sfp: create/destroy I2C mdiobus before PHY probe/after PHY
>     release
>   net: phy: marvell10g: change MACTYPE if underlying MAC does not
>     support it
>   net: sfp: add support for multigig RollBall transceivers
> 
>  drivers/net/mdio/mdio-i2c.c   | 232 +++++++++++++++++++++++++++++++++-
>  drivers/net/phy/marvell10g.c  |  31 +++++
>  drivers/net/phy/phylink.c     |   5 +-
>  drivers/net/phy/sfp.c         |  67 ++++++++--
>  include/linux/mdio/mdio-i2c.h |   8 +-
>  5 files changed, 322 insertions(+), 21 deletions(-)
> 
> 
> base-commit: cd29296fdfca919590e4004a7e4905544f4c4a32
> -- 
> 2.26.2
> 
> 

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
