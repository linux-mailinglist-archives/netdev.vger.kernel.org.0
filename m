Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4349F1B0F58
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 17:10:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730083AbgDTPKX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 11:10:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726905AbgDTPKW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Apr 2020 11:10:22 -0400
Received: from ssl.serverraum.org (ssl.serverraum.org [IPv6:2a01:4f8:151:8464::1:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9BE0C061A0C;
        Mon, 20 Apr 2020 08:10:22 -0700 (PDT)
Received: from ssl.serverraum.org (web.serverraum.org [172.16.0.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 5491423058;
        Mon, 20 Apr 2020 17:10:20 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1587395421;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0ltuHb7l1+7HEhaCHMWAHJsVLlBWvFM9cUwwU6Q/+H8=;
        b=GXh55I+p1XeHFEEJ6lgxqTmXqMK/e3uuEU+gkGUFZobafGr56JCOwSt3Ejd2lU/MFAVeNe
        zF9AjRTaLC3ZhH6pvE07AhQcKnziOrFttyI5FSynVv5TDOORoeDisFYhDCf/1KAvvcTqnp
        hiS2S5vSYapB9uU8mmb0/8a4s2CVQg4=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 20 Apr 2020 17:10:19 +0200
From:   Michael Walle <michael@walle.cc>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     linux-hwmon@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Jean Delvare <jdelvare@suse.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next 3/3] net: phy: bcm54140: add hwmon support
In-Reply-To: <20200419215549.GR836632@lunn.ch>
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
 <20200419215549.GR836632@lunn.ch>
Message-ID: <75428c5faab7fc656051ab227663e6e6@walle.cc>
X-Sender: michael@walle.cc
User-Agent: Roundcube Webmail/1.3.10
X-Spamd-Bar: +
X-Spam-Level: *
X-Rspamd-Server: web
X-Spam-Status: No, score=1.40
X-Spam-Score: 1.40
X-Rspamd-Queue-Id: 5491423058
X-Spamd-Result: default: False [1.40 / 15.00];
         FROM_HAS_DN(0.00)[];
         TO_DN_SOME(0.00)[];
         FREEMAIL_ENVRCPT(0.00)[gmail.com];
         TO_MATCH_ENVRCPT_ALL(0.00)[];
         TAGGED_RCPT(0.00)[];
         MIME_GOOD(-0.10)[text/plain];
         DKIM_SIGNED(0.00)[];
         RCPT_COUNT_SEVEN(0.00)[10];
         NEURAL_HAM(-0.00)[-0.969];
         RCVD_COUNT_ZERO(0.00)[0];
         FROM_EQ_ENVFROM(0.00)[];
         MIME_TRACE(0.00)[0:+];
         FREEMAIL_CC(0.00)[vger.kernel.org,suse.com,roeck-us.net,gmail.com,armlinux.org.uk,davemloft.net];
         MID_RHS_MATCH_FROM(0.00)[];
         SUSPICIOUS_RECIPS(1.50)[]
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

Am 2020-04-19 23:55, schrieb Andrew Lunn:
>> But what does that have to do with the shared structure? I don't think
>> you have to "bundle" the shared structure with the "access the global
>> registers" method.
> 
> We don't need to. But it would be a good way to clean up code which
> locks the mdio bus, does a register access on some other device, and
> then unlocks the bus.

I'd like do an RFC for that. But how should I proceed with the original
patch series? Should I send an updated version; you didn't reply to the
LED stuff. That is the last remark for now.

> As a general rule of thumb, it is better to have the core do the
> locking, rather than the driver. Driver writers don't always think
> about locking, so it is better to give driver writers safe APIs to
> use.

Ok I see, but what locking do you have in mind? We could have something
like

__phy_package_write(struct phy_device *dev, u32 regnum, u16 val)
{
   return __mdiobus_write(phydev->mdio.bus, phydev->shared->addr,
                          regnum, val);
}

and its phy_package_write() equivalent. But that would just be
convenience functions, nothing where you actually help the user with
locking. Am I missing something?

>>> Get the core to do reference counting on the structure?
>>> Add helpers phy_read_shared(), phy_write_shared(), etc, which does
>>> MDIO accesses on the base device, taking care of the locking.
>>> 
>> The "base" access is another thing, I guess, which has nothing to do
>> with the shared structure.
>> 
> I'm making the assumption that all global addresses are at the base
> address. If we don't want to make that assumption, we need the change
> the API above so you pass a cookie, and all PHYs need to use the same
> cookie to identify the package.

how would a phy driver deduce a common cookie? And how would that be a
difference to using a PHY address.

> Maybe base is the wrong name, since MSCC can have the base as the high
> address of the four, not the low?

I'd say it might be any of the four addresses as long as it is the same
across the PHYs in the same package. And in that case you can also have
the phy_package_read/write() functions.

-michael
