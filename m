Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FE0C572EF2
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 09:19:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234092AbiGMHTj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 03:19:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229968AbiGMHTi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 03:19:38 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30CF75C9E1;
        Wed, 13 Jul 2022 00:19:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Content-Type:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
        Resent-Message-ID:In-Reply-To:References;
        bh=ocFiboKT+wXRxdcF8qb17PSSG33q5N+R3QAfiNxrkD4=; t=1657696776; x=1658906376; 
        b=G315dt4V3cjVCVi4XuwmTIG8HyDPWUNSGszvAcG5OOTWqfnbvgcZW0hDDJF8EEIFPXBHInfb+ox
        tZ1xNFHl6dX29+za8EaUXoAPQpTe9kCKb+fqvA+lQ1ouxe7Out+B8qwGukZOPoZYK0QjFyYhm5He/
        EKCKPWyKXI5DU4fmzDYzV76CLiTggPDa9xg6A6CA0AV5s6dPISWkaxVI1QDfIKHP3Guly9ayQ6iUr
        G2rD/zleBq+/kJWq6fvzg8G6zGwiTkvIAI4XBuqIeeKP0z7u2yKcYG2ME4Cj86vP9PdKog1aftYjH
        xv8B6NupaBrEYyFmMtmonv5/BXHGWJN/oI/Q==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.95)
        (envelope-from <johannes@sipsolutions.net>)
        id 1oBWek-00EbjT-Db;
        Wed, 13 Jul 2022 09:19:34 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org
Subject: pull-request: wireless-next-2022-07-13
Date:   Wed, 13 Jul 2022 09:19:31 +0200
Message-Id: <20220713071932.20538-1-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

And another one, for next! This one's big, due to the first
parts of multi-link operation (MLO) support - though that's
not nearly done yet (have probably about as many patches as
here already in the pipeline again).

Please pull and let me know if there's any problem.

Thanks,
johannes



