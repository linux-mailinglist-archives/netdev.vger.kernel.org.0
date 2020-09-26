Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C7D6279CCD
	for <lists+netdev@lfdr.de>; Sun, 27 Sep 2020 00:40:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727709AbgIZWka (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Sep 2020 18:40:30 -0400
Received: from lists.nic.cz ([217.31.204.67]:35100 "EHLO mail.nic.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726382AbgIZWk3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 26 Sep 2020 18:40:29 -0400
X-Greylist: delayed 2288 seconds by postgrey-1.27 at vger.kernel.org; Sat, 26 Sep 2020 18:40:29 EDT
Received: from localhost (unknown [IPv6:2a0e:b107:ae1:0:3e97:eff:fe61:c680])
        by mail.nic.cz (Postfix) with ESMTPSA id 240DA1405E6;
        Sun, 27 Sep 2020 00:40:26 +0200 (CEST)
Date:   Sun, 27 Sep 2020 00:40:25 +0200
From:   Marek Behun <marek.behun@nic.cz>
To:     netdev <netdev@vger.kernel.org>
Cc:     linux-leds@vger.kernel.org, David Miller <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@armlinux.org.uk>
Subject: Request for Comment: LED device naming for netdev LEDs
Message-ID: <20200927004025.33c6cfce@nic.cz>
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

Hi,

linux-leds is trying to create a consistent naming mechanism for LEDs
The schema is:
  device:color:function
for example
  system:green:power
  keyboard0:green:capslock

But we are not there yet.

LEDs are often dedicated to specific function by manufacturers, for
example there can be an icon or a text next to the LED on the case of a
router, indicating that the LED should blink on activity on a specific
ethernet port.

This can be specified in device tree via the trigger-sources property.

We therefore want to select the device part of the LED name to
correspond to the device it should trigger to according to the
manufacturer.

What I am wondering is how should we select a name for the device part
of the LED for network devices, when network namespaces are enabled.

a) We could just use the interface name (eth0:yellow:activity). The
   problem is what should happen when the interface is renamed, or
   moved to another network namespace.
   Pavel doesn't want to complicate the LED subsystem with LED device
   renaming, nor, I think, with namespace mechanism. I, for my part, am
   not opposed to LED renaming, but do not know what should happen when
   the interface is moved to another namespace.

b) We could use the device name, as in struct device *. But these names
   are often too long and may contain characters that we do not want in
   LED name (':', or '/', for example).

c) We could create a new naming mechanism, something like
   device_pretty_name(dev), which some classes may implement somehow.

What are your ideas about this problem?

Marek
