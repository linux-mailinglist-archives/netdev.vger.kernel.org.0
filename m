Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B9613E3B0B
	for <lists+netdev@lfdr.de>; Sun,  8 Aug 2021 17:18:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231933AbhHHPSh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Aug 2021 11:18:37 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:38792 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229923AbhHHPSh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 8 Aug 2021 11:18:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=IX6iXJR0gdOvuN0kjkDx8GxE+mezPMmx72SsWSZD468=; b=Xz7KwTC+TkeF0IbjWDSRYb02dp
        AzBo0pJjr+W43TgQ2ELghz2eGhoPWcZPiOKEmJmRjyGw+d8DXzAx2nGxOoghaS+iOns1R4FJZXsBM
        5XcRdOGOuPEuX4A2hZhdzPVDyF5KfWo5ccORIMjZ/lbGcxfvxOlG56+tI5HyiNXIEzHA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mCkYq-00Gaij-Qa; Sun, 08 Aug 2021 17:18:00 +0200
Date:   Sun, 8 Aug 2021 17:18:00 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Daniel Golle <daniel@makrotopia.org>
Cc:     Michael Walle <michael@walle.cc>,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] ARM: kirkwood: add missing <linux/if_ether.h> for
 ETH_ALEN
Message-ID: <YQ/1qBum6BxRE6l6@lunn.ch>
References: <YQxk4jrbm31NM1US@makrotopia.org>
 <cde9de20efd3a75561080751766edbec@walle.cc>
 <YQ6WCK0Sytb0nxj9@lunn.ch>
 <YQ9PNeka8VhZqxGR@makrotopia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YQ9PNeka8VhZqxGR@makrotopia.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> When building OpenWrt kernel which includes a backport of
> "of: net: pass the dst buffer to of_get_mac_address()", this is not the
> same as <linux/of_net.h> doesn't include <linux/phy.h> yet. This is
> because we miss commit 0c65b2b90d13c1 ("net: of_get_phy_mode: Change
> API to solve int/unit warnings") which has been in mainline for a long
> time.

That is quiet a big invasive patch, so i can understand it not being
backported. But on the flip side, it will make it harder getting
drivers upstream to mainline. And there are is one other big change,
how the MAC address is fetches from EEPROM, DT, etc.

> Sorry for the noise caused, I'm not sure what the policy is in this
> case

There is nothing in the coding style that all headers must be directly
included in the .c file. And it slows down the compiler having to pull
in a header file multiple times. You do see patches removing unused
includes. So i think OpenWRT should add yet another patch do deal with
its own breakage.

If you have more kirkwood, or Marvell boards in general in OpenWRT
which you want merged to mainline, i'm happy to review them.

      Andrew
