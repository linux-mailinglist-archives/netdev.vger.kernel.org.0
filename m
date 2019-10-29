Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 418D9E91FE
	for <lists+netdev@lfdr.de>; Tue, 29 Oct 2019 22:23:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728437AbfJ2VXq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 17:23:46 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:35806 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726747AbfJ2VXq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Oct 2019 17:23:46 -0400
Received: by mail-qk1-f194.google.com with SMTP id h6so448758qkf.2
        for <netdev@vger.kernel.org>; Tue, 29 Oct 2019 14:23:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ysr/qfmSLr/tceeotw69O5DlOYyzVxvzvinAFelwa8w=;
        b=DQUyIxxhkw4GoIJZAzvL5JtaMslraUVmZSD7pfheJInewtpnUPqgbY+wSdds6v5iDs
         4LHHJXLbbwhDzrPBTdVGZdkmiRDAhpoecHh+o0mBNN4nZBJEI6JyDGCTicuxV+F2mNZ4
         CoD76s1N8Nf50WBiK9hIbV++iRtQ/EoRWsDLc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ysr/qfmSLr/tceeotw69O5DlOYyzVxvzvinAFelwa8w=;
        b=tStC4VDGBK2TGts0L6ssbnS74m2P/e1b3YpONF0iRJV76rMlIMG4gCN3tVFvgB5MET
         nB7B4AvAAw7EdCZdIJznTAUlInE+Gv1KLG71HbCQ9W43ntxYEd4xQrdG7xvoUeMS1tZ/
         LSNHSnPvNNTSAetgzx81Vg72T3P9EzQQKdOH7amS/FXHkC/4BYQCia0TcNhws+J0JU8L
         ivmRYgTb/RrB/Tn63MkURwUL3toWrsFj2mpiu2/TMbchT+VykX6Pi4yxcubT4rb5Mb8/
         iMWgdP15PBnMMW9Q2ce7ev/LIMzrCRspw6Rt9qf2SSEWPzTk5OCVWutiNRyRvfob06nP
         WTlA==
X-Gm-Message-State: APjAAAVy/5sptGb4VPMpEiCH07U6eXuBAtZj1Dj8c7OBvZPTb6TbZgqh
        jQG8n/B6xCjgALWi3PMatZ3MJE1v3rYsRifGWnbEMw==
X-Google-Smtp-Source: APXvYqyn8zxCAply/fPHiMqjd5ehuRyekD3cJ64xxhV2mU7GpTQUw3CH6EpwdUK+kF4VIfMrQT7Tf/TKUIbJhtRlt8s=
X-Received: by 2002:a37:9c52:: with SMTP id f79mr9892798qke.163.1572384224103;
 Tue, 29 Oct 2019 14:23:44 -0700 (PDT)
MIME-Version: 1.0
References: <CABWYdi1QmrHxNZT_DK4A2WUoj=r1+wxSngzaaTuGCatHisaTRw@mail.gmail.com>
 <CANn89iLE-3zxROxGOusPBRmQL4oN2Nqtg3rqXnpO8bkiFAw8EQ@mail.gmail.com>
 <CABWYdi2Eq30vEKKYxr-diofpeATNXiB3ZYKL6Q15y10w+vsCLg@mail.gmail.com>
 <CANn89iJYKurw-3-EooE9qyM8-2MzQvCz8qdV91J1hVNxXwsyng@mail.gmail.com>
 <CABWYdi0nmGE6Y+iUkfGvR07zU640Fu4op4EXbCp6ou6GJMcfww@mail.gmail.com>
 <CANn89iKvLFDHPU2W86TfC7jNFW8HM5o8tE8wiRc7E=CRXLT=-Q@mail.gmail.com> <CANn89i+uxbxB8vTWXhOuW4-weP-NO2yFbbs15cJh7+BJtjSSkA@mail.gmail.com>
In-Reply-To: <CANn89i+uxbxB8vTWXhOuW4-weP-NO2yFbbs15cJh7+BJtjSSkA@mail.gmail.com>
From:   Ivan Babrou <ivan@cloudflare.com>
Date:   Tue, 29 Oct 2019 14:23:32 -0700
Message-ID: <CABWYdi2qvpJ4srwFQo=znvsDs2-h7kiR7V++jbNXjCdypS-W5A@mail.gmail.com>
Subject: Re: fq dropping packets between vlan and ethernet interfaces
To:     Eric Dumazet <edumazet@google.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        kernel-team <kernel-team@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

