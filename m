Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75FA31F0C3A
	for <lists+netdev@lfdr.de>; Sun,  7 Jun 2020 17:00:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726835AbgFGPAi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Jun 2020 11:00:38 -0400
Received: from mail-am6eur05on2089.outbound.protection.outlook.com ([40.107.22.89]:48904
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726595AbgFGPAd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 7 Jun 2020 11:00:33 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZV3zjJNI+z+SHfizKNI2WYEKTQje1r/0Y+16SFTXv2xyNhiSf1YYOydfbiA2qC49qSkIg43NrCDV1oHdWCPkauCnPnI07CdXCHsHUtfxN9fl30Z7dtH1JY2n0D98ZVEmfHNIibfddySghCwmPLshZRuIMwohSt8ZqmCESJ3lOUz/oglF+ntNB5IabkjuEmAXFS7FW2sOiG3LJcdzSP7pyyhzdc1FFn1RhB22Q5RyQKotVFZlXMy+9ewgQ1jRuahhFMyCMxiH+E4gtsXmWoRCMjQYaqA65QhvGqff86n5HCOIq48c5/qj+zJrllISTRcSGt2EOgaLlQlgmdUC5qiBmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F0DJQrVs2r+2/gCHipL4+ugNK28EVx1ilcr/c/RLp08=;
 b=Rjqxi7XfZpgMpEV3F6I/3uUwcex9ZjM08k3IWiIo6635tIXmh3Eidpqw39QWsuQs7VUDZOYInNMNNq4C7YVNuLRta/m866c6FEth2EatD+opkJZgJ7PSLkP0+JJDpVaEAE8ePmRVCyu/l3OVSt6+DDPCtqyiP+xu5UKlPJr4UZd5P6CTdSALJtn16OtVHmRq9IW4nGRvaE/QLEJV4SI9hopgoariqnEeFxN2dIFkcbPJFJNp0emF3MOcvVQZaemRh3GvdCnPnqD/9xuWpJp9psZYwAKF+ey4QN2aekpj3Zr0PSbkM6YmYFXpcvyrW+iKfcjoTIVoqcu03s2RJ8OX5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F0DJQrVs2r+2/gCHipL4+ugNK28EVx1ilcr/c/RLp08=;
 b=U+Xf4a7gnxniXFhhmC0CWjJVZqkGrsJD17n3BeYsyt80l0+QxTi8Kj7bythO7g6+xtY5AIfX8bMJSBb1zCJZkuuyAKcEOkZ+d3T1U+1AaI6G4kdZLvOoeoO8R+Sb/jRFTpDG8gGKmK/bvDNp3Q5Ghu7XK9QM49vcgESzRf6rI1E=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=mellanox.com;
Received: from AM0PR0502MB3826.eurprd05.prod.outlook.com
 (2603:10a6:208:1b::25) by AM0PR0502MB4003.eurprd05.prod.outlook.com
 (2603:10a6:208:2::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3066.23; Sun, 7 Jun
 2020 15:00:15 +0000
Received: from AM0PR0502MB3826.eurprd05.prod.outlook.com
 ([fe80::2dae:c2a2:c26a:f5b]) by AM0PR0502MB3826.eurprd05.prod.outlook.com
 ([fe80::2dae:c2a2:c26a:f5b%7]) with mapi id 15.20.3066.023; Sun, 7 Jun 2020
 15:00:15 +0000
From:   Amit Cohen <amitc@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, corbet@lwn.net,
        jiri@mellanox.com, idosch@mellanox.com, shuah@kernel.org,
        mkubecek@suse.cz, gustavo@embeddedor.com, amitc@mellanox.com,
        cforno12@linux.vnet.ibm.com, andrew@lunn.ch, f.fainelli@gmail.com,
        linux@rempel-privat.de, alexandru.ardelean@analog.com,
        ayal@mellanox.com, petrm@mellanox.com, mlxsw@mellanox.com,
        liuhangbin@gmail.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: [RFC PATCH net-next 04/10] ethtool: Add link extended state
Date:   Sun,  7 Jun 2020 17:59:39 +0300
Message-Id: <20200607145945.30559-5-amitc@mellanox.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200607145945.30559-1-amitc@mellanox.com>
References: <20200607145945.30559-1-amitc@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR10CA0015.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:17c::25) To AM0PR0502MB3826.eurprd05.prod.outlook.com
 (2603:10a6:208:1b::25)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dev-r-vrt-155.mtr.labs.mlnx (37.142.13.130) by AM0PR10CA0015.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:17c::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3066.18 via Frontend Transport; Sun, 7 Jun 2020 15:00:13 +0000
X-Mailer: git-send-email 2.20.1
X-Originating-IP: [37.142.13.130]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 9594f15a-09cb-408c-a27d-08d80af37c63
X-MS-TrafficTypeDiagnostic: AM0PR0502MB4003:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR0502MB40031858F4970658A5FBD468D7840@AM0PR0502MB4003.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 04270EF89C
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cpxS632k45uRBcf+uwIZwVkdrjIUFqLs7PNemH6+YXtmxTXHuLR3sxy/isApaAqdS4dUJVSCLzzx7tG+H4UBibZ5Bx9sLxgbN0qD5vG4ZGhOQWIxfx5/BRoUfMR8OlJ9tqEFikyN5PI4qWYxjS3r0BhSQQ1miNxM7TAQg6byLd3t5YKkGPRrEsOB9Hb++L+1ZBmkkJlHEqIWA3u96ESzWsPF8Dsgrf/TDlmFol6lOIu+qNjFvW7rHQr7Asq+4Wh7SyTzS8PxSeUbXenpinZlJ+8ijDmrQh9nZu+iDbzlRES0FFcW9TRMXsgiVw3ucJCOjZIqoDHnWqGxaDj7Nbz+BA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR0502MB3826.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(376002)(366004)(346002)(136003)(39860400002)(66476007)(66946007)(66556008)(1076003)(186003)(8936002)(16526019)(26005)(52116002)(478600001)(6506007)(36756003)(2906002)(6666004)(7416002)(5660300002)(8676002)(4326008)(83380400001)(6486002)(316002)(86362001)(6916009)(2616005)(956004)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: ENh9MsLx3G8ToEMtFPBSqzGnqi+GaB5UxDM3/2rjavEi8WS+URsSbZhGXCzkVWfhQic1dCnGlQECOz8ubmigMiC0RvUVGX8E8VihciCDuwY1n6dQ6xgEidiuZVIPLFWW9wM1g8JfhYi7uTmlWjManQbubPs89goXU0KRkOb+5hASsh16y3hCej1zPsDiwg3Am2+3hl3ExVbf3Vk6eykMkDjrh6+8FvQ01McxBnoulJQh0wamk37T/SyjpPugMR+X1OGVDXx4DtG6v2uRvFQn6/dB2RUcwqHuIvTaT7ibbVerNqkXHaiIa/9zh/DnLQIXiiM7cQXcpAjsOn7QhnnleV929s5dFXRgpahbkKw374mi8xuhdQih2+2496omUDYDUOnHRuakFtQPBPRIMfUQqqvfWjnXsAm2I5wcC7MnMWbZzUSUtpUxKgw6orXQt7xzN/olGrv1d1lOjzQ42axxNbVl3f8cyBz0B/2qprH8Pvo=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9594f15a-09cb-408c-a27d-08d80af37c63
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jun 2020 15:00:15.5578
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sg7P1/6qeVUosc8kdVhPOLwlqDbTZHjOM/y6WuojuYKN6A3x4ehDfJQtiN+fmiJrNN8t+0/YNN7TAxk8pTDfaQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0502MB4003
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, drivers can only tell whether the link is up/down using
LINKSTATE_GET, but no additional information is given.

Add attributes to LINKSTATE_GET command in order to allow drivers
to expose the user more information in addition to link state to ease
the debug process, for example, reason for link down state.

Extended state consists of two attributes - ext_state and ext_substate.
The idea is to avoid 'vendor specific' states in order to prevent
drivers to use specific ext_state that can be in the future common
ext_state.

The substates allows drivers to add more information to the common
ext_state. For example, vendor can expose 'Autoneg failure' as
ext_state and add 'No partner detected during force mode' as
ext_substate.

If a driver cannot pinpoint the extended state with the substate
accuracy, it is free to expose only the extended state and omit the
substate attribute.

Signed-off-by: Amit Cohen <amitc@mellanox.com>
Reviewed-by: Petr Machata <petrm@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 include/linux/ethtool.h              | 22 +++++++++
 include/uapi/linux/ethtool.h         | 70 ++++++++++++++++++++++++++++
 include/uapi/linux/ethtool_netlink.h |  2 +
 net/ethtool/linkstate.c              | 40 ++++++++++++++++
 4 files changed, 134 insertions(+)

diff --git a/include/linux/ethtool.h b/include/linux/ethtool.h
index a23b26eab479..48ec542f4504 100644
--- a/include/linux/ethtool.h
+++ b/include/linux/ethtool.h
@@ -86,6 +86,22 @@ struct net_device;
 u32 ethtool_op_get_link(struct net_device *dev);
 int ethtool_op_get_ts_info(struct net_device *dev, struct ethtool_ts_info *eti);
 
+
+/**
+ * struct ethtool_ext_state_info - link extended state and substate.
+ */
+struct ethtool_ext_state_info {
+	enum ethtool_ext_state ext_state;
+	union {
+		enum ethtool_ext_substate_autoneg autoneg;
+		enum ethtool_ext_substate_link_training link_training;
+		enum ethtool_ext_substate_link_logical_mismatch link_logical_mismatch;
+		enum ethtool_ext_substate_bad_signal_integrity bad_signal_integrity;
+		enum ethtool_ext_substate_cable_issue cable_issue;
+		int __ext_substate;
+	};
+};
+
 /**
  * ethtool_rxfh_indir_default - get default value for RX flow hash indirection
  * @index: Index in RX flow hash indirection table
@@ -245,6 +261,10 @@ bool ethtool_convert_link_mode_to_legacy_u32(u32 *legacy_u32,
  * @get_link: Report whether physical link is up.  Will only be called if
  *	the netdev is up.  Should usually be set to ethtool_op_get_link(),
  *	which uses netif_carrier_ok().
+ * @get_ext_state: Report link extended state. Should set ext_state and
+ *	ext_substate (ext_substate of 0 means ext_substate is unknown,
+ *	do not attach ext_substate attribute to netlink message). If not
+ *	implemented, ext_state and ext_substate will not be sent to userspace.
  * @get_eeprom: Read data from the device EEPROM.
  *	Should fill in the magic field.  Don't need to check len for zero
  *	or wraparound.  Fill in the data argument with the eeprom values
@@ -384,6 +404,8 @@ struct ethtool_ops {
 	void	(*set_msglevel)(struct net_device *, u32);
 	int	(*nway_reset)(struct net_device *);
 	u32	(*get_link)(struct net_device *);
+	int	(*get_ext_state)(struct net_device *,
+				 struct ethtool_ext_state_info *);
 	int	(*get_eeprom_len)(struct net_device *);
 	int	(*get_eeprom)(struct net_device *,
 			      struct ethtool_eeprom *, u8 *);
diff --git a/include/uapi/linux/ethtool.h b/include/uapi/linux/ethtool.h
index f4662b3a9e1e..830fa0d6aebe 100644
--- a/include/uapi/linux/ethtool.h
+++ b/include/uapi/linux/ethtool.h
@@ -579,6 +579,76 @@ struct ethtool_pauseparam {
 	__u32	tx_pause;
 };
 
+/**
+ * enum ethtool_ext_state - link extended state
+ */
+enum ethtool_ext_state {
+	ETHTOOL_EXT_STATE_AUTONEG_FAILURE,
+	ETHTOOL_EXT_STATE_LINK_TRAINING_FAILURE,
+	ETHTOOL_EXT_STATE_LINK_LOGICAL_MISMATCH,
+	ETHTOOL_EXT_STATE_BAD_SIGNAL_INTEGRITY,
+	ETHTOOL_EXT_STATE_NO_CABLE,
+	ETHTOOL_EXT_STATE_CABLE_ISSUE,
+	ETHTOOL_EXT_STATE_EEPROM_ISSUE,
+	ETHTOOL_EXT_STATE_CALIBRATION_FAILURE,
+	ETHTOOL_EXT_STATE_POWER_BUDGET_EXCEEDED,
+	ETHTOOL_EXT_STATE_OVERHEAT,
+};
+
+/**
+ * enum ethtool_ext_substate_autoneg - more information in addition to
+ * ETHTOOL_EXT_STATE_AUTONEG_FAILURE.
+ */
+enum ethtool_ext_substate_autoneg {
+	ETHTOOL_EXT_SUBSTATE_AN_NO_PARTNER_DETECTED = 1,
+	ETHTOOL_EXT_SUBSTATE_AN_ACK_NOT_RECEIVED,
+	ETHTOOL_EXT_SUBSTATE_AN_NEXT_PAGE_EXCHANGE_FAILED,
+	ETHTOOL_EXT_SUBSTATE_AN_NO_PARTNER_DETECTED_FORCE_MODE,
+	ETHTOOL_EXT_SUBSTATE_AN_FEC_MISMATCH_DURING_OVERRIDE,
+	ETHTOOL_EXT_SUBSTATE_AN_NO_HCD,
+};
+
+/**
+ * enum ethtool_ext_substate_link_training - more information in addition to
+ * ETHTOOL_EXT_STATE_LINK_TRAINING_FAILURE.
+ */
+enum ethtool_ext_substate_link_training {
+	ETHTOOL_EXT_SUBSTATE_LT_KR_FRAME_LOCK_NOT_ACQUIRED = 1,
+	ETHTOOL_EXT_SUBSTATE_LT_KR_LINK_INHIBIT_TIMEOUT,
+	ETHTOOL_EXT_SUBSTATE_LT_KR_LINK_PARTNER_DID_NOT_SET_RECEIVER_READY,
+	ETHTOOL_EXT_SUBSTATE_LT_REMOTE_FAULT,
+};
+
+/**
+ * enum ethtool_ext_substate_logical_mismatch - more information in addition
+ * to ETHTOOL_EXT_STATE_LINK_LOGICAL_MISMATCH.
+ */
+enum ethtool_ext_substate_link_logical_mismatch {
+	ETHTOOL_EXT_SUBSTATE_LLM_PCS_DID_NOT_ACQUIRE_BLOCK_LOCK = 1,
+	ETHTOOL_EXT_SUBSTATE_LLM_PCS_DID_NOT_ACQUIRE_AM_LOCK,
+	ETHTOOL_EXT_SUBSTATE_LLM_PCS_DID_NOT_GET_ALIGN_STATUS,
+	ETHTOOL_EXT_SUBSTATE_LLM_FC_FEC_IS_NOT_LOCKED,
+	ETHTOOL_EXT_SUBSTATE_LLM_RS_FEC_IS_NOT_LOCKED,
+};
+
+/**
+ * enum ethtool_ext_substate_bad_signal_integrity - more information in
+ * addition to ETHTOOL_EXT_STATE_BAD_SIGNAL_INTEGRITY.
+ */
+enum ethtool_ext_substate_bad_signal_integrity {
+	ETHTOOL_EXT_SUBSTATE_BSI_LARGE_NUMBER_OF_PHYSICAL_ERRORS = 1,
+	ETHTOOL_EXT_SUBSTATE_BSI_UNSUPPORTED_RATE,
+};
+
+/**
+ * enum ethtool_ext_substate_cable_issue - more information in
+ * addition to ETHTOOL_EXT_STATE_CABLE_ISSUE.
+ */
+enum ethtool_ext_substate_cable_issue {
+	ETHTOOL_EXT_SUBSTATE_UNSUPPORTED_CABLE = 1,
+	ETHTOOL_EXT_SUBSTATE_SHORTED_CABLE,
+};
+
 #define ETH_GSTRING_LEN		32
 
 /**
diff --git a/include/uapi/linux/ethtool_netlink.h b/include/uapi/linux/ethtool_netlink.h
index e6f109b76c9a..1de8b77bedff 100644
--- a/include/uapi/linux/ethtool_netlink.h
+++ b/include/uapi/linux/ethtool_netlink.h
@@ -234,6 +234,8 @@ enum {
 	ETHTOOL_A_LINKSTATE_LINK,		/* u8 */
 	ETHTOOL_A_LINKSTATE_SQI,		/* u32 */
 	ETHTOOL_A_LINKSTATE_SQI_MAX,		/* u32 */
+	ETHTOOL_A_LINKSTATE_EXT_STATE,		/* u8 */
+	ETHTOOL_A_LINKSTATE_EXT_SUBSTATE,	/* u8 */
 
 	/* add new constants above here */
 	__ETHTOOL_A_LINKSTATE_CNT,
diff --git a/net/ethtool/linkstate.c b/net/ethtool/linkstate.c
index 7f47ba89054e..0f3a15fe9919 100644
--- a/net/ethtool/linkstate.c
+++ b/net/ethtool/linkstate.c
@@ -13,6 +13,8 @@ struct linkstate_reply_data {
 	int				link;
 	int				sqi;
 	int				sqi_max;
+	bool				ext_state_provided;
+	struct ethtool_ext_state_info	ethtool_ext_state_info;
 };
 
 #define LINKSTATE_REPDATA(__reply_base) \
@@ -25,6 +27,8 @@ linkstate_get_policy[ETHTOOL_A_LINKSTATE_MAX + 1] = {
 	[ETHTOOL_A_LINKSTATE_LINK]		= { .type = NLA_REJECT },
 	[ETHTOOL_A_LINKSTATE_SQI]		= { .type = NLA_REJECT },
 	[ETHTOOL_A_LINKSTATE_SQI_MAX]		= { .type = NLA_REJECT },
+	[ETHTOOL_A_LINKSTATE_EXT_STATE]		= { .type = NLA_REJECT },
+	[ETHTOOL_A_LINKSTATE_EXT_SUBSTATE]	= { .type = NLA_REJECT },
 };
 
 static int linkstate_get_sqi(struct net_device *dev)
@@ -61,6 +65,23 @@ static int linkstate_get_sqi_max(struct net_device *dev)
 	mutex_unlock(&phydev->lock);
 
 	return ret;
+};
+
+static void linkstate_get_ext_state(struct net_device *dev,
+				    struct linkstate_reply_data *data)
+{
+	int err;
+
+	if (!dev->ethtool_ops->get_ext_state)
+		return;
+
+	err = dev->ethtool_ops->get_ext_state(dev, &data->ethtool_ext_state_info);
+	if (err) {
+		data->ext_state_provided = false;
+		return;
+	}
+
+	data->ext_state_provided = true;
 }
 
 static int linkstate_prepare_data(const struct ethnl_req_info *req_base,
@@ -88,6 +109,8 @@ static int linkstate_prepare_data(const struct ethnl_req_info *req_base,
 
 	data->sqi_max = ret;
 
+	linkstate_get_ext_state(dev, data);
+
 	ethnl_ops_complete(dev);
 
 	return 0;
@@ -108,6 +131,12 @@ static int linkstate_reply_size(const struct ethnl_req_info *req_base,
 	if (data->sqi_max != -EOPNOTSUPP)
 		len += nla_total_size(sizeof(u32));
 
+	if (data->ext_state_provided)
+		len += sizeof(u8); /* LINKSTATE_EXT_STATE */
+
+	if (data->ethtool_ext_state_info.__ext_substate)
+		len += sizeof(u8); /* LINKSTATE_EXT_SUBSTATE */
+
 	return len;
 }
 
@@ -129,6 +158,17 @@ static int linkstate_fill_reply(struct sk_buff *skb,
 	    nla_put_u32(skb, ETHTOOL_A_LINKSTATE_SQI_MAX, data->sqi_max))
 		return -EMSGSIZE;
 
+	if (data->ext_state_provided) {
+		if (nla_put_u8(skb, ETHTOOL_A_LINKSTATE_EXT_STATE,
+			       data->ethtool_ext_state_info.ext_state))
+			return -EMSGSIZE;
+
+		if (data->ethtool_ext_state_info.__ext_substate &&
+		    nla_put_u8(skb, ETHTOOL_A_LINKSTATE_EXT_SUBSTATE,
+			       data->ethtool_ext_state_info.__ext_substate))
+			return -EMSGSIZE;
+	}
+
 	return 0;
 }
 
-- 
2.20.1

