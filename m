Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF4BF45DD45
	for <lists+netdev@lfdr.de>; Thu, 25 Nov 2021 16:22:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356081AbhKYP0A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Nov 2021 10:26:00 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:52190 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231931AbhKYPYA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Nov 2021 10:24:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=0gTqvjQUjjNxDHvgF8Fupxl1PXplc8BHRwL0CZelpQU=; b=s56owq4RZMUMwM06qhbkWD7ODk
        /+ZHl5EBHJnGEcJS9BqD6vnOvVv9UgyE34vxb7smmegwbDHv/anFFl4F+xCRCYu5U47r+RJjocyeN
        /Ul90DX2EXrJPi2N/iBVaM4VPTFQIaGzTKGKM902/efP1JD94qej0Nx1JQLPi3I1cZ0Y=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mqGYG-00EcXT-7O; Thu, 25 Nov 2021 16:20:44 +0100
Date:   Thu, 25 Nov 2021 16:20:44 +0100
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
Message-ID: <YZ+pzFRCB0faDikb@lunn.ch>
References: <cover.1636620754.git.wells.lu@sunplus.com>
 <519b61af544f4c6920012d44afd35a0f8761b24f.1636620754.git.wells.lu@sunplus.com>
 <YY7/v1msiaqJF3Uy@lunn.ch>
 <7cccf9f79363416ca8115a7ed9b1b7fd@sphcmbx02.sunplus.com.tw>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7cccf9f79363416ca8115a7ed9b1b7fd@sphcmbx02.sunplus.com.tw>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Due to hardware design, we still need to set PHY address,
> because MDIO controller of SP7021 only sends out MDIO 
> commands with the same address listed in PHY address 
> registers. The function below needs to be kept.

I suggest you actually set it to some other address. One of the
good/bad things about MDIO is you have no idea if the device is
there. A read to a device which does not exist just returns 0xffff,
not an error. So i would set the address of 0x1f. I've never seen a
PHY actually use that address.

    Andrew
