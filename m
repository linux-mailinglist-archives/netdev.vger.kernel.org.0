Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 230E166DF28
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 14:44:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230370AbjAQNoM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 08:44:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230422AbjAQNng (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 08:43:36 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14C5435263;
        Tue, 17 Jan 2023 05:43:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=VGaAWzb+vg166BG+ToU6thlaLyp9+9c0uKkVxaL39SY=; b=cA3LM7qrfWjstNkPnlBYUDMIhx
        A4XcQsXfVUvPdsDAQvolMZV/slYsq57uS/7bZUB09RPj2mV/+aN0XiESt93fonJiNj4Amo+F2FEl2
        25Nj07RrGnWCcFgq0x7gR4J5EB1fJ73o360iXZNgSXyGPHzppqksR9xbAobNrtjJKl0c=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pHmEx-002KGQ-95; Tue, 17 Jan 2023 14:43:03 +0100
Date:   Tue, 17 Jan 2023 14:43:03 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Pierluigi Passaro <pierluigi.p@variscite.com>
Cc:     Lars-Peter Clausen <lars@metafoo.de>,
        Pierluigi Passaro <pierluigi.passaro@gmail.com>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Eran Matityahu <eran.m@variscite.com>,
        Nate Drude <Nate.D@variscite.com>,
        Francesco Ferraro <francesco.f@variscite.com>
Subject: Re: [PATCH] net: mdio: force deassert MDIO reset signal
Message-ID: <Y8al5zE5zwu0CET5@lunn.ch>
References: <20230115161006.16431-1-pierluigi.p@variscite.com>
 <Y8QzI2VUY6//uBa/@lunn.ch>
 <f691f339-9e50-b968-01e1-1821a2f696e7@metafoo.de>
 <Y8SSb+tJsfJ3/DvH@lunn.ch>
 <AM6PR08MB43767C522EDAAF962B3AA73AFFC19@AM6PR08MB4376.eurprd08.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AM6PR08MB43767C522EDAAF962B3AA73AFFC19@AM6PR08MB4376.eurprd08.prod.outlook.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 16, 2023 at 08:39:31AM +0000, Pierluigi Passaro wrote:
> On Mon, Jan 16, 2023 at 12:55 AM Andrew Lunn <andrew@lunn.ch> wrote:
> > > Specifying the ID as part of the compatible string works for clause 22 PHYs,
> > > but for clause 45 PHYs it does not work. The code always wants to read the
> > > ID from the PHY itself. But I do not understand things well enough to tell
> > > whether that's a fundamental restriction of C45 or just our implementation
> > > and the implementation can be changed to fix it.
> > >
> > > Do you have some thoughts on this?
> >
> > Do you have more details about what goes wrong? Which PHY driver is
> > it? What compatibles do you put into DT for the PHY?
> >
> We use both AR8033 and ADIN1300: these are 10/100/1000 PHYs.
> They are both probed after the MDIO bus, but skipped if the reset was
> asserted while probing the MDIO bus.
> However, for iMX6UL and iMX7 we use C22, not C45.

I never said it did. Please read the actual emails, then you would of
noticed we have go off on tangent and are trying to fix another issue.

	Andrew
