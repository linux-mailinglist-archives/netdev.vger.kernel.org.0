Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AE30412E0C
	for <lists+netdev@lfdr.de>; Tue, 21 Sep 2021 06:48:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229682AbhIUEtr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Sep 2021 00:49:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229577AbhIUEtq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Sep 2021 00:49:46 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EB67C061574;
        Mon, 20 Sep 2021 21:48:18 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id u18so813918lfd.12;
        Mon, 20 Sep 2021 21:48:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=Ip3CmDcrvCR7mSuZiOXJnqTk1laRcjuypF6vnbdF2j4=;
        b=UCKdrKujsSwhVA3Z3sg6PaHDpZyOUuLjQHIguNngIBdHGL8OEP99M3dsHysY9WUqrI
         wPNZXoRmgtklWtvfLRK8wIC72BRMMWaBE5wBwyVagj19c4UD5HZSD4IaoOAmPQUGXiLP
         v7o6idqINewG0OqHWtwthKL+lbpAwjMhVa/SkS1q3QbX78BoVKoD7EU5PCuUU89cjs0M
         WOhKAE4abF6arEy3bBSBpK7wkMeuzk7TV8LkIeD4GAg8E2ltaPIki03NpJff8TQvNdUl
         UR7Dc+VpyRrxUe0odn47iIRnfduSahhbIZdVhzbg9zTBiNlH6W5Wr7CCnJFI0C1wyGA8
         Sl7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition
         :content-transfer-encoding:in-reply-to;
        bh=Ip3CmDcrvCR7mSuZiOXJnqTk1laRcjuypF6vnbdF2j4=;
        b=3Wefv5iuiWJGidE+kBIQWoVweJcNVDcBYkiwgZPQVT1k81lCNg17yMxs2jHPniw8f5
         wSRLMgciOMEEK3s1uZh0o75vQ6NtlJjIEzXiCfSwbRnZK23L4vVPX625JTiY96Tv2vci
         BGVkWlcKtoklvcX7Fgjv9qOT7uKuD7eSDecHMIPZzNj0lh4oQ4uYx8Z2pB7mgGoQcNzq
         vY7N+9+njGXfxLhZPljt1OnuXHmaCTHKS4aCsqn+aq5N8odY1zohdBnIMW4/QMm7gBW3
         g+GXvSmvCIFcM/ju4W2wUWJeEoNRYtGeMCwES8SkxIUNXJYVRVcrBWGXzANVa6e7aowZ
         OXYg==
X-Gm-Message-State: AOAM533Ez1BMNSjgy7Oh++eqDLyGGiSADmzk5fnLFrDiFQdqaKtVk5aX
        L30C9nkzKjzDjL3PfuKf92pz4hNN41F/cg==
X-Google-Smtp-Source: ABdhPJzYHOVhOEYqwg39iNYpinku35g6R9GQUvxxRkr6Yso/EhbboDCz6I/vX/Ds7ULqbwX/VvEg0A==
X-Received: by 2002:a2e:a555:: with SMTP id e21mr27180152ljn.490.1632199696469;
        Mon, 20 Sep 2021 21:48:16 -0700 (PDT)
Received: from elende (elende.valinor.li. [2a01:4f9:6a:1c47::2])
        by smtp.gmail.com with ESMTPSA id a25sm41834lfk.63.2021.09.20.21.48.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Sep 2021 21:48:15 -0700 (PDT)
Sender: Salvatore Bonaccorso <salvatore.bonaccorso@gmail.com>
Date:   Tue, 21 Sep 2021 06:48:14 +0200
From:   Salvatore Bonaccorso <carnil@debian.org>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        Kelly Anderson <kelly@xilka.com>, linux-kernel@vger.kernel.org,
        Netdev <netdev@vger.kernel.org>, stable@vger.kernel.org
Subject: Re: ethtool_get_rxnfc: Buffer overflow detected (8 < 192)!
Message-ID: <YUlkDoDSu+fd/wAo@lorien.valinor.li>
References: <5756374.lOV4Wx5bFT@comer.internal>
 <c428cdd7-cba2-b292-4fe0-5b71c87558de@infradead.org>
 <20210920091225.7k7ixamcwp6auy3i@lion.mk-sys.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20210920091225.7k7ixamcwp6auy3i@lion.mk-sys.cz>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Michal,

On Mon, Sep 20, 2021 at 11:12:25AM +0200, Michal Kubecek wrote:
> On Sat, Sep 18, 2021 at 05:52:00PM -0700, Randy Dunlap wrote:
> > [adding netdev]
> >=20
> > On 9/18/21 5:16 PM, Kelly Anderson wrote:
> > > New patches in 5.14.6 cause a problem in ethtool_get_rxnfc.
> > >=20
> > > It seems someone has allocated a variable length struct @958:ioctl.c:=
 struct ethtool_rxnfc info.
> > > Unfortunately depending on the calls being made the struct cannot hol=
d the variable length part of the data.
> > > Luckily the error checking caught this, otherwise it would be messing=
 up the stack.
