Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4214B2A6531
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 14:31:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729827AbgKDNbl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 08:31:41 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:38539 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726691AbgKDNbl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 08:31:41 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 0C4825C0058;
        Wed,  4 Nov 2020 08:31:40 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Wed, 04 Nov 2020 08:31:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=ku9G2JgBQ6N6oQECI
        kn+awm5XvKyh0b1onYA0aWaLO4=; b=GmfHADYH4o5kdIajxZ6QJz5vNl2/bmlO3
        L1vZ/KH0oqENW1I0NL78mHwdA/PMN17Vor/zRpnj0cCnq3wv4hTg8/s8P5vfW9Xp
        RjLPetwvLF+zsRRPnuhkdk8YS0vRhqR3sxpuLwTJXCvOrp/flBrrtOgZmSez71f3
        3EVJA+F+kcaDFY4y+2FoyUKe1gto4LBq3LitSH5T9UlQGOmmiF2A4ZdJpwRfDjmo
        fV4QLrC3UNe12jYt2MQorOgGl8UElP1VqxtACAXhevRkyucKHZtMBp9hYFMueHMJ
        VqzZ/lZuEbMceZ8h8K0imkJ9Bvmo1NCjRbpbw0Y3OnrOyVKCAi+eQ==
X-ME-Sender: <xms:O62iX2dZ9hnHB3razaBBBc89YfGHoFk7sDBgzlR2akFlVcW8CiCGvg>
    <xme:O62iXwO3IGcWFZjci9zE1y9ekcYqqpdC18VEZhC2c2iUp2NgpJSI5GtJYhA13f-zr
    6lWfYBrvI7DTxw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedruddthedgheehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgggfestdekredtre
    dttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiughoshgt
    hhdrohhrgheqnecuggftrfgrthhtvghrnhepleeuffeukeejteeugfdvgfdtheefgfejud
    ethfdtveeujedvkefguddvudfhjeefnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghen
    ucfkphepkeegrddvvdelrdduhedvrddvheehnecuvehluhhsthgvrhfuihiivgeptdenuc
    frrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:O62iX3j2fpUg762gfidJhDaa5Z0NqVHJVdYHoQv4pZ1gaxjnCKUKYQ>
    <xmx:O62iXz8tAkQzblgIrRnQlT2AHZIR8bMZGdda7WeQp47O5jNvSdxQQw>
    <xmx:O62iXyui6337UK29S207fR7KKDeK4BXrz3PDqFFP4aiVz97icwksvA>
    <xmx:PK2iX2IDAvnvdNXIvGuTLQvWrhYvDHunLcu44IsnZaRiF_A5iOdZ8w>
Received: from shredder.mtl.com (unknown [84.229.152.255])
        by mail.messagingengine.com (Postfix) with ESMTPA id 6F2AC3064680;
        Wed,  4 Nov 2020 08:31:38 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, dsahern@gmail.com,
        jiri@nvidia.com, mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 00/18] nexthop: Add support for nexthop objects offload
Date:   Wed,  4 Nov 2020 15:30:22 +0200
Message-Id: <20201104133040.1125369-1-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

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

Patches #1-#4 introduce the aforementioned data structures and convert
existing listeners (i.e., the VXLAN driver) to use them.

Patches #5-#6 add a new RTNH_F_TRAP flag and the ability to set it and
RTNH_F_OFFLOAD on nexthops. This flag is used by netdevsim for testing
purposes and will also be used by mlxsw. These flags are consistent with
the existing RTM_F_OFFLOAD and RTM_F_TRAP flags.

Patches #7-#14 gradually add the new nexthop notifications.

Patches #15-#18 add a dummy implementation for nexthop offload over
netdevsim and a selftest to exercise both good and bad flows.

Changes since RFC [1]:

Patch #1: s/is_encap/has_encap/
Patch #3: Add a blank line in __nh_notifier_single_info_init()
Patch #5: Reword commit message
Patch #6: s/nexthop_hw_flags_set/nexthop_set_hw_flags/
Patch #7: Reword commit message
Patch #11: Allocate extack on the stack

Follow-up patch sets:

selftests: forwarding: Add nexthop objects tests
mlxsw: Preparations for nexthop objects support - part 1/2
mlxsw: Preparations for nexthop objects support - part 2/2
mlxsw: Add support for nexthop objects
mlxsw: Add support for blackhole nexthops
mlxsw: Update adjacency index more efficiently

[1] https://lore.kernel.org/netdev/20200908091037.2709823-1-idosch@idosch.org/

Ido Schimmel (18):
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
 drivers/net/netdevsim/fib.c                   | 265 ++++++++++-
 drivers/net/netdevsim/netdevsim.h             |   1 +
 drivers/net/vxlan.c                           |  12 +-
 include/net/nexthop.h                         |  42 +-
 include/uapi/linux/rtnetlink.h                |   6 +-
 net/ipv4/fib_semantics.c                      |   2 +
 net/ipv4/fib_trie.c                           |   9 -
 net/ipv4/nexthop.c                            | 255 +++++++++-
 net/ipv6/route.c                              |   5 -
 .../drivers/net/netdevsim/nexthop.sh          | 436 ++++++++++++++++++
 12 files changed, 995 insertions(+), 47 deletions(-)
 create mode 100755 tools/testing/selftests/drivers/net/netdevsim/nexthop.sh

-- 
2.26.2

