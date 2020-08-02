Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30C8E235A17
	for <lists+netdev@lfdr.de>; Sun,  2 Aug 2020 21:02:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726901AbgHBTB4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Aug 2020 15:01:56 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:24219 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726347AbgHBTB4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 2 Aug 2020 15:01:56 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1596394914; h=Date: Message-Id: Cc: To: Subject: From:
 Content-Transfer-Encoding: MIME-Version: Content-Type: Sender;
 bh=cHzHL0zADcJxhR86g/ptn9DBYd8VGV62cYghFvS2YoE=; b=cDTBT9ZrF8gI6eU3AEstdrJIDTpz1ey0/iUgQJjqqdbQeTwSWv2HwZ/5YFdDxBVnIVYZwQDP
 D6+xTx9aZLi1IgGYQSrRTqs6+i7L5Vx+OhgmLr9qU7MaXo1NogMemViDjxO7LEz+p66Up3H/
 koFwKc+3Cd7Uotjahqmbhg2FVS4=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n15.prod.us-west-2.postgun.com with SMTP id
 5f270d9121feae908b58f6e3 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Sun, 02 Aug 2020 19:01:37
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id CB524C433CA; Sun,  2 Aug 2020 19:01:36 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=2.0 tests=ALL_TRUSTED,MISSING_DATE,
        MISSING_MID,SPF_NONE autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 4B91DC433C9;
        Sun,  2 Aug 2020 19:01:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 4B91DC433C9
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From:   Kalle Valo <kvalo@codeaurora.org>
Subject: pull-request: wireless-drivers-next-2020-08-02
To:     netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org
Message-Id: <20200802190136.CB524C433CA@smtp.codeaurora.org>
Date:   Sun,  2 Aug 2020 19:01:36 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

here's a pull request to net-next tree, more info below. Please let me know if
there are any problems.

Kalle

