Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E75627BF52
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 10:26:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727755AbgI2I0H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 04:26:07 -0400
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:58087 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727678AbgI2I0G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 04:26:06 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id 3CBD95807CF;
        Tue, 29 Sep 2020 04:17:06 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 29 Sep 2020 04:17:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=MZU1qJW5Uk3NTQDK1nJr3FTilojGe+/yiq8YPwN6bXg=; b=RDVX4e4M
        57cztdepsJxQvZQG8/S0BZ6vYn7fR9UXz6IJnmvROl+k0XawnamenqTewArvIFoh
        WvC5TqyoExk2KozTB3wYKc9Zp5vN9/ADy9QquwXIA11a3qTTkz/0ECkqEfUwQ9FJ
        2Bx7KSpsFRA6qjSbRpZvBrZNrR7p04+PooJ5lB2pK6Xa0X7auWYF+L1Z7xyAZYbr
        5/DOQx8g8NJZSMDu4qM0FfYKAFutaZQoWw2EiCiTnIthQYIKftn75u8iM9SPAY0s
        u5vN+oZtn4zoQihmfHbIXdwK9wij81FMgU8aZX9gZwpLQnNZPdKL6zaDyFjJNyz/
        uaTXTdxHEMGg8A==
X-ME-Sender: <xms:gu1yXw8v_2Fb5UnzE9VFr0pxSr6CZi9N89UGTfqPshwrVb_sfY-LXg>
    <xme:gu1yX4ufuKkodzzk0_Rbhv8giHZmksxIcg81gjOxzVdCRexfQ5gxwRFwVZ5lXiyf7
    kcmIlXT2YrX0gM>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvdekgddtvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhfekhe
    fgtdfftefhledvjefggfehgfevjeekhfenucfkphepkeegrddvvdelrdefjedrudegkeen
    ucevlhhushhtvghrufhiiigvpeefnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughosh
    gthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:gu1yX2Aod7izMvsyS2F59q5jU-qDZnUBo7pVoXzIEGbkFIAgI-KvpA>
    <xmx:gu1yXwfdZVaYInSyaUwKq5ctoTPaykxKwwwzTWfzyZm0tW4wxtOwIQ>
    <xmx:gu1yX1Mqq17heOlZuVr8hrkQgB6AlIeUmBvqujzMqDBpMwCeLcWyMQ>
    <xmx:gu1yX4ciheYwUFYTqnP8alk2HgIX2nzeIb53tuq4qAMtzrJ1WtyfPw>
Received: from shredder.mtl.com (igld-84-229-37-148.inter.net.il [84.229.37.148])
        by mail.messagingengine.com (Postfix) with ESMTPA id EC2EF3280059;
        Tue, 29 Sep 2020 04:17:03 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, nhorman@tuxdriver.com,
        jiri@nvidia.com, roopa@nvidia.com, aroulin@nvidia.com,
        ayal@nvidia.com, masahiroy@kernel.org, mlxsw@nvidia.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 5/7] drop_monitor: Remove duplicate struct
Date:   Tue, 29 Sep 2020 11:15:54 +0300
Message-Id: <20200929081556.1634838-6-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200929081556.1634838-1-idosch@idosch.org>
References: <20200929081556.1634838-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

'struct net_dm_hw_metadata' is a duplicate of 'struct
devlink_trap_metadata'.

Remove the former and simplify the code.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 net/core/drop_monitor.c | 27 ++++++++++-----------------
 1 file changed, 10 insertions(+), 17 deletions(-)

diff --git a/net/core/drop_monitor.c b/net/core/drop_monitor.c
index db6d87ddde8d..0e4309414a30 100644
--- a/net/core/drop_monitor.c
+++ b/net/core/drop_monitor.c
@@ -108,13 +108,6 @@ static enum net_dm_alert_mode net_dm_alert_mode = NET_DM_ALERT_MODE_SUMMARY;
 static u32 net_dm_trunc_len;
 static u32 net_dm_queue_len = 1000;
 
