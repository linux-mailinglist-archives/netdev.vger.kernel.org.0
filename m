Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12A2F67793D
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 11:33:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231883AbjAWKdp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 05:33:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231645AbjAWKdn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 05:33:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC31514E9D;
        Mon, 23 Jan 2023 02:33:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 37EF8B80CC3;
        Mon, 23 Jan 2023 10:33:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 330CBC433EF;
        Mon, 23 Jan 2023 10:33:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674470018;
        bh=D6wxpzhBPVnmUmO9pIJ6yjXJVHLSNxbB4lCaD5otXw0=;
        h=From:Subject:To:Cc:Date:From;
        b=Fc5gXnzDOieznyLF9P1yQOT/yjs/qgjuAaNbLLotmQ0Sg115KZVOpGv0geMnDEpvH
         qC+6j/Fm5GCRVrJzYQKXzzew3cX8sCyAghQtrZ6vFKd3kYuJe8lh7mFhTsC5X9NFbH
         EoqXKdViGNjn0Csk87UnF9k3VnMnbo0rjr/XFDQ1Ckgl+PvNc8P9HNJNIacVe8O9gr
         GSKnI1Dnqk0Mn5AaVEHHqs8NYR/IFQLiplSqPF18GtgW7kDYwelkll2yaeJQfaPEFH
         zjPVCt1PbOCZ9SRXdbZxe7lOssxIdqyuNJepgqRRUM2iQ4wn/SzK3P0n1/pnU18s6l
         IAVRwED4ygh7A==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From:   Kalle Valo <kvalo@kernel.org>
Subject: pull-request: wireless-next-2023-01-23
To:     netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org
Message-Id: <20230123103338.330CBC433EF@smtp.kernel.org>
Date:   Mon, 23 Jan 2023 10:33:38 +0000 (UTC)
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

here's a pull request to net-next tree, more info below. Please let me know if
there are any problems.

Kalle

The following changes since commit 80f8a66dede0a4b4e9e846765a97809c6fe49ce5:

  Revert "wifi: mac80211: fix memory leak in ieee80211_if_add()" (2023-01-16 17:28:52 +0200)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless-next.git tags/wireless-next-2023-01-23

for you to fetch changes up to 4ca69027691a0039279b64cfa0aa511d9c9fde59:

  wifi: wireless: deny wireless extensions on MLO-capable devices (2023-01-19 20:01:41 +0200)

----------------------------------------------------------------
wireless-next patches for v6.3

First set of patches for v6.3. The most important change here is that
the old Wireless Extension user space interface is not supported on
Wi-Fi 7 devices at all. We also added a warning if anyone with modern
drivers (ie. cfg80211 and mac80211 drivers) tries to use Wireless
Extensions, everyone should switch to using nl80211 interface instead.

Static WEP support is removed, there wasn't any driver using that
anyway so there's no user impact. Otherwise it's smaller features and
fixes as usual.

Note: As mt76 had tricky conflicts due to the fixes in wireless tree,
we decided to merge wireless into wireless-next to solve them easily.
There should not be any merge problems anymore.

Major changes:

cfg80211

* remove never used static WEP support

* warn if Wireless Extention interface is used with cfg80211/mac80211 drivers

* stop supporting Wireless Extensions with Wi-Fi 7 devices

* support minimal Wi-Fi 7 Extremely High Throughput (EHT) rate reporting

rfkill

* add GPIO DT support

bitfield

* add FIELD_PREP_CONST()

mt76

* per-PHY LED support

rtw89

* support new Bluetooth co-existance version

rtl8xxxu

* support RTL8188EU

----------------------------------------------------------------
Alexey Kodanev (1):
      wifi: orinoco: check return value of hermes_write_wordrec()

Bitterblue Smith (11):
      wifi: rtl8xxxu: Fix assignment to bit field priv->pi_enabled
      wifi: rtl8xxxu: Fix assignment to bit field priv->cck_agc_report_type
      wifi: rtl8xxxu: Deduplicate the efuse dumping code
      wifi: rtl8xxxu: Make rtl8xxxu_load_firmware take const char*
      wifi: rtl8xxxu: Define masks for cck_agc_rpt bits
      wifi: rtl8xxxu: Add rate control code for RTL8188EU
      wifi: rtl8xxxu: Fix memory leaks with RTL8723BU, RTL8192EU
      wifi: rtl8xxxu: Report the RSSI to the firmware
      wifi: rtl8xxxu: Use a longer retry limit of 48
      wifi: rtl8xxxu: Print the ROM version too
      wifi: rtl8xxxu: Dump the efuse only for untested devices

