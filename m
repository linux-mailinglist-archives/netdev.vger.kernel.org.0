Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4959D1B2DB4
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 19:04:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729279AbgDUREb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 13:04:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:33750 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729066AbgDURER (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Apr 2020 13:04:17 -0400
Received: from mail.kernel.org (ip5f5ad4d8.dynamic.kabel-deutschland.de [95.90.212.216])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1794520735;
        Tue, 21 Apr 2020 17:04:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587488654;
        bh=4/i9W4GgAcQe6wApHTBX6w5i7TpEniD9O/sncUoeQso=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DhlQRrj6H+b6MaNRZ7OP8PpKws9THUgWA3s4xBG5ZiRytxAjmbnNCoMa7+zpx/7z1
         /1QdNq9v8d1MQV/Byf4gKtz7TsSIGvTmFxqOR1lNCmh1vzuvzZ4p1p92FW5IiZCdes
         QEhY+3RWCeawvDJEhECk4xgCva9r99Iv7rAH5BWA=
Received: from mchehab by mail.kernel.org with local (Exim 4.92.3)
        (envelope-from <mchehab@kernel.org>)
        id 1jQwJg-00CmLj-4s; Tue, 21 Apr 2020 19:04:12 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Joel Fernandes <joel@joelfernandes.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Joe Stringer <joe@wand.net.nz>,
        zhanglin <zhang.lin16@zte.com.cn>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vito Caputo <vcaputo@pengaru.com>, rcu@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH 04/10] docs: RCU: convert rculist_nulls.txt to ReST
Date:   Tue, 21 Apr 2020 19:04:05 +0200
Message-Id: <772af5d06b5122e77441625cbfd7950549b44954.1587488137.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <cover.1587488137.git.mchehab+huawei@kernel.org>
References: <cover.1587488137.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

- Add a SPDX header;
- Adjust document title;
- Some whitespace fixes and new line breaks;
- Mark literal blocks as such;
- Add it to RCU/index.rst.

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 Documentation/RCU/index.rst         |   1 +
 Documentation/RCU/rculist_nulls.rst | 194 ++++++++++++++++++++++++++++
 Documentation/RCU/rculist_nulls.txt | 172 ------------------------
 include/linux/rculist_nulls.h       |   2 +-
 net/core/sock.c                     |   4 +-
 5 files changed, 198 insertions(+), 175 deletions(-)
 create mode 100644 Documentation/RCU/rculist_nulls.rst
 delete mode 100644 Documentation/RCU/rculist_nulls.txt

diff --git a/Documentation/RCU/index.rst b/Documentation/RCU/index.rst
index fa7a2a8949b7..577a47e27f5d 100644
--- a/Documentation/RCU/index.rst
+++ b/Documentation/RCU/index.rst
@@ -17,6 +17,7 @@ RCU concepts
    rcu_dereference
    whatisRCU
    rcu
+   rculist_nulls
    listRCU
    NMI-RCU
    UP
