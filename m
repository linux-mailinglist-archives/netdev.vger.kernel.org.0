Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99D64413D42
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 00:04:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235875AbhIUWGS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Sep 2021 18:06:18 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:53052 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234138AbhIUWGR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Sep 2021 18:06:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=Y8walwzZfA6oEsgIq0XGt24YSfqgsXw1/bUyLuA7xcs=; b=kTDVJxxx5imoyYRq6kTWjvD74d
        P/avqx65kgQ4+uiMcC3Kd1MJljHo2oqvedNLnJE+inyxXm3gijd7dJU7nRppe0iOFM62F2k/WLDuD
        Dz9jmiJxdr25gxOK/zAYpAtazUfuBC9Ht1ywXZEq7R+RmvbgoRwLczxtsUTSlO/9MWGs=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mSnsS-007h9z-7i; Wed, 22 Sep 2021 00:04:36 +0200
Date:   Wed, 22 Sep 2021 00:04:36 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Saravana Kannan <saravanak@google.com>
Cc:     "Rafael J. Wysocki" <rafael@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Len Brown <lenb@kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Vladimir Oltean <olteanv@gmail.com>,
        "Cc: Android Kernel" <kernel-team@android.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Subject: Re: [PATCH v3 2/3] driver core: fw_devlink: Add support for
 FWNODE_FLAG_NEEDS_CHILD_BOUND_ON_ADD
Message-ID: <YUpW9LIcrcok8rBa@lunn.ch>
References: <CAJZ5v0h11ts69FJh7LDzhsDs=BT2MrN8Le8dHi73k9dRKsG_4g@mail.gmail.com>
 <YUaPcgc03r/Dw0yk@lunn.ch>
 <YUoFFXtWFAhLvIoH@kroah.com>
 <CAJZ5v0jjvf6eeEKMtRJ-XP1QbOmjEWG=DmODbMhAFuemNn4rZg@mail.gmail.com>
 <YUocuMM4/VKzNMXq@lunn.ch>
 <CAJZ5v0iU3SGqrw909GLtuLwAxdyOy=pe2avxpDW+f4dP4ArhaQ@mail.gmail.com>
 <YUo3kD9jgx6eNadX@lunn.ch>
 <CAGETcx9hTFhY4+fHd71zYUsWW223GfUWBp8xxFCb2SNR6YUQ4Q@mail.gmail.com>
 <YUpIgTqyrDRXMUyC@lunn.ch>
 <CAGETcx_50KQuj0L+MCcf2Se8kpFfZwJBKP0juh_T7w+ZCs2p+g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGETcx_50KQuj0L+MCcf2Se8kpFfZwJBKP0juh_T7w+ZCs2p+g@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 21, 2021 at 02:54:47PM -0700, Saravana Kannan wrote:
> On Tue, Sep 21, 2021 at 2:03 PM Andrew Lunn <andrew@lunn.ch> wrote:
> >
> > > There are cases where the children try to probe too quickly (before
> > > the parent has had time to set up all the resources it's setting up)
> > > and the child defers the probe. Even Andrew had an example of that
> > > with some ethernet driver where the deferred probe is attempted
> > > multiple times wasting time and then it eventually succeeds.
> >
> > And i prefer an occasional EPROBE_DEFER over a broken Ethernet switch,
> > which is the current state. I'm happy to see optimisations, but not at
> > the expense of breaking working stuff.
> 
> Right, but in that case, the long term solution should be to make
> changes so we don't expect the child to be bound as soon as it's
> added. Not disable the optimization. Agree?

Maybe. Lets see how you fix what is currently broken. At the moment, i
don't care too much about the long term solution. The current quick
fix for stable does not seem to be making any progress. So we need the
real fix now, to unbreak what is currently broken, then we can think
about the long term.

    Andrew
