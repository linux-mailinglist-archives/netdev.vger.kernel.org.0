Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2BA6D1438C7
	for <lists+netdev@lfdr.de>; Tue, 21 Jan 2020 09:50:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729324AbgAUIuM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 03:50:12 -0500
Received: from out30-56.freemail.mail.aliyun.com ([115.124.30.56]:60457 "EHLO
        out30-56.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728783AbgAUIuK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jan 2020 03:50:10 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R861e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01f04455;MF=alex.shi@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0ToHY.4t_1579596608;
Received: from localhost(mailfrom:alex.shi@linux.alibaba.com fp:SMTPD_---0ToHY.4t_1579596608)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 21 Jan 2020 16:50:09 +0800
From:   Alex Shi <alex.shi@linux.alibaba.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] tcp/ipv4: remove AF_INET_FAMILY
Date:   Tue, 21 Jan 2020 16:50:07 +0800
Message-Id: <1579596607-258481-1-git-send-email-alex.shi@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After commit 079096f103fa ("tcp/dccp: install syn_recv requests into ehash table")
the macro isn't used anymore. remove it.

Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
Cc: "David S. Miller" <davem@davemloft.net> 
Cc: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru> 
Cc: Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org> 
Cc: netdev@vger.kernel.org 
Cc: linux-kernel@vger.kernel.org 
---
 net/ipv4/inet_connection_sock.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
index 18c0d5bffe12..ca22073cd500 100644
--- a/net/ipv4/inet_connection_sock.c
+++ b/net/ipv4/inet_connection_sock.c
@@ -610,12 +610,6 @@ struct dst_entry *inet_csk_route_child_sock(const struct sock *sk,
 }
 EXPORT_SYMBOL_GPL(inet_csk_route_child_sock);
 
-#if IS_ENABLED(CONFIG_IPV6)
-#define AF_INET_FAMILY(fam) ((fam) == AF_INET)
-#else
-#define AF_INET_FAMILY(fam) true
-#endif
-
 /* Decide when to expire the request and when to resend SYN-ACK */
 static inline void syn_ack_recalc(struct request_sock *req, const int thresh,
 				  const int max_retries,
-- 
1.8.3.1

