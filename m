Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5136D42A7A8
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 16:52:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237217AbhJLOyl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 10:54:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237147AbhJLOyk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Oct 2021 10:54:40 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8923C061749
        for <netdev@vger.kernel.org>; Tue, 12 Oct 2021 07:52:38 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id pf6-20020a17090b1d8600b0019fa884ab85so2067008pjb.5
        for <netdev@vger.kernel.org>; Tue, 12 Oct 2021 07:52:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amikom.ac.id; s=google;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SqI2PNRgKCBhtVEuRijky26j7MYEps/XUhYv/0G4p9w=;
        b=NzgZ7dv780XSMSksF2NcW7HaWxpUjSzfS8Vde70vFAC4HSvGe4AKxY+fpiCMBGMj6H
         klGEo/8yDKsNy1Z2xYS+0khbQfB5VzMPwiWuKMfeI946ZZWzfsC7BFY2m+VHP5QSGeZT
         bYkCS2FZCFkZZmjDKfHIOln5TraEJRcTxYBCIsk6ExOKKYD8Ey5XmdpdgsJRyRKiZdkH
         vF0tMvzG7J4E7Jwe29r+p2Bl4Ed7Th9HADcrNMqXHQBMzHMLzMQ7O1Aax3kr8UPcQYc5
         60E4n0Vo6VBoofO5s3L/wgsGpAhknNyh+3N6Bt63VDsyLV+kfmwXD7oQQd50Vuf3P69t
         z+vQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SqI2PNRgKCBhtVEuRijky26j7MYEps/XUhYv/0G4p9w=;
        b=SGvv4yvhtQlliGCQIdw1O4yJCikrY3XhIrWJ6GJfZ8pcxQ058A3MwPeSZOIp+ehdLa
         VoZlco5BawX80TAEkG70QR2UZ+4WBsMtw2UHzZf1xMWvCC6jisAGr2J6MZRQ4iqILcL5
         pBpPUptfubEWLtijNyUMASP90D1INMRTMdZpC8NSKXCq+YGM45n2W4ojg4XYJXxEQ8ug
         T235wYUTacE9yYoWLJl+FUPjR4dbO2tzzh7dEl2vrat5YAXsZfpL6wxqYYqZQPWXlG8w
         mOOz45yGe2E/91i3NG+7SlGPFw8ast+mr3u3L0Ac/QDlQN1aSDzCvlDuEfS8wBLnRSG5
         zThw==
X-Gm-Message-State: AOAM530gOc8TxvuzghRlImdYWhHopfrwLZ4dzmzmsXA9YnJZjtiRPQYh
        itIwv7N4Pwb7a5G5QQXqaN9O5g==
X-Google-Smtp-Source: ABdhPJz54bG61mv/7YYeEWSxenNp6qovlBN3SruykwBnbDUGGeEJmk4gRd/9xt1mR7dNBZYODS1onQ==
X-Received: by 2002:a17:90a:9292:: with SMTP id n18mr6419462pjo.120.1634050357617;
        Tue, 12 Oct 2021 07:52:37 -0700 (PDT)
Received: from integral.. ([182.2.71.100])
        by smtp.gmail.com with ESMTPSA id m10sm2991295pjs.21.2021.10.12.07.52.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Oct 2021 07:52:37 -0700 (PDT)
From:   Ammar Faizi <ammar.faizi@students.amikom.ac.id>
X-Google-Original-From: Ammar Faizi <ammarfaizi2@gmail.com>
To:     Johannes Berg <johannes@sipsolutions.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "John W . Linville" <linville@tuxdriver.com>,
        Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>,
        Avraham Stern <avraham.stern@intel.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: WARNING: CPU: 2 PID: 633 at net/wireless/sme.c:974 cfg80211_roamed+0x265/0x2a0 [cfg80211]
Date:   Tue, 12 Oct 2021 21:52:27 +0700
Message-Id: <20211012145227.566254-1-ammarfaizi2@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I am using Jens Axboe's tree.

Last commit from Linus' tree is
9e1ff307c779ce1f0f810c7ecce3d95bbae40896 ("Linux 5.15-rc4").

OS details:
  DISTRIB_ID=3DUbuntu
  DISTRIB_RELEASE=3D21.04
  DISTRIB_CODENAME=3Dhirsute
  DISTRIB_DESCRIPTION=3D"Ubuntu 21.04"
  NAME=3D"Ubuntu"
  VERSION=3D"21.04 (Hirsute Hippo)"
  ID=3Dubuntu
  ID_LIKE=3Ddebian
  PRETTY_NAME=3D"Ubuntu 21.04"
  VERSION_ID=3D"21.04"

I found a kernel warning at net/wireless/sme.c:974. I don't have the
reproducer for it. It's hard to reproduce, because it happens randomly.

I might miss something.

More info:
I am using WiFi on my laptop for general internet use, after several
hours using it, my laptop suddenly freezes for about 3 seconds, then I
can't connect to the internet despite my WiFi is still connected. At
this point, I check dmesg and find these kernel warnings.

If I disconnect and reconnect the WiFi, it works again, but several
moment later, the same will happen again with the same kernel warning.

If anyone has any suggestion what should I do to diagnose this issue,
please guide me, I will be happy to follow it eventhough it may not
solve the problem (I am still happy to try). Maybe recommend me to
compile the kernel with specific configuration, test a patch to fix it
or something.

Here is the log:

<4>[266728.385936][  T633] ------------[ cut here ]------------
<4>[266728.385946][  T633] WARNING: CPU: 2 PID: 633 at net/wireless/sme.c:9=
74 cfg80211_roamed+0x265/0x2a0 [cfg80211]
<4>[266728.386040][  T633] Modules linked in: rfcomm xt_CHECKSUM xt_MASQUER=
ADE xt_conntrack ipt_REJECT nf_reject_ipv4 xt_tcpudp nft_compat nft_chain_n=
at nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 nft_counter nf_tables =
nfnetlink bridge stp llc bfq cmac algif_hash algif_skcipher af_alg bnep dm_=
multipath scsi_dh_rdac scsi_dh_emc scsi_dh_alua snd_hda_codec_realtek snd_h=
da_codec_hdmi uvcvideo snd_hda_codec_generic ledtrig_audio snd_hda_intel vi=
deobuf2_vmalloc snd_intel_dspcfg videobuf2_memops snd_intel_sdw_acpi btusb =
btrtl videobuf2_v4l2 videobuf2_common btbcm snd_hda_codec btintel videodev =
snd_hda_core bluetooth snd_hwdep wl(OE) mc snd_pcm ecdh_generic snd_seq_mid=
i ecc snd_seq_midi_event edac_mce_amd snd_rawmidi kvm_amd acer_wmi snd_seq =
sparse_keymap kvm cfg80211 wmi_bmof input_leds serio_raw snd_seq_device snd=
_timer snd soundcore ccp fam15h_power k10temp mac_hid sch_fq_codel msr ip_t=
ables x_tables autofs4 btrfs blake2b_generic raid10 raid456 async_raid6_rec=
ov async_memcpy async_pq
<4>[266728.386224][  T633]  async_xor async_tx xor raid6_pq libcrc32c raid1=
 raid0 multipath linear amdgpu iommu_v2 gpu_sched radeon i2c_algo_bit drm_t=
tm_helper ttm hid_generic drm_kms_helper syscopyarea usbhid crct10dif_pclmu=
l sysfillrect crc32_pclmul sysimgblt hid ghash_clmulni_intel fb_sys_fops ce=
c aesni_intel rc_core rtsx_pci_sdmmc sdhci_pci crypto_simd cqhci r8169 cryp=
td psmouse ahci xhci_pci rtsx_pci realtek libahci drm sdhci i2c_piix4 xhci_=
pci_renesas wmi video
<4>[266728.386330][  T633] CPU: 2 PID: 633 Comm: wl_event_handle Tainted: G=
        W  OE     5.15.0-rc4-for-5.16-io-uring-00060-g4922ab639eb6 #4 8b24b=
2500a34cedea2e69c8d84eb4c855e713e61
<4>[266728.386337][  T633] Hardware name: Acer Aspire ES1-421/OLVIA_BE, BIO=
S V1.05 07/02/2015
<4>[266728.386341][  T633] RIP: 0010:cfg80211_roamed+0x265/0x2a0 [cfg80211]
<4>[266728.386408][  T633] Code: 4c 89 f7 49 8d 8d 22 01 00 00 45 0f b6 85 =
42 01 00 00 6a 02 48 8b 36 e8 79 ab fc ff 48 89 43 08 5a 48 85 c0 0f 85 d6 =
fd ff ff <0f> 0b 48 8d 65 d8 5b 41 5c 41 5d 41 5e 41 5f 5d c3 0f 0b 48 8b 73
<4>[266728.386412][  T633] RSP: 0018:ffffc9000157bdd8 EFLAGS: 00010246
<4>[266728.386418][  T633] RAX: 0000000000000000 RBX: ffffc9000157be20 RCX:=
 0000000000000000
