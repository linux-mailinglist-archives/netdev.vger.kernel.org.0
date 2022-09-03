Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 278E15ABF88
	for <lists+netdev@lfdr.de>; Sat,  3 Sep 2022 17:29:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231280AbiICP3J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Sep 2022 11:29:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbiICP3I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Sep 2022 11:29:08 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82E6F58DE8;
        Sat,  3 Sep 2022 08:29:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Content-Type:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
        Resent-Message-ID:In-Reply-To:References;
        bh=qeVZyP/ilYKeHyuA6rnpvOZV3acUlas6b6CbUfjpms8=; t=1662218947; x=1663428547; 
        b=HVG/0poQYVwmvIRfkU/+jpo98Zk5vYYdy9uWjzxYBXWhtU1W9hNg1pBHBNl9iBrF186rFQPwvJp
        paqS4ji/DZD9lUD5VpVaZD76+kipRrodk2y+ndxrPBmEZvLCKhTEOHlTUNxesrHNxWSm1vqDUIWGa
        91rkMUktM+EVeoxp3ft9fGO15k0FsP6Y1rx2aDO37akdmxd6Y976xjfD4yv3vO5j90AuZ94v3k1ES
        aYVAKy6mB2ZN3yfC71trO467Vkni1gdcqlHLaedVE01TNDUDpW6GK7tVyKYXjOcjM79lthpSn4tnQ
        CUNyaOWhwL08UqKs3GxxskVyc4bycpcuzkuw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1oUV4z-0070Zo-2p;
        Sat, 03 Sep 2022 17:29:06 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org
Subject: pull-request: wireless-next-2022-09-03
Date:   Sat,  3 Sep 2022 17:29:02 +0200
Message-Id: <20220903152903.134214-1-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.37.2
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

Here's the promised pull request from wireless-next. Most of
the updates are rtw89 and MLO work really, for more MLO work
I'm waiting to get net merged into net-next (and then back to
us) so we don't cause strange conflicts.

Please pull and let me know if there's any problem.

Thanks,
johannes



The following changes since commit 643952f3ecace9e20b8a0c5cd1bbd7409ac2d02c:

  Merge tag 'wireless-next-2022-08-26-v2' of git://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless-next (2022-08-26 11:56:55 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless-next.git tags/wireless-next-2022-09-03

for you to fetch changes up to c087f9fcd0fb53422a9a6c865dbf7dc89b6aecdb:

  wifi: mac80211_hwsim: fix multi-channel handling in netlink RX (2022-09-03 17:05:44 +0200)

----------------------------------------------------------------
drivers
 - rtw89: large update across the map, e.g. coex, pci(e), etc.
 - ath9k: uninit memory read fix
 - ath10k: small peer map fix and a WCN3990 device fix
 - wfx: underflow

stack
 - the "change MAC address while IFF_UP" change from James
   we discussed
 - more MLO work, including a set of fixes for the previous
   code, now that we have more code we can exercise it more
 - prevent some features with MLO that aren't ready yet
   (AP_VLAN and 4-address connections)

----------------------------------------------------------------
Cheng-Chieh Hsieh (1):
      wifi: rtw89: enlarge the CFO tracking boundary

Chia-Yuan Li (4):
      rtw89: 8852c: modify PCIE prebkf time
      rtw89: 8852c: adjust mactxen delay of mac/phy interface
      wifi: rtw89: 8852c: set TBTT shift configuration
      wifi: rtw89: pci: fix PCI PHY auto adaption by using software restore

Chin-Yen Lee (3):
      wifi: rtw89: add retry to change power_mode state
      wifi: rtw89: pci: enable CLK_REQ, ASPM, L1 and L1ss for 8852c
      wifi: rtw89: pci: correct suspend/resume setting for variant chips

Ching-Te Ku (9):
      rtw89: coex: update radio state for RTL8852A/RTL8852C
      rtw89: coex: Move Wi-Fi firmware coexistence matching version to chip
      rtw89: coex: Add logic to parsing rtl8852c firmware type ctrl report
      rtw89: coex: Define BT B1 slot length
      rtw89: coex: Add v1 version TDMA format and parameters
      rtw89: coex: update WL role info v1 for RTL8852C branch using
      rtw89: coex: Move _set_policy to chip_ops
      rtw89: coex: Add v1 Wi-Fi SCC coexistence policy
      rtw89: coex: Update Wi-Fi driver/firmware TDMA cycle report for RTL8852c

Dan Carpenter (2):
      wifi: rtl8xxxu: tighten bounds checking in rtl8xxxu_read_efuse()
      wifi: wfx: prevent underflow in wfx_send_pds()

James Prestwood (2):
      wifi: nl80211: Add POWERED_ADDR_CHANGE feature
      wifi: mac80211: Support POWERED_ADDR_CHANGE feature

