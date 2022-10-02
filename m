Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E50005F25E1
	for <lists+netdev@lfdr.de>; Mon,  3 Oct 2022 00:11:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229731AbiJBWLd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Oct 2022 18:11:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229716AbiJBWLc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Oct 2022 18:11:32 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 787972B622;
        Sun,  2 Oct 2022 15:11:31 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id nb11so18753809ejc.5;
        Sun, 02 Oct 2022 15:11:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=WgA0hCJxi/dSWwodIJcvgXcBJQgqJf2yOczBA3op2Mo=;
        b=eJ2Hv1l6pIGCnYF11BAdkKmTi4GIfKZNPzCLDJK7kRwTO1f/CRGzyap+0iPRf8CsJC
         JDKsocx71VylWZuNJ9wJ6PMhcC50itxZTAOjKhmDD0in+WWW4eFqAdgkY2+VZCPK6zgf
         /kabYkxEdUYLjpHeEvF+suWEHSw7rg+ZK/IHYck4Ugi7wqppkp1+R0+IRp1uXO/AinHt
         FZmYLfT3ibFFZ8nL+VhRwixInUCLUuFEOfEgJOTma6JG+koJPpsBK1PIl3TQquEzCrx+
         9liyMSORxUgbS7Z05cqDzbvAfgJcw69qbMwqCykYnkNM4SrQGirJXrpOuHiZvfZYi6T8
         i4jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=WgA0hCJxi/dSWwodIJcvgXcBJQgqJf2yOczBA3op2Mo=;
        b=0iqFM2n+n9J3/mD0PK8Lag1lilr2gKZ16ZzZnn/CUtdgJM71VwyuUwSKagyuq4W8LQ
         VqGPkzg0O+jpTrn9AhJnxjXn/wiyx9ZzhKpcL81DeGbdpx6FZu7nTj5PpUH005mb0Dkv
         eCDb2HM7gfySc9R746eQ/DfQ+ZTVlhJTNggrvalg5+iCSodvxIq+oCO7DivaM9sjtSSj
         xangOR0gmswDVhlf0iX8c91WYpqOK8KZeLFc0GzIwLXQOAwHVf1H+w+TdvyFaU7fwC4i
         XVZpXEX49rCK26Iti8n230HqEYe2F3Wton6Q6s8dMVghU/XbqKTzYx6sTjV3oLwam4tS
         gAeg==
X-Gm-Message-State: ACrzQf0xHyMXe570UxjR2qWyhN+vmCXs+dmHhtaj/JBucmvbMEKixSng
        sLLOD5G/Ym113TX/wYXOm3M=
X-Google-Smtp-Source: AMsMyM40/yNd3nAHASDfDw+wogM6bUHkmOeBiCagX+O4Wmu8l8BOTQlr3OWup349rTVBUHsPwP70TQ==
X-Received: by 2002:a17:907:3ea9:b0:787:f6aa:8ad5 with SMTP id hs41-20020a1709073ea900b00787f6aa8ad5mr10255201ejc.3.1664748689040;
        Sun, 02 Oct 2022 15:11:29 -0700 (PDT)
Received: from satellite.lan ([2001:470:70b8:1337:725a:23fc:85d5:cac9])
        by smtp.gmail.com with ESMTPSA id w15-20020a1709062f8f00b007415f8ffcbbsm4540207eji.98.2022.10.02.15.11.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Oct 2022 15:11:28 -0700 (PDT)
From:   Maxim Mikityanskiy <maxtram95@gmail.com>
To:     Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Gustavo Padovan <gustavo.padovan@collabora.co.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        Maxim Mikityanskiy <maxtram95@gmail.com>
Subject: [PATCH] Bluetooth: L2CAP: Fix use-after-free caused by l2cap_reassemble_sdu
Date:   Mon,  3 Oct 2022 01:11:12 +0300
Message-Id: <20221002221112.475966-1-maxtram95@gmail.com>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the race condition between the following two flows that run in
parallel:

1. l2cap_reassemble_sdu -> chan->ops->recv -> l2cap_sock_recv_cb ->
   __sock_queue_rcv_skb.

2. bt_sock_recvmsg -> skb_recv_datagram, skb_free_datagram.

An SKB can be queued by the first flow and immediately dequeued and
freed by the second flow, therefore the callers of l2cap_reassemble_sdu
can't use the SKB after that function returns. However, some places
continue accessing struct l2cap_ctrl that resides in the SKB's CB for a
short time after l2cap_reassemble_sdu returns, leading to a
use-after-free condition (the stack trace is below, line numbers for
kernel 5.19.8).

Fix it by keeping a local copy of struct l2cap_ctrl.

