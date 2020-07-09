Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4669921A0A4
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 15:19:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726828AbgGINTE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 09:19:04 -0400
Received: from new4-smtp.messagingengine.com ([66.111.4.230]:54605 "EHLO
        new4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726315AbgGINTE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jul 2020 09:19:04 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id C78EF5804D0;
        Thu,  9 Jul 2020 09:19:02 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Thu, 09 Jul 2020 09:19:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=UqBxurt22x458TpuEWsYDsxDjg5Jk0S+wSjzQGC8PjM=; b=KGavvwas
        8HVBA6Drycaq3vGaI2H2A/eEJhTA1i857QpPTODMajN6RqMgw8D1d53x9JhaTbkq
        f37DtjwjwGeUf9lEsN0UMiMMlBiYOixqX8dYsNxZDSiphgTVzdqRa/NfudJBrYoR
        DYTQtyAWzcxgXRZbKU40jX5LXhRLmNsyGs35b7TmQCzbqjh0YlQelpBmJlE47Qol
        V7Ec4hwpnwhH0nCeeSMX5Mj75MKtLbPavmOT4+GlXGnDNUp/ERC2y41jUh5K2ca7
        Ty4i6jeNZn3dxOcT60ta83FxQPfU3KLTT68NNEa52Uvc6AhmS/Av1Go/cA0K4Ydb
        +8bL1/JGhEF2VQ==
X-ME-Sender: <xms:RhkHX_4PoHhujHEosNOJEzQNVy49_8BgTdIsoJGqnk4ikmJWmetiGA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrudelgdeigecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhfekhe
    fgtdfftefhledvjefggfehgfevjeekhfenucfkphepuddtledrieeirdduledrudeffeen
    ucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughosh
    gthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:RhkHX04fo3TqEdwsyfxDd33MGA-0f1Mbper_woY2NhrUkKy0Im44oQ>
    <xmx:RhkHX2fA3K7L144MQYZHBC_SIfFtKyhwBUxs3FdGVPhvMKdnql-iFA>
    <xmx:RhkHXwLisb7NO1LvCTK7zMTBj0rzffxyBJnAHq8y1JvOIUwWgSQjXQ>
    <xmx:RhkHXwCOPr-y3CrjQzgMFhD6u76oZu5ccdN0ut6iQiAmlHnankLJJQ>
Received: from shredder.mtl.com (bzq-109-66-19-133.red.bezeqint.net [109.66.19.133])
        by mail.messagingengine.com (Postfix) with ESMTPA id 1F23A3280066;
        Thu,  9 Jul 2020 09:18:58 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, michael.chan@broadcom.com,
        jeffrey.t.kirsher@intel.com, saeedm@mellanox.com, leon@kernel.org,
        jiri@mellanox.com, snelson@pensando.io, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        danieller@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next v3 1/9] devlink: Move set attribute of devlink_port_attrs to devlink_port
Date:   Thu,  9 Jul 2020 16:18:14 +0300
Message-Id: <20200709131822.542252-2-idosch@idosch.org>
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

The 'set' field is not devlink_port's attribute as opposed to most of the
others.

Move 'set' to be devlink_port's field called 'attrs_set'.

Signed-off-by: Danielle Ratson <danieller@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 include/net/devlink.h | 4 ++--
 net/core/devlink.c    | 6 +++---
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/include/net/devlink.h b/include/net/devlink.h
index 428f55f8197c..28f8d92c5741 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -65,8 +65,7 @@ struct devlink_port_pci_vf_attrs {
 };
 
 struct devlink_port_attrs {
-	u8 set:1,
-	   split:1,
+	u8 split:1,
 	   switch_port:1;
 	enum devlink_port_flavour flavour;
 	struct netdev_phys_item_id switch_id;
@@ -90,6 +89,7 @@ struct devlink_port {
 	enum devlink_port_type desired_type;
 	void *type_dev;
 	struct devlink_port_attrs attrs;
+	u8 attrs_set:1;
 	struct delayed_work type_warn_dw;
 };
 
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 6ae36808c152..f28ae63cdb6b 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -528,7 +528,7 @@ static int devlink_nl_port_attrs_put(struct sk_buff *msg,
 {
 	struct devlink_port_attrs *attrs = &devlink_port->attrs;
 
-	if (!attrs->set)
+	if (!devlink_port->attrs_set)
 		return 0;
 	if (nla_put_u16(msg, DEVLINK_ATTR_PORT_FLAVOUR, attrs->flavour))
 		return -EMSGSIZE;
@@ -7518,7 +7518,7 @@ static int __devlink_port_attrs_set(struct devlink_port *devlink_port,
 
 	if (WARN_ON(devlink_port->registered))
 		return -EEXIST;
-	attrs->set = true;
+	devlink_port->attrs_set = true;
 	attrs->flavour = flavour;
 	if (switch_id) {
 		attrs->switch_port = true;
@@ -7626,7 +7626,7 @@ static int __devlink_port_phys_port_name_get(struct devlink_port *devlink_port,
 	struct devlink_port_attrs *attrs = &devlink_port->attrs;
 	int n = 0;
 
-	if (!attrs->set)
+	if (!devlink_port->attrs_set)
 		return -EOPNOTSUPP;
 
 	switch (attrs->flavour) {
-- 
2.26.2

