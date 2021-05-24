Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4FB938E707
	for <lists+netdev@lfdr.de>; Mon, 24 May 2021 15:01:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232734AbhEXNDW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 May 2021 09:03:22 -0400
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:43029 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232424AbhEXNDV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 May 2021 09:03:21 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id E4A0923FE;
        Mon, 24 May 2021 09:01:52 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Mon, 24 May 2021 09:01:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cerno.tech; h=
        date:from:to:cc:subject:message-id:mime-version:content-type; s=
        fm2; bh=aNCZUa7QqC6dD9ZLjjM2Eas1cdBQByWA1PYf0G6l0RU=; b=hgj7cSsD
        Ks3xO3064z1vOYBLWfLS/k7Of6GvegrGval4MlzV3tHcIjcT0JxM7yD2TFTmnNhc
        De21o5lpOyOJLkT69MWss6N0hgb+rzlhnIlFXevIXE3QjRTjkuVFQeeSWQ7zpY5U
        Lj46b2Tb+BwerB4+qZ0LDExxsRyuSCwk9SjsKLXoX1SU7pU7cxBgDbArWit2G1z/
        AIKsPXteE+jhLJV9q/1GUkOuSQ49MvtzCXgDV9ueCvuuC+PjRSu7dGJ8bmzetqV4
        o2GVLjnLQKkGD/yxuG/K52ANzCBsr2n89AmJpYzhbGRmj9VyTukRJHN6p44iw8mT
        pQrfLVhFkxhYtg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:message-id
        :mime-version:subject:to:x-me-proxy:x-me-proxy:x-me-sender
        :x-me-sender:x-sasl-enc; s=fm2; bh=aNCZUa7QqC6dD9ZLjjM2Eas1cdBQB
        yWA1PYf0G6l0RU=; b=XUgcFUM/tHWmAT7tQqVCFqaWQ1bad1U83WvCgI2MEv+mM
        A+U7s/NfSry7ANaFG1sDzn2cDtwF9cpynaa0QDRiGwYdXZeZWBujea/uAldy80TL
        I9z5VLldGb/IcCERiCDQBZK3OkRtFCuQLfF747NYfGGMp3woWOCdCxMsZRRHKjht
        tJ9I4YRtq61vIWn7aSzaOl1CoBMC6DV3sinDt9+93D4qfpL9g6NM68mYkXNvLZtM
        KD+QimtZ2PVeTUb4AJgLWHhi569HAW//zdtr3KxPRRn+oLK4vx2p/HZ/JR5BfJnH
        OrSK94BfrDvxQBXd7ruv3UmHP6F3tgP4+f3MBwhNA==
X-ME-Sender: <xms:wKOrYLAQdaprdEFcb7rbHww0fgp_NR8TuKxfmLX0tcMfKL2ZlifAgg>
    <xme:wKOrYBhXDAs2aVy-BYUJ1ygZnrhdRTPWKmZ_wF-z_vZUaS_kLkGK8H0JgY92JdXzC
    _vx4o1iXu_0O9dLLFo>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdejledgiedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfggtggusehgtderredttddvnecuhfhrohhmpeforgigihhmvgcu
    tfhiphgrrhguuceomhgrgihimhgvsegtvghrnhhordhtvggthheqnecuggftrfgrthhtvg
    hrnhepgeehvddvffelveeiuefggfeiueduvdfhfeeuhffgleejleeghfdvgedtveegleek
    necukfhppeeltddrkeelrdeikedrjeeinecuvehluhhsthgvrhfuihiivgeptdenucfrrg
    hrrghmpehmrghilhhfrhhomhepmhgrgihimhgvsegtvghrnhhordhtvggthh
