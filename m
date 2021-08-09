Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6F143E43CA
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 12:22:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234254AbhHIKWg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 06:22:36 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:37925 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232707AbhHIKWf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Aug 2021 06:22:35 -0400
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id 210DB5C00DC;
        Mon,  9 Aug 2021 06:22:15 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Mon, 09 Aug 2021 06:22:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=pBcDepnCskhmqAcCv
        yU8iApqsELJCRwhacQWxxOp/T0=; b=hkjIbH3Dno92xQjBvyc6/gnbMG6HG3jiU
        P+8U3Zt/ErjyguSI+KXsGJ4+XK0U44wkeGCAzF0CjbbUMl3c3zDf+rE2R57lsafy
        +s6JrtsScPmwbI/28par9lN/4jlOXcq4HZMkBd6u6Y6wm1nVu0Bqvex4sEdVLXt+
        DBAbSyjSw8u2HvBj9sFM+iL+P1VdE67RqyVeXnJ6HHyLCW7JbMezQgy+2eeYdxke
        FbkYixKQ/2DHC+PDzaXueiiFEuzyUf5gyWMM+Tci3Lfk7bzw4ZCfZEcJVuwWQIOF
        YtyCGeMM7gSjw2ZW8TK8RFN+ax7De9IqBYWKFsswiW9+t9xNdzeKw==
X-ME-Sender: <xms:1gERYSKGSNlMa3SLZD10W4wGM_DC8dE-IDObpr33aqoAOk7sLBkXhA>
    <xme:1gERYaLEsRdnZgKiEYHgXSbsJEdt71eAi1NaKdPQ6zmO9Jaz3CHaPQOEvFv6EZ7Qr
    QFubyUGj4fo90g>
X-ME-Received: <xmr:1gERYSudEoZ-EzOIzMmCQ-elEyw7hcwsSvIKrjV_anJveQR2pK8isMYoT0P1jg8WRJdPohfws6MAh5Fte708eL4O3PlQK9b7SvjZiUNhiNCEbg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrjeejgddvkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffoggfgsedtkeertdertd
    dtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhstghh
    rdhorhhgqeenucggtffrrghtthgvrhhnpeeukeeggfegkeekleefledtheevkedtveekge
    dthfdukeetgfeghfefleelfeelffenucffohhmrghinhepkhgvrhhnvghlrdhorhhgpdhs
    nhhirgdrohhrghdpqhhsfhhpqdguugdrtghomhenucevlhhushhtvghrufhiiigvpedtne
    curfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:1gERYXb5qEHI5ZUM1rOTLfOIbfo28Fedn-LLyEgemqymjmdQiGru7g>
    <xmx:1gERYZb_HU5IBYxATAN7oikuf1Dj1jMHx_0ujkXz-bswS9Df-cXzDg>
    <xmx:1gERYTAzlWlQLreryO-fF-ILkVI5nAlvdqsTxLgslk8nIiWDM91gqA>
    <xmx:1wERYeO3S-_5uVqak_A65D5aB5To7L3YubMHOmsC6L8_y5rk1Bdakw>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 9 Aug 2021 06:22:11 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        mkubecek@suse.cz, pali@kernel.org, vadimp@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [RFC PATCH net-next 0/8] ethtool: Add ability to control transceiver modules
Date:   Mon,  9 Aug 2021 13:21:44 +0300
Message-Id: <20210809102152.719961-1-idosch@idosch.org>
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
'ETHTOOL_A_MODULE_LOW_POWER_ENABLED' attribute allows user space to
control the low power mode of the module in order to limit its power
consumption. See detailed description in patch #1.

In addition, patch #2 adds the 'ETHTOOL_MSG_MODULE_RESET_ACT' message
(with a corresponding notification) that allows user space to reset the
module in order to get out of fault state.

The user API is designed to be generic enough so that it could be used
for modules with different memory maps (e.g., SFF-8636, CMIS).

The only implementation of the device driver API in this series is for a
MAC driver (mlxsw) where the module is controlled by the device's
firmware, but it is designed to be generic enough so that it could also
be used by implementations where the module is controlled by the kernel.

Testing and introspection
=========================

See detailed description in patches #1 and #2.

Patchset overview
=================

Patch #1 adds the initial infrastructure in ethtool along with the
ability to control transceiver modules' low power mode.

Patch #2 adds the ability to reset transceiver modules.

Patches #3-#6 add required device registers in mlxsw.

Patch #7 implements in mlxsw the ethtool operations added in patch #1.

Patch #8 implements in mlxsw the ethtool operation added in patch #2.

Future plans
============

* Extend 'ETHTOOL_MSG_MODULE_SET' to control Tx output among other
attributes.

* Add new ethtool message(s) to update firmware on transceiver modules.

* Extend ethtool(8) to parse more diagnostic information from CMIS
modules. No kernel changes required.

[1] https://lore.kernel.org/netdev/20210623075925.2610908-1-idosch@idosch.org/
[2] https://members.snia.org/document/dl/26418
[3] http://www.qsfp-dd.com/wp-content/uploads/2021/05/CMIS5p0.pdf

Ido Schimmel (8):
  ethtool: Add ability to control transceiver modules' low power mode
  ethtool: Add ability to reset transceiver modules
  mlxsw: reg: Add fields to PMAOS register
  mlxsw: Make PMAOS pack function more generic
  mlxsw: reg: Add Port Module Memory Map Properties register
  mlxsw: reg: Add Management Cable IO and Notifications register
  mlxsw: Add ability to control transceiver modules' low power mode
  mlxsw: Add ability to reset transceiver modules

 Documentation/networking/ethtool-netlink.rst  |  83 +++++-
 .../net/ethernet/mellanox/mlxsw/core_env.c    | 232 ++++++++++++++-
 .../net/ethernet/mellanox/mlxsw/core_env.h    |  11 +
 drivers/net/ethernet/mellanox/mlxsw/minimal.c |  34 +++
 drivers/net/ethernet/mellanox/mlxsw/reg.h     | 140 +++++++++-
 .../mellanox/mlxsw/spectrum_ethtool.c         |  68 +++++
 include/linux/ethtool.h                       |  12 +
 include/uapi/linux/ethtool_netlink.h          |  18 ++
 net/ethtool/Makefile                          |   2 +-
 net/ethtool/module.c                          | 264 ++++++++++++++++++
 net/ethtool/netlink.c                         |  26 ++
 net/ethtool/netlink.h                         |   6 +
 12 files changed, 887 insertions(+), 9 deletions(-)
 create mode 100644 net/ethtool/module.c

-- 
2.31.1

