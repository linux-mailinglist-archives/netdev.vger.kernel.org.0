Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2B8A1F5067
	for <lists+netdev@lfdr.de>; Wed, 10 Jun 2020 10:38:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726876AbgFJIiR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jun 2020 04:38:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726842AbgFJIiD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jun 2020 04:38:03 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57BC1C03E96B
        for <netdev@vger.kernel.org>; Wed, 10 Jun 2020 01:38:03 -0700 (PDT)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1jiwF5-0000Ij-ST; Wed, 10 Jun 2020 10:37:51 +0200
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1jiwF1-00022u-Nq; Wed, 10 Jun 2020 10:37:47 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Michal Kubecek <mkubecek@suse.cz>,
        "John W. Linville" <linville@tuxdriver.com>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        David Jander <david@protonic.nl>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>, mkl@pengutronix.de,
        Marek Vasut <marex@denx.de>,
        Christian Herber <christian.herber@nxp.com>,
        Amit Cohen <amitc@mellanox.com>,
        Petr Machata <petrm@mellanox.com>
Subject: [PATCH v4 1/3] update UAPI header copies
Date:   Wed, 10 Jun 2020 10:37:42 +0200
Message-Id: <20200610083744.21322-2-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200610083744.21322-1-o.rempel@pengutronix.de>
References: <20200610083744.21322-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update to linux/master:
5b14671be58d00 ("Merge tag 'fuse-update-5.8' of git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/fuse")

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 uapi/linux/ethtool.h         |  16 +++-
 uapi/linux/ethtool_netlink.h | 153 ++++++++++++++++++++++++++++++++++-
 uapi/linux/genetlink.h       |   2 +
 uapi/linux/if_link.h         |   1 +
 uapi/linux/netlink.h         | 103 +++++++++++++++++++++++
 uapi/linux/rtnetlink.h       |   6 ++
 6 files changed, 279 insertions(+), 2 deletions(-)

diff --git a/uapi/linux/ethtool.h b/uapi/linux/ethtool.h
index c5c3948..6074caa 100644
--- a/uapi/linux/ethtool.h
+++ b/uapi/linux/ethtool.h
@@ -1664,6 +1664,18 @@ static __inline__ int ethtool_validate_duplex(__u8 duplex)
 	return 0;
 }
 
+#define MASTER_SLAVE_CFG_UNSUPPORTED		0
+#define MASTER_SLAVE_CFG_UNKNOWN		1
+#define MASTER_SLAVE_CFG_MASTER_PREFERRED	2
+#define MASTER_SLAVE_CFG_SLAVE_PREFERRED	3
+#define MASTER_SLAVE_CFG_MASTER_FORCE		4
+#define MASTER_SLAVE_CFG_SLAVE_FORCE		5
+#define MASTER_SLAVE_STATE_UNSUPPORTED		0
+#define MASTER_SLAVE_STATE_UNKNOWN		1
+#define MASTER_SLAVE_STATE_MASTER		2
+#define MASTER_SLAVE_STATE_SLAVE		3
+#define MASTER_SLAVE_STATE_ERR			4
+
 /* Which connector port. */
 #define PORT_TP			0x00
 #define PORT_AUI		0x01
