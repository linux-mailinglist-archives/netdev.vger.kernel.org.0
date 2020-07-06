Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 650F521610A
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 23:46:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726886AbgGFVqa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 17:46:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725860AbgGFVqa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 17:46:30 -0400
X-Greylist: delayed 427 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 06 Jul 2020 14:46:29 PDT
Received: from mail.3c7.de (srv2.3c7.de [IPv6:2a00:12c0:1015:103::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB180C061755
        for <netdev@vger.kernel.org>; Mon,  6 Jul 2020 14:46:29 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by mail.3c7.de (Postfix) with ESMTP id 161D4C0253;
        Mon,  6 Jul 2020 23:39:17 +0200 (CEST)
X-DKIM: Sendmail DKIM Filter v2.8.2 mail.3c7.de 161D4C0253
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=tilman-klaeger.de;
        s=dkim_6; t=1594071557;
        bh=hsGtRH5Bsi7nGMG8UJhb2UzWkBPrgVZkhQVYejbdGxc=;
        h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
         MIME-Version:Content-Transfer-Encoding:Content-Type;
        b=gdCkquccQj79fWPqk5ydqPjH4FWewe52F8Ov9ILOltF+eo6x99SrCCLjRasyoqtQv
         FQdM8YrLFy9I8NU7ZVOAyTiU4BqOi1TFdE+0HuXwASOEXKehWbuWg96lfmsDGcYe/E
         Vd8SPWd1mpNp2Mq1vw3Qm7UWkAkb5r6GrUjZUWuY=
X-Virus-Scanned: Mail checked by aMaViSd at mail.3c7.de
Received: from asterix.localnet (dynamic-2a01-0c22-a85f-d400-eb7f-89b5-cd0e-481d.c22.pool.telefonica.de [IPv6:2a01:c22:a85f:d400:eb7f:89b5:cd0e:481d])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: tilman@3c7.de)
        by mail.3c7.de (Postfix) with ESMTPSA id E0DDCC020D;
        Mon,  6 Jul 2020 23:39:13 +0200 (CEST)
From:   Tilman Klaeger <linux@tilman-klaeger.de>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     =?ISO-8859-1?Q?Dani=EBl?= Sonck <dsonck92@gmail.com>,
        netdev@vger.kernel.org
Subject: Re: BUG: kernel NULL pointer dereference in __cgroup_bpf_run_filter_skb
Date:   Mon, 06 Jul 2020 23:39:11 +0200
Message-ID: <15785048.G5i6evtKuP@asterix>
In-Reply-To: <CAM_iQpUKQJrj8wE+Qa8NGR3P0L+5Uz=qo-O5+k_P60HzTde6aw@mail.gmail.com>
References: <CAMtihapJKityT=urbrx2yq-csRQ4u7Vcosrf0NzUZtrHfmN0cQ@mail.gmail.com> <CAM_iQpUKQJrj8wE+Qa8NGR3P0L+5Uz=qo-O5+k_P60HzTde6aw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am Sonntag, 14. Juni 2020, 20:29:34 CEST schrieb Cong Wang:
> Hello,
>=20
> On Sun, Jun 14, 2020 at 5:39 AM Dani=EBl Sonck <dsonck92@gmail.com> wrote:
> > Hello,
> >=20
> > I found on the archive that this bug I encountered also happened to
> > others. I too have a very similar stacktrace. The issue I'm
> > experiencing is:
> >=20
> > Whenever I fully boot my cluster, in some time, the host crashes with
> > the __cgroup_bpf_run_filter_skb NULL pointer dereference. This has
> > been sporadic enough before not to cause real issues. However, as of
> > lately, the bug is triggered much more frequently. I've changed my
> > server hardware so I could capture serial output in order to get the
> > trace. This trace looked very similar as reported by Lu Fengqi. As it
> > currently stands, I cannot run the cluster as it's almost instantly
> > crashing the host.
>=20
> This has been reported for multiple times. Are you able to test the
> attached patch? And let me know if everything goes fine with it.
>=20
> I suspect we may still leak some cgroup refcnt even with the patch,
> but it might be much harder to trigger with this patch applied.
>=20
> Thanks.
Hello,

I experienced the same (or at least a very similiar) bug on my system and t=
his=20
patch definitelly works for me. I've had uptimes between a couple hours and=
 3=20
days, now the system has been working without panics for 14 days. Two simil=
iar=20
systems haven't any trouble yet but are also less intensively used, especia=
lly=20
in terms of docker. This may change and maybe I can report back again.=20

Thank you very much for the patch!

Kind regards
Tilman


P.S. For the statistics or further bugtracking:

My setup, if you need any more details just let me know:
* 2x10 Core Intel Xeon Silver 4114 (Sky Lake) in Dell Workstation
* NVidia Quadro P5000 GPU using proprietary drivers
* Current Arch Linux on Linux Kernel 5.7.4, then changed to 5.4.47 (LTS, no=
w=20
patched and running, not working without patch)
* Docker 1:19.03.11-1 with changing containers (Developement Workstation)

Here are two logs captured using serial console:

[40282.425243] BUG: kernel NULL pointer dereference, address: 0000000000000=
010
[40282.432201] #PF: supervisor read access in kernel mode
[40282.437330] #PF: error_code(0x0000) - not-present page
[40282.442458] PGD 0 P4D 0=20
[40282.444992] Oops: 0000 [#1] SMP PTI
[40282.448475] CPU: 27 PID: 0 Comm: swapper/27 Tainted: P           OE    =
=20
5.4.46-1-lts #1
[40282.456461] Hardware name: Dell Inc. Precision 7820 Tower/05WNJ2, BIOS=20
2.0.5 05/17/2019
[40282.464452] RIP: 0010:__cgroup_bpf_run_filter_skb+0xca/0x1d0
[40282.470099] Code: 48 89 83 c8 00 00 00 48 01 c8 48 89 14 24 48 89 43 50 =
41=20
83 ff 01 0f 84 92 00 00 00 44 89 fa 48 8d 84 d6 30 06 00 00 48 8b 00 <48> 8=
b 78=20
10 4c 8d 78 10 48 85 ff 0f 84 df 00 00 00 bd 01 00 00 00
[40282.488830] RSP: 0018:ffffa8180cff8bb8 EFLAGS: 00010297
[40282.494043] RAX: 0000000000000000 RBX: ffff91836559a400 RCX: 00000000000=
0008c
[40282.501161] RDX: 0000000000000000 RSI: ffff91ab6810d000 RDI: ffff91874e8=
7e900
[40282.508279] RBP: ffff91836559a400 R08: 0000000000000000 R09: 00000000000=
00001
[40282.515398] R10: 0000000000001003 R11: 0000000000000000 R12:=20
0000000000000014
[40282.522517] R13: 0000000000000014 R14: ffff9183772332a2 R15: 00000000000=
00000
[40282.529636] FS:  0000000000000000(0000) GS:ffff918770e40000(0000) knlGS:
0000000000000000
[40282.537708] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[40282.543440] CR2: 0000000000000010 CR3: 00000025d960a006 CR4:=20
00000000007606e0
[40282.550559] DR0: 0000000000000000 DR1: 0000000000000000 DR2:=20
0000000000000000
[40282.557678] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 00000000000=
00400
[40282.564798] PKRU: 55555554
[40282.567498] Call Trace:
[40282.569940]  <IRQ>
[40282.571953]  sk_filter_trim_cap+0x123/0x220
[40282.576131]  ? tcp_v4_inbound_md5_hash+0x56/0x170
[40282.580825]  tcp_v4_rcv+0x990/0xbc0
[40282.584308]  ip_protocol_deliver_rcu+0x2b/0x1b0
[40282.588827]  ip_local_deliver_finish+0x44/0x50
[40282.593278]  ip_local_deliver+0xf5/0x100
[40282.597191]  ? ip_protocol_deliver_rcu+0x1b0/0x1b0
[40282.601970]  ip_rcv+0xc5/0xd0
[40282.604930]  ? ip_rcv_finish_core.constprop.0+0x390/0x390
[40282.610319]  __netif_receive_skb_one_core+0x87/0xa0
[40282.615187]  netif_receive_skb_internal+0x52/0xc0
[40282.619882]  napi_gro_receive+0x114/0x140
[40282.623895]  e1000_clean_rx_irq+0x1f7/0x420 [e1000e]
[40282.628853]  e1000e_poll+0x7a/0x2c0 [e1000e]
[40282.633115]  net_rx_action+0x16d/0x3f0
[40282.636859]  __do_softirq+0xe9/0x2dc
[40282.640429]  irq_exit+0xa2/0xe0
[40282.643562]  do_IRQ+0x58/0xe0
[40282.646523]  common_interrupt+0xf/0xf
[40282.650176]  </IRQ>
[40282.652274] RIP: 0010:cpuidle_enter_state+0xea/0x400
[40282.657227] Code: ec 2d 76 e8 e8 38 99 ff 48 89 04 24 0f 1f 44 00 00 31 =
ff e8=20
98 46 99 ff 80 7c 24 0b 00 0f 85 12 02 00 00 fb 66 0f 1f 44 00 00 <45> 85 e=
4 0f=20
88 1e 02 00 00 49 63 cc 48 8b 34 24 48 8d 04 49 48 c1
[40282.675957] RSP: 0018:ffffa8180031be80 EFLAGS: 00000246 ORIG_RAX: ffffff=
ffffffffdc
[40282.683511] RAX: ffff918770e6a500 RBX: ffffffff8a8bba00 RCX: 00000000000=
0001f
[40282.690630] RDX: 0000000000000000 RSI: 000000003a518aaa RDI:=20
0000000000000000
[40282.697750] RBP: ffff918770e74d00 R08: 000024a2fba509a0 R09: 000000000a8=
0a000
[40282.704867] R10: 0000000000004e29 R11: ffff918770e692c0 R12: 00000000000=
00003
[40282.711986] R13: ffffffff8a8bbb20 R14: ffffffff8a8bbb38 R15: 000024a2fb5=
09686
[40282.719106]  cpuidle_enter+0x29/0x40
[40282.722675]  do_idle+0x1c4/0x240
[40282.725894]  cpu_startup_entry+0x19/0x20
[40282.729810]  start_secondary+0x176/0x1d0
[40282.733726]  secondary_startup_64+0xb6/0xc0
[40282.737899] Modules linked in: uvcvideo videobuf2_vmalloc videobuf2_memo=
ps=20
videobuf2_v4l2 videobuf2_common videodev mc uinput rfcomm fuse xt_nat veth=
=20
xt_MASQUERADE nf_conntrack_netlink nfnetlink xfrm_user xfrm_algo xt_addrtyp=
e=20
br_netfilter bridge cfg80211 tun md4 nls_utf8 cifs libarc4 dns_resolver fsc=
ache=20
libdes ext4 mbcache jbd2 iptable_security iptable_raw iptable_mangle=20
xt_conntrack xt_tcpudp cmac algif_hash iptable_filter iptable_nat 8021q nf_=
nat=20
algif_skcipher nf_conntrack garp af_alg mrp stp nf_defrag_ipv6 bnep llc=20
nf_defrag_ipv4 intel_rapl_msr intel_rapl_common isst_if_common nvidia_drm(P=
OE)=20
nvidia_modeset(POE) skx_edac nfit nvidia(POE) snd_hda_codec_hdmi=20
x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm dell_wmi=20
dell_smbios dcdbas iTCO_wdt irqbypass mei_wdt iTCO_vendor_support wmi_bmof=
=20
sparse_keymap dell_wmi_descriptor intel_wmi_thunderbolt dell_smm_hwmon=20
crct10dif_pclmul crc32_pclmul ghash_clmulni_intel aesni_intel nls_iso8859_1=
=20
snd_hda_codec_realtek nls_cp437
[40282.737948]  crypto_simd snd_hda_codec_generic vfat cryptd glue_helper f=
at=20
intel_cstate ledtrig_audio btusb btrtl btbcm btintel snd_hda_intel bluetoot=
h=20
snd_intel_nhlt snd_hda_codec drm_kms_helper snd_hda_core snd_hwdep ofpart=20
snd_pcm ipmi_devintf cmdlinepart ipmi_msghandler intel_spi_pci ecdh_generic=
=20
intel_spi snd_timer syscopyarea intel_uncore rfkill sysfillrect sysimgblt=20
spi_nor ecc mousedev intel_rapl_perf input_leds e1000e fb_sys_fops crc16 sn=
d=20
vmd mtd soundcore mei_me i2c_i801 lpc_ich mei ioatdma dca wmi evdev mac_hid=
=20
nfsd nfs_acl drm lockd auth_rpcgss grace sunrpc crypto_user agpgart ip_tabl=
es=20
x_tables hid_logitech_hidpp uas usb_storage btrfs libcrc32c crc32c_generic =
xor=20
hid_logitech_dj hid_generic usbhid hid raid6_pq sr_mod cdrom sd_mod serio_r=
aw=20
atkbd libps2 ahci ata_generic libahci pata_acpi crc32c_intel libata xhci_pc=
i=20
scsi_mod xhci_hcd i8042 serio
[40282.900416] CR2: 0000000000000010
[40282.903737] ---[ end trace 59098be211c9040b ]---
[40282.924544] RIP: 0010:__cgroup_bpf_run_filter_skb+0xca/0x1d0
[40282.930191] Code: 48 89 83 c8 00 00 00 48 01 c8 48 89 14 24 48 89 43 50 =
41=20
83 ff 01 0f 84 92 00 00 00 44 89 fa 48 8d 84 d6 30 06 00 00 48 8b 00 <48> 8=
b 78=20
10 4c 8d 78 10 48 85 ff 0f 84 df 00 00 00 bd 01 00 00 00
[40282.948922] RSP: 0018:ffffa8180cff8bb8 EFLAGS: 00010297
[40282.954136] RAX: 0000000000000000 RBX: ffff91836559a400 RCX: 00000000000=
0008c
[40282.961254] RDX: 0000000000000000 RSI: ffff91ab6810d000 RDI: ffff91874e8=
7e900
[40282.968373] RBP: ffff91836559a400 R08: 0000000000000000 R09: 00000000000=
00001
[40282.975490] R10: 0000000000001003 R11: 0000000000000000 R12:=20
0000000000000014
[40282.982608] R13: 0000000000000014 R14: ffff9183772332a2 R15: 00000000000=
00000
[40282.989729] FS:  0000000000000000(0000) GS:ffff918770e40000(0000) knlGS:
0000000000000000
[40282.997801] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[40283.003533] CR2: 0000000000000010 CR3: 00000025d960a006 CR4:=20
00000000007606e0
[40283.010652] DR0: 0000000000000000 DR1: 0000000000000000 DR2:=20
0000000000000000
[40283.017771] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 00000000000=
00400
[40283.024890] PKRU: 55555554
[40283.027589] Kernel panic - not syncing: Fatal exception in interrupt
[40283.034002] Kernel Offset: 0x8600000 from 0xffffffff81000000 (relocation=
 range:=20
0xffffffff80000000-0xffffffffbfffffff)
[40283.060906] ---[ end Kernel panic - not syncing: Fatal exception in=20
interrupt ]---

The second one, slightly different:
[131527.564414] general protection fault: 0000 [#1] SMP PTI
[131527.569729] CPU: 21 PID: 0 Comm: swapper/21 Tainted: P           OE    =
=20
5.4.47-1-lts #1
[131527.577805] Hardware name: Dell Inc. Precision 7820 Tower/05WNJ2, BIOS=
=20
2.0.5 05/17/2019
[131527.585890] RIP: 0010:cgroup_sk_free+0x26/0x80
[131527.590415] Code: 93 0f 1f 00 0f 1f 44 00 00 53 48 8b 07 48 c7 c3 b0 d3=
 05=20
a0 a8 01 75 07 48 85 c0 48 0f 45 d8 48 8b 83 c8 08 00 00 a8 03 75 1a <65> 4=
8 ff=20
08 f6 43 7c 01 74 02 5b c3 48 8b 43 18 a8 03 75 26 65 48
[131527.609235] RSP: 0018:ffffafb3ccec0c30 EFLAGS: 00010246
[131527.614536] RAX: ffff8c9e2199f000 RBX: ffff8c9e2199f000 RCX: 0000000000=
000040
[131527.621740] RDX: 0000000000000000 RSI: 0000000000000000 RDI:=20
ffff8c9b0814f450
[131527.628947] RBP: ffff8c9b0814f1c0 R08: 0000000000000000 R09:=20
0000000000000001
[131527.636152] R10: ffff8c9a1fe6e600 R11: 0000000000000000 R12: ffff8c9e27=
430fc0
[131527.643359] R13: 0000000000000000 R14: ffff8c9b0814f248 R15:=20
0000000000000000
[131527.650566] FS:  0000000000000000(0000) GS:ffff8c9e30cc0000(0000) knlGS:
0000000000000000
[131527.658727] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[131527.664545] CR2: 00007f1b7002e730 CR3: 000000259f60a003 CR4:=20
00000000007606e0
[131527.671752] DR0: 0000000000000000 DR1: 0000000000000000 DR2:=20
0000000000000000
[131527.678959] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:=20
0000000000000400
[131527.686166] PKRU: 55555554
[131527.688952] Call Trace:
[131527.691479]  <IRQ>
[131527.693577]  __sk_destruct+0x11a/0x1d0
[131527.697409]  tcp_v4_rcv+0xac2/0xbc0
[131527.700977]  ip_protocol_deliver_rcu+0x2b/0x1b0
[131527.705584]  ip_local_deliver_finish+0x44/0x50
[131527.710102]  ip_local_deliver+0xf5/0x100
[131527.714102]  ? ip_protocol_deliver_rcu+0x1b0/0x1b0
[131527.718967]  ip_rcv+0xc5/0xd0
[131527.722013]  ? ip_rcv_finish_core.constprop.0+0x390/0x390
[131527.727504]  __netif_receive_skb_one_core+0x87/0xa0
[131527.732459]  netif_receive_skb_internal+0x52/0xc0
[131527.737240]  napi_gro_receive+0x114/0x140
[131527.741353]  e1000_clean_rx_irq+0x1f7/0x420 [e1000e]
[131527.746398]  e1000e_poll+0x7a/0x2c0 [e1000e]
[131527.750745]  net_rx_action+0x16d/0x3f0
[131527.754574]  __do_softirq+0xe9/0x2dc
[131527.758230]  irq_exit+0xa2/0xe0
[131527.761450]  do_IRQ+0x58/0xe0
[131527.764497]  common_interrupt+0xf/0xf
[131527.768236]  </IRQ>
[131527.770419] RIP: 0010:cpuidle_enter_state+0xea/0x400
[131527.775460] Code: ec ad 60 e8 08 39 99 ff 48 89 04 24 0f 1f 44 00 00 31=
 ff=20
e8 b8 46 99 ff 80 7c 24 0b 00 0f 85 12 02 00 00 fb 66 0f 1f 44 00 00 <45> 8=
5 e4=20
0f 88 1e 02 00 00 49 63 cc 48 8b 34 24 48 8d 04 49 48 c1
[131527.794278] RSP: 0018:ffffafb3c02ebe80 EFLAGS: 00000246 ORIG_RAX: fffff=
fffffffffdc
[131527.801919] RAX: ffff8c9e30cea500 RBX: ffffffffa00bba00 RCX: 0000000000=
00001f
[131527.809124] RDX: 0000000000000000 RSI: 000000003a518aaa RDI:=20
0000000000000000
[131527.816329] RBP: ffff8c9e30cf4d00 R08: 0000779fa5c0a379 R09: 0000779ff0=
724ae1
[131527.823536] R10: 0000000000002284 R11: ffff8c9e30ce92c0 R12:=20
0000000000000003
[131527.830743] R13: ffffffffa00bbb20 R14: ffffffffa00bbb38 R15: 0000779fa5=
bdd653
[131527.837952]  cpuidle_enter+0x29/0x40
[131527.841609]  do_idle+0x1c4/0x240
[131527.844918]  cpu_startup_entry+0x19/0x20
[131527.848921]  start_secondary+0x176/0x1d0
[131527.852935]  secondary_startup_64+0xb6/0xc0
[131527.857194] Modules linked in: rfcomm(E) fuse(E) xt_nat veth xt_MASQUER=
ADE=20
nf_conntrack_netlink nfnetlink xfrm_user xfrm_algo xt_addrtype br_netfilter=
=20
bridge cfg80211 tun md4 nls_utf8 cifs libarc4 dns_resolver fscache libdes=20
iptable_security iptable_raw iptable_mangle xt_conntrack xt_tcpudp cmac=20
iptable_filter algif_hash iptable_nat nf_nat algif_skcipher nf_conntrack 80=
21q=20
garp af_alg mrp nf_defrag_ipv6 stp bnep llc nf_defrag_ipv4 intel_rapl_msr=20
intel_rapl_common isst_if_common nvidia_drm(POE) nvidia_modeset(POE)=20
snd_hda_codec_hdmi nvidia(POE) skx_edac nfit x86_pkg_temp_thermal=20
intel_powerclamp coretemp kvm_intel dell_wmi nls_iso8859_1 nls_cp437=20
snd_hda_codec_realtek dell_smbios kvm dcdbas iTCO_wdt vfat mei_wdt irqbypas=
s=20
iTCO_vendor_support dell_wmi_descriptor wmi_bmof sparse_keymap=20
intel_wmi_thunderbolt dell_smm_hwmon snd_hda_codec_generic fat=20
crct10dif_pclmul crc32_pclmul ledtrig_audio btusb ghash_clmulni_intel btrtl=
=20
aesni_intel btbcm snd_hda_intel btintel ofpart snd_intel_nhlt
[131527.857229]  crypto_simd bluetooth cmdlinepart snd_hda_codec cryptd=20
glue_helper drm_kms_helper snd_hda_core intel_cstate snd_hwdep snd_pcm=20
ipmi_devintf intel_spi_pci ipmi_msghandler intel_spi intel_uncore snd_timer=
=20
syscopyarea ecdh_generic spi_nor snd sysfillrect mei_me rfkill sysimgblt=20
ioatdma ecc mousedev intel_rapl_perf input_leds e1000e fb_sys_fops crc16 mt=
d=20
vmd soundcore i2c_i801 lpc_ich mei wmi dca evdev mac_hid nfsd nfs_acl drm=20
lockd auth_rpcgss grace sunrpc crypto_user agpgart ip_tables x_tables=20
hid_logitech_hidpp btrfs libcrc32c crc32c_generic xor uas usb_storage=20
hid_logitech_dj hid_generic usbhid hid raid6_pq sr_mod cdrom sd_mod serio_r=
aw=20
atkbd libps2 ata_generic ahci pata_acpi libahci xhci_pci libata crc32c_inte=
l=20
xhci_hcd scsi_mod i8042 serio
[131528.010630] ---[ end trace 779287d3980c54e5 ]---
[131528.026121] RIP: 0010:cgroup_sk_free+0x26/0x80
[131528.030646] Code: 93 0f 1f 00 0f 1f 44 00 00 53 48 8b 07 48 c7 c3 b0 d3=
 05=20
a0 a8 01 75 07 48 85 c0 48 0f 45 d8 48 8b 83 c8 08 00 00 a8 03 75 1a <65> 4=
8 ff=20
08 f6 43 7c 01 74 02 5b c3 48 8b 43 18 a8 03 75 26 65 48
[131528.049469] RSP: 0018:ffffafb3ccec0c30 EFLAGS: 00010246
[131528.054774] RAX: ffff8c9e2199f000 RBX: ffff8c9e2199f000 RCX: 0000000000=
000040
[131528.061982] RDX: 0000000000000000 RSI: 0000000000000000 RDI:=20
ffff8c9b0814f450
[131528.069191] RBP: ffff8c9b0814f1c0 R08: 0000000000000000 R09:=20
0000000000000001
[131528.076417] R10: ffff8c9a1fe6e600 R11: 0000000000000000 R12: ffff8c9e27=
430fc0
[131528.083628] R13: 0000000000000000 R14: ffff8c9b0814f248 R15:=20
0000000000000000
[131528.090839] FS:  0000000000000000(0000) GS:ffff8c9e30cc0000(0000) knlGS:
0000000000000000
[131528.099002] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[131528.104826] CR2: 00007f1b7002e730 CR3: 000000259f60a003 CR4:=20
00000000007606e0
[131528.114316] DR0: 0000000000000000 DR1: 0000000000000000 DR2:=20
0000000000000000
[131528.121524] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:=20
0000000000000400
[131528.128734] PKRU: 55555554
[131528.131524] Kernel panic - not syncing: Fatal exception in interrupt
[131528.138042] Kernel Offset: 0x1de00000 from 0xffffffff81000000 (relocati=
on=20
range: 0xffffffff80000000-0xffffffffbfffffff)
[131528.161583] ---[ end Kernel panic - not syncing: Fatal exception in=20
interrupt ]---