X-ME-Proxy: <xmx:wKOrYGn9ANz5moeGdRqPlIEh_0QaA6HX_p9I4H5-kABHawFzMKfJVw>
    <xmx:wKOrYNynx398q7yad4J6cGC_MvCT6FtlQWmrnNjyU_nkx--eu-pA0A>
    <xmx:wKOrYATl5YtFurQDL2_CvtdsK5z5O0OAY_vGvDwBIvLKodkOECb-xw>
    <xmx:wKOrYGe3xGfixQTXALjC0qze4PWDGmO8MrKoNL1RkIYrjso0yq3TuQ>
Received: from localhost (lfbn-tou-1-1502-76.w90-89.abo.wanadoo.fr [90.89.68.76])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Mon, 24 May 2021 09:01:51 -0400 (EDT)
Date:   Mon, 24 May 2021 15:01:47 +0200
From:   Maxime Ripard <maxime@cerno.tech>
To:     Doug Berger <opendmb@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Cc:     bcm-kernel-feedback-list@broadcom.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Nicolas Saenz Julienne <nsaenz@kernel.org>
Subject: Kernel Panic in skb_release_data using genet
Message-ID: <20210524130147.7xv6ih2e3apu2zvu@gilmour>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="3plytasmu4pwlokc"
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--3plytasmu4pwlokc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Doug, Florian,

