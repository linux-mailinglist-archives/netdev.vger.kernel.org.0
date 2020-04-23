Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DE991B5F0C
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 17:24:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729107AbgDWPYH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 11:24:07 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:50176 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729024AbgDWPYG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Apr 2020 11:24:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587655444;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iib8ZLJ+ytRy3kWHRd/K99vFN9tRiXM+hYpl8MLO10s=;
        b=gXXagS+oPJwGuxdLnAzXuoWXlqHTewUuL29rmqB6591iNCiO3DA+IcQVcVoOtxgoKUSdCV
        UtK69ds5nYQjP8YTYJYw+j0l615guKa8Tmow9Uk7A8JWAP6Udlzzs4H1uGuJeHNRFPleuZ
        WrzTvf9Idyhfjv+utQIb4J+NRxrUg/Q=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-177-kB69WM3nN7CKCOU3vKHI5g-1; Thu, 23 Apr 2020 11:24:02 -0400
X-MC-Unique: kB69WM3nN7CKCOU3vKHI5g-1
Received: by mail-lf1-f71.google.com with SMTP id h12so2446380lfk.22
        for <netdev@vger.kernel.org>; Thu, 23 Apr 2020 08:24:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=iib8ZLJ+ytRy3kWHRd/K99vFN9tRiXM+hYpl8MLO10s=;
        b=VPRsahj1AxT8vztj9W+Rtrba/J/1MNqfWx2TouoorOEKQ2u8hzDiCHkHvCatT8V52N
         SmzKxwxUeiOqblB2BfI6rqoMtFSLgRl0eBoODaivcWjuNP/tjCHNBTmLE0IJvRac4rsu
         Ak4mDnIPoluebJA09Pq2DizKFLuNPW57tDfFm3q50KOrH6dfLdukSo/nGXPigK1wqors
         U30ewtTdc8kQNTjjHCi+pE0kuoT78/PL4CmAa+pfrB7Aa9D0WlFxmwmBCyApAbvwFZ7A
         PIN0IKmMZdQJE1rDRPXlMFEYYlXurDUxiE5ZTK4F9hym7CMFN19Llr5qaUwSanQenMzJ
         +odg==
X-Gm-Message-State: AGi0PubfCpOnor/MxerfI5pRVSOxhT94KuWPwInk2KIeD0GqRa9WwOdI
        QZHeN834HJyVlThxyVnIEi5P+ifi2+nwDBKcO+Qbez3vC+BAAavYv+gdjRFVaExOCwLqYXZSk3X
        s305yoaBofc2voiN+
X-Received: by 2002:a19:e041:: with SMTP id g1mr2697169lfj.70.1587655438694;
        Thu, 23 Apr 2020 08:23:58 -0700 (PDT)
X-Google-Smtp-Source: APiQypKjZO4h/mwphHVTq6vWlaRUXLnjV1gGlZJxg9Adln/Tq1x/A1zAUPwiewMsW/BK5Dg/3V8fLg==
X-Received: by 2002:a19:e041:: with SMTP id g1mr2697144lfj.70.1587655438357;
        Thu, 23 Apr 2020 08:23:58 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id x24sm2037806lji.52.2020.04.23.08.23.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Apr 2020 08:23:57 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 58C661814FF; Thu, 23 Apr 2020 17:23:56 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     David Ahern <dsahern@gmail.com>, David Ahern <dsahern@kernel.org>,
        netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        prashantbhole.linux@gmail.com, jasowang@redhat.com,
        brouer@redhat.com, toshiaki.makita1@gmail.com,
        daniel@iogearbox.net, john.fastabend@gmail.com, ast@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        David Ahern <dahern@digitalocean.com>
Subject: Re: [PATCH bpf-next 04/16] net: Add BPF_XDP_EGRESS as a bpf_attach_type
In-Reply-To: <6009ff42-5981-6fe7-5b67-30ecbb7d7842@gmail.com>
References: <20200420200055.49033-1-dsahern@kernel.org> <20200420200055.49033-5-dsahern@kernel.org> <87ftcx9mcf.fsf@toke.dk> <856a263f-3bde-70a7-ff89-5baaf8e2240e@gmail.com> <87pnc17yz1.fsf@toke.dk> <073ed1a6-ff5e-28ef-d41d-c33d87135faa@gmail.com> <87k1277om2.fsf@toke.dk> <154e86ee-7e6a-9598-3dab-d7b46cce0967@gmail.com> <875zdr8rrx.fsf@toke.dk> <783d0842-a83f-c22f-25f2-4a86f3924472@gmail.com> <87368v8qnr.fsf@toke.dk> <6009ff42-5981-6fe7-5b67-30ecbb7d7842@gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 23 Apr 2020 17:23:56 +0200
Message-ID: <87d07y6x9v.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

David Ahern <dsahern@gmail.com> writes:

