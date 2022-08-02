Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2B84587B8F
	for <lists+netdev@lfdr.de>; Tue,  2 Aug 2022 13:27:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236904AbiHBL1u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Aug 2022 07:27:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236899AbiHBL1t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Aug 2022 07:27:49 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7A5C82AC78
        for <netdev@vger.kernel.org>; Tue,  2 Aug 2022 04:27:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659439667;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=q8oSNbkd+gJJgmU22K14DBIu+SGmCTCtRxIBOtjBZAU=;
        b=cxurmfoHarw1r1+KjkfX32Ogp7lxuFcsdXewynrR6XCuhwXEtwgvEZ7gxNY306FfmR+D9K
        bwTw7ipOqlhKt9vW1WUe8HX/2zL5SG2bsuc/y7pcAFlz9RlsbgUC/H53Sp28yJHTxTp+2G
        E0tfFcRpiPgc3ZJ9/CS/46cQ0YMOIbo=
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com
 [209.85.208.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-297-1AB2c8lPOtqc59YAyewsWQ-1; Tue, 02 Aug 2022 07:27:46 -0400
X-MC-Unique: 1AB2c8lPOtqc59YAyewsWQ-1
Received: by mail-lj1-f198.google.com with SMTP id h18-20020a2e9012000000b0025e4f48d24dso1263540ljg.10
        for <netdev@vger.kernel.org>; Tue, 02 Aug 2022 04:27:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=q8oSNbkd+gJJgmU22K14DBIu+SGmCTCtRxIBOtjBZAU=;
        b=4S4ef23jjEJ6SXwxwBP8ZOxhExv9NmChsK84kyZSOisKcCj2trRP6d2v0vL6GR8j0f
         TLDH6qnt7azmyCXAENll97d9L+xFBmrRAbjBYBwsnLqEi9ZvTPzyUofh5vRjKnbVTgXp
         Depj4fBQPf9c9bpaXgq5SzGIT/ZYd9/6oaF4tEW62khntQnxj9TurTyxLlrRD/r7AlPa
         hKTvmzl3u5pPz3QdDcX6phNXMjaQnA+XTlpsP6LhkwLZ80wTJPgH3k4QWq4WLiRBkQKd
         9Sc7u0W7l3jew0L7Sx9jVNkzIMYVSvzPOiTxPnUQSgMLRKkJ7+If8mMXM8lY9i5++DxN
         IL4g==
X-Gm-Message-State: AJIora+WOd9t/5vgY8FYxMStb2+7FPcFiHotnwxD7x7bwEqKm+AWcTsU
        rM4wPew6Ok5ojSEGR4H+c8ZbtSbNxmpVNEOxiY7/q36/+OlmIH5sY5hYigNYB7Kpgkcpslpu2Lj
        gfiQswkCslGGBXpqDOYocWUigdoit5ZR5
X-Received: by 2002:a05:6512:218c:b0:48a:1e1e:7b59 with SMTP id b12-20020a056512218c00b0048a1e1e7b59mr7015309lft.580.1659439664118;
        Tue, 02 Aug 2022 04:27:44 -0700 (PDT)
X-Google-Smtp-Source: AA6agR66a8TtMNJeHlNE8jQYvGN4WTQoWp3OElFZm0/+JK6AMi92gRjALj0JMaJoaeG+jcu+cEc0oNqsTYwBvQPWZUc=
X-Received: by 2002:a05:6512:218c:b0:48a:1e1e:7b59 with SMTP id
 b12-20020a056512218c00b0048a1e1e7b59mr7015300lft.580.1659439663874; Tue, 02
 Aug 2022 04:27:43 -0700 (PDT)
MIME-Version: 1.0
From:   Bruno Goncalves <bgoncalv@redhat.com>
Date:   Tue, 2 Aug 2022 13:27:32 +0200
Message-ID: <CA+QYu4qxW1BUcbC9MwG1BxXjPO96sa9BOUXOHCj1SLY7ObJnQw@mail.gmail.com>
Subject: RIP: 0010:qede_load+0x128d/0x13b0 [qede] - 5.19.0
To:     LKML <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>
Cc:     CKI Project <cki-project@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

We've noticed the following panic when booting up kernel 5.19.0 on a
specific machine.
The panic seems to happen when we build the kernel with debug flags.
Below is the first crash we noticed, more logs at [1] and the kernel
config is at [2].

[   59.207684] invalid opcode: 0000 [#1] PREEMPT SMP NOPTI
[   59.212949] CPU: 32 PID: 1967 Comm: NetworkManager Not tainted 5.19.0-rc3 #1
[   59.220041] Hardware name: HPE ProLiant DL325 Gen10 Plus/ProLiant
DL325 Gen10 Plus, BIOS A43 08/09/2021
[   59.229490] RIP: 0010:qede_load.cold+0x5a1/0x819 [qede]
[   59.234757] Code: 41 88 84 24 b1 00 00 00 41 0f b7 84 24 b6 00 00
00 45 88 b4 24 b3 00 00 00 e9 b8 00 ff ff 48 c7 c1 09 66 46 c1 e9 6f
ff ff ff <0f> 0b 49 8b 7c 24 08 e8 82 e2 fe ff 48 89 c1 48 85 c0 74 32
ba 2a
[   59.253639] RSP: 0018:ffffae1e04593688 EFLAGS: 00010206
[   59.258897] RAX: 000000000000006b RBX: 0000000000000000 RCX: 0000000000000006
[   59.266073] RDX: ffff8f8f35332be8 RSI: ffffffffaf96411f RDI: ffffffffaf8e4b1e
[   59.273250] RBP: ffff8f8f2a87acd0 R08: 0000000000000001 R09: 0000000000000001
[   59.280426] R10: 0000000000000000 R11: 000000000f8c087f R12: ffff8f8f2a87ac00
[   59.287602] R13: ffff8f8f34d7f928 R14: ffffae1e0c039000 R15: 0000000000000000
[   59.294777] FS:  00007f164509f500(0000) GS:ffff8f9dfd800000(0000)
knlGS:0000000000000000
[   59.302917] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   59.308697] CR2: 00005575f29a5c08 CR3: 0000000163810000 CR4: 0000000000350ee0
[   59.315875] Call Trace:
[   59.318335]  <TASK>
[   59.320458]  qede_open+0x3b/0x90 [qede]
[   59.324323]  __dev_open+0xf1/0x1c0
[   59.327748]  __dev_change_flags+0x1f8/0x280
[   59.331957]  dev_change_flags+0x22/0x60
[   59.335816]  do_setlink+0x327/0x1140
[   59.339413]  ? lock_is_held_type+0xe3/0x140
[   59.343625]  ? lock_is_held_type+0xe3/0x140
[   59.347833]  ? __nla_validate_parse+0x5f/0xb70
[   59.352307]  ? mark_held_locks+0x49/0x70
[   59.356256]  ? _raw_spin_unlock_irqrestore+0x30/0x60
[   59.361254]  ? lockdep_hardirqs_on+0x7d/0x100
[   59.365640]  __rtnl_newlink+0x59c/0x950
[   59.369502]  ? rtnl_newlink+0x2a/0x60
[   59.373185]  ? rcu_read_lock_sched_held+0x3c/0x70
[   59.377918]  ? trace_kmalloc+0x30/0xf0
[   59.381692]  ? kmem_cache_alloc_trace+0x1ad/0x270
[   59.386426]  rtnl_newlink+0x43/0x60
[   59.389936]  rtnetlink_rcv_msg+0x184/0x540
[   59.394057]  ? lock_acquire+0xe2/0x2e0
[   59.397830]  ? rtnl_stats_set+0x190/0x190
[   59.401863]  netlink_rcv_skb+0x51/0xf0
[   59.405639]  netlink_unicast+0x189/0x260
[   59.409586]  netlink_sendmsg+0x25a/0x4c0
[   59.413536]  sock_sendmsg+0x5c/0x60
[   59.417045]  ____sys_sendmsg+0x22b/0x270
[   59.420991]  ? import_iovec+0x17/0x20
[   59.424675]  ? sendmsg_copy_msghdr+0x78/0xa0
[   59.428972]  ___sys_sendmsg+0x85/0xc0
[   59.432658]  ? lock_is_held_type+0xe3/0x140
[   59.436867]  ? find_held_lock+0x2b/0x80
[   59.440727]  ? lock_release+0x145/0x300
[   59.444586]  ? __fget_files+0xe5/0x170
[   59.448360]  __sys_sendmsg+0x5c/0xb0
[   59.451961]  do_syscall_64+0x5b/0x80
[   59.455558]  entry_SYSCALL_64_after_hwframe+0x46/0xb0
[   59.460641] RIP: 0033:0x7f164628539d
[   59.464251] Code: 28 89 54 24 1c 48 89 74 24 10 89 7c 24 08 e8 0a
b1 f7 ff 8b 54 24 1c 48 8b 74 24 10 41 89 c0 8b 7c 24 08 b8 2e 00 00
00 0f 05 <48> 3d 00 f0 ff ff 77 33 44 89 c7 48 89 44 24 08 e8 5e b1 f7
ff 48
[   59.483133] RSP: 002b:00007ffd9bf01520 EFLAGS: 00000293 ORIG_RAX:
000000000000002e
[   59.490749] RAX: ffffffffffffffda RBX: 000000000000000d RCX: 00007f164628539d
[   59.497925] RDX: 0000000000000000 RSI: 00007ffd9bf01560 RDI: 000000000000000c
[   59.505100] RBP: 00005575f2915040 R08: 0000000000000000 R09: 0000000000000000
[   59.512275] R10: 0000000000000000 R11: 0000000000000293 R12: 0000000000000000
[   59.519453] R13: 00007ffd9bf016c0 R14: 00007ffd9bf016bc R15: 0000000000000000
[   59.526637]  </TASK>
[   59.528834] Modules linked in: rfkill sunrpc intel_rapl_msr
intel_rapl_common vfat fat qede qed edac_mce_amd i2c_piix4 crc8 rapl
igb ipmi_ssif ptdma ses enclosure pcspkr dca hpilo k10temp acpi_ipmi
acpi_tad ipmi_si acpi_power_meter fuse zram xfs crct10dif_pclmul
crc32_pclmul crc32c_intel mgag200 i2c_algo_bit drm_shmem_helper
drm_kms_helper ghash_clmulni_intel drm hpwdt smartpqi ccp
scsi_transport_sas sp5100_tco wmi ipmi_devintf ipmi_msghandler
[   59.568459] ---[ end trace 0000000000000000 ]---
[   59.632952] RIP: 0010:qede_load.cold+0x5a1/0x819 [qede]
[   59.632967] Code: 41 88 84 24 b1 00 00 00 41 0f b7 84 24 b6 00 00
00 45 88 b4 24 b3 00 00 00 e9 b8 00 ff ff 48 c7 c1 09 66 46 c1 e9 6f
ff ff ff <0f> 0b 49 8b 7c 24 08 e8 82 e2 fe ff 48 89 c1 48 85 c0 74 32
ba 2a
[   59.632970] RSP: 0018:ffffae1e04593688 EFLAGS: 00010206
[   59.632972] RAX: 000000000000006b RBX: 0000000000000000 RCX: 0000000000000006
[   59.632974] RDX: ffff8f8f35332be8 RSI: ffffffffaf96411f RDI: ffffffffaf8e4b1e
[   59.632977] RBP: ffff8f8f2a87acd0 R08: 0000000000000001 R09: 0000000000000001
[   59.632978] R10: 0000000000000000 R11: 000000000f8c087f R12: ffff8f8f2a87ac00
[   59.632980] R13: ffff8f8f34d7f928 R14: ffffae1e0c039000 R15: 0000000000000000
[   59.632982] FS:  00007f164509f500(0000) GS:ffff8f9dfd800000(0000)
knlGS:0000000000000000
[   59.632984] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   59.632986] CR2: 00005575f29a5c08 CR3: 0000000163810000 CR4: 0000000000350ee0
[   59.632989] Kernel panic - not syncing: Fatal exception
[   59.732905] Kernel Offset: 0x2d000000 from 0xffffffff81000000
(relocation range: 0xffffffff80000000-0xffffffffbfffffff)
[   59.807803] ---[ end Kernel panic - not syncing: Fatal exception ]---


cki issue tracker: https://datawarehouse.cki-project.org/issue/1470

[1] https://datawarehouse.cki-project.org/kcidb/tests/4002370
[2] http://s3.amazonaws.com/arr-cki-prod-datawarehouse-public/datawarehouse-public/2022/06/20/568171088/redhat:568171088/redhat:568171088_x86_64_debug/.config

Thanks,
Bruno Goncalves

