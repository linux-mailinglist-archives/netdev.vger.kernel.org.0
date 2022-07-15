Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6916357689E
	for <lists+netdev@lfdr.de>; Fri, 15 Jul 2022 23:00:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229872AbiGOVAE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 17:00:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbiGOVAD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 17:00:03 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D33612A93;
        Fri, 15 Jul 2022 14:00:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=FjCH/n3lVoEPHgozxLLQnFJq01zsIEBs6rSRAl4LUfo=; b=WKKiz+z+1GNbNjlQjPRlLiGJqL
        FRDF66ZCOy07pHFlDyDftMKkHY1TYvDf2YWOE73hwFjsEQrSXgb1jjocCl6lvN9RG1mVbSnkGcNQv
        kVZL3n+Yr9XcI4QbsFT8pg6sFegjsaIEV0Ng39sfdacMW4lfkrgJXiBIUFIacBPA3FFDGyz0psHw+
        QAgsOUeTKG6y+2l7v8TIaAgb918RWnug/5T08to1WUlI656wOtIO7E+mVq2+5IVCDG6nUZLaN0gl4
        4ny0S9u1tzZ8Tj+2ltJaZFEJpoo9irlaWvETMo74SbVnBVNdMdPzj9ILxNF5wj0NzryMheVImKXjp
        8PVabpMg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:33364)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1oCSPK-0007WX-2a; Fri, 15 Jul 2022 21:59:30 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1oCSPE-0007rY-3L; Fri, 15 Jul 2022 21:59:24 +0100
Date:   Fri, 15 Jul 2022 21:59:24 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Alvin =?utf-8?Q?=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
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
        Marek =?us-ascii?B?PT9pc28tODg1OS0xP1E/QmVoPUZBbj89?= 
        <kabel@kernel.org>, Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Sean Wang <sean.wang@mediatek.com>,
        UNGLinuxDriver@microchip.com,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Woojung Huh <woojung.huh@microchip.com>
Subject: Re: [PATCH net-next 0/6] net: dsa: always use phylink
Message-ID: <YtHVLGR0RQ6dWuBS@shell.armlinux.org.uk>
References: <YtGPO5SkMZfN8b/s@shell.armlinux.org.uk>
 <20220715171719.niqcrklpk4ittfvl@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220715171719.niqcrklpk4ittfvl@skbuf>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 15, 2022 at 08:17:19PM +0300, Vladimir Oltean wrote:
> Hi Russell,
> 
> On Fri, Jul 15, 2022 at 05:00:59PM +0100, Russell King (Oracle) wrote:
> > Hi,
> > 
> > This is a re-hash of the previous RFC series, this time using the
> > suggestion from Vladimir to create a swnode based fixed-link
> > specifier.
> > 
> > Most of the changes are to DSA and phylink code from the previous
> > series. I've tested on my Clearfog (which has just one Marvell DSA
> > switch) and it works there - also tested without the fixed-link
> > specified in DT.
> 
> I had some comments I wanted to leave on the previous RFC patch set
> (which in turn is essentially identical to this one, hence they still
> apply), but I held off because I thought you were waiting for some
> feedback from Andrew. Has something changed?

I've got fed up of waiting for very little feedback on patches I send.
Jakub was fully prepared to apply my v2 RFC patches after - as he saw
it - everyone that was likely to respond had responded.

The only thing that delayed them was your eventual comments about
re-working how it was being done. Yet again, posting the RFC series
created very little in the way of feedback. I'm getting to the point
of thinking its a waste of time posting RFC patches - it's counter
productive. RFC means "request for comments" but it seems that many
interpret it as "I can ignore it".

So, I'm saying sod it now. I'm posting patches that I create without
RFC tags. That means reviewers need to be on the ball if they want to
comment _before_ they get merged into net-next. Posting RFC is a total
waste of time, IMHO.

You've proven it as well with some of your comments on this series,
which I'll address in a separate reply.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
