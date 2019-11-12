Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B03DFF8F43
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 13:08:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727140AbfKLMIL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 07:08:11 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:58213 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726979AbfKLMIK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 07:08:10 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from ayal@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 12 Nov 2019 14:08:08 +0200
Received: from dev-l-vrt-210.mtl.labs.mlnx (dev-l-vrt-210.mtl.labs.mlnx [10.134.210.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id xACC88mE029869;
        Tue, 12 Nov 2019 14:08:08 +0200
Received: from dev-l-vrt-210.mtl.labs.mlnx (localhost [127.0.0.1])
        by dev-l-vrt-210.mtl.labs.mlnx (8.15.2/8.15.2/Debian-8ubuntu1) with ESMTP id xACC87QE004242;
        Tue, 12 Nov 2019 14:08:07 +0200
Received: (from ayal@localhost)
        by dev-l-vrt-210.mtl.labs.mlnx (8.15.2/8.15.2/Submit) id xACC87Tn004241;
        Tue, 12 Nov 2019 14:08:07 +0200
From:   Aya Levin <ayal@mellanox.com>
To:     David Miller <davem@davemloft.net>, Jiri Pirko <jiri@mellanox.com>
Cc:     netdev@vger.kernel.org, Aya Levin <ayal@mellanox.com>
Subject: [PATCH net-next 3/4] netdevsim: Update dummy reporter's devlink binary interface
Date:   Tue, 12 Nov 2019 14:07:51 +0200
Message-Id: <1573560472-4187-4-git-send-email-ayal@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1573560472-4187-1-git-send-email-ayal@mellanox.com>
References: <1573560472-4187-1-git-send-email-ayal@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update dummy reporter's output to use updated devlink interface of
binary fmsg pair.

Signed-off-by: Aya Levin <ayal@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 drivers/net/netdevsim/health.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/net/netdevsim/health.c b/drivers/net/netdevsim/health.c
index 2716235a0336..9aa637d162eb 100644
--- a/drivers/net/netdevsim/health.c
+++ b/drivers/net/netdevsim/health.c
@@ -82,18 +82,12 @@ static int nsim_dev_dummy_fmsg_put(struct devlink_fmsg *fmsg, u32 binary_len)
 	if (err)
 		return err;
 
-	err = devlink_fmsg_arr_pair_nest_start(fmsg, "test_binary");
-	if (err)
-		return err;
 	binary = kmalloc(binary_len, GFP_KERNEL);
 	if (!binary)
 		return -ENOMEM;
 	get_random_bytes(binary, binary_len);
-	err = devlink_fmsg_binary_put(fmsg, binary, binary_len);
+	err = devlink_fmsg_binary_pair_put(fmsg, "test_binary", binary, binary_len);
 	kfree(binary);
-	if (err)
-		return err;
-	err = devlink_fmsg_arr_pair_nest_end(fmsg);
 	if (err)
 		return err;
 
-- 
2.14.1

