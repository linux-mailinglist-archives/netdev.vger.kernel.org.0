Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F216231887A
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 11:48:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230130AbhBKKn2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 05:43:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230139AbhBKKkn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 05:40:43 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40D44C061574;
        Thu, 11 Feb 2021 02:40:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=KqKL6U54aCC0e44bsyZEz0rjpqJM8TsWEFnpO14j4I0=; b=V/XKeJOwhiGwwPrOF/Ejk+2gU
        RUlWQlS7edN8olo8oHfkWd7OfyKxmdav9/717Ou8/3rJweQCj8FWraj7NC3ofElWgR/b4oP6+WMMr
        9a6hKi+G955sI6tWlouZKrxpPC8XUR76WOdOJ7GzpQMLIZYAq9QhR4Gft4GC+SCGyDO92arJJlhSf
        SYq2lujQBwQBLKiUqZjSmC/AE+yGH2LlB7IswQNlqGwT0933GByZGtJxQcwhaQzqPW/Zf7zRfBtxv
        Q+LGWnwyD68v1Wb0WX2gCJT+wrc9HRham/g+Z5QSbb4v99b9BTVrItcQ+y1GLxpsijl5mnPkx+Ci8
        gF9YWi+SQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:41972)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1lA9Nz-0005vP-Cw; Thu, 11 Feb 2021 10:39:47 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1lA9Nt-00060X-RR; Thu, 11 Feb 2021 10:39:41 +0000
Date:   Thu, 11 Feb 2021 10:39:41 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Serge Semin <Sergey.Semin@baikalelectronics.ru>
Cc:     Serge Semin <fancer.lancer@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Joao Pinto <Joao.Pinto@synopsys.com>,
        linux-kernel@vger.kernel.org,
        Alexandre Torgue <alexandre.torgue@st.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        Alexey Malahov <Alexey.Malahov@baikalelectronics.ru>,
        Jose Abreu <joabreu@synopsys.com>,
        Pavel Parkhomenko <Pavel.Parkhomenko@baikalelectronics.ru>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Vyacheslav Mitrofanov 
        <Vyacheslav.Mitrofanov@baikalelectronics.ru>,
        "David S. Miller" <davem@davemloft.net>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 01/20] net: phy: realtek: Fix events detection failure in
 LPI mode
Message-ID: <20210211103941.GW1463@shell.armlinux.org.uk>
References: <20210208140341.9271-1-Sergey.Semin@baikalelectronics.ru>
 <20210208140341.9271-2-Sergey.Semin@baikalelectronics.ru>
 <8300d9ca-b877-860f-a975-731d6d3a93a5@gmail.com>
 <20210209101528.3lf47ouaedfgq74n@mobilestation>
 <a652c69b-94d3-9dc6-c529-1ebc0ed407ac@gmail.com>
 <20210209105646.GP1463@shell.armlinux.org.uk>
 <20210210164720.migzigazyqsuxwc6@mobilestation>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210210164720.migzigazyqsuxwc6@mobilestation>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 10, 2021 at 07:47:20PM +0300, Serge Semin wrote:
> On Tue, Feb 09, 2021 at 10:56:46AM +0000, Russell King - ARM Linux admin wrote:
> > On Tue, Feb 09, 2021 at 11:37:29AM +0100, Heiner Kallweit wrote:
> > > Right, adding something like a genphy_{read,write}_mmd() doesn't make
> > > too much sense for now. What I meant is just exporting mmd_phy_indirect().
> > > Then you don't have to open-code the first three steps of a mmd read/write.
> > > And it requires no additional code in phylib.
> > 
> > ... but at the cost that the compiler can no longer inline that code,
> > as I mentioned in my previous reply. (However, the cost of the accesses
> > will be higher.) On the plus side, less I-cache footprint, and smaller
> > kernel code.
> 
> Just to note mmd_phy_indirect() isn't defined with inline specifier,
> but just as static and it's used twice in the
> drivers/net/phy/phy-core.c unit. So most likely the compiler won't
> inline the function code in there.

You can't always tell whether the compiler will inline a static function
or not.

> Anyway it's up to the PHY
> library maintainers to decide. Please settle the issue with Heiner and
> Andrew then. I am ok with both solutions and will do as you decide.

FYI, *I* am one of the phylib maintainers.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
