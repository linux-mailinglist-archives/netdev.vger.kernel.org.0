Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2987433A4AF
	for <lists+netdev@lfdr.de>; Sun, 14 Mar 2021 13:22:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235320AbhCNMUr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Mar 2021 08:20:47 -0400
Received: from new2-smtp.messagingengine.com ([66.111.4.224]:59319 "EHLO
        new2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229837AbhCNMUR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Mar 2021 08:20:17 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id 9F4C95808B9;
        Sun, 14 Mar 2021 08:20:16 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sun, 14 Mar 2021 08:20:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=1cCuyqLB5lZGxBrM9
        pfyK9oN21tcQyv3WmbRD/0mHP0=; b=Ie27E9aphkJz2nYMNpCbNPoVp/qgJ62oV
        krMrAAhEU9v3qjvo7EhqiZz2z83Hfm2dKlar+eojPSLRqukbha9WBKrD8JdFInk/
        38516++h5/EXVMx8uUtd8q/wjwo56f94er2BUKykq3sF79mP36SEDKKNE+xf5bvz
        rjq9FBahZBUEIguYizEV2jWh0azCgaCyCro+Hfs0po5hGl+hGTjT4+Bf8CP5eU7R
        TYICOSDgFq9tFeWGswBK+MXPRGzfUjzCGo/VNcjg5j7v47wX3timOZF98WTA+s2C
        052GEV7aQkJRLMw0vePGkV8fHNdj4iLcLWi4xTfQIQwHvr8Xnk3yg==
X-ME-Sender: <xms:gP9NYPNbYNMXEVmlbqlQyk1xAafvYPqV6-rlqd8Wa4gt7IDFrFu0DA>
    <xme:gP9NYJ-UnViJf4zqoPxi_uG2RFGXb9SrYQRAo-YmG2HvKUDlRsguv9MxkisVVm1HJ
    DKPOArSbqNY-Ro>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledruddvjedgudefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgggfestdekredtre
    dttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiughoshgt
    hhdrohhrgheqnecuggftrfgrthhtvghrnhepgeffheduuddtvdettefgteevfeffkeffue
    eikeeugfeijefgudefuedtffegteetnecuffhomhgrihhnpehsfhhlohifrdhorhhgpdhg
    ihhtlhgrsgdrtghomhenucfkphepkeegrddvvdelrdduheefrdeggeenucevlhhushhtvg
    hrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhs
    tghhrdhorhhg
X-ME-Proxy: <xmx:gP9NYOR5kyrhpsIak3MxzOPnou6drvrYJTFcP1Tj3Q0J56Q-n4l7aQ>
    <xmx:gP9NYDsqYfuxeRCdEu-feB178gRSfL3dkIHzpKiI7arW63kXv_sWxg>
    <xmx:gP9NYHfB96jXPyz0z_v75ilyChbD2ZSmA1V9_H-aPT6kbx7JRVn9-w>
    <xmx:gP9NYGyjZOnCF4Gx1kdqmnNpx92U03Sz5irJL18onsVPe7H8t70ogQ>
Received: from shredder.lan (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id 58D4C24005B;
        Sun, 14 Mar 2021 08:20:13 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        yotam.gi@gmail.com, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        roopa@nvidia.com, peter.phaal@inmon.com, neil.mckee@inmon.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 00/11] psample: Add additional metadata attributes
Date:   Sun, 14 Mar 2021 14:19:29 +0200
Message-Id: <20210314121940.2807621-1-idosch@idosch.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

This series extends the psample module to expose additional metadata to
user space for packets sampled via act_sample. The new metadata (e.g.,
transit delay) can then be consumed by applications such as hsflowd [1]
for better network observability.

netdevsim is extended with a dummy psample implementation that
periodically reports "sampled" packets to the psample module. In
addition to testing of the psample module, it enables the development
and demonstration of user space applications (e.g., hsflowd) that are
interested in the new metadata even without access to specialized
hardware (e.g., Spectrum ASIC) that can provide it.

mlxsw is also extended to provide the new metadata to psample.

A Wireshark dissector for psample netlink packets [2] will be submitted
upstream after the kernel patches are accepted. In addition, a libpcap
capture module for psample is currently in the works. Eventually, users
should be able to run:

 # tshark -i psample

In order to consume sampled packets along with their metadata.

Series overview:

Patch #1 makes it easier to extend the metadata provided to psample

Patch #2 adds the new metadata attributes to psample

Patch #3 extends netdevsim to periodically report "sampled" packets to
psample. Various debugfs knobs are added to control the reporting

Patch #4 adds a selftest over netdevsim

Patches #5-#10 gradually add support for the new metadata in mlxsw

Patch #11 adds a selftest over mlxsw

[1] https://sflow.org/draft4_sflow_transit.txt
[2] https://gitlab.com/amitcohen1/wireshark/-/commit/3d711143024e032aef1b056dd23f0266c54fab56

Ido Schimmel (11):
  psample: Encapsulate packet metadata in a struct
  psample: Add additional metadata attributes
  netdevsim: Add dummy psample implementation
  selftests: netdevsim: Test psample functionality
  mlxsw: pci: Add more metadata fields to CQEv2
  mlxsw: Create dedicated field for Rx metadata in skb control block
  mlxsw: pci: Set extra metadata in skb control block
  mlxsw: spectrum: Remove unnecessary RCU read-side critical section
  mlxsw: spectrum: Remove mlxsw_sp_sample_receive()
  mlxsw: spectrum: Report extra metadata to psample module
  selftests: mlxsw: Add tc sample tests

 drivers/net/Kconfig                           |   1 +
 drivers/net/ethernet/mellanox/mlxsw/core.h    |  21 +-
 drivers/net/ethernet/mellanox/mlxsw/pci.c     |  55 +-
 drivers/net/ethernet/mellanox/mlxsw/pci_hw.h  |  71 +++
 .../net/ethernet/mellanox/mlxsw/spectrum.c    |  26 -
 .../net/ethernet/mellanox/mlxsw/spectrum.h    |   2 -
 .../ethernet/mellanox/mlxsw/spectrum_trap.c   |  71 ++-
 drivers/net/netdevsim/Makefile                |   4 +
 drivers/net/netdevsim/dev.c                   |  17 +-
 drivers/net/netdevsim/netdevsim.h             |  15 +
 drivers/net/netdevsim/psample.c               | 264 ++++++++++
 include/net/psample.h                         |  21 +-
 include/uapi/linux/psample.h                  |   7 +
 net/psample/psample.c                         |  45 +-
 net/sched/act_sample.c                        |  16 +-
 .../selftests/drivers/net/mlxsw/tc_sample.sh  | 492 ++++++++++++++++++
 .../drivers/net/netdevsim/psample.sh          | 181 +++++++
 17 files changed, 1256 insertions(+), 53 deletions(-)
 create mode 100644 drivers/net/netdevsim/psample.c
 create mode 100755 tools/testing/selftests/drivers/net/mlxsw/tc_sample.sh
 create mode 100755 tools/testing/selftests/drivers/net/netdevsim/psample.sh

-- 
2.29.2

