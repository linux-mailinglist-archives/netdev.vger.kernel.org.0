Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD6CC552C57
	for <lists+netdev@lfdr.de>; Tue, 21 Jun 2022 09:49:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347280AbiFUHtn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jun 2022 03:49:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347506AbiFUHtl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jun 2022 03:49:41 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2CB424098
        for <netdev@vger.kernel.org>; Tue, 21 Jun 2022 00:49:40 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id g16-20020a17090a7d1000b001ea9f820449so12884280pjl.5
        for <netdev@vger.kernel.org>; Tue, 21 Jun 2022 00:49:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7/hDpS6blyjZMuwrDXbiRBMkALAdUgXcxq+o8msad28=;
        b=WUbHaF6945hsiJnYEpfWzL+v7Q6tWWxAgn1BOEkDkrqtFU7w1/UCzRkgc1G48pEigx
         nMPJWWgHtiqvgg3RfAVwv2DydQC+X6D/ZRou8Jplyq1wVWQeRle2rLps1a+n2pOnYz/a
         ZBkP8+t+uMndVaUIBmkIgGU9GVP8C1fsi58hXemnlkQcXszSDjDTyt3XZUyaWaVH50q5
         FFKq0mHf5KMYJYykOGxN4ekGYFbw3b8yxSlZF+OhLW92oAqfpLBsGJkttaoEkousacw3
         p/ZRKBmEwPtQRPQzLX72KsuftsBl9b/hvXXnMkT+3Dxo1sqIIehX1jkDOMACamYZ86RT
         U5MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7/hDpS6blyjZMuwrDXbiRBMkALAdUgXcxq+o8msad28=;
        b=ntGgGLT3lWiUjokvayO7/Tafin7jZgedU8GSYWkSYFkWKO/qJ1aFYNuyk7bgZP3CLH
         esJT9uz1ZiI5YmDPsmjb5LniAvqjw4ATwzDyYvWgKQ2GVp3pg+xEhha1c5eJ4CimSZJg
         RQrpkJ32X3jJiE+bFX97Lep7/4RkQelRdlXF5RjReVc7v4lAwo/iyhZ01SZwMUgR9dn+
         A56NXXpQeCV30alX6nJkKTirmK1ViD3oBERswgNvdiTAoa0xLDRoRZCa9zF6Ens7SANE
         rBB+Yc+8k/XrjoxEZPD486dnolQrCDRMtcfYu3EOPY6fO+X6R/a0xqL+qmGHTZi/7WQc
         XPYg==
X-Gm-Message-State: AJIora9bipmMNYnWNA9J5uIdZ5CY3FfTVhf5cfKboOl+2JiEOaofTDli
        1RaYk3yOD6+WEkIg2s6lr2W4ODwKfbk=
X-Google-Smtp-Source: AGRyM1saxwD8ibTA3dNzG7k3B1PEqvZXJzjy7mYx/bpVEy/e3aL7XMpKDqB+56e3go+3xrmFYZ0cRQ==
X-Received: by 2002:a17:90a:f318:b0:1ec:b74b:9b82 with SMTP id ca24-20020a17090af31800b001ecb74b9b82mr6817944pjb.198.1655797780223;
        Tue, 21 Jun 2022 00:49:40 -0700 (PDT)
Received: from Laptop-X1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id mm5-20020a17090b358500b001ecd3034b66sm8119pjb.54.2022.06.21.00.49.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jun 2022 00:49:39 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Toppins <jtoppins@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCHv3 net-next 2/2] Bonding: add per-port priority for failover re-selection
Date:   Tue, 21 Jun 2022 15:49:19 +0800
Message-Id: <20220621074919.2636622-3-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220621074919.2636622-1-liuhangbin@gmail.com>
References: <20220621074919.2636622-1-liuhangbin@gmail.com>
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

Add per port priority support for bonding active slave re-selection during
failover. A higher number means higher priority in selection. The primary
slave still has the highest priority. This option also follows the
primary_reselect rules.

This option could only be configured via netlink.

Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
v3: store slave_dev in bond_opt_value directly to simplify setting
    values for slave.

v2: using the extant bonding options management stuff instead setting
    slave prio in bond_slave_changelink() directly.
---
 Documentation/networking/bonding.rst | 11 ++++++++++
 drivers/net/bonding/bond_main.c      | 27 +++++++++++++++++++++++
 drivers/net/bonding/bond_netlink.c   | 15 +++++++++++++
 drivers/net/bonding/bond_options.c   | 33 ++++++++++++++++++++++++++++
 include/net/bond_options.h           |  1 +
 include/net/bonding.h                |  1 +
 include/uapi/linux/if_link.h         |  1 +
 tools/include/uapi/linux/if_link.h   |  1 +
 8 files changed, 90 insertions(+)

diff --git a/Documentation/networking/bonding.rst b/Documentation/networking/bonding.rst
index 43be3782e5df..53a18ff7cf23 100644
--- a/Documentation/networking/bonding.rst
+++ b/Documentation/networking/bonding.rst
@@ -780,6 +780,17 @@ peer_notif_delay
 	value is 0 which means to match the value of the link monitor
 	interval.
 
+prio
+	Slave priority. A higher number means higher priority.
+	The primary slave has the highest priority. This option also
+	follows the primary_reselect rules.
+
+	This option could only be configured via netlink, and is only valid
+	for active-backup(1), balance-tlb (5) and balance-alb (6) mode.
+	The valid value range is a signed 32 bit integer.
+
+	The default value is 0.
+
 primary
 
 	A string (eth0, eth2, etc) specifying which slave is the
diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 3d427183ec8e..3415a0feea07 100644
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
+				hprio = hprio ?: slave;
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
index 5a6f44455b95..c2d080fc4fc4 100644
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
@@ -157,6 +162,16 @@ static int bond_slave_changelink(struct net_device *bond_dev,
 			return err;
 	}
 
+	if (data[IFLA_BOND_SLAVE_PRIO]) {
+		int prio = nla_get_s32(data[IFLA_BOND_SLAVE_PRIO]);
+
+		bond_opt_slave_initval(&newval, &slave_dev, prio);
+		err = __bond_opt_set(bond, BOND_OPT_PRIO, &newval,
+				     data[IFLA_BOND_SLAVE_PRIO], extack);
+		if (err)
+			return err;
+	}
+
 	return 0;
 }
 
diff --git a/drivers/net/bonding/bond_options.c b/drivers/net/bonding/bond_options.c
index 96eef19cffc4..3498db1c1b3c 100644
--- a/drivers/net/bonding/bond_options.c
+++ b/drivers/net/bonding/bond_options.c
@@ -40,6 +40,8 @@ static int bond_option_arp_validate_set(struct bonding *bond,
 					const struct bond_opt_value *newval);
 static int bond_option_arp_all_targets_set(struct bonding *bond,
 					   const struct bond_opt_value *newval);
+static int bond_option_prio_set(struct bonding *bond,
+				const struct bond_opt_value *newval);
 static int bond_option_primary_set(struct bonding *bond,
 				   const struct bond_opt_value *newval);
 static int bond_option_primary_reselect_set(struct bonding *bond,
@@ -365,6 +367,16 @@ static const struct bond_option bond_opts[BOND_OPT_LAST] = {
 		.values = bond_intmax_tbl,
 		.set = bond_option_miimon_set
 	},
+	[BOND_OPT_PRIO] = {
+		.id = BOND_OPT_PRIO,
+		.name = "prio",
+		.desc = "Link priority for failover re-selection",
+		.flags = BOND_OPTFLAG_RAWVAL,
+		.unsuppmodes = BOND_MODE_ALL_EX(BIT(BOND_MODE_ACTIVEBACKUP) |
+						BIT(BOND_MODE_TLB) |
+						BIT(BOND_MODE_ALB)),
+		.set = bond_option_prio_set
+	},
 	[BOND_OPT_PRIMARY] = {
 		.id = BOND_OPT_PRIMARY,
 		.name = "primary",
@@ -1306,6 +1318,27 @@ static int bond_option_missed_max_set(struct bonding *bond,
 	return 0;
 }
 
+static int bond_option_prio_set(struct bonding *bond,
+				const struct bond_opt_value *newval)
+{
+	struct slave *slave;
+
+	slave = bond_slave_get_rtnl(newval->slave_dev);
+	if (!slave) {
+		netdev_dbg(newval->slave_dev, "%s called on NULL slave\n", __func__);
+		return -ENODEV;
+	}
+	slave->prio = newval->value;
+
+	if (rtnl_dereference(bond->primary_slave))
+		slave_warn(bond->dev, slave->dev,
+			   "prio updated, but will not affect failover re-selection as primary slave have been set\n");
+	else
+		bond_select_active_slave(bond);
+
+	return 0;
+}
+
 static int bond_option_primary_set(struct bonding *bond,
 				   const struct bond_opt_value *newval)
 {
diff --git a/include/net/bond_options.h b/include/net/bond_options.h
index eade8236a4df..d2aea5cf1e41 100644
--- a/include/net/bond_options.h
+++ b/include/net/bond_options.h
@@ -67,6 +67,7 @@ enum {
 	BOND_OPT_LACP_ACTIVE,
 	BOND_OPT_MISSED_MAX,
 	BOND_OPT_NS_TARGETS,
+	BOND_OPT_PRIO,
 	BOND_OPT_LAST
 };
 
diff --git a/include/net/bonding.h b/include/net/bonding.h
index cb904d356e31..6e78d657aa05 100644
--- a/include/net/bonding.h
+++ b/include/net/bonding.h
@@ -178,6 +178,7 @@ struct slave {
 	u32    speed;
 	u16    queue_id;
 	u8     perm_hwaddr[MAX_ADDR_LEN];
+	int    prio;
 	struct ad_slave_info *ad_info;
 	struct tlb_slave_info tlb_info;
 #ifdef CONFIG_NET_POLL_CONTROLLER
diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index 5f58dcfe2787..e36d9d2c65a7 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -963,6 +963,7 @@ enum {
 	IFLA_BOND_SLAVE_AD_AGGREGATOR_ID,
 	IFLA_BOND_SLAVE_AD_ACTOR_OPER_PORT_STATE,
 	IFLA_BOND_SLAVE_AD_PARTNER_OPER_PORT_STATE,
+	IFLA_BOND_SLAVE_PRIO,
 	__IFLA_BOND_SLAVE_MAX,
 };
 
diff --git a/tools/include/uapi/linux/if_link.h b/tools/include/uapi/linux/if_link.h
index b339bf2196ca..0242f31e339c 100644
--- a/tools/include/uapi/linux/if_link.h
+++ b/tools/include/uapi/linux/if_link.h
@@ -890,6 +890,7 @@ enum {
 	IFLA_BOND_SLAVE_AD_AGGREGATOR_ID,
 	IFLA_BOND_SLAVE_AD_ACTOR_OPER_PORT_STATE,
 	IFLA_BOND_SLAVE_AD_PARTNER_OPER_PORT_STATE,
+	IFLA_BOND_SLAVE_PRIO,
 	__IFLA_BOND_SLAVE_MAX,
 };
 
-- 
2.35.1

