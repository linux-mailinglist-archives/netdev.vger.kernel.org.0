Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71B5A1F1E58
	for <lists+netdev@lfdr.de>; Mon,  8 Jun 2020 19:30:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387587AbgFHRa2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jun 2020 13:30:28 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:24491 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730742AbgFHRa1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jun 2020 13:30:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591637425;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=CydLNuieMFXuTeLFl9DAS3JoZAu9uEAH3zDcoHjZ+rw=;
        b=DzG7VzadXr+Dq39vXdYFdlnYHitriL24kmKc6Pq12luRG0uVnGCknIdqp7pXwGMEcgdVek
        LO65hHoHYOnpoY6BdfeRhcMuhl2DRJCeBIFEG4KdsYQJJpzmDnyWMoWRa28uUfOpBWnIpn
        Bot9bVfQwKrz3ruY6b2rqXZpewk6mxc=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-464-m0n7FJbUPeycYRbzognzLQ-1; Mon, 08 Jun 2020 13:30:23 -0400
X-MC-Unique: m0n7FJbUPeycYRbzognzLQ-1
Received: by mail-wm1-f70.google.com with SMTP id y15so60678wmi.0
        for <netdev@vger.kernel.org>; Mon, 08 Jun 2020 10:30:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=CydLNuieMFXuTeLFl9DAS3JoZAu9uEAH3zDcoHjZ+rw=;
        b=K/c2vMpJMaQ/Ue2PBlT9k3ludlUqkVOqqPf76W8hhylO8U7T842HFX16uTrozipUjX
         +MgLZN5xwbMWv2shjtLqr2gJLKni7MDR+yCd2PsZQfSHeDM+s0dsWX2Gqhu26TryXFiM
         0Lsdh3g7tGv/Qqhwwc+PurxTSTvU3M0MYG6ab9hEPTRLkxxbpMzB3IFSE859DBvQJZGC
         V04EhlKMPFuVC73Mg0t7/NDihcv1T1ysKscWH53b7xhUhJ1zH0VZJGbGeYYAhXhGdznG
         vsGfiQWoYPK+sbbdofeQaOz6dUFup14BY9vGjmFUCJy8hP1chbtKo0MzkJ+J8nsCgiyi
         PRDA==
X-Gm-Message-State: AOAM533kPsLSGUx7hISTQCuipNSoDqIpws13B+9k4cZkS1kZ65DqbfKl
        o3gh3y+cMM0XfL9DO+fc2m2t955KKfEYVV/ixrbalAG5FhZCBsSCY/cLnOPFpXbJfaRCG1ECbiz
        usdMTJ9v7FtS2WKUX
X-Received: by 2002:a1c:1983:: with SMTP id 125mr370289wmz.43.1591637421981;
        Mon, 08 Jun 2020 10:30:21 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxawQBk2KuedCoeq45qKTknHdFZ/Hzdg0iNXD3UZKIwvVktz96TcUIMIJ1pKhk0TcTZ2sCXUw==
X-Received: by 2002:a1c:1983:: with SMTP id 125mr370264wmz.43.1591637421518;
        Mon, 08 Jun 2020 10:30:21 -0700 (PDT)
Received: from steredhat ([79.49.207.108])
        by smtp.gmail.com with ESMTPSA id v19sm219936wml.26.2020.06.08.10.30.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jun 2020 10:30:20 -0700 (PDT)
Date:   Mon, 8 Jun 2020 19:30:18 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        eperezma@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH RFC v6 00/11] vhost: ring format independence
Message-ID: <20200608173018.2l5wywnscyinf4w7@steredhat>
References: <20200608125238.728563-1-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200608125238.728563-1-mst@redhat.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Michael,