Chih-Kang Chang (2):
      wifi: rtw89: 8852c: rfk: refine AGC tuning flow of DPK for irregular PA
      wifi: rtw89: 8852c: rfk: correct ADC clock settings

Ching-Te Ku (19):
      wifi: rtw89: coex: Enable Bluetooth report when show debug info
      wifi: rtw89: coex: Update BTC firmware report bitmap definition
      wifi: rtw89: coex: Add v2 BT AFH report and related variable
      wifi: rtw89: coex: refactor _chk_btc_report() to extend more features
      wifi: rtw89: coex: Change TDMA related logic to version separate
      wifi: rtw89: coex: Remove le32 to CPU translator at firmware cycle report
      wifi: rtw89: coex: Rename BTC firmware cycle report by feature version
      wifi: rtw89: coex: Add v4 version firmware cycle report
      wifi: rtw89: coex: Change firmware control report to version separate
      wifi: rtw89: coex: Add v5 firmware control report
      wifi: rtw89: coex: only read Bluetooth counter of report version 1 for RTL8852A
      wifi: rtw89: coex: Update WiFi role info H2C report
      wifi: rtw89: coex: Add version code for Wi-Fi firmware coexistence control
      wifi: rtw89: coex: Change Wi-Fi Null data report to version separate
      wifi: rtw89: coex: Change firmware steps report to version separate
      wifi: rtw89: coex: refactor debug log of slot list
      wifi: rtw89: coex: Packet traffic arbitration hardware owner monitor
      wifi: rtw89: coex: Change RTL8852B use v1 TDMA policy
      wifi: rtw89: coex: Change Wi-Fi role info related logic to version separate

Deren Wu (2):
      wifi: mt76: mt7921s: fix slab-out-of-bounds access in sdio host
      wifi: mt76: fix coverity uninit_use_in_call in mt76_connac2_reverse_frag0_hdr_trans()

Eric Huang (2):
      wifi: rtw89: 8852b: update BSS color mapping register
      wifi: rtw89: correct register definitions of digital CFO and spur elimination

Jes Sorensen (1):
      wifi: rtl8xxxu: Support new chip RTL8188EU

Jiapeng Chong (1):
      wifi: rt2x00: Remove useless else if

Jiasheng Jiang (1):
      wifi: rtw89: Add missing check for alloc_workqueue

Jisoo Jang (3):
      wifi: brcmfmac: Fix potential stack-out-of-bounds in brcmf_c_preinit_dcmds()
      wifi: brcmfmac: ensure CLM version is null-terminated to prevent stack-out-of-bounds
      wifi: mt7601u: fix an integer underflow

Johannes Berg (7):
      wifi: cfg80211: remove support for static WEP
      mac80211: support minimal EHT rate reporting on RX
      wifi: mac80211: add kernel-doc for EHT structure
      bitfield: add FIELD_PREP_CONST()
      wifi: mac80211: drop extra 'e' from ieeee80211... name
      wifi: wireless: warn on most wireless extension usage
      wifi: wireless: deny wireless extensions on MLO-capable devices

Jun ASAKA (1):
      wifi: rtl8xxxu: fixing transmisison failure for rtl8192eu

Kalle Valo (2):
      Merge tag 'mt76-for-kvalo-2022-12-09' of https://github.com/nbd168/wireless
      Merge wireless into wireless-next

Konstantin Ryabitsev (1):
      wifi: rtlwifi: rtl8723ae: fix obvious spelling error tyep->type

Kuan-Chung Chen (2):
      wifi: rtw89: fix null vif pointer when get management frame date rate
      wifi: rtw89: set the correct mac_id for management frames

Li Zetao (1):
      wifi: rtlwifi: Fix global-out-of-bounds bug in _rtl8812ae_phy_set_txpower_limit()

Lorenzo Bianconi (10):
      wifi: mt76: mt7996: fix endianness warning in mt7996_mcu_sta_he_tlv
      wifi: mt76: mt76x0: fix oob access in mt76x0_phy_get_target_power
      wifi: mt76: move leds field in leds struct
      wifi: mt76: move leds struct in mt76_phy
      wifi: mt76: mt7915: enable per-phy led support
      wifi: mt76: mt7615: enable per-phy led support
      wifi: mt76: dma: do not increment queue head if mt76_dma_add_buf fails
      wifi: mt76: handle possible mt76_rx_token_consume failures
      wifi: mt76: dma: rely on queue page_frag_cache for wed rx queues
      wifi: mt76: mt7915: get rid of wed rx_buf_ring page_frag_cache

