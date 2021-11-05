Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07BD1446263
	for <lists+netdev@lfdr.de>; Fri,  5 Nov 2021 11:52:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231536AbhKEKyg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Nov 2021 06:54:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230003AbhKEKyg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Nov 2021 06:54:36 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3482C061714;
        Fri,  5 Nov 2021 03:51:56 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id n11-20020a17090a2bcb00b001a1e7a0a6a6so3077367pje.0;
        Fri, 05 Nov 2021 03:51:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=E1FRoWLiKOB9PX3H+Wgx8ywsIIZ+AgW1uQa0wt4YaY0=;
        b=Y6ccZ2X25m5uEh0AtwNljsolovYIwmkXrAr3m5v2L5qaGVVPatzPEBKnOU85y80nVO
         qAx7SiFNCp6shzbB3IOsfIJC5Qdz8MaUc6r0VeJZsDuV6rDqVn8NLTr2CZsW8R7sYVYw
         dZJ8A1Kxc380LrBt1OBR8G9t2FkEJJAVjUGv1T0q3WesGhUBe31KXTeoOta+VhaI/zdT
         wI/08wm7CMPvdugLJyRDuyQyHuicCp2OybcAHPlP16FgY/S+O4EhgqLxNtApIhEFtG46
         Hs7fTILHNpxo/Exvw6P0Trr8m92m8QuqL7xsy/KM07S1FjS8xmYdThLB3bBKNDUwMMuy
         w1tA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=E1FRoWLiKOB9PX3H+Wgx8ywsIIZ+AgW1uQa0wt4YaY0=;
        b=qti7ojjy5lDt6PmBrcKmMPdVD0n4yTj/OUm5yaX9YbUib+ro9zDmkfq4gOH1Ywtqyt
         xO9qjtzeWKiXuAbKwS6Su8Kttvl4DWouivxPD4eu7GO48J/ntfhpSECajRnR2oRBJ3gL
         vAhFctSjLOXnJjREy/hLxeQcoJOH2Mls4sLrH4h1tAayq6DkPJH6Xpwqy35xRoFEUXI7
         tbsferECDngvjzV/NFaKYjSJCU9sXQQ3EZiyLf8985/EVRwkLxw02JqVEpWwils60ekE
         iAWYef32J/tNHSF8Y8JOchmxtf9NGdg0S8klx846+BDd3rDrbYzRvsvR5il1YyVi1u32
         iOxQ==
X-Gm-Message-State: AOAM532vI1Knr2Cs+PLmUSUW6NoXNSI13iC9Tv7bwRGtGYshTvvXXaXr
        QnmpTZkdplJwWAKFrFsHA0Q=
X-Google-Smtp-Source: ABdhPJzxghfCOe5Q5NDIFFdSuuRMprwqg6ohErvVLiK9lYEKBgz0A80krgZgQx5pMxmiMlE/rZhYYw==
X-Received: by 2002:a17:90a:df01:: with SMTP id gp1mr29105161pjb.28.1636109516434;
        Fri, 05 Nov 2021 03:51:56 -0700 (PDT)
Received: from baohua-VirtualBox.localdomain (47-72-197-19.dsl.dyn.ihug.co.nz. [47.72.197.19])
        by smtp.gmail.com with ESMTPSA id e6sm5751644pgf.59.2021.11.05.03.51.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Nov 2021 03:51:55 -0700 (PDT)
From:   Barry Song <21cnbao@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, fw@strlen.de, mingo@redhat.com,
        peterz@infradead.org, juri.lelli@redhat.com,
        vincent.guittot@linaro.org, dietmar.eggemann@arm.com,
        rostedt@goodmis.org, bsegall@google.com, mgorman@suse.de,
        bristot@redhat.com, tglx@linutronix.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     linuxarm@huawei.com, guodong.xu@linaro.org, yangyicong@huawei.com,
        shenyang39@huawei.com, tangchengchang@huawei.com,
        Barry Song <song.bao.hua@hisilicon.com>,
        Libo Chen <libo.chen@oracle.com>,
        Tim Chen <tim.c.chen@linux.intel.com>
