Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7EB75400AE
	for <lists+netdev@lfdr.de>; Tue,  7 Jun 2022 16:06:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235603AbiFGOGA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 10:06:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235425AbiFGOF5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 10:05:57 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8297779803;
        Tue,  7 Jun 2022 07:05:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=/8ZEI2+4F6AsYinhF3XoVVKTVooozaOJVaelB9wjkfQ=; b=z5aJ7+fZFCVcT5sYsUjL7nRVbE
        FhjO8ncqboCDxqBFgp2PscB6fjiqSSlBSGkOZzIbnspd1p6QzstFJC/oKlPrQPazgWayLWYasdoHL
        9r4zdC4USglGlgkVTD4KN1ByyeZ1B3hzagHNLxNemkB5xqcsaTbU/cptHKPqoEHBHOPJMXZahVqsp
        oTnzTD7HiFC9nQ6TTyQuhaoLLqRp+Ufl1dxAUlW3hmlaGnlJ4cpD7hX2gxUpsjJ21+pLo+EjMy9jJ
        syTBbga83e9EsWRQa+GnmHv9mVF0fH+cBskgRHnQs4Lx+9QeRf+WVQNWCBZULCsziAYS33TP91XhI
        GgmnM4BA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:32768)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1nyZq3-0003YY-Tb; Tue, 07 Jun 2022 15:05:44 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1nyZq0-0000ql-Dg; Tue, 07 Jun 2022 15:05:40 +0100
Date:   Tue, 7 Jun 2022 15:05:40 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Luiz Angelo Daros de Luca <luizluca@gmail.com>
Cc:     Alvin =?utf-8?Q?=C5=A0ipraga?= <ALSI@bang-olufsen.dk>,
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
Message-ID: <Yp9bNLRV/7kYweCS@shell.armlinux.org.uk>
References: <20220606130130.2894410-1-alvin@pqrs.dk>
 <Yp4BpJkZx4szsLfm@shell.armlinux.org.uk>
 <20220606134708.x2s6hbrvyz4tp5ii@bang-olufsen.dk>
 <CAJq09z6YLza5v7fzfH2FCDrS8v8cC=B5pKg0_GiqX=fEYaGoqQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJq09z6YLza5v7fzfH2FCDrS8v8cC=B5pKg0_GiqX=fEYaGoqQ@mail.gmail.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 07, 2022 at 10:52:48AM -0300, Luiz Angelo Daros de Luca wrote:
> > > > Luiz, Russel:
> > > >
> > > > Commit a5dba0f207e5 ought to have had a Fixes: tag I think, because it
> > > > claims to have been fixing a regression in the net-next tree - is that
> > > > right? I seem to have missed both referenced commits when they were
> > > > posted and never hit this issue personally. I only found things now
> > > > during some other refactoring and the test for GMII looked weird to me
> > > > so I went and investigated.
> > > >
> > > > Could you please help me identify that Fixes: tag? Just for my own
> > > > understanding of what caused this added requirement for GMII on ports
> > > > with internal PHY.
> > >
> > > I have absolutely no idea. I don't think any "requirement" has ever been
> > > added - phylib has always defaulted to GMII, so as the driver stood when
> > > it was first submitted on Oct 18 2021, I don't see how it could have
> > > worked, unless the DT it was being tested with specified a phy-mode of
> > > "internal". As you were the one who submitted it, you would have a
> > > better idea.
> > >
> > > The only suggestion I have is to bisect to find out exactly what caused
> > > the GMII vs INTERNAL issue to crop up.
> >
> > Alright, thanks for the quick response. Maybe Luiz has a better idea, otherwise
> > I will try bisecting if I find the time.
> 
> I don't know. I just got hit by the issue after a rebase (sorry, I
> don't know exactly from which commit I was rebasing).
> But I did test the net (!-next) and left a working commit note. You
> can diff 3dd7d40b43..a5dba0f20.
> If I'm to guess, I would blame:
> 
> 21bd64bd717de: net: dsa: consolidate phylink creation

Why do you suspect that commit? I fail to see any functional change in
that commit that would cause the problem.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
