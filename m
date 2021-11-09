Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C8C344B478
	for <lists+netdev@lfdr.de>; Tue,  9 Nov 2021 22:09:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244907AbhKIVMd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Nov 2021 16:12:33 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:53414 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237584AbhKIVMc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Nov 2021 16:12:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=fqMfvevUL4ukmxtHDYzE4N3EIZqfBJykGBfoMdASPoc=; b=EdA5Rkfs5/ZsHFfhINZIQ6inmE
        xr1hE5zxYp/zcr/mb/MlKKxMvBKAMm70zb3zyoSaTLgp9SOqvO0KpwXMF0UY/0RRJESp2k7eXNYkj
        AyX/Zjkebe7biSqDhYgH9WnC07Rmh9jiajIC5nKERkr+8B2iqgTypBC6Tv5PekdX7bnE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mkYNA-00D1Wk-AZ; Tue, 09 Nov 2021 22:09:40 +0100
Date:   Tue, 9 Nov 2021 22:09:40 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     Ansuel Smith <ansuelsmth@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, Pavel Machek <pavel@ucw.cz>,
        John Crispin <john@phrozen.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-leds@vger.kernel.org
Subject: Re: [RFC PATCH v3 6/8] leds: trigger: add hardware-phy-activity
 trigger
Message-ID: <YYrjlHz/UgTUwQAm@lunn.ch>
References: <20211109022608.11109-1-ansuelsmth@gmail.com>
 <20211109022608.11109-7-ansuelsmth@gmail.com>
 <20211109042517.03baa809@thinkpad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211109042517.03baa809@thinkpad>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > +/* Expose sysfs for every blink to be configurable from userspace */
> > +DEFINE_OFFLOAD_TRIGGER(blink_tx, BLINK_TX);
> > +DEFINE_OFFLOAD_TRIGGER(blink_rx, BLINK_RX);
> > +DEFINE_OFFLOAD_TRIGGER(keep_link_10m, KEEP_LINK_10M);
> > +DEFINE_OFFLOAD_TRIGGER(keep_link_100m, KEEP_LINK_100M);
> > +DEFINE_OFFLOAD_TRIGGER(keep_link_1000m, KEEP_LINK_1000M);

You might get warnings about CamelCase, but i suggest keep_link_10M,
keep_link_100M and keep_link_1000M. These are megabits, not millibits.

> > +DEFINE_OFFLOAD_TRIGGER(keep_half_duplex, KEEP_HALF_DUPLEX);
> > +DEFINE_OFFLOAD_TRIGGER(keep_full_duplex, KEEP_FULL_DUPLEX);

What does keep mean in this context?

> > +DEFINE_OFFLOAD_TRIGGER(option_linkup_over, OPTION_LINKUP_OVER);
> > +DEFINE_OFFLOAD_TRIGGER(option_power_on_reset, OPTION_POWER_ON_RESET);
> > +DEFINE_OFFLOAD_TRIGGER(option_blink_2hz, OPTION_BLINK_2HZ);
> > +DEFINE_OFFLOAD_TRIGGER(option_blink_4hz, OPTION_BLINK_4HZ);
> > +DEFINE_OFFLOAD_TRIGGER(option_blink_8hz, OPTION_BLINK_8HZ);
> 
> This is very strange. Is option_blink_2hz a trigger on itself? Or just
> an option for another trigger? It seems that it is an option, so that I
> can set something like
>   blink_tx,option_blink_2hz
> and the LED will blink on tx activity with frequency 2 Hz... If that is
> so, I think you are misnaming your macros or something, since you are
> defining option_blink_2hz as a trigger with
>  DEFINE_OFFLOAD_TRIGGER

Yes, i already said this needs handling differently. The 2Hz, 4Hz and
8Hz naturally fit the delay_on, delay_of sysfs attributes.

    Andrew