Lukas Wunner (1):
      wifi: cfg80211: Deduplicate certificate loading

Martin Blumenstingl (4):
      wifi: mac80211: Drop stations iterator where the iterator function may sleep
      wifi: rtw88: Move register access from rtw_bf_assoc() outside the RCU
      wifi: rtw88: Use rtw_iterate_vifs() for rtw_vif_watch_dog_iter()
      wifi: rtw88: Use non-atomic sta iterator in rtw_ra_mask_info_update()

Masanari Iida (1):
      wifi: rtw89: Fix a typo in debug message

Muna Sinada (2):
      wifi: mac80211: Add VHT MU-MIMO related flags in ieee80211_bss_conf
      wifi: mac80211: Add HE MU-MIMO related flags in ieee80211_bss_conf

Nick Hainke (1):
      wifi: mac80211: fix double space in comment

Philipp Zabel (2):
      dt-bindings: net: Add rfkill-gpio binding
      net: rfkill: gpio: add DT support

Ping-Ke Shih (7):
      wifi: rtw89: consider ER SU as a TX capability
      wifi: rtw89: fw: adapt to new firmware format of security section
      wifi: rtw89: 8852c: rfk: correct DACK setting
      wifi: rtw89: 8852c: rfk: correct DPK settings
      wifi: rtw89: 8852c: rfk: recover RX DCK failure
      wifi: rtw89: coex: add BTC format version derived from firmware version
      wifi: rtw89: coex: use new introduction BTC version format

Po-Hao Huang (1):
      wifi: rtw89: refine 6 GHz scanning dwell time

Quan Zhou (1):
      wifi: mt76: mt7921: add support to update fw capability with MTFG table

Ryder Lee (12):
      wifi: mt76: mt7915: fix mt7915_rate_txpower_get() resource leaks
      wifi: mt76: mt7996: fix insecure data handling of mt7996_mcu_ie_countdown()
      wifi: mt76: mt7996: fix insecure data handling of mt7996_mcu_rx_radar_detected()
      wifi: mt76: mt7996: fix integer handling issue of mt7996_rf_regval_set()
      wifi: mt76: mt7915: split mcu chan_mib array up
      wifi: mt76: mt7915: check return value before accessing free_block_num
      wifi: mt76: mt7996: check return value before accessing free_block_num
      wifi: mt76: mt7915: check the correctness of event data
      wifi: mt76: mt7915: drop always true condition of __mt7915_reg_addr()
      wifi: mt76: mt7996: drop always true condition of __mt7996_reg_addr()
      wifi: mt76: mt7996: fix unintended sign extension of mt7996_hw_queue_read()
      wifi: mt76: mt7915: fix unintended sign extension of mt7915_hw_queue_read()

Sean Wang (1):
      wifi: mt76: mt7921: resource leaks at mt7921_check_offload_capability()

Shivani Baranwal (2):
      wifi: cfg80211: Fix extended KCK key length check in nl80211_set_rekey_data()
      wifi: cfg80211: Support 32 bytes KCK key in GTK rekey offload

Veerendranath Jakkam (1):
      wifi: cfg80211: Use MLD address to indicate MLD STA disconnection

Wang Yufen (2):
      wifi: mt76: mt7915: add missing of_node_put()
      wifi: wilc1000: add missing unregister_netdev() in wilc_netdev_ifc_init()

Yang Yingliang (11):
      wifi: rtlwifi: rtl8821ae: don't call kfree_skb() under spin_lock_irqsave()
      wifi: rtlwifi: rtl8188ee: don't call kfree_skb() under spin_lock_irqsave()
      wifi: rtlwifi: rtl8723be: don't call kfree_skb() under spin_lock_irqsave()
      wifi: iwlegacy: common: don't call dev_kfree_skb() under spin_lock_irqsave()
      wifi: rtl8xxxu: don't call dev_kfree_skb() under spin_lock_irqsave()
      wifi: ipw2x00: don't call dev_kfree_skb() under spin_lock_irqsave()
      wifi: libertas_tf: don't call kfree_skb() under spin_lock_irqsave()
      wifi: libertas: if_usb: don't call kfree_skb() under spin_lock_irqsave()
      wifi: libertas: main: don't call kfree_skb() under spin_lock_irqsave()
      wifi: libertas: cmdresp: don't call kfree_skb() under spin_lock_irqsave()
      wifi: wl3501_cs: don't call kfree_skb() under spin_lock_irqsave()

Yuan Can (1):
      wifi: rsi: Fix memory leak in rsi_coex_attach()