You were right about some non-standard forwarding I forgot about, we
use glb-redirect:

[Tue Oct 29 21:21:00 2019] ------------[ cut here ]------------
[Tue Oct 29 21:21:00 2019] WARNING: CPU: 12 PID: 0 at
net/sched/sch_fq.c:386 fq_enqueue+0x544/0x610 [sch_fq]
[Tue Oct 29 21:21:01 2019] Modules linked in: nf_tables_set
nft_counter nf_tables ip_gre gre veth xfrm_user xfrm_algo xt_connlimit
nf_conncount xt_hashlimit iptable_security sch_ingress sch_fq
ip6table_nat ip6table_mangle ip6table_security ip6table_raw xt_nat
iptable_nat nf_nat xt_TCPMSS xt_TPROXY nf_tproxy_ipv6 nf_tproxy_ipv4
xt_u32 xt_connmark iptable_mangle xt_owner xt_CT xt_socket
nf_socket_ipv4 nf_socket_ipv6 iptable_raw xt_bpf ipt_REJECT
nf_reject_ipv4 ip6table_filter ip6_tables nfnetlink_log xt_NFLOG
xt_comment xt_conntrack xt_mark xt_multiport xt_set xt_tcpudp
ipt_GLBREDIRECT(O) fou ip6_udp_tunnel udp_tunnel iptable_filter
bpfilter ip_set_hash_netport ip_set_hash_net ip_set_hash_ip ip_set
nfnetlink md_mod dm_crypt algif_skcipher af_alg dm_mod dax sit ipip
tunnel4 ip_tunnel tun nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 8021q
garp stp mrp llc ses enclosure sb_edac x86_pkg_temp_thermal kvm_intel
kvm irqbypass crc32_pclmul crc32c_intel aesni_intel glue_helper
crypto_simd cryptd
[Tue Oct 29 21:21:01 2019]  intel_cstate ipmi_ssif mpt3sas
intel_uncore raid_class sfc(O) igb ipmi_si scsi_transport_sas
i2c_algo_bit intel_rapl_perf ipmi_devintf mdio dca ipmi_msghandler
efivarfs ip_tables x_tables
[Tue Oct 29 21:21:01 2019] CPU: 12 PID: 0 Comm: swapper/12 Tainted: G
         O      5.4.0-rc5-cloudflare-2019.10.16 #2019.10.16
