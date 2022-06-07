Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78E745401AC
	for <lists+netdev@lfdr.de>; Tue,  7 Jun 2022 16:45:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238850AbiFGOpp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 10:45:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244641AbiFGOpo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 10:45:44 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54BE34474E;
        Tue,  7 Jun 2022 07:45:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=7rNMDeDx4T7YoKNaSO1w0qFDUszwAfmML4PKjeMx32o=; b=duVZ8Cv8kSYWaiAPwvDGRyUCLc
        TkqjYDEDgtPGgBTzekHCiNFIP7nQmYo1b9iDwZGrEFfquSQ/SnNneDMKCyyCildK0IskT6FsHU4El
        WOpwDgXKCfNLRnfSCJE6Sd4r+IauRpCpbwMv+c5Y3U62tzpYkqEwFWEaf3vvI1LCJ0Sj9Mp70Za1D
        vJF7eg7dJCOsS9xRuLgfa2A43pboAie4uYeYcF3idUbsPHwOfhhALEODKKcMeDTJh3Zi69J5e0Lz2
        MfSI/95cffnnZ89ZIX+EUcaPJvOWnfjV+dFEbU8morurvQ9WJN4rdidsS+iMo93NIrOt132rjjYJq
        ODWZDJvQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:32770)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1nyaSc-0003cV-Dc; Tue, 07 Jun 2022 15:45:34 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1nyaSa-0000so-6n; Tue, 07 Jun 2022 15:45:32 +0100
Date:   Tue, 7 Jun 2022 15:45:32 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Alvin =?utf-8?Q?=C5=A0ipraga?= <ALSI@bang-olufsen.dk>
Cc:     Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        Alvin =?utf-8?Q?=C5=A0ipraga?= <alvin@pqrs.dk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net] net: dsa: realtek: rtl8365mb: fix GMII caps for
 ports with internal PHY
Message-ID: <Yp9kjD0D9XYIvran@shell.armlinux.org.uk>
References: <20220606130130.2894410-1-alvin@pqrs.dk>
 <Yp4BpJkZx4szsLfm@shell.armlinux.org.uk>
 <20220606134708.x2s6hbrvyz4tp5ii@bang-olufsen.dk>
 <CAJq09z6YLza5v7fzfH2FCDrS8v8cC=B5pKg0_GiqX=fEYaGoqQ@mail.gmail.com>
 <Yp9bNLRV/7kYweCS@shell.armlinux.org.uk>
 <20220607141744.l2yhwnix6aoiwl54@bang-olufsen.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220607141744.l2yhwnix6aoiwl54@bang-olufsen.dk>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 07, 2022 at 02:17:44PM +0000, Alvin Šipraga wrote:
> On Tue, Jun 07, 2022 at 03:05:40PM +0100, Russell King (Oracle) wrote:
> > On Tue, Jun 07, 2022 at 10:52:48AM -0300, Luiz Angelo Daros de Luca wrote:
> > > > > > Luiz, Russel:
> > > > > >
> > > > > > Commit a5dba0f207e5 ought to have had a Fixes: tag I think, because it
> > > > > > claims to have been fixing a regression in the net-next tree - is that
> > > > > > right? I seem to have missed both referenced commits when they were
> > > > > > posted and never hit this issue personally. I only found things now
> > > > > > during some other refactoring and the test for GMII looked weird to me
> > > > > > so I went and investigated.
> > > > > >
> > > > > > Could you please help me identify that Fixes: tag? Just for my own
> > > > > > understanding of what caused this added requirement for GMII on ports
> > > > > > with internal PHY.
> > > > >
> > > > > I have absolutely no idea. I don't think any "requirement" has ever been
> > > > > added - phylib has always defaulted to GMII, so as the driver stood when
> > > > > it was first submitted on Oct 18 2021, I don't see how it could have
> > > > > worked, unless the DT it was being tested with specified a phy-mode of
> > > > > "internal". As you were the one who submitted it, you would have a
> > > > > better idea.
> > > > >
> > > > > The only suggestion I have is to bisect to find out exactly what caused
> > > > > the GMII vs INTERNAL issue to crop up.
> > > >
> > > > Alright, thanks for the quick response. Maybe Luiz has a better idea, otherwise
> > > > I will try bisecting if I find the time.
> > > 
> > > I don't know. I just got hit by the issue after a rebase (sorry, I
> > > don't know exactly from which commit I was rebasing).
> > > But I did test the net (!-next) and left a working commit note. You
> > > can diff 3dd7d40b43..a5dba0f20.
> > > If I'm to guess, I would blame:
> > > 
> > > 21bd64bd717de: net: dsa: consolidate phylink creation
> > 
> > Why do you suspect that commit? I fail to see any functional change in
> > that commit that would cause the problem.
> 
> Agree, seems like the referenced commit makes no functional change.
> 
> But thanks for the range of commits Luiz, I found one that looks like the
> culprit. It's small so I will reproduce the whole thing below. Will test later.

This one I agree could well be the culpret, but it means that the
original premise that PHY_INTERFACE_MODE_INTERNAL was being used is
incorrect - it's actually been relying on using PHY_INTERFACE_MODE_NA.

It instead means that PHY_INTERFACE_MODE_NA was being used, which
really isn't good, because PHY_INTERFACE_MODE_NA internally inside
phylink has always had a special meaning - that being with the
validate step which has been used to get _all_ possible modes from
the MAC. This was never intended to be used for anything except
phylink's internal use to retrieve that information from the MAC
driver to make decisions about what mode(s) a SFP should use.

So yes, this is most likely the culpret, and if proven, please use
it for the Fixes: tag for any fixes to drivers that incorrectly
relied upon that behaviour.

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
