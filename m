Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B132C2498E6
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 10:58:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727073AbgHSI5x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 04:57:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727955AbgHSI5T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 04:57:19 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19EC1C061342;
        Wed, 19 Aug 2020 01:57:19 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id f7so20713299wrw.1;
        Wed, 19 Aug 2020 01:57:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3IDlmArv+ha2HqUtuqilQB53eBkXbwqE5RHb/bHCDeE=;
        b=jLFOV3C93J/646mCY5hFwORqAfzjfF+jfChRKBH6730XYB9q3jyij6imWacVqqEgOq
         9AIDOxkO1XGxUB33jqXcYVgyaphb9L2m9yxu063yJE2S+Yw2ZCsIcT7B1XGnOUokispI
         0mTzZldZivb7OfrnX70Ie0qhIpQJpFuDVE6ABo245MXqu6wph7JzAdAIIWOYiOe/sjJW
         MX4C+xOxgv3EDPVUxbZsMsl+E0wi2YU4kOG07fuKrvNk6zX5d2xH9BipVj/Ax9GRwVLy
         /m9GGGCOz6+IKKmVSqrQwmYYPFBqpbicZhZv/TW6+Pgwxzkh/zTfyZl2qWz1B+Ucm9wO
         619w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3IDlmArv+ha2HqUtuqilQB53eBkXbwqE5RHb/bHCDeE=;
        b=lG6sNVSvh0mwEqXCmzm5hduoVgI21BIWOKnFYXQHJOduaHF9gRJFyyIIKh864hZsPQ
         M6OoBRfAFurVQf80wc2+m1aUwmSFi92Kv/PukuqCQnuNKdkIUk57ew2RgGCWEpYFLnou
         vcZfX7JeNGTvJCKAmh129UTad4I3JOvaU1rBAZZcTtE2zaxsU8ln/Z2aXR2L90gaNwZt
         PlDMACZH7p+QAgWAyyc0Nnf7pssPaEcbBeyjGd3rDkl1Xliz+CClUSqAlKm+602XhYT3
         FUkE6v9yInecIBXTXQUB1f4j7p0SC3eFmduCMiNvBymn/GFQIH+Qpe5i78vFsUktCUNq
         +U+Q==
X-Gm-Message-State: AOAM530eaLjLOapPamAhCb2OqE0qdk9It/jzaHR4usz4ZRz8HYs+czje
        8DvMqerP3HgFzOLujH665duI4/5n6Z5op35CkZTRtm63oDZ19w==
X-Google-Smtp-Source: ABdhPJzCJKAynaogm/xrbpKCom0oA16u65iZqPuQmO4PBwVlBFVcOkyBzIb2BaTu5RBQcz1oLfqgTJW1hyxZnNJM+qU=
X-Received: by 2002:a5d:43ca:: with SMTP id v10mr23896375wrr.299.1597827437739;
 Wed, 19 Aug 2020 01:57:17 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000d411cf05a8ffc4a6@google.com>
In-Reply-To: <000000000000d411cf05a8ffc4a6@google.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Wed, 19 Aug 2020 17:09:54 +0800
Message-ID: <CADvbK_dRc+Cn4wM4R9KEzoHy+jUa7uWzfA096NthsEEXxwNGOQ@mail.gmail.com>
Subject: Re: WARNING: suspicious RCU usage in tipc_l2_send_msg
To:     syzbot <syzbot+47bbc6b678d317cccbe0@syzkaller.appspotmail.com>
Cc:     davem <davem@davemloft.net>, Jon Maloy <jmaloy@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        network dev <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        tipc-discussion@lists.sourceforge.net,
        Ying Xue <ying.xue@windriver.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 27, 2020 at 1:25 AM syzbot
<syzbot+47bbc6b678d317cccbe0@syzkaller.appspotmail.com> wrote:
>
> Hello,
>
> syzbot found the following crash on:
>
> HEAD commit:    b835a71e usbnet: smsc95xx: Fix use-after-free after removal
> git tree:       net
> console output: https://syzkaller.appspot.com/x/log.txt?x=1095a51d100000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=dcc6334acae363d4
> dashboard link: https://syzkaller.appspot.com/bug?extid=47bbc6b678d317cccbe0
> compiler:       gcc (GCC) 10.1.0-syz 20200507
>
> Unfortunately, I don't have any reproducer for this crash yet.
>
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+47bbc6b678d317cccbe0@syzkaller.appspotmail.com
>
> =============================
> WARNING: suspicious RCU usage
> 5.8.0-rc1-syzkaller #0 Not tainted
> -----------------------------
> net/tipc/bearer.c:466 suspicious rcu_dereference_check() usage!
>
> other info that might help us debug this:
>
>
> rcu_scheduler_active = 2, debug_locks = 1
> 2 locks held by kworker/0:16/19143:
>  #0: ffff8880a6901d38 ((wq_completion)cryptd){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
>  #0: ffff8880a6901d38 ((wq_completion)cryptd){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
>  #0: ffff8880a6901d38 ((wq_completion)cryptd){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
>  #0: ffff8880a6901d38 ((wq_completion)cryptd){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
>  #0: ffff8880a6901d38 ((wq_completion)cryptd){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
>  #0: ffff8880a6901d38 ((wq_completion)cryptd){+.+.}-{0:0}, at: process_one_work+0x82b/0x1670 kernel/workqueue.c:2240
>  #1: ffffc90006f9fda8 ((work_completion)(&cpu_queue->work)){+.+.}-{0:0}, at: process_one_work+0x85f/0x1670 kernel/workqueue.c:2244
>
> stack backtrace:
> CPU: 0 PID: 19143 Comm: kworker/0:16 Not tainted 5.8.0-rc1-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> Workqueue: cryptd cryptd_queue_worker
> Call Trace:
>  __dump_stack lib/dump_stack.c:77 [inline]
>  dump_stack+0x18f/0x20d lib/dump_stack.c:118
>  tipc_l2_send_msg+0x354/0x420 net/tipc/bearer.c:466
>  tipc_aead_encrypt_done+0x204/0x3a0 net/tipc/crypto.c:761
>  cryptd_aead_crypt+0xe8/0x1d0 crypto/cryptd.c:739
>  cryptd_queue_worker+0x118/0x1b0 crypto/cryptd.c:181
>  process_one_work+0x94c/0x1670 kernel/workqueue.c:2269
>  worker_thread+0x64c/0x1120 kernel/workqueue.c:2415
>  kthread+0x3b5/0x4a0 kernel/kthread.c:291
>  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:293
>
Like in bearer.c, rcu_read_lock() is needed before calling
b->media->send_msg() in tipc_aead_encrypt_done():

@@ -757,10 +757,12 @@ static void tipc_aead_encrypt_done(struct
crypto_async_request *base, int err)
        switch (err) {
        case 0:
                this_cpu_inc(tx->stats->stat[STAT_ASYNC_OK]);
+               rcu_read_lock();
                if (likely(test_bit(0, &b->up)))
                        b->media->send_msg(net, skb, b, &tx_ctx->dst);
                else
                        kfree_skb(skb);
+               rcu_read_unlock();
                break;
>
> ---
> This bug is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
>
> syzbot will keep track of this bug report. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
