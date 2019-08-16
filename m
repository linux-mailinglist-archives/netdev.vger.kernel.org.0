Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 53780902F5
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 15:26:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727336AbfHPN0Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Aug 2019 09:26:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60822 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726981AbfHPN0Y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Aug 2019 09:26:24 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 11CF630833C1;
        Fri, 16 Aug 2019 13:26:24 +0000 (UTC)
Received: from bistromath.localdomain (ovpn-116-43.ams2.redhat.com [10.36.116.43])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6871480C8;
        Fri, 16 Aug 2019 13:26:21 +0000 (UTC)
Date:   Fri, 16 Aug 2019 15:26:19 +0200
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Igor Russkikh <Igor.Russkikh@aquantia.com>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
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
Message-ID: <20190816132619.GB8697@bistromath.localdomain>
References: <20190808140600.21477-1-antoine.tenart@bootlin.com>
 <20190808140600.21477-7-antoine.tenart@bootlin.com>
 <e96fa4ae-1f2c-c1be-b2d8-060217d8e151@aquantia.com>
 <20190813085817.GA3200@kwain>
 <20190813131706.GE15047@lunn.ch>
 <2e3c2307-d414-a531-26cb-064e05fa01fc@aquantia.com>
 <20190813162823.GH15047@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190813162823.GH15047@lunn.ch>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.44]); Fri, 16 Aug 2019 13:26:24 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2019-08-13, 18:28:23 +0200, Andrew Lunn wrote:
> > 1) With current implementation it's impossible to install SW macsec engine onto
> > the device which supports HW offload. That could be a strong limitation in
> > cases when user sees HW macsec offload is broken or work differently, and he/she
> > wants to replace it with SW one.
> > MACSec is a complex feature, and it may happen something is missing in HW.
> > Trivial example is 256bit encryption, which is not always a musthave in HW
> > implementations.
> 
> Ideally, we want the driver to return EOPNOTSUPP if it does not
> support something and the software implement should be used.
> 
> If the offload is broken, we want a bug report! And if it works
> differently, it suggests there is also a bug we need to fix, or the
> standard is ambiguous.

Yes. But in the meantime, we want the user to be able to disable the
offload. It's helpful for debugging purposes, and it can provide some
level of functionality until the bug is fixed or non-buggy hardware
becomes available.

> It would also be nice to add extra information to the netlink API to
> indicate if HW or SW is being used. In other places where we offload
> to accelerators we have such additional information.

+1

-- 
Sabrina
