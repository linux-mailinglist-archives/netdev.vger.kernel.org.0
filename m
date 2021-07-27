Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0EDD3D7791
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 15:55:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232457AbhG0NzR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 09:55:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:50768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232314AbhG0NzQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Jul 2021 09:55:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9C36161220;
        Tue, 27 Jul 2021 13:55:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627394116;
        bh=r9Ehp4FfQF7Ry5rGGdla1pRbvCkTzIIe34SMTERdObQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=tLxD0EQCwjABQSMiNKxgRYy9KCkP95Ydc+VCMvnRhsVI8qF+H33MDE5QobYrwUDNa
         +jjp2s8duvSDqLOnb/DwkJ8Qr3e0ocwqm/DiH3qXK8C2o+iii/xoYa/rb21WT6B7V8
         cZga3W+WbfvW6zoM0erRpaQjs5egu9Trag8yMhY9KdCkIt31AKMqLFiNcASxE+Opva
         qpchHVz1mBgXGIqypUAqXNhcmqMiaNyb5oGCVE3MMGyUvBLE1JPNbuJ1rPC+ScZZ34
         UG3JaO+U+eQpZIYh9bSXC9enOFSDou4J2GRfLXRxIIk1FUAMVi++uPEfYhtCbc1MX2
         g8iKJ5JI6UjJA==
Date:   Tue, 27 Jul 2021 15:55:10 +0200
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        Pavel Machek <pavel@ucw.cz>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>, davem@davemloft.net,
        kuba@kernel.org, Kurt Kanzenbach <kurt@linutronix.de>,
        netdev@vger.kernel.org, sasha.neftin@intel.com,
        vitaly.lifshits@intel.com, vinicius.gomes@intel.com,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>,
        "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>
Subject: Re: [PATCH net-next 5/5] igc: Export LEDs
Message-ID: <20210727155510.256e5fcc@thinkpad>
In-Reply-To: <YP9n+VKcRDIvypes@lunn.ch>
References: <YPTKB0HGEtsydf9/@lunn.ch>
        <88d23db8-d2d2-5816-6ba1-3bd80738c398@gmail.com>
        <YPbu8xOFDRZWMTBe@lunn.ch>
        <3b7ad100-643e-c173-0d43-52e65d41c8c3@gmail.com>
        <20210721204543.08e79fac@thinkpad>
        <YPh6b+dTZqQNX+Zk@lunn.ch>
        <20210721220716.539f780e@thinkpad>
        <4d8db4ce-0413-1f41-544d-fe665d3e104c@gmail.com>
        <6d2697b1-f0f6-aa9f-579c-48a7abb8559d@gmail.com>
        <20210727020619.2ba78163@thinkpad>
        <YP9n+VKcRDIvypes@lunn.ch>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

On Tue, 27 Jul 2021 03:57:13 +0200
Andrew Lunn <andrew@lunn.ch> wrote:

> > The last time we discussed this (Andrew, Pavel and I), we've decided
> > that for ethernet PHY controlled LEDs we want the devicename part
> > should be something like
> >    phyN  or  ethphyN  or  ethernet-phyN
> > with N a number unique for every PHY (a simple atomically increased
> > integer for every ethernet PHY).  
> 
> We might want to rethink this. PHYs typically have 2 or 3 LEDs. So we
> want a way to indicate which LED of a PHY it is. So i suspect we will
> want something like
> 
> ethphyN-led0, ethphyN-led1, ethphyN-led2.

But... there is still color and function and possibly function-numerator
to differentiate them. I was talking only about the devicename part. So
for three LEDs you can have, for example:
  ethphyN:green:link
  ethphyN:yellow:activity
Even if you don't have information about color, the default function
(on chip reset) should be different. And even if it is not, the
function enumerator would fix this:
  ethphyN::link-1
  ethphyN::link-2

Marek
