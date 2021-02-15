Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D946631BF26
	for <lists+netdev@lfdr.de>; Mon, 15 Feb 2021 17:27:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231579AbhBOQ0y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Feb 2021 11:26:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232125AbhBOQYq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Feb 2021 11:24:46 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F0CFC061788
        for <netdev@vger.kernel.org>; Mon, 15 Feb 2021 08:24:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=HNITFIjqLM8jJw6WhUn1Zo+GKkWd2Nf8YoWxOm87kg4=; b=fmKYyEfHdCnP/0jpyQ0ZlcQNB
        zqwbOeW8R76PUffgHMSP49wY6K7wTYO2zHGaUhoAFdV9Iyk0GOMCedAierKD8pNKl/uArLHiGGu13
        WZWl1xAXkIdJaLA0sxbtrjd+p6g2TxiGJCZrYRRhYrLneZOrSECZmrHN9xfE3u621sqb65+Wbs4+z
        ozZVYTJWfPGcwymjJ+O0TQBrJErODs/0Gx1TxCrqUSdssuUqRsoMm3hclXyc3Tm15bCqYh9WBgAhb
        kQo1+Y9Amx/udRwNEeCygalFLpZUwu2+fX8sIAl7AjOhTeZx9i1i3G6eKJe/yY28xUPKBcDqMvHo7
        XnpRi9C2g==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:43772)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1lBgfL-0001Dj-AS; Mon, 15 Feb 2021 16:24:03 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1lBgfK-0001py-Cq; Mon, 15 Feb 2021 16:24:02 +0000
Date:   Mon, 15 Feb 2021 16:24:02 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Stefan Chulski <stefanc@marvell.com>, Andrew Lunn <andrew@lunn.ch>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Marcin Wojtas (mw@semihalf.com)" <mw@semihalf.com>,
        Nadav Haklai <nadavh@marvell.com>,
        Yan Markman <ymarkman@marvell.com>
Subject: Re: [EXT] Re: Phylink flow control support on ports with
 MLO_AN_FIXED auto negotiation
Message-ID: <20210215162402.GZ1463@shell.armlinux.org.uk>
References: <CO6PR18MB38732F56EF08FA2C949326F9B0B79@CO6PR18MB3873.namprd18.prod.outlook.com>
 <20210131103549.GA1463@shell.armlinux.org.uk>
 <CO6PR18MB3873D6F519D1B4112AA77671B0B79@CO6PR18MB3873.namprd18.prod.outlook.com>
 <20210131111214.GB1463@shell.armlinux.org.uk>
 <20210131121950.GA1477@shell.armlinux.org.uk>
 <20210213113947.GD1477@shell.armlinux.org.uk>
 <CO6PR18MB38732FD9F40B8956B019F719B0889@CO6PR18MB3873.namprd18.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CO6PR18MB38732FD9F40B8956B019F719B0889@CO6PR18MB3873.namprd18.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 15, 2021 at 04:19:19PM +0000, Stefan Chulski wrote:
> > > > I discussed it with Andrew earlier last year, and his response was:
> > > >
> > > >  DT configuration of pause for fixed link probably is sufficient. I
> > > > don't  remember it ever been really discussed for DSA. It was a
> > > > Melanox  discussion about limiting pause for the CPU. So I think it
> > > > is safe to  not implement ethtool -A, at least until somebody has a
> > > > real use case  for it.
> > > >
> > > > So I chose not to support it - no point supporting features that
> > > > people aren't using. If you have a "real use case" then it can be added.
> > >
> > > This patch may be sufficient - I haven't fully considered all the
> > > implications of changing this though.
> > 
> > Did you try this patch? What's the outcome?
> 
> For me patch worked as expected.

Great, thanks. Andrew, do you have any further opinions on this
subject, or shall I sent a proper patch for net-next?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
