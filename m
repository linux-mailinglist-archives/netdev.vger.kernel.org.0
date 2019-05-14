Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23CC51CF78
	for <lists+netdev@lfdr.de>; Tue, 14 May 2019 20:57:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727661AbfENS5S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 May 2019 14:57:18 -0400
Received: from mail.maddes.net ([62.75.236.153]:42647 "EHLO mail.maddes.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727262AbfENS5S (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 May 2019 14:57:18 -0400
X-Greylist: delayed 484 seconds by postgrey-1.27 at vger.kernel.org; Tue, 14 May 2019 14:57:17 EDT
Received: from www.maddes.net (zulu1959.startdedicated.de [62.75.236.153])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mail.maddes.net (Postfix) with ESMTPSA id 9621A4043E
        for <netdev@vger.kernel.org>; Tue, 14 May 2019 20:49:12 +0200 (CEST)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Tue, 14 May 2019 20:49:12 +0200
From:   "M. Buecher" <maddes+kernel@maddes.net>
To:     netdev@vger.kernel.org
Subject: IP-Aliasing for IPv6?
Message-ID: <5c3590c1568251d0f92b61138b7a7f10@maddes.net>
X-Sender: maddes+kernel@maddes.net
User-Agent: Roundcube Webmail/1.1.5
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Preamble: I'm just a network hobbyist at home, so please bear with me if 
something in this mail is "stupid" from an expert's point of view.

According to the documentation [1] "IP-Aliasing" is an obsolete way to 
manage multiple IP[v4]-addresses/masks on an interface.
For having multiple IP[v4]-addresses on an interface this is absolutely 
true.

For me "IP-Aliasing" is still a valid, good and easy way to "group" ip 
addresses to run multiple instances of the same service with different 
IPs via virtual interfaces on a single physical NIC.

Short story:
I recently added IPv6 to my LAN setup and recognized that IP-Aliasing is 
not support by the kernel.
Could IP-Aliasing support for IPv6 be added to the kernel?

Long story:
I tried to find out how to do virtual network interfaces "The Right Way 
(tm)" nowadays.
So I came across MACVLAN, IPVLAN and alike on the internet, mostly in 
conjunction with containers or VMs.
But MACVLAN/IPVLAN do not provide the same usability as "IP-Aliasing", 
e.g. user needs to learn a lot about network infrastructre, sysctl 
settings, forwarding, etc.
They also do not provide the same functionality, e.g. the virtual 
interfaces cannot reach their parent interface.

In my tests with MACVLAN (bridge)/IPVLAN (L2) pinging between parent and 
virtual devices with `ping -I <device> <target ip>` failed for IPv4 and 
IPV6.
Pinging from outside MACVLAN worked fine for IPv4 but not IPv6, while 
IPVLAN failed also for pinging with IPv4 to the virtual interfaces. 
Pinging to outside only worked from the parent device.
Unfortunately I could not find any source on the internet that describes 
how to setup MACVLAN/IPVLAN and their surroundings correctly for a 
single machine. It seems they are just used for containers and VMs.

If it is possible to setup MACVLAN/IPVLAN that they can reach and also 
can be reached from their parent device, other virtual devices and from 
outside, then please guide me to the right direction or provide links. 
Would be much appreciated.
Otherwise I would like to see IP-Aliasing for IPv6.

Hope to stimulate further thoughts and thanks for reading
Matthias "Maddes" Bücher

[1] https://www.kernel.org/doc/html/latest/networking/alias.html

