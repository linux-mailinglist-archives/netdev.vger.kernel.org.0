Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B630557F582
	for <lists+netdev@lfdr.de>; Sun, 24 Jul 2022 16:40:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229578AbiGXOkC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Jul 2022 10:40:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229494AbiGXOkB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Jul 2022 10:40:01 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6850A60C9
        for <netdev@vger.kernel.org>; Sun, 24 Jul 2022 07:39:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=QiTBVEBlRWHVk7S2SUqitXtGBkDFw4DSp4R3tX2RIuc=; b=PMs35mVCJxbC7Tn7eCdA7nvCNl
        W+1bsB/cxppGH4YgMJcWD5X8GyL9kj6iv5m1OZ/48VnYWwzvI6SqULWlOH5iBJY0E3ZrG8ubXTJm1
        rtPXXO7Ts5j1jsbfuoUxcNkbX8QilEGtJQS94y+BzFTgng8KXAxNbgVGX7lqsUk2LkL4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oFclo-00BMiD-Rr; Sun, 24 Jul 2022 16:39:48 +0200
Date:   Sun, 24 Jul 2022 16:39:48 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Christian Marangi <ansuelsmth@gmail.com>,
        John Crispin <john@phrozen.org>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Mans Rullgard <mans@mansr.com>,
        Arun Ramadoss <arun.ramadoss@microchip.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        George McCollister <george.mccollister@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Aleksander Jan Bajkowski <olek2@wp.pl>,
        Alvin =?utf-8?Q?=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Pawel Dembicki <paweldembicki@gmail.com>,
        =?iso-8859-1?Q?Cl=E9ment_L=E9ger?= <clement.leger@bootlin.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Russell King <rmk+kernel@armlinux.org.uk>
Subject: Re: [PATCH net-next] net: dsa: validate that DT nodes of shared
 ports have the properties they need
Message-ID: <Yt1ZtD7nxZ5SIkx8@lunn.ch>
References: <20220723164635.1621911-1-vladimir.oltean@nxp.com>
 <Ytw5XrDYa4FQF+Uk@lunn.ch>
 <20220724142158.dsj7yytiwk7welcp@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220724142158.dsj7yytiwk7welcp@skbuf>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jul 24, 2022 at 02:21:59PM +0000, Vladimir Oltean wrote:
> On Sat, Jul 23, 2022 at 08:09:34PM +0200, Andrew Lunn wrote:
> > Hi Vladimir
> > 
> > I think this is a first good step.
> > 
> > > +static const char * const dsa_switches_skipping_validation[] = {
> > 
> > One thing to consider is do we want to go one step further and make
> > this dsa_switches_dont_enforce_validation
> > 
> > Meaning always run the validation, and report what is not valid, but
> > don't enforce with an -EINVAL for switches on the list?
> 
> Can do. The question is what are our prospects of eventually getting rid
> of incompletely specified DT blobs. If they're likely to stay around
> forever, maybe printing with dev_err() doesn't sound like such a great
> idea?
 
That is a question we need to ask ourselves. Do we want to continue to
live with this unhappy situation, or do we want to try to spend some
time to make it better. I _think_ i can produce reasonably safe
patches for mv88e6xxx DT descriptions in mainline. Maybe once that is
done, we can have the mv88e6xxx compatibles warn but don't error out,
so encouraging out of tree blobs to be updated. And unlike bcm_sf2,
i've not heard of boards where the blob cannot be update.

     Andrew
