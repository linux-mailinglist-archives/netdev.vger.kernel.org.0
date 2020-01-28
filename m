Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8EC7D14BE25
	for <lists+netdev@lfdr.de>; Tue, 28 Jan 2020 17:57:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726618AbgA1Q46 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jan 2020 11:56:58 -0500
Received: from mail-pj1-f67.google.com ([209.85.216.67]:51239 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725881AbgA1Q46 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jan 2020 11:56:58 -0500
Received: by mail-pj1-f67.google.com with SMTP id fa20so1260251pjb.1
        for <netdev@vger.kernel.org>; Tue, 28 Jan 2020 08:56:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id;
        bh=ZJuvsYQcrXorljRvfWBDN0Ebxds4fkld46xnw6e7fek=;
        b=HhruMJ+sSR5HcIVnZdiz6AN6ngE3QqA9BAak8hC0q/C7rXSd/ooLazwflW9H7vOtEe
         /xmDZI1DTOvotKDo4JQKFOoY3kmRnYTkZFjfrSJ1hGPYj3N7mqp3i/wQ4w8aPDcMbctl
         nKfR3VoQfsvoKfPwkrc9SLRHaPGRrWqDz+Dv+fNMQL65G93V4VL9N2iyQlaAAcOYJ2+C
         BZj12KKD250z+huoGcZ4GSJiLL632Zv2Tg0GgvQjUJgpk+EjQeWsXIM/M4shieo2dKJ4
         gmYytYM/DFq4l4JADwceKfoKCSZr4dqyaOC343aA6MDCEJl7VxYlRwZYQnvLgwARzTn5
         9V9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id;
        bh=ZJuvsYQcrXorljRvfWBDN0Ebxds4fkld46xnw6e7fek=;
        b=UXpZpGx29V7/7/K6ox5/Beyd07M4l1P5jziodLXhVx22EA67PYdaMuaFIhU4WM8loG
         TmIpyJ6l92ZG0zNxSoQ3tmACrqfKqmD4pErq08/WzSGoph6oM2f07Sd4suLoKT8Twvid
         DBHXlg0vLtAz5hocP5wDOAT8Iwcgxyax7izFqmjH65qemW3HiHJ158+S/5feZfttGLxe
         NEoXTuECLGcUzXo2vEDbSIoEqs1Zz4UdVt+PioY0rXtXF1NlA5DhMpdmYWptkJyZze0w
         2MyJMfXP90WvENG9qaUIfTSKO4sKsBRPoIskhexjDzF4cl5AhjJkIwrY85Vqap2zfF2A
         chMA==
X-Gm-Message-State: APjAAAVOzTVd4V8KGc2UHrVR8vK9ejwpvKI4Lv1+XbjRL7GtR7gqIS2D
        C3ML+Vv9e1vVoRioAfSpVhj3Sq/0
X-Google-Smtp-Source: APXvYqwyGRmF1GQzC6aMjXKPslG2kW5ipDjYZNcsSzy0TFEkwhJVtnZ1OZon4hZLDvUDZD6Rpbzn1g==
X-Received: by 2002:a17:902:8a88:: with SMTP id p8mr23280376plo.179.1580230617353;
        Tue, 28 Jan 2020 08:56:57 -0800 (PST)
Received: from martin-VirtualBox.dlink.router ([122.178.219.138])
        by smtp.gmail.com with ESMTPSA id g19sm19750170pfh.134.2020.01.28.08.56.53
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 28 Jan 2020 08:56:56 -0800 (PST)
From:   Martin Varghese <martinvarghesenokia@gmail.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, corbet@lwn.net,
        kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        scott.drennan@nokia.com, jbenc@redhat.com,
        martin.varghese@nokia.com
Subject: [PATCH net-next v6 0/2] Bare UDP L3 Encapsulation Module
Date:   Tue, 28 Jan 2020 22:26:31 +0530
Message-Id: <cover.1580205811.git.martin.varghese@nokia.com>
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

Why not FOU ?
------------
FOU by design does l4 encapsulation.It maps udp port to ipproto (IP protocol number for l4 protocol).
Bareudp acheives a generic l3 encapsulation.It maps udp port to l3 ethertype.

Martin Varghese (2):
  net: UDP tunnel encapsulation module for tunnelling different
    protocols like     MPLS,IP,NSH etc.
  net: Special handling for IP & MPLS.

 Documentation/networking/bareudp.rst |  53 +++
 Documentation/networking/index.rst   |   1 +
 drivers/net/Kconfig                  |  13 +
 drivers/net/Makefile                 |   1 +
 drivers/net/bareudp.c                | 803 +++++++++++++++++++++++++++++++++++
 include/net/bareudp.h                |  20 +
 include/net/ipv6.h                   |   6 +
 include/net/route.h                  |   6 +
 include/uapi/linux/if_link.h         |  12 +
 net/ipv4/route.c                     |  48 +++
 net/ipv6/ip6_output.c                |  70 +++
 11 files changed, 1033 insertions(+)
 create mode 100644 Documentation/networking/bareudp.rst
 create mode 100644 drivers/net/bareudp.c
 create mode 100644 include/net/bareudp.h

-- 
1.8.3.1