> > >=20
> > >=20
> > > Sep 18 15:11:27 bbb.internal kernel: Buffer overflow detected (8 < 19=
2)!
> > > Sep 18 15:11:27 bbb.internal kernel: WARNING: CPU: 4 PID: 1434 at inc=
lude/linux/thread_info.h:200 ethtool_rxnfc_copy_to_user+0x26/0xa0
> > > Sep 18 15:11:27 bbb.internal kernel: Modules linked in: xt_CHECKSUM x=
t_MASQUERADE ipt_REJECT nf_reject_ipv4 ip6table_mangle ip6table_nat iptable=
_mangle iptable_nat nf_nat ip6table_filter ip6_tables xt_tcpudp xt_set xt_L=
OG nf_log_syslog xt_conntrack nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 ip=
table_filter bpfilter ip_set_hash_ipport ip_set_list_set ip_set_hash_net ip=
_set_hash_ip ip_set nfnetlink amdgpu iommu_v2 gpu_sched snd_hda_codec_realt=
ek snd_hda_codec_generic ledtrig_audio snd_hda_codec_hdmi wmi_bmof mxm_wmi =
sp5100_tco crct10dif_pclmul ghash_clmulni_intel pcspkr fam15h_power k10temp=
 radeon ixgbe i2c_piix4 ptp i2c_algo_bit drm_ttm_helper snd_hda_intel pps_c=
ore ttm snd_intel_dspcfg mdio snd_intel_sdw_acpi dca drm_kms_helper snd_hda=
_codec xhci_pci xhci_pci_renesas snd_hda_core cec snd_pcm fb_sys_fops snd_t=
imer syscopyarea sysfillrect snd sysimgblt soundcore wmi evdev sch_fq_codel=
 xt_limit vhost_net vhost vhost_iotlb tap tun sha512_ssse3 sha1_ssse3 sg rp=
csec_gss_krb5 r8169 realtek mdio_devres libphy macvlan
> > > Sep 18 15:11:27 bbb.internal kernel:  kvm_amd ccp rng_core kvm irqbyp=
ass it87 hwmon_vid hwmon msr ftdi_sio cpuid camellia_aesni_avx_x86_64 camel=
lia_x86_64 br_netfilter bridge stp llc aesni_intel crypto_simd cryptd drm n=
fsd configfs ip_tables x_tables
> > > Sep 18 15:11:27 bbb.internal kernel: CPU: 4 PID: 1434 Comm: nmbd Tain=
ted: G                T 5.14.6 #1
> > > Sep 18 15:11:27 bbb.internal kernel: Hardware name: To be filled by O=
=2EE.M. To be filled by O.E.M./SABERTOOTH 990FX R2.0, BIOS 2901 05/04/2016
> > > Sep 18 15:11:27 bbb.internal kernel: RIP: 0010:ethtool_rxnfc_copy_to_=
user+0x26/0xa0
> > > Sep 18 15:11:27 bbb.internal kernel: Code: ff 0f 1f 00 41 55 65 48 8b=
 04 25 00 6d 01 00 41 54 55 53 f6 40 10 02 75 23 be 08 00 00 00 48 c7 c7 68=
 16 30 aa e8 01 85 13 00 <0f> 0b 41 bc f2 ff ff ff 5b 44 89 e0 5d 41 5c 41 =
5d c3 48 89 fb 49
> > > Sep 18 15:11:27 bbb.internal kernel: RSP: 0018:ffffb9ca819bbb10 EFLAG=
S: 00010282
> > > Sep 18 15:11:27 bbb.internal kernel: RAX: 0000000000000000 RBX: fffff=
fffc071a440 RCX: 0000000000000027
> > > Sep 18 15:11:27 bbb.internal kernel: RDX: ffff9d78ded17508 RSI: 00000=
00000000001 RDI: ffff9d78ded17500
> > > Sep 18 15:11:27 bbb.internal kernel: RBP: ffffb9ca819bbb40 R08: 00000=
00000000000 R09: ffffb9ca819bb948
> > > Sep 18 15:11:27 bbb.internal kernel: R10: ffffb9ca819bb940 R11: fffff=
fffaa6beda8 R12: 0000000000000000
> > > Sep 18 15:11:27 bbb.internal kernel: R13: 00007ffe1b458980 R14: 00000=
00000000000 R15: ffff9d71c7e08000
> > > Sep 18 15:11:27 bbb.internal kernel: FS:  00007fcd84c55a40(0000) GS:f=
fff9d78ded00000(0000) knlGS:0000000000000000
> > > Sep 18 15:11:27 bbb.internal kernel: CS:  0010 DS: 0000 ES: 0000 CR0:=
 0000000080050033
