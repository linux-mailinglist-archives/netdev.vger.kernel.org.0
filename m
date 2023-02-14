Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58B906966ED
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 15:32:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232901AbjBNOcy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 09:32:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232852AbjBNOcx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 09:32:53 -0500
Received: from mail-oo1-xc36.google.com (mail-oo1-xc36.google.com [IPv6:2607:f8b0:4864:20::c36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D60C1A0;
        Tue, 14 Feb 2023 06:32:51 -0800 (PST)
Received: by mail-oo1-xc36.google.com with SMTP id i21-20020a4ad395000000b00517895ed15dso1539891oos.0;
        Tue, 14 Feb 2023 06:32:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZO4QwoaGp+m/4vwmbAwGzupQ0lcOzVs3mz3QwG9cfcI=;
        b=bq4YBXst99Zz6uOY2whY6vN+liADR8CZyds3TAsEtIERL8jtFL7VjIk/F6CQvHJ/TV
         iWzuPFz+ObFEOZ179cF4VARYPgvLFX96c1Mg+79GFz6UBvoFymBtykYWqcbOdgCXnk+z
         vXqM9szhq5rhyCx6LVYiwNOAih3gZRwC5lu4dXro9TDwOAydFnBxiJC1eCamccQDKK02
         m48WWo1PqUcO0mXdDG0g0lOf9Zipvc36kwFI0nOWadtOMj1QL9KKMhc1iCfuI0H6BSKz
         DIwQ2769agI5/quTxSmjj8Xsx5c4QkRAYsjvLxVzPR7iy6mUPrt2LieP6GhJ+3O5X7GJ
         4ulw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZO4QwoaGp+m/4vwmbAwGzupQ0lcOzVs3mz3QwG9cfcI=;
        b=Lnd5h8IX0iHWztYO5btDKejqPq2EqtdWwFUS8fxiVKgLzkfCLedLhXYbvo1pJLLQT5
         BIq9mL5gv5JQvhAJYgV5GwydLAn96wLyeVg1bOtBxpISWXW0UytgBuOj6WzTLs0/70HV
         qVsnrHcm9m6dcBSaFe1Hmsvfg0VXjSrqrZ91rT3JwWV03cB2DQEM6unQg7adlFnXjRWm
         GMhZQWJFnx2XnLInjNjU6OgRkCuEpIzQbFO8nvIEsIPOSBnLvQpg5ZB/OTDBeYK/1nMH
         Z+AMMotvw1D5d29v+j1XOeNgHH2xGqsWYsaudyYJnubyL4OQRswTnmb4TT2y96SXPL3q
         y3zA==
X-Gm-Message-State: AO0yUKVm7DGduDcNkbNmUO3dm2DINFTr+Mq3QvIOjxDXkT4W4zKqGUPZ
        9yXjKOztHH7IOQKHxz1yp2c=
X-Google-Smtp-Source: AK7set99sBSb1Pb5RYCItYGo9QCn36Q28dvxNs/naY9QRfgycA/3fklPo0GkxuMMXVhnU2deUVZRDg==
X-Received: by 2002:a4a:9522:0:b0:517:b476:12d6 with SMTP id m31-20020a4a9522000000b00517b47612d6mr828858ooi.6.1676385170270;
        Tue, 14 Feb 2023 06:32:50 -0800 (PST)
Received: from localhost ([12.97.180.36])
        by smtp.gmail.com with ESMTPSA id v6-20020a4a5a06000000b00517b076e071sm5913743ooa.47.2023.02.14.06.32.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Feb 2023 06:32:49 -0800 (PST)
Date:   Tue, 14 Feb 2023 06:32:48 -0800
From:   Yury Norov <yury.norov@gmail.com>
To:     Bruno Goncalves <bgoncalv@redhat.com>
Cc:     Networking <netdev@vger.kernel.org>, alan.maguire@oracle.com,
        Jakub Kicinski <kuba@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        CKI Project <cki-project@redhat.com>
Subject: Re: [6.2.0-rc7] BUG: KASAN: slab-out-of-bounds in hop_cmp+0x26/0x110
Message-ID: <Y+ubkJtpmc6l0gOt@yury-laptop>
References: <CA+QYu4qkVzZaB2OTaTLniZB9OCbTYUr2qvvvCmAnMkaq43OOLA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+QYu4qkVzZaB2OTaTLniZB9OCbTYUr2qvvvCmAnMkaq43OOLA@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 14, 2023 at 02:23:06PM +0100, Bruno Goncalves wrote:
> Hello,
> 
> recently when testing kernel with debug options set from net-next [1]
> and bpf-next [2] the following call trace happens:
> 
Hi Bruno,

Thanks for report.

This looks weird, because the hop_cmp() spent for 3 month in -next till
now. Anyways, can you please share your NUMA configuration so I'll try
to reproduce the bug locally? What 'numactl -H' outputs?

Thanks,
Yury

> [   92.539335] be2net 0000:04:00.0: FW config: function_mode=0x10003,
> function_caps=0x7
> [   92.559345] scsi host1: BC_356 : error in cmd completion: Subsystem
> : 1 Opcode : 191 status(compl/extd)=2/30
> [   92.560448] scsi host1: BG_1597 : HBA error recovery not supported
> [   92.587657] be2net 0000:04:00.0: Max: txqs 16, rxqs 17, rss 16, eqs 16, vfs 0
> [   92.588471] be2net 0000:04:00.0: Max: uc-macs 30, mc-macs 64, vlans 64
> [   93.731235] be2net 0000:04:00.0: enabled 8 MSI-x vector(s) for NIC
> [   93.749741] ==================================================================
> [   93.750521] BUG: KASAN: slab-out-of-bounds in hop_cmp+0x26/0x110
> [   93.751233] Read of size 8 at addr ffff888104719758 by task kworker/0:2/108
> [   93.751601]
> [   93.752087] CPU: 0 PID: 108 Comm: kworker/0:2 Tainted: G          I
>        6.2.0-rc7 #1
> [   93.752549] Hardware name: HP ProLiant BL460c Gen8, BIOS I31 11/02/2014
> [   93.752884] Workqueue: events work_for_cpu_fn
> [   93.753510] Call Trace:
> [   93.753687]  <TASK>
> [   93.754215]  dump_stack_lvl+0x55/0x71
> [   93.754449]  print_report+0x184/0x4b1
> [   93.754697]  ? __virt_addr_valid+0xe8/0x160
> [   93.754972]  ? hop_cmp+0x26/0x110
> [   93.755533]  kasan_report+0xa5/0xe0
> [   93.756193]  ? hop_cmp+0x26/0x110
> [   93.756767]  ? __pfx_hop_cmp+0x10/0x10
> [   93.756990]  ? hop_cmp+0x26/0x110
> [   93.757556]  ? __pfx_hop_cmp+0x10/0x10
> [   93.757774]  ? bsearch+0x53/0x80
> [   93.758838]  ? sched_numa_find_nth_cpu+0x128/0x360
> [   93.759492]  ? __pfx_sched_numa_find_nth_cpu+0x10/0x10
> [   93.759792]  ? alloc_cpumask_var_node+0x38/0x60
> [   93.760419]  ? rcu_read_lock_sched_held+0x3f/0x80
> [   93.761060]  ? trace_kmalloc+0x33/0xf0
> [   93.761306]  ? __kmalloc_node+0x76/0xc0
> [   93.761528]  ? cpumask_local_spread+0x44/0xc0
> [   93.762192]  ? be_setup_queues+0x13b/0x3c0 [be2net]
> [   93.762957]  ? be_setup+0x663/0xa60 [be2net]
> [   93.763795]  ? __pfx_be_setup+0x10/0x10 [be2net]
> [   93.764523]  ? is_module_address+0x2b/0x50
> [   93.764744]  ? is_module_address+0x2b/0x50
> [   93.764996]  ? static_obj+0x6b/0x80
> [   93.765865]  ? lockdep_init_map_type+0xcf/0x370
> [   93.766527]  ? be_probe+0x825/0xcd0 [be2net]
> [   93.767224]  ? __pfx_be_probe+0x10/0x10 [be2net]
> [   93.767932]  ? preempt_count_sub+0xb7/0x100
> [   93.768181]  ? _raw_spin_unlock_irqrestore+0x35/0x60
> [   93.768450]  ? __pfx_be_probe+0x10/0x10 [be2net]
> [   93.769162]  ? local_pci_probe+0x77/0xc0
> [   93.769392]  ? __pfx_local_pci_probe+0x10/0x10
> [   93.770007]  ? work_for_cpu_fn+0x29/0x40
> [   93.770253]  ? process_one_work+0x543/0xa20
> [   93.770490]  ? __pfx_process_one_work+0x10/0x10
> [   93.797773pin_lock+0x10/0x10
> [   93.871656]  ? __list_add_valid+0x3f/0x70
> [   93.871874]  ? move_linked_works+0x103/0x140
> [   93.872487]  ? worker_thread+0x364/0x630
> [   93.872704]  ? __kthread_parkme+0xd8/0xf0
> [   93.872919]  ? __pfx_worker_thread+0x10/0x10
> [   93.873513]  ? kthread+0x17e/0x1b0
> [   93.874055]  ? __pfx_kthread+0x10/0x10
> [   93.874290]  ? ret_from_fork+0x2c/0x50
> [   93.874541]  </TASK>
> [   93.874727]
> [   93.875188] Allocated by task 1:
> [   93.875733]  kasan_save_stack+0x34/0x60
> [   93.875942]  kasan_set_track+0x21/0x30
> [   93.876164]  __kasan_kmalloc+0xa9/0xb0
> [   93.876373]  __kmalloc+0x57/0xd0
> [   93.876918]  sched_init_numa+0x21f/0x7e0
> [   93.877146]  sched_init_smp+0x6d/0x113
> [   93.877358]  kernel_init_freeable+0x2a3/0x4a0
> [   93.877993]  kernel_init+0x18/0x160
> [   93.878592]  ret_from_fork+0x2c/0x50
> [   93.878811]
> [   93.879278] The buggy address belongs to the object at ffff888104719760
> [   93.879278]  which belongs to the cache kmalloc-16 of size 16
> [   93.879926] The buggy address is located 8 bytes to the left of
> [   93.879926]  16-byte region [ffff888104719760, ffff888104719770)
> [   94.363686] flags: 0x17ffffc0000200(slab|node=0|zone=2|lastcpupid=0x1fffff)
> [   94.381131] raw: 0017ffffc0000200 ffff88810004c580 ffffea000400df50
> ffffea0004165190
> [   94.381554] raw: 0000000000000000 00000000001c001c 00000001ffffffff
> 0000000000000000
> [   94.381958] page dumped because: kasan: bad access detected
> [   94.382249]
> [   94.382710] Memory state around the buggy address:
> [   94.383319]  ffff888104719600: fc fc fc fc fc fc fc fc fa fb fc fc
> fc fc fc fc
> [   94.384066]  ffff888104719680: fc fc fc fc fc fc fc fc fc fc 00 00
> fc fc fc fc
> [   94.384841] >ffff888104719700: fc fc fc fc fc fc fc fc fc fc fc fc
> 00 00 fc fc
> [   94.385573]                                                     ^
> [   94.386251]  ffff888104719780: fc fc fc fc fc fc fc fc fc fc fc fc
> fc fc 00 00
> [   94.386989]  ffff888104719800: fc fc fc fc fc fc fc fc fc fc fc fc
> fc fc fc fc
> [   94.387710] ==================================================================
> 
> full console log:
> https://s3.us-east-1.amazonaws.com/arr-cki-prod-datawarehouse-public/datawarehouse-public/3762562309/redhat:776235046/build_x86_64_redhat:776235046-x86_64-kernel-debug/tests/1/results_0001/job.01/recipes/13385613/tasks/5/logs/test_console.log
> 
> test logs: https://datawarehouse.cki-project.org/kcidb/tests/7075911
> cki issue tracker: https://datawarehouse.cki-project.org/issue/1896
> 
> kernel config: https://s3.amazonaws.com/arr-cki-prod-trusted-artifacts/trusted-artifacts/776235046/build%20x86_64%20debug/3762562279/artifacts/kernel-bpf-next-redhat_776235046-x86_64-kernel-debug.config
> kernel tarball:
> https://s3.amazonaws.com/arr-cki-prod-trusted-artifacts/trusted-artifacts/776235046/publish%20x86_64%20debug/3762562289/artifacts/kernel-bpf-next-redhat_776235046-x86_64-kernel-debug.tar.gz
> 
> The first commit we tested that we hit the problem is [3], but we
> didn't bisect it to know what commit introduced the issue.
> 
> [1] https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git
> [2] https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git
> [3] https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git/commit/?id=0243d3dfe274832aa0a16214499c208122345173
> 
> Thanks,
> Bruno Goncalves
