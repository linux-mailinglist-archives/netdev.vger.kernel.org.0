Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70A6C4FCD7F
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 06:13:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344943AbiDLEPv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 00:15:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238728AbiDLEPu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 00:15:50 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01FC432EEE
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 21:13:34 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id z6-20020a17090a398600b001cb9fca3210so1520788pjb.1
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 21:13:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lcmbY3ertznUSx7RmGcGvAOFdDT3P5klNno6B49vndM=;
        b=k7rJanAlbTZl+6qJju00XIoUKC0MJ5/hTM49uGwraVMqplDE35MCghMUclFjO6gbEc
         A12hLuaaYPLjHIye2MTv6sdD2LzTrgf0Fx9qnhx/t+wrWf4jyJ3SGXjECDBYaSA+HJZZ
         KWCSu7EPHE6M/vThAtSwDE8nC3vAaODbgGMJiFIAqPIGHOEoxc4UsN0ekv+hRPV0Rxy2
         pDluveOS1vaABVs2YKcE4bvawBqZnbAVqTD0h/D4Cp4FRj9YhQVbC9skubc3ZHw+CuNX
         YvYUwJmcsMybdscWHb5znJSUVt+fQk+vXzfwi5fCs5n0TgMO5aL8sO13xurFm2P38ooB
         ErQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lcmbY3ertznUSx7RmGcGvAOFdDT3P5klNno6B49vndM=;
        b=v03EqClzAYCe5/uSeV3GHMjfWJBHbQOe1hKOsJPV4G7dDnI1YRw9vlYDXInPBKHi70
         i9F4NC4B/GhcTT0vQXSlbdiqQGqzdZZgwY9wm9szGgJGLz/T+6w6oXzil+istiAJ2P/4
         1UdheCzSqIzAsIQ6Xt7KgxaCiBgqFOMdlI4TlzMhAiUfFoKfMJllhu3ZWlGH1WkQjDjH
         KjStbpbX2vS6IhzmsZL3Y/XHRV7RX6E6PyuwG0oEqPec8zo0+WUqkYIwSdrhO+F7WEmH
         9wLyIjV1wUEzox5YsICpH2UU+vLVjAv1yVWFDBBwyyLmpynmwjZMmJojRwQC6o9GdhaK
         K8tw==
X-Gm-Message-State: AOAM533ay6qb2TDfHukkzs3zpyr2wyG6HF+ClqhgFF4+2YcujUqxqKO3
        CjCU8ExatlFj0iFK+M1hZgHPjUNRP1c=
X-Google-Smtp-Source: ABdhPJwK9TVnlRRI5vR3qpmtEUJ2CG4kh/TLJ/Ur4YU+C1bPzsKe1nUViB+l8W+GslYFvK4iDnLcWQ==
X-Received: by 2002:a17:90a:2941:b0:1cb:95d6:c5cd with SMTP id x1-20020a17090a294100b001cb95d6c5cdmr2739328pjf.178.1649736813130;
        Mon, 11 Apr 2022 21:13:33 -0700 (PDT)
Received: from Laptop-X1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id be11-20020a056a001f0b00b004fb29215dd9sm34679769pfb.30.2022.04.11.21.13.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Apr 2022 21:13:32 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        David Ahern <dsahern@gmail.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jonathan Toppins <jtoppins@redhat.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH net-next] Bonding: add per port priority support
Date:   Tue, 12 Apr 2022 12:13:22 +0800
Message-Id: <20220412041322.2409558-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add per port priority support for bonding. A higher number means higher
priority. The primary slave still has the highest priority. This option
also follows the primary_reselect rules.

This option could only be configured via netlink.

Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 Documentation/networking/bonding.rst |  9 +++++++++
 drivers/net/bonding/bond_main.c      | 27 +++++++++++++++++++++++++++
 drivers/net/bonding/bond_netlink.c   | 12 ++++++++++++
 include/net/bonding.h                |  1 +
 include/uapi/linux/if_link.h         |  1 +
 tools/include/uapi/linux/if_link.h   |  1 +
 6 files changed, 51 insertions(+)

diff --git a/Documentation/networking/bonding.rst b/Documentation/networking/bonding.rst
index 525e6842dd33..103e292a04a1 100644
--- a/Documentation/networking/bonding.rst
+++ b/Documentation/networking/bonding.rst
@@ -780,6 +780,15 @@ peer_notif_delay
 	value is 0 which means to match the value of the link monitor
 	interval.
 
+prio
+	Slave priority. A higher number means higher priority.
+	The primary slave has the highest priority. This option also
+	follows the primary_reselect rules.
+
+	This option could only be configured via netlink, and is only valid
+	for active-backup(1), balance-tlb (5) and balance-alb (6) mode.
+	The default value is 0.
+
 primary
 
 	A string (eth0, eth2, etc) specifying which slave is the
diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 15eddca7b4b6..4211b79ac619 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -1026,12 +1026,38 @@ static void bond_do_fail_over_mac(struct bonding *bond,
 
 }
 
