Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2FB52297A2
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 13:45:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726462AbgGVLpN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 07:45:13 -0400
Received: from vinduvvm.duvert.net ([91.224.149.70]:44326 "EHLO
        vinduvvm.duvert.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726161AbgGVLpM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 07:45:12 -0400
X-Greylist: delayed 410 seconds by postgrey-1.27 at vger.kernel.org; Wed, 22 Jul 2020 07:45:11 EDT
Received: from home.duvert.net (152.60.68.91.rev.sfr.net [91.68.60.152])
        by vinduvvm.duvert.net (Postfix) with ESMTPSA id DB11672FAD
        for <netdev@vger.kernel.org>; Wed, 22 Jul 2020 13:38:19 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=duvert.net;
        s=vinduvmail; t=1595417899;
        bh=vkAb9Z8GrA+OxmouJVHm0egJVQWG/TaYqNa+WfCPY74=;
        h=From:To:Cc:Subject:Date:From;
        b=D/Bm0NiEsSYW4v76G6/2zfwtMp7FTigK7AXaxuACHPzYgn6oF4Ef/XRjUyhHsE7sr
         93/4z+Zh8z2ibAvjv+hycaVhvydHtT2WrC2D7iEFymcqckhPkrF2VhupCehFNKbzTM
         xVd/GxXHZVm9/c/DxYon6m6ydARqzN1wpQ35AoU4=
Received: from vincent (uid 1000)
        (envelope-from vincent@home.duvert.net)
        id 91e20
        by home.duvert.net (DragonFly Mail Agent v0.11);
        Wed, 22 Jul 2020 13:38:19 +0200
From:   Vincent Duvert <vincent.ldev@duvert.net>
To:     netdev@vger.kernel.org
Cc:     Vincent Duvert <vincent.ldev@duvert.net>
Subject: [PATCH 1/2] appletalk: Fix atalk_proc_init return path
Date:   Wed, 22 Jul 2020 13:37:51 +0200
Message-Id: <20200722113752.1218-1-vincent.ldev@duvert.net>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a missing return statement to atalk_proc_init so it doesn't return
-ENOMEM when successful. This allows the appletalk module to load
properly.

Signed-off-by: Vincent Duvert <vincent.ldev@duvert.net>
---
 net/appletalk/atalk_proc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/appletalk/atalk_proc.c b/net/appletalk/atalk_proc.c
index 550c6ca007cc..9c1241292d1d 100644
--- a/net/appletalk/atalk_proc.c
+++ b/net/appletalk/atalk_proc.c
@@ -229,6 +229,8 @@ int __init atalk_proc_init(void)
 				     sizeof(struct aarp_iter_state), NULL))
 		goto out;
 
+	return 0;
+
 out:
 	remove_proc_subtree("atalk", init_net.proc_net);
 	return -ENOMEM;
-- 
2.20.1

