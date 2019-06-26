Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A90C56E35
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 18:00:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726544AbfFZP77 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 11:59:59 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:39232 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726382AbfFZP75 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 11:59:57 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id A01A260ACA; Wed, 26 Jun 2019 15:59:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1561564795;
        bh=Wvz5/xQszjp8ZANrPMlV2VAzkfDMW9+/kiut4REesC4=;
        h=From:To:Cc:Subject:Date:From;
        b=YveOCXvrqlVAgF7d+dSRlHpqFATm8i34yG+MPMIQvAOpFdxesixQxetboyJin0P6V
         5x+qfwWWFlZ4rPt4xSC0pfbmaZJAPz4AfiWIqDqdT3P99p7+TdvFxW30GAylVLnsRA
         zgn32u7QAkwGKF0flsUnPB0JhEfphkXDa4uTnGTw=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        pdx-caf-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_INVALID,DKIM_SIGNED,SPF_NONE autolearn=no autolearn_force=no
        version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id CED7D609F3;
        Wed, 26 Jun 2019 15:59:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1561564794;
        bh=Wvz5/xQszjp8ZANrPMlV2VAzkfDMW9+/kiut4REesC4=;
        h=From:To:Cc:Subject:Date:From;
        b=S3fC7jrbdHm4v4Z5C2NeSwp0AyQNIAc2ms2pXnP0/xXQDriHSuje4rGg5d6cM9lQo
         Re97eE6XEIGxd4uhtp6pdf9SW2LGG+++dy+JTOD32SmR1CmZ8eY6MuSsSXFcXssMN+
         JuRinVUYv+lqGL1M3zMmeO1ljnC23EoTzh1qRJfw=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org CED7D609F3
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     David Miller <davem@davemloft.net>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: pull-request: wireless-drivers-next 2019-06-26
Date:   Wed, 26 Jun 2019 18:59:49 +0300
Message-ID: <87ef3gjq16.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave,

here's a pull request to net-next for 5.3, more info below. Please let
me know if there are any problems.

Kalle