<4>[266728.386421][  T633] RDX: 0000000000000002 RSI: 0000000000000000 RDI:=
 ffffffff8109ead2
<4>[266728.386425][  T633] RBP: ffffc9000157be10 R08: 0000000000000001 R09:=
 0000000000000001
<4>[266728.386428][  T633] R10: fffffffefb3c8d52 R11: ffff8881328b75b2 R12:=
 0000000000000cc0
<4>[266728.386431][  T633] R13: ffff888105873800 R14: ffff8881328b6580 R15:=
 dead000000000100
<4>[266728.386435][  T633] FS:  0000000000000000(0000) GS:ffff888313d00000(=
0000) knlGS:0000000000000000
<4>[266728.386439][  T633] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
<4>[266728.386443][  T633] CR2: 00007f3033edd000 CR3: 000000011a878000 CR4:=
 00000000000406e0
<4>[266728.386447][  T633] Call Trace:
<4>[266728.386456][  T633]  ? wl_update_bss_info.isra.0+0xf5/0x210 [wl 47ce=
17d152623ac79abb5e1d4a28d4375eb94473]
<4>[266728.386555][  T633]  wl_bss_roaming_done.constprop.0+0xc4/0x100 [wl =
47ce17d152623ac79abb5e1d4a28d4375eb94473]
<4>[266728.386648][  T633]  wl_notify_roaming_status+0x3f/0x60 [wl 47ce17d1=
52623ac79abb5e1d4a28d4375eb94473]
<4>[266728.386730][  T633]  wl_event_handler+0x5f/0x140 [wl 47ce17d152623ac=
79abb5e1d4a28d4375eb94473]
<4>[266728.386808][  T633]  ? wl_cfg80211_del_key+0x100/0x100 [wl 47ce17d15=
2623ac79abb5e1d4a28d4375eb94473]
<4>[266728.386890][  T633]  kthread+0x140/0x160
<4>[266728.386898][  T633]  ? set_kthread_struct+0x40/0x40
<4>[266728.386907][  T633]  ret_from_fork+0x1f/0x30
<4>[266728.386931][  T633] irq event stamp: 435419
<4>[266728.386933][  T633] hardirqs last  enabled at (435425): [<ffffffff81=
126320>] __up_console_sem+0x60/0x70
<4>[266728.386941][  T633] hardirqs last disabled at (435430): [<ffffffff81=
126305>] __up_console_sem+0x45/0x70
<4>[266728.386947][  T633] softirqs last  enabled at (434440): [<ffffffffa1=
059338>] cfg80211_get_bss+0x2c8/0x400 [cfg80211]
<4>[266728.387009][  T633] softirqs last disabled at (434438): [<ffffffffa1=
0590dc>] cfg80211_get_bss+0x6c/0x400 [cfg80211]
<4>[266728.387072][  T633] ---[ end trace bdd7d27535aea25e ]---
<4>[266733.198366][  T633] ------------[ cut here ]------------
<4>[266733.198376][  T633] WARNING: CPU: 1 PID: 633 at net/wireless/sme.c:9=
74 cfg80211_roamed+0x265/0x2a0 [cfg80211]
<4>[266733.198467][  T633] Modules linked in: rfcomm xt_CHECKSUM xt_MASQUER=
ADE xt_conntrack ipt_REJECT nf_reject_ipv4 xt_tcpudp nft_compat nft_chain_n=
at nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 nft_counter nf_tables =
nfnetlink bridge stp llc bfq cmac algif_hash algif_skcipher af_alg bnep dm_=
multipath scsi_dh_rdac scsi_dh_emc scsi_dh_alua snd_hda_codec_realtek snd_h=
da_codec_hdmi uvcvideo snd_hda_codec_generic ledtrig_audio snd_hda_intel vi=
deobuf2_vmalloc snd_intel_dspcfg videobuf2_memops snd_intel_sdw_acpi btusb =
btrtl videobuf2_v4l2 videobuf2_common btbcm snd_hda_codec btintel videodev =
snd_hda_core bluetooth snd_hwdep wl(OE) mc snd_pcm ecdh_generic snd_seq_mid=
i ecc snd_seq_midi_event edac_mce_amd snd_rawmidi kvm_amd acer_wmi snd_seq =
sparse_keymap kvm cfg80211 wmi_bmof input_leds serio_raw snd_seq_device snd=
_timer snd soundcore ccp fam15h_power k10temp mac_hid sch_fq_codel msr ip_t=
ables x_tables autofs4 btrfs blake2b_generic raid10 raid456 async_raid6_rec=
ov async_memcpy async_pq
<4>[266733.198638][  T633]  async_xor async_tx xor raid6_pq libcrc32c raid1=
 raid0 multipath linear amdgpu iommu_v2 gpu_sched radeon i2c_algo_bit drm_t=
tm_helper ttm hid_generic drm_kms_helper syscopyarea usbhid crct10dif_pclmu=
l sysfillrect crc32_pclmul sysimgblt hid ghash_clmulni_intel fb_sys_fops ce=
c aesni_intel rc_core rtsx_pci_sdmmc sdhci_pci crypto_simd cqhci r8169 cryp=
td psmouse ahci xhci_pci rtsx_pci realtek libahci drm sdhci i2c_piix4 xhci_=
pci_renesas wmi video
<4>[266733.198736][  T633] CPU: 1 PID: 633 Comm: wl_event_handle Tainted: G=
        W  OE     5.15.0-rc4-for-5.16-io-uring-00060-g4922ab639eb6 #4 8b24b=
2500a34cedea2e69c8d84eb4c855e713e61
<4>[266733.198743][  T633] Hardware name: Acer Aspire ES1-421/OLVIA_BE, BIO=
S V1.05 07/02/2015
<4>[266733.198748][  T633] RIP: 0010:cfg80211_roamed+0x265/0x2a0 [cfg80211]
<4>[266733.198814][  T633] Code: 4c 89 f7 49 8d 8d 22 01 00 00 45 0f b6 85 =
42 01 00 00 6a 02 48 8b 36 e8 79 ab fc ff 48 89 43 08 5a 48 85 c0 0f 85 d6 =
fd ff ff <0f> 0b 48 8d 65 d8 5b 41 5c 41 5d 41 5e 41 5f 5d c3 0f 0b 48 8b 73
<4>[266733.198819][  T633] RSP: 0018:ffffc9000157bdd8 EFLAGS: 00010246
<4>[266733.198824][  T633] RAX: 0000000000000000 RBX: ffffc9000157be20 RCX:=
 0000000000000000
<4>[266733.198828][  T633] RDX: 0000000000000002 RSI: 0000000000000000 RDI:=
 ffffffff8109ead2
<4>[266733.198832][  T633] RBP: ffffc9000157be10 R08: 0000000000000001 R09:=
 0000000000000001
<4>[266733.198835][  T633] R10: fffffffefb3c87af R11: ffff8881328b75b2 R12:=
 0000000000000cc0
<4>[266733.198838][  T633] R13: ffff888105873800 R14: ffff8881328b6580 R15:=
 dead000000000100
<4>[266733.198842][  T633] FS:  0000000000000000(0000) GS:ffff888313c80000(=
0000) knlGS:0000000000000000
<4>[266733.198846][  T633] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
<4>[266733.198849][  T633] CR2: 00007ffa5b641000 CR3: 0000000114c48000 CR4:=
 00000000000406e0