> On 4/22/20 9:51 AM, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> Your patch is relying on the (potentially buggy) behaviour, so I don't
>> think it's out of scope to mention it in this context.
>
> This is getting ridiculous. I am in no way, shape, or form relying on
> freplace.

No, I meant that you're relying on 'expected_attach_type'.

> I guess we'll see tomorrow the outcome of your investigations.

Try this (when running a kernel with your XDP egress patches applied,
obviously):

$ git clone --recurse-submodules -b xdp-egress https://github.com/xdp-proje=
ct/xdp-tools
$ cd xdp-tools && make && cd xdp-loader
$ sudo ./xdp-loader load --egress eth0 xdp-ctx-test.o xdp-ctx-test.o

Leads to an instant kernel crash (well, assuming there's any traffic on
the device, I suppose):

[  804.417699] general protection fault, probably for non-canonical address=
 0x10a18210d14ba9: 0000 [#1] SMP PTI
[  804.427518] CPU: 1 PID: 0 Comm: swapper/1 Not tainted 5.7.0-rc1+ #204
[  804.434053] Hardware name: LENOVO 30B3005DMT/102F, BIOS S00KT56A 01/15/2=
018
[  804.441012] RIP: 0010:bpf_prog_3525d0165d4bca62_xdp_drop_func+0x1d/0xc98
[  804.447704] Code: cc cc cc cc cc cc cc cc cc cc cc cc cc 0f 1f 44 00 00 =
55 48 89 e5 48 81 ec 00 00 00 00 53 41 55 41 56 41 57 6a 00 48 8b 7f 28 <48=
> 8b 7f 00 8b bf 00 01 00 00 b8 01 00 00 00 48 85 ff 74 05 b8 02
[  804.466442] RSP: 0018:ffffb177c007ca38 EFLAGS: 00010286
[  804.471662] RAX: 000000000000dd86 RBX: ffffb177c007cb10 RCX: ffff939cde4=
ae102
[  804.478782] RDX: ffffffffc0bcb680 RSI: ffffb177c016b038 RDI: 0010a18210d=
14ba9
[  804.485903] RBP: ffffb177c007ca60 R08: ffff939cde4ae184 R09: 00000000000=
00001
[  804.493188] R10: ffff939d1c8028c0 R11: ffff939d1c3acf00 R12: ffffb177c01=
6b000
[  804.500307] R13: 0000000000000002 R14: ffffb177c0594000 R15: ffff939cde4=
ae102
[  804.507430] FS:  0000000000000000(0000) GS:ffff939d1fc40000(0000) knlGS:=
0000000000000000
[  804.515510] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  804.521245] CR2: 00007f6705642640 CR3: 000000074860a002 CR4: 00000000003=
606e0
[  804.528374] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000000000=
00000
[  804.535502] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 00000000000=
00400
[  804.542629] Call Trace:
[  804.545076]  <IRQ>
[  804.547096]  bpf_prog_79f73a00e07a6bab_F+0x38/0x980
[  804.551974]  do_xdp_generic_core+0x12b/0x320
[  804.556366]  do_xdp_egress_skb+0x52/0x110
[  804.560376]  dev_hard_start_xmit+0x107/0x220
[  804.564644]  sch_direct_xmit+0xec/0x230
[  804.568481]  __qdisc_run+0x140/0x550
[  804.572058]  __dev_queue_xmit+0x4b3/0x780
[  804.576071]  ip6_finish_output2+0x248/0x5b0
[  804.580254]  ip6_output+0x73/0x120
[  804.583656]  ? __ip6_finish_output+0x100/0x100
[  804.588105]  mld_sendpack+0x1c1/0x230
[  804.591766]  mld_ifc_timer_expire+0x1ab/0x310
[  804.596122]  ? ip6_mc_leave_src+0x90/0x90
[  804.600134]  call_timer_fn+0x2b/0x140
[  804.603796]  __run_timers.part.0+0x16f/0x270
[  804.608068]  ? timerqueue_add+0x96/0xb0
[  804.611902]  ? enqueue_hrtimer+0x36/0x90
[  804.615827]  run_timer_softirq+0x26/0x50
[  804.619877]  __do_softirq+0xe1/0x2fe
[  804.623453]  irq_exit+0xa6/0xb0
[  804.626595]  smp_apic_timer_interrupt+0x68/0x130
[  804.631210]  apic_timer_interrupt+0xf/0x20
[  804.635308]  </IRQ>
[  804.637414] RIP: 0010:cpuidle_enter_state+0xc3/0x400
[  804.642377] Code: e8 b2 02 8b ff 80 7c 24 0f 00 74 17 9c 58 0f 1f 44 00 =
00 f6 c4 02 0f 85 0a 03 00 00 31 ff e8 64 14 91 ff fb 66 0f 1f 44 00 00 <45=
> 85 ed 0f 88 52 02 00 00 49 63 d5 4c 2b 64 24 10 48 8d 04 52 48
[  804.661114] RSP: 0018:ffffb177c00ffe60 EFLAGS: 00000246 ORIG_RAX: ffffff=
ffffffff13
[  804.668674] RAX: ffff939d1fc6c8c0 RBX: ffff939d1fc76708 RCX: 00000000000=
0001f
[  804.675801] RDX: 0000000000000000 RSI: 0000000023a34d57 RDI: 00000000000=
00000
[  804.683035] RBP: ffffffff896e6760 R08: 000000bb4b078647 R09: 00000000000=
00498
[  804.690163] R10: 0000000000000ae9 R11: ffff939d1fc6ba44 R12: 000000bb4b0=
78647
[  804.697283] R13: 0000000000000004 R14: 0000000000000004 R15: ffff939d1fc=
76708
[  804.704409]  cpuidle_enter+0x29/0x40
[  804.707987]  do_idle+0x1ff/0x290
[  804.711216]  cpu_startup_entry+0x19/0x20
[  804.715139]  start_secondary+0x161/0x1c0
[  804.719063]  secondary_startup_64+0xa4/0xb0
[  804.723246] Modules linked in: xt_nat mlx5_ib xt_CHECKSUM iptable_mangle=
 xt_MASQUERADE iptable_nat nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv=
