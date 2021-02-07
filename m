Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A40AF3122A4
	for <lists+netdev@lfdr.de>; Sun,  7 Feb 2021 09:28:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230192AbhBGI1v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Feb 2021 03:27:51 -0500
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:46865 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230043AbhBGIY2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Feb 2021 03:24:28 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id 4EE6D5801A0;
        Sun,  7 Feb 2021 03:23:32 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sun, 07 Feb 2021 03:23:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=XYFXRjUwgrRZmzZxV
        h9ZrINx/hl3ZGvwW01z2V5kJfk=; b=UEb8RWeef0ubFQctXn//5MVt8D8A2NJzH
        /UjHFJjM07Do8GTxKWFMvSH6RmIi5zTXqf47bpLAgjusogjv/yoirDZbSpYbO3YB
        +2hN5spJj0aZCFjBGBEEmVeripV8bTqKAryDqAuMFOGUYjvX/6nOwAGOgrTC3NYD
        Orcv0JQmduuMB25hvbysxz6OpIRuTbsIMWPquyHm25NO9Ylj9aZto0cJid28iSXJ
        zp88CApEoDhHs7yeLVIu8KcYGqXU+YwPf2FjECZhZQ5I4+DXMW9Xvw+3p2Win95F
        zRy9PSQNOTqGI878eicR0M0c4NDX8V8fe6EmcC5FxsYdhscKz4nag==
X-ME-Sender: <xms:g6MfYNoEz9t6sRkHgdZiaf5YDEhYeeWEss3DcqUoBLht8pDZ0gRdlQ>
    <xme:g6MfYPlt7oLyZrcdRX5-KEhh0AtANjvH-R4TeD0c16agmsJ96tLt3JP7Y0wjdu-yA
    pKCkvOcHEw0fRg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrhedtgddvjecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffoggfgsedtkeertdertd
    dtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhstghh
    rdhorhhgqeenucggtffrrghtthgvrhhnpeetveeghfevgffgffekueffuedvhfeuheehte
    ffieekgeehveefvdegledvffduhfenucfkphepkeegrddvvdelrdduheefrdeggeenucev
    lhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthh
    esihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:g6MfYHF-A-fJ7rCteYgfIs18eV9r_u4GiOYJqpk3EtGXUfHqHPTcsw>
    <xmx:g6MfYApJ7c_RpfsWcz1YTFsF1dI-kOXO3cghNOlBN-ZzRqKjGReTjw>
    <xmx:g6MfYL4e3scq6JFfAH_h0Txg38DioaLDchv3iJhvVT-0Bg0VyANKeg>
    <xmx:hKMfYKAhPyzDpLcFiLcwS0GvKURX3l4e1vXg69Vysgh1wjET_J0XKw>
Received: from shredder.lan (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id A8678108005F;
        Sun,  7 Feb 2021 03:23:28 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, dsahern@gmail.com,
        jiri@nvidia.com, yoshfuji@linux-ipv6.org, amcohen@nvidia.com,
        roopa@nvidia.com, bpoirier@nvidia.com, sharpd@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 00/10] Add support for route offload failure notifications
Date:   Sun,  7 Feb 2021 10:22:48 +0200
Message-Id: <20210207082258.3872086-1-idosch@idosch.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

This is a complementary series to the one merged in commit 389cb1ecc86e
("Merge branch 'add-notifications-when-route-hardware-flags-change'").

The previous series added RTM_NEWROUTE notifications to user space
whenever a route was successfully installed in hardware or when its
state in hardware changed. This allows routing daemons to delay
advertisement of routes until they are installed in hardware.

However, if route installation failed, a routing daemon will wait
indefinitely for a notification that will never come. The aim of this
series is to provide a failure notification via a new flag
(RTM_F_OFFLOAD_FAILED) in the RTM_NEWROUTE message. Upon such a
notification a routing daemon may decide to withdraw the route from the
FIB.

Series overview:

Patch #1 adds the new RTM_F_OFFLOAD_FAILED flag

Patches #2-#3 and #4-#5 add failure notifications to IPv4 and IPv6,
respectively

Patches #6-#8 teach netdevsim to fail route installation via a new knob
in debugfs

Patch #9 extends mlxsw to mark routes with the new flag

Patch #10 adds test cases for the new notification over netdevsim

Amit Cohen (9):
  rtnetlink: Add RTM_F_OFFLOAD_FAILED flag
  IPv4: Add "offload failed" indication to routes
  IPv4: Extend 'fib_notify_on_flag_change' sysctl
  IPv6: Add "offload failed" indication to routes
  IPv6: Extend 'fib_notify_on_flag_change' sysctl
  netdevsim: fib: Do not warn if route was not found for several events
  netdevsim: fib: Add debugfs to debug route offload failure
  mlxsw: spectrum_router: Set offload_failed flag
  selftests: netdevsim: Test route offload failure notifications

Ido Schimmel (1):
  netdevsim: dev: Initialize FIB module after debugfs

 Documentation/networking/ip-sysctl.rst        |   6 +-
 .../ethernet/mellanox/mlxsw/spectrum_router.c |  58 +++++++-
 drivers/net/netdevsim/dev.c                   |  40 +++---
 drivers/net/netdevsim/fib.c                   | 123 +++++++++++++++-
 include/net/ip6_fib.h                         |   5 +-
 include/net/ip_fib.h                          |   3 +-
 include/uapi/linux/rtnetlink.h                |   5 +
 net/ipv4/fib_lookup.h                         |   3 +-
 net/ipv4/fib_semantics.c                      |   3 +
 net/ipv4/fib_trie.c                           |  13 +-
 net/ipv4/route.c                              |   1 +
 net/ipv4/sysctl_net_ipv4.c                    |   2 +-
 net/ipv6/route.c                              |  14 +-
 net/ipv6/sysctl_net_ipv6.c                    |   2 +-
 .../net/netdevsim/fib_notifications.sh        | 134 +++++++++++++++++-
 15 files changed, 372 insertions(+), 40 deletions(-)

-- 
2.29.2