@@ -1902,7 +1914,9 @@ struct ethtool_link_settings {
 	__u8	eth_tp_mdix_ctrl;
 	__s8	link_mode_masks_nwords;
 	__u8	transceiver;
-	__u8	reserved1[3];
+	__u8	master_slave_cfg;
+	__u8	master_slave_state;
+	__u8	reserved1[1];
 	__u32	reserved[7];
 	__u32	link_mode_masks[0];
 	/* layout of link_mode_masks fields:
diff --git a/uapi/linux/ethtool_netlink.h b/uapi/linux/ethtool_netlink.h
index 10061e4..b18e7bc 100644
--- a/uapi/linux/ethtool_netlink.h
+++ b/uapi/linux/ethtool_netlink.h
@@ -2,7 +2,7 @@
 /*
  * include/uapi/linux/ethtool_netlink.h - netlink interface for ethtool
  *
- * See Documentation/networking/ethtool-netlink.txt in kernel source tree for
+ * See Documentation/networking/ethtool-netlink.rst in kernel source tree for
  * doucumentation of the interface.
  */
 
@@ -39,6 +39,8 @@ enum {
 	ETHTOOL_MSG_EEE_GET,
 	ETHTOOL_MSG_EEE_SET,
 	ETHTOOL_MSG_TSINFO_GET,
+	ETHTOOL_MSG_CABLE_TEST_ACT,
+	ETHTOOL_MSG_CABLE_TEST_TDR_ACT,
 
 	/* add new constants above here */
 	__ETHTOOL_MSG_USER_CNT,
@@ -74,6 +76,8 @@ enum {
 	ETHTOOL_MSG_EEE_GET_REPLY,
 	ETHTOOL_MSG_EEE_NTF,
 	ETHTOOL_MSG_TSINFO_GET_REPLY,
+	ETHTOOL_MSG_CABLE_TEST_NTF,
+	ETHTOOL_MSG_CABLE_TEST_TDR_NTF,
 
 	/* add new constants above here */
 	__ETHTOOL_MSG_KERNEL_CNT,
@@ -216,6 +220,8 @@ enum {
 	ETHTOOL_A_LINKMODES_PEER,		/* bitset */
 	ETHTOOL_A_LINKMODES_SPEED,		/* u32 */
 	ETHTOOL_A_LINKMODES_DUPLEX,		/* u8 */
+	ETHTOOL_A_LINKMODES_MASTER_SLAVE_CFG,	/* u8 */
+	ETHTOOL_A_LINKMODES_MASTER_SLAVE_STATE,	/* u8 */
 
 	/* add new constants above here */
 	__ETHTOOL_A_LINKMODES_CNT,
@@ -228,6 +234,8 @@ enum {
 	ETHTOOL_A_LINKSTATE_UNSPEC,
 	ETHTOOL_A_LINKSTATE_HEADER,		/* nest - _A_HEADER_* */
 	ETHTOOL_A_LINKSTATE_LINK,		/* u8 */
+	ETHTOOL_A_LINKSTATE_SQI,		/* u32 */
+	ETHTOOL_A_LINKSTATE_SQI_MAX,		/* u32 */
 
 	/* add new constants above here */
 	__ETHTOOL_A_LINKSTATE_CNT,
@@ -403,6 +411,149 @@ enum {
 	ETHTOOL_A_TSINFO_MAX = (__ETHTOOL_A_TSINFO_CNT - 1)
 };
 
+/* CABLE TEST */
+
+enum {
+	ETHTOOL_A_CABLE_TEST_UNSPEC,
+	ETHTOOL_A_CABLE_TEST_HEADER,		/* nest - _A_HEADER_* */
+
+	/* add new constants above here */
+	__ETHTOOL_A_CABLE_TEST_CNT,
+	ETHTOOL_A_CABLE_TEST_MAX = __ETHTOOL_A_CABLE_TEST_CNT - 1
+};
+
+/* CABLE TEST NOTIFY */
+enum {
+	ETHTOOL_A_CABLE_RESULT_CODE_UNSPEC,
+	ETHTOOL_A_CABLE_RESULT_CODE_OK,
+	ETHTOOL_A_CABLE_RESULT_CODE_OPEN,
+	ETHTOOL_A_CABLE_RESULT_CODE_SAME_SHORT,
+	ETHTOOL_A_CABLE_RESULT_CODE_CROSS_SHORT,
+};
+
+enum {
+	ETHTOOL_A_CABLE_PAIR_A,
+	ETHTOOL_A_CABLE_PAIR_B,
+	ETHTOOL_A_CABLE_PAIR_C,
+	ETHTOOL_A_CABLE_PAIR_D,
+};
+
+enum {
+	ETHTOOL_A_CABLE_RESULT_UNSPEC,
+	ETHTOOL_A_CABLE_RESULT_PAIR,		/* u8 ETHTOOL_A_CABLE_PAIR_ */
+	ETHTOOL_A_CABLE_RESULT_CODE,		/* u8 ETHTOOL_A_CABLE_RESULT_CODE_ */
+
+	__ETHTOOL_A_CABLE_RESULT_CNT,
+	ETHTOOL_A_CABLE_RESULT_MAX = (__ETHTOOL_A_CABLE_RESULT_CNT - 1)
+};
+
+enum {
+	ETHTOOL_A_CABLE_FAULT_LENGTH_UNSPEC,
+	ETHTOOL_A_CABLE_FAULT_LENGTH_PAIR,	/* u8 ETHTOOL_A_CABLE_PAIR_ */
+	ETHTOOL_A_CABLE_FAULT_LENGTH_CM,	/* u32 */
+
+	__ETHTOOL_A_CABLE_FAULT_LENGTH_CNT,
+	ETHTOOL_A_CABLE_FAULT_LENGTH_MAX = (__ETHTOOL_A_CABLE_FAULT_LENGTH_CNT - 1)
+};
+
+enum {
+	ETHTOOL_A_CABLE_TEST_NTF_STATUS_UNSPEC,
+	ETHTOOL_A_CABLE_TEST_NTF_STATUS_STARTED,
+	ETHTOOL_A_CABLE_TEST_NTF_STATUS_COMPLETED
+};
+
+enum {
+	ETHTOOL_A_CABLE_NEST_UNSPEC,
+	ETHTOOL_A_CABLE_NEST_RESULT,		/* nest - ETHTOOL_A_CABLE_RESULT_ */
+	ETHTOOL_A_CABLE_NEST_FAULT_LENGTH,	/* nest - ETHTOOL_A_CABLE_FAULT_LENGTH_ */
+	__ETHTOOL_A_CABLE_NEST_CNT,
+	ETHTOOL_A_CABLE_NEST_MAX = (__ETHTOOL_A_CABLE_NEST_CNT - 1)
+};
+
+enum {
+	ETHTOOL_A_CABLE_TEST_NTF_UNSPEC,
+	ETHTOOL_A_CABLE_TEST_NTF_HEADER,	/* nest - ETHTOOL_A_HEADER_* */
+	ETHTOOL_A_CABLE_TEST_NTF_STATUS,	/* u8 - _STARTED/_COMPLETE */
+	ETHTOOL_A_CABLE_TEST_NTF_NEST,		/* nest - of results: */
+
+	__ETHTOOL_A_CABLE_TEST_NTF_CNT,
+	ETHTOOL_A_CABLE_TEST_NTF_MAX = (__ETHTOOL_A_CABLE_TEST_NTF_CNT - 1)
+};
+
+/* CABLE TEST TDR */
+
+enum {
+	ETHTOOL_A_CABLE_TEST_TDR_CFG_UNSPEC,
+	ETHTOOL_A_CABLE_TEST_TDR_CFG_FIRST,		/* u32 */
+	ETHTOOL_A_CABLE_TEST_TDR_CFG_LAST,		/* u32 */
+	ETHTOOL_A_CABLE_TEST_TDR_CFG_STEP,		/* u32 */
+	ETHTOOL_A_CABLE_TEST_TDR_CFG_PAIR,		/* u8 */
+
+	/* add new constants above here */
+	__ETHTOOL_A_CABLE_TEST_TDR_CFG_CNT,
+	ETHTOOL_A_CABLE_TEST_TDR_CFG_MAX = __ETHTOOL_A_CABLE_TEST_TDR_CFG_CNT - 1
+};
+
+enum {
+	ETHTOOL_A_CABLE_TEST_TDR_UNSPEC,
+	ETHTOOL_A_CABLE_TEST_TDR_HEADER,	/* nest - _A_HEADER_* */
+	ETHTOOL_A_CABLE_TEST_TDR_CFG,		/* nest - *_TDR_CFG_* */
+
+	/* add new constants above here */
+	__ETHTOOL_A_CABLE_TEST_TDR_CNT,
+	ETHTOOL_A_CABLE_TEST_TDR_MAX = __ETHTOOL_A_CABLE_TEST_TDR_CNT - 1
+};
+
+/* CABLE TEST TDR NOTIFY */
+
+enum {
+	ETHTOOL_A_CABLE_AMPLITUDE_UNSPEC,
+	ETHTOOL_A_CABLE_AMPLITUDE_PAIR,         /* u8 */
+	ETHTOOL_A_CABLE_AMPLITUDE_mV,           /* s16 */
+
+	__ETHTOOL_A_CABLE_AMPLITUDE_CNT,
+	ETHTOOL_A_CABLE_AMPLITUDE_MAX = (__ETHTOOL_A_CABLE_AMPLITUDE_CNT - 1)
+};
+
+enum {
+	ETHTOOL_A_CABLE_PULSE_UNSPEC,
+	ETHTOOL_A_CABLE_PULSE_mV,		/* s16 */
+
+	__ETHTOOL_A_CABLE_PULSE_CNT,
+	ETHTOOL_A_CABLE_PULSE_MAX = (__ETHTOOL_A_CABLE_PULSE_CNT - 1)
+};
+
+enum {
+	ETHTOOL_A_CABLE_STEP_UNSPEC,
+	ETHTOOL_A_CABLE_STEP_FIRST_DISTANCE,	/* u32 */
+	ETHTOOL_A_CABLE_STEP_LAST_DISTANCE,	/* u32 */
+	ETHTOOL_A_CABLE_STEP_STEP_DISTANCE,	/* u32 */
+
+	__ETHTOOL_A_CABLE_STEP_CNT,
+	ETHTOOL_A_CABLE_STEP_MAX = (__ETHTOOL_A_CABLE_STEP_CNT - 1)
+};
+
+enum {
+	ETHTOOL_A_CABLE_TDR_NEST_UNSPEC,
+	ETHTOOL_A_CABLE_TDR_NEST_STEP,		/* nest - ETHTTOOL_A_CABLE_STEP */
+	ETHTOOL_A_CABLE_TDR_NEST_AMPLITUDE,	/* nest - ETHTOOL_A_CABLE_AMPLITUDE */
+	ETHTOOL_A_CABLE_TDR_NEST_PULSE,		/* nest - ETHTOOL_A_CABLE_PULSE */
+
+	__ETHTOOL_A_CABLE_TDR_NEST_CNT,
+	ETHTOOL_A_CABLE_TDR_NEST_MAX = (__ETHTOOL_A_CABLE_TDR_NEST_CNT - 1)
+};
+
+enum {
+	ETHTOOL_A_CABLE_TEST_TDR_NTF_UNSPEC,
+	ETHTOOL_A_CABLE_TEST_TDR_NTF_HEADER,	/* nest - ETHTOOL_A_HEADER_* */
+	ETHTOOL_A_CABLE_TEST_TDR_NTF_STATUS,	/* u8 - _STARTED/_COMPLETE */
+	ETHTOOL_A_CABLE_TEST_TDR_NTF_NEST,	/* nest - of results: */
+
+	/* add new constants above here */
+	__ETHTOOL_A_CABLE_TEST_TDR_NTF_CNT,
+	ETHTOOL_A_CABLE_TEST_TDR_NTF_MAX = __ETHTOOL_A_CABLE_TEST_TDR_NTF_CNT - 1
+};
+
 /* generic netlink info */
 #define ETHTOOL_GENL_NAME "ethtool"
 #define ETHTOOL_GENL_VERSION 1
diff --git a/uapi/linux/genetlink.h b/uapi/linux/genetlink.h
index 1317119..7c6c390 100644
--- a/uapi/linux/genetlink.h
+++ b/uapi/linux/genetlink.h
@@ -48,6 +48,7 @@ enum {
 	CTRL_CMD_NEWMCAST_GRP,
 	CTRL_CMD_DELMCAST_GRP,
 	CTRL_CMD_GETMCAST_GRP, /* unused */
+	CTRL_CMD_GETPOLICY,
 	__CTRL_CMD_MAX,
 };
 
@@ -62,6 +63,7 @@ enum {
 	CTRL_ATTR_MAXATTR,
 	CTRL_ATTR_OPS,
 	CTRL_ATTR_MCAST_GROUPS,
+	CTRL_ATTR_POLICY,
 	__CTRL_ATTR_MAX,
 };
 
diff --git a/uapi/linux/if_link.h b/uapi/linux/if_link.h
index 978f98c..a8901a3 100644
--- a/uapi/linux/if_link.h
+++ b/uapi/linux/if_link.h
@@ -341,6 +341,7 @@ enum {
 	IFLA_BRPORT_NEIGH_SUPPRESS,
 	IFLA_BRPORT_ISOLATED,
 	IFLA_BRPORT_BACKUP_PORT,
+	IFLA_BRPORT_MRP_RING_OPEN,
 	__IFLA_BRPORT_MAX
 };
 #define IFLA_BRPORT_MAX (__IFLA_BRPORT_MAX - 1)
diff --git a/uapi/linux/netlink.h b/uapi/linux/netlink.h
index 2c28d32..695c88e 100644
--- a/uapi/linux/netlink.h
+++ b/uapi/linux/netlink.h
@@ -245,4 +245,107 @@ struct nla_bitfield32 {
 	__u32 selector;
 };
 
+/*
+ * policy descriptions - it's specific to each family how this is used
+ * Normally, it should be retrieved via a dump inside another attribute
+ * specifying where it applies.
+ */
+
+/**
+ * enum netlink_attribute_type - type of an attribute
+ * @NL_ATTR_TYPE_INVALID: unused
+ * @NL_ATTR_TYPE_FLAG: flag attribute (present/not present)
+ * @NL_ATTR_TYPE_U8: 8-bit unsigned attribute
+ * @NL_ATTR_TYPE_U16: 16-bit unsigned attribute
+ * @NL_ATTR_TYPE_U32: 32-bit unsigned attribute
+ * @NL_ATTR_TYPE_U64: 64-bit unsigned attribute
+ * @NL_ATTR_TYPE_S8: 8-bit signed attribute
+ * @NL_ATTR_TYPE_S16: 16-bit signed attribute
+ * @NL_ATTR_TYPE_S32: 32-bit signed attribute
+ * @NL_ATTR_TYPE_S64: 64-bit signed attribute
+ * @NL_ATTR_TYPE_BINARY: binary data, min/max length may be specified
+ * @NL_ATTR_TYPE_STRING: string, min/max length may be specified
+ * @NL_ATTR_TYPE_NUL_STRING: NUL-terminated string,
+ *	min/max length may be specified
+ * @NL_ATTR_TYPE_NESTED: nested, i.e. the content of this attribute
+ *	consists of sub-attributes. The nested policy and maxtype
+ *	inside may be specified.
+ * @NL_ATTR_TYPE_NESTED_ARRAY: nested array, i.e. the content of this
+ *	attribute contains sub-attributes whose type is irrelevant
+ *	(just used to separate the array entries) and each such array
+ *	entry has attributes again, the policy for those inner ones
+ *	and the corresponding maxtype may be specified.
+ * @NL_ATTR_TYPE_BITFIELD32: &struct nla_bitfield32 attribute
+ */
+enum netlink_attribute_type {
+	NL_ATTR_TYPE_INVALID,
+
+	NL_ATTR_TYPE_FLAG,
+
+	NL_ATTR_TYPE_U8,
+	NL_ATTR_TYPE_U16,
+	NL_ATTR_TYPE_U32,
+	NL_ATTR_TYPE_U64,
+
+	NL_ATTR_TYPE_S8,
+	NL_ATTR_TYPE_S16,
+	NL_ATTR_TYPE_S32,
+	NL_ATTR_TYPE_S64,
+
+	NL_ATTR_TYPE_BINARY,
+	NL_ATTR_TYPE_STRING,
+	NL_ATTR_TYPE_NUL_STRING,
+
+	NL_ATTR_TYPE_NESTED,
+	NL_ATTR_TYPE_NESTED_ARRAY,
+
+	NL_ATTR_TYPE_BITFIELD32,
+};
+
+/**
+ * enum netlink_policy_type_attr - policy type attributes
+ * @NL_POLICY_TYPE_ATTR_UNSPEC: unused
+ * @NL_POLICY_TYPE_ATTR_TYPE: type of the attribute,
+ *	&enum netlink_attribute_type (U32)
+ * @NL_POLICY_TYPE_ATTR_MIN_VALUE_S: minimum value for signed
+ *	integers (S64)
+ * @NL_POLICY_TYPE_ATTR_MAX_VALUE_S: maximum value for signed
+ *	integers (S64)
+ * @NL_POLICY_TYPE_ATTR_MIN_VALUE_U: minimum value for unsigned
+ *	integers (U64)
+ * @NL_POLICY_TYPE_ATTR_MAX_VALUE_U: maximum value for unsigned
+ *	integers (U64)
+ * @NL_POLICY_TYPE_ATTR_MIN_LENGTH: minimum length for binary
+ *	attributes, no minimum if not given (U32)
+ * @NL_POLICY_TYPE_ATTR_MAX_LENGTH: maximum length for binary
+ *	attributes, no maximum if not given (U32)
+ * @NL_POLICY_TYPE_ATTR_POLICY_IDX: sub policy for nested and
+ *	nested array types (U32)
+ * @NL_POLICY_TYPE_ATTR_POLICY_MAXTYPE: maximum sub policy
+ *	attribute for nested and nested array types, this can
+ *	in theory be < the size of the policy pointed to by
+ *	the index, if limited inside the nesting (U32)
+ * @NL_POLICY_TYPE_ATTR_BITFIELD32_MASK: valid mask for the
+ *	bitfield32 type (U32)
+ * @NL_POLICY_TYPE_ATTR_PAD: pad attribute for 64-bit alignment
+ */
+enum netlink_policy_type_attr {
+	NL_POLICY_TYPE_ATTR_UNSPEC,
+	NL_POLICY_TYPE_ATTR_TYPE,
+	NL_POLICY_TYPE_ATTR_MIN_VALUE_S,
+	NL_POLICY_TYPE_ATTR_MAX_VALUE_S,
+	NL_POLICY_TYPE_ATTR_MIN_VALUE_U,
+	NL_POLICY_TYPE_ATTR_MAX_VALUE_U,
+	NL_POLICY_TYPE_ATTR_MIN_LENGTH,
+	NL_POLICY_TYPE_ATTR_MAX_LENGTH,
+	NL_POLICY_TYPE_ATTR_POLICY_IDX,
+	NL_POLICY_TYPE_ATTR_POLICY_MAXTYPE,
+	NL_POLICY_TYPE_ATTR_BITFIELD32_MASK,
+	NL_POLICY_TYPE_ATTR_PAD,
+
+	/* keep last */
+	__NL_POLICY_TYPE_ATTR_MAX,
+	NL_POLICY_TYPE_ATTR_MAX = __NL_POLICY_TYPE_ATTR_MAX - 1
+};
+
 #endif /* __LINUX_NETLINK_H */
diff --git a/uapi/linux/rtnetlink.h b/uapi/linux/rtnetlink.h
index 9d802cd..bcb1ba4 100644
--- a/uapi/linux/rtnetlink.h
+++ b/uapi/linux/rtnetlink.h
@@ -609,11 +609,17 @@ enum {
 	TCA_HW_OFFLOAD,
 	TCA_INGRESS_BLOCK,
 	TCA_EGRESS_BLOCK,
+	TCA_DUMP_FLAGS,
 	__TCA_MAX
 };
 
 #define TCA_MAX (__TCA_MAX - 1)
 
+#define TCA_DUMP_FLAGS_TERSE (1 << 0) /* Means that in dump user gets only basic
+				       * data necessary to identify the objects
+				       * (handle, cookie, etc.) and stats.
+				       */
+
 #define TCA_RTA(r)  ((struct rtattr*)(((char*)(r)) + NLMSG_ALIGN(sizeof(struct tcmsg))))
 #define TCA_PAYLOAD(n) NLMSG_PAYLOAD(n,sizeof(struct tcmsg))
 
-- 
2.27.0

