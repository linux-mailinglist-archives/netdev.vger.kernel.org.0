Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AFF92B9854
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 17:46:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727435AbgKSQmt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 11:42:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725877AbgKSQms (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 11:42:48 -0500
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6206AC0613CF;
        Thu, 19 Nov 2020 08:42:48 -0800 (PST)
Received: by mail-lj1-x243.google.com with SMTP id l10so6944622lji.4;
        Thu, 19 Nov 2020 08:42:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=MPuQBBQOEb6QOhMQvVv4jBymuLz/o0p4TC6CwXfIIC8=;
        b=rqbbYnI8YkMbbmq6+66NC7UUqghBPrqgBDpNdQFGJ58K7PASjEq0ogHU3Ucm0mCL2f
         35q45RmkCSn8vC8Zc6g9amUDGM2rFS19wilZuPoVwYEKxghC+fiGDqymJo7jRPTq3/nk
         +wytYxgM5up4Djx++rsFOf/njw3pB9fRGP4rbepy41Rm4YPov9jBLQk91vbl+11/PvwO
         RzdZPiqv7Fo62GXbFvTzi01Pc4VYe6LQ7EwBBxhfWj3dO4Fv3DBsjuVFlPRTZdn1Ujc5
         izZX02LKCl5T/LR3yi45i9nk6dEwoo3IlwR5LxXsojmzG7OUVEHhPSEUfJ0Shlkhw3i5
         sOfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=MPuQBBQOEb6QOhMQvVv4jBymuLz/o0p4TC6CwXfIIC8=;
        b=r9mwhE1M4xrjxPzkiFQYjteAjk85PsTRGWV3R/OZwRU9mEIYGqL+Hc/A+nHz/gTxbo
         ZVMilAM3XpPhlYEe/doD66nWnMjbaeZS7vFUGK6BLjaCazcaNKQ1Vj/nMQ8L12LjWp5j
         DLcq4WC+A4EpOsVnSL70MAcCRoD4BwPjtJteF83/iPJhfjUwQEd3YmNq3vKXTxTzyyis
         R6z3AInaRo93BNacEu4Js49bsuVrey1Q/iNLkImAJuz3e3p4Q4aVXUeQ0T6awSHSFqbq
         +RXkXaubxYBy3uU++QYlDcXa7rpS5oXCWNRHVusx2lyCwYGB7kKYtLEpw9fVlgsNFD/0
         HAcA==
X-Gm-Message-State: AOAM533flamMwFvg/8m6grrZlB58CS6H+5p62FR6snQG3S4Mn2KxQxs4
        CF0UJvxFw5wBjwMi5IRcYl986QnIfH4srsPefx0=
X-Google-Smtp-Source: ABdhPJzNbFbTtfE+OI93zslJv5cNMRg82btWpKjPorr6N8rBh0UyvLZ3Wa12lskqCMbLcE1+s8B2ljmZb2my07cBLF8=
X-Received: by 2002:a05:651c:2111:: with SMTP id a17mr6732126ljq.220.1605804166699;
 Thu, 19 Nov 2020 08:42:46 -0800 (PST)
MIME-Version: 1.0
From:   Gonsolo <gonsolo@gmail.com>
Date:   Thu, 19 Nov 2020 17:42:34 +0100
Message-ID: <CANL0fFQqsGU01Z8iEhznDLQjw5huayarNoqbJ8Nikujs0r+ecQ@mail.gmail.com>
Subject: Wifi hangs
To:     Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Mordechay Goodstein <mordechay.goodstein@intel.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Waiman Long <longman@redhat.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi!

Sporadically my wifi hangs. Any idea why?
This is on a 5.10.0-051000rc2-lowlatency kernel from
https://kernel.ubuntu.com/~kernel-ppa/mainline.
I have to stop and start the device to make it work again.
From dmesg:

[  +0,000101] ------------[ cut here ]------------
[  +0,000002] TX on unused queue 5
[  +0,000049] WARNING: CPU: 2 PID: 20577 at
drivers/net/wireless/intel/iwlwifi/pcie/tx.c:1927
iwl_trans_pcie_tx+0x676/0x7f0 [iwlwifi]
[  +0,000003] Modules linked in: dvb_usb_af9035 uas usb_storage
dvb_usb_v2 dvb_core rfcomm ccm snd_seq_dummy snd_hrtimer cmac
algif_hash algif_skcipher af_alg bnep binfmt_misc nls_iso8859_1
snd_hda_codec_hdmi intel_rapl_msr snd_hda_codec_realtek
snd_hda_codec_generic snd_hda_intel snd_intel_dspcfg snd_hda_codec
snd_hda_core snd_hwdep pn544_mei mei_phy pn544 cdc_mbim
intel_rapl_common snd_pcm x86_pkg_temp_thermal intel_powerclamp
coretemp hci snd_seq_midi cdc_wdm qcserial kvm_intel nfc
snd_seq_midi_event usb_wwan mei_hdcp dell_laptop kvm ledtrig_audio
cdc_ncm usbserial snd_rawmidi cdc_ether crct10dif_pclmul usbnet
ghash_clmulni_intel mii dell_smm_hwmon iwlmvm mac80211 libarc4
aesni_intel crypto_simd uvcvideo videobuf2_vmalloc iwlwifi cryptd
glue_helper rapl intel_cstate snd_seq btusb btrtl btbcm
videobuf2_memops i915 btintel bluetooth videobuf2_v4l2
videobuf2_common snd_seq_device videodev dell_wmi snd_timer input_leds
joydev dell_smbios mc dcdbas ecdh_generic ecc sparse_keymap cfg80211
[  +0,000079]  serio_raw at24 wmi_bmof dell_wmi_descriptor efi_pstore
snd drm_kms_helper cec rc_core mei_me i2c_algo_bit fb_sys_fops
syscopyarea sysfillrect mei soundcore sysimgblt dell_rbtn mac_hid
sch_fq_codel parport_pc ppdev lp drm parport ip_tables x_tables
autofs4 hid_logitech_hidpp hid_logitech_dj hid_generic usbhid hid
sdhci_pci crc32_pclmul i2c_i801 psmouse cqhci i2c_smbus sdhci ahci
libahci lpc_ich e1000e xhci_pci wmi xhci_pci_renesas video [last
unloaded: dvb_usb_af9035]
[  +0,000049] CPU: 2 PID: 20577 Comm: kworker/2:1 Not tainted
5.10.0-051000rc2-lowlatency #202011012330
[  +0,000001] Hardware name: Dell Inc. Latitude E7240/0R6F3F, BIOS A29
06/13/2019
[  +0,000029] Workqueue: events cfg80211_rfkill_block_work [cfg80211]
[  +0,000013] RIP: 0010:iwl_trans_pcie_tx+0x676/0x7f0 [iwlwifi]
[  +0,000005] Code: 3d 03 5e 03 00 00 b8 ea ff ff ff 0f 85 eb fc ff ff
44 89 fe 48 c7 c7 5d b5 d3 c0 89 45 d0 c6 05 e4 5d 03 00 01 e8 7b 5d
4b c4 <0f> 0b 8b 45 d0 e9 c8 fc ff ff 41 0f b6 86 80 00 00 00 83 e0 60
3c
[  +0,000002] RSP: 0018:ffffaf8f00e1f680 EFLAGS: 00010282
[  +0,000002] RAX: 0000000000000000 RBX: ffff9b8c8d0d0900 RCX: ffff9b8e96b18988
[  +0,000001] RDX: 00000000ffffffd8 RSI: 0000000000000027 RDI: ffff9b8e96b18980
[  +0,000001] RBP: ffffaf8f00e1f6e0 R08: 0000000000000000 R09: ffffaf8f00e1f470
[  +0,000002] R10: ffffaf8f00e1f468 R11: ffffffff86353c28 R12: ffff9b8d823243e8
[  +0,000001] R13: 0000000000000037 R14: 0000000000000005 R15: 0000000000000005
[  +0,000002] FS:  0000000000000000(0000) GS:ffff9b8e96b00000(0000)
knlGS:0000000000000000
[  +0,000002] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  +0,000001] CR2: 00003a4e0b5b3080 CR3: 0000000105a0c002 CR4: 00000000001706e0
[  +0,000002] Call Trace:
[  +0,000020]  iwl_mvm_tx_mpdu+0x1e0/0x590 [iwlmvm]
[  +0,000011]  iwl_mvm_tx_skb_sta+0x153/0x1e0 [iwlmvm]
[  +0,000008]  iwl_mvm_tx_skb+0x1c/0x40 [iwlmvm]
[  +0,000008]  iwl_mvm_mac_itxq_xmit+0x7a/0xe0 [iwlmvm]
[  +0,000010]  iwl_mvm_mac_wake_tx_queue+0x29/0x80 [iwlmvm]
[  +0,000029]  drv_wake_tx_queue+0x51/0xe0 [mac80211]
[  +0,000023]  ieee80211_queue_skb+0x15b/0x220 [mac80211]
[  +0,000035]  ieee80211_tx+0xd6/0x140 [mac80211]
[  +0,000025]  ieee80211_xmit+0xb8/0xf0 [mac80211]
[  +0,000024]  __ieee80211_tx_skb_tid_band+0x6d/0x80 [mac80211]
[  +0,000022]  ieee80211_send_deauth_disassoc+0xff/0x130 [mac80211]
[  +0,000024]  ieee80211_set_disassoc+0x3ae/0x4b0 [mac80211]
[  +0,000027]  ieee80211_mgd_deauth+0x106/0x300 [mac80211]
[  +0,000004]  ? __update_blocked_fair+0xda/0x3f0
[  +0,000004]  ? acpi_ut_delete_object_desc+0xa2/0xa6
[  +0,000022]  ieee80211_deauth+0x18/0x20 [mac80211]
[  +0,000028]  cfg80211_mlme_deauth+0xb2/0x1e0 [cfg80211]
[  +0,000022]  cfg80211_mlme_down+0x64/0x80 [cfg80211]
[  +0,000021]  cfg80211_disconnect+0x157/0x210 [cfg80211]
[  +0,000021]  __cfg80211_leave+0x133/0x1b0 [cfg80211]
[  +0,000020]  cfg80211_netdev_notifier_call+0x1bf/0x5c0 [cfg80211]
[  +0,000009]  ? iwl_mvm_nic_error+0x40/0x40 [iwlmvm]
[  +0,000011]  ? iwl_mvm_send_cmd_pdu+0x54/0x90 [iwlmvm]
[  +0,000009]  ? iwl_mvm_send_cmd+0x1f/0x50 [iwlmvm]
[  +0,000008]  ? iwl_mvm_mc_iface_iterator+0xb9/0xe0 [iwlmvm]
[  +0,000023]  ? __iterate_interfaces+0xa2/0x100 [mac80211]
[  +0,000008]  ? iwl_mvm_set_tim+0x50/0x50 [iwlmvm]
[  +0,000009]  ? iwl_mvm_set_tim+0x50/0x50 [iwlmvm]
[  +0,000024]  ? ieee80211_iterate_active_interfaces_atomic+0x38/0x50 [mac80211]
[  +0,000006]  ? rtnl_is_locked+0x15/0x20
[  +0,000004]  ? inetdev_event+0x34/0x400
[  +0,000006]  raw_notifier_call_chain+0x49/0x60
[  +0,000003]  call_netdevice_notifiers_info+0x50/0x90
[  +0,000004]  __dev_close_many+0x5e/0x110
[  +0,000002]  dev_close_many+0x85/0x130
[  +0,000003]  dev_close+0x5e/0x80
[  +0,000021]  cfg80211_shutdown_all_interfaces+0x77/0xd0 [cfg80211]
[  +0,000017]  cfg80211_rfkill_block_work+0x1e/0x30 [cfg80211]
[  +0,000006]  process_one_work+0x1e3/0x3b0
[  +0,000003]  worker_thread+0x4d/0x350
[  +0,000003]  ? rescuer_thread+0x390/0x390
[  +0,000003]  kthread+0x145/0x170
[  +0,000002]  ? __kthread_bind_mask+0x70/0x70
[  +0,000004]  ret_from_fork+0x22/0x30
[  +0,000005] CPU: 2 PID: 20577 Comm: kworker/2:1 Not tainted
5.10.0-051000rc2-lowlatency #202011012330
[  +0,000002] Hardware name: Dell Inc. Latitude E7240/0R6F3F, BIOS A29
06/13/2019
[  +0,000018] Workqueue: events cfg80211_rfkill_block_work [cfg80211]
[  +0,000002] Call Trace:
[  +0,000005]  show_stack+0x52/0x58
[  +0,000003]  dump_stack+0x70/0x8b
[  +0,000013]  ? iwl_trans_pcie_tx+0x676/0x7f0 [iwlwifi]
[  +0,000004]  __warn.cold+0x24/0x77
[  +0,000011]  ? iwl_trans_pcie_tx+0x676/0x7f0 [iwlwifi]
[  +0,000003]  report_bug+0xa1/0xc0
[  +0,000006]  handle_bug+0x3e/0xa0
[  +0,000002]  exc_invalid_op+0x19/0x70
[  +0,000004]  asm_exc_invalid_op+0x12/0x20
[  +0,000011] RIP: 0010:iwl_trans_pcie_tx+0x676/0x7f0 [iwlwifi]
[  +0,000003] Code: 3d 03 5e 03 00 00 b8 ea ff ff ff 0f 85 eb fc ff ff
44 89 fe 48 c7 c7 5d b5 d3 c0 89 45 d0 c6 05 e4 5d 03 00 01 e8 7b 5d
4b c4 <0f> 0b 8b 45 d0 e9 c8 fc ff ff 41 0f b6 86 80 00 00 00 83 e0 60
3c
[  +0,000002] RSP: 0018:ffffaf8f00e1f680 EFLAGS: 00010282
[  +0,000002] RAX: 0000000000000000 RBX: ffff9b8c8d0d0900 RCX: ffff9b8e96b18988
[  +0,000001] RDX: 00000000ffffffd8 RSI: 0000000000000027 RDI: ffff9b8e96b18980
[  +0,000002] RBP: ffffaf8f00e1f6e0 R08: 0000000000000000 R09: ffffaf8f00e1f470
[  +0,000001] R10: ffffaf8f00e1f468 R11: ffffffff86353c28 R12: ffff9b8d823243e8
[  +0,000001] R13: 0000000000000037 R14: 0000000000000005 R15: 0000000000000005
[  +0,000013]  iwl_mvm_tx_mpdu+0x1e0/0x590 [iwlmvm]
[  +0,000012]  iwl_mvm_tx_skb_sta+0x153/0x1e0 [iwlmvm]
[  +0,000009]  iwl_mvm_tx_skb+0x1c/0x40 [iwlmvm]
[  +0,000009]  iwl_mvm_mac_itxq_xmit+0x7a/0xe0 [iwlmvm]
[  +0,000008]  iwl_mvm_mac_wake_tx_queue+0x29/0x80 [iwlmvm]
[  +0,000021]  drv_wake_tx_queue+0x51/0xe0 [mac80211]
[  +0,000021]  ieee80211_queue_skb+0x15b/0x220 [mac80211]
[  +0,000025]  ieee80211_tx+0xd6/0x140 [mac80211]
[  +0,000023]  ieee80211_xmit+0xb8/0xf0 [mac80211]
[  +0,000021]  __ieee80211_tx_skb_tid_band+0x6d/0x80 [mac80211]
[  +0,000025]  ieee80211_send_deauth_disassoc+0xff/0x130 [mac80211]
[  +0,000026]  ieee80211_set_disassoc+0x3ae/0x4b0 [mac80211]
[  +0,000023]  ieee80211_mgd_deauth+0x106/0x300 [mac80211]
[  +0,000004]  ? __update_blocked_fair+0xda/0x3f0
[  +0,000003]  ? acpi_ut_delete_object_desc+0xa2/0xa6
[  +0,000024]  ieee80211_deauth+0x18/0x20 [mac80211]
[  +0,000022]  cfg80211_mlme_deauth+0xb2/0x1e0 [cfg80211]
[  +0,000021]  cfg80211_mlme_down+0x64/0x80 [cfg80211]
[  +0,000025]  cfg80211_disconnect+0x157/0x210 [cfg80211]
[  +0,000019]  __cfg80211_leave+0x133/0x1b0 [cfg80211]
[  +0,000017]  cfg80211_netdev_notifier_call+0x1bf/0x5c0 [cfg80211]
[  +0,000011]  ? iwl_mvm_nic_error+0x40/0x40 [iwlmvm]
[  +0,000009]  ? iwl_mvm_send_cmd_pdu+0x54/0x90 [iwlmvm]
[  +0,000009]  ? iwl_mvm_send_cmd+0x1f/0x50 [iwlmvm]
[  +0,000008]  ? iwl_mvm_mc_iface_iterator+0xb9/0xe0 [iwlmvm]
[  +0,000022]  ? __iterate_interfaces+0xa2/0x100 [mac80211]
[  +0,000008]  ? iwl_mvm_set_tim+0x50/0x50 [iwlmvm]
[  +0,000008]  ? iwl_mvm_set_tim+0x50/0x50 [iwlmvm]
[  +0,000024]  ? ieee80211_iterate_active_interfaces_atomic+0x38/0x50 [mac80211]
[  +0,000004]  ? rtnl_is_locked+0x15/0x20
[  +0,000003]  ? inetdev_event+0x34/0x400
[  +0,000004]  raw_notifier_call_chain+0x49/0x60
[  +0,000004]  call_netdevice_notifiers_info+0x50/0x90
[  +0,000004]  __dev_close_many+0x5e/0x110
[  +0,000003]  dev_close_many+0x85/0x130
[  +0,000003]  dev_close+0x5e/0x80
[  +0,000020]  cfg80211_shutdown_all_interfaces+0x77/0xd0 [cfg80211]
[  +0,000018]  cfg80211_rfkill_block_work+0x1e/0x30 [cfg80211]
[  +0,000004]  process_one_work+0x1e3/0x3b0
[  +0,000004]  worker_thread+0x4d/0x350
[  +0,000003]  ? rescuer_thread+0x390/0x390
[  +0,000002]  kthread+0x145/0x170
[  +0,000003]  ? __kthread_bind_mask+0x70/0x70
[  +0,000004]  ret_from_fork+0x22/0x30
[  +0,000012] ---[ end trace db8dbd78d4c68899 ]---
[  +0,100513] ------------[ cut here ]------------
[  +0,000003] Timeout waiting for hardware access (CSR_GP_CNTRL 0x000003d8)
[  +0,000038] WARNING: CPU: 2 PID: 20577 at
drivers/net/wireless/intel/iwlwifi/pcie/trans.c:2067
iwl_trans_pcie_grab_nic_access+0x1bd/0x1f0 [iwlwifi]
[  +0,000001] Modules linked in: dvb_usb_af9035 uas usb_storage
dvb_usb_v2 dvb_core rfcomm ccm snd_seq_dummy snd_hrtimer cmac
algif_hash algif_skcipher af_alg bnep binfmt_misc nls_iso8859_1
snd_hda_codec_hdmi intel_rapl_msr snd_hda_codec_realtek
snd_hda_codec_generic snd_hda_intel snd_intel_dspcfg snd_hda_codec
snd_hda_core snd_hwdep pn544_mei mei_phy pn544 cdc_mbim
intel_rapl_common snd_pcm x86_pkg_temp_thermal intel_powerclamp
coretemp hci snd_seq_midi cdc_wdm qcserial kvm_intel nfc
snd_seq_midi_event usb_wwan mei_hdcp dell_laptop kvm ledtrig_audio
cdc_ncm usbserial snd_rawmidi cdc_ether crct10dif_pclmul usbnet
ghash_clmulni_intel mii dell_smm_hwmon iwlmvm mac80211 libarc4
aesni_intel crypto_simd uvcvideo videobuf2_vmalloc iwlwifi cryptd
glue_helper rapl intel_cstate snd_seq btusb btrtl btbcm
videobuf2_memops i915 btintel bluetooth videobuf2_v4l2
videobuf2_common snd_seq_device videodev dell_wmi snd_timer input_leds
joydev dell_smbios mc dcdbas ecdh_generic ecc sparse_keymap cfg80211
[  +0,000043]  serio_raw at24 wmi_bmof dell_wmi_descriptor efi_pstore
snd drm_kms_helper cec rc_core mei_me i2c_algo_bit fb_sys_fops
syscopyarea sysfillrect mei soundcore sysimgblt dell_rbtn mac_hid
sch_fq_codel parport_pc ppdev lp drm parport ip_tables x_tables
autofs4 hid_logitech_hidpp hid_logitech_dj hid_generic usbhid hid
sdhci_pci crc32_pclmul i2c_i801 psmouse cqhci i2c_smbus sdhci ahci
libahci lpc_ich e1000e xhci_pci wmi xhci_pci_renesas video [last
unloaded: dvb_usb_af9035]
[  +0,000027] CPU: 2 PID: 20577 Comm: kworker/2:1 Tainted: G        W
       5.10.0-051000rc2-lowlatency #202011012330
