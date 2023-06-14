Return-Path: <netdev+bounces-10570-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B49372F233
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 03:53:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3245C2812E1
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 01:53:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 68246384;
	Wed, 14 Jun 2023 01:53:03 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58E3F7F
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 01:53:02 +0000 (UTC)
Received: from zg8tndyumtaxlji0oc4xnzya.icoremail.net (zg8tndyumtaxlji0oc4xnzya.icoremail.net [46.101.248.176])
	by lindbergh.monkeyblade.net (Postfix) with ESMTP id 27B9E106;
	Tue, 13 Jun 2023 18:52:58 -0700 (PDT)
Received: from localhost.localdomain (unknown [125.119.249.156])
	by mail-app2 (Coremail) with SMTP id by_KCgCH3hh3HYlkw7S7Bg--.47750S4;
	Wed, 14 Jun 2023 09:52:56 +0800 (CST)
From: Lin Ma <linma@zju.edu.cn>
To: kuba@kernel.org
Cc: netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Lin Ma <linma@zju.edu.cn>
Subject: [PATCH v1] net/handshake: remove fput() that causes use-after-free
Date: Wed, 14 Jun 2023 09:52:49 +0800
Message-Id: <20230614015249.987448-1-linma@zju.edu.cn>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID:by_KCgCH3hh3HYlkw7S7Bg--.47750S4
X-Coremail-Antispam: 1UD129KBjvJXoW3Xw4kZry7tF47GFykJr4Dtwb_yoW7WFyfpF
	WYvFn8CrWrtr9YqFn7J3WkXr109F43Z3WUWryxZryrtFsxWw1kAr1UGa48WrW5Jws7ursr
	tFnxXFyFyr1UXaDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUyv14x267AKxVWUJVW8JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4U
	JVW0owA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
	I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
	4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCF04k20xvY0x0EwIxG
	rwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4
	vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1lIxkGc2Ij64vIr41lIxAIcVC0I7IY
	x2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k26c
	xKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAF
	wI0_Jr0_GrUvcSsGvfC2KfnxnUUI43ZEXa7VUbrMaUUUUUU==
X-CM-SenderInfo: qtrwiiyqvtljo62m3hxhgxhubq/
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_MSPIKE_H2,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>

A reference underflow is found in TLS handshake subsystem that causes a
direct use-after-free. Part of the crash log is like below:

[    2.022114] ------------[ cut here ]------------
[    2.022193] refcount_t: underflow; use-after-free.
[    2.022288] WARNING: CPU: 0 PID: 60 at lib/refcount.c:28 refcount_warn_saturate+0xbe/0x110
[    2.022432] Modules linked in:
[    2.022848] RIP: 0010:refcount_warn_saturate+0xbe/0x110
[    2.023231] RSP: 0018:ffffc900001bfe18 EFLAGS: 00000286
[    2.023325] RAX: 0000000000000000 RBX: 0000000000000007 RCX: 00000000ffffdfff
[    2.023438] RDX: 0000000000000000 RSI: 00000000ffffffea RDI: 0000000000000001
[    2.023555] RBP: ffff888004c20098 R08: ffffffff82b392c8 R09: 00000000ffffdfff
[    2.023693] R10: ffffffff82a592e0 R11: ffffffff82b092e0 R12: ffff888004c200d8
[    2.023813] R13: 0000000000000000 R14: ffff888004c20000 R15: ffffc90000013ca8
[    2.023930] FS:  0000000000000000(0000) GS:ffff88807dc00000(0000) knlGS:0000000000000000
[    2.024062] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    2.024161] CR2: ffff888003601000 CR3: 0000000002a2e000 CR4: 00000000000006f0
[    2.024275] Call Trace:
[    2.024322]  <TASK>
[    2.024367]  ? __warn+0x7f/0x130
[    2.024430]  ? refcount_warn_saturate+0xbe/0x110
[    2.024513]  ? report_bug+0x199/0x1b0
[    2.024585]  ? handle_bug+0x3c/0x70
[    2.024676]  ? exc_invalid_op+0x18/0x70
[    2.024750]  ? asm_exc_invalid_op+0x1a/0x20
[    2.024830]  ? refcount_warn_saturate+0xbe/0x110
[    2.024916]  ? refcount_warn_saturate+0xbe/0x110
[    2.024998]  __tcp_close+0x2f4/0x3d0
[    2.025065]  ? __pfx_kunit_generic_run_threadfn_adapter+0x10/0x10
[    2.025168]  tcp_close+0x1f/0x70
[    2.025231]  inet_release+0x33/0x60
[    2.025297]  sock_release+0x1f/0x80
[    2.025361]  handshake_req_cancel_test2+0x100/0x2d0
[    2.025457]  kunit_try_run_case+0x4c/0xa0
[    2.025532]  kunit_generic_run_threadfn_adapter+0x15/0x20
[    2.025644]  kthread+0xe1/0x110
[    2.025708]  ? __pfx_kthread+0x10/0x10
[    2.025780]  ret_from_fork+0x2c/0x50

