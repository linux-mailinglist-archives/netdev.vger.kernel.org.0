Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C14BB4126CC
	for <lists+netdev@lfdr.de>; Mon, 20 Sep 2021 21:21:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230272AbhITTWt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Sep 2021 15:22:49 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:50858 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245388AbhITTUp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Sep 2021 15:20:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=TkN2Ia7bums+Ijew637ZfATCHcWZLf84rC4MSNogrQc=; b=zfVXbzPogWtzueEw5yX5NKNkwJ
        ZsvdtMjs25dfU6fsCVGbwZbV4U5pTiodfR9l8f1S0AfR++CK7+y8zgi5CPDLHE/vCW2KYaNBteUSE
        HzBIPdT6P6IA0/h1oh+MuAk1cSeR5L5uqloHR8Xw+pIr10eME5OGE1TEh7QxzJmja8c0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mSOor-007XDO-1m; Mon, 20 Sep 2021 21:19:13 +0200
Date:   Mon, 20 Sep 2021 21:19:13 +0200
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
Message-ID: <YUjesc5nLItkUNxy@lunn.ch>
References: <20210920180851.30762-1-ansuelsmth@gmail.com>
 <YUjZNA1Swo6Bv3/Q@lunn.ch>
 <YUja1JsFJNwh8hXr@Ansuel-xps.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YUja1JsFJNwh8hXr@Ansuel-xps.localdomain>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Yes, can you point me to the discussion?

It has gone through many cycles :-(

The linux-led list is probably the better archive to look through, it
is a lot lower volume than netdev.

https://www.spinics.net/lists/linux-leds/msg18652.html

https://www.spinics.net/lists/linux-leds/msg18527.html


> I post this as RFC for this exact reason... I read somehwere that there
> was a discussion on how to implementd leds for switch but never ever
> found it.

Most of the discussion so far has been about PHY LEDs, where the PHY
driver controls the LEDs. However some Ethernet switches also have LED
controls, which are not part of the PHY. And then there are some MAC
drivers which control the PHY in firmware, and have firmware calls for
controlling the LEDs. We need a generic solution which scales across
all this. And it needs to work without DT, or at least, not block ACPI
being added later.

But progress is slow. I hope that the PHY use case will drive things
forward, get the ABI defined. We can then scale it out to include
switches, maybe with a bit of code refactoring.

	  Andrew
