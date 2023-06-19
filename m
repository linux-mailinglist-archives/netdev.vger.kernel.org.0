Return-Path: <netdev+bounces-11842-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 69945734C56
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 09:27:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1B29A280F6E
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 07:27:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 56080524C;
	Mon, 19 Jun 2023 07:27:49 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43A6E3C35
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 07:27:49 +0000 (UTC)
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2196DE7D
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 00:27:43 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-bd69bb4507eso3783983276.2
        for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 00:27:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1687159662; x=1689751662;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=S9UyzP2VJo10c54Mi2KWgqzi733xkgqeMtxThUaIwoA=;
        b=1y+XMFloO6vOAX5y63C4a/HLeiKg5aZD8hL1yN4bMBW7LA0J2Y1iCoG4BxSBLb0yMI
         jHvDW2eUik1I3gmVJOObh+nXI7xoRhaDcj25xq8J6XHXoUYje03I2/I9ZtBDB9l01Jxf
         lFAOWWXmSTEa7InUuVILfkEfxMUSyfWiR8IuBj74YwvyQod9CuZosn1WDSBd0zYI8sRl
         Heqdw9FrliHAKVC6LWhctytsdGQLcajil4rOHI7iUr8l9oqRS4oyz7qozl9iYunzfhNu
         4lUFEfePbj1OoZ6kYomNhLeXb0L66kn4/VgcySML6VrHrEPr61z2KjXMmA5IEaomUJXI
         MoPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687159662; x=1689751662;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=S9UyzP2VJo10c54Mi2KWgqzi733xkgqeMtxThUaIwoA=;
        b=M6T2Qcffbj6RKCU3e5rZIR4VxBAQB3u/Twn1cbe0huLFn5lAPNV0MjjKgRU7eP/0yP
         eTKatq+bTHVHCcxJndj0o/DQE1RhccM5BfMQ91HSmp6pCI7X3ls4x1rS6Cg9SNvVoTPH
         1UNXz2wnqKlbu5vXM1YL2mDwcC/w4PZjRsK+TAFEimd60k+vhzKFK4/Sl0adK5S1WoJU
         RTzD/r6rEvfVseM5tamY1jqUfbwwEJz6kB1cRzpn7GE4jpN/USM7rs/qNyZc3VAlBIU+
         Hg974A75gr7PmQ7pI3VZuUVt3NGHcBnAiCRb7HLmXjoxoVAlBFnj9+FbdxHjmKDLKiDe
         IW0A==
X-Gm-Message-State: AC+VfDx4J0luy8DBb1bxPH5H24iX9IiI8sOgKu9ZnjxHFJoQ06+e9K4d
	U8l7wBKc+mQKn7RQcOuqB9Z29JuxePMCTA==
X-Google-Smtp-Source: ACHHUZ7vpxNrAvLZTIyqSJoNHoIOTTm9m8CJymZ+/250HbPVJOqUut8rwMxKU9rGCRrM3fkFdZehK59+Wv0uxg==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a05:6902:86:b0:bc7:4714:182e with SMTP id
 h6-20020a056902008600b00bc74714182emr769897ybs.3.1687159662131; Mon, 19 Jun
 2023 00:27:42 -0700 (PDT)
Date: Mon, 19 Jun 2023 07:27:40 +0000
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.41.0.185.g7c58973941-goog
Message-ID: <20230619072740.464528-1-edumazet@google.com>
Subject: [PATCH net-next] ipv6: fix a typo in ip6mr_sk_ioctl()
From: Eric Dumazet <edumazet@google.com>
To: "David S . Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>
Cc: netdev@vger.kernel.org, eric.dumazet@gmail.com, 
	Eric Dumazet <edumazet@google.com>, syzbot <syzkaller@googlegroups.com>, 
	Breno Leitao <leitao@debian.org>, Willem de Bruijn <willemb@google.com>, David Ahern <dsahern@kernel.org>, 
	Kuniyuki Iwashima <kuniyu@amazon.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

