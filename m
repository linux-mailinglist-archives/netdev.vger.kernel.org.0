Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A66B41AFE6E
	for <lists+netdev@lfdr.de>; Sun, 19 Apr 2020 23:31:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726025AbgDSVbP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Apr 2020 17:31:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725848AbgDSVbO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Apr 2020 17:31:14 -0400
Received: from ssl.serverraum.org (ssl.serverraum.org [IPv6:2a01:4f8:151:8464::1:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87BABC061A0C;
        Sun, 19 Apr 2020 14:31:14 -0700 (PDT)
Received: from ssl.serverraum.org (web.serverraum.org [172.16.0.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id B912B22FEC;
        Sun, 19 Apr 2020 23:31:10 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1587331871;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PtI6NkaGa1R7Noht+2pgWWFtr5DFcjOkkrFfIhTsxqM=;
        b=fOE4jT5zK4bb6WmWgDLkKy96nf6sIt7OR7TtmC0oc/ypo1ZLwVDnTIKcGOTGcbHUDlSsRT
        q5Gl4V94zDxdmNdtxgGK5JDK/RJ4mEZpWgNQ0tuHOULLXoySGtV8IpO8Qmn7WPKlvGsrKr
        8tY+4yykRlyHrn6dt5GMnU7iPF7DUt4=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Sun, 19 Apr 2020 23:31:10 +0200
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
In-Reply-To: <20200419170547.GO836632@lunn.ch>
References: <20200417192858.6997-1-michael@walle.cc>
 <20200417192858.6997-3-michael@walle.cc> <20200417195003.GG785713@lunn.ch>
 <35d00dfe1ad24b580dc247d882aa2e39@walle.cc>
 <20200417201338.GI785713@lunn.ch>
 <84679226df03bdd8060cb95761724d3a@walle.cc>
 <20200417212829.GJ785713@lunn.ch>
 <4f3ff33f78472f547212f87f75a37b66@walle.cc>
 <20200419162928.GL836632@lunn.ch>
 <ebc026792e09d5702d031398e96d34f2@walle.cc>
 <20200419170547.GO836632@lunn.ch>
Message-ID: <0f7ea4522a76f977f3aa3a80dd62201d@walle.cc>
X-Sender: michael@walle.cc
User-Agent: Roundcube Webmail/1.3.10
X-Spamd-Bar: +
X-Spam-Level: *
X-Rspamd-Server: web
X-Spam-Status: No, score=1.40
X-Spam-Score: 1.40
X-Rspamd-Queue-Id: B912B22FEC
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

Am 2020-04-19 19:05, schrieb Andrew Lunn:
>> > Maybe we need a phydev->shared structure, which all PHYs in one
>> > package share?
>> 
>> That came to my mind too. But how could the PHY core find out which
>> shared structure belongs to which phydev? I guess the phydev have to
>> find out, but then how does it tell the PHY core that it wants such
>> a shared structure. Have the (base) PHY address as an identifier?
> 
> Yes. I was thinking along those lines.
> 
> phy_package_join(phydev, base)
> 
> If this is the first call with that value of base, allocate the
> structure, set the ref count to 1, and set phydev->shared to point to
> it. For subsequent calls, increment the reference count, and set
> phydev->shared.
> 
> phy_package_leave(phydev)
> 
> Decrement the reference count, and set phydev->shared to NULL. If the
> reference count goes to 0, free the structure.
> 
>> > Get the core to do reference counting on the structure?
>> > Add helpers phy_read_shared(), phy_write_shared(), etc, which does
>> > MDIO accesses on the base device, taking care of the locking.
>> 
>> The "base" access is another thing, I guess, which has nothing to do
>> with the shared structure.
> 
> I'm making the assumption that all global addresses are at the base
> address.

But what does that have to do with the shared structure? I don't think
you have to "bundle" the shared structure with the "access the global
registers" method. The phy drivers just have to know some common key,
which can be anything arbitrary, correct? So we can say its the
lowest address, but it could also be any other address, as long as
each PHY driver instance can deduce the same key.

> If we don't want to make that assumption, we need the change
> the API above so you pass a cookie, and all PHYs need to use the same
> cookie to identify the package.

whats the difference between a PHY address and a cookie, given that the
phy core doesn't actually use the phy address for anything.

-michael

> Maybe base is the wrong name, since MSCC can have the base as the high
> address of the four, not the low?
> 
> Still just thinking aloud....
> 
>        Andrew
