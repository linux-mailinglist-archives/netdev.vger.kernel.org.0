Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E62AD2A0C9
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 23:57:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404475AbfEXV5G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 17:57:06 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59271 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404259AbfEXV5G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 May 2019 17:57:06 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
        (Exim 4.76)
        (envelope-from <colin.king@canonical.com>)
        id 1hUIBO-0001hg-OD; Fri, 24 May 2019 21:56:58 +0000
From:   Colin King <colin.king@canonical.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] ipv4: remove redundant assignment to n
Date:   Fri, 24 May 2019 22:56:58 +0100
Message-Id: <20190524215658.25432-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The pointer n is being assigned a value however this value is
never read in the code block and the end of the code block
continues to the next loop iteration. Clean up the code by
removing the redundant assignment.

Addresses-Coverity: ("Unused value")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 net/ipv4/fib_trie.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/ipv4/fib_trie.c b/net/ipv4/fib_trie.c
index ea7df7ebf597..b53ecef89d59 100644
--- a/net/ipv4/fib_trie.c
+++ b/net/ipv4/fib_trie.c
@@ -1961,7 +1961,6 @@ static void __fib_info_notify_update(struct net *net, struct fib_table *tb,
 			if (IS_TRIE(pn))
 				break;
 
-			n = pn;
 			pn = node_parent(pn);
 			cindex = get_index(pkey, pn);
 			continue;
-- 
2.20.1

