Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12136215BA0
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 18:14:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729578AbgGFQOt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 12:14:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729550AbgGFQOs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 12:14:48 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72C22C061755
        for <netdev@vger.kernel.org>; Mon,  6 Jul 2020 09:14:48 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id l6so13920238pjq.1
        for <netdev@vger.kernel.org>; Mon, 06 Jul 2020 09:14:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=YtF9/0yMKL2PcFyEul56lzjmhF87KWBUEMDgmj8/9pI=;
        b=1n/OrGEu1/9FziBMzoC82tG+nhebSzPyHJ/7KClbqoCDrkHcCeHKfyjg2EN6AAuJOe
         UkfsAJSBqBbqTM6wFUfHtmfzgVbrUU5Qw4OUczp0r5ocAsEvWlDHhWUNDfh5eu2tsTWy
         tvvpuQbg1WE5LAYL4bQ2QkAmQuHdAWBWN2xzDq1qsnRluLe1209ZIq+ktUleqhf6zoOk
         QHIDGvUNiioZpQDUNC4OXXKKEdAxS0XyOIBH+k+M7V9+TqNPXZIpO8kGLzwHP8PSUwO+
         pInf4kLjgFwZAA0hpiIXgsJ6LbG+gsGmmmtCmTEKo1e+AsHmUafPaJW6OX4NGIcQFlJ6
         avpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=YtF9/0yMKL2PcFyEul56lzjmhF87KWBUEMDgmj8/9pI=;
        b=pUCLKtz4H8ICnJBBMqtaNQll6HAwC4fgRMXDizOxihwCkzZIiKHIdw5Po1AXbLCQBo
         +DBehDX3IH2gpfs5fDMmPGhWf5t8i0qCHDOisAVFnDBtLedu5txEh7rCMqmiv35WNSa7
         KnFZm8cvsQHku4CI8L0o4zJwuP7NkHxICYJQ2kQQgdWfWaMKlGLY3N6zvoZu0LnoBNFy
         bVLEwCaIWcsMC+OaTg3TC3EjcBxp9WyyX8HNqBb3wdxL5QRJlabKoLIIQvpINydLJwcO
         toLF4/7LpLwOM4yhzyIqzlvgwsupJ+84WyenmVIc/qPUVp2deFsr/LpG7I+Wh+J38eOl
         QzCg==
X-Gm-Message-State: AOAM532nICrIcSN+E4M3dfdVdsY07+VG0zInVpYbdnSwSVuhCy36ICyb
        cdDm4cnkNLasop5ZqSaz6BOP83jn//c=
X-Google-Smtp-Source: ABdhPJwLtNIFPD9KcWSpmlewTVqFjJcdjJmrNM9j41cBAF9OQYBG1/Cy4wzm7YKvuhZeiZPfUXfEng==
X-Received: by 2002:a17:90a:6983:: with SMTP id s3mr34214966pjj.55.1594052087496;
        Mon, 06 Jul 2020 09:14:47 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id t188sm20582969pfc.198.2020.07.06.09.14.46
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jul 2020 09:14:47 -0700 (PDT)
Date:   Mon, 6 Jul 2020 09:14:37 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Subject: Fw: [Bug 206885] macvlan and proxy ARP can be accidentally
 configured to respond to ARP requests for all IPs
Message-ID: <20200706091437.6f2188c0@hermes.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This likes a user configuration error.

Begin forwarded message:

Date: Mon, 06 Jul 2020 09:36:58 +0000
From: bugzilla-daemon@bugzilla.kernel.org
To: stephen@networkplumber.org
Subject: [Bug 206885] macvlan and proxy ARP can be accidentally configured to respond to ARP requests for all IPs


https://bugzilla.kernel.org/show_bug.cgi?id=206885

--- Comment #2 from Thomas Parrott (thomas.parrott@canonical.com) ---
Hi,

Thanks for your reply.

I've setup another test:

ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group
default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host 
       valid_lft forever preferred_lft forever
