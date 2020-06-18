Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE2FF1FEE4D
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 11:06:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728986AbgFRJGM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 05:06:12 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:22198 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728926AbgFRJGG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 05:06:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592471163;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=8+6yu/x63A8JNPDDG24GnqbRutaJYdNpzGAAuIIzQpc=;
        b=QtMvigq4BClEFInUvj7/tWyXG02xAoguZ0g7gLTKrEW0fNOqgkI4q2mt4MZZyGbDSF0pYM
        43I5GIqoNrpJPA5HGmjTj7iotyR/NdWV+5Rg8bS9RHNBiTxiiHTtwbYjOQG7YOyQqZOfsz
        hFfur3bq0sE2jTjAkGtSHkfgOwlaaw0=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-416-pGoeYvnQPz-CbdKLwJgHmg-1; Thu, 18 Jun 2020 05:06:01 -0400
X-MC-Unique: pGoeYvnQPz-CbdKLwJgHmg-1
Received: by mail-ed1-f71.google.com with SMTP id c20so1983339edy.17
        for <netdev@vger.kernel.org>; Thu, 18 Jun 2020 02:06:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:content-transfer-encoding;
        bh=8+6yu/x63A8JNPDDG24GnqbRutaJYdNpzGAAuIIzQpc=;
        b=mRus1mGkfC2zykxVdc0M8HPFwEGbG2V+4pslyyty/qfqQ6o5Y2KxxtSXSBQSVggE+l
         u44QmsZSFlh/mpv6GVp3o1sZbwfzV7/v3HDTAE7eQ1dyZD9KWrB6x7BzpdwTEoCKwj8m
         AuBc9cuUpDzOrrxUh5tkmX3JOSCjNdFEszBAPBSZREudTMrOubQj8OqbLk0n2f3F+Bkx
         5eThGtqwq9iUJ/F34l0zP3ZXA2nestDpQT40fJOys7ZoecNZVhl0o3lFu9h5tCdo6tnc
         9l9hqxFPfh/MPzgLQO5bcTDQ5QgDOgwKNLgspArpPmKAOr0HOEyrer8H9u3r7Dxxy0fh
         tFhQ==
X-Gm-Message-State: AOAM531phB5kjZCuSG+li5IsHO9c1dYt+xGgQXWxut7K/cNhZgU1HjHg
        p5pPKl7uvYvsLs+1jERP+FnbK0mdyQ0BY7xfqTErlErKuAKtc+sHEL89BGxElzsJ0Emw5+1rofa
        5wshhXdBmiANbjLk8
X-Received: by 2002:a50:e14e:: with SMTP id i14mr2926294edl.279.1592471158864;
        Thu, 18 Jun 2020 02:05:58 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz2wUOr8xyEWG9/PeDteraN07me4t//OcPVrYa6R1sI8XQ69VG5AHblLgBb8E5pIcRlchzffw==
X-Received: by 2002:a50:e14e:: with SMTP id i14mr2926264edl.279.1592471158493;
        Thu, 18 Jun 2020 02:05:58 -0700 (PDT)
Received: from localhost (home.natalenko.name. [151.237.229.131])
        by smtp.gmail.com with ESMTPSA id bt11sm1639299edb.48.2020.06.18.02.05.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Jun 2020 02:05:57 -0700 (PDT)
Date:   Thu, 18 Jun 2020 11:05:56 +0200
From:   Oleksandr Natalenko <oleksandr@redhat.com>
To:     Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
Cc:     Felix Fietkau <nbd@nbd.name>, Ryder Lee <ryder.lee@mediatek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: mt7612 suspend/resume issue
Message-ID: <20200618090556.pepjdbnba2gqzcbe@butterfly.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello, Lorenzo et al.

I'm using MT7612 mini-PCIE cards as both AP in a home server and as a clien=
t in
a laptop. The AP works perfectly (after some fixing from your side; thanks =
for
that!), and so does the client modulo it has issues during system resume.

So, the card is installed in my aging Dell Vostro 3360. The system always
suspends fine, but on resume this can happen occasionally:

=3D=3D=3D
=C4=8Den 15 20:21:07 spock kernel: mt76x2e 0000:01:00.0: MCU message 2 (seq=
 11) timed out
