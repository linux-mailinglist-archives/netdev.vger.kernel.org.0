Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BC1E5FC966
	for <lists+netdev@lfdr.de>; Wed, 12 Oct 2022 18:43:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230071AbiJLQm4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Oct 2022 12:42:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229963AbiJLQmx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Oct 2022 12:42:53 -0400
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E543CC7079
        for <netdev@vger.kernel.org>; Wed, 12 Oct 2022 09:42:51 -0700 (PDT)
Received: by mail-yb1-xb2e.google.com with SMTP id n74so20635450yba.11
        for <netdev@vger.kernel.org>; Wed, 12 Oct 2022 09:42:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=h+F92RkYhFsQOtGvE4sV1yhvRS5q4N+++0G7TOCIAAE=;
        b=VuhOIML5x4p+9jPGYEHYx6Qe2CMLDGInQ/ECsOzVpu4IZw1lnu8FcoTxAIMumN07Ta
         o+rRjfV2MLOCIW7hVl6MaPjMe0in5B16itWcHjIm4tMv+NAnmKfFX0AMpMMtawsM5F2L
         IWexc3OnT5WCSgf2rh4BPw3xeUUQAFqZT93Z87FEz0WwEvMatlFiEfXkAVNq3F06+/fh
         V4hoKHVerte5F8B7AM4VPFHvv7F4PxVM8cPrYwrr1Rn+UeuAgXm63DbSstk0vK/qrLWs
         Ep569RfFUSidGtCgeGK+JSP+ub9B5YdstWTmm9afjj75e9fFYZq6d4Fh08iH/TYGaU9B
         63rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=h+F92RkYhFsQOtGvE4sV1yhvRS5q4N+++0G7TOCIAAE=;
        b=79YYJ5xV6GYp/A8gGZzDVcxivHzuWy/ZB/Wl8wu5AgENI2Nr0TvhFirXByvPsfu/VK
         ip4R2qrhrA2Lnw+u3lT/iL0aN+VrEQ6+8d7I4dPi35t2DiMuFt9cgpy2oyjLHSSmk9Tx
         mU+1iGmRWeweb7P+sfalBWzznOp7tA/mLl1lAfl7Znk7j8wO/7nVmarMsiWN78ZVZDUy
         2EVzhWizEgj9KkUQoOsUSvLBkNQ5lwASeDOvQbBFmweOJY5y/F4XamaPVNe/Tc7MFHqA
         uKmU9tWeBwmQ85I9oL0YXLEXSHdOttTawbiVdBnwUa5xplTV0/+ePD8PVyBsqYFPsf8L
         mUfw==
X-Gm-Message-State: ACrzQf2Mgis+PhDjPFUe3ArFf8Q/msjJEa5aZ0EWXFArzekVr9JqzRA+
        6fYLpHMyPb+DpvWKJx4nhN4QiKVu5deE7ruDt0FHQA==
X-Google-Smtp-Source: AMsMyM5g7D0QJR6D9Y7lwdZi6CeG6LDwJJrFsoaiu1ULmyoxX4cZeR698SIeWkkGe+mNs9fVkcMzaOfiYgqQvj+h8Q0=
X-Received: by 2002:a25:7a01:0:b0:6b0:820:dd44 with SMTP id
 v1-20020a257a01000000b006b00820dd44mr26544935ybc.387.1665592970881; Wed, 12
 Oct 2022 09:42:50 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000c8900705ead19e41@google.com> <CACT4Y+Zuoo_rgf=DP90wgSVm909Qboj5kdYQjZELPDfdkQWJqA@mail.gmail.com>
 <Y0a88zDFLVeVzBPB@nanopsycho> <CACT4Y+Z4CCBqyNJCNySYEWUFT-GOfEjYguBfUh_nb6aAe1w99Q@mail.gmail.com>
 <Y0bYaPsJDG1KvqKG@nanopsycho>
In-Reply-To: <Y0bYaPsJDG1KvqKG@nanopsycho>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 12 Oct 2022 09:42:39 -0700
Message-ID: <CANn89i+AN-6FrEhbGM_3JCAW9esRhdhka-=aXQYkxTP2+VGJ-w@mail.gmail.com>
Subject: Re: [syzbot] kernel panic: kernel stack overflow
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Dmitry Vyukov <dvyukov@google.com>,
        syzbot <syzbot+60748c96cf5c6df8e581@syzkaller.appspotmail.com>,
        davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 12, 2022 at 8:08 AM Jiri Pirko <jiri@resnulli.us> wrote:
>
> Wed, Oct 12, 2022 at 03:54:59PM CEST, dvyukov@google.com wrote:
> >On Wed, 12 Oct 2022 at 15:11, Jiri Pirko <jiri@resnulli.us> wrote:
> >>
> >> Wed, Oct 12, 2022 at 09:53:27AM CEST, dvyukov@google.com wrote:
> >> >On Wed, 12 Oct 2022 at 09:48, syzbot
> >> ><syzbot+60748c96cf5c6df8e581@syzkaller.appspotmail.com> wrote:
> >> >>
> >> >> Hello,
> >> >>
> >> >> syzbot found the following issue on:
> >> >>
> >> >> HEAD commit:    bbed346d5a96 Merge branch 'for-next/core' into for-kernelci
> >> >> git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
> >> >> console output: https://syzkaller.appspot.com/x/log.txt?x=14a03a2a880000
> >> >> kernel config:  https://syzkaller.appspot.com/x/.config?x=aae2d21e7dd80684
> >> >> dashboard link: https://syzkaller.appspot.com/bug?extid=60748c96cf5c6df8e581
> >> >> compiler:       Debian clang version 13.0.1-++20220126092033+75e33f71c2da-1~exp1~20220126212112.63, GNU ld (GNU Binutils for Debian) 2.35.2
> >> >> userspace arch: arm64
> >> >>
> >> >> Unfortunately, I don't have any reproducer for this issue yet.
> >> >>
> >> >> Downloadable assets:
> >> >> disk image: https://storage.googleapis.com/syzbot-assets/11078f50b80b/disk-bbed346d.raw.xz
> >> >> vmlinux: https://storage.googleapis.com/syzbot-assets/398e5f1e6c84/vmlinux-bbed346d.xz
> >> >>
> >> >> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> >> >> Reported-by: syzbot+60748c96cf5c6df8e581@syzkaller.appspotmail.com
> >> >
> >> >+Jiri
> >> >
> >> >It looks like the issue is with the team device. It seems to call
> >> >itself infinitely.
> >> >team_device_event was mentioned in stack overflow bugs in the past:
> >> >https://groups.google.com/g/syzkaller-bugs/search?q=%22team_device_event%22
> >>
> >> Hi, do you have dmesg output available by any chance?
> >
> >Hi Jiri,
> >
> >syzbot attaches dmesg output to every report under the "console output" link.
>
> I see. I guess the debug messages are not printed out, I don't see them
> there. Would it be possible to turn them on?

What debug messages do you need ?

There is a nice stack trace [1] with file:number available


My guess was that for some reason the team driver does not enforce a
max nest level of 8 ?

https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git/commit/?id=65921376425fc9c8b7ce647e1f7989f7cdf5dd70


[1]
CPU: 1 PID: 16874 Comm: syz-executor.3 Not tainted
6.0.0-rc7-syzkaller-18095-gbbed346d5a96 #0
Hardware name: Google Google Compute Engine/Google Compute Engine,
BIOS Google 09/30/2022
Call trace:
 dump_backtrace+0x1c4/0x1f0 arch/arm64/kernel/stacktrace.c:156
 show_stack+0x2c/0x54 arch/arm64/kernel/stacktrace.c:163
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0x104/0x16c lib/dump_stack.c:106
 dump_stack+0x1c/0x58 lib/dump_stack.c:113
 panic+0x218/0x50c kernel/panic.c:274
 nmi_panic+0xbc/0xf0 kernel/panic.c:169
 panic_bad_stack+0x134/0x154 arch/arm64/kernel/traps.c:906
 handle_bad_stack+0x34/0x48 arch/arm64/kernel/entry-common.c:848
 __bad_stack+0x78/0x7c arch/arm64/kernel/entry.S:549
 mark_lock+0x4/0x1b4 kernel/locking/lockdep.c:4593
 lock_acquire+0x100/0x1f8 kernel/locking/lockdep.c:5666
 do_write_seqcount_begin_nested include/linux/seqlock.h:516 [inline]
 do_write_seqcount_begin include/linux/seqlock.h:541 [inline]
 psi_group_change+0x128/0x3d0 kernel/sched/psi.c:705
 psi_task_switch+0x9c/0x310 kernel/sched/psi.c:851
 psi_sched_switch kernel/sched/stats.h:194 [inline]
 __schedule+0x554/0x5a0 kernel/sched/core.c:6489
 preempt_schedule_irq+0x64/0x110 kernel/sched/core.c:6806
 arm64_preempt_schedule_irq arch/arm64/kernel/entry-common.c:265 [inline]
 __el1_irq arch/arm64/kernel/entry-common.c:473 [inline]
 el1_interrupt+0x4c/0x68 arch/arm64/kernel/entry-common.c:485
 el1h_64_irq_handler+0x18/0x24 arch/arm64/kernel/entry-common.c:490
 el1h_64_irq+0x64/0x68 arch/arm64/kernel/entry.S:577
 arch_local_irq_restore+0x8/0x10 arch/arm64/include/asm/irqflags.h:122
 lock_is_held include/linux/lockdep.h:283 [inline]
 __might_resched+0x7c/0x218 kernel/sched/core.c:9854
 __might_sleep+0x48/0x78 kernel/sched/core.c:9821
 might_alloc include/linux/sched/mm.h:274 [inline]
 slab_pre_alloc_hook mm/slab.h:700 [inline]
 slab_alloc_node mm/slub.c:3162 [inline]
 kmem_cache_alloc_node+0x80/0x370 mm/slub.c:3298
 __alloc_skb+0xf8/0x378 net/core/skbuff.c:422
 alloc_skb include/linux/skbuff.h:1257 [inline]
 nlmsg_new include/net/netlink.h:953 [inline]
 genlmsg_new include/net/genetlink.h:410 [inline]
 ethnl_default_notify+0x16c/0x320 net/ethtool/netlink.c:640
...
