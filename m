Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0F881C03FA
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 19:37:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726517AbgD3RhL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 13:37:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726355AbgD3RhK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 13:37:10 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AABF4C035494
        for <netdev@vger.kernel.org>; Thu, 30 Apr 2020 10:37:10 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id e6so987536pjt.4
        for <netdev@vger.kernel.org>; Thu, 30 Apr 2020 10:37:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=GqdNFKrppA4lg731637DrQ9hb2ieBy3NSSpdjjmhTa4=;
        b=pJ4nWmuzW2HW5n8TZdmQzIOvhplC1JN6T+AgXWbqvxT7cLbyf0jh0BNHFGe4ByC4ZS
         dwVkbTvzV2hFHDz3tcq+gb/X1btf+FNbl/y/XZVyKbSe7gDlLyTLFTpyRpKQ4Z11skoK
         lH1xWxAB6vf8G/Rb3ayjQVJkMravwLu0Nf1ZRsgQvGi0Yg0eQ7vDzbzpswdEfxCYkXsb
         UPsqhytz+mQIn6zv46/TGGKZw6utD+l7/GLrhSRrK6QNAYn58SMgg0ONH7D3HJrmmdgV
         G/GCqkocs+QTZih6vBLwxblWhXysFJXCZGExWV1S9zzRox86f15iQrd5wWQlWoL4IZj/
         UMng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=GqdNFKrppA4lg731637DrQ9hb2ieBy3NSSpdjjmhTa4=;
        b=XJN3AX0/xj3AVG2Bo7dYIJ7zWZ1o/xBWJrN3b3C19lkiRawyRnSuVxKQLH8A9ZV1+Z
         v5ozkUDs9qrN7uuaQoy8AsSX0Xig5CwhsEFzM7wcDMOBpqrYCK8iq6K9YXR/osgaWVSk
         Ix8OZlYPSkfzQ/7Qx4JVFC6UQGkCbBISuRxcTqIBWHpYZwY2i1EVd7d3HDjA43xoz78a
         zFoaBBVlQjU/CGtzuKViwrodrJDgL/7B6xxRcLnSQW41Ml+QQQTgzjT1PINvO5JXNU20
         FAgDV0hy+8RD+P2N4rdMF/y8jDF4/tBUek8L9csCEsGst7hFBgwYkv6wiBJoW7afY0uP
         fmxg==
X-Gm-Message-State: AGi0PuZ0Pb8pD1TPJXn6dXo2wCz9SmuoCYNP+cHVsXJTZTfXP/Khj+04
        c+BulibqvR6Shh7by+plUt8=
X-Google-Smtp-Source: APiQypKbRvEW0LbZkQJzCvJaWW+EY98Z61IQX0PGfVBV0FgWjEX1QP40vPMSDx0x+fNnCpwXxR9V4g==
X-Received: by 2002:a17:90a:f985:: with SMTP id cq5mr4251738pjb.193.1588268230010;
        Thu, 30 Apr 2020 10:37:10 -0700 (PDT)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id d2sm360907pfc.7.2020.04.30.10.37.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Apr 2020 10:37:08 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com
Subject: [PATCH net-next] hsr: remove hsr interface if all slaves are removed
Date:   Thu, 30 Apr 2020 17:37:02 +0000
Message-Id: <20200430173702.20146-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When all hsr slave interfaces are removed, hsr interface doesn't work.
At that moment, it's fine to remove an unused hsr interface automatically
for saving resources.
That's a common behavior of virtual interfaces.

Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 net/hsr/hsr_main.c | 22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

diff --git a/net/hsr/hsr_main.c b/net/hsr/hsr_main.c
index 26d6c39f24e1..e2564de67603 100644
--- a/net/hsr/hsr_main.c
+++ b/net/hsr/hsr_main.c
@@ -15,12 +15,23 @@
 #include "hsr_framereg.h"
 #include "hsr_slave.h"
 
+static bool hsr_slave_empty(struct hsr_priv *hsr)
+{
+	struct hsr_port *port;
+
+	hsr_for_each_port(hsr, port)
+		if (port->type != HSR_PT_MASTER)
+			return false;
+	return true;
+}
+
 static int hsr_netdev_notify(struct notifier_block *nb, unsigned long event,
 			     void *ptr)
 {
-	struct net_device *dev;
 	struct hsr_port *port, *master;
+	struct net_device *dev;
 	struct hsr_priv *hsr;
+	LIST_HEAD(list_kill);
 	int mtu_max;
 	int res;
 
@@ -85,8 +96,15 @@ static int hsr_netdev_notify(struct notifier_block *nb, unsigned long event,
 		master->dev->mtu = mtu_max;
 		break;
 	case NETDEV_UNREGISTER:
-		if (!is_hsr_master(dev))
+		if (!is_hsr_master(dev)) {
+			master = hsr_port_get_hsr(port->hsr, HSR_PT_MASTER);
 			hsr_del_port(port);
+			if (hsr_slave_empty(master->hsr)) {
+				unregister_netdevice_queue(master->dev,
+							   &list_kill);
+				unregister_netdevice_many(&list_kill);
+			}
+		}
 		break;
 	case NETDEV_PRE_TYPE_CHANGE:
 		/* HSR works only on Ethernet devices. Refuse slave to change
-- 
2.17.1

