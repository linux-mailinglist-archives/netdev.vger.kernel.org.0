Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C119577E01
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 10:53:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233430AbiGRIxs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 04:53:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229711AbiGRIxq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 04:53:46 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8BCB323;
        Mon, 18 Jul 2022 01:53:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=ToUKRE4eNm6A2sNEpB2OgcNUP6tRu+NWWWVVE3lb698=; b=axll7zDzOI4zNYGcIznYOr22/b
        zZLBakwxRpaoKWTIi8Rs4mQFujP8xxWOnylDB8E0KizU/HcmQkqKn+oa4WBQW8DwXVaLTLJl9EU/s
        rA7wYM+lzml0of/QCDYlICeakokyYcNziX6hHNQ9mvlgsjbE1Od62xR1s7IMGEWgDx2pEJs680Vay
        YbvI7hIuvwse9JclVDvvD/GEnBhazCgZU7yjzxN/EABM/A28BJOsnGCXIMmkQqv/FDrwuOqX7sNr/
        ifPhRxlVjyPGjvCW7rYa9qSN8vqQBWn5rbLfYTH26/j500fZPrUk0xRhobryiga/kNPt/RWNB+uFP
        PiDXOnUA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:33400)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1oDMVK-0001Im-4Z; Mon, 18 Jul 2022 09:53:26 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1oDMVH-0001pv-28; Mon, 18 Jul 2022 09:53:23 +0100
Date:   Mon, 18 Jul 2022 09:53:23 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
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
        Kurt Kanzenbach <kurt@linutronix.de>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Sean Wang <sean.wang@mediatek.com>,
        UNGLinuxDriver@microchip.com,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Woojung Huh <woojung.huh@microchip.com>
Subject: Re: [PATCH net-next 0/6] net: dsa: always use phylink
Message-ID: <YtUfg+WYIYYi5J+q@shell.armlinux.org.uk>
References: <YtGPO5SkMZfN8b/s@shell.armlinux.org.uk>
 <20220715171719.niqcrklpk4ittfvl@skbuf>
 <YtHVLGR0RQ6dWuBS@shell.armlinux.org.uk>
 <20220715160359.2e9dabfe@kernel.org>
 <20220716111551.64rjruz4q4g5uzee@skbuf>
 <YtKkRLD74tqoeBuR@shell.armlinux.org.uk>
 <20220716131345.b2jas3rucsifli7g@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220716131345.b2jas3rucsifli7g@skbuf>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 16, 2022 at 04:13:45PM +0300, Vladimir Oltean wrote:
> On Sat, Jul 16, 2022 at 12:43:00PM +0100, Russell King (Oracle) wrote:
> > In the first RFC series I sent on the 24 June, I explicitly asked the
> > following questions:
> (...)
> > I even stated: "Please look at the patches and make suggestions on how
> > we can proceed to clean up this quirk of DSA." and made no mention of
> > wanting something explicitly from Andrew.
> > 
> > Yet, none of those questions were answered.
> > 
> > So no, Jakub's comments are *not* misdirected at all. Go back and read
> > my June 24th RFC series yourself:
> > 
> > https://lore.kernel.org/all/YrWi5oBFn7vR15BH@shell.armlinux.org.uk/
> 
> I don't believe I need to justify myself any further for why I didn't
> leave a comment on any certain day. I left my comments when I believed
> it was most appropriate for me to intervene (as someone who isn't really
> affected in any way by the changes, except for generally maintaining
> what's in net/dsa/, and wanting to keep a clean framework structure).
> Also, to repeat myself, blaming me for leaving comments, but doing so
> late, is not really fair. I could have not responded at all, and I
> wouldn't be having this unpleasant discussion. It begs the question
> whether you're willing to be held accountable in the same way for the
> dates on which you respond on RFC patches.
> 
> > I've *tried* my best to be kind and collaborative, but I've been
> > ignored. Now I'm hacked off. This could have been avoided by responding
> > to my explicit questions sooner, rather than at the -rc6/-rc7 stage of
> > the show.
> 
> I think you should continue to try your best to be kind and collaborative,
> you weren't provoked or intentionally ignored in any way, and it isn't
> doing these patches any good.

And yet again, I don't have answers to many of those questions... which
just shows how broken this process is, and how utterly pointless it is
0to ask any questions in this area.

My conclusion: you don't care one bit to even answer questions until
there's a chance that patches that you disagree with might be merged,
and oh my god, you've got to respond to stop that happening because you
might disagree with something. You can't do the collaborative thing and
respond when someone asks explicit questions about how things should be
done.

I'm not going to let this go. I'm really pissed off by this and you
are the focus of my frustration.

Well, its now too late to do anything about this. This is going to miss
this cycle. It might get in next cycle, and whoopy do, for a kernel
that's very likely to be a LTS. Given the lack of testing that sounds
like a complete and utter disaster. One that was entirely avoidable had
feedback been given EARLIER in this cycle.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
