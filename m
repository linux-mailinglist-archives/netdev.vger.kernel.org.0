Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E28D2260E5B
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 11:11:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728656AbgIHJL1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 05:11:27 -0400
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:34159 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727995AbgIHJL1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 05:11:27 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id 4507CE88;
        Tue,  8 Sep 2020 05:11:26 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Tue, 08 Sep 2020 05:11:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=FlKzlICP6X7d1d0Tm
        9n3dnKw23n/U3hVZEh5dotLIKo=; b=butCl+6NxTBNsvBSb23Ss2Fn9jQ8f4QXd
        V+dxFrKv9AbXE3ALST7pnfeJWTIUWcFWBxaAS4pokun/DvT6xwsy6OVJpcVApXst
        xbs8PMwBk+rdsk81QTsEXUDvN3ofkcOFHmws3bNxeNG2jt6r1havJWbogoU5Ixdg
        +AWWojLCtF4dnjb4wDluvSsWdEowN+tL/3EUMOm8VBRj32KYYRFw7atz55VWhkxb
        b2AQwvmLBSxeKpCV94h+XFL0e5Hewr2PCBZ3jizqO9oJLmwki+RHJtZ7NC1mDoLd
        xjJun42kiJ7YK4FuGs75IyRzlpQJFnnQUWJp4F91sYIhIFZjAs6YQ==
X-ME-Sender: <xms:vUpXX7gw1FIVX3jCrjAw5OIU17v5HXkEz-UqdWV79XYqPYaLVBrjhA>
    <xme:vUpXX4AqtKlCCru0ZmOosYLM0UPRtbKdwQ7yyJHl0PNMgc8cOk5SR8fF8Bs7oYd7l
    RUnwnsZ0Nd7Qvo>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrudehvddguddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgggfestdekredtre
    dttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiughoshgt
    hhdrohhrgheqnecuggftrfgrthhtvghrnhepteevgefhvefggfffkeeuffeuvdfhueehhe
    etffeikeegheevfedvgeelvdffudfhnecukfhppeekgedrvddvledrfeeirdduvdeknecu
    vehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstg
    hhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:vUpXX7FwRUXD3IG7GpVGnOFQe72eCs3OSFqZklxymw6tyEIjcd7QwA>
    <xmx:vUpXX4Rt34cEzjnW86czMaf3a3z3gylieDtgvkMaKGsAEPlDKX0jOw>
    <xmx:vUpXX4z9eUBYGVFAf8m-OpvmsdoVPhOTrerZiZHyCLR8TDM8w5baIQ>
    <xmx:vUpXX0-uaCCs162xXtvEpxUyaFp5ZXbuhNJ08A5IYBISlA-OzG0l_w>
Received: from shredder.mtl.com (igld-84-229-36-128.inter.net.il [84.229.36.128])
        by mail.messagingengine.com (Postfix) with ESMTPA id 3678D306467D;
        Tue,  8 Sep 2020 05:11:24 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, dsahern@gmail.com,
        roopa@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [RFC PATCH net-next 00/22] nexthop: Add support for nexthop objects offload
Date:   Tue,  8 Sep 2020 12:10:15 +0300
Message-Id: <20200908091037.2709823-1-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Note: I'm aware that 22 patches is a lot and I will split it for the
non-RFC submission. Sending all in one piece to see if there are general
comments regarding the interface. Also, most of the patches are very
small.

This patch set adds support for nexthop objects offload with a dummy
implementation over netdevsim. mlxsw support will be added later.

The general idea is very similar to route offload in that notifications
are sent whenever nexthop objects are changed. A listener can veto the
change and the error will be communicated to user space with extack.

To keep listeners as simple as possible, they not only receive
notifications for the nexthop object that is changed, but also for all
the other objects affected by this change. For example, when a single
nexthop is replaced, a replace notification is sent for the single
nexthop, but also for all the nexthop groups this nexthop is member in.
This relieves listeners from the need to track such dependencies.

To simplify things further for listeners, the notification info does not
contain the raw nexthop data structures (e.g., 'struct nexthop'), but
less complex data structures into which the raw data structures are
parsed into.

Tested with a new selftest over netdevsim and with fib_nexthops.sh:

Tests passed: 164
Tests failed:   0

Patch set overview:

Patches #1-#4 perform small cleanups and covert the existing nexthop
notification chain to a blocking one, so that device drivers could block
when programming nexthops to hardware. This is safe because all
notifications are emitted from a process context.

Patches #5-#8 introduce the aforementioned data structures and convert
existing listeners (i.e., the VXLAN driver) to use them.

Patches #9-#10 add a new RTNH_F_TRAP flag and the ability to set it and
RTNH_F_OFFLOAD on nexthops. This flag is used by netdevsim for testing
purposes and will also be used by mlxsw. These flags are consistent with
the existing RTM_F_OFFLOAD and RTM_F_TRAP flags.

Patches #11-#18 gradually add the new nexthop notifications.

Patches #19-#22 add a dummy implementation for nexthop offload over
netdevsim and a selftest to exercise both good and bad flows.

Ido Schimmel (22):
  nexthop: Remove unused function declaration from header file
  nexthop: Convert to blocking notification chain
  nexthop: Only emit a notification when nexthop is actually deleted
  selftests: fib_nexthops: Test cleanup of FDB entries following nexthop
    deletion
  nexthop: Add nexthop notification data structures
  nexthop: Pass extack to nexthop notifier
  nexthop: Prepare new notification info
  nexthop: vxlan: Convert to new notification info
  rtnetlink: Add RTNH_F_TRAP flag
  nexthop: Allow setting "offload" and "trap" indications on nexthops
  nexthop: Emit a notification when a nexthop is added
  nexthop: Emit a notification when a nexthop group is replaced
  nexthop: Emit a notification when a single nexthop is replaced
  nexthop: Emit a notification when a nexthop group is modified
  nexthop: Emit a notification when a nexthop group is reduced
  nexthop: Pass extack to register_nexthop_notifier()
  nexthop: Replay nexthops when registering a notifier
  nexthop: Remove in-kernel route notifications when nexthop changes
  netdevsim: Add devlink resource for nexthops
  netdevsim: Add dummy implementation for nexthop offload
  netdevsim: Allow programming routes with nexthop objects
  selftests: netdevsim: Add test for nexthop offload API

 .../networking/devlink/netdevsim.rst          |   3 +-
 drivers/net/netdevsim/dev.c                   |   6 +
 drivers/net/netdevsim/fib.c                   | 265 +++++++++++-
 drivers/net/netdevsim/netdevsim.h             |   1 +
 drivers/net/vxlan.c                           |  12 +-
 include/net/netns/nexthop.h                   |   2 +-
 include/net/nexthop.h                         |  45 +-
 include/uapi/linux/rtnetlink.h                |   6 +-
 net/ipv4/fib_semantics.c                      |   2 +
 net/ipv4/fib_trie.c                           |   9 -
 net/ipv4/nexthop.c                            | 262 ++++++++++-
 net/ipv6/route.c                              |   5 -
 .../drivers/net/netdevsim/nexthop.sh          | 408 ++++++++++++++++++
 tools/testing/selftests/net/fib_nexthops.sh   |  14 +
 14 files changed, 985 insertions(+), 55 deletions(-)
 create mode 100755 tools/testing/selftests/drivers/net/netdevsim/nexthop.sh

-- 
2.26.2

