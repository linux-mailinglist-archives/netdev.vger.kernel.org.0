Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD068578301
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 15:03:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234954AbiGRNDC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 09:03:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230394AbiGRNDB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 09:03:01 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52855959D;
        Mon, 18 Jul 2022 06:03:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=XidPYl11smFttKHJvFnl6SJFpfWwT+eJ4zfOs1kVy/I=; b=HNXSITYgKyS2AT0HBOFQpDpc2y
        fncTocyT8qTf99rm7secmA39Es5zp5dk5bOtD2FpAt6dSNye2wfD9Sx0wWJf8bmI57UYZwQO8hv2x
        InGWdUhlemAKoFxnkn8d4NkJZgOVHDDidU3ellLxWz+7X7ZdRrCKU7q18WHWVZdddQwZAN8UZSMAd
        ZBn7mSR9x+FRwd25C3PktQmfDrBwD5RN7PC8PC10+4z3GEWQr6yi6828qJZFZzE95Zt470WspVC2I
        wGtkFvCACLc9+zDxJR6eP8w6jOoRyj0mftTr5h20HTjRfl2OYhYAjrQU4qJaCrb+eWK8gSHMPTbFa
        qnBeHBNw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:33408)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1oDQOV-0001bG-Ds; Mon, 18 Jul 2022 14:02:39 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1oDQOP-0001yk-Eq; Mon, 18 Jul 2022 14:02:33 +0100
Date:   Mon, 18 Jul 2022 14:02:33 +0100
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
Message-ID: <YtVZ6VI1yvbgSYDg@shell.armlinux.org.uk>
References: <YtGPO5SkMZfN8b/s@shell.armlinux.org.uk>
 <20220715171719.niqcrklpk4ittfvl@skbuf>
 <YtHVLGR0RQ6dWuBS@shell.armlinux.org.uk>
 <20220715160359.2e9dabfe@kernel.org>
 <20220716111551.64rjruz4q4g5uzee@skbuf>
 <YtKkRLD74tqoeBuR@shell.armlinux.org.uk>
 <20220716131345.b2jas3rucsifli7g@skbuf>
 <YtUfg+WYIYYi5J+q@shell.armlinux.org.uk>
 <20220718124512.o3qxiwop7nzfjbfx@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220718124512.o3qxiwop7nzfjbfx@skbuf>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 18, 2022 at 03:45:12PM +0300, Vladimir Oltean wrote:
> On Mon, Jul 18, 2022 at 09:53:23AM +0100, Russell King (Oracle) wrote:
> > On Sat, Jul 16, 2022 at 04:13:45PM +0300, Vladimir Oltean wrote:
> > > On Sat, Jul 16, 2022 at 12:43:00PM +0100, Russell King (Oracle) wrote:
> > > > In the first RFC series I sent on the 24 June, I explicitly asked the
> > > > following questions:
> > > (...)
> > > > I even stated: "Please look at the patches and make suggestions on how
> > > > we can proceed to clean up this quirk of DSA." and made no mention of
> > > > wanting something explicitly from Andrew.
> > > > 
> > > > Yet, none of those questions were answered.
> > > > 
> > > > So no, Jakub's comments are *not* misdirected at all. Go back and read
> > > > my June 24th RFC series yourself:
> > > > 
> > > > https://lore.kernel.org/all/YrWi5oBFn7vR15BH@shell.armlinux.org.uk/
> > > 
> > > I don't believe I need to justify myself any further for why I didn't
> > > leave a comment on any certain day. I left my comments when I believed
> > > it was most appropriate for me to intervene (as someone who isn't really
> > > affected in any way by the changes, except for generally maintaining
> > > what's in net/dsa/, and wanting to keep a clean framework structure).
> > > Also, to repeat myself, blaming me for leaving comments, but doing so
> > > late, is not really fair. I could have not responded at all, and I
> > > wouldn't be having this unpleasant discussion. It begs the question
> > > whether you're willing to be held accountable in the same way for the
> > > dates on which you respond on RFC patches.
> > > 
> > > > I've *tried* my best to be kind and collaborative, but I've been
> > > > ignored. Now I'm hacked off. This could have been avoided by responding
> > > > to my explicit questions sooner, rather than at the -rc6/-rc7 stage of
> > > > the show.
> > > 
> > > I think you should continue to try your best to be kind and collaborative,
> > > you weren't provoked or intentionally ignored in any way, and it isn't
> > > doing these patches any good.
> > 
> > And yet again, I don't have answers to many of those questions... which
> > just shows how broken this process is, and how utterly pointless it is
> > 0to ask any questions in this area.
> > 
> > My conclusion: you don't care one bit to even answer questions until
> > there's a chance that patches that you disagree with might be merged,
> > and oh my god, you've got to respond to stop that happening because you
> > might disagree with something. You can't do the collaborative thing and
> > respond when someone asks explicit questions about how things should be
> > done.
> > 
> > I'm not going to let this go. I'm really pissed off by this and you
> > are the focus of my frustration.
> 
> The hypothesis that you put forward is that I'm sabotaging you by not
> responding to RFCs, then leaving comments when you submit the patches
> proper, just so that they're delayed because I don't agree with them;
> and that the process is broken because it allows me to do just that and
> get away with it (for fun, I assume?).
> 
> So first off, you sent the first RFC towards 2 people in To:, and 19
> people in Cc:. I was one of the people in Cc. You didn't ask *me* any
> explicit question. In fact, when you did, I responded within 5 hours:
> https://lore.kernel.org/linux-arm-kernel/20220707154303.236xaeape7isracw@skbuf/
> 
> Then, why did I not respond earlier to questions I had an opinion on?

In the second RFC, I stated:

"Some of the questions from the original RFC remain though, so I've
included that text below. I'm guessing as they remain unanswered that
no one has any opinions on them?"

Clearly, I was soliciting answers from _everyone_ who received this,
not just the two people in the To: header.

> Based on prior experience, anything I reply to you has a chance of
> inflaming you for reasons that are outside of my control, and the
> discussion derails and eventually ends with you saying that I'm being
> difficult and you're quitting for the day, week, month, kernel release
> cycle or what not. I'm not saying that's my fault or your fault in
> general, it's just a statistical observation based on past interactions,
> and it looks like this one is no different.
> 
> With regard to this topic, there was ample opportunity for the patch set
> to come to a resolve without my intervention, and I decided that the
> best way to maximize the chances of this discussion not going sideways
> is to not say anything at all, especially when I don't need to.
> Gradually, the opportunity for the patch set to resolve itself without
> my intervention diminished, and I started offering my feedback to the code.
> 
> It's perhaps necessary of me to not let this phrase of yours unaddressed,
> because it is subtly part of your argument that I'm just trying to delay
> your patches as part of a sabotage plot:
> 
> | The only thing that delayed them was your eventual comments about
> | re-working how it was being done.
> 
> Let's not forget that I did *not* request you to rework the implementation
> to use software nodes. I simply went with the code you originally proposed,
> explained why it is unnaturally structured in my view, asked you why you
> did not consider an alternative structure if you're not willing to make
> phylink absorb the logic, then you said you'd be happy to rework using
> software nodes.
> https://lore.kernel.org/netdev/20220707193753.2j67ni3or3bfkt6k@skbuf/

This is _not_ the issue I'm raising. I am complaining about the
"default_interface" issue that you've only piped up about, despite
(a) an explicit question having been asked about that approach, (b) it
appearing in not just one, not two, not three but four RFC series sent,
and only finally being raised when a non-RFC series was sent.

This whole debarcle could have been avoided with providing feedback at
an earlier stage, when I explicitly requested it _several_ times.

I will not be doing any further work on this - this can wait a few
kernel cycles, because quite honestly, I'm not going to try to submit
this for next cycle.

And I quite expect a repeat of this shit, with me struggling to get
comments on patches, being mostly ignored and then for comments to come
at the last minute when there's no reasonable time left in the cycle to
action them.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
