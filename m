Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B097609F9
	for <lists+netdev@lfdr.de>; Fri,  5 Jul 2019 18:06:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727353AbfGEQGd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jul 2019 12:06:33 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:39676 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725763AbfGEQGd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Jul 2019 12:06:33 -0400
Received: by mail-pg1-f194.google.com with SMTP id u17so4018967pgi.6
        for <netdev@vger.kernel.org>; Fri, 05 Jul 2019 09:06:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=Ce9j80NwzrkR31TIPbEbmPnK/2+x4q195ROBtub58H4=;
        b=BOtyECsdgq8aZHcjT1+9cPwar/PLRpgL8knQGsfWzWpgjEOWGlbiQ5nRTJyys17SCq
         aitMcXQGqIeKrC5i7VAfQJz5nGQ5+NglkGD3ITNxEod/S2bBqpayA88SVGL583GruKhr
         elnEPUBuVpaTJfdVspJh3bymIN1Ri8oP0XgJZly3UFd6cQdnTZQltC+Yc82f4X5qVf0+
         qDeAvzZbxNEOILd85iSDv+rrvHyqZrLQleU4C5eSf1O//tkSwzDiabiRWUgF0sVxWkJd
         l2+rcLq/gl1F6wxg3Jr7DsWH6WaX5hOSJWZr9cdDXw4foD6nBXO0CetddJ92j0RH87sk
         q0rA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Ce9j80NwzrkR31TIPbEbmPnK/2+x4q195ROBtub58H4=;
        b=kaxVyDwNqbGhfpqbf4iHaiLgU+o+BPNbGYu00KoQRMRfLuSDbD4EgrG3mYmjEfanRN
         hEGNQgpABiHWtIzlLHWw762bLuT2pRTQPf8jt06sF4KrM27y0/A+jjH6hPoHeoFnqIT/
         zyb26duci9IhoRAKPpiNYGSgfqEROeWd5sNTDN4Bz1rLm7bZdHrMEZGvPxtR/YA1FPHr
         P87YZ4KXewan9T1ksDweDtMyZ+JnsLU6QRS6VZV73HRO0go7swq32CTvc1FL6DiwA+tL
         /3dw8IV20ATXq36d5sflyaIB1qr1BP7jfspXaL4T7FBuD9w0ZrQi4XbDdaXFIWVfncrh
         KUhA==
X-Gm-Message-State: APjAAAWqKy0Xr9udUCyD+6AZQPic9DtpfcdrcdoyA4QgahSvhid+oM+I
        Qcy8HIXB4YeGkBDH34kaZvm6leca0k8=
X-Google-Smtp-Source: APXvYqx1k4Y6+mboi8AqSryhzenGCJdnTGj331l1JKKcStcCfmEYg23GfLTjFUXLDBMVy7FksAqaPw==
X-Received: by 2002:a63:4c19:: with SMTP id z25mr3037293pga.47.1562342792156;
        Fri, 05 Jul 2019 09:06:32 -0700 (PDT)
Received: from ap-To-be-filled-by-O-E-M.8.8.8.8 ([14.33.120.60])
        by smtp.gmail.com with ESMTPSA id n140sm9580747pfd.132.2019.07.05.09.06.29
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 05 Jul 2019 09:06:31 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, pshelar@ovn.org, netdev@vger.kernel.org,
        dev@openvswitch.org
Cc:     ap420073@gmail.com
Subject: [PATCH net-next] net: openvswitch: use netif_ovs_is_port() instead of opencode
Date:   Sat,  6 Jul 2019 01:05:46 +0900
Message-Id: <20190705160546.4847-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use netif_ovs_is_port() function instead of open code.
This patch doesn't change logic.

Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 net/openvswitch/dp_notify.c    | 2 +-
 net/openvswitch/vport-netdev.c | 6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/openvswitch/dp_notify.c b/net/openvswitch/dp_notify.c
index 53cf07d141b4..7af0cde8b293 100644
--- a/net/openvswitch/dp_notify.c
+++ b/net/openvswitch/dp_notify.c
@@ -48,7 +48,7 @@ void ovs_dp_notify_wq(struct work_struct *work)
 				if (vport->ops->type == OVS_VPORT_TYPE_INTERNAL)
 					continue;
 
-				if (!(vport->dev->priv_flags & IFF_OVS_DATAPATH))
+				if (!(netif_is_ovs_port(vport->dev)))
 					dp_detach_port_notify(vport);
 			}
 		}
diff --git a/net/openvswitch/vport-netdev.c b/net/openvswitch/vport-netdev.c
index 52a1ed9633ec..57d6436e6f6a 100644
--- a/net/openvswitch/vport-netdev.c
+++ b/net/openvswitch/vport-netdev.c
@@ -156,7 +156,7 @@ void ovs_netdev_detach_dev(struct vport *vport)
 static void netdev_destroy(struct vport *vport)
 {
 	rtnl_lock();
-	if (vport->dev->priv_flags & IFF_OVS_DATAPATH)
+	if (netif_is_ovs_port(vport->dev))
 		ovs_netdev_detach_dev(vport);
 	rtnl_unlock();
 
@@ -166,7 +166,7 @@ static void netdev_destroy(struct vport *vport)
 void ovs_netdev_tunnel_destroy(struct vport *vport)
 {
 	rtnl_lock();
-	if (vport->dev->priv_flags & IFF_OVS_DATAPATH)
+	if (netif_is_ovs_port(vport->dev))
 		ovs_netdev_detach_dev(vport);
 
 	/* We can be invoked by both explicit vport deletion and
@@ -186,7 +186,7 @@ EXPORT_SYMBOL_GPL(ovs_netdev_tunnel_destroy);
 /* Returns null if this device is not attached to a datapath. */
 struct vport *ovs_netdev_get_vport(struct net_device *dev)
 {
-	if (likely(dev->priv_flags & IFF_OVS_DATAPATH))
+	if (likely(netif_is_ovs_port(dev)))
 		return (struct vport *)
 			rcu_dereference_rtnl(dev->rx_handler_data);
 	else
-- 
2.17.1

