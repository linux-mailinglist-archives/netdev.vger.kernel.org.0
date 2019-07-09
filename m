Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5006F63A23
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 19:27:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726324AbfGIR1A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jul 2019 13:27:00 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:53998 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726133AbfGIR1A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jul 2019 13:27:00 -0400
Received: from Internal Mail-Server by MTLPINE2 (envelope-from parav@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 9 Jul 2019 20:26:57 +0300
Received: from sw-mtx-036.mtx.labs.mlnx (sw-mtx-036.mtx.labs.mlnx [10.12.150.149])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id x69HQtmK003792;
        Tue, 9 Jul 2019 20:26:56 +0300
From:   Parav Pandit <parav@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, jiri@mellanox.com, dsahern@kernel.org,
        Parav Pandit <parav@mellanox.com>
Subject: [PATCH net-next iproute2 v1] devlink: Show devlink port number
Date:   Tue,  9 Jul 2019 12:26:54 -0500
Message-Id: <20190709172654.24057-1-parav@mellanox.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20190709163352.20371-1-parav@mellanox.com>
References: <20190709163352.20371-1-parav@mellanox.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Show devlink port number whenever kernel reports that attribute.

An example output for a physical port.
$ devlink port show
pci/0000:06:00.1/65535: type eth netdev eth1_p1 flavour physical port 1

Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Parav Pandit <parav@mellanox.com>
---
Changelog:
v0->v1:
 - Declare and assign port_number as two different lines.
---
 devlink/devlink.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/devlink/devlink.c b/devlink/devlink.c
index 559f624e..c5491877 100644
--- a/devlink/devlink.c
+++ b/devlink/devlink.c
@@ -2806,6 +2806,12 @@ static void pr_out_port(struct dl *dl, struct nlattr **tb)
 
 		pr_out_str(dl, "flavour", port_flavour_name(port_flavour));
 	}
+	if (tb[DEVLINK_ATTR_PORT_NUMBER]) {
+		uint32_t port_number;
+
+		port_number = mnl_attr_get_u32(tb[DEVLINK_ATTR_PORT_NUMBER]);
+		pr_out_uint(dl, "port", port_number);
+	}
 	if (tb[DEVLINK_ATTR_PORT_SPLIT_GROUP])
 		pr_out_uint(dl, "split_group",
 			    mnl_attr_get_u32(tb[DEVLINK_ATTR_PORT_SPLIT_GROUP]));
-- 
2.19.2

