Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A42A6D1186
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 23:55:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230246AbjC3Vz0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 17:55:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229518AbjC3VzZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 17:55:25 -0400
Received: from smtp-fw-80007.amazon.com (smtp-fw-80007.amazon.com [99.78.197.218])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 520BBF772;
        Thu, 30 Mar 2023 14:55:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1680213324; x=1711749324;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=OjeCvB9tNeU8DjEsNgAC0pFUIzbXpFWwjPaeRcBgyjQ=;
  b=piqIu2cf8ZWoqBKkXqzDK/pIcd9ktDJIaMz/22AKX73N6JjGsc3e+jYE
   jS10Jtp+Sn3siCHmH9JiPtHhZ4pbSQ3p6J6hVrdD/slds1025h8nVuMDG
   fJDEIelDjEcP5azqx9tvVg5apRE0C2uqwSKYNxdIlRHuAKfyGbOU7UaOw
   Q=;
X-IronPort-AV: E=Sophos;i="5.98,306,1673913600"; 
   d="scan'208";a="199450011"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-pdx-2b-m6i4x-189d700f.us-west-2.amazon.com) ([10.25.36.214])
  by smtp-border-fw-80007.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2023 21:55:21 +0000
Received: from EX19MTAUWB002.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-pdx-2b-m6i4x-189d700f.us-west-2.amazon.com (Postfix) with ESMTPS id 52F6840D79;
        Thu, 30 Mar 2023 21:55:19 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX19MTAUWB002.ant.amazon.com (10.250.64.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.25; Thu, 30 Mar 2023 21:55:19 +0000
Received: from 88665a182662.ant.amazon.com.com (10.106.100.11) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Thu, 30 Mar 2023 21:55:16 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     <threeearcat@gmail.com>
CC:     <davem@davemloft.net>, <dsahern@kernel.org>, <edumazet@google.com>,
        <kuba@kernel.org>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <pabeni@redhat.com>, <kuniyu@amazon.com>
Subject: Re: general protection fault in raw_seq_start
Date:   Thu, 30 Mar 2023 14:55:07 -0700
Message-ID: <20230330215507.56509-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <ZCA2mGV_cmq7lIfV@dragonet>
References: <ZCA2mGV_cmq7lIfV@dragonet>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.106.100.11]
X-ClientProxiedBy: EX19D040UWB004.ant.amazon.com (10.13.138.91) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-2.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   "Dae R. Jeong" <threeearcat@gmail.com>
Date:   Sun, 26 Mar 2023 21:12:08 +0900
> Hi,
> 
> We observed an issue "general protection fault in raw_seq_start"
> during fuzzing.
> 
> Unfortunately, we have not found a reproducer for the crash yet. We
> will inform you if we have any update on this crash.
> Detailed crash information is attached below.
> 
> Best regards,
> Dae R. Jeong
> 
> -----
> 
> - Kernel version
>   6.2
> 
> - Last executed input
>   unshare(0x40060200)
>   r0 = syz_open_procfs(0x0, &(0x7f0000002080)='net/raw\x00')
>   socket$inet_icmp_raw(0x2, 0x3, 0x1)
>   ppoll(0x0, 0x0, 0x0, 0x0, 0x0)
>   socket$inet_icmp_raw(0x2, 0x3, 0x1)
>   pread64(r0, &(0x7f0000000000)=""/10, 0xa, 0x10000000007f)

Thanks for reporting the issue.

It seems we need to use RCU variant in raw_get_first().
I'll post a patch.

