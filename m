Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 251B24849C2
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 22:16:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233936AbiADVQj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 16:16:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233916AbiADVQi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 16:16:38 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7C06C061761;
        Tue,  4 Jan 2022 13:16:38 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id r16-20020a17090a0ad000b001b276aa3aabso1030576pje.0;
        Tue, 04 Jan 2022 13:16:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:message-id:in-reply-to:references:subject:mime-version
         :content-transfer-encoding;
        bh=npTjTety+46FhNBHpTDwPtrds+SXleaCAqvAkUVFly0=;
        b=RVsVVH1gcmIm5rKq5FAVE3wqzcYe/VIX6RPLRjzE+RmLTgwtSsHiTbdWRNSVK/+feO
         tceMJzCWfsVjmQaJBmNvNCcPf7P7bHR2x/5ZhYg2BBlgePtQA0kkGzWCFRdo/YyPP4bu
         06AbwtwJrcag8JY1DeyOStXtdVGVuOYdRue2oXB7dmYNQZUdflkr6+Xr3ppGUxXmP7Zb
         YlVdF7R+9OamsKa6xIxirJA619q0pZxVCzWs9UDvpRfY3+USxnXshU1oXflKXeuzpZj9
         +pUmB0qZJonpQKczXNHpi/xJ+FmlbO7b2RfuTzYOuJsZMTU3zSXBEtJkKWmY/Q0qqG4J
         JTkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:message-id:in-reply-to:references
         :subject:mime-version:content-transfer-encoding;
        bh=npTjTety+46FhNBHpTDwPtrds+SXleaCAqvAkUVFly0=;
        b=asT+rlm1o8ha+Lk6V1r7S47wkBpo7lAuDnyuYj6Df9eeJueK1/eHE870R2PQR151SI
         ijp952RtSudxJ6OfMZxc9Wb3F2hZXp/JAkO+DV+XN4VzvWK+NwuFJ/Ze3Oc7ORthaS6B
         4B1zj1cwhu/heUIxgJdhaEk+arBpP+4luxyZ5Utsw6FkUAY/dEOLQ/yZAccbjBvL6wp1
         BhGizgzvD4viBtHkqtAii9D1Vtafqw2GKvvqrxHzZVUQqLX6OOulMNr0AztAMSy1goon
         qtOO9+wzpXeXaNeH3OrXTFaVes77X+RO9PWz3ZjHZv5nhgfS5xjd8v/fmSxOnQ2DlhrT
         gFfg==
X-Gm-Message-State: AOAM530I9tq8hZ4DyEnoBCoHbTtLHiSMqIhSQ2+N3u6FBTtXwkoWthGA
        6EJXvEPySMMP397NdEqFMyY=
X-Google-Smtp-Source: ABdhPJyCh5fpuOjGgRimb654UjU3D0A2cz2oRwvewRN52GCZLWcu4nmzxVM7aPKKsAqR1LfEsox23Q==
X-Received: by 2002:a17:90b:17c1:: with SMTP id me1mr278650pjb.131.1641330998376;
        Tue, 04 Jan 2022 13:16:38 -0800 (PST)
Received: from localhost ([71.236.223.183])
        by smtp.gmail.com with ESMTPSA id x11sm225108pjq.52.2022.01.04.13.16.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Jan 2022 13:16:38 -0800 (PST)
Date:   Tue, 04 Jan 2022 13:16:37 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     syzbot <syzbot+bb73e71cf4b8fd376a4f@syzkaller.appspotmail.com>,
        andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, davem@davemloft.net, hawk@kernel.org,
        jakub@cloudflare.com, john.fastabend@gmail.com, kafai@fb.com,
        kpsingh@kernel.org, kuba@kernel.org, linux-kernel@vger.kernel.org,
        lmb@cloudflare.com, netdev@vger.kernel.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, yhs@fb.com
