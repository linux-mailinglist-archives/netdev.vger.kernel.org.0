Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6424126829A
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 04:28:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726017AbgINC2p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Sep 2020 22:28:45 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:60574 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725983AbgINC2n (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 13 Sep 2020 22:28:43 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kHeES-00EXZp-Nm; Mon, 14 Sep 2020 04:28:40 +0200
Date:   Mon, 14 Sep 2020 04:28:40 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vadym Kochan <vadym.kochan@plvision.eu>
Cc:     netdev@vger.kernel.org, Russell King <linux@armlinux.org.uk>
Subject: Re: [DISCUSS] sfp: sfp controller concept
Message-ID: <20200914022840.GF3463198@lunn.ch>
References: <20200911181914.GB20711@plvision.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200911181914.GB20711@plvision.eu>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 11, 2020 at 09:19:14PM +0300, Vadym Kochan wrote:
> Hi,
> 
> I'd like to discuss a concept of introduction additional entity into SFP
> subsystem called SFP controller. But lets start with the issue.
> 
> Issue
> =====
> 
> There are boards with SFP ports whose GPIO pins are not connected directly to
> the SoC but to the I2C CPLD device which has ability to read/write statuses of
> each SFP via I2C read/write commands.

> 
> Of course there is already a solution - implement GPIO chip and convert GPIO
> numbers & states into internal representation (I2C registers). But it requires
> additional GPIO-related handling like:
> 
> 1) Describe GPIO pins and IN/OUT mapping in DTS
> 
> 2) Consider this mapping also in CPLD driver
> 
> 3) IRQ - for me this is not clear how to simulate
>    sending IRQ via GPIO chip.

Hi Vadym

I2C GPIO expanders do work O.K. for this use case. See for example
vf610-zii-dev-rev-c.dts. It has a semtech,sx1503q expander. And the
two SFF on that board are connected to it. The sx1503q can generate an
interrupt when one of its inputs changes state. But for the SFP core,
that is optional, it can also poll the GPIOs if interrupts are not
supported.

	Andrew
