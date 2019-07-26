Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9736762C3
	for <lists+netdev@lfdr.de>; Fri, 26 Jul 2019 11:51:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726371AbfGZJqP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jul 2019 05:46:15 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42258 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725842AbfGZJqP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jul 2019 05:46:15 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
        (Exim 4.76)
        (envelope-from <colin.king@canonical.com>)
        id 1hqwnk-0007TE-1C; Fri, 26 Jul 2019 09:46:12 +0000
From:   Colin King <colin.king@canonical.com>
To:     "David S . Miller" <davem@davemloft.net>,
        David Ahern <dsahern@gmail.com>, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net: neigh: remove redundant assignment to variable bucket
Date:   Fri, 26 Jul 2019 10:46:11 +0100
Message-Id: <20190726094611.3597-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The variable bucket is being initialized with a value that is never
read and it is being updated later with a new value in a following
for-loop. The initialization is redundant and can be removed.

Addresses-Coverity: ("Unused value")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 net/core/neighbour.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index f79e61c570ea..5480edff0c86 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -3033,7 +3033,7 @@ static struct neighbour *neigh_get_first(struct seq_file *seq)
 	struct net *net = seq_file_net(seq);
 	struct neigh_hash_table *nht = state->nht;
 	struct neighbour *n = NULL;
-	int bucket = state->bucket;
+	int bucket;
 
 	state->flags &= ~NEIGH_SEQ_IS_PNEIGH;
 	for (bucket = 0; bucket < (1 << nht->hash_shift); bucket++) {
-- 
2.20.1

