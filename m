Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AD223B1549
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 10:01:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230163AbhFWIDd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Jun 2021 04:03:33 -0400
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:36097 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230135AbhFWIDa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Jun 2021 04:03:30 -0400
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailnew.nyi.internal (Postfix) with ESMTP id 7E0D0580709;
        Wed, 23 Jun 2021 04:01:12 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Wed, 23 Jun 2021 04:01:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=AU8sQ78J2P3irjMpN
        r1TDXEDTp2WFV0bCMvQiFMqfwg=; b=FSXur90/TP73d7mKiL9XsbFSMOHSRJdRy
        t2N3q0eREefmgaeEV7r1/jh2Waxe62kmbgX9OA333k1vQ82X8q+Fge5Q3i6rNjug
        KbD5RAlO/+/nu4cG9OO9tL4m/Y9Bz0w89X6hbNuTVGH6iAJLIhPpPwJKbJMIcVaX
        /qPOKlOzDRLn9adBP1JIeR671Vz92g0gQIKKMiG5ZGkFQUd/JTPN0uqnSM0KkE82
        z1M683lkADRm5LckjTk+hObj0AC3OKgWk4xdbeoBWg0TKzr/SSpkmYeVRmh9PX+5
        xnCwgudVroAIZOkZsV0wDmZFkK8JfthrTcqRloMfvjPVVikuJY3wA==
X-ME-Sender: <xms:R-rSYLGi3hzubtjG6OHRNFK_-qsAsN0xL6tVs0wsOETjAVUupKICHQ>
    <xme:R-rSYIVnGBL45a83sI2kw5mM2yWwABhOEZquIAuCCVy4AFiPmyNrlrI27bjlmZIXB
    TXeAj1dSzvGd4E>
X-ME-Received: <xmr:R-rSYNLpYV2TA0IhoMIveUtNHctJpo9paIvnqR9_y1dXnOnCxSZp9KHXaQLCAHbaIooZy32Sfx8MHJBVd8qioX2dEaF7d5BnIPJSIT44Z_urpg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfeegvddguddujecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffoggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucggtffrrghtthgvrhhnpedtffethefgiefhtdelueefteegleehhe
    dtudfhtdeugedukeetfeevueeuleefudenucffohhmrghinhepshhnihgrrdhorhhgpdhq
    shhfphdquggurdgtohhmpdhkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpe
    dtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:R-rSYJGmPqnICnc1VyZ10u7OwshoqiAlwstY0M9-KYqqCTwBT9-uXQ>
    <xmx:R-rSYBX2QuHN6aKBr0jvvSUzAPo25Gan6zILh1QQnGk3Fot1e061VQ>
    <xmx:R-rSYENB3KQFwYEs_LZhQeeR23i4RdJZQhmn5B6PIdVSz25yfh_DkQ>
    <xmx:SOrSYNrqhmTak_72FPCtNAObLUGfy8-6q3wSemQe-Ql4LIIP8utRSA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 23 Jun 2021 04:01:09 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        andrew@lunn.ch, vladyslavt@nvidia.com, moshe@nvidia.com,
        vadimp@nvidia.com, mkubecek@suse.cz, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [RFC PATCH net-next 0/4] ethtool: Add ability to write to transceiver module EEPROMs
Date:   Wed, 23 Jun 2021 10:59:21 +0300
Message-Id: <20210623075925.2610908-1-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

This patchset adds write support to transceiver module EEPROMs by
extending the ethtool netlink API.

Motivation
==========

The kernel can currently dump the contents of module EEPROMs to user
space via the ethtool legacy ioctl API or the new netlink API. These
dumps can then be parsed by ethtool(8) according to the specification
that defines the memory map of the EEPROM. For example, SFF-8636 [1] for
QSFP and CMIS [2] for QSFP-DD.

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

The legacy ioctl API to dump module EEPROMs required drivers to parse
the contents of the EEPROM in order to understand how many bytes can be
read and dumped to user space. This meant that drivers had to be updated
to support new standards. See [3], for example.

To overcome this limitation, a new netlink-based API to dump module
EEPROMs was merged in kernel 5.13 [4]. With the new API, the kernel is
merely responsible for fetching EEPROM pages. User space then parses the
information, determines if more pages are available and instructs the
kernel to fetch them as well.

