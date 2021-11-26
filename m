Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC49445F386
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 19:09:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239217AbhKZSMY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Nov 2021 13:12:24 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:53922 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239453AbhKZSKW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Nov 2021 13:10:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=V7nt6++xF+JkbGcSSs0/FlS22HkeHHtA60Ftrs6BEeo=; b=1S
        fHiiRJ7isrKAFBA+5Pt85pY5wIUTD7mT8F2/TulYh/xGZR0wjx7Bp3lI2GhMbsTsqA/aYZzmVMb7p
        HruySqLKh8crijT7q+3hpsGuWH/Z9jOAuhrKnvRPdtEEnUC4WmuqAJ0ek896iHocstSkoodE0NW/7
        euVTi0zQmU8RX4M=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mqfck-00EiaD-QZ; Fri, 26 Nov 2021 19:07:02 +0100
Date:   Fri, 26 Nov 2021 19:07:02 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Wells Lu =?utf-8?B?5ZGC6Iqz6aiw?= <wells.lu@sunplus.com>
Cc:     Wells Lu <wellslutw@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "p.zabel@pengutronix.de" <p.zabel@pengutronix.de>,
        Vincent Shih =?utf-8?B?5pa96YyV6bS7?= 
        <vincent.shih@sunplus.com>
Subject: Re: [PATCH v2 2/2] net: ethernet: Add driver for Sunplus SP7021
Message-ID: <YaEiRt+vqt1Ix8xb@lunn.ch>
References: <cover.1636620754.git.wells.lu@sunplus.com>
 <519b61af544f4c6920012d44afd35a0f8761b24f.1636620754.git.wells.lu@sunplus.com>
 <YY7/v1msiaqJF3Uy@lunn.ch>
 <7cccf9f79363416ca8115a7ed9b1b7fd@sphcmbx02.sunplus.com.tw>
 <YZ+pzFRCB0faDikb@lunn.ch>
 <6c1ce569d2dd46eba8d4b0be84d6159b@sphcmbx02.sunplus.com.tw>
 <YaDxc2+HKUYxsmX4@lunn.ch>
 <38e40bc4c0de409ca959bcb847c1fc96@sphcmbx02.sunplus.com.tw>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <38e40bc4c0de409ca959bcb847c1fc96@sphcmbx02.sunplus.com.tw>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 26, 2021 at 04:12:46PM +0000, Wells Lu 呂芳騰 wrote:
> Hi Andrew,
> 
> 
> From data provided by ASIC engineer, MAC of SP7021 only
> reads the 4 registers of PHY:
> 0: Control register
> 1: Status register

This is the register which has latching of the link
status. genphy_update_link() expects this latching behaviour, and if
the hardware reads the register, that behaviour is not going to
happen.

	Andrew
