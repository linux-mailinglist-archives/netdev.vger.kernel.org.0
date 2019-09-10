Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13C1EAE247
	for <lists+netdev@lfdr.de>; Tue, 10 Sep 2019 04:15:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392671AbfIJCPh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Sep 2019 22:15:37 -0400
Received: from node.noduck.org ([207.192.71.159]:53266 "EHLO node.noduck.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392452AbfIJCPh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Sep 2019 22:15:37 -0400
X-Greylist: delayed 2753 seconds by postgrey-1.27 at vger.kernel.org; Mon, 09 Sep 2019 22:15:36 EDT
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=noduck.org;
         s=node; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Date:
        Message-ID:Cc:Subject:From:To:Sender:Reply-To:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=85eU4RmDOJPzcYl8tJEQRD8VSLV45S613gqUpCd/WK0=; b=vmTDcbo8UvBHFRq3iB5HvoTgrn
        e5C0emrqmhjC49MtkdMy+5MgZYCNhG8k/F6VDLsheXQOrHBG24HRN0kuS9SZVzpvsiI9QKfBzn8zI
        mk6hsAN/vG9mOsiT9opFptuAUA3HdTCHoyXY7xYtiBK/VNi6DKBhLegaegJihxonr60d9g/IimrYR
        BmKzh3D0CjuuZyhAFlRqYwaUZwA9gP+U34I5/GzTwSwv62T/A9Xj0oQZd1T+yW7ixZ44GVeE5vVXi
        eaJ++lWSeVYaUJ5ykxBo13qFuKPbqZG0/GzWwyXjhb7ce8oaraxjsDnUScqgYpppS8rwAMJaUKGbC
        KFsFBN8g==;
Received: from xxx.noduck.org ([2600:3c03:e001:400::8])
        by node.noduck.org with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Mixe)
        id 1i7UyR-0002X7-Cl from <raf@noduck.org>; Tue, 10 Sep 2019 01:29:39 +0000
Received: from xxx.noduck.org ([2600:3c03:e001:400::b583])
        by xxx.noduck.org with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Mixe)
        id 1i7UyM-0005eU-1K from <raf@noduck.org>; Mon, 09 Sep 2019 21:29:39 -0400
To:     "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
From:   Rafael D'Halleweyn <raf@noduck.org>
Subject: NULL pointer dereference in ip6_datagram_dst_update
Cc:     netdev@vger.kernel.org
Message-ID: <096ac8d4-4eab-3254-fe20-295e4c092554@noduck.org>
Date:   Mon, 9 Sep 2019 21:29:33 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Spam_score: 1.5
X-Spam_score_int: 15
X-Spam_bar: +
X-Spam_report: Spam detection software, running on the system "alto.noduck.org",
 has NOT identified this incoming email as spam.  The original
 message has been attached to this so you can view it or label
 similar future email.  If you have any questions, see
 @@CONTACT_ADDRESS@@ for details.
 Content preview:  Hi, While running 5.3.0-rc8 on my laptop, I receive an NULL
    pointer error when trying to use IPv6 (i.e. just browsing with Firefox).
   I have a desktop running the same version and kernel-config without pro [...]
 Content analysis details:   (1.5 points, 5.0 required)
  pts rule name              description
 ---- ---------------------- --------------------------------------------------
  1.5 BODY_8BITS             BODY: Body includes 8 consecutive 8-bit characters
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

While running 5.3.0-rc8 on my laptop, I receive an NULL pointer error when trying to use IPv6 (i.e. just browsing with Firefox). I have a desktop running the same version and kernel-config without problem (but different hardware). The laptop is using wireless (Intel AX200 iwlwifi).

Please let me know if you need more detailed information.

Thanks,

Raf.


