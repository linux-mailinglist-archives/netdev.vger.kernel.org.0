Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30A0FFEAC3
	for <lists+netdev@lfdr.de>; Sat, 16 Nov 2019 06:50:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726154AbfKPFuT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Nov 2019 00:50:19 -0500
Received: from mail-pl1-f175.google.com ([209.85.214.175]:35621 "EHLO
        mail-pl1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725308AbfKPFuS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Nov 2019 00:50:18 -0500
Received: by mail-pl1-f175.google.com with SMTP id s10so6182399plp.2
        for <netdev@vger.kernel.org>; Fri, 15 Nov 2019 21:50:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id;
        bh=wu3oZoe7k2VRaLbPjoBkfivdC6jjhbmHb2d2waA+xmE=;
        b=RJafXH7/wnbzZ/f1XBe+ysZtpZoQKf/vdNKlUdPWdYgvfzPk/Gd5SN091+rNNn7XSg
         KlQZZ8v+XnJVWAXs5QojblIezQ8bRKQV9UPFloL8QMVbOdwpqnHJzG7zPF/jvwaQf7d/
         8D2cUNx4hLsF9mJCGsXsDpqPKnhmukPc+FJnYXDp+gFn7m2q11XzCpBqptcSMqemoDBw
         NzE05MVRn/Z1eQcVvP8sWt9G2sZcR9JfLvwIb9CAvYayabOc1iQ9YPAkvuMFo6CmcLP1
         /WPZa54zaz0t2Ds82YhvZUKRy9Ga7G8AtypaJM63XP+YZXXcq2PekFp4i4zag1fZY5w2
         DB1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id;
        bh=wu3oZoe7k2VRaLbPjoBkfivdC6jjhbmHb2d2waA+xmE=;
        b=aFuDnE56ZnyL8GK2tpe1MWRxq8EJyEYOnGuXublmUSS0lldgN+g4I00n24WRxSkKF0
         cvuITFTAaAz9/7fibOH7nb3mA/BqqWXvi1ON2spvDaLCCE1bDE29LrXL384keox8Ncjs
         VL9lEcSAXgzqLnZgVkHnHa5AB/qRnejcmTqS4poThI13k03eI/BktDRLppntBj7laa0q
         yM5jlB8ES2TtqKWznLG6wy5UE2GzdLaK3ezxzU4KsOlIxoxaLl49l7ltjFFS+Fg5dguW
         1zEHqEiS6EfQMaFWN1vxAoaGIZMdI8whcHWdNYZGRqXCI6GCnKAWqE+EixBds6GzsrB6
         Al0A==
X-Gm-Message-State: APjAAAV7c99tjXw8/bAvaZXQKJr8pMkcHKpll2j+LiU8aty/CKmcDmDv
        pcGkZVEM5tszfEI4E2WWMgk9z9Up
X-Google-Smtp-Source: APXvYqzQbOcaE4MJZilurMdT9zxOgTpyJuBbgJkqFfLAzT944f+q9PFjhh2aOaB7DPVAOHVRlvSObA==
X-Received: by 2002:a17:90a:2e87:: with SMTP id r7mr24504797pjd.21.1573883418006;
        Fri, 15 Nov 2019 21:50:18 -0800 (PST)
Received: from martin-VirtualBox.dlink.router ([171.61.89.87])
        by smtp.gmail.com with ESMTPSA id 82sm12478694pfa.115.2019.11.15.21.50.16
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 15 Nov 2019 21:50:17 -0800 (PST)
From:   Martin Varghese <martinvarghesenokia@gmail.com>
To:     netdev@vger.kernel.org, stephen@networkplumber.org,
        scott.drennan@nokia.com, jbenc@redhat.com,
        martin.varghese@nokia.com
Subject: [PATCH v3 net-next 0/1] Bareudp Device Support
Date:   Sat, 16 Nov 2019 11:20:04 +0530
Message-Id: <cover.1573872856.git.martin.varghese@nokia.com>
X-Mailer: git-send-email 1.9.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Martin Varghese <martin.varghese@nokia.com>

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

