Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC2B3372A87
	for <lists+netdev@lfdr.de>; Tue,  4 May 2021 14:59:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230449AbhEDNAa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 May 2021 09:00:30 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:52332 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230445AbhEDNA3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 May 2021 09:00:29 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1ldue9-002Trl-LL; Tue, 04 May 2021 14:59:29 +0200
Date:   Tue, 4 May 2021 14:59:29 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Don Bollinger <don@thebollingers.org>
Cc:     'Moshe Shemesh' <moshe@nvidia.com>,
        'Michal Kubecek' <mkubecek@suse.cz>,
        'Jakub Kicinski' <kuba@kernel.org>, netdev@vger.kernel.org,
        'Vladyslav Tarasiuk' <vladyslavt@nvidia.com>
Subject: Re: [PATCH ethtool-next 0/4] Extend module EEPROM API
Message-ID: <YJFFMWslomZHIoYG@lunn.ch>
References: <1619162596-23846-1-git-send-email-moshe@nvidia.com>
 <008301d73e03$1196abb0$34c40310$@thebollingers.org>
 <YIx9UaSckIraOQCC@lunn.ch>
 <008e01d73e0e$5d6a70c0$183f5240$@thebollingers.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <008e01d73e0e$5d6a70c0$183f5240$@thebollingers.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Here we go again...  It is my experience that there are far more
> capabilities in these devices than will ever be captured in ethtool.  Module
> vendors can provide additional value to their customers by putting
> innovative features into their modules, and providing software applications
> to take advantage of those features.  These features don't necessarily
> impact the network stack.  They may be used to draw additional diagnostic
> data from the devices, or to enable management features like flashing
> colored lights built into custom modules.  I've written code to do these and
> more things which are unique to one vendor, and valued by their customers.

Sorry, but not going to happen. Ethernet PHYs can have lots of
addition registers on stop of what 802.3 specifies. Vendors do add
additional functionality. And we do support some of it, like
configuring downshift, energy detect power down, cable diagnostics in
a generic manor. And we are open to adding more such features. People
can contribute code which multiple vendors might implement. We then
have well documented APIs which are the same across different vendors.

For LEDs you should be using the Linux LED class drivers. The Ethernet
PHYs are slowly moving that way. Very slowly :-(

Both MAC and Ethernet PHY drivers have tunables. I would suggest using
this concept, but applied to SFPs. This is how most of the additional
PHY features are supported. But first you need to add an SFP driver
framework, which matches on the fields in the EEPROM to load the
driver specific to an SFP. That then gives you a place to add such
code.

	Andrew
