Return-Path: <netdev+bounces-6568-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 97CB9716F4F
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 23:01:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 36E711C20CF4
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 21:01:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7772021CF3;
	Tue, 30 May 2023 21:01:29 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C85221CE0;
	Tue, 30 May 2023 21:01:29 +0000 (UTC)
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DFB2100;
	Tue, 30 May 2023 14:01:27 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id 98e67ed59e1d1-2566f66190dso2651138a91.1;
        Tue, 30 May 2023 14:01:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685480487; x=1688072487;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lVfqXAluQ8L6Q43FfKn6T9fOnZOaZK4ZfTTWre2cHNk=;
        b=O3rF9iz5CM0XQzZ9UtLfTPc51lpqndrCguHtCc4rV7hGVKmFeyZN3peLWbkU0Vl13S
         K7VIN+CI/WcXxS3m0Q2jxzuIBxR6BKOTSUl140Lj1+QDUBcGvyrqJRD5EJsAvoD+hq3q
         J4XSLBJ77gfUGyKgdtgyATMWqeJN5GPpEmSwk+OSuXUGzBl4LzIqtbm/LYWVEqaev/Wo
         G63oRcagHtaEd7gEkxDWewQSJSKfwO75Nybg90BYiuNrjxRZWghU6K/wOEIOcG/NBg5/
         dpZ5u3Xl3hyXzBHi2Z+ZQVopNqdfQBeuNxLqw+5pQQHxDYfhC4myPYMZa4neHFRHa5xO
         c+XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685480487; x=1688072487;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=lVfqXAluQ8L6Q43FfKn6T9fOnZOaZK4ZfTTWre2cHNk=;
        b=KmSmZ7PwUiyOwiiPYM67Pc8uVTNyVrz52uZvaAM5+7xr6YKhMb8DOpAK3/Xlykb4Sh
         NG21ttsK+mNfI1fwPDypEyUINLNFAe0t9x98+KteGnr47rJcB2OzBQ70ZpQs+hyPrzvp
         RB1VbF/jmUkBdfKjZyX+gK+fPbf/Gn4YE3GQnEd4Qx0Dg1rHyOGhaxv+tDYuR8GR/EwT
         DE/bU5UOgKfR9nJsSvEaFDj2AzxgeRmgWWnKgQqQQXBYvQ9VWNuXBt8jwf60gW0I3oU5
         n8zAv7SOaEYg1hQbLDyWffxRaKjkjXU7910mFBJxuvhLpYq0k20GNMi8uHwgdU0/lDrE
         QJew==
X-Gm-Message-State: AC+VfDzvMysIsEpKNF/MeF76cj7V95/8c8Xn3FgVS+vKmQYrrcQRANX8
	m/WrKqAFR6Lu03+4mkdRwuA=
X-Google-Smtp-Source: ACHHUZ5SrmZ6ttWlf4D2kJpi9oCUgEN3EAPxfdhmqLSiUIdq7ewpswWnILG8UAwcR2CXCL4ibSgAcQ==
X-Received: by 2002:a17:902:e80e:b0:1af:d00c:7f04 with SMTP id u14-20020a170902e80e00b001afd00c7f04mr3922322plg.12.1685480486706;
        Tue, 30 May 2023 14:01:26 -0700 (PDT)
Received: from localhost ([2605:59c8:148:ba10:88bf:3da6:e71a:c5dc])
        by smtp.gmail.com with ESMTPSA id 9-20020a170902c10900b001a5fccab02dsm10750947pli.177.2023.05.30.14.01.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 May 2023 14:01:26 -0700 (PDT)
Date: Tue, 30 May 2023 14:01:20 -0700
From: John Fastabend <john.fastabend@gmail.com>
To: Eric Dumazet <edumazet@google.com>, 
 "David S . Miller" <davem@davemloft.net>, 
 Jakub Kicinski <kuba@kernel.org>, 
 Paolo Abeni <pabeni@redhat.com>, 
 Daniel Borkmann <daniel@iogearbox.net>, 
 Alexei Starovoitov <ast@kernel.org>, 
 Andrii Nakryiko <andrii@kernel.org>
Cc: netdev@vger.kernel.org, 
 bpf@vger.kernel.org, 
 eric.dumazet@gmail.com, 
 Eric Dumazet <edumazet@google.com>, 
 syzbot <syzkaller@googlegroups.com>, 
 John Fastabend <john.fastabend@gmail.com>, 
 Jakub Sitnicki <jakub@cloudflare.com>
