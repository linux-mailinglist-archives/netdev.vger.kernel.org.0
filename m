Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B82827B132
	for <lists+netdev@lfdr.de>; Mon, 28 Sep 2020 17:52:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726636AbgI1PwM convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 28 Sep 2020 11:52:12 -0400
Received: from lists.nic.cz ([217.31.204.67]:39248 "EHLO mail.nic.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726424AbgI1PwL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Sep 2020 11:52:11 -0400
Received: from localhost (unknown [IPv6:2a0e:b107:ae1:0:3e97:eff:fe61:c680])
        by mail.nic.cz (Postfix) with ESMTPSA id 76F2A140A68;
        Mon, 28 Sep 2020 17:52:09 +0200 (CEST)
Date:   Mon, 28 Sep 2020 17:52:09 +0200
From:   Marek Behun <marek.behun@nic.cz>
To:     Alexander Dahl <ada@thorsis.com>
Cc:     linux-leds@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@armlinux.org.uk>,
        Alexander Dahl <post@lespocky.de>
Subject: Re: Request for Comment: LED device naming for netdev LEDs
Message-ID: <20200928175209.06193d95@nic.cz>
In-Reply-To: <2817077.TXCUc2rGbz@ada>
References: <20200927004025.33c6cfce@nic.cz>
        <20200927025258.38585d5e@nic.cz>
        <2817077.TXCUc2rGbz@ada>
X-Mailer: Claws Mail 3.17.6 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-100.0 required=5.9 tests=SHORTCIRCUIT,
        USER_IN_WELCOMELIST,USER_IN_WHITELIST shortcircuit=ham
        autolearn=disabled version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.nic.cz
X-Virus-Scanned: clamav-milter 0.102.2 at mail
X-Virus-Status: Clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 28 Sep 2020 15:04:10 +0200
Alexander Dahl <ada@thorsis.com> wrote:

> Hei Marek,
> 
> Am Sonntag, 27. September 2020, 02:52:58 CEST schrieb Marek Behun:
> > On Sun, 27 Sep 2020 00:40:25 +0200
> > 
> > Marek Behun <marek.behun@nic.cz> wrote:  
> > > What I am wondering is how should we select a name for the device part
> > > of the LED for network devices, when network namespaces are enabled.
> > > 
> > > a) We could just use the interface name (eth0:yellow:activity). The
> > > 
> > >    problem is what should happen when the interface is renamed, or
> > >    moved to another network namespace.
> > >    Pavel doesn't want to complicate the LED subsystem with LED device
> > >    renaming, nor, I think, with namespace mechanism. I, for my part, am
> > >    not opposed to LED renaming, but do not know what should happen when
> > >    the interface is moved to another namespace.
> > > 
> > > b) We could use the device name, as in struct device *. But these names
> > > 
> > >    are often too long and may contain characters that we do not want in
> > >    LED name (':', or '/', for example).
> > > 
> > > c) We could create a new naming mechanism, something like
> > > 
> > >    device_pretty_name(dev), which some classes may implement somehow.
> > > 
> > > What are your ideas about this problem?
> > > 
> > > Marek  
> > 
> > BTW option b) and c) can be usable if we create a new utility, ledtool,
> > to report infromation about LEDs and configure LEDs.
> > 
> > In that case it does not matter if the LED is named
> >   ethernet-adapter0:red:activity
> > or
> >   ethernet-phy0:red:activity
> > because this new ledtool utility could just look deeper into sysfs to
> > find out that the LED corresponds to eth0, whatever it name is.  
> 
> I like the idea to have such a tool.  What do you have in mind?  Sounds for me 
> like it would be somehow similar to libgpiod with gpio* for GPIO devices or 
> like libevdev for input devices or like mtd-utils …
> 
As Pavel said, we have ethtool, maybe we could have ledtool.

> Especially a userspace library could be helpful to avoid reinventing the wheel 
> on userspace developer side?

If such a need arises, than yes. For most embedded systems though I
think ledtool would be enough, since mostly LEDs can be controlled from
shell scripts.

> Does anyone else know prior work for linux leds sysfs interface from 
> userspace?

I am not aware of that, everyone just uses sysfs now.

Marek
