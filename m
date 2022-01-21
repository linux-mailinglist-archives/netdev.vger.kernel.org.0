Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14233495894
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 04:38:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233481AbiAUDiO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jan 2022 22:38:14 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:46934 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233406AbiAUDiN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Jan 2022 22:38:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=ZU/PEYNTT8vpKNnUJQm48p21UVkPUjERoKoMWQWxJ+w=; b=sWaRUf2bSEEqGI/6plwuI5bslV
        TASohLEFLU8G5sFo51j41w3onjHOFJeDo+jI3yPMVjpLkE3BL3S0BgbOU7vmgI04sJGV4aJWINt+V
        2hojqtjW8h2sI3gFIpQN3iRup+Dd7OhQq67fxWyxxaGWnsskeBBHat5zS0ugLfUQw8m4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nAkkb-0022ro-86; Fri, 21 Jan 2022 04:38:09 +0100
Date:   Fri, 21 Jan 2022 04:38:09 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Richard Cochran <richardcochran@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Miroslav Lichvar <mlichvar@redhat.com>,
        Russell King <linux@arm.linux.org.uk>
Subject: Re: [PATCH RFC V1 net-next 3/4] net: Let the active time stamping
 layer be selectable.
Message-ID: <Yeoqof1onvrcWGNp@lunn.ch>
References: <20220103232555.19791-4-richardcochran@gmail.com>
 <20220120164832.xdebp5vykib6h6dp@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220120164832.xdebp5vykib6h6dp@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> This is also the reason why DSA denies PTP timestamping on the master
> interface, although there isn't any physical reason to do that. For the
> same reason mentioned earlier, it would be nice to see hwtstamps for a
> packet as it traverses DSA master -> DSA switch port -> PHY attached to
> DSA switch.

Don't forget there could be back to back PHYs between the master and
the DSA switch port. In theory they could also be doing time stamping.

Also consider the case of a switch port connected to a PHY which does
media conversion to SFP. And the SFP has a copper module, so contains
another PHY. So you could have the MAC and both PHYs doing time
stamping?

So in the extreme case, you have 7 time stamps, 3 from MACs and 4 from
PHYs!

I doubt we want to support this, is there a valid use case for it?

  Andrew
