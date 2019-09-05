Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96248AA366
	for <lists+netdev@lfdr.de>; Thu,  5 Sep 2019 14:43:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389455AbfIEMn3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Sep 2019 08:43:29 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:58415 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2389447AbfIEMn3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Sep 2019 08:43:29 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from tariqt@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 5 Sep 2019 15:43:23 +0300
Received: from dev-l-vrt-207-011.mtl.labs.mlnx. (dev-l-vrt-207-011.mtl.labs.mlnx [10.134.207.11])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id x85ChNGb021437;
        Thu, 5 Sep 2019 15:43:23 +0300
From:   Tariq Toukan <tariqt@mellanox.com>
To:     Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@gmail.com>
Cc:     netdev@vger.kernel.org, Moshe Shemesh <moshe@mellanox.com>,
        Aya Levin <ayal@mellanox.com>, Jiri Pirko <jiri@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>
Subject: [PATCH iproute2 4/4] devlink: Fix devlink health set command
Date:   Thu,  5 Sep 2019 15:43:07 +0300
Message-Id: <1567687387-12993-5-git-send-email-tariqt@mellanox.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1567687387-12993-1-git-send-email-tariqt@mellanox.com>
References: <1567687387-12993-1-git-send-email-tariqt@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@mellanox.com>

Prior to this patch both the reporter's name and the grace period
attributes shared the same bit. This caused zeroing grace period when
setting auto recovery. Let each parameter has its own bit.

Fixes: b18d89195b16 ("devlink: Add devlink health set command")
Signed-off-by: Aya Levin <ayal@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
---
 devlink/devlink.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/devlink/devlink.c b/devlink/devlink.c
index 722b6a101673..306abfb5222b 100644
--- a/devlink/devlink.c
+++ b/devlink/devlink.c
@@ -231,11 +231,11 @@ static void ifname_map_free(struct ifname_map *ifname_map)
 #define DL_OPT_FLASH_FILE_NAME	BIT(25)
 #define DL_OPT_FLASH_COMPONENT	BIT(26)
 #define DL_OPT_HEALTH_REPORTER_NAME	BIT(27)
-#define DL_OPT_HEALTH_REPORTER_GRACEFUL_PERIOD	BIT(27)
-#define DL_OPT_HEALTH_REPORTER_AUTO_RECOVER	BIT(28)
+#define DL_OPT_HEALTH_REPORTER_GRACEFUL_PERIOD	BIT(28)
 #define DL_OPT_TRAP_NAME		BIT(29)
 #define DL_OPT_TRAP_ACTION		BIT(30)
 #define DL_OPT_TRAP_GROUP_NAME		BIT(31)
+#define DL_OPT_HEALTH_REPORTER_AUTO_RECOVER	BIT(32)
 
 struct dl_opts {
 	uint64_t present; /* flags of present items */
-- 
1.8.3.1