Jinpeng Cui (2):
      wifi: wilc1000: remove redundant ret variable
      wifi: nl80211: remove redundant err variable

Johannes Berg (14):
      wifi: mac80211: prevent VLANs on MLDs
      wifi: mac80211: prevent 4-addr use on MLDs
      wifi: mac80211_hwsim: remove multicast workaround
      wifi: mac80211: remove unused arg to ieee80211_chandef_eht_oper
      wifi: mac80211_hwsim: check STA magic in change_sta_links
      wifi: mac80211_hwsim: refactor RX a bit
      wifi: mac80211: move link code to a new file
      wifi: mac80211: mlme: assign link address correctly
      wifi: mac80211: fix double SW scan stop
      wifi: mac80211_hwsim: warn on invalid link address
      wifi: mac80211: mlme: refactor QoS settings code
      wifi: nl80211: add MLD address to assoc BSS entries
      wifi: mac80211: call drv_sta_state() under sdata_lock() in reconfig
      wifi: mac80211_hwsim: fix multi-channel handling in netlink RX

Kalle Valo (1):
      Merge ath-next from git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git

Ping-Ke Shih (10):
      rtw89: declare support HE HTC always
      wifi: rtw89: 8852c: update RF radio A/B parameters to R49
      wifi: rtw89: 8852c: declare correct BA CAM number
      wifi: rtw89: 8852c: initialize and correct BA CAM content
      wifi: rtw89: correct BA CAM allocation
      wifi: rtw89: pci: fix interrupt stuck after leaving low power mode
      wifi: rtw89: pci: correct TX resource checking in low power mode
      wifi: rtw89: no HTC field if TX rate might fallback to legacy
      wifi: rtw89: correct polling address of address CAM
      wifi: rtw89: declare to support beamformee above bandwidth 80MHz

Po-Hao Huang (1):
      rtw89: 8852c: disable dma during mac init

Sun Ke (1):
      wifi: mac80211: fix potential deadlock in ieee80211_key_link()

Tetsuo Handa (1):
      wifi: ath9k: avoid uninit memory read in ath9k_htc_rx_msg()

Wen Gong (1):
      wifi: ath10k: add peer map clean up for peer delete in ath10k_sta_state()

Wolfram Sang (1):
      wifi: move from strlcpy with unused retval to strscpy

Yang Yingliang (1):
      wifi: rtw88: add missing destroy_workqueue() on error path in rtw_core_init()

Youghandhar Chintala (1):
      wifi: ath10k: Set tx credit to one for WCN3990 snoc based devices

