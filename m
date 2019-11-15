Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C3501FD39A
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 05:23:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726956AbfKOEXa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 23:23:30 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:33247 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726549AbfKOEXa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 23:23:30 -0500
Received: by mail-pg1-f193.google.com with SMTP id h27so5194736pgn.0
        for <netdev@vger.kernel.org>; Thu, 14 Nov 2019 20:23:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id;
        bh=lRjeNlv6a3fUWGiiKJCxmbfheR1iGPEtE+GRaDdZ678=;
        b=IpkLKbmrqB62pHbmbNa6zhMAWY5j04Pk+4+kKLla7QFGqkcdktI8bSqWXv7OoqIlF3
         HhGBM6VGn19LVB23Ub5PVoShpdFmS4dye+p/diDOiz4TRKUOzVH+eyr4B9Qk2tU/4f5P
         8Mrt5ZD75fNgnQgAKh+/OgcNM4ze9H6IgBKmraeCW+zwlSHetjogVRyCl/p2wfsqEooj
         2A4KDunRx5UI+fISxiHOSWzpZa7Lcycz4gAAk9eBEVKfmC8khlPVgwzzTPlJgaMD/pRG
         gsMDnMxeJkcihL3eglQkxADogFbAIh3rNFJY6qEhLHfybry66LcNF7sS5hAx1+PIx0Vj
         twfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id;
        bh=lRjeNlv6a3fUWGiiKJCxmbfheR1iGPEtE+GRaDdZ678=;
        b=JMqo95zgGkySmEZuT66M2MraLfy8+izyGIod6lNmYTaM+97GEe1zjQ+YDSkIFYiPGA
         C2r3kgoMS+YpnJi67UbTyOUcfd0IPACJ2y4UkxuxrjgLsVMzD48BHPyVi6XfAE5fNNHR
         m+G+l6S7J1VTDnPtOWs3ew3T6kElur5xMuN4uIsusYNMPt4PMlATapYXXSgMdDbH2C8y
         p4GoM8L6CWfTMNUoQ7LKi9afakz/T1OQ5xNvo//l16/N5EsLrhhF0SyyGnv++fRClyJ+
         EpYpz9TG/IG0xvEh1xSEkM3PnlclZUxvioxw+NKN+cyUQgScs2VYkCzGXZP1f0EHwgOM
         90MQ==
X-Gm-Message-State: APjAAAXCgKbHr42qEDfyXPH3YHyskK8Xz4srmxInpoi4e8oZQoub2eAY
        ZSEz0E93cep0uFNi+LKAd1iedJ7Q
X-Google-Smtp-Source: APXvYqz8HmUrDJfIy8c9xz+XCNDwEcSmNaquMTomKXQFbG3vaTPH5Goe1Zs2nan9ibbhQarBPW4zug==
X-Received: by 2002:aa7:860f:: with SMTP id p15mr15144123pfn.104.1573791808984;
        Thu, 14 Nov 2019 20:23:28 -0800 (PST)
Received: from localhost.localdomain ([112.79.83.185])
        by smtp.gmail.com with ESMTPSA id v15sm9110332pfc.85.2019.11.14.20.23.24
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 14 Nov 2019 20:23:28 -0800 (PST)
From:   Martin Varghese <martinvarghesenokia@gmail.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, corbet@lwn.net,
        kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        scott.drennan@nokia.com, jbenc@redhat.com,
        martin.varghese@nokia.com
Subject: [PATCH v2 net-next 0/2] Bare UDP L3 Encapsulation Module
Date:   Fri, 15 Nov 2019 09:53:13 +0530
Message-Id: <cover.1573659466.git.martin.varghese@nokia.com>
X-Mailer: git-send-email 1.9.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Martin Varghese <martin.varghese@nokia.com>

There are various L3 encapsulation standards using UDP being discussed to
leverage the UDP based load balancing capability of different networks.
MPLSoUDP (https://tools.ietf.org/html/rfc7510) is one among them.

The Bareudp tunnel module provides a generic L3 encapsulation tunnelling
support for tunnelling different L3 protocols like MPLS, IP, NSH etc. inside
a UDP tunnel.

Special Handling
----------------
The bareudp device supports special handling for MPLS & IP as they can have
multiple ethertypes.
MPLS procotcol can have ethertypes 0x8847 (unicast) & 0x8848 (multicast).
IP proctocol can have ethertypes 0x0800 (v4) & 0x86dd (v6).
This special handling can be enabled only for ethertype 0x0800 & 0x8847 with a
flag called extended mode.

Usage
------

1. Device creation & deletion

a. ip link add dev bareudp0 type bareudp dstport 6635 ethertype 0x8847

This creates a bareudp tunnel device which tunnels L3 traffic with ethertype
0x8847 (MPLS traffic). The destination port of the UDP header will be set to 6635
The device will listen on UDP port 6635 to receive traffic.

b. ip link delete bareudp0

2. Device creation with extended mode enabled

There are two ways to create a bareudp device for MPLS & IP with extended mode
enabled.

a. ip link add dev  bareudp0 type bareudp dstport 6635 ethertype 0x8847 extmode 1

b. ip link add dev  bareudp0 type bareudp dstport 6635 ethertype mpls

Why not FOU ?
------------
FOU by design does l4 encapsulation.It maps udp port to ipproto (IP protocol number
for l4 protocol).

Bareudp acheives a generic l3 encapsulation.It maps udp port to l3 ethertype

For example in the case of MPLS -

In the egress direction an MPLS packet  "eth header | mpls header | payload" is
encapsulated to "eth header | ip header | udp header | mpls header | payload"

In the Ingress direction the udp tunnel packet
"eth header | ip header | udp header | mpls header | payload" is decapsulated to
"eth header | mpls header | payload"


Martin Varghese (2):
  UDP tunnel encapsulation module for tunnelling different protocols    
    like MPLS,IP,NSH etc.
  Special handling for IP & MPLS.

 Documentation/networking/bareudp.rst |  44 ++
 Documentation/networking/index.rst   |   1 +
 drivers/net/Kconfig                  |  13 +
 drivers/net/Makefile                 |   1 +
 drivers/net/bareudp.c                | 876 +++++++++++++++++++++++++++++++++++
 include/net/bareudp.h                |  20 +
 include/net/ip6_tunnel.h             |  45 ++
 include/net/ip_tunnels.h             |  42 ++
 include/uapi/linux/if_link.h         |  13 +
 9 files changed, 1055 insertions(+)
 create mode 100644 Documentation/networking/bareudp.rst
 create mode 100644 drivers/net/bareudp.c
 create mode 100644 include/net/bareudp.h

-- 
1.8.3.1