[  +0,000001] Hardware name: Dell Inc. Latitude E7240/0R6F3F, BIOS A29
06/13/2019
[  +0,000026] Workqueue: events cfg80211_rfkill_block_work [cfg80211]
[  +0,000009] RIP: 0010:iwl_trans_pcie_grab_nic_access+0x1bd/0x1f0 [iwlwifi]
[  +0,000001] Code: 85 c5 49 8d 57 08 bf 00 20 00 00 e8 0d bf 9a c3 e9
35 ff ff ff 89 c6 48 c7 c7 20 ea d3 c0 c6 05 93 25 03 00 01 e8 24 25
4b c4 <0f> 0b e9 f0 fe ff ff 49 8b 7c 24 38 48 c7 c1 88 ea d3 c0 31 d2
31
[  +0,000001] RSP: 0018:ffffaf8f00e1fb80 EFLAGS: 00010082
[  +0,000001] RAX: 0000000000000000 RBX: ffffaf8f00e1fbb8 RCX: ffff9b8e96b18988
[  +0,000001] RDX: 00000000ffffffd8 RSI: 0000000000000027 RDI: ffff9b8e96b18980
[  +0,000001] RBP: ffffaf8f00e1fba8 R08: 0000000000000000 R09: ffffaf8f00e1f970
[  +0,000001] R10: ffffaf8f00e1f968 R11: ffffffff86353c28 R12: ffff9b8d895f8018
[  +0,000000] R13: 0000000000000000 R14: ffff9b8d895fa6f4 R15: 00000000000003d8
[  +0,000002] FS:  0000000000000000(0000) GS:ffff9b8e96b00000(0000)
knlGS:0000000000000000
[  +0,000000] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  +0,000001] CR2: 00003a4e0b5b3080 CR3: 0000000103918004 CR4: 00000000001706e0
[  +0,000001] Call Trace:
[  +0,000007]  iwl_set_bits_prph+0x3a/0x90 [iwlwifi]
[  +0,000008]  iwl_fw_dbg_stop_restart_recording.part.0+0x234/0x260 [iwlwifi]
[  +0,000003]  ? __cancel_work_timer+0x109/0x190
[  +0,000008]  iwl_fw_dbg_stop_sync+0x46/0x50 [iwlwifi]
[  +0,000009]  __iwl_mvm_mac_stop+0x8c/0x170 [iwlmvm]
[  +0,000004]  iwl_mvm_mac_stop+0x77/0x90 [iwlmvm]
[  +0,000022]  drv_stop+0x32/0x110 [mac80211]
[  +0,000014]  ieee80211_stop_device+0x46/0x50 [mac80211]
[  +0,000012]  ieee80211_do_stop+0x551/0x860 [mac80211]
[  +0,000003]  ? _raw_spin_unlock_bh+0x1e/0x20
[  +0,000012]  ieee80211_stop+0x1a/0x20 [mac80211]
[  +0,000002]  __dev_close_many+0x9d/0x110
[  +0,000002]  dev_close_many+0x85/0x130
[  +0,000002]  dev_close+0x5e/0x80
[  +0,000011]  cfg80211_shutdown_all_interfaces+0x77/0xd0 [cfg80211]
[  +0,000010]  cfg80211_rfkill_block_work+0x1e/0x30 [cfg80211]
[  +0,000002]  process_one_work+0x1e3/0x3b0
[  +0,000002]  worker_thread+0x4d/0x350
[  +0,000002]  ? rescuer_thread+0x390/0x390
[  +0,000002]  kthread+0x145/0x170
[  +0,000001]  ? __kthread_bind_mask+0x70/0x70
[  +0,000003]  ret_from_fork+0x22/0x30
[  +0,000002] CPU: 2 PID: 20577 Comm: kworker/2:1 Tainted: G        W
       5.10.0-051000rc2-lowlatency #202011012330