[   31.377880] dst_release: dst:00000000751fac0a refcnt:-1
[   31.769445] BUG: kernel NULL pointer dereference, address: 00000000000000ed
[   31.769449] #PF: supervisor read access in kernel mode
[   31.769451] #PF: error_code(0x0000) - not-present page
[   31.769452] PGD 0 P4D 0
[   31.769455] Oops: 0000 [#1] SMP PTI
[   31.769458] CPU: 7 PID: 3103 Comm: pool-gnome-shel Tainted: G           OE     5.3.0-rc8 #14
[   31.769460] Hardware name: Dell Inc. XPS 13 9360/02PG84, BIOS 2.12.0 05/26/2019
[   31.769465] RIP: 0010:ip6_sk_dst_store_flow+0x7b/0xb0
[   31.769467] Code: 48 8b 42 30 48 33 47 40 48 09 c1 0f b6 4f 12 b8 01 00 00 00 4d 0f 45 e1 31 db d3 e0 a9 bf ef ff ff 74 07 48 8b 9f f0 02 00 00 <48> 8b 46 70 31 d2 48 85 c0 74 0c 48 8b 40 10 48 85 c0 74 03 8b 50
[   31.769469] RSP: 0018:ffffbc40c2253d10 EFLAGS: 00010202
[   31.769471] RAX: 0000000000000080 RBX: ffffa01ac2098460 RCX: 0000000000000007
[   31.769473] RDX: ffffbc40c2253d50 RSI: 000000000000007d RDI: ffffa01ac2098000
[   31.769474] RBP: ffffa01ac2098460 R08: 0000000000000000 R09: 0000000000000000
[   31.769475] R10: 83b567a7afeebe71 R11: ffffa01b5e85fb80 R12: ffffa01ac2098038
[   31.769476] R13: 0000000000000000 R14: 0000000000000001 R15: ffffa01ac2098460
[   31.769479] FS:  00007f33320c5700(0000) GS:ffffa01b6e3c0000(0000) knlGS:0000000000000000
[   31.769481] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   31.769482] CR2: 00000000000000ed CR3: 000000046be2e005 CR4: 00000000003606e0
[   31.769483] Call Trace:
[   31.769490]  ip6_datagram_dst_update+0x156/0x280
[   31.769494]  __ip6_datagram_connect+0x1dc/0x380
[   31.769497]  ip6_datagram_connect+0x27/0x40
[   31.769500]  __sys_connect+0xd0/0x100
[   31.769504]  ? __sys_socket+0xb7/0xe0
[   31.769506]  __x64_sys_connect+0x16/0x20
[   31.769509]  do_syscall_64+0x4f/0x120
[   31.769514]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[   31.769517] RIP: 0033:0x7f3375ebdb57
[   31.769519] Code: 0f 1f 00 41 54 41 89 d4 55 48 89 f5 53 89 fb 48 83 ec 10 e8 8b d2 00 00 44 89 e2 48 89 ee 89 df 41 89 c0 b8 2a 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 33 44 89 c7 89 44 24 0c e8 c5 d2 00 00 8b 44
[   31.769521] RSP: 002b:00007f33320c4270 EFLAGS: 00000293 ORIG_RAX: 000000000000002a
[   31.769523] RAX: ffffffffffffffda RBX: 0000000000000023 RCX: 00007f3375ebdb57
[   31.769524] RDX: 000000000000001c RSI: 00007f3308001530 RDI: 0000000000000023
[   31.769526] RBP: 00007f3308001530 R08: 0000000000000000 R09: 0000000000000000
[   31.769527] R10: 0000000000000009 R11: 0000000000000293 R12: 000000000000001c
[   31.769528] R13: 0000000000000023 R14: 000000000000000a R15: 00007f3308001500
[   31.769531] Modules linked in: rfcomm msr nf_log_ipv4 nf_log_common xt_LOG xt_CHECKSUM iptable_mangle xt_MASQUERADE iptable_nat wireguard(OE) nf_nat ip6_udp_tunnel udp_tunnel ccm xt_conntrack nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 ipt_REJECT nf_reject_ipv4 xt_tcpudp tun bridge stp llc ebtable_filter ebtables ip6table_filter ip6_tables iptable_filter cmac bnep uvcvideo videobuf2_vmalloc videobuf2_memops videobuf2_v4l2 btusb videobuf2_common btrtl btbcm btintel videodev bluetooth mc ecdh_generic ecc snd_hda_codec_hdmi binfmt_misc x86_pkg_temp_thermal intel_powerclamp coretemp joydev snd_hda_codec_realtek snd_hda_codec_generic snd_soc_skl kvm_intel snd_soc_hdac_hda snd_hda_ext_core snd_soc_skl_ipc kvm snd_soc_sst_ipc irqbypass snd_soc_sst_dsp snd_soc_acpi_intel_match snd_soc_acpi snd_soc_core snd_compress ac97_bus snd_pcm_dmaengine snd_hda_intel snd_hda_codec snd_hda_core iwlmvm snd_hwdep snd_pcm crct10dif_pclmul nls_iso8859_1 mac80211 dell_laptop ledtrig_audio
snd_seq_midi libarc4
[   31.769567]  mei_hdcp crc32_pclmul intel_rapl_msr snd_seq_midi_event ghash_clmulni_intel snd_rawmidi i915 snd_seq iwlwifi snd_seq_device aesni_intel snd_timer dell_wmi cec dell_smbios aes_x86_64 crypto_simd dcdbas drm_kms_helper cryptd snd dell_wmi_descriptor cfg80211 glue_helper wmi_bmof intel_wmi_thunderbolt soundcore input_leds rtsx_pci_ms serio_raw drm memstick ucsi_acpi intel_gtt mei_me hid_multitouch processor_thermal_device i2c_algo_bit typec_ucsi fb_sys_fops syscopyarea mei idma64 intel_rapl_common sysfillrect virt_dma intel_xhci_usb_role_switch sysimgblt roles intel_pch_thermal intel_soc_dts_iosf typec soc_button_array intel_vbtn mac_hid intel_hid int3400_thermal int3403_thermal sparse_keymap acpi_thermal_rel int340x_thermal_zone acpi_pad sch_fq_codel parport_pc ppdev lp parport efivarfs ip_tables x_tables autofs4 raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq libcrc32c raid1 raid0 multipath linear usbhid hid_generic
rtsx_pci_sdmmc rtsx_pci
[   31.769605]  i2c_i801 intel_lpss_pci i2c_hid intel_lpss wmi hid pinctrl_sunrisepoint video pinctrl_intel
[   31.769613] CR2: 00000000000000ed
[   31.769615] ---[ end trace 18eaad00960f2046 ]---
[   31.769618] RIP: 0010:ip6_sk_dst_store_flow+0x7b/0xb0
[   31.769621] Code: 48 8b 42 30 48 33 47 40 48 09 c1 0f b6 4f 12 b8 01 00 00 00 4d 0f 45 e1 31 db d3 e0 a9 bf ef ff ff 74 07 48 8b 9f f0 02 00 00 <48> 8b 46 70 31 d2 48 85 c0 74 0c 48 8b 40 10 48 85 c0 74 03 8b 50
[   31.769622] RSP: 0018:ffffbc40c2253d10 EFLAGS: 00010202
[   31.769624] RAX: 0000000000000080 RBX: ffffa01ac2098460 RCX: 0000000000000007
[   31.769625] RDX: ffffbc40c2253d50 RSI: 000000000000007d RDI: ffffa01ac2098000
[   31.769627] RBP: ffffa01ac2098460 R08: 0000000000000000 R09: 0000000000000000
[   31.769628] R10: 83b567a7afeebe71 R11: ffffa01b5e85fb80 R12: ffffa01ac2098038
[   31.769630] R13: 0000000000000000 R14: 0000000000000001 R15: ffffa01ac2098460
[   31.769632] FS:  00007f33320c5700(0000) GS:ffffa01b6e3c0000(0000) knlGS:0000000000000000
[   31.769633] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   31.769635] CR2: 00000000000000ed CR3: 000000046be2e005 CR4: 00000000003606e0
[   43.255937] BUG: kernel NULL pointer dereference, address: 00000000000000ed
[   43.255943] #PF: supervisor read access in kernel mode
[   43.255946] #PF: error_code(0x0000) - not-present page
[   43.255949] PGD 0 P4D 0
[   43.255954] Oops: 0000 [#2] SMP PTI
[   43.255960] CPU: 7 PID: 797 Comm: sd-resolve Tainted: G      D    OE     5.3.0-rc8 #14
[   43.255963] Hardware name: Dell Inc. XPS 13 9360/02PG84, BIOS 2.12.0 05/26/2019
[   43.255971] RIP: 0010:ip6_sk_dst_store_flow+0x7b/0xb0
[   43.255976] Code: 48 8b 42 30 48 33 47 40 48 09 c1 0f b6 4f 12 b8 01 00 00 00 4d 0f 45 e1 31 db d3 e0 a9 bf ef ff ff 74 07 48 8b 9f f0 02 00 00 <48> 8b 46 70 31 d2 48 85 c0 74 0c 48 8b 40 10 48 85 c0 74 03 8b 50
[   43.255979] RSP: 0018:ffffbc40c0b9bd10 EFLAGS: 00010202
[   43.255982] RAX: 0000000000000080 RBX: ffffa01b66018960 RCX: 0000000000000007
[   43.255984] RDX: ffffbc40c0b9bd50 RSI: 000000000000007d RDI: ffffa01b66018500
[   43.255986] RBP: ffffa01b66018960 R08: 0000000000000000 R09: 0000000000000000
[   43.255988] R10: 83b567a7afeebe71 R11: ffffa01b5e85fb80 R12: ffffa01b66018538
[   43.255990] R13: 0000000000000000 R14: 0000000000000001 R15: ffffa01b66018960
[   43.255993] FS:  00007f37b47a1700(0000) GS:ffffa01b6e3c0000(0000) knlGS:0000000000000000
[   43.255995] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   43.255997] CR2: 00000000000000ed CR3: 0000000464eca004 CR4: 00000000003606e0
[   43.255998] Call Trace:
[   43.256008]  ip6_datagram_dst_update+0x156/0x280
[   43.256014]  __ip6_datagram_connect+0x1dc/0x380
[   43.256019]  ip6_datagram_connect+0x27/0x40
[   43.256025]  __sys_connect+0xd0/0x100
[   43.256034]  ? syscall_trace_enter+0x131/0x2c0
[   43.256039]  __x64_sys_connect+0x16/0x20
[   43.256044]  do_syscall_64+0x4f/0x120
[   43.256051]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[   43.256056] RIP: 0033:0x7f37b543bb57
[   43.256061] Code: 0f 1f 00 41 54 41 89 d4 55 48 89 f5 53 89 fb 48 83 ec 10 e8 8b d2 00 00 44 89 e2 48 89 ee 89 df 41 89 c0 b8 2a 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 33 44 89 c7 89 44 24 0c e8 c5 d2 00 00 8b 44
[   43.256065] RSP: 002b:00007f37b479b410 EFLAGS: 00000293 ORIG_RAX: 000000000000002a
[   43.256069] RAX: ffffffffffffffda RBX: 000000000000000c RCX: 00007f37b543bb57
[   43.256071] RDX: 000000000000001c RSI: 00007f37ac003010 RDI: 000000000000000c
[   43.256073] RBP: 00007f37ac003010 R08: 0000000000000000 R09: 0000000000000000
[   43.256075] R10: 0000000000000000 R11: 0000000000000293 R12: 000000000000001c
[   43.256077] R13: 000000000000000c R14: 000000000000000a R15: 00007f37ac002fe0
[   43.256080] Modules linked in: rfcomm msr nf_log_ipv4 nf_log_common xt_LOG xt_CHECKSUM iptable_mangle xt_MASQUERADE iptable_nat wireguard(OE) nf_nat ip6_udp_tunnel udp_tunnel ccm xt_conntrack nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 ipt_REJECT nf_reject_ipv4 xt_tcpudp tun bridge stp llc ebtable_filter ebtables ip6table_filter ip6_tables iptable_filter cmac bnep uvcvideo videobuf2_vmalloc videobuf2_memops videobuf2_v4l2 btusb videobuf2_common btrtl btbcm btintel videodev bluetooth mc ecdh_generic ecc snd_hda_codec_hdmi binfmt_misc x86_pkg_temp_thermal intel_powerclamp coretemp joydev snd_hda_codec_realtek snd_hda_codec_generic snd_soc_skl kvm_intel snd_soc_hdac_hda snd_hda_ext_core snd_soc_skl_ipc kvm snd_soc_sst_ipc irqbypass snd_soc_sst_dsp snd_soc_acpi_intel_match snd_soc_acpi snd_soc_core snd_compress ac97_bus snd_pcm_dmaengine snd_hda_intel snd_hda_codec snd_hda_core iwlmvm snd_hwdep snd_pcm crct10dif_pclmul nls_iso8859_1 mac80211 dell_laptop ledtrig_audio
snd_seq_midi libarc4
[   43.256123]  mei_hdcp crc32_pclmul intel_rapl_msr snd_seq_midi_event ghash_clmulni_intel snd_rawmidi i915 snd_seq iwlwifi snd_seq_device aesni_intel snd_timer dell_wmi cec dell_smbios aes_x86_64 crypto_simd dcdbas drm_kms_helper cryptd snd dell_wmi_descriptor cfg80211 glue_helper wmi_bmof intel_wmi_thunderbolt soundcore input_leds rtsx_pci_ms serio_raw drm memstick ucsi_acpi intel_gtt mei_me hid_multitouch processor_thermal_device i2c_algo_bit typec_ucsi fb_sys_fops syscopyarea mei idma64 intel_rapl_common sysfillrect virt_dma intel_xhci_usb_role_switch sysimgblt roles intel_pch_thermal intel_soc_dts_iosf typec soc_button_array intel_vbtn mac_hid intel_hid int3400_thermal int3403_thermal sparse_keymap acpi_thermal_rel int340x_thermal_zone acpi_pad sch_fq_codel parport_pc ppdev lp parport efivarfs ip_tables x_tables autofs4 raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq libcrc32c raid1 raid0 multipath linear usbhid hid_generic
rtsx_pci_sdmmc rtsx_pci
[   43.256179]  i2c_i801 intel_lpss_pci i2c_hid intel_lpss wmi hid pinctrl_sunrisepoint video pinctrl_intel
[   43.256188] CR2: 00000000000000ed
[   43.256192] ---[ end trace 18eaad00960f2047 ]---
[   43.256196] RIP: 0010:ip6_sk_dst_store_flow+0x7b/0xb0
[   43.256200] Code: 48 8b 42 30 48 33 47 40 48 09 c1 0f b6 4f 12 b8 01 00 00 00 4d 0f 45 e1 31 db d3 e0 a9 bf ef ff ff 74 07 48 8b 9f f0 02 00 00 <48> 8b 46 70 31 d2 48 85 c0 74 0c 48 8b 40 10 48 85 c0 74 03 8b 50
[   43.256202] RSP: 0018:ffffbc40c2253d10 EFLAGS: 00010202
[   43.256204] RAX: 0000000000000080 RBX: ffffa01ac2098460 RCX: 0000000000000007
[   43.256206] RDX: ffffbc40c2253d50 RSI: 000000000000007d RDI: ffffa01ac2098000
[   43.256208] RBP: ffffa01ac2098460 R08: 0000000000000000 R09: 0000000000000000
[   43.256209] R10: 83b567a7afeebe71 R11: ffffa01b5e85fb80 R12: ffffa01ac2098038
[   43.256211] R13: 0000000000000000 R14: 0000000000000001 R15: ffffa01ac2098460
[   43.256213] FS:  00007f37b47a1700(0000) GS:ffffa01b6e3c0000(0000) knlGS:0000000000000000
[   43.256216] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   43.256217] CR2: 00000000000000ed CR3: 0000000464eca004 CR4: 00000000003606e0
[   46.137611] dst_release: dst:00000000f80c721f refcnt:-1
[   46.137627] dst_release: dst:00000000f80c721f refcnt:-2
[   46.137635] dst_release: dst:00000000f80c721f refcnt:-3
[   46.137642] dst_release: dst:00000000f80c721f refcnt:-4
[   46.137649] dst_release: dst:00000000f80c721f refcnt:-5
[   46.137656] dst_release: dst:00000000f80c721f refcnt:-6
[   46.137663] dst_release: dst:00000000f80c721f refcnt:-7
[   46.137669] dst_release: dst:00000000f80c721f refcnt:-8
[   46.137900] BUG: kernel NULL pointer dereference, address: 00000000000000d1
[   46.137902] #PF: supervisor read access in kernel mode
[   46.137904] #PF: error_code(0x0000) - not-present page
[   46.137905] PGD 80000003d7b10067 P4D 80000003d7b10067 PUD 0
[   46.137908] Oops: 0000 [#3] SMP PTI
[   46.137910] CPU: 3 PID: 3156 Comm: Socket Thread Tainted: G      D    OE     5.3.0-rc8 #14
[   46.137911] Hardware name: Dell Inc. XPS 13 9360/02PG84, BIOS 2.12.0 05/26/2019
[   46.137915] RIP: 0010:sk_setup_caps+0x38/0x130
[   46.137917] Code: 53 48 89 fb 66 89 47 78 c7 87 88 01 00 00 00 00 00 00 48 89 f7 48 87 bb 38 01 00 00 e8 11 d0 02 00 48 8b 45 00 b9 01 00 00 00 <48> 8b 80 d0 00 00 00 48 0b 83 f8 01 00 00 48 89 c2 48 0d 00 00 1d
[   46.137918] RSP: 0018:ffffbc40c0ecfcf8 EFLAGS: 00010246
[   46.137920] RAX: 0000000000000001 RBX: ffffa01b1fe60000 RCX: 0000000000000001
[   46.137921] RDX: 0000000000000000 RSI: ffffa01b5f588100 RDI: 0000000000000000
[   46.137922] RBP: ffffa01b5f588100 R08: 0000000000000006 R09: 020401e0033c0026
[   46.137923] R10: 83b567a7afeebe71 R11: ffffa01b5e85fb80 R12: ffffbc40c0ecfe88
[   46.137924] R13: 0000000000000000 R14: ffffa01b1fe60888 R15: 0000000000000000
[   46.137925] FS:  00007fde8d541700(0000) GS:ffffa01b6e2c0000(0000) knlGS:0000000000000000
[   46.137926] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   46.137927] CR2: 00000000000000d1 CR3: 0000000411536002 CR4: 00000000003606e0
[   46.137928] Call Trace:
[   46.137934]  tcp_v6_connect+0x405/0x5f0
[   46.137938]  __inet_stream_connect+0xd1/0x370
[   46.137941]  ? tomoyo_socket_connect_permission+0xa2/0xf0
[   46.137943]  inet_stream_connect+0x36/0x50
[   46.137945]  __sys_connect+0xd0/0x100
[   46.137947]  ? __sys_setsockopt+0x16d/0x190
[   46.137948]  __x64_sys_connect+0x16/0x20
[   46.137951]  do_syscall_64+0x4f/0x120
[   46.137954]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[   46.137957] RIP: 0033:0x7fde9eceaf57
[   46.137958] Code: 44 00 00 41 54 41 89 d4 55 48 89 f5 53 89 fb 48 83 ec 10 e8 9b fa ff ff 44 89 e2 48 89 ee 89 df 41 89 c0 b8 2a 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 33 44 89 c7 89 44 24 0c e8 d5 fa ff ff 8b 44
[   46.137959] RSP: 002b:00007fde8d540500 EFLAGS: 00000293 ORIG_RAX: 000000000000002a
[   46.137961] RAX: ffffffffffffffda RBX: 000000000000007f RCX: 00007fde9eceaf57
[   46.137962] RDX: 000000000000001c RSI: 00007fde8d540590 RDI: 000000000000007f
[   46.137963] RBP: 00007fde8d540590 R08: 0000000000000000 R09: 0000000000000000
[   46.137963] R10: 000000000000002e R11: 0000000000000293 R12: 000000000000001c
[   46.137964] R13: 00007fde801e05e0 R14: 000000000000001c R15: 0000000000000014
[   46.137966] Modules linked in: rfcomm msr nf_log_ipv4 nf_log_common xt_LOG xt_CHECKSUM iptable_mangle xt_MASQUERADE iptable_nat wireguard(OE) nf_nat ip6_udp_tunnel udp_tunnel ccm xt_conntrack nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 ipt_REJECT nf_reject_ipv4 xt_tcpudp tun bridge stp llc ebtable_filter ebtables ip6table_filter ip6_tables iptable_filter cmac bnep uvcvideo videobuf2_vmalloc videobuf2_memops videobuf2_v4l2 btusb videobuf2_common btrtl btbcm btintel videodev bluetooth mc ecdh_generic ecc snd_hda_codec_hdmi binfmt_misc x86_pkg_temp_thermal intel_powerclamp coretemp joydev snd_hda_codec_realtek snd_hda_codec_generic snd_soc_skl kvm_intel snd_soc_hdac_hda snd_hda_ext_core snd_soc_skl_ipc kvm snd_soc_sst_ipc irqbypass snd_soc_sst_dsp snd_soc_acpi_intel_match snd_soc_acpi snd_soc_core snd_compress ac97_bus snd_pcm_dmaengine snd_hda_intel snd_hda_codec snd_hda_core iwlmvm snd_hwdep snd_pcm crct10dif_pclmul nls_iso8859_1 mac80211 dell_laptop ledtrig_audio
snd_seq_midi libarc4
[   46.137991]  mei_hdcp crc32_pclmul intel_rapl_msr snd_seq_midi_event ghash_clmulni_intel snd_rawmidi i915 snd_seq iwlwifi snd_seq_device aesni_intel snd_timer dell_wmi cec dell_smbios aes_x86_64 crypto_simd dcdbas drm_kms_helper cryptd snd dell_wmi_descriptor cfg80211 glue_helper wmi_bmof intel_wmi_thunderbolt soundcore input_leds rtsx_pci_ms serio_raw drm memstick ucsi_acpi intel_gtt mei_me hid_multitouch processor_thermal_device i2c_algo_bit typec_ucsi fb_sys_fops syscopyarea mei idma64 intel_rapl_common sysfillrect virt_dma intel_xhci_usb_role_switch sysimgblt roles intel_pch_thermal intel_soc_dts_iosf typec soc_button_array intel_vbtn mac_hid intel_hid int3400_thermal int3403_thermal sparse_keymap acpi_thermal_rel int340x_thermal_zone acpi_pad sch_fq_codel parport_pc ppdev lp parport efivarfs ip_tables x_tables autofs4 raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq libcrc32c raid1 raid0 multipath linear usbhid hid_generic
rtsx_pci_sdmmc rtsx_pci
[   46.138017]  i2c_i801 intel_lpss_pci i2c_hid intel_lpss wmi hid pinctrl_sunrisepoint video pinctrl_intel
[   46.138022] CR2: 00000000000000d1
[   46.138024] ---[ end trace 18eaad00960f2048 ]---
[   46.138026] RIP: 0010:ip6_sk_dst_store_flow+0x7b/0xb0
[   46.138027] Code: 48 8b 42 30 48 33 47 40 48 09 c1 0f b6 4f 12 b8 01 00 00 00 4d 0f 45 e1 31 db d3 e0 a9 bf ef ff ff 74 07 48 8b 9f f0 02 00 00 <48> 8b 46 70 31 d2 48 85 c0 74 0c 48 8b 40 10 48 85 c0 74 03 8b 50
[   46.138028] RSP: 0018:ffffbc40c2253d10 EFLAGS: 00010202
[   46.138030] RAX: 0000000000000080 RBX: ffffa01ac2098460 RCX: 0000000000000007
[   46.138030] RDX: ffffbc40c2253d50 RSI: 000000000000007d RDI: ffffa01ac2098000
[   46.138031] RBP: ffffa01ac2098460 R08: 0000000000000000 R09: 0000000000000000
[   46.138032] R10: 83b567a7afeebe71 R11: ffffa01b5e85fb80 R12: ffffa01ac2098038
[   46.138033] R13: 0000000000000000 R14: 0000000000000001 R15: ffffa01ac2098460
[   46.138034] FS:  00007fde8d541700(0000) GS:ffffa01b6e2c0000(0000) knlGS:0000000000000000
[   46.138035] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   46.138036] CR2: 00000000000000d1 CR3: 0000000411536002 CR4: 00000000003606e0
[   90.518474] dst_release: dst:00000000f80c721f refcnt:-9
[   90.518495] dst_release: dst:00000000f80c721f refcnt:-10
[   90.518504] dst_release: dst:00000000f80c721f refcnt:-11
[   90.518511] dst_release: dst:00000000f80c721f refcnt:-12
[   90.518588] dst_release: dst:00000000f80c721f refcnt:-13
[   90.521844] dst_release: dst:00000000e32e020e refcnt:-1
[   90.521891] dst_release: dst:00000000e32e020e refcnt:-2
[   90.522907] BUG: kernel NULL pointer dereference, address: 00000000000000d1
[   90.522911] #PF: supervisor read access in kernel mode
[   90.522912] #PF: error_code(0x0000) - not-present page
[   90.522914] PGD 0 P4D 0
[   90.522918] Oops: 0000 [#4] SMP PTI
[   90.522921] CPU: 3 PID: 3773 Comm: http Tainted: G      D    OE     5.3.0-rc8 #14
[   90.522922] Hardware name: Dell Inc. XPS 13 9360/02PG84, BIOS 2.12.0 05/26/2019
[   90.522928] RIP: 0010:sk_setup_caps+0x38/0x130
[   90.522931] Code: 53 48 89 fb 66 89 47 78 c7 87 88 01 00 00 00 00 00 00 48 89 f7 48 87 bb 38 01 00 00 e8 11 d0 02 00 48 8b 45 00 b9 01 00 00 00 <48> 8b 80 d0 00 00 00 48 0b 83 f8 01 00 00 48 89 c2 48 0d 00 00 1d
[   90.522932] RSP: 0018:ffffbc40c1c87cf8 EFLAGS: 00010246
[   90.522934] RAX: 0000000000000001 RBX: ffffa01aca530000 RCX: 0000000000000001
[   90.522936] RDX: 0000000000000000 RSI: ffffa01b5f588100 RDI: 0000000000000000
[   90.522937] RBP: ffffa01b5f588100 R08: 0000000000000000 R09: 0000000000000000
[   90.522939] R10: 83b567a7afeebe71 R11: ffffa01b5e85fb80 R12: ffffa01aca530038
[   90.522940] R13: 0000000000000000 R14: 0000000000000001 R15: ffffa01aca530460
[   90.522942] FS:  00007ff174d29a40(0000) GS:ffffa01b6e2c0000(0000) knlGS:0000000000000000
[   90.522944] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   90.522945] CR2: 00000000000000d1 CR3: 00000003cd750006 CR4: 00000000003606e0
[   90.522947] Call Trace:
[   90.522953]  ip6_sk_dst_store_flow+0x9a/0xb0
[   90.522958]  ip6_datagram_dst_update+0x156/0x280
[   90.522963]  __ip6_datagram_connect+0x1dc/0x380
[   90.522966]  ip6_datagram_connect+0x27/0x40
[   90.522969]  __sys_connect+0xd0/0x100
[   90.522972]  ? __sys_socket+0xb7/0xe0
[   90.522974]  __x64_sys_connect+0x16/0x20
[   90.522978]  do_syscall_64+0x4f/0x120
[   90.522983]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[   90.522987] RIP: 0033:0x7ff1758f5b24
[   90.522989] Code: 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 8d 05 b9 b8 0c 00 8b 00 85 c0 75 13 b8 2a 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 54 c3 0f 1f 00 41 54 41 89 d4 55 48 89 f5 53
[   90.522991] RSP: 002b:00007ffc0e6a79b8 EFLAGS: 00000246 ORIG_RAX: 000000000000002a
[   90.522993] RAX: ffffffffffffffda RBX: 00007ffc0e6a7c30 RCX: 00007ff1758f5b24
[   90.522994] RDX: 000000000000001c RSI: 0000556f0399faf0 RDI: 0000000000000003
[   90.522995] RBP: 00007ffc0e6a8330 R08: 0000000000000018 R09: 0000000000000000
[   90.522997] R10: 0000000000000009 R11: 0000000000000246 R12: 000000000000000d
[   90.522998] R13: 0000000000000003 R14: 000000000000000a R15: 0000556f0399fac0
[   90.523000] Modules linked in: rfcomm msr nf_log_ipv4 nf_log_common xt_LOG xt_CHECKSUM iptable_mangle xt_MASQUERADE iptable_nat wireguard(OE) nf_nat ip6_udp_tunnel udp_tunnel ccm xt_conntrack nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 ipt_REJECT nf_reject_ipv4 xt_tcpudp tun bridge stp llc ebtable_filter ebtables ip6table_filter ip6_tables iptable_filter cmac bnep uvcvideo videobuf2_vmalloc videobuf2_memops videobuf2_v4l2 btusb videobuf2_common btrtl btbcm btintel videodev bluetooth mc ecdh_generic ecc snd_hda_codec_hdmi binfmt_misc x86_pkg_temp_thermal intel_powerclamp coretemp joydev snd_hda_codec_realtek snd_hda_codec_generic snd_soc_skl kvm_intel snd_soc_hdac_hda snd_hda_ext_core snd_soc_skl_ipc kvm snd_soc_sst_ipc irqbypass snd_soc_sst_dsp snd_soc_acpi_intel_match snd_soc_acpi snd_soc_core snd_compress ac97_bus snd_pcm_dmaengine snd_hda_intel snd_hda_codec snd_hda_core iwlmvm snd_hwdep snd_pcm crct10dif_pclmul nls_iso8859_1 mac80211 dell_laptop ledtrig_audio
snd_seq_midi libarc4
[   90.523039]  mei_hdcp crc32_pclmul intel_rapl_msr snd_seq_midi_event ghash_clmulni_intel snd_rawmidi i915 snd_seq iwlwifi snd_seq_device aesni_intel snd_timer dell_wmi cec dell_smbios aes_x86_64 crypto_simd dcdbas drm_kms_helper cryptd snd dell_wmi_descriptor cfg80211 glue_helper wmi_bmof intel_wmi_thunderbolt soundcore input_leds rtsx_pci_ms serio_raw drm memstick ucsi_acpi intel_gtt mei_me hid_multitouch processor_thermal_device i2c_algo_bit typec_ucsi fb_sys_fops syscopyarea mei idma64 intel_rapl_common sysfillrect virt_dma intel_xhci_usb_role_switch sysimgblt roles intel_pch_thermal intel_soc_dts_iosf typec soc_button_array intel_vbtn mac_hid intel_hid int3400_thermal int3403_thermal sparse_keymap acpi_thermal_rel int340x_thermal_zone acpi_pad sch_fq_codel parport_pc ppdev lp parport efivarfs ip_tables x_tables autofs4 raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq libcrc32c raid1 raid0 multipath linear usbhid hid_generic
rtsx_pci_sdmmc rtsx_pci
[   90.523071]  i2c_i801 intel_lpss_pci i2c_hid intel_lpss wmi hid pinctrl_sunrisepoint video pinctrl_intel
[   90.523076] CR2: 00000000000000d1
[   90.523078] ---[ end trace 18eaad00960f2049 ]---
[   90.523081] RIP: 0010:ip6_sk_dst_store_flow+0x7b/0xb0
[   90.523082] Code: 48 8b 42 30 48 33 47 40 48 09 c1 0f b6 4f 12 b8 01 00 00 00 4d 0f 45 e1 31 db d3 e0 a9 bf ef ff ff 74 07 48 8b 9f f0 02 00 00 <48> 8b 46 70 31 d2 48 85 c0 74 0c 48 8b 40 10 48 85 c0 74 03 8b 50
[   90.523083] RSP: 0018:ffffbc40c2253d10 EFLAGS: 00010202
[   90.523084] RAX: 0000000000000080 RBX: ffffa01ac2098460 RCX: 0000000000000007
[   90.523085] RDX: ffffbc40c2253d50 RSI: 000000000000007d RDI: ffffa01ac2098000
[   90.523086] RBP: ffffa01ac2098460 R08: 0000000000000000 R09: 0000000000000000
[   90.523087] R10: 83b567a7afeebe71 R11: ffffa01b5e85fb80 R12: ffffa01ac2098038
[   90.523088] R13: 0000000000000000 R14: 0000000000000001 R15: ffffa01ac2098460
[   90.523089] FS:  00007ff174d29a40(0000) GS:ffffa01b6e2c0000(0000) knlGS:0000000000000000
[   90.523090] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   90.523091] CR2: 00000000000000d1 CR3: 00000003cd750006 CR4: 00000000003606e0
[   90.558593] dst_release: dst:00000000c2af7d17 refcnt:-1
[   90.558644] dst_release: dst:00000000c2af7d17 refcnt:-2
[   90.575184] dst_release: dst:00000000c2af7d17 refcnt:-3

