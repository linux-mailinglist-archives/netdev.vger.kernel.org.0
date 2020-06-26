Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F71A20B090
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 13:32:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728684AbgFZLcW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 07:32:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725864AbgFZLcT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 07:32:19 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0314C08C5C1
        for <netdev@vger.kernel.org>; Fri, 26 Jun 2020 04:32:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=1tXoJHKyXc3I2vl/OwJhd/EUmw8jK/5qS95V+mKLFxg=; b=sMFZcqT+U2DUeW5ayh5dDKfHn
        dye95/GHk1VEBgGa11xt/Q2ueJyYn5EuL8sg07cDntgS8Smew5Rsw/LK/iFkd5M1mGQUhoCWOCYrT
        RwWjvodh2AQIGy9ZP2qUPxJZHShdVGK4zyfJLUyIDg8dPklzFtDmjAcl3NqpEOGw7HnzRg+7YetUP
        ZhdSdXLZRzpVaFdy36FwP3nwHW0+9HLGfECz60OrWaICn93OK9vgmesHqSP/jlxnR4+AhOi2U6evP
        Sp3xGZs5uJROJcQ5yi4TpjxvGbM7iuR6B9SDRTmYbkhyYLPM2UUlLgbjeaPWpc0PABBWKfJ/Rva9D
        M8nWnh/Sg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:60002)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jomaf-0005FK-8s; Fri, 26 Jun 2020 12:32:17 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jomae-000421-MF; Fri, 26 Jun 2020 12:32:16 +0100
Date:   Fri, 26 Jun 2020 12:32:16 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: Re: [PATCH net-next 5/7] net: dsa: felix: delete
 .phylink_mac_an_restart code
Message-ID: <20200626113216.GP1551@shell.armlinux.org.uk>
References: <20200625152331.3784018-1-olteanv@gmail.com>
 <20200625152331.3784018-6-olteanv@gmail.com>
 <20200625165349.GI1551@shell.armlinux.org.uk>
 <CA+h21hqn0P6mVJd1o=P1qwmVw-E56-FbY0gkfq9KurkRuJ5_hQ@mail.gmail.com>
 <20200626110828.GO1551@shell.armlinux.org.uk>
 <CA+h21hoDVQfeVZJaSJ1BymVcATgJq5zoHo2_K7JnG2V22RKe5A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+h21hoDVQfeVZJaSJ1BymVcATgJq5zoHo2_K7JnG2V22RKe5A@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 26, 2020 at 02:19:42PM +0300, Vladimir Oltean wrote:
> On Fri, 26 Jun 2020 at 14:08, Russell King - ARM Linux admin
> <linux@armlinux.org.uk> wrote:
> >
> 
> [snip]
> 
> >
> > So, I ask again, what practical use and benefit does restarting the
> > configuration exchange on a SGMII or USXGMII link have?  Give me a real
> > life use case where there's a problem with a link that this can solve.
> >
> 
> You are pushing the discussion in an area that to me is pretty
> insignificant, and where I did _not_ want to go. I said:
> 
> > This is
> > probably OK, I can't come up with a situation where it might be useful for the
> > MAC PCS to clear its cache of link state and ask for a new tx_config_reg. So
> > remove this code.
> 
> I was going to remove this code in the first place, it's just that you
> didn't like the justification in the initial commit message. Fine. So
> I asked you if this new commit message is OK. You said:
> 
> > This is going over the top
> 
> So let's cut this short: we agree about everything now, hardware
> behavior and software behavior. Could you edit my commit message in a
> way that you agree with, and paste it here so that I could include it
> in v2?

No.  Too busy.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