Subject: [RFC PATCH] sched&net: avoid over-pulling tasks due to network interrupts
Date:   Fri,  5 Nov 2021 18:51:36 +0800
Message-Id: <20211105105136.12137-1-21cnbao@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Barry Song <song.bao.hua@hisilicon.com>

In LPC2021, both Libo Chen and Tim Chen have reported the overpull
of network interrupts[1]. For example, while running one database,
ethernet is located in numa0, numa1 might be almost idle due to
interrupts are pulling tasks to numa0 because of wake_up affine.
I have seen the same problem. One way to solve this problem is
moving to a normal wakeup in network rather than using a sync
wakeup which will be more aggressively pulling tasks in scheduler
core.

On kunpeng920 with 4numa, ethernet is located at numa0, storage
disk is located at numa2. While using sysbench to connect this
mysql machine, I am seeing numa1 is idle though numa0,2 and 3
are quite busy.

The benchmark command:

 sysbench --db-driver=mysql --mysql-user=sbtest_user \
 --mysql_password=password --mysql-db=sbtest \
 --mysql-host=192.168.101.3 --mysql-port=3306 \
 --point-selects=10 --simple-ranges=1 \
 --sum-ranges=1 --order-ranges=1 --distinct-ranges=1 \
 --index-updates=1 --non-index-updates=1 \
 --delete-inserts=1 --range-size=100 \
 --time=600 --events=0 --report-interval=60 \
 --tables=64 --table-size=2000000 --threads=128 \
  /usr/share/sysbench/oltp_read_only.lua run

The benchmark result is as below:
                 tps        qps
w/o patch     31748.22     507971.56
w/  patch     35075.20     561203.13
              +10.5%

With the patch I am seeing NUMA1 becomes busy as well so I am
getting 10%+ performance improvement.

I am not saying this patch is exactly the right approach, But I'd
like to use this RFC to connect the people of net and scheduler,
and start the discussion in this wider range.

Testing was done based on the latest linus tree commit d4439a1189.
with the .config[2]

[1] https://linuxplumbersconf.org/event/11/contributions/1044/attachments/801/1508/lpc21_wakeup_pulling_libochen.pdf
[2] http://www.linuxep.com/patches/config

Cc: Libo Chen <libo.chen@oracle.com>
Cc: Tim Chen <tim.c.chen@linux.intel.com>
Signed-off-by: Barry Song <song.bao.hua@hisilicon.com>
---
 net/core/sock.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/core/sock.c b/net/core/sock.c
index 9862eef..a346359 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -3133,7 +3133,7 @@ void sock_def_readable(struct sock *sk)
 	rcu_read_lock();
 	wq = rcu_dereference(sk->sk_wq);
 	if (skwq_has_sleeper(wq))
-		wake_up_interruptible_sync_poll(&wq->wait, EPOLLIN | EPOLLPRI |
+		wake_up_interruptible_poll(&wq->wait, EPOLLIN | EPOLLPRI |
 						EPOLLRDNORM | EPOLLRDBAND);
 	sk_wake_async(sk, SOCK_WAKE_WAITD, POLL_IN);
 	rcu_read_unlock();
@@ -3151,7 +3151,7 @@ static void sock_def_write_space(struct sock *sk)
 	if ((refcount_read(&sk->sk_wmem_alloc) << 1) <= READ_ONCE(sk->sk_sndbuf)) {
 		wq = rcu_dereference(sk->sk_wq);
 		if (skwq_has_sleeper(wq))
-			wake_up_interruptible_sync_poll(&wq->wait, EPOLLOUT |
+			wake_up_interruptible_poll(&wq->wait, EPOLLOUT |
 						EPOLLWRNORM | EPOLLWRBAND);
 
 		/* Should agree with poll, otherwise some programs break */
-- 
1.8.3.1