diff --git a/Documentation/RCU/rculist_nulls.rst b/Documentation/RCU/rculist_nulls.rst
new file mode 100644
index 000000000000..d40374221d69
--- /dev/null
+++ b/Documentation/RCU/rculist_nulls.rst
@@ -0,0 +1,194 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+=================================================
+Using RCU hlist_nulls to protect list and objects
+=================================================
+
+This section describes how to use hlist_nulls to
+protect read-mostly linked lists and
+objects using SLAB_TYPESAFE_BY_RCU allocations.
+
+Please read the basics in Documentation/RCU/listRCU.rst
+
+Using special makers (called 'nulls') is a convenient way
+to solve following problem :
+
+A typical RCU linked list managing objects which are
+allocated with SLAB_TYPESAFE_BY_RCU kmem_cache can
+use following algos :
+
+1) Lookup algo
+--------------
+
+::
+
+  rcu_read_lock()
+  begin:
+  obj = lockless_lookup(key);
+  if (obj) {
+    if (!try_get_ref(obj)) // might fail for free objects
+      goto begin;
+    /*
+    * Because a writer could delete object, and a writer could
+    * reuse these object before the RCU grace period, we
+    * must check key after getting the reference on object
+    */
+    if (obj->key != key) { // not the object we expected
+      put_ref(obj);
+      goto begin;
+    }
+  }
+  rcu_read_unlock();
+
+Beware that lockless_lookup(key) cannot use traditional hlist_for_each_entry_rcu()
+but a version with an additional memory barrier (smp_rmb())
+
+::
+
+  lockless_lookup(key)
+  {
+    struct hlist_node *node, *next;
+    for (pos = rcu_dereference((head)->first);
+        pos && ({ next = pos->next; smp_rmb(); prefetch(next); 1; }) &&
+        ({ tpos = hlist_entry(pos, typeof(*tpos), member); 1; });
+        pos = rcu_dereference(next))
+      if (obj->key == key)
+        return obj;
+    return NULL;
+  }
+
+And note the traditional hlist_for_each_entry_rcu() misses this smp_rmb()::
+
+  struct hlist_node *node;
+  for (pos = rcu_dereference((head)->first);
+        pos && ({ prefetch(pos->next); 1; }) &&
+        ({ tpos = hlist_entry(pos, typeof(*tpos), member); 1; });
+        pos = rcu_dereference(pos->next))
+   if (obj->key == key)
+     return obj;
+  return NULL;
+
+Quoting Corey Minyard::
+
+  "If the object is moved from one list to another list in-between the
+  time the hash is calculated and the next field is accessed, and the
+  object has moved to the end of a new list, the traversal will not
+  complete properly on the list it should have, since the object will
+  be on the end of the new list and there's not a way to tell it's on a
+  new list and restart the list traversal. I think that this can be
+  solved by pre-fetching the "next" field (with proper barriers) before
+  checking the key."
+
+2) Insert algo
+--------------
+
+We need to make sure a reader cannot read the new 'obj->obj_next' value
+and previous value of 'obj->key'. Or else, an item could be deleted
+from a chain, and inserted into another chain. If new chain was empty
+before the move, 'next' pointer is NULL, and lockless reader can
+not detect it missed following items in original chain.
+
+::
+
+  /*
+  * Please note that new inserts are done at the head of list,
+  * not in the middle or end.
+  */
+  obj = kmem_cache_alloc(...);
+  lock_chain(); // typically a spin_lock()
+  obj->key = key;
+  /*
+  * we need to make sure obj->key is updated before obj->next
+  * or obj->refcnt
+  */
+  smp_wmb();
+  atomic_set(&obj->refcnt, 1);
+  hlist_add_head_rcu(&obj->obj_node, list);
+  unlock_chain(); // typically a spin_unlock()
+
+
+3) Remove algo
+--------------
+Nothing special here, we can use a standard RCU hlist deletion.
+But thanks to SLAB_TYPESAFE_BY_RCU, beware a deleted object can be reused
+very very fast (before the end of RCU grace period)
+
+::
+
+  if (put_last_reference_on(obj) {
+    lock_chain(); // typically a spin_lock()
+    hlist_del_init_rcu(&obj->obj_node);
+    unlock_chain(); // typically a spin_unlock()
+    kmem_cache_free(cachep, obj);
+  }
+
+
+
+--------------------------------------------------------------------------
+
+With hlist_nulls we can avoid extra smp_rmb() in lockless_lookup()
+and extra smp_wmb() in insert function.
+
+For example, if we choose to store the slot number as the 'nulls'
+end-of-list marker for each slot of the hash table, we can detect
+a race (some writer did a delete and/or a move of an object
+to another chain) checking the final 'nulls' value if
+the lookup met the end of chain. If final 'nulls' value
+is not the slot number, then we must restart the lookup at
+the beginning. If the object was moved to the same chain,
+then the reader doesn't care : It might eventually
+scan the list again without harm.
+
+
+1) lookup algo
+--------------
+
+::
+
+  head = &table[slot];
+  rcu_read_lock();
+  begin:
+  hlist_nulls_for_each_entry_rcu(obj, node, head, member) {
+    if (obj->key == key) {
+      if (!try_get_ref(obj)) // might fail for free objects
+        goto begin;
+      if (obj->key != key) { // not the object we expected
+        put_ref(obj);
+        goto begin;
+      }
+    goto out;
+  }
+  /*
+  * if the nulls value we got at the end of this lookup is
+  * not the expected one, we must restart lookup.
+  * We probably met an item that was moved to another chain.
+  */
+  if (get_nulls_value(node) != slot)
+  goto begin;
+  obj = NULL;
+
+  out:
+  rcu_read_unlock();
+
+2) Insert function
+------------------
+
+::
+
+  /*
+  * Please note that new inserts are done at the head of list,
+  * not in the middle or end.
+  */
+  obj = kmem_cache_alloc(cachep);
+  lock_chain(); // typically a spin_lock()
+  obj->key = key;
+  /*
+  * changes to obj->key must be visible before refcnt one
+  */
+  smp_wmb();
+  atomic_set(&obj->refcnt, 1);
+  /*
+  * insert obj in RCU way (readers might be traversing chain)
+  */
+  hlist_nulls_add_head_rcu(&obj->obj_node, list);
+  unlock_chain(); // typically a spin_unlock()
diff --git a/Documentation/RCU/rculist_nulls.txt b/Documentation/RCU/rculist_nulls.txt
deleted file mode 100644
index 23f115dc87cf..000000000000
--- a/Documentation/RCU/rculist_nulls.txt
+++ /dev/null
@@ -1,172 +0,0 @@
-Using hlist_nulls to protect read-mostly linked lists and
-objects using SLAB_TYPESAFE_BY_RCU allocations.
-
-Please read the basics in Documentation/RCU/listRCU.rst
-
-Using special makers (called 'nulls') is a convenient way
-to solve following problem :
-
-A typical RCU linked list managing objects which are
-allocated with SLAB_TYPESAFE_BY_RCU kmem_cache can
-use following algos :
-
-1) Lookup algo
---------------
-rcu_read_lock()
-begin:
-obj = lockless_lookup(key);
-if (obj) {
-  if (!try_get_ref(obj)) // might fail for free objects
-    goto begin;
-  /*
-   * Because a writer could delete object, and a writer could
-   * reuse these object before the RCU grace period, we
-   * must check key after getting the reference on object
-   */
-  if (obj->key != key) { // not the object we expected
-     put_ref(obj);
-     goto begin;
-   }
-}
-rcu_read_unlock();
-
-Beware that lockless_lookup(key) cannot use traditional hlist_for_each_entry_rcu()
-but a version with an additional memory barrier (smp_rmb())
-
-lockless_lookup(key)
-{
-   struct hlist_node *node, *next;
-   for (pos = rcu_dereference((head)->first);
-          pos && ({ next = pos->next; smp_rmb(); prefetch(next); 1; }) &&
-          ({ tpos = hlist_entry(pos, typeof(*tpos), member); 1; });
-          pos = rcu_dereference(next))
-      if (obj->key == key)
-         return obj;
-   return NULL;
-
-And note the traditional hlist_for_each_entry_rcu() misses this smp_rmb() :
-
-   struct hlist_node *node;
-   for (pos = rcu_dereference((head)->first);
-		pos && ({ prefetch(pos->next); 1; }) &&
-		({ tpos = hlist_entry(pos, typeof(*tpos), member); 1; });
-		pos = rcu_dereference(pos->next))
-      if (obj->key == key)
-         return obj;
-   return NULL;
-}
-
-Quoting Corey Minyard :
-
-"If the object is moved from one list to another list in-between the
- time the hash is calculated and the next field is accessed, and the
- object has moved to the end of a new list, the traversal will not
- complete properly on the list it should have, since the object will
- be on the end of the new list and there's not a way to tell it's on a
- new list and restart the list traversal.  I think that this can be
- solved by pre-fetching the "next" field (with proper barriers) before
- checking the key."
-
-2) Insert algo :
-----------------
-
-We need to make sure a reader cannot read the new 'obj->obj_next' value
-and previous value of 'obj->key'. Or else, an item could be deleted
-from a chain, and inserted into another chain. If new chain was empty
-before the move, 'next' pointer is NULL, and lockless reader can
-not detect it missed following items in original chain.
-
-/*
- * Please note that new inserts are done at the head of list,
- * not in the middle or end.
- */
-obj = kmem_cache_alloc(...);
-lock_chain(); // typically a spin_lock()
-obj->key = key;
-/*
- * we need to make sure obj->key is updated before obj->next
- * or obj->refcnt
- */
-smp_wmb();
-atomic_set(&obj->refcnt, 1);
-hlist_add_head_rcu(&obj->obj_node, list);
-unlock_chain(); // typically a spin_unlock()
-
-
-3) Remove algo
---------------
-Nothing special here, we can use a standard RCU hlist deletion.
-But thanks to SLAB_TYPESAFE_BY_RCU, beware a deleted object can be reused
-very very fast (before the end of RCU grace period)
-
-if (put_last_reference_on(obj) {
-   lock_chain(); // typically a spin_lock()
-   hlist_del_init_rcu(&obj->obj_node);
-   unlock_chain(); // typically a spin_unlock()
-   kmem_cache_free(cachep, obj);
-}
-
-
-
---------------------------------------------------------------------------
-With hlist_nulls we can avoid extra smp_rmb() in lockless_lookup()
-and extra smp_wmb() in insert function.
-
-For example, if we choose to store the slot number as the 'nulls'
-end-of-list marker for each slot of the hash table, we can detect
-a race (some writer did a delete and/or a move of an object
-to another chain) checking the final 'nulls' value if
-the lookup met the end of chain. If final 'nulls' value
-is not the slot number, then we must restart the lookup at
-the beginning. If the object was moved to the same chain,
-then the reader doesn't care : It might eventually
-scan the list again without harm.
-
-
-1) lookup algo
-
- head = &table[slot];
- rcu_read_lock();
-begin:
- hlist_nulls_for_each_entry_rcu(obj, node, head, member) {
-   if (obj->key == key) {
-      if (!try_get_ref(obj)) // might fail for free objects
-         goto begin;
-      if (obj->key != key) { // not the object we expected
-         put_ref(obj);
-         goto begin;
-      }
-  goto out;
- }
-/*
- * if the nulls value we got at the end of this lookup is
- * not the expected one, we must restart lookup.
- * We probably met an item that was moved to another chain.
- */
- if (get_nulls_value(node) != slot)
-   goto begin;
- obj = NULL;
-
-out:
- rcu_read_unlock();
-
-2) Insert function :
---------------------
-
-/*
- * Please note that new inserts are done at the head of list,
- * not in the middle or end.
- */
-obj = kmem_cache_alloc(cachep);
-lock_chain(); // typically a spin_lock()
-obj->key = key;
-/*
- * changes to obj->key must be visible before refcnt one
- */
-smp_wmb();
-atomic_set(&obj->refcnt, 1);
-/*
- * insert obj in RCU way (readers might be traversing chain)
- */
-hlist_nulls_add_head_rcu(&obj->obj_node, list);
-unlock_chain(); // typically a spin_unlock()
diff --git a/include/linux/rculist_nulls.h b/include/linux/rculist_nulls.h
index 9670b54b484a..ff3e94779e73 100644
--- a/include/linux/rculist_nulls.h
+++ b/include/linux/rculist_nulls.h
@@ -162,7 +162,7 @@ static inline void hlist_nulls_add_fake(struct hlist_nulls_node *n)
  * The barrier() is needed to make sure compiler doesn't cache first element [1],
  * as this loop can be restarted [2]
  * [1] Documentation/core-api/atomic_ops.rst around line 114
