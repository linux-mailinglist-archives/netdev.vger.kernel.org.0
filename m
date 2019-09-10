Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92B65AE928
	for <lists+netdev@lfdr.de>; Tue, 10 Sep 2019 13:31:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730674AbfIJLaK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Sep 2019 07:30:10 -0400
Received: from smtp13.smtpout.orange.fr ([80.12.242.135]:30974 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728618AbfIJLaK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Sep 2019 07:30:10 -0400
Received: from localhost.localdomain ([90.126.97.183])
        by mwinf5d72 with ME
        id znW0200053xPcdm03nW0if; Tue, 10 Sep 2019 13:30:05 +0200
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Tue, 10 Sep 2019 13:30:05 +0200
X-ME-IP: 90.126.97.183
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     davem@davemloft.net, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] ipv6: Fix the link time qualifier of 'ping_v6_proc_exit_net()'
Date:   Tue, 10 Sep 2019 13:29:59 +0200
Message-Id: <20190910112959.9222-1-christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The '.exit' functions from 'pernet_operations' structure should be marked
as __net_exit, not __net_init.

Fixes: d862e5461423 ("net: ipv6: Implement /proc/net/icmp6.")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
Untested, but using __net_exit looks consistent with other
pernet_operations.exit use case.
---
 net/ipv6/ping.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv6/ping.c b/net/ipv6/ping.c
index 87d2d8c1db7c..98ac32b49d8c 100644
--- a/net/ipv6/ping.c
+++ b/net/ipv6/ping.c
@@ -223,7 +223,7 @@ static int __net_init ping_v6_proc_init_net(struct net *net)
 	return 0;
 }
 
-static void __net_init ping_v6_proc_exit_net(struct net *net)
+static void __net_exit ping_v6_proc_exit_net(struct net *net)
 {
 	remove_proc_entry("icmp6", net->proc_net);
 }
-- 
2.20.1

