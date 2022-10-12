Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCC8D5FC52F
	for <lists+netdev@lfdr.de>; Wed, 12 Oct 2022 14:20:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229623AbiJLMUH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Oct 2022 08:20:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229557AbiJLMUG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Oct 2022 08:20:06 -0400
Received: from mail-yw1-x1130.google.com (mail-yw1-x1130.google.com [IPv6:2607:f8b0:4864:20::1130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 279C21111
        for <netdev@vger.kernel.org>; Wed, 12 Oct 2022 05:20:03 -0700 (PDT)
Received: by mail-yw1-x1130.google.com with SMTP id 00721157ae682-3321c2a8d4cso154004067b3.5
        for <netdev@vger.kernel.org>; Wed, 12 Oct 2022 05:20:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=udueFBIM3j5WdgP6Fcf8GFLqeB62jVPjdscuPwIWGqE=;
        b=aFTryuZrZHT7pX7ho/qMT2X8qpRLqZs/b1HWJ5F7DTwUYsJu/Dn9QTYMOHZO3YTr0v
         hxl1YyHHfynYv9oC1uBxvD4I3I2QrAoGTvibUJgEcJP7xpxgHVGnKIOtYwOMlPpii4uK
         MDR/YtUNAVH4WoZAzt/l1Hy+C9FuQaIVWob5WxvpEfgVNZPs5Osw9a/jjPAk4hgn6/Tr
         xuWi5kZtu+93N2uyJJ+46jvi0ajEOQUAVyRVW9fXOh4uyHLxG2m1z5SybMK4knna16x+
         dSczP/sV0yGPCdDc/7NEopdwkp1Ww5iVGDgOkodr2LKkI2DOnSbWv4hBxg7DmFntpE+w
         C3qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=udueFBIM3j5WdgP6Fcf8GFLqeB62jVPjdscuPwIWGqE=;
        b=4/3Bnnkn14uzB4EFMT8ic3C//XpY9la1fTdsnsYGU2S70x+ZmftZ4i9aKgAHchNCUB
         vA9DNhJnlg3xgXIr2P1kxwn91hTYlCxtd0RrEW1sw9rsuOzdYJ2x65EaauxJ6LJoMnCz
         a+rLtlFmC356QomOYHcwkPca5dAMOzqJS3AHh5Tf4OUWjG3lAw4b52oKIJsGKGcTwenf
         ngCN2QML0iq9Y4u9Ah+4R8BtATHo3FjS5werZ0sMplzcY17RfK/ai/9sKkLyQPUHX4dZ
         4pdPvO2UPZcNvnXn4T1HT2qInnq8yCAhBEKDO2kET5Oc6lrT0L9zVuTONYektFMn0vHR
         qU2w==
X-Gm-Message-State: ACrzQf1yAUROkjIvs5TMv3mTDbKZFw4KkkU6GF0QfeD8c3K30lAbeLwl
        4DapchhihCpZ5OxhqF1XKgFX/EoJNvh1EVnpBVz5hQ==
X-Google-Smtp-Source: AMsMyM4OeUVBJQn+Dio1t9tYJ0bneW94KRckwc3c1yc+FdYsM+nQeQZFxkQJPDFSd4yfPBJaVs1RI/6P+LJMskpgNkg=
X-Received: by 2002:a81:1c07:0:b0:358:6e7d:5118 with SMTP id
 c7-20020a811c07000000b003586e7d5118mr27018934ywc.255.1665577202055; Wed, 12
 Oct 2022 05:20:02 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000c8900705ead19e41@google.com> <CACT4Y+Zuoo_rgf=DP90wgSVm909Qboj5kdYQjZELPDfdkQWJqA@mail.gmail.com>
In-Reply-To: <CACT4Y+Zuoo_rgf=DP90wgSVm909Qboj5kdYQjZELPDfdkQWJqA@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 12 Oct 2022 05:19:50 -0700
Message-ID: <CANn89iLkk75vy6fKMzwQXFEBdyTrQghnFKSxR3HPaeWS4oT+8g@mail.gmail.com>
Subject: Re: [syzbot] kernel panic: kernel stack overflow
To:     Dmitry Vyukov <dvyukov@google.com>, Taehee Yoo <ap420073@gmail.com>
Cc:     syzbot <syzbot+60748c96cf5c6df8e581@syzkaller.appspotmail.com>,
        =?UTF-8?B?SmnFmcOtIFDDrXJrbw==?= <jiri@resnulli.us>,
        davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 12, 2022 at 12:53 AM Dmitry Vyukov <dvyukov@google.com> wrote:
>
> On Wed, 12 Oct 2022 at 09:48, syzbot
> <syzbot+60748c96cf5c6df8e581@syzkaller.appspotmail.com> wrote:
> >
> > Hello,
> >
> > syzbot found the following issue on:
> >
> > HEAD commit:    bbed346d5a96 Merge branch 'for-next/core' into for-kernelci
> > git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
> > console output: https://syzkaller.appspot.com/x/log.txt?x=14a03a2a880000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=aae2d21e7dd80684
> > dashboard link: https://syzkaller.appspot.com/bug?extid=60748c96cf5c6df8e581
> > compiler:       Debian clang version 13.0.1-++20220126092033+75e33f71c2da-1~exp1~20220126212112.63, GNU ld (GNU Binutils for Debian) 2.35.2
> > userspace arch: arm64
> >
> > Unfortunately, I don't have any reproducer for this issue yet.
> >
> > Downloadable assets:
> > disk image: https://storage.googleapis.com/syzbot-assets/11078f50b80b/disk-bbed346d.raw.xz
> > vmlinux: https://storage.googleapis.com/syzbot-assets/398e5f1e6c84/vmlinux-bbed346d.xz
> >
> > IMPORTANT: if you fix the issue, please add the following tag to the commit:
> > Reported-by: syzbot+60748c96cf5c6df8e581@syzkaller.appspotmail.com
>
> +Jiri
>
> It looks like the issue is with the team device. It seems to call
> itself infinitely.
> team_device_event was mentioned in stack overflow bugs in the past:
> https://groups.google.com/g/syzkaller-bugs/search?q=%22team_device_event%22
>


Taehee Yoo, can you take a look ?

Patch series of yours was supposed to limit max nest level to 8

https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git/commit/?id=65921376425fc9c8b7ce647e1f7989f7cdf5dd70




>
> > x8 : 00000000000c008e x7 : ffff80000818cfc0 x6 : 0000000000000000
> > x5 : 0000000000000080 x4 : 0000000000000001 x3 : 0000000000000000
> > x2 : 0000000000000008 x1 : ffff00013e520a60 x0 : ffff00013e520000
> > Kernel panic - not syncing: kernel stack overflow
> > CPU: 1 PID: 16874 Comm: syz-executor.3 Not tainted 6.0.0-rc7-syzkaller-18095-gbbed346d5a96 #0
> > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/30/2022
> > Call trace:
> >  dump_backtrace+0x1c4/0x1f0 arch/arm64/kernel/stacktrace.c:156
> >  show_stack+0x2c/0x54 arch/arm64/kernel/stacktrace.c:163
> >  __dump_stack lib/dump_stack.c:88 [inline]
> >  dump_stack_lvl+0x104/0x16c lib/dump_stack.c:106
> >  dump_stack+0x1c/0x58 lib/dump_stack.c:113
> >  panic+0x218/0x50c kernel/panic.c:274
> >  nmi_panic+0xbc/0xf0 kernel/panic.c:169
> >  panic_bad_stack+0x134/0x154 arch/arm64/kernel/traps.c:906
> >  handle_bad_stack+0x34/0x48 arch/arm64/kernel/entry-common.c:848
> >  __bad_stack+0x78/0x7c arch/arm64/kernel/entry.S:549
> >  mark_lock+0x4/0x1b4 kernel/locking/lockdep.c:4593
> >  lock_acquire+0x100/0x1f8 kernel/locking/lockdep.c:5666
> >  do_write_seqcount_begin_nested include/linux/seqlock.h:516 [inline]
> >  do_write_seqcount_begin include/linux/seqlock.h:541 [inline]
> >  psi_group_change+0x128/0x3d0 kernel/sched/psi.c:705
> >  psi_task_switch+0x9c/0x310 kernel/sched/psi.c:851
> >  psi_sched_switch kernel/sched/stats.h:194 [inline]
> >  __schedule+0x554/0x5a0 kernel/sched/core.c:6489
> >  preempt_schedule_irq+0x64/0x110 kernel/sched/core.c:6806
> >  arm64_preempt_schedule_irq arch/arm64/kernel/entry-common.c:265 [inline]
> >  __el1_irq arch/arm64/kernel/entry-common.c:473 [inline]
> >  el1_interrupt+0x4c/0x68 arch/arm64/kernel/entry-common.c:485
> >  el1h_64_irq_handler+0x18/0x24 arch/arm64/kernel/entry-common.c:490
> >  el1h_64_irq+0x64/0x68 arch/arm64/kernel/entry.S:577
> >  arch_local_irq_restore+0x8/0x10 arch/arm64/include/asm/irqflags.h:122
> >  lock_is_held include/linux/lockdep.h:283 [inline]
> >  __might_resched+0x7c/0x218 kernel/sched/core.c:9854
> >  __might_sleep+0x48/0x78 kernel/sched/core.c:9821
> >  might_alloc include/linux/sched/mm.h:274 [inline]
> >  slab_pre_alloc_hook mm/slab.h:700 [inline]
> >  slab_alloc_node mm/slub.c:3162 [inline]
> >  kmem_cache_alloc_node+0x80/0x370 mm/slub.c:3298
> >  __alloc_skb+0xf8/0x378 net/core/skbuff.c:422
> >  alloc_skb include/linux/skbuff.h:1257 [inline]
> >  nlmsg_new include/net/netlink.h:953 [inline]
> >  genlmsg_new include/net/genetlink.h:410 [inline]
> >  ethnl_default_notify+0x16c/0x320 net/ethtool/netlink.c:640
> >  ethtool_notify+0xb4/0x178 net/ethtool/netlink.c:704
> >  ethnl_notify_features net/ethtool/netlink.c:715 [inline]
> >  ethnl_netdev_event+0x44/0x60 net/ethtool/netlink.c:723
> >  notifier_call_chain kernel/notifier.c:87 [inline]
> >  raw_notifier_call_chain+0x7c/0x108 kernel/notifier.c:455
> >  call_netdevice_notifiers_info net/core/dev.c:1945 [inline]
> >  call_netdevice_notifiers_extack net/core/dev.c:1983 [inline]
> >  call_netdevice_notifiers net/core/dev.c:1997 [inline]
> >  netdev_features_change net/core/dev.c:1315 [inline]
> >  netdev_sync_lower_features+0x13c/0x21c net/core/dev.c:9599
> >  __netdev_update_features+0x284/0xa88 net/core/dev.c:9751
> >  netdev_change_features+0x30/0xfc net/core/dev.c:9823
> >  team_compute_features drivers/net/team/team.c:1031 [inline]
> >  team_device_event+0x1a8/0x25c drivers/net/team/team.c:3024
> >  notifier_call_chain kernel/notifier.c:87 [inline]
> >  raw_notifier_call_chain+0x7c/0x108 kernel/notifier.c:455
> >  call_netdevice_notifiers_info net/core/dev.c:1945 [inline]
> >  call_netdevice_notifiers_extack net/core/dev.c:1983 [inline]
> >  call_netdevice_notifiers net/core/dev.c:1997 [inline]
> >  netdev_features_change net/core/dev.c:1315 [inline]
> >  netdev_sync_lower_features+0x13c/0x21c net/core/dev.c:9599
> >  __netdev_update_features+0x284/0xa88 net/core/dev.c:9751
> >  netdev_change_features+0x30/0xfc net/core/dev.c:9823
> >  team_compute_features drivers/net/team/team.c:1031 [inline]
> >  team_device_event+0x1a8/0x25c drivers/net/team/team.c:3024
> >  notifier_call_chain kernel/notifier.c:87 [inline]
> >  raw_notifier_call_chain+0x7c/0x108 kernel/notifier.c:455
> >  call_netdevice_notifiers_info net/core/dev.c:1945 [inline]
> >  call_netdevice_notifiers_extack net/core/dev.c:1983 [inline]
> >  call_netdevice_notifiers net/core/dev.c:1997 [inline]
> >  netdev_features_change net/core/dev.c:1315 [inline]
> >  netdev_sync_lower_features+0x13c/0x21c net/core/dev.c:9599
> >  __netdev_update_features+0x284/0xa88 net/core/dev.c:9751
> >  netdev_change_features+0x30/0xfc net/core/dev.c:9823
> >  team_compute_features drivers/net/team/team.c:1031 [inline]
> >  team_device_event+0x1a8/0x25c drivers/net/team/team.c:3024
> >  notifier_call_chain kernel/notifier.c:87 [inline]
> >  raw_notifier_call_chain+0x7c/0x108 kernel/notifier.c:455
> >  call_netdevice_notifiers_info net/core/dev.c:1945 [inline]
> >  call_netdevice_notifiers_extack net/core/dev.c:1983 [inline]
> >  call_netdevice_notifiers net/core/dev.c:1997 [inline]
> >  netdev_features_change net/core/dev.c:1315 [inline]
> >  netdev_sync_lower_features+0x13c/0x21c net/core/dev.c:9599
> >  __netdev_update_features+0x284/0xa88 net/core/dev.c:9751
> >  netdev_change_features+0x30/0xfc net/core/dev.c:9823
> >  team_compute_features drivers/net/team/team.c:1031 [inline]
> >  team_device_event+0x1a8/0x25c drivers/net/team/team.c:3024
> >  notifier_call_chain kernel/notifier.c:87 [inline]
> >  raw_notifier_call_chain+0x7c/0x108 kernel/notifier.c:455
> >  call_netdevice_notifiers_info net/core/dev.c:1945 [inline]
> >  call_netdevice_notifiers_extack net/core/dev.c:1983 [inline]
> >  call_netdevice_notifiers net/core/dev.c:1997 [inline]
> >  netdev_features_change net/core/dev.c:1315 [inline]
> >  netdev_sync_lower_features+0x13c/0x21c net/core/dev.c:9599
> >  __netdev_update_features+0x284/0xa88 net/core/dev.c:9751
> >  netdev_change_features+0x30/0xfc net/core/dev.c:9823
> >  team_compute_features drivers/net/team/team.c:1031 [inline]
> >  team_device_event+0x1a8/0x25c drivers/net/team/team.c:3024
> >  notifier_call_chain kernel/notifier.c:87 [inline]
> >  raw_notifier_call_chain+0x7c/0x108 kernel/notifier.c:455
> >  call_netdevice_notifiers_info net/core/dev.c:1945 [inline]
> >  call_netdevice_notifiers_extack net/core/dev.c:1983 [inline]
> >  call_netdevice_notifiers net/core/dev.c:1997 [inline]
> >  netdev_features_change net/core/dev.c:1315 [inline]
> >  netdev_sync_lower_features+0x13c/0x21c net/core/dev.c:9599
> >  __netdev_update_features+0x284/0xa88 net/core/dev.c:9751
> >  netdev_change_features+0x30/0xfc net/core/dev.c:9823
> >  team_compute_features drivers/net/team/team.c:1031 [inline]
> >  team_device_event+0x1a8/0x25c drivers/net/team/team.c:3024
> >  notifier_call_chain kernel/notifier.c:87 [inline]
> >  raw_notifier_call_chain+0x7c/0x108 kernel/notifier.c:455
> >  call_netdevice_notifiers_info net/core/dev.c:1945 [inline]
> >  call_netdevice_notifiers_extack net/core/dev.c:1983 [inline]
> >  call_netdevice_notifiers net/core/dev.c:1997 [inline]
> >  netdev_features_change net/core/dev.c:1315 [inline]
> >  netdev_sync_lower_features+0x13c/0x21c net/core/dev.c:9599
> >  __netdev_update_features+0x284/0xa88 net/core/dev.c:9751
> >  netdev_change_features+0x30/0xfc net/core/dev.c:9823
> >  team_compute_features drivers/net/team/team.c:1031 [inline]
> >  team_device_event+0x1a8/0x25c drivers/net/team/team.c:3024
> >  notifier_call_chain kernel/notifier.c:87 [inline]
> >  raw_notifier_call_chain+0x7c/0x108 kernel/notifier.c:455
> >  call_netdevice_notifiers_info net/core/dev.c:1945 [inline]
> >  call_netdevice_notifiers_extack net/core/dev.c:1983 [inline]
> >  call_netdevice_notifiers net/core/dev.c:1997 [inline]
> >  netdev_features_change net/core/dev.c:1315 [inline]
> >  netdev_sync_lower_features+0x13c/0x21c net/core/dev.c:9599
> >  __netdev_update_features+0x284/0xa88 net/core/dev.c:9751
> >  netdev_change_features+0x30/0xfc net/core/dev.c:9823
> >  team_compute_features drivers/net/team/team.c:1031 [inline]
> >  team_device_event+0x1a8/0x25c drivers/net/team/team.c:3024
> >  notifier_call_chain kernel/notifier.c:87 [inline]
> >  raw_notifier_call_chain+0x7c/0x108 kernel/notifier.c:455
> >  call_netdevice_notifiers_info net/core/dev.c:1945 [inline]
> >  call_netdevice_notifiers_extack net/core/dev.c:1983 [inline]
> >  call_netdevice_notifiers net/core/dev.c:1997 [inline]
> >  netdev_features_change net/core/dev.c:1315 [inline]
> >  netdev_sync_lower_features+0x13c/0x21c net/core/dev.c:9599
> >  __netdev_update_features+0x284/0xa88 net/core/dev.c:9751
> >  netdev_change_features+0x30/0xfc net/core/dev.c:9823
> >  team_compute_features drivers/net/team/team.c:1031 [inline]
> >  team_device_event+0x1a8/0x25c drivers/net/team/team.c:3024
> >  notifier_call_chain kernel/notifier.c:87 [inline]
> >  raw_notifier_call_chain+0x7c/0x108 kernel/notifier.c:455
> >  call_netdevice_notifiers_info net/core/dev.c:1945 [inline]
> >  call_netdevice_notifiers_extack net/core/dev.c:1983 [inline]
> >  call_netdevice_notifiers net/core/dev.c:1997 [inline]
> >  netdev_features_change net/core/dev.c:1315 [inline]
> >  netdev_sync_lower_features+0x13c/0x21c net/core/dev.c:9599
> >  __netdev_update_features+0x284/0xa88 net/core/dev.c:9751
> >  netdev_change_features+0x30/0xfc net/core/dev.c:9823
> >  team_compute_features drivers/net/team/team.c:1031 [inline]
> >  team_device_event+0x1a8/0x25c drivers/net/team/team.c:3024
> >  notifier_call_chain kernel/notifier.c:87 [inline]
> >  raw_notifier_call_chain+0x7c/0x108 kernel/notifier.c:455
> >  call_netdevice_notifiers_info net/core/dev.c:1945 [inline]
> >  call_netdevice_notifiers_extack net/core/dev.c:1983 [inline]
> >  call_netdevice_notifiers net/core/dev.c:1997 [inline]
> >  netdev_features_change net/core/dev.c:1315 [inline]
> >  netdev_sync_lower_features+0x13c/0x21c net/core/dev.c:9599
> >  __netdev_update_features+0x284/0xa88 net/core/dev.c:9751
> >  netdev_change_features+0x30/0xfc net/core/dev.c:9823
> >  team_compute_features drivers/net/team/team.c:1031 [inline]
> >  team_device_event+0x1a8/0x25c drivers/net/team/team.c:3024
> >  notifier_call_chain kernel/notifier.c:87 [inline]
> >  raw_notifier_call_chain+0x7c/0x108 kernel/notifier.c:455
> >  call_netdevice_notifiers_info net/core/dev.c:1945 [inline]
> >  call_netdevice_notifiers_extack net/core/dev.c:1983 [inline]
> >  call_netdevice_notifiers net/core/dev.c:1997 [inline]
> >  netdev_features_change net/core/dev.c:1315 [inline]
> >  netdev_sync_lower_features+0x13c/0x21c net/core/dev.c:9599
> >  __netdev_update_features+0x284/0xa88 net/core/dev.c:9751
> >  netdev_change_features+0x30/0xfc net/core/dev.c:9823
> >  team_compute_features drivers/net/team/team.c:1031 [inline]
> >  team_device_event+0x1a8/0x25c drivers/net/team/team.c:3024
> >  notifier_call_chain kernel/notifier.c:87 [inline]
> >  raw_notifier_call_chain+0x7c/0x108 kernel/notifier.c:455
> >  call_netdevice_notifiers_info net/core/dev.c:1945 [inline]
> >  call_netdevice_notifiers_extack net/core/dev.c:1983 [inline]
> >  call_netdevice_notifiers net/core/dev.c:1997 [inline]
> >  netdev_features_change net/core/dev.c:1315 [inline]
> >  netdev_sync_lower_features+0x13c/0x21c net/core/dev.c:9599
> >  __netdev_update_features+0x284/0xa88 net/core/dev.c:9751
> >  netdev_change_features+0x30/0xfc net/core/dev.c:9823
> >  team_compute_features drivers/net/team/team.c:1031 [inline]
> >  team_device_event+0x1a8/0x25c drivers/net/team/team.c:3024
> >  notifier_call_chain kernel/notifier.c:87 [inline]
> >  raw_notifier_call_chain+0x7c/0x108 kernel/notifier.c:455
> >  call_netdevice_notifiers_info net/core/dev.c:1945 [inline]
> >  call_netdevice_notifiers_extack net/core/dev.c:1983 [inline]
> >  call_netdevice_notifiers net/core/dev.c:1997 [inline]
> >  netdev_features_change net/core/dev.c:1315 [inline]
> >  netdev_sync_lower_features+0x13c/0x21c net/core/dev.c:9599
> >  __netdev_update_features+0x284/0xa88 net/core/dev.c:9751
> >  netdev_change_features+0x30/0xfc net/core/dev.c:9823
> >  team_compute_features drivers/net/team/team.c:1031 [inline]
> >  team_device_event+0x1a8/0x25c drivers/net/team/team.c:3024
> >  notifier_call_chain kernel/notifier.c:87 [inline]
> >  raw_notifier_call_chain+0x7c/0x108 kernel/notifier.c:455
> >  call_netdevice_notifiers_info net/core/dev.c:1945 [inline]
> >  call_netdevice_notifiers_extack net/core/dev.c:1983 [inline]
> >  call_netdevice_notifiers net/core/dev.c:1997 [inline]
> >  netdev_features_change net/core/dev.c:1315 [inline]
> >  netdev_sync_lower_features+0x13c/0x21c net/core/dev.c:9599
> >  __netdev_update_features+0x284/0xa88 net/core/dev.c:9751
> >  netdev_change_features+0x30/0xfc net/core/dev.c:9823
> >  team_compute_features drivers/net/team/team.c:1031 [inline]
> >  team_device_event+0x1a8/0x25c drivers/net/team/team.c:3024
> >  notifier_call_chain kernel/notifier.c:87 [inline]
> >  raw_notifier_call_chain+0x7c/0x108 kernel/notifier.c:455
> >  call_netdevice_notifiers_info net/core/dev.c:1945 [inline]
> >  call_netdevice_notifiers_extack net/core/dev.c:1983 [inline]
> >  call_netdevice_notifiers net/core/dev.c:1997 [inline]
> >  netdev_features_change net/core/dev.c:1315 [inline]
> >  netdev_sync_lower_features+0x13c/0x21c net/core/dev.c:9599
> >  __netdev_update_features+0x284/0xa88 net/core/dev.c:9751
> >  netdev_change_features+0x30/0xfc net/core/dev.c:9823
> >  team_compute_features drivers/net/team/team.c:1031 [inline]
> >  team_device_event+0x1a8/0x25c drivers/net/team/team.c:3024
> >  notifier_call_chain kernel/notifier.c:87 [inline]
> >  raw_notifier_call_chain+0x7c/0x108 kernel/notifier.c:455
> >  call_netdevice_notifiers_info net/core/dev.c:1945 [inline]
> >  call_netdevice_notifiers_extack net/core/dev.c:1983 [inline]
> >  call_netdevice_notifiers net/core/dev.c:1997 [inline]
> >  netdev_features_change net/core/dev.c:1315 [inline]
> >  netdev_sync_lower_features+0x13c/0x21c net/core/dev.c:9599
> >  __netdev_update_features+0x284/0xa88 net/core/dev.c:9751
> >  netdev_change_features+0x30/0xfc net/core/dev.c:9823
> >  team_compute_features drivers/net/team/team.c:1031 [inline]
> >  team_device_event+0x1a8/0x25c drivers/net/team/team.c:3024
> >  notifier_call_chain kernel/notifier.c:87 [inline]
> >  raw_notifier_call_chain+0x7c/0x108 kernel/notifier.c:455
> >  call_netdevice_notifiers_info net/core/dev.c:1945 [inline]
> >  call_netdevice_notifiers_extack net/core/dev.c:1983 [inline]
> >  call_netdevice_notifiers net/core/dev.c:1997 [inline]
> >  netdev_features_change net/core/dev.c:1315 [inline]
> >  netdev_sync_lower_features+0x13c/0x21c net/core/dev.c:9599
> >  __netdev_update_features+0x284/0xa88 net/core/dev.c:9751
> >  netdev_change_features+0x30/0xfc net/core/dev.c:9823
> >  team_compute_features drivers/net/team/team.c:1031 [inline]
> >  team_device_event+0x1a8/0x25c drivers/net/team/team.c:3024
> >  notifier_call_chain kernel/notifier.c:87 [inline]
> >  raw_notifier_call_chain+0x7c/0x108 kernel/notifier.c:455
> >  call_netdevice_notifiers_info net/core/dev.c:1945 [inline]
> >  call_netdevice_notifiers_extack net/core/dev.c:1983 [inline]
> >  call_netdevice_notifiers net/core/dev.c:1997 [inline]
> >  netdev_features_change net/core/dev.c:1315 [inline]
> >  netdev_sync_lower_features+0x13c/0x21c net/core/dev.c:9599
> >  __netdev_update_features+0x284/0xa88 net/core/dev.c:9751
> >  netdev_change_features+0x30/0xfc net/core/dev.c:9823
> >  team_compute_features drivers/net/team/team.c:1031 [inline]
> >  team_device_event+0x1a8/0x25c drivers/net/team/team.c:3024
> >  notifier_call_chain kernel/notifier.c:87 [inline]
> >  raw_notifier_call_chain+0x7c/0x108 kernel/notifier.c:455
> >  call_netdevice_notifiers_info net/core/dev.c:1945 [inline]
> >  call_netdevice_notifiers_extack net/core/dev.c:1983 [inline]
> >  call_netdevice_notifiers net/core/dev.c:1997 [inline]
> >  netdev_features_change net/core/dev.c:1315 [inline]
> >  netdev_sync_lower_features+0x13c/0x21c net/core/dev.c:9599
> >  __netdev_update_features+0x284/0xa88 net/core/dev.c:9751
> >  netdev_change_features+0x30/0xfc net/core/dev.c:9823
> >  team_compute_features drivers/net/team/team.c:1031 [inline]
> >  team_device_event+0x1a8/0x25c drivers/net/team/team.c:3024
> >  notifier_call_chain kernel/notifier.c:87 [inline]
> >  raw_notifier_call_chain+0x7c/0x108 kernel/notifier.c:455
> >  call_netdevice_notifiers_info net/core/dev.c:1945 [inline]
> >  call_netdevice_notifiers_extack net/core/dev.c:1983 [inline]
> >  call_netdevice_notifiers net/core/dev.c:1997 [inline]
> >  netdev_features_change net/core/dev.c:1315 [inline]
> >  netdev_sync_lower_features+0x13c/0x21c net/core/dev.c:9599
> >  __netdev_update_features+0x284/0xa88 net/core/dev.c:9751
> >  netdev_change_features+0x30/0xfc net/core/dev.c:9823
> >  team_compute_features drivers/net/team/team.c:1031 [inline]
> >  team_device_event+0x1a8/0x25c drivers/net/team/team.c:3024
> >  notifier_call_chain kernel/notifier.c:87 [inline]
> >  raw_notifier_call_chain+0x7c/0x108 kernel/notifier.c:455
> >  call_netdevice_notifiers_info net/core/dev.c:1945 [inline]
> >  call_netdevice_notifiers_extack net/core/dev.c:1983 [inline]
> >  call_netdevice_notifiers net/core/dev.c:1997 [inline]
> >  netdev_features_change net/core/dev.c:1315 [inline]
> >  netdev_sync_lower_features+0x13c/0x21c net/core/dev.c:9599
> >  __netdev_update_features+0x284/0xa88 net/core/dev.c:9751
> >  netdev_change_features+0x30/0xfc net/core/dev.c:9823
> >  team_compute_features drivers/net/team/team.c:1031 [inline]
> >  team_device_event+0x1a8/0x25c drivers/net/team/team.c:3024
> >  notifier_call_chain kernel/notifier.c:87 [inline]
> >  raw_notifier_call_chain+0x7c/0x108 kernel/notifier.c:455
> >  call_netdevice_notifiers_info net/core/dev.c:1945 [inline]
> >  call_netdevice_notifiers_extack net/core/dev.c:1983 [inline]
> >  call_netdevice_notifiers net/core/dev.c:1997 [inline]
> >  netdev_features_change net/core/dev.c:1315 [inline]
> >  netdev_sync_lower_features+0x13c/0x21c net/core/dev.c:9599
> >  __netdev_update_features+0x284/0xa88 net/core/dev.c:9751
> >  netdev_change_features+0x30/0xfc net/core/dev.c:9823
> >  team_compute_features drivers/net/team/team.c:1031 [inline]
> >  team_device_event+0x1a8/0x25c drivers/net/team/team.c:3024
> >  notifier_call_chain kernel/notifier.c:87 [inline]
> >  raw_notifier_call_chain+0x7c/0x108 kernel/notifier.c:455
> >  call_netdevice_notifiers_info net/core/dev.c:1945 [inline]
> >  call_netdevice_notifiers_extack net/core/dev.c:1983 [inline]
> >  call_netdevice_notifiers net/core/dev.c:1997 [inline]
> >  netdev_features_change net/core/dev.c:1315 [inline]
> >  netdev_sync_lower_features+0x13c/0x21c net/core/dev.c:9599
> >  __netdev_update_features+0x284/0xa88 net/core/dev.c:9751
> >  netdev_change_features+0x30/0xfc net/core/dev.c:9823
> >  team_compute_features drivers/net/team/team.c:1031 [inline]
> >  team_device_event+0x1a8/0x25c drivers/net/team/team.c:3024
> >  notifier_call_chain kernel/notifier.c:87 [inline]
> >  raw_notifier_call_chain+0x7c/0x108 kernel/notifier.c:455
> >  call_netdevice_notifiers_info net/core/dev.c:1945 [inline]
> >  call_netdevice_notifiers_extack net/core/dev.c:1983 [inline]
> >  call_netdevice_notifiers net/core/dev.c:1997 [inline]
> >  netdev_features_change net/core/dev.c:1315 [inline]
> >  netdev_sync_lower_features+0x13c/0x21c net/core/dev.c:9599
> >  __netdev_update_features+0x284/0xa88 net/core/dev.c:9751
> >  netdev_change_features+0x30/0xfc net/core/dev.c:9823
> >  team_compute_features drivers/net/team/team.c:1031 [inline]
> >  team_device_event+0x1a8/0x25c drivers/net/team/team.c:3024
> >  notifier_call_chain kernel/notifier.c:87 [inline]
> >  raw_notifier_call_chain+0x7c/0x108 kernel/notifier.c:455
> >  call_netdevice_notifiers_info net/core/dev.c:1945 [inline]
> >  call_netdevice_notifiers_extack net/core/dev.c:1983 [inline]
> >  call_netdevice_notifiers net/core/dev.c:1997 [inline]
> >  netdev_features_change net/core/dev.c:1315 [inline]
> >  netdev_sync_lower_features+0x13c/0x21c net/core/dev.c:9599
> >  __netdev_update_features+0x284/0xa88 net/core/dev.c:9751
> >  netdev_change_features+0x30/0xfc net/core/dev.c:9823
> >  team_compute_features drivers/net/team/team.c:1031 [inline]
> >  team_device_event+0x1a8/0x25c drivers/net/team/team.c:3024
> >  notifier_call_chain kernel/notifier.c:87 [inline]
> >  raw_notifier_call_chain+0x7c/0x108 kernel/notifier.c:455
> >  call_netdevice_notifiers_info net/core/dev.c:1945 [inline]
> >  call_netdevice_notifiers_extack net/core/dev.c:1983 [inline]
> >  call_netdevice_notifiers net/core/dev.c:1997 [inline]
> >  netdev_features_change net/core/dev.c:1315 [inline]
> >  netdev_sync_lower_features+0x13c/0x21c net/core/dev.c:9599
> >  __netdev_update_features+0x284/0xa88 net/core/dev.c:9751
> >  netdev_change_features+0x30/0xfc net/core/dev.c:9823
> >  team_compute_features drivers/net/team/team.c:1031 [inline]
> >  team_device_event+0x1a8/0x25c drivers/net/team/team.c:3024
> >  notifier_call_chain kernel/notifier.c:87 [inline]
> >  raw_notifier_call_chain+0x7c/0x108 kernel/notifier.c:455
> >  call_netdevice_notifiers_info net/core/dev.c:1945 [inline]
> >  call_netdevice_notifiers_extack net/core/dev.c:1983 [inline]
> >  call_netdevice_notifiers net/core/dev.c:1997 [inline]
> >  netdev_features_change net/core/dev.c:1315 [inline]
> >  netdev_sync_lower_features+0x13c/0x21c net/core/dev.c:9599
> >  __netdev_update_features+0x284/0xa88 net/core/dev.c:9751
> >  netdev_change_features+0x30/0xfc net/core/dev.c:9823
> >  team_compute_features drivers/net/team/team.c:1031 [inline]
> >  team_device_event+0x1a8/0x25c drivers/net/team/team.c:3024
> >  notifier_call_chain kernel/notifier.c:87 [inline]
> >  raw_notifier_call_chain+0x7c/0x108 kernel/notifier.c:455
> >  call_netdevice_notifiers_info net/core/dev.c:1945 [inline]
> >  call_netdevice_notifiers_extack net/core/dev.c:1983 [inline]
> >  call_netdevice_notifiers net/core/dev.c:1997 [inline]
> >  netdev_features_change net/core/dev.c:1315 [inline]
> >  netdev_sync_lower_features+0x13c/0x21c net/core/dev.c:9599
> >  __netdev_update_features+0x284/0xa88 net/core/dev.c:9751
> >  netdev_change_features+0x30/0xfc net/core/dev.c:9823
> >  team_add_slave+0x7c/0x98 drivers/net/team/team.c:1988
> >  do_set_master net/core/rtnetlink.c:2577 [inline]
> >  do_setlink+0x5f8/0x17a4 net/core/rtnetlink.c:2787
> >  __rtnl_newlink net/core/rtnetlink.c:3546 [inline]
> >  rtnl_newlink+0x988/0xa04 net/core/rtnetlink.c:3593
> >  rtnetlink_rcv_msg+0x484/0x82c net/core/rtnetlink.c:6090
> >  netlink_rcv_skb+0xe4/0x1d0 net/netlink/af_netlink.c:2501
> >  rtnetlink_rcv+0x28/0x38 net/core/rtnetlink.c:6108
> >  netlink_unicast_kernel+0xfc/0x1dc net/netlink/af_netlink.c:1319
> >  netlink_unicast+0x164/0x248 net/netlink/af_netlink.c:1345
> >  netlink_sendmsg+0x484/0x584 net/netlink/af_netlink.c:1921
> >  sock_sendmsg_nosec net/socket.c:714 [inline]
> >  sock_sendmsg net/socket.c:734 [inline]
> >  ____sys_sendmsg+0x2f8/0x440 net/socket.c:2482
> >  ___sys_sendmsg net/socket.c:2536 [inline]
> >  __sys_sendmsg+0x1ac/0x228 net/socket.c:2565
> >  __do_sys_sendmsg net/socket.c:2574 [inline]
> >  __se_sys_sendmsg net/socket.c:2572 [inline]
> >  __arm64_sys_sendmsg+0x2c/0x3c net/socket.c:2572
> >  __invoke_syscall arch/arm64/kernel/syscall.c:38 [inline]
> >  invoke_syscall arch/arm64/kernel/syscall.c:52 [inline]
> >  el0_svc_common+0x138/0x220 arch/arm64/kernel/syscall.c:142
> >  do_el0_svc+0x48/0x164 arch/arm64/kernel/syscall.c:206
> >  el0_svc+0x58/0x150 arch/arm64/kernel/entry-common.c:636
> >  el0t_64_sync_handler+0x84/0xf0 arch/arm64/kernel/entry-common.c:654
> >  el0t_64_sync+0x18c/0x190 arch/arm64/kernel/entry.S:581
> > SMP: stopping secondary CPUs
> > Kernel Offset: disabled
> > CPU features: 0x00000,02070084,26017203
> > Memory Limit: none
> >
> >
> > ---
> > This report is generated by a bot. It may contain errors.
> > See https://goo.gl/tpsmEJ for more information about syzbot.
> > syzbot engineers can be reached at syzkaller@googlegroups.com.
> >
> > syzbot will keep track of this issue. See:
> > https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> >
> > --
> > You received this message because you are subscribed to the Google Groups "syzkaller-bugs" group.
> > To unsubscribe from this group and stop receiving emails from it, send an email to syzkaller-bugs+unsubscribe@googlegroups.com.
> > To view this discussion on the web visit https://groups.google.com/d/msgid/syzkaller-bugs/000000000000c8900705ead19e41%40google.com.
