Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA389423294
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 23:01:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236136AbhJEVDN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 17:03:13 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:50800 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231387AbhJEVDM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Oct 2021 17:03:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=xoD6/I7Cc8crpzzqPjHiA+h57zOy6+xgtG83jf7v3i8=; b=NYWTqPejfFry0n/LrjSsAY4phD
        Qv1Tdgk05aJiDeQWZbS1BqXiFN/DcEdqUax8IasE+VPxks+3NE3UEyp2JQfM8YXCOsAG4Oogb1FPj
        SFZsudwdTTCj2sSoyY+bdNG+q9Bbt+LK+gMQf5D8vdH6eIZDVq+QPOqlesfuADycj2UQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mXrYs-009kQB-57; Tue, 05 Oct 2021 23:01:18 +0200
Date:   Tue, 5 Oct 2021 23:01:18 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        Rob Herring <robh+dt@kernel.org>, Pavel Machek <pavel@ucw.cz>,
        "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: lets settle the LED `function` property regarding the netdev
 trigger
Message-ID: <YVy9Ho47XeVON+lB@lunn.ch>
References: <20211001143601.5f57eb1a@thinkpad>
 <YVn815h7JBtVSfwZ@lunn.ch>
 <20211003212654.30fa43f5@thinkpad>
 <YVsUodiPoiIESrEE@lunn.ch>
 <20211004170847.3f92ef48@thinkpad>
 <0b1bc2d7-6e62-5adb-5aed-48b99770d80d@gmail.com>
 <20211005222657.7d1b2a19@thinkpad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211005222657.7d1b2a19@thinkpad>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> In the discussed case (ethernet PHY LEDs) - it is sometimes possible to
> have multiple brightness levels per color channel. For example some
> Marvell PHYs allow to set 8 levels of brightness for Dual Mode LEDs.
> Dual Mode is what Marvell calls when the PHY allows to pair two
> LED pins to control one dual-color LED (green-red, for example) into
> one.
> 
> Moreover for this Dual Mode case they also allow for HW control of
> this dual LED, which, when enabled, does something like this, in HW:
>   1g link	green
>   100m link	yellow
>   10m link	red
>   no link	off
> 
> Note that actual colors depend on the LEDs themselves. The PHY
> documentation does not talk about the color, only about which pin is
> on/off. The thing is that if we want to somehow set this mode for the
> LED, it should be represented as one LED class device.
> 
> I want to extend the netdev trigger to support such configuration,
> so that when you have multicolor LED, you will be able to say which
> color should be set for which link mode.

This is getting into the exotic level i don't think we need to
support. How many PHYs have you seen that support something like this?

I suggest we start with simple independent LEDs. That gives enough to
support the majority of use cases people actually need. And is enough
to unblock people who i keep NACKing patches and tell them to wait for
this work to get merged.

     Andrew



