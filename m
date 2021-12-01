Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B26DD464A03
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 09:42:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233821AbhLAIp5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 03:45:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232262AbhLAIp4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 03:45:56 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FAF8C061574;
        Wed,  1 Dec 2021 00:42:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0AE3EB81DF9;
        Wed,  1 Dec 2021 08:42:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4053DC53FAD;
        Wed,  1 Dec 2021 08:42:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638348149;
        bh=RtBXXc7j6M6wRvYlM7KQB+jMuBoMXbnqnOjEYIVycI4=;
        h=From:Subject:To:Cc:Date:From;
        b=bCP50LStzwhyip6IQqTRaXTcnXidC8eK6QdslXQwXKEPl0l64cHGrxjjRR5psKqCn
         qoyO4I0262VMbwiut1lRFzK1N8wNyxwMXST3LIPsPfkLHoVZ30yydKeSO3mfNZL9Pb
         0iX9YcbkeRsiJlZ472bsD6a2KsluLB4c1A9rArCUSAIqIyVKIG+OklHHK9lCCDCpTR
         dlOG+/wu3E9RVAyKv3Bu4h94advkvEKD6r9qgWCdvVSW33a0iSTxsodKSk3T6bU7CD
         E339X0RCD3BqhrRAnU+QaYx/AViWK0Ec2xIs0BErcSCONK8dpRLdk3sPGw4aGJQsBP
         /qO7/JW3VCXyA==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
From:   Kalle Valo <kvalo@kernel.org>
Subject: pull-request: wireless-drivers-2021-12-01
To:     netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org
Message-Id: <20211201084229.4053DC53FAD@smtp.kernel.org>
Date:   Wed,  1 Dec 2021 08:42:29 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

here's a pull request to net tree, more info below. Please let me know if there
are any problems.

Kalle

The following changes since commit fa55b7dcdc43c1aa1ba12bca9d2dd4318c2a0dbf:

  Linux 5.16-rc1 (2021-11-14 13:56:52 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers.git tags/wireless-drivers-2021-12-01

for you to fetch changes up to 191587cd1a5f36852a0fc32cff2d5bc7680551db:

  mt76: fix key pointer overwrite in mt7921s_write_txwi/mt7663_usb_sdio_write_txwi (2021-11-29 19:33:33 +0200)

----------------------------------------------------------------
wireless-drivers fixes for v5.16

First set of fixes for v5.16. Mostly crash and driver initialisation
fixes, the fix for rtw89 being most important.

iwlwifi

* compiler, lockdep and smatch warning fixes

* fix for a rare driver initialisation failure

* fix a memory leak

rtw89

* fix const buffer modification causing a kernel crash

mt76

* fix null pointer access

* fix idr leak

rt2x00

* fix driver initialisation errors, a regression since v5.2-rc1

----------------------------------------------------------------
Arnd Bergmann (1):
      iwlwifi: pcie: fix constant-conversion warning

Christophe JAILLET (1):
      iwlwifi: Fix memory leaks in error handling path

Deren Wu (1):
      mt76: fix timestamp check in tx_status

Lorenzo Bianconi (3):
      mt76: mt7915: fix NULL pointer dereference in mt7915_get_phy_mode
      mt76: fix possible pktid leak
      mt76: fix key pointer overwrite in mt7921s_write_txwi/mt7663_usb_sdio_write_txwi

Mordechay Goodstein (1):
      iwlwifi: mvm: retry init flow if failed

Ping-Ke Shih (1):
      rtw89: update partition size of firmware header on skb->data

Stanislaw Gruszka (1):
      rt2x00: do not mark device gone on EPROTO errors during start

chongjiapeng (1):
      iwlwifi: Fix missing error code in iwl_pci_probe()

Łukasz Bartosik (1):
      iwlwifi: fix warnings produced by kernel debug options

 drivers/net/wireless/intel/iwlwifi/fw/uefi.c       |  6 +++++
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c       | 22 +++++++++++------
 drivers/net/wireless/intel/iwlwifi/iwl-drv.h       |  3 +++
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  | 24 ++++++++++++++++++-
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h       |  3 +++
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c       |  5 ++++
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c      | 10 ++++++--
 .../net/wireless/mediatek/mt76/mt7615/pci_mac.c    |  3 +--
 .../net/wireless/mediatek/mt76/mt7615/usb_sdio.c   | 28 ++++++++++++----------
 .../net/wireless/mediatek/mt76/mt76x02_usb_core.c  |  8 ++++++-
 drivers/net/wireless/mediatek/mt76/mt7915/mac.c    | 15 ++++++------
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.c    |  4 ++--
 .../net/wireless/mediatek/mt76/mt7921/sdio_mac.c   | 21 +++++++++-------
 drivers/net/wireless/mediatek/mt76/tx.c            |  2 +-
 drivers/net/wireless/ralink/rt2x00/rt2x00usb.c     |  3 +++
 drivers/net/wireless/realtek/rtw89/fw.c            |  2 +-
 drivers/net/wireless/realtek/rtw89/fw.h            |  6 +++--
 17 files changed, 116 insertions(+), 49 deletions(-)
