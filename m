Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 392BB287BE3
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 20:50:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729377AbgJHSum (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 14:50:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725908AbgJHSum (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 14:50:42 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CC56C061755
        for <netdev@vger.kernel.org>; Thu,  8 Oct 2020 11:50:42 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id l16so6721801ilt.13
        for <netdev@vger.kernel.org>; Thu, 08 Oct 2020 11:50:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=VarNHeS8Lit5Sb+YfK+Jc/qEKlqL2LCF1aEUZbPqnBk=;
        b=ZbqiHHYddPNuryuJLlXZXko8mRDl+eyO+klkR/wLOI4jsxWgwwecseS5+6IAayeHys
         hfd3bcW6eMuCuUV7LVHGyfnBsRu3PbO9iE0LOW/g/t3vuAyCFUEutLCNyvkDqr+R23Xn
         uKQPkqGru9Zi47PZfjQpPmfQtN27xIpRvFISGDH8+hTOAqncxCwfqfak3k4Rb6ZwS+0+
         9wfCBun/vxs8nh8mqnKisZBZo4zTRjwPdgiRAT7BnZ9Nu+qCcHjU4NFmeU/1+60jEHrO
         Gh7zrOBRzmxSFvDGMf6U8nFnd/Gn4v6s6zSecw7OmDZ31xBaQINeQQnMk6qT5hetPjJ/
         HVLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=VarNHeS8Lit5Sb+YfK+Jc/qEKlqL2LCF1aEUZbPqnBk=;
        b=JkLQkaBJJMiNHgBjia8R3CCmdu51qWXn4lwxNpZcC4SCSRNR5+gylURmSJUQh/1aVz
         m5epSlmm8tHH7v4p5N7da0KQf6BSt5fh4ZqYQ4PTEgMgK+xec+9pm98t0wR06VHV3yRw
         TY8oT+QMLz5Iye333ztuo2JMkbs5lobEXBK33pOtpeyWptE0xPvDxe8CN9umpX4Wl8AZ
         nXNqJ7Axz22KzsJW0sSmlPZjt1QYB43dPzzGDPF/SeGOJFVhMuzaZfbo+YeSzKHlqclD
         S/oF/aUEWIBVTki10Are4OX3qLqpM9b8DX0JNup+446MnbxpVA+vN/Js0+kszC8qVd0V
         zeww==
X-Gm-Message-State: AOAM531pNijx74PNY2VXggzdVusC0TzCfpUa1nLVqG2uGK2Agquw29vt
        prh4iS6RhdZ1TRt63QOe3GDspdECfxTA382zLeNwizwFCJA=
X-Google-Smtp-Source: ABdhPJwM7EI6ETQwSxhzuAKE4bxgcAVIRU+28lkCVWheW6k57nZDkUKOUVlN3ZzoE2pBZvq3TpFJbHVKpStxRXnzXDM=
X-Received: by 2002:a92:5e42:: with SMTP id s63mr8033637ilb.205.1602183040702;
 Thu, 08 Oct 2020 11:50:40 -0700 (PDT)
MIME-Version: 1.0
References: <bug-209423-201211-atteo0d1ZY@https.bugzilla.kernel.org/>
 <80adc922-f667-a1ab-35a6-02bf1acfd5a1@gmail.com> <CANn89i+ZC5y_n_kQTm4WCWZsYaph4E2vtC9k_caE6dkuQrXdPQ@mail.gmail.com>
 <733a6e54-f03c-0076-1bdc-9b0d4ec1038c@gmail.com> <CANn89iJ2zqH=_fvJQ8dhG4nBVnKNB7SjHnHDLv+0iR7UwgxTsw@mail.gmail.com>
 <b6ff841a-320c-5592-1c2b-650e18dfe3e0@gmail.com> <CANn89iJ2KxQKZmT2ShVZRTjdgyYkF_2ZWBraTZE4TJVtUKh--Q@mail.gmail.com>
 <9e4b2b1f-c2d9-dbd0-c7ce-49007ddd7af2@gmail.com> <CANn89iJwwDCkdmFFAkXav+HNJQEEKZsp8PKvEuHc4gNJ=4iCoQ@mail.gmail.com>
 <77541223-8eaf-512c-1930-558e8d23eb33@gmail.com>
In-Reply-To: <77541223-8eaf-512c-1930-558e8d23eb33@gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 8 Oct 2020 20:50:28 +0200
Message-ID: <CANn89i+dtetSScxtSRWX8BEgcW_uJ7vzvb+8sW57b7DJ3r=fXQ@mail.gmail.com>
Subject: Re: [Bug 209423] WARN_ON_ONCE() at rtl8169_tso_csum_v2()
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 8, 2020 at 8:42 PM Heiner Kallweit <hkallweit1@gmail.com> wrote=
:
>
> On 08.10.2020 19:15, Eric Dumazet wrote:
> > On Thu, Oct 8, 2020 at 6:37 PM Heiner Kallweit <hkallweit1@gmail.com> w=
rote:
> >>
> >> On 02.10.2020 13:48, Eric Dumazet wrote:
> >>> On Fri, Oct 2, 2020 at 1:09 PM Heiner Kallweit <hkallweit1@gmail.com>=
 wrote:
> >>>>
> >>>> On 02.10.2020 10:46, Eric Dumazet wrote:
> >>>>> On Fri, Oct 2, 2020 at 10:32 AM Eric Dumazet <eric.dumazet@gmail.co=
m> wrote:
> >>>>>>
> >>>>>>
> >>>>>>
> >>>>>> On 10/2/20 10:26 AM, Eric Dumazet wrote:
> >>>>>>> On Thu, Oct 1, 2020 at 10:34 PM Heiner Kallweit <hkallweit1@gmail=
.com> wrote:
> >>>>>>>>
> >>>>>>>> I have a problem with the following code in ndo_start_xmit() of
> >>>>>>>> the r8169 driver. A user reported the WARN being triggered due
> >>>>>>>> to gso_size > 0 and gso_type =3D 0. The chip supports TSO(6).
> >>>>>>>> The driver is widely used, therefore I'd expect much more such
> >>>>>>>> reports if it should be a common problem. Not sure what's specia=
l.
> >>>>>>>> My primary question: Is it a valid use case that gso_size is
> >>>>>>>> greater than 0, and no SKB_GSO_ flag is set?
> >>>>>>>> Any hint would be appreciated.
> >>>>>>>>
> >>>>>>>>
> >>>>>>>
> >>>>>>> Maybe this is not a TCP packet ? But in this case GSO should have=
 taken place.
> >>>>>>>
> >>>>>>> You might add a
> >>>>>>> pr_err_once("gso_type=3D%x\n", shinfo->gso_type);
> >>>>>>>
> >>>>>
> >>>>>>
> >>>>>> Ah, sorry I see you already printed gso_type
> >>>>>>
> >>>>>> Must then be a bug somewhere :/
> >>>>>
> >>>>>
> >>>>> napi_reuse_skb() does :
> >>>>>
> >>>>> skb_shinfo(skb)->gso_type =3D 0;
> >>>>>
> >>>>> It does _not_ clear gso_size.
> >>>>>
> >>>>> I wonder if in some cases we could reuse an skb while gso_size is n=
ot zero.
> >>>>>
> >>>>> Normally, we set it only from dev_gro_receive() when the skb is que=
ued
> >>>>> into GRO engine (status being GRO_HELD)
> >>>>>
> >>>> Thanks Eric. I'm no expert that deep in the network stack and just w=
onder
> >>>> why napi_reuse_skb() re-initializes less fields in shinfo than __all=
oc_skb().
> >>>> The latter one does a
> >>>> memset(shinfo, 0, offsetof(struct skb_shared_info, dataref));
> >>>>
> >>>
> >>> memset() over the whole thing is more expensive.
> >>>
> >>> Here we know the prior state of some fields, while __alloc_skb() just
> >>> got a piece of memory with random content.
> >>>
> >>>> What I can do is letting the affected user test the following.
> >>>>
> >>>> diff --git a/net/core/dev.c b/net/core/dev.c
> >>>> index 62b06523b..8e75399cc 100644
> >>>> --- a/net/core/dev.c
> >>>> +++ b/net/core/dev.c
> >>>> @@ -6088,6 +6088,7 @@ static void napi_reuse_skb(struct napi_struct =
*napi, struct sk_buff *skb)
> >>>>
> >>>>         skb->encapsulation =3D 0;
> >>>>         skb_shinfo(skb)->gso_type =3D 0;
> >>>> +       skb_shinfo(skb)->gso_size =3D 0;
> >>>>         skb->truesize =3D SKB_TRUESIZE(skb_end_offset(skb));
> >>>>         skb_ext_reset(skb);
> >>>>
> >>>
> >>> As I hinted, this should not be needed.
> >>>
> >>> For debugging purposes, I would rather do :
> >>>
> >>> BUG_ON(skb_shinfo(skb)->gso_size);
> >>>
> >>
> >> We did the following for debugging:
> >>
> >> diff --git a/net/core/dev.c b/net/core/dev.c
> >> index 62b06523b..4c943b774 100644
> >> --- a/net/core/dev.c
> >> +++ b/net/core/dev.c
> >> @@ -3491,6 +3491,9 @@ static netdev_features_t gso_features_check(cons=
t struct sk_buff *skb,
> >>  {
> >>         u16 gso_segs =3D skb_shinfo(skb)->gso_segs;
> >>
> >> +       if (!skb_shinfo(skb)->gso_type)
> >> +               skb_warn_bad_offload(skb);
> >
> > You also want to get a stack trace here, to give us the call graph.
> >
>
> Here it comes, full story is in https://bugzilla.kernel.org/show_bug.cgi?=
id=3D209423
>
>
> [236222.967498] ------------[ cut here ]------------
> [236222.967508] r8169: caps=3D(0x00000100000041b2, 0x0000000000000000)
> [236222.967668] WARNING: CPU: 0 PID: 0 at net/core/dev.c:3184 skb_warn_ba=
d_offload+0x72/0xe0
> [236222.967691] Modules linked in: tcp_diag udp_diag raw_diag inet_diag u=
nix_diag tun nft_nat nft_masq nft_objref nf_conntrack_netbios_ns nf_conntra=
ck_broadcast nft_fib_inet nft_fib_ipv4 nft_fib_ipv6 nft_fib nft_reject_inet=
 nf_reject_ipv4 nf_reject_ipv6 nft_reject nft_ct nft_chain_nat ip_set_hash_=
net ip6table_nat ip6table_mangle ip6table_raw ip6table_security iptable_nat=
 nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 iptable_mangle iptable_r=
aw iptable_security ip_set nf_tables nfnetlink ip6table_filter ip6_tables i=
ptable_filter sunrpc vfat fat snd_hda_codec_realtek snd_hda_codec_generic e=
dac_mce_amd ledtrig_audio kvm_amd snd_hda_codec_hdmi ccp snd_hda_intel snd_=
intel_dspcfg kvm snd_hda_codec snd_hda_core snd_hwdep irqbypass snd_pcm snd=
_timer snd hp_wmi sp5100_tco sparse_keymap wmi_bmof fam15h_power k10temp i2=
c_piix4 soundcore rfkill_gpio rfkill acpi_cpufreq ip_tables xfs amdgpu iomm=
u_v2 gpu_sched i2c_algo_bit ttm drm_kms_helper cec crct10dif_pclmul crc32_p=
clmul crc32c_intel drm
> [236222.967776]  ghash_clmulni_intel ax88179_178a serio_raw usbnet mii r8=
169 wmi video
> [236222.967858] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.8.12-203.fc32=
.x86_64 #1
> [236222.967870] Hardware name: HP HP t630 Thin Client/8158, BIOS M40 v01.=
12 02/04/2020
> [236222.967895] RIP: 0010:skb_warn_bad_offload+0x72/0xe0
> [236222.967908] Code: 8d 95 c8 00 00 00 48 8d 88 e8 01 00 00 48 85 c0 48 =
c7 c0 d8 d7 15 a4 48 0f 44 c8 4c 89 e6 48 c7 c7 90 7b 47 a4 e8 04 85 72 ff =
<0f> 0b 5b 5d 41 5c c3 80 7d 00 00 49 c7 c4 3b 28 40 a4 74 ac be 25
> [236222.967926] RSP: 0018:ffffa8f9c0003c80 EFLAGS: 00010282
> [236222.967938] RAX: 0000000000000034 RBX: ffff8d7090f2cd00 RCX: 00000000=
00000000
> [236222.967951] RDX: ffff8d709b427060 RSI: ffff8d709b418d00 RDI: 00000000=
00000300
> [236222.967962] RBP: ffff8d709a9fc000 R08: 0000000000000406 R09: 07200720=
07200720
> [236222.967974] R10: 0720072007200720 R11: 0729073007300730 R12: ffffffff=
c012e729
> [236222.967986] R13: ffffa8f9c0003d3b R14: 0000000000000000 R15: ffff8d70=
367652ac
> [236222.968000] FS:  0000000000000000(0000) GS:ffff8d709b400000(0000) knl=
GS:0000000000000000
> [236222.968013] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [236222.968023] CR2: 00007f3cf5ebf010 CR3: 0000000113cc6000 CR4: 00000000=
001406f0
> [236222.968035] Call Trace:
> [236222.968047]  <IRQ>
> [236222.968064]  netif_skb_features+0x25e/0x2c0
> [236222.968084]  ? ipt_do_table+0x333/0x600 [ip_tables]
> [236222.968098]  validate_xmit_skb+0x1d/0x300
> [236222.968111]  validate_xmit_skb_list+0x48/0x70
> [236222.968126]  sch_direct_xmit+0x129/0x2f0
> [236222.968140]  __dev_queue_xmit+0x710/0x8a0
> [236222.968184]  ? nf_confirm+0xcb/0xf0 [nf_conntrack]
> [236222.968200]  ? nf_hook_slow+0x3f/0xb0
> [236222.968214]  ip_finish_output2+0x2ad/0x560
> [236222.968229]  __netif_receive_skb_core+0x4f0/0xf40
> [236222.968244]  ? packet_rcv+0x44/0x490
> [236222.968257]  __netif_receive_skb_one_core+0x2d/0x70
> [236222.968277]  process_backlog+0x96/0x160
> [236222.968290]  net_rx_action+0x13c/0x3e0
> [236222.968312]  ? usbnet_bh+0x24/0x2b0 [usbnet]
> [236222.968327]  __do_softirq+0xd9/0x2c4
> [236222.968340]  asm_call_on_stack+0x12/0x20
> [236222.968350]  </IRQ>
> [236222.968362]  do_softirq_own_stack+0x39/0x50
> [236222.968376]  irq_exit_rcu+0xc2/0x100
> [236222.968389]  common_interrupt+0x75/0x140
> [236222.968405]  asm_common_interrupt+0x1e/0x40
> [236222.968427] RIP: 0010:native_safe_halt+0xe/0x10
> [236222.968438] Code: 02 20 48 8b 00 a8 08 75 c4 e9 7b ff ff ff cc cc cc =
cc cc cc cc cc cc cc cc cc cc cc e9 07 00 00 00 0f 00 2d f6 69 49 00 fb f4 =
<c3> 90 e9 07 00 00 00 0f 00 2d e6 69 49 00 f4 c3 cc cc 0f 1f 44 00
> [236222.968456] RSP: 0018:ffffffffa4a03e08 EFLAGS: 00000246
> [236222.968467] RAX: 0000000000004000 RBX: 0000000000000001 RCX: 00000000=
0000001f
> [236222.968480] RDX: 4ec4ec4ec4ec4ec5 RSI: ffffffffa4b78960 RDI: ffff8d70=
92f45c00
> [236222.968492] RBP: ffff8d709a288000 R08: 0000d6d7f20a4084 R09: 00000000=
00000006
> [236222.968504] R10: 0000000000000022 R11: 000000000000000f R12: ffff8d70=
9a288064
> [236222.968515] R13: 0000000000000001 R14: 0000000000000001 R15: 00000000=
00000000
> [236222.968535]  acpi_safe_halt+0x1b/0x30
> [236222.968549]  acpi_idle_enter+0x27e/0x2e0
> [236222.968566]  cpuidle_enter_state+0x81/0x3f0
> [236222.968589]  cpuidle_enter+0x29/0x40
> [236222.968602]  do_idle+0x1d5/0x2a0
> [236222.968615]  cpu_startup_entry+0x19/0x20
> [236222.968628]  start_kernel+0x7f4/0x804
> [236222.968645]  secondary_startup_64+0xb6/0xc0
> [236222.968659] ---[ end trace 8a4d7f639ad88505 ]---
>
>

OK, it would be nice to know what is the input interface

if4 -> look at "ip link | grep 4:"

Then identifying the driver that built such a strange packet (32000
bytes allocated in skb->head)

ethtool -i ifname



> >
> >> +
> >>         if (gso_segs > dev->gso_max_segs)
> >>                 return features & ~NETIF_F_GSO_MASK;
> >>
> >> Following skb then triggered the skb_warn_bad_offload. Not sure whethe=
r this helps
> >> to find out where in the network stack something goes wrong.
> >>
> >>
> >> [236222.967236] skb len=3D134 headroom=3D778 headlen=3D134 tailroom=3D=
31536
> >>                 mac=3D(778,14) net=3D(792,20) trans=3D812
> >>                 shinfo(txflags=3D0 nr_frags=3D0 gso(size=3D568 type=3D=
0 segs=3D1))
> >>                 csum(0x0 ip_summed=3D1 complete_sw=3D0 valid=3D0 level=
=3D0)
> >>                 hash(0x0 sw=3D0 l4=3D0) proto=3D0x0800 pkttype=3D0 iif=
=3D4
> >> [236222.967297] dev name=3Denp1s0 feat=3D0x0x00000100000041b2
> >> [236222.967392] skb linear:   00000000: 00 13 3b a0 01 e8 7c d3 0a 2d =
1b 3b 08 00 45 00
> >> [236222.967404] skb linear:   00000010: 00 78 e2 e6 00 00 7b 06 52 e1 =
d8 3a d0 ce c0 a8
> >> [236222.967415] skb linear:   00000020: a0 06 01 bb 8b c6 53 91 be 5e =
6e 60 bd e2 80 18
> >> [236222.967426] skb linear:   00000030: 01 13 5c f6 00 00 01 01 08 0a =
3d d6 6a a3 63 ea
> >> [236222.967437] skb linear:   00000040: 5c d9 17 03 03 00 3f af 00 01 =
84 45 e2 36 e4 6a
> >> [236222.967454] skb linear:   00000050: 3d 76 a8 7f d7 12 fa 72 4b d1 =
d0 74 0d c1 49 77
> >> [236222.967466] skb linear:   00000060: 8b a4 bb 04 e5 aa 03 61 d3 e6 =
1f c9 0d 3e 46 c8
> >> [236222.967477] skb linear:   00000070: cd 1f 7d ce e8 a7 84 84 01 5d =
1f b4 ee 4f 27 63
> >> [236222.967488] skb linear:   00000080: d2 a1 ab 1f 26 1d
> >>
> >>
> >>
> >>>
> >>> Nothing in GRO stack will change gso_size, unless the packet is queue=
d
> >>> by GRO layer (after this, napi_reuse_skb() wont be called)
> >>>
> >>> napi_reuse_skb() is only used when a packet has been aggregated to
> >>> another, and at this point gso_size should be still 0.
> >>>
> >>
>
