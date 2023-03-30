Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEEFA6D1064
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 22:56:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230018AbjC3U41 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 16:56:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229992AbjC3U4V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 16:56:21 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8EDACC31;
        Thu, 30 Mar 2023 13:56:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Content-Type:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
        Resent-Message-ID:In-Reply-To:References;
        bh=GZ/3NuIe7Wj49ujkU+W7luutiN2SGmj51Gp8G8WtFtA=; t=1680209778; x=1681419378; 
        b=PLUFbZDt9qCl/TtD2SNOYs2O4D+u7esU8GR5pUoLSKHh/t9bpCIswHlOwTPTBb1cfInpx/1lntG
        IkpvUlx5aFz6PawKZndMqjanVNfhZtoS3rmqIycfN9zw6fqSLqNxAUW+8fZK/sO+yJnj8OeVn1ihy
        hGt9jJUviTm7ZGsAHxAa0EFy8Q5jHu+K289Cv1Zu8s6WOh+1OWL3BOjuA99OdJ5kqp3z9zXCRve9O
        hSrFH/hbMo+lURF8jvv2ue6wtlq6w5+LACJsGfAn9Rwr8JQbM4h/MqdLyzez7L+KV1oLL8T07BmAm
        xXWtmv1HByE1w6E/uzc7/Rwh06uOAmeeEdeA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1phzJg-001S0M-19;
        Thu, 30 Mar 2023 22:56:16 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org
Subject: pull-request: wireless-next-2023-03-30
Date:   Thu, 30 Mar 2023 22:56:11 +0200
Message-Id: <20230330205612.921134-1-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Here's new content for -next, this time with a bunch
of the promised iwlwifi work, but also lots of changes
in other drivers and some new stack features.

I also mention it in the tag, but Kalle moved all the
plain C files out of drivers/net/wireless/ into dirs,
just FYI.

Please pull or let me know if there's any problem.

Thanks,
johannes