+/**
+ * bond_choose_primary_or_current - select the primary or high priority slave
+ * @bond: our bonding struct
+ *
+ * - Check if there is a primary link. If the primary link was set and is up,
+ *   go on and do link reselection.
+ *
+ * - If primary link is not set or down, find the highest priority link.
+ *   If the highest priority link is not current slave, set it as primary
+ *   link and do link reselection.
+ */
 static struct slave *bond_choose_primary_or_current(struct bonding *bond)
 {
 	struct slave *prim = rtnl_dereference(bond->primary_slave);
 	struct slave *curr = rtnl_dereference(bond->curr_active_slave);
+	struct slave *slave, *hprio = NULL;
+	struct list_head *iter;
 
 	if (!prim || prim->link != BOND_LINK_UP) {
+		bond_for_each_slave(bond, slave, iter) {
+			if (slave->link == BOND_LINK_UP) {
+				hprio = hprio ? hprio : slave;
+				if (slave->prio > hprio->prio)
+					hprio = slave;
+			}
+		}
+
+		if (hprio && hprio != curr) {
+			prim = hprio;
+			goto link_reselect;
+		}
+
 		if (!curr || curr->link != BOND_LINK_UP)
 			return NULL;
 		return curr;
@@ -1042,6 +1068,7 @@ static struct slave *bond_choose_primary_or_current(struct bonding *bond)
 		return prim;
 	}
 
+link_reselect:
 	if (!curr || curr->link != BOND_LINK_UP)
 		return prim;
 
diff --git a/drivers/net/bonding/bond_netlink.c b/drivers/net/bonding/bond_netlink.c
index f427fa1737c7..63066559e7d6 100644
--- a/drivers/net/bonding/bond_netlink.c
+++ b/drivers/net/bonding/bond_netlink.c
@@ -27,6 +27,7 @@ static size_t bond_get_slave_size(const struct net_device *bond_dev,
 		nla_total_size(sizeof(u16)) +	/* IFLA_BOND_SLAVE_AD_AGGREGATOR_ID */
 		nla_total_size(sizeof(u8)) +	/* IFLA_BOND_SLAVE_AD_ACTOR_OPER_PORT_STATE */
 		nla_total_size(sizeof(u16)) +	/* IFLA_BOND_SLAVE_AD_PARTNER_OPER_PORT_STATE */
+		nla_total_size(sizeof(s32)) +	/* IFLA_BOND_SLAVE_PRIO */
 		0;
 }
 
@@ -53,6 +54,9 @@ static int bond_fill_slave_info(struct sk_buff *skb,
 	if (nla_put_u16(skb, IFLA_BOND_SLAVE_QUEUE_ID, slave->queue_id))
 		goto nla_put_failure;
 
+	if (nla_put_s32(skb, IFLA_BOND_SLAVE_PRIO, slave->prio))
+		goto nla_put_failure;
+
 	if (BOND_MODE(slave->bond) == BOND_MODE_8023AD) {
 		const struct aggregator *agg;
 		const struct port *ad_port;
@@ -117,6 +121,7 @@ static const struct nla_policy bond_policy[IFLA_BOND_MAX + 1] = {
 
 static const struct nla_policy bond_slave_policy[IFLA_BOND_SLAVE_MAX + 1] = {
 	[IFLA_BOND_SLAVE_QUEUE_ID]	= { .type = NLA_U16 },
+	[IFLA_BOND_SLAVE_PRIO]		= { .type = NLA_S32 },
 };
 
 static int bond_validate(struct nlattr *tb[], struct nlattr *data[],
@@ -136,6 +141,7 @@ static int bond_slave_changelink(struct net_device *bond_dev,
 				 struct nlattr *tb[], struct nlattr *data[],
 				 struct netlink_ext_ack *extack)
 {
+	struct slave *slave = bond_slave_get_rtnl(slave_dev);
 	struct bonding *bond = netdev_priv(bond_dev);
 	struct bond_opt_value newval;
 	int err;
@@ -156,6 +162,12 @@ static int bond_slave_changelink(struct net_device *bond_dev,
 			return err;
 	}
 
+	/* No need to bother __bond_opt_set as we only support netlink config */
+	if (data[IFLA_BOND_SLAVE_PRIO]) {
+		slave->prio = nla_get_s32(data[IFLA_BOND_SLAVE_PRIO]);
+		bond_select_active_slave(bond);
+	}
+
 	return 0;
 }
 
diff --git a/include/net/bonding.h b/include/net/bonding.h
index b14f4c0b4e9e..4ff093fb2289 100644
--- a/include/net/bonding.h
+++ b/include/net/bonding.h
@@ -176,6 +176,7 @@ struct slave {
 	u32    speed;
 	u16    queue_id;
 	u8     perm_hwaddr[MAX_ADDR_LEN];
+	int    prio;
 	struct ad_slave_info *ad_info;
 	struct tlb_slave_info tlb_info;
 #ifdef CONFIG_NET_POLL_CONTROLLER
diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index cc284c048e69..204e342b107a 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -956,6 +956,7 @@ enum {
 	IFLA_BOND_SLAVE_AD_AGGREGATOR_ID,
 	IFLA_BOND_SLAVE_AD_ACTOR_OPER_PORT_STATE,
 	IFLA_BOND_SLAVE_AD_PARTNER_OPER_PORT_STATE,
+	IFLA_BOND_SLAVE_PRIO,
 	__IFLA_BOND_SLAVE_MAX,
 };
 
diff --git a/tools/include/uapi/linux/if_link.h b/tools/include/uapi/linux/if_link.h
index e1ba2d51b717..ee5de9f3700b 100644
--- a/tools/include/uapi/linux/if_link.h
+++ b/tools/include/uapi/linux/if_link.h
@@ -888,6 +888,7 @@ enum {
 	IFLA_BOND_SLAVE_AD_AGGREGATOR_ID,
 	IFLA_BOND_SLAVE_AD_ACTOR_OPER_PORT_STATE,
 	IFLA_BOND_SLAVE_AD_PARTNER_OPER_PORT_STATE,
+	IFLA_BOND_SLAVE_PRIO,
 	__IFLA_BOND_SLAVE_MAX,
 };
 
-- 
2.35.1

