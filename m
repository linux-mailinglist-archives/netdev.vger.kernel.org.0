Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4079C314DB2
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 11:59:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232208AbhBIK6d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 05:58:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231950AbhBIKzx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 05:55:53 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D8A2C061797;
        Tue,  9 Feb 2021 02:55:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=3/TUpESOFMiIecNRcH48chaK6zVBZGJlr46X+upUebA=; b=ORIeczxG6jbTmSEAuNEG1JdrR
        xGoiTu7oGesBibfvig3oGF/eDxko88zQN52GBNVNFyzH/LgbCNH5qlaS69+llTaJD2rTIwzASf9US
        UK3zl9y5TBYF31nbpMxSomHFgmJazlF02ICFaFTamhXN4wI4bRmdnbcgibxXm3TqLyywpDdkjRyY9
        bkGCE3zuY3Zar5eR9uiiCPSMzZjwhT+mgRfrKTwFbH0qVG0ck78s/YSEJfHmYzApX7zxBpNmdZEtI
        jFRsdcjUxCqyn8ebdImG5vBccCYanY0+lbY97AH218dHtdUtqDYX2PtCqJH3tJXPa1h1LtixSgNt2
        IkiPojVMA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:41152)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1l9Qfb-0003J3-5t; Tue, 09 Feb 2021 10:55:00 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1l9QfX-0003zQ-Vc; Tue, 09 Feb 2021 10:54:55 +0000
Date:   Tue, 9 Feb 2021 10:54:55 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Serge Semin <Sergey.Semin@baikalelectronics.ru>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Serge Semin <fancer.lancer@gmail.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Joao Pinto <Joao.Pinto@synopsys.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Alexey Malahov <Alexey.Malahov@baikalelectronics.ru>,
        Pavel Parkhomenko <Pavel.Parkhomenko@baikalelectronics.ru>,
        Vyacheslav Mitrofanov 
        <Vyacheslav.Mitrofanov@baikalelectronics.ru>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/20] net: phy: realtek: Fix events detection failure in
 LPI mode
Message-ID: <20210209105455.GO1463@shell.armlinux.org.uk>
References: <20210208140341.9271-1-Sergey.Semin@baikalelectronics.ru>
 <20210208140341.9271-2-Sergey.Semin@baikalelectronics.ru>
 <8300d9ca-b877-860f-a975-731d6d3a93a5@gmail.com>
 <20210209101528.3lf47ouaedfgq74n@mobilestation>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210209101528.3lf47ouaedfgq74n@mobilestation>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 09, 2021 at 01:15:28PM +0300, Serge Semin wrote:
> On Mon, Feb 08, 2021 at 09:14:02PM +0100, Heiner Kallweit wrote:
> > Nice analysis. Alternatively to duplicating this code piece we could
> > export mmd_phy_indirect(). But up to you.
> 
> I also considered creating a generic method to access the MMD
> registers of a generic PHY, something like phy_read()/phy_write(), but
> for MMD (alas just exporting mmd_phy_indirect() would not be enough).
> But as I see it such methods need to be created only after we get to
> have at least several places with duplicating direct MMD-read/write
> patterns. Doing that just for a single place seems redundant. Anyway it's
> up to maintainers to decide whether they want to see a generic part
> of the phy_read_mmd()/phy_write_mmd() methods being detached and
> exported as something like genphy_{read,write}_mmd() methods. I can do
> that in v2 if you ask me to.

Please not genphy_* - that namespace is used for up-to-1G PHYs.

I thought about suggesting what you are proposing, but the problem is
this is just making things less and less efficient. Every time we
break a function up and export it, we increase the execution overhead
of the code. That said, the PHY accesses are relatively slow.

My opinion is that as this is just a single location at the moment,
it is not worth the effort - but if we get more of examples of this,
then it makes sense to provide the common accessor.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
