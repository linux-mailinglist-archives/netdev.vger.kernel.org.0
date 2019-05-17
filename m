Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 510D621A56
	for <lists+netdev@lfdr.de>; Fri, 17 May 2019 17:10:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729213AbfEQPKp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 May 2019 11:10:45 -0400
Received: from relay8-d.mail.gandi.net ([217.70.183.201]:45321 "EHLO
        relay8-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729162AbfEQPKp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 May 2019 11:10:45 -0400
X-Originating-IP: 90.88.22.185
Received: from bootlin.com (aaubervilliers-681-1-80-185.w90-88.abo.wanadoo.fr [90.88.22.185])
        (Authenticated sender: maxime.chevallier@bootlin.com)
        by relay8-d.mail.gandi.net (Postfix) with ESMTPSA id 2A9B01BF20B;
        Fri, 17 May 2019 15:10:38 +0000 (UTC)
Date:   Fri, 17 May 2019 17:10:38 +0200
From:   Maxime Chevallier <maxime.chevallier@bootlin.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        "thomas.petazzoni@bootlin.com" <thomas.petazzoni@bootlin.com>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: Re: dsa: using multi-gbps speeds on CPU port
Message-ID: <20190517171038.36d921a5@bootlin.com>
In-Reply-To: <35daa9e7-8b97-35dd-bc95-bab57ef401cd@gmail.com>
References: <20190515143936.524acd4e@bootlin.com>
        <20190515132701.GD23276@lunn.ch>
        <20190515160214.1aa5c7d9@bootlin.com>
        <35daa9e7-8b97-35dd-bc95-bab57ef401cd@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi everyone,

On Wed, 15 May 2019 09:09:26 -0700
Florian Fainelli <f.fainelli@gmail.com> wrote:

>On 5/15/19 7:02 AM, Maxime Chevallier wrote:
>> Hi Andrew,
>> 
>> On Wed, 15 May 2019 15:27:01 +0200
>> Andrew Lunn <andrew@lunn.ch> wrote:
>>   
>>> I think you are getting your terminology wrong. 'master' is eth0 in
>>> the example you gave above. CPU and DSA ports don't have netdev
>>> structures, and so any PHY used with them is not corrected to a
>>> netdev.  
>> 
>> Ah yes sorry, I'm still in the process of getting familiar with the
>> internals of DSA :/
>>   
>>>> I'll be happy to help on that, but before prototyping anything, I wanted
>>>> to have your thougts on this, and see if you had any plans.    
>>>
>>> There are two different issues here.
>>>
>>> 1) Is using a fixed-link on a CPU or DSA port the right way to do this?
>>> 2) Making fixed-link support > 1G.
>>>
>>> The reason i decided to use fixed-link on CPU and DSA ports is that we
>>> already have all the code needed to configure a port, and an API to do
>>> it, the adjust_link() callback. Things have moved on since then, and
>>> we now have an additional API, .phylink_mac_config(). It might be
>>> better to directly use that. If there is a max-speed property, create
>>> a phylink_link_state structure, which has no reference to a netdev,
>>> and pass it to .phylink_mac_config().
>>>
>>> It is just an idea, but maybe you could investigate if that would
>>> work.  

I've quickly prototyped and tested this solution, and besides a few
tweaks that are needed on the mv88e6xxx driver side, it works fine.

I'll post an RFC with this shortly, so that you can see what it looks
like.

As Russell said, there wasn't anything needed on the master interface
side.

>
>Vladimir mentioned a few weeks ago that he is considering adding support
>for PHYLIB and PHYLINK to run without a net_device instance, you two
>should probably coordinate with each other and make sure both of your
>requirements (which are likely the same) get addressed.

That would help a lot solving this issue indeed, I'll be happy to help
on that, thanks for the tip !

Maxime


-- 
Maxime Chevallier, Bootlin
Embedded Linux and kernel engineering
https://bootlin.com