Write support for module EEPROMs employs the same approach. User space
instructs the kernel which bytes (page/offset/bank/length) to change and
to which values.

This approach allows the kernel to remain ignorant of the various
standards and avoids the need to constantly update the kernel to support
new registers / commands. More importantly, it allows advanced
functionality such as firmware update to be implemented once in user
space and shared across all the drivers that support read and write
access to module EEPROMs.

The above is achieved by adding a new command to the generic ethtool
netlink family ('ETHTOOL_MSG_MODULE_EEPROM_SET') which shares the same
attributes with the get command ('ETHTOOL_MSG_MODULE_EEPROM_GET'). See
Documentation/networking/ethtool-netlink.rst in patch #3 for detailed
description of the proposed netlink API.

Note that the new command shares the same restrictions with the existing
get command. This means, for example, that no more than 128 bytes can be
written at once and that cross-page write is forbidden. However, some
CMIS compliant modules might support "Auto Paging" which allows hosts to
"write data in large chunks, without the overhead of explicitly
programming Page changes" [2].

At this time, I cannot evaluate the benefits of "Auto Paging" as I do
not have modules that support the feature, nor a host that can write
more than 48 bytes at once. If the current restrictions prove to be a
bottleneck, they can be relaxed in the future.

ethtool(8) support
==================

The corresponding user space patches extend ethtool(8) with the ability
to change the value of a single byte in the module EEPROM. Example:

 # ethtool -M swp11 offset 0x80 page 3 bank 0 i2c 0x50 value 0x44

This is in accordance with the '-E' option which allows changing the
value of a single byte in the EEPROM of the network device.

The current command line interface is not user-friendly and also
impractical for functionality that requires many reads and writes such
as firmware update.

Therefore, the plan is to extend ethtool(8) over time with commonly
requested functionality on top of the netlink API.

Testing
=======

Tested by writing to page 3 (User EEPROM) of a QSFP-DD module:

 # ethtool -m swp11 offset 0x80 length 3 page 3 bank 0 i2c 0x50
 Offset          Values
 ------          ------
 0x0080:         00 00 00
 # ethtool -M swp11 offset 0x80 page 3 bank 0 i2c 0x50 value 0x44
 # ethtool -M swp11 offset 0x81 page 3 bank 0 i2c 0x50 value 0x41
 # ethtool -M swp11 offset 0x82 page 3 bank 0 i2c 0x50 value 0x44
 # ethtool -m swp11 offset 0x80 length 3 page 3 bank 0 i2c 0x50
 Offset          Values
 ------          ------
 0x0080:         44 41 44

Patchset overview
=================

Patches #1-#2 refactor the ethtool module EEPROM code to allow sharing
attribute validation between read and write.

Patch #3 adds the actual module EEPROM write implementation.

Patch #4 adds mlxsw support.

[1] https://members.snia.org/document/dl/26418
[2] http://www.qsfp-dd.com/wp-content/uploads/2021/05/CMIS5p0.pdf
[3] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=6af496adcbb8d4656b90a85401eeceb88d520c0d
[4] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=7dc85b599ae17fb705ffae1b7321ace4b3056aeb

Ido Schimmel (4):
  ethtool: Extract module EEPROM attributes before validation
  ethtool: Split module EEPROM attributes validation to a function
  ethtool: Add ability to write to transceiver module EEPROM
  mlxsw: core: Add support for module EEPROM write by page

 Documentation/networking/ethtool-netlink.rst  |  47 +++++
 .../net/ethernet/mellanox/mlxsw/core_env.c    |  44 ++++
 .../net/ethernet/mellanox/mlxsw/core_env.h    |   5 +
 drivers/net/ethernet/mellanox/mlxsw/minimal.c |  13 ++
 .../mellanox/mlxsw/spectrum_ethtool.c         |  14 ++
 include/linux/ethtool.h                       |  21 +-
 include/uapi/linux/ethtool_netlink.h          |   2 +
 net/ethtool/eeprom.c                          | 192 +++++++++++++++---
 net/ethtool/netlink.c                         |   7 +
 net/ethtool/netlink.h                         |   2 +
 10 files changed, 316 insertions(+), 31 deletions(-)

-- 
2.31.1

