Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FCB04C001B
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 18:26:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234622AbiBVR1S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 12:27:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234613AbiBVR1Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 12:27:16 -0500
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72D5CB7C67;
        Tue, 22 Feb 2022 09:26:50 -0800 (PST)
Received: by mail-pf1-x431.google.com with SMTP id d187so12747935pfa.10;
        Tue, 22 Feb 2022 09:26:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=QATrpVd/puNrA3QEY1KgNyb1yfnb8yP4bnZQ0jYrArQ=;
        b=JwmCyLf28KeVXuvrXF6hFEhw9Zam+KkE4sEx8vR6O+NMvatzDbK2m5ZEq6YcBaYNx5
         p8AQwMA3ow5AnpkNxTgZocQQvrxPMMmJvjYbFb0hbvnSbc5l6ifwAS8/3+/TYX934cCY
         KPO5PmPiRGPTBXGtpAoOKc5qQJJMBZK6gCSycp9yFAAHAqIBYPvh4jsZS03tRjQHvxZL
         oJWnDqcK7H8FSRRdjNhegKwacn6TmDmtK0cWx9oYXVzHISon5ROIRviED+16TeEf0JZi
         943G3mQXrdePa2qxbW6aOCXFaXkUgYqHWgYcWh2RBOJjy/FTyzkpzX7Odwp6+mwWDfX4
         mwWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=QATrpVd/puNrA3QEY1KgNyb1yfnb8yP4bnZQ0jYrArQ=;
        b=xYMyfH2ijCPLvwsaRjXX714Q1ELYIWL4518HkkKEhAo5VaNsJxlUJQWQVOGfRxfkY4
         NK2lRYsABlrPagtogdkZAiBBLhSn7N5hwzJpvR4wrpwICZmQNdfT7Y0E9+UXT0y2KqaE
         SqWIQuMBVQAk5EjrzQruAp1IQxdaGtJEozAnywzR58EvTIYumvWCZSwIbxIZuVYgOGSj
         ihWvnDGKZO8uWHIECwZ1kISx0CHvJCwZP5WzivTqQL7kF6OilU4ngmqvvQH+XwowUaaF
         5IkQt4lvOkhAz5LYJZH0SNTK5Ir1n4KKymXcOb8qA+uWmiCWWwtn31GIZT6iqejyrfw0
         9CJg==
X-Gm-Message-State: AOAM533wacDeKwXNQNTQB0nrrjc827m1IuYKH/Lz9t595mm9Obbo1dez
        XnFrbe6AJwdWSA3PgtkEZZxT7SnnVB0=
X-Google-Smtp-Source: ABdhPJyZJeKo5Tw1oZpB6fIX6de8qZXWjawuIErx+P4XxAr2p4r3kP5d0o6hgmUQoQqIfAxFh3CQGA==
X-Received: by 2002:a63:2314:0:b0:370:5429:84ed with SMTP id j20-20020a632314000000b00370542984edmr20667856pgj.469.1645550809775;
        Tue, 22 Feb 2022 09:26:49 -0800 (PST)
Received: from localhost (2603-800c-1a02-1bae-e24f-43ff-fee6-449f.res6.spectrum.com. [2603:800c:1a02:1bae:e24f:43ff:fee6:449f])
        by smtp.gmail.com with ESMTPSA id q9sm18900852pfk.31.2022.02.22.09.26.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Feb 2022 09:26:49 -0800 (PST)
Sender: Tejun Heo <htejun@gmail.com>
Date:   Tue, 22 Feb 2022 07:26:47 -1000
From:   Tejun Heo <tj@kernel.org>
To:     syzbot <syzbot+568dc81cd20b72d4a49f@syzkaller.appspotmail.com>
Cc:     cgroups@vger.kernel.org, hannes@cmpxchg.org,
        linux-kernel@vger.kernel.org, lizefan.x@bytedance.com,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        Waiman Long <longman@redhat.com>
Subject: Re: [syzbot] WARNING in cpuset_write_resmask
Message-ID: <YhUc10UcAmot1AJK@slm.duckdns.org>
References: <000000000000264b2a05d44bca80@google.com>
 <0000000000008f71e305d89070bb@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0000000000008f71e305d89070bb@google.com>
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