---
diff --git a/net/ipv4/raw.c b/net/ipv4/raw.c
index 3cf68695b40d..fe0d1ad20b35 100644
--- a/net/ipv4/raw.c
+++ b/net/ipv4/raw.c
@@ -957,7 +957,7 @@ static struct sock *raw_get_first(struct seq_file *seq, int bucket)
 	for (state->bucket = bucket; state->bucket < RAW_HTABLE_SIZE;
 			++state->bucket) {
 		hlist = &h->ht[state->bucket];
-		sk_nulls_for_each(sk, hnode, hlist) {
+		sk_nulls_for_each_rcu(sk, hnode, hlist) {
 			if (sock_net(sk) == seq_file_net(seq))
 				return sk;
 		}
---

Thanks,
Kuniyuki



> 
> - Crash report
> general protection fault, probably for non-canonical address 0xdffffc0000000005: 0000 [#1] PREEMPT SMP KASAN
> KASAN: null-ptr-deref in range [0x0000000000000028-0x000000000000002f]
> CPU: 2 PID: 20952 Comm: syz-executor.0 Not tainted 6.2.0-g048ec869bafd-dirty #7
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.14.0-0-g155821a1990b-prebuilt.qemu.org 04/01/2014
> RIP: 0010:read_pnet include/net/net_namespace.h:383 [inline]
> RIP: 0010:sock_net include/net/sock.h:649 [inline]
> RIP: 0010:raw_get_next net/ipv4/raw.c:974 [inline]
> RIP: 0010:raw_get_idx net/ipv4/raw.c:986 [inline]
> RIP: 0010:raw_seq_start+0x431/0x800 net/ipv4/raw.c:995
> Code: ef e8 33 3d 94 f7 49 8b 6d 00 4c 89 ef e8 b7 65 5f f7 49 89 ed 49 83 c5 98 0f 84 9a 00 00 00 48 83 c5 c8 48 89 e8 48 c1 e8 03 <42> 80 3c 30 00 74 08 48 89 ef e8 00 3d 94 f7 4c 8b 7d 00 48 89 ef
> RSP: 0018:ffffc9001154f9b0 EFLAGS: 00010206
> RAX: 0000000000000005 RBX: 1ffff1100302c8fd RCX: 0000000000000000
> RDX: 0000000000000028 RSI: ffffc9001154f988 RDI: ffffc9000f77a338
> RBP: 0000000000000029 R08: ffffffff8a50ffb4 R09: fffffbfff24b6bd9
> R10: fffffbfff24b6bd9 R11: 0000000000000000 R12: ffff88801db73b78
> R13: fffffffffffffff9 R14: dffffc0000000000 R15: 0000000000000030
> FS:  00007f843ae8e700(0000) GS:ffff888063700000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 000055bb9614b35f CR3: 000000003c672000 CR4: 00000000003506e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  <TASK>
>  seq_read_iter+0x4c6/0x10f0 fs/seq_file.c:225
>  seq_read+0x224/0x320 fs/seq_file.c:162
>  pde_read fs/proc/inode.c:316 [inline]
>  proc_reg_read+0x23f/0x330 fs/proc/inode.c:328
>  vfs_read+0x31e/0xd30 fs/read_write.c:468
>  ksys_pread64 fs/read_write.c:665 [inline]
>  __do_sys_pread64 fs/read_write.c:675 [inline]
>  __se_sys_pread64 fs/read_write.c:672 [inline]
>  __x64_sys_pread64+0x1e9/0x280 fs/read_write.c:672
>  do_syscall_x64 arch/x86/entry/common.c:51 [inline]
>  do_syscall_64+0x4e/0xa0 arch/x86/entry/common.c:82
>  entry_SYSCALL_64_after_hwframe+0x63/0xcd
> RIP: 0033:0x478d29
> Code: f7 d8 64 89 02 b8 ff ff ff ff c3 66 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007f843ae8dbe8 EFLAGS: 00000246 ORIG_RAX: 0000000000000011
> RAX: ffffffffffffffda RBX: 0000000000791408 RCX: 0000000000478d29
> RDX: 000000000000000a RSI: 0000000020000000 RDI: 0000000000000003
> RBP: 00000000f477909a R08: 0000000000000000 R09: 0000000000000000
> R10: 000010000000007f R11: 0000000000000246 R12: 0000000000791740
> R13: 0000000000791414 R14: 0000000000791408 R15: 00007ffc2eb48a50
>  </TASK>
> Modules linked in:
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:read_pnet include/net/net_namespace.h:383 [inline]
> RIP: 0010:sock_net include/net/sock.h:649 [inline]
> RIP: 0010:raw_get_next net/ipv4/raw.c:974 [inline]
> RIP: 0010:raw_get_idx net/ipv4/raw.c:986 [inline]
> RIP: 0010:raw_seq_start+0x431/0x800 net/ipv4/raw.c:995
> Code: ef e8 33 3d 94 f7 49 8b 6d 00 4c 89 ef e8 b7 65 5f f7 49 89 ed 49 83 c5 98 0f 84 9a 00 00 00 48 83 c5 c8 48 89 e8 48 c1 e8 03 <42> 80 3c 30 00 74 08 48 89 ef e8 00 3d 94 f7 4c 8b 7d 00 48 89 ef
> RSP: 0018:ffffc9001154f9b0 EFLAGS: 00010206
> RAX: 0000000000000005 RBX: 1ffff1100302c8fd RCX: 0000000000000000
> RDX: 0000000000000028 RSI: ffffc9001154f988 RDI: ffffc9000f77a338
> RBP: 0000000000000029 R08: ffffffff8a50ffb4 R09: fffffbfff24b6bd9
> R10: fffffbfff24b6bd9 R11: 0000000000000000 R12: ffff88801db73b78
> R13: fffffffffffffff9 R14: dffffc0000000000 R15: 0000000000000030
> FS:  00007f843ae8e700(0000) GS:ffff888063700000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f92ff166000 CR3: 000000003c672000 CR4: 00000000003506e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
