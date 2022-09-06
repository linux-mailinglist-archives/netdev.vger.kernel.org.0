Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06EF35AF33C
	for <lists+netdev@lfdr.de>; Tue,  6 Sep 2022 20:04:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229520AbiIFSEl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 14:04:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbiIFSEk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 14:04:40 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2D7213E16
        for <netdev@vger.kernel.org>; Tue,  6 Sep 2022 11:04:38 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id lz22so4262362ejb.3
        for <netdev@vger.kernel.org>; Tue, 06 Sep 2022 11:04:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares.net; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=Ow/wLd30qnpVXkYHu9y10pAdjF3WB8VsFrXpWU88Txg=;
        b=28aoz7P7Ti8HMbmay9OAw9t6XaM0aGpiu1qjbU04Xqk2kmJdB4n9pNYyu0BPHUUARY
         ZkbOuz7tkerHLa8mU/2DfbvUnLjzVt0QzW2FvP5WkryNWCzQLwkUD0VUDRMIUv3Jnc8/
         HK4nSUiWPhF10YEtpPnvdueoz28qFOugksikcsiT0kFlnCBU1MLUYwYxM+pm7AgDWF3i
         NcwfutTvXQfxGw1kqCfn5zZxJbot2DWR80QA+Kp76BU6Y2dn9cy6uRzViwHr4s5Y6Jj2
         tBmutwyjtSbapmcxuaPfdkN2NNyoYWCuYFD4oemB0Wf2udzDwE5lfca2uUFxgfhRyFzm
         gUBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=Ow/wLd30qnpVXkYHu9y10pAdjF3WB8VsFrXpWU88Txg=;
        b=SIvvnuz8u0m5VyxexbWKbxMMdVRIm12ttgsVniOkBF1/2sAnQTwhHrkWgFctReOgoF
         LeiQvFo8LuGMjZGqjjqaPI/IQZDw3r/9OBq10XoibeZ6S7ZrNkWS0kg2SysG9Z8xM+R4
         zau+Gu6wpzSKm4OjwUtK+vWAlxUPYmoD+mO/0QMoo5pRz8RhgJVTQoeGpaMvDSkVp9F8
         A5dH1z0pt1cqGFvUH736KW0/vmHbn7W+QB6XXTMVPjIrwKXNyJ52KBYqjMnj2R9Dw5+0
         ENE7v+6PMJDWQ3aztiVfDsNEFjyHQUSr+jXCaGRo9OTICX1e7zMRnNZhnBQLycAdKGGl
         58oQ==
X-Gm-Message-State: ACgBeo05ZAgxTK8mNlFvqnYehbJJdYWc0o0jCQXumvXxmf7K8tMAKYrn
        7QeQ4+3+GxoOVV+WqPnnmEoQvA==
X-Google-Smtp-Source: AA6agR6lafvIMENxBfPkng6SP6E+fxgPIE0i4Xce9xglTCv8jjI/RR4iSZAXuzihbSYkU0fRkNQ0Hg==
X-Received: by 2002:a17:907:7ea8:b0:731:4fa1:d034 with SMTP id qb40-20020a1709077ea800b007314fa1d034mr40894770ejc.758.1662487477080;
        Tue, 06 Sep 2022 11:04:37 -0700 (PDT)
Received: from vdi08.nix.tessares.net (static.219.156.76.144.clients.your-server.de. [144.76.156.219])
        by smtp.gmail.com with ESMTPSA id t6-20020a170906948600b00731745a7e62sm7007845ejx.28.2022.09.06.11.04.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Sep 2022 11:04:35 -0700 (PDT)
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     kernel test robot <oliver.sang@intel.com>, netdev@vger.kernel.org,
        mptcp@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: [PATCH net 1/2] mptcp: fix fwd memory accounting on coalesce
