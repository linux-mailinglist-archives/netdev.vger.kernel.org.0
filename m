Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9A552F415A
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 02:52:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726858AbhAMBvX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 20:51:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726329AbhAMBvW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 20:51:22 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE3E8C0617A5;
        Tue, 12 Jan 2021 17:50:41 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id m6so266093pfk.1;
        Tue, 12 Jan 2021 17:50:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lVMcs8UX05yYXnv8U8ZRWy0QX2Aplqzdx81ZhiBh7Rg=;
        b=YSrS63qemmiLiixU+9VJW7ig6DvBllC70+EwxvUTHxHvABJQI7xoO5KhU//Ft86i+T
         gR1wNiUxIxadrz6NaT3D2Yq8yNjByMD47EJkrhi8jBLt/UboGUhqCsPz0brvudDVv3oG
         w3rm5kAtE/aOb1AqlMZRfc1vEYIwGNvgKDkHB622O3j3L59LqaDHxV16QhbO6Rfx5Tah
         7iDbrnNZHyjoEIk0VyAk8O3vWp3+KHR6HD4YLJ3N/OCeRpfoFDok4w7vXxKnbxBXFfLQ
         2rxCKxW0PW23LeIzenJCyhKeGGFrtiLvQIjY/JKH3WtnlEyR1tbuI62k3RCTgr9p7te6
         QI4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lVMcs8UX05yYXnv8U8ZRWy0QX2Aplqzdx81ZhiBh7Rg=;
        b=eg89Z1yKzmSC3mXBXny/UzecSnFhNYJyye5gMKOIOJA2dg5aaPZ7AbH1aqAryNBdUE
         uqtGRuyqj+rZofEhvm+uCesDgfohD9m1rY5w2yO3ZiULBiVvunAQBvkBUxZ2S8wypZlC
         /saqX8JbATN1Mx337CLS5OX+HjLy94B3RH/n0HzRb6hThnqfACxWTYr5p/P1ZdtO6245
         uZoOou1OHvtcgLj/23+bw3ey2I5i7Z/mpdCEaS9gYgbWAegdXY+0oZGpPuQ+frwN81h9
         5Y7HUIxnQuSQNaA3mziUsPuvKeKFWpRaAh8ToLGNK4BGzIewSFXeGnNrUesS8FZAezai
         jctg==
X-Gm-Message-State: AOAM530LqpY4o7AX/Kd1em9jeSdZOpVcFQakcVQeRT835jcR3yGOPtuR
        R/Jta9c+g6egvYD56PjtZp8y6/Dio+V4
X-Google-Smtp-Source: ABdhPJwTz97VyacaNkUBhukAr/6SlYHlN8opCDa4IIoJbI8KKVvtHMQfGKBcVgLgxtjeH5FoFS4GOg==
X-Received: by 2002:a65:50c8:: with SMTP id s8mr2028437pgp.68.1610502641398;
        Tue, 12 Jan 2021 17:50:41 -0800 (PST)
Received: from localhost.localdomain ([216.52.21.4])
        by smtp.gmail.com with ESMTPSA id a18sm388345pfg.107.2021.01.12.17.50.40
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 12 Jan 2021 17:50:40 -0800 (PST)
From:   Praveen Chaudhary <praveen5582@gmail.com>
X-Google-Original-From: Praveen Chaudhary <pchaudhary@linkedin.com>
To:     davem@davemloft.net, kuba@kernel.org, corbet@lwn.net,
        kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        netdev@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v1 net-next 0/1] Allow user to set metric on default route learned via Router Advertisement.
Date:   Tue, 12 Jan 2021 17:50:35 -0800
Message-Id: <20210113015036.17674-1-pchaudhary@linkedin.com>
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
 net/ipv6/ndisc.c                       | 14 ++++++++++----
 net/ipv6/route.c                       |  5 +++--
 8 files changed, 46 insertions(+), 7 deletions(-)


base-commit: 139711f033f636cc78b6aaf7363252241b9698ef
-- 
2.29.0

