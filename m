Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2DB527BF50
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 10:26:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727774AbgI2I0I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 04:26:08 -0400
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:51781 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727753AbgI2I0H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 04:26:07 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id F39E75807A2;
        Tue, 29 Sep 2020 04:16:56 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 29 Sep 2020 04:16:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=sRmx3hz3I+ujiBqBkrLYXJvjYEjlp9OGVjGB3V3zx2w=; b=LEhNfF52
        JcnMJYEvdN0eTpHYDxlpD+r030F/UhyjrMuDY9qmb32QzolkuLJwlPKIiU+0uEff
        XtTLyiT9Q9Rhzqj/vcrdyoatfysl7w5qT6OiBjQe/XJPDaesGqyNbiuZf8cXVINI
        GD2Y/8L5xwe8QyQXMb7sTZn/xMtp6Ax0i7bUfkwk96w3x6jWXPdY+QIWd0ALBGY8
        oHlrC3AEzhaZH/YSmfG/Bepv89+pM1EIW9LIf1b39iiJmRhfZFqppW2rFQ1j60IX
        oTsJZIpogD5yY7GRfqs9xv8yIbKhxiaX5Pf2n/9ZhsgSQE5skhHIKoVb1+hOSAip
        s0P8fGcHCyfCxA==
X-ME-Sender: <xms:eO1yXzUSvBSpgIpeaMdY5d5d_oOZDvfPYwtF5zSkOlVSEGyUS9_Lkw>
    <xme:eO1yX7l6QdM8jEMiHzjewgC31-5tQ60tXAt0yY_Cs9DADLdEPTdz_bdxH_VwMJyWq
    0Jyv9jGAVwpmLc>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvdekgddtvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhfekhe
    fgtdfftefhledvjefggfehgfevjeekhfenucfkphepkeegrddvvdelrdefjedrudegkeen
    ucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughosh
    gthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:eO1yX_bOD0-1aLTJgZoRuNxMk_-iwWSk1FV_EfA0LZK1AjALouTywA>
    <xmx:eO1yX-WOV0ELTN-qHX0YHrTVAo8d25zTLu-YjL4_4rrW8FacSSAftw>
    <xmx:eO1yX9lZCQoUvq8REz9Lmr9_V9UPs0BRUiQFg2BEoNB6z232bde7ng>
    <xmx:eO1yXzUl0xSyg_qLEILdxFynGvkpf1Hw8Sag5RjCO6Rm-6f4oAwOLg>
Received: from shredder.mtl.com (igld-84-229-37-148.inter.net.il [84.229.37.148])
        by mail.messagingengine.com (Postfix) with ESMTPA id 22DD9328005E;
        Tue, 29 Sep 2020 04:16:53 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, nhorman@tuxdriver.com,
        jiri@nvidia.com, roopa@nvidia.com, aroulin@nvidia.com,
        ayal@nvidia.com, masahiroy@kernel.org, mlxsw@nvidia.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 1/7] devlink: Add a tracepoint for trap reports
Date:   Tue, 29 Sep 2020 11:15:50 +0300
Message-Id: <20200929081556.1634838-2-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200929081556.1634838-1-idosch@idosch.org>
References: <20200929081556.1634838-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

Add a tracepoint for trap reports so that drop monitor could register
its probe on it. Use trace_devlink_trap_report_enabled() to avoid
wasting cycles setting the trap metadata if the tracepoint is not
enabled.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 include/net/devlink.h          | 14 +++++++++++++
 include/trace/events/devlink.h | 37 ++++++++++++++++++++++++++++++++++
 net/core/devlink.c             | 25 +++++++++++++++++++++++
 3 files changed, 76 insertions(+)

diff --git a/include/net/devlink.h b/include/net/devlink.h
index 7339bf9ba6b4..1014294ba6a0 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -624,6 +624,20 @@ struct devlink_health_reporter_ops {
 		    struct netlink_ext_ack *extack);
 };
 