- * [2] Documentation/RCU/rculist_nulls.txt around line 146
+ * [2] Documentation/RCU/rculist_nulls.rst around line 146
  */
 #define hlist_nulls_for_each_entry_rcu(tpos, pos, head, member)			\
 	for (({barrier();}),							\
diff --git a/net/core/sock.c b/net/core/sock.c
index 90509c37d291..da7eb3f5c03e 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -1883,7 +1883,7 @@ struct sock *sk_clone_lock(const struct sock *sk, const gfp_t priority)
 
 		/*
 		 * Before updating sk_refcnt, we must commit prior changes to memory
-		 * (Documentation/RCU/rculist_nulls.txt for details)
+		 * (Documentation/RCU/rculist_nulls.rst for details)
 		 */
 		smp_wmb();
 		refcount_set(&newsk->sk_refcnt, 2);
@@ -2945,7 +2945,7 @@ void sock_init_data(struct socket *sock, struct sock *sk)
 	sk_rx_queue_clear(sk);
 	/*
 	 * Before updating sk_refcnt, we must commit prior changes to memory
-	 * (Documentation/RCU/rculist_nulls.txt for details)
+	 * (Documentation/RCU/rculist_nulls.rst for details)
 	 */
 	smp_wmb();
 	refcount_set(&sk->sk_refcnt, 1);
-- 
2.25.2

