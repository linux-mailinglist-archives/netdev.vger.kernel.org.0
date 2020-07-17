Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4FD4223517
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 09:02:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726817AbgGQHCk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 03:02:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726113AbgGQHCj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jul 2020 03:02:39 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84899C061755
        for <netdev@vger.kernel.org>; Fri, 17 Jul 2020 00:02:39 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id a24so4958538pfc.10
        for <netdev@vger.kernel.org>; Fri, 17 Jul 2020 00:02:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=PHgct3BLFUnmK+uj3RXSG9QsRywzralM8BpHXCvrWEY=;
        b=J9/0j56GUQH6KbzUoZeyn/t6Ex3ZodQWsD0sbtS3AezoVbP/9LVHPMYjyycCQZ5TPe
         7j1QXQ9lSjtRa2TAgSfAEXxXbi/md4kikB7f2CZdl8CHzcRB5KYp7K5AwJPhCSLOsZS/
         zU2Kc4KBvFSktlDWSC49QKvqpOe/QeNmddrcW4duod9QeS3ExbtRy7vfMmVyfCVvUH4p
         48XMdAFZmu8BhkCy07Zt/Cs0KGjW1WgoNn1I9szgTtIpy9rIkKi0tW5NOsQz9vcspDta
         UfQeGkUs6ndR6QXJiUirhgW7iFLGW6z2yO7D8KLTn4SFu8PIlEbNLtwcylyRBMk5mA3Q
         FueA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=PHgct3BLFUnmK+uj3RXSG9QsRywzralM8BpHXCvrWEY=;
        b=t4GrzK0xGzK0qPRkplDqx1Sdf2Kk2AKzqQGrODT6Jp+pLlq6FAlvUyWdJBjJeAtfvl
         6whShG+lexOQvj/03BT5NqQZJC+karKKKOVX/j5aU2k2a4dLUv1VwuOTla2LhuRtHCjx
         pMM/fZLB3IH6g21zUaT+i+tKNU1rkMyktSRTW3dsIOZATN0S/5MjTD24L7f5TbD4ODIV
         jIzfJnckHQ6XcZzl4n8TyqttH+Kvdy08aOh8Xiar37zLspx8o7pqmD2pIDICoFWhX8+b
         inD/QKfucfCiDLW5WyrnygB8z1DxGz4WLzJr+Y2pd8iLEj4O+YUSOatVSpoIfVnsx22l
         4glw==
X-Gm-Message-State: AOAM532kOTSwHJYm7NeUnwE8ly8pBfhy8QtIK6ggIxFYVeAm+nSKjNjd
        /MC9ov0BinmvUZdSJ5QyeCb3dIj1
X-Google-Smtp-Source: ABdhPJyXy7f1g4EkvCUDBpYMZzuRn6FnYPCkL7NgWag4RC7gFyLncNFZ8y+cZ8i0Mp4qTZjO97+DVA==
X-Received: by 2002:a63:3ec4:: with SMTP id l187mr7313279pga.371.1594969358414;
        Fri, 17 Jul 2020 00:02:38 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id y7sm6436472pfq.69.2020.07.17.00.02.37
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 17 Jul 2020 00:02:37 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     kbuild test robot <lkp@intel.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH ipsec-next] xfrm: interface: use IS_REACHABLE to avoid some compile errors
Date:   Fri, 17 Jul 2020 15:02:30 +0800
Message-Id: <b1bb348efd21f1567164adb33c39d6c3d55b0c65.1594969350.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

