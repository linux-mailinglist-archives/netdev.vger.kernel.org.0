Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9171B368CAA
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 07:28:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240523AbhDWF24 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 01:28:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229643AbhDWF2z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Apr 2021 01:28:55 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F5F0C061574;
        Thu, 22 Apr 2021 22:28:20 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id f2-20020a17090a4a82b02900c67bf8dc69so593693pjh.1;
        Thu, 22 Apr 2021 22:28:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=/axqALunwK/x/ep+nsjP4YESIodeSuPtKqfsHHOS/H8=;
        b=TIUuVdHv2vVZqJap9HWJYLb54BDEhkM7t/kQDzW2qEI8U6HyP1+pXNlp+YYQxgBjDp
         QIK8VyxwvNO8S58eXBWL+nfaothFt4rqjiLnAbSQLC9LwuKJVuwxY8gLHKOBw7+mxRAO
         LzCkJ9TsTU9FPP97+Ox6n2f2SQFWqwlVoT835poSxdJ8D0xx03Lkus901cRzVNo/AGfg
         aZI/dtXTcSEwiMgErRO1mNWoRdjkBUO22J4hFMKpFcw8WPsIjxHe2cxMvf+bov23njTM
         eMTCsVyRxOUehiI1oYSS253yi6vuq2Kwm4CYL0BmsJdZFJhd9AGky7qFLubvdpEPvxJQ
         RrOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=/axqALunwK/x/ep+nsjP4YESIodeSuPtKqfsHHOS/H8=;
        b=XzX/ciLX9u/pxLTaZT2OJhFEKTa5bf5/1pQfS6U4xH1mxzn+ySDvI/eYq1FfMQcz91
         9tA3ws3hX/d7di8BLeK93A3PlvOgTsGCzXAIiSGBV877qGtdQGpP7DlDn9ItLy+whe8Y
         MEa/IGeYzzB9dqHf/Qcac0TtpccQwlFQNUxHIG1zGFjgTCXeYRQPGToCu8JyEpb6H7RI
         33yZv9hBhqRsyCcXqIjNB3KQqouQVnNPJC6x1Bu73EmeWm2eAFruanHbJ5SZ4jGV0+4i
         SAGZDtlBg6GxCKh+nO5e1XP5dMIg5gzQPeg8dKy8W8lb7lFZrh0M5qLu6T2czgjgvPpP
         bmJA==
X-Gm-Message-State: AOAM531FpunJF4p6owdZ+YZcog0FyMhamZ+YG7HI7TtQvIza5QNYZPPH
        2FwZtijSmCp25M/HzGzwgew/ypndzJREh0FsTo0=
X-Google-Smtp-Source: ABdhPJzs58EFmuc2yhf5/xhmi4ywz9xeBzX117cDJTQ9Wd5/578lp0zWfl/PGz0OORPnwUMXYGAWvXrvqeIXTsYRMcc=
X-Received: by 2002:a17:902:4d:b029:ec:94df:c9aa with SMTP id
 71-20020a170902004db02900ec94dfc9aamr2124544pla.7.1619155699463; Thu, 22 Apr
 2021 22:28:19 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1617885385.git.lorenzo@kernel.org> <CAJ8uoz1MOYLzyy7xXq_fmpKDEakxSomzfM76Szjr5gWsqHc9jQ@mail.gmail.com>
 <20210418181801.17166935@carbon> <CAJ8uoz0m8AAJFddn2LjehXtdeGS0gat7dwOLA_-_ZeOVYjBdxw@mail.gmail.com>
 <YH0pdXXsZ7IELBn3@lore-desk> <CAJ8uoz101VZiwuvM-bs4UdW+kFT5xjgdgUwPWHZn4ABEOkyQ-w@mail.gmail.com>
 <20210421144747.33c5f51f@carbon> <CAJ8uoz3ROiPn+-bh7OjFOjXjXK9xGhU5cxWoFPM9JoYeh=zw=g@mail.gmail.com>
 <20210421173921.23fef6a7@carbon> <CAJ8uoz2JpfdjvjJp-vjWuhw5z1=2D32jj-KktFnLN6Zd9ZVmAQ@mail.gmail.com>
 <20210422164223.77870d28@carbon> <20210422170508.22c58226@carbon>
