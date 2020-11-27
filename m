Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34E772C6905
	for <lists+netdev@lfdr.de>; Fri, 27 Nov 2020 16:57:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730529AbgK0P4p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Nov 2020 10:56:45 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:52942 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727281AbgK0P4p (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Nov 2020 10:56:45 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kig6v-0099LG-C4; Fri, 27 Nov 2020 16:56:37 +0100
Date:   Fri, 27 Nov 2020 16:56:37 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Moshe Shemesh <moshe@nvidia.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Moshe Shemesh <moshe@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        Adrian Pop <pop.adrian61@gmail.com>,
        Michal Kubecek <mkubecek@suse.cz>, netdev@vger.kernel.org,
        Vladyslav Tarasiuk <vladyslavt@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>
Subject: Re: [PATCH net-next v2 0/2] Add support for DSFP transceiver type
Message-ID: <20201127155637.GS2073444@lunn.ch>
References: <1606123198-6230-1-git-send-email-moshe@mellanox.com>
 <20201124011459.GD2031446@lunn.ch>
 <20201124131608.1b884063@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <98319caa-de5f-6f5e-9c9e-ee680e5abdc0@nvidia.com>
 <20201125141822.GI2075216@lunn.ch>
 <a9835ab6-70a1-5a15-194e-977ff9c859ec@nvidia.com>
 <20201126152113.GM2073444@lunn.ch>
 <6a9bbcb0-c0c4-92fe-f3c1-581408d1e7da@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6a9bbcb0-c0c4-92fe-f3c1-581408d1e7da@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> OK, but if the caching system is checking one time netlink and one time
> ioctl, it means this cache should be in user space, or did you mean to have
> this cache in kernel ?

This is all in userspace, in the ethtool code.

> > > What about the global offset that we currently got when user doesn't specify
> > > a page, do you mean that this global offset goes through the optional and
> > > non optional pages that exist and skip the ones that are missing according
> > > to the specific EEPROM ?
> > ethtool -m|--dump-module-eeprom|--module-info devname [raw on|off] [hex on|off] [offset N] [length N]
> > 
> > So you mean [offset N] [length N].
> 
> 
> Yes, that's the current options and we can either try coding new
> implementation for that or just call the current ioctl implementation. The
> new code can be triggered once options [bank N] and [Page N] are used.

You cannot rely on the ioctl being available. New drivers won't
implement it, if they have the netlink code. Drivers will convert from
get_module_info to whatever new ndo call you add for netlink.

> OK, if I got it right on current API [offset N] [length N] just call ioctl
> current implementation, while using the option [raw on] will call new
> implementation for new SFPs (CMIS 4). Also using [bank N] and [page N] will
> call new implementation for new SFPs.

Not just CMIS. All SFPs.

    Andrew
