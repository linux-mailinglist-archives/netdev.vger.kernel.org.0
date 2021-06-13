Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C4A13A58DF
	for <lists+netdev@lfdr.de>; Sun, 13 Jun 2021 15:46:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231923AbhFMNsn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Jun 2021 09:48:43 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53856 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231747AbhFMNsm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Jun 2021 09:48:42 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <colin.king@canonical.com>)
        id 1lsQRh-0003aH-6a; Sun, 13 Jun 2021 13:46:37 +0000
From:   Colin King <colin.king@canonical.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ipv6: fib6: remove redundant initialization of variable err
Date:   Sun, 13 Jun 2021 14:46:36 +0100
Message-Id: <20210613134636.74416-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The variable err is being initialized with a value that is never read, the
assignment is redundant and can be removed.

Addresses-Coverity: ("Unused value")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 net/ipv6/fib6_rules.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv6/fib6_rules.c b/net/ipv6/fib6_rules.c
index 8f9a83314de7..40f3e4f9f33a 100644
--- a/net/ipv6/fib6_rules.c
+++ b/net/ipv6/fib6_rules.c
@@ -467,7 +467,7 @@ static const struct fib_rules_ops __net_initconst fib6_rules_ops_template = {
 static int __net_init fib6_rules_net_init(struct net *net)
 {
 	struct fib_rules_ops *ops;
-	int err = -ENOMEM;
+	int err;
 
 	ops = fib_rules_register(&fib6_rules_ops_template, net);
 	if (IS_ERR(ops))
-- 
2.31.1

