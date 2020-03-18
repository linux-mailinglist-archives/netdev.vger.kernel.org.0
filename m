Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99ACD18A651
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 22:07:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728026AbgCRVHc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 17:07:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:53634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727656AbgCRUyP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Mar 2020 16:54:15 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C4423208D5;
        Wed, 18 Mar 2020 20:54:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584564854;
        bh=zkRWAbiq0M3xe+y08WZiqdbbWb156+sTJhQOtwChwbk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d9jXOmfPdt4gDAbAN7SKs5UfNVZn1DR8eTWe5GkCXEcrfk2GybsuKHgIwkFuTVF3M
         5nB/ykvM9sCjfuDxdEdcRvz/p/uLKyOC4g406WL4iKXRRVB40deGmrB0D7kzIbjz7u
         rINOeLNkdrJxuihBG1mhhPyXZSQeftmWLnx//ba8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 31/73] netfilter: nft_chain_nat: inet family is missing module ownership
Date:   Wed, 18 Mar 2020 16:52:55 -0400
Message-Id: <20200318205337.16279-31-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200318205337.16279-1-sashal@kernel.org>
References: <20200318205337.16279-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit 6a42cefb25d8bdc1b391f4a53c78c32164eea2dd ]

Set owner to THIS_MODULE, otherwise the nft_chain_nat module might be
removed while there are still inet/nat chains in place.

[  117.942096] BUG: unable to handle page fault for address: ffffffffa0d5e040
[  117.942101] #PF: supervisor read access in kernel mode
[  117.942103] #PF: error_code(0x0000) - not-present page
[  117.942106] PGD 200c067 P4D 200c067 PUD 200d063 PMD 3dc909067 PTE 0
[  117.942113] Oops: 0000 [#1] PREEMPT SMP PTI
[  117.942118] CPU: 3 PID: 27 Comm: kworker/3:0 Not tainted 5.6.0-rc3+ #348
[  117.942133] Workqueue: events nf_tables_trans_destroy_work [nf_tables]
[  117.942145] RIP: 0010:nf_tables_chain_destroy.isra.0+0x94/0x15a [nf_tables]
[  117.942149] Code: f6 45 54 01 0f 84 d1 00 00 00 80 3b 05 74 44 48 8b 75 e8 48 c7 c7 72 be de a0 e8 56 e6 2d e0 48 8b 45 e8 48 c7 c7 7f be de a0 <48> 8b 30 e8 43 e6 2d e0 48 8b 45 e8 48 8b 40 10 48 85 c0 74 5b 8b
[  117.942152] RSP: 0018:ffffc9000015be10 EFLAGS: 00010292
[  117.942155] RAX: ffffffffa0d5e040 RBX: ffff88840be87fc2 RCX: 0000000000000007
[  117.942158] RDX: 0000000000000007 RSI: 0000000000000086 RDI: ffffffffa0debe7f
[  117.942160] RBP: ffff888403b54b50 R08: 0000000000001482 R09: 0000000000000004
[  117.942162] R10: 0000000000000000 R11: 0000000000000001 R12: ffff8883eda7e540
[  117.942164] R13: dead000000000122 R14: dead000000000100 R15: ffff888403b3db80
[  117.942167] FS:  0000000000000000(0000) GS:ffff88840e4c0000(0000) knlGS:0000000000000000
[  117.942169] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  117.942172] CR2: ffffffffa0d5e040 CR3: 00000003e4c52002 CR4: 00000000001606e0
[  117.942174] Call Trace:
[  117.942188]  nf_tables_trans_destroy_work.cold+0xd/0x12 [nf_tables]
[  117.942196]  process_one_work+0x1d6/0x3b0
[  117.942200]  worker_thread+0x45/0x3c0
[  117.942203]  ? process_one_work+0x3b0/0x3b0
[  117.942210]  kthread+0x112/0x130
[  117.942214]  ? kthread_create_worker_on_cpu+0x40/0x40
[  117.942221]  ret_from_fork+0x35/0x40

nf_tables_chain_destroy() crashes on module_put() because the module is
gone.

Fixes: d164385ec572 ("netfilter: nat: add inet family nat support")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_chain_nat.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/netfilter/nft_chain_nat.c b/net/netfilter/nft_chain_nat.c
index ff9ac8ae0031f..eac4a901233f2 100644
--- a/net/netfilter/nft_chain_nat.c
+++ b/net/netfilter/nft_chain_nat.c
@@ -89,6 +89,7 @@ static const struct nft_chain_type nft_chain_nat_inet = {
 	.name		= "nat",
 	.type		= NFT_CHAIN_T_NAT,
 	.family		= NFPROTO_INET,
+	.owner		= THIS_MODULE,
 	.hook_mask	= (1 << NF_INET_PRE_ROUTING) |
 			  (1 << NF_INET_LOCAL_IN) |
 			  (1 << NF_INET_LOCAL_OUT) |
-- 
2.20.1