The following changes since commit dfecd3e00cd32b2a6d1cfdb30b513dd42575ada3:

  Merge branch 'net-dsa-mv88e6xxx-port-mtu-support' (2020-07-24 20:03:28 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-next.git tags/wireless-drivers-next-2020-08-02

for you to fetch changes up to 3dc05ffb04436020f63138186dbc4f37bd938552:

  brcmfmac: Set timeout value when configuring power save (2020-08-02 18:32:06 +0300)

----------------------------------------------------------------
wireless-drivers-next patches for v5.9

Second set of patches for v5.9. These patches have not been build
tested as much as normally because I'm on vacation right now.
Hopefully this does not cause any regressions.

mt76 has most of patches this time. Otherwise it's just smaller fixed
and cleanups to other drivers.

This pull request causes conflicts in four files in
drivers/net/wireless/mediatek/mt76/mt7615/, here is how I fixed those:

* usb.c: take the hunk which uses mt7663_usb_sdio_tx_*() functions

* mt7615.h: remove either one of the duplicate (and identical) enum tx_pkt_queue_idx

* mt7615.h: take the hunk which has mt7615_mutex_acquire/release() functions

* main.c: take the hunk which uses mt7615_mutex_acquire/release()

* mac.c: take the hunk which uses is_mmio

Major changes:

rtw88

* add support for ieee80211_ops::change_interface

* add support for enabling and disabling beacon

* add debugfs file for testing h2c

mt76

* ARP filter offload for 7663

* runtime power management for 7663

* testmode support for mfg calibration

* support for more channels

----------------------------------------------------------------
Ajay Singh (1):
      wilc1000: Move wilc1000 SDIO ID's from driver source to common header file

Alexander A. Klimov (4):
      prism54: Replace HTTP links with HTTPS ones
      ipw2x00: Replace HTTP links with HTTPS ones
      b43: Replace HTTP links with HTTPS ones
      b43legacy: Replace HTTP links with HTTPS ones

Andy Shevchenko (1):
      rtlwifi: btcoex: use %*ph to print small buffer

Christophe JAILLET (4):
      p54: switch from 'pci_' to 'dma_' API
      prism54: switch from 'pci_' to 'dma_' API
      ipw2100: Use GFP_KERNEL instead of GFP_ATOMIC in some memory allocation
      ipw2x00: switch from 'pci_' to 'dma_' API

Colin Ian King (1):
      rtlwifi: btcoex: remove redundant initialization of variables ant_num and single_ant_path

Dan Carpenter (1):
      mt76: mt7915: potential array overflow in mt7915_mcu_tx_rate_report()

Felix Fietkau (8):
      mt76: mt7615: re-enable offloading of sequence number assignment
      mt76: mt7615: schedule tx tasklet and sta poll on mac tx free
      mt76: mt7615: add support for accessing mapped registers via bus ops
      mt76: mt7615: add support for accessing RF registers via MCU
      mt76: mt7615: use full on-chip memory address for WF_PHY registers
      mt76: vif_mask to struct mt76_phy
      mt76: add API for testmode support
      mt76: mt7615: implement testmode support

Flavio Suligoi (1):
      intersil: fix wiki website url

Kalle Valo (1):
      Merge tag 'mt76-for-kvalo-2020-07-21' of https://github.com/nbd168/wireless

Linus Walleij (1):
      bcma: gpio: Use irqchip template

Lorenzo Bianconi (41):
      mt76: add missing lock configuring coverage class
      mt76: mt7615: fix lmac queue debugsfs entry
      mt76: mt7615: fix hw queue mapping
      mt76: overwrite qid for non-bufferable mgmt frames
      mt76: usb: rely on mt76_for_each_q_rx
      mt76: rely on register macros
      mt76: add U-APSD support on AP side
      mt76: mt76x2e: rename routines in pci.c
      mt76: mt76x2: fix pci suspend/resume on mt7612e
      mt76: mt76x2u: enable HC-M7662BU1
      mt76: mt7615: avoid polling in fw_own for mt7663
      mt76: move mt76 workqueue in common code
      mt76: mt7615: add mt7615_pm_wake utility routine
      mt76: mt7615: introduce mt7615_mutex_{acquire,release} utilities
      mt76: mt7615: wake device before accessing regmap in debugfs
      mt76: mt7615: wake device before configuring hw keys
      mt76: mt7615: introduce pm_power_save delayed work
      mt76: mt7615: wake device in mt7615_update_channel before access regmap
      mt76: mt7615: acquire driver_own before configuring device for suspend
      mt76: mt7615: wake device before performing freq scan
      mt76: mt7615: add missing lock in mt7615_regd_notifier
      mt76: mt7615: run mt7615_mcu_set_wmm holding mt76 mutex
      mt76: mt7615: run mt7615_mcu_set_roc holding mt76 mutex
      mt76: mt7615: wake device before pulling packets from mac80211 queues
      mt76: mt7615: wake device before pushing frames in mt7615_tx
      mt76: mt7615: run mt7615_pm_wake in mt7615_mac_sta_{add,remove}
      mt76: mt7615: check MT76_STATE_PM flag before accessing the device
      mt76: mt7615: do not request {driver,fw}_own if already granted
      mt76: mt7615: add runtime-pm knob in mt7615 debugfs
      mt76: mt7615: enable beacon hw filter for runtime-pm
      mt76: mt7615: add idle-timeout knob in mt7615 debugfs
      mt76: mt7615: improve mt7615_driver_own reliability
      mt76: mt7663u: sync probe sampling with rate configuration
      mt76: mt7615: avoid scheduling runtime-pm during hw scan
      mt76: mt7615: reschedule ps work according to last activity
      mt76: mt7615: take into account sdio bus configuring txwi
      mt76: mt76u: add mt76_skb_adjust_pad utility routine
      mt76: mt7615: sdio code must access rate/key regs in preocess context
      mt76: mt7615: introduce mt7663-usb-sdio-common module
      mt76: mt76s: move queue accounting in mt76s_tx_queue_skb
      mt76: mt7615: fix possible memory leak in mt7615_mcu_wtbl_sta_add

Markus Theil (2):
      mt76: allow more channels, allowed in ETSI domain
      mt76: fix include in pci.h

Navid Emamdoost (2):
      mt76: mt76u: add missing release on skb in __mt76x02u_mcu_send_msg
      mt7601u: add missing release on skb in mt7601u_mcu_msg_send

Nicolas Saenz Julienne (1):
      brcmfmac: Set timeout value when configuring power save

Ping-Cheng Chen (1):
      rtw88: 8821c: coex: add functions and parameters

Ryder Lee (9):
      mt76: mt7615: add .set_tsf callback
      mt76: mt7915: add a fixed AC queue mapping
      mt76: mt7915: add MU-MIMO support
      mt76: mt7915: use ieee80211_tx_queue_params to avoid open coded
      mt76: mt7915: overwrite qid for non-bufferable mgmt frames
      mt76: mt7915: update HE capabilities
      mt76: mt7915: avoid memcpy in rxv operation
      mt76: mt7915: add missing CONFIG_MAC80211_DEBUGFS
      mt76: mt7915: fix potential memory leak in mcu message handler

Sean Wang (7):
      mt76: mt7663: introduce ARP filter offload
      mt76: mt7615: fix up typo in Kconfig for MT7663U
      mt76: mt7663u: fix memory leak in set key
      mt76: mt7663u: fix potential memory leak in mcu message handler
      mt76: mt7615: fix potential memory leak in mcu message handler
      mt76: introduce mt76_sdio module
      mt76: mt7615: introduce mt7663s support

Tsang-Shian Lin (2):
      rtw88: fix LDPC field for RA info
      rtw88: fix short GI capability based on current bandwidth

Tzu-En Huang (2):
      rtw88: update tx descriptor of mgmt and reserved page packets
      rtw88: add h2c command in debugfs

Vaibhav Gupta (4):
      prism54: islpci_hotplug: use generic power management
      rt2x00: pci: use generic power management
      hostap: use generic power management
      airo: use generic power management

Wang Hai (2):
      qtnfmac: Missing platform_device_unregister() on error in qtnf_core_mac_alloc()
      wl1251: fix always return 0 error

Wei Yongjun (1):
      rtw88: 8821c: make symbol 'rtw8821c_rtw_pwr_track_tbl' static

Wolfram Sang (1):
      iwlwifi: yoyo: don't print failure if debug firmware is missing

Xu Wang (1):
      mwifiex: 11n_rxreorder: Remove unnecessary cast in kfree()

Yan-Hsuan Chuang (3):
      rtw88: coex: only skip coex triggered by BT info
      rtw88: add ieee80211_ops::change_interface
      rtw88: allows driver to enable/disable beacon

Zheng Yongjun (1):
      drivers: bcma: remove set but not used variable `addrh` and `sizeh`

 .../device_drivers/wifi/intel/ipw2100.rst          |   2 +-
 drivers/bcma/driver_gpio.c                         |  23 +-
 drivers/bcma/scan.c                                |   8 +-
 drivers/net/wireless/broadcom/b43/main.c           |  14 +-
 drivers/net/wireless/broadcom/b43/phy_common.c     |   2 +-
 drivers/net/wireless/broadcom/b43/phy_g.c          |  12 +-
 drivers/net/wireless/broadcom/b43/phy_ht.c         |   2 +-
 drivers/net/wireless/broadcom/b43/phy_lp.c         |   2 +-
 drivers/net/wireless/broadcom/b43/phy_n.c          | 150 +++----
 drivers/net/wireless/broadcom/b43/radio_2056.c     |   2 +-
 drivers/net/wireless/broadcom/b43/tables_nphy.c    |   4 +-
 drivers/net/wireless/broadcom/b43legacy/main.c     |   8 +-
 drivers/net/wireless/broadcom/b43legacy/phy.c      |   8 +-
 drivers/net/wireless/broadcom/b43legacy/radio.c    |   8 +-
 .../broadcom/brcm80211/brcmfmac/cfg80211.c         |   8 +
 drivers/net/wireless/cisco/airo.c                  |  39 +-
 drivers/net/wireless/intel/ipw2x00/Kconfig         |   4 +-
 drivers/net/wireless/intel/ipw2x00/ipw2100.c       | 123 +++--
 drivers/net/wireless/intel/ipw2x00/ipw2200.c       |  56 +--
 drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c   |   2 +-
 drivers/net/wireless/intersil/Kconfig              |   2 +-
 drivers/net/wireless/intersil/hostap/hostap_hw.c   |   6 +-
 drivers/net/wireless/intersil/hostap/hostap_pci.c  |  34 +-
 drivers/net/wireless/intersil/orinoco/Kconfig      |   4 +-
 drivers/net/wireless/intersil/p54/Kconfig          |   6 +-
 drivers/net/wireless/intersil/p54/fwio.c           |   2 +-
 drivers/net/wireless/intersil/p54/p54pci.c         |  65 +--
 drivers/net/wireless/intersil/p54/p54usb.c         |   2 +-
 drivers/net/wireless/intersil/prism54/isl_oid.h    |   2 +-
 drivers/net/wireless/intersil/prism54/islpci_dev.c |  30 +-
 drivers/net/wireless/intersil/prism54/islpci_eth.c |  24 +-
 .../net/wireless/intersil/prism54/islpci_hotplug.c |  39 +-
 drivers/net/wireless/intersil/prism54/islpci_mgt.c |  21 +-
 .../net/wireless/marvell/mwifiex/11n_rxreorder.c   |   2 +-
 drivers/net/wireless/mediatek/mt76/Kconfig         |   4 +
 drivers/net/wireless/mediatek/mt76/Makefile        |   3 +
 drivers/net/wireless/mediatek/mt76/debugfs.c       |   7 +-
 drivers/net/wireless/mediatek/mt76/dma.c           |   6 +
 drivers/net/wireless/mediatek/mt76/eeprom.c        |   5 +
 drivers/net/wireless/mediatek/mt76/mac80211.c      |  37 +-
 drivers/net/wireless/mediatek/mt76/mt76.h          | 116 ++++-
 drivers/net/wireless/mediatek/mt76/mt7603/main.c   |   8 +-
 drivers/net/wireless/mediatek/mt76/mt7603/mt7603.h |   2 -
 drivers/net/wireless/mediatek/mt76/mt7615/Kconfig  |  19 +-
 drivers/net/wireless/mediatek/mt76/mt7615/Makefile |   7 +-
 .../net/wireless/mediatek/mt76/mt7615/debugfs.c    | 111 ++++-
 drivers/net/wireless/mediatek/mt76/mt7615/dma.c    |  13 +-
 drivers/net/wireless/mediatek/mt76/mt7615/init.c   |  17 +-
 drivers/net/wireless/mediatek/mt76/mt7615/mac.c    | 330 ++++++++++++--
 drivers/net/wireless/mediatek/mt76/mt7615/mac.h    |  20 +-
 drivers/net/wireless/mediatek/mt76/mt7615/main.c   | 332 +++++++++++---
 drivers/net/wireless/mediatek/mt76/mt7615/mcu.c    | 371 ++++++++++++---
 drivers/net/wireless/mediatek/mt76/mt7615/mcu.h    |  54 ++-
 drivers/net/wireless/mediatek/mt76/mt7615/mmio.c   |  51 ++-
 drivers/net/wireless/mediatek/mt76/mt7615/mt7615.h | 125 +++++-
 drivers/net/wireless/mediatek/mt76/mt7615/pci.c    |   4 +
 .../net/wireless/mediatek/mt76/mt7615/pci_init.c   |   4 +
 .../net/wireless/mediatek/mt76/mt7615/pci_mac.c    |   1 -
 drivers/net/wireless/mediatek/mt76/mt7615/regs.h   |  33 +-
 drivers/net/wireless/mediatek/mt76/mt7615/sdio.c   | 478 ++++++++++++++++++++
 drivers/net/wireless/mediatek/mt76/mt7615/sdio.h   | 115 +++++
 .../net/wireless/mediatek/mt76/mt7615/sdio_mcu.c   | 162 +++++++
 .../net/wireless/mediatek/mt76/mt7615/sdio_txrx.c  | 268 +++++++++++
 .../net/wireless/mediatek/mt76/mt7615/testmode.c   | 363 +++++++++++++++
 drivers/net/wireless/mediatek/mt76/mt7615/usb.c    | 248 +---------
 .../net/wireless/mediatek/mt76/mt7615/usb_init.c   | 145 ------
 .../net/wireless/mediatek/mt76/mt7615/usb_mcu.c    |   7 +-
 .../net/wireless/mediatek/mt76/mt7615/usb_sdio.c   | 394 ++++++++++++++++
 drivers/net/wireless/mediatek/mt76/mt76x0/usb.c    |   6 +-
 drivers/net/wireless/mediatek/mt76/mt76x02.h       |   1 -
 drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c  |   2 +-
 .../net/wireless/mediatek/mt76/mt76x02_usb_core.c  |   3 +-
 .../net/wireless/mediatek/mt76/mt76x02_usb_mcu.c   |   7 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_util.c  |   8 +-
 drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2.h |   1 +
 drivers/net/wireless/mediatek/mt76/mt76x2/pci.c    |  70 ++-
 .../net/wireless/mediatek/mt76/mt76x2/pci_init.c   |  17 +
 drivers/net/wireless/mediatek/mt76/mt76x2/usb.c    |   8 +-
 .../net/wireless/mediatek/mt76/mt7915/debugfs.c    |  11 +-
 drivers/net/wireless/mediatek/mt76/mt7915/dma.c    |  21 +-
 drivers/net/wireless/mediatek/mt76/mt7915/init.c   |  44 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mac.c    |  93 ++--
 drivers/net/wireless/mediatek/mt76/mt7915/mac.h    |  17 -
 drivers/net/wireless/mediatek/mt76/mt7915/main.c   |  16 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.c    | 117 ++++-
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.h    |   6 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mt7915.h |  35 +-
 drivers/net/wireless/mediatek/mt76/mt7915/pci.c    |   2 +-
 drivers/net/wireless/mediatek/mt76/mt7915/regs.h   |   5 +
 drivers/net/wireless/mediatek/mt76/pci.c           |   1 +
 drivers/net/wireless/mediatek/mt76/sdio.c          | 368 +++++++++++++++
 drivers/net/wireless/mediatek/mt76/testmode.c      | 497 +++++++++++++++++++++
 drivers/net/wireless/mediatek/mt76/testmode.h      | 156 +++++++
 drivers/net/wireless/mediatek/mt76/tx.c            |  54 +++
 drivers/net/wireless/mediatek/mt76/usb.c           | 107 ++---
 drivers/net/wireless/mediatek/mt76/util.c          |   4 +-
 drivers/net/wireless/mediatek/mt7601u/mcu.c        |   4 +-
 drivers/net/wireless/microchip/wilc1000/sdio.c     |   6 +-
 drivers/net/wireless/quantenna/qtnfmac/core.c      |   5 +-
 drivers/net/wireless/ralink/rt2x00/rt2400pci.c     |   3 +-
 drivers/net/wireless/ralink/rt2x00/rt2500pci.c     |   3 +-
 drivers/net/wireless/ralink/rt2x00/rt2800pci.c     |   3 +-
 drivers/net/wireless/ralink/rt2x00/rt2x00.h        |   5 +-
 drivers/net/wireless/ralink/rt2x00/rt2x00dev.c     |   4 +-
 drivers/net/wireless/ralink/rt2x00/rt2x00pci.c     |  31 +-
 drivers/net/wireless/ralink/rt2x00/rt2x00pci.h     |   9 +-
 drivers/net/wireless/ralink/rt2x00/rt2x00soc.c     |   2 +-
 drivers/net/wireless/ralink/rt2x00/rt2x00usb.c     |   2 +-
 drivers/net/wireless/ralink/rt2x00/rt61pci.c       |   3 +-
 .../realtek/rtlwifi/btcoexist/halbtcoutsrc.c       |   8 +-
 drivers/net/wireless/realtek/rtw88/coex.c          |   3 +-
 drivers/net/wireless/realtek/rtw88/debug.c         |  30 ++
 drivers/net/wireless/realtek/rtw88/fw.c            |  17 +-
 drivers/net/wireless/realtek/rtw88/fw.h            |   2 +
 drivers/net/wireless/realtek/rtw88/mac80211.c      |  27 ++
 drivers/net/wireless/realtek/rtw88/main.c          |  11 +-
 drivers/net/wireless/realtek/rtw88/main.h          |   2 +
 drivers/net/wireless/realtek/rtw88/reg.h           |   1 +
 drivers/net/wireless/realtek/rtw88/rtw8821c.c      | 405 ++++++++++++++++-
 drivers/net/wireless/realtek/rtw88/rtw8821c.h      |  26 ++
 drivers/net/wireless/realtek/rtw88/tx.c            | 104 +++--
 drivers/net/wireless/realtek/rtw88/tx.h            |  13 +-
 drivers/net/wireless/ti/wl1251/event.c             |   2 +-
 include/linux/mmc/sdio_ids.h                       |   3 +
 124 files changed, 5667 insertions(+), 1320 deletions(-)
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7615/sdio.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7615/sdio.h
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7615/sdio_mcu.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7615/sdio_txrx.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7615/testmode.c
 delete mode 100644 drivers/net/wireless/mediatek/mt76/mt7615/usb_init.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7615/usb_sdio.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/sdio.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/testmode.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/testmode.h
