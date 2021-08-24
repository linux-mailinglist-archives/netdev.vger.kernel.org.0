Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C02113F5E98
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 15:04:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237363AbhHXNFP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 09:05:15 -0400
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:43847 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236443AbhHXNFP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Aug 2021 09:05:15 -0400
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailnew.nyi.internal (Postfix) with ESMTP id A24655803E9;
        Tue, 24 Aug 2021 09:04:30 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Tue, 24 Aug 2021 09:04:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=3Nhao+SewolVrE6To
        ti4sLuXYXfxz2qS77ueIIWZqGA=; b=dJMv9SMYlPMg/HEAsaM0G/XAq7t8MKaXa
        A98lGF1axDwb5f3Ye2fIjbvBLt9Os20sCWnHHLtFygkl7ugH7St3RgJPCLXC7bvx
        xindqAe56B45IFYIEIFSIihE76WDtnmfoZscqITP8FAbALiEZMEMq08bINWxPSwk
        owLpkS5cps6vjO3Ob3gpGNGYR/xV5bOOaD2jSyE5SZWc6W387C625L2FhTZKVVvv
        jWCaOlfbsURj9ZyIGfu4VxXfUyI+tGZWWUo23cWJo7z6Z5tXRNz89GvWqSYgWCEm
        qsyHEF7Z27qTcW9Zfa2NgjV0vnhiv0ZKRCIUwfb0+U32rs8qvnh2g==
X-ME-Sender: <xms:Xe4kYTvlAq1qVaJgn-icC5HXUdYpTHn_e-maICmlPy9wz_pFwNTz3w>
    <xme:Xe4kYUe4iAjILE48CvZlkzFE1TqC0WBEbkP8cvHxXEf9zW21jEhBc91NZ01cZqwdA
    SB6mqn0qDmfzDQ>
X-ME-Received: <xmr:Xe4kYWyYmuJnSbuK9JuOT-NDuA6Cwey2J9VQ0N4SdffJp7jz99HT8YmJdTUjjMt4X5Z3VIDRf0qrZXvl8GCH_pEKJwkTuPad_mNGYJWocAP-bw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddruddtjedgheelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgggfestdekredtre
    dttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiughoshgt
    hhdrohhrgheqnecuggftrfgrthhtvghrnhepueekgefggeekkeelfeeltdehveektdevke
    egtdfhudektefggefhfeelleefleffnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghdp
    shhnihgrrdhorhhgpdhqshhfphdquggurdgtohhmnecuvehluhhsthgvrhfuihiivgeptd
    enucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:Xe4kYSNaN9Em55r4FUwXEZ569WODlFr9DJCv7B5LmJMDfFLnuen2lQ>
    <xmx:Xe4kYT-XFH4oxebQvbd8PK2cbmHhg_twUHUigNOSUN6ltD0N7b5PmQ>
    <xmx:Xe4kYSWcob8URYa11ZgAjcbz386KkmIuWZwBswl1HlHB5umk-IATaw>
    <xmx:Xu4kYfRzEIcj8LR2WFHJvpf472WM3tTxjdDRpIIUrAKWi97weGLmhg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 24 Aug 2021 09:04:26 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        mkubecek@suse.cz, pali@kernel.org, jacob.e.keller@intel.com,
        jiri@nvidia.com, vadimp@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [RFC PATCH net-next v3 0/6] ethtool: Add ability to control transceiver modules' power mode
Date:   Tue, 24 Aug 2021 16:03:38 +0300
Message-Id: <20210824130344.1828076-1-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

