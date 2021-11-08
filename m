Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EEB6448136
	for <lists+netdev@lfdr.de>; Mon,  8 Nov 2021 15:17:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240340AbhKHOU1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 09:20:27 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:50680 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237965AbhKHOU0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Nov 2021 09:20:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=gmwJXUQZZysDMClQuXxVmi498zqenZAX/qkgrMBBZ50=; b=5sED2Qlu/i1e7c6vp1/BW3d4NP
        nV8oRFSio//MRsYm1iWPcPRPCCTxYuR0syPTB4OUGLQscihcyflEkb9CrFuX6FsvZqPqrgdKzsH7j
        GSLDwEYIVEJHzUpGvlzvMXbBWiiBs2hUYKZ4iUzlKxuBENDaFzQRb8Lq1Im5QcsjLHdQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mk5Sn-00Cu1S-Sq; Mon, 08 Nov 2021 15:17:33 +0100
Date:   Mon, 8 Nov 2021 15:17:33 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, Pavel Machek <pavel@ucw.cz>,
        John Crispin <john@phrozen.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-leds@vger.kernel.org
Subject: Re: [RFC PATCH v2 3/5] leds: trigger: add offload-phy-activity
 trigger
Message-ID: <YYkxfRrJ8ERaTr5x@lunn.ch>
References: <20211108002500.19115-1-ansuelsmth@gmail.com>
 <20211108002500.19115-4-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211108002500.19115-4-ansuelsmth@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 08, 2021 at 01:24:58AM +0100, Ansuel Smith wrote:
> Add Offload Trigger for PHY Activity. This special trigger is used to
> configure and expose the different HW trigger that are provided by the
> PHY. Each offload trigger can be configured by sysfs and on trigger
> activation the offload mode is enabled.
> 
> This currently implement these hw triggers:
>   - blink_tx: Blink LED on tx packet receive
>   - blink_rx: Blink LED on rx packet receive
>   - blink_collision: Blink LED on collision detection

When did you last see a collision? Do you really have a 1/2 duplex
link? Just because the PHY can, does not mean we should support
it. Lets restrict this to the most useful modes.

>   - link_10m: Keep LED on with 10m link speed
>   - link_100m: Keep LED on with 100m link speed
>   - link_1000m: Keep LED on with 1000m link speed
>   - half_duplex: Keep LED on with half duplex link
>   - full_duplex: Keep LED on with full duplex link
>   - linkup_over: Keep LED on with link speed and blink on rx/tx traffic
>   - power_on_reset: Keep LED on with switch reset

>   - blink_2hz: Set blink speed at 2hz for every blink event
>   - blink_4hz: Set blink speed at 4hz for every blink event
>   - blink_8hz: Set blink speed at 8hz for every blink event

These seems like attributes, not blink modes. They need to be
specified somehow differently, or not at all. Do we really need them?

>   - blink_auto: Set blink speed at 2hz for 10m link speed,
>       4hz for 100m and 8hz for 1000m

Another attribute, and one i've not seen any other PHY do.

	Andrew
