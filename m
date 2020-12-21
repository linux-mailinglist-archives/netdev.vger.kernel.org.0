Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 564642E0071
	for <lists+netdev@lfdr.de>; Mon, 21 Dec 2020 19:50:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727233AbgLUSty (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Dec 2020 13:49:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:52110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727220AbgLUSty (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Dec 2020 13:49:54 -0500
Date:   Mon, 21 Dec 2020 10:47:57 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608576480;
        bh=gTGZfpII5i36fRI++AgefpXMI0LpZgdmm0CChJOkdbQ=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=P+yPfGWu6pHp9hgsdBKJvEgrOmFXkVuDTqcyYIeJro2C3obApB7sshTq385G5/8L+
         q8cAsbq1neQOFPMAJx9G4io82WOHiqf1JjqyNc993uslBpjOYOOGnDR9v7xB7BLwAJ
         LjC4Z9Cx+UH5nBqC04DGmG+LUh8HgmW3MKyPYeUa6A837yh4UmO8wriye/nlZTt3Gy
         CaI78p/k+f1Sjpo54/+MgtDAqwWs8FMCNf5LlqoKwvMFF8OwgBMkiLTBbQiMZvTfgs
         p+czOb8gWudNwACRZHjhR3MwW0SYiNbK35U1wvgQ6WBB6490VQulzn8bHQ8F21dbuU
         GyCiZtFhwts1Q==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        stable@vger.kernel.org
Cc:     Marcin Wojtas <mw@semihalf.com>, Sasha Levin <sashal@kernel.org>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Gabor Samu <samu_gabor@yahoo.ca>,
        Jon Nettleton <jon@solid-run.com>,
        Andrew Elwell <andrew.elwell@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH net-next 2/4] net: mvpp2: add mvpp2_phylink_to_port()
 helper
Message-ID: <20201221104757.2cd8d68c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201221183032.GA1551@shell.armlinux.org.uk>
References: <CAPv3WKdJKAEwCoj5z6NzP2xRFfT1HG+2o0wigt=Czi4bG7EQcg@mail.gmail.com>
        <CAPv3WKfEN22cKbM8=+qDANefQE67KQ1zwURrCqAsrbo1+gBCDA@mail.gmail.com>
        <20201102180326.GA2416734@kroah.com>
        <CAPv3WKf0fNOOovq9UzoxoAXwGLMe_MHdfCZ6U9sjgKxarUKA+Q@mail.gmail.com>
        <20201208133532.GH643756@sasha-vm>
        <CAPv3WKed9zhe0q2noGKiKdzd=jBNLtN6vRW0fnQddJhhiD=rkg@mail.gmail.com>
        <X9CuTjdgD3tDKWwo@kroah.com>
        <CAPv3WKdKOnd+iBkfcVkoOZkHj16jOpBprY3A01ERJeq6ZQCkVQ@mail.gmail.com>
        <CAPv3WKfCfECmwjtXLAMbNe-vuGkws_icoQ+MrgJhZJqFcgGDyw@mail.gmail.com>
        <20201221102539.6bdb9f5c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20201221183032.GA1551@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 21 Dec 2020 18:30:32 +0000 Russell King - ARM Linux admin wrote:
> On Mon, Dec 21, 2020 at 10:25:39AM -0800, Jakub Kicinski wrote:
> > We need to work with stable maintainers on this, let's see..
> > 
> > Greg asked for a clear description of what happens, from your 
> > previous response it sounds like a null-deref in mvpp2_mac_config(). 
> > Is the netdev -> config -> netdev linking not ready by the time
> > mvpp2_mac_config() is called?  
> 
> We are going round in circles, so nothing is going to happen.
> 
> I stated in detail in one of my emails on the 10th December why the
> problem occurs. So, Greg has the description already. There is no
> need to repeat it.
> 
> Can we please move forward with this?

Well, the fact it wasn't quoted in Marcin's reply and that I didn't
spot it when scanning the 30 email thread should be a clear enough
indication whether pinging threads is a good strategy..

A clear, fresh backport request would had been much more successful 
and easier for Greg to process. If you still don't see a reply in
2 weeks, please just do that.

In case Greg is in fact reading this:


Greg, can we backport: 

6c2b49eb9671 ("net: mvpp2: add mvpp2_phylink_to_port() helper")

to 5.4? Quoting Russell:

The problem is that mvpp2_acpi_start() passes an un-initialised
(zeroed) port->phylink_config, as phylink is not used in ACPI setups.

Crash occurs because port->phylink_config.dev (which is a NULL pointer
in this instance) is passed to to_net_dev():

#define to_net_dev(d) container_of(d, struct net_device, dev)

Which then means netdev_priv(dev) attempts to dereference a not-quite
NULL pointer, leading to an oops.


Folks here are willing to provide a more cut down fix if necessary.

Thanks!