-struct net_dm_hw_metadata {
-	const char *trap_group_name;
-	const char *trap_name;
-	struct net_device *input_dev;
-	const struct flow_action_cookie *fa_cookie;
-};
-
 struct net_dm_alert_ops {
 	void (*kfree_skb_probe)(void *ignore, struct sk_buff *skb,
 				void *location);
@@ -129,7 +122,7 @@ struct net_dm_alert_ops {
 
 struct net_dm_skb_cb {
 	union {
-		struct net_dm_hw_metadata *hw_metadata;
+		struct devlink_trap_metadata *hw_metadata;
 		void *pc;
 	};
 };
@@ -715,7 +708,7 @@ static void net_dm_packet_work(struct work_struct *work)
 }
 
 static size_t
-net_dm_flow_action_cookie_size(const struct net_dm_hw_metadata *hw_metadata)
+net_dm_flow_action_cookie_size(const struct devlink_trap_metadata *hw_metadata)
 {
 	return hw_metadata->fa_cookie ?
 	       nla_total_size(hw_metadata->fa_cookie->cookie_len) : 0;
@@ -723,7 +716,7 @@ net_dm_flow_action_cookie_size(const struct net_dm_hw_metadata *hw_metadata)
 
 static size_t
 net_dm_hw_packet_report_size(size_t payload_len,
-			     const struct net_dm_hw_metadata *hw_metadata)
+			     const struct devlink_trap_metadata *hw_metadata)
 {
 	size_t size;
 
@@ -753,7 +746,7 @@ net_dm_hw_packet_report_size(size_t payload_len,
 static int net_dm_hw_packet_report_fill(struct sk_buff *msg,
 					struct sk_buff *skb, size_t payload_len)
 {
-	struct net_dm_hw_metadata *hw_metadata;
+	struct devlink_trap_metadata *hw_metadata;
 	struct nlattr *attr;
 	void *hdr;
 
@@ -820,11 +813,11 @@ static int net_dm_hw_packet_report_fill(struct sk_buff *msg,
 	return -EMSGSIZE;
 }
 
-static struct net_dm_hw_metadata *
+static struct devlink_trap_metadata *
 net_dm_hw_metadata_copy(const struct devlink_trap_metadata *metadata)
 {
 	const struct flow_action_cookie *fa_cookie;
-	struct net_dm_hw_metadata *hw_metadata;
+	struct devlink_trap_metadata *hw_metadata;
 	const char *trap_group_name;
 	const char *trap_name;
 
@@ -869,7 +862,7 @@ net_dm_hw_metadata_copy(const struct devlink_trap_metadata *metadata)
 }
 
 static void
-net_dm_hw_metadata_free(const struct net_dm_hw_metadata *hw_metadata)
+net_dm_hw_metadata_free(const struct devlink_trap_metadata *hw_metadata)
 {
 	if (hw_metadata->input_dev)
 		dev_put(hw_metadata->input_dev);
@@ -881,7 +874,7 @@ net_dm_hw_metadata_free(const struct net_dm_hw_metadata *hw_metadata)
 
 static void net_dm_hw_packet_report(struct sk_buff *skb)
 {
-	struct net_dm_hw_metadata *hw_metadata;
+	struct devlink_trap_metadata *hw_metadata;
 	struct sk_buff *msg;
 	size_t payload_len;
 	int rc;
@@ -938,7 +931,7 @@ net_dm_hw_trap_packet_probe(void *ignore, const struct devlink *devlink,
 			    struct sk_buff *skb,
 			    const struct devlink_trap_metadata *metadata)
 {
-	struct net_dm_hw_metadata *n_hw_metadata;
+	struct devlink_trap_metadata *n_hw_metadata;
 	ktime_t tstamp = ktime_get_real();
 	struct per_cpu_dm_data *hw_data;
 	struct sk_buff *nskb;
@@ -1081,7 +1074,7 @@ static void net_dm_hw_monitor_stop(struct netlink_ext_ack *extack)
 		del_timer_sync(&hw_data->send_timer);
 		cancel_work_sync(&hw_data->dm_alert_work);
 		while ((skb = __skb_dequeue(&hw_data->drop_queue))) {
-			struct net_dm_hw_metadata *hw_metadata;
+			struct devlink_trap_metadata *hw_metadata;
 
 			hw_metadata = NET_DM_SKB_CB(skb)->hw_metadata;
 			net_dm_hw_metadata_free(hw_metadata);
-- 
2.26.2