One can enable CONFIG_NET_HANDSHAKE_KUNIT_TEST config to reproduce above
crash.

The root cause of this bug is that the commit 1ce77c998f04
("net/handshake: Unpin sock->file if a handshake is cancelled") adds one
additional fput() function. That patch claims that the fput() is used to
enable sock->file to be freed even when user space never calls DONE.

However, it seems that the intended DONE routine will never give an
additional fput() of ths sock->file. The existing two of them are just
used to balance the reference added in sockfd_lookup().

This patch revert the mentioned commit to avoid the use-after-free. The
patched kernel could successfully pass the KUNIT test and boot to shell.

[    0.733613]     # Subtest: Handshake API tests
[    0.734029]     1..11
[    0.734255]         KTAP version 1
[    0.734542]         # Subtest: req_alloc API fuzzing
[    0.736104]         ok 1 handshake_req_alloc NULL proto
[    0.736114]         ok 2 handshake_req_alloc CLASS_NONE
[    0.736559]         ok 3 handshake_req_alloc CLASS_MAX
[    0.737020]         ok 4 handshake_req_alloc no callbacks
[    0.737488]         ok 5 handshake_req_alloc no done callback
[    0.737988]         ok 6 handshake_req_alloc excessive privsize
[    0.738529]         ok 7 handshake_req_alloc all good
[    0.739036]     # req_alloc API fuzzing: pass:7 fail:0 skip:0 total:7
[    0.739444]     ok 1 req_alloc API fuzzing
[    0.740065]     ok 2 req_submit NULL req arg
[    0.740436]     ok 3 req_submit NULL sock arg
[    0.740834]     ok 4 req_submit NULL sock->file
[    0.741236]     ok 5 req_lookup works
[    0.741621]     ok 6 req_submit max pending
[    0.741974]     ok 7 req_submit multiple
[    0.742382]     ok 8 req_cancel before accept
[    0.742764]     ok 9 req_cancel after accept
[    0.743151]     ok 10 req_cancel after done
[    0.743510]     ok 11 req_destroy works
[    0.743882] # Handshake API tests: pass:11 fail:0 skip:0 total:11
[    0.744205] # Totals: pass:17 fail:0 skip:0 total:17


Fixes: 1ce77c998f04 ("net/handshake: Unpin sock->file if a handshake is cancelled")
Signed-off-by: Lin Ma <linma@zju.edu.cn>
---
 net/handshake/handshake.h | 1 -
 net/handshake/request.c   | 4 ----
 2 files changed, 5 deletions(-)

diff --git a/net/handshake/handshake.h b/net/handshake/handshake.h
index 8aeaadca844f..4dac965c99df 100644
--- a/net/handshake/handshake.h
+++ b/net/handshake/handshake.h
@@ -31,7 +31,6 @@ struct handshake_req {
 	struct list_head		hr_list;
 	struct rhash_head		hr_rhash;
 	unsigned long			hr_flags;
-	struct file			*hr_file;
 	const struct handshake_proto	*hr_proto;
 	struct sock			*hr_sk;
 	void				(*hr_odestruct)(struct sock *sk);
diff --git a/net/handshake/request.c b/net/handshake/request.c
index d78d41abb3d9..94d5cef3e048 100644
--- a/net/handshake/request.c
+++ b/net/handshake/request.c
@@ -239,7 +239,6 @@ int handshake_req_submit(struct socket *sock, struct handshake_req *req,
 	}
 	req->hr_odestruct = req->hr_sk->sk_destruct;
 	req->hr_sk->sk_destruct = handshake_sk_destruct;
-	req->hr_file = sock->file;
 
 	ret = -EOPNOTSUPP;
 	net = sock_net(req->hr_sk);
@@ -335,9 +334,6 @@ bool handshake_req_cancel(struct sock *sk)
 		return false;
 	}
 
-	/* Request accepted and waiting for DONE */
-	fput(req->hr_file);
-
 out_true:
 	trace_handshake_cancel(net, req, sk);
 
-- 
2.34.1


