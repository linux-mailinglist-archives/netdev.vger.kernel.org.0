Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D37E8119265
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 21:46:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726771AbfLJUq0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 15:46:26 -0500
Received: from mail-pg1-f171.google.com ([209.85.215.171]:36903 "EHLO
        mail-pg1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726500AbfLJUqZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 15:46:25 -0500
Received: by mail-pg1-f171.google.com with SMTP id q127so9454610pga.4
        for <netdev@vger.kernel.org>; Tue, 10 Dec 2019 12:46:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:subject:to:cc:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=mtRJL/5pVYyC4xJI0+vwTKi6i0mohpvP6qscGAqnrZw=;
        b=ibPtQ+CNR/9Ufmc8PnF/6OdTpUvbR36CFzknvOpzLejyLNW0XDPsTS/eeXMmgIKoZ1
         T+RdRbk6GXcjDKsbpGKsROKfrTvekErgG1IchF00Tj3CL0i7Y0t5nHYuR/liJVnK4xmC
         KP0dgwjyEiKWeDXO5wJ+7aMWP4rqVD8gKtBlDDgQG5x5/ynVW4e8AJxQFZyfhrG19E/M
         WYIw1J9+qo3lJ7AZ9eIHgMVwezx4EsZ3/QOt2/RuKBDEg6fQGpwvmzxQDWy5Ej4EXcNY
         IvbA2FmVeJ1BPi+E5WsqngBUDqSwjfuQ5D/hJpWkASfLP9vgynl/cDPuenc69evqbebh
         m4XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=mtRJL/5pVYyC4xJI0+vwTKi6i0mohpvP6qscGAqnrZw=;
        b=V2ct5SvGzfDOju3pyDU0KV/UY9Z4xS/f0/ZAkbAEUmpYR6n6P4fSxkOYNvHhr/Hd6D
         RPIlRD7DDeKKl/hcLK0Z2hX5IIyNSi3SiKYODUec36pqjPub8gs463qHjQ5Gs4ftKY+j
         RevX404uVzrtBF/1AfLFOsY+LXBwo+vEqtOrhxY1b6qdtzKrB2xidI9i0F2GCw486LgX
         xmfHvkRMWbTbVMYzvAbnvC6P+Fv7qBFnMNW6tgCqQ9lPjeKWqR7foEAMEH2gGatFD/pa
         vxq9xfUHDmxKt/p84cevBKUWxbwfMorVwuxm2hdJJqeLDpMtff+TIZrcy7OdM2A6/q0q
         BX3A==
X-Gm-Message-State: APjAAAU1pgyg+cttHNOUZFygR96gBXNtD7brmTVsJ4NFgSlYNHbXtIJ9
        AqLURwcX6Jd/0XRAfwJmRmKEUG2PhxXuoQ==
X-Google-Smtp-Source: APXvYqzXVot7zliTMSf3m+G8HlFV5BojcJbLGGnrx1qqEMsq1eHWvCsklKWUYwye5e/KrlNwM1OHkQ==
X-Received: by 2002:a65:4085:: with SMTP id t5mr26895669pgp.335.1576010784161;
        Tue, 10 Dec 2019 12:46:24 -0800 (PST)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id s15sm4237044pgq.4.2019.12.10.12.46.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Dec 2019 12:46:23 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
Subject: iwlwifi warnings in 5.5-rc1
To:     Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Cc:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>
Message-ID: <ceb74ea2-6a1b-4cef-8749-db21a2ee4311@kernel.dk>
Date:   Tue, 10 Dec 2019 13:46:22 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Since the GRO issue got fixed, iwlwifi has worked fine for me.
However, on every boot, I get some warnings:

------------[ cut here ]------------
STA b4:75:0e:99:1f:e0 AC 2 txq pending airtime underflow: 4294967088, 208
WARNING: CPU: 0 PID: 606 at net/mac80211/sta_info.c:1931 ieee80211_sta_update_pending_airtime+0x11c/0x130 [mac80211]
Modules linked in: rfcomm ccm cmac msr bnep iwlmvm joydev x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel mac80211 kvm binfmt_misc irqbypass nls_iso8859_1 snd_soc_skl libarc4 iwlwifi snd_soc_hdac_hda snd_hda_ext_core snd_hda_codec_hdmi snd_soc_acpi_intel_match hid_multitouch snd_soc_acpi snd_soc_sst_ipc snd_soc_sst_dsp wmi_bmof intel_wmi_thunderbolt snd_soc_core uvcvideo btusb snd_hda_codec_realtek crct10dif_pclmul btrtl crc32_pclmul ghash_clmulni_intel btbcm snd_hda_codec_generic btintel bluetooth videobuf2_vmalloc aesni_intel cfg80211 videobuf2_memops glue_helper videobuf2_v4l2 crypto_simd videobuf2_common cryptd intel_cstate videodev snd_hda_intel intel_rapl_perf snd_intel_dspcfg snd_hda_codec serio_raw input_leds snd_hwdep mc snd_hda_core mei_me ecdh_generic ecc snd_pcm mei snd_seq thinkpad_acpi intel_lpss_pci nvram processor_thermal_device ledtrig_audio ucsi_acpi intel_lpss intel_soc_dts_iosf typec_ucsi snd_timer idma64 intel_rapl_common virt_dma snd_seq_device
 typec intel_pch_thermal snd wmi int3403_thermal soundcore int340x_thermal_zone int3400_thermal acpi_pad acpi_thermal_rel sch_fq_codel ip_tables x_tables hid_generic usbhid i915 i2c_algo_bit drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops drm e1000e nvme i2c_hid ptp nvme_core hid pps_core video
CPU: 0 PID: 606 Comm: irq/139-iwlwifi Tainted: G     U            5.5.0-rc1+ #4143
Hardware name: LENOVO 20QD001XUS/20QD001XUS, BIOS N2HET42W (1.25 ) 11/26/2019
RIP: 0010:ieee80211_sta_update_pending_airtime+0x11c/0x130 [mac80211]
Code: 99 a6 96 c4 0f 0b 8b 45 d4 eb a1 48 83 c6 40 45 89 e0 89 c1 89 45 d4 48 c7 c7 88 ec f7 c0 c6 05 6a af 09 00 01 e8 73 a6 96 c4 <0f> 0b 8b 45 d4 eb 91 0f 1f 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f
RSP: 0018:ffffa6cfc092fb30 EFLAGS: 00010286
RAX: 0000000000000000 RBX: 00000000ffffff30 RCX: 0000000000000000
RDX: 0000000000000049 RSI: ffffffff86d89729 RDI: ffffffff86d872ac
RBP: ffffa6cfc092fb60 R08: ffffffff86d896e0 R09: 0000000000000049
R10: abcc77118461cefd R11: ffffffff86d89729 R12: 00000000000000d0
R13: ffff8afb89fd07c0 R14: 0000000000000002 R15: ffff8afb8fcc05c8
FS:  0000000000000000(0000) GS:ffff8afbae400000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f355c35aea0 CR3: 000000042c609005 CR4: 00000000001606f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 __ieee80211_tx_status+0x69b/0x8c0 [mac80211]
 ? sta_info_get_by_addrs+0x12e/0x1e0 [mac80211]
 ieee80211_tx_status+0x75/0xa0 [mac80211]
 iwl_mvm_tx_reclaim+0x2b5/0x3d0 [iwlmvm]
 iwl_mvm_rx_ba_notif+0x285/0x330 [iwlmvm]
 iwl_mvm_rx_common+0xde/0x2a0 [iwlmvm]
 iwl_mvm_rx_mq+0x71/0xb0 [iwlmvm]
 iwl_pcie_rx_handle+0x3b5/0xa70 [iwlwifi]
 ? irq_forced_thread_fn+0x80/0x80
 iwl_pcie_irq_rx_msix_handler+0x58/0x120 [iwlwifi]
 irq_thread_fn+0x23/0x60
 irq_thread+0xd8/0x170
 ? wake_threads_waitq+0x30/0x30
 kthread+0x103/0x140
 ? irq_thread_dtor+0xa0/0xa0
 ? kthread_park+0x90/0x90
 ret_from_fork+0x1f/0x30
---[ end trace 0c7c7c0cf1fc73ce ]---
------------[ cut here ]------------
Device phy0 AC 2 pending airtime underflow: 4294967088, 208
WARNING: CPU: 0 PID: 606 at net/mac80211/sta_info.c:1940 ieee80211_sta_update_pending_airtime+0xf6/0x130 [mac80211]
Modules linked in: rfcomm ccm cmac msr bnep iwlmvm joydev x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel mac80211 kvm binfmt_misc irqbypass nls_iso8859_1 snd_soc_skl libarc4 iwlwifi snd_soc_hdac_hda snd_hda_ext_core snd_hda_codec_hdmi snd_soc_acpi_intel_match hid_multitouch snd_soc_acpi snd_soc_sst_ipc snd_soc_sst_dsp wmi_bmof intel_wmi_thunderbolt snd_soc_core uvcvideo btusb snd_hda_codec_realtek crct10dif_pclmul btrtl crc32_pclmul ghash_clmulni_intel btbcm snd_hda_codec_generic btintel bluetooth videobuf2_vmalloc aesni_intel cfg80211 videobuf2_memops glue_helper videobuf2_v4l2 crypto_simd videobuf2_common cryptd intel_cstate videodev snd_hda_intel intel_rapl_perf snd_intel_dspcfg snd_hda_codec serio_raw input_leds snd_hwdep mc snd_hda_core mei_me ecdh_generic ecc snd_pcm mei snd_seq thinkpad_acpi intel_lpss_pci nvram processor_thermal_device ledtrig_audio ucsi_acpi intel_lpss intel_soc_dts_iosf typec_ucsi snd_timer idma64 intel_rapl_common virt_dma snd_seq_device
 typec intel_pch_thermal snd wmi int3403_thermal soundcore int340x_thermal_zone int3400_thermal acpi_pad acpi_thermal_rel sch_fq_codel ip_tables x_tables hid_generic usbhid i915 i2c_algo_bit drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops drm e1000e nvme i2c_hid ptp nvme_core hid pps_core video
CPU: 0 PID: 606 Comm: irq/139-iwlwifi Tainted: G     U  W         5.5.0-rc1+ #4143
Hardware name: LENOVO 20QD001XUS/20QD001XUS, BIOS N2HET42W (1.25 ) 11/26/2019
RIP: 0010:ieee80211_sta_update_pending_airtime+0xf6/0x130 [mac80211]
Code: 48 8b b2 90 01 00 00 48 85 f6 75 07 48 8b b2 40 01 00 00 45 89 e0 89 c1 44 89 f2 89 45 d4 48 c7 c7 c0 ec f7 c0 e8 99 a6 96 c4 <0f> 0b 8b 45 d4 eb a1 48 83 c6 40 45 89 e0 89 c1 89 45 d4 48 c7 c7
RSP: 0018:ffffa6cfc092fb30 EFLAGS: 00010286
RAX: 0000000000000000 RBX: 00000000ffffff30 RCX: 0000000000000000
RDX: 000000000000003b RSI: ffffffff86d8971b RDI: ffffffff86d872ac
RBP: ffffa6cfc092fb60 R08: ffffffff86d896e0 R09: 000000000000003b
R10: abcc77118461cefd R11: ffffffff86d8971b R12: 00000000000000d0
R13: ffff8afb89fd07c0 R14: 0000000000000002 R15: ffff8afb8fcc05c8
FS:  0000000000000000(0000) GS:ffff8afbae400000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f355c35aea0 CR3: 000000042c609005 CR4: 00000000001606f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 __ieee80211_tx_status+0x69b/0x8c0 [mac80211]
 ? sta_info_get_by_addrs+0x12e/0x1e0 [mac80211]
 ieee80211_tx_status+0x75/0xa0 [mac80211]
 iwl_mvm_tx_reclaim+0x2b5/0x3d0 [iwlmvm]
 iwl_mvm_rx_ba_notif+0x285/0x330 [iwlmvm]
 iwl_mvm_rx_common+0xde/0x2a0 [iwlmvm]
 iwl_mvm_rx_mq+0x71/0xb0 [iwlmvm]
 iwl_pcie_rx_handle+0x3b5/0xa70 [iwlwifi]
 ? irq_forced_thread_fn+0x80/0x80
 iwl_pcie_irq_rx_msix_handler+0x58/0x120 [iwlwifi]
 irq_thread_fn+0x23/0x60
 irq_thread+0xd8/0x170
 ? wake_threads_waitq+0x30/0x30
 kthread+0x103/0x140
 ? irq_thread_dtor+0xa0/0xa0
 ? kthread_park+0x90/0x90
 ret_from_fork+0x1f/0x30
---[ end trace 0c7c7c0cf1fc73cf ]---

-- 
Jens Axboe

