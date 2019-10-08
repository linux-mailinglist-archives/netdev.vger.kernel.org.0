Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4FAFECF670
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 11:51:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730030AbfJHJvB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 05:51:01 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:33860 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729375AbfJHJvB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Oct 2019 05:51:01 -0400
Received: by mail-pg1-f194.google.com with SMTP id y35so10001486pgl.1
        for <netdev@vger.kernel.org>; Tue, 08 Oct 2019 02:50:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=9l5cnRw8FDs0uaiGoLrj/pAhu1qbnf2id0ZSkjkP52s=;
        b=FgDaEes/QiiBklrrATLGwEpQr+mFxeRm/oCnFxru5UnDuz1G/aeOL7jMU0gJrMgAPc
         KROm5nqDhdowPmW3RLCn31KE8ZPJk/IdEaexqrM+ASsSdpN9UlNhNKAapQ2H3e9farP9
         Zfe5PgRf+bJu62ij/tjOA/dYXyr8P2PROWfbGypiWmCiWcUz4eFZa6p87PZqJKJ3o4QB
         B3YWAd5uvgOkY3Be3rkUGcIL+K7EJ9mRTBpBnbhtihFl6pabk03vYD4JCVxJJ4mLHctU
         HEuxwveQQWMsAMV6868GiYjs/qxwKUpttwERxiooC0U5Y5NWlx0/ISat/i0lDH5MQcnn
         wocg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=9l5cnRw8FDs0uaiGoLrj/pAhu1qbnf2id0ZSkjkP52s=;
        b=j4FMt9hwgA+jhXj37U1TpVT3hs8w0LYQAvFGDoEBUfIbatSi79WA4YVJItENaeFUXq
         P5+7hb8So7gBBqC/yKUX4BFJiBsp2zk7tauqgjVeqh3oGLG2d6bxwHeR+oiLQTsEOasA
         NT245uadPGZUSKTEmlgiNLzeKfwzft5H/BGe+C+jd7GhSVQU6fesGH6CX6vW2ng/uMC1
         HWd6UGvw7ZH+1Xi+wyd60S8sxTGo67pBV8glCo2J2tQM0zbb7oCQXMDbdXXUF0ZWiPeM
         ilZMvcD9QTwiv1OtPIFAlUUPYG8zinfhrPTP0bmIiGMpd8Qn9Q9bVVpZj78V8hF07dR6
         prSQ==
X-Gm-Message-State: APjAAAXmTnjTK4AqP7OYbzM8O1WNc+08wDh4oDK8fcf2U1piaU41GQOq
        es2Bh1XFTkU6PJv2gXnaIAe5gQvu
X-Google-Smtp-Source: APXvYqxb+nrPdtO6tTuBBDbbox44pTvebkoO5jp7keabbT+swfr+1wAqu3UOXxle46/7nG9mvDDxPQ==
X-Received: by 2002:a17:90a:ad48:: with SMTP id w8mr4822657pjv.43.1570528258886;
        Tue, 08 Oct 2019 02:50:58 -0700 (PDT)
Received: from martin-VirtualBox.dlink.router ([122.178.241.240])
        by smtp.gmail.com with ESMTPSA id f188sm19970933pfa.170.2019.10.08.02.50.56
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 08 Oct 2019 02:50:58 -0700 (PDT)
From:   Martin Varghese <martinvarghesenokia@gmail.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, corbet@lwn.net,
        scott.drennan@nokia.com, jbenc@redhat.com,
        martin.varghese@nokia.com
Cc:     Martin Varghese <martinvarghesenokia@gmail.com>
Subject: [PATCH net-next 0/2]  Bareudp Tunnel Module
Date:   Tue,  8 Oct 2019 15:18:14 +0530
Message-Id: <cover.1570455278.git.martinvarghesenokia@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are various L3 encapsulation standards using UDP being discussed to
leverage the UDP based load balancing capability of different networks.
MPLSoUDP (https://tools.ietf.org/html/rfc7510)is one among them.

The Bareudp tunnel module provides a generic L3 encapsulation tunnelling
support for tunnelling different L3 protocols like MPLS, IP, NSH etc. inside
a UDP tunnel.

Special Handling
----------------
The bareudp device supports special handling for MPLS & IP as they can have
multiple ethertypes.
MPLS procotcol can have ethertypes 0x8847 (unicast) & 0x8847 (multicast).
IP proctocol can have ethertypes 0x0800 (v4) & 0x866 (v6).
This special handling can be enabled only for ethertype 0x0800 & 0x88847 with a
flag called extended mode.

Usage
------

1. Device creation & deletion

a. ip link add dev bareudp0 type bareudp dstport 6635 ethertype 0x8847

This creates a bareudp tunnel device which tunnels L3 traffic with ethertype
0x8847 (MPLS traffic).The destination port of the UDP header will be set to 6635
The device will listen on UDP port 6635 to receive traffic.

b. ip link delete bareudp0

2. Device creation with extended mode enabled

There are two ways to create a bareudp device for MPLS & IP with extended mode
enabled

a. ip link add dev  bareudp0 type bareudp dstport 6635 ethertype 0x8847 extmode 1

b. ip link add dev  bareudp0 type bareudp dstport 6635 ethertype mpls

Note - iproute2 & Selftests are implemented in seperate patches.


Martin (2):
  UDP tunnel encapsulation module for tunnelling different protocols    
    like MPLS,IP,NSH etc.
  Special handling for IP & MPLS.

 Documentation/networking/bareudp.txt |  41 ++
 drivers/net/Kconfig                  |  13 +
 drivers/net/Makefile                 |   1 +
 drivers/net/bareudp.c                | 998 +++++++++++++++++++++++++++++++++++
 include/net/bareudp.h                |  20 +
 include/uapi/linux/if_link.h         |  13 +
 6 files changed, 1086 insertions(+)
 create mode 100644 Documentation/networking/bareudp.txt
 create mode 100644 drivers/net/bareudp.c
 create mode 100644 include/net/bareudp.h

-- 
1.8.3.1