4 xt_tcpudp bridge stp llc iptable_filter binfmt_misc nls_iso8859_1 ib_uver=
bs intel_rapl_msr intel_rapl_common sb_edac x86_pkg_temp_thermal intel_powe=
rclamp coretemp kvm_intel kvm snd_hda_codec_realtek snd_hda_codec_generic s=
nd_hda_codec_hdmi irqbypass mlx5_core snd_hda_intel snd_intel_dspcfg snd_hd=
a_codec snd_hwdep snd_hda_core crct10dif_pclmul crc32_pclmul snd_pcm uas gh=
ash_clmulni_intel usb_storage snd_timer wmi_bmof e1000e snd mei_me mei lpc_=
ich soundcore pata_acpi squashfs mac_hid ib_iser rdma_cm configfs iw_cm ib_=
cm ib_core iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi ip_tables x=
_tables autofs4 raid10 raid456 libcrc32c async_raid6_recov async_memcpy asy=
nc_pq async_xor xor async_tx raid6_pq raid1 raid0 multipath linear nouveau =
video i2c_algo_bit drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_=
fops ttm drm mxm_wmi aesni_intel
[  804.723288]  glue_helper crypto_simd cryptd ahci libahci wmi
[  804.816671] ---[ end trace d70f476e5883fde3 ]---
[  804.866476] RIP: 0010:bpf_prog_3525d0165d4bca62_xdp_drop_func+0x1d/0xc98
[  804.873269] Code: cc cc cc cc cc cc cc cc cc cc cc cc cc 0f 1f 44 00 00 =
55 48 89 e5 48 81 ec 00 00 00 00 53 41 55 41 56 41 57 6a 00 48 8b 7f 28 <48=
> 8b 7f 00 8b bf 00 01 00 00 b8 01 00 00 00 48 85 ff 74 05 b8 02
[  804.892010] RSP: 0018:ffffb177c007ca38 EFLAGS: 00010286
[  804.897236] RAX: 000000000000dd86 RBX: ffffb177c007cb10 RCX: ffff939cde4=
ae102
[  804.904362] RDX: ffffffffc0bcb680 RSI: ffffb177c016b038 RDI: 0010a18210d=
14ba9
[  804.911491] RBP: ffffb177c007ca60 R08: ffff939cde4ae184 R09: 00000000000=
00001
[  804.918622] R10: ffff939d1c8028c0 R11: ffff939d1c3acf00 R12: ffffb177c01=
6b000
[  804.925750] R13: 0000000000000002 R14: ffffb177c0594000 R15: ffff939cde4=
ae102
[  804.932879] FS:  0000000000000000(0000) GS:ffff939d1fc40000(0000) knlGS:=
0000000000000000
[  804.941135] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  804.946876] CR2: 00007f6705642640 CR3: 000000074860a002 CR4: 00000000003=
606e0
[  804.954006] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000000000=
00000
[  804.961134] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 00000000000=
00400
[  804.968265] Kernel panic - not syncing: Fatal exception in interrupt
[  804.974648] Kernel Offset: 0x7000000 from 0xffffffff81000000 (relocation=
 range: 0xffffffff80000000-0xffffffffbfffffff)


The XDP program being loaded (as a multi-prog with freplace) is simply
this:

SEC("xdp_ctx_test")
int xdp_drop_func(struct xdp_md *ctx)
{
        if (ctx->ingress_ifindex > 0)
                return XDP_PASS;

        return XDP_DROP;
}

-Toke

