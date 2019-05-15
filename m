Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5CA11EAE4
	for <lists+netdev@lfdr.de>; Wed, 15 May 2019 11:26:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726338AbfEOJ0U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 May 2019 05:26:20 -0400
Received: from mx2.suse.de ([195.135.220.15]:42952 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725871AbfEOJ0U (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 May 2019 05:26:20 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 6441CAD62;
        Wed, 15 May 2019 09:26:19 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id F24B3E0326; Wed, 15 May 2019 11:26:18 +0200 (CEST)
Date:   Wed, 15 May 2019 11:26:18 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     netdev@vger.kernel.org
Cc:     "M. Buecher" <maddes+kernel@maddes.net>
Subject: Re: IP-Aliasing for IPv6?
Message-ID: <20190515092618.GI22349@unicorn.suse.cz>
References: <5c3590c1568251d0f92b61138b7a7f10@maddes.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5c3590c1568251d0f92b61138b7a7f10@maddes.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 14, 2019 at 08:49:12PM +0200, M. Buecher wrote:
> According to the documentation [1] "IP-Aliasing" is an obsolete way to
> manage multiple IP[v4]-addresses/masks on an interface.
> For having multiple IP[v4]-addresses on an interface this is absolutely
> true.
> 
> For me "IP-Aliasing" is still a valid, good and easy way to "group" ip
> addresses to run multiple instances of the same service with different IPs
> via virtual interfaces on a single physical NIC.
> 
> Short story:
> I recently added IPv6 to my LAN setup and recognized that IP-Aliasing is not
> support by the kernel.
> Could IP-Aliasing support for IPv6 be added to the kernel?

You should probably better explain what is the feature you are using
with IPv4 but you are missing for IPv6. The actual IP aliasing has been
removed in kernel 2.2, i.e. 20 years ago. Since then, there is no IP
aliasing even for IPv4. What exactly works for IPv4 but does not for
IPv6?

> Long story:
> I tried to find out how to do virtual network interfaces "The Right Way
> (tm)" nowadays.
> So I came across MACVLAN, IPVLAN and alike on the internet, mostly in
> conjunction with containers or VMs.
> But MACVLAN/IPVLAN do not provide the same usability as "IP-Aliasing", e.g.
> user needs to learn a lot about network infrastructre, sysctl settings,
> forwarding, etc.
> They also do not provide the same functionality, e.g. the virtual interfaces
> cannot reach their parent interface.
> 
> In my tests with MACVLAN (bridge)/IPVLAN (L2) pinging between parent and
> virtual devices with `ping -I <device> <target ip>` failed for IPv4 and
> IPV6.

This is an interesting observation but also a completely artificial
example. You should probably explain what is the actual goal you want to
achieve.

> Pinging from outside MACVLAN worked fine for IPv4 but not IPv6, while IPVLAN
> failed also for pinging with IPv4 to the virtual interfaces. Pinging to
> outside only worked from the parent device.
> Unfortunately I could not find any source on the internet that describes how
> to setup MACVLAN/IPVLAN and their surroundings correctly for a single
> machine. It seems they are just used for containers and VMs.

That's because containers and VMs are the primary use case (macvlan can
also make sense if you want to use different MAC address for some
reason). Otherwise, it should be sufficient to simply assign multiple
IPv[46] addresses to your interface.

Michal Kubecek
