Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CBC3A3D134
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 17:45:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391798AbfFKPpo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 11:45:44 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:42279 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2391628AbfFKPpo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jun 2019 11:45:44 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 1F88A22303;
        Tue, 11 Jun 2019 11:45:41 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Tue, 11 Jun 2019 11:45:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=CXJguJiR0lCFmlW/D
        pVxEYzemE/BLKyVclC1Src/s/Q=; b=bYYXIvDHWs9Lcxh/JRqm9k7jvxSm5btsT
        zgAzWXK4UUpUFC3rA35nFYNmytv1YkXh8ZI6LDMB5JKE+GhlqPcCQwy11Sk5UiFB
        ErgPAtVltcHE5Sl+BQImr4veYjSl0yQZ1BRS3BoWFk+Lz/hck2lvfrLddnUeJmGh
        WZo9qcbE5Re0/CWaSkncSFKLPZHkYN6SFOCQaaaBAkBS7bwerVYIcbuJJjLx8hDj
        bsQTYs6yYUMmUaQT558a1QhBaufx4vDN8RkQKp0zq/fHVtTNnDKfEYvGFCVPaFY1
        eW6YamiUOiPG9X67uSU9WIWw8vYhF/zafWBj+al8kbF5KpBB3g8ZQ==
X-ME-Sender: <xms:pMz_XAKuiea9sosaM3IurnDI5ikbEj2UxE0XHGrVFNv107zUieNKIA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddrudehhedgjeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgggfestdekredtre
    dttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiughoshgt
    hhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpehmrg
    hilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghrufhi
    iigvpedt
X-ME-Proxy: <xmx:pMz_XOzWfHGknFOpLbJ2t-beRpJDuJeDT0LQxoKEh8-VmnSOaBJooQ>
    <xmx:pMz_XAUaiomwjja11UJnsrXBoGGB1b3bJhBDR40ROyzlT5mc_KcgNQ>
    <xmx:pMz_XDnzUnZknZXEJ6Iao_hVIVnmEHycjZAx5l91fILL_m1IBLH8IA>
    <xmx:pcz_XHqz5F0c6rDJv6BFhGKdVqOlc2zl8JsNv7q-9LPSJXiiKBtYZg>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id EF3E8380088;
        Tue, 11 Jun 2019 11:45:38 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, shalomt@mellanox.com,
        petrm@mellanox.com, richardcochran@gmail.com, olteanv@gmail.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next v2 0/9] mlxsw: Add support for physical hardware clock
Date:   Tue, 11 Jun 2019 18:45:03 +0300
Message-Id: <20190611154512.17650-1-idosch@idosch.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

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

v2 (Richard):
* s/ptp_clock_scaled_ppm_to_ppb/scaled_ppm_to_ppb/
* imply PTP_1588_CLOCK in mlxsw Kconfig
* s/mlxsw_sp1_ptp_update_phc_settime/mlxsw_sp1_ptp_phc_settime/
* s/mlxsw_sp1_ptp_update_phc_adjfreq/mlxsw_sp1_ptp_phc_adjfreq/

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

 drivers/net/ethernet/mellanox/mlxsw/Kconfig   |   1 +
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
 drivers/ptp/ptp_clock.c                       |   3 +-
 include/linux/ptp_clock_kernel.h              |   8 +
 tools/testing/selftests/ptp/phc.sh            | 166 +++++++++++
 15 files changed, 697 insertions(+), 2 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c
 create mode 100644 drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.h
 create mode 100755 tools/testing/selftests/ptp/phc.sh

-- 
2.20.1