This patchset extends the ethtool netlink API to allow user space to
control transceiver modules. Two specific APIs are added, but the plan
is to extend the interface with more APIs in the future (see "Future
plans").

This submission is a complete rework of a previous submission [1] that
tried to achieve the same goal by allowing user space to write to the
EEPROMs of these modules. It was rejected as it could have enabled user
space binary blob drivers.

However, the main issue is that by directly writing to some pages of
these EEPROMs, we are interfering with the entity that is controlling
the modules (kernel / device firmware). In addition, some functionality
cannot be implemented solely by writing to the EEPROM, as it requires
the assertion / de-assertion of hardware signals (e.g., "ResetL" pin in
SFF-8636).

Motivation
==========

The kernel can currently dump the contents of module EEPROMs to user
space via the ethtool legacy ioctl API or the new netlink API. These
dumps can then be parsed by ethtool(8) according to the specification
that defines the memory map of the EEPROM. For example, SFF-8636 [2] for
QSFP and CMIS [3] for QSFP-DD.

In addition to read-only elements, these specifications also define
writeable elements that can be used to control the behavior of the
module. For example, controlling whether the module is put in low or
high power mode to limit its power consumption.

The CMIS specification even defines a message exchange mechanism (CDB,
Command Data Block) on top of the module's memory map. This allows the
host to send various commands to the module. For example, to update its
firmware.

Implementation
==============

The ethtool netlink API is extended with two new messages,
'ETHTOOL_MSG_MODULE_SET' and 'ETHTOOL_MSG_MODULE_GET', that allow user
space to set and get transceiver module parameters. Specifically, the
'ETHTOOL_A_MODULE_POWER_MODE_POLICY' attribute allows user space to
control the power mode policy of the module in order to limit its power
consumption. See detailed description in patch #1.

The user API is designed to be generic enough so that it could be used
for modules with different memory maps (e.g., SFF-8636, CMIS).

The only implementation of the device driver API in this series is for a
MAC driver (mlxsw) where the module is controlled by the device's
firmware, but it is designed to be generic enough so that it could also
be used by implementations where the module is controlled by the kernel.

Testing and introspection
=========================

See detailed description in patches #1 and #5.

Patchset overview
=================

Patch #1 adds the initial infrastructure in ethtool along with the
ability to control transceiver modules' power mode.

Patches #2-#3 add required device registers in mlxsw.

Patch #4 implements in mlxsw the ethtool operations added in patch #1.

Patch #5 adds extended link states in order to allow user space to
troubleshoot link down issues related to transceiver modules.

Patch #6 adds support for these extended states in mlxsw.

Future plans
============

* Extend 'ETHTOOL_MSG_MODULE_SET' to control Tx output among other
attributes.

* Add new ethtool message(s) to update firmware on transceiver modules.

* Extend ethtool(8) to parse more diagnostic information from CMIS
modules. No kernel changes required.

Changes since RFC v2 [4]:

* Change 'high-on-up' power mode policy to 'auto'
* Remove 'low' power mode policy
* Document that default power mode policy is driver-dependent
* Remove restrictions regarding interface administrative state when
  setting the power mode policy

Changes since RFC v1 [5]:

* Split 'ETHTOOL_A_MODULE_LOW_POWER_ENABLED' into two attributes.
* Add 'high-on-up' power mode policy.
* Drop 'ETHTOOL_MSG_MODULE_RESET_ACT' in favor of existing ioctl
  interface.
* Add extended link states to help in troubleshooting.

Note: This series does not apply to net-next (it is RFC, anyway) because
I left out mundane infra work in mlxsw. Will submit it with reset
support as part of a separate set.

[1] https://lore.kernel.org/netdev/20210623075925.2610908-1-idosch@idosch.org/
[2] https://members.snia.org/document/dl/26418
[3] http://www.qsfp-dd.com/wp-content/uploads/2021/05/CMIS5p0.pdf
[4] https://lore.kernel.org/netdev/20210818155202.1278177-1-idosch@idosch.org/
[5] https://lore.kernel.org/netdev/20210809102152.719961-1-idosch@idosch.org/

Ido Schimmel (6):
  ethtool: Add ability to control transceiver modules' power mode
  mlxsw: reg: Add Port Module Memory Map Properties register
  mlxsw: reg: Add Management Cable IO and Notifications register
  mlxsw: Add ability to control transceiver modules' power mode
  ethtool: Add transceiver module extended states
  mlxsw: Add support for transceiver module extended states

 Documentation/networking/ethtool-netlink.rst  |  76 ++++++-
 .../net/ethernet/mellanox/mlxsw/core_env.c    | 194 +++++++++++++++++-
 .../net/ethernet/mellanox/mlxsw/core_env.h    |  10 +
 drivers/net/ethernet/mellanox/mlxsw/minimal.c |  26 +++
 drivers/net/ethernet/mellanox/mlxsw/reg.h     |  78 +++++++
 .../mellanox/mlxsw/spectrum_ethtool.c         |  73 ++++++-
 include/linux/ethtool.h                       |  26 +++
 include/uapi/linux/ethtool.h                  |  30 +++
 include/uapi/linux/ethtool_netlink.h          |  17 ++
 net/ethtool/Makefile                          |   2 +-
 net/ethtool/module.c                          | 184 +++++++++++++++++
 net/ethtool/netlink.c                         |  19 ++
 net/ethtool/netlink.h                         |   4 +
 13 files changed, 731 insertions(+), 8 deletions(-)
 create mode 100644 net/ethtool/module.c

-- 
2.31.1

