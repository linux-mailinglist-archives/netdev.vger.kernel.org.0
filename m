Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC95C2FB8F1
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 15:34:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395068AbhASOFi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 09:05:38 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:59176 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2393342AbhASMlS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jan 2021 07:41:18 -0500
Received: from mail-wr1-f71.google.com ([209.85.221.71])
        by youngberry.canonical.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <juerg.haefliger@canonical.com>)
        id 1l1qJ8-0007d6-7Q
        for netdev@vger.kernel.org; Tue, 19 Jan 2021 12:40:26 +0000
Received: by mail-wr1-f71.google.com with SMTP id u29so9856610wru.6
        for <netdev@vger.kernel.org>; Tue, 19 Jan 2021 04:40:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version;
        bh=eJCqiBdnR/ZR6safINEz4pf5BUOKZUmEESGRAPzin5s=;
        b=LQIqNosAVAGvkK4ZxuDlPuG5AoaLirdZ4yNR0T0uvyLtB5MnnTZ/K/wfnLoHenjgvB
         i/vtlXCXgxghSpnG/S6p9oC3R1v/sgKveds+E+w3xUOuN0UTzdZhkEzUKHwaBNJork3u
         j8NDXVb5YVA697GmO/rSplapU+Z1hPk6QsRMw7b1aS7frFUkCvD9QHIMeyvRaDflmPXZ
         On9eEIws3lof1BI+wgafVuVQt3G20LhhUb9DxaUmeY40v0rURQJa7IvulSJxJK2CiBX6
         IfXtANkW4oL8FA4Xf35XHKHu/Z1A7PSjjKuzZNk4jJdqgh8NbBg9zEBDJvhmXxkfcWjg
         R8dg==
X-Gm-Message-State: AOAM531PpUeWvwS8PsHUmW2gIuA9Q/aPopXllQQn0xUKVdPRElH6sWnE
        05JGRbLXACzep3/3fsstssK/xI6vtXnozTvQeri3LWCOazWu4B2OrLe2NoTlT78O8vuuKZ9QVF9
        fjUANVMKXuEpAMrAENHMXMR3qdze38p/1bQ==
X-Received: by 2002:a1c:e902:: with SMTP id q2mr3842569wmc.143.1611060025690;
        Tue, 19 Jan 2021 04:40:25 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyL7U+giNk4Ih8RKQVJSy1P1qHrKw53I22M/fF1n7552vK/NisHEMPIarseoUTq07FXHM0Wbg==
X-Received: by 2002:a1c:e902:: with SMTP id q2mr3842537wmc.143.1611060025203;
        Tue, 19 Jan 2021 04:40:25 -0800 (PST)
Received: from gollum ([194.191.244.86])
        by smtp.gmail.com with ESMTPSA id l1sm36383011wrq.64.2021.01.19.04.40.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jan 2021 04:40:24 -0800 (PST)
From:   Juerg Haefliger <juerg.haefliger@canonical.com>
X-Google-Original-From: Juerg Haefliger <juergh@canonical.com>
Date:   Tue, 19 Jan 2021 13:40:23 +0100
To:     Eric Dumazet <edumazet@google.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        UNGLinuxDriver@microchip.com,
        Woojung Huh <woojung.huh@microchip.com>
Subject: Re: [Bug 209423] WARN_ON_ONCE() at rtl8169_tso_csum_v2()
Message-ID: <20210119134023.082577ca@gollum>
In-Reply-To: <CANn89i+dtetSScxtSRWX8BEgcW_uJ7vzvb+8sW57b7DJ3r=fXQ@mail.gmail.com>
References: <bug-209423-201211-atteo0d1ZY@https.bugzilla.kernel.org/>
        <80adc922-f667-a1ab-35a6-02bf1acfd5a1@gmail.com>
        <CANn89i+ZC5y_n_kQTm4WCWZsYaph4E2vtC9k_caE6dkuQrXdPQ@mail.gmail.com>
        <733a6e54-f03c-0076-1bdc-9b0d4ec1038c@gmail.com>
        <CANn89iJ2zqH=_fvJQ8dhG4nBVnKNB7SjHnHDLv+0iR7UwgxTsw@mail.gmail.com>
        <b6ff841a-320c-5592-1c2b-650e18dfe3e0@gmail.com>
        <CANn89iJ2KxQKZmT2ShVZRTjdgyYkF_2ZWBraTZE4TJVtUKh--Q@mail.gmail.com>
        <9e4b2b1f-c2d9-dbd0-c7ce-49007ddd7af2@gmail.com>
        <CANn89iJwwDCkdmFFAkXav+HNJQEEKZsp8PKvEuHc4gNJ=4iCoQ@mail.gmail.com>
        <77541223-8eaf-512c-1930-558e8d23eb33@gmail.com>
        <CANn89i+dtetSScxtSRWX8BEgcW_uJ7vzvb+8sW57b7DJ3r=fXQ@mail.gmail.com>
Organization: Canonical Ltd
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/1=yDia1zO_anxAX1v00oCz.";
 protocol="application/pgp-signature"; micalg=pgp-sha512
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/1=yDia1zO_anxAX1v00oCz.
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 8 Oct 2020 20:50:28 +0200
Eric Dumazet <edumazet@google.com> wrote:

> On Thu, Oct 8, 2020 at 8:42 PM Heiner Kallweit <hkallweit1@gmail.com> wro=
te:
> >
> > On 08.10.2020 19:15, Eric Dumazet wrote: =20
> > > On Thu, Oct 8, 2020 at 6:37 PM Heiner Kallweit <hkallweit1@gmail.com>=
 wrote: =20
> > >>
> > >> On 02.10.2020 13:48, Eric Dumazet wrote: =20
> > >>> On Fri, Oct 2, 2020 at 1:09 PM Heiner Kallweit <hkallweit1@gmail.co=
m> wrote: =20
> > >>>>
> > >>>> On 02.10.2020 10:46, Eric Dumazet wrote: =20
> > >>>>> On Fri, Oct 2, 2020 at 10:32 AM Eric Dumazet <eric.dumazet@gmail.=
com> wrote: =20
> > >>>>>>
> > >>>>>>
> > >>>>>>
> > >>>>>> On 10/2/20 10:26 AM, Eric Dumazet wrote: =20
> > >>>>>>> On Thu, Oct 1, 2020 at 10:34 PM Heiner Kallweit <hkallweit1@gma=
il.com> wrote: =20
> > >>>>>>>>
> > >>>>>>>> I have a problem with the following code in ndo_start_xmit() of
> > >>>>>>>> the r8169 driver. A user reported the WARN being triggered due
> > >>>>>>>> to gso_size > 0 and gso_type =3D 0. The chip supports TSO(6).
> > >>>>>>>> The driver is widely used, therefore I'd expect much more such
> > >>>>>>>> reports if it should be a common problem. Not sure what's spec=
ial.
> > >>>>>>>> My primary question: Is it a valid use case that gso_size is
> > >>>>>>>> greater than 0, and no SKB_GSO_ flag is set?
> > >>>>>>>> Any hint would be appreciated.
> > >>>>>>>>
> > >>>>>>>> =20
> > >>>>>>>
> > >>>>>>> Maybe this is not a TCP packet ? But in this case GSO should ha=
ve taken place.
> > >>>>>>>
> > >>>>>>> You might add a
> > >>>>>>> pr_err_once("gso_type=3D%x\n", shinfo->gso_type);
> > >>>>>>> =20
> > >>>>> =20
> > >>>>>>
> > >>>>>> Ah, sorry I see you already printed gso_type
> > >>>>>>
> > >>>>>> Must then be a bug somewhere :/ =20
> > >>>>>
> > >>>>>
> > >>>>> napi_reuse_skb() does :
> > >>>>>
> > >>>>> skb_shinfo(skb)->gso_type =3D 0;
> > >>>>>
> > >>>>> It does _not_ clear gso_size.
> > >>>>>
> > >>>>> I wonder if in some cases we could reuse an skb while gso_size is=
 not zero.