The following changes since commit 95b744508d4d5135ae2a096ff3f0ee882bcc52b3:

  qede: remove linux/version.h and linux/compiler.h (2023-03-10 21:29:54 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless-next.git tags/wireless-next-2023-03-30

for you to fetch changes up to aa2aa818cd1198cfa2498116d57cd9f13fea80e4:

  wifi: clean up erroneously introduced file (2023-03-30 22:50:12 +0200)

----------------------------------------------------------------
Major stack changes:
 * TC offload support for drivers below mac80211
 * reduced neighbor report (RNR) handling for AP mode
 * mac80211 mesh fast-xmit and fast-rx support
 * support for another mesh A-MSDU format
   (seems nobody got the spec right)

Major driver changes:

Kalle moved the drivers that were just plain C files
in drivers/net/wireless/ to legacy/ and virtual/ dirs.

hwsim
 * multi-BSSID support
 * some FTM support

ath11k
 * MU-MIMO parameters support
 * ack signal support for management packets

rtl8xxxu
 * support for RTL8710BU aka RTL8188GU chips

rtw89
 * support for various newer firmware APIs

ath10k
 * enabled threaded NAPI on WCN3990

iwlwifi
 * lots of work for multi-link/EHT (wifi7)
 * hardware timestamping support for some devices/firwmares
 * TX beacon protection on newer hardware

----------------------------------------------------------------
Abhishek Kumar (1):
      wifi: ath10k: snoc: enable threaded napi on WCN3990

Abhishek Naik (1):
      wifi: iwlwifi: mvm: Add debugfs to get TAS status

Abinaya Kalaiselvan (1):
      wifi: ath11k: Add tx ack signal support for management packets

Aditya Kumar Singh (3):
      wifi: ath11k: use proper regulatory reference for bands
      wifi: ath11k: add support to parse new WMI event for 6 GHz
      wifi: ath11k: add debug prints in regulatory WMI event processing

Alexey V. Vissarionov (1):
      wifi: ath6kl: minor fix for allocation size

Aloka Dixit (6):
      wifi: mac80211: generate EMA beacons in AP mode
      wifi: mac80211_hwsim: move beacon transmission to a separate function
      wifi: mac80211_hwsim: Multiple BSSID support
      wifi: mac80211_hwsim: EMA support
      cfg80211: support RNR for EMA AP
      mac80211: support RNR for EMA AP

Avraham Stern (7):
      wifi: iwlwifi: mvm: read synced time from firmware if supported
      wifi: iwlwifi: mvm: report hardware timestamps in RX/TX status
      wifi: iwlwifi: mvm: implement PHC clock adjustments
      wifi: iwlwifi: mvm: select ptp cross timestamp from multiple reads
      wifi: iwlwifi: mvm: support enabling and disabling HW timestamping
      wifi: iwlwifi: mvm: add set_hw_timestamp to mld ops
      wifi: iwlwifi: mvm: adjust iwl_mvm_scan_respect_p2p_go_iter() for MLO

Bagas Sanjaya (1):
      wifi: mac80211: use bullet list for amsdu_mesh_control formats list

Benjamin Berg (2):
      wifi: iwlwifi: mvm: use appropriate link for rate selection
      wifi: iwlwifi: mvm: initialize max_rc_amsdu_len per-link

Bitterblue Smith (2):
      wifi: rtl8xxxu: RTL8192EU always needs full init
      wifi: rtl8xxxu: Support new chip RTL8710BU aka RTL8188GU

Ching-Te Ku (7):
      wifi: rtw89: coex: Add more error_map and counter to log
      wifi: rtw89: coex: Add WiFi role info v2
      wifi: rtw89: coex: Add traffic TX/RX info and its H2C
      wifi: rtw89: coex: Add register monitor report v2 format
      wifi: rtw89: coex: Fix wrong structure assignment at null data report
      wifi: rtw89: coex: Add v2 Bluetooth scan info
      wifi: rtw89: coex: Add v5 firmware cycle status report

Christian Marangi (1):
      wifi: ath11k: fix SAC bug on peer addition with sta band migration

Christophe JAILLET (1):
      wifi: wcn36xx: Slightly optimize PREPARE_HAL_BUF()

Colin Ian King (1):
      wifi: ath12k: Fix spelling mistakes in warning messages and comments

Dan Carpenter (2):
      wifi: ath12k: use kfree_skb() instead of kfree()
      wifi: ath5k: fix an off by one check in ath5k_eeprom_read_freq_list()

Dongliang Mu (1):
      wifi: rtw88: fix memory leak in rtw_usb_probe()

Douglas Anderson (2):
      wifi: ath11k: Use platform_get_irq() to get the interrupt
      wifi: ath5k: Use platform_get_irq() to get the interrupt

Fedor Pchelkin (2):
      wifi: ath9k: hif_usb: fix memory leak of remain_skbs
      wifi: ath6kl: reduce WARN to dev_dbg() in callback

Felix Fietkau (6):
      wifi: mac80211: add support for letting drivers register tc offload support
      wifi: mac80211: fix race in mesh sequence number assignment
      wifi: mac80211: mesh fast xmit support
      wifi: mac80211: use mesh header cache to speed up mesh forwarding
      wifi: mac80211: add mesh fast-rx support
      wifi: mac80211: implement support for yet another mesh A-MSDU format

Gregory Greenman (22):
      wifi: iwlwifi: mvm: fix NULL deref in iwl_mvm_mld_disable_txq
      wifi: iwlwifi: mvm: vif preparation for MLO
      wifi: iwlwifi: mvm: sta preparation for MLO
      wifi: iwlwifi: mvm: adjust smart fifo configuration to MLO
      wifi: iwlwifi: mvm: adjust mld_mac_ctxt_/beacon_changed() for MLO
      wifi: iwlwifi: mvm: adjust some PS and PM methods to MLD
      wifi: iwlwifi: mvm: adjust SMPS for MLO
      wifi: iwlwifi: mvm: add link_conf parameter for add/remove/change link
      wifi: iwlwifi: mvm: replace bss_info_changed() with vif_cfg/link_info_changed()
      wifi: iwlwifi: mvm: adjust internal stations to MLO
      wifi: iwlwifi: mvm: add fw link id allocation
      wifi: iwlwifi: mvm: adjust to MLO assign/unassign/switch_vif_chanctx()
      wifi: iwlwifi: mvm: update iwl_mvm_tx_reclaim() for MLO
      wifi: iwlwifi: mvm: refactor iwl_mvm_mac_sta_state_common()
      wifi: iwlwifi: mvm: adjust some cleanup functions to MLO
      wifi: iwlwifi: mvm: adjust iwl_mvm_sec_key_remove_ap to MLO
      wifi: iwlwifi: mvm: adjust radar detection to MLO
      wifi: iwlwifi: mvm: adjust rs init to MLO
      wifi: iwlwifi: mvm: update mac config when assigning chanctx
      wifi: iwlwifi: mvm: rework active links counting
      wifi: iwlwifi: mvm: move max_agg_bufsize into host TLC lq_sta
      wifi: iwlwifi: bump FW API to 75 for AX devices

Hans de Goede (1):
      wifi: brcmfmac: Use ISO3166 country code and rev 0 as fallback on 4356

Jacob Keller (2):
      wifi: ipw2x00: convert ipw_fw_error->elem to flexible array[]
      wifi: qtnfmac: use struct_size and size_sub for payload length

Jaewan Kim (5):
      mac80211_hwsim: add PMSR capability support
      wifi: nl80211: make nl80211_send_chandef non-static
      mac80211_hwsim: add PMSR request support via virtio
      mac80211_hwsim: add PMSR abort support via virtio
      mac80211_hwsim: add PMSR report support via virtio

Jiapeng Chong (1):
      wifi: ath10k: Remove redundant assignment to changed_flags

Jisoo Jang (1):
      wifi: brcmfmac: slab-out-of-bounds read in brcmf_get_assoc_ies()

Johannes Berg (28):
      wifi: iwlwifi: mvm: avoid sta lookup in queue alloc
      wifi: iwlwifi: mvm: rs: print BAD_RATE for invalid HT/VHT index
      wifi: iwlwifi: fw: pnvm: fix uefi reduced TX power loading
      wifi: iwlwifi: suppress printf warnings in tracing
      wifi: iwlwifi: mvm: enable TX beacon protection
      wifi: iwlwifi: mvm: add link to firmware earlier
      wifi: iwlwifi: mvm: don't check dtim_period in new API
      wifi: iwlwifi: mvm: implement link change ops
      wifi: iwlwifi: mvm: make some HW flags conditional
      wifi: iwlwifi: mvm: fix narrow RU check for MLO
      wifi: iwlwifi: mvm: skip MEI update for MLO
      wifi: iwlwifi: mvm: use STA link address
      wifi: iwlwifi: mvm: rs-fw: don't crash on missing channel
      wifi: iwlwifi: mvm: coex: start handling multiple links
      wifi: iwlwifi: mvm: make a few warnings only trigger once
      wifi: iwlwifi: mvm: rxmq: report link ID to mac80211
      wifi: iwlwifi: mvm: skip inactive links
      wifi: iwlwifi: mvm: remove only link-specific AP keys
      wifi: iwlwifi: mvm: avoid sending MAC context for idle
      wifi: iwlwifi: mvm: remove chanctx WARN_ON
      wifi: iwlwifi: mvm: use the new lockdep-checking macros
      wifi: iwlwifi: mvm: fix station link data leak
      wifi: iwlwifi: mvm: clean up mac_id vs. link_id in MLD sta
      wifi: iwlwifi: mvm: send full STA during HW restart
      wifi: iwlwifi: mvm: free probe_resp_data later
      wifi: iwlwifi: separate AP link management queues
      wifi: iwlwifi: mvm: correctly use link in iwl_mvm_sta_del()
      wifi: clean up erroneously introduced file

Julia Lawall (1):
      wifi: iwlwifi: fix typos in comment

Kalle Valo (4):
      wifi: ath12k: remove memset with byte count of 278528
      wifi: move mac80211_hwsim and virt_wifi to virtual directory
      wifi: move raycs, wl3501 and rndis_wlan to legacy directory
      Merge ath-next from git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git

Kees Cook (1):
      wifi: ath: Silence memcpy run-time false positive warning

Kieran Frewen (2):
      wifi: mac80211: S1G capabilities information element in probe request
      wifi: nl80211: support advertising S1G capabilities

Krishnanand Prabhu (2):
      wifi: iwlwifi: mvm: add support for PTP HW clock (PHC)
      wifi: iwlwifi: mvm: add support for timing measurement

Lukas Bulwahn (1):
      MAINTAINERS: adjust file entries after wifi driver movement

Manikanta Pubbisetty (1):
      wifi: nl80211: Update the documentation of NL80211_SCAN_FLAG_COLOCATED_6GHZ

Martin Kaiser (2):
      wifi: rtl8xxxu: mark Edimax EW-7811Un V2 as tested
      wifi: rtl8xxxu: use module_usb_driver

Miri Korenblit (32):
      wifi: iwlwifi: mvm: Refactor STA_HE_CTXT_CMD sending flow
      wifi: iwlwifi: mvm: Refactor MAC_CONTEXT_CMD sending flow
      wifi: iwlwifi: mvm: add support for the new MAC CTXT command
      wifi: iwlwifi: mvm: add support for the new LINK command
      wifi: iwlwifi: mvm: add support for the new STA related commands
      wifi: iwlwifi: mvm: Add an add_interface() callback for mld mode
      wifi: iwlwifi: mvm: Add a remove_interface() callback for mld mode
      wifi: iwlwifi: mvm: refactor __iwl_mvm_assign_vif_chanctx()
      wifi: iwlwifi: mvm: add an assign_vif_chanctx() callback for MLD mode
      wifi: iwlwifi: mvm: refactor __iwl_mvm_unassign_vif_chanctx()
      wifi: iwlwifi: mvm: add an unassign_vif_chanctx() callback for MLD mode
      wifi: iwlwifi: mvm: add start_ap() and join_ibss() callbacks for MLD mode
      wifi: iwlwifi: mvm: add stop_ap() and leave_ibss() callbacks for MLD mode
      wifi: iwlwifi: mvm: Don't send MAC CTXT cmd after deauthorization
      wifi: iwlwifi: mvm: refactor iwl_mvm_cfg_he_sta()
      wifi: iwlwifi: mvm: refactor iwl_mvm_sta
      wifi: iwlwifi: mvm: refactor iwl_mvm_sta_send_to_fw()
      wifi: iwlwifi: mvm: remove not needed initializations
      wifi: iwlwifi: mvm: refactor iwl_mvm_add_sta(), iwl_mvm_rm_sta()
      wifi: iwlwifi: mvm: add an indication that the new MLD API is used
      wifi: iwlwifi: mvm: add sta handling flows for MLD mode
      wifi: iwlwifi: mvm: add some new MLD ops
      wifi: iwlwifi: mvm: refactor iwl_mvm_roc()
      wifi: iwlwifi: mvm: add cancel/remain_on_channel for MLD mode
      wifi: iwlwifi: mvm: unite sta_modify_disable_tx flows
      wifi: iwlwifi: mvm: add support for post_channel_switch in MLD mode
      wifi: iwlwifi: mvm: add all missing ops to iwl_mvm_mld_ops
      wifi: iwlwifi: mvm: fix "modify_mask" value in the link cmd.
      wifi: iwlwifi: mvm: fix crash on queue removal for MLD API too
      wifi: iwlwifi: mvm: modify link instead of removing it during csa
      wifi: iwlwifi: mvm: always use the sta->addr as the peers addr
      wifi: iwlwifi: mvm: align to the LINK cmd update in the FW

Mukesh Sisodiya (4):
      wifi: iwlwifi: yoyo: Add new tlv for dump file name extension
      wifi: iwlwifi: yoyo: Add driver defined dump file name
      wifi: iwlwifi: Update configurations for Bnj and Bz devices
      wifi: iwlwifi: Update configurations for Bnj device

Muna Sinada (4):
      wifi: ath11k: modify accessor macros to match index size
      wifi: ath11k: push MU-MIMO params from hostapd to hardware
      wifi: ath11k: move HE MCS mapper to a separate function
      wifi: ath11k: generate rx and tx mcs maps for supported HE mcs

Nathan Chancellor (2):
      wifi: iwlwifi: Avoid disabling GCC specific flag with clang
      wifi: iwlwifi: mvm: Use 64-bit division helper in iwl_mvm_get_crosstimestamp_fw()

Ping-Ke Shih (1):
      wifi: rtw89: release RX standby timer of beamformee CSI to save power

Ramya Gnanasekar (2):
      wifi: ath12k: Handle lock during peer_id find
      wifi: ath12k: PCI ops for wakeup/release MHI

Shaul Triebitz (5):
      wifi: iwlwifi: mvm: use the link sta address
      wifi: iwlwifi: mvm: implement mac80211 callback change_sta_links
      wifi: iwlwifi: mvm: translate management frame address
      wifi: iwlwifi: mvm: use bcast/mcast link station id
      wifi: iwlwifi: mvm: use the correct link queue

Solomon Tan (3):
      wifi: iwlwifi: Remove prohibited spaces
      wifi: iwlwifi: Add required space before open '('
      wifi: iwlwifi: Replace space with tabs as code indent

Tamizh Chelvam Raja (1):
      wifi: ath11k: Set ext passive scan flag to adjust passive scan start time

Tom Rix (2):
      wifi: iwlwifi: mvm: remove setting of 'sta' parameter
      mac80211: minstrel_ht: remove unused n_supported variable

Yang Li (3):
      wifi: ath12k: dp_mon: Fix unsigned comparison with less than zero
      wifi: ath12k: dp_mon: clean up some inconsistent indentings
      wifi: ath10k: Remove the unused function shadow_dst_wr_ind_addr() and ath10k_ce_error_intr_enable()

Yang Yingliang (1):
      wifi: ath11k: fix return value check in ath11k_ahb_probe()

 MAINTAINERS                                        |    8 +-
 drivers/net/wireless/Kconfig                       |   75 +-
 drivers/net/wireless/Makefile                      |   11 +-
 drivers/net/wireless/ath/ath.h                     |   12 +-
 drivers/net/wireless/ath/ath10k/ce.c               |   52 -
 drivers/net/wireless/ath/ath10k/mac.c              |    1 -
 drivers/net/wireless/ath/ath10k/snoc.c             |    1 +
 drivers/net/wireless/ath/ath11k/ahb.c              |   10 +-
 drivers/net/wireless/ath/ath11k/hw.c               |    1 +
 drivers/net/wireless/ath/ath11k/mac.c              |  255 ++-
 drivers/net/wireless/ath/ath11k/peer.c             |    5 +-
 drivers/net/wireless/ath/ath11k/reg.c              |   59 +-
 drivers/net/wireless/ath/ath11k/wmi.c              |  602 +++++-
 drivers/net/wireless/ath/ath11k/wmi.h              |  366 +++-
 drivers/net/wireless/ath/ath12k/ce.c               |    2 +-
 drivers/net/wireless/ath/ath12k/core.h             |    2 +-
 drivers/net/wireless/ath/ath12k/dp.c               |    7 +-
 drivers/net/wireless/ath/ath12k/dp.h               |    6 +-
 drivers/net/wireless/ath/ath12k/dp_mon.c           |   19 +-
 drivers/net/wireless/ath/ath12k/dp_rx.c            |   11 +-
 drivers/net/wireless/ath/ath12k/dp_tx.c            |    2 +-
 drivers/net/wireless/ath/ath12k/hal.c              |    2 +-
 drivers/net/wireless/ath/ath12k/hal.h              |   12 +-
 drivers/net/wireless/ath/ath12k/hal_desc.h         |   10 +-
 drivers/net/wireless/ath/ath12k/pci.c              |   47 +-
 drivers/net/wireless/ath/ath12k/pci.h              |    6 +
 drivers/net/wireless/ath/ath12k/rx_desc.h          |    2 +-
 drivers/net/wireless/ath/ath12k/wmi.c              |    6 +-
 drivers/net/wireless/ath/ath12k/wmi.h              |    4 +-
 drivers/net/wireless/ath/ath5k/ahb.c               |   10 +-
 drivers/net/wireless/ath/ath5k/eeprom.c            |    2 +-
 drivers/net/wireless/ath/ath6kl/bmi.c              |    2 +-
 drivers/net/wireless/ath/ath6kl/htc_pipe.c         |    4 +-
 drivers/net/wireless/ath/ath9k/hif_usb.c           |   19 +
 drivers/net/wireless/ath/key.c                     |    2 +-
 drivers/net/wireless/ath/wcn36xx/smd.c             |    4 +-
 .../broadcom/brcm80211/brcmfmac/cfg80211.c         |    6 +
 drivers/net/wireless/intel/ipw2x00/ipw2200.c       |    7 +-
 drivers/net/wireless/intel/ipw2x00/ipw2200.h       |    3 +-
 drivers/net/wireless/intel/iwlwifi/cfg/22000.c     |   64 +-
 .../net/wireless/intel/iwlwifi/fw/api/commands.h   |   18 +
 .../net/wireless/intel/iwlwifi/fw/api/datapath.h   |  184 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/debug.h  |   96 +
 .../net/wireless/intel/iwlwifi/fw/api/mac-cfg.h    |  426 +++-
 drivers/net/wireless/intel/iwlwifi/fw/api/tx.h     |   10 +-
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c        |   32 +-
 drivers/net/wireless/intel/iwlwifi/fw/dump.c       |   58 +-
 drivers/net/wireless/intel/iwlwifi/fw/error-dump.h |   17 +-
 drivers/net/wireless/intel/iwlwifi/fw/file.h       |    3 +
 drivers/net/wireless/intel/iwlwifi/fw/img.h        |    4 +-
 drivers/net/wireless/intel/iwlwifi/fw/pnvm.c       |   20 +-
 drivers/net/wireless/intel/iwlwifi/fw/runtime.h    |    4 +
 drivers/net/wireless/intel/iwlwifi/iwl-config.h    |    5 +
 drivers/net/wireless/intel/iwlwifi/iwl-devtrace.c  |    3 +
 drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c |    2 +-
 drivers/net/wireless/intel/iwlwifi/iwl-trans.h     |    4 +
 drivers/net/wireless/intel/iwlwifi/mvm/Makefile    |    4 +-
 drivers/net/wireless/intel/iwlwifi/mvm/binding.c   |   13 +-
 drivers/net/wireless/intel/iwlwifi/mvm/coex.c      |  104 +-
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c        |   39 +-
 .../net/wireless/intel/iwlwifi/mvm/debugfs-vif.c   |   14 +-
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c   |  226 ++-
 .../net/wireless/intel/iwlwifi/mvm/ftm-initiator.c |    6 +-
 .../net/wireless/intel/iwlwifi/mvm/ftm-responder.c |    2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c        |   37 +-
 drivers/net/wireless/intel/iwlwifi/mvm/link.c      |  294 +++
 drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c  |  439 +++--
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  | 2042 +++++++++++++-------
 drivers/net/wireless/intel/iwlwifi/mvm/mld-key.c   |   27 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mld-mac.c   |  306 +++
 .../net/wireless/intel/iwlwifi/mvm/mld-mac80211.c  | 1074 ++++++++++
 drivers/net/wireless/intel/iwlwifi/mvm/mld-sta.c   | 1058 ++++++++++
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h       |  518 ++++-
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c       |   48 +-
 drivers/net/wireless/intel/iwlwifi/mvm/phy-ctxt.c  |    4 +-
 drivers/net/wireless/intel/iwlwifi/mvm/power.c     |   45 +-
 drivers/net/wireless/intel/iwlwifi/mvm/ptp.c       |  326 ++++
 drivers/net/wireless/intel/iwlwifi/mvm/quota.c     |   11 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rs-fw.c     |  174 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rs.c        |   66 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rs.h        |   16 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rx.c        |   30 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c      |   36 +-
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c      |   33 +-
 drivers/net/wireless/intel/iwlwifi/mvm/sf.c        |   38 +-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c       |  688 ++++---
 drivers/net/wireless/intel/iwlwifi/mvm/sta.h       |  132 +-
 drivers/net/wireless/intel/iwlwifi/mvm/tdls.c      |    8 +-
 .../net/wireless/intel/iwlwifi/mvm/time-event.c    |   12 +-
 drivers/net/wireless/intel/iwlwifi/mvm/time-sync.c |  173 ++
 drivers/net/wireless/intel/iwlwifi/mvm/time-sync.h |   30 +
 drivers/net/wireless/intel/iwlwifi/mvm/tt.c        |    4 +-
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c        |   80 +-
 drivers/net/wireless/intel/iwlwifi/mvm/utils.c     |   91 +-
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c      |   29 +-
 drivers/net/wireless/legacy/Kconfig                |   55 +
 drivers/net/wireless/legacy/Makefile               |    6 +
 drivers/net/wireless/{ => legacy}/ray_cs.c         |    0
 drivers/net/wireless/{ => legacy}/ray_cs.h         |    0
 drivers/net/wireless/{ => legacy}/rayctl.h         |    0
 drivers/net/wireless/{ => legacy}/rndis_wlan.c     |    0
 drivers/net/wireless/{ => legacy}/wl3501.h         |    0
 drivers/net/wireless/{ => legacy}/wl3501_cs.c      |    0
 drivers/net/wireless/quantenna/qtnfmac/commands.c  |    7 +-
 drivers/net/wireless/realtek/rtl8xxxu/Kconfig      |    2 +-
 drivers/net/wireless/realtek/rtl8xxxu/Makefile     |    2 +-
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h   |  313 ++-
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_8188e.c |    5 +-
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_8188f.c |    7 +-
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192c.c |    2 +
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c |    6 +-
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_8710b.c | 1878 ++++++++++++++++++
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723a.c |    5 +-
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723b.c |    5 +-
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c  |  297 ++-
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h  |   44 +
 drivers/net/wireless/realtek/rtw88/usb.c           |    2 +-
 drivers/net/wireless/realtek/rtw89/coex.c          |  859 +++++++-
 drivers/net/wireless/realtek/rtw89/coex.h          |    5 +
 drivers/net/wireless/realtek/rtw89/core.h          |  239 ++-
 drivers/net/wireless/realtek/rtw89/fw.c            |  142 ++
 drivers/net/wireless/realtek/rtw89/fw.h            |  138 ++
 drivers/net/wireless/realtek/rtw89/mac.c           |   35 +-
 drivers/net/wireless/realtek/rtw89/reg.h           |    2 +
 drivers/net/wireless/virtual/Kconfig               |   20 +
 drivers/net/wireless/virtual/Makefile              |    3 +
 .../net/wireless/{ => virtual}/mac80211_hwsim.c    |  869 ++++++++-
 .../net/wireless/{ => virtual}/mac80211_hwsim.h    |   58 +
 drivers/net/wireless/{ => virtual}/virt_wifi.c     |    0
 include/net/cfg80211.h                             |   39 +-
 include/net/mac80211.h                             |   77 +
 include/uapi/linux/nl80211.h                       |   24 +-
 net/mac80211/cfg.c                                 |   70 +-
 net/mac80211/driver-ops.h                          |   17 +
 net/mac80211/ieee80211_i.h                         |   53 +-
 net/mac80211/iface.c                               |   11 +
 net/mac80211/mesh.c                                |   98 +-
 net/mac80211/mesh.h                                |   44 +
 net/mac80211/mesh_hwmp.c                           |   37 +-
 net/mac80211/mesh_pathtbl.c                        |  282 +++
 net/mac80211/rc80211_minstrel_ht.c                 |    6 -
 net/mac80211/rx.c                                  |  131 +-
 net/mac80211/sta_info.h                            |    9 +-
 net/mac80211/trace.h                               |   25 +
 net/mac80211/tx.c                                  |  197 +-
 net/mac80211/util.c                                |   23 +
 net/wireless/nl80211.c                             |   93 +-
 net/wireless/util.c                                |   36 +-
 148 files changed, 14823 insertions(+), 2337 deletions(-)
 create mode 100644 drivers/net/wireless/intel/iwlwifi/mvm/link.c
 create mode 100644 drivers/net/wireless/intel/iwlwifi/mvm/mld-mac.c
 create mode 100644 drivers/net/wireless/intel/iwlwifi/mvm/mld-mac80211.c
 create mode 100644 drivers/net/wireless/intel/iwlwifi/mvm/mld-sta.c
 create mode 100644 drivers/net/wireless/intel/iwlwifi/mvm/ptp.c
 create mode 100644 drivers/net/wireless/intel/iwlwifi/mvm/time-sync.c
 create mode 100644 drivers/net/wireless/intel/iwlwifi/mvm/time-sync.h
 create mode 100644 drivers/net/wireless/legacy/Kconfig
 create mode 100644 drivers/net/wireless/legacy/Makefile
 rename drivers/net/wireless/{ => legacy}/ray_cs.c (100%)
 rename drivers/net/wireless/{ => legacy}/ray_cs.h (100%)
 rename drivers/net/wireless/{ => legacy}/rayctl.h (100%)
 rename drivers/net/wireless/{ => legacy}/rndis_wlan.c (100%)
 rename drivers/net/wireless/{ => legacy}/wl3501.h (100%)
 rename drivers/net/wireless/{ => legacy}/wl3501_cs.c (100%)
 create mode 100644 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8710b.c
 create mode 100644 drivers/net/wireless/virtual/Kconfig
 create mode 100644 drivers/net/wireless/virtual/Makefile
 rename drivers/net/wireless/{ => virtual}/mac80211_hwsim.c (87%)
 rename drivers/net/wireless/{ => virtual}/mac80211_hwsim.h (80%)
 rename drivers/net/wireless/{ => virtual}/virt_wifi.c (100%)