=C4=8Den 15 20:21:07 spock kernel: mt76x2e 0000:01:00.0: MCU message 30 (se=
q 12) timed out
=C4=8Den 15 20:21:07 spock kernel: mt76x2e 0000:01:00.0: MCU message 30 (se=
q 13) timed out
=C4=8Den 15 20:21:07 spock kernel: mt76x2e 0000:01:00.0: Firmware Version: =
0.0.00
=C4=8Den 15 20:21:07 spock kernel: mt76x2e 0000:01:00.0: Build: 1
=C4=8Den 15 20:21:07 spock kernel: mt76x2e 0000:01:00.0: Build Time: 201507=
311614____
=C4=8Den 15 20:21:07 spock kernel: mt76x2e 0000:01:00.0: Firmware running!
=C4=8Den 15 20:21:07 spock kernel: ieee80211 phy0: Hardware restart was req=
uested
=C4=8Den 15 20:21:08 spock kernel: mt76x2e 0000:01:00.0: MCU message 2 (seq=
 1) timed out
=C4=8Den 15 20:21:09 spock kernel: mt76x2e 0000:01:00.0: MCU message 30 (se=
q 2) timed out
=C4=8Den 15 20:21:10 spock kernel: mt76x2e 0000:01:00.0: MCU message 30 (se=
q 3) timed out
=C4=8Den 15 20:21:10 spock kernel: mt76x2e 0000:01:00.0: Firmware Version: =
0.0.00
=C4=8Den 15 20:21:10 spock kernel: mt76x2e 0000:01:00.0: Build: 1
=C4=8Den 15 20:21:10 spock kernel: mt76x2e 0000:01:00.0: Build Time: 201507=
311614____
=C4=8Den 15 20:21:10 spock kernel: mt76x2e 0000:01:00.0: Firmware running!
=C4=8Den 15 20:21:10 spock kernel: ieee80211 phy0: Hardware restart was req=
uested
=C4=8Den 15 20:21:11 spock kernel: mt76x2e 0000:01:00.0: MCU message 31 (se=
q 5) timed out
=C4=8Den 15 20:21:12 spock kernel: mt76x2e 0000:01:00.0: MCU message 31 (se=
q 6) timed out
=C4=8Den 15 20:21:13 spock kernel: mt76x2e 0000:01:00.0: MCU message 31 (se=
q 7) timed out
=C4=8Den 15 20:21:14 spock kernel: mt76x2e 0000:01:00.0: MCU message 31 (se=
q 8) timed out
=C4=8Den 15 20:21:15 spock kernel: mt76x2e 0000:01:00.0: MCU message 31 (se=
q 9) timed out
=C4=8Den 15 20:21:16 spock kernel: mt76x2e 0000:01:00.0: MCU message 31 (se=
q 10) timed out
=C4=8Den 15 20:21:17 spock kernel: mt76x2e 0000:01:00.0: MCU message 31 (se=
q 11) timed out
=C4=8Den 15 20:21:17 spock kernel: mt76x2e 0000:01:00.0: Firmware Version: =
0.0.00
=C4=8Den 15 20:21:17 spock kernel: mt76x2e 0000:01:00.0: Build: 1
=C4=8Den 15 20:21:17 spock kernel: mt76x2e 0000:01:00.0: Build Time: 201507=
311614____
=C4=8Den 15 20:21:17 spock kernel: mt76x2e 0000:01:00.0: Firmware running!
=C4=8Den 15 20:21:17 spock kernel: ieee80211 phy0: Hardware restart was req=
uested
=C4=8Den 15 20:21:18 spock kernel: ------------[ cut here ]------------
=C4=8Den 15 20:21:18 spock kernel: WARNING: CPU: 3 PID: 11956 at net/mac802=
11/util.c:2270 ieee80211_reconfig+0x234/0x1700 [mac80211]
=C4=8Den 15 20:21:18 spock kernel: Modules linked in: pl2303 md4 nls_utf8 c=
ifs dns_resolver fscache libdes cmac ccm bridge stp llc nft_ct nf_conntrack=
 nf_defrag_ipv6 nf_defrag_ipv4 nf_tables tun nfnetlink msr nls_iso8859_1 nl=
