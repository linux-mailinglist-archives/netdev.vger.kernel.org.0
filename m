Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C0BA22C5CA
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 15:09:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726783AbgGXNJ1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 09:09:27 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:35926 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726572AbgGXNJ1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jul 2020 09:09:27 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1jyxRv-0004tR-PI; Fri, 24 Jul 2020 13:09:19 +0000
From:   Colin King <colin.king@canonical.com>
To:     Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-sctp@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][V2] sctp: remove redundant initialization of variable status
Date:   Fri, 24 Jul 2020 14:09:19 +0100
Message-Id: <20200724130919.18497-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The variable status is being initialized with a value that is never read
and it is being updated later with a new value.  The initialization is
redundant and can be removed.  Also put the variable declarations into
reverse christmas tree order.

Addresses-Coverity: ("Unused value")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
---

V2: put variable declarations into reverse christmas tree order.

---
 net/sctp/protocol.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/sctp/protocol.c b/net/sctp/protocol.c
index 7ecaf7d575c0..d19db22262fd 100644
--- a/net/sctp/protocol.c
+++ b/net/sctp/protocol.c
@@ -1367,15 +1367,15 @@ static struct pernet_operations sctp_ctrlsock_ops = {
 /* Initialize the universe into something sensible.  */
 static __init int sctp_init(void)
 {
-	int i;
-	int status = -EINVAL;
-	unsigned long goal;
-	unsigned long limit;
 	unsigned long nr_pages = totalram_pages();
+	unsigned long limit;
+	unsigned long goal;
+	int max_entry_order;
+	int num_entries;
 	int max_share;
+	int status;
 	int order;
-	int num_entries;
-	int max_entry_order;
+	int i;
 
 	sock_skb_cb_check_size(sizeof(struct sctp_ulpevent));
 
-- 
2.27.0

