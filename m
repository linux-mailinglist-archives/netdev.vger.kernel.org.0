Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DF2D697818
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 09:25:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233898AbjBOIZ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 03:25:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233893AbjBOIZz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 03:25:55 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A419028205
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 00:25:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676449507;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dLL/jCAxo1iTynmaOCVM0EshLOHE+/3byUzGHaiGWw8=;
        b=Xl1upV6Bm0iiRtekU8dM2XTxJb96USx/ArDFuXvvaqO9BNkm9VhEW7IaP1woJvz0rHV90r
        UR1QA+hBmUvoVyNgx6sJEQphZ6vJ5W2cTW+m5u2E51XZNFGGjIqxGrc8D1j11ac/OWy9S4
        HmK88oG0F3TCHcp0iuKC19qZ1LNjh5g=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-596-PQYeVwGpMIub4PjHM9Bc-g-1; Wed, 15 Feb 2023 03:25:06 -0500
X-MC-Unique: PQYeVwGpMIub4PjHM9Bc-g-1
Received: by mail-ej1-f71.google.com with SMTP id qa17-20020a170907869100b0088ea39742c8so11824227ejc.13
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 00:25:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dLL/jCAxo1iTynmaOCVM0EshLOHE+/3byUzGHaiGWw8=;
        b=rhnp/JEKhaSeHyCoVF30j7AtLQ7TJjo2ylg3JPHIpD/g/r9CYziGYDAmH+ovsZOZvK
         pmZNQfJaYSndhOFo1Zchjo2PNd8lpf97KG1oVOYNHQF1+Dr5ApD8+gKJjKfJ4gToZN/2
         CiU+tXZ4Qnrtcu+e1MP2vMa5jgvhvvWAhgkzNf8O1QC4fonw4aw1KFOENdWGKz+hcHu+
         xHSVPN60eruvOsN8cQBqOZvjAS4srawcyHAlliIhPJuYeupaym5znlRhuXfczcI0+dnw
         PZ3ifSrif++nSiYIffChnyG6KcS9qgIrxBQnc9WrN78qVrG9FRNFyRzKnHr8Z15z3CFu
         6MLQ==
X-Gm-Message-State: AO0yUKUvFVFoD6n3ci5InFrMCVahpP7ySdJprrHNG707fKah71WgiwWV
        IBTtg2Kcexf0hnMFSeSvconpFtHYXIb7rS+ZyYH7MOndfU3LWGHj9uyrAq33GA6dyR0BCHpBk+l
        1aIa2aLc87bX1DL7D9uhYGJks0DedLG9k
X-Received: by 2002:a50:c050:0:b0:4ab:470c:b4a3 with SMTP id u16-20020a50c050000000b004ab470cb4a3mr599873edd.7.1676449504476;
        Wed, 15 Feb 2023 00:25:04 -0800 (PST)
X-Google-Smtp-Source: AK7set/GmkKDYtqV7NGA9sYuMn9pb+nzZeWIYwfXpgPZMpLAxt0mUXovp45ZN+BImiVqhSE1RDvJq4g+bCHEaQfBY50=
X-Received: by 2002:a50:c050:0:b0:4ab:470c:b4a3 with SMTP id
 u16-20020a50c050000000b004ab470cb4a3mr599861edd.7.1676449504224; Wed, 15 Feb
 2023 00:25:04 -0800 (PST)
MIME-Version: 1.0
References: <CA+QYu4qkVzZaB2OTaTLniZB9OCbTYUr2qvvvCmAnMkaq43OOLA@mail.gmail.com>
 <Y+ubkJtpmc6l0gOt@yury-laptop>
In-Reply-To: <Y+ubkJtpmc6l0gOt@yury-laptop>
From:   Bruno Goncalves <bgoncalv@redhat.com>
Date:   Wed, 15 Feb 2023 09:24:52 +0100
Message-ID: <CA+QYu4rBbstxtewRVF2hSaVK1i3-CzifPnchfSaxe_EALhR1rA@mail.gmail.com>
Subject: Re: [6.2.0-rc7] BUG: KASAN: slab-out-of-bounds in hop_cmp+0x26/0x110
To:     Yury Norov <yury.norov@gmail.com>
Cc:     Networking <netdev@vger.kernel.org>, alan.maguire@oracle.com,
        Jakub Kicinski <kuba@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        CKI Project <cki-project@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 14 Feb 2023 at 15:32, Yury Norov <yury.norov@gmail.com> wrote:
>
> On Tue, Feb 14, 2023 at 02:23:06PM +0100, Bruno Goncalves wrote:
> > Hello,
> >
> > recently when testing kernel with debug options set from net-next [1]
> > and bpf-next [2] the following call trace happens:
> >
> Hi Bruno,
>
> Thanks for report.
>
> This looks weird, because the hop_cmp() spent for 3 month in -next till
> now. Anyways, can you please share your NUMA configuration so I'll try
> to reproduce the bug locally? What 'numactl -H' outputs?
>

