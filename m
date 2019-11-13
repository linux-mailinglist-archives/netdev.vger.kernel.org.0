Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76969FB1FB
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 14:59:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727460AbfKMN72 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Nov 2019 08:59:28 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:38130 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726186AbfKMN72 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Nov 2019 08:59:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=5hxUuH5ckl8wDfr4jKXVzkWhwFVJaJSyi5oNLQqtJik=; b=nZY0H+56XRgSdZ+OMefcUDf513
        TleYrLqiP2SXG8HoSggQGSuMX541iK+cP3zvSyphaXsU6JbIOKDNE9MuWKjFYYnezpIKNyViFgAoD
        2Id2HGW9DHAilFNzJJNZU1ucEm1Tkfc2he1XMGv4E7O6IfGgRRiYzxJO7xqled7LtJFk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iUtB7-0007Op-0P; Wed, 13 Nov 2019 14:59:25 +0100
Date:   Wed, 13 Nov 2019 14:59:25 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Adrian Pop <popadrian1996@gmail.com>
Cc:     netdev@vger.kernel.org, linville@tuxdriver.com
Subject: Re: [PATCH] ethtool: Add QSFP-DD support
Message-ID: <20191113135925.GB27785@lunn.ch>
References: <20191109124205.11273-1-popadrian1996@gmail.com>
 <20191109153355.GK22978@lunn.ch>
 <CAL_jBfQhVAy24xbz_VbpPM0QtRu-Uzawhyn=AY0b41B9=v3Ytg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL_jBfQhVAy24xbz_VbpPM0QtRu-Uzawhyn=AY0b41B9=v3Ytg@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 13, 2019 at 12:56:51PM +0000, Adrian Pop wrote:
> Hi Andrew!
> 
> Thank you for your email. At the moment, there are no in-kernel drivers that
> require this support (the 1st version of the Common Management Interface
> Specification for the QSFP-DD 8X pluggable transceivers came out this year in
> May [0]). I first came across implementing this extra functionality to ethtool
> at my company, where we use a custom driver for a NIC that works with the new
> QSFP-DD transceivers. All the ethtool readings for QSFP-DD were correct and I
> can provide a sample if needed. Another example of somebody putting QSFP-DD
> support in their products is Exablaze with their ExaNIC [1] and I'm sure that
> with time there will be more. Unfortunately at the moment I'm not able to
> provide help with an update on the mainline driver in the kernel.
> 
> I know that ETH_MODULE_SFF_8436_MAX_LEN is 640 bytes, but to provide for
> QSFP-DD all the stats as for QSFP (basically to maintain the same behavior/
> functionality), we came to the conclusion that we need to read more pages than
> before, since the memory map is different and the data is more spread around.
> 
> Please let me know if you have any other feedback and/or suggestions for the
> patch.

Hi Adrian

You are defining a kernel API here. It is very unusual to define a
KAPI without the mainline kernel actually implementing it. So in my
opinion, we need an in kernel implementation first.

I guess you are not going to mainline your driver? The ExaNIC is also
a long way from being mainline'able.

Could i suggest you extend drivers/net/phy/sfp.c to support QSFP-DD?
Or maybe one of Intels or Mellanox drivers? Basically, any hardware
with an in kernel driver you can get your hands on and test. Maybe you
already have something which you use of interoperability testing.

     Andrew
