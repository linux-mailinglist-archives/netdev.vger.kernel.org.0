Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2AEF2F090F
	for <lists+netdev@lfdr.de>; Sun, 10 Jan 2021 19:36:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726906AbhAJSeO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Jan 2021 13:34:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726748AbhAJSeN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Jan 2021 13:34:13 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48BF5C061786;
        Sun, 10 Jan 2021 10:33:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=Z8Z9C1kjMOhCuaq0XM5mBpvsFD/f2hhtu6hYbA5wArU=; b=KjosWBvj7guLV+U4ZU9zEhVkN
        sIIsmsbDtEHDTfRY9lRGNGsySp1flI0d/Mr+R81WjS0dsnmV63KAotKNQCNGfUH7meqjh0Bv4Hu5h
        tY3Dm8eN78REiXg1tkGweKOchWk1+y4HxPRASp7KN1fV+wKOj1XDymSNVqQGbZib3z5UhuJPeHV2+
        kkP7+LjKcHAEH8xlDriYuIG3013AewV0K4aohFPKx1JAkAWzfBkigpTp4y7nkCteP088rou7dauhN
        3MVDCE20Jm0A9cuRFvmM0/epwbnqMYNvBF750Nmyk0tFuDwa2F2pb0dmRBt79lU0G3eMCD1CcHv3J
        wXyNeHOdw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:46268)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1kyfWt-00066x-FB; Sun, 10 Jan 2021 18:33:31 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1kyfWs-0004R1-Ml; Sun, 10 Jan 2021 18:33:30 +0000
Date:   Sun, 10 Jan 2021 18:33:30 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Stefan Chulski <stefanc@marvell.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "thomas.petazzoni@bootlin.com" <thomas.petazzoni@bootlin.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Nadav Haklai <nadavh@marvell.com>,
        Yan Markman <ymarkman@marvell.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "mw@semihalf.com" <mw@semihalf.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "atenart@kernel.org" <atenart@kernel.org>
Subject: Re: [EXT] Re: [PATCH RFC net-next  14/19] net: mvpp2: add ethtool
 flow control configuration support
Message-ID: <20210110183330.GN1551@shell.armlinux.org.uk>
References: <1610292623-15564-1-git-send-email-stefanc@marvell.com>
 <1610292623-15564-15-git-send-email-stefanc@marvell.com>
 <20210110181519.GJ1551@shell.armlinux.org.uk>
 <CO6PR18MB3873D0FCB65F1E3879002D15B0AC9@CO6PR18MB3873.namprd18.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CO6PR18MB3873D0FCB65F1E3879002D15B0AC9@CO6PR18MB3873.namprd18.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 10, 2021 at 06:27:57PM +0000, Stefan Chulski wrote:
> > What also concerns me is whether flow control is supported in the existing
> > driver at all, given this patch set. If it isn't supported without the firmware's
> > help, then we should _not_ be negotiating flow control with the link partner
> > unless we actually support it, so the Pause and Asym_Pause bits in
> > mvpp2_phylink_validate() should be cleared.
> 
> RX FC supported, issue only with TX FC.

That doesn't seem relevant given table 28B in IEEE 802.3. There is
no advertisement combination that allows one to advertise an ability
to receive FC frames but not transmit FC frames.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
