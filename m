Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9EC846E49E
	for <lists+netdev@lfdr.de>; Fri, 19 Jul 2019 13:00:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727603AbfGSLAj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jul 2019 07:00:39 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:46618 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726853AbfGSLAh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jul 2019 07:00:37 -0400
Received: by mail-wr1-f68.google.com with SMTP id z1so31799332wru.13
        for <netdev@vger.kernel.org>; Fri, 19 Jul 2019 04:00:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DTK2ZLtJVSwF9AaTMZTu60BrCUvqjcjFDZTGN0lYE6Q=;
        b=HO2+5beVR6ZoEFGND48FWNSM5CX1jPAtVICz4fTqgUxi5/BjTLxghRLrf9uZPfq7wj
         QXwSpYhU1JrrVmFAq3sBIM8jpslhLg5Cwe3DDwUbeuSeJW6qEcX0JHhmF9hZ4kPGJbGQ
         fRfHRpGRGtTwZL2XaOJFw7wpTUgPva5KR8u3kyscRIczads+gHZn+ALmtsxRsr1icB23
         keVA4f8xTcINvMTSgT6WpOW0DTunSyJkzKgZd9Hp9skhjJRC29KscOpimCEzLJewgyEN
         OsgygAE2Tz7dvw29CVsKdLxoZjNey2587rXB6mSlMWQfSa9yG7c2H+HHCckV9tiFBSzW
         HZlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DTK2ZLtJVSwF9AaTMZTu60BrCUvqjcjFDZTGN0lYE6Q=;
        b=bMfKoM8jDR+eKjSfeLMZ4BpxgPmcI9INSbE1IDj8lMpdQ4CZRjrh+bhez5IxGce1Dt
         XY0Sg18CcFOjPxi4VJaupX5qKswgmqzKcfaauB58a6qKGGwOyKvjbUtqEp1Dowk0sRXI
         O1fZt45lLQvXt/fYvu7MEfyM0MC+Kq+bxX+N2Qh3Grn6apZhB5rGBKmN6Ri5u887mfAE
         H3aUA3OkRHZlAwxaErhWq/t5MML37Ud1iezEd5V3wOZPzZ72w/reEuFciyUhVQFYkQFb
         9bNQoPBD/qkDNfjf4RuGLNyFLojcQuUqg8KWNZ37cxRMJHj3PqMhEUcWzuJ0+RmnHK93
         xNtw==
X-Gm-Message-State: APjAAAUaUeKXnGHGu7g0IY3adVbC5nIH2BPCmcxnkHMYy1jHtoLcOVDN
        Cd0PsxrcP4YceND/YX0v8bQmR6l4
X-Google-Smtp-Source: APXvYqzmFBKKyd1rfIylk3x2eKbkprSLTqeW4EaB53XV+igsx/6fcn6kY9TarK9Nx5qDg7l2ZZm/QQ==
X-Received: by 2002:adf:e8d0:: with SMTP id k16mr56015366wrn.31.1563534030725;
        Fri, 19 Jul 2019 04:00:30 -0700 (PDT)
Received: from localhost (ip-62-24-94-150.net.upcbroadband.cz. [62.24.94.150])
        by smtp.gmail.com with ESMTPSA id p6sm29575793wrq.97.2019.07.19.04.00.30
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 19 Jul 2019 04:00:30 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jakub.kicinski@netronome.com,
        sthemmin@microsoft.com, dsahern@gmail.com, dcbw@redhat.com,
        mkubecek@suse.cz, andrew@lunn.ch, parav@mellanox.com,
        saeedm@mellanox.com, mlxsw@mellanox.com
Subject: [patch net-next rfc 0/7] net: introduce alternative names for network interfaces
Date:   Fri, 19 Jul 2019 13:00:22 +0200
Message-Id: <20190719110029.29466-1-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

In the past, there was repeatedly discussed the IFNAMSIZ (16) limit for
netdevice name length. Now when we have PF and VF representors
with port names like "pfXvfY", it became quite common to hit this limit:
0123456789012345
enp131s0f1npf0vf6
enp131s0f1npf0vf22

Udev cannot rename these interfaces out-of-the-box and user needs to
create custom rules to handle them.

