Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F24B4279D38
	for <lists+netdev@lfdr.de>; Sun, 27 Sep 2020 02:53:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728580AbgI0AxA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Sep 2020 20:53:00 -0400
Received: from mail.nic.cz ([217.31.204.67]:45160 "EHLO mail.nic.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726840AbgI0AxA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 26 Sep 2020 20:53:00 -0400
Received: from localhost (unknown [IPv6:2a0e:b107:ae1:0:3e97:eff:fe61:c680])
        by mail.nic.cz (Postfix) with ESMTPSA id 5DA73140925;
        Sun, 27 Sep 2020 02:52:58 +0200 (CEST)
Date:   Sun, 27 Sep 2020 02:52:58 +0200
From:   Marek Behun <marek.behun@nic.cz>
To:     netdev <netdev@vger.kernel.org>
Cc:     linux-leds@vger.kernel.org, David Miller <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@armlinux.org.uk>
Subject: Re: Request for Comment: LED device naming for netdev LEDs
Message-ID: <20200927025258.38585d5e@nic.cz>
In-Reply-To: <20200927004025.33c6cfce@nic.cz>
References: <20200927004025.33c6cfce@nic.cz>
X-Mailer: Claws Mail 3.17.6 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-100.0 required=5.9 tests=SHORTCIRCUIT,
        USER_IN_WELCOMELIST,USER_IN_WHITELIST shortcircuit=ham
        autolearn=disabled version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.nic.cz
X-Virus-Scanned: clamav-milter 0.102.2 at mail
X-Virus-Status: Clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 27 Sep 2020 00:40:25 +0200
Marek Behun <marek.behun@nic.cz> wrote:

> What I am wondering is how should we select a name for the device part
> of the LED for network devices, when network namespaces are enabled.
> 
> a) We could just use the interface name (eth0:yellow:activity). The
>    problem is what should happen when the interface is renamed, or
>    moved to another network namespace.
>    Pavel doesn't want to complicate the LED subsystem with LED device
>    renaming, nor, I think, with namespace mechanism. I, for my part, am
>    not opposed to LED renaming, but do not know what should happen when
>    the interface is moved to another namespace.
> 
> b) We could use the device name, as in struct device *. But these names
>    are often too long and may contain characters that we do not want in
>    LED name (':', or '/', for example).
>
> c) We could create a new naming mechanism, something like
>    device_pretty_name(dev), which some classes may implement somehow.
> 
> What are your ideas about this problem?
> 
> Marek

BTW option b) and c) can be usable if we create a new utility, ledtool,
to report infromation about LEDs and configure LEDs.

In that case it does not matter if the LED is named
  ethernet-adapter0:red:activity
or
  ethernet-phy0:red:activity
because this new ledtool utility could just look deeper into sysfs to
find out that the LED corresponds to eth0, whatever it name is.

Still does not solve namespaces, though, because ethernet PHY devices
(struct phy_device) do not currently support network namespaces.

Marek
