Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B23212A08B
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 23:43:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404286AbfEXVnO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 17:43:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:36856 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404252AbfEXVnO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 May 2019 17:43:14 -0400
Received: from kenny.it.cumulusnetworks.com. (fw.cumulusnetworks.com [216.129.126.126])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 86311217D7;
        Fri, 24 May 2019 21:43:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558734193;
        bh=7wKzb2VjOPDLjZyRhoVTuAYfvK7gxL0zoJzpkDUvJDs=;
        h=From:To:Cc:Subject:Date:From;
        b=IU6XyyT89O0U9LmGEdfiQdF5GnQbSxjpVfmc0xKjOxhvVAYzOgTQRcYKr7H/2lLmP
         Cpy2GiUs/Y8HS7sSuJn8SyXWQmcGYAedxdENBUX3Lkahl9aehH2yrnqoa7sZPXulLp
         kRxDXmKoE1ZG+qPNi9kWUGKcg3YWxjve1qC/owF8=
From:   David Ahern <dsahern@kernel.org>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     sharpd@cumulusnetworks.com, sworley@cumulusnetworks.com,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH net-next 0/6] net: API and initial implementation for nexthop objects
Date:   Fri, 24 May 2019 14:43:02 -0700
Message-Id: <20190524214308.18615-1-dsahern@kernel.org>
X-Mailer: git-send-email 2.11.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

This set contains the API and initial implementation for nexthops as
standalone objects.

Patch 1 contains the UAPI and updates to selinux struct.

Patch 2 contains the barebones code for nexthop commands, rbtree
maintenance and notifications.

Patch 3 then adds support for IPv4 gateways along with handling of
netdev events.

Patch 4 adds support for IPv6 gateways.

Patch 5 has the implementation of the encap attributes. 

Patch 6 adds support for nexthop groups.

At the end of this set, nexthop objects can be created and deleted and
userspace can monitor nexthop events, but ipv4 and ipv6 routes can not
use them yet. Once the nexthop struct is defined, follow on sets add it
to fib{6}_info and handle it within the respective code before routes
can be inserted using them.

David Ahern (6):
  net: nexthop uapi
  net: Initial nexthop code
  nexthop: Add support for IPv4 nexthops
  nexthop: Add support for IPv6 gateways
  nexthop: Add support for lwt encaps
  nexthop: Add support for nexthop groups

 include/net/net_namespace.h    |    2 +
 include/net/netns/nexthop.h    |   18 +
 include/net/nexthop.h          |  195 ++++++
 include/uapi/linux/nexthop.h   |   56 ++
 include/uapi/linux/rtnetlink.h |   10 +
 net/ipv4/Makefile              |    2 +-
 net/ipv4/nexthop.c             | 1479 ++++++++++++++++++++++++++++++++++++++++
 security/selinux/nlmsgtab.c    |    5 +-
 8 files changed, 1765 insertions(+), 2 deletions(-)
 create mode 100644 include/net/netns/nexthop.h
 create mode 100644 include/net/nexthop.h
 create mode 100644 include/uapi/linux/nexthop.h
 create mode 100644 net/ipv4/nexthop.c

-- 
2.11.0