I've been running a RaspberryPi4 with a mainline kernel for a while,
booting from NFS. Every once in a while (I'd say ~20-30% of all boots),
I'm getting a kernel panic around the time init is started.

I was debugging a kernel based on drm-misc-next-2021-05-17 today with
KASAN enabled and got this, which looks related:

[    6.109454] mmc0: SDHCI controller on fe300000.sdhci [fe300000.sdhci] us=
ing PIO
[    6.124819] bcmgenet fd580000.ethernet: configuring instance for externa=
l RGMII (RX delay)
[    6.133391] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
[    6.140736] BUG: KASAN: user-memory-access in skb_release_data+0x14c/0x1=
fc
[    6.147748] Read of size 4 at addr 1c8befdc by task swapper/0/0
[    6.153776]=20
[    6.155300] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.13.0-rc1-v7l #165
[    6.162214] Hardware name: BCM2711
[    6.165679] Backtrace:=20
[    6.168183] [<c110f5a8>] (dump_backtrace) from [<c110f930>] (show_stack+=
0x20/0x24)
[    6.175931]  r7:c1e00000 r6:00000193 r5:00000000 r4:c837f8e0
[    6.181683] [<c110f910>] (show_stack) from [<c11156c0>] (dump_stack+0xb8=
/0xdc)
[    6.189051] [<c1115608>] (dump_stack) from [<c0514b30>] (kasan_report+0x=
11c/0x1c0)
[    6.196789]  r9:cc97ff02 r8:cc57e400 r7:c0ea3628 r6:00000000 r5:00000000=
 r4:1c8befdc
[    6.204655] [<c0514a14>] (kasan_report) from [<c05154d4>] (__asan_load4+=
0x74/0x90)
[    6.212393]  r7:cc97ff00 r6:00000000 r5:cc97ff28 r4:1c8befd4
[    6.218144] [<c0515460>] (__asan_load4) from [<c0ea3628>] (skb_release_d=
ata+0x14c/0x1fc)
[    6.226395] [<c0ea34dc>] (skb_release_data) from [<c0ea9d2c>] (consume_s=
kb+0x60/0x134)
[    6.234479]  r10:0000a8d8 r9:cc560000 r8:00000000 r7:cc560580 r6:0000000=
1 r5:cc57e4ac
[    6.242438]  r4:cc57e400 r3:cc97f680
[    6.246074] [<c0ea9ccc>] (consume_skb) from [<c0ec0d74>] (__dev_kfree_sk=
b_any+0x60/0x64)
[    6.254337]  r9:cc560000 r8:00000000 r7:cc560580 r6:00000001 r5:cc57e400=
 r4:c1e00000
[    6.262203] [<c0ec0d14>] (__dev_kfree_skb_any) from [<c0c814d4>] (bcmgen=
et_rx_poll+0x578/0x770)
[    6.271081]  r7:cc560580 r6:a8d81759 r5:cc57e400 r4:cc563ed8
[    6.276831] [<c0c80f5c>] (bcmgenet_rx_poll) from [<c0ed3f0c>] (__napi_po=
ll+0x60/0x2b8)
[    6.284925]  r10:c1e03d20 r9:c1e05d00 r8:cc563ee0 r7:c1e03d10 r6:0000004=
0 r5:00000001
[    6.292881]  r4:cc563ed8
[    6.295460] [<c0ed3eac>] (__napi_poll) from [<c0ed4a14>] (net_rx_action+=
0x580/0x620)
[    6.303377]  r10:c1e03d20 r9:c1e05d00 r8:0000012c r7:cc563edc r6:cc56000=
0 r5:cc563ed8
[    6.311333]  r4:c1e03d80
[    6.313911] [<c0ed4494>] (net_rx_action) from [<c02012e8>] (__do_softirq=
+0x1f0/0x69c)
[    6.321916]  r10:c1e00000 r9:00000008 r8:16b2f000 r7:00000003 r6:0000000=
4 r5:c18b9360
[    6.329872]  r4:c1e0508c
[    6.332449] [<c02010f8>] (__do_softirq) from [<c02367a4>] (irq_exit+0x18=
8/0x1b0)
[    6.340012]  r10:16b2f000 r9:c1e03ec0 r8:16b2f000 r7:c1e03e28 r6:ffffc00=
0 r5:c1cc0940
[    6.347969]  r4:c1e06ea4
[    6.350546] [<c023661c>] (irq_exit) from [<c02c75fc>] (__handle_domain_i=
rq+0xc4/0x128)
[    6.353302] bcmgenet fd580000.ethernet eth0: Link is Down
[    6.358635]  r9:c1e03ec0 r8:00000001 r7:00000000 r6:c1e00000 r5:00000000=
 r4:c1cbfe80
[    6.371956] [<c02c7538>] (__handle_domain_irq) from [<c09ef2b4>] (gic_ha=
ndle_irq+0x9c/0xb4)
[    6.380496]  r10:f080200c r9:f0802000 r8:c1e03ec0 r7:c1e07878 r6:c1cbfe8=
c r5:000000bd
[    6.388452]  r4:000000bd
[    6.391030] [<c09ef218>] (gic_handle_irq) from [<c0200abc>] (__irq_svc+0=
x5c/0x80)
[    6.398666] Exception stack(0xc1e03ec0 to 0xc1e03f08)
[    6.403821] 3ec0: c175a018 d87f0614 00000000 c0222bc0 c1e00000 c1e06e1c =
00000000 c1e06e6c
[    6.412145] 3ee0: c84ff712 c121e120 30c5387d c1e03f1c c175a018 c1e03f10 =
c020a204 c020a208
[    6.420459] 3f00: 60000013 ffffffff
[    6.424026]  r10:30c5387d r9:c1e00000 r8:c84ff712 r7:c1e03ef4 r6:fffffff=
f r5:60000013
[    6.431983]  r4:c020a208
[    6.434561] [<c020a1b8>] (arch_cpu_idle) from [<c112af34>] (default_idle=
_call+0x48/0x188)
[    6.442906] [<c112aeec>] (default_idle_call) from [<c0287578>] (do_idle+=
0x11c/0x180)
[    6.450816]  r9:c121e120 r8:c84ff712 r7:c1e06e6c r6:00000000 r5:c1e06e1c=
 r4:c1e00000
[    6.458681] [<c028745c>] (do_idle) from [<c0287a00>] (cpu_startup_entry+=
0x28/0x2c)
[    6.466416]  r9:410fd083 r8:c187df68 r7:c1e00000 r6:ca9d6000 r5:c85201e0=
 r4:000000e1
[    6.474283] [<c02879d8>] (cpu_startup_entry) from [<c111d7b8>] (rest_ini=
t+0x148/0x150)
[    6.482358] [<c111d670>] (rest_init) from [<c1801534>] (arch_call_rest_i=
nit+0x18/0x1c)
[    6.490450]  r7:c1e06dc0 r6:c1e00000 r5:c1e00000 r4:c851d5c0
[    6.496202] [<c180151c>] (arch_call_rest_init) from [<c1801990>] (start_=
kernel+0x3e0/0x424)
[    6.504723] [<c18015b0>] (start_kernel) from [<00000000>] (0x0)
[    6.510776]  r8:2eff9400 r7:00000c42 r6:30c0387d r5:00000000 r4:c1800334
[    6.517584] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
[    6.524921] Disabling lock debugging due to kernel taint
[    6.530467] 8<--- cut here ---
[    6.533628] Unable to handle kernel paging request at virtual address 1c=
8befdc
[    6.541025] pgd =3D (ptrval)
[    6.543837] [1c8befdc] *pgd=3D80000000004003, *pmd=3D00000000
[    6.549431] Internal error: Oops: 206 [#1] SMP ARM
[    6.554311] Modules linked in:
[    6.557433] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G    B             5.=
13.0-rc1-v7l #165
[    6.565755] Hardware name: BCM2711
[    6.569217] PC is at skb_release_data+0x14c/0x1fc
[    6.574015] LR is at end_report+0x6c/0xf0
[    6.578109] pc : [<c0ea3628>]    lr : [<c05148ac>]    psr: 60000113
[    6.584484] sp : c1e03ac8  ip : c1e03a60  fp : c1e03af4
[    6.589801] r10: cc57e462  r9 : cc97ff02  r8 : cc57e400
[    6.595116] r7 : cc97ff00  r6 : 00000000  r5 : cc97ff28  r4 : 1c8befd4
[    6.601755] r3 : 00000000  r2 : c1e0ccc0  r1 : c0514884  r0 : 00000001
[    6.608393] Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment=
 user
[    6.615657] Control: 30c5383d  Table: 00003000  DAC: fffffffd
[    6.621497] Register r0 information: non-paged memory
[    6.626651] Register r1 information: non-slab/vmalloc memory
[    6.632418] Register r2 information: non-slab/vmalloc memory
[    6.638185] Register r3 information: NULL pointer
[    6.642981] Register r4 information: non-paged memory
[    6.648129] Register r5 information: non-slab/vmalloc memory
[    6.653895] Register r6 information: NULL pointer
[    6.658690] Register r7 information: non-slab/vmalloc memory
[    6.664455] Register r8 information: slab skbuff_head_cache start cc57e4=
00 pointer offset 0 size 48
[    6.673715] Register r9 information: non-slab/vmalloc memory
[    6.679481] Register r10 information: slab skbuff_head_cache start cc57e=
400 pointer offset 98 size 48
[    6.688914] Register r11 information: non-slab/vmalloc memory
[    6.694768] Register r12 information: non-slab/vmalloc memory
[    6.700621] Process swapper/0 (pid: 0, stack limit =3D 0x(ptrval))
[    6.706730] Stack: (0xc1e03ac8 to 0xc1e04000)
[    6.711177] 3ac0:                   cc97f680 cc57e400 cc57e4ac 00000001 =
cc560580 00000000
[    6.719502] 3ae0: cc560000 0000a8d8 c1e03b1c c1e03af8 c0ea9d2c c0ea34e8 =
c1e00000 cc57e400
[    6.727825] 3b00: 00000001 cc560580 00000000 cc560000 c1e03b3c c1e03b20 =
c0ec0d74 c0ea9cd8
[    6.736149] 3b20: cc563ed8 cc57e400 a8d81759 cc560580 c1e03c54 c1e03b40 =
c0c814d4 c0ec0d20
[    6.744473] 3b40: c0210414 c05154fc c02103d8 ffffc000 c1e03b84 c1e03be0 =
c1e03c20 b73c0778
[    6.752795] 3b60: 00000040 cc5640e8 cc560588 cc560088 cc561944 cc563fe0 =
cc561580 cc563fd8
[    6.761118] 3b80: ca5c3c00 cc563fc8 cc563fd4 cc564078 0000000c 00000000 =
c1e03be4 00000000
[    6.769441] 3ba0: 00000000 cc563580 c0210430 00000000 00000000 cc920374 =
c1e03be4 c1e03c88
[    6.777764] 3bc0: 41b58ab3 c1730000 c0c80f5c cc920374 cc920340 00000001 =
c1e03d04 c1e03be8
[    6.786084] 3be0: 00000000 00000000 00000000 00000000 00000000 00000000 =
c1e03c24 c1e03c08
[    6.794406] 3c00: 41b58ab3 c16ca308 c02a73bc d87efd80 cab4d000 d87f0318 =
c1e03c4c 0147adf0
[    6.802729] 3c20: c175a5d0 b5ed3f2f c02012e8 cc563ed8 00000001 00000040 =
c1e03d10 cc563ee0
[    6.811052] 3c40: c1e05d00 c1e03d20 c1e03c94 c1e03c58 c0ed3f0c c0c80f68 =
c03a9ed0 c05154fc
[    6.819376] 3c60: c03aa120 cc563ed8 60000113 c1e03d80 cc563ed8 cc560000 =
cc563edc 0000012c
[    6.827700] 3c80: c1e05d00 c1e03d20 c1e03db4 c1e03c98 c0ed4a14 c0ed3eb8 =
d87f0740 b73c079c
[    6.836023] 3ca0: c02104fc c1e00000 c1e00010 c1e00000 c1e03d40 16b2f000 =
c1cc1740 c1e05d00
[    6.844347] 3cc0: ffff8d38 c1e03d20 c0210430 0000004c c1e03d04 c1e03ce0 =
c0c7e6e4 c051546c
[    6.852670] 3ce0: 41b58ab3 c17447f0 c0ed4494 cb17fc00 c1e03da0 0000004c =
c1e03d54 c1e03d08
[    6.860994] 3d00: c1e03e4c c1e03e28 c03a9eb0 c02367a4 c02cdd00 c051546c =
d87efdc0 cb17fc44
[    6.869316] 3d20: c1e03d20 c1e03d20 d87efdf0 cb17fc00 c1e03d54 c1e03d40 =
c112b730 c051546c
[    6.877640] 3d40: c1e03d40 c1e03d40 c02367a4 c0201240 c02c8548 c1e00000 =
c1cbec50 c02367a4
[    6.885965] 3d60: c0201240 c1e00004 16b2f000 c1e00000 c1e03db4 c1e03d80 =
c03a9ed0 c05154fc
[    6.894287] 3d80: 41b58ab3 b5ed3f2f c1e03db4 c1e0508c c18b9360 00000004 =
00000003 16b2f000
[    6.902610] 3da0: 00000008 c1e00000 c1e03e24 c1e03db8 c02012e8 c0ed44a0 =
c1e03de4 c1e03dc8
[    6.910932] 3dc0: 00000001 00200002 c1213840 c1e05d00 ffff8d37 c18b92d4 =
0000000a c1cc0940
[    6.919256] 3de0: c09eed7c c18b9350 c1e05080 c1e03db8 00000101 c1e06e1c =
c1e03e24 c1e06ea4
[    6.927580] 3e00: c1cc0940 ffffc000 c1e03e28 16b2f000 c1e03ec0 16b2f000 =
c1e03e4c c1e03e28
[    6.935901] 3e20: c02367a4 c0201104 c1cbfe80 00000000 c1e00000 00000000 =
00000001 c1e03ec0
[    6.944224] 3e40: c1e03e84 c1e03e50 c02c75fc c0236628 c112af34 ca91f000 =
c1e03ebc 000000bd
[    6.952547] 3e60: 000000bd c1cbfe8c c1e07878 c1e03ec0 f0802000 f080200c =
c1e03ebc c1e03e88
[    6.960872] 3e80: c09ef2b4 c02c7544 c03aa120 c021043c c020a204 c020a208 =
60000013 ffffffff
[    6.969195] 3ea0: c1e03ef4 c84ff712 c1e00000 30c5387d c1e03f1c c1e03ec0 =
c0200abc c09ef224
[    6.977516] 3ec0: c175a018 d87f0614 00000000 c0222bc0 c1e00000 c1e06e1c =
00000000 c1e06e6c
[    6.985840] 3ee0: c84ff712 c121e120 30c5387d c1e03f1c c175a018 c1e03f10 =
c020a204 c020a208
[    6.994163] 3f00: 60000013 ffffffff c020a1f4 00000000 c1e03f44 c1e03f20 =
c112af34 c020a1c4
[    7.002486] 3f20: c1e00000 c1e06e1c 00000000 c1e06e6c c84ff712 c121e120 =
c1e03f6c c1e03f48
[    7.010810] 3f40: c0287578 c112aef8 000000e1 c85201e0 ca9d6000 c1e00000 =
c187df68 410fd083
[    7.019134] 3f60: c1e03f7c c1e03f70 c0287a00 c0287468 c1e03f9c c1e03f80 =
c111d7b8 c02879e4
[    7.027458] 3f80: c851d5c0 c1e00000 c1e00000 c1e06dc0 c1e03fac c1e03fa0 =
c1801534 c111d67c
[    7.035781] 3fa0: c1e03ff4 c1e03fb0 c1801990 c1801528 ffffffff ffffffff =
00000000 c18006b8
[    7.044103] 3fc0: 00000000 c187df68 b5e8322f 00000000 410fd083 c1800334 =
00000000 30c0387d
[    7.052425] 3fe0: 00000c42 2eff9400 00000000 c1e03ff8 00000000 c18015bc =
00000000 00000000
[    7.060734] Backtrace:=20
[    7.063237] [<c0ea34dc>] (skb_release_data) from [<c0ea9d2c>] (consume_s=
kb+0x60/0x134)
[    7.071327]  r10:0000a8d8 r9:cc560000 r8:00000000 r7:cc560580 r6:0000000=
1 r5:cc57e4ac
[    7.079286]  r4:cc57e400 r3:cc97f680
[    7.082923] [<c0ea9ccc>] (consume_skb) from [<c0ec0d74>] (__dev_kfree_sk=
b_any+0x60/0x64)
[    7.091187]  r9:cc560000 r8:00000000 r7:cc560580 r6:00000001 r5:cc57e400=
 r4:c1e00000
[    7.099054] [<c0ec0d14>] (__dev_kfree_skb_any) from [<c0c814d4>] (bcmgen=
et_rx_poll+0x578/0x770)
[    7.107934]  r7:cc560580 r6:a8d81759 r5:cc57e400 r4:cc563ed8
[    7.113686] [<c0c80f5c>] (bcmgenet_rx_poll) from [<c0ed3f0c>] (__napi_po=
ll+0x60/0x2b8)
[    7.121778]  r10:c1e03d20 r9:c1e05d00 r8:cc563ee0 r7:c1e03d10 r6:0000004=
0 r5:00000001
[    7.129735]  r4:cc563ed8
[    7.132313] [<c0ed3eac>] (__napi_poll) from [<c0ed4a14>] (net_rx_action+=
0x580/0x620)
[    7.140233]  r10:c1e03d20 r9:c1e05d00 r8:0000012c r7:cc563edc r6:cc56000=
0 r5:cc563ed8
[    7.148189]  r4:c1e03d80
[    7.150767] [<c0ed4494>] (net_rx_action) from [<c02012e8>] (__do_softirq=
+0x1f0/0x69c)
[    7.158772]  r10:c1e00000 r9:00000008 r8:16b2f000 r7:00000003 r6:0000000=
4 r5:c18b9360
[    7.166728]  r4:c1e0508c
[    7.169306] [<c02010f8>] (__do_softirq) from [<c02367a4>] (irq_exit+0x18=
8/0x1b0)
[    7.176870]  r10:16b2f000 r9:c1e03ec0 r8:16b2f000 r7:c1e03e28 r6:ffffc00=
0 r5:c1cc0940
[    7.184827]  r4:c1e06ea4
[    7.187405] [<c023661c>] (irq_exit) from [<c02c75fc>] (__handle_domain_i=
rq+0xc4/0x128)
[    7.195497]  r9:c1e03ec0 r8:00000001 r7:00000000 r6:c1e00000 r5:00000000=
 r4:c1cbfe80
[    7.203363] [<c02c7538>] (__handle_domain_irq) from [<c09ef2b4>] (gic_ha=
ndle_irq+0x9c/0xb4)
[    7.211902]  r10:f080200c r9:f0802000 r8:c1e03ec0 r7:c1e07878 r6:c1cbfe8=
c r5:000000bd
[    7.219858]  r4:000000bd
[    7.222436] [<c09ef218>] (gic_handle_irq) from [<c0200abc>] (__irq_svc+0=
x5c/0x80)
[    7.230074] Exception stack(0xc1e03ec0 to 0xc1e03f08)
[    7.235228] 3ec0: c175a018 d87f0614 00000000 c0222bc0 c1e00000 c1e06e1c =
00000000 c1e06e6c
[    7.243552] 3ee0: c84ff712 c121e120 30c5387d c1e03f1c c175a018 c1e03f10 =
c020a204 c020a208
[    7.251865] 3f00: 60000013 ffffffff
[    7.255432]  r10:30c5387d r9:c1e00000 r8:c84ff712 r7:c1e03ef4 r6:fffffff=
f r5:60000013
[    7.263389]  r4:c020a208
[    7.265967] [<c020a1b8>] (arch_cpu_idle) from [<c112af34>] (default_idle=
_call+0x48/0x188)
[    7.274309] [<c112aeec>] (default_idle_call) from [<c0287578>] (do_idle+=
0x11c/0x180)
[    7.282219]  r9:c121e120 r8:c84ff712 r7:c1e06e6c r6:00000000 r5:c1e06e1c=
 r4:c1e00000
[    7.290085] [<c028745c>] (do_idle) from [<c0287a00>] (cpu_startup_entry+=
0x28/0x2c)
[    7.297821]  r9:410fd083 r8:c187df68 r7:c1e00000 r6:ca9d6000 r5:c85201e0=
 r4:000000e1
[    7.305687] [<c02879d8>] (cpu_startup_entry) from [<c111d7b8>] (rest_ini=
t+0x148/0x150)
[    7.313764] [<c111d670>] (rest_init) from [<c1801534>] (arch_call_rest_i=
nit+0x18/0x1c)
[    7.321855]  r7:c1e06dc0 r6:c1e00000 r5:c1e00000 r4:c851d5c0
[    7.327606] [<c180151c>] (arch_call_rest_init) from [<c1801990>] (start_=
kernel+0x3e0/0x424)
[    7.336126] [<c18015b0>] (start_kernel) from [<00000000>] (0x0)
[    7.342179]  r8:2eff9400 r7:00000c42 r6:30c0387d r5:00000000 r4:c1800334
[    7.349000] Code: ebd9c790 e5954000 e2840008 ebd9c78d (e5943008)=20
[    7.355247] ---[ end trace 38b3df6838c109c3 ]---

Let me know if you need any other information, thanks!
Maxime

--3plytasmu4pwlokc
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRcEzekXsqa64kGDp7j7w1vZxhRxQUCYKujuwAKCRDj7w1vZxhR
xbR2AP9T0fl1jE89RgnrFROQQdQDFxGP5IatNbGeGLDZggKyawD/X52DrpRFPFha
tGWwbWHnVVy/foGmONjXtDb3XOe7UgQ=
=TA7M
-----END PGP SIGNATURE-----

--3plytasmu4pwlokc--
