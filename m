Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E9B72F81DD
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 18:13:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387625AbhAORM4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 12:12:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387596AbhAORMu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 12:12:50 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C29D2C061798
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 09:11:45 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id g1so9676257edu.4
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 09:11:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=oJ7vHO30mT3PwEX3LIlYnP7lc7tRv3XoUAPGbW7Z2DE=;
        b=QEBnFFCoM3FqBkcvcVLHGWAd/ZmwVmqVN+JK0TkgNn+/WUO7oy9c7vdEjJYeVeOROR
         mbYPpvB+OHj16p1aRw6Y0CGRM3xQ/t0qs0JZwouczBqUUuRrlBWe6Sw+D4R45aG2tTnw
         Zw9lk3cWHoSOdzlgJAMg2rTWkkYKxhe3EKveQf+Aq/Oc7Eok1X7hCe/2Z07/Qcb+E93q
         GwQm67mPCtcBFGMn6DHpZrSxxu47Plk4OLUaQsAUVNRsNb/6O9jKlUjAYPSANiHP9laZ
         MHElrL47Mrm8F37vgSHNv9oOLnU1mhlaF9safIRsSON7htr9PCv+gtVAL0i40hcBbBGr
         PIbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=oJ7vHO30mT3PwEX3LIlYnP7lc7tRv3XoUAPGbW7Z2DE=;
        b=glYaYCcWgp77NTIz9nC3YDlmu3vKCvjVCusN5PI+uXoH/RirvjNZelFs+XKaRw//zc
         uwVuJTZzo6ap/cnzS+vx0HxiPF5UAFUNoR7nGVoSx+qFMul8PQQbSAhiazrgSFqnqLxZ
         LPe2ZuPVgYlsbcWrv6nfDm67QZabo6Ri7j+8SYazr08PSm2oRRN1Yeexx8eS9Zm7in3j
         siQ1Ig//9GO+hdsJbMKgIOAiEvjlJVkLoLL8/vsQA02KkpF7FNE4EhWgT6YWJ3AcpMtd
         67oL3VBwTN0qM/IszdsQhut52wdorEDTplD5n62p8Y1XATnByFBM2XdUZpJOTGz5iX4T
         A46w==
X-Gm-Message-State: AOAM532StWs4UcV6J7fjOx2cFmxlvviIIoLE8wj7fYFFMII72IqdyXnW
        kJ8mP/1qJK4VGBmJOeNhWmU=
X-Google-Smtp-Source: ABdhPJzCx0moM49KxLdHPCb1/kZkJ6hAvIntXqGYxcOt93T0tvW6uw9d8ArJX5xJ8KZZ3bLkX7Hq2A==
X-Received: by 2002:a05:6402:487:: with SMTP id k7mr10482901edv.130.1610730704513;
        Fri, 15 Jan 2021 09:11:44 -0800 (PST)
Received: from skbuf (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id g3sm1225229eds.69.2021.01.15.09.11.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jan 2021 09:11:43 -0800 (PST)
Date:   Fri, 15 Jan 2021 19:11:42 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, alexandre.belloni@bootlin.com,
        andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        alexandru.marginean@nxp.com, claudiu.manoil@nxp.com,
        xiaoliang.yang_1@nxp.com, hongbo.wang@nxp.com, jiri@resnulli.us,
        idosch@idosch.org, UNGLinuxDriver@microchip.com
Subject: Renaming interfaces that are up (Was "Re: [PATCH v3 net-next 08/10]
 net: mscc: ocelot: register devlink") ports
Message-ID: <20210115171142.4iylui5uuv5vljwq@skbuf>
References: <20210108175950.484854-1-olteanv@gmail.com>
 <20210108175950.484854-9-olteanv@gmail.com>
 <20210109174439.404713f6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20210111171344.j6chsp5djr5t5ykk@skbuf>
 <20210111111909.4cf0174f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20210114103405.yizjfsk4idzgnpot@skbuf>
 <20210114084435.094c260a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210114084435.094c260a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 14, 2021 at 08:44:35AM -0800, Jakub Kicinski wrote:
> > > Can you unbind and bind the driver back and see if phys_port_name
> > > always gets the correct value? (replay/udevadm test is not sufficient)
> >
> > Yes, and that udev renaming test failed miserably still.
> >
> > I have dhcpcd in my system, and it races with my udev script by
> > auto-upping the interfaces when they probe. Then, dev_change_name()
> > returns -EBUSY because the interfaces are up but its priv_flags do not
> > declare IFF_LIVE_RENAME_OK.
> >
> > How is that one solved?
>
> Yeah, that's one of those perennial problems we never found a strong
> answer to. IIRC IFF_LIVE_RENAME_OK was more of a dirty hack than a
> serious answer. I think we should allow renaming interfaces while
> they're up, and see if anything breaks. We'd just need to add the right
> netlink notifications to dev_change_name(), maybe?

I'm probably crazy for even indulging in this, since it is likely going
to just be a huge time sink. But I need to ask anyway: what netlink
notification are you thinking of adding? Do you want me to call
dev_close and then dev_open, like what was discussed in the
"[virtio-dev] Re: net_failover slave udev renaming (was Re: [RFC PATCH
net-next v6 4/4] netvsc: refactor notifier/event handling code to use
the bypass framework)" thread and then in the "failover: allow name
change on IFF_UP slave interfaces" email threads?

