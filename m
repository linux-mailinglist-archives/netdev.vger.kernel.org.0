Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 117A5423BAD
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 12:47:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238067AbhJFKtQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 06:49:16 -0400
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:50967 "EHLO
        new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229824AbhJFKtP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Oct 2021 06:49:15 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id D3CDA58119B;
        Wed,  6 Oct 2021 06:47:22 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Wed, 06 Oct 2021 06:47:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=VBO7ufSgZY6nyoGcl
        TPwKfAqnB9JsYZatD3OcTarvyo=; b=XkcQsNlal3KVAb8bLifLZCBH4auN4B4vx
        7pZhN9n41E8wpHRMhoB1rqVWe4V+EHbxHPlyfMPIuP2zIeKxViwITZ1ORWD1KfOw
        /EEXJX6zxiVDU2XMGVl0Or3m8enT4PbS5XGnt0JOyRt3ZeJY28suZnDnI6kzGYJW
        De27sxuyJOQI393PEt5OxYD3tj3MG1HKy6wMqT/Vgp49vdOYuZrYeuyZUIkB6Aji
        N8PA1nSHrYrXmS0trGU11BvBtjlivkrmodreYMl1a8Ot/omqyPtazuUl4xUOWZu4
        zjlY/jFgMf8OnmjhckLFn8A2dhXpNC+n7ACjmi7r3fwnDUB25Kwxg==
X-ME-Sender: <xms:un5dYcx1pCOQD4DGnqqCyeRCkV40qXVkHmSIMyhpfc-O_BPDZiWIkw>
    <xme:un5dYQSM4baVaIEAuj8IT9VqGlQMIEr2g-fXdYSdBiqi659Q2lC0me-hbMM1VCq14
    cs9x-IMLLxuhck>
X-ME-Received: <xmr:un5dYeWN5ATCUzSZlY8aqBKTNvPCC9MG28UG2YixSroOBBC-xKkXI6KwLgHP2Td8ea5I3MLSTGyc-pFZqXI6eE7scJbk7eAyOE_qgYa2wrErVA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrudeliedgfedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgggfestdekredtre
    dttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiughoshgt
    hhdrohhrgheqnecuggftrfgrthhtvghrnhepueekgefggeekkeelfeeltdehveektdevke
    egtdfhudektefggefhfeelleefleffnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghdp
    shhnihgrrdhorhhgpdhqshhfphdquggurdgtohhmnecuvehluhhsthgvrhfuihiivgeptd
    enucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:un5dYaiUyxYSU9lV3GUzxxNiitkUN9UiMvn3CkotG2Wj3Sg2TsIVSQ>
    <xmx:un5dYeD_YJOclFyqshAC2I4FxqxCXODfKdYNqYrV7wvDTQrPRUCsAw>
    <xmx:un5dYbLOlollls0MHmQP96xI1szhdodVJD86FyxQ-5BTsaai8yItqA>
    <xmx:un5dYa25lmq8hGE2eXnoI8ix90ufx4kk2kPV7t1W8BaqkX9FepyBLQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 6 Oct 2021 06:47:19 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        mkubecek@suse.cz, pali@kernel.org, jacob.e.keller@intel.com,
        jiri@nvidia.com, vadimp@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next v2 0/6] ethtool: Add ability to control transceiver modules' power mode
Date:   Wed,  6 Oct 2021 13:46:41 +0300
Message-Id: <20211006104647.2357115-1-idosch@idosch.org>
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

Changes since v1 [4]:

* Patch #1: Set ETHTOOL_MODULE_POWER_MODE_POLICY_HIGH to 1 and remove
  validity bit.
* Patch #1: Avoid calling set_module_power_mode() if policy did not
  change.

Changes since RFC v3 [5]:

* Patch #1: Fix comment indentation.
* Patch #1: Rephrase paragraph about default power mode policy.
* Patch #1: Remove ethtool_module_power_mode_params::mode_valid.
* Patch #1: Set ETHTOOL_MODULE_POWER_MODE_LOW to 1.
* Patch #1: Add a new paragraph in "Conventions" section.
* Patch #2: Add "sticky" bit.

Changes since RFC v2 [6]:

* Change 'high-on-up' power mode policy to 'auto'.
* Remove 'low' power mode policy.
* Document that default power mode policy is driver-dependent.
* Remove restrictions regarding interface administrative state when
  setting the power mode policy.

Changes since RFC v1 [7]:

* Split 'ETHTOOL_A_MODULE_LOW_POWER_ENABLED' into two attributes.
* Add 'high-on-up' power mode policy.
* Drop 'ETHTOOL_MSG_MODULE_RESET_ACT' in favor of existing ioctl
  interface.
* Add extended link states to help in troubleshooting.

[1] https://lore.kernel.org/netdev/20210623075925.2610908-1-idosch@idosch.org/
[2] https://members.snia.org/document/dl/26418
[3] http://www.qsfp-dd.com/wp-content/uploads/2021/05/CMIS5p0.pdf
[4] https://lore.kernel.org/netdev/20211003073219.1631064-1-idosch@idosch.org/
[5] https://lore.kernel.org/netdev/20210824130344.1828076-1-idosch@idosch.org/
[6] https://lore.kernel.org/netdev/20210818155202.1278177-1-idosch@idosch.org/
[7] https://lore.kernel.org/netdev/20210809102152.719961-1-idosch@idosch.org/

Ido Schimmel (6):
  ethtool: Add ability to control transceiver modules' power mode
  mlxsw: reg: Add Port Module Memory Map Properties register
  mlxsw: reg: Add Management Cable IO and Notifications register
  mlxsw: Add ability to control transceiver modules' power mode
  ethtool: Add transceiver module extended state
  mlxsw: Add support for transceiver module extended state

 Documentation/networking/ethtool-netlink.rst  |  81 +++++++-
 .../net/ethernet/mellanox/mlxsw/core_env.c    | 193 +++++++++++++++++-
 .../net/ethernet/mellanox/mlxsw/core_env.h    |  10 +
 drivers/net/ethernet/mellanox/mlxsw/minimal.c |  26 +++
 drivers/net/ethernet/mellanox/mlxsw/reg.h     |  84 ++++++++
 .../mellanox/mlxsw/spectrum_ethtool.c         |  35 ++++
 include/linux/ethtool.h                       |  23 +++
 include/uapi/linux/ethtool.h                  |  29 +++
 include/uapi/linux/ethtool_netlink.h          |  17 ++
 net/ethtool/Makefile                          |   2 +-
 net/ethtool/module.c                          | 180 ++++++++++++++++
 net/ethtool/netlink.c                         |  19 ++
 net/ethtool/netlink.h                         |   4 +
 13 files changed, 697 insertions(+), 6 deletions(-)
 create mode 100644 net/ethtool/module.c

-- 
2.31.1

