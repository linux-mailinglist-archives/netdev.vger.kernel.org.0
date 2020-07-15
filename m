Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D274822131C
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 19:03:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726670AbgGORC7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 13:02:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725798AbgGORC6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 13:02:58 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8704CC061755
        for <netdev@vger.kernel.org>; Wed, 15 Jul 2020 10:02:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=a2CRZXPeJvwwZak9RXKz3QEP0FS12tt7oHoepp2RUsA=; b=uSt71JaMRHCsBlCVNIdmAGmHk
        hUsGVzr9rvbgcXCDCcgqdHVSGA+Otf0xf6xzc9+f+1LHvE4cfLrcl1FyGQlodk9UaLv5dWwJIcPE2
        C2BvzXKzunbPLp5rdG88xeFtmbnprsKBSld/OcLY+hW0d+FwNpG+VFRnetQXDt27HWwbWOM3BT049
        WOjwLu3NBriEitKQI3Oz6JuKQ3m1JZBxGTEsyx1UIpnRk9pOoWQ2MUNXdRfYF2gu3wTOcIr33Z3zF
        19L/O382q1kmbgKKeJi/GMJu1dVJQIdIiP0j2cKb338dSd4J4MxTm9cUF/MF/23e7Ro8P+5X0GEjY
        0pLWxPnFQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:39892)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jvknx-0006wM-Kz; Wed, 15 Jul 2020 18:02:49 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jvknt-0008Sl-IH; Wed, 15 Jul 2020 18:02:45 +0100
Date:   Wed, 15 Jul 2020 18:02:45 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "michael@walle.cc" <michael@walle.cc>, netdev@vger.kernel.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH RFC net-next 00/13] Phylink PCS updates
Message-ID: <20200715170245.GH1551@shell.armlinux.org.uk>
References: <20200630142754.GC1551@shell.armlinux.org.uk>
 <20200714084958.to4n52cnk32prn4v@skbuf>
 <20200714131832.GC1551@shell.armlinux.org.uk>
 <20200714234652.w2pw3osynbuqw3m4@skbuf>
 <20200715112100.GG1551@shell.armlinux.org.uk>
 <20200715113441.GR1605@shell.armlinux.org.uk>
 <20200715123153.vvvnx6rwgzl5ejuo@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200715123153.vvvnx6rwgzl5ejuo@skbuf>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 15, 2020 at 03:31:53PM +0300, Vladimir Oltean wrote:
> On Wed, Jul 15, 2020 at 12:21:01PM +0100, Russell King - ARM Linux admin wrote:
> > On Wed, Jul 15, 2020 at 02:46:52AM +0300, Vladimir Oltean wrote:
> > > By this I think you are aiming squarely at "[PATCH net-next v3 0/9] net:
> > > ethernet backplane support on DPAA1". If I understand you correctly, you
> > > are saying that because of the non-phylink models used to represent that
> > > system comprised of a clause 49 PCS + clause 72 PMD + clause 73 AN/LT,
> > > it is not worth pursuing this phylink-based representation of a clause
> > > 37 PCS.
> > 
> > Actually, that is not what I was aiming that comment at - that is not
> > something that has been posted recently.  I'm not going to explicitly
> > point at a patch set.
> > 
> 
> You are making it unnecessarily difficult to have a meaningful
> conversation.

Sorry, but no, I really don't have time to spend hours writing endless
replies to you explaining in great detail about every minute issue.
I spent an hour and a half on that email, and quite frankly, you've
used your quota of my time for today.

Life is already difficult enough during this time of Covid 19, I
really do not need extra pressure from people who need minute detail
in every email.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
