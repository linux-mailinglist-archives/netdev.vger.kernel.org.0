Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C53814FCDA
	for <lists+netdev@lfdr.de>; Sun,  2 Feb 2020 12:24:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726541AbgBBLXD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Feb 2020 06:23:03 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:41269 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725988AbgBBLXD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Feb 2020 06:23:03 -0500
Received: from Internal Mail-Server by MTLPINE2 (envelope-from raeds@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 2 Feb 2020 13:23:00 +0200
Received: from dev-l-vrt-074.mtl.labs.mlnx (dev-l-vrt-074.mtl.labs.mlnx [10.134.74.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 012BN0bK021033;
        Sun, 2 Feb 2020 13:23:00 +0200
From:   Raed Salem <raeds@mellanox.com>
To:     john.fastabend@gmail.com, daniel@iogearbox.net, kuba@kernel.org,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org, Raed Salem <raeds@mellanox.com>
Subject: [PATCH net] tls: handle NETDEV_UNREGISTER for tls device
Date:   Sun,  2 Feb 2020 13:22:52 +0200
Message-Id: <1580642572-21096-1-git-send-email-raeds@mellanox.com>
X-Mailer: git-send-email 1.9.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch to handle the asynchronous unregister
device event so the device tls offload resources
could be cleanly released.

Fixes: e8f69799810c ("net/tls: Add generic NIC offload infrastructure")
Signed-off-by: Raed Salem <raeds@mellanox.com>
Reviewed-by: Tariq Toukan <tariqt@mellanox.com>
Reviewed-by: Saeed Mahameed <saeedm@mellanox.com>
---
 net/tls/tls_device.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
index cd91ad8..bbd2a53 100644
--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -1246,6 +1246,7 @@ static int tls_dev_event(struct notifier_block *this, unsigned long event,
 		else
 			return NOTIFY_BAD;
 	case NETDEV_DOWN:
+	case NETDEV_UNREGISTER:
 		return tls_device_down(dev);
 	}
 	return NOTIFY_DONE;
-- 
1.9.4

