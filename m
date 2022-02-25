Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA8C34C4449
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 13:08:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232284AbiBYMIk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 07:08:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229537AbiBYMIk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 07:08:40 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0875CD04B4
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 04:08:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:To:From:Date:Reply-To:Cc:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=wL3fwulFKu7Q36Fe0Acepx8AHZqe5Sog+xFeJ1u19Dk=; b=f1Fd1UqjLg8GKx2HvbfTtAWaO4
        EDf9UtlEqm94yRac1BMwFQQ0FmmgSTyCuLNZhAV6LbpyNJiD7u82lJ0KNFUVa0U0icoJNw62CdOfK
        9/UqmbLVHvvVsxvSXuLXc/U49nnXboQZFPrhC9nHz4KtJBGtw6ukhqKgRgRCpZqH3GE7o5YBc2xrL
        VUKZdTL2dGvcVA+tVORUXr7QvOgEgiXDVy9vZAJ167CNA9PwLPB/TOM9UEnDzpnzVp/KmLlq1WSY3
        i0fHGgCB3bB4Ldhvusp1x08u/OoEorktsdzrmDdxUcW6k2mQdE3gQTupGaaKlGIgBGAEmeSPT5wGs
        6CDHssSA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:57484)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1nNZOF-0005Kk-86; Fri, 25 Feb 2022 12:08:03 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1nNZOE-00032M-4z; Fri, 25 Feb 2022 12:08:02 +0000
Date:   Fri, 25 Feb 2022 12:08:02 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Vladimir Oltean <olteanv@gmail.com>,
        Marek Beh__n <kabel@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 1/6] net: dsa: sja1105: populate
 supported_interfaces
Message-ID: <YhjGolv59ZjDDr5I@shell.armlinux.org.uk>
References: <YhjDvsSC1gZAYF74@shell.armlinux.org.uk>
 <E1nNZCc-00Ab1Q-Kg@rmk-PC.armlinux.org.uk>
 <20220225115858.6hwi4e55fjkgqzs5@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220225115858.6hwi4e55fjkgqzs5@skbuf>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 25, 2022 at 01:58:58PM +0200, Vladimir Oltean wrote:
> On Fri, Feb 25, 2022 at 11:56:02AM +0000, Russell King (Oracle) wrote:
> > Populate the supported interfaces bitmap for the SJA1105 DSA switch.
> > 
> > This switch only supports a static model of configuration, so we
> > restrict the interface modes to the configured setting.
> > 
> > Reviewed-by: Vladimir Oltean <olteanv@gmail.com>                                Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> 
> These all appear on the same line, can you please fix and resend?

I hate vi/vim precisely because of this.

How this problem happens. I read the email in mutt under KDE's kconsole
with your attributation. I select the attributation so it can be pasted.
I edit the commit, which starts vi, move to the line containing my
sign-off, hit 'i' and paste it in.

The result is a line that _looks_ in vi as being entirely correct. The
next line follows on as if it is a separate line.

I save the commit message. When I look at it in "git log", again,
everything looks good.

The only times that it can be identified is after sending and looking
at it in mutt, and noticing that the Signed-off-by line appears to have
a# '+' prefix, indicating that mutt wrapped the line - or after it gets
merged into net-next when linux-next identifies the lack of s-o-b, by
which time it's too late to fix.

How do others avoid this problem? Not use vi/vim, but use some other
editor such as emacs or microemacs that doesn't have this crazy way of
dealing with multiple lines?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