(cc'ing Waiman and quoting whole body)

Hello, Waiman.

It looks like it's hitting

 WARN_ON(!is_in_v2_mode() && !nodes_equal(cp->mems_allowed, cp->effective_mems))

Can you take a look?

Thanks.

On Mon, Feb 21, 2022 at 04:29:18PM -0800, syzbot wrote:
> syzbot has found a reproducer for the following issue on:
> 
> HEAD commit:    e5313968c41b Merge branch 'Split bpf_sk_lookup remote_port..
> git tree:       bpf-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=113aeefa700000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=c40b67275bfe2a58
> dashboard link: https://syzkaller.appspot.com/bug?extid=568dc81cd20b72d4a49f
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13bb97ce700000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12062c8e700000
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+568dc81cd20b72d4a49f@syzkaller.appspotmail.com
> 
> ------------[ cut here ]------------
> WARNING: CPU: 1 PID: 3647 at kernel/cgroup/cpuset.c:1817 update_nodemasks_hier kernel/cgroup/cpuset.c:1817 [inline]
> WARNING: CPU: 1 PID: 3647 at kernel/cgroup/cpuset.c:1817 update_nodemask kernel/cgroup/cpuset.c:1890 [inline]
> WARNING: CPU: 1 PID: 3647 at kernel/cgroup/cpuset.c:1817 cpuset_write_resmask+0x167b/0x20f0 kernel/cgroup/cpuset.c:2457
> Modules linked in:
> CPU: 0 PID: 3647 Comm: syz-executor287 Not tainted 5.16.0-syzkaller-11655-ge5313968c41b #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> RIP: 0010:update_nodemasks_hier kernel/cgroup/cpuset.c:1817 [inline]
> RIP: 0010:update_nodemask kernel/cgroup/cpuset.c:1890 [inline]
> RIP: 0010:cpuset_write_resmask+0x167b/0x20f0 kernel/cgroup/cpuset.c:2457
> Code: 3c 08 00 0f 85 ed 08 00 00 49 8b 9c 24 38 01 00 00 48 89 ef 48 89 de e8 63 4a 04 00 48 39 dd 0f 84 dd ef ff ff e8 e5 46 04 00 <0f> 0b e9 d1 ef ff ff e8 d9 46 04 00 e8 b4 a5 ef ff e8 cf 46 04 00
> RSP: 0018:ffffc90003acfb18 EFLAGS: 00010293
> RAX: 0000000000000000 RBX: 0000000000000001 RCX: 0000000000000000
> RDX: ffff88801e193a00 RSI: ffffffff81740f0b RDI: 0000000000000003
> RBP: 0000000000000003 R08: 0000000000000003 R09: ffffffff8fdeca17
> R10: ffffffff81740efd R11: 0000000000000001 R12: ffff888074f2e000
> R13: ffff888074f2e054 R14: ffff888074f2e138 R15: 0000000000000000
> FS:  00007fee62f33700(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007ffcf8240960 CR3: 0000000072ae3000 CR4: 00000000003506f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  <TASK>
>  cgroup_file_write+0x1de/0x760 kernel/cgroup/cgroup.c:3877
>  kernfs_fop_write_iter+0x342/0x500 fs/kernfs/file.c:296
>  call_write_iter include/linux/fs.h:2086 [inline]
>  new_sync_write+0x431/0x660 fs/read_write.c:503
>  vfs_write+0x7cd/0xae0 fs/read_write.c:590
>  ksys_write+0x12d/0x250 fs/read_write.c:643
>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
>  entry_SYSCALL_64_after_hwframe+0x44/0xae
> RIP: 0033:0x7fee62f82b79
> Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 b1 15 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007fee62f33308 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
> RAX: ffffffffffffffda RBX: 00007fee6300c4c8 RCX: 00007fee62f82b79
> RDX: 0000000000000001 RSI: 0000000020000080 RDI: 0000000000000006
> RBP: 00007fee6300c4c0 R08: 0000000000000012 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 00007fee6300c4cc
> R13: 00007fee62fd92b0 R14: 6d2e746573757063 R15: 0000000000022000
>  </TASK>
> 

-- 
tejun