s_cp437 vfat fat snd_hda_codec_hdmi mt76x2e snd_hda_codec_cirrus snd_hda_co=
dec_generic mt76x2_common mt76x02_lib mt76 snd_hda_intel intel_rapl_msr snd=
_intel_dspcfg mei_hdcp dell_wmi iTCO_wdt mac80211 iTCO_vendor_support intel=
_rapl_common sparse_keymap wmi_bmof snd_hda_codec x86_pkg_temp_thermal rtsx=
_usb_ms intel_powerclamp dell_laptop coretemp ledtrig_audio dell_smbios mem=
stick kvm_intel kvm snd_hda_core dell_wmi_descriptor dcdbas snd_hwdep dell_=
smm_hwmon cfg80211 snd_pcm irqbypass mousedev intel_cstate psmouse joydev i=
ntel_uncore intel_rapl_perf input_leds snd_timer i2c_i801 snd mei_me alx rf=
kill mei libarc4 lpc_ich mdio soundcore battery wmi evdev mac_hid dell_smo8=
800 ac tcp_bbr crypto_user ip_tables x_tables xfs dm_thin_pool dm_persisten=
t_data dm_bio_prison dm_bufio libcrc32c
=C4=8Den 15 20:21:18 spock kernel:  crc32c_generic dm_crypt hid_logitech_hi=
dpp hid_logitech_dj hid_generic usbhid hid rtsx_usb_sdmmc mmc_core rtsx_usb=
 dm_mod crct10dif_pclmul crc32_pclmul crc32c_intel raid10 ghash_clmulni_int=
el serio_raw atkbd libps2 md_mod aesni_intel crypto_simd cryptd glue_helper=
 xhci_pci xhci_hcd ehci_pci ehci_hcd i8042 serio i915 intel_gtt i2c_algo_bi=
t drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops cec rc_core =
drm agpgart
=C4=8Den 15 20:21:18 spock kernel: CPU: 3 PID: 11956 Comm: kworker/3:1 Not =
tainted 5.7.0-pf2 #1
=C4=8Den 15 20:21:18 spock kernel: Hardware name: Dell Inc.          Vostro=
 3360/0F5DWF, BIOS A18 09/25/2013
=C4=8Den 15 20:21:18 spock kernel: Workqueue: events_freezable ieee80211_re=
start_work [mac80211]
=C4=8Den 15 20:21:18 spock kernel: RIP: 0010:ieee80211_reconfig+0x234/0x170=
0 [mac80211]
=C4=8Den 15 20:21:18 spock kernel: Code: 83 b8 0b 00 00 83 e0 fd 83 f8 04 7=
4 e6 48 8b 83 90 04 00 00 a8 01 74 db 48 89 de 48 89 ef e8 03 dc fb ff 41 8=
9 c7 85 c0 74 c9 <0f> 0b 48 8b 5b 08 4c 8b 24 24 48 3b 1c 24 75 12 e9 51 fe=
 ff ff 48