[Tue Oct 29 21:21:01 2019] Hardware name: Quanta
S210-X22RQ/S210-X22RQ, BIOS S2RQ3A27 10/31/2013
[Tue Oct 29 21:21:01 2019] RIP: 0010:fq_enqueue+0x544/0x610 [sch_fq]
[Tue Oct 29 21:21:01 2019] Code: e8 c1 ba f5 e7 45 85 ff 75 d4 49 8b
6d 00 e9 ec fb ff ff 48 83 83 30 02 00 00 01 e9 fa fc ff ff 4c 89 fa
31 c0 e9 c2 fc ff ff <0f> 0b e9 72 fc ff ff 41 8b 46 08 39 45 28 0f 84
09 fc ff ff 8b 83
[Tue Oct 29 21:21:01 2019] RSP: 0018:ffffa53c06604338 EFLAGS: 00010202
[Tue Oct 29 21:21:01 2019] RAX: 00000006fc23ac00 RBX: ffff998717cafc00
RCX: 0000000000000017
[Tue Oct 29 21:21:01 2019] RDX: 15d23af8c069e56c RSI: 15d2397b4f4a52fe
RDI: ffffffffa941dc60
[Tue Oct 29 21:21:01 2019] RBP: ffff9980509d1718 R08: ffff998717cafcac
R09: 0000000000000052
[Tue Oct 29 21:21:01 2019] R10: ffff99972da40000 R11: ffff99872caee04c
R12: ffff99871774d800
[Tue Oct 29 21:21:01 2019] R13: ffff9986fa874888 R14: 00000000000001c3
R15: ffff9980509d1700
[Tue Oct 29 21:21:01 2019] FS:  0000000000000000(0000)
GS:ffff99873f980000(0000) knlGS:0000000000000000
[Tue Oct 29 21:21:01 2019] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[Tue Oct 29 21:21:01 2019] CR2: 00007f5c5f08e018 CR3: 0000001df8e0a006
CR4: 00000000000606e0
[Tue Oct 29 21:21:01 2019] Call Trace:
[Tue Oct 29 21:21:01 2019]  <IRQ>
[Tue Oct 29 21:21:01 2019]  ? nf_conntrack_tuple_taken+0x52/0x1f0 [nf_conntrack]
[Tue Oct 29 21:21:01 2019]  ? netdev_pick_tx+0xd6/0x210
[Tue Oct 29 21:21:01 2019]  __dev_queue_xmit+0x451/0x960
[Tue Oct 29 21:21:01 2019]  ? packet_rcv+0x34c/0x460
[Tue Oct 29 21:21:01 2019]  vlan_dev_hard_start_xmit+0x8e/0x100 [8021q]
[Tue Oct 29 21:21:01 2019]  dev_hard_start_xmit+0x8d/0x1e0
[Tue Oct 29 21:21:01 2019]  __dev_queue_xmit+0x712/0x960
[Tue Oct 29 21:21:01 2019]  ?
nf_ct_del_from_dying_or_unconfirmed_list+0x32/0x70 [nf_conntrack]
[Tue Oct 29 21:21:01 2019]  ? eth_header+0x26/0xc0
[Tue Oct 29 21:21:01 2019]  ip_finish_output2+0x198/0x550
[Tue Oct 29 21:21:01 2019]  ip_output+0x71/0xf0
[Tue Oct 29 21:21:01 2019]  ? __ip_finish_output+0x1c0/0x1c0
[Tue Oct 29 21:21:01 2019]
glbredirect_handle_inner_tcp_generic+0x331/0x790 [ipt_GLBREDIRECT]
[Tue Oct 29 21:21:01 2019]  glbredirect_tg4+0x2ad/0x5c0 [ipt_GLBREDIRECT]
[Tue Oct 29 21:21:01 2019]  ? efx_enqueue_skb+0x501/0xa30 [sfc]
[Tue Oct 29 21:21:01 2019]  ? bpf_sk_storage_clone+0x48/0x1b0
[Tue Oct 29 21:21:01 2019]  ? packet_rcv+0x43/0x460
[Tue Oct 29 21:21:01 2019]  ? efx_hard_start_xmit+0x59/0xe0 [sfc]
[Tue Oct 29 21:21:01 2019]  ? dev_hard_start_xmit+0x8d/0x1e0
[Tue Oct 29 21:21:01 2019]  ? select_idle_sibling+0x22/0x550
[Tue Oct 29 21:21:01 2019]  ? efx_farch_msi_interrupt+0x77/0x90 [sfc]
[Tue Oct 29 21:21:01 2019]  ? efx_farch_tx_write+0x170/0x170 [sfc]
[Tue Oct 29 21:21:01 2019]  ? efx_tx_map_chunk+0x47/0x80 [sfc]
[Tue Oct 29 21:21:01 2019]  ? efx_enqueue_skb+0x501/0xa30 [sfc]
[Tue Oct 29 21:21:01 2019]  ? packet_rcv+0x43/0x460
[Tue Oct 29 21:21:01 2019]  ? fib4_rule_action+0x65/0x70
[Tue Oct 29 21:21:01 2019]  ? fib4_rule_fill+0x100/0x100
[Tue Oct 29 21:21:01 2019]  ? fib_rules_lookup+0x143/0x1a0
[Tue Oct 29 21:21:01 2019]  ? __fib_lookup+0x6b/0xb0
[Tue Oct 29 21:21:01 2019]  ? __fib_validate_source+0x1dd/0x430
[Tue Oct 29 21:21:01 2019]  ? fib4_rule_action+0x65/0x70
[Tue Oct 29 21:21:01 2019]  ? fib4_rule_fill+0x100/0x100
[Tue Oct 29 21:21:01 2019]  ? fib_rules_lookup+0x143/0x1a0
[Tue Oct 29 21:21:01 2019]  ? fib_validate_source+0x47/0xf0
[Tue Oct 29 21:21:01 2019]  ? ipt_do_table+0x306/0x640 [ip_tables]
[Tue Oct 29 21:21:01 2019]  ipt_do_table+0x306/0x640 [ip_tables]
[Tue Oct 29 21:21:01 2019]  ? ipt_do_table+0x351/0x640 [ip_tables]
[Tue Oct 29 21:21:01 2019]  nf_hook_slow+0x40/0xb0
[Tue Oct 29 21:21:01 2019]  ip_local_deliver+0xd1/0xf0
[Tue Oct 29 21:21:01 2019]  ? ip_protocol_deliver_rcu+0x1b0/0x1b0
[Tue Oct 29 21:21:01 2019]  ip_rcv+0xbc/0xd0
[Tue Oct 29 21:21:01 2019]  ? ip_rcv_finish_core.isra.0+0x390/0x390
[Tue Oct 29 21:21:01 2019]  __netif_receive_skb_one_core+0x80/0x90
[Tue Oct 29 21:21:01 2019]  netif_receive_skb_internal+0x2f/0xa0
[Tue Oct 29 21:21:01 2019]  netif_receive_skb+0x18/0xb0
[Tue Oct 29 21:21:02 2019]  efx_rx_deliver+0x10e/0x1c0 [sfc]
[Tue Oct 29 21:21:02 2019]  __efx_rx_packet+0x393/0x800 [sfc]
[Tue Oct 29 21:21:02 2019]  efx_poll+0x311/0x460 [sfc]
[Tue Oct 29 21:21:02 2019]  net_rx_action+0x13a/0x380
[Tue Oct 29 21:21:02 2019]  __do_softirq+0xe0/0x2ca
[Tue Oct 29 21:21:02 2019]  irq_exit+0xa0/0xb0
[Tue Oct 29 21:21:02 2019]  do_IRQ+0x58/0xe0
[Tue Oct 29 21:21:02 2019]  common_interrupt+0xf/0xf
[Tue Oct 29 21:21:02 2019]  </IRQ>
[Tue Oct 29 21:21:02 2019] RIP: 0010:cpuidle_enter_state+0xb2/0x410
[Tue Oct 29 21:21:02 2019] Code: c5 66 66 66 66 90 31 ff e8 ab 4c 9c
ff 80 7c 24 0b 00 74 12 9c 58 f6 c4 02 0f 85 36 03 00 00 31 ff e8 92
69 a1 ff fb 45 85 e4 <0f> 88 74 02 00 00 4c 2b 2c 24 49 63 cc 48 8d 04
49 48 c1 e0 05 8b
[Tue Oct 29 21:21:02 2019] RSP: 0018:ffffa53c0638be70 EFLAGS: 00000206
ORIG_RAX: ffffffffffffffda
[Tue Oct 29 21:21:02 2019] RAX: ffff99873f9a8d40 RBX: ffffffffa94fcb40
RCX: 000000000000001f
[Tue Oct 29 21:21:02 2019] RDX: 0000000000000000 RSI: 00000000402794b1
RDI: 0000000000000000
[Tue Oct 29 21:21:02 2019] RBP: ffff99873f9b2500 R08: 0000017dd5dc66ea
R09: 000000000000085f
[Tue Oct 29 21:21:02 2019] R10: ffff99873f9a7c80 R11: ffff99873f9a7c60
R12: 0000000000000005
[Tue Oct 29 21:21:02 2019] R13: 0000017dd5dc66ea R14: 0000000000000005
R15: ffff99873bf05b80
[Tue Oct 29 21:21:02 2019]  cpuidle_enter+0x29/0x40
[Tue Oct 29 21:21:02 2019]  do_idle+0x1b8/0x200
[Tue Oct 29 21:21:02 2019]  cpu_startup_entry+0x19/0x20
[Tue Oct 29 21:21:02 2019]  start_secondary+0x143/0x170
[Tue Oct 29 21:21:02 2019]  secondary_startup_64+0xa4/0xb0
[Tue Oct 29 21:21:02 2019] ---[ end trace 47f595949b82e151 ]---

