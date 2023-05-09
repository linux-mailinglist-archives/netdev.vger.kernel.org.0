Return-Path: <netdev+bounces-1219-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B1FF66FCBE1
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 18:56:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 756BC281361
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 16:56:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4ECCAF9EB;
	Tue,  9 May 2023 16:56:52 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 406F9F9EA
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 16:56:52 +0000 (UTC)
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28D7F30C3
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 09:56:38 -0700 (PDT)
Received: by mail-qk1-x74a.google.com with SMTP id af79cd13be357-751409cba6dso372559785a.3
        for <netdev@vger.kernel.org>; Tue, 09 May 2023 09:56:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683651397; x=1686243397;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=3+F30DicOrdyBo3GVrpAFrGM0uZFF7P4Kv7l+OswML4=;
        b=N76h/q/mV0B0wbFZvysyEt7kG3QRRuF1o1MSAFlfX5qES+f4lYwRtmjppx2fipnEAx
         nUuZQc/qjWZHUNwNII3qeFKQRljvXB9CPMR/4f8dRvRVm/EQfbh2ws1Wom8L1YDVdowy
         lFECunNwB2EPD3U+LbwhlIQn4a/L+CSYLrkGSIJ1/Du4Cr7OqtKCfzcp3p+6bKLWtmOn
         nqohYrcTz/LUX6EnDDM9piAbvFiEV5oh0s+Vhi2LVvSHA3fnh8G3vGrxp0yuv1VGeNGU
         N9q+CfLHLK6Spawwxgw9xkCCemZZc5CB8GPFH0rdY4nWDJOWPFDQQgHkaNvXlnCSmtAL
         LyiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683651397; x=1686243397;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3+F30DicOrdyBo3GVrpAFrGM0uZFF7P4Kv7l+OswML4=;
        b=I+VeA9ItP++9ASem77ylBhAX5zgXVTDKVScjJl3p+68TEGZmW+uf24BxA0STCyFf/c
         9R6uEJ4w2lHX5qU1B991VFODVIgcC/OiSG93rKJcflDIaxquO30vd7AQWDSjMMxTtheb
         tA3pDxf1zUB6Fd2TcD5JdTy9lOf1hHwNxwyVlu7oX6Zfl00u68hTeKOzb/ykTOubMc6Z
         o9yTGCLkajvdayvYYJMhWNqZIApuWDkJ/Rv+I0nvmy8D6mT2E2aTqtfg7c4BGwGfgj4z
         Ibp3mpfcRFqFbMcgaS7ODseQmCbjdnxaIhoqSgc8MEitHod6ljd/LlM9l6lmHbCadONh
         c5hg==
X-Gm-Message-State: AC+VfDwAqvOi2AJ2Oicul8BAXetngDZC5mo23HM9VPdSYiOWe4Y2T70q
	/L/D7p9aJPn7w/wQCy8tr2ldPmW/6Oc+Qw==
X-Google-Smtp-Source: ACHHUZ5Y01Qq5cAV1DcOx+IJx8Sujs5qFoQLsb7IqxCfcJzy4/rYO9JGZN26K3bRoNz6OhG8iSNt2Lh7mQcs0w==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a05:620a:2985:b0:74d:fdca:a6c6 with SMTP
 id r5-20020a05620a298500b0074dfdcaa6c6mr4565938qkp.14.1683651397256; Tue, 09
 May 2023 09:56:37 -0700 (PDT)
Date: Tue,  9 May 2023 16:56:34 +0000
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.40.1.521.gf1e218fcd8-goog
Message-ID: <20230509165634.3154266-1-edumazet@google.com>
Subject: [PATCH net] netlink: annotate accesses to nlk->cb_running
From: Eric Dumazet <edumazet@google.com>
To: "David S . Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>
Cc: netdev@vger.kernel.org, eric.dumazet@gmail.com, 
	Eric Dumazet <edumazet@google.com>, syzbot <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Both netlink_recvmsg() and netlink_native_seq_show() read
nlk->cb_running locklessly. Use READ_ONCE() there.

Add corresponding WRITE_ONCE() to netlink_dump() and
__netlink_dump_start()

syzbot reported:
BUG: KCSAN: data-race in __netlink_dump_start / netlink_recvmsg

