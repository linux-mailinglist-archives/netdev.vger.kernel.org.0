Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C9F43E43D0
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 12:22:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234509AbhHIKWs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 06:22:48 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:44887 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234344AbhHIKWn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Aug 2021 06:22:43 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.nyi.internal (Postfix) with ESMTP id E7CF25C00CE;
        Mon,  9 Aug 2021 06:22:20 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Mon, 09 Aug 2021 06:22:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=vYJT8H8ACxsHWzoto/oj9HCCktdxmpAiKZRuDOB9FCk=; b=W0xw+C/0
        bRLWyhZWfcpVlGwFlarmDRFprG0XU90YY5pKdqlE1fAmVaHCJ1kDeEVesV16P3li
        F9FsV78f5zhBtAawhbjV/yFeg2w/A+PIlPzI6zxLWSsWu7G1wY2mbwWqe60pPCmz
        m95zdoezWh9nf5w5DRV7pJ8HRH1d0adqIQPWb7jro3lIrP9N07u3AeXgIJWz8Hac
        dwn/vSgL7VxYrrYfXe4IWLL/VO9lA8sffy+U7IdqI2NF3rgTgVATX/IFsFfYbDmb
        04/T+5w0upITmBos8KbRIZ8eOHeHAKR80TIcWYxYW3d38jqHyI4FE8rCumsjMmGt
        MVkd7yhAA34DWQ==
X-ME-Sender: <xms:3AERYfVKwJSP9vV4G7CiJO43187wjPhs0bMz6pcIZf3_FgJAx-RPHA>
    <xme:3AERYXkkCvGxlBH5eN3TJyB_yw_N7giYiYQFG5FP-iS7nmEDQbhwEWfbYGCkdmMe7
    r_EA-UvlBbknfg>
X-ME-Received: <xmr:3AERYbaVAkPz-KrOWvF9i76OvFxy4hDerIDo1CNi245vd07G-PEpJEa6rH-fXHNiaoCefv9r-WAQ6NVNaIgP9bjxAHp1Il1n8vLSIC9ttwJ8ig>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrjeejgddvkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhfekhe
    fgtdfftefhledvjefggfehgfevjeekhfenucevlhhushhtvghrufhiiigvpedtnecurfgr
    rhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:3AERYaWuRvcCEr3cPDOCVihHEtY8xh89ChlDZXJARLsuYSkJzTUdYA>
    <xmx:3AERYZleYByFOmWJgZDy8MaxUjNgisolsH5CzyR4NmcSgl7erLUqag>
    <xmx:3AERYXdZ-A2FZEvcYlcvL1kx9hTBMRQeUb1dE7fkp1Fp9nAu053Y6g>
    <xmx:3AERYXZX2scNsLbR48VZx3y904Z8cASlXK4NctWNgTYBbdqMBgSAMg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 9 Aug 2021 06:22:18 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        mkubecek@suse.cz, pali@kernel.org, vadimp@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [RFC PATCH net-next 2/8] ethtool: Add ability to reset transceiver modules
Date:   Mon,  9 Aug 2021 13:21:46 +0300
Message-Id: <20210809102152.719961-3-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210809102152.719961-1-idosch@idosch.org>
References: <20210809102152.719961-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Add a new ethtool message, 'ETHTOOL_MSG_MODULE_RESET_ACT', which allows
user space to request a reset of transceiver modules. A successful reset
results in a notification being emitted to user space in the form of a
'ETHTOOL_MSG_MODULE_RESET_NTF' message.

Reset can be performed by either asserting the relevant hardware signal
("Reset" in CMIS / "ResetL" in SFF-8636) or by writing to the relevant
reset bit in the module's EEPROM (page 00h, byte 26, bit 3 in CMIS /
page 00h, byte 93, bit 7 in SFF-8636).

