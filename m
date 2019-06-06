Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 501CF3734E
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 13:49:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727613AbfFFLt0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 07:49:26 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:52910 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727263AbfFFLt0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 07:49:26 -0400
Received: from Internal Mail-Server by MTLPINE2 (envelope-from parav@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 6 Jun 2019 14:49:22 +0300
Received: from sw-mtx-036.mtx.labs.mlnx (sw-mtx-036.mtx.labs.mlnx [10.12.150.149])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id x56BnKWG024644;
        Thu, 6 Jun 2019 14:49:21 +0300
From:   Parav Pandit <parav@mellanox.com>
To:     dsahern@gmail.com
Cc:     netdev@vger.kernel.org, stephen@networkplumber.org,
        jiri@mellanox.com, Parav Pandit <parav@mellanox.com>
Subject: [PATCH iproute2-next] devlink: Increase bus,device buffer size to 64 bytes
Date:   Thu,  6 Jun 2019 06:49:19 -0500
Message-Id: <20190606114919.27811-1-parav@mellanox.com>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Device name on mdev bus is 36 characters long which follow standard uuid
RFC 4122.
This is probably the longest name that a kernel will return for a
device.

Hence increase the buffer size to 64 bytes.

Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Parav Pandit <parav@mellanox.com>

---
 devlink/devlink.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/devlink/devlink.c b/devlink/devlink.c
index 436935f8..559f624e 100644
--- a/devlink/devlink.c
+++ b/devlink/devlink.c
@@ -1523,7 +1523,7 @@ static void __pr_out_handle_start(struct dl *dl, struct nlattr **tb,
 {
 	const char *bus_name = mnl_attr_get_str(tb[DEVLINK_ATTR_BUS_NAME]);
 	const char *dev_name = mnl_attr_get_str(tb[DEVLINK_ATTR_DEV_NAME]);
-	char buf[32];
+	char buf[64];
 
 	sprintf(buf, "%s/%s", bus_name, dev_name);
 
@@ -1616,7 +1616,7 @@ static void __pr_out_port_handle_start(struct dl *dl, const char *bus_name,
 				       uint32_t port_index, bool try_nice,
 				       bool array)
 {
-	static char buf[32];
+	static char buf[64];
 	char *ifname = NULL;
 
 	if (dl->no_nice_names || !try_nice ||
-- 
2.19.2

