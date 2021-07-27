Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E1D93D793C
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 17:04:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232573AbhG0PD6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 11:03:58 -0400
Received: from ssl.serverraum.org ([176.9.125.105]:36207 "EHLO
        ssl.serverraum.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231552AbhG0PD4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 11:03:56 -0400
Received: from ssl.serverraum.org (web.serverraum.org [172.16.0.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 6807922234;
        Tue, 27 Jul 2021 17:03:53 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1627398235;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bmx1fTN9l/xY8lHDQKh3a/r/5GaTgtJB296kL2tMH8k=;
        b=kddq4yQy4eUrsv1ktixl0KWyIc5k3lP3vywwptMGD/6AGf8gufJpRdPQtUjj0LUEJCqqYY
        09e8Bd9Db/E7dlSNrQvJ/1lSZyPtNOtNKKJMGUI3ghytedipG/7HMbp67orY7RYzJdcmMs
        zidYbwaeqqS/CozTPx0t9wpxiHNav4A=
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Tue, 27 Jul 2021 17:03:53 +0200
From:   Michael Walle <michael@walle.cc>
To:     =?UTF-8?Q?Marek_Beh=C3=BAn?= <kabel@kernel.org>
Cc:     andrew@lunn.ch, anthony.l.nguyen@intel.com, bigeasy@linutronix.de,
        davem@davemloft.net, dvorax.fuxbrumer@linux.intel.com,
        f.fainelli@gmail.com, hkallweit1@gmail.com,
        jacek.anaszewski@gmail.com, kuba@kernel.org, kurt@linutronix.de,
        linux-leds@vger.kernel.org, netdev@vger.kernel.org, pavel@ucw.cz,
        sasha.neftin@intel.com, vinicius.gomes@intel.com,
        vitaly.lifshits@intel.com
Subject: Re: [PATCH net-next 5/5] igc: Export LEDs
In-Reply-To: <20210727165605.5c8ddb68@thinkpad>
References: <YP9n+VKcRDIvypes@lunn.ch>
 <20210727081528.9816-1-michael@walle.cc> <20210727165605.5c8ddb68@thinkpad>
User-Agent: Roundcube Webmail/1.4.11
Message-ID: <c56fd3dbe1037a5c2697b311f256b3d8@walle.cc>
X-Sender: michael@walle.cc
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Am 2021-07-27 16:56, schrieb Marek Behún:
> On Tue, 27 Jul 2021 10:15:28 +0200
> Michael Walle <michael@walle.cc> wrote:
> 
>> Why do we have to distiguish between LEDs connected to the PHY and 
>> LEDs
>> connected to the MAC at all? Why not just name it ethN either if its 
>> behind
>> the PHY or the MAC? Does it really matter from the users POV?
> 
> Because
> 1. network interfaces can be renamed
> 2. network interfaces can be moved between network namespaces. The LED
>    subsystem is agnostic to network namespaces

I wasn't talking about ethN being same as the network interface name.
For clarity I'll use ethernetN now. My question was why would you
use ethmacN or ethphyN instead if just ethernetN for both. What is
the reason for having two different names? I'm not sure who is using
that name anyway. If it is for an user, I don't think he is interested
in knowing wether that LED is controlled by the PHY or by the MAC.

> So it can for example happen that within a network namespace you
> have only one interface, eth0, but in /sys/class/leds you would see
>   eth0:green:activity
>   eth1:green:activity
> So you would know that there are at least 2 network interfaces on the
> system, and also with renaming it can happen that the first LED is not
> in fact connected to the eth0 interface in your network namespace.

But the first problem persists wether its named ethernetN or ethphyN,
no?

-michael