<4>[266733.198854][  T633] Call Trace:
<4>[266733.198862][  T633]  ? wl_update_bss_info.isra.0+0xf5/0x210 [wl 47ce=
17d152623ac79abb5e1d4a28d4375eb94473]
<4>[266733.198965][  T633]  wl_bss_roaming_done.constprop.0+0xc4/0x100 [wl =
47ce17d152623ac79abb5e1d4a28d4375eb94473]
<4>[266733.199059][  T633]  wl_notify_roaming_status+0x3f/0x60 [wl 47ce17d1=
52623ac79abb5e1d4a28d4375eb94473]
<4>[266733.199140][  T633]  wl_event_handler+0x5f/0x140 [wl 47ce17d152623ac=
79abb5e1d4a28d4375eb94473]
<4>[266733.199219][  T633]  ? wl_cfg80211_del_key+0x100/0x100 [wl 47ce17d15=
2623ac79abb5e1d4a28d4375eb94473]
<4>[266733.199301][  T633]  kthread+0x140/0x160
<4>[266733.199310][  T633]  ? set_kthread_struct+0x40/0x40
<4>[266733.199319][  T633]  ret_from_fork+0x1f/0x30
<4>[266733.199343][  T633] irq event stamp: 436605
<4>[266733.199346][  T633] hardirqs last  enabled at (436611): [<ffffffff81=
126320>] __up_console_sem+0x60/0x70
<4>[266733.199354][  T633] hardirqs last disabled at (436616): [<ffffffff81=
126305>] __up_console_sem+0x45/0x70
<4>[266733.199360][  T633] softirqs last  enabled at (435626): [<ffffffffa1=
059338>] cfg80211_get_bss+0x2c8/0x400 [cfg80211]
<4>[266733.199423][  T633] softirqs last disabled at (435624): [<ffffffffa1=
0590dc>] cfg80211_get_bss+0x6c/0x400 [cfg80211]
<4>[266733.199485][  T633] ---[ end trace bdd7d27535aea25f ]---
<4>[266738.114113][  T633] ------------[ cut here ]------------
<4>[266738.114122][  T633] WARNING: CPU: 2 PID: 633 at net/wireless/sme.c:9=
74 cfg80211_roamed+0x265/0x2a0 [cfg80211]
<4>[266738.114211][  T633] Modules linked in: rfcomm xt_CHECKSUM xt_MASQUER=
ADE xt_conntrack ipt_REJECT nf_reject_ipv4 xt_tcpudp nft_compat nft_chain_n=
at nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 nft_counter nf_tables =
nfnetlink bridge stp llc bfq cmac algif_hash algif_skcipher af_alg bnep dm_=
multipath scsi_dh_rdac scsi_dh_emc scsi_dh_alua snd_hda_codec_realtek snd_h=
da_codec_hdmi uvcvideo snd_hda_codec_generic ledtrig_audio snd_hda_intel vi=
deobuf2_vmalloc snd_intel_dspcfg videobuf2_memops snd_intel_sdw_acpi btusb =
btrtl videobuf2_v4l2 videobuf2_common btbcm snd_hda_codec btintel videodev =
snd_hda_core bluetooth snd_hwdep wl(OE) mc snd_pcm ecdh_generic snd_seq_mid=
i ecc snd_seq_midi_event edac_mce_amd snd_rawmidi kvm_amd acer_wmi snd_seq =
sparse_keymap kvm cfg80211 wmi_bmof input_leds serio_raw snd_seq_device snd=
_timer snd soundcore ccp fam15h_power k10temp mac_hid sch_fq_codel msr ip_t=
ables x_tables autofs4 btrfs blake2b_generic raid10 raid456 async_raid6_rec=
ov async_memcpy async_pq
<4>[266738.114382][  T633]  async_xor async_tx xor raid6_pq libcrc32c raid1=
 raid0 multipath linear amdgpu iommu_v2 gpu_sched radeon i2c_algo_bit drm_t=
tm_helper ttm hid_generic drm_kms_helper syscopyarea usbhid crct10dif_pclmu=
l sysfillrect crc32_pclmul sysimgblt hid ghash_clmulni_intel fb_sys_fops ce=
c aesni_intel rc_core rtsx_pci_sdmmc sdhci_pci crypto_simd cqhci r8169 cryp=
td psmouse ahci xhci_pci rtsx_pci realtek libahci drm sdhci i2c_piix4 xhci_=
pci_renesas wmi video
<4>[266738.114480][  T633] CPU: 2 PID: 633 Comm: wl_event_handle Tainted: G=
        W  OE     5.15.0-rc4-for-5.16-io-uring-00060-g4922ab639eb6 #4 8b24b=
2500a34cedea2e69c8d84eb4c855e713e61
<4>[266738.114487][  T633] Hardware name: Acer Aspire ES1-421/OLVIA_BE, BIO=
S V1.05 07/02/2015
<4>[266738.114491][  T633] RIP: 0010:cfg80211_roamed+0x265/0x2a0 [cfg80211]
<4>[266738.114566][  T633] Code: 4c 89 f7 49 8d 8d 22 01 00 00 45 0f b6 85 =
42 01 00 00 6a 02 48 8b 36 e8 79 ab fc ff 48 89 43 08 5a 48 85 c0 0f 85 d6 =
fd ff ff <0f> 0b 48 8d 65 d8 5b 41 5c 41 5d 41 5e 41 5f 5d c3 0f 0b 48 8b 73
<4>[266738.114571][  T633] RSP: 0018:ffffc9000157bdd8 EFLAGS: 00010246
<4>[266738.114577][  T633] RAX: 0000000000000000 RBX: ffffc9000157be20 RCX:=
 0000000000000000
<4>[266738.114581][  T633] RDX: 0000000000000002 RSI: 0000000000000000 RDI:=
 ffffffff8109ead2
<4>[266738.114585][  T633] RBP: ffffc9000157be10 R08: 0000000000000001 R09:=
 0000000000000001
<4>[266738.114588][  T633] R10: fffffffefb3c81ed R11: ffff8881328b75b2 R12:=
 0000000000000cc0
<4>[266738.114592][  T633] R13: ffff888105873800 R14: ffff8881328b6580 R15:=
 dead000000000100
<4>[266738.114596][  T633] FS:  0000000000000000(0000) GS:ffff888313d00000(=
0000) knlGS:0000000000000000
<4>[266738.114601][  T633] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
<4>[266738.114604][  T633] CR2: 000011fdd5d39000 CR3: 000000011a878000 CR4:=
 00000000000406e0
<4>[266738.114609][  T633] Call Trace:
<4>[266738.114618][  T633]  ? wl_update_bss_info.isra.0+0xf5/0x210 [wl 47ce=
17d152623ac79abb5e1d4a28d4375eb94473]
<4>[266738.114724][  T633]  wl_bss_roaming_done.constprop.0+0xc4/0x100 [wl =
47ce17d152623ac79abb5e1d4a28d4375eb94473]
<4>[266738.114826][  T633]  wl_notify_roaming_status+0x3f/0x60 [wl 47ce17d1=
52623ac79abb5e1d4a28d4375eb94473]
<4>[266738.114915][  T633]  wl_event_handler+0x5f/0x140 [wl 47ce17d152623ac=
79abb5e1d4a28d4375eb94473]
<4>[266738.115001][  T633]  ? wl_cfg80211_del_key+0x100/0x100 [wl 47ce17d15=
2623ac79abb5e1d4a28d4375eb94473]
<4>[266738.115090][  T633]  kthread+0x140/0x160
<4>[266738.115099][  T633]  ? set_kthread_struct+0x40/0x40
<4>[266738.115108][  T633]  ret_from_fork+0x1f/0x30
<4>[266738.115135][  T633] irq event stamp: 437791
<4>[266738.115137][  T633] hardirqs last  enabled at (437797): [<ffffffff81=
126320>] __up_console_sem+0x60/0x70
<4>[266738.115146][  T633] hardirqs last disabled at (437802): [<ffffffff81=
126305>] __up_console_sem+0x45/0x70
<4>[266738.115153][  T633] softirqs last  enabled at (436812): [<ffffffffa1=
059338>] cfg80211_get_bss+0x2c8/0x400 [cfg80211]
<4>[266738.115221][  T633] softirqs last disabled at (436810): [<ffffffffa1=
0590dc>] cfg80211_get_bss+0x6c/0x400 [cfg80211]
<4>[266738.115289][  T633] ---[ end trace bdd7d27535aea260 ]---
<4>[266742.929898][  T633] ------------[ cut here ]------------
<4>[266742.929908][  T633] WARNING: CPU: 1 PID: 633 at net/wireless/sme.c:9=
74 cfg80211_roamed+0x265/0x2a0 [cfg80211]
<4>[266742.930006][  T633] Modules linked in: rfcomm xt_CHECKSUM xt_MASQUER=
ADE xt_conntrack ipt_REJECT nf_reject_ipv4 xt_tcpudp nft_compat nft_chain_n=
at nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 nft_counter nf_tables =
nfnetlink bridge stp llc bfq cmac algif_hash algif_skcipher af_alg bnep dm_=
multipath scsi_dh_rdac scsi_dh_emc scsi_dh_alua snd_hda_codec_realtek snd_h=
da_codec_hdmi uvcvideo snd_hda_codec_generic ledtrig_audio snd_hda_intel vi=
deobuf2_vmalloc snd_intel_dspcfg videobuf2_memops snd_intel_sdw_acpi btusb =
btrtl videobuf2_v4l2 videobuf2_common btbcm snd_hda_codec btintel videodev =
snd_hda_core bluetooth snd_hwdep wl(OE) mc snd_pcm ecdh_generic snd_seq_mid=
i ecc snd_seq_midi_event edac_mce_amd snd_rawmidi kvm_amd acer_wmi snd_seq =
sparse_keymap kvm cfg80211 wmi_bmof input_leds serio_raw snd_seq_device snd=
_timer snd soundcore ccp fam15h_power k10temp mac_hid sch_fq_codel msr ip_t=
ables x_tables autofs4 btrfs blake2b_generic raid10 raid456 async_raid6_rec=
ov async_memcpy async_pq
<4>[266742.930188][  T633]  async_xor async_tx xor raid6_pq libcrc32c raid1=
 raid0 multipath linear amdgpu iommu_v2 gpu_sched radeon i2c_algo_bit drm_t=