2: enp5s0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP
group default qlen 1000
    link/ether 00:16:3e:14:4a:d4 brd ff:ff:ff:ff:ff:ff
    inet 10.109.89.91/24 brd 10.109.89.255 scope global dynamic enp5s0
       valid_lft 3279sec preferred_lft 3279sec
    inet6 fd42:d37c:f0f2:a5f:69c1:50d9:30fe:6d20/128 scope global dynamic
noprefixroute 
       valid_lft 3282sec preferred_lft 3282sec
    inet6 fe80::216:3eff:fe14:4ad4/64 scope link 
       valid_lft forever preferred_lft forever
3: vtest@enp5s0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state
UP group default qlen 1000
    link/ether f6:83:72:e4:77:0a brd ff:ff:ff:ff:ff:ff
    inet 192.168.1.200/32 scope global vtest
       valid_lft forever preferred_lft forever
    inet6 fe80::f483:72ff:fee4:770a/64 scope link 
       valid_lft forever preferred_lft forever

ip r
default via 10.109.89.1 dev enp5s0 proto dhcp src 10.109.89.91 metric 100 
10.109.89.0/24 dev enp5s0 proto kernel scope link src 10.109.89.91 
10.109.89.1 dev enp5s0 proto dhcp scope link src 10.109.89.91 metric 100

sysctl -w net.ipv4.conf.vtest.rp_filter=2
sysctl -w net.ipv4.conf.vtest.proxy_arp=1
sysctl -w net.ipv4.conf.vtest.forwarding=1

On another host:
sudo arping -c1 -I lxdbr0 -S 10.109.89.1 8.8.8.8
ARPING 8.8.8.8
42 bytes from f6:83:72:e4:77:0a (8.8.8.8): index=0 time=11.809 msec

--- 8.8.8.8 statistics ---
1 packets transmitted, 1 packets received,   0% unanswered (0 extra)
rtt min/avg/max/std-dev = 11.809/11.809/11.809/0.000 ms


So are you saying the default route is triggering a response to all ARP
requests due to rp_filter=2 with proxy_arp=1?

The reason this seems odd is that setting these same settings on an ethernet
device (rather than a macvlan device) does not result in the same behaviour
(even with rp_filter=2).

E.g.

Remove the macvlan interface.

ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group
default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host 
       valid_lft forever preferred_lft forever
2: enp5s0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP
group default qlen 1000
    link/ether 00:16:3e:14:4a:d4 brd ff:ff:ff:ff:ff:ff
    inet 10.109.89.91/24 brd 10.109.89.255 scope global dynamic enp5s0
       valid_lft 3029sec preferred_lft 3029sec
    inet6 fd42:d37c:f0f2:a5f:69c1:50d9:30fe:6d20/128 scope global dynamic
noprefixroute 
       valid_lft 3032sec preferred_lft 3032sec
    inet6 fe80::216:3eff:fe14:4ad4/64 scope link 
       valid_lft forever preferred_lft forever

ip r
default via 10.109.89.1 dev enp5s0 proto dhcp src 10.109.89.91 metric 100 
10.109.89.0/24 dev enp5s0 proto kernel scope link src 10.109.89.91 
10.109.89.1 dev enp5s0 proto dhcp scope link src 10.109.89.91 metric 100 

Set the sysctls on parent ethernet device instead:

sysctl -w net.ipv4.conf.enp5s0.proxy_arp=1
sysctl -w net.ipv4.conf.enp5s0.rp_filter=2
sysctl -w net.ipv4.conf.enp5s0.forwarding=1


Now repeat the arping from a different host in same segment, and it doesn't get
a response as it did with macvlan:

sudo arping -c1 -I lxdbr0 -S 10.109.89.1 8.8.8.8
ARPING 8.8.8.8
Timeout

--- 8.8.8.8 statistics ---
1 packets transmitted, 0 packets received, 100% unanswered (0 extra)

-- 
You are receiving this mail because:
You are the assignee for the bug.
