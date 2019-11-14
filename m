Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5EC28FC5B7
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 12:54:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726767AbfKNLyn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 06:54:43 -0500
Received: from mail-pg1-f180.google.com ([209.85.215.180]:35838 "EHLO
        mail-pg1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726002AbfKNLyn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 06:54:43 -0500
Received: by mail-pg1-f180.google.com with SMTP id q22so3660027pgk.2
        for <netdev@vger.kernel.org>; Thu, 14 Nov 2019 03:54:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id;
        bh=wu3oZoe7k2VRaLbPjoBkfivdC6jjhbmHb2d2waA+xmE=;
        b=nL3s4TvvGX9TEWd72YbNcs9/3f5Avgpx4LbVLl9eDyukPhoyJd70+mdqP1hKuSgT1w
         imluiJsbEzNEkjYgWMbCbtN6sVgLiBN2h99eXv22i2gOWlq36jTfJx9pFfzK1Gh9fgZ8
         8XonzhhI+cFVdFykqSMDbR4bb3CT56cuqSZuoQQmCQqAxO6TLwTXFme+twRgdW9DRgB5
         U0IoIhmTySWGxcOCiJUYQmVukyKdfxacy0JAId/FI+jQJ4ySEXnLk7CO9EZxzElr8XzG
         n0LrwAIlj58thOivLJCWLK8dwNgFal2dkYpra7BlmFgJAo+4uoZ05Kl7V43uAzuFbhM/
         Q6Jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id;
        bh=wu3oZoe7k2VRaLbPjoBkfivdC6jjhbmHb2d2waA+xmE=;
        b=hAUZV9Kah0lOMJr1hjt318K0sByuSagDPAuOUgl/0OOcv2pG2NK6RXSq9JY99532Qv
         9jvFEwGcDlehH2+rs5l4l11Ivq5L0P2B2/Vaw/vUpAnnmlSy0TH1o4uqn8Yqe44ICiVC
         e6KDE1crOwvtC776Uq5OV6nrub8uBWRJlASlb72oA6cWf/PSZ+ocMhG4IzvzNRuwxS4C
         YiPdGCQwAhZDQNje59+uPfbEFXQcZBVICBw+BbsVd9PeW4137MV3Z7HNEGKJh6XU2TL6
         n7QgZ3XzJJIEPOXXEC/z0AGLGWe6sGQh/XoII9MxIEc1A2kg/9uGh9cFGBAaa9aDTORf
         UrHA==
X-Gm-Message-State: APjAAAVUKTXTlBb6iEhIjeDwNKGzYrxv6XjtRLMzk8VnXxvCTiB7XhX+
        pvV0D/2xnO9FK0pE8UCi+0eiVert
X-Google-Smtp-Source: APXvYqxhJApLesPR/5Q0iH9HOVDO8FrUb+Owd/JvzkvvLlY4m8Pzo9N43lIRhwGOlTNC83ecWZtp+w==
X-Received: by 2002:a17:90a:fc91:: with SMTP id ci17mr11789981pjb.13.1573732482228;
        Thu, 14 Nov 2019 03:54:42 -0800 (PST)
Received: from martin-VirtualBox.dlink.router ([171.61.89.87])
        by smtp.gmail.com with ESMTPSA id b26sm5991449pfo.158.2019.11.14.03.54.40
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 14 Nov 2019 03:54:41 -0800 (PST)
From:   Martin Varghese <martinvarghesenokia@gmail.com>
To:     netdev@vger.kernel.org, stephen@networkplumber.org,
        scott.drennan@nokia.com, jbenc@redhat.com,
        martin.varghese@nokia.com
Subject: [PATCH v2 net-next 0/1] Bareudp Device Support
Date:   Thu, 14 Nov 2019 17:24:34 +0530
Message-Id: <cover.1573654929.git.martin.varghese@nokia.com>
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