Date:   Tue,  6 Sep 2022 20:04:01 +0200
Message-Id: <20220906180404.1255873-1-matthieu.baerts@tessares.net>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=5665; i=matthieu.baerts@tessares.net;
 h=from:subject; bh=t8cmDnU3uUS9PdW1N2RcyIJOSiEW+cMzPyWsGrCTiQQ=;
 b=owEBbQKS/ZANAwAIAfa3gk9CaaBzAcsmYgBjF4uEGvXD6136jzJ9RSpbwD8Xf7mZeTRCTlvAoKQd
 KrYW74mJAjMEAAEIAB0WIQToy4X3aHcFem4n93r2t4JPQmmgcwUCYxeLhAAKCRD2t4JPQmmgc5GsD/
 42uTEzezIR1isCLJfxvuKH+edEeHDc9WVDBxEr5SDyxKjNZVBgmWShPjaOFV+HodpN9REuezgZwD0R
 A37hGko4Y6ERWeXVuzglXERHMVz2ImDvXEHQrlJUpQc4ilv8miqLDA4Po5C3T+2y6SMtRMvzuE5g/b
 8YeGKfPWWnaI/1gjXjIyKenkVBgGxuqs138qDExX5N8hGCjUAyNdNCpFX7QjvgWb7luKbsRKhD59H5
 tO6kfywJ2bim9uN2pyBMZM0sWjHHYNp3tkPAWPNpo+8MJcCW822DH4MYutUA9kKA3i6q5zoQj95IrC
 wzh43vOcIu1yncmBN3ckaRRWqoCygKnYQjDsxE9hkXXVcdoTcdxOFQ602YOifciIFuhlwA/AWTwLwR
 4XRLLaO8On3Zw+A7LWWhK2DtsUglp5/htgHnEAvpw2SeQJCGBt+PmIDkonTYJVuxX0sN69gOsZG7nL
 MHNCISs+EzMl/bFSU8ppq5Ml3+JRvjXkDPdxHKTGcJjQR6+e5J3vlGzZ0+Lp0RRax/OC9i72D+gwg4
 KvZhr5TqxOFq4i01t2W8iZ4sDqnlx7jfYFsPq0DaZhpRpOteQun1pOTzw00sXqE89NpuzS84WBQukK
 v9CWFpvH2ZQTmGAbaRbKunMVmKFAGXYbzEXXs6I8JxZLSpumiHZVlUSTnyZA==
X-Developer-Key: i=matthieu.baerts@tessares.net; a=openpgp; fpr=E8CB85F76877057A6E27F77AF6B7824F4269A073
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

The intel bot reported a memory accounting related splat:

[  240.473094] ------------[ cut here ]------------
[  240.478507] page_counter underflow: -4294828518 nr_pages=4294967290
[  240.485500] WARNING: CPU: 2 PID: 14986 at mm/page_counter.c:56 page_counter_cancel+0x96/0xc0
[  240.570849] CPU: 2 PID: 14986 Comm: mptcp_connect Tainted: G S                5.19.0-rc4-00739-gd24141fe7b48 #1
[  240.581637] Hardware name: HP HP Z240 SFF Workstation/802E, BIOS N51 Ver. 01.63 10/05/2017
[  240.590600] RIP: 0010:page_counter_cancel+0x96/0xc0
[  240.596179] Code: 00 00 00 45 31 c0 48 89 ef 5d 4c 89 c6 41 5c e9 40 fd ff ff 4c 89 e2 48 c7 c7 20 73 39 84 c6 05 d5 b1 52 04 01 e8 e7 95 f3
01 <0f> 0b eb a9 48 89 ef e8 1e 25 fc ff eb c3 66 66 2e 0f 1f 84 00 00
[  240.615639] RSP: 0018:ffffc9000496f7c8 EFLAGS: 00010082
[  240.621569] RAX: 0000000000000000 RBX: ffff88819c9c0120 RCX: 0000000000000000
[  240.629404] RDX: 0000000000000027 RSI: 0000000000000004 RDI: fffff5200092deeb
[  240.637239] RBP: ffff88819c9c0120 R08: 0000000000000001 R09: ffff888366527a2b
[  240.645069] R10: ffffed106cca4f45 R11: 0000000000000001 R12: 00000000fffffffa
[  240.652903] R13: ffff888366536118 R14: 00000000fffffffa R15: ffff88819c9c0000
[  240.660738] FS:  00007f3786e72540(0000) GS:ffff888366500000(0000) knlGS:0000000000000000
[  240.669529] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  240.675974] CR2: 00007f966b346000 CR3: 0000000168cea002 CR4: 00000000003706e0
[  240.683807] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  240.691641] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[  240.699468] Call Trace:
[  240.702613]  <TASK>
[  240.705413]  page_counter_uncharge+0x29/0x80
[  240.710389]  drain_stock+0xd0/0x180
[  240.714585]  refill_stock+0x278/0x580
[  240.718951]  __sk_mem_reduce_allocated+0x222/0x5c0
[  240.729248]  __mptcp_update_rmem+0x235/0x2c0
[  240.734228]  __mptcp_move_skbs+0x194/0x6c0
[  240.749764]  mptcp_recvmsg+0xdfa/0x1340
[  240.763153]  inet_recvmsg+0x37f/0x500
[  240.782109]  sock_read_iter+0x24a/0x380
[  240.805353]  new_sync_read+0x420/0x540
[  240.838552]  vfs_read+0x37f/0x4c0
[  240.842582]  ksys_read+0x170/0x200
[  240.864039]  do_syscall_64+0x5c/0x80
[  240.872770]  entry_SYSCALL_64_after_hwframe+0x46/0xb0
[  240.878526] RIP: 0033:0x7f3786d9ae8e
[  240.882805] Code: c0 e9 b6 fe ff ff 50 48 8d 3d 6e 18 0a 00 e8 89 e8 01 00 66 0f 1f 84 00 00 00 00 00 64 8b 04 25 18 00 00 00 85 c0 75 14 0f 05 <48> 3d 00 f0 ff ff 77 5a c3 66 0f 1f 84 00 00 00 00 00 48 83 ec 28
[  240.902259] RSP: 002b:00007fff7be81e08 EFLAGS: 00000246 ORIG_RAX: 0000000000000000
[  240.910533] RAX: ffffffffffffffda RBX: 0000000000002000 RCX: 00007f3786d9ae8e
[  240.918368] RDX: 0000000000002000 RSI: 00007fff7be87ec0 RDI: 0000000000000005
[  240.926206] RBP: 0000000000000005 R08: 00007f3786e6a230 R09: 00007f3786e6a240
[  240.934046] R10: fffffffffffff288 R11: 0000000000000246 R12: 0000000000002000
[  240.941884] R13: 00007fff7be87ec0 R14: 00007fff7be87ec0 R15: 0000000000002000
[  240.949741]  </TASK>
[  240.952632] irq event stamp: 27367
[  240.956735] hardirqs last  enabled at (27366): [<ffffffff81ba50ea>] mem_cgroup_uncharge_skmem+0x6a/0x80
[  240.966848] hardirqs last disabled at (27367): [<ffffffff81b8fd42>] refill_stock+0x282/0x580
[  240.976017] softirqs last  enabled at (27360): [<ffffffff83a4d8ef>] mptcp_recvmsg+0xaf/0x1340
[  240.985273] softirqs last disabled at (27364): [<ffffffff83a4d30c>] __mptcp_move_skbs+0x18c/0x6c0
[  240.994872] ---[ end trace 0000000000000000 ]---

After commit d24141fe7b48 ("mptcp: drop SK_RECLAIM_* macros"),
if rmem_fwd_alloc become negative, mptcp_rmem_uncharge() can
try to reclaim a negative amount of pages, since the expression:

	reclaimable >= PAGE_SIZE

will evaluate to true for any negative value of the int
'reclaimable': 'PAGE_SIZE' is an unsigned long and
the negative integer will be promoted to a (very large)
unsigned long value.

Still after the mentioned commit, kfree_skb_partial()
in mptcp_try_coalesce() will reclaim most of just released fwd
memory, so that following charging of the skb delta size will
lead to negative fwd memory values.

At that point a racing recvmsg() can trigger the splat.

Address the issue switching the order of the memory accounting
operations. The fwd memory can still transiently reach negative
values, but that will happen in an atomic scope and no code
path could touch/use such value.

Reported-by: kernel test robot <oliver.sang@intel.com>
Fixes: d24141fe7b48 ("mptcp: drop SK_RECLAIM_* macros")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
---
 net/mptcp/protocol.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index d398f3810662..969b33a9dd64 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -150,9 +150,15 @@ static bool mptcp_try_coalesce(struct sock *sk, struct sk_buff *to,
 		 MPTCP_SKB_CB(from)->map_seq, MPTCP_SKB_CB(to)->map_seq,
 		 to->len, MPTCP_SKB_CB(from)->end_seq);
 	MPTCP_SKB_CB(to)->end_seq = MPTCP_SKB_CB(from)->end_seq;
-	kfree_skb_partial(from, fragstolen);
+
+	/* note the fwd memory can reach a negative value after accounting
+	 * for the delta, but the later skb free will restore a non
+	 * negative one
+	 */
 	atomic_add(delta, &sk->sk_rmem_alloc);
 	mptcp_rmem_charge(sk, delta);
+	kfree_skb_partial(from, fragstolen);
+
 	return true;
 }
 
-- 
2.37.2

