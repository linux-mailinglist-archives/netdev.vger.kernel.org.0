Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 702FF641A06
	for <lists+netdev@lfdr.de>; Sun,  4 Dec 2022 00:49:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229762AbiLCXh0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Dec 2022 18:37:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbiLCXhZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Dec 2022 18:37:25 -0500
Received: from mail-qt1-x834.google.com (mail-qt1-x834.google.com [IPv6:2607:f8b0:4864:20::834])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8D8715728
        for <netdev@vger.kernel.org>; Sat,  3 Dec 2022 15:37:24 -0800 (PST)
Received: by mail-qt1-x834.google.com with SMTP id r19so9162178qtx.6
        for <netdev@vger.kernel.org>; Sat, 03 Dec 2022 15:37:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=rMvTWGxulE9yvQiI5bn27Qrz6ZS1MYp03pRkY6Ui0e8=;
        b=OgPmThBMNmCw9FooZO96IpAhdD7lSB3qVz4cbg1cu4SlN/lt2RzEmO67wi6LrKKXsU
         CQ+6EDmaSwnQGCguPoOnhPBizRpahQ8nofWrQ7ZkxdzZZ6qI44gBBjy2asj+3PL039Az
         sO5Fk6Nbe+eOmNjP7TNzMBg0cogmQdTAexnf+9jzZrWaT3TWzloCA166CfPuPszhfXbT
         WkmkFwYaMmvwR6TnhoOimLhzhcD9tHF9A2OKgOl5ZDtqhsFLNmEjVSvI9WxJ8K9voqKr
         +UP9oujUYsjCOWk4beleCvVzsbY2Epch4xIiJio1XTxroCdhVVez3wJCX+TBhxJcaKgO
         weVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rMvTWGxulE9yvQiI5bn27Qrz6ZS1MYp03pRkY6Ui0e8=;
        b=47hWjIIYEpksM/MgpbW6Sq8HgbquLzmdVAs+M15+CWXwXKhyi0Yqxmtker5ihE2OpD
         WbZ/sdzxw+bqFxe7truEKDilmkZEIyxNAjfj4zFIE3j+Y76jkCjpbfp1XMH4qqNioB4T
         nclkYFAirgE7B7PYjkDiP2JevMMziXnsKZHEVogwoO5odF6vQjfFusG86H2CQ/l4p+uF
         Xv542v96VBjUg2C58litRlktgbmwZDeuLvdXlRk7f0vFvosAJtwzqzgTItHrOZ7PTwVg
         CbZ1aWTxsUtyXPlw4lDvqc7Gx6T6gxkqGvUAPjTwGN9gPFJWY5JYG2pQrUIpFmFiPGKj
         Bufw==
X-Gm-Message-State: ANoB5pnxGLCEd7mw0w/gRpR56Us2RSfoxTJdcF7yD3/zzk87s3LyHM/g
        1WIQqOmpnaFVk3fU81qhGqch8FxMs5GPFw==
X-Google-Smtp-Source: AA0mqf74+rKVecaREOfUfCFVM+P/z0GmNKVkwBDcgXkTtRdNwbf0iiw3ehnXDf+vzGbps9Qp3kWS+g==
X-Received: by 2002:ac8:1189:0:b0:3a5:2766:552a with SMTP id d9-20020ac81189000000b003a52766552amr58291512qtj.79.1670110643378;
        Sat, 03 Dec 2022 15:37:23 -0800 (PST)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id l5-20020a05620a28c500b006cf19068261sm8838375qkp.116.2022.12.03.15.37.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Dec 2022 15:37:22 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>,
        tipc-discussion@lists.sourceforge.net
Cc:     davem@davemloft.net, kuba@kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Jon Maloy <jmaloy@redhat.com>,
        Ying Xue <ying.xue@windriver.com>,
        Shuang Li <shuali@redhat.com>,
        Hoang Le <hoang.h.le@dektech.com.au>
Subject: [PATCH net] tipc: call tipc_lxc_xmit without holding node_read_lock
Date:   Sat,  3 Dec 2022 18:37:21 -0500
Message-Id: <5bdd1f8fee9db695cfff4528a48c9b9d0523fb00.1670110641.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.31.1
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

When sending packets between nodes in netns, it calls tipc_lxc_xmit() for
peer node to receive the packets where tipc_sk_mcast_rcv()/tipc_sk_rcv()
might be called, and it's pretty much like in tipc_rcv().

