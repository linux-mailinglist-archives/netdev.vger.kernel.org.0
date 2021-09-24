Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EF43416B6D
	for <lists+netdev@lfdr.de>; Fri, 24 Sep 2021 08:09:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244171AbhIXGKz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Sep 2021 02:10:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:37872 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244155AbhIXGKm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Sep 2021 02:10:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BD8B460E97;
        Fri, 24 Sep 2021 06:09:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632463748;
        bh=SnjyYdXnFlvhpBR3KEpK7jManzF2IVx0BI0qSH/0KQI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TLiG7cw/7S6qdenYBIID5vtPj9GjGDT4edzaDmJIUgjpacqEQDHkl3ZB2H6qjwIfm
         pXwV+Ghe+VxJdENbJEFPfOXgDhdkakZ/gpUKr2lBZcnIyw9m+/Ggz1mMEXjXBA7u9P
         s/bBL236u1NqQ3RsIBRXjkPpjAvtgg6a5vf+AWQw=
Date:   Fri, 24 Sep 2021 08:09:05 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Saravana Kannan <saravanak@google.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Len Brown <lenb@kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        kernel-team@android.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [PATCH v3 0/3] fw_devlink bug fixes
Message-ID: <YU1rgZHUxx7v6JmR@kroah.com>
References: <20210915170940.617415-1-saravanak@google.com>
 <YUy5nDMeWMg0sfGI@kroah.com>
 <20210923194448.tnzkdvigknjrgoqn@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210923194448.tnzkdvigknjrgoqn@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 23, 2021 at 10:44:48PM +0300, Vladimir Oltean wrote:
> On Thu, Sep 23, 2021 at 07:30:04PM +0200, Greg Kroah-Hartman wrote:
> > It fixes the real problem where drivers were making the wrong assumption
> > that if they registered a device, it would be instantly bound to a
> > driver.  Drivers that did this were getting lucky, as this was never a
> > guarantee of the driver core (think about if you enabled async
> > probing, and the mess with the bus specific locks that should be
> > preventing much of this)
> 
> Since commit d173a137c5bd ("driver-core: enable drivers to opt-out of
> async probe") it is possible to opt out of async probing, and PHY
> drivers do opt out of it, at the time of writing.

That's good, but we are talking about system-wide enabling of async
probing in the future, which might cause problems here :)

Anyway, let's go with this option for now and Saravana has assured me
that he will work on fixing up these drivers/bus to work properly going
forward.

thanks,

greg k-h