> > > Sep 18 15:11:27 bbb.internal kernel: CR2: 00005576720f14d8 CR3: 00000=
00243892000 CR4: 00000000000406e0
> > > Sep 18 15:11:27 bbb.internal kernel: Call Trace:
> > > Sep 18 15:11:27 bbb.internal kernel:  ethtool_get_rxnfc+0xce/0x1b0
> > > Sep 18 15:11:27 bbb.internal kernel:  dev_ethtool+0xc26/0x2d90
> > > Sep 18 15:11:27 bbb.internal kernel:  ? inet_ioctl+0xe5/0x210
> > > Sep 18 15:11:27 bbb.internal kernel:  dev_ioctl+0x188/0x490
> > > Sep 18 15:11:27 bbb.internal kernel:  sock_do_ioctl+0xe9/0x180
> > > Sep 18 15:11:27 bbb.internal kernel:  sock_ioctl+0x273/0x370
> > > Sep 18 15:11:27 bbb.internal kernel:  __x64_sys_ioctl+0x7c/0xb0
> > > Sep 18 15:11:27 bbb.internal kernel:  do_syscall_64+0x64/0x90
> > > Sep 18 15:11:27 bbb.internal kernel:  ? sock_alloc_file+0x56/0xa0
> > > Sep 18 15:11:27 bbb.internal kernel:  ? get_vtime_delta+0xa/0xb0
> > > Sep 18 15:11:27 bbb.internal kernel:  ? vtime_user_enter+0x17/0x70
> > > Sep 18 15:11:27 bbb.internal kernel:  ? __context_tracking_enter+0x5c=
/0x60
> > > Sep 18 15:11:27 bbb.internal kernel:  ? syscall_exit_to_user_mode+0x3=
9/0x40
> > > Sep 18 15:11:27 bbb.internal kernel:  ? do_syscall_64+0x71/0x90
> > > Sep 18 15:11:27 bbb.internal kernel:  ? syscall_exit_to_user_mode+0x3=
9/0x40
> > > Sep 18 15:11:27 bbb.internal kernel:  ? do_syscall_64+0x71/0x90
> > > Sep 18 15:11:27 bbb.internal kernel:  ? vtime_user_enter+0x17/0x70
> > > Sep 18 15:11:27 bbb.internal kernel:  ? __context_tracking_enter+0x5c=
/0x60
> > > Sep 18 15:11:27 bbb.internal kernel:  entry_SYSCALL_64_after_hwframe+=
0x44/0xae
> > > Sep 18 15:11:27 bbb.internal kernel: RIP: 0033:0x7fcd84b1a767
> > > Sep 18 15:11:27 bbb.internal kernel: Code: 3c 1c e8 2c ff ff ff 85 c0=
 79 97 49 c7 c4 ff ff ff ff 5b 5d 4c 89 e0 41 5c c3 66 0f 1f 84 00 00 00 00=
 00 b8 10 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 99 16 0f 00 =
f7 d8 64 89 01 48
> > > Sep 18 15:11:27 bbb.internal kernel: RSP: 002b:00007ffe1b458938 EFLAG=
S: 00000246 ORIG_RAX: 0000000000000010
> > > Sep 18 15:11:27 bbb.internal kernel: RAX: ffffffffffffffda RBX: 00005=
576720f0160 RCX: 00007fcd84b1a767
> > > Sep 18 15:11:27 bbb.internal kernel: RDX: 00007ffe1b458950 RSI: 00000=
00000008946 RDI: 000000000000000f
> > > Sep 18 15:11:27 bbb.internal kernel: RBP: 00007ffe1b458a50 R08: 00000=
00000000000 R09: 00007fcd84b6e070
> > > Sep 18 15:11:27 bbb.internal kernel: R10: 0000000000000040 R11: 00000=
00000000246 R12: 00007ffe1b458ee8
> > > Sep 18 15:11:27 bbb.internal kernel: R13: 00005576702c9649 R14: 00007=
fcd85187c40 R15: 000055767030a350
> > > Sep 18 15:11:27 bbb.internal kernel: ---[ end trace d48f50afc5752bb2 =
]---
>=20
> Looking at the code, I think this is the problem:
>=20
> static int ethtool_rxnfc_copy_to_user(void __user *useraddr,
> 				      const struct ethtool_rxnfc *rxnfc,
> 				      size_t size, const u32 *rule_buf)
> {
> ...
> 		ret =3D copy_to_user(useraddr, &rxnfc, size);
> ...
> }
>=20
> This was introduced in mainline commit dd98d2895de6 ("ethtool: improve
> compat ioctl handling"), backported into 5.14.6 stable. Unlike info
> variable in the original code, rxnfc is a pointer, not the structure, so
> that second parameter to copy_to_user() should be "rxnfc", not "&rxnfc".
>=20
> This was already fixed in 5.15-rc1 by commit 9b29a161ef38 ("ethtool: Fix
> rxnfc copy to user buffer overflow") which provides correct Fixes tag
> (and both in fact reached mainline in the same merge) so that it's
> rather surprising that the original commit got into stable-5.14.y
> without the follow-up fix.

FTR, it looks this followup commit has been queued as well now for the
next rounds of stable updates where this is relevant.

Regards,
Salvatore