SIOCGETSGCNT_IN6 uses a "struct sioc_sg_req6 buffer".

Unfortunately the blamed commit made hard to ensure type safety.

syzbot reported:

BUG: KASAN: stack-out-of-bounds in ip6mr_ioctl+0xba3/0xcb0 net/ipv6/ip6mr.c:1917
Read of size 16 at addr ffffc900039afb68 by task syz-executor937/5008

CPU: 1 PID: 5008 Comm: syz-executor937 Not tainted 6.4.0-rc6-syzkaller-01304-gc08afcdcf952 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 05/27/2023
Call Trace:
<TASK>
__dump_stack lib/dump_stack.c:88 [inline]
dump_stack_lvl+0xd9/0x150 lib/dump_stack.c:106
print_address_description.constprop.0+0x2c/0x3c0 mm/kasan/report.c:351
print_report mm/kasan/report.c:462 [inline]
kasan_report+0x11c/0x130 mm/kasan/report.c:572
ip6mr_ioctl+0xba3/0xcb0 net/ipv6/ip6mr.c:1917
rawv6_ioctl+0x4e/0x1e0 net/ipv6/raw.c:1143
sock_ioctl_out net/core/sock.c:4186 [inline]
sk_ioctl+0x151/0x440 net/core/sock.c:4214
inet6_ioctl+0x1b8/0x290 net/ipv6/af_inet6.c:582
sock_do_ioctl+0xcc/0x230 net/socket.c:1189
sock_ioctl+0x1f8/0x680 net/socket.c:1306
vfs_ioctl fs/ioctl.c:51 [inline]
__do_sys_ioctl fs/ioctl.c:870 [inline]
__se_sys_ioctl fs/ioctl.c:856 [inline]
__x64_sys_ioctl+0x197/0x210 fs/ioctl.c:856
do_syscall_x64 arch/x86/entry/common.c:50 [inline]
do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7f255849bad9
Code: 28 c3 e8 2a 14 00 00 66 2e 0f 1f 84 00 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffd06792778 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f255849bad9
RDX: 0000000000000000 RSI: 00000000000089e1 RDI: 0000000000000003
RBP: 00007f255845fc80 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007f255845fd10
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
</TASK>

The buggy address belongs to stack of task syz-executor937/5008
and is located at offset 40 in frame:
sk_ioctl+0x0/0x440 net/core/sock.c:4172

This frame has 2 objects:
[32, 36) 'karg'
[48, 88) 'buffer'

Fixes: e1d001fa5b47 ("net: ioctl: Use kernel memory on protocol ioctl callbacks")
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Breno Leitao <leitao@debian.org>
Cc: Willem de Bruijn <willemb@google.com>
Cc: David Ahern <dsahern@kernel.org>
Cc: Kuniyuki Iwashima <kuniyu@amazon.com>
---
 include/linux/mroute6.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/mroute6.h b/include/linux/mroute6.h
index 2f95d5b4e47af6e1a53c9164e1ebca288e0d3d2e..63ef5191cc57908ca6b0da692c9e812875715000 100644
--- a/include/linux/mroute6.h
+++ b/include/linux/mroute6.h
@@ -109,13 +109,13 @@ static inline int ip6mr_sk_ioctl(struct sock *sk, unsigned int cmd,
 		struct sioc_mif_req6 buffer;
 
 		return sock_ioctl_inout(sk, cmd, arg, &buffer,
-				      sizeof(buffer));
+					sizeof(buffer));
 		}
 	case SIOCGETSGCNT_IN6: {
-		struct sioc_mif_req6 buffer;
+		struct sioc_sg_req6 buffer;
 
 		return sock_ioctl_inout(sk, cmd, arg, &buffer,
-				      sizeof(buffer));
+					sizeof(buffer));
 		}
 	}
 
-- 
2.41.0.185.g7c58973941-goog


