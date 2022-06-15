Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F07B54C031
	for <lists+netdev@lfdr.de>; Wed, 15 Jun 2022 05:30:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240422AbiFOD3w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 23:29:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240412AbiFOD3u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 23:29:50 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B65C46674
        for <netdev@vger.kernel.org>; Tue, 14 Jun 2022 20:29:49 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id bo5so10276159pfb.4
        for <netdev@vger.kernel.org>; Tue, 14 Jun 2022 20:29:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WjsI0+78hIrLLh73Y2HQU7tJPk4jmVxo74GksUwLW+Q=;
        b=P/klBSUb9vV0AWBTiiTB444gq/puz7dTVEFfRPMV8UiEzaMD7rt1Vbcp8aLlOE0LHO
         5znQwyItjUh7m37ljwPCf8ZfSE4MEb9iyREJRzc7NW83M0p8ET9VJBVnE1+I8ESLYPp9
         lto/3PzfOuLCT/WLnCcRcuvJJfk1qv0+bPfip9jWdcamBsoTxPTzv7npYshjLqPSilXY
         D7ElGpT78uEG4b0T2d5iks6dhfXszOy5+yeHkhn3by+eCe6DvNAjF5ZtQd12qoONafVW
         DSuWDYf1/gyG6/Bz5MRi/QxkLlkdiAeq/1dEYMYWJglkCTJlMWFQqvhU7M2lEWbDKGI5
         TWBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WjsI0+78hIrLLh73Y2HQU7tJPk4jmVxo74GksUwLW+Q=;
        b=rGu+Z8kAHO5sVfM8lm/jKnI8f6M9d1l1sTuRQMwbqdyJFtF5GHKehnbsW9DYFvWKpF
         xbKmvmzfg5rO/fhFb4f3SWCIeLG9Cl0sY9V12YIoI+Vkz5KS3khApzNCsNNoTz1EEa/L
         5k9tZR0R/kPw9vq+bg3t33FukpdZubxe4/yG7hYPnUdwvXd38CBvFjT4MXYuV/cjt/T5
         EfGe2ODUL47uwU2qQJ8D64woeBkrI2+F3KQ7I4iLwnFErmZv2Nu1/PYm82H2fziBuaQV
         HUS8lgfeWFuuZmsbbdVe1aFpgHMBykBBpbblLeaJHX6Wnm/m/HjuezwyM/u5J+Xj5TpC
         J0gw==
X-Gm-Message-State: AOAM533ibAdG/5q2KpCZktuNszEQucogFtz++xM66+p3EN4GomeWEYCQ
        sSDZkuwHzyFj/FrrWu8+U3s4Hsdpd54=
X-Google-Smtp-Source: ABdhPJy/DA2uiaLEr6e9qeUOYc33AdFLeAc+Ft5uGCjA91DNvZHlTGQc6kE2OXeblf6HVif/LSNGuQ==
X-Received: by 2002:a65:6e44:0:b0:3db:219e:2250 with SMTP id be4-20020a656e44000000b003db219e2250mr7138934pgb.369.1655263788209;
        Tue, 14 Jun 2022 20:29:48 -0700 (PDT)
Received: from Laptop-X1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id g23-20020aa78197000000b0051bd9981ccbsm8320594pfi.39.2022.06.14.20.29.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jun 2022 20:29:47 -0700 (PDT)
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
Subject: [PATCHv2 net-next] Bonding: add per-port priority for failover re-selection
Date:   Wed, 15 Jun 2022 11:29:34 +0800
Message-Id: <20220615032934.2057120-1-liuhangbin@gmail.com>
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

Add per port priority support for bonding active slave re-selection during
failover. A higher number means higher priority in selection. The primary
slave still has the highest priority. This option also follows the
primary_reselect rules.

This option could only be configured via netlink.

v2: using the extant bonding options management stuff instead setting
slave prio in bond_slave_changelink() directly.

Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 Documentation/networking/bonding.rst | 11 +++++
 drivers/net/bonding/bond_main.c      | 27 +++++++++++
 drivers/net/bonding/bond_netlink.c   | 19 ++++++++
 drivers/net/bonding/bond_options.c   | 67 ++++++++++++++++++++++++++++
 include/net/bond_options.h           |  1 +
 include/net/bonding.h                |  1 +
 include/uapi/linux/if_link.h         |  1 +
 tools/include/uapi/linux/if_link.h   |  1 +
 8 files changed, 128 insertions(+)

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
index 5a6f44455b95..41b3244747fa 100644
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
@@ -157,6 +162,20 @@ static int bond_slave_changelink(struct net_device *bond_dev,
 			return err;
 	}
 
+	if (data[IFLA_BOND_SLAVE_PRIO]) {
+		int prio = nla_get_s32(data[IFLA_BOND_SLAVE_PRIO]);
+		char prio_str[IFNAMSIZ + 7];
+
+		/* prio option setting expects slave_name:prio */
+		snprintf(prio_str, sizeof(prio_str), "%s:%d\n",
+			 slave_dev->name, prio);
+
+		bond_opt_initstr(&newval, prio_str);
+		err = __bond_opt_set(bond, BOND_OPT_PRIO, &newval);
+		if (err)
+			return err;
+	}
+
 	return 0;
 }
 
diff --git a/drivers/net/bonding/bond_options.c b/drivers/net/bonding/bond_options.c
index 96eef19cffc4..bac3858825b3 100644
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
@@ -1306,6 +1318,61 @@ static int bond_option_missed_max_set(struct bonding *bond,
 	return 0;
 }
 
+static int bond_option_prio_set(struct bonding *bond,
+				const struct bond_opt_value *newval)
+{
+	struct slave *slave, *update_slave;
+	struct net_device *sdev;
+	struct list_head *iter;
+	char *delim;
+	int ret = 0;
+	int prio;
+
+	/* delim will point to prio if successful */
+	delim = strchr(newval->string, ':');
+	if (!delim)
+		goto err_no_cmd;
+
+	/* Terminate string that points to device name and bump it
+	 * up one, so we can read the prio there.
+	 */
+	*delim = '\0';
+	if (sscanf(++delim, "%d\n", &prio) != 1)
+		goto err_no_cmd;
+
+	/* Valid ifname */
+	if (!dev_valid_name(newval->string))
+		goto err_no_cmd;
+
+	/* Get the pointer to that interface if it exists */
+	sdev = __dev_get_by_name(dev_net(bond->dev), newval->string);
+	if (!sdev)
+		goto err_no_cmd;
+
+	update_slave = NULL;
+	bond_for_each_slave(bond, slave, iter) {
+		if (sdev == slave->dev)
+			update_slave = slave;
+	}
+
+	if (!update_slave)
+		goto err_no_cmd;
+
+	/* Actually set the prio for the slave */
+	update_slave->prio = prio;
+
+	/* Do reselect after prio update */
+	bond_select_active_slave(bond);
+
+out:
+	return ret;
+
+err_no_cmd:
+	netdev_dbg(bond->dev, "invalid input for slave prio set\n");
+	ret = -EPERM;
+	goto out;
+}
+
 static int bond_option_primary_set(struct bonding *bond,
 				   const struct bond_opt_value *newval)
 {
diff --git a/include/net/bond_options.h b/include/net/bond_options.h
index 1618b76f4903..569808933094 100644
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

