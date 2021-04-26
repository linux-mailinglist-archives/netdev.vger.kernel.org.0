Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5099936B1D3
	for <lists+netdev@lfdr.de>; Mon, 26 Apr 2021 12:47:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233043AbhDZKsA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Apr 2021 06:48:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232422AbhDZKr6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Apr 2021 06:47:58 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BF11C061756;
        Mon, 26 Apr 2021 03:47:17 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id f11-20020a17090a638bb02901524d3a3d48so4939493pjj.3;
        Mon, 26 Apr 2021 03:47:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=wkc7JiVXKBxq6o/N7RyOQKl4a5ynaa1kh15Cqro+iEU=;
        b=oXVLYn14d1zXhAl+yNbrIPIw2YbxBIszbSUW0lMNkxpdc8gNxg9zCiEM2cGY5s/kd7
         p6kTqN+MBO7N9gQUHU34u1Co6u7id3tR6GV/ZSkNYWRzqXnGuAQ7Z28AjAFg4G2ktn5j
         IiCWBpC6iXH5x7amSswOtyZrqlI9N4S81Hl2zA8fZKw0Da2Q2M9Gox+p3XWN32R7sOik
         bTFILQeqRDraZhHVa73/BI/KJzs0tt2N0xoHVdfEW9z+VpGJMhhxlQCh+AqSTMG+ewhm
         N2Z9Igg0c4BKsN9a0lr/CgRBVp4bqBGtM12xluaaI8t7dGCWOyfOUzb5AAWP0nndGvUg
         Yh+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=wkc7JiVXKBxq6o/N7RyOQKl4a5ynaa1kh15Cqro+iEU=;
        b=prZj7vtK8gWKM9WQVlYavdDY5hS/w7z2Up5EiBzjFS0jODKLFUkkJcPnQwdyvnhsqt
         WU5JqbnNWMMhtbuohLjepdgNhm3EgYfxDSBz9t0p5XQDTyMRa6rbn0iYZmpZ0BhJQriz
         3qsTs3tPee3KgqxIxZEeJAGAmnJQfxvAFZVnE++l0OYUehaNPtVKhoZyej5pCySlvYF3
         2hsce1oqCeXfagpZlhK8/tRJihbOCsEa7NfbwZ4GDn9cJpSSl0RuTZgsw/9A3u9BzCB5
         CZzGTJMhKFoaCmV2qamYqDV0yuZhC5dSc2O9LWrPwarKrRmJjrAnzrkNmybkRNGKpVv7
         ASyQ==
X-Gm-Message-State: AOAM533d19zJfCaJ8bD0o/I61Z7M1IW513ldPrD8F6fiWUJZPsQKhR+V
        YiUBKCTw1LEk9uKI3wnk+LY=
X-Google-Smtp-Source: ABdhPJxxuDTlolVOsaiOzv1xy5v49HmE9ZogeH28UPz0W4LaZIqG/n+Dd+cT3frkAHtr56Fk0zvSNQ==
X-Received: by 2002:a17:90a:5149:: with SMTP id k9mr14189893pjm.52.1619434037007;
        Mon, 26 Apr 2021 03:47:17 -0700 (PDT)
Received: from Leo-laptop-t470s ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id e3sm3969038pjd.18.2021.04.26.03.47.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Apr 2021 03:47:16 -0700 (PDT)
Date:   Mon, 26 Apr 2021 18:47:04 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Jiri Benc <jbenc@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>, ast@kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>
Subject: Re: [PATCHv10 bpf-next 2/4] xdp: extend xdp_redirect_map with
 broadcast support
Message-ID: <20210426104704.GR3465@Leo-laptop-t470s>
References: <20210423020019.2333192-1-liuhangbin@gmail.com>
 <20210423020019.2333192-3-liuhangbin@gmail.com>
 <20210426115350.501cef2a@carbon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210426115350.501cef2a@carbon>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 26, 2021 at 11:53:50AM +0200, Jesper Dangaard Brouer wrote:
