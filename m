Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5114245F540
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 20:34:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238462AbhKZTiA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Nov 2021 14:38:00 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:54010 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230376AbhKZTf7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Nov 2021 14:35:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=c/8sOzv020CXclteJsgS2hcB1lLfRSyiK7Dp8TTyBFM=; b=AK
        BRunmA97gXuEtGZM7SGnlyp7ZhSW5LIX4NMqmK6mjLqQiDCoVCoUIaNKHrU/DnqlS/ykVjisHpKgB
        hqK65SgWwm9pWxWcnS2Dpre5FKZN0CQyJbAow5SHbTEP7U/grsf+t1KDrqas0BnmXZF0HdlOhRGRl
        TsC57zxbglUcYco=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mqgxc-00Eivm-FB; Fri, 26 Nov 2021 20:32:40 +0100
Date:   Fri, 26 Nov 2021 20:32:40 +0100
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
Message-ID: <YaE2WJibNCQAHBwz@lunn.ch>
References: <cover.1636620754.git.wells.lu@sunplus.com>
 <519b61af544f4c6920012d44afd35a0f8761b24f.1636620754.git.wells.lu@sunplus.com>
 <YY7/v1msiaqJF3Uy@lunn.ch>
 <7cccf9f79363416ca8115a7ed9b1b7fd@sphcmbx02.sunplus.com.tw>
 <YZ+pzFRCB0faDikb@lunn.ch>
 <6c1ce569d2dd46eba8d4b0be84d6159b@sphcmbx02.sunplus.com.tw>
 <YaDxc2+HKUYxsmX4@lunn.ch>
 <38e40bc4c0de409ca959bcb847c1fc96@sphcmbx02.sunplus.com.tw>
 <YaEiRt+vqt1Ix8xb@lunn.ch>
 <b41b754050a14c598b723825ab277322@sphcmbx02.sunplus.com.tw>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b41b754050a14c598b723825ab277322@sphcmbx02.sunplus.com.tw>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 26, 2021 at 07:13:23PM +0000, Wells Lu 呂芳騰 wrote:
> Hi Andrew,
> 
> I read specification of ICPlus IP101G (10M/100M PHY).
> Bits of register 0 (control) and register 1 (status) 
> are R/W or RO type. They will not be cleared after 
> read. No matter how many times they are read, the 
> read-back value is the same.

Please read 802.3,

Section 22.2.4.2: Status register (Register 1)

Table 22-8 Status register bit definitions

Bit 1.2 Link Status is marked as RO/LL, meaning read only Latching
low.

> Can we go with this approach?

You need to not make any read on the PHY which Linux is driving.
Configure the hardware to read on an address where there is no PHY.

	Andrew
