Return-Path: <netdev+bounces-9522-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 340757299C0
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 14:23:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DF9B728193C
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 12:23:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B7871643A;
	Fri,  9 Jun 2023 12:22:19 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC594154B8
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 12:22:18 +0000 (UTC)
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C79835BE;
	Fri,  9 Jun 2023 05:22:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686313333; x=1717849333;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Zhbjko0NgU1oleUi+zxl4wXpj+Yil0aX0uPPaAmiadI=;
  b=YRaQr2P1qKzviuIA5OMebnRD1a8eMQQG2ROBRT4S6GNA6gbg9FOld29l
   z/EXO8mCxjUKc+ppGqQp781TIIPXHtcc/1uzTDRWjWXVgKXxkqXa0H1Pb
   jybVRc+FklYJ1zDirUdnpYHUEtchAAUCDLulPnc6QnVqUH89ODYHBenwa
   osw+AX0/MaX+efgvnvsj/cxjqX3j9iZqNBaNNlNa+vfp6rrVXss5QQOCS
   GlSWvYCXD7MyV10Q1XVihjfBzpv98xYBF/etpv3gqE7j08Pu/xAA2hUpW
   GVxbENeVUBjy4hhi6LgmdDH7v2dypghBmjBaeg6ZCu3iZCyfMxupPc/6M
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10735"; a="337220246"
X-IronPort-AV: E=Sophos;i="6.00,229,1681196400"; 
   d="scan'208";a="337220246"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2023 05:22:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10735"; a="710348658"
X-IronPort-AV: E=Sophos;i="6.00,229,1681196400"; 
   d="scan'208";a="710348658"
Received: from amlin-018-114.igk.intel.com ([10.102.18.114])
  by orsmga002.jf.intel.com with ESMTP; 09 Jun 2023 05:21:59 -0700
From: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
To: kuba@kernel.org,
	jiri@resnulli.us,
	arkadiusz.kubalewski@intel.com,
	vadfed@meta.com,
	jonathan.lemon@gmail.com,
	pabeni@redhat.com
Cc: corbet@lwn.net,
	davem@davemloft.net,
	edumazet@google.com,
	vadfed@fb.com,
	jesse.brandeburg@intel.com,
	anthony.l.nguyen@intel.com,
	saeedm@nvidia.com,
	leon@kernel.org,
	richardcochran@gmail.com,
	sj@kernel.org,
	javierm@redhat.com,
	ricardo.canuelo@collabora.com,
	mst@redhat.com,
	tzimmermann@suse.de,
	michal.michalik@intel.com,
	gregkh@linuxfoundation.org,
	jacek.lawrynowicz@linux.intel.com,
	airlied@redhat.com,
	ogabbay@kernel.org,
	arnd@arndb.de,
	nipun.gupta@amd.com,
	axboe@kernel.dk,
	linux@zary.sk,
	masahiroy@kernel.org,
	benjamin.tissoires@redhat.com,
	geert+renesas@glider.be,
	milena.olech@intel.com,
	kuniyu@amazon.com,
	liuhangbin@gmail.com,
	hkallweit1@gmail.com,
	andy.ren@getcruise.com,
	razor@blackwall.org,
	idosch@nvidia.com,
	lucien.xin@gmail.com,
	nicolas.dichtel@6wind.com,
	phil@nwl.cc,
	claudiajkang@gmail.com,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org,
	intel-wired-lan@lists.osuosl.org,
	linux-rdma@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	poros@redhat.com,
	mschmidt@redhat.com,
	linux-clk@vger.kernel.org,
	vadim.fedorenko@linux.dev,
	Jiri Pirko <jiri@nvidia.com>
Subject: [RFC PATCH v8 06/10] netdev: expose DPLL pin handle for netdevice
Date: Fri,  9 Jun 2023 14:18:49 +0200
Message-Id: <20230609121853.3607724-7-arkadiusz.kubalewski@intel.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20230609121853.3607724-1-arkadiusz.kubalewski@intel.com>
References: <20230609121853.3607724-1-arkadiusz.kubalewski@intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Jiri Pirko <jiri@nvidia.com>

