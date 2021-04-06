Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 586C6355409
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 14:36:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238946AbhDFMga (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 08:36:30 -0400
Received: from vulcan.natalenko.name ([104.207.131.136]:59862 "EHLO
        vulcan.natalenko.name" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231180AbhDFMg3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Apr 2021 08:36:29 -0400
Received: from localhost (kaktus.kanapka.ml [151.237.229.131])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by vulcan.natalenko.name (Postfix) with ESMTPSA id 66A5EA1B9EC;
        Tue,  6 Apr 2021 14:36:20 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=natalenko.name;
        s=dkim-20170712; t=1617712580;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=phm1fcLaGGGrQSmvwxHMDL5vIt5BOBgstrxlye/ABRs=;
        b=QoOrVgpHiWGTOoZX9eG+GPYAzvv7pUTbudXhdbM5L2s18PtRs547zWRad8j02jQGz/uveq
        x62f5vsq52kRL0+pwtWlrAMAwSbOAx6gsx0qfz1rhca0506RqROQIFwNZUe6mt6++ickRH
        xDq1NGl+gQiFRYLX5RCYJZp6JHo//IQ=
Date:   Tue, 6 Apr 2021 14:36:19 +0200
From:   Oleksandr Natalenko <oleksandr@natalenko.name>
To:     linux-kernel@vger.kernel.org
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org
Subject: [igb] netconsole triggers warning in netpoll_poll_dev
Message-ID: <20210406123619.rhvtr73xwwlbu2ll@spock.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello.

I've raised this here [1] first, but was suggested to engage igb devs,
so here we are.

I'm experiencing the following woes while using netconsole regularly:

```
[22038.710800] ------------[ cut here ]------------
[22038.710801] igb_poll+0x0/0x1440 [igb] exceeded budget in poll
[22038.710802] WARNING: CPU: 12 PID: 40362 at net/core/netpoll.c:155 netpol=
l_poll_dev+0x18a/0x1a0
[22038.710802] Modules linked in: blocklayoutdriver rpcsec_gss_krb5 auth_rp=
cgss nfsv4 dns_resolver nfs lockd grace sunrpc nfs_ssc fscache uinput netco=
nsole rfcomm nft_ct nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 cmac algif_h=
ash algif_skcipher af_alg nf_tables tun bnep nfnetlink iwlmvm snd_hda_codec=
_realtek snd_hda_codec_generic ledtrig_audio mac80211 snd_hda_codec_hdmi sn=
d_hda_intel nls_iso8859_1 snd_intel_dspcfg soundwire_intel vfat libarc4 sou=
ndwire_generic_allocation soundwire_cadence fat intel_rapl_msr snd_hda_code=
c intel_rapl_common iwlwifi snd_hda_core soundwire_bus snd_usb_audio snd_so=
c_core eeepc_wmi btusb asus_wmi snd_usbmidi_lib btrtl edac_mce_amd sparse_k=
eymap btbcm video wmi_bmof mxm_wmi kvm_amd snd_hwdep snd_compress btintel s=
nd_rawmidi ac97_bus cfg80211 uvcvideo bluetooth snd_pcm_dmaengine snd_seq_d=
evice snd_pcm videobuf2_vmalloc kvm videobuf2_memops snd_timer videobuf2_v4=
l2 joydev igb mousedev ecdh_generic snd irqbypass pl2303 ipmi_devintf ecc v=
ideobuf2_common soundcore
[22038.710820]  r8169 ipmi_msghandler rapl crc16 k10temp rfkill sp5100_tco =
dca i2c_piix4 tpm_crb realtek mdio_devres tpm_tis libphy tpm_tis_core pinct=
rl_amd wmi acpi_cpufreq mac_hid tcp_bbr2 vhost_vsock vmw_vsock_virtio_trans=
port_common vhost vhost_iotlb vsock v4l2loopback videodev mc nct6775 hwmon_=
vid crypto_user fuse ip_tables x_tables xfs dm_thin_pool dm_persistent_data=
 dm_bio_prison dm_bufio libcrc32c crc32c_generic dm_crypt cbc encrypted_key=
s trusted tpm hid_logitech_hidpp hid_logitech_dj usbhid dm_mod raid10 crct1=
0dif_pclmul crc32_pclmul crc32c_intel ghash_clmulni_intel aesni_intel md_mo=
d crypto_simd cryptd glue_helper ccp amdgpu rng_core xhci_pci xhci_pci_rene=
sas drm_ttm_helper ttm gpu_sched i2c_algo_bit drm_kms_helper syscopyarea sy=
sfillrect sysimgblt fb_sys_fops cec drm agpgart
[22038.710835] CPU: 12 PID: 40362 Comm: systemd-sleep Not tainted 5.11.0-pf=
7 #1
[22038.710836] Hardware name: ASUS System Product Name/Pro WS X570-ACE, BIO=
S 3302 03/05/2021
[22038.710836] RIP: 0010:netpoll_poll_dev+0x18a/0x1a0
[22038.710837] Code: 6e ff 80 3d d2 9d f8 00 00 0f 85 5c ff ff ff 48 8b 73 =
28 48 c7 c7 0c b8 21 84 89 44 24 04 c6 05 b6 9d f8 00 01 e8 84 21 1c 00 <0f=
> 0b 8b 54 24 04 e9 36 ff ff ff 66 66 2e 0f 1f 84 00 00 00 00 00
[22038.710838] RSP: 0018:ffffb24106e37ba0 EFLAGS: 00010086
[22038.710838] RAX: 0000000000000000 RBX: ffff9599d2929c50 RCX: ffff959f8ed=
1ac30
[22038.710839] RDX: 0000000000000000 RSI: 0000000000000023 RDI: ffff959f8ed=
1ac28
[22038.710839] RBP: ffff9598981d4058 R08: 0000000000000019 R09: ffffb24206e=
3796d
[22038.710839] R10: ffffffffffffffff R11: ffffb24106e37968 R12: ffff959887e=
51ec8
[22038.710840] R13: 000000000000000c R14: 00000000ffffffff R15: ffff9599d29=
29c60
[22038.710840] FS:  00007f3ade370a40(0000) GS:ffff959f8ed00000(0000) knlGS:=
0000000000000000
[22038.710841] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[22038.710841] CR2: 0000000000000000 CR3: 00000003017b0000 CR4: 00000000003=
50ee0
[22038.710841] Call Trace:
[22038.710842]  netpoll_send_skb+0x185/0x240
[22038.710842]  write_msg+0xe5/0x100 [netconsole]
[22038.710842]  console_unlock+0x37d/0x640
[22038.710842]  ? __schedule+0x2e5/0xc90
[22038.710843]  suspend_devices_and_enter+0x2ac/0x7f0
[22038.710843]  pm_suspend.cold+0x321/0x36c
[22038.710843]  state_store+0xa6/0x140
[22038.710844]  kernfs_fop_write_iter+0x124/0x1b0
[22038.710844]  new_sync_write+0x16a/0x200
[22038.710844]  vfs_write+0x21c/0x2e0
[22038.710844]  __x64_sys_write+0x6d/0xf0
[22038.710845]  do_syscall_64+0x33/0x40
[22038.710845]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[22038.710845] RIP: 0033:0x7f3adece10f7
[22038.710846] Code: 0d 00 f7 d8 64 89 02 48 c7 c0 ff ff ff ff eb b7 0f 1f =
00 f3 0f 1e fa 64 8b 04 25 18 00 00 00 85 c0 75 10 b8 01 00 00 00 0f 05 <48=
> 3d 00 f0 ff ff 77 51 c3 48 83 ec 28 48 89 54 24 18 48 89 74 24
[22038.710847] RSP: 002b:00007ffc51c555b8 EFLAGS: 00000246 ORIG_RAX: 000000=
0000000001
[22038.710847] RAX: ffffffffffffffda RBX: 0000000000000004 RCX: 00007f3adec=
e10f7
[22038.710848] RDX: 0000000000000004 RSI: 00007ffc51c556a0 RDI: 00000000000=
00004
[22038.710848] RBP: 00007ffc51c556a0 R08: 000055ea374302a0 R09: 00007f3aded=
770c0
[22038.710849] R10: 00007f3aded76fc0 R11: 0000000000000246 R12: 00000000000=
00004
[22038.710849] R13: 000055ea3742c430 R14: 0000000000000004 R15: 00007f3aded=
b3700
[22038.710849] ---[ end trace 6eae54fbf23807f8 ]---
```

This one happened during suspend/resume cycle (on resume), followed by:

```
[22038.868669] igb 0000:05:00.0 enp5s0: Reset adapter
[22040.998673] igb 0000:05:00.0 enp5s0: Reset adapter
[22043.819198] igb 0000:05:00.0 enp5s0: igb: enp5s0 NIC Link is Up 1000 Mbp=
s Full Duplex, Flow Control: RX
```

I've bumped into a similar issue in BZ 211911 [2] (see c#16),
and in c#17 it was suggested it was a separate unrelated issue,
hence I'm raising a new concern.

Please help in finding out why this woe happens and in fixing it.

Thanks.

[1] https://bugzilla.kernel.org/show_bug.cgi?id=3D212573
[2] https://bugzilla.kernel.org/show_bug.cgi?id=3D211911

--=20
  Oleksandr Natalenko (post-factum)
