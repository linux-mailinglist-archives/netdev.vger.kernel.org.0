Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 52E80179C62
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 00:25:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388572AbgCDXZc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 18:25:32 -0500
Received: from mail-pj1-f67.google.com ([209.85.216.67]:54941 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388476AbgCDXZc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Mar 2020 18:25:32 -0500
Received: by mail-pj1-f67.google.com with SMTP id np16so1041833pjb.4
        for <netdev@vger.kernel.org>; Wed, 04 Mar 2020 15:25:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=7OMA8NCI6I4hn1twy2JCpkX3Jqjbh0j+Qa/Gmrv8vAk=;
        b=p9J0xTnFdg4udGN5JQN4GvveWP01oIjbO5wG7kicI4F8LCDHN19M9piiFqUMJ2QkeN
         MUTqznkCLU8JscqK6uEgjG+j02lvhBliiG2iytrLH3Iy9XfInkzjumkPoM0b83ktktHD
         WBLzShW46bFbbiqZEXR93Edk1Fk2DJMLKQ22lhxLTUsu9JIpm+9/wxrYXzgJyGk2Z14X
         ZTdO50FCe7a9Ulus69S84NyWtA1ogNeUHdOVMVfd2yGcBGorZGLZsyoIQyR4LbGOVSUu
         2vk77WQtTIcLnDrJB2a34b6w6E9CdVRpjSCakczib0v8Jw/tO2rNglSJaMeSKZkQhrQB
         QWIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=7OMA8NCI6I4hn1twy2JCpkX3Jqjbh0j+Qa/Gmrv8vAk=;
        b=laoU4/klRpQCJuv5obWFrhVLJFprJVRJUMSaWvQ+wFNz4kjz+e3kg/w9bwgbWWjEDl
         gIOdQxCg7Y3yKC3fwn+sotIMZaC6f1bMAZyPTUbtvPViv1KeEPCEFSUWa+noRd/VhRzg
         hTHpFelHVKZGHMNFYs34l3iLr+UzJULnRDr60m8jxZfc6Dv2F1X4kUUHCKUlXAuudFiT
         ZPNpL7da34bQ49OERkI6B6ysyuaiFhDpfqg8n70LqZ9GErunjcnaRKS/iuNR7GLmuPaz
         tqWttWxofw1iZoJ0IOUCLydvmMtukrtDdAmvWR64/P6cj70eTvecE39NnOp4sy6YeT9t
         Je7A==
X-Gm-Message-State: ANhLgQ1hm+XTXktKY/cHfUu5e5YHI3Vy1OYxyL8UgMtChtHetvZtUYnW
        lvkJfa7pw0V6HemBdkNisyU=
X-Google-Smtp-Source: ADFU+vvkPw8hbq0X3wIqW5elaLko5CSXmm04JIQ8D+g5FmYGXzf85kjcNY1pqj6TuXaL96SCprc2vg==
X-Received: by 2002:a17:90a:db4b:: with SMTP id u11mr5437056pjx.105.1583364329473;
        Wed, 04 Mar 2020 15:25:29 -0800 (PST)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id q187sm29196401pfq.185.2020.03.04.15.25.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Mar 2020 15:25:28 -0800 (PST)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, subashab@codeaurora.org,
        stranche@codeaurora.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com
Subject: [PATCH net-next v2 2/3] net: rmnet: print error message when command fails
Date:   Wed,  4 Mar 2020 23:25:22 +0000
Message-Id: <20200304232522.12473-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When rmnet netlink command fails, it doesn't print any error message.
So, users couldn't know the exact reason.
In order to tell the exact reason to the user, the extack error message
is used in this patch.

Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---

v1->v2:
 - Update error messages

 .../ethernet/qualcomm/rmnet/rmnet_config.c    | 31 +++++++++++++------
 .../net/ethernet/qualcomm/rmnet/rmnet_vnd.c   | 11 ++++---
 .../net/ethernet/qualcomm/rmnet/rmnet_vnd.h   |  3 +-
 3 files changed, 29 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c b/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c
index d846a0ccea8f..63d0c2017ee5 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c
@@ -122,11 +122,10 @@ static int rmnet_newlink(struct net *src_net, struct net_device *dev,
 	}
 
 	real_dev = __dev_get_by_index(src_net, nla_get_u32(tb[IFLA_LINK]));
-	if (!real_dev || !dev)
+	if (!real_dev) {
+		NL_SET_ERR_MSG_MOD(extack, "link does not exist");
 		return -ENODEV;
-
-	if (!data[IFLA_RMNET_MUX_ID])
-		return -EINVAL;
+	}
 
 	ep = kzalloc(sizeof(*ep), GFP_ATOMIC);
 	if (!ep)
@@ -139,7 +138,7 @@ static int rmnet_newlink(struct net *src_net, struct net_device *dev,
 		goto err0;
 
 	port = rmnet_get_port_rtnl(real_dev);
-	err = rmnet_vnd_newlink(mux_id, dev, port, real_dev, ep);
+	err = rmnet_vnd_newlink(mux_id, dev, port, real_dev, ep, extack);
 	if (err)
 		goto err1;
 
@@ -263,12 +262,16 @@ static int rmnet_rtnl_validate(struct nlattr *tb[], struct nlattr *data[],
 {
 	u16 mux_id;
 
-	if (!data || !data[IFLA_RMNET_MUX_ID])
+	if (!data || !data[IFLA_RMNET_MUX_ID]) {
+		NL_SET_ERR_MSG_MOD(extack, "MUX ID not specified");
 		return -EINVAL;
+	}
 
 	mux_id = nla_get_u16(data[IFLA_RMNET_MUX_ID]);
-	if (mux_id > (RMNET_MAX_LOGICAL_EP - 1))
+	if (mux_id > (RMNET_MAX_LOGICAL_EP - 1)) {
+		NL_SET_ERR_MSG_MOD(extack, "invalid MUX ID");
 		return -ERANGE;
+	}
 
 	return 0;
 }
@@ -406,14 +409,22 @@ int rmnet_add_bridge(struct net_device *rmnet_dev,
 	/* If there is more than one rmnet dev attached, its probably being
 	 * used for muxing. Skip the briding in that case
 	 */
-	if (port->nr_rmnet_devs > 1)
+	if (port->nr_rmnet_devs > 1) {
+		NL_SET_ERR_MSG_MOD(extack, "more than one rmnet dev attached");
 		return -EINVAL;
+	}
 
-	if (port->rmnet_mode != RMNET_EPMODE_VND)
+	if (port->rmnet_mode != RMNET_EPMODE_VND) {
+		NL_SET_ERR_MSG_MOD(extack, "bridge device already exists");
 		return -EINVAL;
+	}
+
+	if (rmnet_is_real_dev_registered(slave_dev)) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "slave cannot be another rmnet dev");
 
-	if (rmnet_is_real_dev_registered(slave_dev))
 		return -EBUSY;
+	}
 
 	err = rmnet_register_real_device(slave_dev);
 	if (err)
diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c b/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c
index 26ad40f19c64..d7c52e398e4a 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c
@@ -222,16 +222,17 @@ void rmnet_vnd_setup(struct net_device *rmnet_dev)
 int rmnet_vnd_newlink(u8 id, struct net_device *rmnet_dev,
 		      struct rmnet_port *port,
 		      struct net_device *real_dev,
-		      struct rmnet_endpoint *ep)
+		      struct rmnet_endpoint *ep,
+		      struct netlink_ext_ack *extack)
+
 {
 	struct rmnet_priv *priv = netdev_priv(rmnet_dev);
 	int rc;
 
-	if (ep->egress_dev)
-		return -EINVAL;
-
-	if (rmnet_get_endpoint(port, id))
+	if (rmnet_get_endpoint(port, id)) {
+		NL_SET_ERR_MSG_MOD(extack, "MUX ID already exists");
 		return -EBUSY;
+	}
 
 	rmnet_dev->hw_features = NETIF_F_RXCSUM;
 	rmnet_dev->hw_features |= NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM;
diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.h b/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.h
index 14d77c709d4a..4967f3461ed1 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.h
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.h
@@ -11,7 +11,8 @@ int rmnet_vnd_do_flow_control(struct net_device *dev, int enable);
 int rmnet_vnd_newlink(u8 id, struct net_device *rmnet_dev,
 		      struct rmnet_port *port,
 		      struct net_device *real_dev,
-		      struct rmnet_endpoint *ep);
+		      struct rmnet_endpoint *ep,
+		      struct netlink_ext_ack *extack);
 int rmnet_vnd_dellink(u8 id, struct rmnet_port *port,
 		      struct rmnet_endpoint *ep);
 void rmnet_vnd_rx_fixup(struct sk_buff *skb, struct net_device *dev);
-- 
2.17.1

