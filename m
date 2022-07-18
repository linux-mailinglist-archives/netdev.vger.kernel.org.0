Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67EB5578A70
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 21:15:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234906AbiGRTPN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 15:15:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234131AbiGRTPM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 15:15:12 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49AB62CCB6;
        Mon, 18 Jul 2022 12:15:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=G1YSdmImKh2l18ecQ7FfzX2zqvO0awAs2ffUiZkZuSw=; b=uTS4R1PCUCCnZ83svGKLX53ve1
        C/11IYua0pNPYugrPmbYoaikCsT12yW4BX/nS2o/OIcmkTQ7YLxqjvT6DLGa7hcqDYn1CIa+6TM6V
        7AsENwcdlfZnZ4c1RnhUoU2FfYom1Hqbu1cr4JDB+3UAx7XXI0FS/tX8+wBd5t2wHGqW3jfEgRVgI
        7nSahUr1d3h85yXh39YKLE5eLCPi9vcmNFpG5bw805uyFH/yx+Xl1BMFHNl6AQGMiOhzgZ9kDxlhJ
        oZP0mArmGJuCwOsFPAa+F8EMGsEd/RKGb3+2bvQLeMiMg1HmhDsdOzsdhQok/+fEzmkU/ZBRvIYWF
        2kEnXPCA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:33434)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1oDWCq-000232-Ra; Mon, 18 Jul 2022 20:15:00 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1oDWCo-0002DB-Tm; Mon, 18 Jul 2022 20:14:58 +0100
Date:   Mon, 18 Jul 2022 20:14:58 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Alvin __ipraga <alsi@bang-olufsen.dk>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Daniel Scally <djrscally@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        DENG Qingfang <dqfext@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        George McCollister <george.mccollister@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Sean Wang <sean.wang@mediatek.com>,
        UNGLinuxDriver@microchip.com,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Subject: Re: [PATCH net-next 2/6] software node: allow named software node to
 be created
Message-ID: <YtWxMrz3LcVQa43I@shell.armlinux.org.uk>
References: <YtGPO5SkMZfN8b/s@shell.armlinux.org.uk>
 <E1oCNky-006e3g-KA@rmk-PC.armlinux.org.uk>
 <YtHGwz4v7VWKhIXG@smile.fi.intel.com>
 <20220715201715.foea4rifegmnti46@skbuf>
 <YtHPJNpcN4vNfgT6@smile.fi.intel.com>
 <20220715204841.pwhvnue2atrkc2fx@skbuf>
 <YtVSQI5VHtCOTCHc@smile.fi.intel.com>
 <YtVfppMtW77ICyC5@shell.armlinux.org.uk>
 <YtWp3WkpCtfe559l@smile.fi.intel.com>
 <YtWsM1nr2GZWDiEN@smile.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YtWsM1nr2GZWDiEN@smile.fi.intel.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 18, 2022 at 09:53:39PM +0300, Andy Shevchenko wrote:
> On Mon, Jul 18, 2022 at 09:43:42PM +0300, Andy Shevchenko wrote:
> > On Mon, Jul 18, 2022 at 02:27:02PM +0100, Russell King (Oracle) wrote:
> > > On Mon, Jul 18, 2022 at 03:29:52PM +0300, Andy Shevchenko wrote:
> > > > On Fri, Jul 15, 2022 at 11:48:41PM +0300, Vladimir Oltean wrote:
> > > > > So won't kobject_init_and_add() fail on namespace collision? Is it the
> > > > > problem that it's going to fail, or that it's not trivial to statically
> > > > > determine whether it'll fail?
> > > > > 
> > > > > Sorry, but I don't see something actionable about this.
> > > > 
> > > > I'm talking about validation before a runtime. But if you think that is fine,
> > > > let's fail it at runtime, okay, and consume more backtraces in the future.
> > > 
> > > Is there any sane way to do validation of this namespace before
> > > runtime?
> > 
> > For statically compiled, I think we can do it (to some extent).
> > Currently only three drivers, if I'm not mistaken, define software nodes with
> > names. It's easy to check that their node names are unique.
> > 
> > When you allow such an API then we might have tracebacks (from sysfs) bout name
> > collisions. Not that is something new to kernel (we have seen many of a kind),
> > but I prefer, if possible, to validate this before sysfs issues a traceback.
> > 
> > > The problem in this instance is we need a node named "fixed-link" that
> > > is attached to the parent node as that is defined in the binding doc,
> > > and we're creating swnodes to provide software generated nodes for
> > > this binding.
> > 
> > And how you guarantee that it will be only a single one with unique pathname?
> > 
> > For example, you have two DSA cards (or whatever it's called) in the SMP system,
> > it mean that there is non-zero probability of coexisting swnodes for them.
> > 
> > > There could be several such nodes scattered around, but in this
> > > instance they are very short-lived before they are destroyed, they
> > > don't even need to be published to userspace (and its probably a waste
> > > of CPU cycles for them to be published there.)
> > > 
> > > So, for this specific case, is this the best approach, or is there
> > > some better way to achieve what we need here?
> > 
> > Honestly, I don't know.
> > 
> > The "workaround" (but it looks to me rather a hack) is to create unique swnode
> > and make fixed-link as a child of it.
> > 
> > Or entire concept of the root swnodes (when name is provided) should be
> > reconsidered, so somehow we will have a uniqueness so that the entire
> > path(s) behind it will be caller-dependent. But this I also don't like.
> > 
> > Maybe Heikki, Sakari, Rafael can share their thoughts...
> > 
> > Just for my learning, why PHY uses "fixed-link" instead of relying on a
> > (firmware) graph? It might be the actual solution to your problem.
> > 
> > How graphs are used with swnodes, you may look into IPU3 (Intel Camera)
> > glue driver to support devices before MIPI standardisation of the
> > respective properties.
> 
> Forgot to say (yes, it maybe obvious) that this API will be exported,
> anyone can use it and trap into the similar issue, because, for example,
> of testing in environment with a single instance of the caller.

I think we're coming to the conclusion that using swnodes is not the
correct approach for this problem, correct?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
