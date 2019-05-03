Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1FC112D74
	for <lists+netdev@lfdr.de>; Fri,  3 May 2019 14:21:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727798AbfECMVX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 May 2019 08:21:23 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:58074 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727022AbfECMVW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 May 2019 08:21:22 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id BE0F86090F; Fri,  3 May 2019 12:21:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1556886081;
        bh=2Pg3jshasjRRuXiZymjXl9ogYOaQ0t7+/w88bOooLu8=;
        h=From:To:Cc:Subject:Date:From;
        b=gaPF8a9ypl0D6I5g9XRRNrqcRPqZqJUZn0j8jOgJMSci0CmXjNRXBRNPAhcPYOhUO
         XVJ94AdRxV8TXcBTBNPRym4w6kJgG2YqjYdAqNz0Ikzj97hNRGVrPGktL1EpDmg27p
         ZUuRbuTBr6XeL5xfdjVCQ5gUVf2+cYiUKu9M2lSw=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        pdx-caf-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_INVALID,DKIM_SIGNED autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 7DEF560735;
        Fri,  3 May 2019 12:21:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1556886080;
        bh=2Pg3jshasjRRuXiZymjXl9ogYOaQ0t7+/w88bOooLu8=;
        h=From:To:Cc:Subject:Date:From;
        b=LEAhplK1whcu0F6bME5MzhrphcDFxJkzFTtS6HRKxDu66hwvsbcpwxNGie6KSK9QY
         wiJqMbNNbvJVVrTADLh9UVxu2KUIwNYQoPc8mm7kc0jaD1kfUSxvoCNlwRDloI7TXO
         3dXGaUjMTRtrf7K5JC1kEzikGleDxEX9caoJCPNI=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 7DEF560735
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     David Miller <davem@davemloft.net>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: pull-request: wireless-drivers-next 2019-05-03
Date:   Fri, 03 May 2019 15:21:16 +0300
Message-ID: <87bm0jk9tv.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave,

here's a pull request to net-next for 5.2, more information below. Also
there's a conflict in iwlwifi again and this time I added the conflict
resolution to the signed tag based on our discussion earlier this week.
Please let me know what you think or there are any problems.

Kalle

