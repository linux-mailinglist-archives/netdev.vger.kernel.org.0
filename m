Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4FDC1AFC1B
	for <lists+netdev@lfdr.de>; Sun, 19 Apr 2020 18:47:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726729AbgDSQrd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Apr 2020 12:47:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725793AbgDSQrd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Apr 2020 12:47:33 -0400
Received: from ssl.serverraum.org (ssl.serverraum.org [IPv6:2a01:4f8:151:8464::1:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 101CAC061A0C;
        Sun, 19 Apr 2020 09:47:33 -0700 (PDT)
Received: from ssl.serverraum.org (web.serverraum.org [172.16.0.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id CD1D023059;
        Sun, 19 Apr 2020 18:47:30 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1587314851;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=X5Lq9CuvSC4Dq2s5AcEVgmb8Ojr37XvEcpZUqSG+/R0=;
        b=sZYcqRFcZObp1IsyRDDmJUvQPuSWf0VvAnWSUnZaYXFfX+N9rvBiHHoBXk1oSGX8Vrq6HK
        l2wT3NlWfsu67Mne/ig55oUd4p+qp1iNGGfGzGpIlmb6b65YspXoHwsGmO41sTcQTsLinc
        0U6IWmZDlGvyszO/z2UCCcYzONV5Ac4=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Sun, 19 Apr 2020 18:47:30 +0200
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
In-Reply-To: <20200419162928.GL836632@lunn.ch>
References: <20200417192858.6997-1-michael@walle.cc>
 <20200417192858.6997-3-michael@walle.cc> <20200417195003.GG785713@lunn.ch>
 <35d00dfe1ad24b580dc247d882aa2e39@walle.cc>
 <20200417201338.GI785713@lunn.ch>
 <84679226df03bdd8060cb95761724d3a@walle.cc>
 <20200417212829.GJ785713@lunn.ch>
 <4f3ff33f78472f547212f87f75a37b66@walle.cc>
 <20200419162928.GL836632@lunn.ch>
Message-ID: <ebc026792e09d5702d031398e96d34f2@walle.cc>
X-Sender: michael@walle.cc
User-Agent: Roundcube Webmail/1.3.10
X-Spamd-Bar: +
X-Spam-Level: *
X-Rspamd-Server: web
X-Spam-Status: No, score=1.40
X-Spam-Score: 1.40
X-Rspamd-Queue-Id: CD1D023059
X-Spamd-Result: default: False [1.40 / 15.00];
         FROM_HAS_DN(0.00)[];
         TO_DN_SOME(0.00)[];
         FREEMAIL_ENVRCPT(0.00)[gmail.com];
         TO_MATCH_ENVRCPT_ALL(0.00)[];
         TAGGED_RCPT(0.00)[];
         MIME_GOOD(-0.10)[text/plain];
         DKIM_SIGNED(0.00)[];
         RCPT_COUNT_SEVEN(0.00)[10];
         NEURAL_HAM(-0.00)[-0.970];
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

Am 2020-04-19 18:29, schrieb Andrew Lunn:
> On Sun, Apr 19, 2020 at 12:29:23PM +0200, Michael Walle wrote:
>> Am 2020-04-17 23:28, schrieb Andrew Lunn:
>> > On Fri, Apr 17, 2020 at 11:08:56PM +0200, Michael Walle wrote:
>> > > Am 2020-04-17 22:13, schrieb Andrew Lunn:
>> > > > > Correct, and this function was actually stolen from there ;) This was
>> > > > > actually stolen from the mscc PHY ;)
>> > > >
>> > > > Which in itself indicates it is time to make it a helper :-)
>> > >
>> > > Sure, do you have any suggestions?
>> >
>> > mdiobus_get_phy() does the bit i was complaining about, the mdiobus
>> > internal knowledge.
>> 
>> But that doesn't address your other comment.
> 
> Yes, you are right. But i don't think you can easily generalize the
> rest. It needs knowledge of the driver private structure to reference
> pkg_init. You would have to move that into phy_device.
> 
>> 
>> > There is also the question of locking. What happens if the PHY devices
>> > is unbound while you have an instance of its phydev?
>> 
>> Is there any lock one could take to avoid that?
> 
> phy_attach_direct() does a get_device(). That at least means the
> struct device will not go away. I don't know the code well enough to
> know if that will also stop the phy_device structure from being freed.
> We might need mdiobus_get_phy() to also do a get_device(), and add a
> mdiobus_put_phy() which does a put_device().
> 
>> > What happens if the base PHY is unbound? Are the three others then
>> > unusable?
>> 
>> In my case, this would mean the hwmon device is also removed. I don't
>> see any other way to do it right now. I guess it would be better to
>> have the hwmon device registered to some kind of parent device.
> 
> The phydev structure might go away. But the hardware is still
> there. You can access it via address on the bus. What you have to be
> careful of is using the phydev for a different phy.

But the hwmon is registered to the device of the PHY which might be
unbound. So it will also be removed, correct? FWIW I don't think that
is likely to happen in my case ;)

> 
>> For the BCM54140 there are three different functions:
>>  (1) PHY functions accessible by the PHYs own address (ie PHY
>>      status/control)
>>  (2) PHY functions but only accessible by the global registers (ie
>>      interrupt enables per PHY of the shared interrupt pin)
>>  (3) global functions (like sensors, global configuration)
>> 
>> (1) is already supported in the current PHY framework. (2) and (3)
>> need the "hack" which uses mdiobus_read/write() with the base
>> address.
> 
> Is the _is_pkg_init() function the only place you need to access some
> other phy_device structure.

yes.

> Maybe we need a phydev->shared structure, which all PHYs in one
> package share?

That came to my mind too. But how could the PHY core find out which
shared structure belongs to which phydev? I guess the phydev have to
find out, but then how does it tell the PHY core that it wants such
a shared structure. Have the (base) PHY address as an identifier?

> Get the core to do reference counting on the structure?
> Add helpers phy_read_shared(), phy_write_shared(), etc, which does
> MDIO accesses on the base device, taking care of the locking.

The "base" access is another thing, I guess, which has nothing to do
with the shared structure. Also I presume not every PHY has the base
address as some global register access. Eg. this PHY also have
"base + 4" (or depending on the configuration base + 3, that is the
last PHY of the four) as a special register access.

> pkg_init
> is a member of this shared structure. And have a void * priv in shared
> for shared driver private data?

if you have a void *priv, why would you need pkg_init, which is an
implementation detail of the phydev. I guess it is enough to just have
a void *shared (I don't know about the locking for now).

-michael