Reset is useful in order to allow a module to transition out of a fault
state. From section 6.3.2.12 in CMIS 5.0: "Except for a power cycle, the
only exit path from the ModuleFault state is to perform a module reset
by taking an action that causes the ResetS transition signal to become
TRUE (see Table 6-11)".

To avoid changes to the operational state of the device, reset can only
be performed when the device is administratively down.

Example usage:

 # ethtool --reset-module swp11
 netlink error: Cannot reset module when port is administratively up
 netlink error: Invalid argument

 # ip link set dev swp11 down

 # ethtool --reset-module swp11

Monitor notifications:

 $ ethtool --monitor
 listening...

 Module reset done for swp11

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 Documentation/networking/ethtool-netlink.rst | 28 +++++++
 include/linux/ethtool.h                      |  3 +
 include/uapi/linux/ethtool_netlink.h         |  2 +
 net/ethtool/module.c                         | 80 ++++++++++++++++++++
 net/ethtool/netlink.c                        |  7 ++
 net/ethtool/netlink.h                        |  2 +
 6 files changed, 122 insertions(+)

diff --git a/Documentation/networking/ethtool-netlink.rst b/Documentation/networking/ethtool-netlink.rst
index 07eac5bc9cfc..4e4d0c6a943e 100644
--- a/Documentation/networking/ethtool-netlink.rst
+++ b/Documentation/networking/ethtool-netlink.rst
@@ -215,6 +215,7 @@ Userspace to kernel:
   ``ETHTOOL_MSG_PHC_VCLOCKS_GET``       get PHC virtual clocks info
   ``ETHTOOL_MSG_MODULE_SET``            set transceiver module parameters
   ``ETHTOOL_MSG_MODULE_GET``            get transceiver module parameters
+  ``ETHTOOL_MSG_MODULE_RESET_ACT``      action reset transceiver module
   ===================================== =================================
 
 Kernel to userspace:
@@ -255,6 +256,7 @@ Kernel to userspace:
   ``ETHTOOL_MSG_STATS_GET_REPLY``          standard statistics
   ``ETHTOOL_MSG_PHC_VCLOCKS_GET_REPLY``    PHC virtual clocks info
   ``ETHTOOL_MSG_MODULE_GET_REPLY``         transceiver module parameters
+  ``ETHTOOL_MSG_MODULE_RESET_NTF``         transceiver module reset
   ======================================== =================================
 
 ``GET`` requests are sent by userspace applications to retrieve device
@@ -1547,6 +1549,31 @@ For SFF-8636 modules, low power mode is forced by the host according to table
 For CMIS modules, low power mode is forced by the host according to table 6-12
 in revision 5.0 of the specification.
 
+MODULE_RESET_ACT
+================
+
+Resets the transceiver module to its initial state, as if it was just
+plugged-in. The Module State Machine (MSM) is reset to the "Reset" steady state
+and module's registers are reset to their default values.
+
+Action contents:
+
+  ======================================  ======  ==========================
+  ``ETHTOOL_A_MODULE_HEADER``             nested  request header
+  ======================================  ======  ==========================
+
+Upon a successful reset, a ``ETHTOOL_MSG_MODULE_RESET_NTF`` notification is
+sent to user space.
+
+To avoid changes to the operational state of the device, reset can only be
+performed when the device is administratively down.
+
+For SFF-8636 modules, reset can be implemented according to section 4.4.3 in
+revision 2.10a of the specification.
+
+For CMIS modules, reset can be implemented according to table 6-11 in revision
+5.0 of the specification.
+
 Request translation
 ===================
 
@@ -1648,4 +1675,5 @@ are netlink only.
   n/a                                 ``ETHTOOL_MSG_PHC_VCLOCKS_GET``
   n/a                                 ``ETHTOOL_MSG_MODULE_GET``
   n/a                                 ``ETHTOOL_MSG_MODULE_SET``
+  n/a                                 ``ETHTOOL_MSG_MODULE_RESET_ACT``
   =================================== =====================================