write to 0xffff88813ea4db59 of 1 bytes by task 28219 on cpu 0:
__netlink_dump_start+0x3af/0x4d0 net/netlink/af_netlink.c:2399
netlink_dump_start include/linux/netlink.h:308 [inline]
rtnetlink_rcv_msg+0x70f/0x8c0 net/core/rtnetlink.c:6130
netlink_rcv_skb+0x126/0x220 net/netlink/af_netlink.c:2577
rtnetlink_rcv+0x1c/0x20 net/core/rtnetlink.c:6192
netlink_unicast_kernel net/netlink/af_netlink.c:1339 [inline]
netlink_unicast+0x56f/0x640 net/netlink/af_netlink.c:1365
netlink_sendmsg+0x665/0x770 net/netlink/af_netlink.c:1942
sock_sendmsg_nosec net/socket.c:724 [inline]
sock_sendmsg net/socket.c:747 [inline]
sock_write_iter+0x1aa/0x230 net/socket.c:1138
call_write_iter include/linux/fs.h:1851 [inline]
new_sync_write fs/read_write.c:491 [inline]
vfs_write+0x463/0x760 fs/read_write.c:584
ksys_write+0xeb/0x1a0 fs/read_write.c:637
__do_sys_write fs/read_write.c:649 [inline]
__se_sys_write fs/read_write.c:646 [inline]
__x64_sys_write+0x42/0x50 fs/read_write.c:646
do_syscall_x64 arch/x86/entry/common.c:50 [inline]
do_syscall_64+0x41/0xc0 arch/x86/entry/common.c:80
entry_SYSCALL_64_after_hwframe+0x63/0xcd

read to 0xffff88813ea4db59 of 1 bytes by task 28222 on cpu 1:
netlink_recvmsg+0x3b4/0x730 net/netlink/af_netlink.c:2022
sock_recvmsg_nosec+0x4c/0x80 net/socket.c:1017
____sys_recvmsg+0x2db/0x310 net/socket.c:2718
___sys_recvmsg net/socket.c:2762 [inline]
do_recvmmsg+0x2e5/0x710 net/socket.c:2856
__sys_recvmmsg net/socket.c:2935 [inline]
__do_sys_recvmmsg net/socket.c:2958 [inline]
__se_sys_recvmmsg net/socket.c:2951 [inline]
__x64_sys_recvmmsg+0xe2/0x160 net/socket.c:2951
do_syscall_x64 arch/x86/entry/common.c:50 [inline]
do_syscall_64+0x41/0xc0 arch/x86/entry/common.c:80
entry_SYSCALL_64_after_hwframe+0x63/0xcd

value changed: 0x00 -> 0x01

Fixes: 16b304f3404f ("netlink: Eliminate kmalloc in netlink dump operation.")
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/netlink/af_netlink.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index 7ef8b9a1e30c5a87687899dfcfc014fc033bf572..c87804112d0c6e8010ef1257eb68da3cd48a3969 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -1990,7 +1990,7 @@ static int netlink_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
 
 	skb_free_datagram(sk, skb);
 
-	if (nlk->cb_running &&
+	if (READ_ONCE(nlk->cb_running) &&
 	    atomic_read(&sk->sk_rmem_alloc) <= sk->sk_rcvbuf / 2) {
 		ret = netlink_dump(sk);
 		if (ret) {
@@ -2302,7 +2302,7 @@ static int netlink_dump(struct sock *sk)
 	if (cb->done)
 		cb->done(cb);
 
-	nlk->cb_running = false;
+	WRITE_ONCE(nlk->cb_running, false);
 	module = cb->module;
 	skb = cb->skb;
 	mutex_unlock(nlk->cb_mutex);
@@ -2365,7 +2365,7 @@ int __netlink_dump_start(struct sock *ssk, struct sk_buff *skb,
 			goto error_put;
 	}
 
-	nlk->cb_running = true;
+	WRITE_ONCE(nlk->cb_running, true);
 	nlk->dump_done_errno = INT_MAX;
 
 	mutex_unlock(nlk->cb_mutex);
@@ -2703,7 +2703,7 @@ static int netlink_native_seq_show(struct seq_file *seq, void *v)
 			   nlk->groups ? (u32)nlk->groups[0] : 0,
 			   sk_rmem_alloc_get(s),
 			   sk_wmem_alloc_get(s),
-			   nlk->cb_running,
+			   READ_ONCE(nlk->cb_running),
 			   refcount_read(&s->sk_refcnt),
 			   atomic_read(&s->sk_drops),
 			   sock_i_ino(s)
-- 
2.40.1.521.gf1e218fcd8-goog


