Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6130146C665
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 22:10:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235079AbhLGVNx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 16:13:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230374AbhLGVNw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 16:13:52 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9111FC061574;
        Tue,  7 Dec 2021 13:10:21 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id x6so1069544edr.5;
        Tue, 07 Dec 2021 13:10:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=lNyqGYp+8MURh7GGGLFcbdIhzRc6e9BqDyhcuibFU64=;
        b=NngUPNdCBmjC1732LN4AUvtL65nNs04u5pXY45ElQrPkbMRyJs7Gl6NV0q/v0IqlaR
         CpQqyLFvG/oHo33ilNX8EBatJzGw+E//YKRpadStavG9Vqa8YcHlv8uRQOlNcnDh7RlG
         k0RdxPUVI/9e2yPdcuqLwtv5JgJSFrzzMZAaxwSJweM+dTCjlT1DhmwjS5Ms7sHxFI8e
         NLNZZ014W8euCjClQiRNVqwdHVfRjfFTRy2pIr7nA3bIOW9FcAmK6xv1mAXJOK4fTWtm
         7jNiqHDV/5kL5L3pvj2XMdcTAnV5882v1IA3p2RCTyzGqJYm9WGfZ7SAmcVq+V5ZXsF9
         b9FQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=lNyqGYp+8MURh7GGGLFcbdIhzRc6e9BqDyhcuibFU64=;
        b=XNuLClen7NM7OxLWDw+XYX6gun4fA9c2fjLzcyYBu1VKA0GLybXPkDUpCgE1SmbJ+G
         Fcv741f0ZxHiFi3XgmSiC/IfHRZxoDYjrD5UlaMeAv6Y5PWv2zD1yocNoaGDAmlfQlnh
         I858b6i4Te4cedRKmg+00lFdC38Sh2EPqdTY5l7YUPxP90Mn1L/No070ANsrJcGY8AWX
         +Dgf/i9xd2TgX2VuPKTAkIg2mwHByraBlCu7I1apBtAZLDT0TFyFrOYCRV4ow1osTphT
         sIwCQuk9RRA6XPal8PWHzvZ+xThMbRcrwM3ibm1XzdQrUN2SIaV7hOKCC8SRIkIuvugw
         cWlA==
X-Gm-Message-State: AOAM531DUF7GoT/FzYvnhOjH9WHHbGIilSQJQvWToW/0hYHq6xN1WPn2
        GdnknTkVF8eK1ZzOUsQof+oerRYyo9k=
X-Google-Smtp-Source: ABdhPJzVHpq/PrfFH9Gj9DJdnTnh373/XyCblBXCY4MvmSlsZO8adJo6MGxo20/Yl8lSkBuLf5iZDA==
X-Received: by 2002:a17:906:15d0:: with SMTP id l16mr2192486ejd.462.1638911419957;
        Tue, 07 Dec 2021 13:10:19 -0800 (PST)
Received: from skbuf ([188.25.173.50])
        by smtp.gmail.com with ESMTPSA id co10sm575191edb.83.2021.12.07.13.10.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Dec 2021 13:10:19 -0800 (PST)
Date:   Tue, 7 Dec 2021 23:10:18 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, Ansuel Smith <ansuelsmth@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [net-next RFC PATCH 0/6] Add support for qca8k mdio rw in
 Ethernet packet
Message-ID: <20211207211018.cljhqkjyyychisl5@skbuf>
References: <20211207145942.7444-1-ansuelsmth@gmail.com>
 <Ya96pwC1KKZDO9et@lunn.ch>
 <77203cb2-ba90-ff01-5940-2e9b599f648f@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <77203cb2-ba90-ff01-5940-2e9b599f648f@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 07, 2021 at 10:49:43AM -0800, Florian Fainelli wrote:
