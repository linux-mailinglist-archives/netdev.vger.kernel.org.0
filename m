Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 25DB61570EA
	for <lists+netdev@lfdr.de>; Mon, 10 Feb 2020 09:36:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727595AbgBJIgg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Feb 2020 03:36:36 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:58722 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727079AbgBJIgf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 Feb 2020 03:36:35 -0500
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id E4AAAE82F780F6B7DEDF;
        Mon, 10 Feb 2020 16:36:28 +0800 (CST)
Received: from euler.huawei.com (10.175.104.193) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.439.0; Mon, 10 Feb 2020 16:36:22 +0800
From:   Chen Wandun <chenwandun@huawei.com>
To:     <pablo@netfilter.org>, <kadlec@netfilter.org>, <fw@strlen.de>,
        <davem@davemloft.net>, <kuba@kernel.org>, <sbrivio@redhat.com>,
        <netfilter-devel@vger.kernel.org>, <coreteam@netfilter.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <chenwandun@huawei.com>
Subject: [PATCH next] nf_tables: make the symbol 'nft_pipapo_get' static
Date:   Mon, 10 Feb 2020 16:51:09 +0800
Message-ID: <20200210085109.13954-1-chenwandun@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.104.193]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the following sparse warning:

net/netfilter/nft_set_pipapo.c:739:6: warning: symbol 'nft_pipapo_get' was not declared. Should it be static?

Fixes: 3c4287f62044 ("nf_tables: Add set type for arbitrary concatenation of ranges")
Signed-off-by: Chen Wandun <chenwandun@huawei.com>
---
 net/netfilter/nft_set_pipapo.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
index f0cb1e13af50..f5b9bb6bfcc3 100644
--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -736,8 +736,8 @@ static struct nft_pipapo_elem *pipapo_get(const struct net *net,
  * @elem:	nftables API element representation containing key data
  * @flags:	Unused
  */
-void *nft_pipapo_get(const struct net *net, const struct nft_set *set,
-		     const struct nft_set_elem *elem, unsigned int flags)
+static void *nft_pipapo_get(const struct net *net, const struct nft_set *set,
+			    const struct nft_set_elem *elem, unsigned int flags)
 {
 	return pipapo_get(net, set, (const u8 *)elem->key.val.data,
 			  nft_genmask_cur(net));
-- 
2.17.1

