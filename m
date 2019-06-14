Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD2C14512F
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 03:29:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726821AbfFNB3X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 21:29:23 -0400
Received: from mx139-tc.baidu.com ([61.135.168.139]:32205 "EHLO
        tc-sys-mailedm01.tc.baidu.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725616AbfFNB3X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jun 2019 21:29:23 -0400
Received: from localhost (cp01-cos-dev01.cp01.baidu.com [10.92.119.46])
        by tc-sys-mailedm01.tc.baidu.com (Postfix) with ESMTP id A0D32204004B
        for <netdev@vger.kernel.org>; Fri, 14 Jun 2019 09:29:09 +0800 (CST)
From:   Li RongQing <lirongqing@baidu.com>
To:     netdev@vger.kernel.org
Subject: [PATCH][net-next] net: remove empty netlink_tap_exit_net
Date:   Fri, 14 Jun 2019 09:29:09 +0800
Message-Id: <1560475749-13866-1-git-send-email-lirongqing@baidu.com>
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
 net/netlink/af_netlink.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index 718a97d5f1fd..9a2cd648d9c6 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -245,13 +245,8 @@ static __net_init int netlink_tap_init_net(struct net *net)
 	return 0;
 }
 
-static void __net_exit netlink_tap_exit_net(struct net *net)
-{
-}
-
 static struct pernet_operations netlink_tap_net_ops = {
 	.init = netlink_tap_init_net,
-	.exit = netlink_tap_exit_net,
 	.id   = &netlink_tap_net_id,
 	.size = sizeof(struct netlink_tap_net),
 };
-- 
2.16.2

