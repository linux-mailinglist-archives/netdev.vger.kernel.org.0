Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 593791C5708
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 15:34:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728965AbgEENeE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 09:34:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728892AbgEENeE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 09:34:04 -0400
Received: from xavier.telenet-ops.be (xavier.telenet-ops.be [IPv6:2a02:1800:120:4::f00:14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CD9DC061A0F
        for <netdev@vger.kernel.org>; Tue,  5 May 2020 06:34:04 -0700 (PDT)
Received: from ramsan ([IPv6:2a02:1810:ac12:ed60:bd97:8453:3b10:1832])
        by xavier.telenet-ops.be with bizsmtp
        id b1a2220043VwRR3011a2jH; Tue, 05 May 2020 15:34:02 +0200
Received: from rox.of.borg ([192.168.97.57])
        by ramsan with esmtp (Exim 4.90_1)
        (envelope-from <geert@linux-m68k.org>)
        id 1jVxhy-00085f-EG; Tue, 05 May 2020 15:34:02 +0200
Received: from geert by rox.of.borg with local (Exim 4.90_1)
        (envelope-from <geert@linux-m68k.org>)
        id 1jVxhy-0006i0-Bc; Tue, 05 May 2020 15:34:02 +0200
From:   Geert Uytterhoeven <geert+renesas@glider.be>
To:     "David S . Miller" <davem@davemloft.net>,
        Vishal Kulkarni <vishal@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH resend] cxgb4/cxgb4vf: Remove superfluous void * cast in debugfs_create_file() call
Date:   Tue,  5 May 2020 15:34:00 +0200
Message-Id: <20200505133400.25747-1-geert+renesas@glider.be>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is no need to cast a typed pointer to a void pointer when calling
a function that accepts the latter.  Remove it, as the cast prevents
further compiler checks.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c b/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c
index 9cc3541a7e1cbca5..cec865a97464d292 100644
--- a/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c
@@ -2480,7 +2480,7 @@ static int setup_debugfs(struct adapter *adapter)
 	for (i = 0; i < ARRAY_SIZE(debugfs_files); i++)
 		debugfs_create_file(debugfs_files[i].name,
 				    debugfs_files[i].mode,
-				    adapter->debugfs_root, (void *)adapter,
+				    adapter->debugfs_root, adapter,
 				    debugfs_files[i].fops);
 
 	return 0;
-- 
2.17.1