tm_helper ttm hid_generic drm_kms_helper syscopyarea usbhid crct10dif_pclmu=
l sysfillrect crc32_pclmul sysimgblt hid ghash_clmulni_intel fb_sys_fops ce=
c aesni_intel rc_core rtsx_pci_sdmmc sdhci_pci crypto_simd cqhci r8169 cryp=
td psmouse ahci xhci_pci rtsx_pci realtek libahci drm sdhci i2c_piix4 xhci_=
pci_renesas wmi video
<4>[266742.930294][  T633] CPU: 1 PID: 633 Comm: wl_event_handle Tainted: G=
        W  OE     5.15.0-rc4-for-5.16-io-uring-00060-g4922ab639eb6 #4 8b24b=
2500a34cedea2e69c8d84eb4c855e713e61
<4>[266742.930302][  T633] Hardware name: Acer Aspire ES1-421/OLVIA_BE, BIO=
S V1.05 07/02/2015
<4>[266742.930306][  T633] RIP: 0010:cfg80211_roamed+0x265/0x2a0 [cfg80211]
<4>[266742.930379][  T633] Code: 4c 89 f7 49 8d 8d 22 01 00 00 45 0f b6 85 =
42 01 00 00 6a 02 48 8b 36 e8 79 ab fc ff 48 89 43 08 5a 48 85 c0 0f 85 d6 =
fd ff ff <0f> 0b 48 8d 65 d8 5b 41 5c 41 5d 41 5e 41 5f 5d c3 0f 0b 48 8b 73
<4>[266742.930384][  T633] RSP: 0018:ffffc9000157bdd8 EFLAGS: 00010246
<4>[266742.930390][  T633] RAX: 0000000000000000 RBX: ffffc9000157be20 RCX:=
 0000000000000000
<4>[266742.930394][  T633] RDX: 0000000000000002 RSI: 0000000000000000 RDI:=
 ffffffff8109ead2
<4>[266742.930398][  T633] RBP: ffffc9000157be10 R08: 0000000000000001 R09:=
 0000000000000001
<4>[266742.930401][  T633] R10: fffffffefb3c7c49 R11: ffff8881328b75b2 R12:=
 0000000000000cc0
<4>[266742.930405][  T633] R13: ffff888105873800 R14: ffff8881328b6580 R15:=
 dead000000000100
<4>[266742.930409][  T633] FS:  0000000000000000(0000) GS:ffff888313c80000(=
0000) knlGS:0000000000000000
<4>[266742.930414][  T633] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
<4>[266742.930417][  T633] CR2: 00007ff9eb020000 CR3: 000000011a878000 CR4:=
 00000000000406e0
<4>[266742.930422][  T633] Call Trace:
<4>[266742.930430][  T633]  ? wl_update_bss_info.isra.0+0xf5/0x210 [wl 47ce=
17d152623ac79abb5e1d4a28d4375eb94473]
<4>[266742.930543][  T633]  wl_bss_roaming_done.constprop.0+0xc4/0x100 [wl =
47ce17d152623ac79abb5e1d4a28d4375eb94473]
<4>[266742.930651][  T633]  wl_notify_roaming_status+0x3f/0x60 [wl 47ce17d1=
52623ac79abb5e1d4a28d4375eb94473]
<4>[266742.930733][  T633]  wl_event_handler+0x5f/0x140 [wl 47ce17d152623ac=
79abb5e1d4a28d4375eb94473]
<4>[266742.930811][  T633]  ? wl_cfg80211_del_key+0x100/0x100 [wl 47ce17d15=
2623ac79abb5e1d4a28d4375eb94473]
<4>[266742.930893][  T633]  kthread+0x140/0x160
<4>[266742.930903][  T633]  ? set_kthread_struct+0x40/0x40
<4>[266742.930911][  T633]  ret_from_fork+0x1f/0x30
<4>[266742.930935][  T633] irq event stamp: 438977
<4>[266742.930938][  T633] hardirqs last  enabled at (438983): [<ffffffff81=
126320>] __up_console_sem+0x60/0x70
<4>[266742.930947][  T633] hardirqs last disabled at (438988): [<ffffffff81=
126305>] __up_console_sem+0x45/0x70
<4>[266742.930953][  T633] softirqs last  enabled at (437998): [<ffffffffa1=
059338>] cfg80211_get_bss+0x2c8/0x400 [cfg80211]
<4>[266742.931015][  T633] softirqs last disabled at (437996): [<ffffffffa1=
0590dc>] cfg80211_get_bss+0x6c/0x400 [cfg80211]
<4>[266742.931078][  T633] ---[ end trace bdd7d27535aea261 ]---
<4>[266747.737176][  T633] ------------[ cut here ]------------
<4>[266747.737189][  T633] WARNING: CPU: 3 PID: 633 at net/wireless/sme.c:9=
74 cfg80211_roamed+0x265/0x2a0 [cfg80211]
<4>[266747.737282][  T633] Modules linked in: rfcomm xt_CHECKSUM xt_MASQUER=
ADE xt_conntrack ipt_REJECT nf_reject_ipv4 xt_tcpudp nft_compat nft_chain_n=
at nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 nft_counter nf_tables =
nfnetlink bridge stp llc bfq cmac algif_hash algif_skcipher af_alg bnep dm_=
multipath scsi_dh_rdac scsi_dh_emc scsi_dh_alua snd_hda_codec_realtek snd_h=
da_codec_hdmi uvcvideo snd_hda_codec_generic ledtrig_audio snd_hda_intel vi=
deobuf2_vmalloc snd_intel_dspcfg videobuf2_memops snd_intel_sdw_acpi btusb =
btrtl videobuf2_v4l2 videobuf2_common btbcm snd_hda_codec btintel videodev =
snd_hda_core bluetooth snd_hwdep wl(OE) mc snd_pcm ecdh_generic snd_seq_mid=
i ecc snd_seq_midi_event edac_mce_amd snd_rawmidi kvm_amd acer_wmi snd_seq =
sparse_keymap kvm cfg80211 wmi_bmof input_leds serio_raw snd_seq_device snd=
_timer snd soundcore ccp fam15h_power k10temp mac_hid sch_fq_codel msr ip_t=
ables x_tables autofs4 btrfs blake2b_generic raid10 raid456 async_raid6_rec=
ov async_memcpy async_pq
<4>[266747.737463][  T633]  async_xor async_tx xor raid6_pq libcrc32c raid1=
 raid0 multipath linear amdgpu iommu_v2 gpu_sched radeon i2c_algo_bit drm_t=
tm_helper ttm hid_generic drm_kms_helper syscopyarea usbhid crct10dif_pclmu=
l sysfillrect crc32_pclmul sysimgblt hid ghash_clmulni_intel fb_sys_fops ce=
c aesni_intel rc_core rtsx_pci_sdmmc sdhci_pci crypto_simd cqhci r8169 cryp=
td psmouse ahci xhci_pci rtsx_pci realtek libahci drm sdhci i2c_piix4 xhci_=
pci_renesas wmi video
<4>[266747.737568][  T633] CPU: 3 PID: 633 Comm: wl_event_handle Tainted: G=
        W  OE     5.15.0-rc4-for-5.16-io-uring-00060-g4922ab639eb6 #4 8b24b=
2500a34cedea2e69c8d84eb4c855e713e61
<4>[266747.737576][  T633] Hardware name: Acer Aspire ES1-421/OLVIA_BE, BIO=
S V1.05 07/02/2015
<4>[266747.737580][  T633] RIP: 0010:cfg80211_roamed+0x265/0x2a0 [cfg80211]
<4>[266747.737653][  T633] Code: 4c 89 f7 49 8d 8d 22 01 00 00 45 0f b6 85 =
42 01 00 00 6a 02 48 8b 36 e8 79 ab fc ff 48 89 43 08 5a 48 85 c0 0f 85 d6 =
fd ff ff <0f> 0b 48 8d 65 d8 5b 41 5c 41 5d 41 5e 41 5f 5d c3 0f 0b 48 8b 73
<4>[266747.737658][  T633] RSP: 0018:ffffc9000157bdd8 EFLAGS: 00010246
<4>[266747.737664][  T633] RAX: 0000000000000000 RBX: ffffc9000157be20 RCX:=
 0000000000000000
<4>[266747.737668][  T633] RDX: 0000000000000002 RSI: 0000000000000000 RDI:=
 ffffffff8109ead2
<4>[266747.737671][  T633] RBP: ffffc9000157be10 R08: 0000000000000001 R09:=
 0000000000000001
