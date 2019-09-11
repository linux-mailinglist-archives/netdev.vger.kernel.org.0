Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69927B00BE
	for <lists+netdev@lfdr.de>; Wed, 11 Sep 2019 18:02:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728900AbfIKQCw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Sep 2019 12:02:52 -0400
Received: from smtp11.smtpout.orange.fr ([80.12.242.133]:25075 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728826AbfIKQCw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Sep 2019 12:02:52 -0400
Received: from localhost.localdomain ([90.126.97.183])
        by mwinf5d90 with ME
        id 0G2h2100b3xPcdm03G2i0h; Wed, 11 Sep 2019 18:02:49 +0200
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Wed, 11 Sep 2019 18:02:49 +0200
X-ME-IP: 90.126.97.183
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     davem@davemloft.net, vyasevich@gmail.com, nhorman@tuxdriver.com,
        marcelo.leitner@gmail.com
Cc:     linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] sctp: Fix the link time qualifier of 'sctp_ctrlsock_exit()'
Date:   Wed, 11 Sep 2019 18:02:39 +0200
Message-Id: <20190911160239.10734-1-christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The '.exit' functions from 'pernet_operations' structure should be marked
as __net_exit, not __net_init.

Fixes: 8e2d61e0aed2 ("sctp: fix race on protocol/netns initialization")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 net/sctp/protocol.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sctp/protocol.c b/net/sctp/protocol.c
index 2d47adcb4cbe..53746ffeeca3 100644
--- a/net/sctp/protocol.c
+++ b/net/sctp/protocol.c
@@ -1336,7 +1336,7 @@ static int __net_init sctp_ctrlsock_init(struct net *net)
 	return status;
 }
 
-static void __net_init sctp_ctrlsock_exit(struct net *net)
+static void __net_exit sctp_ctrlsock_exit(struct net *net)
 {
 	/* Free the control endpoint.  */
 	inet_ctl_sock_destroy(net->sctp.ctl_sock);
-- 
2.20.1