+/**
+ * struct devlink_trap_metadata - Packet trap metadata.
+ * @trap_name: Trap name.
+ * @trap_group_name: Trap group name.
+ * @input_dev: Input netdevice.
+ * @fa_cookie: Flow action user cookie.
+ */
+struct devlink_trap_metadata {
+	const char *trap_name;
+	const char *trap_group_name;
+	struct net_device *input_dev;
+	const struct flow_action_cookie *fa_cookie;
+};
+
 /**
  * struct devlink_trap_policer - Immutable packet trap policer attributes.
  * @id: Policer identifier.
diff --git a/include/trace/events/devlink.h b/include/trace/events/devlink.h
index 6f60a78d9a7e..44d8e2981065 100644
--- a/include/trace/events/devlink.h
+++ b/include/trace/events/devlink.h
@@ -171,6 +171,43 @@ TRACE_EVENT(devlink_health_reporter_state_update,
 		  __entry->new_state)
 );
 
+/*
+ * Tracepoint for devlink packet trap:
+ */
+TRACE_EVENT(devlink_trap_report,
+	TP_PROTO(const struct devlink *devlink, struct sk_buff *skb,
+		 const struct devlink_trap_metadata *metadata),
+
+	TP_ARGS(devlink, skb, metadata),
+
+	TP_STRUCT__entry(
+		__string(bus_name, devlink->dev->bus->name)
+		__string(dev_name, dev_name(devlink->dev))
+		__string(driver_name, devlink->dev->driver->name)
+		__string(trap_name, metadata->trap_name)
+		__string(trap_group_name, metadata->trap_group_name)
+		__dynamic_array(char, input_dev_name, IFNAMSIZ)
+	),
+
+	TP_fast_assign(
+		struct net_device *input_dev = metadata->input_dev;
+
+		__assign_str(bus_name, devlink->dev->bus->name);
+		__assign_str(dev_name, dev_name(devlink->dev));
+		__assign_str(driver_name, devlink->dev->driver->name);
+		__assign_str(trap_name, metadata->trap_name);
+		__assign_str(trap_group_name, metadata->trap_group_name);
+		__assign_str(input_dev_name,
+			     (input_dev ? input_dev->name : "NULL"));
+	),
+
+	TP_printk("bus_name=%s dev_name=%s driver_name=%s trap_name=%s "
+		  "trap_group_name=%s input_dev_name=%s", __get_str(bus_name),
+		  __get_str(dev_name), __get_str(driver_name),
+		  __get_str(trap_name), __get_str(trap_group_name),
+		  __get_str(input_dev_name))
+);
+
 #endif /* _TRACE_DEVLINK_H */
 
 /* This part must be outside protection */
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 7a38f9e25922..c0f300507c37 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -84,6 +84,7 @@ EXPORT_SYMBOL(devlink_dpipe_header_ipv6);
 
 EXPORT_TRACEPOINT_SYMBOL_GPL(devlink_hwmsg);
 EXPORT_TRACEPOINT_SYMBOL_GPL(devlink_hwerr);
+EXPORT_TRACEPOINT_SYMBOL_GPL(devlink_trap_report);
 
 static const struct nla_policy devlink_function_nl_policy[DEVLINK_PORT_FUNCTION_ATTR_MAX + 1] = {
 	[DEVLINK_PORT_FUNCTION_ATTR_HW_ADDR] = { .type = NLA_BINARY },
@@ -9278,6 +9279,22 @@ devlink_trap_report_metadata_fill(struct net_dm_hw_metadata *hw_metadata,
 	spin_unlock(&in_devlink_port->type_lock);
 }
 
+static void
+devlink_trap_report_metadata_set(struct devlink_trap_metadata *metadata,
+				 const struct devlink_trap_item *trap_item,
+				 struct devlink_port *in_devlink_port,
+				 const struct flow_action_cookie *fa_cookie)
+{
+	metadata->trap_name = trap_item->trap->name;
+	metadata->trap_group_name = trap_item->group_item->group->name;
+	metadata->fa_cookie = fa_cookie;
+
+	spin_lock(&in_devlink_port->type_lock);
+	if (in_devlink_port->type == DEVLINK_PORT_TYPE_ETH)
+		metadata->input_dev = in_devlink_port->type_dev;
+	spin_unlock(&in_devlink_port->type_lock);
+}
+
 /**
  * devlink_trap_report - Report trapped packet to drop monitor.
  * @devlink: devlink.
@@ -9307,6 +9324,14 @@ void devlink_trap_report(struct devlink *devlink, struct sk_buff *skb,
 	devlink_trap_report_metadata_fill(&hw_metadata, trap_item,
 					  in_devlink_port, fa_cookie);
 	net_dm_hw_report(skb, &hw_metadata);
+
+	if (trace_devlink_trap_report_enabled()) {
+		struct devlink_trap_metadata metadata = {};
+
+		devlink_trap_report_metadata_set(&metadata, trap_item,
+						 in_devlink_port, fa_cookie);
+		trace_devlink_trap_report(devlink, skb, &metadata);
+	}
 }
 EXPORT_SYMBOL_GPL(devlink_trap_report);
 
-- 
2.26.2

