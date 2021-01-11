Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 222FA2F224E
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 22:59:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388761AbhAKV7T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 16:59:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725917AbhAKV7T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 16:59:19 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6556C061786;
        Mon, 11 Jan 2021 13:58:38 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id iq13so354683pjb.3;
        Mon, 11 Jan 2021 13:58:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4PGlAn7wCIV4EDJoX9M4AaHSOiw+OLhl+bqgOwKmRdk=;
        b=H3qB/1OzCMMnEDkGDbGOHzwGUglRBVoTDELIHnajalH/mk927EFQfLFxTq2DvvlPXU
         LRPgz03p1MU+h/b+00oW4hh74gMlykOENTtDD4bOEYh6XRafApcAdYX3LYKs6jzlPjnU
         BNZms8OudLZUPzu2OUE4agT2mnhJXAUm7OoC1803o2y2m70vlM2Qi+KZausIO2AqgsAL
         m/jlyIURBFUV/bLOyWGK8vpbyZG41xghzvZEVeBiguKbqC70AXn/m4QDrG8sq4PbNfqF
         dD/eRCJbXLt9i0PKj6fCA5rP4QwWu9mEqnpfvzVjWtapfaDBa8k0TXl0KlwC/8FGbZVQ
         s0uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4PGlAn7wCIV4EDJoX9M4AaHSOiw+OLhl+bqgOwKmRdk=;
        b=h+/P7C88Kn3BKdgwfe8jJD9yno9fhC/7gHZ4/V4dR9gucFskYcWoh7p0jas0AOwjgw
         id2SPeR7foGM760JURMW1JTe4S1udaDy7nfhHMqhAuoS9D/LIMryRmwKb8CiDUBCF3Ta
         Ox0UN+oj7JzITCrelpYyf8E3f7TygEvIwQWenBXy+dX6nJINmdEo0QjeoBJisOf7/rvQ
         fR2dmSGRV2jE7gsmWXNifyasUIxhn1Ka3dkN+vV/zSUi8cK0q7Ms9HWUddjI5e0mVodw
         pa+Gq4NBq0b65htaFdHulWoiPusAqfBWkEYw5pxWUhf3jZaWk2f3HxkJ8pzz2MOiC/cg
         9jeQ==
X-Gm-Message-State: AOAM531caSzgSGW1lYDbYXgdvpBEK5W92yAyIUlN7CF736Z/42Kx5YhH
        +3NTIpL2stbR5/bntfv/tVu+E0eSGloG
X-Google-Smtp-Source: ABdhPJx/F5gP3zGDVNuENTGJAKbOflc+xJqi5AmSBqr62++Y6kX/+KBgpSfaN/x3J+xox/8PI4GYQA==
X-Received: by 2002:a17:902:f688:b029:da:a817:1753 with SMTP id l8-20020a170902f688b02900daa8171753mr1337249plg.76.1610402318460;
        Mon, 11 Jan 2021 13:58:38 -0800 (PST)
Received: from localhost.localdomain ([216.52.21.4])
        by smtp.gmail.com with ESMTPSA id z13sm403883pjz.42.2021.01.11.13.58.36
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 11 Jan 2021 13:58:37 -0800 (PST)
From:   Praveen Chaudhary <praveen5582@gmail.com>
X-Google-Original-From: Praveen Chaudhary <pchaudhary@linkedin.com>
To:     davem@davemloft.net, kuba@kernel.org, corbet@lwn.net,
        kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        netdev@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v0 net-next 0/1] Allow user to set metric on default route learned via Router Advertisement.
Date:   Mon, 11 Jan 2021 13:58:28 -0800
Message-Id: <20210111215829.3774-1-pchaudhary@linkedin.com>
X-Mailer: git-send-email 2.29.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Allow user to set metric on default route learned via Router Advertisement.

Note: RFC 4191 does not say anything for metric for IPv6 default route.

Fix:
For IPv4, default route is learned via DHCPv4 and user is allowed to change
metric using config in etc/network/interfaces. But for IPv6, default route can
be learned via RA, for which, currently a fixed metric value 1024 is used.

Ideally, user should be able to configure metric on default route for IPv6
similar to IPv4. This fix adds sysctl for the same.

