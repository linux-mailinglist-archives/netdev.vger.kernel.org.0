Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D3B123CE4C
	for <lists+netdev@lfdr.de>; Wed,  5 Aug 2020 20:23:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729172AbgHESXX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Aug 2020 14:23:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728712AbgHESWy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Aug 2020 14:22:54 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B16F6C061575;
        Wed,  5 Aug 2020 11:22:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=wjGUmMwAwZVHBFBHwSRAPlWoXdzqfrdYlvMEZCahuMA=; b=Jmg3XGUXX1Sk+AH/bPxJUbHC9
        85vLTxq6eqP0fNuvrSWRAGFdHwCQGF+BszQW/24v9HHpk05QTEZ0u9FghyxQ+Ve6JgtoHZOEwzegd
        eLbjLMsjytLiNSRro1Jv0I35rRqQbMjKwFP2Yu1oUPjY3/75L5CzhewAYIammS5nxIWmX98BTaj3x
        nH05ej6nyqL3jn51BozCTt4zLYPcstWPmvtV3bXCkHOTnelIydBH+482e3P8ZZ8fqUkcyYoeEXjNe
        wBIrLbOHezitiYtM4Z8Uk5lwJ45NkAkmNZJ/FzmTSaCpm9lDPmmAAHZMJW7ddeB3UPAGYPo2WZbjy
        4AQ68jvwg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:48736)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1k3O3w-0003n2-86; Wed, 05 Aug 2020 19:22:52 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1k3O3v-0005LP-0e; Wed, 05 Aug 2020 19:22:51 +0100
Date:   Wed, 5 Aug 2020 19:22:50 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH] MAINTAINERS: update phylink/sfp keyword matching
Message-ID: <20200805182250.GX1551@shell.armlinux.org.uk>
References: <E1k3KUx-0000da-In@rmk-PC.armlinux.org.uk>
 <CAHk-=whbLwN9GEVVt=7eYhPYk0t0Wh1xeuNEDD+xmQxBFjAQJA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=whbLwN9GEVVt=7eYhPYk0t0Wh1xeuNEDD+xmQxBFjAQJA@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 05, 2020 at 11:11:28AM -0700, Linus Torvalds wrote:
> On Wed, Aug 5, 2020 at 7:34 AM Russell King <rmk+kernel@armlinux.org.uk> wrote:
> >
> > Is this something you're willing to merge directly please?
> 
> Done.
> 
> That said:
> 
> > -K:     phylink
> > +K:     phylink\.h|struct\s+phylink|\.phylink|>phylink_|phylink_(autoneg|clear|connect|create|destroy|disconnect|ethtool|helper|mac|mii|of|set|start|stop|test|validate)
> 
> That's a very awkward pattern. I wonder if there could be better ways
> to express this (ie "only apply this pattern to these files" kind of
> thing)

Yes, it's extremely awkward - I spent much of the morning with perl
testing it out on the drivers/ subtree.

> Isn't the 'F' pattern already complete enough that maybe the K pattern
> isn't even worth it?

Unfortunately not; I used not to have a K: line, which presented the
problem that we had users of phylink added to the kernel that were not
being reviewed.  So, the suggestion was to add a K: line.

However, I'm now being spammed by syzbot (I've received multiple emails
about the same problem) because, rather than MAINTAINERS being applied
to just patches, it is now being applied to entire source files.  This
means that the previous "K: phylink" entry matches not just on patches
(which can be easily ignored) but entire files, such as
net/bluetooth/hci_event.c which happens to contain "phylink" in a
function name.

So, when syzbot identifies there is a problem in
net/bluetooth/hci_event.c, it sends me a report, despite it having
no relevance for me.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
