Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 651B24AA98B
	for <lists+netdev@lfdr.de>; Sat,  5 Feb 2022 15:58:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380171AbiBEO6B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Feb 2022 09:58:01 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:43816 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236323AbiBEO6A (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 5 Feb 2022 09:58:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=b50B8/pM0u49zfZrqiOAhoZ2WmIOCD9FYNeN94DzpsA=; b=q8YlP0NjT37AwLC8qG2pZMkN8s
        7KLMrEJPiiOVOxuDOjAL07weitvm2lzx8EE0N5WtNMmr5h1DQL8iYJ66cO5w6VrMxplS/rQe6P4pN
        EmYHrooTszI61BsDZwlnnu+Xpf8aac/aZ3RdLMdHR2BB5HhikixtjXYCxWPWs9M7hv7M=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nGMVZ-004OwC-Gw; Sat, 05 Feb 2022 15:57:49 +0100
Date:   Sat, 5 Feb 2022 15:57:49 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Raag Jadav <raagjadav@gmail.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Steen Hegelund <steen.hegelund@microchip.com>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: phy: mscc: enable MAC SerDes autonegotiation
Message-ID: <Yf6QbbqaxZhZPUdC@lunn.ch>
References: <1644043492-31307-1-git-send-email-raagjadav@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1644043492-31307-1-git-send-email-raagjadav@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Feb 05, 2022 at 12:14:52PM +0530, Raag Jadav wrote:
> Enable MAC SerDes autonegotiation to distinguish between
> 1000BASE-X, SGMII and QSGMII MAC.

How does autoneg help you here? It just tells you about duplex, pause
etc. It does not indicate 1000BaseX, SGMII etc. The PHY should be
using whatever mode it was passed in phydev->interface, which the MAC
sets when it calls the connection function. If the PHY dynamically
changes its host side mode as a result of what that line side is
doing, it should also change phydev->interface. However, as far as i
can see, the mscc does not do this.

So i don't understand this commit message.

   Andrew