On Tue, Oct 29, 2019 at 11:54 AM Eric Dumazet <edumazet@google.com> wrote:
>
> On Tue, Oct 29, 2019 at 11:41 AM Eric Dumazet <edumazet@google.com> wrote:
> >
> > On Tue, Oct 29, 2019 at 11:35 AM Ivan Babrou <ivan@cloudflare.com> wrote:
> > >
> > > 5.4-rc5 has it, but we still experience the issue.
> >
> > Please refrain from top-posting on netdev@
> >
> > You could try the debug patch I have posted earlier.
> >
> > Something like :
> >
> > diff --git a/net/sched/sch_fq.c b/net/sched/sch_fq.c
> > index 98dd87ce15108cfe1c011da44ba32f97763776c8..2b9697e05115d334fd6d3a2909d5112d04032420
> > 100644
> > --- a/net/sched/sch_fq.c
> > +++ b/net/sched/sch_fq.c
> > @@ -380,9 +380,14 @@ static void flow_queue_add(struct fq_flow *flow,
> > struct sk_buff *skb)
> >  {
> >         struct rb_node **p, *parent;
> >         struct sk_buff *head, *aux;
> > +       u64 now = ktime_get_ns();
> >
> > -       fq_skb_cb(skb)->time_to_send = skb->tstamp ?: ktime_get_ns();
> > -
> > +       if (skb->tstamp) {
> > +               WARN_ON_ONCE(skb->tstamp - now > 30LLU * NSEC_PER_SEC);
>
> Probably needs to use s64 as in :
>
> WARN_ON_ONCE((s64)(skb->tstamp - now) > (s64)(30LLU * NSEC_PER_SEC));
>
> > +               fq_skb_cb(skb)->time_to_send = skb->tstamp;
> > +       } else {
> > +               fq_skb_cb(skb)->time_to_send = now;
> > +       }
> >         head = flow->head;
> >         if (!head ||
> >             fq_skb_cb(skb)->time_to_send >=
> > fq_skb_cb(flow->tail)->time_to_send) {
> >
> >
> > >
> > > On Tue, Oct 29, 2019 at 11:33 AM Eric Dumazet <edumazet@google.com> wrote:
> > > >
> > > > On Tue, Oct 29, 2019 at 11:31 AM Ivan Babrou <ivan@cloudflare.com> wrote:
> > > > >
> > > > > I'm on 5.4-rc5. Let me apply e7a409c3f46cb0dbc7bfd4f6f9421d53e92614a5
> > > > > on top and report back to you.
> > > >
> > > >
> > > > Oops, wrong copy/paste. I really meant this one :
> > > >
> > > > 9669fffc1415bb0c30e5d2ec98a8e1c3a418cb9c net: ensure correct
> > > > skb->tstamp in various fragmenters
> > > >
> > > >
> > > > >
> > > > > On Tue, Oct 29, 2019 at 11:27 AM Eric Dumazet <edumazet@google.com> wrote:
> > > > > >
> > > > > > On Tue, Oct 29, 2019 at 11:20 AM Ivan Babrou <ivan@cloudflare.com> wrote:
> > > > > > >
> > > > > > > Hello,
> > > > > > >
> > > > > > > We're trying to test Linux 5.4 early and hit an issue with FQ.
> > > > > > >
> > > > > > > The relevant part of our network setup involves four interfaces:
> > > > > > >
> > > > > > > * ext0 (ethernet, internet facing)
> > > > > > > * vlan101@ext0 (vlan)
> > > > > > > * int0 (ethernet, lan facing)
> > > > > > > * vlan11@int0 (vlan)
> > > > > > >
> > > > > > > Both int0 and ext0 have fq on them:
> > > > > > >
> > > > > > > qdisc fq 1: dev ext0 root refcnt 65 limit 10000p flow_limit 100p
> > > > > > > buckets 1024 orphan_mask 1023 quantum 3228 initial_quantum 16140
> > > > > > > low_rate_threshold 550Kbit refill_delay 40.0ms
> > > > > > > qdisc fq 8003: dev int0 root refcnt 65 limit 10000p flow_limit 100p
> > > > > > > buckets 1024 orphan_mask 1023 quantum 3028 initial_quantum 15140
> > > > > > > low_rate_threshold 550Kbit refill_delay 40.0ms
> > > > > > >
> > > > > > > The issue itself is that after some time ext0 stops feeding off
> > > > > > > vlan101, which is visible as tcpdump not seeing packets on ext0, while
> > > > > > > they flow over vlan101.
> > > > > > >
> > > > > > > I can see that fq_dequeue does not report any packets:
> > > > > > >
> > > > > > > $ sudo perf record -e qdisc:qdisc_dequeue -aR sleep 1
> > > > > > > hping3 40335 [006] 63920.881016: qdisc:qdisc_dequeue: dequeue
> > > > > > > ifindex=4 qdisc handle=0x10000 parent=0xFFFFFFFF txq_state=0x0
> > > > > > > packets=0 skbaddr=(nil)
> > > > > > > hping3 40335 [006] 63920.881030: qdisc:qdisc_dequeue: dequeue
> > > > > > > ifindex=4 qdisc handle=0x10000 parent=0xFFFFFFFF txq_state=0x0
> > > > > > > packets=0 skbaddr=(nil)
> > > > > > > hping3 40335 [006] 63920.881041: qdisc:qdisc_dequeue: dequeue
> > > > > > > ifindex=4 qdisc handle=0x10000 parent=0xFFFFFFFF txq_state=0x0
> > > > > > > packets=0 skbaddr=(nil)
> > > > > > > hping3 40335 [006] 63920.881070: qdisc:qdisc_dequeue: dequeue
> > > > > > > ifindex=4 qdisc handle=0x10000 parent=0xFFFFFFFF txq_state=0x0
> > > > > > > packets=0 skbaddr=(nil)
> > > > > > >
> > > > > > > Inside of fq_dequeue I'm able to see that we throw away packets in here:
> > > > > > >
> > > > > > > * https://elixir.bootlin.com/linux/v5.4-rc2/source/net/sched/sch_fq.c#L510
> > > > > > >
> > > > > > > The output of tc -s qdisc shows the following:
> > > > > > >
> > > > > > > qdisc fq 1: dev ext0 root refcnt 65 limit 10000p flow_limit 100p
> > > > > > > buckets 1024 orphan_mask 1023 quantum 3228 initial_quantum 16140
> > > > > > > low_rate_threshold 550Kbit refill_delay 40.0ms
> > > > > > >  Sent 4872143400 bytes 8448638 pkt (dropped 201276670, overlimits 0
> > > > > > > requeues 103)
> > > > > > >  backlog 779376b 10000p requeues 103
> > > > > > >   2806 flows (2688 inactive, 118 throttled), next packet delay
> > > > > > > 1572240566653952889 ns
> > > > > > >   354201 gc, 0 highprio, 804560 throttled, 3919 ns latency, 19492 flows_plimit
> > > > > > > qdisc fq 8003: dev int0 root refcnt 65 limit 10000p flow_limit 100p
> > > > > > > buckets 1024 orphan_mask 1023 quantum 3028 initial_quantum 15140
> > > > > > > low_rate_threshold 550Kbit refill_delay 40.0ms
> > > > > > >  Sent 15869093876 bytes 17387110 pkt (dropped 0, overlimits 0 requeues 2817)
> > > > > > >  backlog 0b 0p requeues 2817
> > > > > > >   2047 flows (2035 inactive, 0 throttled)
> > > > > > >   225074 gc, 10 highprio, 102308 throttled, 7525 ns latency
> > > > > > >
> > > > > > > The key part here is probably that next packet delay for ext0 is the
> > > > > > > current unix timestamp in nanoseconds. Naturally, we see this code
> > > > > > > path being executed:
> > > > > > >
> > > > > > > * https://elixir.bootlin.com/linux/v5.4-rc2/source/net/sched/sch_fq.c#L462
> > > > > > >
> > > > > > > Unfortunately, I don't have a reliable reproduction for this issue. It
> > > > > > > appears naturally with some traffic and I can do limited tracing with
> > > > > > > perf and bcc tools while running hping3 to generate packets.
> > > > > > >
> > > > > > > The issue goes away if I replace fq with pfifo_fast on ext0.
> > > > > >
> > > > > > At which commit is your tree  precisely ?
> > > > > >
> > > > > > This sounds like the recent fix we had for fragmented packets.
> > > > > >
> > > > > > e7a409c3f46cb0dbc7bfd4f6f9421d53e92614a5 ipv4: fix IPSKB_FRAG_PMTU
> > > > > > handling with fragmentation