> On 12/7/21 7:15 AM, Andrew Lunn wrote:
> > On Tue, Dec 07, 2021 at 03:59:36PM +0100, Ansuel Smith wrote:
> >> Hi, this is still WIP and currently has some problem but I would love if
> >> someone can give this a superficial review and answer to some problem
> >> with this.
> >>
> >> The main reason for this is that we notice some routing problem in the
> >> switch and it seems assisted learning is needed. Considering mdio is
> >> quite slow due to the indirect write using this Ethernet alternative way
> >> seems to be quicker.
> >>
> >> The qca8k switch supports a special way to pass mdio read/write request
> >> using specially crafted Ethernet packet.
> > 
> > Oh! Cool! Marvell has this as well, and i suspect a few others. It is
> > something i've wanted to work on for a long long time, but never had
> > the opportunity.
> > 
> > This also means that, even if you are focusing on qca8k, please try to
> > think what could be generic, and what should specific to the
> > qca8k. The idea of sending an Ethernet frame and sometime later
> > receiving a reply should be generic and usable for other DSA
> > drivers. The contents of those frames needs to be driver specific.
> > How we hook this into MDIO might also be generic, maybe.
> > 
> > I will look at your questions later, but soon.
> 
> There was a priori attempt from Vivien to add support for mv88e6xxx over
> RMU frames:
> 
> https://www.mail-archive.com/netdev@vger.kernel.org/msg298317.html
> 
> This gets interesting because the switch's control path moves from MDIO
> to Ethernet and there is not really an "ethernet bus" though we could
> certainly come up with one. We have mdio-i2c, so maybe we should have
> mdio-ethernet?

This raises interesting questions. I see two distinct cases:

1. "dual I/O": the switch probes initially over a standard bus (MDIO,
   SPI, I2C) then at some point transitions towards I/O through the
   tagger.  This would be the case when there is some preparation work
   to be done (maybe the CPU port needs to be brought up, maybe there is
   a firmware to be uploaded to the switch's embedded microcontroller
   such that the expected remote management protocol is supported, etc).
   It would also be the case when multiple CPU ports are supported (and
   changing between CPU ports), because we could end up bringing a
   certain CPU port down, and the register I/O would need to be
   temporarily done over MDIO before bringing the other CPU port up.

2. "single I/O": the switch needs no such configuration, and in this
    case, it could in principle probe over an "Ethernet bus" rather than
    a standard bus as mentioned above.

I don't know which case is going to be more common, honestly. The
difference between the two is that the former would work using the
existing infrastructure (bus types) we have today, whereas the latter
would (maybe) need an "Ethernet bus" as mentioned by Vivien and Florian.

I'm not completely convinced, though. The argument for an "Ethernet bus"
seems to be that any Ethernet controller may need to set up such a
thing, independently of being a DSA master. In Vivien's link, an example
is given where we have "Control path via port 1, Data path via port port 3".
But I don't know, this separation seems pretty artificial and ultimately
boils down to configuration. Like it or not, in that particular example,
both ports 1 and 3 are CPU ports, and both eth1 and eth0 are DSA masters.
The fact that they are used asymmetrically should pretty much not matter.

I think a fair simplifying assumption is that switch management
protocols will never be spoken through interfaces that aren't DSA
masters (because being a DSA master _implies_ having a physical link to
a DSA switch). And if we have this simplifying factor, we could consider
moving dsa_tree_setup_master() somewhere earlier in the DSA probe path,
and just make "type 2" / "single I/O" switches be platform devices, with
a more-or-less empty probe function (just calls dsa_register_switch),
and do their hardware init in ->setup, which is _after_
dsa_tree_setup_master and therefore after the tagging protocol has bound
to the DSA switch tree and is prepared to handle I/O. So no bus really
needed.

Although I have to point this out. An "Ethernet bus" would be one of the
most unreliable buses out there. Consider that the user may run "ip link
set eth0 down" at any given time. What do you do, as a switch driver on
an Ethernet bus, when your DSA master goes down? Postpone all your I/O?
Error out on I/O? Unbind?

Even moreso, there are currently code paths in DSA that can only be done
while the DSA master is down (changing the tagging protocol comes to
mind). So does this mean that those code paths are simply not available
when the I/O is over Ethernet? Or does it mean that Ethernet cannot be
the sole I/O method of any switch driver, due to it being unreliable?
And if the latter, this is yet another argument against "Ethernet as bus".
A bus is basically only there for probing purposes, but if you need to
have a primary I/O method beside Ethernet, you already have a bus and
don't need another.