Zhang Changzhong (2):
      wifi: wilc1000: fix potential memory leak in wilc_mac_xmit()
      wifi: brcmfmac: fix potential memory leak in brcmf_netdev_start_xmit()

Zhengchao Shao (3):
      wifi: libertas: fix memory leak in lbs_init_adapter()
      wifi: ipw2200: fix memory leak in ipw_wdev_init()
      wifi: brcmfmac: unmap dma buffer in brcmf_msgbuf_alloc_pktid()

Zong-Zhe Yang (3):
      wifi: rtw89: fix potential leak in rtw89_append_probe_req_ie()
      wifi: rtw89: fix assignation of TX BD RAM table
      wifi: rtw89: 8852b: fill the missing configuration about queue empty checking

 .../devicetree/bindings/net/rfkill-gpio.yaml       |   51 +
 crypto/asymmetric_keys/x509_loader.c               |    1 +
 drivers/net/wireless/ath/ath11k/wmi.c              |    4 +-
 .../wireless/broadcom/brcm80211/brcmfmac/common.c  |    7 +-
 .../wireless/broadcom/brcm80211/brcmfmac/core.c    |    1 +
 .../wireless/broadcom/brcm80211/brcmfmac/msgbuf.c  |    5 +-
 drivers/net/wireless/intel/ipw2x00/ipw2200.c       |   11 +-
 drivers/net/wireless/intel/iwlegacy/common.c       |    4 +-
 drivers/net/wireless/intersil/orinoco/hw.c         |    2 +
 drivers/net/wireless/marvell/libertas/cmdresp.c    |    2 +-
 drivers/net/wireless/marvell/libertas/if_usb.c     |    2 +-
 drivers/net/wireless/marvell/libertas/main.c       |    3 +-
 drivers/net/wireless/marvell/libertas_tf/if_usb.c  |    2 +-
 drivers/net/wireless/mediatek/mt76/debugfs.c       |    2 +-
 drivers/net/wireless/mediatek/mt76/dma.c           |   16 +-
 drivers/net/wireless/mediatek/mt76/mac80211.c      |   56 +-
 drivers/net/wireless/mediatek/mt76/mt76.h          |   12 +-
 drivers/net/wireless/mediatek/mt76/mt7603/init.c   |   34 +-
 drivers/net/wireless/mediatek/mt76/mt7615/init.c   |   85 +
 drivers/net/wireless/mediatek/mt76/mt7615/mmio.c   |   16 -
 drivers/net/wireless/mediatek/mt76/mt7615/mt7615.h |    6 +
 .../net/wireless/mediatek/mt76/mt7615/pci_init.c   |   62 +-
 drivers/net/wireless/mediatek/mt76/mt7615/regs.h   |    1 +
 .../net/wireless/mediatek/mt76/mt76_connac_mac.c   |    2 +-
 drivers/net/wireless/mediatek/mt76/mt76x0/phy.c    |    7 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_util.c  |   35 +-
 .../net/wireless/mediatek/mt76/mt7915/debugfs.c    |    6 +-
 drivers/net/wireless/mediatek/mt76/mt7915/eeprom.c |   19 +-
 drivers/net/wireless/mediatek/mt76/mt7915/init.c   |  124 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.c    |   81 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mmio.c   |   27 +-
 drivers/net/wireless/mediatek/mt76/mt7915/regs.h   |   13 +-
 drivers/net/wireless/mediatek/mt76/mt7915/soc.c    |    1 +
 .../net/wireless/mediatek/mt76/mt7921/acpi_sar.c   |   55 +
 .../net/wireless/mediatek/mt76/mt7921/acpi_sar.h   |   12 +
 drivers/net/wireless/mediatek/mt76/mt7921/init.c   |    3 +-
 drivers/net/wireless/mediatek/mt76/mt7921/mcu.c    |    4 +-
 drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h |    7 +
 .../net/wireless/mediatek/mt76/mt7996/debugfs.c    |    5 +-
 drivers/net/wireless/mediatek/mt76/mt7996/eeprom.c |   18 +-
 drivers/net/wireless/mediatek/mt76/mt7996/init.c   |   14 +-
 drivers/net/wireless/mediatek/mt76/mt7996/mcu.c    |   15 +-
 drivers/net/wireless/mediatek/mt76/mt7996/mmio.c   |    2 +-
 drivers/net/wireless/mediatek/mt76/mt7996/regs.h   |    1 -
 drivers/net/wireless/mediatek/mt76/sdio_txrx.c     |    4 +
 drivers/net/wireless/mediatek/mt7601u/dma.c        |    3 +-
 drivers/net/wireless/microchip/wilc1000/netdev.c   |    8 +-
 drivers/net/wireless/ralink/rt2x00/rt2800lib.c     |    2 -
 drivers/net/wireless/realtek/rtl8xxxu/Kconfig      |    2 +-
 drivers/net/wireless/realtek/rtl8xxxu/Makefile     |    3 +-
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h   |  134 +-
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_8188e.c | 1874 ++++++++++++++++++++
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_8188f.c |   24 +-
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192c.c |   13 +-
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c |   21 +-
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723a.c |    3 +-
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723b.c |   18 +-
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c  |  412 ++++-
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h  |   40 +-
 .../net/wireless/realtek/rtlwifi/rtl8188ee/hw.c    |    6 +-
 .../realtek/rtlwifi/rtl8723ae/hal_bt_coexist.h     |    2 +-
 .../net/wireless/realtek/rtlwifi/rtl8723be/hw.c    |    6 +-
 .../net/wireless/realtek/rtlwifi/rtl8821ae/hw.c    |    6 +-
 .../net/wireless/realtek/rtlwifi/rtl8821ae/phy.c   |   52 +-
 drivers/net/wireless/realtek/rtw88/bf.c            |   13 +-
 drivers/net/wireless/realtek/rtw88/mac80211.c      |    4 +-
 drivers/net/wireless/realtek/rtw88/main.c          |    6 +-
 drivers/net/wireless/realtek/rtw89/coex.c          | 1665 +++++++++++------
 drivers/net/wireless/realtek/rtw89/coex.h          |    1 +
 drivers/net/wireless/realtek/rtw89/core.c          |   50 +-
 drivers/net/wireless/realtek/rtw89/core.h          |  289 ++-
 drivers/net/wireless/realtek/rtw89/fw.c            |   62 +-
 drivers/net/wireless/realtek/rtw89/fw.h            |   14 +-
 drivers/net/wireless/realtek/rtw89/mac.c           |   11 +-
 drivers/net/wireless/realtek/rtw89/pci.c           |   15 +-
 drivers/net/wireless/realtek/rtw89/pci.h           |   15 +-
 drivers/net/wireless/realtek/rtw89/phy.c           |   10 +-
 drivers/net/wireless/realtek/rtw89/reg.h           |   22 +-
 drivers/net/wireless/realtek/rtw89/rtw8852a.c      |   25 +-
 drivers/net/wireless/realtek/rtw89/rtw8852a_rfk.c  |    2 +-
 drivers/net/wireless/realtek/rtw89/rtw8852ae.c     |    1 +
 drivers/net/wireless/realtek/rtw89/rtw8852b.c      |   20 +-
 drivers/net/wireless/realtek/rtw89/rtw8852be.c     |    1 +
 drivers/net/wireless/realtek/rtw89/rtw8852c.c      |   15 +-
 drivers/net/wireless/realtek/rtw89/rtw8852c_rfk.c  |  353 +++-
 drivers/net/wireless/realtek/rtw89/rtw8852ce.c     |    1 +
 drivers/net/wireless/realtek/rtw89/txrx.h          |    2 +
 drivers/net/wireless/rsi/rsi_91x_coex.c            |    1 +
 drivers/net/wireless/wl3501_cs.c                   |    2 +-
 include/linux/bitfield.h                           |   26 +
 include/linux/soc/mediatek/mtk_wed.h               |    1 -
 include/net/cfg80211.h                             |   16 +-
 include/net/mac80211.h                             |   73 +-
 include/uapi/linux/nl80211.h                       |    4 +-
 net/mac80211/cfg.c                                 |   36 +-
 net/mac80211/rx.c                                  |   15 +-
 net/mac80211/sta_info.c                            |    9 +-
 net/mac80211/sta_info.h                            |   24 +-
 net/mac80211/util.c                                |   26 +-
 net/rfkill/rfkill-gpio.c                           |   20 +-
 net/wireless/core.h                                |    4 +-
 net/wireless/ibss.c                                |    5 +-
 net/wireless/nl80211.c                             |    6 +-
 net/wireless/reg.c                                 |   54 +-
 net/wireless/sme.c                                 |    6 +-
 net/wireless/util.c                                |    2 +-
 net/wireless/wext-compat.c                         |    2 +-
 net/wireless/wext-core.c                           |   20 +-
 net/wireless/wext-sme.c                            |    2 +-
 109 files changed, 5079 insertions(+), 1341 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/rfkill-gpio.yaml
 create mode 100644 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8188e.c
