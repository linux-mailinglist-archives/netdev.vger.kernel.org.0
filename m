Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47B5B66575F
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 10:27:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238507AbjAKJ1M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 04:27:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236563AbjAKJ03 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 04:26:29 -0500
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 403772AEB
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 01:26:00 -0800 (PST)
Received: by mail-pj1-x1041.google.com with SMTP id n12so15278734pjp.1
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 01:26:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=TzG5BkJ704bsQ7RpGaEAajTvu7APvIVwu6zcOwvyvjY=;
        b=a8fiiPxffkO2rDpYB1IE9QCNor2qXuSovnf6omjJ2AO/Bp7/WRK2Q+e+becNU2qc5n
         ZK8uCmoa0fivGMyAet0ZTLOMR3ipbeDd9xqo1I0UW7TddY6EluKfU/GSvBZSizBb+TNQ
         Tf3zSz2pVTNVQFABsw5EqkXPPFX2JDIb57reaVzqXLl+QgO/g5O5099dbyRPfFE+t6iE
         nfVOX61txVuoZTKBMa07g4EGxvMBLdsdjsL8FA86hgnH/NNEcavJnNndu+ghOyQ63aIk
         aZ8+i1BNT0WRdllcoLexygqNW7PZdw4adaC7Ib7pSz+n+xYNJhscaoRTuweHZVfQOuXV
         REdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TzG5BkJ704bsQ7RpGaEAajTvu7APvIVwu6zcOwvyvjY=;
        b=stMDrjxJTTAettoUWyfwSKHraekioZf5ds/2vgLBWSBBt56CzhMzUNy3q9rYz4mUK+
         UCRemD7XF+Wuldw6U4CG/gg6QJ44rMuckIZw7OMW5A8B9G+wbzWDcBiLx1vB8dO+DGwj
         HKPYU80BV1RUuOiQtaOmYxuy1R8Oc+WWaAx9El5OJbsxp4SXSAZlYxHkVFtCTX9ubUc7
         xfWZUYtlmIAC+0yVbD/R4hKhh5cYAOHMjwaUg7JiL18M73G82M2VMVd9H3TDOpYah6/g
         BovFmbrpX8p/todcC25HKimRQWOndIoZWLmmjptNbh9ACUmqIkWaUVUrRT3hPccGzXPI
         tKLg==
X-Gm-Message-State: AFqh2ko/YZjwl/eFK+pjAcW3dz6hEew1XIbrb5VDk3mFg1oQtnoKUmwg
        kaApx1c+ub/jPr8xJQVyy1rHQg==
X-Google-Smtp-Source: AMrXdXsHqLs9SaEJsWMl7CApZELV2uFvNa7CqCcxEIDVBnNXmDuJ7eCCBPfrV1RV1XYwrCzuJoRtVg==
X-Received: by 2002:a17:90a:ac08:b0:226:3d16:43b2 with SMTP id o8-20020a17090aac0800b002263d1643b2mr1879926pjq.43.1673429159782;
        Wed, 11 Jan 2023 01:25:59 -0800 (PST)
Received: from localhost (thunderhill.nvidia.com. [216.228.112.22])
        by smtp.gmail.com with ESMTPSA id cl14-20020a17090af68e00b00218a7808ec9sm8569515pjb.8.2023.01.11.01.25.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Jan 2023 01:25:59 -0800 (PST)
Date:   Wed, 11 Jan 2023 10:25:56 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     syzbot <syzbot+9f0dd863b87113935acf@syzkaller.appspotmail.com>
Cc:     davem@davemloft.net, edumazet@google.com, jiri@nvidia.com,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com,
        syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] WARNING in devlink_free
Message-ID: <Y76ApH3648mpePh7@nanopsycho>
References: <000000000000076ab405f1f8134a@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000000000000076ab405f1f8134a@google.com>
X-Spam-Status: No, score=0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SORTED_RECIPS,SPF_HELO_NONE,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Jan 11, 2023 at 08:37:36AM CET, syzbot+9f0dd863b87113935acf@syzkaller.appspotmail.com wrote:
>Hello,
>
>syzbot found the following issue on:
>
>HEAD commit:    6d0c4b11e743 libbpf: Poison strlcpy()
>git tree:       bpf-next
>console output: https://syzkaller.appspot.com/x/log.txt?x=17b1945a480000
>kernel config:  https://syzkaller.appspot.com/x/.config?x=46221e8203c7aca6
>dashboard link: https://syzkaller.appspot.com/bug?extid=9f0dd863b87113935acf
>compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
>
>Unfortunately, I don't have any reproducer for this issue yet.
>
>Downloadable assets:
>disk image: https://storage.googleapis.com/syzbot-assets/83567aa48724/disk-6d0c4b11.raw.xz
>vmlinux: https://storage.googleapis.com/syzbot-assets/6047fdb8660e/vmlinux-6d0c4b11.xz
>kernel image: https://storage.googleapis.com/syzbot-assets/a94d1047d7b7/bzImage-6d0c4b11.xz
>
>IMPORTANT: if you fix the issue, please add the following tag to the commit:
>Reported-by: syzbot+9f0dd863b87113935acf@syzkaller.appspotmail.com
>
>------------[ cut here ]------------
>DEBUG_LOCKS_WARN_ON(mutex_is_locked(lock))

