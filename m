Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6541C31A046
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 15:06:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231317AbhBLOFx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 09:05:53 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:36880 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230182AbhBLOFi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Feb 2021 09:05:38 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lAZ3y-005q4A-U6; Fri, 12 Feb 2021 15:04:50 +0100
Date:   Fri, 12 Feb 2021 15:04:50 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Saravana Kannan <saravanak@google.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Android Kernel Team <kernel-team@android.com>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Jon Hunter <jonathanh@nvidia.com>
Subject: Re: phy_attach_direct()'s use of device_bind_driver()
Message-ID: <YCaLAtsdV3BmbsGe@lunn.ch>
References: <CAGETcx9YpCUMmHjyydMtOJP9SKBbVsHNB-9SspD9u=txJ12Gug@mail.gmail.com>
 <YCRjmpKjK0pxKTCP@lunn.ch>
 <CAGETcx-tBw_=VPvQVYcpPJBJjgQvp8UASrdMdSbSduahZpJf9w@mail.gmail.com>
 <4f0086ad-1258-063d-0ace-fe4c6c114991@gmail.com>
 <CAGETcx_9bmeLzOvDp8eCGdWtfwZNajCBCNSbyx7a_0T=FcSvwA@mail.gmail.com>
 <YCU3vaZ51XpksIpc@lunn.ch>
 <CAGETcx9gS7oq65nU9nHicMU6NXN8L=z9zuuEuEDMjtLUYyOoVg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGETcx9gS7oq65nU9nHicMU6NXN8L=z9zuuEuEDMjtLUYyOoVg@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> So the plan to fix this warning is, when device_bind_driver() is called:
> 1. Delete all device links from the device (in this case, the PHY) to
> suppliers that haven't probed yet because there's no probe function
> that can defer at this point.

Just because it currently does not happen, does not mean it couldn't
happen in the future. What are the implications of removing the links?


> 2. Then call the usual device link status update code so that it
> updates the status of the remaining device links correctly. This will
> avoid the warning.
> 
> This seems like a generic solution that works for PHY and for any
> device that is force bound.

I don't know if there is any other case in the kernel where a fallback
driver is force bound on a device. But i agree this should be
generic. And hidden away in the drive core, with maybe a new call?

	 Andrew
