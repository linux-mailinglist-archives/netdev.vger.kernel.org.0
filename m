Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 997B9516232
	for <lists+netdev@lfdr.de>; Sun,  1 May 2022 08:22:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240841AbiEAGZv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 May 2022 02:25:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231721AbiEAGZs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 May 2022 02:25:48 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85DD650464;
        Sat, 30 Apr 2022 23:22:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=3+qzA7PHMmDHNHuNIiXNUOUy8rzwaRd3MaO7YujuXCQ=; b=xXWvZRUz+UeJyVHlrRbK9vEEWU
        kc13z1UURFsemmhkm8BX2rGCOM6oSATTMIpaHZkI0Clvngr4KK9i0rMgFKxoy+8CjVUVp3CNvGtUO
        koMDmQsRLXiXKAxNVVjGlD0sk0A7biSGGwTs3dcmWh8ivQkfXXh3mxHnpJXaxnfCmgZMGUeFWVMVN
        T+/OKD2uj9nKchkGTuBuevzcr8ph2nfMCtvB7A0vobMrOVwsEq1qIxfJvpt45TIMu9I8/Vs/HKbeH
        gb09Y8J9r/CtQcN56LflJToxs3TxQhnYdpUk1/H3POiJ3/BZH2m7oReSWZLRelFIC+Rv3g6d9vbuO
        o0yR0hgw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:58468)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1nl2yF-0005yo-0i; Sun, 01 May 2022 07:22:14 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1nl2yC-0003fG-Os; Sun, 01 May 2022 07:22:12 +0100
Date:   Sun, 1 May 2022 07:22:12 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Peter Geis <pgwipeout@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1] net: phy: fix motorcomm module automatic loading
Message-ID: <Ym4nFLqOsozrb+HM@shell.armlinux.org.uk>
References: <20220228233057.1140817-1-pgwipeout@gmail.com>
 <Yh1lboz7VDiuYuZV@shell.armlinux.org.uk>
 <CAMdYzYrNvUUMom4W4uD9yf9LtFK1h5Xw+9GYc54hB5+iqVmJtw@mail.gmail.com>
 <CAMdYzYrFuMw4aj_9L698ZhL7Xqy8=NeXhy9HDz4ug-v3=f4fpw@mail.gmail.com>
 <Ym1bWHNj0p6L9lY8@lunn.ch>
 <CAMdYzYq41TndbJK-=ah31=vECisgRbPmtFYwOLQQ7yn4L=JVYw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMdYzYq41TndbJK-=ah31=vECisgRbPmtFYwOLQQ7yn4L=JVYw@mail.gmail.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 30, 2022 at 12:31:27PM -0400, Peter Geis wrote:
> On Sat, Apr 30, 2022 at 11:52 AM Andrew Lunn <andrew@lunn.ch> wrote:
> >
> > > Good Morning,
> > >
> > > After testing various configurations I found what is actually
> > > happening here. When libphy is built in but the phy drivers are
> > > modules and not available in the initrd, the generic phy driver binds
> > > here. This allows the phy to come up but it is not functional.
> >
> > What MAC are you using?
> 
> Specifically Motorcomm, but I've discovered it can happen with any of
> the phy drivers with the right kconfig.
> 
> >
> > Why is you interface being brought up by the initramfs? Are you using
> > NFS root from within the initramfs?
> 
> This was discovered with embedded programming. It's common to have a
> small initramfs, or forgo an initramfs altogether.

If you're talking about embedded, it makes more sense to have the PHY
drivers built-in. They will take up less text and data space that way.
Typically, PHY drivers have very small amounts of text and data, and
both of these end up being rounded up to a page size when loaded as a
module.

> Another cause is a
> mismatch in kernel config where phylib is built in because of a
> dependency, but the rest of the phy drivers are modular.
> The key is:
> - phylib is built in
> - ethernet driver is built in
> - the phy driver is a module
> - modules aren't available at probe time (for any reason).

This is why many ethernet drivers connect with their PHY in their
.ndo_open method, rather than at probe time.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
