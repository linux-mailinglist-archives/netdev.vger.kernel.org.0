Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4111A92324
	for <lists+netdev@lfdr.de>; Mon, 19 Aug 2019 14:11:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727496AbfHSMLP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 08:11:15 -0400
Received: from mx132-tc.baidu.com ([61.135.168.132]:59758 "EHLO
        tc-sys-mailedm03.tc.baidu.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726491AbfHSMLP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Aug 2019 08:11:15 -0400
X-Greylist: delayed 346 seconds by postgrey-1.27 at vger.kernel.org; Mon, 19 Aug 2019 08:11:14 EDT
Received: from localhost (cp01-cos-dev01.cp01.baidu.com [10.92.119.46])
        by tc-sys-mailedm03.tc.baidu.com (Postfix) with ESMTP id 8D4604500040
        for <netdev@vger.kernel.org>; Mon, 19 Aug 2019 20:05:15 +0800 (CST)
From:   Li RongQing <lirongqing@baidu.com>
To:     netdev@vger.kernel.org
Subject: [PATCH][net-next] net: remove empty inet_exit_net
Date:   Mon, 19 Aug 2019 20:05:15 +0800
Message-Id: <1566216315-18506-1-git-send-email-lirongqing@baidu.com>
X-Mailer: git-send-email 1.7.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Pointer members of an object with static storage duration, if not
explicitly initialized, will be initialized to a NULL pointer. The
net namespace API checks if this pointer is not NULL before using it,
it are safe to remove the function.

Signed-off-by: Li RongQing <lirongqing@baidu.com>
---
 net/ipv4/af_inet.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
index ed2301ef872e..70f92aaca411 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -1845,13 +1845,8 @@ static __net_init int inet_init_net(struct net *net)
 	return 0;
 }
 
-static __net_exit void inet_exit_net(struct net *net)
-{
-}
-
 static __net_initdata struct pernet_operations af_inet_ops = {
 	.init = inet_init_net,
-	.exit = inet_exit_net,
 };
 
 static int __init init_inet_pernet_ops(void)
-- 
2.16.2

