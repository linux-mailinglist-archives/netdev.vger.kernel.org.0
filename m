Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 911A721A0A6
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 15:19:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726867AbgGINTT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 09:19:19 -0400
Received: from new4-smtp.messagingengine.com ([66.111.4.230]:47001 "EHLO
        new4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726315AbgGINTH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jul 2020 09:19:07 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id 15DB05804CA;
        Thu,  9 Jul 2020 09:19:07 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Thu, 09 Jul 2020 09:19:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=EmIeC1M6zTAjAo6hq9Tehx4369Lb5jUo1S394iDJ84w=; b=U0QztFVX
        mhJYVdsqkYrVybcn4vGCPVkqe9KXOBJS9BWjcS2/Y/XK4w7m8LuwIdB7rlxgIIZo
        weCtimzFzTBkhCEnjUgcReeFwQG/MSAdbwqKUBBoOl5iH+LWUGE+KcWkb1Dj6q1O
        5L6ndVzlbvDzv0lDyMied0ToX/tvtsKCljsRxIQQOetFKLDFUmOpO2U6NQMoPEQ+
        yl7Z/Ubv9h9WaJ/givnwAnDwDp6m/rBFxIo+oK9qiRHJq2qv+tiQcXGRjr7vgpdA
        Zgfv0TkG1edu9BJB8GopM9zQkyYIBb+RxlAnUlbsn6srbkU6iX62jsBqCQDIjGRb
        2xdqn1u3Pjb07A==
X-ME-Sender: <xms:ShkHX-1SzgAvdUIpuclXh6ao-2ZhHiaDKSqKehEVH_2XNzsYsGXmJA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrudelgdeigecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhfekhe
    fgtdfftefhledvjefggfehgfevjeekhfenucfkphepuddtledrieeirdduledrudeffeen
    ucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughosh
    gthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:ShkHXxFZzPakzxuhXLVJQmLWHihJ3LgvupJpM8H3M4sUpkDP6tPS2A>
    <xmx:ShkHX26KE36lvmlTwgaM2AdM6x3US6uGPZTGCWLrgNJD9tuOEBjqCQ>
    <xmx:ShkHX_0w_IKxnr3LGHv6uHIQMIthjJ0QDl1wAdMWjpizD87vG27DnQ>
    <xmx:SxkHX58m1vUYnrwLLn8-TeA9Nt0ibShYm4g15bUB69DHbytfHM-p5Q>
Received: from shredder.mtl.com (bzq-109-66-19-133.red.bezeqint.net [109.66.19.133])
        by mail.messagingengine.com (Postfix) with ESMTPA id 412363280063;
        Thu,  9 Jul 2020 09:19:02 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, michael.chan@broadcom.com,
        jeffrey.t.kirsher@intel.com, saeedm@mellanox.com, leon@kernel.org,
        jiri@mellanox.com, snelson@pensando.io, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        danieller@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next v3 2/9] devlink: Move switch_port attribute of devlink_port_attrs to devlink_port
Date:   Thu,  9 Jul 2020 16:18:15 +0300
Message-Id: <20200709131822.542252-3-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200709131822.542252-1-idosch@idosch.org>
References: <20200709131822.542252-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Danielle Ratson <danieller@mellanox.com>

The struct devlink_port_attrs holds the attributes of devlink_port.

Similarly to the previous patch, 'switch_port' attribute is another
exception.

Move 'switch_port' to be devlink_port's field.

Signed-off-by: Danielle Ratson <danieller@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 include/net/devlink.h | 6 +++---
 net/core/devlink.c    | 6 +++---
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/net/devlink.h b/include/net/devlink.h
index 28f8d92c5741..de4b5dcdb4a5 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -65,8 +65,7 @@ struct devlink_port_pci_vf_attrs {
 };
 
 struct devlink_port_attrs {
-	u8 split:1,
-	   switch_port:1;
+	u8 split:1;
 	enum devlink_port_flavour flavour;
 	struct netdev_phys_item_id switch_id;
 	union {
@@ -89,7 +88,8 @@ struct devlink_port {
 	enum devlink_port_type desired_type;
 	void *type_dev;
 	struct devlink_port_attrs attrs;
-	u8 attrs_set:1;
+	u8 attrs_set:1,
+	   switch_port:1;
 	struct delayed_work type_warn_dw;
 };
 
diff --git a/net/core/devlink.c b/net/core/devlink.c
index f28ae63cdb6b..452b2f8a054e 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -7521,13 +7521,13 @@ static int __devlink_port_attrs_set(struct devlink_port *devlink_port,
 	devlink_port->attrs_set = true;
 	attrs->flavour = flavour;
 	if (switch_id) {
-		attrs->switch_port = true;
+		devlink_port->switch_port = true;
 		if (WARN_ON(switch_id_len > MAX_PHYS_ITEM_ID_LEN))
 			switch_id_len = MAX_PHYS_ITEM_ID_LEN;
 		memcpy(attrs->switch_id.id, switch_id, switch_id_len);
 		attrs->switch_id.id_len = switch_id_len;
 	} else {
-		attrs->switch_port = false;
+		devlink_port->switch_port = false;
 	}
 	return 0;
 }
@@ -9461,7 +9461,7 @@ int devlink_compat_switch_id_get(struct net_device *dev,
 	 * any devlink lock as only permanent values are accessed.
 	 */
 	devlink_port = netdev_to_devlink_port(dev);
-	if (!devlink_port || !devlink_port->attrs.switch_port)
+	if (!devlink_port || !devlink_port->switch_port)
 		return -EOPNOTSUPP;
 
 	memcpy(ppid, &devlink_port->attrs.switch_id, sizeof(*ppid));
-- 
2.26.2