The following changes since commit 5c2e6e14a0ad24a35d9d2b318204c8c012d9d618:

  Merge branch 'net-add-reset-controller-driven-PHY-reset' (2019-04-18 17:4=
3:11 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-next=
.git tags/wireless-drivers-next-for-davem-2019-05-03

for you to fetch changes up to f9b628d61faef9b6d411f13cf4be41470b7a7adb:

  rtw88: add license for Makefile (2019-05-03 15:06:12 +0300)

----------------------------------------------------------------
wireless-drivers-next patches for 5.2

Most likely the last patchset of new feature for 5.2, and this time we
have quite a lot of new features. Most obvious being rtw88 from
Realtek which supports RTL8822BE and RTL8822CE 802.11ac devices. We
have also new hardware support for existing drivers and improvements.

There's one conflict in iwlwifi, my example conflict resolution below.

Major changes:

iwlwifi

* bump the 20000-series FW API version

* work on new hardware continues

* RTT confidence indication support for Fine Timing Measurement (FTM)

* an improvement in HE (802.11ax) rate-scaling

* add command version parsing from the fimware TLVs

* add support for a new WoWLAN patterns firmware API

rsi

* add support for rs9116

mwifiex

* add support for SD8987

brcmfmac

* add quirk for ACEPC T8 and T11 mini PCs

rt2x00

* add RT3883 support

qtnfmac

* fix debugfs interface to support multiple cards

rtw88

* new driver

mt76

* share more code across drivers

* add support for MT7615 chipset

* rework DMA API

* tx/rx performance optimizations

* use NAPI for tx cleanup on mt76x02

* AP mode support for USB devices

* USB stability fixes

* tx power handling fixes for 76x2

* endian fixes

Conflicts:

There's a trivial conflict in
drivers/net/wireless/intel/iwlwifi/fw/file.h, just leave
IWL_UCODE_TLV_FW_FSEQ_VERSION to the file. 'git diff' output should be
just empty:

diff --cc drivers/net/wireless/intel/iwlwifi/fw/file.h
index cd622af90077,b0671e16e1ce..000000000000
--- a/drivers/net/wireless/intel/iwlwifi/fw/file.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/file.h

----------------------------------------------------------------
Aditya Pakki (1):
      rsi: Fix NULL pointer dereference in kmalloc

Ahmad Masri (4):
      wil6210: prevent device memory access while in reset or suspend
      wil6210: check mid is valid
      wil6210: fix report of rx packet checksum in edma mode
      wil6210: add support for ucode tracing

Alexei Avshalom Lazar (1):
      wil6210: align to latest auto generated wmi.h

Alexey Khoroshilov (1):
      mwl8k: fix error handling in mwl8k_post_cmd()

Andrei Otcheretianski (1):
      iwlwifi: mvm: Don't sleep in RX path

Avraham Stern (2):
      iwlwifi: mvm: support rtt confidence indication
      iwlwifi: mvm: report FTM start time TSF when applicable

Colin Ian King (3):
      iwlegacy: fix spelling mistake "acumulative" -> "accumulative"
      mwifiex: fix spelling mistake "capabilties" -> "capabilities"
      rtw88: fix shift of more than 32 bits of a integer

Dan Carpenter (2):
      mwifiex: prevent an array overflow
      brcm80211: potential NULL dereference in brcmf_cfg80211_vndr_cmds_dcm=
d_handler()

Dedy Lansky (2):
      wil6210: use OEM MAC address from OTP
      wil6210: free edma_rx_swtail upon reset

Felix Fietkau (11):
      mt76: fix tx power issues
      mt76: use readl/writel instead of ioread32/iowrite32
      mt76: use mac80211 txq scheduling
      mt76: reduce locking in mt76_dma_tx_cleanup
      mt76: store wcid tx rate info in one u32 reduce locking
      mt76: move tx tasklet to struct mt76_dev
      mt76: only schedule txqs from the tx tasklet
      mt76: mt76x02: use napi polling for tx cleanup
      mt76: mt76x02: remove irqsave/restore in locking for tx status fifo
      mt76: mt7603: fix initialization of max rx length
      mt76: mt7615: use sizeof instead of sizeof_field

Gabor Juhos (1):
      rt2x00: add RT3883 support

Gregory Greenman (1):
      iwlwifi: rs: consider LDPC capability in case of HE

Gustavo A. R. Silva (5):
      rndis_wlan: use struct_size() helper
      mwifiex: use struct_size() in kzalloc()
      zd1211rw: use struct_size() helper
      rtlwifi: rtl8723ae: Fix missing break in switch statement
      rtw88: phy: mark expected switch fall-throughs

Hans de Goede (1):
      brcmfmac: Add DMI nvram filename quirk for ACEPC T8 and T11 mini PCs

Igor Mitsyanko (1):
      qtnfmac: allow to control DFS slave radar detection

Jeff Xie (1):
      mwl8k: move spin_lock_bh to spin_lock in tasklet

Johannes Berg (3):
      iwlwifi: pcie: initialize debug_rfkill to -1
      iwlwifi: pcie: don't crash on invalid RX interrupt
      iwlwifi: parse command version TLV

Kalle Valo (5):
      Merge ath-next from git://git.kernel.org/.../kvalo/ath.git
      Merge tag 'iwlwifi-next-for-kalle-2019-04-18-2' of git://git.kernel.o=
rg/.../iwlwifi/iwlwifi-next
      Revert "brcmfmac: send mailbox interrupt twice for specific hardware =
device"
      Merge tag 'iwlwifi-next-for-kalle-2019-04-29' of git://git.kernel.org=
/.../iwlwifi/iwlwifi-next
      Merge tag 'mt76-for-kvalo-2019-05-01' of https://github.com/nbd168/wi=
reless

Kangjie Lu (1):
      net: cw1200: fix a NULL pointer dereference

Larry Finger (1):
      b43: Remove empty function lpphy_papd_cal()

Liad Kaufman (1):
      iwlwifi: mvm: limit TLC according to our HE capabilities

Lior David (1):
      wil6210: fix return code of wmi_mgmt_tx and wmi_mgmt_tx_ext

Lorenzo Bianconi (35):
      mt76: mmio: move mt76x02_set_irq_mask in mt76 module
      mt76: dma: move mt76x02_init_{tx,rx}_queue in mt76 module
      mt76: remove mt76_queue dependency from tx_queue_skb function pointer
      mt76: remove mt76_queue dependency from tx_prepare_skb function point=
er
      mt76: remove mt76_queue dependency from tx_complete_skb function poin=
ter
      mt76: introduce mt76_sw_queue data structure
      mt76: introduce mt76_txq_id field in mt76_queue_entry
      mt76: move mt76x02_insert_hdr_pad in mt76-core module
      mt76: mmio: move mt76_insert_hdr_pad in mt76_dma_tx_queue_skb
      mt76: move skb dma mapping before running tx_prepare_skb
      mt76: introduce mt76_tx_info data structure
      mt76: dma: add static qualifier to mt76_dma_tx_queue_skb
      mt7603: remove mt7603_mcu_init routine
      mt7603: core: do not use magic numbers in mt7603_reg_map
      mt76: usb: reduce code indentation in mt76u_alloc_tx
      mt76: introduce mt76_free_device routine
      mt76: move mac_work in mt76_dev
      mt76: usb: reduce locking in mt76u_tx_tasklet
      mt76: set txwi_size according to the driver value
      mt76: add skb pointer to mt76_tx_info
      mt76: dma: introduce skb field in mt76_txwi_cache
      mt76: dma: add skb check for dummy pointer
      mt76: mt7603: remove query from mt7603_mcu_msg_send signature
      mt76: mt7603: use standard signature for mt7603_mcu_msg_send
      mt76: mt7603: initialize mt76_mcu_ops data structure
      mt76: introduce mt76_mcu_restart macro
      mt76: mt7603: init mcu_restart function pointer
      mt76: mt7603: run __mt76_mcu_send_msg in mt7603_mcu_send_firmware
      mt76: mt7603: report firmware version using ethtool
      mt76: move beacon_int in mt76_dev
      mt76: move beacon_mask in mt76_dev
      mt76: move pre_tbtt_tasklet in mt76_dev
      mt76: mt7603: enable/disable pre_tbtt_tasklet in mt7603_set_channel
      mt76: do not enable/disable pre_tbtt_tasklet in scan_start/scan_compl=
ete
      mt76: mt7603: dynamically alloc mcu req in mt7603_mcu_set_eeprom

Luca Coelho (5):
      iwlwifi: bump FW API to 47 for 22000 series
      iwlwifi: remove unused 0x40C0 PCI device IDs
      iwlwifi: mvm: support v2 of the WoWLAN patterns command
      iwlwifi: bump FW API to 48 for 22000 series
      iwlwifi: pcie: remove stray character in iwl_pcie_rx_alloc_page()

Maya Erez (6):
      wil6210: increase PCP stop command timeout
      wil6210: do not set BIT_USER_SUPPORT_T_POWER_ON_0 in Talyn-MB
      wil6210: update WIL_MCS_MAX to 15
      wil6210: prevent access to RGF_CAF_ICR in Talyn
      wil6210: reset buff id in status message after completion
      wil6210: print error in FW and board files load failures

Nathan Chancellor (2):
      iwlwifi: mvm: Change an 'else if' into an 'else' in iwl_mvm_send_add_=
bcast_sta
      rtw88: Make RA_MASK macros ULL

Pan Bian (1):
      p54: drop device reference count if fails to enable device

Paolo Bonzini (1):
      wlcore: simplify/fix/optimize reg_ch_conf_pending operations

Petr =C5=A0tetiar (1):
      mwl8k: Fix rate_idx underflow

Rafa=C5=82 Mi=C5=82ecki (1):
      brcmfmac: print firmware messages after a firmware crash

Ryder Lee (6):
      mt76: add mac80211 driver for MT7615 PCIe-based chipsets
      mt76: add unlikely() for dma_mapping_error() check
      mt76: use macro for sn and seq_ctrl conversion
      MAINTAINERS: update entry for mt76 wireless driver
      mt76: fix endianness sparse warnings
      mt76: add TX/RX antenna pattern capabilities

Sergey Matyukevich (2):
      qtnfmac: handle channel switch events for connected stations only
      qtnfmac: modify debugfs to support multiple cards

Shahar S Matityahu (12):
      iwlwifi: dbg_ini: support notification and dhc regions type parsing
      iwlwifi: add FW_INFO debug level
      iwlwifi: dbg_ini: add debug prints to the ini flows
      iwlwifi: dbg: add periphery memory dumping support to ax210 device fa=
mily
      iwlwifi: dbg: add lmac and umac PC registers to periphery dump
      iwlwifi: dbg_ini: set dump bit only when trigger collection is certain
      iwlwifi: support fseq tlv and print fseq version
      iwlwifi: dbg_ini: add lmac and umac error tables dumping support
      iwlwifi: dbg_ini: add periodic trigger support
      iwlwifi: dbg: replace dump info device family with HW type
      iwlwifi: avoid allocating memory for region with disabled domain
      iwlwifi: dbg_ini: check for valid region type during regions parsing

Shaul Triebitz (2):
      iwlwifi: mvm: set 512 TX queue slots for AX210 devices
      iwlwifi: unite macros with same meaning

Siva Rebbagondla (8):
      rsi: add new device model for 9116
      rsi: move common part of firmware load to separate function
      rsi: add firmware loading for 9116 device
      rsi: change in device init frame sequence for 9116
      rsi: new bootup parameters for 9116
      rsi: send new tx command frame wlan9116 features
      rsi: reset device changes for 9116
      rsi: miscallaneous changes for 9116 and common

Stanislaw Gruszka (39):
      rt2x00: use ratelimited variants dev_warn/dev_err
      rt2x00: check number of EPROTO errors
      rt2x00: do not print error when queue is full
      rt2800: partially restore old mmio txstatus behaviour
      rt2800: new flush implementation for SoC devices
      rt2800: move txstatus pending routine
      rt2800mmio: fetch tx status changes
      rt2800mmio: use timer and work for handling tx statuses timeouts
      rt2x00: remove last_nostatus_check
      rt2x00: remove not used entry field
      rt2x00mmio: remove legacy comment
      mt76x02: introduce mt76x02_beacon.c
      mt76x02: add hrtimer for pre TBTT for USB
      mt76x02: introduce beacon_ops
      mt76x02u: implement beacon_ops
      mt76x02: generalize some mmio beaconing functions
      mt76x02u: add sta_ps
      mt76x02: disable HW encryption for group frames
      mt76x02u: implement pre TBTT work for USB
      mt76x02: make beacon slots bigger for USB
      mt76x02u: add mt76_release_buffered_frames
      mt76: unify set_tim
      mt76x02: enable AP mode for USB
      mt76usb: change mt76u_submit_buf
      mt76: remove rx_page_lock
      mt76usb: change mt76u_fill_rx_sg arguments
      mt76usb: use usb_dev private data
      mt76usb: remove mt76u_buf redundant fileds
      mt76usb: move mt76u_buf->done to queue entry
      mt76usb: remove mt76u_buf and use urb directly
      mt76usb: remove MT_RXQ_MAIN queue from mt76u_urb_alloc
      mt76usb: resue mt76u_urb_alloc for tx
      mt76usb: remove unneded sg_init_table
      mt76usb: allocate urb and sg as linear data
      mt76usb: remove queue variable from rx_tasklet
      mt76: mt76x02u: remove bogus stop on suspend
      mt76usb: fix tx/rx stop
      mt76: mt76x02: remove bogus mutex usage
      mt76: usb: use EP max packet aligned buffer sizes for rx

Tam=C3=A1s Sz=C5=B1cs (1):
      mwifiex: add support for SD8987 chipset

Tomislav Po=C5=BEega (1):
      rt2x00: code-style fix in rt2800usb.c

Wright Feng (3):
      brcmfmac: send mailbox interrupt twice for specific hardware device
      brcmfmac: send mailbox interrupt twice for specific hardware device
      brcmfmac: set txflow request id from 1 to pktids array size

Yan-Hsuan Chuang (2):
      rtw88: new Realtek 802.11ac driver
      rtw88: add license for Makefile

YueHaibing (6):
      ray_cs: Check return value of pcmcia_register_driver
      ray_cs: use remove_proc_subtree to simplify procfs code
      ssb: Fix possible NULL pointer dereference in ssb_host_pcmcia_exit
      at76c50x-usb: Don't register led_trigger if usb_register_driver failed
      rtlwifi: rtl8192cu: remove set but not used variable 'turbo_scanoff'
      iwlwifi: Use correct channel_profile iniwl_get_nvm

kbuild test robot (1):
      mt76: mt76x02: mt76x02_poll_tx() can be static

 MAINTAINERS                                        |     8 +
 drivers/net/wireless/ath/wil6210/cfg80211.c        |    11 +-
 drivers/net/wireless/ath/wil6210/debugfs.c         |    38 +-
 drivers/net/wireless/ath/wil6210/fw_inc.c          |     6 +-
 drivers/net/wireless/ath/wil6210/main.c            |    78 +-
 drivers/net/wireless/ath/wil6210/netdev.c          |    10 +-
 drivers/net/wireless/ath/wil6210/pcie_bus.c        |     4 +-
 drivers/net/wireless/ath/wil6210/pm.c              |    35 +-
 drivers/net/wireless/ath/wil6210/txrx_edma.c       |    74 +-
 drivers/net/wireless/ath/wil6210/txrx_edma.h       |    47 +-
 drivers/net/wireless/ath/wil6210/wil6210.h         |    11 +-
 drivers/net/wireless/ath/wil6210/wil_crash_dump.c  |    18 +-
 drivers/net/wireless/ath/wil6210/wmi.c             |    24 +-
 drivers/net/wireless/ath/wil6210/wmi.h             |    91 +-
 drivers/net/wireless/atmel/at76c50x-usb.c          |     4 +-
 drivers/net/wireless/broadcom/b43/phy_lp.c         |    11 -
 .../net/wireless/broadcom/brcm80211/brcmfmac/dmi.c |    26 +
 .../wireless/broadcom/brcm80211/brcmfmac/msgbuf.c  |     6 +-
 .../wireless/broadcom/brcm80211/brcmfmac/pcie.c    |    31 +-
 .../wireless/broadcom/brcm80211/brcmfmac/vendor.c  |     5 +-
 drivers/net/wireless/intel/iwlegacy/3945-debug.c   |     8 +-
 drivers/net/wireless/intel/iwlwifi/cfg/22000.c     |    19 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/d3.h     |   136 +-
 .../net/wireless/intel/iwlwifi/fw/api/dbg-tlv.h    |     4 +
 .../net/wireless/intel/iwlwifi/fw/api/location.h   |    77 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/txq.h    |     3 +
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c        |   187 +-
 drivers/net/wireless/intel/iwlwifi/fw/dbg.h        |     3 +
 drivers/net/wireless/intel/iwlwifi/fw/error-dump.h |     4 +-
 drivers/net/wireless/intel/iwlwifi/fw/file.h       |    33 +-
 drivers/net/wireless/intel/iwlwifi/fw/img.h        |     7 +-
 drivers/net/wireless/intel/iwlwifi/fw/init.c       |     2 +
 drivers/net/wireless/intel/iwlwifi/fw/runtime.h    |     1 +
 drivers/net/wireless/intel/iwlwifi/iwl-config.h    |     1 -
 drivers/net/wireless/intel/iwlwifi/iwl-csr.h       |     1 +
 drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c   |     2 +-
 drivers/net/wireless/intel/iwlwifi/iwl-debug.h     |     2 +
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c       |    26 +-
 drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c |     2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c        |    58 +-
 .../net/wireless/intel/iwlwifi/mvm/ftm-initiator.c |    33 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c  |     2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c       |     1 +
 drivers/net/wireless/intel/iwlwifi/mvm/rs-fw.c     |    50 +-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c       |    11 +-
 .../net/wireless/intel/iwlwifi/mvm/time-event.c    |     2 +-
 .../wireless/intel/iwlwifi/pcie/ctxt-info-gen3.c   |     3 +-
 .../net/wireless/intel/iwlwifi/pcie/ctxt-info.c    |     6 +-
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c      |     5 -
 drivers/net/wireless/intel/iwlwifi/pcie/internal.h |     8 +-
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c       |     9 +-
 .../net/wireless/intel/iwlwifi/pcie/trans-gen2.c   |     7 +-
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c    |    13 +-
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c       |     8 +-
 drivers/net/wireless/intersil/p54/p54pci.c         |     3 +-
 drivers/net/wireless/marvell/mwifiex/Kconfig       |     4 +-
 drivers/net/wireless/marvell/mwifiex/cfp.c         |     3 +
 drivers/net/wireless/marvell/mwifiex/sdio.c        |     5 +
 drivers/net/wireless/marvell/mwifiex/sdio.h        |    69 +
 drivers/net/wireless/marvell/mwifiex/sta_cmdresp.c |     7 +-
 drivers/net/wireless/marvell/mwifiex/sta_event.c   |    12 +-
 drivers/net/wireless/marvell/mwifiex/uap_event.c   |     8 +-
 drivers/net/wireless/marvell/mwl8k.c               |    24 +-
 drivers/net/wireless/mediatek/mt76/Kconfig         |     1 +
 drivers/net/wireless/mediatek/mt76/Makefile        |     3 +-
 drivers/net/wireless/mediatek/mt76/agg-rx.c        |     2 +-
 drivers/net/wireless/mediatek/mt76/debugfs.c       |     7 +-
 drivers/net/wireless/mediatek/mt76/dma.c           |   164 +-
 drivers/net/wireless/mediatek/mt76/dma.h           |     2 +
 drivers/net/wireless/mediatek/mt76/mac80211.c      |    41 +-
 drivers/net/wireless/mediatek/mt76/mmio.c          |    17 +-
 drivers/net/wireless/mediatek/mt76/mt76.h          |   119 +-
 drivers/net/wireless/mediatek/mt76/mt7603/beacon.c |    35 +-
 drivers/net/wireless/mediatek/mt76/mt7603/core.c   |    19 +-
 drivers/net/wireless/mediatek/mt76/mt7603/dma.c    |    39 +-
 drivers/net/wireless/mediatek/mt76/mt7603/init.c   |    12 +-
 drivers/net/wireless/mediatek/mt76/mt7603/mac.c    |    54 +-
 drivers/net/wireless/mediatek/mt76/mt7603/main.c   |    34 +-
 drivers/net/wireless/mediatek/mt76/mt7603/mcu.c    |   116 +-
 drivers/net/wireless/mediatek/mt76/mt7603/mt7603.h |    23 +-
 drivers/net/wireless/mediatek/mt76/mt7603/regs.h   |     4 +
 drivers/net/wireless/mediatek/mt76/mt7615/Kconfig  |     7 +
 drivers/net/wireless/mediatek/mt76/mt7615/Makefile |     5 +
 drivers/net/wireless/mediatek/mt76/mt7615/dma.c    |   205 +
 drivers/net/wireless/mediatek/mt76/mt7615/eeprom.c |    98 +
 drivers/net/wireless/mediatek/mt76/mt7615/eeprom.h |    18 +
 drivers/net/wireless/mediatek/mt76/mt7615/init.c   |   229 +
 drivers/net/wireless/mediatek/mt76/mt7615/mac.c    |   775 +
 drivers/net/wireless/mediatek/mt76/mt7615/mac.h    |   300 +
 drivers/net/wireless/mediatek/mt76/mt7615/main.c   |   499 +
 drivers/net/wireless/mediatek/mt76/mt7615/mcu.c    |  1655 ++
 drivers/net/wireless/mediatek/mt76/mt7615/mcu.h    |   520 +
 drivers/net/wireless/mediatek/mt76/mt7615/mt7615.h |   195 +
 drivers/net/wireless/mediatek/mt76/mt7615/pci.c    |   150 +
 drivers/net/wireless/mediatek/mt76/mt7615/regs.h   |   203 +
 drivers/net/wireless/mediatek/mt76/mt76x0/init.c   |     2 +-
 drivers/net/wireless/mediatek/mt76/mt76x0/main.c   |     8 +-
 drivers/net/wireless/mediatek/mt76/mt76x0/pci.c    |    26 +-
 drivers/net/wireless/mediatek/mt76/mt76x0/usb.c    |    49 +-
 drivers/net/wireless/mediatek/mt76/mt76x02.h       |    44 +-
 .../net/wireless/mediatek/mt76/mt76x02_beacon.c    |   286 +
 drivers/net/wireless/mediatek/mt76/mt76x02_mac.c   |   185 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_mac.h   |     4 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c  |   266 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_regs.h  |     5 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_txrx.c  |    29 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_usb.h   |    12 +-
 .../net/wireless/mediatek/mt76/mt76x02_usb_core.c  |   188 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_util.c  |   107 +-
 drivers/net/wireless/mediatek/mt76/mt76x2/init.c   |    12 +-
 drivers/net/wireless/mediatek/mt76/mt76x2/pci.c    |     3 +-
 .../net/wireless/mediatek/mt76/mt76x2/pci_init.c   |     6 +-
 .../net/wireless/mediatek/mt76/mt76x2/pci_main.c   |    27 +-
 drivers/net/wireless/mediatek/mt76/mt76x2/phy.c    |     6 +-
 drivers/net/wireless/mediatek/mt76/mt76x2/usb.c    |    14 +-
 .../net/wireless/mediatek/mt76/mt76x2/usb_init.c   |     5 +-
 .../net/wireless/mediatek/mt76/mt76x2/usb_main.c   |    19 +-
 drivers/net/wireless/mediatek/mt76/tx.c            |   148 +-
 drivers/net/wireless/mediatek/mt76/usb.c           |   379 +-
 drivers/net/wireless/quantenna/qtnfmac/cfg80211.c  |     2 +-
 drivers/net/wireless/quantenna/qtnfmac/commands.c  |     4 +-
 drivers/net/wireless/quantenna/qtnfmac/commands.h  |     3 +-
 drivers/net/wireless/quantenna/qtnfmac/core.c      |    35 +
 drivers/net/wireless/quantenna/qtnfmac/core.h      |     2 +
 drivers/net/wireless/quantenna/qtnfmac/debug.c     |     4 +-
 drivers/net/wireless/quantenna/qtnfmac/event.c     |    16 +-
 drivers/net/wireless/quantenna/qtnfmac/qlink.h     |     4 +-
 drivers/net/wireless/ralink/rt2x00/rt2800.h        |    19 +-
 drivers/net/wireless/ralink/rt2x00/rt2800lib.c     |   628 +-
 drivers/net/wireless/ralink/rt2x00/rt2800lib.h     |     3 +-
 drivers/net/wireless/ralink/rt2x00/rt2800mmio.c    |   124 +-
 drivers/net/wireless/ralink/rt2x00/rt2800mmio.h    |     1 +
 drivers/net/wireless/ralink/rt2x00/rt2800pci.c     |     2 +-
 drivers/net/wireless/ralink/rt2x00/rt2800soc.c     |    13 +-
 drivers/net/wireless/ralink/rt2x00/rt2800usb.c     |    28 +-
 drivers/net/wireless/ralink/rt2x00/rt2x00.h        |     7 +-
 drivers/net/wireless/ralink/rt2x00/rt2x00dev.c     |     4 +
 drivers/net/wireless/ralink/rt2x00/rt2x00mmio.h    |     2 -
 drivers/net/wireless/ralink/rt2x00/rt2x00queue.c   |     3 +-
 drivers/net/wireless/ralink/rt2x00/rt2x00queue.h   |     3 -
 drivers/net/wireless/ralink/rt2x00/rt2x00usb.c     |    22 +-
 drivers/net/wireless/ray_cs.c                      |     8 +-
 drivers/net/wireless/realtek/Kconfig               |     1 +
 drivers/net/wireless/realtek/Makefile              |     1 +
 .../net/wireless/realtek/rtlwifi/rtl8192cu/rf.c    |     3 -
 .../net/wireless/realtek/rtlwifi/rtl8723ae/hw.c    |     1 +
 drivers/net/wireless/realtek/rtw88/Kconfig         |    54 +
 drivers/net/wireless/realtek/rtw88/Makefile        |    22 +
 drivers/net/wireless/realtek/rtw88/debug.c         |   637 +
 drivers/net/wireless/realtek/rtw88/debug.h         |    52 +
 drivers/net/wireless/realtek/rtw88/efuse.c         |   160 +
 drivers/net/wireless/realtek/rtw88/efuse.h         |    26 +
 drivers/net/wireless/realtek/rtw88/fw.c            |   633 +
 drivers/net/wireless/realtek/rtw88/fw.h            |   222 +
 drivers/net/wireless/realtek/rtw88/hci.h           |   211 +
 drivers/net/wireless/realtek/rtw88/mac.c           |   965 +
 drivers/net/wireless/realtek/rtw88/mac.h           |    35 +
 drivers/net/wireless/realtek/rtw88/mac80211.c      |   481 +
 drivers/net/wireless/realtek/rtw88/main.c          |  1211 ++
 drivers/net/wireless/realtek/rtw88/main.h          |  1104 +
 drivers/net/wireless/realtek/rtw88/pci.c           |  1211 ++
 drivers/net/wireless/realtek/rtw88/pci.h           |   237 +
 drivers/net/wireless/realtek/rtw88/phy.c           |  1727 ++
 drivers/net/wireless/realtek/rtw88/phy.h           |   134 +
 drivers/net/wireless/realtek/rtw88/ps.c            |   166 +
 drivers/net/wireless/realtek/rtw88/ps.h            |    20 +
 drivers/net/wireless/realtek/rtw88/reg.h           |   421 +
 drivers/net/wireless/realtek/rtw88/regd.c          |   391 +
 drivers/net/wireless/realtek/rtw88/regd.h          |    67 +
 drivers/net/wireless/realtek/rtw88/rtw8822b.c      |  1594 ++
 drivers/net/wireless/realtek/rtw88/rtw8822b.h      |   170 +
 .../net/wireless/realtek/rtw88/rtw8822b_table.c    | 20783 +++++++++++++++=
++++
 .../net/wireless/realtek/rtw88/rtw8822b_table.h    |    18 +
 drivers/net/wireless/realtek/rtw88/rtw8822c.c      |  1890 ++
 drivers/net/wireless/realtek/rtw88/rtw8822c.h      |   186 +
 .../net/wireless/realtek/rtw88/rtw8822c_table.c    | 11753 +++++++++++
 .../net/wireless/realtek/rtw88/rtw8822c_table.h    |    17 +
 drivers/net/wireless/realtek/rtw88/rx.c            |   151 +
 drivers/net/wireless/realtek/rtw88/rx.h            |    41 +
 drivers/net/wireless/realtek/rtw88/sec.c           |   120 +
 drivers/net/wireless/realtek/rtw88/sec.h           |    39 +
 drivers/net/wireless/realtek/rtw88/tx.c            |   367 +
 drivers/net/wireless/realtek/rtw88/tx.h            |    89 +
 drivers/net/wireless/realtek/rtw88/util.c          |    72 +
 drivers/net/wireless/realtek/rtw88/util.h          |    34 +
 drivers/net/wireless/rndis_wlan.c                  |    12 +-
 drivers/net/wireless/rsi/rsi_91x_hal.c             |   199 +-
 drivers/net/wireless/rsi/rsi_91x_mac80211.c        |    30 +-
 drivers/net/wireless/rsi/rsi_91x_mgmt.c            |   232 +-
 drivers/net/wireless/rsi/rsi_91x_sdio.c            |   129 +-
 drivers/net/wireless/rsi/rsi_91x_usb.c             |    96 +-
 drivers/net/wireless/rsi/rsi_boot_params.h         |    63 +
 drivers/net/wireless/rsi/rsi_hal.h                 |    44 +-
 drivers/net/wireless/rsi/rsi_main.h                |    21 +-
 drivers/net/wireless/rsi/rsi_mgmt.h                |    26 +
 drivers/net/wireless/rsi/rsi_sdio.h                |     5 +-
 drivers/net/wireless/rsi/rsi_usb.h                 |     3 +-
 drivers/net/wireless/st/cw1200/main.c              |     5 +
 drivers/net/wireless/ti/wlcore/cmd.c               |    15 +-
 drivers/net/wireless/ti/wlcore/wlcore.h            |     4 +-
 drivers/net/wireless/zydas/zd1211rw/zd_usb.c       |     3 +-
 drivers/ssb/bridge_pcmcia_80211.c                  |     9 +-
 202 files changed, 56497 insertions(+), 1641 deletions(-)
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7615/Kconfig
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7615/Makefile
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7615/dma.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7615/eeprom.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7615/eeprom.h
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7615/init.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7615/mac.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7615/mac.h
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7615/main.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7615/mcu.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7615/mcu.h
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7615/mt7615.h
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7615/pci.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7615/regs.h
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x02_beacon.c
 create mode 100644 drivers/net/wireless/realtek/rtw88/Kconfig
 create mode 100644 drivers/net/wireless/realtek/rtw88/Makefile
 create mode 100644 drivers/net/wireless/realtek/rtw88/debug.c
 create mode 100644 drivers/net/wireless/realtek/rtw88/debug.h
 create mode 100644 drivers/net/wireless/realtek/rtw88/efuse.c
 create mode 100644 drivers/net/wireless/realtek/rtw88/efuse.h
 create mode 100644 drivers/net/wireless/realtek/rtw88/fw.c
 create mode 100644 drivers/net/wireless/realtek/rtw88/fw.h
 create mode 100644 drivers/net/wireless/realtek/rtw88/hci.h
 create mode 100644 drivers/net/wireless/realtek/rtw88/mac.c
 create mode 100644 drivers/net/wireless/realtek/rtw88/mac.h
 create mode 100644 drivers/net/wireless/realtek/rtw88/mac80211.c
 create mode 100644 drivers/net/wireless/realtek/rtw88/main.c
 create mode 100644 drivers/net/wireless/realtek/rtw88/main.h
 create mode 100644 drivers/net/wireless/realtek/rtw88/pci.c
 create mode 100644 drivers/net/wireless/realtek/rtw88/pci.h
 create mode 100644 drivers/net/wireless/realtek/rtw88/phy.c
 create mode 100644 drivers/net/wireless/realtek/rtw88/phy.h
 create mode 100644 drivers/net/wireless/realtek/rtw88/ps.c
 create mode 100644 drivers/net/wireless/realtek/rtw88/ps.h
 create mode 100644 drivers/net/wireless/realtek/rtw88/reg.h
 create mode 100644 drivers/net/wireless/realtek/rtw88/regd.c
 create mode 100644 drivers/net/wireless/realtek/rtw88/regd.h
 create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8822b.c
 create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8822b.h
 create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8822b_table.c
 create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8822b_table.h
 create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8822c.c
 create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8822c.h
 create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8822c_table.c
 create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8822c_table.h
 create mode 100644 drivers/net/wireless/realtek/rtw88/rx.c
 create mode 100644 drivers/net/wireless/realtek/rtw88/rx.h
 create mode 100644 drivers/net/wireless/realtek/rtw88/sec.c
 create mode 100644 drivers/net/wireless/realtek/rtw88/sec.h
 create mode 100644 drivers/net/wireless/realtek/rtw88/tx.c
 create mode 100644 drivers/net/wireless/realtek/rtw88/tx.h
 create mode 100644 drivers/net/wireless/realtek/rtw88/util.c
 create mode 100644 drivers/net/wireless/realtek/rtw88/util.h