BUG: KASAN: use-after-free in l2cap_rx_state_recv (net/bluetooth/l2cap_core.c:6906) bluetooth
Read of size 1 at addr ffff88812025f2f0 by task kworker/u17:3/43169

Workqueue: hci0 hci_rx_work [bluetooth]
Call Trace:
 <TASK>
 dump_stack_lvl (lib/dump_stack.c:107 (discriminator 4))
 print_report.cold (mm/kasan/report.c:314 mm/kasan/report.c:429)
 ? l2cap_rx_state_recv (net/bluetooth/l2cap_core.c:6906) bluetooth
 kasan_report (mm/kasan/report.c:162 mm/kasan/report.c:493)
 ? l2cap_rx_state_recv (net/bluetooth/l2cap_core.c:6906) bluetooth
 l2cap_rx_state_recv (net/bluetooth/l2cap_core.c:6906) bluetooth
 l2cap_rx (net/bluetooth/l2cap_core.c:7236 net/bluetooth/l2cap_core.c:7271) bluetooth
 ? sk_filter_trim_cap (net/core/filter.c:123)
 ? l2cap_chan_hold_unless_zero (./arch/x86/include/asm/atomic.h:202 ./include/linux/atomic/atomic-instrumented.h:560 ./include/linux/refcount.h:157 ./include/linux/refcount.h:227 ./include/linux/refcount.h:245 ./include/linux/kref.h:111 net/bluetooth/l2cap_core.c:517) bluetooth
 ? l2cap_rx_state_recv (net/bluetooth/l2cap_core.c:7252) bluetooth
 l2cap_recv_frame (net/bluetooth/l2cap_core.c:7405 net/bluetooth/l2cap_core.c:7620 net/bluetooth/l2cap_core.c:7723) bluetooth
 ? lock_release (./include/trace/events/lock.h:69 kernel/locking/lockdep.c:5677)
 ? hci_rx_work (net/bluetooth/hci_core.c:3637 net/bluetooth/hci_core.c:3832) bluetooth
 ? reacquire_held_locks (kernel/locking/lockdep.c:5674)
 ? trace_contention_end (./include/trace/events/lock.h:122 ./include/trace/events/lock.h:122)
 ? l2cap_config_rsp.isra.0 (net/bluetooth/l2cap_core.c:7674) bluetooth
 ? hci_rx_work (./include/net/bluetooth/hci_core.h:1024 net/bluetooth/hci_core.c:3634 net/bluetooth/hci_core.c:3832) bluetooth
 ? lock_acquire (./include/trace/events/lock.h:24 kernel/locking/lockdep.c:5637)
 ? __mutex_unlock_slowpath (./arch/x86/include/asm/atomic64_64.h:190 ./include/linux/atomic/atomic-long.h:449 ./include/linux/atomic/atomic-instrumented.h:1790 kernel/locking/mutex.c:924)
 ? rcu_read_lock_sched_held (kernel/rcu/update.c:104 kernel/rcu/update.c:123)
 ? memcpy (mm/kasan/shadow.c:65 (discriminator 1))
 ? l2cap_recv_frag (net/bluetooth/l2cap_core.c:8340) bluetooth
 l2cap_recv_acldata (net/bluetooth/l2cap_core.c:8486) bluetooth
 hci_rx_work (net/bluetooth/hci_core.c:3642 net/bluetooth/hci_core.c:3832) bluetooth
 process_one_work (kernel/workqueue.c:2289)
 ? lock_downgrade (kernel/locking/lockdep.c:5634)
 ? pwq_dec_nr_in_flight (kernel/workqueue.c:2184)
 ? rwlock_bug.part.0 (kernel/locking/spinlock_debug.c:113)
 worker_thread (./include/linux/list.h:292 kernel/workqueue.c:2437)
 ? __kthread_parkme (./arch/x86/include/asm/bitops.h:207 (discriminator 4) ./include/asm-generic/bitops/instrumented-non-atomic.h:135 (discriminator 4) kernel/kthread.c:270 (discriminator 4))
 ? process_one_work (kernel/workqueue.c:2379)
 kthread (kernel/kthread.c:376)
 ? kthread_complete_and_exit (kernel/kthread.c:331)
 ret_from_fork (arch/x86/entry/entry_64.S:306)
 </TASK>

Allocated by task 43169:
 kasan_save_stack (mm/kasan/common.c:39)
 __kasan_slab_alloc (mm/kasan/common.c:45 mm/kasan/common.c:436 mm/kasan/common.c:469)
 kmem_cache_alloc_node (mm/slab.h:750 mm/slub.c:3243 mm/slub.c:3293)
 __alloc_skb (net/core/skbuff.c:414)
 l2cap_recv_frag (./include/net/bluetooth/bluetooth.h:425 net/bluetooth/l2cap_core.c:8329) bluetooth
 l2cap_recv_acldata (net/bluetooth/l2cap_core.c:8442) bluetooth
 hci_rx_work (net/bluetooth/hci_core.c:3642 net/bluetooth/hci_core.c:3832) bluetooth
 process_one_work (kernel/workqueue.c:2289)
 worker_thread (./include/linux/list.h:292 kernel/workqueue.c:2437)
 kthread (kernel/kthread.c:376)
 ret_from_fork (arch/x86/entry/entry_64.S:306)