By the way I removed the if condition and added nothing in its place,
just to see what would happen. I see a lot of these messages, I did not
investigate where they are coming from and why they are emitted. They go
away when I rename the interface back to swp0.

# ip monitor &
[1] 26931
# ip link set swp0 name random
[ 2857.570246] mscc_felix 0000:00:00.5 random: renamed from swp0
32: random: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default
    link/ether 7a:1e:87:48:79:c0 brd ff:ff:ff:ff:ff:ff
Deleted inet swp0
inet swp0 forwarding off rp_filter off mc_forwarding off proxy_neigh off ignore_routes_with_linkdown off
Deleted inet6 swp0
inet6 swp0 forwarding off mc_forwarding off proxy_neigh off ignore_routes_with_linkdown off
32: random: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default
    link/ether 7a:1e:87:48:79:c0 brd ff:ff:ff:ff:ff:ff
fe80::/64 dev swp0 proto kernel metric 256 pref medium
32: swp0    inet6 fe80::e4fb:6ac5:7211:7981/64 scope link tentative
       valid_lft forever preferred_lft forever
Deleted 32: swp0    inet6 fe80::e4fb:6ac5:7211:7981/64 scope link tentative
       valid_lft forever preferred_lft forever
Deleted fe80::/64 dev swp0 proto kernel metric 256 pref medium
32: random: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default
    link/ether 7a:1e:87:48:79:c0 brd ff:ff:ff:ff:ff:ff
fe80::/64 dev swp0 proto kernel metric 256 pref medium
32: swp0    inet6 fe80::e4fb:6ac5:7211:7981/64 scope link tentative
       valid_lft forever preferred_lft forever
Deleted 32: swp0    inet6 fe80::e4fb:6ac5:7211:7981/64 scope link tentative
       valid_lft forever preferred_lft forever
Deleted fe80::/64 dev swp0 proto kernel metric 256 pref medium
32: random: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default
    link/ether 7a:1e:87:48:79:c0 brd ff:ff:ff:ff:ff:ff
fe80::/64 dev swp0 proto kernel metric 256 pref medium
32: swp0    inet6 fe80::e4fb:6ac5:7211:7981/64 scope link tentative
       valid_lft forever preferred_lft forever
Deleted 32: swp0    inet6 fe80::e4fb:6ac5:7211:7981/64 scope link tentative
       valid_lft forever preferred_lft forever
Deleted fe80::/64 dev swp0 proto kernel metric 256 pref medium
^C32: random: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default
    link/ether 7a:1e:87:48:79:c0 brd ff:ff:ff:ff:ff:ff
fe80::/64 dev swp0 proto kernel metric 256 pref medium
32: swp0    inet6 fe80::e4fb:6ac5:7211:7981/64 scope link tentative
       valid_lft forever preferred_lft forever
Deleted 32: swp0    inet6 fe80::e4fb:6ac5:7211:7981/64 scope link tentative
       valid_lft forever preferred_lft forever
Deleted fe80::/64 dev swp0 proto kernel metric 256 pref medium
32: random: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default
    link/ether 7a:1e:87:48:79:c0 brd ff:ff:ff:ff:ff:ff
fe80::/64 dev swp0 proto kernel metric 256 pref medium
32: swp0    inet6 fe80::e4fb:6ac5:7211:7981/64 scope link tentative
       valid_lft forever preferred_lft forever
Deleted 32: swp0    inet6 fe80::e4fb:6ac5:7211:7981/64 scope link tentative
       valid_lft forever preferred_lft forever
Deleted fe80::/64 dev swp0 proto kernel metric 256 pref medium
