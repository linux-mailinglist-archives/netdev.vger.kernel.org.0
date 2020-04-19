Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B89AC1AF952
	for <lists+netdev@lfdr.de>; Sun, 19 Apr 2020 12:29:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725987AbgDSK30 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Apr 2020 06:29:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725783AbgDSK3Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Apr 2020 06:29:25 -0400
Received: from ssl.serverraum.org (ssl.serverraum.org [IPv6:2a01:4f8:151:8464::1:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 606DEC061A0C;
        Sun, 19 Apr 2020 03:29:25 -0700 (PDT)
Received: from ssl.serverraum.org (web.serverraum.org [172.16.0.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 752A223059;
        Sun, 19 Apr 2020 12:29:23 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1587292163;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TbYFlrjpu4ST5SWEqVqD8WF0zCnnnfS7jHo+g2Rkr/U=;
        b=Z8ON4iq3dQ8V1H+OpfOlW447vjWjj8F3TPtlN3Yz8zYTA5BSaOY0XWx/Y9HSJyhzYadX24
        TDCYo5t+cSmelPa2fUKTBOwZZ5PUSNgpYB+uwiR9HGApIfC55MzEFsUVMc+wISMl66rj7N
        QOsnkY44q06h15OD5gnGpAiFKfOiNjA=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Sun, 19 Apr 2020 12:29:23 +0200
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
In-Reply-To: <20200417212829.GJ785713@lunn.ch>
References: <20200417192858.6997-1-michael@walle.cc>
 <20200417192858.6997-3-michael@walle.cc> <20200417195003.GG785713@lunn.ch>
 <35d00dfe1ad24b580dc247d882aa2e39@walle.cc>
 <20200417201338.GI785713@lunn.ch>
 <84679226df03bdd8060cb95761724d3a@walle.cc>
 <20200417212829.GJ785713@lunn.ch>
Message-ID: <4f3ff33f78472f547212f87f75a37b66@walle.cc>
X-Sender: michael@walle.cc
User-Agent: Roundcube Webmail/1.3.10
X-Spamd-Bar: +
X-Spam-Level: *
X-Rspamd-Server: web
X-Spam-Status: No, score=1.40
X-Spam-Score: 1.40
X-Rspamd-Queue-Id: 752A223059
X-Spamd-Result: default: False [1.40 / 15.00];
         FROM_HAS_DN(0.00)[];
         TO_DN_SOME(0.00)[];
         FREEMAIL_ENVRCPT(0.00)[gmail.com];
         TO_MATCH_ENVRCPT_ALL(0.00)[];
         TAGGED_RCPT(0.00)[];
         MIME_GOOD(-0.10)[text/plain];
         DKIM_SIGNED(0.00)[];
         RCPT_COUNT_SEVEN(0.00)[10];
         NEURAL_HAM(-0.00)[-0.974];
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

Am 2020-04-17 23:28, schrieb Andrew Lunn:
> On Fri, Apr 17, 2020 at 11:08:56PM +0200, Michael Walle wrote:
>> Am 2020-04-17 22:13, schrieb Andrew Lunn:
>> > > Correct, and this function was actually stolen from there ;) This was
>> > > actually stolen from the mscc PHY ;)
>> >
>> > Which in itself indicates it is time to make it a helper :-)
>> 
>> Sure, do you have any suggestions?
> 
> mdiobus_get_phy() does the bit i was complaining about, the mdiobus
> internal knowledge.

But that doesn't address your other comment.

> There is also the question of locking. What happens if the PHY devices
> is unbound while you have an instance of its phydev?

Is there any lock one could take to avoid that?

> What happens if the base PHY is unbound? Are the three others then
> unusable?

In my case, this would mean the hwmon device is also removed. I don't
see any other way to do it right now. I guess it would be better to
have the hwmon device registered to some kind of parent device.

> I think we need to take a step back and look at how we handle quad
> PHYs in general. The VSC8584 has many of the same issues.

For the BCM54140 there are three different functions:
  (1) PHY functions accessible by the PHYs own address (ie PHY
      status/control)
  (2) PHY functions but only accessible by the global registers (ie
      interrupt enables per PHY of the shared interrupt pin)
  (3) global functions (like sensors, global configuration)

(1) is already supported in the current PHY framework. (2) and (3)
need the "hack" which uses mdiobus_read/write() with the base
address.

-michael
