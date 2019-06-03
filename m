Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2152632F44
	for <lists+netdev@lfdr.de>; Mon,  3 Jun 2019 14:13:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727113AbfFCMNs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 08:13:48 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:60299 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726136AbfFCMNr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jun 2019 08:13:47 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 903642214E;
        Mon,  3 Jun 2019 08:13:46 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Mon, 03 Jun 2019 08:13:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=uAQjJq4couvJhyAcP
        mpFadNQja3tP1ORS1TfP8OAK00=; b=hS/zqpFaVXGTTVI1YUiy1v/NEDIB4EkO7
        LFIHvCCSgxJkdkcS/JxWTgWlGonx0cD0hu7HGekfVlg/pKPxNAFqaJvn5FDpuAnN
        B9JbDqhyA/Cxo4/4WZ4GvHaIATJy1FjbNAYEaH8Mn5oac2jOjEWtEZ1s/lyhpaPT
        ybnn13JO6fnEnzpF7wZQQHkqXv/UO8jF9PLA8RS6BaEIsH6d2cBywwJ+ivrXaRZx
        D/iuIQd526BvT5eleMXXIZUjqJeFUQ0V1slMqyGovJtY9APgzEUcvdGqdyUcsL1K
        7b8pBu5ULC9nAC+vtOTL8GMDfZH+eC9Fr8205sjoTgHMs+DBDiAWw==
X-ME-Sender: <xms:-g71XOnu9jwAaym3qQdvTZPZU0xXUWGXBq7cYZFYrZju7x0lfE291Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddrudefjedggeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgggfestdekredtre
    dttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiughoshgt
    hhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpehmrg
    hilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghrufhi
    iigvpedt
X-ME-Proxy: <xmx:-g71XMhfFcwCw8GlHfOErU-BLRMjPSTrFXj4KwlOUYaZkMNW8YKGrQ>
    <xmx:-g71XG1GU1f0d88Yl5LNPAsH-bR1nkM5_Or7UbjKEzerZVhXcaBLBA>
    <xmx:-g71XDMIPImK3bzFCSQUCYcYt3K92l7SBYClKI7R0iuSDwYyVp3Sag>
    <xmx:-g71XL68gixZ0SPEdRBRA0hqaeZhPxAREYCtioFdXP7wvssp2q_bfA>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 86680380086;
        Mon,  3 Jun 2019 08:13:44 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, richardcochran@gmail.com, jiri@mellanox.com,
        shalomt@mellanox.com, petrm@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 0/9] mlxsw: Add support for physical hardware clock
Date:   Mon,  3 Jun 2019 15:12:35 +0300
Message-Id: <20190603121244.3398-1-idosch@idosch.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

This is the first of about four patchsets that add PTP support in mlxsw
for the Spectrum-1 ASIC.

This patchset exposes the physical hardware clock, while subsequent
patchsets will add timestamping support and mlxsw tracepoints for
debugging and testing.

Shalom says:

This patchset adds support for physical hardware clock for Spectrum-1
ASIC only.

Patches #1, #2 and #3 add the ability to query the free running clock
PCI address.

Patches #4 and #5 add two new register, the Management UTC Register and
the Management Pulse Per Second Register.

Patch #6 publishes scaled_ppm_to_ppb() to allow drivers to use it.

Patch #7 adds the physical hardware clock operations.

Patch #8 initializes the physical hardware clock.

Patch #9 adds a selftest for testing the PTP physical hardware clock.

Shalom Toledo (9):
  mlxsw: cmd: Free running clock PCI BAR and offsets via query firmware
  mlxsw: core: Add a new interface for reading the hardware free running
    clock
  mlxsw: pci: Query free running clock PCI BAR and offsets
  mlxsw: reg: Add Management UTC Register
  mlxsw: reg: Add Management Pulse Per Second Register
  ptp: ptp_clock: Publish scaled_ppm_to_ppb
  mlxsw: spectrum_ptp: Add implementation for physical hardware clock
    operations
  mlxsw: spectrum: PTP physical hardware clock initialization
  selftests: ptp: Add Physical Hardware Clock test

 drivers/net/ethernet/mellanox/mlxsw/Makefile  |   1 +
 drivers/net/ethernet/mellanox/mlxsw/cmd.h     |  12 +
 drivers/net/ethernet/mellanox/mlxsw/core.c    |  12 +
 drivers/net/ethernet/mellanox/mlxsw/core.h    |   8 +-
 drivers/net/ethernet/mellanox/mlxsw/pci.c     |  32 +++
 drivers/net/ethernet/mellanox/mlxsw/pci_hw.h  |   3 +
 drivers/net/ethernet/mellanox/mlxsw/reg.h     | 103 +++++++
 .../net/ethernet/mellanox/mlxsw/spectrum.c    |  36 +++
 .../net/ethernet/mellanox/mlxsw/spectrum.h    |   3 +
 .../ethernet/mellanox/mlxsw/spectrum_ptp.c    | 267 ++++++++++++++++++
 .../ethernet/mellanox/mlxsw/spectrum_ptp.h    |  44 +++
 drivers/ptp/ptp_clock.c                       |   5 +-
 include/linux/ptp_clock_kernel.h              |   8 +
 tools/testing/selftests/ptp/phc.sh            | 166 +++++++++++
 14 files changed, 697 insertions(+), 3 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c
 create mode 100644 drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.h
 create mode 100755 tools/testing/selftests/ptp/phc.sh

-- 
2.20.1

