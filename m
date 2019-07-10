Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8AE2C6458A
	for <lists+netdev@lfdr.de>; Wed, 10 Jul 2019 13:03:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727231AbfGJLDf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jul 2019 07:03:35 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:54918 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727110AbfGJLDe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jul 2019 07:03:34 -0400
Received: from Internal Mail-Server by MTLPINE2 (envelope-from tariqt@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 10 Jul 2019 14:03:30 +0300
Received: from dev-l-vrt-206-006.mtl.labs.mlnx (dev-l-vrt-206-006.mtl.labs.mlnx [10.134.206.6])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id x6AB3US1020650;
        Wed, 10 Jul 2019 14:03:30 +0300
From:   Tariq Toukan <tariqt@mellanox.com>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org, moshe@mellanox.com, ayal@mellanox.com,
        Tariq Toukan <tariqt@mellanox.com>
Subject: [PATCH iproute2 master 3/3] devlink: Remove enclosing array brackets binary print with json format
Date:   Wed, 10 Jul 2019 14:03:21 +0300
Message-Id: <1562756601-19171-4-git-send-email-tariqt@mellanox.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1562756601-19171-1-git-send-email-tariqt@mellanox.com>
References: <1562756601-19171-1-git-send-email-tariqt@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@mellanox.com>

Keep pr_out_binary_value function only for printing. Inner relations
like array grouping should be done outside the function.

Fixes: 844a61764c6f ("devlink: Add helper functions for name and value separately")
Signed-off-by: Aya Levin <ayal@mellanox.com>
Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
---
 devlink/devlink.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/devlink/devlink.c b/devlink/devlink.c
index 4bced4e60ae8..7532c3f888f9 100644
--- a/devlink/devlink.c
+++ b/devlink/devlink.c
@@ -1788,9 +1788,6 @@ static void pr_out_binary_value(struct dl *dl, uint8_t *data, uint32_t len)
 {
 	int i = 0;
 
-	if (dl->json_output)
-		jsonw_start_array(dl->jw);
-
 	while (i < len) {
 		if (dl->json_output)
 			jsonw_printf(dl->jw, "%d", data[i]);
@@ -1800,9 +1797,7 @@ static void pr_out_binary_value(struct dl *dl, uint8_t *data, uint32_t len)
 		if (!dl->json_output && is_binary_eol(i))
 			__pr_out_newline();
 	}
-	if (dl->json_output)
-		jsonw_end_array(dl->jw);
-	else if (!is_binary_eol(i))
+	if (!dl->json_output && !is_binary_eol(i))
 		__pr_out_newline();
 }
 
-- 
1.8.3.1

