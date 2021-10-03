Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2B63420076
	for <lists+netdev@lfdr.de>; Sun,  3 Oct 2021 09:34:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229868AbhJCHfg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Oct 2021 03:35:36 -0400
Received: from new2-smtp.messagingengine.com ([66.111.4.224]:49717 "EHLO
        new2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229567AbhJCHfe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Oct 2021 03:35:34 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id 2D852580E3D;
        Sun,  3 Oct 2021 03:33:47 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sun, 03 Oct 2021 03:33:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=PfbRM510/n73z94JR
        SRrQUMnriU40mt7b8Ld3ip4TEQ=; b=T4/lp6RWZOm8YQVX3sLyNjEBIi7bitT2C
        9/PEC/8YC+N4UPMLHvXHtG5NHB5lB2XF02MiOlIKB7m47EbP1AHDKfriFHMPMGs2
        1vkLtA7NU4XUnrPWYyTua68GoxJ2SzvuXet98qiVq6iVbeqDOYk6HqTDRFVZA1TU
        ABoc8rDz1xIsCHfgUwi8bb9xJFXjFTKxOeF5dGD8dYb2jRVyoE90u8IX8jer48RM
        W8nrFdDLl5yJdnSmIIsiAjILCP8TyCrItGssVOf2b2j+aVBJaf0N0MVykkG0zGAk
        iQPZZvDrsBCztpBSc0Bq/5hBEL4pjH18enoWR6z0l1zp6EZh/XWjQ==
X-ME-Sender: <xms:2lxZYRS5Zxg5m59EJwR5_VovA1hM1iGoNvuxpd9XARp6WdRk0HGH-Q>
    <xme:2lxZYazh19IP7Tj1L_rCaoYaYj7PnerE7xI4ibA5qBvEx-PrKhY0FmNaNeh7GhXkW
    ED0zAu95Zexmms>
X-ME-Received: <xmr:2lxZYW32m-TgadJAzvLWbltj-4_pxUii3Ld5gm05PP1_oNNuqOC1BjGHkqDYqNkyD3849AFTrtiZBwQ2SiMdjAHuAYkr2r3QmGysROo_4sDECQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrudekledguddulecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffoggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucggtffrrghtthgvrhhnpeeukeeggfegkeekleefledtheevkedtve
    ekgedthfdukeetgfeghfefleelfeelffenucffohhmrghinhepkhgvrhhnvghlrdhorhhg
    pdhsnhhirgdrohhrghdpqhhsfhhpqdguugdrtghomhenucevlhhushhtvghrufhiiigvpe
    dtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:2lxZYZBGLW3dLYotVAc4uagTnjvF8HnDBgxC7fy_1V5wbbOD3QzRag>
    <xmx:2lxZYagvsFK_q1_rcVuBnwhyEz_SBJ7GIamrsRDtCMroZy1_GM8eJg>
    <xmx:2lxZYdrWm58btOxwEJ3PVxYBJBT6TLlgLA_Z9BUNcPjjGR8XlTY2Qg>
    <xmx:21xZYTVUmQT5MrApgkVI7B-LtOMkciQZHCuw-v1OKE1KJEKJWyc99A>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 3 Oct 2021 03:33:43 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        mkubecek@suse.cz, pali@kernel.org, jacob.e.keller@intel.com,
        jiri@nvidia.com, vadimp@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 0/6] ethtool: Add ability to control transceiver modules' power mode
Date:   Sun,  3 Oct 2021 10:32:13 +0300
Message-Id: <20211003073219.1631064-1-idosch@idosch.org>
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

Changes since RFC v3 [4]:

* Patch #1: Fix comment indentation.
* Patch #1: Rephrase paragraph about default power mode policy.
* Patch #1: Remove ethtool_module_power_mode_params::mode_valid.
* Patch #1: Set ETHTOOL_MODULE_POWER_MODE_LOW to 1.
* Patch #1: Add a new paragraph in "Conventions" section.
* Patch #2: Add "sticky" bit.

Changes since RFC v2 [5]:

* Change 'high-on-up' power mode policy to 'auto'.
* Remove 'low' power mode policy.
* Document that default power mode policy is driver-dependent.
* Remove restrictions regarding interface administrative state when
  setting the power mode policy.

Changes since RFC v1 [6]:

* Split 'ETHTOOL_A_MODULE_LOW_POWER_ENABLED' into two attributes.
* Add 'high-on-up' power mode policy.
* Drop 'ETHTOOL_MSG_MODULE_RESET_ACT' in favor of existing ioctl
  interface.
* Add extended link states to help in troubleshooting.

[1] https://lore.kernel.org/netdev/20210623075925.2610908-1-idosch@idosch.org/
[2] https://members.snia.org/document/dl/26418
[3] http://www.qsfp-dd.com/wp-content/uploads/2021/05/CMIS5p0.pdf
[4] https://lore.kernel.org/netdev/20210824130344.1828076-1-idosch@idosch.org/
[5] https://lore.kernel.org/netdev/20210818155202.1278177-1-idosch@idosch.org/
[6] https://lore.kernel.org/netdev/20210809102152.719961-1-idosch@idosch.org/

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
 net/ethtool/module.c                          | 184 +++++++++++++++++
 net/ethtool/netlink.c                         |  19 ++
 net/ethtool/netlink.h                         |   4 +
 13 files changed, 701 insertions(+), 6 deletions(-)
 create mode 100644 net/ethtool/module.c

-- 
2.31.1

