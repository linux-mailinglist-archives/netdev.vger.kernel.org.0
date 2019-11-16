Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F886FEABC
	for <lists+netdev@lfdr.de>; Sat, 16 Nov 2019 06:43:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725879AbfKPFnu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Nov 2019 00:43:50 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:42010 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725308AbfKPFnt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Nov 2019 00:43:49 -0500
Received: by mail-pg1-f194.google.com with SMTP id q17so6952446pgt.9
        for <netdev@vger.kernel.org>; Fri, 15 Nov 2019 21:43:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id;
        bh=SxR9Z+TNioV7+LUNruLnxtBPLm4t33t9McTjJjr0wgI=;
        b=LcNYYJUXJn+pn3rMHC2mZdkIRNvFdHKzxoIiCFZmI0ZRcfsZ+KFNn74jIGPyrzp+8a
         m+pSJhCCs31pjQDt6qr2JWrBnKhoz7uV4MG/05HMSIWSy7CvNDoMVfyLHgUyKLK/dWxm
         M1Z9ODeSxuIdvXk2/7NONbsK9Olo5ACbSKA2fM+9taIyZ371BVehJJfpw5Dn3kEM3JS2
         BOHuSJTkLTdMVtm01Y+QM6yj75T1Alt1jPWJKdznT6n1+hANzRFo9af9x/s/19yVbgeC
         laaeUuVhC0LbB+xDFyMZE8/64mjact+t8O53RYOilhuGSj+pS9GaQelzNQ6uJIRlTZu4
         tn+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id;
        bh=SxR9Z+TNioV7+LUNruLnxtBPLm4t33t9McTjJjr0wgI=;
        b=mQbYtdUZmcvFI1VGmpH6DmBqLsIoipaqtnDUrdbp3rHqkpWBRxgzquyZYX2WPvUHFP
         Om/WeD6BVgXE0PeBRg8OhpXkzWX56nkquBzu0SfnvfP5Q81aUzWJzw6SeVb5ETmhY+tF
         dJqNQdD3TkyNNcLvgFAxyHXtyQZ8PrPZz/6qhp+BUF5SCKWAwZ0mYJRlCMwiveFkq5Zg
         4ytj3HqABpWGB27eS7LUlPDh+38BHsvswRCOLxGrkn5Adh/R+T2Ny2k8LHi+m6C6UrC2
         p5LPLN61vpVdsSKO0qHnbtTOQJHWpDTFc5JcnBi1i5cclPaSUN2zt2IT16+3R9MEhwxM
         nIjQ==
X-Gm-Message-State: APjAAAWlnL7nuO6q9xlGA5Yrsdfr548xpQrwMeItKurwO5jErBsUWB7z
        8U0xpl9BeUI7buSvYXEQot5XgJPb
X-Google-Smtp-Source: APXvYqzLpU0o4QmJFgzw91Qp/oEdvjyx6mNU/O+7YDWPyqq6IH0qVyauMgY3x3ZzwgmZAbPtWvOCUg==
X-Received: by 2002:a63:1402:: with SMTP id u2mr20424914pgl.391.1573883027376;
        Fri, 15 Nov 2019 21:43:47 -0800 (PST)
Received: from martin-VirtualBox.dlink.router ([171.61.89.87])
        by smtp.gmail.com with ESMTPSA id t15sm13847014pgb.0.2019.11.15.21.43.44
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 15 Nov 2019 21:43:46 -0800 (PST)
From:   Martin Varghese <martinvarghesenokia@gmail.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, corbet@lwn.net,
        kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        scott.drennan@nokia.com, jbenc@redhat.com,
        martin.varghese@nokia.com
Subject: [PATCH v3 net-next 0/2] Bare UDP L3 Encapsulation Module
Date:   Sat, 16 Nov 2019 11:13:32 +0530
Message-Id: <cover.1573872263.git.martin.varghese@nokia.com>
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