> On Fri, 23 Apr 2021 10:00:17 +0800
> Hangbin Liu <liuhangbin@gmail.com> wrote:
> 
> > This patch adds two flags BPF_F_BROADCAST and BPF_F_EXCLUDE_INGRESS to
> > extend xdp_redirect_map for broadcast support.
> > 
> > With BPF_F_BROADCAST the packet will be broadcasted to all the interfaces
> > in the map. with BPF_F_EXCLUDE_INGRESS the ingress interface will be
> > excluded when do broadcasting.
> > 
> > When getting the devices in dev hash map via dev_map_hash_get_next_key(),
> > there is a possibility that we fall back to the first key when a device
> > was removed. This will duplicate packets on some interfaces. So just walk
> > the whole buckets to avoid this issue. For dev array map, we also walk the
> > whole map to find valid interfaces.
> > 
> > Function bpf_clear_redirect_map() was removed in
> > commit ee75aef23afe ("bpf, xdp: Restructure redirect actions").
> > Add it back as we need to use ri->map again.
> > 
> > Here is the performance result by using 10Gb i40e NIC, do XDP_DROP on
> > veth peer, run xdp_redirect_{map, map_multi} in sample/bpf and send pkts
> > via pktgen cmd:
> > ./pktgen_sample03_burst_single_flow.sh -i eno1 -d $dst_ip -m $dst_mac -t 10 -s 64
> 
> While running:
>  $ sudo ./xdp_redirect_map_multi -F i40e2 i40e2
>  Get interfaces 7 7
>  libbpf: elf: skipping unrecognized data section(23) .eh_frame
>  libbpf: elf: skipping relo section(24) .rel.eh_frame for section(23) .eh_frame
>  Forwarding   10140845 pkt/s
>  Forwarding   11767042 pkt/s
>  Forwarding   11783437 pkt/s
>  Forwarding   11767331 pkt/s
> 
> When starting:  sudo ./xdp_monitor --stats

That seems the same issue I reported previously in our meeting.
https://bugzilla.redhat.com/show_bug.cgi?id=1906820#c4

I only saw it 3 times and can't reproduce it easily.

Do you have any idea where is the root cause?

Thanks
Hangbin

