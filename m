Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F42146D6D74
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 21:52:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236202AbjDDTwh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 15:52:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236180AbjDDTwg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 15:52:36 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03295421A;
        Tue,  4 Apr 2023 12:52:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=/y9frG2WtrKdRepi7ezn+sZjLB5C7uTT0dTfaWYDEmU=; b=x/9inwS78iKQd/grPu0LUEQGES
        6KLBGgh398gZyyYycS4Kwsy2h9C0xXOdKxmRNbHaMe//TnsgZ2TKNHrwg4sWVsiicShbFpGPLWIds
        7o/YU/UlzcVBD6qNcADQNfNN3UVLyM6zTaEYjKwhXwvk2GVlxUBxZTjEDmbwexOY1W8Q=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pjmhS-009RgK-SM; Tue, 04 Apr 2023 21:52:14 +0200
Date:   Tue, 4 Apr 2023 21:52:14 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Pavel Machek <pavel@ucw.cz>
Cc:     Christian Marangi <ansuelsmth@gmail.com>,
        Lee Jones <lee@kernel.org>, Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        John Crispin <john@phrozen.org>, linux-leds@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org
Subject: Re: [net-next PATCH v6 16/16] arm: mvebu: dt: Add PHY LED support
 for 370-rd WAN port
Message-ID: <7cadf888-8d6e-4b7d-8f94-7e869fd49ee2@lunn.ch>
References: <20230327141031.11904-1-ansuelsmth@gmail.com>
 <20230327141031.11904-17-ansuelsmth@gmail.com>
 <ZCKl1A9dZOIAdMY8@duo.ucw.cz>
 <2e5c6dfb-5f55-416f-a934-6fa3997783b7@lunn.ch>
 <ZCsu4qD8k947kN7v@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZCsu4qD8k947kN7v@duo.ucw.cz>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Acceptance criteria would be "consistent with documentation and with
> other similar users". If the LED is really white, it should be
> f1072004.mdio-mii\:white\:WAN, but you probably want
> f1072004.mdio-mii\:white\:LAN (or :activity), as discussed elsewhere in the thread.

Hi Pavel

What i ended up with is:

f1072004.mdio-mii:00:white:wan

The label on the box is WAN, since it is meant to be a WiFi routers,
and this port should connected to your WAN. And this is what the LED
code came up with, given my DT description for this device.

> Documentation is in Documentation/leds/well-known-leds.txt , so you
> should probably add a new section about networking, and explain naming
> scheme for network activity LEDs. When next users appear, I'll point
> them to the documentation.

I added a patch with the following text:

* Ethernet LEDs

Currently two types of Network LEDs are support, those controlled by
the PHY and those by the MAC. In theory both can be present at the
same time for one Linux netdev, hence the names need to differ between
MAC and PHY.

Do not use the netdev name, such as eth0, enp1s0. These are not stable
and are not unique. They also don't differentiate between MAC and PHY.

** MAC LEDs

Good: f1070000.ethernet:white:WAN
Good: mdio_mux-0.1:00:green:left
Good: 0000:02:00.0:yellow:top

The first part must uniquely name the MAC controller. Then follows the
colour.  WAN/LAN should be used for a single LED. If there are
multiple LEDs, use left/right, or top/bottom to indicate their
position on the RJ45 socket.

** PHY LEDs

Good: f1072004.mdio-mii:00: white:WAN
Good: !mdio-mux!mdio@2!switch@0!mdio:01:green:right
Good: r8169-0-200:00:yellow:bottom

The first part must uniquely name the PHY. This often means uniquely
identifying the MDIO bus controller, and the address on the bus.


	Andrew