Zong-Zhe Yang (17):
      wifi: rtw89: rewrite decision on channel by entity state
      wifi: rtw89: introduce rtw89_chan for channel stuffs
      wifi: rtw89: re-arrange channel related stuffs under HAL
      wifi: rtw89: create rtw89_chan centrally to avoid breakage
      wifi: rtw89: txpwr: concentrate channel related control to top
      wifi: rtw89: rfk: concentrate parameter control while set_channel()
      wifi: rtw89: concentrate parameter control for setting channel callback
      wifi: rtw89: concentrate chandef setting to stack callback
      wifi: rtw89: initialize entity and configure default chandef
      wifi: rtw89: introduce entity mode and its recalculated prototype
      wifi: rtw89: add skeleton of mac80211 chanctx ops support
      wifi: rtw89: declare support for mac80211 chanctx ops by chip
      wifi: rtw89: early recognize FW feature to decide if chanctx
      rtw89: 8852a: update HW setting on BB
      rtw89: ser: leave lps with mutex
      wifi: rtw89: TX power limit/limit_ru consider negative
      wifi: rtw89: 8852c: update TX power tables to R49

 drivers/net/wireless/ath/ath10k/core.c             |    16 +
 drivers/net/wireless/ath/ath10k/htc.c              |    11 +-
 drivers/net/wireless/ath/ath10k/hw.h               |     2 +
 drivers/net/wireless/ath/ath10k/mac.c              |    54 +-
 drivers/net/wireless/ath/ath6kl/init.c             |     2 +-
 drivers/net/wireless/ath/ath9k/htc_hst.c           |    43 +-
 drivers/net/wireless/ath/carl9170/fw.c             |     2 +-
 drivers/net/wireless/ath/wil6210/main.c            |     2 +-
 drivers/net/wireless/ath/wil6210/netdev.c          |     2 +-
 drivers/net/wireless/ath/wil6210/wmi.c             |     2 +-
 drivers/net/wireless/atmel/atmel.c                 |     2 +-
 drivers/net/wireless/broadcom/b43/leds.c           |     2 +-
 drivers/net/wireless/broadcom/b43legacy/leds.c     |     2 +-
 .../wireless/broadcom/brcm80211/brcmfmac/common.c  |     8 +-
 .../wireless/broadcom/brcm80211/brcmfmac/core.c    |     8 +-
 .../broadcom/brcm80211/brcmfmac/firmware.c         |     2 +-
 .../broadcom/brcm80211/brcmfmac/fwsignal.c         |     2 +-
 drivers/net/wireless/intel/ipw2x00/ipw2100.c       |     6 +-
 drivers/net/wireless/intel/ipw2x00/ipw2200.c       |     6 +-
 drivers/net/wireless/intel/iwlegacy/3945-mac.c     |     2 +-
 .../net/wireless/intersil/hostap/hostap_ioctl.c    |     2 +-
 drivers/net/wireless/mac80211_hwsim.c              |    63 +-
 drivers/net/wireless/marvell/libertas/ethtool.c    |     4 +-
 drivers/net/wireless/microchip/wilc1000/cfg80211.c |     5 +-
 drivers/net/wireless/microchip/wilc1000/mon.c      |     2 +-
 drivers/net/wireless/quantenna/qtnfmac/cfg80211.c  |     2 +-
 drivers/net/wireless/quantenna/qtnfmac/commands.c  |     2 +-
 .../net/wireless/realtek/rtl818x/rtl8187/leds.c    |     2 +-
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c  |    14 +-
 drivers/net/wireless/realtek/rtw88/main.c          |     8 +-
 drivers/net/wireless/realtek/rtw89/Makefile        |     1 +
 drivers/net/wireless/realtek/rtw89/chan.c          |   235 +
 drivers/net/wireless/realtek/rtw89/chan.h          |    64 +
 drivers/net/wireless/realtek/rtw89/coex.c          |  1098 +-
 drivers/net/wireless/realtek/rtw89/coex.h          |     6 +-
 drivers/net/wireless/realtek/rtw89/core.c          |   332 +-
 drivers/net/wireless/realtek/rtw89/core.h          |   418 +-
 drivers/net/wireless/realtek/rtw89/debug.c         |    31 +-
 drivers/net/wireless/realtek/rtw89/fw.c            |   251 +-
 drivers/net/wireless/realtek/rtw89/fw.h            |   109 +-
 drivers/net/wireless/realtek/rtw89/mac.c           |    79 +-
 drivers/net/wireless/realtek/rtw89/mac.h           |     1 +
 drivers/net/wireless/realtek/rtw89/mac80211.c      |    77 +-
 drivers/net/wireless/realtek/rtw89/pci.c           |   226 +-
 drivers/net/wireless/realtek/rtw89/pci.h           |    41 +-
 drivers/net/wireless/realtek/rtw89/phy.c           |   286 +-
 drivers/net/wireless/realtek/rtw89/phy.h           |    10 +-
 drivers/net/wireless/realtek/rtw89/reg.h           |    18 +-
 drivers/net/wireless/realtek/rtw89/regd.c          |     2 +-
 drivers/net/wireless/realtek/rtw89/rtw8852a.c      |   150 +-
 drivers/net/wireless/realtek/rtw89/rtw8852a_rfk.c  |    77 +-
 drivers/net/wireless/realtek/rtw89/rtw8852c.c      |   285 +-
 drivers/net/wireless/realtek/rtw89/rtw8852c_rfk.c  |    73 +-
 drivers/net/wireless/realtek/rtw89/rtw8852c_rfk.h  |     2 +-
 .../net/wireless/realtek/rtw89/rtw8852c_table.c    | 28868 +++++++++++++++----
 drivers/net/wireless/realtek/rtw89/sar.c           |     8 +-
 drivers/net/wireless/realtek/rtw89/ser.c           |    13 +-
 drivers/net/wireless/silabs/wfx/main.c             |     2 +-
 drivers/net/wireless/wl3501_cs.c                   |     8 +-
 include/uapi/linux/nl80211.h                       |    11 +
 net/mac80211/Makefile                              |     1 +
 net/mac80211/cfg.c                                 |     7 +
 net/mac80211/ieee80211_i.h                         |    18 +-
 net/mac80211/iface.c                               |   327 +-
 net/mac80211/key.c                                 |     6 +-
 net/mac80211/link.c                                |   262 +
 net/mac80211/main.c                                |     2 +
 net/mac80211/mlme.c                                |    50 +-
 net/mac80211/scan.c                                |     2 +-
 net/mac80211/util.c                                |    33 +-
 net/wireless/nl80211.c                             |    11 +-
 71 files changed, 26681 insertions(+), 7100 deletions(-)
 create mode 100644 drivers/net/wireless/realtek/rtw89/chan.c
 create mode 100644 drivers/net/wireless/realtek/rtw89/chan.h
 create mode 100644 net/mac80211/link.c

