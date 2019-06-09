Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB9353A8FF
	for <lists+netdev@lfdr.de>; Sun,  9 Jun 2019 19:07:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389030AbfFIRG3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jun 2019 13:06:29 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:39080 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388603AbfFIRG2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Jun 2019 13:06:28 -0400
Received: by mail-pf1-f196.google.com with SMTP id j2so3900350pfe.6
        for <netdev@vger.kernel.org>; Sun, 09 Jun 2019 10:06:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=ITkSv1dRWXw8BORwXgryBj9VsqOkKkD9Lq2/ENmMZyg=;
        b=pWzQ/PIopM3Q3qJaEAmE4hqv605X1O8WaJY3HNQMd6p4RKtDJvWMbtnZt2n7vsZZVQ
         U7Gqc2qfBzpUU2lCKKjU5J8erjgGIrNtwonR69iGOJDhj0YYufxPeciPM2IiBZhyfZ6p
         w17WlslmrZsZpglDKK8z6QU6mogJzTGE0aZdxWYnKjqhuiurXifXbdciXE+7XVUBMDvf
         lAuUtm55AVcjct1zzmREe2cZBI8DKK6Efo1wa3h6+kAIVz1DJur+Rt4HjXfwi2PhiLaR
         miBIYlEPYJS2L95QuNXHEJCGdju6W9Gk2V/QptogjNB1q71FUoGpoJtgLcW9bEUlDo0q
         QwMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=ITkSv1dRWXw8BORwXgryBj9VsqOkKkD9Lq2/ENmMZyg=;
        b=ZSs+64W/0OCSh5dPJmq1qDiIdmRwNrZ4oaaVMYK0uozOzX6/EzxXOhQVmQN7ar6Q4T
         eqQlYKuNMbKBFJFojk1/KqhZDb9Kd2AD64GHdoXEiBAHXRXczc4+BQBelun25oFx/5zx
         hvnUVOb6zqEimljh7f5Oam5N67WCxH7gmQRF0IW88JHZV0yEHp+LwOzml6s/34MCeeTc
         J2Uy/1Iyftg5RK8ABlN8Kglkd1hUwWf+8vQYnf+2iJPjnpY5ai6CFPmAzYEI90oc3YKh
         OTtc6eZLSSsfTIStXHtslBmPaWDhUWW9TLNQ8ycuhUQcFffnJ3HpAiUwCEFjPbF7bwlC
         fCRg==
X-Gm-Message-State: APjAAAVJ52+SqA5NpKAxjU0rBgJgybsf8sUw5StxkhJ+j/42qJ/9gjPm
        /cQS+dlHLqraxqwQuuU7Gms=
X-Google-Smtp-Source: APXvYqxHxpvvuBRf5Ick4AQYe3vQl8z1JC3Vg8qpQuXWIDu0L/1grhMYNcr6GVZrlE7D4C/9tPLVbg==
X-Received: by 2002:a17:90a:1951:: with SMTP id 17mr16983794pjh.79.1560099987415;
        Sun, 09 Jun 2019 10:06:27 -0700 (PDT)
Received: from ap-To-be-filled-by-O-E-M.8.8.8.8 ([14.33.120.60])
        by smtp.gmail.com with ESMTPSA id l21sm8039484pff.40.2019.06.09.10.06.25
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 09 Jun 2019 10:06:26 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     Taehee Yoo <ap420073@gmail.com>
Subject: [PATCH net-next] net: netlink: make netlink_walk_start() void return type
Date:   Mon, 10 Jun 2019 02:05:30 +0900
Message-Id: <20190609170530.27895-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

netlink_walk_start() needed to return an error code because of 
rhashtable_walk_init(). but that was converted to rhashtable_walk_enter()
and it is a void type function. so now netlink_walk_start() doesn't need 
any return value.

Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 net/netlink/af_netlink.c | 15 +++------------
 1 file changed, 3 insertions(+), 12 deletions(-)

diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index e9ddfd782d16..7bc579f27332 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -2544,12 +2544,10 @@ struct nl_seq_iter {
 	int link;
 };
 
-static int netlink_walk_start(struct nl_seq_iter *iter)
+static void netlink_walk_start(struct nl_seq_iter *iter)
 {
 	rhashtable_walk_enter(&nl_table[iter->link].hash, &iter->hti);
 	rhashtable_walk_start(&iter->hti);
-
-	return 0;
 }
 
 static void netlink_walk_stop(struct nl_seq_iter *iter)
@@ -2565,8 +2563,6 @@ static void *__netlink_seq_next(struct seq_file *seq)
 
 	do {
 		for (;;) {
-			int err;
-
 			nlk = rhashtable_walk_next(&iter->hti);
 
 			if (IS_ERR(nlk)) {
@@ -2583,9 +2579,7 @@ static void *__netlink_seq_next(struct seq_file *seq)
 			if (++iter->link >= MAX_LINKS)
 				return NULL;
 
-			err = netlink_walk_start(iter);
-			if (err)
-				return ERR_PTR(err);
+			netlink_walk_start(iter);
 		}
 	} while (sock_net(&nlk->sk) != seq_file_net(seq));
 
@@ -2597,13 +2591,10 @@ static void *netlink_seq_start(struct seq_file *seq, loff_t *posp)
 	struct nl_seq_iter *iter = seq->private;
 	void *obj = SEQ_START_TOKEN;
 	loff_t pos;
-	int err;
 
 	iter->link = 0;
 
-	err = netlink_walk_start(iter);
-	if (err)
-		return ERR_PTR(err);
+	netlink_walk_start(iter);
 
 	for (pos = *posp; pos && obj && !IS_ERR(obj); pos--)
 		obj = __netlink_seq_next(seq);
-- 
2.17.1

