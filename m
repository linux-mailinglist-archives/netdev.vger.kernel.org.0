Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7269A26C86F
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 20:49:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728153AbgIPSt3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 14:49:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:44154 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728067AbgIPSqK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Sep 2020 14:46:10 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2615921974;
        Wed, 16 Sep 2020 18:46:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600281965;
        bh=/obTa5dDgpQbEhPY8NXqfpcnesfsIbZr0kI0nIbHCZc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hicf/gwlNME9c/NAU4/d3YEy3FC62ZR+K4mtyLI+U/UAa7VFyuB8hESAxyAMrPFTj
         DdkMbTbwb7i84ugxcdWlRgptrF1c5o3x160nWMwrvtm5v7fTXXMYb2YCIiHTv50tt0
         mBK/Topivrm4mnx5D+z7VBJAnYHTjCOl2xRIT/Oo=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net, paulmck@kernel.org, joel@joelfernandes.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        rcu@vger.kernel.org, josh@joshtriplett.org, peterz@infradead.org,
        christian.brauner@ubuntu.com, Jakub Kicinski <kuba@kernel.org>,
        ebiederm@xmission.com, akpm@linux-foundation.org, mingo@kernel.org
Subject: [PATCH net-next 1/7] sched: un-hide lockdep_tasklist_lock_is_held() for !LOCKDEP
Date:   Wed, 16 Sep 2020 11:45:22 -0700
Message-Id: <20200916184528.498184-2-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200916184528.498184-1-kuba@kernel.org>
References: <20200916184528.498184-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We're trying to make LOCKDEP-related function declarations
visible to the compiler and depend on dead code elimination
to remove them.

Make lockdep_tasklist_lock_is_held() visible.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: christian.brauner@ubuntu.com
CC: peterz@infradead.org
CC: ebiederm@xmission.com
CC: akpm@linux-foundation.org
CC: mingo@kernel.org
---
 include/linux/sched/task.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/include/linux/sched/task.h b/include/linux/sched/task.h
index a98965007eef..9f943c391df9 100644
--- a/include/linux/sched/task.h
+++ b/include/linux/sched/task.h
@@ -47,9 +47,7 @@ extern spinlock_t mmlist_lock;
 extern union thread_union init_thread_union;
 extern struct task_struct init_task;
 
-#ifdef CONFIG_PROVE_RCU
 extern int lockdep_tasklist_lock_is_held(void);
-#endif /* #ifdef CONFIG_PROVE_RCU */
 
 extern asmlinkage void schedule_tail(struct task_struct *prev);
 extern void init_idle(struct task_struct *idle, int cpu);
-- 
2.26.2

