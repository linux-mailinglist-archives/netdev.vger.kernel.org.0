Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BCD7665135
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 02:47:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233003AbjAKBrG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 20:47:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231151AbjAKBrF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 20:47:05 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9BAA63C9;
        Tue, 10 Jan 2023 17:47:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 45B2E619D6;
        Wed, 11 Jan 2023 01:47:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16CA4C433D2;
        Wed, 11 Jan 2023 01:47:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673401623;
        bh=9wEvjZ7+McmNbo2jlG6VOYF0uVrSmbCh6cUh5UaKJ5k=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=k2NSqDYrGa1Q8yEa9nrREKICA0DkzvUhcUS3M8ZN8iv2F0WYvfx0w0reVAQj2qzJJ
         sFickMGMAbggSsGFPFxpW/EX+nSFOHYWBm457on5Ihk1L9nvbVSZlZZT8uNqVgNO5i
         LJiTPoy8TnHEKTE0hkLAzVEVrL45twRl9sHTsDMmuLHc44+eDN+L6k8AU3WEds+91L
         dBpySKs9AdIZVLupsoFbhOqGmahXoc5xt+D0tFFSDQP+o9mDnv0QG3/ieGLNJwQLHE
         GfizsD25hYOY3eD4AJT1U0oS6boDQKM7YAiu53qioZvobaNDnAVt38dBoQZM5lgdzo
         8migqnt83OaIw==
Date:   Tue, 10 Jan 2023 17:47:02 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     syzbot <syzbot+d94d214ea473e218fc89@syzkaller.appspotmail.com>
Cc:     acme@kernel.org, alexander.shishkin@linux.intel.com,
        bpf@vger.kernel.org, jolsa@kernel.org,
        linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
        mark.rutland@arm.com, mingo@redhat.com, namhyung@kernel.org,
        netdev@vger.kernel.org, peterz@infradead.org,
        syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] WARNING: locking bug in __perf_event_task_sched_in (2)
Message-ID: <20230110174702.72fe74c7@kernel.org>
In-Reply-To: <000000000000dde02b05f1ef09a4@google.com>
References: <000000000000dde02b05f1ef09a4@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 10 Jan 2023 12:50:48 -0800 syzbot wrote:
>  <TASK>
>  lock_acquire kernel/locking/lockdep.c:5668 [inline]
>  lock_acquire+0x1e3/0x630 kernel/locking/lockdep.c:5633
>  rcu_lock_acquire include/linux/rcupdate.h:325 [inline]
>  rcu_read_lock include/linux/rcupdate.h:764 [inline]
>  perf_event_context_sched_in kernel/events/core.c:3913 [inline]
>  __perf_event_task_sched_in+0xe2/0x6c0 kernel/events/core.c:3980
>  perf_event_task_sched_in include/linux/perf_event.h:1328 [inline]
>  finish_task_switch.isra.0+0x5e5/0xc80 kernel/sched/core.c:5118
>  context_switch kernel/sched/core.c:5247 [inline]
>  __schedule+0xb92/0x5450 kernel/sched/core.c:6555
>  schedule+0xde/0x1b0 kernel/sched/core.c:6631
>  schedule_preempt_disabled+0x13/0x20 kernel/sched/core.c:6690
>  __mutex_lock_common kernel/locking/mutex.c:679 [inline]
>  __mutex_lock+0xa48/0x1360 kernel/locking/mutex.c:747
>  devl_lock net/devlink/core.c:54 [inline]
>  devlink_pernet_pre_exit+0x10a/0x220 net/devlink/core.c:301
>  ops_pre_exit_list net/core/net_namespace.c:159 [inline]
>  cleanup_net+0x455/0xb10 net/core/net_namespace.c:594
>  process_one_work+0x9bf/0x1710 kernel/workqueue.c:2289
>  worker_thread+0x669/0x1090 kernel/workqueue.c:2436
>  kthread+0x2e8/0x3a0 kernel/kthread.c:376
>  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:308
>  </TASK>

Yes, I pooped it. We need to keep the mutex around as well as 
the devlink instance memory, otherwise locked screams.
Fix building..