The following changes since commit f4aa80129ff71909380ee0bde8be36c5cc031d4c:

  cxgb4: Make t4_get_tp_e2c_map static (2019-05-26 22:16:26 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-next=
.git tags/wireless-drivers-next-for-davem-2019-06-26

for you to fetch changes up to e5db0ad7563c38b7b329504836c9a64ae025a47a:

  airo: switch to skcipher interface (2019-06-25 08:12:20 +0300)

----------------------------------------------------------------
wireless-drivers-next patches for 5.3

First set of patches for 5.3, but not that many patches this time.

This pull request fails to compile with the tip tree due to
ktime_get_boot_ns() API changes there. It should be easy for Linus to
fix it in p54 driver once he pulls this, an example resolution here:

https://lkml.kernel.org/r/20190625160432.533aa140@canb.auug.org.au

Major changes:

airo

* switch to use skcipher interface

p54

* support boottime in scan results

rtw88

* add fast xmit support

* add random mac address on scan support

rt2x00

* add software watchdog to detect hangs, it's disabled by default

----------------------------------------------------------------
Ahmad Masri (1):
      wil6210: fix overwriting max_assoc_sta module param

Alagu Sankar (3):
      ath10k: htt: don't use txdone_fifo with SDIO
      ath10k: htt: support MSDU ids with SDIO
      ath10k: add initialization of HTC header

Alan Stern (1):
      p54usb: Fix race between disconnect and firmware loading

Alexei Avshalom Lazar (1):
      wil6210: fix _desc access in __wil_tx_vring_tso

Anilkumar Kolli (1):
      ath: DFS JP domain W56 fixed pulse type 3 RADAR detection

Ard Biesheuvel (1):
      airo: switch to skcipher interface

Arend van Spriel (6):
      brcm80211: switch common header files to using SPDX license identifier
      brcmutil: switch source files to using SPDX license identifier
      brcmsmac: switch phy source files to using SPDX license identifier
      brcmfmac: switch source files to using SPDX license identifier
      brcmfmac: use separate Kconfig file for brcmfmac
      brcm80211: select WANT_DEV_COREDUMP conditionally for brcmfmac

Arnd Bergmann (1):
      wireless: carl9170: fix clang build warning

Balaji Pothunoori (1):
      ath10k: rx_duration update for fw_stats debugfs entry

Brandon Huang (1):
      ath10k: Fix the tx stats bytes & packets parsing

Brian Norris (2):
      mwifiex: drop 'set_consistent_dma_mask' log message
      mwifiex: print PCI mmap with %pK

Chien-Hsun Liao (2):
      rtw88: 8822c: add rf write protection when switching channel
      rtw88: 8822c: update channel and bandwidth BB setting

Chin-Yen Lee (1):
      rtw88: add beacon function setting

Christian Lamparter (3):
      p54: fix crash during initialization
      p54: Support boottime in scan results
      p54: remove dead branch in op_conf_tx callback

Colin Ian King (5):
      ath6kl: remove redundant check of status !=3D 0
      libertas: fix spelling mistake "Donwloading" -> "Downloading"
      rtlwifi: remove redundant assignment to variable badworden
      rtlwifi: remove redundant assignment to variable k
      rtlwifi: rtl8188ee: remove redundant assignment to rtstatus

Dan Carpenter (1):
      ath6kl: add some bounds checking

Dedy Lansky (3):
      wil6210: add printout of platform capabilities
      wil6210: enhancements for descriptor and status ring debugfs
      wil6210: check rx_buff_mgmt before accessing it

Erik Stromdahl (1):
      ath10k: sdio: add missing error check

Govind Singh (2):
      ath10k: Move board id and fw version logging to info level
      ath10k: Modify CE4 src buffer entries to 2048 for WCN3990

Greg Kroah-Hartman (2):
      iwlegacy: 3945: no need to check return value of debugfs_create funct=
ions
      iwlegacy: 4965: no need to check return value of debugfs_create funct=
ions

Gustavo A. R. Silva (6):
      ath6kl: debug: Use struct_size() helper
      ath6kl: wmi: use struct_size() helper
      wil6210: fix potential out-of-bounds read
      ath10k: Use struct_size() helper
      ath10k: coredump: use struct_size() helper
      qtnfmac: Use struct_size() in kzalloc()

Jia-Ju Bai (1):
      b43: Avoid possible double calls to b43_one_core_detach()

Kalle Valo (3):
      ath10k: initialise struct ath10k_bus params to zero
      ath10k: fix use-after-free on SDIO data frames
      Merge ath-next from git://git.kernel.org/.../kvalo/ath.git

Larry Finger (4):
      rtlwifi: rtl8821ae: Remove unused GET_XXX and SET_XXX descriptor macr=
os
      rtlwifi: rtl8821ae: Replace local bit manipulation macros
      rtlwifi: rtl8821ae: Convert macros that set descriptor
      rtlwifi: rtl8821ae: Convert inline routines to little-endian words

Lorenzo Bianconi (2):
      mt7601u: do not schedule rx_tasklet when the device has been disconne=
cted
      mt7601u: fix possible memory leak when the device is disconnected

Maharaja Kennadyrajan (2):
      ath10k: Extended the HTT stats support to retrieve Mu-MIMO related st=
ats
      ath10k: Added support to reset HTT stats in debugfs

Maya Erez (4):
      wil6210: fix spurious interrupts in 3-msi
      wil6210: add support for multiple sections in brd file
      wil6210: fix missed MISC mbox interrupt
      wil6210: remove HALP for Talyn devices

Michael Buesch (1):
      ssb/gpio: Remove unnecessary WARN_ON from driver_gpio

Neo Jou (1):
      brcmfmac: use strlcpy() instead of strcpy()

Ping-Ke Shih (5):
      rtlwifi: 8192de: Reduce indentation and fix coding style
      rtlwifi: 8192de: make tables to be 'static const'
      rtlwifi: 8192de: Fix used uninitialized variables in power tracking
      rtlwifi: 8192de: use le32 to access cckswing tables
      rtlwifi: rtl8192cu: fix error handle when usb probe failed

Pradeep kumar Chitrapu (1):
      ath10k: fix incorrect multicast/broadcast rate setting

Rakesh Pillai (1):
      ath10k: Fix encoding for protected management frames

Sharvari Harisangam (1):
      mwifiex: update set_mac_address logic

Stanislaw Gruszka (7):
      rt2x00: allow to specify watchdog interval
      rt2800: add helpers for reading dma done index
      rt2800: initial watchdog implementation
      rt2800: add pre_reset_hw callback
      rt2800: do not nullify initialization vector data
      rt2x00: add restart hw
      rt2800: do not enable watchdog by default

Surabhi Vishnoi (4):
      ath10k: Fix the wrong value of enums for wmi tlv stats id
      ath10k: Add wmi tlv vdev subtype for mesh in WCN3990
      ath10k: Do not send probe response template for mesh
      ath10k: Add wmi tlv service map for mesh 11s

Sven Eckelmann (1):
      ath9k: Differentiate between max combined and per chain power

Swati Kushwaha (1):
      mwifiex: ignore processing invalid command response

Tim Schumacher (1):
      ath9k: Check for errors when reading SREV register

Toke H=C3=B8iland-J=C3=B8rgensen (1):
      ath9k: Don't trust TX status TID number when reporting airtime

Tomislav Po=C5=BEega (2):
      ath: drop duplicated define
      ath9k: drop redundant code in ar9003_hw_set_channel

Tzu-En Huang (1):
      rtw88: fix typo rtw_writ16_set

Weitao Hou (1):
      brcmfmac: fix typos in code comments

Wen Gong (9):
      ath10k: sdio: workaround firmware UART pin configuration bug
      ath10k: don't disable interrupts in ath10k_sdio_remove()
      ath10k: add struct for high latency PN replay protection
      ath10k: add handler for HTT_T2H_MSG_TYPE_SEC_IND event
      ath10k: add PN replay protection for high latency devices
      ath10k: add fragmentation handler for high latency devices
      ath10k: enable QCA6174 hw3.2 SDIO hardware
      ath10k: change swap mail box config for UTF mode of SDIO
      ath10k: add peer id check in ath10k_peer_find_by_id

Yan-Hsuan Chuang (10):
      rtw88: pci: use ieee80211_ac_numbers instead of 0-3
      rtw88: pci: check if queue mapping exceeds size of ac_to_hwq
      rtw88: more descriptions about LPS
      rtw88: add fast xmit support
      rtw88: add support for random mac scan
      rtw88: 8822c: disable rx clock gating before counter reset
      rtw88: 8822c: use more accurate ofdm fa counting
      rtw88: power on again if it was already on
      rtw88: restore DACK results to save time
      rtw88: rsvd page should go though management queue

Yingying Tang (1):
      ath10k: Check tx_stats before use it

YueHaibing (4):
      ath9k: Remove some set but not used variables
      rtlwifi: rtl8821ae: Remove set but not used variables 'cur_txokcnt' a=
nd 'b_last_is_cur_rdl_state'
      rtlwifi: btcoex: Remove set but not used variable 'len' and 'asso_typ=
e_v2'
      rtlwifi: btcoex: remove unused function exhalbtc_stack_operation_noti=
fy

 drivers/net/wireless/ath/ath10k/ahb.c              |   2 +-
 drivers/net/wireless/ath/ath10k/core.c             |  48 +-
 drivers/net/wireless/ath/ath10k/core.h             |  12 +-
 drivers/net/wireless/ath/ath10k/coredump.c         |   4 +-
 drivers/net/wireless/ath/ath10k/debug.c            |  50 +-
 drivers/net/wireless/ath/ath10k/debugfs_sta.c      |   7 +
 drivers/net/wireless/ath/ath10k/htc.c              |   1 +
 drivers/net/wireless/ath/ath10k/htt.h              |  60 +-
 drivers/net/wireless/ath/ath10k/htt_rx.c           | 387 ++++++++++-
 drivers/net/wireless/ath/ath10k/htt_tx.c           |  29 +-
 drivers/net/wireless/ath/ath10k/hw.h               |   6 +
 drivers/net/wireless/ath/ath10k/mac.c              |  14 +-
 drivers/net/wireless/ath/ath10k/pci.c              |   2 +-
 drivers/net/wireless/ath/ath10k/qmi.c              |  15 +-
 drivers/net/wireless/ath/ath10k/sdio.c             |  18 +-
 drivers/net/wireless/ath/ath10k/snoc.c             |   4 +-
 drivers/net/wireless/ath/ath10k/txrx.c             |   3 +
 drivers/net/wireless/ath/ath10k/usb.c              |   2 +-
 drivers/net/wireless/ath/ath10k/wmi-tlv.c          |  28 +-
 drivers/net/wireless/ath/ath10k/wmi-tlv.h          |  12 +
 drivers/net/wireless/ath/ath10k/wmi.c              |  37 +-
 drivers/net/wireless/ath/ath10k/wmi.h              |   7 +-
 drivers/net/wireless/ath/ath6kl/debug.c            |   3 +-
 drivers/net/wireless/ath/ath6kl/htc_pipe.c         |   3 -
 drivers/net/wireless/ath/ath6kl/wmi.c              |  13 +-
 drivers/net/wireless/ath/ath9k/ar9003_phy.c        |  24 +-
 drivers/net/wireless/ath/ath9k/eeprom.c            |   2 +-
 drivers/net/wireless/ath/ath9k/eeprom_4k.c         |   1 +
 drivers/net/wireless/ath/ath9k/hw.c                |  40 +-
 drivers/net/wireless/ath/ath9k/hw.h                |   1 +
 drivers/net/wireless/ath/ath9k/init.c              |   2 +-
 drivers/net/wireless/ath/ath9k/xmit.c              |  18 +-
 drivers/net/wireless/ath/carl9170/mac.c            |   2 +-
 drivers/net/wireless/ath/carl9170/rx.c             |   2 +-
 drivers/net/wireless/ath/dfs_pattern_detector.c    |   2 +-
 drivers/net/wireless/ath/regd.h                    |   1 -
 drivers/net/wireless/ath/wil6210/cfg80211.c        |   4 +-
 drivers/net/wireless/ath/wil6210/debugfs.c         |  70 +-
 drivers/net/wireless/ath/wil6210/fw.h              |  11 +-
 drivers/net/wireless/ath/wil6210/fw_inc.c          | 148 +++--
 drivers/net/wireless/ath/wil6210/interrupt.c       |  67 +-
 drivers/net/wireless/ath/wil6210/main.c            |  18 +-
 drivers/net/wireless/ath/wil6210/pcie_bus.c        |   2 +
 drivers/net/wireless/ath/wil6210/rx_reorder.c      |   2 +-
 drivers/net/wireless/ath/wil6210/txrx.c            |  26 +-
 drivers/net/wireless/ath/wil6210/txrx_edma.c       |  10 +-
 drivers/net/wireless/ath/wil6210/wil6210.h         |  33 +-
 drivers/net/wireless/ath/wil6210/wmi.c             |  14 +-
 drivers/net/wireless/broadcom/b43/main.c           |   7 +-
 drivers/net/wireless/broadcom/brcm80211/Kconfig    |  52 +-
 drivers/net/wireless/broadcom/brcm80211/Makefile   |  14 +-
 .../wireless/broadcom/brcm80211/brcmfmac/Kconfig   |  50 ++
 .../wireless/broadcom/brcm80211/brcmfmac/Makefile  |  14 +-
 .../wireless/broadcom/brcm80211/brcmfmac/bcdc.c    |  13 +-
 .../wireless/broadcom/brcm80211/brcmfmac/bcdc.h    |  13 +-
 .../wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c  |  13 +-
 .../wireless/broadcom/brcm80211/brcmfmac/btcoex.c  |  13 +-
 .../wireless/broadcom/brcm80211/brcmfmac/btcoex.h  |  13 +-
 .../net/wireless/broadcom/brcm80211/brcmfmac/bus.h |  13 +-
 .../broadcom/brcm80211/brcmfmac/cfg80211.c         |  13 +-
 .../broadcom/brcm80211/brcmfmac/cfg80211.h         |  13 +-
 .../wireless/broadcom/brcm80211/brcmfmac/chip.c    |  13 +-
 .../wireless/broadcom/brcm80211/brcmfmac/chip.h    |  13 +-
 .../wireless/broadcom/brcm80211/brcmfmac/common.c  |  15 +-
 .../wireless/broadcom/brcm80211/brcmfmac/common.h  |  16 +-
 .../broadcom/brcm80211/brcmfmac/commonring.c       |  16 +-
 .../broadcom/brcm80211/brcmfmac/commonring.h       |  16 +-
 .../wireless/broadcom/brcm80211/brcmfmac/core.c    |  13 +-
 .../wireless/broadcom/brcm80211/brcmfmac/core.h    |  13 +-
 .../wireless/broadcom/brcm80211/brcmfmac/debug.c   |  13 +-
 .../wireless/broadcom/brcm80211/brcmfmac/debug.h   |  13 +-
 .../net/wireless/broadcom/brcm80211/brcmfmac/dmi.c |  13 +-
 .../wireless/broadcom/brcm80211/brcmfmac/feature.c |  13 +-
 .../wireless/broadcom/brcm80211/brcmfmac/feature.h |  13 +-
 .../broadcom/brcm80211/brcmfmac/firmware.c         |  13 +-
 .../broadcom/brcm80211/brcmfmac/firmware.h         |  13 +-
 .../broadcom/brcm80211/brcmfmac/flowring.c         |  16 +-
 .../broadcom/brcm80211/brcmfmac/flowring.h         |  16 +-
 .../wireless/broadcom/brcm80211/brcmfmac/fweh.c    |  13 +-
 .../wireless/broadcom/brcm80211/brcmfmac/fweh.h    |  13 +-
 .../wireless/broadcom/brcm80211/brcmfmac/fwil.c    |  15 +-
 .../wireless/broadcom/brcm80211/brcmfmac/fwil.h    |  13 +-
 .../broadcom/brcm80211/brcmfmac/fwil_types.h       |  13 +-
 .../broadcom/brcm80211/brcmfmac/fwsignal.c         |  13 +-
 .../broadcom/brcm80211/brcmfmac/fwsignal.h         |  14 +-
 .../wireless/broadcom/brcm80211/brcmfmac/msgbuf.c  |  16 +-
 .../wireless/broadcom/brcm80211/brcmfmac/msgbuf.h  |  16 +-
 .../net/wireless/broadcom/brcm80211/brcmfmac/of.c  |  13 +-
 .../net/wireless/broadcom/brcm80211/brcmfmac/of.h  |  13 +-
 .../net/wireless/broadcom/brcm80211/brcmfmac/p2p.c |  13 +-
 .../net/wireless/broadcom/brcm80211/brcmfmac/p2p.h |  13 +-
 .../wireless/broadcom/brcm80211/brcmfmac/pcie.c    |  16 +-
 .../wireless/broadcom/brcm80211/brcmfmac/pcie.h    |  16 +-
 .../net/wireless/broadcom/brcm80211/brcmfmac/pno.c |  13 +-
 .../net/wireless/broadcom/brcm80211/brcmfmac/pno.h |  13 +-
 .../wireless/broadcom/brcm80211/brcmfmac/proto.c   |  13 +-
 .../wireless/broadcom/brcm80211/brcmfmac/proto.h   |  13 +-
 .../wireless/broadcom/brcm80211/brcmfmac/sdio.c    |  13 +-
 .../wireless/broadcom/brcm80211/brcmfmac/sdio.h    |  13 +-
 .../broadcom/brcm80211/brcmfmac/tracepoint.c       |  13 +-
 .../broadcom/brcm80211/brcmfmac/tracepoint.h       |  13 +-
 .../net/wireless/broadcom/brcm80211/brcmfmac/usb.c |  13 +-
 .../net/wireless/broadcom/brcm80211/brcmfmac/usb.h |  13 +-
 .../wireless/broadcom/brcm80211/brcmfmac/vendor.c  |  13 +-
 .../wireless/broadcom/brcm80211/brcmfmac/vendor.h  |  13 +-
 .../broadcom/brcm80211/brcmsmac/phy/phy_cmn.c      |  13 +-
 .../broadcom/brcm80211/brcmsmac/phy/phy_hal.h      |  13 +-
 .../broadcom/brcm80211/brcmsmac/phy/phy_int.h      |  13 +-
 .../broadcom/brcm80211/brcmsmac/phy/phy_lcn.c      |  13 +-
 .../broadcom/brcm80211/brcmsmac/phy/phy_lcn.h      |  13 +-
 .../broadcom/brcm80211/brcmsmac/phy/phy_n.c        |  13 +-
 .../broadcom/brcm80211/brcmsmac/phy/phy_qmath.c    |  13 +-
 .../broadcom/brcm80211/brcmsmac/phy/phy_qmath.h    |  13 +-
 .../broadcom/brcm80211/brcmsmac/phy/phy_radio.h    |  13 +-
 .../broadcom/brcm80211/brcmsmac/phy/phyreg_n.h     |  13 +-
 .../broadcom/brcm80211/brcmsmac/phy/phytbl_lcn.c   |  13 +-
 .../broadcom/brcm80211/brcmsmac/phy/phytbl_lcn.h   |  13 +-
 .../broadcom/brcm80211/brcmsmac/phy/phytbl_n.c     |  13 +-
 .../broadcom/brcm80211/brcmsmac/phy/phytbl_n.h     |  13 +-
 .../wireless/broadcom/brcm80211/brcmutil/Makefile  |  13 +-
 .../net/wireless/broadcom/brcm80211/brcmutil/d11.c |  13 +-
 .../wireless/broadcom/brcm80211/brcmutil/utils.c   |  13 +-
 .../broadcom/brcm80211/include/brcm_hw_ids.h       |  13 +-
 .../broadcom/brcm80211/include/brcmu_d11.h         |  13 +-
 .../broadcom/brcm80211/include/brcmu_utils.h       |  13 +-
 .../broadcom/brcm80211/include/brcmu_wifi.h        |  13 +-
 .../broadcom/brcm80211/include/chipcommon.h        |  13 +-
 .../net/wireless/broadcom/brcm80211/include/defs.h |  13 +-
 .../net/wireless/broadcom/brcm80211/include/soc.h  |  13 +-
 drivers/net/wireless/cisco/Kconfig                 |   2 +
 drivers/net/wireless/cisco/airo.c                  |  57 +-
 drivers/net/wireless/intel/iwlegacy/3945-rs.c      |  14 +-
 drivers/net/wireless/intel/iwlegacy/3945.h         |   3 -
 drivers/net/wireless/intel/iwlegacy/4965-rs.c      |  31 +-
 drivers/net/wireless/intel/iwlegacy/common.h       |   4 -
 drivers/net/wireless/intersil/p54/main.c           |   9 +-
 drivers/net/wireless/intersil/p54/p54usb.c         |  43 +-
 drivers/net/wireless/intersil/p54/txrx.c           |  11 +-
 drivers/net/wireless/marvell/libertas/if_usb.c     |   2 +-
 drivers/net/wireless/marvell/libertas_tf/if_usb.c  |   2 +-
 drivers/net/wireless/marvell/mwifiex/cmdevt.c      |  27 +-
 drivers/net/wireless/marvell/mwifiex/main.c        |   6 +-
 drivers/net/wireless/marvell/mwifiex/main.h        |   2 +-
 drivers/net/wireless/marvell/mwifiex/pcie.c        |   5 +-
 drivers/net/wireless/mediatek/mt7601u/dma.c        |  54 +-
 drivers/net/wireless/mediatek/mt7601u/tx.c         |   4 +-
 drivers/net/wireless/quantenna/qtnfmac/commands.c  |   5 +-
 drivers/net/wireless/ralink/rt2x00/rt2800lib.c     |  96 ++-
 drivers/net/wireless/ralink/rt2x00/rt2800lib.h     |  11 +
 drivers/net/wireless/ralink/rt2x00/rt2800mmio.c    |  31 +
 drivers/net/wireless/ralink/rt2x00/rt2800mmio.h    |   2 +
 drivers/net/wireless/ralink/rt2x00/rt2800pci.c     |   3 +
 drivers/net/wireless/ralink/rt2x00/rt2800soc.c     |   3 +
 drivers/net/wireless/ralink/rt2x00/rt2800usb.c     |  11 +
 drivers/net/wireless/ralink/rt2x00/rt2x00.h        |  10 +
 drivers/net/wireless/ralink/rt2x00/rt2x00debug.c   |  35 +
 drivers/net/wireless/ralink/rt2x00/rt2x00dev.c     |  10 +-
 drivers/net/wireless/ralink/rt2x00/rt2x00link.c    |  15 +-
 drivers/net/wireless/ralink/rt2x00/rt2x00queue.h   |   6 +
 .../realtek/rtlwifi/btcoexist/halbtcoutsrc.c       |  35 +-
 .../realtek/rtlwifi/btcoexist/halbtcoutsrc.h       |   1 -
 .../wireless/realtek/rtlwifi/btcoexist/rtl_btc.c   |   3 +-
 drivers/net/wireless/realtek/rtlwifi/efuse.c       |   5 +-
 .../net/wireless/realtek/rtlwifi/rtl8188ee/hw.c    |   2 +-
 .../net/wireless/realtek/rtlwifi/rtl8192de/dm.c    | 695 ++++++++++-------=
---
 .../net/wireless/realtek/rtlwifi/rtl8821ae/dm.c    |   8 +-
 .../net/wireless/realtek/rtlwifi/rtl8821ae/trx.c   | 253 ++++----
 .../net/wireless/realtek/rtlwifi/rtl8821ae/trx.h   | 708 +++++++++++------=
----
 drivers/net/wireless/realtek/rtlwifi/usb.c         |   5 +-
 drivers/net/wireless/realtek/rtlwifi/wifi.h        |   1 +
 drivers/net/wireless/realtek/rtw88/hci.h           |   2 +-
 drivers/net/wireless/realtek/rtw88/mac.c           |   8 +-
 drivers/net/wireless/realtek/rtw88/mac80211.c      |  32 +
 drivers/net/wireless/realtek/rtw88/main.c          |  10 +-
 drivers/net/wireless/realtek/rtw88/main.h          |  11 +
 drivers/net/wireless/realtek/rtw88/pci.c           |  10 +-
 drivers/net/wireless/realtek/rtw88/phy.c           |  13 +-
 drivers/net/wireless/realtek/rtw88/rtw8822c.c      | 436 ++++++++++++-
 drivers/net/wireless/realtek/rtw88/rtw8822c.h      |  23 +
 drivers/net/wireless/realtek/rtw88/tx.c            |   2 +-
 drivers/ssb/driver_gpio.c                          |   6 -
 181 files changed, 2885 insertions(+), 2322 deletions(-)
 create mode 100644 drivers/net/wireless/broadcom/brcm80211/brcmfmac/Kconfig
