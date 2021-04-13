Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92FEA35E7EF
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 23:00:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344600AbhDMVAI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 17:00:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232043AbhDMVAH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Apr 2021 17:00:07 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21CE4C061574;
        Tue, 13 Apr 2021 13:59:46 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id u20so4933664wmj.0;
        Tue, 13 Apr 2021 13:59:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:from:subject:message-id:date:mime-version:content-language
         :content-transfer-encoding;
        bh=oh5f+syIH84jzV8UOwEn0uY0b+4q+kVQBHCl5OUqdaA=;
        b=h/peI7ikFaAxlgflNzPa+psG76wYLr87yZa3NfwEfYvph+WyPBceWYi+gQER1R16fy
         CCmnxbYY9MA07ppLPigIxfSjGjL1/7QbFjGcLC9AjfIKSL9eLqbSa0EaFhUS4XSluIbd
         21+B0KzFygX0S1QZHbPI4QsH6gfSCrEHCJt/Qlp5OLFxIbRBhlxfPpvWbNDTloOhA5m8
         01FpsF7LvBubZMbXDK5AfWwUtKt5ioKUWqvG4MA5zD47iYl9ighrltXEEcoURT8TOdmq
         ctn1/Wri2o0OwPgqa2wgaxdi2Pp7MLtSwIqW7Eww02mFxRV2Qa7z7N/FkVoZ/vmdSfFZ
         Ip+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:mime-version
         :content-language:content-transfer-encoding;
        bh=oh5f+syIH84jzV8UOwEn0uY0b+4q+kVQBHCl5OUqdaA=;
        b=iF/LVj/0oCc1YBkpfwJdu6H2KLDjlakgCdsIelg/ZBGArHKUy0krexejCLcIRk0Syg
         CQ7JL/WDoQ2NvW6SuafuKrE/5a82uwMPDCeArWj/84h8Sg1xpIcb2GnNJ7+PKOv6a7+3
         YwHM9fhhiL1Rx2mzWgLeCs5e+COCtoe5EO+6XXa9x07ROjd1ZYa4PPBo/kYSvvg8zGqC
         W19kUHqSa4Zjz2r0IjJka7izF1AKgk3RE7gB12rWkwt9n9dTS6dsDV+gKLuzZ8eRAlvO
         ondOINXWSqYM2bQEz4b6u6Wmboih3pp5ea/DxE3ex5h3IXfJ995jfgIwQN/cqB1KJ+1J
         jjNA==
X-Gm-Message-State: AOAM532fpyxw+SnE/sRbIVXjG578ObqLkjzW6ZQGq4PSD7c/q1R0ntXg
        z9Y0KXayOae+1gXlFT5uG+tDXxciTQ==
X-Google-Smtp-Source: ABdhPJzfp5jimmZ6JwhJuYyJubW+oVpwFpnoeaBGrzkCwela6CL2sSkJef148rDIUB21vJSyjvrrHA==
X-Received: by 2002:a7b:c0c4:: with SMTP id s4mr1766024wmh.184.1618347584663;
        Tue, 13 Apr 2021 13:59:44 -0700 (PDT)
Received: from localhost ([84.39.183.235])
        by smtp.gmail.com with ESMTPSA id w22sm3476613wmc.13.2021.04.13.13.59.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Apr 2021 13:59:44 -0700 (PDT)
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        Realtek NIC <nic_swsd@realtek.com>,
        NETDEV ML <netdev@vger.kernel.org>,
        KERNEL ML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, X86 DEV <x86@kernel.org>
From:   Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [BUG]: WARNING: CPU: 5 PID: 0 at net/sched/sch_generic.c:442
 dev_watchdog+0x24d/0x260
Message-ID: <8ab3069a-734f-80ee-49a0-34e1399d44f1@gmail.com>
Date:   Tue, 13 Apr 2021 22:59:42 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A non-recurring bug, on 5.11.12-300.fc34.x86_64 (Fedora kernel).

Thanks.


0c:00.0 Ethernet controller [0200]: Realtek Semiconductor Co., Ltd. RTL8111/8168/8411 PCI Express Gigabit Ethernet Controller [10ec:8168] (rev 06)

[    2.968280] libphy: r8169: probed
[    2.968844] r8169 0000:0c:00.0 eth0: RTL8168e/8111e, 2c:41:38:9e:98:93, XID 2c2, IRQ 47
[    2.968849] r8169 0000:0c:00.0 eth0: jumbo features [frames: 9194 bytes, tx checksumming: ko]
[    4.071966] RTL8211DN Gigabit Ethernet r8169-c00:00: attached PHY driver (mii_bus:phy_addr=r8169-c00:00, irq=IGNORE)
[    4.323834] r8169 0000:0c:00.0 eth0: Link is Down
[    6.729111] r8169 0000:0c:00.0 eth0: Link is Up - 1Gbps/Full - flow control rx/tx