<4>[266747.737675][  T633] R10: fffffffefb3c76a8 R11: ffff8881328b75b2 R12:=
 0000000000000cc0
<4>[266747.737679][  T633] R13: ffff888105873800 R14: ffff8881328b6580 R15:=
 dead000000000100
<4>[266747.737683][  T633] FS:  0000000000000000(0000) GS:ffff888313d80000(=
0000) knlGS:0000000000000000
<4>[266747.737687][  T633] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
<4>[266747.737691][  T633] CR2: 00001fd1a673af38 CR3: 000000011a878000 CR4:=
 00000000000406e0
<4>[266747.737695][  T633] Call Trace:
<4>[266747.737704][  T633]  ? wl_update_bss_info.isra.0+0xf5/0x210 [wl 47ce=
17d152623ac79abb5e1d4a28d4375eb94473]
<4>[266747.737810][  T633]  wl_bss_roaming_done.constprop.0+0xc4/0x100 [wl =
47ce17d152623ac79abb5e1d4a28d4375eb94473]
<4>[266747.737911][  T633]  wl_notify_roaming_status+0x3f/0x60 [wl 47ce17d1=
52623ac79abb5e1d4a28d4375eb94473]
<4>[266747.738000][  T633]  wl_event_handler+0x5f/0x140 [wl 47ce17d152623ac=
79abb5e1d4a28d4375eb94473]
<4>[266747.738085][  T633]  ? wl_cfg80211_del_key+0x100/0x100 [wl 47ce17d15=
2623ac79abb5e1d4a28d4375eb94473]
<4>[266747.738174][  T633]  kthread+0x140/0x160
<4>[266747.738183][  T633]  ? set_kthread_struct+0x40/0x40
<4>[266747.738192][  T633]  ret_from_fork+0x1f/0x30
<4>[266747.738217][  T633] irq event stamp: 440159
<4>[266747.738221][  T633] hardirqs last  enabled at (440165): [<ffffffff81=
126320>] __up_console_sem+0x60/0x70
<4>[266747.738229][  T633] hardirqs last disabled at (440170): [<ffffffff81=
126305>] __up_console_sem+0x45/0x70
<4>[266747.738236][  T633] softirqs last  enabled at (439180): [<ffffffffa1=
059338>] cfg80211_get_bss+0x2c8/0x400 [cfg80211]
<4>[266747.738304][  T633] softirqs last disabled at (439178): [<ffffffffa1=
0590dc>] cfg80211_get_bss+0x6c/0x400 [cfg80211]
<4>[266747.738372][  T633] ---[ end trace bdd7d27535aea262 ]---
<4>[266752.658071][  T633] ------------[ cut here ]------------
<4>[266752.658081][  T633] WARNING: CPU: 3 PID: 633 at net/wireless/sme.c:9=
74 cfg80211_roamed+0x265/0x2a0 [cfg80211]
<4>[266752.658169][  T633] Modules linked in: rfcomm xt_CHECKSUM xt_MASQUER=
ADE xt_conntrack ipt_REJECT nf_reject_ipv4 xt_tcpudp nft_compat nft_chain_n=
at nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 nft_counter nf_tables =
nfnetlink bridge stp llc bfq cmac algif_hash algif_skcipher af_alg bnep dm_=
multipath scsi_dh_rdac scsi_dh_emc scsi_dh_alua snd_hda_codec_realtek snd_h=
da_codec_hdmi uvcvideo snd_hda_codec_generic ledtrig_audio snd_hda_intel vi=
deobuf2_vmalloc snd_intel_dspcfg videobuf2_memops snd_intel_sdw_acpi btusb =
btrtl videobuf2_v4l2 videobuf2_common btbcm snd_hda_codec btintel videodev =
snd_hda_core bluetooth snd_hwdep wl(OE) mc snd_pcm ecdh_generic snd_seq_mid=
i ecc snd_seq_midi_event edac_mce_amd snd_rawmidi kvm_amd acer_wmi snd_seq =
sparse_keymap kvm cfg80211 wmi_bmof input_leds serio_raw snd_seq_device snd=
_timer snd soundcore ccp fam15h_power k10temp mac_hid sch_fq_codel msr ip_t=
ables x_tables autofs4 btrfs blake2b_generic raid10 raid456 async_raid6_rec=
ov async_memcpy async_pq
<4>[266752.658357][  T633]  async_xor async_tx xor raid6_pq libcrc32c raid1=
 raid0 multipath linear amdgpu iommu_v2 gpu_sched radeon i2c_algo_bit drm_t=
tm_helper ttm hid_generic drm_kms_helper syscopyarea usbhid crct10dif_pclmu=
l sysfillrect crc32_pclmul sysimgblt hid ghash_clmulni_intel fb_sys_fops ce=
c aesni_intel rc_core rtsx_pci_sdmmc sdhci_pci crypto_simd cqhci r8169 cryp=
td psmouse ahci xhci_pci rtsx_pci realtek libahci drm sdhci i2c_piix4 xhci_=
pci_renesas wmi video
<4>[266752.658462][  T633] CPU: 3 PID: 633 Comm: wl_event_handle Tainted: G=
        W  OE     5.15.0-rc4-for-5.16-io-uring-00060-g4922ab639eb6 #4 8b24b=
2500a34cedea2e69c8d84eb4c855e713e61
<4>[266752.658469][  T633] Hardware name: Acer Aspire ES1-421/OLVIA_BE, BIO=
S V1.05 07/02/2015
<4>[266752.658473][  T633] RIP: 0010:cfg80211_roamed+0x265/0x2a0 [cfg80211]
<4>[266752.658540][  T633] Code: 4c 89 f7 49 8d 8d 22 01 00 00 45 0f b6 85 =
42 01 00 00 6a 02 48 8b 36 e8 79 ab fc ff 48 89 43 08 5a 48 85 c0 0f 85 d6 =
fd ff ff <0f> 0b 48 8d 65 d8 5b 41 5c 41 5d 41 5e 41 5f 5d c3 0f 0b 48 8b 73
<4>[266752.658545][  T633] RSP: 0018:ffffc9000157bdd8 EFLAGS: 00010246
<4>[266752.658550][  T633] RAX: 0000000000000000 RBX: ffffc9000157be20 RCX:=
 0000000000000000
<4>[266752.658554][  T633] RDX: 0000000000000002 RSI: 0000000000000000 RDI:=
 ffffffff8109ead2
<4>[266752.658558][  T633] RBP: ffffc9000157be10 R08: 0000000000000001 R09:=
 0000000000000001
<4>[266752.658561][  T633] R10: fffffffefb3c70e4 R11: ffff8881328b75b2 R12:=
 0000000000000cc0
<4>[266752.658564][  T633] R13: ffff888105873800 R14: ffff8881328b6580 R15:=
 dead000000000100
<4>[266752.658568][  T633] FS:  0000000000000000(0000) GS:ffff888313d80000(=
0000) knlGS:0000000000000000
<4>[266752.658572][  T633] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
<4>[266752.658576][  T633] CR2: 00007f961c6cc000 CR3: 0000000133b98000 CR4:=
 00000000000406e0
