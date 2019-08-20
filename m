Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 680FB95492
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 04:46:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728878AbfHTCqR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 22:46:17 -0400
Received: from mx139-tc.baidu.com ([61.135.168.139]:35013 "EHLO
        tc-sys-mailedm01.tc.baidu.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728669AbfHTCqR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Aug 2019 22:46:17 -0400
Received: from localhost (cp01-cos-dev01.cp01.baidu.com [10.92.119.46])
        by tc-sys-mailedm01.tc.baidu.com (Postfix) with ESMTP id B8533204005A
        for <netdev@vger.kernel.org>; Tue, 20 Aug 2019 10:46:00 +0800 (CST)
From:   Li RongQing <lirongqing@baidu.com>
To:     netdev@vger.kernel.org
Subject: [PATCH] net: fix icmp_socket_deliver argument 2 input
Date:   Tue, 20 Aug 2019 10:46:00 +0800
Message-Id: <1566269160-11031-1-git-send-email-lirongqing@baidu.com>
X-Mailer: git-send-email 1.7.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

it expects a unsigned int, but got a __be32

Signed-off-by: Li RongQing <lirongqing@baidu.com>
Signed-off-by: Zhang Yu <zhangyu31@baidu.com>
---
 net/ipv4/icmp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/icmp.c b/net/ipv4/icmp.c
index 1510e951f451..bf7b5d45de99 100644
--- a/net/ipv4/icmp.c
+++ b/net/ipv4/icmp.c
@@ -902,7 +902,7 @@ static bool icmp_redirect(struct sk_buff *skb)
 		return false;
 	}
 
-	icmp_socket_deliver(skb, icmp_hdr(skb)->un.gateway);
+	icmp_socket_deliver(skb, ntohl(icmp_hdr(skb)->un.gateway));
 	return true;
 }
 
-- 
2.16.2

