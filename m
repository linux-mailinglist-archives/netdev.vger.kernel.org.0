Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E856A671569
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 08:49:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229637AbjARHto (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 02:49:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229703AbjARHsN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 02:48:13 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79BE946D79
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 23:17:36 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id 207so9369834pfv.5
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 23:17:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=yVKQEtNfpUB5gcrvUxbBNZCCawjadGb5FOsZgWiuy0U=;
        b=RXkxCxmZ4mkzmsi/R+RWhm+CL3ymEnhmThkDd3y7UgcGgUjQvoPN9ubDmUnQVZIg1v
         U7N9pSnFr++NlGhbDqXP+Uk6uL6MZ1lP9npnMJwODdalwqNZw5Ad9Vmy8+stvwtwGBh4
         odWHAUNTLtBJMhlc3mYnBfXR+yambLblMi3IBBYkWfyXJr0XtH5uHxXHsc/s0koN/kyr
         9PqbRD4pjFWGQU6wRe/FIkuK6wdHzmeYu3nuDXHTadOtDV/KpfY1dbti2GaF8eD2jhJG
         2QmYOtBEdWGzHLkpLZWWWW3Voh7ENmk9swmwCIxu70wqxLoEVDMb1wnBIpkHxXT6QAEs
         oS2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yVKQEtNfpUB5gcrvUxbBNZCCawjadGb5FOsZgWiuy0U=;
        b=retKWKd2sJEaIpiCQUBs7V/1Rt8aqvk1cA7pSD3nSyTvAuMhzwnWsR/Z6xf+trpgD9
         SYviMTogoZHymb/xzPLW4CodANkoc9PDHsLgtn/VoAOFIJf6Dqkww/sRSRDp5TK73vPI
         iu+braPjribb4AtfTK8SVKglB65n4RPwt1H9x3yIbnd/mYRJ/YuOhFEo2KUtseuzIChV
         VCPbSJSc/oKom0VU5qfZ9HIyrke6flQ0eRyb3fEFC8Z2l68rteVn3mzLEJFtESzvcYtD
         YjnVq8cHWuaic4Xx7O4MD/2Q83beK/Mxt71pqsXJH0fh/Q4KtV59mPKwGB0ePwom7jZj
         OJYw==
X-Gm-Message-State: AFqh2kqVqMyHB8LEOpOsg+XuUndyRswblNNMPEmcb9FPovPW3o3ybLr+
        XQkRbd70ETQ84/XeIdSkm0J9/Mcpa1c=
X-Google-Smtp-Source: AMrXdXuA7QK69RGP+BhmEZKeFfvcykA7DYVeL/6gZzawprxVR+RCk7Qq/+jzJ0DGO7272QvJlb0Llg==
X-Received: by 2002:a05:6a00:70f:b0:581:1f4b:d1e5 with SMTP id 15-20020a056a00070f00b005811f4bd1e5mr6850383pfl.12.1674026256014;
        Tue, 17 Jan 2023 23:17:36 -0800 (PST)
Received: from pek-lpggp6.wrs.com (unknown-105-121.windriver.com. [147.11.105.121])
        by smtp.gmail.com with ESMTPSA id t25-20020a62d159000000b0056bd1bf4243sm6499158pfl.53.2023.01.17.23.17.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Jan 2023 23:17:35 -0800 (PST)
From:   Kevin Hao <haokexin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Sunil Goutham <sgoutham@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        hariprasad <hkelam@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH net] octeontx2-pf: Fix the use of GFP_KERNEL in atomic context on rt
Date:   Wed, 18 Jan 2023 15:13:00 +0800
Message-Id: <20230118071300.3271125-1-haokexin@gmail.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The commit 4af1b64f80fb ("octeontx2-pf: Fix lmtst ID used in aura
free") uses the get/put_cpu() to protect the usage of percpu pointer
in ->aura_freeptr() callback, but it also unnecessarily disable the
preemption for the blockable memory allocation. The commit 87b93b678e95
("octeontx2-pf: Avoid use of GFP_KERNEL in atomic context") tried to
fix these sleep inside atomic warnings. But it only fix the one for
the non-rt kernel. For the rt kernel, we still get the similar warnings
like below.
  BUG: sleeping function called from invalid context at kernel/locking/spinlock_rt.c:46
  in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 1, name: swapper/0
  preempt_count: 1, expected: 0
  RCU nest depth: 0, expected: 0
  3 locks held by swapper/0/1:
   #0: ffff800009fc5fe8 (rtnl_mutex){+.+.}-{3:3}, at: rtnl_lock+0x24/0x30
   #1: ffff000100c276c0 (&mbox->lock){+.+.}-{3:3}, at: otx2_init_hw_resources+0x8c/0x3a4
   #2: ffffffbfef6537e0 (&cpu_rcache->lock){+.+.}-{2:2}, at: alloc_iova_fast+0x1ac/0x2ac
  Preemption disabled at:
  [<ffff800008b1908c>] otx2_rq_aura_pool_init+0x14c/0x284
  CPU: 20 PID: 1 Comm: swapper/0 Tainted: G        W          6.2.0-rc3-rt1-yocto-preempt-rt #1
  Hardware name: Marvell OcteonTX CN96XX board (DT)
  Call trace:
   dump_backtrace.part.0+0xe8/0xf4
   show_stack+0x20/0x30
   dump_stack_lvl+0x9c/0xd8
   dump_stack+0x18/0x34
   __might_resched+0x188/0x224
   rt_spin_lock+0x64/0x110
   alloc_iova_fast+0x1ac/0x2ac
   iommu_dma_alloc_iova+0xd4/0x110
   __iommu_dma_map+0x80/0x144
   iommu_dma_map_page+0xe8/0x260
   dma_map_page_attrs+0xb4/0xc0
   __otx2_alloc_rbuf+0x90/0x150
   otx2_rq_aura_pool_init+0x1c8/0x284
   otx2_init_hw_resources+0xe4/0x3a4
   otx2_open+0xf0/0x610
   __dev_open+0x104/0x224
   __dev_change_flags+0x1e4/0x274
   dev_change_flags+0x2c/0x7c
   ic_open_devs+0x124/0x2f8
   ip_auto_config+0x180/0x42c
   do_one_initcall+0x90/0x4dc
   do_basic_setup+0x10c/0x14c
   kernel_init_freeable+0x10c/0x13c
   kernel_init+0x2c/0x140
   ret_from_fork+0x10/0x20

Of course, we can shuffle the get/put_cpu() to only wrap the invocation
of ->aura_freeptr() as what commit 87b93b678e95 does. But there are only
two ->aura_freeptr() callbacks, otx2_aura_freeptr() and
cn10k_aura_freeptr(). There is no usage of perpcu variable in the
otx2_aura_freeptr() at all, so the get/put_cpu() seems redundant to it.
We can move the get/put_cpu() into the corresponding callback which
really has the percpu variable usage and avoid the sprinkling of
get/put_cpu() in several places.

Fixes: 4af1b64f80fb ("octeontx2-pf: Fix lmtst ID used in aura free")
Signed-off-by: Kevin Hao <haokexin@gmail.com>
---
 .../net/ethernet/marvell/octeontx2/nic/otx2_common.c  | 11 ++---------
 .../net/ethernet/marvell/octeontx2/nic/otx2_common.h  |  2 ++
 2 files changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
index 497b777b6a34..8a41ad8ca04f 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
@@ -1012,7 +1012,6 @@ static void otx2_pool_refill_task(struct work_struct *work)
 	rbpool = cq->rbpool;
 	free_ptrs = cq->pool_ptrs;
 
-	get_cpu();
 	while (cq->pool_ptrs) {
 		if (otx2_alloc_rbuf(pfvf, rbpool, &bufptr)) {
 			/* Schedule a WQ if we fails to free atleast half of the
@@ -1032,7 +1031,6 @@ static void otx2_pool_refill_task(struct work_struct *work)
 		pfvf->hw_ops->aura_freeptr(pfvf, qidx, bufptr + OTX2_HEAD_ROOM);
 		cq->pool_ptrs--;
 	}
-	put_cpu();
 	cq->refill_task_sched = false;
 }
 
@@ -1387,9 +1385,7 @@ int otx2_sq_aura_pool_init(struct otx2_nic *pfvf)
 			err = otx2_alloc_rbuf(pfvf, pool, &bufptr);
 			if (err)
 				goto err_mem;
-			get_cpu();
 			pfvf->hw_ops->aura_freeptr(pfvf, pool_id, bufptr);
-			put_cpu();
 			sq->sqb_ptrs[sq->sqb_count++] = (u64)bufptr;
 		}
 	}
@@ -1435,21 +1431,18 @@ int otx2_rq_aura_pool_init(struct otx2_nic *pfvf)
 	if (err)
 		goto fail;
 
-	get_cpu();
 	/* Allocate pointers and free them to aura/pool */
 	for (pool_id = 0; pool_id < hw->rqpool_cnt; pool_id++) {
 		pool = &pfvf->qset.pool[pool_id];
 		for (ptr = 0; ptr < num_ptrs; ptr++) {
 			err = otx2_alloc_rbuf(pfvf, pool, &bufptr);
 			if (err)
-				goto err_mem;
+				return -ENOMEM;
 			pfvf->hw_ops->aura_freeptr(pfvf, pool_id,
 						   bufptr + OTX2_HEAD_ROOM);
 		}
 	}
-err_mem:
-	put_cpu();
-	return err ? -ENOMEM : 0;
+	return 0;
 fail:
 	otx2_mbox_reset(&pfvf->mbox.mbox, 0);
 	otx2_aura_pool_free(pfvf);
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
index 5bee3c3a7ce4..3d22cc6a2804 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
@@ -736,8 +736,10 @@ static inline void cn10k_aura_freeptr(void *dev, int aura, u64 buf)
 	u64 ptrs[2];
 
 	ptrs[1] = buf;
+	get_cpu();
 	/* Free only one buffer at time during init and teardown */
 	__cn10k_aura_freeptr(pfvf, aura, ptrs, 2);
+	put_cpu();
 }
 
 /* Alloc pointer from pool/aura */
-- 
2.38.1

