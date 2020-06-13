Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 719371F8133
	for <lists+netdev@lfdr.de>; Sat, 13 Jun 2020 08:01:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726401AbgFMGA4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Jun 2020 02:00:56 -0400
Received: from mxhk.zte.com.cn ([63.217.80.70]:60772 "EHLO mxhk.zte.com.cn"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725272AbgFMGA4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 13 Jun 2020 02:00:56 -0400
Received: from mse-fl2.zte.com.cn (unknown [10.30.14.239])
        by Forcepoint Email with ESMTPS id 89F1FD6F033CB2C894DE;
        Sat, 13 Jun 2020 14:00:50 +0800 (CST)
Received: from notes_smtp.zte.com.cn (notessmtp.zte.com.cn [10.30.1.239])
        by mse-fl2.zte.com.cn with ESMTP id 05D60mhR008458;
        Sat, 13 Jun 2020 14:00:48 +0800 (GMT-8)
        (envelope-from wang.yi59@zte.com.cn)
Received: from fox-host8.localdomain ([10.74.120.8])
          by szsmtp06.zte.com.cn (Lotus Domino Release 8.5.3FP6)
          with ESMTP id 2020061314013247-3927540 ;
          Sat, 13 Jun 2020 14:01:32 +0800 
From:   Yi Wang <wang.yi59@zte.com.cn>
To:     davem@davemloft.net
Cc:     kuba@kernel.org, mst@redhat.com, hkallweit1@gmail.com,
        snelson@pensando.io, andriy.shevchenko@linux.intel.com,
        xiyou.wangcong@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, xue.zhihong@zte.com.cn,
        wang.yi59@zte.com.cn, wang.liang82@zte.com.cn,
        Liao Pingfang <liao.pingfang@zte.com.cn>
Subject: [PATCH v3] net: atm: Remove the error message according to the atomic context
Date:   Sat, 13 Jun 2020 14:03:26 +0800
Message-Id: <1592028206-19557-1-git-send-email-wang.yi59@zte.com.cn>
X-Mailer: git-send-email 1.8.3.1
X-MIMETrack: Itemize by SMTP Server on SZSMTP06/server/zte_ltd(Release 8.5.3FP6|November
 21, 2013) at 2020-06-13 14:01:32,
        Serialize by Router on notes_smtp/zte_ltd(Release 9.0.1FP7|August  17, 2016) at
 2020-06-13 14:00:49,
        Serialize complete at 2020-06-13 14:00:49
X-MAIL: mse-fl2.zte.com.cn 05D60mhR008458
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Liao Pingfang <liao.pingfang@zte.com.cn>

Looking into the context (atomic!) and the error message should be dropped.

Signed-off-by: Liao Pingfang <liao.pingfang@zte.com.cn>
---
Changes in v3: remove {} as there is only one statement left.

 net/atm/lec.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/net/atm/lec.c b/net/atm/lec.c
index ca37f5a..875fc0b 100644
--- a/net/atm/lec.c
+++ b/net/atm/lec.c
@@ -1536,10 +1536,8 @@ static struct lec_arp_table *make_entry(struct lec_priv *priv,
 	struct lec_arp_table *to_return;
 
 	to_return = kzalloc(sizeof(struct lec_arp_table), GFP_ATOMIC);
-	if (!to_return) {
-		pr_info("LEC: Arp entry kmalloc failed\n");
+	if (!to_return)
 		return NULL;
-	}
 	ether_addr_copy(to_return->mac_addr, mac_addr);
 	INIT_HLIST_NODE(&to_return->next);
 	timer_setup(&to_return->timer, lec_arp_expire_arp, 0);
-- 
2.9.5