<4>[266752.658580][  T633] Call Trace:
<4>[266752.658589][  T633]  ? wl_update_bss_info.isra.0+0xf5/0x210 [wl 47ce=
17d152623ac79abb5e1d4a28d4375eb94473]
<4>[266752.658688][  T633]  wl_bss_roaming_done.constprop.0+0xc4/0x100 [wl =
47ce17d152623ac79abb5e1d4a28d4375eb94473]
<4>[266752.658781][  T633]  wl_notify_roaming_status+0x3f/0x60 [wl 47ce17d1=
52623ac79abb5e1d4a28d4375eb94473]
<4>[266752.658863][  T633]  wl_event_handler+0x5f/0x140 [wl 47ce17d152623ac=
79abb5e1d4a28d4375eb94473]
<4>[266752.658951][  T633]  ? wl_cfg80211_del_key+0x100/0x100 [wl 47ce17d15=
2623ac79abb5e1d4a28d4375eb94473]
<4>[266752.659040][  T633]  kthread+0x140/0x160
<4>[266752.659050][  T633]  ? set_kthread_struct+0x40/0x40
<4>[266752.659059][  T633]  ret_from_fork+0x1f/0x30
<4>[266752.659084][  T633] irq event stamp: 441347
<4>[266752.659087][  T633] hardirqs last  enabled at (441353): [<ffffffff81=
126320>] __up_console_sem+0x60/0x70
<4>[266752.659096][  T633] hardirqs last disabled at (441358): [<ffffffff81=
126305>] __up_console_sem+0x45/0x70
<4>[266752.659103][  T633] softirqs last  enabled at (440366): [<ffffffffa1=
059338>] cfg80211_get_bss+0x2c8/0x400 [cfg80211]
<4>[266752.659171][  T633] softirqs last disabled at (440364): [<ffffffffa1=
0590dc>] cfg80211_get_bss+0x6c/0x400 [cfg80211]
<4>[266752.659239][  T633] ---[ end trace bdd7d27535aea263 ]---
<4>[266757.467138][  T633] ------------[ cut here ]------------
<4>[266757.467149][  T633] WARNING: CPU: 0 PID: 633 at net/wireless/sme.c:9=
74 cfg80211_roamed+0x265/0x2a0 [cfg80211]
<4>[266757.467251][  T633] Modules linked in: rfcomm xt_CHECKSUM xt_MASQUER=
ADE xt_conntrack ipt_REJECT nf_reject_ipv4 xt_tcpudp nft_compat nft_chain_n=
at nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 nft_counter nf_tables =
nfnetlink bridge stp llc bfq cmac algif_hash algif_skcipher af_alg bnep dm_=
multipath scsi_dh_rdac scsi_dh_emc scsi_dh_alua snd_hda_codec_realtek snd_h=
da_codec_hdmi uvcvideo snd_hda_codec_generic ledtrig_audio snd_hda_intel vi=
deobuf2_vmalloc snd_intel_dspcfg videobuf2_memops snd_intel_sdw_acpi btusb =
btrtl videobuf2_v4l2 videobuf2_common btbcm snd_hda_codec btintel videodev =
snd_hda_core bluetooth snd_hwdep wl(OE) mc snd_pcm ecdh_generic snd_seq_mid=
i ecc snd_seq_midi_event edac_mce_amd snd_rawmidi kvm_amd acer_wmi snd_seq =
sparse_keymap kvm cfg80211 wmi_bmof input_leds serio_raw snd_seq_device snd=
_timer snd soundcore ccp fam15h_power k10temp mac_hid sch_fq_codel msr ip_t=
ables x_tables autofs4 btrfs blake2b_generic raid10 raid456 async_raid6_rec=
ov async_memcpy async_pq
<4>[266757.467447][  T633]  async_xor async_tx xor raid6_pq libcrc32c raid1=
 raid0 multipath linear amdgpu iommu_v2 gpu_sched radeon i2c_algo_bit drm_t=
tm_helper ttm hid_generic drm_kms_helper syscopyarea usbhid crct10dif_pclmu=
l sysfillrect crc32_pclmul sysimgblt hid ghash_clmulni_intel fb_sys_fops ce=
c aesni_intel rc_core rtsx_pci_sdmmc sdhci_pci crypto_simd cqhci r8169 cryp=
td psmouse ahci xhci_pci rtsx_pci realtek libahci drm sdhci i2c_piix4 xhci_=
pci_renesas wmi video
<4>[266757.467569][  T633] CPU: 0 PID: 633 Comm: wl_event_handle Tainted: G=
        W  OE     5.15.0-rc4-for-5.16-io-uring-00060-g4922ab639eb6 #4 8b24b=
2500a34cedea2e69c8d84eb4c855e713e61
<4>[266757.467580][  T633] Hardware name: Acer Aspire ES1-421/OLVIA_BE, BIO=
S V1.05 07/02/2015
<4>[266757.467584][  T633] RIP: 0010:cfg80211_roamed+0x265/0x2a0 [cfg80211]
<4>[266757.467670][  T633] Code: 4c 89 f7 49 8d 8d 22 01 00 00 45 0f b6 85 =
42 01 00 00 6a 02 48 8b 36 e8 79 ab fc ff 48 89 43 08 5a 48 85 c0 0f 85 d6 =
fd ff ff <0f> 0b 48 8d 65 d8 5b 41 5c 41 5d 41 5e 41 5f 5d c3 0f 0b 48 8b 73
<4>[266757.467675][  T633] RSP: 0018:ffffc9000157bdd8 EFLAGS: 00010246
<4>[266757.467681][  T633] RAX: 0000000000000000 RBX: ffffc9000157be20 RCX:=
 0000000000000000
<4>[266757.467685][  T633] RDX: 0000000000000002 RSI: 0000000000000000 RDI:=
 ffffffff8109ead2
<4>[266757.467688][  T633] RBP: ffffc9000157be10 R08: 0000000000000001 R09:=
 0000000000000001
<4>[266757.467692][  T633] R10: fffffffefb3c6b42 R11: ffff8881328b75b2 R12:=
 0000000000000cc0
<4>[266757.467696][  T633] R13: ffff888105873800 R14: ffff8881328b6580 R15:=
 dead000000000100
<4>[266757.467700][  T633] FS:  0000000000000000(0000) GS:ffff888313c00000(=
0000) knlGS:0000000000000000
<4>[266757.467704][  T633] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
<4>[266757.467708][  T633] CR2: 00007f71a05b6008 CR3: 000000011a878000 CR4:=
 00000000000406f0
<4>[266757.467713][  T633] Call Trace:
<4>[266757.467721][  T633]  ? wl_update_bss_info.isra.0+0xf5/0x210 [wl 47ce=
17d152623ac79abb5e1d4a28d4375eb94473]
<4>[266757.467865][  T633]  wl_bss_roaming_done.constprop.0+0xc4/0x100 [wl =
47ce17d152623ac79abb5e1d4a28d4375eb94473]
<4>[266757.467968][  T633]  wl_notify_roaming_status+0x3f/0x60 [wl 47ce17d1=
52623ac79abb5e1d4a28d4375eb94473]
<4>[266757.468057][  T633]  wl_event_handler+0x5f/0x140 [wl 47ce17d152623ac=
79abb5e1d4a28d4375eb94473]
<4>[266757.468143][  T633]  ? wl_cfg80211_del_key+0x100/0x100 [wl 47ce17d15=
2623ac79abb5e1d4a28d4375eb94473]
<4>[266757.468232][  T633]  kthread+0x140/0x160
<4>[266757.468243][  T633]  ? set_kthread_struct+0x40/0x40
<4>[266757.468252][  T633]  ret_from_fork+0x1f/0x30
<4>[266757.468278][  T633] irq event stamp: 442525
<4>[266757.468281][  T633] hardirqs last  enabled at (442531): [<ffffffff81=
126320>] __up_console_sem+0x60/0x70
<4>[266757.468289][  T633] hardirqs last disabled at (442536): [<ffffffff81=
126305>] __up_console_sem+0x45/0x70
<4>[266757.468296][  T633] softirqs last  enabled at (441544): [<ffffffffa1=
059338>] cfg80211_get_bss+0x2c8/0x400 [cfg80211]
<4>[266757.468369][  T633] softirqs last disabled at (441542): [<ffffffffa1=
0590dc>] cfg80211_get_bss+0x6c/0x400 [cfg80211]
<4>[266757.468437][  T633] ---[ end trace bdd7d27535aea264 ]---
<4>[266762.382898][  T633] ------------[ cut here ]------------
<4>[266762.382907][  T633] WARNING: CPU: 2 PID: 633 at net/wireless/sme.c:9=
74 cfg80211_roamed+0x265/0x2a0 [cfg80211]
<4>[266762.382996][  T633] Modules linked in: rfcomm xt_CHECKSUM xt_MASQUER=
ADE xt_conntrack ipt_REJECT nf_reject_ipv4 xt_tcpudp nft_compat nft_chain_n=
at nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 nft_counter nf_tables =
nfnetlink bridge stp llc bfq cmac algif_hash algif_skcipher af_alg bnep dm_=
multipath scsi_dh_rdac scsi_dh_emc scsi_dh_alua snd_hda_codec_realtek snd_h=
da_codec_hdmi uvcvideo snd_hda_codec_generic ledtrig_audio snd_hda_intel vi=
deobuf2_vmalloc snd_intel_dspcfg videobuf2_memops snd_intel_sdw_acpi btusb =
btrtl videobuf2_v4l2 videobuf2_common btbcm snd_hda_codec btintel videodev =
snd_hda_core bluetooth snd_hwdep wl(OE) mc snd_pcm ecdh_generic snd_seq_mid=
i ecc snd_seq_midi_event edac_mce_amd snd_rawmidi kvm_amd acer_wmi snd_seq =
sparse_keymap kvm cfg80211 wmi_bmof input_leds serio_raw snd_seq_device snd=
_timer snd soundcore ccp fam15h_power k10temp mac_hid sch_fq_codel msr ip_t=
ables x_tables autofs4 btrfs blake2b_generic raid10 raid456 async_raid6_rec=
ov async_memcpy async_pq
<4>[266762.383166][  T633]  async_xor async_tx xor raid6_pq libcrc32c raid1=
 raid0 multipath linear amdgpu iommu_v2 gpu_sched radeon i2c_algo_bit drm_t=
