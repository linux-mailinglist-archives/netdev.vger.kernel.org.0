Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D6DC3E831A
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 20:43:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230351AbhHJSnb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 14:43:31 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:43368 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229480AbhHJSna (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Aug 2021 14:43:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=vuY4CU2wqTh4MiNOaeRz1+bUXIW8uOlvfPoVeU/k6qY=; b=b7DMOqREteJbMkdZnjrSvBb+i/
        kW+1wtYwdvcdmYrcehORUYKTu3xXLeYgTg0X8imZx2IZvFh4XxZ6h2YmJg75FknEdRWRDS9YN4YXk
        8ULqbKcKkqG1MwuX8NsAYDVB/BKcIHRaD3kblDoU/nTXfziLorKDDfFu/pjKqghsSUlM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mDWi5-00GxZx-R1; Tue, 10 Aug 2021 20:42:45 +0200
Date:   Tue, 10 Aug 2021 20:42:45 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jean Delvare <jdelvare@suse.com>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Marek Vasut <marex@denx.de>, David Jander <david@protonic.nl>,
        linux-hwmon@vger.kernel.org
Subject: Re: [PATCH net-next v1] net: phy: nxp-tja11xx: log critical health
 state
Message-ID: <YRLIpQIVgieYo1yc@lunn.ch>
References: <20210810125618.20255-1-o.rempel@pengutronix.de>
 <YRKV05IoqtJYr6Cj@lunn.ch>
 <04df44d9-f049-e87b-81de-5a9fe888a49b@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <04df44d9-f049-e87b-81de-5a9fe888a49b@roeck-us.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > I'm not so happy abusing the statistic counters like this. Especially
> > when we have a better API for temperature and voltage: hwmon.
> > 
> > phy_temp_warn maps to hwmon_temp_max_alarm. phy_temp_high maps to
> > either hwmon_temp_crit_alarm or hwmon_temp_emergency_alarm.
> > 
> > The under voltage maps to hwmon_in_lcrit_alarm.
> > 
> 
> FWIW, the statistics counters in this driver are already abused
> (phy_polarity_detect, phy_open_detect, phy_short_detect), so
> I am not sure if adding more abuse makes a difference (and/or
> if such abuse is common for phy drivers in general).

Hi Guenter

Abuse is not common in general. I think this is the only driver
abusing stats to return flags.  At the time those where added, we did
not have phy cable test support. Now we do, i would also suggest that
the driver makes use of that infrastructure to issue a cable test
report. These 'stats' need to stay, since they are ABI, but we should
not add more.

That is also why i said "Especially when we have a better API".

     Andrew

