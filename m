Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19A076964A0
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 14:24:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232716AbjBNNYX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 08:24:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232677AbjBNNYW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 08:24:22 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C64D35B0
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 05:23:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676381001;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=OATV7Ncr1VgnZ/gsUoj3D9uZAUj842x4JwuDkg1eFpQ=;
        b=BUkvOKb8Bz5XETeDVQ6pwH8v978OhOzBSvo6lRESbm34i/sTkeJ9t3mHjbvrNBNTmtClZT
        fxSOM0k0Mig1slmR3mDDckaIPSIcaTv48hA512T+XMK3/I4MUBHprdsKkcAa9EeaX1v10B
        gNR6RSBX05dcrQfYt61CWqS3k8iWRP0=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-262-dVd0_ZCHOsmf4S66qOGYew-1; Tue, 14 Feb 2023 08:23:20 -0500
X-MC-Unique: dVd0_ZCHOsmf4S66qOGYew-1
Received: by mail-ed1-f72.google.com with SMTP id s20-20020a05640217d400b004ab46449f12so8006608edy.23
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 05:23:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=OATV7Ncr1VgnZ/gsUoj3D9uZAUj842x4JwuDkg1eFpQ=;
        b=Md/qkPZxsIbduLmhzuMqt6Eo825d0BraRcFwENUDdiRDMJ/umhEDR+Hwup0CfK4bK2
         gTUDyNGm2SE2f3Z7bGmHXi9dk55wUIo21lRsbj+U3oXmj+/1BKLrzzAUB+qDNaDm5PyT
         zKqLgioNO0GIbKY/27wausTWFok/YL77NhN04GPxZpHqdCD7odztWf/PLOzq5kmCVtZv
         ErnGEtlT0g7bEThqh8FIc0VKuDVTGwpSvfPpZg0fpSRTFmeE1SkVhUKPBjIhqGh/XA8a
         P/oOf0LTRWHHxCeVY5BjisVOD2hlO5WxhEFizk3JzgO96WDdOP+TLziTw96OMTm42Vvu
         cfIw==
X-Gm-Message-State: AO0yUKXP6ti2QBCrbVo9pUy8gh/0z2+5Q3k7ZYsOHjZ7vEejIKt4ITC4
        /mKMbMDTeUbq8ky5zNNZQAkZgndcp2UbvmkjhOWxVr2BzkHiMXGNbKdHhkt9iaW4qdTr8DrkG6P
        xi9Q9XjtzBqv3wZNOA+GGC2VXlFRedvunAfHoXXNZ
X-Received: by 2002:a17:906:6d19:b0:8ae:1078:722f with SMTP id m25-20020a1709066d1900b008ae1078722fmr1261043ejr.9.1676380998025;
        Tue, 14 Feb 2023 05:23:18 -0800 (PST)
X-Google-Smtp-Source: AK7set/D83KqRDZHRuGxY61FGJWbOV3CPyzaLzJBwgPMDusE1AK8RkTfVq8+Dcf3wScCG/y/LXxo8MynKGv7JUxcIOI=
X-Received: by 2002:a17:906:6d19:b0:8ae:1078:722f with SMTP id
 m25-20020a1709066d1900b008ae1078722fmr1261029ejr.9.1676380997812; Tue, 14 Feb
 2023 05:23:17 -0800 (PST)
MIME-Version: 1.0
From:   Bruno Goncalves <bgoncalv@redhat.com>
Date:   Tue, 14 Feb 2023 14:23:06 +0100
Message-ID: <CA+QYu4qkVzZaB2OTaTLniZB9OCbTYUr2qvvvCmAnMkaq43OOLA@mail.gmail.com>
Subject: [6.2.0-rc7] BUG: KASAN: slab-out-of-bounds in hop_cmp+0x26/0x110
To:     Networking <netdev@vger.kernel.org>, yury.norov@gmail.com,
        alan.maguire@oracle.com, Jakub Kicinski <kuba@kernel.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
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

Hello,