kernel test robot reported some compile errors:

  ia64-linux-ld: net/xfrm/xfrm_interface.o: in function `xfrmi4_fini':
  net/xfrm/xfrm_interface.c:900: undefined reference to `xfrm4_tunnel_deregister'
  ia64-linux-ld: net/xfrm/xfrm_interface.c:901: undefined reference to `xfrm4_tunnel_deregister'
  ia64-linux-ld: net/xfrm/xfrm_interface.o: in function `xfrmi4_init':
  net/xfrm/xfrm_interface.c:873: undefined reference to `xfrm4_tunnel_register'
  ia64-linux-ld: net/xfrm/xfrm_interface.c:876: undefined reference to `xfrm4_tunnel_register'
  ia64-linux-ld: net/xfrm/xfrm_interface.c:885: undefined reference to `xfrm4_tunnel_deregister'

This happened when set CONFIG_XFRM_INTERFACE=y and CONFIG_INET_TUNNEL=m.
We don't really want xfrm_interface to depend inet_tunnel completely,
but only to disable the tunnel code when inet_tunnel is not seen.

So instead of adding "select INET_TUNNEL" for XFRM_INTERFACE, this patch
is only to change to IS_REACHABLE to avoid these compile error.

Reported-by: kernel test robot <lkp@intel.com>
Fixes: da9bbf0598c9 ("xfrm: interface: support IPIP and IPIP6 tunnels processing with .cb_handler")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/xfrm/xfrm_interface.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/net/xfrm/xfrm_interface.c b/net/xfrm/xfrm_interface.c
index 63a52b4..4c904d3 100644
--- a/net/xfrm/xfrm_interface.c
+++ b/net/xfrm/xfrm_interface.c
@@ -812,7 +812,7 @@ static struct xfrm6_protocol xfrmi_ipcomp6_protocol __read_mostly = {
 	.priority	=	10,
 };
 
-#if IS_ENABLED(CONFIG_INET6_XFRM_TUNNEL)
+#if IS_REACHABLE(CONFIG_INET6_XFRM_TUNNEL)
 static int xfrmi6_rcv_tunnel(struct sk_buff *skb)
 {
 	const xfrm_address_t *saddr;
@@ -863,7 +863,7 @@ static struct xfrm4_protocol xfrmi_ipcomp4_protocol __read_mostly = {
 	.priority	=	10,
 };
 
-#if IS_ENABLED(CONFIG_INET_XFRM_TUNNEL)
+#if IS_REACHABLE(CONFIG_INET_XFRM_TUNNEL)
 static int xfrmi4_rcv_tunnel(struct sk_buff *skb)
 {
 	return xfrm4_rcv_spi(skb, IPPROTO_IPIP, ip_hdr(skb)->saddr);
@@ -897,7 +897,7 @@ static int __init xfrmi4_init(void)
 	err = xfrm4_protocol_register(&xfrmi_ipcomp4_protocol, IPPROTO_COMP);
 	if (err < 0)
 		goto xfrm_proto_comp_failed;
-#if IS_ENABLED(CONFIG_INET_XFRM_TUNNEL)
+#if IS_REACHABLE(CONFIG_INET_XFRM_TUNNEL)
 	err = xfrm4_tunnel_register(&xfrmi_ipip_handler, AF_INET);
 	if (err < 0)
 		goto xfrm_tunnel_ipip_failed;
@@ -908,7 +908,7 @@ static int __init xfrmi4_init(void)
 
 	return 0;
 
-#if IS_ENABLED(CONFIG_INET_XFRM_TUNNEL)
+#if IS_REACHABLE(CONFIG_INET_XFRM_TUNNEL)
 xfrm_tunnel_ipip6_failed:
 	xfrm4_tunnel_deregister(&xfrmi_ipip_handler, AF_INET);
 xfrm_tunnel_ipip_failed:
@@ -924,7 +924,7 @@ static int __init xfrmi4_init(void)
 
 static void xfrmi4_fini(void)
 {
-#if IS_ENABLED(CONFIG_INET_XFRM_TUNNEL)
+#if IS_REACHABLE(CONFIG_INET_XFRM_TUNNEL)
 	xfrm4_tunnel_deregister(&xfrmi_ipip6_handler, AF_INET6);
 	xfrm4_tunnel_deregister(&xfrmi_ipip_handler, AF_INET);
 #endif
@@ -946,7 +946,7 @@ static int __init xfrmi6_init(void)
 	err = xfrm6_protocol_register(&xfrmi_ipcomp6_protocol, IPPROTO_COMP);
 	if (err < 0)
 		goto xfrm_proto_comp_failed;
-#if IS_ENABLED(CONFIG_INET6_XFRM_TUNNEL)
+#if IS_REACHABLE(CONFIG_INET6_XFRM_TUNNEL)
 	err = xfrm6_tunnel_register(&xfrmi_ipv6_handler, AF_INET6);
 	if (err < 0)
 		goto xfrm_tunnel_ipv6_failed;
@@ -957,7 +957,7 @@ static int __init xfrmi6_init(void)
 
 	return 0;
 
-#if IS_ENABLED(CONFIG_INET6_XFRM_TUNNEL)
+#if IS_REACHABLE(CONFIG_INET6_XFRM_TUNNEL)
 xfrm_tunnel_ip6ip_failed:
 	xfrm6_tunnel_deregister(&xfrmi_ipv6_handler, AF_INET6);
 xfrm_tunnel_ipv6_failed:
@@ -973,7 +973,7 @@ static int __init xfrmi6_init(void)
 
 static void xfrmi6_fini(void)
 {
-#if IS_ENABLED(CONFIG_INET6_XFRM_TUNNEL)
+#if IS_REACHABLE(CONFIG_INET6_XFRM_TUNNEL)
 	xfrm6_tunnel_deregister(&xfrmi_ip6ip_handler, AF_INET);
 	xfrm6_tunnel_deregister(&xfrmi_ipv6_handler, AF_INET6);
 #endif
-- 
2.1.0

