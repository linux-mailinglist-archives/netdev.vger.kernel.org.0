Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B565AA350A
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 12:40:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728017AbfH3Kj6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Aug 2019 06:39:58 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:39610 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727603AbfH3Kj6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Aug 2019 06:39:58 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from parav@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 30 Aug 2019 13:39:52 +0300
Received: from sw-mtx-036.mtx.labs.mlnx (sw-mtx-036.mtx.labs.mlnx [10.12.150.149])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id x7UAdoIG005946;
        Fri, 30 Aug 2019 13:39:51 +0300
From:   Parav Pandit <parav@mellanox.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     jiri@mellanox.com, Parav Pandit <parav@mellanox.com>
Subject: [PATCH net-next 1/2] devlink: Make port index data type as unsigned int
Date:   Fri, 30 Aug 2019 05:39:44 -0500
Message-Id: <20190830103945.18097-2-parav@mellanox.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20190830103945.18097-1-parav@mellanox.com>
References: <20190830103945.18097-1-parav@mellanox.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Devlink port index attribute is returned to users as u32 through
netlink response.
Change index data type from 'unsigned' to 'unsigned int' to avoid
below checkpatch.pl warning.

WARNING: Prefer 'unsigned int' to bare use of 'unsigned'
81: FILE: include/net/devlink.h:81:
+       unsigned index;

Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Parav Pandit <parav@mellanox.com>
---
 include/net/devlink.h | 2 +-
 net/core/devlink.c    | 5 +++--
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/include/net/devlink.h b/include/net/devlink.h
index 7f43c48f54cd..13523b0a0642 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -75,7 +75,7 @@ struct devlink_port {
 	struct list_head list;
 	struct list_head param_list;
 	struct devlink *devlink;
-	unsigned index;
+	unsigned int index;
 	bool registered;
 	spinlock_t type_lock; /* Protects type and type_dev
 			       * pointer consistency.
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 650f36379203..b7091329987a 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -136,7 +136,7 @@ static struct devlink *devlink_get_from_info(struct genl_info *info)
 }
 
 static struct devlink_port *devlink_port_get_by_index(struct devlink *devlink,
-						      int port_index)
+						      unsigned int port_index)
 {
 	struct devlink_port *devlink_port;
 
@@ -147,7 +147,8 @@ static struct devlink_port *devlink_port_get_by_index(struct devlink *devlink,
 	return NULL;
 }
 
-static bool devlink_port_index_exists(struct devlink *devlink, int port_index)
+static bool devlink_port_index_exists(struct devlink *devlink,
+				      unsigned int port_index)
 {
 	return devlink_port_get_by_index(devlink, port_index);
 }
-- 
2.19.2