recently when testing kernel with debug options set from net-next [1]
and bpf-next [2] the following call trace happens:

[   92.539335] be2net 0000:04:00.0: FW config: function_mode=0x10003,
function_caps=0x7
[   92.559345] scsi host1: BC_356 : error in cmd completion: Subsystem
: 1 Opcode : 191 status(compl/extd)=2/30
[   92.560448] scsi host1: BG_1597 : HBA error recovery not supported
[   92.587657] be2net 0000:04:00.0: Max: txqs 16, rxqs 17, rss 16, eqs 16, vfs 0
[   92.588471] be2net 0000:04:00.0: Max: uc-macs 30, mc-macs 64, vlans 64
[   93.731235] be2net 0000:04:00.0: enabled 8 MSI-x vector(s) for NIC
[   93.749741] ==================================================================
[   93.750521] BUG: KASAN: slab-out-of-bounds in hop_cmp+0x26/0x110
[   93.751233] Read of size 8 at addr ffff888104719758 by task kworker/0:2/108
[   93.751601]
[   93.752087] CPU: 0 PID: 108 Comm: kworker/0:2 Tainted: G          I
       6.2.0-rc7 #1
[   93.752549] Hardware name: HP ProLiant BL460c Gen8, BIOS I31 11/02/2014
[   93.752884] Workqueue: events work_for_cpu_fn
[   93.753510] Call Trace:
[   93.753687]  <TASK>
[   93.754215]  dump_stack_lvl+0x55/0x71
[   93.754449]  print_report+0x184/0x4b1
[   93.754697]  ? __virt_addr_valid+0xe8/0x160
[   93.754972]  ? hop_cmp+0x26/0x110
[   93.755533]  kasan_report+0xa5/0xe0
[   93.756193]  ? hop_cmp+0x26/0x110
[   93.756767]  ? __pfx_hop_cmp+0x10/0x10
[   93.756990]  ? hop_cmp+0x26/0x110
[   93.757556]  ? __pfx_hop_cmp+0x10/0x10
[   93.757774]  ? bsearch+0x53/0x80
[   93.758838]  ? sched_numa_find_nth_cpu+0x128/0x360
[   93.759492]  ? __pfx_sched_numa_find_nth_cpu+0x10/0x10
[   93.759792]  ? alloc_cpumask_var_node+0x38/0x60
[   93.760419]  ? rcu_read_lock_sched_held+0x3f/0x80
[   93.761060]  ? trace_kmalloc+0x33/0xf0
[   93.761306]  ? __kmalloc_node+0x76/0xc0
[   93.761528]  ? cpumask_local_spread+0x44/0xc0
[   93.762192]  ? be_setup_queues+0x13b/0x3c0 [be2net]
[   93.762957]  ? be_setup+0x663/0xa60 [be2net]
[   93.763795]  ? __pfx_be_setup+0x10/0x10 [be2net]
[   93.764523]  ? is_module_address+0x2b/0x50
[   93.764744]  ? is_module_address+0x2b/0x50
[   93.764996]  ? static_obj+0x6b/0x80
[   93.765865]  ? lockdep_init_map_type+0xcf/0x370
[   93.766527]  ? be_probe+0x825/0xcd0 [be2net]
[   93.767224]  ? __pfx_be_probe+0x10/0x10 [be2net]
[   93.767932]  ? preempt_count_sub+0xb7/0x100
[   93.768181]  ? _raw_spin_unlock_irqrestore+0x35/0x60
[   93.768450]  ? __pfx_be_probe+0x10/0x10 [be2net]
[   93.769162]  ? local_pci_probe+0x77/0xc0
[   93.769392]  ? __pfx_local_pci_probe+0x10/0x10
[   93.770007]  ? work_for_cpu_fn+0x29/0x40
[   93.770253]  ? process_one_work+0x543/0xa20
[   93.770490]  ? __pfx_process_one_work+0x10/0x10
[   93.797773pin_lock+0x10/0x10
[   93.871656]  ? __list_add_valid+0x3f/0x70
[   93.871874]  ? move_linked_works+0x103/0x140
[   93.872487]  ? worker_thread+0x364/0x630
[   93.872704]  ? __kthread_parkme+0xd8/0xf0
[   93.872919]  ? __pfx_worker_thread+0x10/0x10
[   93.873513]  ? kthread+0x17e/0x1b0
[   93.874055]  ? __pfx_kthread+0x10/0x10
[   93.874290]  ? ret_from_fork+0x2c/0x50
[   93.874541]  </TASK>
[   93.874727]
[   93.875188] Allocated by task 1:
[   93.875733]  kasan_save_stack+0x34/0x60
[   93.875942]  kasan_set_track+0x21/0x30
[   93.876164]  __kasan_kmalloc+0xa9/0xb0
[   93.876373]  __kmalloc+0x57/0xd0
[   93.876918]  sched_init_numa+0x21f/0x7e0
[   93.877146]  sched_init_smp+0x6d/0x113
[   93.877358]  kernel_init_freeable+0x2a3/0x4a0
[   93.877993]  kernel_init+0x18/0x160
[   93.878592]  ret_from_fork+0x2c/0x50
[   93.878811]
[   93.879278] The buggy address belongs to the object at ffff888104719760
[   93.879278]  which belongs to the cache kmalloc-16 of size 16
[   93.879926] The buggy address is located 8 bytes to the left of
[   93.879926]  16-byte region [ffff888104719760, ffff888104719770)
[   94.363686] flags: 0x17ffffc0000200(slab|node=0|zone=2|lastcpupid=0x1fffff)
[   94.381131] raw: 0017ffffc0000200 ffff88810004c580 ffffea000400df50
ffffea0004165190
[   94.381554] raw: 0000000000000000 00000000001c001c 00000001ffffffff
0000000000000000
[   94.381958] page dumped because: kasan: bad access detected
[   94.382249]
[   94.382710] Memory state around the buggy address:
[   94.383319]  ffff888104719600: fc fc fc fc fc fc fc fc fa fb fc fc
fc fc fc fc
[   94.384066]  ffff888104719680: fc fc fc fc fc fc fc fc fc fc 00 00
fc fc fc fc
[   94.384841] >ffff888104719700: fc fc fc fc fc fc fc fc fc fc fc fc
00 00 fc fc
[   94.385573]                                                     ^
[   94.386251]  ffff888104719780: fc fc fc fc fc fc fc fc fc fc fc fc
fc fc 00 00
[   94.386989]  ffff888104719800: fc fc fc fc fc fc fc fc fc fc fc fc
fc fc fc fc
[   94.387710] ==================================================================

full console log:
https://s3.us-east-1.amazonaws.com/arr-cki-prod-datawarehouse-public/datawarehouse-public/3762562309/redhat:776235046/build_x86_64_redhat:776235046-x86_64-kernel-debug/tests/1/results_0001/job.01/recipes/13385613/tasks/5/logs/test_console.log

test logs: https://datawarehouse.cki-project.org/kcidb/tests/7075911
cki issue tracker: https://datawarehouse.cki-project.org/issue/1896

kernel config: https://s3.amazonaws.com/arr-cki-prod-trusted-artifacts/trusted-artifacts/776235046/build%20x86_64%20debug/3762562279/artifacts/kernel-bpf-next-redhat_776235046-x86_64-kernel-debug.config
kernel tarball:
https://s3.amazonaws.com/arr-cki-prod-trusted-artifacts/trusted-artifacts/776235046/publish%20x86_64%20debug/3762562289/artifacts/kernel-bpf-next-redhat_776235046-x86_64-kernel-debug.tar.gz

The first commit we tested that we hit the problem is [3], but we
didn't bisect it to know what commit introduced the issue.

[1] https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git
[2] https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git
[3] https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git/commit/?id=0243d3dfe274832aa0a16214499c208122345173

Thanks,
Bruno Goncalves