Message-ID: <61d4b9354cf9b_4679220874@john.notmuch>
In-Reply-To: <00000000000006fee605d38f0418@google.com>
References: <00000000000006fee605d38f0418@google.com>
Subject: RE: [syzbot] KASAN: vmalloc-out-of-bounds Read in bpf_prog_put
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    9eaa88c7036e Merge tag 'libata-5.16-rc6' of git://git.kern..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=10ed4143b00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=10f3f669b8093e95
> dashboard link: https://syzkaller.appspot.com/bug?extid=bb73e71cf4b8fd376a4f
> compiler:       Debian clang version 11.0.1-2, GNU ld (GNU Binutils for Debian) 2.35.2
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=112d6ca5b00000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=17393549b00000
> 
> The issue was bisected to:
> 
> commit 38207a5e81230d6ffbdd51e5fa5681be5116dcae
> Author: John Fastabend <john.fastabend@gmail.com>
> Date:   Fri Nov 19 18:14:17 2021 +0000
> 
>     bpf, sockmap: Attach map progs to psock early for feature probes
> 
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=13532e85b00000
> final oops:     https://syzkaller.appspot.com/x/report.txt?x=10d32e85b00000
> console output: https://syzkaller.appspot.com/x/log.txt?x=17532e85b00000
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+bb73e71cf4b8fd376a4f@syzkaller.appspotmail.com
> Fixes: 38207a5e8123 ("bpf, sockmap: Attach map progs to psock early for feature probes")
> 
> ==================================================================
> BUG: KASAN: vmalloc-out-of-bounds in __bpf_prog_put kernel/bpf/syscall.c:1812 [inline]
> BUG: KASAN: vmalloc-out-of-bounds in __bpf_prog_put kernel/bpf/syscall.c:1812 [inline] kernel/bpf/syscall.c:1829
> BUG: KASAN: vmalloc-out-of-bounds in bpf_prog_put+0x8c/0x4f0 kernel/bpf/syscall.c:1829 kernel/bpf/syscall.c:1829
> Read of size 8 at addr ffffc90000e76038 by task syz-executor020/3641
> 
> CPU: 1 PID: 3641 Comm: syz-executor020 Not tainted 5.16.0-rc5-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> Call Trace:
>  <TASK>
>  __dump_stack lib/dump_stack.c:88 [inline]
>  __dump_stack lib/dump_stack.c:88 [inline] lib/dump_stack.c:106
>  dump_stack_lvl+0x1dc/0x2d8 lib/dump_stack.c:106 lib/dump_stack.c:106
>  print_address_description+0x65/0x380 mm/kasan/report.c:247 mm/kasan/report.c:247
>  __kasan_report mm/kasan/report.c:433 [inline]
>  __kasan_report mm/kasan/report.c:433 [inline] mm/kasan/report.c:450
>  kasan_report+0x19a/0x1f0 mm/kasan/report.c:450 mm/kasan/report.c:450
>  __bpf_prog_put kernel/bpf/syscall.c:1812 [inline]
>  __bpf_prog_put kernel/bpf/syscall.c:1812 [inline] kernel/bpf/syscall.c:1829
>  bpf_prog_put+0x8c/0x4f0 kernel/bpf/syscall.c:1829 kernel/bpf/syscall.c:1829
>  bpf_prog_release+0x37/0x40 kernel/bpf/syscall.c:1837 kernel/bpf/syscall.c:1837
>  __fput+0x3fc/0x870 fs/file_table.c:280 fs/file_table.c:280
>  task_work_run+0x146/0x1c0 kernel/task_work.c:164 kernel/task_work.c:164
>  exit_task_work include/linux/task_work.h:32 [inline]
>  exit_task_work include/linux/task_work.h:32 [inline] kernel/exit.c:832
>  do_exit+0x705/0x24f0 kernel/exit.c:832 kernel/exit.c:832
>  do_group_exit+0x168/0x2d0 kernel/exit.c:929 kernel/exit.c:929
>  __do_sys_exit_group+0x13/0x20 kernel/exit.c:940 kernel/exit.c:940
>  __se_sys_exit_group+0x10/0x10 kernel/exit.c:938 kernel/exit.c:938
>  __x64_sys_exit_group+0x37/0x40 kernel/exit.c:938 kernel/exit.c:938
>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  do_syscall_x64 arch/x86/entry/common.c:50 [inline] arch/x86/entry/common.c:80
>  do_syscall_64+0x44/0xd0 arch/x86/entry/common.c:80 arch/x86/entry/common.c:80
>  entry_SYSCALL_64_after_hwframe+0x44/0xae
> RIP: 0033:0x7f3b90ccd1d9
> Code: Unable to access opcode bytes at RIP 0x7f3b90ccd1af.
> RSP: 002b:00007ffdeec58318 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
> RAX: ffffffffffffffda RBX: 00007f3b90d41330 RCX: 00007f3b90ccd1d9
> RDX: 000000000000003c RSI: 00000000000000e7 RDI: 0000000000000000
> RBP: 0000000000000000 R08: ffffffffffffffc4 R09: 00007ffdeec58390
> R10: 00007ffdeec58390 R11: 0000000000000246 R12: 00007f3b90d41330
> R13: 0000000000000001 R14: 0000000000000000 R15: 0000000000000001
>  </TASK>
> 
> 
> Memory state around the buggy address:
>  ffffc90000e75f00: f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8
>  ffffc90000e75f80: f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8
> >ffffc90000e76000: f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8
>                                         ^
>  ffffc90000e76080: f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8
>  ffffc90000e76100: f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8
> ==================================================================
> 
> 
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
> 
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> For information about bisection process see: https://goo.gl/tpsmEJ#bisection
> syzbot can test patches for this issue, for details see:
> https://goo.gl/tpsmEJ#testing-patches

#syz test: git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git master