[106378.638739] ------------[ cut here ]------------
[106378.638757] NETDEV WATCHDOG: eth0 (r8169): transmit queue 0 timed out
[106378.638783] WARNING: CPU: 5 PID: 0 at net/sched/sch_generic.c:442 dev_watchdog+0x24d/0x260
[106378.638796] Modules linked in: snd_hrtimer mei_hdcp pktcdvd snd_hda_codec_realtek snd_hda_codec_generic ledtrig_audio snd_hda_intel ath9k snd_intel_dspcfg soundwire_intel 
soundwire_generic_allocation ath9k_common snd_soc_core ath9k_hw snd_compress intel_rapl_msr iTCO_wdt snd_pcm_dmaengine i915 intel_rapl_common intel_pmc_bxt soundwire_cadence iTCO_vendor_support at24 
mac80211 snd_hda_codec snd_seq_dummy snd_seq_oss x86_pkg_temp_thermal intel_powerclamp snd_hda_core snd_seq_midi_event coretemp ac97_bus snd_pcm_oss ath snd_hwdep rapl hid_logitech_hidpp ses 
intel_cstate video snd_seq i2c_i801 enclosure intel_uncore i2c_smbus i2c_algo_bit snd_seq_device cfg80211 scsi_transport_sas drm_kms_helper snd_pcm r8169 mei_me rfkill libarc4 lpc_ich mei cec 
snd_timer snd_mixer_oss snd soundcore drm binfmt_misc fuse ip_tables hid_logitech_dj crct10dif_pclmul crc32_pclmul crc32c_intel ghash_clmulni_intel uas usb_storage serio_raw
[106378.638958] CPU: 5 PID: 0 Comm: swapper/5 Tainted: G        W         5.11.12-300.fc34.x86_64 #1
[106378.638964] Hardware name: Hewlett-Packard p6-2004es/2ABF, BIOS 7.16 03/23/2012
[106378.638967] RIP: 0010:dev_watchdog+0x24d/0x260
[106378.638974] Code: d9 a2 fd ff eb a9 4c 89 f7 c6 05 2a 46 30 01 01 e8 68 87 fa ff 44 89 e9 4c 89 f6 48 c7 c7 40 77 48 93 48 89 c2 e8 82 26 16 00 <0f> 0b eb 8a 66 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 
40 00 66 66 66
[106378.638979] RSP: 0018:ffffb6dd801acec0 EFLAGS: 00010282
[106378.638984] RAX: 0000000000000039 RBX: ffff8d1945108a00 RCX: 0000000000000000
[106378.638987] RDX: ffff8d1a77566ba0 RSI: ffff8d1a77558ac0 RDI: 0000000000000300
[106378.638991] RBP: ffff8d19436f43dc R08: 0000000000000000 R09: ffffb6dd801accf0
[106378.638994] R10: ffffb6dd801acce8 R11: ffffffff93b44f08 R12: ffff8d19436f4480
[106378.638998] R13: 0000000000000000 R14: ffff8d19436f4000 R15: ffff8d1945108a80
[106378.639001] FS:  0000000000000000(0000) GS:ffff8d1a77540000(0000) knlGS:0000000000000000
[106378.639005] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[106378.639009] CR2: 00007f160ef2d000 CR3: 0000000048a10005 CR4: 00000000000606e0
[106378.639013] Call Trace:
[106378.639017]  <IRQ>
[106378.639022]  ? pfifo_fast_enqueue+0x150/0x150
[106378.639029]  call_timer_fn+0x29/0xf0
[106378.639036]  __run_timers.part.0+0x1b1/0x210
[106378.639042]  ? ktime_get+0x38/0x90
[106378.639049]  ? lapic_next_deadline+0x28/0x30
[106378.639055]  ? clockevents_program_event+0x95/0xf0
[106378.639062]  ? sched_clock+0x5/0x10
[106378.639069]  run_timer_softirq+0x26/0x50
[106378.639074]  __do_softirq+0xd0/0x28f
[106378.639081]  asm_call_irq_on_stack+0xf/0x20
[106378.639087]  </IRQ>
[106378.639090]  do_softirq_own_stack+0x37/0x40
[106378.639094]  __irq_exit_rcu+0xbf/0x100
[106378.639099]  sysvec_apic_timer_interrupt+0x36/0x80
[106378.639108]  asm_sysvec_apic_timer_interrupt+0x12/0x20
[106378.639113] RIP: 0010:cpuidle_enter_state+0xc4/0x350
[106378.639120] Code: 7c ff 65 8b 3d 7d 3c 6c 6d e8 28 45 7c ff 49 89 c5 66 66 66 66 90 31 ff e8 59 5d 7c ff 45 84 ff 0f 85 fa 00 00 00 fb 66 66 90 <66> 66 90 45 85 f6 0f 88 06 01 00 00 49 63 d6 4c 2b 
2c 24 48 8d 04
[106378.639124] RSP: 0018:ffffb6dd800b7eb0 EFLAGS: 00000246
[106378.639129] RAX: ffff8d1a7756a000 RBX: 0000000000000004 RCX: 000000000000001f
[106378.639133] RDX: 0000000000000000 RSI: 0000000025bb8b00 RDI: 0000000000000000
[106378.639136] RBP: ffff8d1a77575200 R08: 000060c034f92547 R09: 0000000000000018
[106378.639139] R10: 000000000000afc8 R11: 0000000000008692 R12: ffffffff93c56dc0
[106378.639142] R13: 000060c034f92547 R14: 0000000000000004 R15: 0000000000000000
[106378.639148]  cpuidle_enter+0x29/0x40
[106378.639154]  do_idle+0x1c7/0x270
[106378.639160]  cpu_startup_entry+0x19/0x20
[106378.639164]  secondary_startup_64_no_verify+0xc2/0xcb
[106378.639173] ---[ end trace f4c1ff4fd6738c3a ]---