tm_helper ttm hid_generic drm_kms_helper syscopyarea usbhid crct10dif_pclmu=
l sysfillrect crc32_pclmul sysimgblt hid ghash_clmulni_intel fb_sys_fops ce=
c aesni_intel rc_core rtsx_pci_sdmmc sdhci_pci crypto_simd cqhci r8169 cryp=
td psmouse ahci xhci_pci rtsx_pci realtek libahci drm sdhci i2c_piix4 xhci_=
pci_renesas wmi video
<4>[266762.383274][  T633] CPU: 2 PID: 633 Comm: wl_event_handle Tainted: G=
        W  OE     5.15.0-rc4-for-5.16-io-uring-00060-g4922ab639eb6 #4 8b24b=
2500a34cedea2e69c8d84eb4c855e713e61
<4>[266762.383282][  T633] Hardware name: Acer Aspire ES1-421/OLVIA_BE, BIO=
S V1.05 07/02/2015
<4>[266762.383286][  T633] RIP: 0010:cfg80211_roamed+0x265/0x2a0 [cfg80211]
<4>[266762.383359][  T633] Code: 4c 89 f7 49 8d 8d 22 01 00 00 45 0f b6 85 =
42 01 00 00 6a 02 48 8b 36 e8 79 ab fc ff 48 89 43 08 5a 48 85 c0 0f 85 d6 =
fd ff ff <0f> 0b 48 8d 65 d8 5b 41 5c 41 5d 41 5e 41 5f 5d c3 0f 0b 48 8b 73
<4>[266762.383364][  T633] RSP: 0018:ffffc9000157bdd8 EFLAGS: 00010246
<4>[266762.383370][  T633] RAX: 0000000000000000 RBX: ffffc9000157be20 RCX:=
 0000000000000000
<4>[266762.383374][  T633] RDX: 0000000000000002 RSI: 0000000000000000 RDI:=
 ffffffff8109ead2
<4>[266762.383377][  T633] RBP: ffffc9000157be10 R08: 0000000000000001 R09:=
 0000000000000001
<4>[266762.383381][  T633] R10: fffffffefb3c6580 R11: ffff8881328b75b2 R12:=
 0000000000000cc0
<4>[266762.383385][  T633] R13: ffff888105873800 R14: ffff8881328b6580 R15:=
 dead000000000100
<4>[266762.383389][  T633] FS:  0000000000000000(0000) GS:ffff888313d00000(=
0000) knlGS:0000000000000000
<4>[266762.383394][  T633] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
<4>[266762.383398][  T633] CR2: 00007f3038f80000 CR3: 000000011a878000 CR4:=
 00000000000406e0
<4>[266762.383402][  T633] Call Trace:
<4>[266762.383411][  T633]  ? wl_update_bss_info.isra.0+0xf5/0x210 [wl 47ce=
17d152623ac79abb5e1d4a28d4375eb94473]
<4>[266762.383544][  T633]  wl_bss_roaming_done.constprop.0+0xc4/0x100 [wl =
47ce17d152623ac79abb5e1d4a28d4375eb94473]
<4>[266762.383647][  T633]  wl_notify_roaming_status+0x3f/0x60 [wl 47ce17d1=
52623ac79abb5e1d4a28d4375eb94473]
<4>[266762.383737][  T633]  wl_event_handler+0x5f/0x140 [wl 47ce17d152623ac=
79abb5e1d4a28d4375eb94473]
<4>[266762.383822][  T633]  ? wl_cfg80211_del_key+0x100/0x100 [wl 47ce17d15=
2623ac79abb5e1d4a28d4375eb94473]
<4>[266762.383911][  T633]  kthread+0x140/0x160
<4>[266762.383921][  T633]  ? set_kthread_struct+0x40/0x40
<4>[266762.383930][  T633]  ret_from_fork+0x1f/0x30
<4>[266762.383956][  T633] irq event stamp: 443797
<4>[266762.383959][  T633] hardirqs last  enabled at (443803): [<ffffffff81=
126320>] __up_console_sem+0x60/0x70
<4>[266762.383967][  T633] hardirqs last disabled at (443808): [<ffffffff81=
126305>] __up_console_sem+0x45/0x70
<4>[266762.383974][  T633] softirqs last  enabled at (442816): [<ffffffffa1=
059338>] cfg80211_get_bss+0x2c8/0x400 [cfg80211]
<4>[266762.384044][  T633] softirqs last disabled at (442814): [<ffffffffa1=
0590dc>] cfg80211_get_bss+0x6c/0x400 [cfg80211]
<4>[266762.384112][  T633] ---[ end trace bdd7d27535aea265 ]---
<4>[266767.195365][  T633] ------------[ cut here ]------------
<4>[266767.195375][  T633] WARNING: CPU: 2 PID: 633 at net/wireless/sme.c:9=
74 cfg80211_roamed+0x265/0x2a0 [cfg80211]
<4>[266767.195460][  T633] Modules linked in: rfcomm xt_CHECKSUM xt_MASQUER=
ADE xt_conntrack ipt_REJECT nf_reject_ipv4 xt_tcpudp nft_compat nft_chain_n=
at nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 nft_counter nf_tables =
nfnetlink bridge stp llc bfq cmac algif_hash algif_skcipher af_alg bnep dm_=
multipath scsi_dh_rdac scsi_dh_emc scsi_dh_alua snd_hda_codec_realtek snd_h=
da_codec_hdmi uvcvideo snd_hda_codec_generic ledtrig_audio snd_hda_intel vi=
deobuf2_vmalloc snd_intel_dspcfg videobuf2_memops snd_intel_sdw_acpi btusb =
btrtl videobuf2_v4l2 videobuf2_common btbcm snd_hda_codec btintel videodev =
snd_hda_core bluetooth snd_hwdep wl(OE) mc snd_pcm ecdh_generic snd_seq_mid=
i ecc snd_seq_midi_event edac_mce_amd snd_rawmidi kvm_amd acer_wmi snd_seq =
sparse_keymap kvm cfg80211 wmi_bmof input_leds serio_raw snd_seq_device snd=
_timer snd soundcore ccp fam15h_power k10temp mac_hid sch_fq_codel msr ip_t=
ables x_tables autofs4 btrfs blake2b_generic raid10 raid456 async_raid6_rec=
ov async_memcpy async_pq
<4>[266767.195627][  T633]  async_xor async_tx xor raid6_pq libcrc32c raid1=
 raid0 multipath linear amdgpu iommu_v2 gpu_sched radeon i2c_algo_bit drm_t=
tm_helper ttm hid_generic drm_kms_helper syscopyarea usbhid crct10dif_pclmu=
l sysfillrect crc32_pclmul sysimgblt hid ghash_clmulni_intel fb_sys_fops ce=
c aesni_intel rc_core rtsx_pci_sdmmc sdhci_pci crypto_simd cqhci r8169 cryp=
td psmouse ahci xhci_pci rtsx_pci realtek libahci drm sdhci i2c_piix4 xhci_=
pci_renesas wmi video
<4>[266767.195725][  T633] CPU: 2 PID: 633 Comm: wl_event_handle Tainted: G=
        W  OE     5.15.0-rc4-for-5.16-io-uring-00060-g4922ab639eb6 #4 8b24b=
2500a34cedea2e69c8d84eb4c855e713e61
<4>[266767.195733][  T633] Hardware name: Acer Aspire ES1-421/OLVIA_BE, BIO=
S V1.05 07/02/2015
<4>[266767.195737][  T633] RIP: 0010:cfg80211_roamed+0x265/0x2a0 [cfg80211]
<4>[266767.195803][  T633] Code: 4c 89 f7 49 8d 8d 22 01 00 00 45 0f b6 85 =
42 01 00 00 6a 02 48 8b 36 e8 79 ab fc ff 48 89 43 08 5a 48 85 c0 0f 85 d6 =
fd ff ff <0f> 0b 48 8d 65 d8 5b 41 5c 41 5d 41 5e 41 5f 5d c3 0f 0b 48 8b 73
<4>[266767.195810][  T633] RSP: 0018:ffffc9000157bdd8 EFLAGS: 00010246
<4>[266767.195815][  T633] RAX: 0000000000000000 RBX: ffffc9000157be20 RCX:=
 0000000000000000
<4>[266767.195819][  T633] RDX: 0000000000000002 RSI: 0000000000000000 RDI:=
 ffffffff8109ead2
<4>[266767.195822][  T633] RBP: ffffc9000157be10 R08: 0000000000000001 R09:=
 0000000000000001
<4>[266767.195825][  T633] R10: fffffffefb3c5fdd R11: ffff8881328b75b2 R12:=
 0000000000000cc0
<4>[266767.195829][  T633] R13: ffff888105873800 R14: ffff8881328b6580 R15:=
 dead000000000100
<4>[266767.195833][  T633] FS:  0000000000000000(0000) GS:ffff888313d00000(=
0000) knlGS:0000000000000000
<4>[266767.195837][  T633] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
<4>[266767.195840][  T633] CR2: 00001a7e96581000 CR3: 0000000133b98000 CR4:=
 00000000000406e0
