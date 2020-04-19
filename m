Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62B311AFE7A
	for <lists+netdev@lfdr.de>; Sun, 19 Apr 2020 23:56:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726117AbgDSVzy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Apr 2020 17:55:54 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:49042 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725848AbgDSVzx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 19 Apr 2020 17:55:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=j46L+tn/U2w9KaKzwAJtWpSSbKCNxNLhJe4DrV1FHzA=; b=wjzgc90gDM3LyszNv3KxFSqR9Y
        U/nBQdqgMv5h6YLPaM9tpkFAkQgEevPjZPs21m5YYFyDi1u1gAR2WfwyEoAgYgUrYm02uQzEJfLQq
        grfldMBY+w8IoAXrq1AWPmkIYh4Db1+EU8Isc4Mqz0MRau8ZZQ3d54jAmAGONP13tlGs=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jQHun-003hht-BS; Sun, 19 Apr 2020 23:55:49 +0200
Date:   Sun, 19 Apr 2020 23:55:49 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michael Walle <michael@walle.cc>
Cc:     linux-hwmon@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Jean Delvare <jdelvare@suse.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next 3/3] net: phy: bcm54140: add hwmon support
Message-ID: <20200419215549.GR836632@lunn.ch>
References: <20200417195003.GG785713@lunn.ch>
 <35d00dfe1ad24b580dc247d882aa2e39@walle.cc>
 <20200417201338.GI785713@lunn.ch>
 <84679226df03bdd8060cb95761724d3a@walle.cc>
 <20200417212829.GJ785713@lunn.ch>
 <4f3ff33f78472f547212f87f75a37b66@walle.cc>
 <20200419162928.GL836632@lunn.ch>
 <ebc026792e09d5702d031398e96d34f2@walle.cc>
 <20200419170547.GO836632@lunn.ch>
 <0f7ea4522a76f977f3aa3a80dd62201d@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0f7ea4522a76f977f3aa3a80dd62201d@walle.cc>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> But what does that have to do with the shared structure? I don't think
> you have to "bundle" the shared structure with the "access the global
> registers" method.

We don't need to. But it would be a good way to clean up code which
locks the mdio bus, does a register access on some other device, and
then unlocks the bus.

As a general rule of thumb, it is better to have the core do the
locking, rather than the driver. Driver writers don't always think
about locking, so it is better to give driver writers safe APIs to
use.

	Andrew