Freed by task 27920:
 kasan_save_stack (mm/kasan/common.c:39)
 kasan_set_track (mm/kasan/common.c:45)
 kasan_set_free_info (mm/kasan/generic.c:372)
 ____kasan_slab_free (mm/kasan/common.c:368 mm/kasan/common.c:328)
 slab_free_freelist_hook (mm/slub.c:1780)
 kmem_cache_free (mm/slub.c:3536 mm/slub.c:3553)
 skb_free_datagram (./include/net/sock.h:1578 ./include/net/sock.h:1639 net/core/datagram.c:323)
 bt_sock_recvmsg (net/bluetooth/af_bluetooth.c:295) bluetooth
 l2cap_sock_recvmsg (net/bluetooth/l2cap_sock.c:1212) bluetooth
 sock_read_iter (net/socket.c:1087)
 new_sync_read (./include/linux/fs.h:2052 fs/read_write.c:401)
 vfs_read (fs/read_write.c:482)
 ksys_read (fs/read_write.c:620)
 do_syscall_64 (arch/x86/entry/common.c:50 arch/x86/entry/common.c:80)
 entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:120)

Link: https://lore.kernel.org/linux-bluetooth/CAKErNvoqga1WcmoR3-0875esY6TVWFQDandbVZncSiuGPBQXLA@mail.gmail.com/T/#u
Fixes: d2a7ac5d5d3a ("Bluetooth: Add the ERTM receive state machine")
Fixes: 4b51dae96731 ("Bluetooth: Add streaming mode receive and incoming packet classifier")
Signed-off-by: Maxim Mikityanskiy <maxtram95@gmail.com>
---
 net/bluetooth/l2cap_core.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index 2c9de67daadc..ea0929458f45 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -6886,6 +6886,8 @@ static int l2cap_rx_state_recv(struct l2cap_chan *chan,
 	case L2CAP_EV_RECV_IFRAME:
 		switch (l2cap_classify_txseq(chan, control->txseq)) {
 		case L2CAP_TXSEQ_EXPECTED:
+			struct l2cap_ctrl local_control;
+
 			l2cap_pass_to_tx(chan, control);
 
 			if (test_bit(CONN_LOCAL_BUSY, &chan->conn_state)) {
@@ -6900,15 +6902,16 @@ static int l2cap_rx_state_recv(struct l2cap_chan *chan,
 			chan->buffer_seq = chan->expected_tx_seq;
 			skb_in_use = true;
 
+			local_control = *control;
 			err = l2cap_reassemble_sdu(chan, skb, control);
 			if (err)
 				break;
 
-			if (control->final) {
+			if (local_control.final) {
 				if (!test_and_clear_bit(CONN_REJ_ACT,
 							&chan->conn_state)) {
-					control->final = 0;
-					l2cap_retransmit_all(chan, control);
+					local_control.final = 0;
+					l2cap_retransmit_all(chan, &local_control);
 					l2cap_ertm_send(chan);
 				}
 			}
@@ -7288,11 +7291,12 @@ static int l2cap_rx(struct l2cap_chan *chan, struct l2cap_ctrl *control,
 static int l2cap_stream_rx(struct l2cap_chan *chan, struct l2cap_ctrl *control,
 			   struct sk_buff *skb)
 {
+	u16 txseq = control->txseq;
+
 	BT_DBG("chan %p, control %p, skb %p, state %d", chan, control, skb,
 	       chan->rx_state);
 
-	if (l2cap_classify_txseq(chan, control->txseq) ==
-	    L2CAP_TXSEQ_EXPECTED) {
+	if (l2cap_classify_txseq(chan, txseq) == L2CAP_TXSEQ_EXPECTED) {
 		l2cap_pass_to_tx(chan, control);
 
 		BT_DBG("buffer_seq %u->%u", chan->buffer_seq,
@@ -7315,8 +7319,8 @@ static int l2cap_stream_rx(struct l2cap_chan *chan, struct l2cap_ctrl *control,
 		}
 	}
 
-	chan->last_acked_seq = control->txseq;
-	chan->expected_tx_seq = __next_seq(chan, control->txseq);
+	chan->last_acked_seq = txseq;
+	chan->expected_tx_seq = __next_seq(chan, txseq);
 
 	return 0;
 }
-- 
2.37.3

