Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3788F4111BC
	for <lists+netdev@lfdr.de>; Mon, 20 Sep 2021 11:13:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236123AbhITJPK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Sep 2021 05:15:10 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:46430 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236443AbhITJNz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Sep 2021 05:13:55 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 4927A2206F;
        Mon, 20 Sep 2021 09:12:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1632129148; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7wgwfuo7994eWNLDV8vJTaFNjCpPsVrh9SoxNbeeg3w=;
        b=LA2ERwjeQx0Tw55dx+G050f84pSI2t6pZ7IUl5jjrnPZFyx39eUkajU/2o8sACd0SUXbJP
        bjmSxPwqNNfkM8H/j8Rp7L5IDMhZlH8uEkBOzePiNKsX0edgRChpUPoZRnBqli5zc55fKm
        7ov4SfpgBsGFMzi7cE8UUC3eObIlbgY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1632129148;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7wgwfuo7994eWNLDV8vJTaFNjCpPsVrh9SoxNbeeg3w=;
        b=IJauI4/CKjXVVPfo7bH+QQhgzndB5JA9idm+tCkCCDe57rRxQ0+i4UHef5jeGXlQZEBGzb
        n+wYHDnDH7XLOhAA==
Received: from lion.mk-sys.cz (unknown [10.100.200.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 3988DA3BBE;
        Mon, 20 Sep 2021 09:12:28 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 2010E60410; Mon, 20 Sep 2021 11:12:25 +0200 (CEST)
Date:   Mon, 20 Sep 2021 11:12:25 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     Kelly Anderson <kelly@xilka.com>, linux-kernel@vger.kernel.org,
        Netdev <netdev@vger.kernel.org>, stable@vger.kernel.org
Subject: Re: ethtool_get_rxnfc: Buffer overflow detected (8 < 192)!
Message-ID: <20210920091225.7k7ixamcwp6auy3i@lion.mk-sys.cz>
References: <5756374.lOV4Wx5bFT@comer.internal>
 <c428cdd7-cba2-b292-4fe0-5b71c87558de@infradead.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="6xhjkixp765la55v"
Content-Disposition: inline
In-Reply-To: <c428cdd7-cba2-b292-4fe0-5b71c87558de@infradead.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--6xhjkixp765la55v
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Sep 18, 2021 at 05:52:00PM -0700, Randy Dunlap wrote:
> [adding netdev]
>=20
> On 9/18/21 5:16 PM, Kelly Anderson wrote:
> > New patches in 5.14.6 cause a problem in ethtool_get_rxnfc.
> >=20
> > It seems someone has allocated a variable length struct @958:ioctl.c: s=
truct ethtool_rxnfc info.
> > Unfortunately depending on the calls being made the struct cannot hold =
the variable length part of the data.
> > Luckily the error checking caught this, otherwise it would be messing u=
p the stack.
> >=20
> >=20
> > Sep 18 15:11:27 bbb.internal kernel: Buffer overflow detected (8 < 192)!
> > Sep 18 15:11:27 bbb.internal kernel: WARNING: CPU: 4 PID: 1434 at inclu=
de/linux/thread_info.h:200 ethtool_rxnfc_copy_to_user+0x26/0xa0
> > Sep 18 15:11:27 bbb.internal kernel: Modules linked in: xt_CHECKSUM xt_=
MASQUERADE ipt_REJECT nf_reject_ipv4 ip6table_mangle ip6table_nat iptable_m=
angle iptable_nat nf_nat ip6table_filter ip6_tables xt_tcpudp xt_set xt_LOG=
 nf_log_syslog xt_conntrack nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 ipta=
ble_filter bpfilter ip_set_hash_ipport ip_set_list_set ip_set_hash_net ip_s=
et_hash_ip ip_set nfnetlink amdgpu iommu_v2 gpu_sched snd_hda_codec_realtek=
 snd_hda_codec_generic ledtrig_audio snd_hda_codec_hdmi wmi_bmof mxm_wmi sp=
5100_tco crct10dif_pclmul ghash_clmulni_intel pcspkr fam15h_power k10temp r=
adeon ixgbe i2c_piix4 ptp i2c_algo_bit drm_ttm_helper snd_hda_intel pps_cor=
e ttm snd_intel_dspcfg mdio snd_intel_sdw_acpi dca drm_kms_helper snd_hda_c=
odec xhci_pci xhci_pci_renesas snd_hda_core cec snd_pcm fb_sys_fops snd_tim=
er syscopyarea sysfillrect snd sysimgblt soundcore wmi evdev sch_fq_codel x=
t_limit vhost_net vhost vhost_iotlb tap tun sha512_ssse3 sha1_ssse3 sg rpcs=
ec_gss_krb5 r8169 realtek mdio_devres libphy macvlan
> > Sep 18 15:11:27 bbb.internal kernel:  kvm_amd ccp rng_core kvm irqbypas=
s it87 hwmon_vid hwmon msr ftdi_sio cpuid camellia_aesni_avx_x86_64 camelli=
a_x86_64 br_netfilter bridge stp llc aesni_intel crypto_simd cryptd drm nfs=
d configfs ip_tables x_tables
> > Sep 18 15:11:27 bbb.internal kernel: CPU: 4 PID: 1434 Comm: nmbd Tainte=
d: G                T 5.14.6 #1
> > Sep 18 15:11:27 bbb.internal kernel: Hardware name: To be filled by O.E=
=2EM. To be filled by O.E.M./SABERTOOTH 990FX R2.0, BIOS 2901 05/04/2016
> > Sep 18 15:11:27 bbb.internal kernel: RIP: 0010:ethtool_rxnfc_copy_to_us=
er+0x26/0xa0
> > Sep 18 15:11:27 bbb.internal kernel: Code: ff 0f 1f 00 41 55 65 48 8b 0=
4 25 00 6d 01 00 41 54 55 53 f6 40 10 02 75 23 be 08 00 00 00 48 c7 c7 68 1=
6 30 aa e8 01 85 13 00 <0f> 0b 41 bc f2 ff ff ff 5b 44 89 e0 5d 41 5c 41 5d=
 c3 48 89 fb 49
> > Sep 18 15:11:27 bbb.internal kernel: RSP: 0018:ffffb9ca819bbb10 EFLAGS:=
 00010282
> > Sep 18 15:11:27 bbb.internal kernel: RAX: 0000000000000000 RBX: fffffff=
fc071a440 RCX: 0000000000000027
> > Sep 18 15:11:27 bbb.internal kernel: RDX: ffff9d78ded17508 RSI: 0000000=
000000001 RDI: ffff9d78ded17500
> > Sep 18 15:11:27 bbb.internal kernel: RBP: ffffb9ca819bbb40 R08: 0000000=
000000000 R09: ffffb9ca819bb948
> > Sep 18 15:11:27 bbb.internal kernel: R10: ffffb9ca819bb940 R11: fffffff=
faa6beda8 R12: 0000000000000000
> > Sep 18 15:11:27 bbb.internal kernel: R13: 00007ffe1b458980 R14: 0000000=
000000000 R15: ffff9d71c7e08000
> > Sep 18 15:11:27 bbb.internal kernel: FS:  00007fcd84c55a40(0000) GS:fff=
f9d78ded00000(0000) knlGS:0000000000000000
> > Sep 18 15:11:27 bbb.internal kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0=
000000080050033
> > Sep 18 15:11:27 bbb.internal kernel: CR2: 00005576720f14d8 CR3: 0000000=
243892000 CR4: 00000000000406e0
> > Sep 18 15:11:27 bbb.internal kernel: Call Trace:
> > Sep 18 15:11:27 bbb.internal kernel:  ethtool_get_rxnfc+0xce/0x1b0
> > Sep 18 15:11:27 bbb.internal kernel:  dev_ethtool+0xc26/0x2d90
> > Sep 18 15:11:27 bbb.internal kernel:  ? inet_ioctl+0xe5/0x210
> > Sep 18 15:11:27 bbb.internal kernel:  dev_ioctl+0x188/0x490
> > Sep 18 15:11:27 bbb.internal kernel:  sock_do_ioctl+0xe9/0x180
> > Sep 18 15:11:27 bbb.internal kernel:  sock_ioctl+0x273/0x370
> > Sep 18 15:11:27 bbb.internal kernel:  __x64_sys_ioctl+0x7c/0xb0
> > Sep 18 15:11:27 bbb.internal kernel:  do_syscall_64+0x64/0x90
> > Sep 18 15:11:27 bbb.internal kernel:  ? sock_alloc_file+0x56/0xa0
> > Sep 18 15:11:27 bbb.internal kernel:  ? get_vtime_delta+0xa/0xb0
> > Sep 18 15:11:27 bbb.internal kernel:  ? vtime_user_enter+0x17/0x70
> > Sep 18 15:11:27 bbb.internal kernel:  ? __context_tracking_enter+0x5c/0=
x60
> > Sep 18 15:11:27 bbb.internal kernel:  ? syscall_exit_to_user_mode+0x39/=
0x40
> > Sep 18 15:11:27 bbb.internal kernel:  ? do_syscall_64+0x71/0x90
> > Sep 18 15:11:27 bbb.internal kernel:  ? syscall_exit_to_user_mode+0x39/=
0x40
> > Sep 18 15:11:27 bbb.internal kernel:  ? do_syscall_64+0x71/0x90
> > Sep 18 15:11:27 bbb.internal kernel:  ? vtime_user_enter+0x17/0x70
> > Sep 18 15:11:27 bbb.internal kernel:  ? __context_tracking_enter+0x5c/0=
x60
> > Sep 18 15:11:27 bbb.internal kernel:  entry_SYSCALL_64_after_hwframe+0x=
44/0xae
> > Sep 18 15:11:27 bbb.internal kernel: RIP: 0033:0x7fcd84b1a767
> > Sep 18 15:11:27 bbb.internal kernel: Code: 3c 1c e8 2c ff ff ff 85 c0 7=
9 97 49 c7 c4 ff ff ff ff 5b 5d 4c 89 e0 41 5c c3 66 0f 1f 84 00 00 00 00 0=
0 b8 10 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 99 16 0f 00 f7=
 d8 64 89 01 48
> > Sep 18 15:11:27 bbb.internal kernel: RSP: 002b:00007ffe1b458938 EFLAGS:=
 00000246 ORIG_RAX: 0000000000000010
> > Sep 18 15:11:27 bbb.internal kernel: RAX: ffffffffffffffda RBX: 0000557=
6720f0160 RCX: 00007fcd84b1a767
> > Sep 18 15:11:27 bbb.internal kernel: RDX: 00007ffe1b458950 RSI: 0000000=
000008946 RDI: 000000000000000f
> > Sep 18 15:11:27 bbb.internal kernel: RBP: 00007ffe1b458a50 R08: 0000000=
000000000 R09: 00007fcd84b6e070
> > Sep 18 15:11:27 bbb.internal kernel: R10: 0000000000000040 R11: 0000000=
000000246 R12: 00007ffe1b458ee8
> > Sep 18 15:11:27 bbb.internal kernel: R13: 00005576702c9649 R14: 00007fc=
d85187c40 R15: 000055767030a350
> > Sep 18 15:11:27 bbb.internal kernel: ---[ end trace d48f50afc5752bb2 ]-=
--

Looking at the code, I think this is the problem:

static int ethtool_rxnfc_copy_to_user(void __user *useraddr,
				      const struct ethtool_rxnfc *rxnfc,
				      size_t size, const u32 *rule_buf)
{
=2E..
		ret =3D copy_to_user(useraddr, &rxnfc, size);
=2E..
}

This was introduced in mainline commit dd98d2895de6 ("ethtool: improve
compat ioctl handling"), backported into 5.14.6 stable. Unlike info
variable in the original code, rxnfc is a pointer, not the structure, so
that second parameter to copy_to_user() should be "rxnfc", not "&rxnfc".

This was already fixed in 5.15-rc1 by commit 9b29a161ef38 ("ethtool: Fix
rxnfc copy to user buffer overflow") which provides correct Fixes tag
(and both in fact reached mainline in the same merge) so that it's
rather surprising that the original commit got into stable-5.14.y
without the follow-up fix.

Michal

--6xhjkixp765la55v
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEWN3j3bieVmp26mKO538sG/LRdpUFAmFIUHMACgkQ538sG/LR
dpWBhAf/QRzZ5pHHE3B685s9VR1PKT5dvL4n5nmWvLchiNhJvrIMLvOqAIe5zOfB
/oSrQEsO5z9pymITOFBz5GTzzj92ALuu5OZ2Ijoi3lL2e3hjCdzuYiBLTRmgeK1o
8NC41eQmKbXdeNVsA84U7SqzrTd7sqK2rEHP7FKcqWVId0Ga+UUMwiVmraYzvgVb
uLAVzgvWvg3gbpYuBJo5LBL6ax9ScFnOyM28mxAP40RgBkVXT1fEqiCJalWnB0zz
HeYYxCFK92m65VMJYgQ5qY0u92AlgDzFsuOkTJWWtJSdrob8dKAoH9hlGhLmk2sX
VRzdCK7rnJvyEQP4Eo7pWmBR5qa/aA==
=OSdT
-----END PGP SIGNATURE-----

--6xhjkixp765la55v--