In-Reply-To: <20210422170508.22c58226@carbon>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Fri, 23 Apr 2021 07:28:08 +0200
Message-ID: <CAJ8uoz1oEa6ZEp3QKZiPx4oUtt9-nuY4Sh6PVrEnZdu-d_PudQ@mail.gmail.com>
Subject: Re: Crash for i40e on net-next (was: [PATCH v8 bpf-next 00/14]
 mvneta: introduce XDP multi-buffer support)
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        Eelco Chaudron <echaudro@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Saeed Mahameed <saeed@kernel.org>,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        Tirthendu <tirthendu.sarkar@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 22, 2021 at 5:05 PM Jesper Dangaard Brouer
<brouer@redhat.com> wrote:
>
> On Thu, 22 Apr 2021 16:42:23 +0200
> Jesper Dangaard Brouer <brouer@redhat.com> wrote:
>
> > On Thu, 22 Apr 2021 12:24:32 +0200
> > Magnus Karlsson <magnus.karlsson@gmail.com> wrote:
> >
> > > On Wed, Apr 21, 2021 at 5:39 PM Jesper Dangaard Brouer
> > > <brouer@redhat.com> wrote:
> > > >
> > > > On Wed, 21 Apr 2021 16:12:32 +0200
> > > > Magnus Karlsson <magnus.karlsson@gmail.com> wrote:
> > > >
> > [...]
> > > > > more than I get.
> > > >
> > > > I clearly have a bug in the i40e driver.  As I wrote later, I don't=
 see
