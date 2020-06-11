Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C36F01F5F52
	for <lists+netdev@lfdr.de>; Thu, 11 Jun 2020 02:52:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727024AbgFKAv6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jun 2020 20:51:58 -0400
Received: from mxhk.zte.com.cn ([63.217.80.70]:60394 "EHLO mxhk.zte.com.cn"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726977AbgFKAv6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Jun 2020 20:51:58 -0400
X-Greylist: delayed 910 seconds by postgrey-1.27 at vger.kernel.org; Wed, 10 Jun 2020 20:51:57 EDT
Received: from mse-fl2.zte.com.cn (unknown [10.30.14.239])
        by Forcepoint Email with ESMTPS id 3D71CE9261C3F7779FC7;
        Thu, 11 Jun 2020 08:36:46 +0800 (CST)
Received: from notes_smtp.zte.com.cn (notessmtp.zte.com.cn [10.30.1.239])
        by mse-fl2.zte.com.cn with ESMTP id 05B0aic2092194;
        Thu, 11 Jun 2020 08:36:44 +0800 (GMT-8)
        (envelope-from wang.yi59@zte.com.cn)
Received: from fox-host8.localdomain ([10.74.120.8])
          by szsmtp06.zte.com.cn (Lotus Domino Release 8.5.3FP6)
          with ESMTP id 2020061108371067-3897433 ;
          Thu, 11 Jun 2020 08:37:10 +0800 
From:   Yi Wang <wang.yi59@zte.com.cn>
To:     davem@davemloft.net
Cc:     kuba@kernel.org, mst@redhat.com, hkallweit1@gmail.com,
        snelson@pensando.io, andriy.shevchenko@linux.intel.com,
        xiyou.wangcong@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, xue.zhihong@zte.com.cn,
        wang.yi59@zte.com.cn, wang.liang82@zte.com.cn,
        Liao Pingfang <liao.pingfang@zte.com.cn>
Subject: [PATCH v2] net: atm: Remove the error message according to the atomic context
Date:   Thu, 11 Jun 2020 08:38:50 +0800
Message-Id: <1591835930-25941-1-git-send-email-wang.yi59@zte.com.cn>
X-Mailer: git-send-email 1.8.3.1
X-MIMETrack: Itemize by SMTP Server on SZSMTP06/server/zte_ltd(Release 8.5.3FP6|November
 21, 2013) at 2020-06-11 08:37:10,
        Serialize by Router on notes_smtp/zte_ltd(Release 9.0.1FP7|August  17, 2016) at
 2020-06-11 08:36:48,
        Serialize complete at 2020-06-11 08:36:48
X-MAIL: mse-fl2.zte.com.cn 05B0aic2092194
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Liao Pingfang <liao.pingfang@zte.com.cn>

Looking into the context (atomic!) and the error message should be dropped.

Signed-off-by: Liao Pingfang <liao.pingfang@zte.com.cn>
---
Changes in v2: drop the error message instead of changing it.

 net/atm/lec.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/atm/lec.c b/net/atm/lec.c
index ca37f5a..997ce13 100644
--- a/net/atm/lec.c
+++ b/net/atm/lec.c
@@ -1537,7 +1537,6 @@ static struct lec_arp_table *make_entry(struct lec_priv *priv,
 
 	to_return = kzalloc(sizeof(struct lec_arp_table), GFP_ATOMIC);
 	if (!to_return) {
-		pr_info("LEC: Arp entry kmalloc failed\n");
 		return NULL;
 	}
 	ether_addr_copy(to_return->mac_addr, mac_addr);
-- 
2.9.5

