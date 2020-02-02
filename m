Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38F6A14FCD8
	for <lists+netdev@lfdr.de>; Sun,  2 Feb 2020 12:20:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726342AbgBBLTv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Feb 2020 06:19:51 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:35857 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725995AbgBBLTv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Feb 2020 06:19:51 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from raeds@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 2 Feb 2020 13:19:48 +0200
Received: from dev-l-vrt-074.mtl.labs.mlnx (dev-l-vrt-074.mtl.labs.mlnx [10.134.74.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 012BJmZE019048;
        Sun, 2 Feb 2020 13:19:48 +0200
From:   Raed Salem <raeds@mellanox.com>
To:     steffen.klassert@secunet.com
Cc:     netdev@vger.kernel.org, Raed Salem <raeds@mellanox.com>
Subject: [PATCH net] xfrm: handle NETDEV_UNREGISTER for xfrm device
Date:   Sun,  2 Feb 2020 13:19:34 +0200
Message-Id: <1580642374-20942-1-git-send-email-raeds@mellanox.com>
X-Mailer: git-send-email 1.9.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch to handle the asynchronous unregister
device event so the device IPsec offload resources
could be cleanly released.

Fixes: e4db5b61c572 ("xfrm: policy: remove pcpu policy cache")
Signed-off-by: Raed Salem <raeds@mellanox.com>
Reviewed-by: Boris Pismenny <borisp@mellanox.com>
Reviewed-by: Saeed Mahameed <saeedm@mellanox.com>
---
 net/xfrm/xfrm_device.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/xfrm/xfrm_device.c b/net/xfrm/xfrm_device.c
index 189ef15..64486ad 100644
--- a/net/xfrm/xfrm_device.c
+++ b/net/xfrm/xfrm_device.c
@@ -390,6 +390,7 @@ static int xfrm_dev_event(struct notifier_block *this, unsigned long event, void
 		return xfrm_dev_feat_change(dev);
 
 	case NETDEV_DOWN:
+	case NETDEV_UNREGISTER:
 		return xfrm_dev_down(dev);
 	}
 	return NOTIFY_DONE;
-- 
1.9.4