<4>[266767.195844][  T633] Call Trace:
<4>[266767.195853][  T633]  ? wl_update_bss_info.isra.0+0xf5/0x210 [wl 47ce=
17d152623ac79abb5e1d4a28d4375eb94473]
<4>[266767.195954][  T633]  wl_bss_roaming_done.constprop.0+0xc4/0x100 [wl =
47ce17d152623ac79abb5e1d4a28d4375eb94473]
<4>[266767.196048][  T633]  wl_notify_roaming_status+0x3f/0x60 [wl 47ce17d1=
52623ac79abb5e1d4a28d4375eb94473]
<4>[266767.196130][  T633]  wl_event_handler+0x5f/0x140 [wl 47ce17d152623ac=
79abb5e1d4a28d4375eb94473]
<4>[266767.196208][  T633]  ? wl_cfg80211_del_key+0x100/0x100 [wl 47ce17d15=
2623ac79abb5e1d4a28d4375eb94473]
<4>[266767.196290][  T633]  kthread+0x140/0x160
<4>[266767.196299][  T633]  ? set_kthread_struct+0x40/0x40
<4>[266767.196307][  T633]  ret_from_fork+0x1f/0x30
<4>[266767.196331][  T633] irq event stamp: 444983
<4>[266767.196334][  T633] hardirqs last  enabled at (444989): [<ffffffff81=
126320>] __up_console_sem+0x60/0x70
<4>[266767.196342][  T633] hardirqs last disabled at (444994): [<ffffffff81=
126305>] __up_console_sem+0x45/0x70
<4>[266767.196348][  T633] softirqs last  enabled at (444004): [<ffffffffa1=
059338>] cfg80211_get_bss+0x2c8/0x400 [cfg80211]
<4>[266767.196411][  T633] softirqs last disabled at (444002): [<ffffffffa1=
0590dc>] cfg80211_get_bss+0x6c/0x400 [cfg80211]
<4>[266767.196472][  T633] ---[ end trace bdd7d27535aea266 ]---
<4>[266772.007708][  T633] ------------[ cut here ]------------
<4>[266772.007717][  T633] WARNING: CPU: 0 PID: 633 at net/wireless/sme.c:9=
74 cfg80211_roamed+0x265/0x2a0 [cfg80211]
<4>[266772.007805][  T633] Modules linked in: rfcomm xt_CHECKSUM xt_MASQUER=
ADE xt_conntrack ipt_REJECT nf_reject_ipv4 xt_tcpudp nft_compat nft_chain_n=
at nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 nft_counter nf_tables =
nfnetlink bridge stp llc bfq cmac algif_hash algif_skcipher af_alg bnep dm_=
multipath scsi_dh_rdac scsi_dh_emc scsi_dh_alua snd_hda_codec_realtek snd_h=
da_codec_hdmi uvcvideo snd_hda_codec_generic ledtrig_audio snd_hda_intel vi=
deobuf2_vmalloc snd_intel_dspcfg videobuf2_memops snd_intel_sdw_acpi btusb =
btrtl videobuf2_v4l2 videobuf2_common btbcm snd_hda_codec btintel videodev =
snd_hda_core bluetooth snd_hwdep wl(OE) mc snd_pcm ecdh_generic snd_seq_mid=
i ecc snd_seq_midi_event edac_mce_amd snd_rawmidi kvm_amd acer_wmi snd_seq =
sparse_keymap kvm cfg80211 wmi_bmof input_leds serio_raw snd_seq_device snd=
_timer snd soundcore ccp fam15h_power k10temp mac_hid sch_fq_codel msr ip_t=
ables x_tables autofs4 btrfs blake2b_generic raid10 raid456 async_raid6_rec=
ov async_memcpy async_pq
<4>[266772.007977][  T633]  async_xor async_tx xor raid6_pq libcrc32c raid1=
 raid0 multipath linear amdgpu iommu_v2 gpu_sched radeon i2c_algo_bit drm_t=
tm_helper ttm hid_generic drm_kms_helper syscopyarea usbhid crct10dif_pclmu=
l sysfillrect crc32_pclmul sysimgblt hid ghash_clmulni_intel fb_sys_fops ce=
c aesni_intel rc_core rtsx_pci_sdmmc sdhci_pci crypto_simd cqhci r8169 cryp=
td psmouse ahci xhci_pci rtsx_pci realtek libahci drm sdhci i2c_piix4 xhci_=
pci_renesas wmi video
<4>[266772.008074][  T633] CPU: 0 PID: 633 Comm: wl_event_handle Tainted: G=
        W  OE     5.15.0-rc4-for-5.16-io-uring-00060-g4922ab639eb6 #4 8b24b=
2500a34cedea2e69c8d84eb4c855e713e61
<4>[266772.008081][  T633] Hardware name: Acer Aspire ES1-421/OLVIA_BE, BIO=
S V1.05 07/02/2015
<4>[266772.008085][  T633] RIP: 0010:cfg80211_roamed+0x265/0x2a0 [cfg80211]
<4>[266772.008152][  T633] Code: 4c 89 f7 49 8d 8d 22 01 00 00 45 0f b6 85 =
42 01 00 00 6a 02 48 8b 36 e8 79 ab fc ff 48 89 43 08 5a 48 85 c0 0f 85 d6 =
fd ff ff <0f> 0b 48 8d 65 d8 5b 41 5c 41 5d 41 5e 41 5f 5d c3 0f 0b 48 8b 73
<4>[266772.008156][  T633] RSP: 0018:ffffc9000157bdd8 EFLAGS: 00010246
<4>[266772.008162][  T633] RAX: 0000000000000000 RBX: ffffc9000157be20 RCX:=
 0000000000000000
<4>[266772.008165][  T633] RDX: 0000000000000002 RSI: 0000000000000000 RDI:=
 ffffffff8109ead2
<4>[266772.008169][  T633] RBP: ffffc9000157be10 R08: 0000000000000001 R09:=
 0000000000000001
<4>[266772.008172][  T633] R10: fffffffefb3c5a3a R11: ffff8881328b75b2 R12:=
 0000000000000cc0
<4>[266772.008176][  T633] R13: ffff888105873800 R14: ffff8881328b6580 R15:=
 dead000000000100
<4>[266772.008180][  T633] FS:  0000000000000000(0000) GS:ffff888313c00000(=
0000) knlGS:0000000000000000
<4>[266772.008184][  T633] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
<4>[266772.008187][  T633] CR2: 00007f71a0b04000 CR3: 0000000107604000 CR4:=
 00000000000406f0
<4>[266772.008192][  T633] Call Trace:
<4>[266772.008200][  T633]  ? wl_update_bss_info.isra.0+0xf5/0x210 [wl 47ce=
17d152623ac79abb5e1d4a28d4375eb94473]
<4>[266772.008299][  T633]  wl_bss_roaming_done.constprop.0+0xc4/0x100 [wl =
47ce17d152623ac79abb5e1d4a28d4375eb94473]
<4>[266772.008392][  T633]  wl_notify_roaming_status+0x3f/0x60 [wl 47ce17d1=
52623ac79abb5e1d4a28d4375eb94473]
<4>[266772.008474][  T633]  wl_event_handler+0x5f/0x140 [wl 47ce17d152623ac=
79abb5e1d4a28d4375eb94473]
<4>[266772.008553][  T633]  ? wl_cfg80211_del_key+0x100/0x100 [wl 47ce17d15=
2623ac79abb5e1d4a28d4375eb94473]
<4>[266772.008636][  T633]  kthread+0x140/0x160
<4>[266772.008645][  T633]  ? set_kthread_struct+0x40/0x40
<4>[266772.008653][  T633]  ret_from_fork+0x1f/0x30
<4>[266772.008677][  T633] irq event stamp: 446169
<4>[266772.008679][  T633] hardirqs last  enabled at (446175): [<ffffffff81=
126320>] __up_console_sem+0x60/0x70
<4>[266772.008687][  T633] hardirqs last disabled at (446180): [<ffffffff81=
126305>] __up_console_sem+0x45/0x70
<4>[266772.008693][  T633] softirqs last  enabled at (445190): [<ffffffffa1=
059338>] cfg80211_get_bss+0x2c8/0x400 [cfg80211]
<4>[266772.008761][  T633] softirqs last disabled at (445188): [<ffffffffa1=
0590dc>] cfg80211_get_bss+0x6c/0x400 [cfg80211]
<4>[266772.008824][  T633] ---[ end trace bdd7d27535aea267 ]---
<6>[266776.927048][  T892] IPv6: ADDRCONF(NETDEV_CHANGE): wlp2s0: link beco=
mes ready

Thanks!

--=20
Ammar Faizi