Here is the output:

numactl -H
available: 4 nodes (0-3)
node 0 cpus: 0 1 2 3 4 5 6 7 32 33 34 35 36 37 38 39
node 0 size: 32063 MB
node 0 free: 31610 MB
node 1 cpus: 8 9 10 11 12 13 14 15 40 41 42 43 44 45 46 47
node 1 size: 32248 MB
node 1 free: 31909 MB
node 2 cpus: 16 17 18 19 20 21 22 23 48 49 50 51 52 53 54 55
node 2 size: 32248 MB
node 2 free: 31551 MB
node 3 cpus: 24 25 26 27 28 29 30 31 56 57 58 59 60 61 62 63
node 3 size: 32239 MB
node 3 free: 31468 MB
node distances:
node   0   1   2   3
  0:  10  21  31  21
  1:  21  10  21  31
  2:  31  21  10  21
  3:  21  31  21  10

Bruno

> Thanks,
> Yury
>
> > [   92.539335] be2net 0000:04:00.0: FW config: function_mode=0x10003,
> > function_caps=0x7
> > [   92.559345] scsi host1: BC_356 : error in cmd completion: Subsystem
> > : 1 Opcode : 191 status(compl/extd)=2/30
> > [   92.560448] scsi host1: BG_1597 : HBA error recovery not supported
> > [   92.587657] be2net 0000:04:00.0: Max: txqs 16, rxqs 17, rss 16, eqs 16, vfs 0
> > [   92.588471] be2net 0000:04:00.0: Max: uc-macs 30, mc-macs 64, vlans 64
> > [   93.731235] be2net 0000:04:00.0: enabled 8 MSI-x vector(s) for NIC
> > [   93.749741] ==================================================================
> > [   93.750521] BUG: KASAN: slab-out-of-bounds in hop_cmp+0x26/0x110
> > [   93.751233] Read of size 8 at addr ffff888104719758 by task kworker/0:2/108
> > [   93.751601]
> > [   93.752087] CPU: 0 PID: 108 Comm: kworker/0:2 Tainted: G          I
> >        6.2.0-rc7 #1
> > [   93.752549] Hardware name: HP ProLiant BL460c Gen8, BIOS I31 11/02/2014
> > [   93.752884] Workqueue: events work_for_cpu_fn
> > [   93.753510] Call Trace:
> > [   93.753687]  <TASK>
> > [   93.754215]  dump_stack_lvl+0x55/0x71
> > [   93.754449]  print_report+0x184/0x4b1
> > [   93.754697]  ? __virt_addr_valid+0xe8/0x160
> > [   93.754972]  ? hop_cmp+0x26/0x110
> > [   93.755533]  kasan_report+0xa5/0xe0
> > [   93.756193]  ? hop_cmp+0x26/0x110
> > [   93.756767]  ? __pfx_hop_cmp+0x10/0x10
> > [   93.756990]  ? hop_cmp+0x26/0x110
> > [   93.757556]  ? __pfx_hop_cmp+0x10/0x10
> > [   93.757774]  ? bsearch+0x53/0x80
> > [   93.758838]  ? sched_numa_find_nth_cpu+0x128/0x360
> > [   93.759492]  ? __pfx_sched_numa_find_nth_cpu+0x10/0x10
> > [   93.759792]  ? alloc_cpumask_var_node+0x38/0x60
> > [   93.760419]  ? rcu_read_lock_sched_held+0x3f/0x80
> > [   93.761060]  ? trace_kmalloc+0x33/0xf0
> > [   93.761306]  ? __kmalloc_node+0x76/0xc0
> > [   93.761528]  ? cpumask_local_spread+0x44/0xc0
> > [   93.762192]  ? be_setup_queues+0x13b/0x3c0 [be2net]
> > [   93.762957]  ? be_setup+0x663/0xa60 [be2net]
> > [   93.763795]  ? __pfx_be_setup+0x10/0x10 [be2net]
> > [   93.764523]  ? is_module_address+0x2b/0x50
> > [   93.764744]  ? is_module_address+0x2b/0x50
> > [   93.764996]  ? static_obj+0x6b/0x80
> > [   93.765865]  ? lockdep_init_map_type+0xcf/0x370
> > [   93.766527]  ? be_probe+0x825/0xcd0 [be2net]
> > [   93.767224]  ? __pfx_be_probe+0x10/0x10 [be2net]
> > [   93.767932]  ? preempt_count_sub+0xb7/0x100
> > [   93.768181]  ? _raw_spin_unlock_irqrestore+0x35/0x60
> > [   93.768450]  ? __pfx_be_probe+0x10/0x10 [be2net]
> > [   93.769162]  ? local_pci_probe+0x77/0xc0
> > [   93.769392]  ? __pfx_local_pci_probe+0x10/0x10
> > [   93.770007]  ? work_for_cpu_fn+0x29/0x40
> > [   93.770253]  ? process_one_work+0x543/0xa20
> > [   93.770490]  ? __pfx_process_one_work+0x10/0x10
> > [   93.797773pin_lock+0x10/0x10
> > [   93.871656]  ? __list_add_valid+0x3f/0x70
> > [   93.871874]  ? move_linked_works+0x103/0x140
> > [   93.872487]  ? worker_thread+0x364/0x630
> > [   93.872704]  ? __kthread_parkme+0xd8/0xf0
> > [   93.872919]  ? __pfx_worker_thread+0x10/0x10
> > [   93.873513]  ? kthread+0x17e/0x1b0
> > [   93.874055]  ? __pfx_kthread+0x10/0x10
> > [   93.874290]  ? ret_from_fork+0x2c/0x50
> > [   93.874541]  </TASK>
> > [   93.874727]
> > [   93.875188] Allocated by task 1:
> > [   93.875733]  kasan_save_stack+0x34/0x60
> > [   93.875942]  kasan_set_track+0x21/0x30
> > [   93.876164]  __kasan_kmalloc+0xa9/0xb0
> > [   93.876373]  __kmalloc+0x57/0xd0
> > [   93.876918]  sched_init_numa+0x21f/0x7e0
> > [   93.877146]  sched_init_smp+0x6d/0x113
> > [   93.877358]  kernel_init_freeable+0x2a3/0x4a0
> > [   93.877993]  kernel_init+0x18/0x160
> > [   93.878592]  ret_from_fork+0x2c/0x50
> > [   93.878811]
> > [   93.879278] The buggy address belongs to the object at ffff888104719760
> > [   93.879278]  which belongs to the cache kmalloc-16 of size 16
> > [   93.879926] The buggy address is located 8 bytes to the left of
> > [   93.879926]  16-byte region [ffff888104719760, ffff888104719770)
> > [   94.363686] flags: 0x17ffffc0000200(slab|node=0|zone=2|lastcpupid=0x1fffff)
> > [   94.381131] raw: 0017ffffc0000200 ffff88810004c580 ffffea000400df50
> > ffffea0004165190
> > [   94.381554] raw: 0000000000000000 00000000001c001c 00000001ffffffff
> > 0000000000000000
> > [   94.381958] page dumped because: kasan: bad access detected
> > [   94.382249]
> > [   94.382710] Memory state around the buggy address:
> > [   94.383319]  ffff888104719600: fc fc fc fc fc fc fc fc fa fb fc fc
> > fc fc fc fc
> > [   94.384066]  ffff888104719680: fc fc fc fc fc fc fc fc fc fc 00 00
> > fc fc fc fc
> > [   94.384841] >ffff888104719700: fc fc fc fc fc fc fc fc fc fc fc fc
> > 00 00 fc fc
> > [   94.385573]                                                     ^
> > [   94.386251]  ffff888104719780: fc fc fc fc fc fc fc fc fc fc fc fc
> > fc fc 00 00
> > [   94.386989]  ffff888104719800: fc fc fc fc fc fc fc fc fc fc fc fc
> > fc fc fc fc
> > [   94.387710] ==================================================================
> >
> > full console log:
> > https://s3.us-east-1.amazonaws.com/arr-cki-prod-datawarehouse-public/datawarehouse-public/3762562309/redhat:776235046/build_x86_64_redhat:776235046-x86_64-kernel-debug/tests/1/results_0001/job.01/recipes/13385613/tasks/5/logs/test_console.log
> >
> > test logs: https://datawarehouse.cki-project.org/kcidb/tests/7075911
> > cki issue tracker: https://datawarehouse.cki-project.org/issue/1896
> >
> > kernel config: https://s3.amazonaws.com/arr-cki-prod-trusted-artifacts/trusted-artifacts/776235046/build%20x86_64%20debug/3762562279/artifacts/kernel-bpf-next-redhat_776235046-x86_64-kernel-debug.config
> > kernel tarball:
> > https://s3.amazonaws.com/arr-cki-prod-trusted-artifacts/trusted-artifacts/776235046/publish%20x86_64%20debug/3762562289/artifacts/kernel-bpf-next-redhat_776235046-x86_64-kernel-debug.tar.gz
> >
> > The first commit we tested that we hit the problem is [3], but we
> > didn't bisect it to know what commit introduced the issue.
> >
> > [1] https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git
> > [2] https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git
> > [3] https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git/commit/?id=0243d3dfe274832aa0a16214499c208122345173
> >
> > Thanks,
> > Bruno Goncalves
>

