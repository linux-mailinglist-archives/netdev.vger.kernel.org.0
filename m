Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5D6927BF05
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 10:17:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727731AbgI2IQ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 04:16:56 -0400
Received: from wnew1-smtp.messagingengine.com ([64.147.123.26]:59429 "EHLO
        wnew1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725786AbgI2IQ4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 04:16:56 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.west.internal (Postfix) with ESMTP id C8F319DE;
        Tue, 29 Sep 2020 04:16:54 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 29 Sep 2020 04:16:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=maCBlS4YL09SfBfoU
        K486fQLafDOP2uX0oH+5WVdjgQ=; b=HUtQueSeteAr0fK9IVlBnCGZ7Y7Iml7lG
        /dI65u8p2D/9maRtSeq/h8cIhThFQ4KuHGLFld/EOwB6v9imRGUoNZy1JFRma2QL
        cgTrvSqwhwR+EApE5t8q8SjtXmWHA7DPEMQfCEpR0N47V0qGQGbGDROTkPzMgVoX
        W+s/eHkVatyc/dlOSBKiX8s1IGPVCnMFjiIH36J4MRON7XWoGsjjO+FeNVoqNjGd
        kmLu35rSUjl16ZO7W9UOdvjjgXp3WNUlQHfu9Ewd5vNoTKU/Qk/N48g35MySEOXq
        eLp8VgkzTMdbiTu26Gxcr0yYEgrh6E568+pAKSrczxGiPNyuw0Z3Q==
X-ME-Sender: <xms:de1yX-dUD6pTpaX-_2mxVcWmVUNvsKMd25HPnkXNEhzXtIExN2BMGg>
    <xme:de1yX4PMuA25P1YUgpfQ6kY9GcXPep7txCbrCy-r4S6x1x1bMnV4qOdtk22h0dc3j
    DLxkdriU2wsL20>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvdekgddtvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffoggfgsedtkeertdertd
    dtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhstghh
    rdhorhhgqeenucggtffrrghtthgvrhhnpeetveeghfevgffgffekueffuedvhfeuheehte
    ffieekgeehveefvdegledvffduhfenucfkphepkeegrddvvdelrdefjedrudegkeenucev
    lhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthh
    esihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:de1yX_gdkfkaUhqRE_yrB-4hTzODpqbYFJAK6hKEj7nVpmWHsY-J6w>
    <xmx:de1yX7_-OZnS8UtzLoQrf7HZh3lt0KiximcrdwVCsoiChBqijGiHlQ>
    <xmx:de1yX6vV6A6gKgqvXbYfbsw-aDsl5lka7f2VFGPX4zbeYZoqPYws-A>
    <xmx:du1yX399SqtBS9N-R6V8BOaOiK1mlBJOeUQ5DBYkl_8TO73vk_lePp1dZDg>
Received: from shredder.mtl.com (igld-84-229-37-148.inter.net.il [84.229.37.148])
        by mail.messagingengine.com (Postfix) with ESMTPA id 11AF6328005A;
        Tue, 29 Sep 2020 04:16:50 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, nhorman@tuxdriver.com,
        jiri@nvidia.com, roopa@nvidia.com, aroulin@nvidia.com,
        ayal@nvidia.com, masahiroy@kernel.org, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 0/7] drop_monitor: Convert to use devlink tracepoint
Date:   Tue, 29 Sep 2020 11:15:49 +0300
Message-Id: <20200929081556.1634838-1-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Drop monitor is able to monitor both software and hardware originated
drops. Software drops are monitored by having drop monitor register its
probe on the 'kfree_skb' tracepoint. Hardware originated drops are
monitored by having devlink call into drop monitor whenever it receives
a dropped packet from the underlying hardware.

This patch set converts drop monitor to monitor both software and
hardware originated drops in the same way - by registering its probe on
the relevant tracepoint.

In addition to drop monitor being more consistent, it is now also
possible to build drop monitor as module instead of as a builtin and
still monitor hardware originated drops. Initially, CONFIG_NET_DEVLINK
implied CONFIG_NET_DROP_MONITOR, but after commit def2fbffe62c
("kconfig: allow symbols implied by y to become m") we can have
CONFIG_NET_DEVLINK=y and CONFIG_NET_DROP_MONITOR=m and hardware
originated drops will not be monitored.

Patch set overview:

Patch #1 adds a tracepoint in devlink for trap reports.

Patch #2 prepares probe functions in drop monitor for the new
tracepoint.

Patch #3 converts drop monitor to use the new tracepoint.

Patches #4-#6 perform cleanups after the conversion.

Patch #7 adds a test case for drop monitor. Both software originated
drops and hardware originated drops (using netdevsim) are tested.

Tested:

| CONFIG_NET_DEVLINK | CONFIG_NET_DROP_MONITOR | Build | SW drops | HW drops |
| -------------------|-------------------------|-------|----------|----------|
|          y         |            y            |   v   |     v    |     v    |
|          y         |            m            |   v   |     v    |     v    |
|          y         |            n            |   v   |     x    |     x    |
|          n         |            y            |   v   |     v    |     x    |
|          n         |            m            |   v   |     v    |     x    |
|          n         |            n            |   v   |     x    |     x    |

Ido Schimmel (7):
  devlink: Add a tracepoint for trap reports
  drop_monitor: Prepare probe functions for devlink tracepoint
  drop_monitor: Convert to using devlink tracepoint
  drop_monitor: Remove no longer used functions
  drop_monitor: Remove duplicate struct
  drop_monitor: Filter control packets in drop monitor
  selftests: net: Add drop monitor test

 MAINTAINERS                                   |   1 -
 include/net/devlink.h                         |  16 ++
 include/net/drop_monitor.h                    |  36 ---
 include/trace/events/devlink.h                |  37 +++
 net/Kconfig                                   |   1 -
 net/core/devlink.c                            |  37 ++-
 net/core/drop_monitor.c                       | 133 ++++++-----
 tools/testing/selftests/net/Makefile          |   1 +
 tools/testing/selftests/net/config            |   3 +
 .../selftests/net/drop_monitor_tests.sh       | 215 ++++++++++++++++++
 10 files changed, 368 insertions(+), 112 deletions(-)
 delete mode 100644 include/net/drop_monitor.h
 create mode 100755 tools/testing/selftests/net/drop_monitor_tests.sh

-- 
2.26.2