> > >>>>>
> > >>>>> Normally, we set it only from dev_gro_receive() when the skb is q=
ueued
> > >>>>> into GRO engine (status being GRO_HELD)
> > >>>>> =20
> > >>>> Thanks Eric. I'm no expert that deep in the network stack and just=
 wonder
> > >>>> why napi_reuse_skb() re-initializes less fields in shinfo than __a=
lloc_skb().
> > >>>> The latter one does a
> > >>>> memset(shinfo, 0, offsetof(struct skb_shared_info, dataref));
> > >>>> =20
> > >>>
> > >>> memset() over the whole thing is more expensive.
> > >>>
> > >>> Here we know the prior state of some fields, while __alloc_skb() ju=
st
> > >>> got a piece of memory with random content.
> > >>> =20
> > >>>> What I can do is letting the affected user test the following.
> > >>>>
> > >>>> diff --git a/net/core/dev.c b/net/core/dev.c
> > >>>> index 62b06523b..8e75399cc 100644
> > >>>> --- a/net/core/dev.c
> > >>>> +++ b/net/core/dev.c
> > >>>> @@ -6088,6 +6088,7 @@ static void napi_reuse_skb(struct napi_struc=
t *napi, struct sk_buff *skb)
> > >>>>
> > >>>>         skb->encapsulation =3D 0;
> > >>>>         skb_shinfo(skb)->gso_type =3D 0;
> > >>>> +       skb_shinfo(skb)->gso_size =3D 0;
> > >>>>         skb->truesize =3D SKB_TRUESIZE(skb_end_offset(skb));
> > >>>>         skb_ext_reset(skb);
> > >>>> =20
> > >>>
> > >>> As I hinted, this should not be needed.
> > >>>
> > >>> For debugging purposes, I would rather do :
> > >>>
> > >>> BUG_ON(skb_shinfo(skb)->gso_size);
> > >>> =20
> > >>
> > >> We did the following for debugging:
> > >>
> > >> diff --git a/net/core/dev.c b/net/core/dev.c
> > >> index 62b06523b..4c943b774 100644
> > >> --- a/net/core/dev.c
> > >> +++ b/net/core/dev.c
> > >> @@ -3491,6 +3491,9 @@ static netdev_features_t gso_features_check(co=
nst struct sk_buff *skb,
> > >>  {
> > >>         u16 gso_segs =3D skb_shinfo(skb)->gso_segs;
> > >>
> > >> +       if (!skb_shinfo(skb)->gso_type)
> > >> +               skb_warn_bad_offload(skb); =20
> > >
> > > You also want to get a stack trace here, to give us the call graph.
> > > =20
> >
> > Here it comes, full story is in https://bugzilla.kernel.org/show_bug.cg=
i?id=3D209423
> >
> >
> > [236222.967498] ------------[ cut here ]------------
> > [236222.967508] r8169: caps=3D(0x00000100000041b2, 0x0000000000000000)
> > [236222.967668] WARNING: CPU: 0 PID: 0 at net/core/dev.c:3184 skb_warn_=
bad_offload+0x72/0xe0
> > [236222.967691] Modules linked in: tcp_diag udp_diag raw_diag inet_diag=
 unix_diag tun nft_nat nft_masq nft_objref nf_conntrack_netbios_ns nf_connt=
rack_broadcast nft_fib_inet nft_fib_ipv4 nft_fib_ipv6 nft_fib nft_reject_in=
et nf_reject_ipv4 nf_reject_ipv6 nft_reject nft_ct nft_chain_nat ip_set_has=
h_net ip6table_nat ip6table_mangle ip6table_raw ip6table_security iptable_n=
at nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 iptable_mangle iptable=
_raw iptable_security ip_set nf_tables nfnetlink ip6table_filter ip6_tables=
 iptable_filter sunrpc vfat fat snd_hda_codec_realtek snd_hda_codec_generic=
 edac_mce_amd ledtrig_audio kvm_amd snd_hda_codec_hdmi ccp snd_hda_intel sn=
d_intel_dspcfg kvm snd_hda_codec snd_hda_core snd_hwdep irqbypass snd_pcm s=
nd_timer snd hp_wmi sp5100_tco sparse_keymap wmi_bmof fam15h_power k10temp =
i2c_piix4 soundcore rfkill_gpio rfkill acpi_cpufreq ip_tables xfs amdgpu io=
mmu_v2 gpu_sched i2c_algo_bit ttm drm_kms_helper cec crct10dif_pclmul crc32=
_pclmul crc32c_intel drm
> > [236222.967776]  ghash_clmulni_intel ax88179_178a serio_raw usbnet mii =
r8169 wmi video
> > [236222.967858] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.8.12-203.fc=
32.x86_64 #1
> > [236222.967870] Hardware name: HP HP t630 Thin Client/8158, BIOS M40 v0=
1.12 02/04/2020
> > [236222.967895] RIP: 0010:skb_warn_bad_offload+0x72/0xe0
> > [236222.967908] Code: 8d 95 c8 00 00 00 48 8d 88 e8 01 00 00 48 85 c0 4=
8 c7 c0 d8 d7 15 a4 48 0f 44 c8 4c 89 e6 48 c7 c7 90 7b 47 a4 e8 04 85 72 f=
f <0f> 0b 5b 5d 41 5c c3 80 7d 00 00 49 c7 c4 3b 28 40 a4 74 ac be 25
> > [236222.967926] RSP: 0018:ffffa8f9c0003c80 EFLAGS: 00010282
> > [236222.967938] RAX: 0000000000000034 RBX: ffff8d7090f2cd00 RCX: 000000=
0000000000
> > [236222.967951] RDX: ffff8d709b427060 RSI: ffff8d709b418d00 RDI: 000000=
0000000300
> > [236222.967962] RBP: ffff8d709a9fc000 R08: 0000000000000406 R09: 072007=
2007200720
> > [236222.967974] R10: 0720072007200720 R11: 0729073007300730 R12: ffffff=
ffc012e729
> > [236222.967986] R13: ffffa8f9c0003d3b R14: 0000000000000000 R15: ffff8d=
70367652ac
> > [236222.968000] FS:  0000000000000000(0000) GS:ffff8d709b400000(0000) k=
nlGS:0000000000000000
> > [236222.968013] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > [236222.968023] CR2: 00007f3cf5ebf010 CR3: 0000000113cc6000 CR4: 000000=
00001406f0
> > [236222.968035] Call Trace:
> > [236222.968047]  <IRQ>
> > [236222.968064]  netif_skb_features+0x25e/0x2c0
> > [236222.968084]  ? ipt_do_table+0x333/0x600 [ip_tables]
> > [236222.968098]  validate_xmit_skb+0x1d/0x300
> > [236222.968111]  validate_xmit_skb_list+0x48/0x70
> > [236222.968126]  sch_direct_xmit+0x129/0x2f0
> > [236222.968140]  __dev_queue_xmit+0x710/0x8a0
> > [236222.968184]  ? nf_confirm+0xcb/0xf0 [nf_conntrack]
> > [236222.968200]  ? nf_hook_slow+0x3f/0xb0
> > [236222.968214]  ip_finish_output2+0x2ad/0x560
> > [236222.968229]  __netif_receive_skb_core+0x4f0/0xf40
> > [236222.968244]  ? packet_rcv+0x44/0x490
> > [236222.968257]  __netif_receive_skb_one_core+0x2d/0x70
> > [236222.968277]  process_backlog+0x96/0x160
> > [236222.968290]  net_rx_action+0x13c/0x3e0
> > [236222.968312]  ? usbnet_bh+0x24/0x2b0 [usbnet]
> > [236222.968327]  __do_softirq+0xd9/0x2c4
> > [236222.968340]  asm_call_on_stack+0x12/0x20
> > [236222.968350]  </IRQ>
> > [236222.968362]  do_softirq_own_stack+0x39/0x50
> > [236222.968376]  irq_exit_rcu+0xc2/0x100
> > [236222.968389]  common_interrupt+0x75/0x140
> > [236222.968405]  asm_common_interrupt+0x1e/0x40
> > [236222.968427] RIP: 0010:native_safe_halt+0xe/0x10
> > [236222.968438] Code: 02 20 48 8b 00 a8 08 75 c4 e9 7b ff ff ff cc cc c=
c cc cc cc cc cc cc cc cc cc cc cc e9 07 00 00 00 0f 00 2d f6 69 49 00 fb f=
4 <c3> 90 e9 07 00 00 00 0f 00 2d e6 69 49 00 f4 c3 cc cc 0f 1f 44 00
> > [236222.968456] RSP: 0018:ffffffffa4a03e08 EFLAGS: 00000246
> > [236222.968467] RAX: 0000000000004000 RBX: 0000000000000001 RCX: 000000=
000000001f
> > [236222.968480] RDX: 4ec4ec4ec4ec4ec5 RSI: ffffffffa4b78960 RDI: ffff8d=
7092f45c00
> > [236222.968492] RBP: ffff8d709a288000 R08: 0000d6d7f20a4084 R09: 000000=
0000000006
> > [236222.968504] R10: 0000000000000022 R11: 000000000000000f R12: ffff8d=
709a288064
> > [236222.968515] R13: 0000000000000001 R14: 0000000000000001 R15: 000000=
0000000000
> > [236222.968535]  acpi_safe_halt+0x1b/0x30
> > [236222.968549]  acpi_idle_enter+0x27e/0x2e0
> > [236222.968566]  cpuidle_enter_state+0x81/0x3f0
> > [236222.968589]  cpuidle_enter+0x29/0x40
> > [236222.968602]  do_idle+0x1d5/0x2a0
> > [236222.968615]  cpu_startup_entry+0x19/0x20
> > [236222.968628]  start_kernel+0x7f4/0x804
> > [236222.968645]  secondary_startup_64+0xb6/0xc0
> > [236222.968659] ---[ end trace 8a4d7f639ad88505 ]---
> >
> > =20
>=20
> OK, it would be nice to know what is the input interface
>=20
> if4 -> look at "ip link | grep 4:"
>=20
> Then identifying the driver that built such a strange packet (32000
> bytes allocated in skb->head)
>=20
> ethtool -i ifname
>=20
>=20
>=20
> > > =20
> > >> +
> > >>         if (gso_segs > dev->gso_max_segs)
> > >>                 return features & ~NETIF_F_GSO_MASK;
> > >>
> > >> Following skb then triggered the skb_warn_bad_offload. Not sure whet=
her this helps
> > >> to find out where in the network stack something goes wrong.
> > >>
> > >>
> > >> [236222.967236] skb len=3D134 headroom=3D778 headlen=3D134 tailroom=
=3D31536
> > >>                 mac=3D(778,14) net=3D(792,20) trans=3D812
> > >>                 shinfo(txflags=3D0 nr_frags=3D0 gso(size=3D568 type=
=3D0 segs=3D1))
> > >>                 csum(0x0 ip_summed=3D1 complete_sw=3D0 valid=3D0 lev=
el=3D0)
> > >>                 hash(0x0 sw=3D0 l4=3D0) proto=3D0x0800 pkttype=3D0 i=
if=3D4
> > >> [236222.967297] dev name=3Denp1s0 feat=3D0x0x00000100000041b2
> > >> [236222.967392] skb linear:   00000000: 00 13 3b a0 01 e8 7c d3 0a 2=
d 1b 3b 08 00 45 00
> > >> [236222.967404] skb linear:   00000010: 00 78 e2 e6 00 00 7b 06 52 e=
1 d8 3a d0 ce c0 a8
> > >> [236222.967415] skb linear:   00000020: a0 06 01 bb 8b c6 53 91 be 5=
e 6e 60 bd e2 80 18
> > >> [236222.967426] skb linear:   00000030: 01 13 5c f6 00 00 01 01 08 0=
a 3d d6 6a a3 63 ea
> > >> [236222.967437] skb linear:   00000040: 5c d9 17 03 03 00 3f af 00 0=
1 84 45 e2 36 e4 6a
> > >> [236222.967454] skb linear:   00000050: 3d 76 a8 7f d7 12 fa 72 4b d=
1 d0 74 0d c1 49 77
> > >> [236222.967466] skb linear:   00000060: 8b a4 bb 04 e5 aa 03 61 d3 e=
6 1f c9 0d 3e 46 c8
> > >> [236222.967477] skb linear:   00000070: cd 1f 7d ce e8 a7 84 84 01 5=
d 1f b4 ee 4f 27 63
> > >> [236222.967488] skb linear:   00000080: d2 a1 ab 1f 26 1d
> > >>
> > >>
> > >> =20
> > >>>
> > >>> Nothing in GRO stack will change gso_size, unless the packet is que=
ued
> > >>> by GRO layer (after this, napi_reuse_skb() wont be called)
> > >>>
> > >>> napi_reuse_skb() is only used when a packet has been aggregated to
> > >>> another, and at this point gso_size should be still 0.
> > >>> =20
> > >> =20

I seem to have stumbled over the same or a similar issue with a Raspberry Pi
3B+ running 5.11-rc4 and using the on-board lan78xx USB NIC. The Pi is used
as a gateway. If I enable IP forwarding on the Pi and pound on eth0 [1], I
get tons of the below warnings after a couple of seconds:

Jan 19 07:55:22 rpi-3b-plus-rev1d3-abfb kernel: [ 1914.744157] skb len=3D54=
 headroom=3D5194 headlen=3D54 tailroom=3D10816
Jan 19 07:55:22 rpi-3b-plus-rev1d3-abfb kernel: [ 1914.744157] mac=3D(5194,=
14) net=3D(5208,20) trans=3D5228
Jan 19 07:55:22 rpi-3b-plus-rev1d3-abfb kernel: [ 1914.744157] shinfo(txfla=
gs=3D0 nr_frags=3D0 gso(size=3D1448 type=3D0 segs=3D1))
Jan 19 07:55:22 rpi-3b-plus-rev1d3-abfb kernel: [ 1914.744157] csum(0xe505 =
ip_summed=3D0 complete_sw=3D0 valid=3D0 level=3D0)
Jan 19 07:55:22 rpi-3b-plus-rev1d3-abfb kernel: [ 1914.744157] hash(0x0 sw=
=3D0 l4=3D0) proto=3D0x0800 pkttype=3D0 iif=3D2
Jan 19 07:55:22 rpi-3b-plus-rev1d3-abfb kernel: [ 1914.774147] dev name=3De=
th0 feat=3D0x0x0000010000114b09
Jan 19 07:55:22 rpi-3b-plus-rev1d3-abfb kernel: [ 1914.779355] skb linear: =
  00000000: e0 28 6d 9e b9 22 b8 27 eb 3e ab fb 08 00 45 00
Jan 19 07:55:22 rpi-3b-plus-rev1d3-abfb kernel: [ 1914.787365] skb linear: =
  00000010: 00 28 00 00 40 00 3f 06 41 d0 c0 a8 63 84 02 14
Jan 19 07:55:22 rpi-3b-plus-rev1d3-abfb kernel: [ 1914.795266] skb linear: =
  00000020: d3 bf ed 3e 01 bb d4 0f 88 7e 00 00 00 00 50 04
Jan 19 07:55:22 rpi-3b-plus-rev1d3-abfb kernel: [ 1914.803168] skb linear: =
  00000030: 00 00 6a 58 00 00
Jan 19 07:55:22 rpi-3b-plus-rev1d3-abfb kernel: [ 1914.808384] ------------=
[ cut here ]------------
Jan 19 07:55:22 rpi-3b-plus-rev1d3-abfb kernel: [ 1914.813200] lan78xx: cap=
s=3D(0x0000010000114b09, 0x0000000000000000)
Jan 19 07:55:22 rpi-3b-plus-rev1d3-abfb kernel: [ 1914.819717] WARNING: CPU=
: 0 PID: 0 at net/core/dev.c:3197 skb_warn_bad_offload+0x84/0x100
Jan 19 07:55:22 rpi-3b-plus-rev1d3-abfb kernel: [ 1914.828190] Modules link=
ed in:
Jan 19 07:55:22 rpi-3b-plus-rev1d3-abfb kernel: [ 1914.831354] CPU: 0 PID: =
0 Comm: swapper/0 Not tainted 5.11.0-rc4 #103
Jan 19 07:55:22 rpi-3b-plus-rev1d3-abfb kernel: [ 1914.838009] Hardware nam=
e: Raspberry Pi 3 Model B Plus Rev 1.3 (DT)
Jan 19 07:55:22 rpi-3b-plus-rev1d3-abfb kernel: [ 1914.844478] pstate: 6000=
0005 (nZCv daif -PAN -UAO -TCO BTYPE=3D--)
Jan 19 07:55:22 rpi-3b-plus-rev1d3-abfb kernel: [ 1914.850685] pc : skb_war=
n_bad_offload+0x84/0x100
Jan 19 07:55:22 rpi-3b-plus-rev1d3-abfb kernel: [ 1914.855464] lr : skb_war=
n_bad_offload+0x84/0x100
Jan 19 07:55:22 rpi-3b-plus-rev1d3-abfb kernel: [ 1914.860242] sp : ffff800=
010003850
Jan 19 07:55:22 rpi-3b-plus-rev1d3-abfb kernel: [ 1914.863665] x29: ffff800=
010003850 x28: ffff7a96fb196290=20
Jan 19 07:55:22 rpi-3b-plus-rev1d3-abfb kernel: [ 1914.869160] x27: ffff7a9=
6c5958300 x26: 0000000000000001=20
Jan 19 07:55:22 rpi-3b-plus-rev1d3-abfb kernel: [ 1914.874654] x25: ffffa73=
eee323000 x24: ffff7a96ee84b000=20
Jan 19 07:55:22 rpi-3b-plus-rev1d3-abfb kernel: [ 1914.880148] x23: ffffa73=
eee7f4f00 x22: 0000000000000000=20
Jan 19 07:55:22 rpi-3b-plus-rev1d3-abfb kernel: [ 1914.885642] x21: ffffa73=
eee0327e0 x20: ffff7a96ee84b000=20
Jan 19 07:55:22 rpi-3b-plus-rev1d3-abfb kernel: [ 1914.891136] x19: ffff7a9=
6c5958300 x18: 0000000000000010=20
Jan 19 07:55:22 rpi-3b-plus-rev1d3-abfb kernel: [ 1914.896630] x17: 0000000=
000000000 x16: 0000000000000000=20
Jan 19 07:55:22 rpi-3b-plus-rev1d3-abfb kernel: [ 1914.902123] x15: 0000000=
00000ad55 x14: 0000000000000010=20
Jan 19 07:55:22 rpi-3b-plus-rev1d3-abfb kernel: [ 1914.907617] x13: 0000000=
0ffffffff x12: ffffa73eedd9d950=20
Jan 19 07:55:22 rpi-3b-plus-rev1d3-abfb kernel: [ 1914.913109] x11: ffffa73=
eee885de0 x10: ffffa73eee86dda0=20
Jan 19 07:55:22 rpi-3b-plus-rev1d3-abfb kernel: [ 1914.918603] x9 : ffffa73=
eecf2f45c x8 : 0000000000017fe8=20
Jan 19 07:55:22 rpi-3b-plus-rev1d3-abfb kernel: [ 1914.924097] x7 : c000000=
0ffffefff x6 : 0000000000000003=20
Jan 19 07:55:22 rpi-3b-plus-rev1d3-abfb kernel: [ 1914.929590] x5 : 0000000=
000000000 x4 : 0000000000000000=20
Jan 19 07:55:22 rpi-3b-plus-rev1d3-abfb kernel: [ 1914.935081] x3 : 0000000=
000000100 x2 : 0000000000001000=20
Jan 19 07:55:22 rpi-3b-plus-rev1d3-abfb kernel: [ 1914.940575] x1 : 0000000=
000000000 x0 : 0000000000000000=20
Jan 19 07:55:22 rpi-3b-plus-rev1d3-abfb kernel: [ 1914.946070] Call trace:
Jan 19 07:55:22 rpi-3b-plus-rev1d3-abfb kernel: [ 1914.948599]  skb_warn_ba=
d_offload+0x84/0x100
Jan 19 07:55:22 rpi-3b-plus-rev1d3-abfb kernel: [ 1914.953020]  netif_skb_f=
eatures+0x218/0x2a0
Jan 19 07:55:22 rpi-3b-plus-rev1d3-abfb kernel: [ 1914.957350]  validate_xm=
it_skb.isra.0+0x28/0x2c8
Jan 19 07:55:22 rpi-3b-plus-rev1d3-abfb kernel: [ 1914.962125]  validate_xm=
it_skb_list+0x44/0x98
Jan 19 07:55:22 rpi-3b-plus-rev1d3-abfb kernel: [ 1914.966631]  sch_direct_=
xmit+0xf0/0x3a8
Jan 19 07:55:22 rpi-3b-plus-rev1d3-abfb kernel: [ 1914.970599]  __qdisc_run=
+0x140/0x668
Jan 19 07:55:22 rpi-3b-plus-rev1d3-abfb kernel: [ 1914.974297]  __dev_queue=
_xmit+0x59c/0x980
Jan 19 07:55:22 rpi-3b-plus-rev1d3-abfb kernel: [ 1914.978446]  dev_queue_x=
mit+0x1c/0x28
Jan 19 07:55:22 rpi-3b-plus-rev1d3-abfb kernel: [ 1914.982237]  ip_finish_o=
utput2+0x30c/0x558
Jan 19 07:55:22 rpi-3b-plus-rev1d3-abfb kernel: [ 1914.986476]  __ip_finish=
_output+0xe4/0x260
Jan 19 07:55:22 rpi-3b-plus-rev1d3-abfb kernel: [ 1914.990715]  ip_finish_o=
utput+0x3c/0xd8
Jan 19 07:55:22 rpi-3b-plus-rev1d3-abfb kernel: [ 1914.994683]  ip_output+0=
xb4/0x148
Jan 19 07:55:22 rpi-3b-plus-rev1d3-abfb kernel: [ 1914.998116]  ip_forward_=
finish+0x7c/0xc0
Jan 19 07:55:22 rpi-3b-plus-rev1d3-abfb kernel: [ 1915.002174]  ip_forward+=
0x42c/0x4f0
Jan 19 07:55:22 rpi-3b-plus-rev1d3-abfb kernel: [ 1915.005783]  ip_rcv_fini=
sh+0x98/0xb8
Jan 19 07:55:22 rpi-3b-plus-rev1d3-abfb kernel: [ 1915.009481]  ip_rcv+0xe0=
/0xf0
Jan 19 07:55:22 rpi-3b-plus-rev1d3-abfb kernel: [ 1915.012552]  __netif_rec=
eive_skb_one_core+0x5c/0x88
Jan 19 07:55:22 rpi-3b-plus-rev1d3-abfb kernel: [ 1915.017597]  __netif_rec=
eive_skb+0x20/0x70
Jan 19 07:55:22 rpi-3b-plus-rev1d3-abfb kernel: [ 1915.021834]  process_bac=
klog+0xc0/0x1d0
Jan 19 07:55:22 rpi-3b-plus-rev1d3-abfb kernel: [ 1915.025802]  net_rx_acti=
on+0x134/0x478
Jan 19 07:55:22 rpi-3b-plus-rev1d3-abfb kernel: [ 1915.029682]  __do_softir=
q+0x130/0x378
Jan 19 07:55:22 rpi-3b-plus-rev1d3-abfb kernel: [ 1915.033472]  irq_exit+0x=
c0/0xe8
Jan 19 07:55:22 rpi-3b-plus-rev1d3-abfb kernel: [ 1915.036725]  __handle_do=
main_irq+0x70/0xc8
Jan 19 07:55:22 rpi-3b-plus-rev1d3-abfb kernel: [ 1915.040963]  bcm2836_arm=
_irqchip_handle_irq+0x6c/0x80
Jan 19 07:55:22 rpi-3b-plus-rev1d3-abfb kernel: [ 1915.046185]  el1_irq+0xb=
4/0x140
Jan 19 07:55:22 rpi-3b-plus-rev1d3-abfb kernel: [ 1915.053377]  arch_cpu_id=
le+0x18/0x28
Jan 19 07:55:22 rpi-3b-plus-rev1d3-abfb kernel: [ 1915.060981]  default_idl=
e_call+0x44/0x178
Jan 19 07:55:22 rpi-3b-plus-rev1d3-abfb kernel: [ 1915.069009]  do_idle+0x2=
24/0x270
Jan 19 07:55:22 rpi-3b-plus-rev1d3-abfb kernel: [ 1915.076147]  cpu_startup=
_entry+0x30/0x98
Jan 19 07:55:22 rpi-3b-plus-rev1d3-abfb kernel: [ 1915.083916]  rest_init+0=
xc8/0xd8
Jan 19 07:55:22 rpi-3b-plus-rev1d3-abfb kernel: [ 1915.090937]  arch_call_r=
est_init+0x18/0x24
Jan 19 07:55:22 rpi-3b-plus-rev1d3-abfb kernel: [ 1915.098829]  start_kerne=
l+0x57c/0x5b8
Jan 19 07:55:22 rpi-3b-plus-rev1d3-abfb kernel: [ 1915.106251] ---[ end tra=
ce c3d8dd12ce1805e0 ]---

If I also add the following rule:
  $ iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
I get a single warning followed by a TX timeout:

Jan 19 08:15:47 rpi-3b-plus-rev1d3-abfb kernel: [   81.516888] skb len=3D66=
 headroom=3D5194 headlen=3D66 tailroom=3D10804
Jan 19 08:15:47 rpi-3b-plus-rev1d3-abfb kernel: [   81.516888] mac=3D(5194,=
14) net=3D(5208,20) trans=3D5228
Jan 19 08:15:47 rpi-3b-plus-rev1d3-abfb kernel: [   81.516888] shinfo(txfla=
gs=3D0 nr_frags=3D0 gso(size=3D1448 type=3D0 segs=3D1))
Jan 19 08:15:47 rpi-3b-plus-rev1d3-abfb kernel: [   81.516888] csum(0xeedb =
ip_summed=3D1 complete_sw=3D0 valid=3D0 level=3D0)
Jan 19 08:15:47 rpi-3b-plus-rev1d3-abfb kernel: [   81.516888] hash(0x0 sw=
=3D0 l4=3D0) proto=3D0x0800 pkttype=3D0 iif=3D2
Jan 19 08:15:47 rpi-3b-plus-rev1d3-abfb kernel: [   81.546872] dev name=3De=
th0 feat=3D0x0x0000010000114b09
Jan 19 08:15:47 rpi-3b-plus-rev1d3-abfb kernel: [   81.552060] skb linear: =
  00000000: e0 28 6d 9e b9 22 b8 27 eb 3e ab fb 08 00 45 00
Jan 19 08:15:47 rpi-3b-plus-rev1d3-abfb kernel: [   81.560090] skb linear: =
  00000010: 00 34 90 99 40 00 3f 06 87 40 c0 a8 63 84 22 6b
Jan 19 08:15:47 rpi-3b-plus-rev1d3-abfb kernel: [   81.568019] skb linear: =
  00000020: dd 52 d0 ac 00 50 35 e0 1e 2c 78 02 47 fa 80 10
Jan 19 08:15:47 rpi-3b-plus-rev1d3-abfb kernel: [   81.575921] skb linear: =
  00000030: 01 f6 d6 96 00 00 01 01 08 0a 50 c9 d7 4b cd 2e
Jan 19 08:15:47 rpi-3b-plus-rev1d3-abfb kernel: [   81.583918] skb linear: =
  00000040: 9f fc
Jan 19 08:15:47 rpi-3b-plus-rev1d3-abfb kernel: [   81.588105] ------------=
[ cut here ]------------
Jan 19 08:15:47 rpi-3b-plus-rev1d3-abfb kernel: [   81.592920] lan78xx: cap=
s=3D(0x0000010000114b09, 0x0000000000000000)
Jan 19 08:15:47 rpi-3b-plus-rev1d3-abfb kernel: [   81.599429] WARNING: CPU=
: 0 PID: 0 at net/core/dev.c:3197 skb_warn_bad_offload+0x84/0x100
Jan 19 08:15:47 rpi-3b-plus-rev1d3-abfb kernel: [   81.607900] Modules link=
ed in:
Jan 19 08:15:47 rpi-3b-plus-rev1d3-abfb kernel: [   81.611064] CPU: 0 PID: =
0 Comm: swapper/0 Not tainted 5.11.0-rc4 #103
Jan 19 08:15:47 rpi-3b-plus-rev1d3-abfb kernel: [   81.617720] Hardware nam=
e: Raspberry Pi 3 Model B Plus Rev 1.3 (DT)
Jan 19 08:15:47 rpi-3b-plus-rev1d3-abfb kernel: [   81.624189] pstate: 6000=
0005 (nZCv daif -PAN -UAO -TCO BTYPE=3D--)
Jan 19 08:15:47 rpi-3b-plus-rev1d3-abfb kernel: [   81.630396] pc : skb_war=
n_bad_offload+0x84/0x100
Jan 19 08:15:47 rpi-3b-plus-rev1d3-abfb kernel: [   81.635175] lr : skb_war=
n_bad_offload+0x84/0x100
Jan 19 08:15:47 rpi-3b-plus-rev1d3-abfb kernel: [   81.639953] sp : ffff800=
010003810
Jan 19 08:15:47 rpi-3b-plus-rev1d3-abfb kernel: [   81.643374] x29: ffff800=
010003810 x28: ffff50043b196290=20
Jan 19 08:15:47 rpi-3b-plus-rev1d3-abfb kernel: [   81.648870] x27: ffff500=
407371600 x26: 0000000000000001=20
Jan 19 08:15:47 rpi-3b-plus-rev1d3-abfb kernel: [   81.654365] x25: ffffa1f=
a11b23000 x24: ffff50042e96b000=20
Jan 19 08:15:47 rpi-3b-plus-rev1d3-abfb kernel: [   81.659859] x23: ffffa1f=
a11ff4f00 x22: 0000000000000000=20
Jan 19 08:15:47 rpi-3b-plus-rev1d3-abfb kernel: [   81.665353] x21: ffffa1f=
a118327e0 x20: ffff50042e96b000=20
Jan 19 08:15:47 rpi-3b-plus-rev1d3-abfb kernel: [   81.670847] x19: ffff500=
407371600 x18: 0000000000000010=20
Jan 19 08:15:47 rpi-3b-plus-rev1d3-abfb kernel: [   81.676340] x17: 0000000=
000000000 x16: 0000000000000000=20
Jan 19 08:15:47 rpi-3b-plus-rev1d3-abfb kernel: [   81.681833] x15: 0000000=
00000ad55 x14: 0000000000000010=20
Jan 19 08:15:47 rpi-3b-plus-rev1d3-abfb kernel: [   81.687326] x13: 0000000=
0ffffffff x12: ffffa1fa1159d950=20
Jan 19 08:15:47 rpi-3b-plus-rev1d3-abfb kernel: [   81.692819] x11: ffffa1f=
a12085de0 x10: ffffa1fa1206dda0=20
Jan 19 08:15:47 rpi-3b-plus-rev1d3-abfb kernel: [   81.698313] x9 : ffffa1f=
a1072f45c x8 : 0000000000017fe8=20
Jan 19 08:15:47 rpi-3b-plus-rev1d3-abfb kernel: [   81.703806] x7 : c000000=
0ffffefff x6 : 0000000000000003=20
Jan 19 08:15:47 rpi-3b-plus-rev1d3-abfb kernel: [   81.709300] x5 : 0000000=
000000000 x4 : 0000000000000000=20
Jan 19 08:15:47 rpi-3b-plus-rev1d3-abfb kernel: [   81.714791] x3 : 0000000=
000000100 x2 : 0000000000001000=20
Jan 19 08:15:47 rpi-3b-plus-rev1d3-abfb kernel: [   81.720283] x1 : 0000000=
000000000 x0 : 0000000000000000=20
Jan 19 08:15:47 rpi-3b-plus-rev1d3-abfb kernel: [   81.725778] Call trace:
Jan 19 08:15:47 rpi-3b-plus-rev1d3-abfb kernel: [   81.728306]  skb_warn_ba=
d_offload+0x84/0x100
Jan 19 08:15:47 rpi-3b-plus-rev1d3-abfb kernel: [   81.732728]  netif_skb_f=
eatures+0x218/0x2a0
Jan 19 08:15:47 rpi-3b-plus-rev1d3-abfb kernel: [   81.737057]  validate_xm=
it_skb.isra.0+0x28/0x2c8
Jan 19 08:15:47 rpi-3b-plus-rev1d3-abfb kernel: [   81.741833]  validate_xm=
it_skb_list+0x44/0x98
Jan 19 08:15:47 rpi-3b-plus-rev1d3-abfb kernel: [   81.746339]  sch_direct_=
xmit+0xf0/0x3a8
Jan 19 08:15:47 rpi-3b-plus-rev1d3-abfb kernel: [   81.750309]  __qdisc_run=
+0x140/0x668
Jan 19 08:15:47 rpi-3b-plus-rev1d3-abfb kernel: [   81.754008]  __dev_queue=
_xmit+0x59c/0x980
Jan 19 08:15:47 rpi-3b-plus-rev1d3-abfb kernel: [   81.758156]  dev_queue_x=
mit+0x1c/0x28
Jan 19 08:15:47 rpi-3b-plus-rev1d3-abfb kernel: [   81.761945]  neigh_resol=
ve_output+0x108/0x230
Jan 19 08:15:47 rpi-3b-plus-rev1d3-abfb kernel: [   81.766450]  ip_finish_o=
utput2+0x180/0x558
Jan 19 08:15:47 rpi-3b-plus-rev1d3-abfb kernel: [   81.770690]  __ip_finish=
_output+0xe4/0x260
Jan 19 08:15:47 rpi-3b-plus-rev1d3-abfb kernel: [   81.774928]  ip_finish_o=
utput+0x3c/0xd8
Jan 19 08:15:47 rpi-3b-plus-rev1d3-abfb kernel: [   81.778896]  ip_output+0=
xb4/0x148
Jan 19 08:15:47 rpi-3b-plus-rev1d3-abfb kernel: [   81.782328]  ip_forward_=
finish+0x7c/0xc0
Jan 19 08:15:47 rpi-3b-plus-rev1d3-abfb kernel: [   81.786385]  ip_forward+=
0x42c/0x4f0
Jan 19 08:15:47 rpi-3b-plus-rev1d3-abfb kernel: [   81.789995]  ip_rcv_fini=
sh+0x98/0xb8
Jan 19 08:15:47 rpi-3b-plus-rev1d3-abfb kernel: [   81.793694]  ip_rcv+0xe0=
/0xf0
Jan 19 08:15:47 rpi-3b-plus-rev1d3-abfb kernel: [   81.796765]  __netif_rec=
eive_skb_one_core+0x5c/0x88
Jan 19 08:15:47 rpi-3b-plus-rev1d3-abfb kernel: [   81.801810]  __netif_rec=
eive_skb+0x20/0x70
Jan 19 08:15:47 rpi-3b-plus-rev1d3-abfb kernel: [   81.806047]  process_bac=
klog+0xc0/0x1d0
Jan 19 08:15:47 rpi-3b-plus-rev1d3-abfb kernel: [   81.810016]  net_rx_acti=
on+0x134/0x478
Jan 19 08:15:47 rpi-3b-plus-rev1d3-abfb kernel: [   81.813897]  __do_softir=
q+0x130/0x378
Jan 19 08:15:47 rpi-3b-plus-rev1d3-abfb kernel: [   81.817686]  irq_exit+0x=
c0/0xe8
Jan 19 08:15:47 rpi-3b-plus-rev1d3-abfb kernel: [   81.820940]  __handle_do=
main_irq+0x70/0xc8
Jan 19 08:15:47 rpi-3b-plus-rev1d3-abfb kernel: [   81.829099]  bcm2836_arm=
_irqchip_handle_irq+0x6c/0x80
Jan 19 08:15:47 rpi-3b-plus-rev1d3-abfb kernel: [   81.838223]  el1_irq+0xb=
4/0x140
Jan 19 08:15:47 rpi-3b-plus-rev1d3-abfb kernel: [   81.845371]  arch_cpu_id=
le+0x18/0x28
Jan 19 08:15:47 rpi-3b-plus-rev1d3-abfb kernel: [   81.852882]  default_idl=
e_call+0x44/0x178
Jan 19 08:15:47 rpi-3b-plus-rev1d3-abfb kernel: [   81.860756]  do_idle+0x2=
24/0x270
Jan 19 08:15:47 rpi-3b-plus-rev1d3-abfb kernel: [   81.867794]  cpu_startup=
_entry+0x30/0x98
Jan 19 08:15:47 rpi-3b-plus-rev1d3-abfb kernel: [   81.875516]  rest_init+0=
xc8/0xd8
Jan 19 08:15:47 rpi-3b-plus-rev1d3-abfb kernel: [   81.882496]  arch_call_r=
est_init+0x18/0x24
Jan 19 08:15:47 rpi-3b-plus-rev1d3-abfb kernel: [   81.890352]  start_kerne=
l+0x57c/0x5b8
Jan 19 08:15:47 rpi-3b-plus-rev1d3-abfb kernel: [   81.897706] ---[ end tra=
ce a5789410f231a10b ]---
Jan 19 08:16:15 rpi-3b-plus-rev1d3-abfb kernel: [  110.046337] ------------=
[ cut here ]------------
Jan 19 08:16:15 rpi-3b-plus-rev1d3-abfb kernel: [  110.054787] NETDEV WATCH=
DOG: eth0 (lan78xx): transmit queue 0 timed out
Jan 19 08:16:15 rpi-3b-plus-rev1d3-abfb kernel: [  110.065356] WARNING: CPU=
: 2 PID: 0 at net/sched/sch_generic.c:442 dev_watchdog+0x384/0x390
Jan 19 08:16:15 rpi-3b-plus-rev1d3-abfb kernel: [  110.077534] Modules link=
ed in:
Jan 19 08:16:15 rpi-3b-plus-rev1d3-abfb kernel: [  110.084361] CPU: 2 PID: =
0 Comm: swapper/2 Tainted: G        W         5.11.0-rc4 #103
Jan 19 08:16:15 rpi-3b-plus-rev1d3-abfb kernel: [  110.096114] Hardware nam=
e: Raspberry Pi 3 Model B Plus Rev 1.3 (DT)
Jan 19 08:16:15 rpi-3b-plus-rev1d3-abfb kernel: [  110.106246] pstate: 6000=
0005 (nZCv daif -PAN -UAO -TCO BTYPE=3D--)
Jan 19 08:16:15 rpi-3b-plus-rev1d3-abfb kernel: [  110.116085] pc : dev_wat=
chdog+0x384/0x390
Jan 19 08:16:15 rpi-3b-plus-rev1d3-abfb kernel: [  110.123857] lr : dev_wat=
chdog+0x384/0x390
Jan 19 08:16:15 rpi-3b-plus-rev1d3-abfb kernel: [  110.131558] sp : ffff800=
010013d90
Jan 19 08:16:15 rpi-3b-plus-rev1d3-abfb kernel: [  110.138497] x29: ffff800=
010013d90 x28: 0000000000000140=20
Jan 19 08:16:15 rpi-3b-plus-rev1d3-abfb kernel: [  110.147472] x27: 0000000=
0ffffffff x26: ffffa1fa11b23000=20
Jan 19 08:16:15 rpi-3b-plus-rev1d3-abfb kernel: [  110.156489] x25: 0000000=
000000002 x24: 0000000000000000=20
Jan 19 08:16:15 rpi-3b-plus-rev1d3-abfb kernel: [  110.165496] x23: 0000000=
000000001 x22: ffff50042e96b000=20
Jan 19 08:16:15 rpi-3b-plus-rev1d3-abfb kernel: [  110.174494] x21: ffff500=
42e96b440 x20: ffffa1fa11fe7000=20
Jan 19 08:16:15 rpi-3b-plus-rev1d3-abfb kernel: [  110.183490] x19: 0000000=
000000000 x18: 0000000000000010=20
Jan 19 08:16:15 rpi-3b-plus-rev1d3-abfb kernel: [  110.192493] x17: 0000000=
000000000 x16: 0000000000000000=20
Jan 19 08:16:15 rpi-3b-plus-rev1d3-abfb kernel: [  110.201473] x15: 0000000=
00000ad55 x14: 0000000000000010=20
Jan 19 08:16:15 rpi-3b-plus-rev1d3-abfb kernel: [  110.210439] x13: 0000000=
0ffffffff x12: ffffa1fa1159d950=20
Jan 19 08:16:15 rpi-3b-plus-rev1d3-abfb kernel: [  110.219397] x11: ffffa1f=
a12085de0 x10: ffffa1fa1206dda0=20
Jan 19 08:16:15 rpi-3b-plus-rev1d3-abfb kernel: [  110.228367] x9 : ffffa1f=
a1072f45c x8 : 0000000000017fe8=20
Jan 19 08:16:15 rpi-3b-plus-rev1d3-abfb kernel: [  110.237362] x7 : c000000=
0ffffefff x6 : 0000000000000003=20
Jan 19 08:16:15 rpi-3b-plus-rev1d3-abfb kernel: [  110.246353] x5 : 0000000=
000000000 x4 : 0000000000000000=20
Jan 19 08:16:15 rpi-3b-plus-rev1d3-abfb kernel: [  110.255328] x3 : 0000000=
000000100 x2 : 0000000000001000=20
Jan 19 08:16:15 rpi-3b-plus-rev1d3-abfb kernel: [  110.264273] x1 : 0000000=
000000000 x0 : 0000000000000000=20
Jan 19 08:16:15 rpi-3b-plus-rev1d3-abfb kernel: [  110.273192] Call trace:
Jan 19 08:16:15 rpi-3b-plus-rev1d3-abfb kernel: [  110.279183]  dev_watchdo=
g+0x384/0x390
Jan 19 08:16:15 rpi-3b-plus-rev1d3-abfb kernel: [  110.286461]  call_timer_=
fn+0x38/0x188
Jan 19 08:16:15 rpi-3b-plus-rev1d3-abfb kernel: [  110.293762]  run_timer_s=
oftirq+0x494/0x688
Jan 19 08:16:15 rpi-3b-plus-rev1d3-abfb kernel: [  110.301489]  __do_softir=
q+0x130/0x378
Jan 19 08:16:15 rpi-3b-plus-rev1d3-abfb kernel: [  110.308767]  irq_exit+0x=
c0/0xe8
Jan 19 08:16:15 rpi-3b-plus-rev1d3-abfb kernel: [  110.315500]  __handle_do=
main_irq+0x70/0xc8
Jan 19 08:16:15 rpi-3b-plus-rev1d3-abfb kernel: [  110.323214]  bcm2836_arm=
_irqchip_handle_irq+0x6c/0x80
Jan 19 08:16:15 rpi-3b-plus-rev1d3-abfb kernel: [  110.331940]  el1_irq+0xb=
4/0x140
Jan 19 08:16:15 rpi-3b-plus-rev1d3-abfb kernel: [  110.338706]  arch_cpu_id=
le+0x18/0x28
Jan 19 08:16:15 rpi-3b-plus-rev1d3-abfb kernel: [  110.345916]  default_idl=
e_call+0x44/0x178
Jan 19 08:16:15 rpi-3b-plus-rev1d3-abfb kernel: [  110.353577]  do_idle+0x2=
24/0x270
Jan 19 08:16:15 rpi-3b-plus-rev1d3-abfb kernel: [  110.360433]  cpu_startup=
_entry+0x2c/0x98
Jan 19 08:16:15 rpi-3b-plus-rev1d3-abfb kernel: [  110.368000]  secondary_s=
tart_kernel+0x148/0x180
Jan 19 08:16:15 rpi-3b-plus-rev1d3-abfb kernel: [  110.376199] ---[ end tra=
ce a5789410f231a10c ]---

I did some bisecting and found commit [2] to be problematic. Reverting that
commit plus the two follow-on fixes [3] and [4] prevents the warnings and
timeout. I'm no networking expert so can't determine if [2] is broken or
merely exposes a different underlying issue. I failed to reproduce the prob=
lem
using a dedicated Realtek-based USB NIC plugged into the Pi, which points
towards the lan78xx driver/HW being the culprit.

Enabling KASAN didn't trigger any error reports.

Let me know if there's anything else I can try to narrow this down.

...Juerg

[1]
On the Pi, I run:
  $ nc -l 1234 | dd status=3Dprogress >/dev/null

And on another machine, that is configured to use the Pi as the gateway:
  $ nc 192.168.99.115 1234 < /dev/urandom
and a couple of firefox instances that keep opening public URls.

[2]
Author: Eric Dumazet <edumazet@google.com>
Date:   Tue Nov 27 14:42:03 2018 -0800

    tcp: implement coalescing on backlog queue
   =20
    In case GRO is not as efficient as it should be or disabled,
    we might have a user thread trapped in __release_sock() while
    softirq handler flood packets up to the point we have to drop.
   =20
    This patch balances work done from user thread and softirq,
    to give more chances to __release_sock() to complete its work
    before new packets are added the the backlog.
   =20
    This also helps if we receive many ACK packets, since GRO
    does not aggregate them.
   =20
    This patch brings ~60% throughput increase on a receiver
    without GRO, but the spectacular gain is really on
    1000x release_sock() latency reduction I have measured.
   =20
    Signed-off-by: Eric Dumazet <edumazet@google.com>
    Cc: Neal Cardwell <ncardwell@google.com>
    Cc: Yuchung Cheng <ycheng@google.com>
    Acked-by: Neal Cardwell <ncardwell@google.com>
    Signed-off-by: David S. Miller <davem@davemloft.net>

[3] 86bccd036713 tcp: fix receive window update in tcp_add_backlog()
[4] ca2fe2956ace tcp: add sanity tests in tcp_add_backlog()

--Sig_/1=yDia1zO_anxAX1v00oCz.
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEhZfU96IuprviLdeLD9OLCQumQrcFAmAG0zcACgkQD9OLCQum
QrcqcRAArOOH5k3+QumUiAXamNMo2Gyt5P0Yucs1QuouqbrusnC5Q5JHHi0G0s8W
97JD3qdyXOXaGzSMoN3wCTJM9Y+/NKxh27cEXWqQU8u8xdEQl1FezBpRsFXuBVhD
K8FC9HQh92YdJ2kbNXm2BR0o/q+YR4qxSTwgxyv5dzusOgSjLoe06XR25j25Zanf
YPGiUOVINvwOFrXgxGhM/bR18gSCgabg2utB0Kr7uMVxkzcFQRULcrMpe1xrEOQD
BfT0JBzM7RrZ1AHCv01dy8NcsR1JRSeL+uPI/Cv5iPiVy8a+qd7KfCLxHVo2JP4F
2g0Yk1HHxbqQixnXDLt4zT0BU9kVdIV2CnWHYNgPYhsHw58ZoujNgn7WbhNNMcye
aZVAgwDKkZIjGaIqIx4/IpBKV1Ek5Vc6H4OrnK39wW0ezSI/LqhK00x+L0sf5S+L
pGc8U41wNRFO/P/PrI7uyZbFOhYDzoqmw+hI2z3PzHiw/oosMVIqQ8gSnHasr/vX
7OEM9whJi9VPt/jShBnW6R7B9FcBNFwyyJslqlR9IrAd3MFW5dU4KxaIHkH91LV4
XCeA8G8CPiCqO16ZIzBjpjE0YoehHIcVbNKzPch/gqonelUi1vwhQuCSAJs4uUQr
u1F9wN0gKdfhFeYgvwRAf+WmPSsrtSXVV/tuzwg7fWI++D9W2Hw=
=1n9H
-----END PGP SIGNATURE-----

--Sig_/1=yDia1zO_anxAX1v00oCz.--