From f072b6529a5d41e9af8ed04d9f31108a0baa2eec Mon Sep 17 00:00:00 2001
From: John Fastabend <john.fastabend@gmail.com>
Date: Tue, 4 Jan 2022 11:10:38 -0800
Subject: [PATCH bpf-next] bpf, sockmap: fix double bpf_prog_put on error case
 in map_link

sock_map_link() is called to update a sockmap entry with a sk. But, if the
sock_map_init_proto() call fails then we return an error to the map_update
op against the sockmap. In the error path though we need to cleanup psock
and dec the refcnt on any programs associated with the map, because we
refcnt them early in the update process to ensure they are pinned for the
psock. (This avoids a race where user deletes programs while also updating
the map with new socks.)

In current code we do the prog refcnt dec explicitely by calling
bpf_prog_put() when the program was found in the map. But, after commit
'38207a5e81230' in this error path we've already done the prog to psock
assignment so the programs have a reference from the psock as well. This
then causes the psock tear down logic, invoked by sk_psock_put() in the
error path, to similarly call bpf_prog_put on the programs there.

To be explicit this logic does the prog->psock assignemnt

  if (msg_*)
    psock_set_prog(...)

Then the error path under the out_progs label does a similar check and dec
with,

  if (msg_*)
     bpf_prog_put(...)

And the teardown logic sk_psock_put() does,

  psock_set_prog(msg_*, NULL)

triggering another bpf_prog_put(...). Then KASAN gives us this splat, found
by syzbot because we've created an inbalance between bpf_prog_inc and
bpf_prog_put calling put twice on the program.

BUG: KASAN: vmalloc-out-of-bounds in __bpf_prog_put kernel/bpf/syscall.c:1812 [inline]
BUG: KASAN: vmalloc-out-of-bounds in __bpf_prog_put kernel/bpf/syscall.c:1812 [inline] kernel/bpf/syscall.c:1829
BUG: KASAN: vmalloc-out-of-bounds in bpf_prog_put+0x8c/0x4f0 kernel/bpf/syscall.c:1829 kernel/bpf/syscall.c:1829
Read of size 8 at addr ffffc90000e76038 by task syz-executor020/3641

To fix clean up error path so it doesn't try to do the bpf_prog_put in the
error path once progs are assigned then it relies on the normal psock
tear down logic to do complete cleanup.

For completness we also cover the case whereh sk_psock_init_strp() fails,
but this is not expected because it indicates an incorrect socket type
and should be caught earlier.

Reported-by: syzbot+bb73e71cf4b8fd376a4f@syzkaller.appspotmail.com
Fixes: 38207a5e8123 ("bpf, sockmap: Attach map progs to psock early for feature probes")
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 net/core/sock_map.c | 21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/net/core/sock_map.c b/net/core/sock_map.c
index 9618ab6d7cc9..1827669eedd6 100644
--- a/net/core/sock_map.c
+++ b/net/core/sock_map.c
@@ -292,15 +292,23 @@ static int sock_map_link(struct bpf_map *map, struct sock *sk)
 	if (skb_verdict)
 		psock_set_prog(&psock->progs.skb_verdict, skb_verdict);
 
+	/* msg_* and stream_* programs references tracked in psock after this
+	 * point. Reference dec and cleanup will occur through psock destructor
+	 */
 	ret = sock_map_init_proto(sk, psock);
-	if (ret < 0)
-		goto out_drop;
+	if (ret < 0) {
+		sk_psock_put(sk, psock);
+		goto out;
+	}
 
 	write_lock_bh(&sk->sk_callback_lock);
 	if (stream_parser && stream_verdict && !psock->saved_data_ready) {
 		ret = sk_psock_init_strp(sk, psock);
-		if (ret)
-			goto out_unlock_drop;
+		if (ret) {
+			write_unlock_bh(&sk->sk_callback_lock);
+			sk_psock_put(sk, psock);
+			goto out;
+		}
 		sk_psock_start_strp(sk, psock);
 	} else if (!stream_parser && stream_verdict && !psock->saved_data_ready) {
 		sk_psock_start_verdict(sk,psock);
@@ -309,10 +317,6 @@ static int sock_map_link(struct bpf_map *map, struct sock *sk)
 	}
 	write_unlock_bh(&sk->sk_callback_lock);
 	return 0;
-out_unlock_drop:
-	write_unlock_bh(&sk->sk_callback_lock);
-out_drop:
-	sk_psock_put(sk, psock);
 out_progs:
 	if (skb_verdict)
 		bpf_prog_put(skb_verdict);
@@ -325,6 +329,7 @@ static int sock_map_link(struct bpf_map *map, struct sock *sk)
 out_put_stream_verdict:
 	if (stream_verdict)
 		bpf_prog_put(stream_verdict);
+out:
 	return ret;
 }
 
-- 
2.33.0
