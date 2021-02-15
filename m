Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BE2E31C45E
	for <lists+netdev@lfdr.de>; Tue, 16 Feb 2021 00:25:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229646AbhBOXYD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Feb 2021 18:24:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229784AbhBOXXJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Feb 2021 18:23:09 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3356C061574;
        Mon, 15 Feb 2021 15:22:28 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id z6so5055512pfq.0;
        Mon, 15 Feb 2021 15:22:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VeVqFoC56Xze/OWFC7yX9jISWPx8ROKh5fQlj0M8Mck=;
        b=Rv16NeVVN/Te8vROJIaRDCPy2XR44uJbvcAHbw2GneJwWyCbvzhY2dt7xspybJWuiu
         VI+2/Plbo3qfzY1rPZuHGGenibVSVMvTjAztqZt3QFYi2aX4zsZ6W5nu+16mIWt92sWg
         kVAqVF5Lu1rIM0saQUsBqdBfFRogY9G5hNMVJitsYdEVMWr2NtkiUAIRX0eE2pRcbu8f
         jWKlORW8uxQlCWYGGWVFgJZ1z3yyV+Tx44dlRnMBw4NTxSa9xWK3hnShLIHGboNKNMEZ
         Rf9I2tOGFJwmSEfdPBSzdil9B3/RvFm10u1WmUCDWQ3syti12nBtq1KdXvknjRbd3sB+
         Cjbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VeVqFoC56Xze/OWFC7yX9jISWPx8ROKh5fQlj0M8Mck=;
        b=qxXdu433055CkkltfhhKy1gvj47ZqiTojKlnwHbb5npnhn5Ie/rLOLHtldtQcYxw2k
         486HbRjwKI5Qvi0eP2ZvfqV3tvN7gnV955g+aCeehyQvIMDbVVOxhEA2aBXbJaA3YEx0
         SF7lWIkhZ1AWu5bqkQw9nAVSLTTbLTTwla6sdgAQX+U+IoM3Zn9MGikJVk+IAw/1nOj+
         Ks33YU0JVxDz2/SkOIMuZtX83lheQhlWj+viaaOs4xA7YqrYYD9jRkccqwUiIG7WVqfQ
         Rik+8rTt0iVmGif7eVo3na4TPJuC/zCUykAaB4xnF8K2sU4slMTggHgA7CtElzt4g2Rf
         srAA==
X-Gm-Message-State: AOAM533/CpjyLbwCQxP3phlpjQcfbriCQGNoqBU2BTH2M1MHF5DK4i9k
        aAEU4SwTG6ERABv30pT6PGKcM6+2X2ztnP0Q0Ug=
X-Google-Smtp-Source: ABdhPJxp2+VcDdnq/wHz4wIJ9Q40rL63wa9TPcbPWpH6Ef8icZxzXXimQFnHHbAitadsUMJouoD7LG6bHgXOkAf/qyQ=
X-Received: by 2002:a63:e109:: with SMTP id z9mr16683822pgh.5.1613431348584;
 Mon, 15 Feb 2021 15:22:28 -0800 (PST)
MIME-Version: 1.0
References: <0000000000005243f805b05abc7c@google.com> <00000000000008f12905bb0923e0@google.com>
In-Reply-To: <00000000000008f12905bb0923e0@google.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon, 15 Feb 2021 15:22:17 -0800
Message-ID: <CAM_iQpVEZiOca0po6N5Hcp67LV98k_PhbEXogCJFjpOR0AbGwg@mail.gmail.com>
Subject: Re: KASAN: null-ptr-deref Read in tcf_idrinfo_destroy
To:     syzbot <syzbot+151e3e714d34ae4ce7e8@syzkaller.appspotmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Jakub Kicinski <kuba@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Vlad Buslov <vladbu@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 10, 2021 at 9:53 PM syzbot
<syzbot+151e3e714d34ae4ce7e8@syzkaller.appspotmail.com> wrote:
>
> syzbot has found a reproducer for the following issue on:
>
> HEAD commit:    291009f6 Merge tag 'pm-5.11-rc8' of git://git.kernel.org/p..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=14470d18d00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=a53fd47f16f22f8c
> dashboard link: https://syzkaller.appspot.com/bug?extid=151e3e714d34ae4ce7e8
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15f45814d00000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15f4aff8d00000
>
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+151e3e714d34ae4ce7e8@syzkaller.appspotmail.com
>
> ==================================================================
> BUG: KASAN: null-ptr-deref in instrument_atomic_read include/linux/instrumented.h:71 [inline]
> BUG: KASAN: null-ptr-deref in atomic_read include/asm-generic/atomic-instrumented.h:27 [inline]
> BUG: KASAN: null-ptr-deref in __tcf_idr_release net/sched/act_api.c:178 [inline]
> BUG: KASAN: null-ptr-deref in tcf_idrinfo_destroy+0x129/0x1d0 net/sched/act_api.c:598
> Read of size 4 at addr 0000000000000010 by task kworker/u4:5/204
>
> CPU: 0 PID: 204 Comm: kworker/u4:5 Not tainted 5.11.0-rc7-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> Workqueue: netns cleanup_net
> Call Trace:
>  __dump_stack lib/dump_stack.c:79 [inline]
>  dump_stack+0x107/0x163 lib/dump_stack.c:120
>  __kasan_report mm/kasan/report.c:400 [inline]
>  kasan_report.cold+0x5f/0xd5 mm/kasan/report.c:413
>  check_memory_region_inline mm/kasan/generic.c:179 [inline]
>  check_memory_region+0x13d/0x180 mm/kasan/generic.c:185
>  instrument_atomic_read include/linux/instrumented.h:71 [inline]
>  atomic_read include/asm-generic/atomic-instrumented.h:27 [inline]
>  __tcf_idr_release net/sched/act_api.c:178 [inline]
>  tcf_idrinfo_destroy+0x129/0x1d0 net/sched/act_api.c:598
>  tc_action_net_exit include/net/act_api.h:151 [inline]
>  police_exit_net+0x168/0x360 net/sched/act_police.c:390

This is really strange. It seems we still left some -EBUSY placeholders
in the idr, however, we actually call tcf_action_destroy() to clean up
everything including -EBUSY ones on error path.

What do you think, Vlad?

Thanks.