Message-ID: <647664201d3ce_16adb2085c@john.notmuch>
In-Reply-To: <20230530195149.68145-1-edumazet@google.com>
References: <20230530195149.68145-1-edumazet@google.com>
Subject: RE: [PATCH net] bpf, sockmap: avoid potential NULL dereference in
 sk_psock_verdict_data_ready()
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Eric Dumazet wrote:
> syzbot found sk_psock(sk) could return NULL when called
> from sk_psock_verdict_data_ready().
> 
> Just make sure to handle this case.
> 
> [1]
> general protection fault, probably for non-canonical address 0xdffffc000000005c: 0000 [#1] PREEMPT SMP KASAN
> KASAN: null-ptr-deref in range [0x00000000000002e0-0x00000000000002e7]
> CPU: 0 PID: 15 Comm: ksoftirqd/0 Not tainted 6.4.0-rc3-syzkaller-00588-g4781e965e655 #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 05/16/2023
> RIP: 0010:sk_psock_verdict_data_ready+0x19f/0x3c0 net/core/skmsg.c:1213
> Code: 4c 89 e6 e8 63 70 5e f9 4d 85 e4 75 75 e8 19 74 5e f9 48 8d bb e0 02 00 00 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <80> 3c 02 00 0f 85 07 02 00 00 48 89 ef ff 93 e0 02 00 00 e8 29 fd
> RSP: 0018:ffffc90000147688 EFLAGS: 00010206
> RAX: dffffc0000000000 RBX: 0000000000000000 RCX: 0000000000000100
> RDX: 000000000000005c RSI: ffffffff8825ceb7 RDI: 00000000000002e0
> RBP: ffff888076518c40 R08: 0000000000000007 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000001 R12: 0000000000000000
> R13: 0000000000000000 R14: 0000000000008000 R15: ffff888076518c40
> FS: 0000000000000000(0000) GS:ffff8880b9800000(0000) knlGS:0000000000000000
> CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f901375bab0 CR3: 000000004bf26000 CR4: 00000000003506f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
> <TASK>
> tcp_data_ready+0x10a/0x520 net/ipv4/tcp_input.c:5006
> tcp_data_queue+0x25d3/0x4c50 net/ipv4/tcp_input.c:5080
> tcp_rcv_established+0x829/0x1f90 net/ipv4/tcp_input.c:6019
> tcp_v4_do_rcv+0x65a/0x9c0 net/ipv4/tcp_ipv4.c:1726
> tcp_v4_rcv+0x2cbf/0x3340 net/ipv4/tcp_ipv4.c:2148
> ip_protocol_deliver_rcu+0x9f/0x480 net/ipv4/ip_input.c:205
> ip_local_deliver_finish+0x2ec/0x520 net/ipv4/ip_input.c:233
> NF_HOOK include/linux/netfilter.h:303 [inline]
> NF_HOOK include/linux/netfilter.h:297 [inline]
> ip_local_deliver+0x1ae/0x200 net/ipv4/ip_input.c:254
> dst_input include/net/dst.h:468 [inline]
> ip_rcv_finish+0x1cf/0x2f0 net/ipv4/ip_input.c:449
> NF_HOOK include/linux/netfilter.h:303 [inline]
> NF_HOOK include/linux/netfilter.h:297 [inline]
> ip_rcv+0xae/0xd0 net/ipv4/ip_input.c:569
> __netif_receive_skb_one_core+0x114/0x180 net/core/dev.c:5491
> __netif_receive_skb+0x1f/0x1c0 net/core/dev.c:5605
> process_backlog+0x101/0x670 net/core/dev.c:5933
> __napi_poll+0xb7/0x6f0 net/core/dev.c:6499
> napi_poll net/core/dev.c:6566 [inline]
> net_rx_action+0x8a9/0xcb0 net/core/dev.c:6699
> __do_softirq+0x1d4/0x905 kernel/softirq.c:571
> run_ksoftirqd kernel/softirq.c:939 [inline]
> run_ksoftirqd+0x31/0x60 kernel/softirq.c:931
> smpboot_thread_fn+0x659/0x9e0 kernel/smpboot.c:164
> kthread+0x344/0x440 kernel/kthread.c:379
> ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:308
> </TASK>
> 
> Fixes: 6df7f764cd3c ("bpf, sockmap: Wake up polling after data copy")
> Reported-by: syzbot <syzkaller@googlegroups.com>
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: John Fastabend <john.fastabend@gmail.com>
> Cc: Daniel Borkmann <daniel@iogearbox.net>
> Cc: Jakub Sitnicki <jakub@cloudflare.com>
> ---


Seems syzbot is getting good at finding misuse of psock.

Reviewed-by: John Fastabend <john.fastabend@gmail.com>

