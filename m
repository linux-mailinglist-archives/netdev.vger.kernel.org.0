Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92B13460C98
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 03:19:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235231AbhK2CWf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Nov 2021 21:22:35 -0500
Received: from pi.codeconstruct.com.au ([203.29.241.158]:58994 "EHLO
        codeconstruct.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239896AbhK2CUe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Nov 2021 21:20:34 -0500
Received: by codeconstruct.com.au (Postfix, from userid 10000)
        id 42E112022C; Mon, 29 Nov 2021 10:17:08 +0800 (AWST)
From:   Jeremy Kerr <jk@codeconstruct.com.au>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matt Johnston <matt@codeconstruct.com.au>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH net] mctp: test: fix skb free in test device tx
Date:   Mon, 29 Nov 2021 10:16:52 +0800
Message-Id: <20211129021652.3220400-1-jk@codeconstruct.com.au>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In our test device, we're currently freeing skbs in the transmit path
with kfree(), rather than kfree_skb(). This change uses the correct
kfree_skb() instead.

Fixes: ded21b722995 ("mctp: Add test utils")
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Jeremy Kerr <jk@codeconstruct.com.au>
---
 net/mctp/test/utils.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mctp/test/utils.c b/net/mctp/test/utils.c
index cc6b8803aa9d..7b7918702592 100644
--- a/net/mctp/test/utils.c
+++ b/net/mctp/test/utils.c
@@ -12,7 +12,7 @@
 static netdev_tx_t mctp_test_dev_tx(struct sk_buff *skb,
 				    struct net_device *ndev)
 {
-	kfree(skb);
+	kfree_skb(skb);
 	return NETDEV_TX_OK;
 }
 
-- 
2.30.2

