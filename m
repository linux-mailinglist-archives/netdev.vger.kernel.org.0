Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 634253CC277
	for <lists+netdev@lfdr.de>; Sat, 17 Jul 2021 12:18:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233163AbhGQKUw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Jul 2021 06:20:52 -0400
Received: from zg8tmty1ljiyny4xntqumjca.icoremail.net ([165.227.154.27]:53153
        "HELO zg8tmty1ljiyny4xntqumjca.icoremail.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with SMTP id S232942AbhGQKUu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Jul 2021 06:20:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fudan.edu.cn; s=dkim; h=Received:From:To:Cc:Subject:Date:
        Message-Id; bh=XrR4iFojOj6ohS/PqX/LFVLpx5N9SLa4eQr7qy7xDEg=; b=K
        e3WX639/Aq3srDdCa8PkZFLMNcr/ADBSoK7Vh4P3QoViUnV4FFL1d3inMjkbwxhN
        WaShIRVLReXwmv6FyznUzW46vJVGziyAHUTGzyUdcekzZiEYP4d979zU/reFE1Aw
        yGCeYMwgC0SLOhIzIvgWPqb9ltnCz6fn94TF3G6ZrE=
Received: from localhost.localdomain (unknown [39.144.44.130])
        by app2 (Coremail) with SMTP id XQUFCgBHTib3rfJgCbrYBA--.51381S3;
        Sat, 17 Jul 2021 18:16:24 +0800 (CST)
From:   Xiyu Yang <xiyuyang19@fudan.edu.cn>
To:     Raju Rangoju <rajur@chelsio.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     yuanxzhang@fudan.edu.cn, Xiyu Yang <xiyuyang19@fudan.edu.cn>,
        Xin Tan <tanxin.ctf@gmail.com>
Subject: [PATCH] cxgb3: Convert from atomic_t to refcount_t on l2t_entry->refcnt
Date:   Sat, 17 Jul 2021 18:16:15 +0800
Message-Id: <1626516975-42566-1-git-send-email-xiyuyang19@fudan.edu.cn>
X-Mailer: git-send-email 2.7.4
X-CM-TRANSID: XQUFCgBHTib3rfJgCbrYBA--.51381S3
X-Coremail-Antispam: 1UD129KBjvJXoWxAFWkXrW3JF4xWr1rKF18Grg_yoWrAF1xpF
        Z0ka4kuw48Gr4xX3ykJw48Zr9Iv34vvryrGrWUC3savr9Ivw43C3W0gFy5AF98JF4kCF4a
        kF4jkrWUCFn8tFJanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUvG14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4j
        6r4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
        Cq3wAac4AC62xK8xCEY4vEwIxC4wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC
        0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUGVWUXwAv7VC2z280aVAFwI0_Jr0_Gr
        1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IE
        rcIFxwCY02Avz4vE14v_Gw1l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr
        1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE
        14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7
        IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWrJr0_WFyUJwCI42IY
        6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa
        73UjIFyTuYvjfUF0eHDUUUU
X-CM-SenderInfo: irzsiiysuqikmy6i3vldqovvfxof0/
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

refcount_t type and corresponding API can protect refcounters from
accidental underflow and overflow and further use-after-free situations.

Signed-off-by: Xiyu Yang <xiyuyang19@fudan.edu.cn>
Signed-off-by: Xin Tan <tanxin.ctf@gmail.com>
---
 drivers/net/ethernet/chelsio/cxgb3/l2t.c | 15 ++++++++-------
 drivers/net/ethernet/chelsio/cxgb3/l2t.h | 10 +++++++---
 2 files changed, 15 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb3/l2t.c b/drivers/net/ethernet/chelsio/cxgb3/l2t.c
index 9749d1239f58..0f2a47bc20d8 100644
--- a/drivers/net/ethernet/chelsio/cxgb3/l2t.c
+++ b/drivers/net/ethernet/chelsio/cxgb3/l2t.c
@@ -225,10 +225,11 @@ static struct l2t_entry *alloc_l2e(struct l2t_data *d)
 
 	/* there's definitely a free entry */
 	for (e = d->rover, end = &d->l2tab[d->nentries]; e != end; ++e)
-		if (atomic_read(&e->refcnt) == 0)
+		if (refcount_read(&e->refcnt) == 0)
 			goto found;
 
-	for (e = &d->l2tab[1]; atomic_read(&e->refcnt); ++e) ;
+	for (e = &d->l2tab[1]; refcount_read(&e->refcnt); ++e)
+		;
 found:
 	d->rover = e + 1;
 	atomic_dec(&d->nfree);
@@ -264,7 +265,7 @@ static struct l2t_entry *alloc_l2e(struct l2t_data *d)
 void t3_l2e_free(struct l2t_data *d, struct l2t_entry *e)
 {
 	spin_lock_bh(&e->lock);
-	if (atomic_read(&e->refcnt) == 0) {	/* hasn't been recycled */
+	if (refcount_read(&e->refcnt) == 0) {	/* hasn't been recycled */
 		if (e->neigh) {
 			neigh_release(e->neigh);
 			e->neigh = NULL;
@@ -335,7 +336,7 @@ struct l2t_entry *t3_l2t_get(struct t3cdev *cdev, struct dst_entry *dst,
 		if (e->addr == addr && e->ifindex == ifidx &&
 		    e->smt_idx == smt_idx) {
 			l2t_hold(d, e);
-			if (atomic_read(&e->refcnt) == 1)
+			if (refcount_read(&e->refcnt) == 1)
 				reuse_entry(e, neigh);
 			goto done_unlock;
 		}
@@ -350,7 +351,7 @@ struct l2t_entry *t3_l2t_get(struct t3cdev *cdev, struct dst_entry *dst,
 		e->addr = addr;
 		e->ifindex = ifidx;
 		e->smt_idx = smt_idx;
-		atomic_set(&e->refcnt, 1);
+		refcount_set(&e->refcnt, 1);
 		neigh_replace(e, neigh);
 		if (is_vlan_dev(neigh->dev))
 			e->vlan = vlan_dev_vlan_id(neigh->dev);
@@ -418,7 +419,7 @@ void t3_l2t_update(struct t3cdev *dev, struct neighbour *neigh)
 	__skb_queue_head_init(&arpq);
 
 	read_unlock(&d->lock);
-	if (atomic_read(&e->refcnt)) {
+	if (refcount_read(&e->refcnt)) {
 		if (neigh != e->neigh)
 			neigh_replace(e, neigh);
 
@@ -459,7 +460,7 @@ struct l2t_data *t3_init_l2t(unsigned int l2t_capacity)
 		d->l2tab[i].state = L2T_STATE_UNUSED;
 		__skb_queue_head_init(&d->l2tab[i].arpq);
 		spin_lock_init(&d->l2tab[i].lock);
-		atomic_set(&d->l2tab[i].refcnt, 0);
+		refcount_set(&d->l2tab[i].refcnt, 0);
 	}
 	return d;
 }
diff --git a/drivers/net/ethernet/chelsio/cxgb3/l2t.h b/drivers/net/ethernet/chelsio/cxgb3/l2t.h
index ea75f275023f..bbdaa4a6aba2 100644
--- a/drivers/net/ethernet/chelsio/cxgb3/l2t.h
+++ b/drivers/net/ethernet/chelsio/cxgb3/l2t.h
@@ -35,6 +35,7 @@
 #include <linux/spinlock.h>
 #include "t3cdev.h"
 #include <linux/atomic.h>
+#include <linux/refcount.h>
 
 enum {
 	L2T_STATE_VALID,	/* entry is up to date */
@@ -66,7 +67,7 @@ struct l2t_entry {
 	struct l2t_entry *next;	/* next l2t_entry on chain */
 	struct sk_buff_head arpq;	/* queue of packets awaiting resolution */
 	spinlock_t lock;
-	atomic_t refcnt;	/* entry reference count */
+	refcount_t refcnt;	/* entry reference count */
 	u8 dmac[6];		/* neighbour's MAC address */
 };
 
@@ -133,7 +134,7 @@ static inline void l2t_release(struct t3cdev *t, struct l2t_entry *e)
 	rcu_read_lock();
 	d = L2DATA(t);
 
-	if (atomic_dec_and_test(&e->refcnt) && d)
+	if (refcount_dec_and_test(&e->refcnt) && d)
 		t3_l2e_free(d, e);
 
 	rcu_read_unlock();
@@ -141,7 +142,10 @@ static inline void l2t_release(struct t3cdev *t, struct l2t_entry *e)
 
 static inline void l2t_hold(struct l2t_data *d, struct l2t_entry *e)
 {
-	if (d && atomic_add_return(1, &e->refcnt) == 1)	/* 0 -> 1 transition */
+	if (!d)
+		return;
+	refcount_inc(&e->refcnt);
+	if (refcount_read(&e->refcnt) == 1)	/* 0 -> 1 transition */
 		atomic_dec(&d->nfree);
 }
 
-- 
2.7.4

