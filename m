Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B50215FCF7
	for <lists+netdev@lfdr.de>; Sat, 15 Feb 2020 06:39:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725825AbgBOFjq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Feb 2020 00:39:46 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:41266 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725795AbgBOFjq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Feb 2020 00:39:46 -0500
Received: by mail-pg1-f193.google.com with SMTP id 70so6109867pgf.8
        for <netdev@vger.kernel.org>; Fri, 14 Feb 2020 21:39:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id;
        bh=ZJuvsYQcrXorljRvfWBDN0Ebxds4fkld46xnw6e7fek=;
        b=UYNPpK4TheoVxzjLHc+1/cXP0n6/gYrYeh+Jh47EOmM/grtcj8zXzdZxLAT9D7IJcj
         jniD7LDULjkCfhT543s4S98ZB08dalIwFBwMLn0WuoBUQg0wUt7s/aj1Xpo+Z+e6m2Yw
         zrkVi5Y6Dw3QKN1HsLpfe3MIWivdi/teysqG3aLaG2qgagrir3AHpWTiiOy4IDPCQuZO
         G59YudI8xF8Unv6Sv1tSSYIhIom3tlzWEpw2EcNYPpO4N3T12JgNR703DhMsTYKNT088
         yTsG5H6fLmtxw91ajqmSK4D5JXwl9GqQlA//ZqpBEhMrLqdLbNF6OwDlmUrDUkaBMKbs
         49ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id;
        bh=ZJuvsYQcrXorljRvfWBDN0Ebxds4fkld46xnw6e7fek=;
        b=P/gHqJpgo9yxaTR209eVBb0gbRJSYRhNLOhL905uOSeD5ForTXGNgJnD6Oe4VQP+nk
         3VGyLZ0o1DM6UEd7MhrAeTQf3FaWsdDlG2KnxwCWn2CnWug7Vd7/BCbOKrFhiLOaOzyr
         1MN4OZPXFTLwjz+rXR7/F7tltG9tiWt6LANIskNBRAL4ZNgbT5hfYrukyOWzAZro98d/
         HAm45HJDi2uhAh6ndOjOExZtrvBHoMgim7ID4sdrzkYN3NYv39kgNGVpDveNIKt1zee/
         62dANEsXmO4ncmpW8u5od96PahDkIjHDAxrLVTv0Xz290jvviCOJKIP7PBB4g9L2F8r1
         Vlcg==
X-Gm-Message-State: APjAAAXGNNxmWjl+F6zvoRTaAkOUz42iR859V09ROUfPbhRqp8cTezQ1
        FltJASB20OpURsCv2A8XEoCZQsOT3Rc=
X-Google-Smtp-Source: APXvYqx1NNqp+9GXKaJXtF9wlv79XECrsQJ9HFI6CJAnGmT4W3nlO9GM50IT01h6kkCRUD54QFzHFA==
X-Received: by 2002:a63:d710:: with SMTP id d16mr7041534pgg.393.1581745184225;
        Fri, 14 Feb 2020 21:39:44 -0800 (PST)
Received: from martin-VirtualBox.vpn.alcatel-lucent.com ([137.97.74.10])
        by smtp.gmail.com with ESMTPSA id q11sm8703303pff.111.2020.02.14.21.39.39
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 14 Feb 2020 21:39:43 -0800 (PST)
From:   Martin Varghese <martinvarghesenokia@gmail.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, corbet@lwn.net,
        kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        scott.drennan@nokia.com, jbenc@redhat.com,
        martin.varghese@nokia.com
Subject: [PATCH net-next v6 0/2] Bare UDP L3 Encapsulation Module
Date:   Sat, 15 Feb 2020 11:09:34 +0530
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