diff --git a/include/linux/ethtool.h b/include/linux/ethtool.h
index 04286debdcdc..ab67b061be32 100644
--- a/include/linux/ethtool.h
+++ b/include/linux/ethtool.h
@@ -574,6 +574,7 @@ struct ethtool_module_eeprom {
  *	used by the network device.
  * @set_module_low_power: Set the low power mode status of the plug-in module
  *	used by the network device.
+ * @reset_module: Reset the plug-in module used by the network device.
  *
  * All operations are optional (i.e. the function pointer may be set
  * to %NULL) and callers must take this into account.  Callers must
@@ -698,6 +699,8 @@ struct ethtool_ops {
 					struct netlink_ext_ack *extack);
 	int	(*set_module_low_power)(struct net_device *dev, bool low_power,
 					struct netlink_ext_ack *extack);
+	int	(*reset_module)(struct net_device *dev,
+				struct netlink_ext_ack *extack);
 };
 
 int ethtool_check_ops(const struct ethtool_ops *ops);
diff --git a/include/uapi/linux/ethtool_netlink.h b/include/uapi/linux/ethtool_netlink.h
index 72fb821f3928..4e1c1baad250 100644
--- a/include/uapi/linux/ethtool_netlink.h
+++ b/include/uapi/linux/ethtool_netlink.h
@@ -49,6 +49,7 @@ enum {
 	ETHTOOL_MSG_PHC_VCLOCKS_GET,
 	ETHTOOL_MSG_MODULE_GET,
 	ETHTOOL_MSG_MODULE_SET,
+	ETHTOOL_MSG_MODULE_RESET_ACT,
 
 	/* add new constants above here */
 	__ETHTOOL_MSG_USER_CNT,
@@ -94,6 +95,7 @@ enum {
 	ETHTOOL_MSG_PHC_VCLOCKS_GET_REPLY,
 	ETHTOOL_MSG_MODULE_GET_REPLY,
 	ETHTOOL_MSG_MODULE_NTF,
+	ETHTOOL_MSG_MODULE_RESET_NTF,
 
 	/* add new constants above here */
 	__ETHTOOL_MSG_KERNEL_CNT,
diff --git a/net/ethtool/module.c b/net/ethtool/module.c
index 947f2188d725..f5b730eb0645 100644
--- a/net/ethtool/module.c
+++ b/net/ethtool/module.c
@@ -182,3 +182,83 @@ int ethnl_set_module(struct sk_buff *skb, struct genl_info *info)
 	dev_put(dev);
 	return ret;
 }
+
+/* MODULE_RESET_ACT */
+
+const struct nla_policy ethnl_module_reset_act_policy[ETHTOOL_A_MODULE_HEADER + 1] = {
+	[ETHTOOL_A_MODULE_HEADER] = NLA_POLICY_NESTED(ethnl_header_policy),
+};
+
+static void ethnl_module_reset_done(struct net_device *dev)
+{
+	struct sk_buff *skb;
+	void *ehdr;
+	int ret;
+
+	skb = genlmsg_new(NLMSG_GOODSIZE, GFP_KERNEL);
+	if (!skb)
+		return;
+
+	ehdr = ethnl_bcastmsg_put(skb, ETHTOOL_MSG_MODULE_RESET_NTF);
+	if (!ehdr)
+		goto out;
+
+	ret = ethnl_fill_reply_header(skb, dev, ETHTOOL_A_MODULE_HEADER);
+	if (ret < 0)
+		goto out;
+
+	genlmsg_end(skb, ehdr);
+	ethnl_multicast(skb, dev);
+	return;
+
+out:
+	nlmsg_free(skb);
+}
+
+int ethnl_act_module_reset(struct sk_buff *skb, struct genl_info *info)
+{
+	struct ethnl_req_info req_info = {};
+	struct nlattr **tb = info->attrs;
+	const struct ethtool_ops *ops;
+	struct net_device *dev;
+	int ret;
+
+	ret = ethnl_parse_header_dev_get(&req_info,
+					 tb[ETHTOOL_A_MODULE_HEADER],
+					 genl_info_net(info), info->extack,
+					 true);
+	if (ret < 0)
+		return ret;
+
+	dev = req_info.dev;
+
+	rtnl_lock();
+	ops = dev->ethtool_ops;
+	if (!ops->reset_module) {
+		ret = -EOPNOTSUPP;
+		goto out_rtnl;
+	}
+
+	if (netif_running(dev)) {
+		NL_SET_ERR_MSG(info->extack,
+			       "Cannot reset module when port is administratively up");
+		ret = -EINVAL;
+		goto out_rtnl;
+	}
+
+	ret = ethnl_ops_begin(dev);
+	if (ret < 0)
+		goto out_rtnl;
+
+	ret = ops->reset_module(dev, info->extack);
+
+	ethnl_ops_complete(dev);
+
+	if (!ret)
+		ethnl_module_reset_done(dev);
+
+out_rtnl:
+	rtnl_unlock();
+	dev_put(dev);
+	return ret;
+}
diff --git a/net/ethtool/netlink.c b/net/ethtool/netlink.c
index 38b44c0291b1..8558caa1a963 100644
--- a/net/ethtool/netlink.c
+++ b/net/ethtool/netlink.c
@@ -1018,6 +1018,13 @@ static const struct genl_ops ethtool_genl_ops[] = {
 		.policy = ethnl_module_set_policy,
 		.maxattr = ARRAY_SIZE(ethnl_module_set_policy) - 1,
 	},
+	{
+		.cmd	= ETHTOOL_MSG_MODULE_RESET_ACT,
+		.flags	= GENL_UNS_ADMIN_PERM,
+		.doit	= ethnl_act_module_reset,
+		.policy = ethnl_module_reset_act_policy,
+		.maxattr = ARRAY_SIZE(ethnl_module_reset_act_policy) - 1,
+	},
 };
 
 static const struct genl_multicast_group ethtool_nl_mcgrps[] = {
diff --git a/net/ethtool/netlink.h b/net/ethtool/netlink.h
index cf0fcbfe3c5c..7087cd20c4d0 100644
--- a/net/ethtool/netlink.h
+++ b/net/ethtool/netlink.h
@@ -376,6 +376,7 @@ extern const struct nla_policy ethnl_stats_get_policy[ETHTOOL_A_STATS_GROUPS + 1
 extern const struct nla_policy ethnl_phc_vclocks_get_policy[ETHTOOL_A_PHC_VCLOCKS_HEADER + 1];
 extern const struct nla_policy ethnl_module_get_policy[ETHTOOL_A_MODULE_HEADER + 1];
 extern const struct nla_policy ethnl_module_set_policy[ETHTOOL_A_MODULE_LOW_POWER_ENABLED + 1];
+extern const struct nla_policy ethnl_module_reset_act_policy[ETHTOOL_A_MODULE_HEADER + 1];
 
 int ethnl_set_linkinfo(struct sk_buff *skb, struct genl_info *info);
 int ethnl_set_linkmodes(struct sk_buff *skb, struct genl_info *info);
@@ -395,6 +396,7 @@ int ethnl_tunnel_info_start(struct netlink_callback *cb);
 int ethnl_tunnel_info_dumpit(struct sk_buff *skb, struct netlink_callback *cb);
 int ethnl_set_fec(struct sk_buff *skb, struct genl_info *info);
 int ethnl_set_module(struct sk_buff *skb, struct genl_info *info);
+int ethnl_act_module_reset(struct sk_buff *skb, struct genl_info *info);
 
 extern const char stats_std_names[__ETHTOOL_STATS_CNT][ETH_GSTRING_LEN];
 extern const char stats_eth_phy_names[__ETHTOOL_A_STATS_ETH_PHY_CNT][ETH_GSTRING_LEN];
-- 
2.31.1