Currently the local 'node rw lock' is held during calling tipc_lxc_xmit()
to protect the peer_net not being freed by another thread. However, when
receiving these packets, tipc_node_add_conn() might be called where the
peer 'node rw lock' is acquired. Then a dead lock warning is triggered by
lockdep detector, although it is not a real dead lock:

    WARNING: possible recursive locking detected
    --------------------------------------------
    conn_server/1086 is trying to acquire lock:
    ffff8880065cb020 (&n->lock#2){++--}-{2:2}, \
                     at: tipc_node_add_conn.cold.76+0xaa/0x211 [tipc]

    but task is already holding lock:
    ffff8880065cd020 (&n->lock#2){++--}-{2:2}, \
                     at: tipc_node_xmit+0x285/0xb30 [tipc]

    other info that might help us debug this:
     Possible unsafe locking scenario:

           CPU0
           ----
      lock(&n->lock#2);
      lock(&n->lock#2);

     *** DEADLOCK ***

     May be due to missing lock nesting notation

    4 locks held by conn_server/1086:
     #0: ffff8880036d1e40 (sk_lock-AF_TIPC){+.+.}-{0:0}, \
                          at: tipc_accept+0x9c0/0x10b0 [tipc]
     #1: ffff8880036d5f80 (sk_lock-AF_TIPC/1){+.+.}-{0:0}, \
                          at: tipc_accept+0x363/0x10b0 [tipc]
     #2: ffff8880065cd020 (&n->lock#2){++--}-{2:2}, \
                          at: tipc_node_xmit+0x285/0xb30 [tipc]
     #3: ffff888012e13370 (slock-AF_TIPC){+...}-{2:2}, \
                          at: tipc_sk_rcv+0x2da/0x1b40 [tipc]

    Call Trace:
     <TASK>
     dump_stack_lvl+0x44/0x5b
     __lock_acquire.cold.77+0x1f2/0x3d7
     lock_acquire+0x1d2/0x610
     _raw_write_lock_bh+0x38/0x80
     tipc_node_add_conn.cold.76+0xaa/0x211 [tipc]
     tipc_sk_finish_conn+0x21e/0x640 [tipc]
     tipc_sk_filter_rcv+0x147b/0x3030 [tipc]
     tipc_sk_rcv+0xbb4/0x1b40 [tipc]
     tipc_lxc_xmit+0x225/0x26b [tipc]
     tipc_node_xmit.cold.82+0x4a/0x102 [tipc]
     __tipc_sendstream+0x879/0xff0 [tipc]
     tipc_accept+0x966/0x10b0 [tipc]
     do_accept+0x37d/0x590

This patch avoids this warning by not holding the 'node rw lock' before
calling tipc_lxc_xmit(). As to protect the 'peer_net', rcu_read_lock()
should be enough, as in cleanup_net() when freeing the netns, it calls
synchronize_rcu() before the free is continued.

Also since tipc_lxc_xmit() is like the RX path in tipc_rcv(), it makes
sense to call it under rcu_read_lock(). Note that the right lock order
must be:

   rcu_read_lock();
   tipc_node_read_lock(n);
   tipc_node_read_unlock(n);
   tipc_lxc_xmit();
   rcu_read_unlock();

instead of:

   tipc_node_read_lock(n);
   rcu_read_lock();
   tipc_node_read_unlock(n);
   tipc_lxc_xmit();
   rcu_read_unlock();

and we have to call tipc_node_read_lock/unlock() twice in
tipc_node_xmit().

Fixes: f73b12812a3d ("tipc: improve throughput between nodes in netns")
Reported-by: Shuang Li <shuali@redhat.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/tipc/node.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/net/tipc/node.c b/net/tipc/node.c
index b48d97cbbe29..49ddc484c4fe 100644
--- a/net/tipc/node.c
+++ b/net/tipc/node.c
@@ -1689,6 +1689,7 @@ int tipc_node_xmit(struct net *net, struct sk_buff_head *list,
 	struct tipc_node *n;
 	struct sk_buff_head xmitq;
 	bool node_up = false;
+	struct net *peer_net;
 	int bearer_id;
 	int rc;
 
@@ -1705,18 +1706,23 @@ int tipc_node_xmit(struct net *net, struct sk_buff_head *list,
 		return -EHOSTUNREACH;
 	}
 
+	rcu_read_lock();
 	tipc_node_read_lock(n);
 	node_up = node_is_up(n);
-	if (node_up && n->peer_net && check_net(n->peer_net)) {
+	peer_net = n->peer_net;
+	tipc_node_read_unlock(n);
+	if (node_up && peer_net && check_net(peer_net)) {
 		/* xmit inner linux container */
-		tipc_lxc_xmit(n->peer_net, list);
+		tipc_lxc_xmit(peer_net, list);
 		if (likely(skb_queue_empty(list))) {
-			tipc_node_read_unlock(n);
+			rcu_read_unlock();
 			tipc_node_put(n);
 			return 0;
 		}
 	}
+	rcu_read_unlock();
 
+	tipc_node_read_lock(n);
 	bearer_id = n->active_links[selector & 1];
 	if (unlikely(bearer_id == INVALID_BEARER_ID)) {
 		tipc_node_read_unlock(n);
-- 
2.31.1

