Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19B7E4600AE
	for <lists+netdev@lfdr.de>; Sat, 27 Nov 2021 18:48:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355810AbhK0RvO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Nov 2021 12:51:14 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:42171 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238359AbhK0RtO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Nov 2021 12:49:14 -0500
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id 2F4965C00CD;
        Sat, 27 Nov 2021 12:45:59 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Sat, 27 Nov 2021 12:45:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=JZhfMRTe3FIfPDhmS
        XRYPGvgiPbE8Mk8R3068Rr7uvg=; b=nwFTPBv9jMOLpcSEne+iwAZFchk7pgZmN
        /lE/dAk1VaU87K9Czo4BAFdnhcliyXKpldfMe+Y0QnqEdfJEBjvlWAS4SxhmTQVg
        Tf+ZtSldQipWmTDNH9FeHfFmoF0uBj3TOJsgcLZETZdCU2mtBzAtkQbaUd1Yh4py
        ZQUn0zdy1nLFMkL4zaLPBgIToGvYCtdrHyoTOCeGxZIaRompmMDWy71Jb7pxFkbD
        Z1aMT6qZZ6b48NAO/dSbIsiQlZacB0tSMdTEXC53nvsS554hdO27btq2a9BJM0n6
        xBdvwaLtK4aS6pFNVoDg6tcEPXPliXdm28mfeCPQu7x+dDHJcHHRA==
X-ME-Sender: <xms:1m6iYY-xQkn2RvohpCtw7LtwTEQiaxJZz2RGHDq_7ZZfuUl6q8rebA>
    <xme:1m6iYQswthZOHJXA3pBUlOz_6OunGkZaiJITsq3EjLbboyED7LSJtont70uOdukrr
    UELliW74licDo0>
X-ME-Received: <xmr:1m6iYeCuQCaZ76y8UrH97BJCOl1IT5ZhVMJbViCn8Qt6gSmXMcUvva1snFvgGZSSshH1hAp7tR87jd5K3vPX5K739jkK9VKHzw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvuddrheeggdejkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffoggfgsedtkeertdertd
    dtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhstghh
    rdhorhhgqeenucggtffrrghtthgvrhhnpeegvdefveelieehfedugeejueejhffgtdffhf
    fgkeejteekteffiefhgefhteduffenucffohhmrghinhepqhhsfhhpqdguugdrtghomhdp
    ghhithhhuhgsrdgtohhmnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrg
    hilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:1m6iYYchCyJMTsD6sSrv_d_qMtJZzrAXgQfVvF1VPMfeOXaG-YbHXA>
    <xmx:1m6iYdNUlLW34u0nS0zWpCAvaGAV_e0RcvgFaQAhj0evnmCqiPYzpQ>
    <xmx:1m6iYSlMyEHbfP5BvedqR69WfTh5D7jiryO6Pjodu8j-Ujc2PsNm2g>
    <xmx:126iYQfTBwhYlbzD-_IDQaZ7dYMGOXCK9LGUALGoigRYbHyKjpVIDg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sat,
 27 Nov 2021 12:45:55 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        mkubecek@suse.cz, pali@kernel.org, jacob.e.keller@intel.com,
        vadimp@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [RFC PATCH net-next 0/4] ethtool: Add ability to flash and query transceiver modules' firmware
Date:   Sat, 27 Nov 2021 19:45:26 +0200
Message-Id: <20211127174530.3600237-1-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

This patchset extends the ethtool netlink API to allow user space to
both flash transceiver modules' firmware and query the firmware
information (e.g., version, state).

The main use case is CMIS compliant modules such as QSFP-DD. The CMIS
standard specifies the interfaces used for both operations. See section
7.3.1 in revision 5.0 of the standard [1].

Despite the immediate use case being CMIS compliant modules, the user
interface is kept generic enough to accommodate future use cases, if
these arise.

The purpose of this RFC is to solicit feedback on both the proposed user
interface and the device driver API which are described in detail in
patches #1 and #3. The netdevsim patches are for RFC purposes only. The
plan is to implement the CMIS functionality in common code (under lib/)
so that it can be shared by MAC drivers that will pass function pointers
to it in order to read and write from their modules EEPROM.

ethtool(8) patches can be found here [2].

[1] http://www.qsfp-dd.com/wp-content/uploads/2021/05/CMIS5p0.pdf
[2] https://github.com/idosch/ethtool/tree/submit/module_fw_rfc

Ido Schimmel (4):
  ethtool: Add ability to query transceiver modules' firmware
    information
  netdevsim: Implement support for ethtool_ops::get_module_fw_info
  ethtool: Add ability to flash transceiver modules' firmware
  netdevsim: Implement support for ethtool_ops::start_fw_flash_module

 Documentation/networking/ethtool-netlink.rst | 128 +++++++-
 drivers/net/netdevsim/ethtool.c              | 164 ++++++++++
 drivers/net/netdevsim/netdevsim.h            |  10 +
 include/linux/ethtool.h                      | 109 +++++++
 include/linux/ethtool_netlink.h              |   9 +
 include/uapi/linux/ethtool.h                 |  18 +
 include/uapi/linux/ethtool_netlink.h         |  49 +++
 net/ethtool/module.c                         | 327 +++++++++++++++++++
 net/ethtool/netlink.c                        |  17 +
 net/ethtool/netlink.h                        |   4 +
 10 files changed, 833 insertions(+), 2 deletions(-)

-- 
2.31.1