[  +0,000001] Hardware name: Dell Inc. Latitude E7240/0R6F3F, BIOS A29
06/13/2019
[  +0,000010] Workqueue: events cfg80211_rfkill_block_work [cfg80211]
[  +0,000001] Call Trace:
[  +0,000002]  show_stack+0x52/0x58
[  +0,000002]  dump_stack+0x70/0x8b
[  +0,000007]  ? iwl_trans_pcie_grab_nic_access+0x1bd/0x1f0 [iwlwifi]
[  +0,000002]  __warn.cold+0x24/0x77
[  +0,000007]  ? iwl_trans_pcie_grab_nic_access+0x1bd/0x1f0 [iwlwifi]
[  +0,000002]  report_bug+0xa1/0xc0
[  +0,000015]  handle_bug+0x3e/0xa0
[  +0,000001]  exc_invalid_op+0x19/0x70
[  +0,000002]  asm_exc_invalid_op+0x12/0x20
[  +0,000007] RIP: 0010:iwl_trans_pcie_grab_nic_access+0x1bd/0x1f0 [iwlwifi]
[  +0,000001] Code: 85 c5 49 8d 57 08 bf 00 20 00 00 e8 0d bf 9a c3 e9
35 ff ff ff 89 c6 48 c7 c7 20 ea d3 c0 c6 05 93 25 03 00 01 e8 24 25
4b c4 <0f> 0b e9 f0 fe ff ff 49 8b 7c 24 38 48 c7 c1 88 ea d3 c0 31 d2
31
[  +0,000001] RSP: 0018:ffffaf8f00e1fb80 EFLAGS: 00010082
[  +0,000002] RAX: 0000000000000000 RBX: ffffaf8f00e1fbb8 RCX: ffff9b8e96b18988
[  +0,000000] RDX: 00000000ffffffd8 RSI: 0000000000000027 RDI: ffff9b8e96b18980
[  +0,000001] RBP: ffffaf8f00e1fba8 R08: 0000000000000000 R09: ffffaf8f00e1f970
[  +0,000001] R10: ffffaf8f00e1f968 R11: ffffffff86353c28 R12: ffff9b8d895f8018
[  +0,000001] R13: 0000000000000000 R14: ffff9b8d895fa6f4 R15: 00000000000003d8
[  +0,000007]  iwl_set_bits_prph+0x3a/0x90 [iwlwifi]
[  +0,000008]  iwl_fw_dbg_stop_restart_recording.part.0+0x234/0x260 [iwlwifi]
[  +0,000002]  ? __cancel_work_timer+0x109/0x190
[  +0,000016]  iwl_fw_dbg_stop_sync+0x46/0x50 [iwlwifi]
[  +0,000006]  __iwl_mvm_mac_stop+0x8c/0x170 [iwlmvm]
[  +0,000004]  iwl_mvm_mac_stop+0x77/0x90 [iwlmvm]
[  +0,000012]  drv_stop+0x32/0x110 [mac80211]
[  +0,000015]  ieee80211_stop_device+0x46/0x50 [mac80211]
[  +0,000012]  ieee80211_do_stop+0x551/0x860 [mac80211]
[  +0,000002]  ? _raw_spin_unlock_bh+0x1e/0x20
[  +0,000013]  ieee80211_stop+0x1a/0x20 [mac80211]
[  +0,000002]  __dev_close_many+0x9d/0x110
[  +0,000001]  dev_close_many+0x85/0x130
[  +0,000002]  dev_close+0x5e/0x80
[  +0,000011]  cfg80211_shutdown_all_interfaces+0x77/0xd0 [cfg80211]
[  +0,000010]  cfg80211_rfkill_block_work+0x1e/0x30 [cfg80211]
[  +0,000002]  process_one_work+0x1e3/0x3b0
[  +0,000002]  worker_thread+0x4d/0x350
[  +0,000002]  ? rescuer_thread+0x390/0x390
[  +0,000001]  kthread+0x145/0x170
[  +0,000002]  ? __kthread_bind_mask+0x70/0x70
[  +0,000001]  ret_from_fork+0x22/0x30
[  +0,000002] ---[ end trace db8dbd78d4c6889a ]---
[  +0,000003] iwlwifi 0000:02:00.0: iwlwifi transaction failed,
dumping registers
[  +0,000003] iwlwifi 0000:02:00.0: iwlwifi device config registers:
[  +0,000241] iwlwifi 0000:02:00.0: 00000000: 08b18086 00100406
02800073 00000010 f7d00004 00000000 00000000 00000000
[  +0,000002] iwlwifi 0000:02:00.0: 00000020: 00000000 00000000
00000000 44708086 00000000 000000c8 00000000 0000010a
[  +0,000002] iwlwifi 0000:02:00.0: 00000040: 00020010 10008ec0
00100c00 0006ec11 10110042 00000000 00000000 00000000
[  +0,000002] iwlwifi 0000:02:00.0: 00000060: 00000000 00080812
00000405 00000000 00010001 00000000 00000000 00000000
[  +0,000002] iwlwifi 0000:02:00.0: 00000080: 00000000 00000000
00000000 00000000 00000000 00000000 00000000 00000000
[  +0,000001] iwlwifi 0000:02:00.0: 000000a0: 00000000 00000000
00000000 00000000 00000000 00000000 00000000 00000000
[  +0,000002] iwlwifi 0000:02:00.0: 000000c0: 00000000 00000000
c823d001 0d000000 00814005 fee00398 00000000 00000000
[  +0,000002] iwlwifi 0000:02:00.0: 000000e0: 00000000 00000000
00000000 00000000 00000000 00000000 00000000 00000000
[  +0,000002] iwlwifi 0000:02:00.0: 00000100: 14010001 00000000
00000000 00462031 00000000 00002000 00000000 00000000
[  +0,000001] iwlwifi 0000:02:00.0: 00000120: 00000000 00000000
00000000 00000000 00000000 00000000 00000000 00000000
[  +0,000002] iwlwifi 0000:02:00.0: 00000140: 14c10003 ff680263
4851b7ff 15410018 10031003 0001000b 0141cafe 00f01e1f
[  +0,000002] iwlwifi 0000:02:00.0: iwlwifi device memory mapped registers:
[  +0,000094] iwlwifi 0000:02:00.0: 00000000: 40000000 80000000
00000080 00000000 00000000 00000000 00000000 00000000
[  +0,000001] iwlwifi 0000:02:00.0: 00000020: 00000001 000003d8
00000144 00000000 80000000 803a0000 80008040 00080042
[  +0,000053] iwlwifi 0000:02:00.0: iwlwifi device AER capability structure:
[  +0,000022] iwlwifi 0000:02:00.0: 00000000: 14010001 00000000
00000000 00462031 00000000 00002000 00000000 00000000
[  +0,000002] iwlwifi 0000:02:00.0: 00000020: 00000000 00000000 00000000
[  +0,000001] iwlwifi 0000:02:00.0: iwlwifi parent port (0000:00:1c.3)
config registers:
[  +0,000094] iwlwifi 0000:00:1c.3: 00000000: 9c168086 00100407
060400e4 00810010 00000000 00000000 00020200 000000f0
[  +0,000002] iwlwifi 0000:00:1c.3: 00000020: f7d0f7d0 0001fff1
00000000 00000000 00000000 00000040 00000000 0012040a
[  +0,000002] iwlwifi 0000:00:1c.3: 00000040: 01428010 00008000
00100000 04323c12 70110042 001cb200 01400000 00000000
[  +0,000002] iwlwifi 0000:00:1c.3: 00000060: 00000000 00000817
00000400 00000000 00010002 00000000 00000000 00000000
[  +0,000002] iwlwifi 0000:00:1c.3: 00000080: 00019005 fee00258
00000000 00000000 0000a00d 05ca1028 00000000 00000000
[  +0,000001] iwlwifi 0000:00:1c.3: 000000a0: c8030001 00000000
00000000 00000000 00000000 00000000 00000000 00000000
[  +0,000002] iwlwifi 0000:00:1c.3: 000000c0: 00000000 00000000
00000000 00000000 01000000 00001842 8b118008 00000000
[  +0,000002] iwlwifi 0000:00:1c.3: 000000e0: 00400300 8c548c54
00000015 00000000 00000050 0c000040 08050fb1 00000004
[  +0,000001] iwlwifi 0000:00:1c.3: 00000100: 20000000 00000000
00000000 00060011 00000000 00002000 00000000 00000000
[  +0,000002] iwlwifi 0000:00:1c.3: 00000120: 00000000 00000000
00000000 00000000 00000000 00000000 00000000 00000000
[  +0,000002] iwlwifi 0000:00:1c.3: 00000140: 00000000 00000000
00000000 00000000 00000000 00000000 00000000 00000000
[  +0,000001] iwlwifi 0000:00:1c.3: 00000160: 00000000 00000000
00000000 00000000 00000000 00000000 00000000 00000000
[  +0,000002] iwlwifi 0000:00:1c.3: 00000180: 00000000 00000000
00000000 00000000 00000000 00000000 00000000 00000000
[  +0,000001] iwlwifi 0000:00:1c.3: 000001a0: 00000000 00000000
00000000 00000000 00000000 00000000 00000000 00000000
[  +0,000002] iwlwifi 0000:00:1c.3: 000001c0: 00000000 00000000
00000000 00000000 00000000 00000000 00000000 00000000
[  +0,000002] iwlwifi 0000:00:1c.3: 000001e0: 00000000 00000000
00000000 00000000 00000000 00000000 00000000 00000000
[  +0,000001] iwlwifi 0000:00:1c.3: 00000200: 0001001e 0028281f 40a0281f
[  +2,028589] iwlwifi 0000:02:00.0: RF_KILL bit toggled to enable radio.
[  +0,000004] iwlwifi 0000:02:00.0: reporting RF_KILL (radio enabled)
[Nov19 17:24] wlp2s0: authenticate with 68:b6:fc:27:79:c8
[  +0,002785] wlp2s0: send auth to 68:b6:fc:27:79:c8 (try 1/3)
[  +0,002128] wlp2s0: authenticated
[  +0,000481] wlp2s0: associate with 68:b6:fc:27:79:c8 (try 1/3)
[  +0,015219] wlp2s0: RX AssocResp from 68:b6:fc:27:79:c8 (capab=0xc11
status=0 aid=7)
[  +0,001892] wlp2s0: associated
[  +0,227651] IPv6: ADDRCONF(NETDEV_CHANGE): wlp2s0: link becomes ready


-- 
g
