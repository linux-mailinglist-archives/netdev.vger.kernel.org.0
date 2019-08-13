Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E32988BE8C
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 18:28:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728337AbfHMQ2b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 12:28:31 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:57428 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726802AbfHMQ2a (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Aug 2019 12:28:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=34xmiKyA+S2CnLiX+X01d9OYLI0FKAIfY0fTPpCykWA=; b=M2pxP3v7ZshqK85Je7x+dbWUDm
        gxNV75ZSQPGztbD8bG/EuMu4F6qG1HNmClshOwJSKUmqZ9lVWwKr3K8h3H7oKKfiL6eLI7swNXFmw
        fbzWY3nPFC6F4wOZU30iLPbeK924YNUsZUNg8vXkGzm5H5jrkH3+uobUJbxuVN3aa1VU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hxZep-0002tK-VK; Tue, 13 Aug 2019 18:28:23 +0200
Date:   Tue, 13 Aug 2019 18:28:23 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Igor Russkikh <Igor.Russkikh@aquantia.com>
Cc:     Antoine Tenart <antoine.tenart@bootlin.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "sd@queasysnail.net" <sd@queasysnail.net>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "thomas.petazzoni@bootlin.com" <thomas.petazzoni@bootlin.com>,
        "alexandre.belloni@bootlin.com" <alexandre.belloni@bootlin.com>,
        "allan.nielsen@microchip.com" <allan.nielsen@microchip.com>,
        "camelia.groza@nxp.com" <camelia.groza@nxp.com>,
        Simon Edelhaus <Simon.Edelhaus@aquantia.com>,
        Pavel Belous <Pavel.Belous@aquantia.com>
Subject: Re: [PATCH net-next v2 6/9] net: macsec: hardware offloading
 infrastructure
Message-ID: <20190813162823.GH15047@lunn.ch>
References: <20190808140600.21477-1-antoine.tenart@bootlin.com>
 <20190808140600.21477-7-antoine.tenart@bootlin.com>
 <e96fa4ae-1f2c-c1be-b2d8-060217d8e151@aquantia.com>
 <20190813085817.GA3200@kwain>
 <20190813131706.GE15047@lunn.ch>
 <2e3c2307-d414-a531-26cb-064e05fa01fc@aquantia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2e3c2307-d414-a531-26cb-064e05fa01fc@aquantia.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> 1) With current implementation it's impossible to install SW macsec engine onto
> the device which supports HW offload. That could be a strong limitation in
> cases when user sees HW macsec offload is broken or work differently, and he/she
> wants to replace it with SW one.
> MACSec is a complex feature, and it may happen something is missing in HW.
> Trivial example is 256bit encryption, which is not always a musthave in HW
> implementations.

Ideally, we want the driver to return EOPNOTSUPP if it does not
support something and the software implement should be used.

If the offload is broken, we want a bug report! And if it works
differently, it suggests there is also a bug we need to fix, or the
standard is ambiguous.

It would also be nice to add extra information to the netlink API to
indicate if HW or SW is being used. In other places where we offload
to accelerators we have such additional information.

   Andrew