On Mon, Jun 08, 2020 at 08:52:51AM -0400, Michael S. Tsirkin wrote:
> 
> 
> This adds infrastructure required for supporting
> multiple ring formats.
> 
> The idea is as follows: we convert descriptors to an
> independent format first, and process that converting to
> iov later.
> 
> Used ring is similar: we fetch into an independent struct first,
> convert that to IOV later.
> 
> The point is that we have a tight loop that fetches
> descriptors, which is good for cache utilization.
> This will also allow all kind of batching tricks -
> e.g. it seems possible to keep SMAP disabled while
> we are fetching multiple descriptors.
> 
> For used descriptors, this allows keeping track of the buffer length
> without need to rescan IOV.
> 
> This seems to perform exactly the same as the original
> code based on a microbenchmark.
> Lightly tested.
> More testing would be very much appreciated.

while testing the vhost-vsock I found some issues in vhost-net (the VM
had also a virtio-net device).

This is the dmesg of the host (it is a QEMU VM):

[  171.860074] CPU: 0 PID: 16613 Comm: vhost-16595 Not tainted 5.7.0-ste-12703-gaf7b4801030c-dirty #6
[  171.862210] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS ?-20190727_073836-buildvm-ppc64le-16.ppc.fedoraproject.org-3.fc31 04/01/2014
[  171.865998] Call Trace:
[  171.866440]  <IRQ>
[  171.866817]  dump_stack+0x57/0x7a
[  171.867440]  nmi_cpu_backtrace.cold+0x14/0x54
[  171.868233]  ? lapic_can_unplug_cpu.cold+0x3b/0x3b
[  171.869153]  nmi_trigger_cpumask_backtrace+0x85/0x92
[  171.870143]  arch_trigger_cpumask_backtrace+0x19/0x20
[  171.871134]  rcu_dump_cpu_stacks+0xa0/0xd2
[  171.872203]  rcu_sched_clock_irq.cold+0x23a/0x41c
[  171.873098]  update_process_times+0x2c/0x60
[  171.874119]  tick_sched_timer+0x59/0x160
[  171.874777]  ? tick_switch_to_oneshot.cold+0x79/0x79
[  171.875602]  __hrtimer_run_queues+0x10d/0x290
[  171.876317]  hrtimer_interrupt+0x109/0x220
[  171.877025]  smp_apic_timer_interrupt+0x76/0x150
[  171.877875]  apic_timer_interrupt+0xf/0x20
[  171.878563]  </IRQ>
[  171.878897] RIP: 0010:vhost_get_avail_buf+0x5f8/0x860 [vhost]
[  171.879951] Code: 48 8b bb 88 00 00 00 48 85 ff 0f 84 ad 00 00 00 be 01 00 00 00 44 89 45 80 e8 24 52 08 c1 8b 43 68 44 8b 45 80 e9 e9 fb ff ff <45> 85 c0 0f 85 48 fd ff ff 48 8b 43 38 48 83 bb 38 45 00 00 00 48
[  171.889938] RSP: 0018:ffffc90000397c40 EFLAGS: 00000246 ORIG_RAX: ffffffffffffff13
[  171.896828] RAX: 0000000000000040 RBX: ffff88822c3f4688 RCX: ffff888231090000
[  171.898903] RDX: 0000000000000440 RSI: ffff888231090000 RDI: ffffc90000397c80
[  171.901025] RBP: ffffc90000397ce8 R08: 0000000000000001 R09: ffffc90000397dc4
[  171.903136] R10: 000000231edc461f R11: 0000000000000003 R12: 0000000000000001
[  171.905213] R13: 0000000000000001 R14: ffffc90000397dd4 R15: ffff88822c3f87a8
[  171.907553]  get_tx_bufs+0x49/0x180 [vhost_net]
[  171.909142]  handle_tx_copy+0xb4/0x5c0 [vhost_net]
[  171.911495]  ? update_curr+0x67/0x160
[  171.913376]  handle_tx+0xb0/0xe0 [vhost_net]
[  171.916451]  handle_tx_kick+0x15/0x20 [vhost_net]
[  171.919912]  vhost_worker+0xb3/0x110 [vhost]
[  171.923379]  kthread+0x106/0x140
[  171.925314]  ? __vhost_add_used_n+0x1c0/0x1c0 [vhost]
[  171.933388]  ? kthread_park+0x90/0x90
[  171.936148]  ret_from_fork+0x22/0x30
[  234.859212] rcu: INFO: rcu_sched self-detected stall on CPU
[  234.860036] rcu: 	0-....: (20981 ticks this GP) idle=962/1/0x4000000000000002 softirq=15513/15513 fqs=10340
[  234.861547] 	(t=21003 jiffies g=24773 q=2390)
[  234.862158] NMI backtrace for cpu 0
[  234.862638] CPU: 0 PID: 16613 Comm: vhost-16595 Not tainted 5.7.0-ste-12703-gaf7b4801030c-dirty #6
[  234.864008] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS ?-20190727_073836-buildvm-ppc64le-16.ppc.fedoraproject.org-3.fc31 04/01/2014
[  234.866084] Call Trace:
[  234.866395]  <IRQ>
[  234.866648]  dump_stack+0x57/0x7a
[  234.867079]  nmi_cpu_backtrace.cold+0x14/0x54
[  234.867679]  ? lapic_can_unplug_cpu.cold+0x3b/0x3b
[  234.868322]  nmi_trigger_cpumask_backtrace+0x85/0x92
[  234.869013]  arch_trigger_cpumask_backtrace+0x19/0x20
[  234.869747]  rcu_dump_cpu_stacks+0xa0/0xd2
[  234.870267]  rcu_sched_clock_irq.cold+0x23a/0x41c
[  234.870960]  update_process_times+0x2c/0x60
[  234.871578]  tick_sched_timer+0x59/0x160
[  234.872148]  ? tick_switch_to_oneshot.cold+0x79/0x79
[  234.872949]  __hrtimer_run_queues+0x10d/0x290
[  234.873711]  hrtimer_interrupt+0x109/0x220
[  234.874271]  smp_apic_timer_interrupt+0x76/0x150
[  234.874913]  apic_timer_interrupt+0xf/0x20
[  234.876507]  </IRQ>
[  234.876799] RIP: 0010:vhost_get_avail_buf+0x8a/0x860 [vhost]
[  234.877828] Code: 8d 72 06 00 00 85 c0 0f 85 fb 02 00 00 8b 57 70 89 d0 2d 00 04 00 00 0f 88 72 06 00 00 45 31 c0 4c 8d bb 20 41 00 00 4d 89 ee <44> 0f b7 a3 08 01 00 00 66 44 3b a3 0a 01 00 00 0f 84 58 05 00 00
[  234.882059] RSP: 0018:ffffc90000397c40 EFLAGS: 00000283 ORIG_RAX: ffffffffffffff13
[  234.883227] RAX: 0000000000000040 RBX: ffff88822c3f4688 RCX: ffff888231090000
[  234.884317] RDX: 0000000000000440 RSI: ffff888231090000 RDI: ffffc90000397c80
[  234.886531] RBP: ffffc90000397ce8 R08: 0000000000000001 R09: ffffc90000397dc4
[  234.891840] R10: 000000231edc461f R11: 0000000000000003 R12: 0000000000000001
[  234.896670] R13: 0000000000000001 R14: ffffc90000397dd4 R15: ffff88822c3f87a8
[  234.900918]  get_tx_bufs+0x49/0x180 [vhost_net]
[  234.904280]  handle_tx_copy+0xb4/0x5c0 [vhost_net]
[  234.916402]  ? update_curr+0x67/0x160
[  234.917688]  handle_tx+0xb0/0xe0 [vhost_net]
[  234.918865]  handle_tx_kick+0x15/0x20 [vhost_net]
[  234.920366]  vhost_worker+0xb3/0x110 [vhost]
[  234.921500]  kthread+0x106/0x140
[  234.922219]  ? __vhost_add_used_n+0x1c0/0x1c0 [vhost]
[  234.923595]  ? kthread_park+0x90/0x90
[  234.924442]  ret_from_fork+0x22/0x30
[  297.870095] rcu: INFO: rcu_sched self-detected stall on CPU
[  297.871352] rcu: 	0-....: (36719 ticks this GP) idle=962/1/0x4000000000000002 softirq=15513/15513 fqs=18087
[  297.873585] 	(t=36756 jiffies g=24773 q=2853)
[  297.874478] NMI backtrace for cpu 0
[  297.875229] CPU: 0 PID: 16613 Comm: vhost-16595 Not tainted 5.7.0-ste-12703-gaf7b4801030c-dirty #6
[  297.877204] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS ?-20190727_073836-buildvm-ppc64le-16.ppc.fedoraproject.org-3.fc31 04/01/2014
[  297.881644] Call Trace:
[  297.882185]  <IRQ>
[  297.882621]  dump_stack+0x57/0x7a
[  297.883387]  nmi_cpu_backtrace.cold+0x14/0x54
[  297.884390]  ? lapic_can_unplug_cpu.cold+0x3b/0x3b
[  297.885568]  nmi_trigger_cpumask_backtrace+0x85/0x92
[  297.886746]  arch_trigger_cpumask_backtrace+0x19/0x20
[  297.888260]  rcu_dump_cpu_stacks+0xa0/0xd2
[  297.889508]  rcu_sched_clock_irq.cold+0x23a/0x41c
[  297.890803]  update_process_times+0x2c/0x60
[  297.893357]  tick_sched_timer+0x59/0x160
[  297.895143]  ? tick_switch_to_oneshot.cold+0x79/0x79
[  297.897832]  __hrtimer_run_queues+0x10d/0x290
[  297.899841]  hrtimer_interrupt+0x109/0x220
[  297.900909]  smp_apic_timer_interrupt+0x76/0x150
[  297.903543]  apic_timer_interrupt+0xf/0x20
[  297.906509]  </IRQ>
[  297.908004] RIP: 0010:vhost_get_avail_buf+0x92/0x860 [vhost]
[  297.911536] Code: 85 fb 02 00 00 8b 57 70 89 d0 2d 00 04 00 00 0f 88 72 06 00 00 45 31 c0 4c 8d bb 20 41 00 00 4d 89 ee 44 0f b7 a3 08 01 00 00 <66> 44 3b a3 0a 01 00 00 0f 84 58 05 00 00 8b 43 28 83 e8 01 41 21
[  297.930274] RSP: 0018:ffffc90000397c40 EFLAGS: 00000283 ORIG_RAX: ffffffffffffff13
[  297.934056] RAX: 0000000000000040 RBX: ffff88822c3f4688 RCX: ffff888231090000
[  297.938371] RDX: 0000000000000440 RSI: ffff888231090000 RDI: ffffc90000397c80
[  297.944222] RBP: ffffc90000397ce8 R08: 0000000000000001 R09: ffffc90000397dc4
[  297.953817] R10: 000000231edc461f R11: 0000000000000003 R12: 0000000000000001
[  297.956453] R13: 0000000000000001 R14: ffffc90000397dd4 R15: ffff88822c3f87a8
[  297.960873]  get_tx_bufs+0x49/0x180 [vhost_net]
[  297.964163]  handle_tx_copy+0xb4/0x5c0 [vhost_net]
[  297.965871]  ? update_curr+0x67/0x160
[  297.966893]  handle_tx+0xb0/0xe0 [vhost_net]
[  297.968442]  handle_tx_kick+0x15/0x20 [vhost_net]
[  297.971327]  vhost_worker+0xb3/0x110 [vhost]
[  297.974275]  kthread+0x106/0x140
[  297.976141]  ? __vhost_add_used_n+0x1c0/0x1c0 [vhost]
[  297.979518]  ? kthread_park+0x90/0x90
[  297.981665]  ret_from_fork+0x22/0x30

