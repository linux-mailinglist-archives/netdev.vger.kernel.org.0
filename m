Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FCE13FEC39
	for <lists+netdev@lfdr.de>; Thu,  2 Sep 2021 12:37:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244271AbhIBKih (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Sep 2021 06:38:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:59446 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233714AbhIBKig (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Sep 2021 06:38:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DF24660FC0;
        Thu,  2 Sep 2021 10:37:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630579057;
        bh=myvl5C6bWm7U0pzspU+p4yxBN99ESzBLn2YM1d94xhI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Y1yzDS+opMJgUTIiJtfY1tYRDR+ZoWRoM/XEVw8SmpFek+7lRlcxUoUWGno6E7mdj
         cYzjWp98uMwc4FoQWi0f3X/b4zLs4z3W5tN88P1FmQX58NJbyRZ05IQkoRGnnhXN1T
         aAqy72exzeNO9ymO3tU3JSEbDQWSMFm4jNa2J6XQ=
Date:   Thu, 2 Sep 2021 12:37:34 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Alvin =?utf-8?Q?=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        kernel-team <kernel-team@android.com>,
        Len Brown <lenb@kernel.org>
Subject: Re: [RFC PATCH net-next 1/3] net: phy: don't bind genphy in
 phy_attach_direct if the specific driver defers probe
Message-ID: <YTCpbkDMUfBtJM1V@kroah.com>
References: <20210901225053.1205571-1-vladimir.oltean@nxp.com>
 <20210901225053.1205571-2-vladimir.oltean@nxp.com>
 <YTBkbvYYy2f/b3r2@kroah.com>
 <20210902101150.dnd2gycc7ekjwgc6@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210902101150.dnd2gycc7ekjwgc6@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 02, 2021 at 01:11:50PM +0300, Vladimir Oltean wrote:
> On Thu, Sep 02, 2021 at 07:43:10AM +0200, Greg Kroah-Hartman wrote:
> > Wait, no, this should not be a "special" thing, and why would the list
> > of deferred probe show this?
> 
> Why as in why would it work/do what I want, or as in why would you want to do that?

Both!  :)

> > If a bus wants to have this type of "generic vs. specific" logic, then
> > it needs to handle it in the bus logic itself as that does NOT fit into
> > the normal driver model at all.  Don't try to get a "hint" of this by
> > messing with the probe function list.
> 
> Where and how? Do you have an example?

No I do not, sorry, most busses do not do this for obvious ordering /
loading / we are not that crazy reasons.

What is causing this all to suddenly break?  The devlink stuff?

thanks,

greg k-h
