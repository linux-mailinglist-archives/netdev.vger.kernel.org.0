Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4055412685
	for <lists+netdev@lfdr.de>; Mon, 20 Sep 2021 20:58:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355149AbhITS7j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Sep 2021 14:59:39 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:50810 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1354075AbhITS5V (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Sep 2021 14:57:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=jcJ8+PGAESQtnEaep3beg72gC2wG3+PVTH5vzFcM5i4=; b=eRycXmW08DR9G2IcUuJDYtWoZS
        v336b1hI4iAwdh92tguEJztRrWMnqS+zBIZwPiliqeNN39kyktDjm/XzQ9aKJVb9aralydZEb0Ys/
        QIb3BeQzdT6hq1Wb+S0Z7Et/Mm9XVmCa+qro3tt+g+blCZAXy7crYdzTMtGJ346F+dO8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mSOSC-007X3b-MK; Mon, 20 Sep 2021 20:55:48 +0200
Date:   Mon, 20 Sep 2021 20:55:48 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [net-next RFC PATCH 1/2] drivers: net: dsa: qca8k: add support
 for led config
Message-ID: <YUjZNA1Swo6Bv3/Q@lunn.ch>
References: <20210920180851.30762-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210920180851.30762-1-ansuelsmth@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 20, 2021 at 08:08:50PM +0200, Ansuel Smith wrote:
> Add support for led control and led toggle.
> qca8337 and qca8327 switch have various reg to control port leds.
> The current implementation permit to toggle them on/off and to declare
> their blink rules based on the entry in the dts.
> They can also be declared in userspace by the "control_rule" entry in
> the led sysfs. When hw_mode is active (set by default) the leds blink
> based on the control_rule. There are 6 total control rule.
> Control rule that applies to phy0-3 commonly used for lan port.
> Control rule that applies to phy4 commonly used for wan port.
> Each phy port (5 in total) can have a maximum of 3 different leds
> attached. Each led can be turned off, blink at 4hz, off or set to
> hw_mode and follow their respecitve control rule. The hw_mode can be
> toggled using the sysfs entry and will be disabled on brightness or
> blink set.

Hi Ansuel

It is great you are using the LED subsystem for this. But we need to
split the code up into a generic part which can shared by any
switch/PHY and a driver specific part.

There has been a lot of discussion on the list about this. Maybe you
can help get us to a generic solution which can be used by everybody.

    Andrew
