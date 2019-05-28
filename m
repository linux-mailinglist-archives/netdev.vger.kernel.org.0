Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 614152C68D
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 14:31:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727215AbfE1Mbl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 08:31:41 -0400
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:42745 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726592AbfE1MbV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 08:31:21 -0400
X-Greylist: delayed 523 seconds by postgrey-1.27 at vger.kernel.org; Tue, 28 May 2019 08:31:20 EDT
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id BD8681E00;
        Tue, 28 May 2019 08:22:35 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Tue, 28 May 2019 08:22:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=RNhKzaRXWzMczSiY200YHSKeC3J/QHm80215YzOM3qs=; b=qDvBfEzo
        FTU2hObNmdfnnUzb0uQn+tBCEvbbrnoC6a3n810/6Hs2zU0dTdi6xU+LiXPuT/jh
        K1vgunyHNZM2bcm+7gMK70XYT0Q4jB2mgScnvPgw1OScWjodz/JnqBGTlxhNn6hf
        CGprs8b0FCDeuZSoNHuKMJym3Qc6x1NJcxXKymW8gTVMF3eI+Xg4VY5OWZ5gVHV2
        d1d18UAvjMgWGjn1rd6Gq3hfUn3BUDL1/acgOskKvEidmClR61PhftTUqWZLOr6f
        KBsS22Z2eHoygDiioQfUMh25KR/DJSJY/qbMmr6HSAFJPnKCweYOYgxvvL/DrVOZ
        oENCTY5avcZWQg==
X-ME-Sender: <xms:CyjtXGqsAXK_aV6XyKXrhqVvmNLAFMlMunTUqW8fEWthe13amNUS-A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddruddvhedgheduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpedt
X-ME-Proxy: <xmx:CyjtXKc8_Bjs5xw6kWZt-pIlHVER_KbVJXmbGOQzrfymgIVZncld_w>
    <xmx:CyjtXNTySSMrnmLxUkiXqRuCTECXgRJtq8sorYwosYwkTtQUYDXP7A>
    <xmx:CyjtXOfytxwbXsuixuH_iexvXZwHrROXoGCYIX6b6hyx6j0aWvxpKw>
    <xmx:CyjtXHZJPv9K_ifoypqolGhQcWaU3FSN2hVYlNnOHuUMwB936TIfaw>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 1EE5F38008C;
        Tue, 28 May 2019 08:22:32 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, mlxsw@mellanox.com,
        dsahern@gmail.com, roopa@cumulusnetworks.com,
        nikolay@cumulusnetworks.com, andy@greyhouse.net,
        pablo@netfilter.org, jakub.kicinski@netronome.com,
        pieter.jansenvanvuuren@netronome.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@savoirfairelinux.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [RFC PATCH net-next 01/12] devlink: Create helper to fill port type information
Date:   Tue, 28 May 2019 15:21:25 +0300
Message-Id: <20190528122136.30476-2-idosch@idosch.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190528122136.30476-1-idosch@idosch.org>
References: <20190528122136.30476-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

The function that fills port attributes in a netlink message fills the
port type attributes together with other attributes such as the device
handle.

The port type attributes will also need to be filled for trapped packets
by a subsequent patch.

Prevent code duplication and create a helper that can be used from both
places.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 net/core/devlink.c | 49 +++++++++++++++++++++++++++-------------------
 1 file changed, 29 insertions(+), 20 deletions(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index 9716a7f382cb..96c589c5afc0 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -531,6 +531,33 @@ static int devlink_nl_port_attrs_put(struct sk_buff *msg,
 	return 0;
 }
 
+static int devlink_nl_port_type_fill(struct sk_buff *msg,
+				     const struct devlink_port *devlink_port)
+{
+	if (nla_put_u16(msg, DEVLINK_ATTR_PORT_TYPE, devlink_port->type))
+		return -EMSGSIZE;
+
+	if (devlink_port->type == DEVLINK_PORT_TYPE_ETH) {
+		struct net_device *netdev = devlink_port->type_dev;
+
+		if (netdev &&
+		    (nla_put_u32(msg, DEVLINK_ATTR_PORT_NETDEV_IFINDEX,
+				 netdev->ifindex) ||
+		     nla_put_string(msg, DEVLINK_ATTR_PORT_NETDEV_NAME,
+				    netdev->name)))
+			return -EMSGSIZE;
+	} else if (devlink_port->type == DEVLINK_PORT_TYPE_IB) {
+		struct ib_device *ibdev = devlink_port->type_dev;
+
+		if (ibdev &&
+		    nla_put_string(msg, DEVLINK_ATTR_PORT_IBDEV_NAME,
+				   ibdev->name))
+			return -EMSGSIZE;
+	}
+
+	return 0;
+}
+
 static int devlink_nl_port_fill(struct sk_buff *msg, struct devlink *devlink,
 				struct devlink_port *devlink_port,
 				enum devlink_command cmd, u32 portid,
@@ -548,30 +575,12 @@ static int devlink_nl_port_fill(struct sk_buff *msg, struct devlink *devlink,
 		goto nla_put_failure;
 
 	spin_lock(&devlink_port->type_lock);
-	if (nla_put_u16(msg, DEVLINK_ATTR_PORT_TYPE, devlink_port->type))
-		goto nla_put_failure_type_locked;
 	if (devlink_port->desired_type != DEVLINK_PORT_TYPE_NOTSET &&
 	    nla_put_u16(msg, DEVLINK_ATTR_PORT_DESIRED_TYPE,
 			devlink_port->desired_type))
 		goto nla_put_failure_type_locked;
-	if (devlink_port->type == DEVLINK_PORT_TYPE_ETH) {
-		struct net_device *netdev = devlink_port->type_dev;
-
-		if (netdev &&
-		    (nla_put_u32(msg, DEVLINK_ATTR_PORT_NETDEV_IFINDEX,
-				 netdev->ifindex) ||
-		     nla_put_string(msg, DEVLINK_ATTR_PORT_NETDEV_NAME,
-				    netdev->name)))
-			goto nla_put_failure_type_locked;
-	}
-	if (devlink_port->type == DEVLINK_PORT_TYPE_IB) {
-		struct ib_device *ibdev = devlink_port->type_dev;
-
-		if (ibdev &&
-		    nla_put_string(msg, DEVLINK_ATTR_PORT_IBDEV_NAME,
-				   ibdev->name))
-			goto nla_put_failure_type_locked;
-	}
+	if (devlink_nl_port_type_fill(msg, devlink_port))
+		goto nla_put_failure_type_locked;
 	spin_unlock(&devlink_port->type_lock);
 	if (devlink_nl_port_attrs_put(msg, devlink_port))
 		goto nla_put_failure;
-- 
2.20.1

