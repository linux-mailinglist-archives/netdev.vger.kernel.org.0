Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08BB32D8DEF
	for <lists+netdev@lfdr.de>; Sun, 13 Dec 2020 15:27:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729699AbgLMOZ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Dec 2020 09:25:56 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:56704 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729036AbgLMOZ4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Dec 2020 09:25:56 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from tariqt@nvidia.com)
        with SMTP; 13 Dec 2020 16:25:08 +0200
Received: from dev-l-vrt-206-005.mtl.labs.mlnx (dev-l-vrt-206-005.mtl.labs.mlnx [10.234.206.5])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 0BDEP8u1013765;
        Sun, 13 Dec 2020 16:25:08 +0200
From:   Tariq Toukan <tariqt@nvidia.com>
To:     "John W . Linville" <linville@tuxdriver.com>
Cc:     netdev@vger.kernel.org, Roy Novich <royno@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>
Subject: [PATCH ethtool] ethtool: do_sset return correct value on fail
Date:   Sun, 13 Dec 2020 16:25:03 +0200
Message-Id: <20201213142503.25509-1-tariqt@nvidia.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roy Novich <royno@nvidia.com>

The return value for do_sset was constant and returned 0.
This value is misleading when returned on operation failure.
Changed return value to the correct function err status.

Fixes: 32c8037055f5 ("Initial import of ethtool version 3 + a few patches.")
Signed-off-by: Roy Novich <royno@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 ethtool.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/ethtool.c b/ethtool.c
index 1d9067e774af..5cc875c64591 100644
--- a/ethtool.c
+++ b/ethtool.c
@@ -3287,7 +3287,7 @@ static int do_sset(struct cmd_context *ctx)
 		}
 	}
 
-	return 0;
+	return err;
 }
 
 static int do_gregs(struct cmd_context *ctx)
-- 
2.21.0

