Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 660C55FD564
	for <lists+netdev@lfdr.de>; Thu, 13 Oct 2022 09:11:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229573AbiJMHLe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Oct 2022 03:11:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229660AbiJMHLP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Oct 2022 03:11:15 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97E93114DEB
        for <netdev@vger.kernel.org>; Thu, 13 Oct 2022 00:11:09 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id 13so1952736ejn.3
        for <netdev@vger.kernel.org>; Thu, 13 Oct 2022 00:11:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=NW8B2A4IOWuKOdLEgcuPTswvtWIBJW4ugM3qn1pYU6g=;
        b=WVlWFONPAmcJz+b5FrHbw1XDPOcSGVqpYQEWv5efU6Aw2pUAWNyRgY08rPVd2F/UuS
         cu+JCwwJrB8OiPe8p+3JZ9KT6/uvOxOOtYvE+xn6Tji2xaNhKtCJcOrYg+pYh2Ipa8JZ
         ghTRipGho321op6CiyHmEG8RHLGr228q32tZFmRhyl+3AWiWo+jjoBJqb+heO7eQUkhX
         MzuHdf76XFuS8BTwHeb9RapS+8Zwf7F+nLS6u6NyReodp2qqUO2ZvNm2CqiUiDnpDvQB
         mJUDUpEP4Iuh6/xI5w7ebLXkyHaDc+LE8XLiKNSdLCvScJ44k4zMJvo2XhX4lNa35t2Q
         RagQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NW8B2A4IOWuKOdLEgcuPTswvtWIBJW4ugM3qn1pYU6g=;
        b=081o5DjfdjoFON3so5zeX49oN9wPpGBaN2QhflJ9Sfs4vrqpFx5FJKg92TOwOhtPLI
         rLoQTa5NsX8c9/huDmgMbCwmuyNB4T3Urmy1073x2VeEVGmgDah3lRmTWxyoemwQPxNK
         NX2/DzIj38swupaeDcOX5+O5bbf4/4Tc7kDebrkP6lumVU6+5rBv9IPJHFUSKYZdhnO9
         YfgnLcV4Tp254SQR+i8Ndx6YfutBIPwHHa5qWsh+hNJiX4JNEF71N4O5M7wk7qKOENnB
         QGk7cdo2q7CMIj6Z4M0pzvzoUDb5DVlhqv2NYs0FTt++ZAUGOJ70WnFabQE42cE0Bh/0
         l+aA==
X-Gm-Message-State: ACrzQf3oZV39ThmXDDsa9SehjMad7CaTiEjwsEui/Q7ecQTY5puZG1Fl
        YzY8Ew2yy5nyu+pRTE6ZOU4HGQ==
X-Google-Smtp-Source: AMsMyM4A6LfMzg1ccK/c1clSzVllxMcEFWT6512S/P4zuEiRBQDfCTHEDXYEX9UAXaPRSM7gNpT9+w==
X-Received: by 2002:a17:906:da85:b0:741:40a7:d08d with SMTP id xh5-20020a170906da8500b0074140a7d08dmr26757892ejb.263.1665645067965;
        Thu, 13 Oct 2022 00:11:07 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id t21-20020a170906609500b007402796f065sm2471592ejj.132.2022.10.13.00.11.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Oct 2022 00:11:07 -0700 (PDT)
Date:   Thu, 13 Oct 2022 09:11:06 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Eric Dumazet <edumazet@google.com>
Cc:     Dmitry Vyukov <dvyukov@google.com>,
        syzbot <syzbot+60748c96cf5c6df8e581@syzkaller.appspotmail.com>,
        davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com,
        syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] kernel panic: kernel stack overflow
Message-ID: <Y0e6CiwphoN+dlfV@nanopsycho>
References: <000000000000c8900705ead19e41@google.com>
 <CACT4Y+Zuoo_rgf=DP90wgSVm909Qboj5kdYQjZELPDfdkQWJqA@mail.gmail.com>
 <Y0a88zDFLVeVzBPB@nanopsycho>
 <CACT4Y+Z4CCBqyNJCNySYEWUFT-GOfEjYguBfUh_nb6aAe1w99Q@mail.gmail.com>
 <Y0bYaPsJDG1KvqKG@nanopsycho>
 <CANn89i+AN-6FrEhbGM_3JCAW9esRhdhka-=aXQYkxTP2+VGJ-w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANn89i+AN-6FrEhbGM_3JCAW9esRhdhka-=aXQYkxTP2+VGJ-w@mail.gmail.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Oct 12, 2022 at 06:42:39PM CEST, edumazet@google.com wrote:
>On Wed, Oct 12, 2022 at 8:08 AM Jiri Pirko <jiri@resnulli.us> wrote:
>>
>> Wed, Oct 12, 2022 at 03:54:59PM CEST, dvyukov@google.com wrote:
>> >On Wed, 12 Oct 2022 at 15:11, Jiri Pirko <jiri@resnulli.us> wrote:
>> >>
>> >> Wed, Oct 12, 2022 at 09:53:27AM CEST, dvyukov@google.com wrote:
>> >> >On Wed, 12 Oct 2022 at 09:48, syzbot
>> >> ><syzbot+60748c96cf5c6df8e581@syzkaller.appspotmail.com> wrote:
>> >> >>
>> >> >> Hello,
>> >> >>
>> >> >> syzbot found the following issue on:
>> >> >>
>> >> >> HEAD commit:    bbed346d5a96 Merge branch 'for-next/core' into for-kernelci
>> >> >> git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
>> >> >> console output: https://syzkaller.appspot.com/x/log.txt?x=14a03a2a880000
>> >> >> kernel config:  https://syzkaller.appspot.com/x/.config?x=aae2d21e7dd80684
>> >> >> dashboard link: https://syzkaller.appspot.com/bug?extid=60748c96cf5c6df8e581
>> >> >> compiler:       Debian clang version 13.0.1-++20220126092033+75e33f71c2da-1~exp1~20220126212112.63, GNU ld (GNU Binutils for Debian) 2.35.2
>> >> >> userspace arch: arm64
>> >> >>
>> >> >> Unfortunately, I don't have any reproducer for this issue yet.
>> >> >>
>> >> >> Downloadable assets:
>> >> >> disk image: https://storage.googleapis.com/syzbot-assets/11078f50b80b/disk-bbed346d.raw.xz
>> >> >> vmlinux: https://storage.googleapis.com/syzbot-assets/398e5f1e6c84/vmlinux-bbed346d.xz
>> >> >>
>> >> >> IMPORTANT: if you fix the issue, please add the following tag to the commit:
>> >> >> Reported-by: syzbot+60748c96cf5c6df8e581@syzkaller.appspotmail.com
>> >> >
>> >> >+Jiri
>> >> >
>> >> >It looks like the issue is with the team device. It seems to call
>> >> >itself infinitely.
>> >> >team_device_event was mentioned in stack overflow bugs in the past:
>> >> >https://groups.google.com/g/syzkaller-bugs/search?q=%22team_device_event%22
>> >>
>> >> Hi, do you have dmesg output available by any chance?
>> >
>> >Hi Jiri,
>> >
>> >syzbot attaches dmesg output to every report under the "console output" link.
>>
>> I see. I guess the debug messages are not printed out, I don't see them
>> there. Would it be possible to turn them on?
>
>What debug messages do you need ?
>
>There is a nice stack trace [1] with file:number available

Sure, but there are no debug printks that are printed out during feature
processing. That could shed some light on if this is caused by lack of
nest level enforce or perhaps for some reason repetitive processing
of the same team-port netdevice couple in loop.

>
>
>My guess was that for some reason the team driver does not enforce a
>max nest level of 8 ?
>
>https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git/commit/?id=65921376425fc9c8b7ce647e1f7989f7cdf5dd70
>
>
>[1]
>CPU: 1 PID: 16874 Comm: syz-executor.3 Not tainted
>6.0.0-rc7-syzkaller-18095-gbbed346d5a96 #0
>Hardware name: Google Google Compute Engine/Google Compute Engine,
>BIOS Google 09/30/2022
>Call trace:
> dump_backtrace+0x1c4/0x1f0 arch/arm64/kernel/stacktrace.c:156
> show_stack+0x2c/0x54 arch/arm64/kernel/stacktrace.c:163
> __dump_stack lib/dump_stack.c:88 [inline]
> dump_stack_lvl+0x104/0x16c lib/dump_stack.c:106
> dump_stack+0x1c/0x58 lib/dump_stack.c:113
> panic+0x218/0x50c kernel/panic.c:274
> nmi_panic+0xbc/0xf0 kernel/panic.c:169
> panic_bad_stack+0x134/0x154 arch/arm64/kernel/traps.c:906
> handle_bad_stack+0x34/0x48 arch/arm64/kernel/entry-common.c:848
> __bad_stack+0x78/0x7c arch/arm64/kernel/entry.S:549
> mark_lock+0x4/0x1b4 kernel/locking/lockdep.c:4593
> lock_acquire+0x100/0x1f8 kernel/locking/lockdep.c:5666
> do_write_seqcount_begin_nested include/linux/seqlock.h:516 [inline]
> do_write_seqcount_begin include/linux/seqlock.h:541 [inline]
> psi_group_change+0x128/0x3d0 kernel/sched/psi.c:705
> psi_task_switch+0x9c/0x310 kernel/sched/psi.c:851
> psi_sched_switch kernel/sched/stats.h:194 [inline]
> __schedule+0x554/0x5a0 kernel/sched/core.c:6489
> preempt_schedule_irq+0x64/0x110 kernel/sched/core.c:6806
> arm64_preempt_schedule_irq arch/arm64/kernel/entry-common.c:265 [inline]
> __el1_irq arch/arm64/kernel/entry-common.c:473 [inline]
> el1_interrupt+0x4c/0x68 arch/arm64/kernel/entry-common.c:485
> el1h_64_irq_handler+0x18/0x24 arch/arm64/kernel/entry-common.c:490
> el1h_64_irq+0x64/0x68 arch/arm64/kernel/entry.S:577
> arch_local_irq_restore+0x8/0x10 arch/arm64/include/asm/irqflags.h:122
> lock_is_held include/linux/lockdep.h:283 [inline]
> __might_resched+0x7c/0x218 kernel/sched/core.c:9854
> __might_sleep+0x48/0x78 kernel/sched/core.c:9821
> might_alloc include/linux/sched/mm.h:274 [inline]
> slab_pre_alloc_hook mm/slab.h:700 [inline]
> slab_alloc_node mm/slub.c:3162 [inline]
> kmem_cache_alloc_node+0x80/0x370 mm/slub.c:3298
> __alloc_skb+0xf8/0x378 net/core/skbuff.c:422
> alloc_skb include/linux/skbuff.h:1257 [inline]
> nlmsg_new include/net/netlink.h:953 [inline]
> genlmsg_new include/net/genetlink.h:410 [inline]
> ethnl_default_notify+0x16c/0x320 net/ethtool/netlink.c:640
>...