Logs:
----------------------------------------------------------------
For IPv4:
----------------------------------------------------------------

Config in etc/network/interfaces
----------------------------------------------------------------
```
auto eth0
iface eth0 inet dhcp
    metric 4261413864
```

IPv4 Kernel Route Table:
----------------------------------------------------------------
```
$ sudo route -n
Kernel IP routing table
Destination     Gateway         Genmask         Flags Metric Ref    Use Iface
0.0.0.0         172.11.44.1     0.0.0.0         UG    -33553432 0        0 eth0
```

FRR Table, if a static route is configured. [In real scenario, it is useful to prefer BGP learned default route over DHCPv4 default route.]
----------------------------------------------------------------
```
Codes: K - kernel route, C - connected, S - static, R - RIP,
       O - OSPF, I - IS-IS, B - BGP, P - PIM, E - EIGRP, N - NHRP,
       T - Table, v - VNC, V - VNC-Direct, A - Babel, D - SHARP,
       > - selected route, * - FIB route

S>* 0.0.0.0/0 [20/0] is directly connected, eth0, 00:00:03
K   0.0.0.0/0 [254/1000] via 172.21.47.1, eth0, 6d08h51m
```

----------------------------------------------------------------
i.e. User can prefer Default Router learned via Routing Protocol,
Similar behavior is not possible for IPv6, without this fix.


----------------------------------------------------------------
After fix [for IPv6]:
----------------------------------------------------------------
```
sudo sysctl -w net.ipv6.conf.eth0.net.ipv6.conf.eth0.accept_ra_defrtr_metric=0x770003e9
```

IP monitor:
----------------------------------------------------------------
```
default via fe80::xx16:xxxx:feb3:ce8e dev eth0 proto ra metric 1996489705  pref high
```

Kernel IPv6 routing table
----------------------------------------------------------------
```
Destination                    Next Hop                   Flag Met Ref Use If
::/0                           fe80::xx16:xxxx:feb3:ce8e  UGDAe 1996489705 0
 0 eth0
```

FRR Table, if a static route is configured. [In real scenario, it is useful to prefer BGP learned default route over IPv6 RA default route.]
```
----------------------------------------------------------------
Codes: K - kernel route, C - connected, S - static, R - RIPng,
       O - OSPFv3, I - IS-IS, B - BGP, N - NHRP, T - Table,
       v - VNC, V - VNC-Direct, A - Babel, D - SHARP,
       > - selected route, * - FIB route

S>* ::/0 [20/0] is directly connected, eth0, 00:00:06
K   ::/0 [119/1001] via fe80::xx16:xxxx:feb3:ce8e, eth0, 6d07h43m
----------------------------------------------------------------
```

If the metric is changed later, the effect will be seen only when IPv6 RA is received, because the default route must be fully controlled by RA msg.
```
admin@lnos-x1-a-asw03:~$ sudo sysctl -w net.ipv6.conf.eth0.accept_ra_defrtr_metric=0x770003e8
net.ipv6.conf.eth0.accept_ra_defrtr_metric = 0x770003e8

```

IP monitor: when metric is changed after learning Default Route from previous IPv6 RA msg:
```
Deleted default via fe80::xx16:xxxx:feb3:ce8e dev eth0 proto ra metric 1996489705  expires 3sec hoplimit 64 pref high
default via fe80::xx16:xxxx:feb3:ce8e dev eth0 proto ra metric 1996489704  pref high
```
Praveen Chaudhary (1):
  Allow user to set metric on default route learned via Router
    Advertisement.

 Documentation/networking/ip-sysctl.rst | 18 ++++++++++++++++++
 include/linux/ipv6.h                   |  1 +
 include/net/ip6_route.h                |  3 ++-
 include/uapi/linux/ipv6.h              |  1 +
 include/uapi/linux/sysctl.h            |  1 +
 net/ipv6/addrconf.c                    | 10 ++++++++++
 net/ipv6/ndisc.c                       | 12 +++++++++---
 net/ipv6/route.c                       |  5 +++--
 8 files changed, 45 insertions(+), 6 deletions(-)


base-commit: 139711f033f636cc78b6aaf7363252241b9698ef
-- 
2.29.0

