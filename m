Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC85EAF9E1
	for <lists+netdev@lfdr.de>; Wed, 11 Sep 2019 12:06:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727593AbfIKKGH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Sep 2019 06:06:07 -0400
Received: from mail-lf1-f43.google.com ([209.85.167.43]:37211 "EHLO
        mail-lf1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727406AbfIKKGH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Sep 2019 06:06:07 -0400
Received: by mail-lf1-f43.google.com with SMTP id w67so15949241lff.4
        for <netdev@vger.kernel.org>; Wed, 11 Sep 2019 03:06:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=8cVVOaVnq+EGb5ZyGBC6LLpINtschWfuiA7cl3+CSIs=;
        b=CylPWDGyJyFeHvIIBpvs1rRSAQjhcpPuzDb6jxpgmmFP5p0yRQE0UkIQedhN3M/soH
         0ezQ7QTtCv8AxL9UyIel9xMdHjsJAgPrR9JkpVn66T91Fh9FLJla+fydkvVv5uDHywPH
         CqEAPOWDsHV9FOCNcmzX+mv31dc/NBOHgAZjE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=8cVVOaVnq+EGb5ZyGBC6LLpINtschWfuiA7cl3+CSIs=;
        b=aBdWyXHK52Yl8Hd5AS5h1JzaweP+dUVpQu6OWqscO95/mg+P/VTeWrkH2HdVw06pTG
         x6FxeR0TU8MqQ2z0hv8LcpOxzCm+CNLniGryVkXGeqC0d1670X0X/cuIyMjFL96pjc8Y
         7mkMBLOWPVu3Krs/4J7MAvxuCQ2WXu54nLr734ofVMnVfaWytl5AKCNQbg5VoNZ16L/3
         yikoq/7MYY2nOFJhrked1UqZUCO655sU9x1rSQqAUBiVSIdK9rphbj19cDX895aPQD6u
         r2hiYUDJ9l5S/yDjT7JZaCcVSMWrR4geOov8DkobdF0+UizqS2UyRL+7g/uN908GTQs/
         a8GA==
X-Gm-Message-State: APjAAAURSImcjTk0WWyGlIk0h3juDr1J4D1VxQB/PyyD5F876/FLcfyp
        SLHUWyf+r6bWVYe3HOMu4CvLFNHvXFrhSw==
X-Google-Smtp-Source: APXvYqyYKVm3l6+T8HbKy8htKz+nQPjBuUhYVOMxRQ/e4UF8ZmXnqYSnAHNXvSH9ilogNiCgVTwjlg==
X-Received: by 2002:a19:f019:: with SMTP id p25mr23979625lfc.9.1568196364098;
        Wed, 11 Sep 2019 03:06:04 -0700 (PDT)
Received: from mail-lj1-f175.google.com (mail-lj1-f175.google.com. [209.85.208.175])
        by smtp.gmail.com with ESMTPSA id z21sm4542783ljn.100.2019.09.11.03.06.03
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Sep 2019 03:06:03 -0700 (PDT)
Received: by mail-lj1-f175.google.com with SMTP id d5so19397571lja.10
        for <netdev@vger.kernel.org>; Wed, 11 Sep 2019 03:06:03 -0700 (PDT)
X-Received: by 2002:a05:651c:103c:: with SMTP id w28mr7786494ljm.90.1568196362260;
 Wed, 11 Sep 2019 03:06:02 -0700 (PDT)
MIME-Version: 1.0
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 11 Sep 2019 11:05:46 +0100
X-Gmail-Original-Message-ID: <CAHk-=wgBuu8PiYpD7uWgxTSY8aUOJj6NJ=ivNQPYjAKO=cRinA@mail.gmail.com>
Message-ID: <CAHk-=wgBuu8PiYpD7uWgxTSY8aUOJj6NJ=ivNQPYjAKO=cRinA@mail.gmail.com>
Subject: WARNING at net/mac80211/sta_info.c:1057 (__sta_info_destroy_part2())
To:     Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-wireless@vger.kernel.org, Netdev <netdev@vger.kernel.org>,
        Linux List Kernel Mailing <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

So I'm at LCA, reading email, using my laptop more than I normally do,
and with different networking than I normally do.

And I just had a 802.11 WARN_ON() trigger, followed by essentially a
dead machine due to some lock held (maybe rtnl_lock).

It's possible that the lock held thing happened before, and is the
_reason_ for the delay, I don't know. I had to reboot the machine, but
I gathered as much information as made sense and was obvious before I
did so. That's appended.

                 Linus

---
Selected dmesg from the WARN_ON_ONCE() and just before, followed by
info from "sysrq-w":

Previous resume looks normal:

   PM: suspend exit
   ath10k_pci 0000:02:00.0: UART prints enabled
   ath10k_pci 0000:02:00.0: unsupported HTC service id: 1536
   wlp2s0: authenticate with 54:ec:2f:05:70:2c
   wlp2s0: send auth to 54:ec:2f:05:70:2c (try 1/3)
   wlp2s0: send auth to 54:ec:2f:05:70:2c (try 2/3)
   wlp2s0: send auth to 54:ec:2f:05:70:2c (try 3/3)
   wlp2s0: authentication with 54:ec:2f:05:70:2c timed out
   wlp2s0: authenticate with 54:ec:2f:05:70:28
   wlp2s0: send auth to 54:ec:2f:05:70:28 (try 1/3)
   wlp2s0: authenticated
   wlp2s0: associate with 54:ec:2f:05:70:28 (try 1/3)
   wlp2s0: RX AssocResp from 54:ec:2f:05:70:28 (capab=0x1431 status=0 aid=1)
   wlp2s0: associated
   wlp2s0: Limiting TX power to 20 (20 - 0) dBm as advertised by
54:ec:2f:05:70:28
   ath: EEPROM regdomain: 0x826c
   ath: EEPROM indicates we should expect a country code
   ath: doing EEPROM country->regdmn map search
   ath: country maps to regdmn code: 0x37
   ath: Country alpha2 being used: PT
   ath: Regpair used: 0x37
   ath: regdomain 0x826c dynamically updated by country element
   IPv6: ADDRCONF(NETDEV_CHANGE): wlp2s0: link becomes ready
   wlp2s0: disconnect from AP 54:ec:2f:05:70:28 for new auth to
54:ec:2f:05:70:2c
   wlp2s0: authenticate with 54:ec:2f:05:70:2c
   wlp2s0: send auth to 54:ec:2f:05:70:2c (try 1/3)
   wlp2s0: authenticated
   wlp2s0: associate with 54:ec:2f:05:70:2c (try 1/3)
   wlp2s0: RX ReassocResp from 54:ec:2f:05:70:2c (capab=0x1011 status=0 aid=2)
   wlp2s0: associated
   ath: EEPROM regdomain: 0x826c
   ath: EEPROM indicates we should expect a country code
   ath: doing EEPROM country->regdmn map search
   ath: country maps to regdmn code: 0x37
   ath: Country alpha2 being used: PT
   ath: Regpair used: 0x37
   ath: regdomain 0x826c dynamically updated by country element
   wlp2s0: Limiting TX power to 23 (23 - 0) dBm as advertised by
54:ec:2f:05:70:2c

Another _almost_ successful suspend/resume:

   PM: suspend entry (s2idle)
   Filesystems sync: 0.028 seconds
   Freezing user space processes ... (elapsed 0.126 seconds) done.
   OOM killer disabled.
   Freezing remaining freezable tasks ... (elapsed 0.001 seconds) done.
   printk: Suspending console(s) (use no_console_suspend to debug)
   wlp2s0: deauthenticating from 54:ec:2f:05:70:2c by local choice
(Reason: 3=DEAUTH_LEAVING)
   ath10k_pci 0000:02:00.0: UART prints enabled
   ath10k_pci 0000:02:00.0: unsupported HTC service id: 1536
   OOM killer enabled.
   Restarting tasks ... done.
   PM: suspend exit
   ath10k_pci 0000:02:00.0: UART prints enabled
   ath10k_pci 0000:02:00.0: unsupported HTC service id: 1536
   wlp2s0: authenticate with 54:ec:2f:05:70:2c
   wlp2s0: send auth to 54:ec:2f:05:70:2c (try 1/3)
   wlp2s0: authenticated
   wlp2s0: associate with 54:ec:2f:05:70:2c (try 1/3)
   wlp2s0: RX AssocResp from 54:ec:2f:05:70:2c (capab=0x1011 status=0 aid=2)
   wlp2s0: associated
   wlp2s0: Limiting TX power to 23 (23 - 0) dBm as advertised by
54:ec:2f:05:70:2c
   ath: EEPROM regdomain: 0x826c
   ath: EEPROM indicates we should expect a country code
   ath: doing EEPROM country->regdmn map search
   ath: country maps to regdmn code: 0x37
   ath: Country alpha2 being used: PT
   ath: Regpair used: 0x37
   ath: regdomain 0x826c dynamically updated by country element
   IPv6: ADDRCONF(NETDEV_CHANGE): wlp2s0: link becomes ready

I say _almost_, because I don't see the "No TX power limit" for the
country lookup (yes, Portugal) this time?

But wait!

... then 10+ minutes later:

   ath10k_pci 0000:02:00.0: wmi command 16387 timeout, restarting hardware
   ath10k_pci 0000:02:00.0: failed to set 5g txpower 23: -11
   ath10k_pci 0000:02:00.0: failed to setup tx power 23: -11
   ath10k_pci 0000:02:00.0: failed to recalc tx power: -11
   ath10k_pci 0000:02:00.0: failed to set inactivity time for vdev 0: -108
   ath10k_pci 0000:02:00.0: failed to setup powersave: -108

That certainly looks like something did try to set a power limit, but
eventually failed.

Immediately after that:

   wlp2s0: deauthenticating from 54:ec:2f:05:70:2c by local choice
(Reason: 3=DEAUTH_LEAVING)
   ath10k_pci 0000:02:00.0: failed to read hi_board_data address: -16
   ath10k_pci 0000:02:00.0: failed to receive initialized event from
target: 00000000
   ath10k_pci 0000:02:00.0: failed to receive initialized event from
target: 00000000
   ath10k_pci 0000:02:00.0: failed to wait for target init: -110
   ieee80211 phy0: Hardware restart was requested
   ath10k_pci 0000:02:00.0: failed to set inactivity time for vdev 0: -108
   ath10k_pci 0000:02:00.0: failed to setup powersave: -108
   ath10k_pci 0000:02:00.0: failed to set PS Mode 0 for vdev 0: -108
   ath10k_pci 0000:02:00.0: failed to setup powersave: -108
   ath10k_pci 0000:02:00.0: failed to setup ps on vdev 0: -108
   ath10k_pci 0000:02:00.0: failed to flush transmit queue (skip 1
ar-state 2): 5000
   ath10k_pci 0000:02:00.0: failed to delete peer 54:ec:2f:05:70:2c
for vdev 0: -108

and this then results in:

   WARNING: CPU: 4 PID: 1246 at net/mac80211/sta_info.c:1057
__sta_info_destroy_part2+0x147/0x150 [mac80211]
   Modules linked in: ccm fuse rfcomm xt_CHECKSUM xt_MASQUERADE tun
bridge stp llc nf_conntrack_netbios_ns nf_conntrack_broadcast xt_CT
ip6t_rpfilter ip6t_REJECT nf_reject_ipv6 xt_conntrack ebtable_nat
ip6table_nat ip6table_mangle ip6table_raw ip6table_security
iptable_nat nf_nat iptable_mangle iptable_raw iptable_security
nf_conntrack nf_defrag_ipv6 libcrc32c nf_defrag_ipv4 ip_set nfnetlink
ebtable_filter ebtables ip6table_filter ip6_tables cmac bnep vfat fat
hid_multitouch iTCO_wdt iTCO_vendor_support snd_hda_codec_hdmi
snd_soc_skl snd_soc_hdac_hda snd_hda_ext_core snd_hda_codec_realtek
snd_soc_core snd_hda_codec_generic snd_soc_acpi_intel_match
snd_soc_acpi snd_soc_skl_ipc snd_soc_sst_ipc snd_soc_sst_dsp
dell_laptop snd_hda_intel ledtrig_audio dell_wmi dell_smbios
x86_pkg_temp_thermal snd_hda_codec ath10k_pci intel_powerclamp
wmi_bmof dell_wmi_descriptor intel_wmi_thunderbolt snd_hwdep coretemp
ath10k_core snd_hda_core kvm_intel snd_seq ath snd_seq_device kvm
btusb btrtl
    intel_rapl_msr btbcm btintel mac80211 irqbypass snd_pcm bluetooth
intel_cstate dcdbas intel_uncore intel_rapl_perf joydev snd_timer snd
ecdh_generic i2c_i801 cfg80211 ecc idma64 soundcore rtsx_pci_ms
processor_thermal_device mei_me memstick rfkill libarc4 intel_lpss_pci
ucsi_acpi intel_soc_dts_iosf mei typec_ucsi intel_lpss
intel_pch_thermal intel_rapl_common typec wmi int3403_thermal
int340x_thermal_zone intel_hid sparse_keymap int3400_thermal acpi_pad
acpi_thermal_rel dm_crypt i915 crct10dif_pclmul crc32_pclmul
crc32c_intel rtsx_pci_sdmmc mmc_core i2c_algo_bit drm_kms_helper
syscopyarea sysfillrect sysimgblt nvme fb_sys_fops ghash_clmulni_intel
drm serio_raw nvme_core rtsx_pci i2c_hid pinctrl_cannonlake video
pinctrl_intel
   CPU: 4 PID: 1246 Comm: NetworkManager Not tainted
5.3.0-rc8-00004-g56037cadf604-dirty #5
   Hardware name: Dell Inc. XPS 13 9380/0KTW76, BIOS 1.5.0 06/03/2019
   RIP: 0010:__sta_info_destroy_part2+0x147/0x150 [mac80211]
   Code: bd 0c 01 00 00 00 0f 84 4e ff ff ff 45 31 c0 b9 01 00 00 00
48 89 ea 48 89 de 4c 89 e7 e8 e1 aa ff ff 85 c0 0f 84 30 ff ff ff <0f>
0b e9 29 ff ff ff 66 90 0f 1f 44 00 00 41 54 55 48 89 fd e8 40
   RSP: 0018:ffff98fc00daba90 EFLAGS: 00010282
   RAX: 00000000ffffff94 RBX: ffff8e1355ad2880 RCX: 0000000000000000
   RDX: ffff8e1355901ec0 RSI: 0000000000000000 RDI: ffff8e1357902e38
   RBP: ffff8e135bb08000 R08: 0000000000000000 R09: 0000000000000574
   R10: 000000000001cc5c R11: 0000000000000000 R12: ffff8e13579007a0
   R13: ffff8e1355ad2880 R14: 0000000000000001 R15: ffff8e1357900d58
   FS:  00007fbd99372bc0(0000) GS:ffff8e135e500000(0000) knlGS:0000000000000000
   CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
   CR2: 00001cdbd7408000 CR3: 00000004708a2001 CR4: 00000000003606e0
   Call Trace:
    __sta_info_flush+0x125/0x170 [mac80211]
    ieee80211_set_disassoc+0xc2/0x590 [mac80211]
    ieee80211_mgd_deauth.cold+0x4a/0x1b8 [mac80211]
    cfg80211_mlme_deauth+0xb3/0x1d0 [cfg80211]
    ? startup_64+0x3/0x30
    cfg80211_mlme_down+0x66/0x90 [cfg80211]
    cfg80211_disconnect+0x129/0x1e0 [cfg80211]
    cfg80211_leave+0x27/0x40 [cfg80211]
    cfg80211_netdev_notifier_call+0x1a7/0x4e0 [cfg80211]
    ? ieee80211_iter_chan_contexts_atomic+0x3e/0x50 [mac80211]
    ? ath10k_monitor_recalc+0x38f/0x5d0 [ath10k_core]
    ? __schedule+0x143/0x660
    ? ath10k_config_ps+0x4e/0x70 [ath10k_core]
    ? inetdev_event+0x46/0x560
    notifier_call_chain+0x4c/0x70
    __dev_close_many+0x57/0x100
    dev_close_many+0x8d/0x140
    dev_close.part.0+0x44/0x70
    cfg80211_shutdown_all_interfaces+0x71/0xd0 [cfg80211]
    cfg80211_rfkill_set_block+0x22/0x30 [cfg80211]
    rfkill_set_block+0x92/0x140 [rfkill]
    rfkill_fop_write+0x11f/0x1c0 [rfkill]
    vfs_write+0xb6/0x1a0
    ksys_write+0xa7/0xe0
    do_syscall_64+0x59/0x1c0
    entry_SYSCALL_64_after_hwframe+0x44/0xa9
   RIP: 0033:0x7fbd9a36c92f
   Code: 89 54 24 18 48 89 74 24 10 89 7c 24 08 e8 19 fd ff ff 48 8b
54 24 18 48 8b 74 24 10 41 89 c0 8b 7c 24 08 b8 01 00 00 00 0f 05 <48>
3d 00 f0 ff ff 77 2d 44 89 c7 48 89 44 24 08 e8 4c fd ff ff 48
   RSP: 002b:00007fff9a1ee220 EFLAGS: 00000293 ORIG_RAX: 0000000000000001
   RAX: ffffffffffffffda RBX: 000055f18ef5eaad RCX: 00007fbd9a36c92f
   RDX: 0000000000000008 RSI: 00007fff9a1ee258 RDI: 0000000000000019
   RBP: 0000000000000019 R08: 0000000000000000 R09: 0000000000000001
   R10: 0000000000000000 R11: 0000000000000293 R12: 000055f190502090
   R13: 0000000000000000 R14: 0000000000000000 R15: 000055f1904ffbb0
   ---[ end trace 4d7c87877e20badd ]---
   ath10k_pci 0000:02:00.0: failed to recalculate rts/cts prot for vdev 0: -108
   ath10k_pci 0000:02:00.0: failed to set cts protection for vdev 0: -108

and it looks like it leaves some lock held.

Because after this, nothing network-related stops working, and the
machine eventually dies because workqueues don't make any progress (due
to rtnl_lock, I suspect):

   Workqueue: events_freezable ieee80211_restart_work [mac80211]
   Call Trace:
    schedule+0x39/0xa0
    schedule_preempt_disabled+0xa/0x10
    __mutex_lock.isra.0+0x263/0x4b0
    ieee80211_restart_work+0x54/0xe0 [mac80211]
    process_one_work+0x1cf/0x370
    worker_thread+0x4a/0x3c0
    kthread+0xfb/0x130
    ret_from_fork+0x35/0x40

   Workqueue: events disconnect_work [cfg80211]
   Call Trace:
    schedule+0x39/0xa0
    schedule_preempt_disabled+0xa/0x10
    __mutex_lock.isra.0+0x263/0x4b0
    disconnect_work+0x12/0xd0 [cfg80211]
    process_one_work+0x1cf/0x370
    worker_thread+0x4a/0x3c0
    kthread+0xfb/0x130
    ret_from_fork+0x35/0x40
   kworker/3:0     D    0  6313      2 0x80004000


   Workqueue: events linkwatch_event
   Call Trace:
    schedule+0x39/0xa0
    schedule_preempt_disabled+0xa/0x10
    __mutex_lock.isra.0+0x263/0x4b0
    linkwatch_event+0xa/0x30
    process_one_work+0x1cf/0x370
    worker_thread+0x4a/0x3c0
    kthread+0xfb/0x130
    ret_from_fork+0x35/0x40

   ping            D    0  6619   6568 0x80000002
   Call Trace:
    schedule+0x39/0xa0
    schedule_preempt_disabled+0xa/0x10
    __mutex_lock.isra.0+0x263/0x4b0
    ip6mr_sk_done+0x2e/0xd0
    rawv6_close+0x19/0x30
    inet_release+0x34/0x60
    __sock_release+0x3d/0xa0
    sock_close+0x11/0x20
    __fput+0xc1/0x250
    task_work_run+0x81/0xa0
    do_exit+0x2e5/0xaa0
    do_group_exit+0x3a/0x90
    __x64_sys_exit_group+0x14/0x20
    do_syscall_64+0x59/0x1c0
    entry_SYSCALL_64_after_hwframe+0x44/0xa9

   gdbus           D    0  6629   1949 0x80004000
   Call Trace:
    schedule+0x39/0xa0
    do_exit+0x1da/0xaa0
    do_group_exit+0x3a/0x90
    get_signal+0x14f/0x830
    do_signal+0x36/0x620
    exit_to_usermode_loop+0x6f/0xf0
    do_syscall_64+0x17d/0x1c0
    entry_SYSCALL_64_after_hwframe+0x44/0xa9