=C4=8Den 15 20:21:18 spock kernel: RSP: 0018:ffffb803c23ffdf0 EFLAGS: 00010=
286
=C4=8Den 15 20:21:18 spock kernel: RAX: 00000000fffffff0 RBX: ffff9595a7564=
900 RCX: 0000000000000008
=C4=8Den 15 20:21:18 spock kernel: RDX: 0000000000000000 RSI: 0000000000000=
100 RDI: 0000000000000100
=C4=8Den 15 20:21:18 spock kernel: RBP: ffff9595a7ec07e0 R08: 0000000000000=
000 R09: 0000000000000001
=C4=8Den 15 20:21:18 spock kernel: R10: 0000000000000001 R11: 0000000000000=
000 R12: ffff9595a7ec18d0
=C4=8Den 15 20:21:18 spock kernel: R13: 00000000ffffffff R14: 0000000000000=
000 R15: 00000000fffffff0
=C4=8Den 15 20:21:18 spock kernel: FS:  0000000000000000(0000) GS:ffff9595a=
f2c0000(0000) knlGS:0000000000000000
=C4=8Den 15 20:21:18 spock kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000=
080050033
=C4=8Den 15 20:21:18 spock kernel: CR2: 000055e56d7de000 CR3: 000000042200a=
001 CR4: 00000000001706e0
=C4=8Den 15 20:21:18 spock kernel: Call Trace:
=C4=8Den 15 20:21:18 spock kernel:  ieee80211_restart_work+0xb7/0xe0 [mac80=
211]
=C4=8Den 15 20:21:18 spock kernel:  process_one_work+0x1d4/0x3c0
=C4=8Den 15 20:21:18 spock kernel:  worker_thread+0x228/0x470
=C4=8Den 15 20:21:18 spock kernel:  ? process_one_work+0x3c0/0x3c0
=C4=8Den 15 20:21:18 spock kernel:  kthread+0x19c/0x1c0
=C4=8Den 15 20:21:18 spock kernel:  ? __kthread_init_worker+0x30/0x30
=C4=8Den 15 20:21:18 spock kernel:  ret_from_fork+0x35/0x40
=C4=8Den 15 20:21:18 spock kernel: ---[ end trace d8e4d40f48014382 ]---
=C4=8Den 15 20:21:18 spock kernel: ------------[ cut here ]------------
=C4=8Den 15 20:21:18 spock kernel: wlp1s0:  Failed check-sdata-in-driver ch=
eck, flags: 0x0
=C4=8Den 15 20:21:18 spock kernel: WARNING: CPU: 3 PID: 11956 at net/mac802=
11/driver-ops.h:17 drv_remove_interface+0x11f/0x130 [mac80211]
=C4=8Den 15 20:21:18 spock kernel: Modules linked in: pl2303 md4 nls_utf8 c=
ifs dns_resolver fscache libdes cmac ccm bridge stp llc nft_ct nf_conntrack=
 nf_defrag_ipv6 nf_defrag_ipv4 nf_tables tun nfnetlink msr nls_iso8859_1 nl=
s_cp437 vfat fat snd_hda_codec_hdmi mt76x2e snd_hda_codec_cirrus snd_hda_co=
dec_generic mt76x2_common mt76x02_lib mt76 snd_hda_intel intel_rapl_msr snd=
_intel_dspcfg mei_hdcp dell_wmi iTCO_wdt mac80211 iTCO_vendor_support intel=
_rapl_common sparse_keymap wmi_bmof snd_hda_codec x86_pkg_temp_thermal rtsx=
_usb_ms intel_powerclamp dell_laptop coretemp ledtrig_audio dell_smbios mem=
stick kvm_intel kvm snd_hda_core dell_wmi_descriptor dcdbas snd_hwdep dell_=
smm_hwmon cfg80211 snd_pcm irqbypass mousedev intel_cstate psmouse joydev i=
ntel_uncore intel_rapl_perf input_leds snd_timer i2c_i801 snd mei_me alx rf=
kill mei libarc4 lpc_ich mdio soundcore battery wmi evdev mac_hid dell_smo8=
800 ac tcp_bbr crypto_user ip_tables x_tables xfs dm_thin_pool dm_persisten=
t_data dm_bio_prison dm_bufio libcrc32c
=C4=8Den 15 20:21:18 spock kernel:  crc32c_generic dm_crypt hid_logitech_hi=
dpp hid_logitech_dj hid_generic usbhid hid rtsx_usb_sdmmc mmc_core rtsx_usb=
 dm_mod crct10dif_pclmul crc32_pclmul crc32c_intel raid10 ghash_clmulni_int=
el serio_raw atkbd libps2 md_mod aesni_intel crypto_simd cryptd glue_helper=
 xhci_pci xhci_hcd ehci_pci ehci_hcd i8042 serio i915 intel_gtt i2c_algo_bi=
t drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops cec rc_core =
drm agpgart
=C4=8Den 15 20:21:18 spock kernel: CPU: 3 PID: 11956 Comm: kworker/3:1 Tain=
ted: G        W         5.7.0-pf2 #1
=C4=8Den 15 20:21:18 spock kernel: Hardware name: Dell Inc.          Vostro=
 3360/0F5DWF, BIOS A18 09/25/2013