> 
> System crashed with:
> 
> [ 5509.997837] BUG: kernel NULL pointer dereference, address: 0000000000000000
> [ 5510.004793] #PF: supervisor read access in kernel mode
> [ 5510.009929] #PF: error_code(0x0000) - not-present page
> [ 5510.015060] PGD 0 P4D 0 
> [ 5510.017591] Oops: 0000 [#1] PREEMPT SMP PTI
> [ 5510.021769] CPU: 3 PID: 29 Comm: ksoftirqd/3 Not tainted 5.12.0-rc7-net-next-hangbin-v10+ #602
> [ 5510.030368] Hardware name: Supermicro Super Server/X10SRi-F, BIOS 2.0a 08/01/2016
> [ 5510.037835] RIP: 0010:perf_trace_xdp_redirect_template+0xba/0x130
> [ 5510.043929] Code: 00 00 00 8b 45 18 74 1e 41 83 f9 19 74 18 45 85 c9 0f 85 83 00 00 00 81 7d 10 ff ff ff 7f 75 7a 89 c1 31 c0 eb 0d 48 8b 75 b8 <48> 8b 16 8b 8a d0 00 00 00 49 8b 55 38 41 b8 01 00 00 00 be 24 00
> [ 5510.062668] RSP: 0018:ffffc9000017fc50 EFLAGS: 00010246
> [ 5510.067884] RAX: 0000000000000000 RBX: ffffe8ffffccf180 RCX: 0000000000000000
> [ 5510.075007] RDX: ffffffff817d1a9b RSI: 0000000000000000 RDI: ffffe8ffffcd8000
> [ 5510.082133] RBP: ffffc9000017fc98 R08: 0000000000000000 R09: 0000000000000019
> [ 5510.089256] R10: 0000000000000000 R11: ffff88887fd2ab70 R12: 0000000000000000
> [ 5510.096382] R13: ffffc900000a5000 R14: ffff88810a8f2000 R15: ffffffff82a7c840
> [ 5510.103505] FS:  0000000000000000(0000) GS:ffff88887fcc0000(0000) knlGS:0000000000000000
> [ 5510.111584] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [ 5510.117319] CR2: 0000000000000000 CR3: 0000000157b1e004 CR4: 00000000003706e0
> [ 5510.124444] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [ 5510.131567] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> [ 5510.138692] Call Trace:
> [ 5510.141141]  xdp_do_redirect+0x16b/0x230
> [ 5510.145064]  i40e_clean_rx_irq+0x62e/0x9a0 [i40e]
> [ 5510.149779]  i40e_napi_poll+0xf0/0x410 [i40e]
> [ 5510.154135]  __napi_poll+0x2a/0x140
> [ 5510.157620]  net_rx_action+0x215/0x2d0
> [ 5510.161364]  __do_softirq+0xe3/0x2df
> [ 5510.164938]  run_ksoftirqd+0x1a/0x20
> [ 5510.168514]  smpboot_thread_fn+0xee/0x1e0
> [ 5510.172519]  ? sort_range+0x20/0x20
> [ 5510.176003]  kthread+0x116/0x150
> [ 5510.179237]  ? kthread_park+0x90/0x90
> [ 5510.182893]  ret_from_fork+0x22/0x30
> [ 5510.186474] Modules linked in: algif_hash af_alg bpf_preload fuse veth nf_defrag_ipv6 nf_defrag_ipv4 tun bridge stp llc rpcrdma sunrpc rdma_ucm ib_umad rdma_cm ib_ipoib coretemp iw_cm kvm_intel ib_cm kvm mlx5_ib i40iw irqbypass ib_uverbs rapl intel_cstate i2c_i801 intel_uncore ib_core pcspkr bfq i2c_smbus acpi_ipmi wmi ipmi_si ipmi_devintf ipmi_msghandler acpi_pad sch_fq_codel mlx5_core mlxfw i40e ixgbe igc psample mdio igb sd_mod ptp t10_pi nfp i2c_algo_bit i2c_core pps_core hid_generic [last unloaded: bpfilter]
> [ 5510.231847] CR2: 0000000000000000
> [ 5510.235164] ---[ end trace b8e076677c53b5e8 ]---
> [ 5510.241762] RIP: 0010:perf_trace_xdp_redirect_template+0xba/0x130
> [ 5510.247851] Code: 00 00 00 8b 45 18 74 1e 41 83 f9 19 74 18 45 85 c9 0f 85 83 00 00 00 81 7d 10 ff ff ff 7f 75 7a 89 c1 31 c0 eb 0d 48 8b 75 b8 <48> 8b 16 8b 8a d0 00 00 00 49 8b 55 38 41 b8 01 00 00 00 be 24 00
> [ 5510.266590] RSP: 0018:ffffc9000017fc50 EFLAGS: 00010246
> [ 5510.271804] RAX: 0000000000000000 RBX: ffffe8ffffccf180 RCX: 0000000000000000
> [ 5510.278931] RDX: ffffffff817d1a9b RSI: 0000000000000000 RDI: ffffe8ffffcd8000
> [ 5510.286053] RBP: ffffc9000017fc98 R08: 0000000000000000 R09: 0000000000000019
> [ 5510.293178] R10: 0000000000000000 R11: ffff88887fd2ab70 R12: 0000000000000000
> [ 5510.300301] R13: ffffc900000a5000 R14: ffff88810a8f2000 R15: ffffffff82a7c840
> [ 5510.307426] FS:  0000000000000000(0000) GS:ffff88887fcc0000(0000) knlGS:0000000000000000
> [ 5510.315503] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [ 5510.321241] CR2: 0000000000000000 CR3: 0000000157b1e004 CR4: 00000000003706e0
> [ 5510.328364] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [ 5510.335490] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> [ 5510.342612] Kernel panic - not syncing: Fatal exception in interrupt
> [ 5510.348994] Kernel Offset: disabled
> [ 5510.354469] ---[ end Kernel panic - not syncing: Fatal exception in interrupt ]---
> 
> [net-next]$ ./scripts/faddr2line vmlinux xdp_do_redirect+0x16b
> xdp_do_redirect+0x16b/0x230:
> trace_xdp_redirect at include/trace/events/xdp.h:136
> (inlined by) trace_xdp_redirect at include/trace/events/xdp.h:136
> (inlined by) xdp_do_redirect at net/core/filter.c:3996
> 
> Decode: perf_trace_xdp_redirect_template+0xba
>  ./scripts/faddr2line vmlinux perf_trace_xdp_redirect_template+0xba
> perf_trace_xdp_redirect_template+0xba/0x130:
> perf_trace_xdp_redirect_template at include/trace/events/xdp.h:89 (discriminator 13)
> 
> less -N net/core/filter.c
>  [...]
>    3993         if (unlikely(err))
>    3994                 goto err;
>    3995 
> -> 3996         _trace_xdp_redirect_map(dev, xdp_prog, fwd, map_type, map_id, ri->tgt_index);
>    3997         return 0;
>    3998 err:
>    3999         _trace_xdp_redirect_map_err(dev, xdp_prog, fwd, map_type, map_id, ri->tgt_index, err);
>    4000         return err;
>    4001 }
>    4002 EXPORT_SYMBOL_GPL(xdp_do_redirect);
> 
> 
> > ---
> >  include/linux/bpf.h            |  20 ++++
> >  include/linux/filter.h         |  18 +++-
> >  include/net/xdp.h              |   1 +
> >  include/uapi/linux/bpf.h       |  17 +++-
> >  kernel/bpf/cpumap.c            |   3 +-
> >  kernel/bpf/devmap.c            | 181 ++++++++++++++++++++++++++++++++-
> >  net/core/filter.c              |  37 ++++++-
> >  net/core/xdp.c                 |  29 ++++++
> >  net/xdp/xskmap.c               |   3 +-
> >  tools/include/uapi/linux/bpf.h |  17 +++-
> >  10 files changed, 312 insertions(+), 14 deletions(-)
> > 
> [...]
> 
> > diff --git a/net/core/filter.c b/net/core/filter.c
> > index cae56d08a670..05ba5ab4345f 100644
> > --- a/net/core/filter.c
> > +++ b/net/core/filter.c
> > @@ -3926,6 +3926,23 @@ void xdp_do_flush(void)
> >  }
> >  EXPORT_SYMBOL_GPL(xdp_do_flush);
> >  
> > +void bpf_clear_redirect_map(struct bpf_map *map)
> > +{
> > +	struct bpf_redirect_info *ri;
> > +	int cpu;
> > +
> > +	for_each_possible_cpu(cpu) {
> > +		ri = per_cpu_ptr(&bpf_redirect_info, cpu);
> > +		/* Avoid polluting remote cacheline due to writes if
> > +		 * not needed. Once we pass this test, we need the
> > +		 * cmpxchg() to make sure it hasn't been changed in
> > +		 * the meantime by remote CPU.
> > +		 */
> > +		if (unlikely(READ_ONCE(ri->map) == map))
> > +			cmpxchg(&ri->map, map, NULL);
> > +	}
> > +}
> > +
> >  int xdp_do_redirect(struct net_device *dev, struct xdp_buff *xdp,
> >  		    struct bpf_prog *xdp_prog)
> >  {
> > @@ -3933,6 +3950,7 @@ int xdp_do_redirect(struct net_device *dev, struct xdp_buff *xdp,
> >  	enum bpf_map_type map_type = ri->map_type;
> >  	void *fwd = ri->tgt_value;
> >  	u32 map_id = ri->map_id;
> > +	struct bpf_map *map;
> >  	int err;
> >  
> >  	ri->map_id = 0; /* Valid map id idr range: [1,INT_MAX[ */
> > @@ -3942,7 +3960,14 @@ int xdp_do_redirect(struct net_device *dev, struct xdp_buff *xdp,
> >  	case BPF_MAP_TYPE_DEVMAP:
> >  		fallthrough;
> >  	case BPF_MAP_TYPE_DEVMAP_HASH:
> > -		err = dev_map_enqueue(fwd, xdp, dev);
> > +		map = READ_ONCE(ri->map);
> > +		if (map) {
> > +			WRITE_ONCE(ri->map, NULL);
> > +			err = dev_map_enqueue_multi(xdp, dev, map,
> > +						    ri->flags & BPF_F_EXCLUDE_INGRESS);
> > +		} else {
> > +			err = dev_map_enqueue(fwd, xdp, dev);
> > +		}
> >  		break;
> >  	case BPF_MAP_TYPE_CPUMAP:
> >  		err = cpu_map_enqueue(fwd, xdp, dev);
> > @@ -3984,13 +4009,21 @@ static int xdp_do_generic_redirect_map(struct net_device *dev,
> >  				       enum bpf_map_type map_type, u32 map_id)
> >  {
> >  	struct bpf_redirect_info *ri = this_cpu_ptr(&bpf_redirect_info);
> > +	struct bpf_map *map;
> >  	int err;
> >  
> >  	switch (map_type) {
> >  	case BPF_MAP_TYPE_DEVMAP:
> >  		fallthrough;
> >  	case BPF_MAP_TYPE_DEVMAP_HASH:
> > -		err = dev_map_generic_redirect(fwd, skb, xdp_prog);
> > +		map = READ_ONCE(ri->map);
> > +		if (map) {
> > +			WRITE_ONCE(ri->map, NULL);
> > +			err = dev_map_redirect_multi(dev, skb, xdp_prog, map,
> > +						     ri->flags & BPF_F_EXCLUDE_INGRESS);
> > +		} else {
> > +			err = dev_map_generic_redirect(fwd, skb, xdp_prog);
> > +		}
> >  		if (unlikely(err))
> >  			goto err;
> >  		break;
> 
> -- 
> Best regards,
>   Jesper Dangaard Brouer
>   MSc.CS, Principal Kernel Engineer at Red Hat
>   LinkedIn: http://www.linkedin.com/in/brouer
> 