> > > > any packets transmitted for XDP_TX.  Hmm, I using Mel Gorman's tree=
,
> > > > which contains the i40e/ice/ixgbe bug we fixed earlier.
> >
> > Something is wrong with i40e, I changed git-tree to net-next (at
> > commit 5d869070569a) and XDP seems to have stopped working on i40e :-(

Found this out too when switching to the net tree yesterday to work on
proper packet drop tracing as you spotted/requested yesterday. The
commit below completely broke XDP support on i40e (if you do not run
with a zero-copy AF_XDP socket because that path still works). I am
working on a fix that does not just revert the patch, but fixes the
original problem without breaking XDP. Will post it and the tracing
fixes as soon as I can.

commit 12738ac4754ec92a6a45bf3677d8da780a1412b3
Author: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
Date:   Fri Mar 26 19:43:40 2021 +0100

    i40e: Fix sparse errors in i40e_txrx.c

    Remove error handling through pointers. Instead use plain int
    to return value from i40e_run_xdp(...).

    Previously:
    - sparse errors were produced during compilation:
    i40e_txrx.c:2338 i40e_run_xdp() error: (-2147483647) too low for ERR_PT=
R
    i40e_txrx.c:2558 i40e_clean_rx_irq() error: 'skb' dereferencing
possible ERR_PTR()

    - sk_buff* was used to return value, but it has never had valid
    pointer to sk_buff. Returned value was always int handled as
    a pointer.

    Fixes: 0c8493d90b6b ("i40e: add XDP support for pass and drop actions")
    Fixes: 2e6893123830 ("i40e: split XDP_TX tail and XDP_REDIRECT map
flushing")
    Signed-off-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
    Signed-off-by: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
    Tested-by: Dave Switzer <david.switzer@intel.com>
    Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>


> Renamed subj as this is without this patchset applied.
>
> > $ uname -a
> > Linux broadwell 5.12.0-rc7-net-next+ #600 SMP PREEMPT Thu Apr 22 15:13:=
15 CEST 2021 x86_64 x86_64 x86_64 GNU/Linux
> >
> > When I load any XDP prog almost no packets are let through:
> >
> >  [kernel-bpf-samples]$ sudo ./xdp1 i40e2
> >  libbpf: elf: skipping unrecognized data section(16) .eh_frame
> >  libbpf: elf: skipping relo section(17) .rel.eh_frame for section(16) .=
eh_frame
> >  proto 17:          1 pkt/s
> >  proto 0:          0 pkt/s
> >  proto 17:          0 pkt/s
> >  proto 0:          0 pkt/s
> >  proto 17:          1 pkt/s
>
> Trying out xdp_redirect:
>
>  [kernel-bpf-samples]$ sudo ./xdp_redirect i40e2 i40e2
>  input: 7 output: 7
>  libbpf: elf: skipping unrecognized data section(20) .eh_frame
>  libbpf: elf: skipping relo section(21) .rel.eh_frame for section(20) .eh=
_frame
>  libbpf: Kernel error message: XDP program already attached
>  WARN: link set xdp fd failed on 7
>  ifindex 7:       7357 pkt/s
>  ifindex 7:       7909 pkt/s
>  ifindex 7:       7909 pkt/s
>  ifindex 7:       7909 pkt/s
>  ifindex 7:       7909 pkt/s
>  ifindex 7:       7909 pkt/s
>  ifindex 7:       6357 pkt/s
>
> And then it crash (see below) at page_frag_free+0x31 which calls
> virt_to_head_page() with a wrong addr (I guess).  This is called by
> i40e_clean_tx_irq+0xc9.

Did not see a crash myself, just 4 Kpps. But the rings and DMA
mappings got completely mangled by the patch above, so could be the
same cause.

>  $ ./scripts/faddr2line drivers/net/ethernet/intel/i40e/i40e.o i40e_clean=
_tx_irq+0xc9
>  i40e_clean_tx_irq+0xc9/0x440:
>  i40e_clean_tx_irq at /home/jbrouer/git/kernel/net-next/drivers/net/ether=
net/intel/i40e/i40e_txrx.c:976
>
> Which is:
>
>                 /* unmap skb header data */
>  Line:976       dma_unmap_single(tx_ring->dev,
>                                  dma_unmap_addr(tx_buf, dma),
>                                  dma_unmap_len(tx_buf, len),
>                                  DMA_TO_DEVICE);
>
>
> [  935.781751] BUG: unable to handle page fault for address: ffffebde0000=
0008
> [  935.788630] #PF: supervisor read access in kernel mode
> [  935.793766] #PF: error_code(0x0000) - not-present page
> [  935.798906] PGD 0 P4D 0
> [  935.801445] Oops: 0000 [#1] PREEMPT SMP PTI
> [  935.805632] CPU: 4 PID: 113 Comm: kworker/u12:9 Not tainted 5.12.0-rc7=
-net-next+ #600
> [  935.813460] Hardware name: Supermicro Super Server/X10SRi-F, BIOS 2.0a=
 08/01/2016
> [  935.820937] Workqueue: events_unbound call_usermodehelper_exec_work
> [  935.827214] RIP: 0010:page_frag_free+0x31/0x70
> [  935.831656] Code: 00 00 80 48 01 c7 72 55 48 b8 00 00 00 80 7f 77 00 0=
0 48 01 c7 48 b8 00 00 00 00 00 ea ff ff 48 c1 ef 0c 48 c1 e7 06 48 01 c7 <=
48> 8b 47 08 48 8d 50 ff a8 01 48 0f 45 fa f0 ff 4f 34 74 01 c3 48
> [  935.850406] RSP: 0018:ffffc900001c0e50 EFLAGS: 00010286
> [  935.855629] RAX: ffffea0000000000 RBX: ffff88813b258180 RCX: 000000000=
0000000
> [  935.862764] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffebde0=
0000000
> [  935.869895] RBP: ffff88813b258180 R08: ffffc900001c0f38 R09: 000000000=
0000180
> [  935.877028] R10: 00000000fffffe18 R11: ffffc900001c0ff8 R12: ffff88813=
bc403c0
> [  935.884160] R13: 000000000000003c R14: 00000000fffffe18 R15: ffff88813=
b15b180
> [  935.891295] FS:  0000000000000000(0000) GS:ffff88887fd00000(0000) knlG=
S:0000000000000000
> [  935.899380] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  935.905126] CR2: ffffebde00000008 CR3: 000000087e810002 CR4: 000000000=
03706e0
> [  935.912259] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 000000000=
0000000
> [  935.919391] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 000000000=
0000400
> [  935.926526] Call Trace:
> [  935.928980]  <IRQ>
> [  935.930999]  i40e_clean_tx_irq+0xc9/0x440 [i40e]
> [  935.935653]  i40e_napi_poll+0x101/0x410 [i40e]
> [  935.940116]  __napi_poll+0x2a/0x140
> [  935.943607]  net_rx_action+0x215/0x2d0
> [  935.947358]  ? i40e_msix_clean_rings+0x3f/0x50 [i40e]
> [  935.952449]  __do_softirq+0xe3/0x2df
> [  935.956028]  irq_exit_rcu+0xa7/0xb0
> [  935.959519]  common_interrupt+0x83/0xa0
> [  935.963358]  </IRQ>
> [  935.965465]  asm_common_interrupt+0x1e/0x40
> [  935.969651] RIP: 0010:clear_page_erms+0x7/0x10
> [  935.974096] Code: 48 89 47 18 48 89 47 20 48 89 47 28 48 89 47 30 48 8=
9 47 38 48 8d 7f 40 75 d9 90 c3 0f 1f 80 00 00 00 00 b9 00 10 00 00 31 c0 <=
f3> aa c3 cc cc cc cc cc cc 0f 1f 44 00 00 48 85 ff 0f 84 f2 00 00
> [  935.992845] RSP: 0018:ffffc900003bfbc8 EFLAGS: 00010246
> [  935.998069] RAX: 0000000000000000 RBX: 0000000000000901 RCX: 000000000=
0000340
> [  936.005202] RDX: 0000000000002dc2 RSI: 0000000000000000 RDI: ffff88813=
b4d8cc0
> [  936.012334] RBP: ffffea0004ed3600 R08: ffff88887c625f00 R09: ffffea000=
4ed3600
> [  936.019467] R10: ffff888000000000 R11: 0000160000000000 R12: ffffea000=
4ed3640
> [  936.026600] R13: 0000000000000000 R14: 0000000000005c39 R15: ffffc9000=
03bfc50
> [  936.033738]  prep_new_page+0x88/0xe0
> [  936.037313]  get_page_from_freelist+0x2c6/0x3d0
> [  936.041847]  __alloc_pages_nodemask+0x137/0x2e0
> [  936.046380]  __vmalloc_node_range+0x14f/0x270
> [  936.050738]  copy_process+0x39d/0x1ad0
> [  936.054491]  ? kernel_clone+0x8b/0x3c0
> [  936.058244]  kernel_clone+0x8b/0x3c0
> [  936.061822]  ? dequeue_entity+0xc0/0x270
> [  936.065748]  kernel_thread+0x47/0x50
> [  936.069329]  ? umh_complete+0x40/0x40
> [  936.072992]  call_usermodehelper_exec_work+0x2f/0x90
> [  936.077960]  process_one_work+0x1ad/0x380
> [  936.081974]  worker_thread+0x50/0x390
> [  936.085638]  ? process_one_work+0x380/0x380
> [  936.089824]  kthread+0x116/0x150
> [  936.093057]  ? kthread_park+0x90/0x90
> [  936.096722]  ret_from_fork+0x22/0x30
> [  936.100307] Modules linked in: veth nf_defrag_ipv6 nf_defrag_ipv4 tun =
bridge stp llc rpcrdma sunrpc rdma_ucm ib_umad coretemp rdma_cm ib_ipoib kv=
m_intel iw_cm ib_cm kvm mlx5_ib i40iw irqbypass ib_uverbs rapl intel_cstate=
 intel_uncore ib_core pcspkr i2c_i801 bfq i2c_smbus acpi_ipmi wmi ipmi_si i=
pmi_devintf ipmi_msghandler acpi_pad sch_fq_codel sd_mod t10_pi ixgbe igb i=
gc mdio mlx5_core i40e mlxfw nfp psample i2c_algo_bit ptp i2c_core pps_core=
 hid_generic [last unloaded: bpfilter]
> [  936.142697] CR2: ffffebde00000008
> [  936.146015] ---[ end trace 1bffa979f2cccd16 ]---
> [  936.156720] RIP: 0010:page_frag_free+0x31/0x70
> [  936.161170] Code: 00 00 80 48 01 c7 72 55 48 b8 00 00 00 80 7f 77 00 0=
0 48 01 c7 48 b8 00 00 00 00 00 ea ff ff 48 c1 ef 0c 48 c1 e7 06 48 01 c7 <=
48> 8b 47 08 48 8d 50 ff a8 01 48 0f 45 fa f0 ff 4f 34 74 01 c3 48
> [  936.179919] RSP: 0018:ffffc900001c0e50 EFLAGS: 00010286
> [  936.185140] RAX: ffffea0000000000 RBX: ffff88813b258180 RCX: 000000000=
0000000
> [  936.192275] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffebde0=
0000000
> [  936.199407] RBP: ffff88813b258180 R08: ffffc900001c0f38 R09: 000000000=
0000180
> [  936.206541] R10: 00000000fffffe18 R11: ffffc900001c0ff8 R12: ffff88813=
bc403c0
> [  936.213673] R13: 000000000000003c R14: 00000000fffffe18 R15: ffff88813=
b15b180
> [  936.220804] FS:  0000000000000000(0000) GS:ffff88887fd00000(0000) knlG=
S:0000000000000000
> [  936.228893] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  936.234638] CR2: ffffebde00000008 CR3: 000000087e810002 CR4: 000000000=
03706e0
> [  936.241771] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 000000000=
0000000
> [  936.248903] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 000000000=
0000400
> [  936.256036] Kernel panic - not syncing: Fatal exception in interrupt
> [  936.262401] Kernel Offset: disabled
> [  936.271867] ---[ end Kernel panic - not syncing: Fatal exception in in=
terrupt ]---
>
>
> --
> Best regards,
>   Jesper Dangaard Brouer
>   MSc.CS, Principal Kernel Engineer at Red Hat
>   LinkedIn: http://www.linkedin.com/in/brouer
>
