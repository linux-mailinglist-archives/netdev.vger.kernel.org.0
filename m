Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DD3D41AE48
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 13:56:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240468AbhI1L6C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 07:58:02 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:16048 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S240381AbhI1L6B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Sep 2021 07:58:01 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18SAhwLG021117;
        Tue, 28 Sep 2021 07:56:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : content-type : mime-version :
 content-transfer-encoding; s=pp1;
 bh=YBi+sa6x+Ukx7ROvjXfqdVTeRR6kTInI+uAkVTr6JYE=;
 b=Q+f2oeEklst+6ADeH5FUn6nDndEp95mPSqfojXJwpZC/NKJvvS2oMmwXByTjmNYBlX+Y
 2PmI/Njszn9ejW+Hb7HSDnhzhJp6WHo5nkAP9j93KtmaiwaptDnB81qu14Jn+cOJPfah
 fHZ15iDmmLz/Yq1Yk/4dJXEaCWI8icKrZwmENMA2lQcBoi35peitATQ67KBQSVHTkPIA
 nVsup5AGIBBQZs6wp8Y9iCN4TDCJJ8/R5d+XEYYKUJjK68+4CqTm0uBPU4yymJ2fI1ta
 oSryH7SiGTPGXPwtr/ki0h0ytGdvs/ZpCtku7iEqfQUzFbdCRUMT6dTQQJZE6V8TNjle YA== 
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3bby6qcj3q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Sep 2021 07:56:19 -0400
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 18SBfqOM016195;
        Tue, 28 Sep 2021 11:56:18 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma04fra.de.ibm.com with ESMTP id 3b9ud9uvxv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Sep 2021 11:56:18 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 18SBpFq743516282
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Sep 2021 11:51:15 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B657CA405B;
        Tue, 28 Sep 2021 11:56:15 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 674EEA4062;
        Tue, 28 Sep 2021 11:56:15 +0000 (GMT)
Received: from sig-9-145-32-211.uk.ibm.com (unknown [9.145.32.211])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 28 Sep 2021 11:56:15 +0000 (GMT)
Message-ID: <8e4bbd5c59de31db71f718556654c0aa077df03d.camel@linux.ibm.com>
Subject: Oops in during sriov_enable with ixgbe driver
From:   Niklas Schnelle <schnelle@linux.ibm.com>
To:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     linux-acpi@vger.kernel.org, netdev@vger.kernel.org
Date:   Tue, 28 Sep 2021 13:56:15 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-16.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: rgC2Qipdn5Zil2wwlNKu1joFdtorFLHm
X-Proofpoint-ORIG-GUID: rgC2Qipdn5Zil2wwlNKu1joFdtorFLHm
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-28_05,2021-09-28_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 bulkscore=0 mlxlogscore=548 impostorscore=0 suspectscore=0 phishscore=0
 mlxscore=0 spamscore=0 adultscore=0 lowpriorityscore=0 malwarescore=0
 clxscore=1011 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2109280065
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jesse, Hi Tony,

Since v5.15-rc1 I've been having problems with enabling SR-IOV VFs on
my private workstation with an Intel 82599 NIC with the ixgbe driver. I
haven't had time to bisect or look closer but since it still happens on
v5.15-rc3 I wanted to at least check if you're aware of the problem as
I couldn't find anything on the web.

I get below Oops when trying "echo 2 > /sys/bus/pci/.../sriov_numvfs"
and suspect that the earlier ACPI messages could have something to do
with that, absolutely not an ACPI expert though. If there is a need I
could do a bisect.

Thanks,
Niklas

dmesg output:

[    6.112738] ixgbe 0000:03:00.0: registered PHC device on enp3s0
[    6.286041] ixgbe 0000:03:00.0 enp3s0: detected SFP+: 9
[    6.954994] ACPI: \: failed to evaluate _DSM (0x1001)
[    6.955000] ACPI: \: failed to evaluate _DSM (0x1001)
[    6.955002] ACPI: \: failed to evaluate _DSM (0x1001)
[    6.955003] ACPI: \: failed to evaluate _DSM (0x1001)
[    7.155246] ACPI: \: failed to evaluate _DSM (0x1001)
[    7.155251] ACPI: \: failed to evaluate _DSM (0x1001)
[    7.155253] ACPI: \: failed to evaluate _DSM (0x1001)
[    7.155254] ACPI: \: failed to evaluate _DSM (0x1001)
...
[  136.883365] ixgbe 0000:03:00.0 enp3s0: SR-IOV enabled with 2 VFs
[  136.883489] ixgbe 0000:03:00.0: removed PHC on enp3s0
[  136.983130] ixgbe 0000:03:00.0: Multiqueue Enabled: Rx Queue count =3D 4=
, Tx Queue count =3D 4 XDP Queue count =3D 0
[  137.003753] ixgbe 0000:03:00.0: registered PHC device on enp3s0
[  137.179126] ixgbe 0000:03:00.0 enp3s0: detected SFP+: 9
[  137.217508] BUG: kernel NULL pointer dereference, address: 0000000000000=
298
[  137.217515] #PF: supervisor read access in kernel mode
[  137.217518] #PF: error_code(0x0000) - not-present page
[  137.217520] PGD 0 P4D 0=20
[  137.217523] Oops: 0000 [#1] PREEMPT SMP NOPTI
[  137.217527] CPU: 19 PID: 1058 Comm: zsh Not tainted 5.15.0-rc3-niklas #2=
5 ad1c778d4b5b0053fcbb87077df466d6ee92e65b
[  137.217532] Hardware name: To Be Filled By O.E.M. To Be Filled By O.E.M.=
/X570 Creator, BIOS P3.40 01/28/2021
[  137.217534] RIP: 0010:acpi_pci_find_companion+0x9a/0x100
[  137.217540] Code: 83 e0 07 41 c1 e5 0d 41 81 e5 00 00 1f 00 41 09 c5 0f =
b6 83 79 ff ff ff 45 89 ee 83 e8 01 3c 01 48 8b 43 40 41 0f 96 c7 31 ed <4c=
> 8b a0 98 02 00 00 4c 89 e7 e8 97 57 04 00 49 8d 7c 24 f0 44 89
[  137.217543] RSP: 0018:ffffbb978392bb88 EFLAGS: 00010246
[  137.217545] RAX: 0000000000000000 RBX: ffff9cb20c0b80d0 RCX: 00000000000=
000a4
[  137.217548] RDX: ffff9cb1cfdddf40 RSI: 0000000000000100 RDI: ffffffff897=
474e0
[  137.217549] RBP: 0000000000000000 R08: 0000000000000004 R09: ffffbb97839=
2bb94
[  137.217551] R10: ffff9cb1d3588900 R11: 0000000000000004 R12: ffff9cb20c0=
b8000
[  137.217552] R13: 0000000000100000 R14: 0000000000100000 R15: 00000000000=
00000
[  137.217555] FS:  00007f0f792de140(0000) GS:ffff9cc0eeec0000(0000) knlGS:=
0000000000000000
[  137.217557] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  137.217559] CR2: 0000000000000298 CR3: 0000000108492000 CR4: 00000000003=
50ee0
[  137.217561] Call Trace:
[  137.217564]  pci_set_acpi_fwnode+0x34/0x60
[  137.217567]  pci_setup_device+0xe1/0x270
[  137.217572]  pci_iov_add_virtfn+0x27e/0x330
[  137.217577]  sriov_enable+0x219/0x3e0
[  137.217580]  ixgbe_pci_sriov_configure+0xf3/0x170 [ixgbe 7655574dbcea556=
149b0aede65e6825fd4dfd120]
[  137.217599]  sriov_numvfs_store+0xbe/0x130
[  137.217603]  kernfs_fop_write_iter+0x11c/0x1b0
[  137.217607]  new_sync_write+0x15c/0x1f0
[  137.217612]  vfs_write+0x1eb/0x280
[  137.217615]  ksys_write+0x67/0xe0
[  137.217618]  do_syscall_64+0x5c/0x80
[  137.217622]  ? syscall_exit_to_user_mode+0x23/0x40
[  137.217626]  ? do_syscall_64+0x69/0x80
[  137.217629]  ? syscall_exit_to_user_mode+0x23/0x40
[  137.217632]  ? do_syscall_64+0x69/0x80
[  137.217635]  ? syscall_exit_to_user_mode+0x23/0x40
[  137.217638]  ? do_syscall_64+0x69/0x80
[  137.217640]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[  137.217645] RIP: 0033:0x7f0f793ce907
[  137.217648] Code: 0d 00 f7 d8 64 89 02 48 c7 c0 ff ff ff ff eb b7 0f 1f =
00 f3 0f 1e fa 64 8b 04 25 18 00 00 00 85 c0 75 10 b8 01 00 00 00 0f 05 <48=
> 3d 00 f0 ff ff 77 51 c3 48 83 ec 28 48 89 54 24 18 48 89 74 24
[  137.217650] RSP: 002b:00007ffdb6a8e7e8 EFLAGS: 00000246 ORIG_RAX: 000000=
0000000001
[  137.217652] RAX: ffffffffffffffda RBX: 0000000000000002 RCX: 00007f0f793=
ce907
[  137.217654] RDX: 0000000000000002 RSI: 0000564d342b2240 RDI: 00000000000=
00001
[  137.217656] RBP: 0000564d342b2240 R08: 000000000000000a R09: 00000000000=
00000
[  137.217657] R10: 0000000000000000 R11: 0000000000000246 R12: 00000000000=
00002
[  137.217659] R13: 00007f0f794a0520 R14: 0000000000000002 R15: 00007f0f794=
a0700
[  137.217662] Modules linked in: xt_CHECKSUM xt_MASQUERADE xt_conntrack ip=
t_REJECT nf_reject_ipv4 xt_tcpudp ip6table_mangle ip6table_nat ip6table_fil=
ter ip6_tables iptable_mangle iptable_nat nf_nat nf_conntrack nf_defrag_ipv=
6 nf_defrag_ipv4 iptable_filter bridge stp llc cmac algif_hash algif_skciph=
er af_alg bnep nct6683 lm92 dm_multipath scsi_dh_rdac scsi_dh_emc scsi_dh_a=
lua iwlmvm snd_hda_codec_realtek intel_rapl_msr snd_hda_codec_generic intel=
_rapl_common amdgpu ledtrig_audio snd_hda_codec_hdmi snd_hda_intel edac_mce=
_amd snd_intel_dspcfg gpu_sched snd_intel_sdw_acpi kvm_amd drm_ttm_helper m=
ac80211 ttm snd_hda_codec snd_usb_audio btusb snd_usbmidi_lib kvm drm_kms_h=
elper btrtl snd_rawmidi btbcm snd_seq_device snd_hda_core btintel mc snd_hw=
dep wmi_bmof mxm_wmi intel_wmi_thunderbolt libarc4 snd_pcm irqbypass cec cr=
ct10dif_pclmul crc32_pclmul iwlwifi ghash_clmulni_intel bluetooth agpgart s=
nd_timer aesni_intel syscopyarea sp5100_tco sysfillrect crypto_simd atlanti=
c ecdh_generic snd joydev
[  137.217722]  cryptd ecc sysimgblt rapl dm_mod pcspkr k10temp ccp i2c_pii=
x4 fb_sys_fops mousedev soundcore crc16 cfg80211 ixgbe macsec igb mdio_devr=
es rfkill i2c_algo_bit libphy thunderbolt mdio wireguard dca curve25519_x86=
_64 libchacha20poly1305 chacha_x86_64 poly1305_x86_64 tpm_crb libblake2s bl=
ake2s_x86_64 libcurve25519_generic tpm_tis wmi tpm_tis_core libchacha libbl=
ake2s_generic tpm ip6_udp_tunnel rng_core udp_tunnel pinctrl_amd mac_hid ac=
pi_cpufreq usbip_host usbip_core sg drm crypto_user fuse bpf_preload ip_tab=
les x_tables hid_logitech_hidpp hid_logitech_dj usbhid btrfs blake2b_generi=
c libcrc32c crc32c_generic xor raid6_pq crc32c_intel sr_mod cdrom xhci_pci =
xhci_pci_renesas vfat fat
[  137.217772] CR2: 0000000000000298
[  137.217774] ---[ end trace b5fd99c7b5c7e77b ]---
[  137.217776] RIP: 0010:acpi_pci_find_companion+0x9a/0x100
[  137.217779] Code: 83 e0 07 41 c1 e5 0d 41 81 e5 00 00 1f 00 41 09 c5 0f =
b6 83 79 ff ff ff 45 89 ee 83 e8 01 3c 01 48 8b 43 40 41 0f 96 c7 31 ed <4c=
> 8b a0 98 02 00 00 4c 89 e7 e8 97 57 04 00 49 8d 7c 24 f0 44 89
[  137.217781] RSP: 0018:ffffbb978392bb88 EFLAGS: 00010246
[  137.217783] RAX: 0000000000000000 RBX: ffff9cb20c0b80d0 RCX: 00000000000=
000a4
[  137.217784] RDX: ffff9cb1cfdddf40 RSI: 0000000000000100 RDI: ffffffff897=
474e0
[  137.217786] RBP: 0000000000000000 R08: 0000000000000004 R09: ffffbb97839=
2bb94
[  137.217788] R10: ffff9cb1d3588900 R11: 0000000000000004 R12: ffff9cb20c0=
b8000
[  137.217789] R13: 0000000000100000 R14: 0000000000100000 R15: 00000000000=
00000
[  137.217791] FS:  00007f0f792de140(0000) GS:ffff9cc0eeec0000(0000) knlGS:=
0000000000000000
[  137.217793] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  137.217795] CR2: 0000000000000298 CR3: 0000000108492000 CR4: 00000000003=
50ee0

