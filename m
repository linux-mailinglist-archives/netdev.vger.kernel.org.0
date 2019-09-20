Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4B6EB97A8
	for <lists+netdev@lfdr.de>; Fri, 20 Sep 2019 21:13:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393257AbfITTN4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Sep 2019 15:13:56 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:57884 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390701AbfITTNz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Sep 2019 15:13:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=j6aeJv8FCQ1P8z8CISAfuVxQoFXejEKFHklHhWZXL94=; b=vRbwoE9GJJ7K+biRw5TBYh8SKR
        NR+0iX4ps/HGiBhTXyIrZJngJFAKe7h7+dh0j9gZ2Ie2pKxXQeIVos3TwG6FUkPf1z9hvZAn0MdO6
        cN/l+hdUSdJ7E+HPMs0Dtff+XuNNE19aQ4vgsCvdN/8tNOAtaj9JWuS9GcKZp8YOT+tI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1iBOLm-00076a-OK; Fri, 20 Sep 2019 21:13:50 +0200
Date:   Fri, 20 Sep 2019 21:13:50 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Markus Elfring <Markus.Elfring@web.de>
Cc:     netdev@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 2/2] net/phy/mdio-mscc-miim: Move the setting of mii_bus
 structure members in mscc_miim_probe()
Message-ID: <20190920191350.GI3530@lunn.ch>
References: <189ccfc3-d5a6-79fd-29b8-1f7140e9639a@web.de>
 <fe3ecdd2-a011-e4ed-5ef2-c3a8a02b343c@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <fe3ecdd2-a011-e4ed-5ef2-c3a8a02b343c@web.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 20, 2019 at 09:03:57PM +0200, Markus Elfring wrote:
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Fri, 20 Sep 2019 20:42:42 +0200
> 
> Move the modification of some members in the data structure “mii_bus”
> for the local variable “bus” directly before the call of
> the function “of_mdiobus_register” so that this change will be performed
> only after previous resource allocations succeeded.

Hi Markus

I'm not sure it is worth making this change. The resource allocations
succeeds 99.9999% of the time. It is a chunk of MMIO, not some gpio,
or i2c device which might give us EPROBE_DEFERRED. So we are not
wasting anything in reality.

	Andrew