The following changes since commit fbb89d02e33a8c8f522d75882f5f19c65b722b46:

  net: sparx5: Allow mdb entries to both CPU and ports (2022-06-15 13:01:26 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless-next.git tags/wireless-next-2022-07-13

for you to fetch changes up to 58b6259d820d63c2adf1c7541b54cce5a2ae6073:

  wifi: mac80211_hwsim: add back erroneously removed cast (2022-07-11 13:16:30 +0200)

----------------------------------------------------------------
A fairly large set of updates for next, highlights:

ath10k
 * ethernet frame format support

rtw89
 * TDLS support

cfg80211/mac80211
 * airtime fairness fixes
 * EHT support continued, especially in AP mode
 * initial (and still major) rework for multi-link
   operation (MLO) from 802.11be/wifi 7

As usual, also many small updates/cleanups/fixes/etc.

----------------------------------------------------------------
Alexey Kodanev (1):
      wifi: iwlegacy: 4965: fix potential off-by-one overflow in il4965_rs_fill_link_cmd()

Aloka Dixit (1):
      wifi: nl80211: retrieve EHT related elements in AP mode

Baochen Qiang (1):
      ath11k: Fix warning on variable 'sar' dereference before check

Christian 'Ansuel' Marangi (1):
      ath11k: fix missing skb drop on htc_tx_completion error

Christophe JAILLET (1):
      wifi: mac80211: Use the bitmap API to allocate bitmaps

Felix Fietkau (7):
      wifi: mac80211: switch airtime fairness back to deficit round-robin scheduling
      wifi: mac80211: make sta airtime deficit field s32 instead of s64
      wifi: mac80211: consider aql_tx_pending when checking airtime deficit
      wifi: mac80211: keep recently active tx queues in scheduling list
      wifi: mac80211: add a per-PHY AQL limit to improve fairness
      wifi: mac80211: add debugfs file to display per-phy AQL pending airtime
      wifi: mac80211: only accumulate airtime deficit for active clients

Guo Zhengkui (2):
      ath5k: replace ternary operator with min()
      ath9k: replace ternary operator with max()

Jeongik Cha (1):
      wifi: mac80211_hwsim: fix race condition in pending packet

Jiang Jian (1):
      ath9k: remove unexpected words "the" in comments

Johan Hovold (2):
      ath11k: fix netdev open race
      ath11k: fix IRQ affinity warning on shutdown

Johannes Berg (53):
      wifi: mac80211: reject WEP or pairwise keys with key ID > 3
      wifi: cfg80211: do some rework towards MLO link APIs
      wifi: mac80211: move some future per-link data to bss_conf
      wifi: mac80211: move interface config to new struct
      wifi: mac80211: reorg some iface data structs for MLD
      wifi: mac80211: split bss_info_changed method
      wifi: mac80211: add per-link configuration pointer
      wifi: mac80211: pass link ID where already present
      wifi: mac80211: make channel context code MLO-aware
      wifi: mac80211: remove sta_info_tx_streams()
      wifi: mac80211: refactor some sta_info link handling
      wifi: mac80211: use IEEE80211_MLD_MAX_NUM_LINKS
      wifi: mac80211: validate some driver features for MLO
      wifi: mac80211: refactor some link setup code
      wifi: mac80211: add link_id to vht.c code for MLO
      wifi: mac80211: add link_id to eht.c code for MLO
      wifi: mac80211: HT: make ieee80211_ht_cap_ie_to_sta_ht_cap() MLO-aware
      wifi: mac80211: make some SMPS code MLD-aware
      wifi: mac80211: make ieee80211_he_cap_ie_to_sta_he_cap() MLO-aware
      wifi: mac80211: correct link config data in tracing
      wifi: mac80211: sort trace.h file
      wifi: mac80211: status: look up band only where needed
      wifi: mac80211: tx: simplify chanctx_conf handling
      wifi: cfg80211: mlme: get BSS entry outside cfg80211_mlme_assoc()
      wifi: nl80211: refactor BSS lookup in nl80211_associate()
      wifi: ieee80211: add definitions for multi-link element
      wifi: cfg80211: simplify cfg80211_mlme_auth() prototype
      wifi: mac80211: ignore IEEE80211_CONF_CHANGE_SMPS in chanctx mode
      wifi: nl80211: support MLO in auth/assoc
      wifi: mac80211: add vif link addition/removal
      wifi: mac80211: remove band from TX info in MLO
      wifi: mac80211: add MLO link ID to TX frame metadata
      wifi: mac80211: add sta link addition/removal
      wifi: cfg80211: sort trace.h
      wifi: cfg80211: add optional link add/remove callbacks
      wifi: mac80211: implement add/del interface link callbacks
      wifi: mac80211: move ieee80211_bssid_match() function
      wifi: mac80211: ethtool: use deflink for now
      wifi: mac80211: RCU-ify link STA pointers
      wifi: mac80211: maintain link-sta hash table
      wifi: mac80211: set STA deflink addresses
      wifi: nl80211: expose link information for interfaces
      wifi: nl80211: expose link ID for associated BSSes
      wifi: mac80211_hwsim: support creating MLO-capable radios
      wifi: cfg80211: remove redundant documentation
      wifi: mac80211: fix a kernel-doc complaint
      wifi: mac80211: properly skip link info driver update
      wifi: cfg80211: handle IBSS in channel switch
      wifi: nl80211: hold wdev mutex for tid config
      wifi: nl80211: acquire wdev mutex earlier in start_ap
      wifi: nl80211: relax wdev mutex check in wdev_chandef()
      wifi: cfg80211: remove chandef check in cfg80211_cac_event()
      wifi: mac80211_hwsim: add back erroneously removed cast

Julia Lawall (1):
      ath6kl: fix typo in comment

Kalle Valo (3):
      ath10k: fix recently introduced checkpatch warning
      Merge ath-next from git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git
      Merge ath-next from git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git

Krzysztof Kozlowski (1):
      ath10k: do not enforce interrupt trigger type

Kuan-Chung Chen (2):
      wifi: rtw89: fix potential TX stuck
      wifi: rtw89: enable VO TX AMPDU

Manikanta Pubbisetty (5):
      ath11k: Init hw_params before setting up AHB resources
      ath11k: Fix incorrect debug_mask mappings
      ath11k: Avoid REO CMD failed prints during firmware recovery
      ath11k: Fix LDPC config in set_bitrate_mask hook
      ath11k: Fix warnings reported by checkpatch

Mauro Carvalho Chehab (3):
      wifi: cfg80211: fix kernel-doc warnings all over the file
      wifi: mac80211: add a missing comma at kernel-doc markup
      wifi: mac80211: sta_info: fix a missing kernel-doc struct element

Maxime Bizon (1):
      ath10k: fix misreported tx bandwidth for 160Mhz

MeiChia Chiu (1):
      wifi: mac80211: fix center freq calculation in ieee80211_chandef_downgrade

Pavel Skripkin (2):
      ath9k: fix use-after-free in ath9k_hif_usb_rx_cb
      ath9k: htc: clean up statistics macros

Peter Chiu (1):
      wifi: ieee80211: s1g action frames are not robust

Ping-Ke Shih (9):
      wifi: rtw89: allocate address CAM and MAC ID to TDLS peer
      wifi: rtw89: separate BSSID CAM operations
      wifi: rtw89: allocate BSSID CAM per TDLS peer
      wifi: rtw89: support TDLS
      wifi: rtw89: add UNEXP debug mask to keep monitor messages unexpected to happen frequently
      wifi: rtw89: drop invalid TX rate report of legacy rate
      wifi: rtw89: fix long RX latency in low power mode
      wifi: rtw89: pci: fix PCI doesn't reclaim TX BD properly
      wifi: rtw89: 8852a: rfk: fix div 0 exception

Po-Hao Huang (1):
      wifi: rtw89: disable invalid phy reports for all ICs

Sergey Ryazanov (4):
      ath10k: improve tx status reporting
      ath10k: htt_tx: do not interpret Eth frames as WiFi
      ath10k: turn rawmode into frame_mode
      ath10k: add encapsulation offloading support

Shaul Triebitz (6):
      wifi: mac80211_hwsim: split bss_info_changed to vif/link info_changed
      wifi: mac80211: use link in start/stop ap
      wifi: mac80211: pass the link id in start/stop ap
      wifi: mac80211: return a beacon for a specific link
      wifi: mac80211_hwsim: send a beacon per link
      wifi: mac80211_hwsim: print the link id

Sriram R (1):
      ath11k: update missing MU-MIMO and OFDMA stats

Tetsuo Handa (1):
      ath6kl: avoid flush_scheduled_work() usage

Thiraviyam Mariyappan (1):
      ath11k: support avg signal in station dump

Veerendranath Jakkam (5):
      cfg80211: Indicate MLO connection info in connect and roam callbacks
      wifi: cfg80211: Increase akm_suites array size in cfg80211_crypto_settings
      wifi: nl80211: Fix reading NL80211_ATTR_MLO_LINK_ID in nl80211_pre_doit
      wifi: cfg80211: fix a comment in cfg80211_mlme_mgmt_tx()
      wifi: nl80211: fix sending link ID info of associated BSS

Wen Gong (1):
      ath10k: fix regdomain info of iw reg set/get

Xiang wangx (1):
      wcn36xx: Fix typo in comment

Zhang Jiaming (1):
      ath11k: Fix typo in comments

 drivers/net/wireless/admtek/adm8211.c              |    2 +-
 drivers/net/wireless/ath/ar5523/ar5523.c           |   12 +-
 drivers/net/wireless/ath/ath10k/core.c             |   11 +-
 drivers/net/wireless/ath/ath10k/core.h             |    1 +
 drivers/net/wireless/ath/ath10k/htt_rx.c           |    8 +-
 drivers/net/wireless/ath/ath10k/htt_tx.c           |   61 +-
 drivers/net/wireless/ath/ath10k/mac.c              |  113 +-
 drivers/net/wireless/ath/ath10k/qmi.c              |    4 +-
 drivers/net/wireless/ath/ath10k/snoc.c             |    5 +-
 drivers/net/wireless/ath/ath10k/txrx.c             |   15 +-
 drivers/net/wireless/ath/ath10k/wmi-tlv.c          |    2 +-
 drivers/net/wireless/ath/ath10k/wmi.c              |    4 +-
 drivers/net/wireless/ath/ath11k/ahb.c              |    4 +-
 drivers/net/wireless/ath/ath11k/core.c             |   16 +-
 drivers/net/wireless/ath/ath11k/core.h             |    6 +-
 drivers/net/wireless/ath/ath11k/debug.h            |    4 +-
 .../net/wireless/ath/ath11k/debugfs_htt_stats.c    |   88 +-
 .../net/wireless/ath/ath11k/debugfs_htt_stats.h    |   39 +
 drivers/net/wireless/ath/ath11k/dp_rx.c            |    8 +-
 drivers/net/wireless/ath/ath11k/hal.c              |    2 +-
 drivers/net/wireless/ath/ath11k/hal_rx.c           |    2 +-
 drivers/net/wireless/ath/ath11k/htc.c              |    4 +-
 drivers/net/wireless/ath/ath11k/mac.c              |   64 +-
 drivers/net/wireless/ath/ath11k/pci.c              |    2 +
 drivers/net/wireless/ath/ath11k/qmi.c              |    6 +-
 drivers/net/wireless/ath/ath11k/wmi.c              |    6 +-
 drivers/net/wireless/ath/ath5k/base.c              |    2 +-
 drivers/net/wireless/ath/ath5k/mac80211-ops.c      |   14 +-
 drivers/net/wireless/ath/ath5k/phy.c               |    2 +-
 drivers/net/wireless/ath/ath6kl/cfg80211.c         |    8 +-
 drivers/net/wireless/ath/ath6kl/usb.c              |   16 +-
 drivers/net/wireless/ath/ath6kl/wmi.h              |    2 +-
 drivers/net/wireless/ath/ath9k/ar9002_phy.c        |    2 +-
 drivers/net/wireless/ath/ath9k/beacon.c            |   15 +-
 drivers/net/wireless/ath/ath9k/dfs.c               |    2 +-
 drivers/net/wireless/ath/ath9k/hif_usb.c           |   26 +-
 drivers/net/wireless/ath/ath9k/htc.h               |   32 +-
 drivers/net/wireless/ath/ath9k/htc_drv_beacon.c    |    4 +-
 drivers/net/wireless/ath/ath9k/htc_drv_init.c      |    3 +-
 drivers/net/wireless/ath/ath9k/htc_drv_main.c      |   18 +-
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c      |   10 +-
 drivers/net/wireless/ath/ath9k/main.c              |   12 +-
 drivers/net/wireless/ath/carl9170/main.c           |    4 +-
 drivers/net/wireless/ath/carl9170/tx.c             |    2 +-
 drivers/net/wireless/ath/wcn36xx/hal.h             |    4 +-
 drivers/net/wireless/ath/wcn36xx/main.c            |   22 +-
 drivers/net/wireless/ath/wcn36xx/smd.c             |    2 +-
 drivers/net/wireless/ath/wil6210/cfg80211.c        |    9 +-
 drivers/net/wireless/ath/wil6210/wmi.c             |    4 +-
 drivers/net/wireless/atmel/at76c50x-usb.c          |    2 +-
 drivers/net/wireless/broadcom/b43/main.c           |    6 +-
 drivers/net/wireless/broadcom/b43legacy/main.c     |    4 +-
 .../broadcom/brcm80211/brcmfmac/cfg80211.c         |   10 +-
 .../broadcom/brcm80211/brcmsmac/mac80211_if.c      |   18 +-
 drivers/net/wireless/intel/iwlegacy/3945-mac.c     |    6 +-
 drivers/net/wireless/intel/iwlegacy/4965-rs.c      |    5 +-
 drivers/net/wireless/intel/iwlegacy/4965.c         |    6 +-
 drivers/net/wireless/intel/iwlegacy/common.c       |   18 +-
 drivers/net/wireless/intel/iwlegacy/common.h       |    2 +-
 drivers/net/wireless/intel/iwlwifi/dvm/agn.h       |    2 +-
 drivers/net/wireless/intel/iwlwifi/dvm/lib.c       |    4 +-
 drivers/net/wireless/intel/iwlwifi/dvm/main.c      |    4 +-
 drivers/net/wireless/intel/iwlwifi/dvm/rxon.c      |   26 +-
 drivers/net/wireless/intel/iwlwifi/mvm/coex.c      |   10 +-
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c        |    4 +-
 .../net/wireless/intel/iwlwifi/mvm/debugfs-vif.c   |    4 +-
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c   |    2 +-
 .../net/wireless/intel/iwlwifi/mvm/ftm-initiator.c |   12 +-
 .../net/wireless/intel/iwlwifi/mvm/ftm-responder.c |    4 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c  |   24 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  |   88 +-
 .../net/wireless/intel/iwlwifi/mvm/offloading.c    |    6 +-
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c       |    2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/power.c     |    4 +-
 drivers/net/wireless/intel/iwlwifi/mvm/quota.c     |    4 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rs.c        |    2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c      |    4 +-
 drivers/net/wireless/intel/iwlwifi/mvm/sf.c        |    6 +-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c       |    2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/tdls.c      |    4 +-
 .../net/wireless/intel/iwlwifi/mvm/time-event.c    |   12 +-
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c        |    2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/utils.c     |    6 +-
 drivers/net/wireless/intersil/p54/main.c           |    8 +-
 drivers/net/wireless/mac80211_hwsim.c              |  257 +++--
 drivers/net/wireless/mac80211_hwsim.h              |    5 +-
 drivers/net/wireless/marvell/libertas/mesh.c       |   10 +-
 drivers/net/wireless/marvell/libertas_tf/main.c    |    6 +-
 drivers/net/wireless/marvell/mwifiex/11h.c         |    2 +-
 drivers/net/wireless/marvell/mwifiex/cfg80211.c    |   18 +-
 drivers/net/wireless/marvell/mwl8k.c               |   14 +-
 drivers/net/wireless/mediatek/mt76/mac80211.c      |    4 +-
 drivers/net/wireless/mediatek/mt76/mt7603/beacon.c |    2 +-
 drivers/net/wireless/mediatek/mt76/mt7603/main.c   |    4 +-
 drivers/net/wireless/mediatek/mt76/mt7615/main.c   |    4 +-
 drivers/net/wireless/mediatek/mt76/mt7615/mcu.c    |    8 +-
 .../net/wireless/mediatek/mt76/mt76_connac_mcu.c   |   10 +-
 drivers/net/wireless/mediatek/mt76/mt76x02.h       |    2 +-
 .../net/wireless/mediatek/mt76/mt76x02_beacon.c    |    2 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_util.c  |    2 +-
 drivers/net/wireless/mediatek/mt76/mt7915/main.c   |    4 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.c    |   12 +-
 drivers/net/wireless/mediatek/mt76/mt7921/main.c   |    4 +-
 drivers/net/wireless/mediatek/mt76/mt7921/mcu.c    |    4 +-
 drivers/net/wireless/mediatek/mt7601u/main.c       |    2 +-
 drivers/net/wireless/mediatek/mt7601u/phy.c        |    9 +-
 drivers/net/wireless/microchip/wilc1000/cfg80211.c |    3 +-
 drivers/net/wireless/purelifi/plfxlc/mac.c         |    8 +-
 drivers/net/wireless/quantenna/qtnfmac/cfg80211.c  |   14 +-
 drivers/net/wireless/quantenna/qtnfmac/commands.c  |   14 +-
 drivers/net/wireless/quantenna/qtnfmac/event.c     |   15 +-
 drivers/net/wireless/ralink/rt2x00/rt2x00.h        |    2 +-
 drivers/net/wireless/ralink/rt2x00/rt2x00config.c  |    4 +-
 drivers/net/wireless/ralink/rt2x00/rt2x00mac.c     |    4 +-
 drivers/net/wireless/ralink/rt2x00/rt2x00queue.c   |    2 +-
 drivers/net/wireless/realtek/rtl818x/rtl8180/dev.c |    4 +-
 drivers/net/wireless/realtek/rtl818x/rtl8187/dev.c |    4 +-
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c  |   12 +-
 drivers/net/wireless/realtek/rtlwifi/core.c        |    8 +-
 drivers/net/wireless/realtek/rtlwifi/pci.c         |    2 +-
 drivers/net/wireless/realtek/rtw88/bf.c            |    2 +-
 drivers/net/wireless/realtek/rtw88/fw.c            |    2 +-
 drivers/net/wireless/realtek/rtw88/mac80211.c      |    9 +-
 drivers/net/wireless/realtek/rtw88/main.c          |   17 +-
 drivers/net/wireless/realtek/rtw89/cam.c           |   31 +-
 drivers/net/wireless/realtek/rtw89/cam.h           |    9 +-
 drivers/net/wireless/realtek/rtw89/core.c          |  150 ++-
 drivers/net/wireless/realtek/rtw89/core.h          |   35 +-
 drivers/net/wireless/realtek/rtw89/debug.c         |    3 +-
 drivers/net/wireless/realtek/rtw89/debug.h         |    2 +
 drivers/net/wireless/realtek/rtw89/fw.c            |    5 +-
 drivers/net/wireless/realtek/rtw89/mac80211.c      |   12 +-
 drivers/net/wireless/realtek/rtw89/pci.c           |   16 +-
 drivers/net/wireless/realtek/rtw89/phy.c           |   22 +-
 drivers/net/wireless/realtek/rtw89/rtw8852a_rfk.c  |    4 +-
 drivers/net/wireless/realtek/rtw89/ser.c           |   15 +-
 drivers/net/wireless/rndis_wlan.c                  |    5 +-
 drivers/net/wireless/rsi/rsi_91x_core.c            |    3 +-
 drivers/net/wireless/rsi/rsi_91x_hal.c             |    9 +-
 drivers/net/wireless/rsi/rsi_91x_mac80211.c        |   33 +-
 drivers/net/wireless/rsi/rsi_91x_mgmt.c            |    3 +-
 drivers/net/wireless/silabs/wfx/hif_tx.c           |   12 +-
 drivers/net/wireless/silabs/wfx/sta.c              |   40 +-
 drivers/net/wireless/silabs/wfx/sta.h              |   10 +-
 drivers/net/wireless/st/cw1200/sta.c               |   44 +-
 drivers/net/wireless/st/cw1200/sta.h               |    2 +-
 drivers/net/wireless/st/cw1200/txrx.c              |    4 +-
 drivers/net/wireless/ti/wl1251/main.c              |   12 +-
 drivers/net/wireless/ti/wlcore/cmd.c               |    4 +-
 drivers/net/wireless/ti/wlcore/main.c              |   47 +-
 drivers/net/wireless/zydas/zd1211rw/zd_mac.c       |   13 +-
 drivers/staging/rtl8723bs/os_dep/ioctl_cfg80211.c  |    8 +-
 drivers/staging/vt6655/device_main.c               |    8 +-
 drivers/staging/vt6655/rxtx.c                      |    2 +-
 drivers/staging/vt6656/main_usb.c                  |    6 +-
 drivers/staging/vt6656/rxtx.c                      |    2 +-
 drivers/staging/wlan-ng/cfg80211.c                 |    2 +-
 include/linux/ieee80211.h                          |  226 ++++
 include/net/cfg80211.h                             |  265 ++++-
 include/net/mac80211.h                             |  229 ++--
 include/uapi/linux/nl80211.h                       |   53 +
 net/mac80211/agg-rx.c                              |    4 +-
 net/mac80211/agg-tx.c                              |    2 +-
 net/mac80211/airtime.c                             |    4 +-
 net/mac80211/cfg.c                                 |  525 ++++-----
 net/mac80211/chan.c                                |  660 ++++++-----
 net/mac80211/debug.h                               |   14 +
 net/mac80211/debugfs.c                             |  101 +-
 net/mac80211/debugfs_key.c                         |   10 +-
 net/mac80211/debugfs_netdev.c                      |   52 +-
 net/mac80211/debugfs_sta.c                         |   24 +-
 net/mac80211/driver-ops.h                          |  102 +-
 net/mac80211/eht.c                                 |    9 +-
 net/mac80211/ethtool.c                             |   26 +-
 net/mac80211/he.c                                  |   17 +-
 net/mac80211/ht.c                                  |   41 +-
 net/mac80211/ibss.c                                |   65 +-
 net/mac80211/ieee80211_i.h                         |  478 +++-----
 net/mac80211/iface.c                               |  249 ++++-
 net/mac80211/key.c                                 |   56 +-
 net/mac80211/main.c                                |  158 ++-
 net/mac80211/mesh.c                                |   20 +-
 net/mac80211/mesh_plink.c                          |   19 +-
 net/mac80211/mlme.c                                |  434 ++++----
 net/mac80211/ocb.c                                 |   15 +-
 net/mac80211/offchannel.c                          |   22 +-
 net/mac80211/rate.c                                |   19 +-
 net/mac80211/rate.h                                |    8 +-
 net/mac80211/rx.c                                  |   49 +-
 net/mac80211/scan.c                                |    2 +-
 net/mac80211/sta_info.c                            |  391 +++++--
 net/mac80211/sta_info.h                            |   42 +-
 net/mac80211/status.c                              |   43 +-
 net/mac80211/tdls.c                                |   31 +-
 net/mac80211/trace.h                               | 1160 +++++++++++---------
 net/mac80211/tx.c                                  |  722 ++++++------
 net/mac80211/util.c                                |   82 +-
 net/mac80211/vht.c                                 |  177 +--
 net/mac80211/wme.c                                 |    3 +-
 net/wireless/ap.c                                  |   46 +-
 net/wireless/chan.c                                |  206 +++-
 net/wireless/core.c                                |   34 +-
 net/wireless/core.h                                |   24 +-
 net/wireless/ibss.c                                |   57 +-
 net/wireless/mesh.c                                |   31 +-
 net/wireless/mlme.c                                |  163 +--
 net/wireless/nl80211.c                             | 1022 +++++++++++++----
 net/wireless/ocb.c                                 |    5 +-
 net/wireless/rdev-ops.h                            |   58 +-
 net/wireless/reg.c                                 |  139 ++-
 net/wireless/scan.c                                |    8 +-
 net/wireless/sme.c                                 |  512 ++++++---
 net/wireless/trace.h                               |  378 ++++---
 net/wireless/util.c                                |   44 +-
 net/wireless/wext-compat.c                         |   48 +-
 net/wireless/wext-sme.c                            |   29 +-
 216 files changed, 7240 insertions(+), 4284 deletions(-)

