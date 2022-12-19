Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B88EA651354
	for <lists+netdev@lfdr.de>; Mon, 19 Dec 2022 20:33:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232616AbiLSTdf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Dec 2022 14:33:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232332AbiLSTdd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Dec 2022 14:33:33 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DDEB120BA
        for <netdev@vger.kernel.org>; Mon, 19 Dec 2022 11:33:32 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id n190-20020a25dac7000000b007447d7a25e4so4559414ybf.9
        for <netdev@vger.kernel.org>; Mon, 19 Dec 2022 11:33:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=1BXl9vy0f2f/11VKxHLckXglqOMtK0anh34YjL4SpoA=;
        b=gglIK/h4ez0+aqt1O+U+ScB+Bh/FoHfv+OJW2X6p/mpdxgf9sq0WpIXhUJ5u7bEa4H
         10mjJki54ttBlnuEVGRrt4nfvk3DPFYhdmDXX9JB4EHkXVknVwm2r+YbixMYY8N6UZas
         5vXteQ+W/jinCVg1i3jH3Sq6GdLGbtJiJEgL0VHwTnjBd1sEoZok1EKLr4pFYMROU+p0
         YYRYQlwDq4TmyqJr6mbWUEz8O0t2eI0OU1/lIEPwriuBAiJG2+lZYudkRgiaKxtj40mh
         nzufqCnqhxprw5h6I+7GHHOA9d0zJQesZdwXXEQXREzaIOdk4g+/4kVnus4E4cmOz0rr
         e0cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1BXl9vy0f2f/11VKxHLckXglqOMtK0anh34YjL4SpoA=;
        b=MeB/z+voszkRKi92u58IEH6LZHWp+6wmzKIMj5vzKyFL9r4OMqHKCjP2885dc0Ftaf
         RLxC9t9K+37N4BBWd1YfjcoDaGCqJ94Hj83uWp6QmRrEDjjR38kk1Jfk5gp0d0adOX6t
         HU8X9ZSEdl5zFdFMqxZ/n7WqF6FYPSV6Kob+R1Gk7lG7Peu/2QFA6w6GOvIdz/hLuXzX
         K35/g3huLEODQd/qkot9fUp2dLq7ymp5Du77Dgaw+75Kivw57e3gIM9+f2zt5oNJ4vT5
         DOfIYFDOmfOWVw4vMvxNvV6TsGD4RCfSNU2aqz0wVuQ9ke8Qko3DQfKYxjihrenyuz0N
         BGEA==
X-Gm-Message-State: ANoB5pkFXuq6yhyF/OAfpVTmuHedkCcX+9B/D9d+BAI4eUuqBDE5gufM
        XBt0zwZ22z3cmWQhqTB9YpvFxMk=
X-Google-Smtp-Source: AA0mqf7Icw3UnigDaLBzU7ImBfrwnGJPUr76c1EwJr94knLZ93lfIm35xMaxZVPdh0LFftWlP4RFSck=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:a25:b885:0:b0:701:49ca:8ae8 with SMTP id
 w5-20020a25b885000000b0070149ca8ae8mr21490186ybj.553.1671478411506; Mon, 19
 Dec 2022 11:33:31 -0800 (PST)
Date:   Mon, 19 Dec 2022 11:33:29 -0800
In-Reply-To: <Y6B3xEgkbmFUCeni@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
References: <000000000000a20a2e05f029c577@google.com> <Y6B3xEgkbmFUCeni@hirez.programming.kicks-ass.net>
Message-ID: <Y6C8iQGENUk/XY/A@google.com>
Subject: Re: [syzbot] KASAN: use-after-free Read in put_pmu_ctx
From:   sdf@google.com
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     syzbot <syzbot+b8e8c01c8ade4fe6e48f@syzkaller.appspotmail.com>,
        acme@kernel.org, alexander.shishkin@linux.intel.com,
        bpf@vger.kernel.org, jolsa@kernel.org,
        linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
        mark.rutland@arm.com, mingo@redhat.com, namhyung@kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/19, Peter Zijlstra wrote:
> On Mon, Dec 19, 2022 at 12:04:43AM -0800, syzbot wrote:
> > Hello,
> >
> > syzbot found the following issue on:
> >
> > HEAD commit:    13e3c7793e2f Merge tag 'for-netdev' of  
> https://git.kernel...
> > git tree:       bpf
> > console+strace: https://syzkaller.appspot.com/x/log.txt?x=177df7e0480000
> > kernel config:   
> https://syzkaller.appspot.com/x/.config?x=b0e91ad4b5f69c47
> > dashboard link:  
> https://syzkaller.appspot.com/bug?extid=b8e8c01c8ade4fe6e48f
> > compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU  
> Binutils for Debian) 2.35.2
> > syz repro:       
> https://syzkaller.appspot.com/x/repro.syz?x=15e87100480000
> > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16ceeb13880000
> >
> > Downloadable assets:
> > disk image:  
> https://storage.googleapis.com/syzbot-assets/373a99daa295/disk-13e3c779.raw.xz
> > vmlinux:  
> https://storage.googleapis.com/syzbot-assets/7fa71ed0fe17/vmlinux-13e3c779.xz
> > kernel image:  
> https://storage.googleapis.com/syzbot-assets/2842ad5c698b/bzImage-13e3c779.xz
> >
> > IMPORTANT: if you fix the issue, please add the following tag to the  
> commit:
> > Reported-by: syzbot+b8e8c01c8ade4fe6e48f@syzkaller.appspotmail.com
> >
> > ==================================================================
> > BUG: KASAN: use-after-free in __lock_acquire+0x3ee7/0x56d0  
> kernel/locking/lockdep.c:4925
> > Read of size 8 at addr ffff8880237d6018 by task syz-executor287/8300
> >
> > CPU: 0 PID: 8300 Comm: syz-executor287 Not tainted  
> 6.1.0-syzkaller-09661-g13e3c7793e2f #0
> > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
> Google 10/26/2022
> > Call Trace:
> >  <TASK>
> >  __dump_stack lib/dump_stack.c:88 [inline]
> >  dump_stack_lvl+0xd1/0x138 lib/dump_stack.c:106
> >  print_address_description mm/kasan/report.c:284 [inline]
> >  print_report+0x15e/0x45d mm/kasan/report.c:395
> >  kasan_report+0xbf/0x1f0 mm/kasan/report.c:495
> >  __lock_acquire+0x3ee7/0x56d0 kernel/locking/lockdep.c:4925
> >  lock_acquire kernel/locking/lockdep.c:5668 [inline]
> >  lock_acquire+0x1e3/0x630 kernel/locking/lockdep.c:5633
> >  __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:110 [inline]
> >  _raw_spin_lock_irqsave+0x3d/0x60 kernel/locking/spinlock.c:162
> >  put_pmu_ctx kernel/events/core.c:4913 [inline]
> >  put_pmu_ctx+0xad/0x390 kernel/events/core.c:4893
> >  _free_event+0x3c5/0x13d0 kernel/events/core.c:5196
> >  free_event+0x58/0xc0 kernel/events/core.c:5224
> >  __do_sys_perf_event_open+0x66d/0x2980 kernel/events/core.c:12701
> >  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
> >  do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
> >  entry_SYSCALL_64_after_hwframe+0x63/0xcd

> Does this help?

Let's maybe try it this way:

#syz test: https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git  
13e3c7793e2f

diff --git a/kernel/events/core.c b/kernel/events/core.c
index e47914ac8732..bbff551783e1 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -12689,7 +12689,8 @@ SYSCALL_DEFINE5(perf_event_open,
  	return event_fd;

  err_context:
-	/* event->pmu_ctx freed by free_event() */
+	put_pmu_ctx(event->pmu_ctx);
+	event->pmu_ctx = NULL; /* _free_event() */
  err_locked:
  	mutex_unlock(&ctx->mutex);
  	perf_unpin_context(ctx);