In case netdevice represents a SyncE port, the user needs to understand
the connection between netdevice and associated DPLL pin. There might me
multiple netdevices pointing to the same pin, in case of VF/SF
implementation.

Add a IFLA Netlink attribute to nest the DPLL pin handle, similar to
how it is implemented for devlink port. Add a struct dpll_pin pointer
to netdev and protect access to it by RTNL. Expose netdev_dpll_pin_set()
and netdev_dpll_pin_clear() helpers to the drivers so they can set/clear
the DPLL pin relationship to netdev.

Note that during the lifetime of struct dpll_pin the pin handle does not
change. Therefore it is save to access it lockless. It is drivers
responsibility to call netdev_dpll_pin_clear() before dpll_pin_put().

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
---
 drivers/dpll/dpll_netlink.c  | 28 ++++++++++++++++++--------
 include/linux/dpll.h         | 20 +++++++++++++++++++
 include/linux/netdevice.h    | 10 ++++++++++
 include/uapi/linux/if_link.h |  2 ++
 net/core/dev.c               | 22 +++++++++++++++++++++
 net/core/rtnetlink.c         | 38 ++++++++++++++++++++++++++++++++++++
 6 files changed, 112 insertions(+), 8 deletions(-)

diff --git a/drivers/dpll/dpll_netlink.c b/drivers/dpll/dpll_netlink.c
index 44d9699c9e6c..e6efc17aaf26 100644
--- a/drivers/dpll/dpll_netlink.c
+++ b/drivers/dpll/dpll_netlink.c
@@ -214,10 +214,9 @@ dpll_msg_add_pin_parents(struct sk_buff *msg, struct dpll_pin *pin,
 		nest = nla_nest_start(msg, DPLL_A_PIN_PARENT);
 		if (!nest)
 			return -EMSGSIZE;
-		if (nla_put_u32(msg, DPLL_A_PIN_ID, ppin->id)) {
-			ret = -EMSGSIZE;
+		ret = dpll_msg_add_pin_handle(msg, ppin);
+		if (ret)
 			goto nest_cancel;
-		}
 		if (nla_put_u8(msg, DPLL_A_PIN_STATE, state)) {
 			ret = -EMSGSIZE;
 			goto nest_cancel;
@@ -274,8 +273,9 @@ dpll_cmd_pin_fill_details(struct sk_buff *msg, struct dpll_pin *pin,
 	const struct dpll_pin_properties *prop = pin->prop;
 	int ret;
 
-	if (nla_put_u32(msg, DPLL_A_PIN_ID, pin->id))
-		return -EMSGSIZE;
+	ret = dpll_msg_add_pin_handle(msg, pin);
+	if (ret)
+		return ret;
 	if (nla_put_string(msg, DPLL_A_MODULE_NAME, module_name(pin->module)))
 		return -EMSGSIZE;
 	if (nla_put_64bit(msg, DPLL_A_CLOCK_ID, sizeof(pin->clock_id),
@@ -301,6 +301,20 @@ dpll_cmd_pin_fill_details(struct sk_buff *msg, struct dpll_pin *pin,
 	return 0;
 }
 
+size_t dpll_msg_pin_handle_size(struct dpll_pin *pin)
+{
+	return nla_total_size(4); /* DPLL_A_PIN_ID */
+}
+EXPORT_SYMBOL_GPL(dpll_msg_pin_handle_size);
+
+int dpll_msg_add_pin_handle(struct sk_buff *msg, struct dpll_pin *pin)
+{
+	if (nla_put_u32(msg, DPLL_A_PIN_ID, pin->id))
+		return -EMSGSIZE;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(dpll_msg_add_pin_handle);
+
 static int
 __dpll_cmd_pin_dump_one(struct sk_buff *msg, struct dpll_pin *pin,
 			struct netlink_ext_ack *extack)
@@ -690,9 +704,7 @@ dpll_pin_find_from_nlattr(struct genl_info *info, struct sk_buff *skb)
 			    panel_label_attr, package_label_attr);
 	if (!pin)
 		return -EINVAL;
-	if (nla_put_u32(skb, DPLL_A_PIN_ID, pin->id))
-		return -EMSGSIZE;
-	return 0;
+	return dpll_msg_add_pin_handle(skb, pin);
 }
 
 int dpll_nl_pin_id_get_doit(struct sk_buff *skb, struct genl_info *info)
diff --git a/include/linux/dpll.h b/include/linux/dpll.h
index a18bcaa13553..8d085dc92cdd 100644
--- a/include/linux/dpll.h
+++ b/include/linux/dpll.h
@@ -108,6 +108,26 @@ struct dpll_pin_properties {
 	struct dpll_pin_frequency *freq_supported;
 };
 
+#if IS_ENABLED(CONFIG_DPLL)
+
+size_t dpll_msg_pin_handle_size(struct dpll_pin *pin);
+
+int dpll_msg_add_pin_handle(struct sk_buff *msg, struct dpll_pin *pin);
+
+#else
+
+static inline size_t dpll_msg_pin_handle_size(struct dpll_pin *pin)
+{
+	return 0;
+}
+
+static inline int dpll_msg_add_pin_handle(struct sk_buff *msg, struct dpll_pin *pin)
+{
+	return 0;
+}
+
+#endif
+
 struct dpll_device
 *dpll_device_get(u64 clock_id, u32 dev_driver_id, struct module *module);
 
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 08fbd4622ccf..c57723b12f75 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -34,6 +34,7 @@
 #include <linux/rculist.h>
 #include <linux/workqueue.h>
 #include <linux/dynamic_queue_limits.h>
+#include <linux/dpll.h>
 
 #include <net/net_namespace.h>
 #ifdef CONFIG_DCB
@@ -2055,6 +2056,9 @@ enum netdev_ml_priv_type {
  *			SET_NETDEV_DEVLINK_PORT macro. This pointer is static
  *			during the time netdevice is registered.
  *
+ *	@dpll_pin: Pointer to the SyncE source pin of a DPLL subsystem,
+ *		   where the clock is recovered.
+ *
  *	FIXME: cleanup struct net_device such that network protocol info
  *	moves out.
  */
@@ -2411,6 +2415,10 @@ struct net_device {
 	struct rtnl_hw_stats64	*offload_xstats_l3;
 
 	struct devlink_port	*devlink_port;
+
+#if IS_ENABLED(CONFIG_DPLL)
+	struct dpll_pin		*dpll_pin;
+#endif
 };
 #define to_net_dev(d) container_of(d, struct net_device, dev)
 
@@ -3954,6 +3962,8 @@ int dev_get_mac_address(struct sockaddr *sa, struct net *net, char *dev_name);
 int dev_get_port_parent_id(struct net_device *dev,
 			   struct netdev_phys_item_id *ppid, bool recurse);
 bool netdev_port_same_parent_id(struct net_device *a, struct net_device *b);
+void netdev_dpll_pin_set(struct net_device *dev, struct dpll_pin *dpll_pin);
+void netdev_dpll_pin_clear(struct net_device *dev);
 struct sk_buff *validate_xmit_skb_list(struct sk_buff *skb, struct net_device *dev, bool *again);
 struct sk_buff *dev_hard_start_xmit(struct sk_buff *skb, struct net_device *dev,
 				    struct netdev_queue *txq, int *ret);
diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index 0f6a0fe09bdb..be03c8292cd7 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -377,6 +377,8 @@ enum {
 	IFLA_GSO_IPV4_MAX_SIZE,
 	IFLA_GRO_IPV4_MAX_SIZE,
 
+	IFLA_DPLL_PIN,
+
 	__IFLA_MAX
 };
 
diff --git a/net/core/dev.c b/net/core/dev.c
index 99d99b247bc9..7ae0ce75a5c7 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -8993,6 +8993,28 @@ bool netdev_port_same_parent_id(struct net_device *a, struct net_device *b)
 }
 EXPORT_SYMBOL(netdev_port_same_parent_id);
 
+static void netdev_dpll_pin_assign(struct net_device *dev, struct dpll_pin *dpll_pin)
+{
+#if IS_ENABLED(CONFIG_DPLL)
+	rtnl_lock();
+	dev->dpll_pin = dpll_pin;
+	rtnl_unlock();
+#endif
+}
+
+void netdev_dpll_pin_set(struct net_device *dev, struct dpll_pin *dpll_pin)
+{
+	WARN_ON(!dpll_pin);
+	netdev_dpll_pin_assign(dev, dpll_pin);
+}
+EXPORT_SYMBOL(netdev_dpll_pin_set);
+
+void netdev_dpll_pin_clear(struct net_device *dev)
+{
+	netdev_dpll_pin_assign(dev, NULL);
+}
+EXPORT_SYMBOL(netdev_dpll_pin_clear);
+
 /**
  *	dev_change_proto_down - set carrier according to proto_down.
  *
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 41de3a2f29e1..ebe9ae8608fc 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -1052,6 +1052,16 @@ static size_t rtnl_devlink_port_size(const struct net_device *dev)
 	return size;
 }
 
+static size_t rtnl_dpll_pin_size(const struct net_device *dev)
+{
+	size_t size = nla_total_size(0); /* nest IFLA_DPLL_PIN */
+
+	if (dev->dpll_pin)
+		size += dpll_msg_pin_handle_size(dev->dpll_pin);
+
+	return size;
+}
+
 static noinline size_t if_nlmsg_size(const struct net_device *dev,
 				     u32 ext_filter_mask)
 {
@@ -1108,6 +1118,7 @@ static noinline size_t if_nlmsg_size(const struct net_device *dev,
 	       + rtnl_prop_list_size(dev)
 	       + nla_total_size(MAX_ADDR_LEN) /* IFLA_PERM_ADDRESS */
 	       + rtnl_devlink_port_size(dev)
+	       + rtnl_dpll_pin_size(dev)
 	       + 0;
 }
 
@@ -1769,6 +1780,30 @@ static int rtnl_fill_devlink_port(struct sk_buff *skb,
 	return ret;
 }
 
+static int rtnl_fill_dpll_pin(struct sk_buff *skb,
+			      const struct net_device *dev)
+{
+	struct nlattr *dpll_pin_nest;
+	int ret;
+
+	dpll_pin_nest = nla_nest_start(skb, IFLA_DPLL_PIN);
+	if (!dpll_pin_nest)
+		return -EMSGSIZE;
+
+	if (dev->dpll_pin) {
+		ret = dpll_msg_add_pin_handle(skb, dev->dpll_pin);
+		if (ret < 0)
+			goto nest_cancel;
+	}
+
+	nla_nest_end(skb, dpll_pin_nest);
+	return 0;
+
+nest_cancel:
+	nla_nest_cancel(skb, dpll_pin_nest);
+	return ret;
+}
+
 static int rtnl_fill_ifinfo(struct sk_buff *skb,
 			    struct net_device *dev, struct net *src_net,
 			    int type, u32 pid, u32 seq, u32 change,
@@ -1911,6 +1946,9 @@ static int rtnl_fill_ifinfo(struct sk_buff *skb,
 	if (rtnl_fill_devlink_port(skb, dev))
 		goto nla_put_failure;
 
+	if (rtnl_fill_dpll_pin(skb, dev))
+		goto nla_put_failure;
+
 	nlmsg_end(skb, nlh);
 	return 0;
 
-- 
2.37.3