=C4=8Den 15 20:21:18 spock kernel: Workqueue: events_freezable ieee80211_re=
start_work [mac80211]
=C4=8Den 15 20:21:18 spock kernel: RIP: 0010:drv_remove_interface+0x11f/0x1=
30 [mac80211]
=C4=8Den 15 20:21:18 spock kernel: Code: a0 27 d2 da e9 4b ff ff ff 48 8b 8=
6 78 04 00 00 48 8d b6 98 04 00 00 48 c7 c7 e8 1f f7 c0 48 85 c0 48 0f 45 f=
0 e8 59 fe db da <0f> 0b 5b 5d 41 5c c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f=
 44 00 00
=C4=8Den 15 20:21:18 spock kernel: RSP: 0018:ffffb803c23ffc80 EFLAGS: 00010=
282
=C4=8Den 15 20:21:18 spock kernel: RAX: 0000000000000000 RBX: ffff9595a7564=
900 RCX: 0000000000000000
=C4=8Den 15 20:21:18 spock kernel: RDX: 0000000000000001 RSI: 0000000000000=
082 RDI: 00000000ffffffff
=C4=8Den 15 20:21:18 spock kernel: RBP: ffff9595a7ec1930 R08: 0000000000000=
4b6 R09: 0000000000000001
=C4=8Den 15 20:21:18 spock kernel: R10: 0000000000000001 R11: 0000000000006=
f08 R12: ffff9595a7ec1000
=C4=8Den 15 20:21:18 spock kernel: R13: ffff9595a75654b8 R14: ffff9595a7ec0=
ca0 R15: ffff9595a7ec07e0
=C4=8Den 15 20:21:18 spock kernel: FS:  0000000000000000(0000) GS:ffff9595a=
f2c0000(0000) knlGS:0000000000000000
=C4=8Den 15 20:21:18 spock kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000=
080050033
=C4=8Den 15 20:21:18 spock kernel: CR2: 000055e56d7de000 CR3: 000000042200a=
001 CR4: 00000000001706e0
=C4=8Den 15 20:21:18 spock kernel: Call Trace:
=C4=8Den 15 20:21:18 spock kernel:  ieee80211_do_stop+0x5af/0x8c0 [mac80211]
=C4=8Den 15 20:21:18 spock kernel:  ieee80211_stop+0x16/0x20 [mac80211]
=C4=8Den 15 20:21:18 spock kernel:  __dev_close_many+0xaa/0x120
=C4=8Den 15 20:21:18 spock kernel:  dev_close_many+0xa1/0x2b0
=C4=8Den 15 20:21:18 spock kernel:  dev_close+0x6d/0x90
=C4=8Den 15 20:21:18 spock kernel:  cfg80211_shutdown_all_interfaces+0x71/0=
xd0 [cfg80211]
=C4=8Den 15 20:21:18 spock kernel:  ieee80211_reconfig+0xa2/0x1700 [mac8021=
1]
=C4=8Den 15 20:21:18 spock kernel:  ieee80211_restart_work+0xb7/0xe0 [mac80=
211]
=C4=8Den 15 20:21:18 spock kernel:  process_one_work+0x1d4/0x3c0
=C4=8Den 15 20:21:18 spock kernel:  worker_thread+0x228/0x470
=C4=8Den 15 20:21:18 spock kernel:  ? process_one_work+0x3c0/0x3c0
=C4=8Den 15 20:21:18 spock kernel:  kthread+0x19c/0x1c0
=C4=8Den 15 20:21:18 spock kernel:  ? __kthread_init_worker+0x30/0x30
=C4=8Den 15 20:21:18 spock kernel:  ret_from_fork+0x35/0x40
=C4=8Den 15 20:21:18 spock kernel: ---[ end trace d8e4d40f48014383 ]---
=3D=3D=3D

The Wi-Fi becomes unusable from this point. If I `modprobe -r` the "mt76x2e=
" module
after this splat, the system hangs completely.

If the system resumes fine, the resume itself takes quite some time (more t=
han
10 seconds).

I've found a workaround for this, though. It seems the system behaves fine =
if I
do `modprobe -r mt76x2e` before it goes to sleep, and then `modprobe mt76x2=
e`
after resume. Also, the resume time improves greatly.

I cannot say if it is some regression or not. I've installed the card
just recently, and used it with v5.7 kernel series only.

Do you have any idea what could go wrong and how to approach the issue?

Thanks.

--=20
  Best regards,
    Oleksandr Natalenko (post-factum)
    Principal Software Maintenance Engineer

