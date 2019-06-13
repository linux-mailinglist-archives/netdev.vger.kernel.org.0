Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2EF1F43B12
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 17:26:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727065AbfFMPZ6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 11:25:58 -0400
Received: from mx60.baidu.com ([61.135.168.60]:48988 "EHLO
        tc-sys-mailedm04.tc.baidu.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729015AbfFMLvC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jun 2019 07:51:02 -0400
X-Greylist: delayed 319 seconds by postgrey-1.27 at vger.kernel.org; Thu, 13 Jun 2019 07:51:01 EDT
Received: from localhost (cp01-cos-dev01.cp01.baidu.com [10.92.119.46])
        by tc-sys-mailedm04.tc.baidu.com (Postfix) with ESMTP id 734D4236C027;
        Thu, 13 Jun 2019 19:45:24 +0800 (CST)
From:   Li RongQing <lirongqing@baidu.com>
To:     steffen.klassert@secunet.com, netdev@vger.kernel.org
Subject: [PATCH] xfrm: remove empty xfrmi_init_net
Date:   Thu, 13 Jun 2019 19:45:24 +0800
Message-Id: <1560426324-5824-1-git-send-email-lirongqing@baidu.com>
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
 net/xfrm/xfrm_interface.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/net/xfrm/xfrm_interface.c b/net/xfrm/xfrm_interface.c
index 6be8c7df15bb..2c9c4108a426 100644
--- a/net/xfrm/xfrm_interface.c
+++ b/net/xfrm/xfrm_interface.c
@@ -782,11 +782,6 @@ static void __net_exit xfrmi_destroy_interfaces(struct xfrmi_net *xfrmn)
 	unregister_netdevice_many(&list);
 }
 
-static int __net_init xfrmi_init_net(struct net *net)
-{
-	return 0;
-}
-
 static void __net_exit xfrmi_exit_net(struct net *net)
 {
 	struct xfrmi_net *xfrmn = net_generic(net, xfrmi_net_id);
@@ -797,7 +792,6 @@ static void __net_exit xfrmi_exit_net(struct net *net)
 }
 
 static struct pernet_operations xfrmi_net_ops = {
-	.init = xfrmi_init_net,
 	.exit = xfrmi_exit_net,
 	.id   = &xfrmi_net_id,
 	.size = sizeof(struct xfrmi_net),
-- 
2.16.2

