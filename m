Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28B8D2F2088
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 21:18:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391433AbhAKURA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 15:17:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390782AbhAKUQ7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 15:16:59 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBC8AC061786;
        Mon, 11 Jan 2021 12:16:18 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id g3so106387plp.2;
        Mon, 11 Jan 2021 12:16:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3CsBtxxzWzgpFpPnqOKH7lub5SUyOmIjPcsVKOpfVmY=;
        b=k76VoE3x4rEvPoKMeUoYlDF6iAymtEZZPAZ8EMDPDFtxpc7NKfL8UpD93eGEfRrSj9
         NAxUpDzS17LKEW0zk7ZUsCVWlWTebwrsbkHmxV6O2zRI12se/wL6q53zmoNIzm9IfG/N
         11QVSWPm8OKWXMoUX3tXdaE/QePCNtEiyCqBcKjJ6rCHYuNl6Z/F3iws+uq0f22bO6vY
         DPEeixfMhLXBLWjl3NdyuBeqFnjcBmmmmBO8NxjF1Q9OpwVYVWHhZLxQGIoRZsfVG7Bt
         1MGsQQB9qgv39+HiZW5CfpFNYAGEUxw8BX552zG+0r3JjGrK6usNZbfRUPLuEAFTfYNs
         Y4sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3CsBtxxzWzgpFpPnqOKH7lub5SUyOmIjPcsVKOpfVmY=;
        b=FHClOmakRhOuoav2h96Er+Bucl2S6ZmVcNV+D6ZDKNuXP/LaA/jM1V6wCSHRO0aqIy
         1LjRWRmcBOMFUSZjVa1D27MXb4ArlRZ/j5W4u+IAaqeosL0rtJYrWQzlgDm2D8JGkDHW
         4hKTAbF0iJ048w29tD99UaV6qMaRMyD/kdUW+sYl0L0UACJkKBMtAaC/BLO8HMG+j5Hc
         b/vhd3tqTHQSO8Gkp1UFAEhFbWxaLW/LGLdPkmITcPyhZTjQZuJVTywcHjqScQmXcLJ6
         NJsdYLYbSN77hz4bu1CRtAPDMlP/fE18y/RvVyJ34OLmrZmCDRHOLbELW0fqG2aqYdOX
         +WPA==
X-Gm-Message-State: AOAM533y/3Jo8rib7P/bt/JXlvJu9QRWsymFqJCzBaLA0q+55sN0USmW
        wH2GUhfRSBthjwcKk8ZH8Q==
X-Google-Smtp-Source: ABdhPJwhfeQmeN7haLvQ0Nzb/IYlJMSPxKyhLLF4VG2SyzMkA0e12NfsZUX3gf5OKxjTS1qTuJVfcg==
X-Received: by 2002:a17:902:d3c7:b029:de:18c6:d330 with SMTP id w7-20020a170902d3c7b02900de18c6d330mr27044plb.48.1610396178307;
        Mon, 11 Jan 2021 12:16:18 -0800 (PST)
Received: from localhost.localdomain ([216.52.21.4])
        by smtp.gmail.com with ESMTPSA id t25sm591278pgv.30.2021.01.11.12.16.17
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 11 Jan 2021 12:16:17 -0800 (PST)
From:   Praveen Chaudhary <praveen5582@gmail.com>
X-Google-Original-From: Praveen Chaudhary <pchaudhary@linkedin.com>
To:     davem@davemloft.net, kuba@kernel.org, corbet@lwn.net,
        kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        netdev@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v0 net-next 0/1] Allow user to set metric on default route learned via Router Advertisement.
Date:   Mon, 11 Jan 2021 12:16:09 -0800
Message-Id: <20210111201610.2425-1-pchaudhary@linkedin.com>
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

 Documentation/networking/ip-sysctl.rst |  8 ++++++++
 include/linux/ipv6.h                   |  1 +
 include/net/ip6_route.h                |  3 ++-
 include/uapi/linux/ipv6.h              |  1 +
 include/uapi/linux/sysctl.h            |  1 +
 net/ipv6/addrconf.c                    | 10 ++++++++++
 net/ipv6/ndisc.c                       | 15 +++++++++++----
 net/ipv6/route.c                       |  8 +++++---
 8 files changed, 39 insertions(+), 8 deletions(-)


base-commit: 139711f033f636cc78b6aaf7363252241b9698ef
-- 
2.29.0