This is going to be very likely fixed by:
https://lore.kernel.org/all/20230111042908.988199-1-kuba@kernel.org/


>WARNING: CPU: 1 PID: 14225 at kernel/locking/mutex-debug.c:102 mutex_destroy+0xc1/0x100 kernel/locking/mutex-debug.c:102
>Modules linked in:
>CPU: 1 PID: 14225 Comm: syz-executor.5 Not tainted 6.2.0-rc2-syzkaller-00302-g6d0c4b11e743 #0
>Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
>RIP: 0010:mutex_destroy+0xc1/0x100 kernel/locking/mutex-debug.c:102
>Code: 03 0f b6 14 11 38 d0 7c 04 84 d2 75 3f 8b 05 ee 21 10 0d 85 c0 75 92 48 c7 c6 00 47 4c 8a 48 c7 c7 40 47 4c 8a e8 af 7f 5c 08 <0f> 0b e9 78 ff ff ff 48 c7 c7 00 8a c0 91 e8 2c 64 6c 00 e9 5d ff
>RSP: 0018:ffffc900030efa20 EFLAGS: 00010286
>RAX: 0000000000000000 RBX: ffff88807ca752d0 RCX: 0000000000000000
>RDX: ffff88802749d7c0 RSI: ffffffff8166724c RDI: fffff5200061df36
>RBP: ffff88807ca75000 R08: 0000000000000005 R09: 0000000000000000
>R10: 0000000080000000 R11: 0000000000000001 R12: ffff88807ca73000
>R13: ffff88807ca73078 R14: ffffffff8d7af3c0 R15: 0000000000000000
>FS:  0000555556d5f400(0000) GS:ffff8880b9900000(0000) knlGS:0000000000000000
>CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>CR2: 000055a9c409d950 CR3: 000000004f7a2000 CR4: 00000000003506e0
>DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>Call Trace:
> <TASK>
> devlink_free+0x83/0x510 net/devlink/core.c:262
> nsim_drv_remove+0x158/0x1d0 drivers/net/netdevsim/dev.c:1688
> device_remove+0xc8/0x170 drivers/base/dd.c:548
> __device_release_driver drivers/base/dd.c:1253 [inline]
> device_release_driver_internal+0x4a5/0x700 drivers/base/dd.c:1279
> bus_remove_device+0x2e7/0x5a0 drivers/base/bus.c:529
> device_del+0x4f7/0xc80 drivers/base/core.c:3666
> device_unregister+0x1e/0xc0 drivers/base/core.c:3698
> nsim_bus_dev_del drivers/net/netdevsim/bus.c:310 [inline]
> del_device_store+0x34e/0x470 drivers/net/netdevsim/bus.c:219
> bus_attr_store+0x76/0xa0 drivers/base/bus.c:122
> sysfs_kf_write+0x114/0x170 fs/sysfs/file.c:136
> kernfs_fop_write_iter+0x3f1/0x600 fs/kernfs/file.c:334
> call_write_iter include/linux/fs.h:2186 [inline]
> new_sync_write fs/read_write.c:491 [inline]
> vfs_write+0x9ed/0xdd0 fs/read_write.c:584
> ksys_write+0x12b/0x250 fs/read_write.c:637
> do_syscall_x64 arch/x86/entry/common.c:50 [inline]
> do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
> entry_SYSCALL_64_after_hwframe+0x63/0xcd
>RIP: 0033:0x7fcfd903de4f
>Code: 89 54 24 18 48 89 74 24 10 89 7c 24 08 e8 99 fd ff ff 48 8b 54 24 18 48 8b 74 24 10 41 89 c0 8b 7c 24 08 b8 01 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 31 44 89 c7 48 89 44 24 08 e8 cc fd ff ff 48
>RSP: 002b:00007ffcd827a1d0 EFLAGS: 00000293 ORIG_RAX: 0000000000000001
>RAX: ffffffffffffffda RBX: 0000000000000001 RCX: 00007fcfd903de4f
>RDX: 0000000000000001 RSI: 00007ffcd827a220 RDI: 0000000000000005
>RBP: 0000000000000005 R08: 0000000000000000 R09: 00007ffcd827a170
>R10: 0000000000000000 R11: 0000000000000293 R12: 00007fcfd90e76fe
>R13: 00007ffcd827a220 R14: 0000000000000000 R15: 00007ffcd827a8f0
> </TASK>
>
>
>---
>This report is generated by a bot. It may contain errors.
>See https://goo.gl/tpsmEJ for more information about syzbot.
>syzbot engineers can be reached at syzkaller@googlegroups.com.
>
>syzbot will keep track of this issue. See:
>https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
