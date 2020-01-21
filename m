Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B4C614439C
	for <lists+netdev@lfdr.de>; Tue, 21 Jan 2020 18:52:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729255AbgAURwS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 12:52:18 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:35672 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728186AbgAURwS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jan 2020 12:52:18 -0500
Received: by mail-pl1-f193.google.com with SMTP id g6so1656556plt.2
        for <netdev@vger.kernel.org>; Tue, 21 Jan 2020 09:52:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id;
        bh=DlHRmqeo1gEu+hKfNhylOzWWt91H7EB52NxJexAP6+g=;
        b=Zp/eXfeNI/3i3lrpu7nY6VvVMZLG5cS+pIBVXA6lao2g/YG3mnIXqGBFPQ6D8fvqJ+
         0Wo4pQTmwwRaccVRvQMQ63vwalpqeiFxJWAuspT+3nBWJL3op+w+dQSGI4UgeSfVNJih
         dmQR9Y66NFO3Z73iiIStyOUmZiu+Kha9LvvMktIV5Yx3VGvxMkzSjpH+mDoT7hNMki5w
         l5iqA1AKFiZht7CVVBmewLFAt0CCqMigjzysb9XCr9tbIUNa6uexyZTR5uL50THajhcS
         Tf6Cst8soIu8NwbEGU+TyP5+jAKgIHgy650+WGxBrsdkX1s2jARf2dQjGJziO7XL0h3X
         3CPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id;
        bh=DlHRmqeo1gEu+hKfNhylOzWWt91H7EB52NxJexAP6+g=;
        b=LlPVDuYB5zdBHEZQmWNzaXZyQcX+ZKcw2G8PCs3XsMCMcnhD207dDTRcIpNv+kAbh6
         S4vAqhEOlEMR5M13/qqJhvUlSwzjIzk1DqQkxR7TrrvN3+6EC4P/JrDH6IwySk146BWr
         FgTv4j7f4jkbXlq6kf3IXHaFnnEQ4SCTtu+5oiHDlAX/r3yv8VLv2EPP0W+is0RzjFAJ
         RqJfgdA0tHy9kJdG8GFagTI187sP8FgjQS9Vkl5ed+YrzLcn/UOeQKmifuOzOzh/NYlA
         9WOLywAQbjgDKl78z60tk9IlG4qq1j3KGxGe+1lO34S0SieXcrauSJdCLfNZ+6KMi/M7
         Ha1A==
X-Gm-Message-State: APjAAAWpKgre/0rWSqSGGYSkIDQY6+bbh0lqM4/I8bBK7+b6GNpu9T84
        +C/x3Luapq9Xgdkc3aSy6rw8QzUH
X-Google-Smtp-Source: APXvYqzZn6DiGfI+E5wyFVxrxz7wAcU/CV5YKsbtagRmAoWX59mKLisIGJw51Kn82/pG3mcsKK137w==
X-Received: by 2002:a17:90b:3011:: with SMTP id hg17mr6649986pjb.90.1579629137503;
        Tue, 21 Jan 2020 09:52:17 -0800 (PST)
Received: from martin-VirtualBox.in.alcatel-lucent.com ([122.178.219.138])
        by smtp.gmail.com with ESMTPSA id b8sm44415428pff.114.2020.01.21.09.52.15
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 21 Jan 2020 09:52:17 -0800 (PST)
From:   Martin Varghese <martinvarghesenokia@gmail.com>
To:     netdev@vger.kernel.org, stephen@networkplumber.org,
        scott.drennan@nokia.com, jbenc@redhat.com,
        martin.varghese@nokia.com
Subject: [PATCH net-next v4 0/1] Bareudp Device Support
Date:   Tue, 21 Jan 2020 23:22:07 +0530
Message-Id: <cover.1579624340.git.martin.varghese@nokia.com>
X-Mailer: git-send-email 1.9.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Martin Varghese <martin.varghese@nokia.com>

There are various L3 encapsulation standards using UDP being discussed to
leverage the UDP based load balancing capability of different networks.
MPLSoUDP (__ https://tools.ietf.org/html/rfc7510) is one among them.

The Bareudp tunnel module provides a generic L3 encapsulation tunnelling
support for tunnelling different L3 protocols like MPLS, IP, NSH etc. inside
a UDP tunnel.

Special Handling
----------------
The bareudp device supports special handling for MPLS & IP as they can have
multiple ethertypes.
MPLS procotcol can have ethertypes ETH_P_MPLS_UC  (unicast) & ETH_P_MPLS_MC (multicast).
IP protocol can have ethertypes ETH_P_IP (v4) & ETH_P_IPV6 (v6).
This special handling can be enabled only for ethertypes ETH_P_IP & ETH_P_MPLS_UC
with a flag called multiproto mode.

Usage
------

1) Device creation & deletion

    a) ip link add dev bareudp0 type bareudp dstport 6635 ethertype 0x8847.

       This creates a bareudp tunnel device which tunnels L3 traffic with ethertype
       0x8847 (MPLS traffic). The destination port of the UDP header will be set to
       6635.The device will listen on UDP port 6635 to receive traffic.

    b) ip link delete bareudp0

2) Device creation with multiple proto mode enabled

There are two ways to create a bareudp device for MPLS & IP with multiproto mode
enabled.

    a) ip link add dev  bareudp0 type bareudp dstport 6635 ethertype 0x8847 multiproto

    b) ip link add dev  bareudp0 type bareudp dstport 6635 ethertype mpls

3) Device Usage

The bareudp device could be used along with OVS or flower filter in TC.
The OVS or TC flower layer must set the tunnel information in SKB dst field before
sending packet buffer to the bareudp device for transmission. On reception the
bareudp device extracts and stores the tunnel information in SKB dst field before
passing the packet buffer to the network stack.

Martin Varghese (1):
  Bareudp device support

 include/uapi/linux/if_link.h |  12 ++++
 ip/Makefile                  |   2 +-
 ip/iplink.c                  |   2 +-
 ip/iplink_bareudp.c          | 157 +++++++++++++++++++++++++++++++++++++++++++
 man/man8/ip-link.8.in        |  38 +++++++++++
 5 files changed, 209 insertions(+), 2 deletions(-)
 create mode 100644 ip/iplink_bareudp.c

-- 
1.8.3.1