Also, udev has multiple schemes of netdev names. From udev code:
 * Type of names:
 *   b<number>                             - BCMA bus core number
 *   c<bus_id>                             - bus id of a grouped CCW or CCW device,
 *                                           with all leading zeros stripped [s390]
 *   o<index>[n<phys_port_name>|d<dev_port>]
 *                                         - on-board device index number
 *   s<slot>[f<function>][n<phys_port_name>|d<dev_port>]
 *                                         - hotplug slot index number
 *   x<MAC>                                - MAC address
 *   [P<domain>]p<bus>s<slot>[f<function>][n<phys_port_name>|d<dev_port>]
 *                                         - PCI geographical location
 *   [P<domain>]p<bus>s<slot>[f<function>][u<port>][..][c<config>][i<interface>]
 *                                         - USB port number chain
 *   v<slot>                               - VIO slot number (IBM PowerVM)
 *   a<vendor><model>i<instance>           - Platform bus ACPI instance id
 *   i<addr>n<phys_port_name>              - Netdevsim bus address and port name

One device can be often renamed by multiple patterns at the
same time (e.g. pci address/mac).

This patchset introduces alternative names for network interfaces.
Main goal is to:
1) Overcome the IFNAMSIZ limitation
2) Allow to have multiple names at the same time (multiple udev patterns)
3) Allow to use alternative names as handle for commands

See following examples.

$ ip link
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN mode DEFAULT group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
3: dummy0: <BROADCAST,NOARP> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
    link/ether 7e:a2:d4:b8:91:7a brd ff:ff:ff:ff:ff:ff

-> Add alternative names for dummy0:

$ ip link altname add dummy0 name someothername
$ ip link altname add dummy0 name someotherveryveryveryverylongname
$ ip link
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN mode DEFAULT group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
3: dummy0: <BROADCAST,NOARP> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
    link/ether 7e:a2:d4:b8:91:7a brd ff:ff:ff:ff:ff:ff
    altname someothername
    altname someotherveryveryveryverylongname
  
-> Add bridge brx, add it's alternative name and use alternative names to
   do enslavement.

$ ip link add name brx type bridge
$ ip link altname add brx name mypersonalsuperspecialbridge
$ ip link set someotherveryveryveryverylongname master mypersonalsuperspecialbridge
$ ip link
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN mode DEFAULT group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
3: dummy0: <BROADCAST,NOARP> mtu 1500 qdisc noop master brx state DOWN mode DEFAULT group default qlen 1000
    link/ether 7e:a2:d4:b8:91:7a brd ff:ff:ff:ff:ff:ff
    altname someothername
    altname someotherveryveryveryverylongname
4: brx: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
    link/ether 7e:a2:d4:b8:91:7a brd ff:ff:ff:ff:ff:ff
    altname mypersonalsuperspecialbridge

-> Add ipv4 address to the bridge using alternative name:
    
$ ip addr add 192.168.0.1/24 dev mypersonalsuperspecialbridge
$ ip addr show mypersonalsuperspecialbridge     
4: brx: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN group default qlen 1000
    link/ether 7e:a2:d4:b8:91:7a brd ff:ff:ff:ff:ff:ff
    altname mypersonalsuperspecialbridge
    inet 192.168.0.1/24 scope global brx
       valid_lft forever preferred_lft forever

-> Delete one of dummy0 alternative names:

$ ip link altname del someotherveryveryveryverylongname    
$ ip link
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN mode DEFAULT group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
3: dummy0: <BROADCAST,NOARP> mtu 1500 qdisc noop master brx state DOWN mode DEFAULT group default qlen 1000
    link/ether 7e:a2:d4:b8:91:7a brd ff:ff:ff:ff:ff:ff
    altname someothername
4: brx: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
    link/ether 7e:a2:d4:b8:91:7a brd ff:ff:ff:ff:ff:ff
    altname mypersonalsuperspecialbridge

TODO:
- notifications for alternative names add/removal
- sanitization of add/del cmds (similar to get link)
- test more usecases and write selftests
- extend support for other netlink ifaces (ovs for example)
- add sysfs symlink altname->basename?

Jiri Pirko (7):
  net: procfs: use index hashlist instead of name hashlist
  net: introduce name_node struct to be used in hashlist
  net: rtnetlink: add commands to add and delete alternative ifnames
  net: rtnetlink: put alternative names to getlink message
  net: rtnetlink: unify the code in __rtnl_newlink get dev with the rest
  net: rtnetlink: introduce helper to get net_device instance by ifname
  net: rtnetlink: add possibility to use alternative names as message
    handle

 include/linux/netdevice.h      |  14 ++-
 include/uapi/linux/if.h        |   1 +
 include/uapi/linux/if_link.h   |   3 +
 include/uapi/linux/rtnetlink.h |   7 ++
 net/core/dev.c                 | 152 ++++++++++++++++++++++----
 net/core/net-procfs.c          |   4 +-
 net/core/rtnetlink.c           | 192 +++++++++++++++++++++++++++++----
 security/selinux/nlmsgtab.c    |   4 +-
 8 files changed, 334 insertions(+), 43 deletions(-)

-- 
2.21.0

