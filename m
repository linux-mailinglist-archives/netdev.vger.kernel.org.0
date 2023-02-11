Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3D9D692C46
	for <lists+netdev@lfdr.de>; Sat, 11 Feb 2023 01:50:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229745AbjBKAuu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 19:50:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229716AbjBKAul (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 19:50:41 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2046.outbound.protection.outlook.com [40.107.244.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96340765D7
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 16:50:40 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Iobybu3VEX1tZJTg9P1/SpSV/wNjYYLgD+2SFwyBXdPJ5EdlqVmcVBqBbvWvtXlDa2aON4RGWkwOBzbcO1V7L1uuR2JFde7EleLEU0TihRQdU3X3y60eVTBWmLP+DzxbVldcsGPvu4li+QJNBS7ZMqmm6QYtPgIsg2qWMQ81eqiOFfQPmvhLNqTY7J/wEbbUfxDv1HBkLgpmZc498H8rGt8RxFluF4nrF4PDoWeqJpxXzRIHPHQV4Z+nOWSVMR00873CvddGYdM6VSkWTqBbc+8R/f5Rj5DwhePelAsF//fqKJpFQfiyoTDFOPeTpXUVns0sOdSDE0e/W8WP792klQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XOhUJ8Shd54DyQpPHOYETyHY6sCV+GVJO9whmWV3ZiY=;
 b=hBiU4yAoaXbWKMOVNUvyKV8h+/aMNf41x8Wq6NcYVYP4qYrxDKYivtiCv3Uqg8ugdU999XWYK87MNLIAj6xZ2cTsS/Z78nDCjHi+4mjACLHaFlGlDS2E0UhSaaVSIFCgQ4eKRYohqR3K7512Rnb86ypZX5L6aSUG0rA1oNzzX+GjiaMlMayuHff0iWwg1feCbkyjOv1mYk5xPMSAqzZy5CqaHsPRCLII79j6RRHnVwCdE0fjWc2VeZTH7oqIZVPUbcCk47N2bDA4p1AUDgNrn3qyRh0+Q3/qRr4h6IBfwFj8SEPRMcsy8YrmWTMYI5C0v8Y389QCagYs4vlkO/FZZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XOhUJ8Shd54DyQpPHOYETyHY6sCV+GVJO9whmWV3ZiY=;
 b=BxnhKGHxkGCRZ0wqqYV/8cqiw1vm78ldSB55VE9c2afs4czIE+Js/1hCQDXCNWTs4P2YhjbIfavNsYh4fnijj62GawXxSrywTqzGe7RCM6mEWx/fWm6wvYxZ3EdqCqjH6ymyU5TKniGkAj7MXUWNkvROHWa1vjy8mHAyPS6hSfc=
Received: from CY5PR19CA0113.namprd19.prod.outlook.com (2603:10b6:930:64::9)
 by IA1PR12MB6458.namprd12.prod.outlook.com (2603:10b6:208:3aa::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.17; Sat, 11 Feb
 2023 00:50:37 +0000
Received: from CY4PEPF0000C969.namprd02.prod.outlook.com
 (2603:10b6:930:64:cafe::d4) by CY5PR19CA0113.outlook.office365.com
 (2603:10b6:930:64::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.21 via Frontend
 Transport; Sat, 11 Feb 2023 00:50:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000C969.mail.protection.outlook.com (10.167.241.73) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6086.16 via Frontend Transport; Sat, 11 Feb 2023 00:50:36 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Fri, 10 Feb
 2023 18:50:35 -0600
From:   Shannon Nelson <shannon.nelson@amd.com>
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <drivers@pensando.io>, Shannon Nelson <shannon.nelson@amd.com>
Subject: [PATCH v4 net-next 3/4] net: ethtool: extend ringparam set/get APIs for rx_push
Date:   Fri, 10 Feb 2023 16:50:16 -0800
Message-ID: <20230211005017.48134-4-shannon.nelson@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230211005017.48134-1-shannon.nelson@amd.com>
References: <20230211005017.48134-1-shannon.nelson@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000C969:EE_|IA1PR12MB6458:EE_
X-MS-Office365-Filtering-Correlation-Id: 5f91a36c-f106-4e5b-73e0-08db0bc9fd5a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AbpMB3SCPE1jBuNEr/vXjX86lBURC7ac4RK3/3iEOEeqT+XdAi0RMqU8W9/3HEXypiKXfJJUrWqKt2yVZZA/dn52vOgSO2p2sEa7Umvyv8xGMNzDAyMCOB16v/0d1L8PY9cYGl3GTaHf6lRRquyNuGtkElT/mdMO49MG2q+YqVPCjS3+WCeG7B4qt1zzh75PEzJOs+UoycPVARJQqUs5WBgIY/9FsKOtgEXD9v4lHLLGaHXODQowjMI3CsEdcVyduEMbOUvwrXzaqXIvTICU4hKGQGZZo/sLfPQ/fEgPkkZboVCxm/+ftI8BAuiinlyBA4iWJr5GZ/0dcbDdfLUsVh+hxqPR3A2vXEipkr8ooRVtYXLKdZJOObuL7St0yPIevpeyNWKJcC/0NXR31QLWHCWdUaOC3exQLP46gW7PhVU4FJqSRMHxr9adZXPEuscvIMENI6UzWHQqUsF2mx/TuJ6BbrVhAXKxCKaX07az4bf51xmyqOqbAKFD+NBXcnZEY0ki/Df6+6B8+oGN2v5ATIBW9ABTyHoXk6++9NCzxFVO3rnWdg1/0xirAUFDUZXUQsevqBF40fu6cTz1dBPvT3zpZHghNisnuSlR5xEb238vRJp0BlJNfRqvjHs5eDYZsi9tLfTen1fouY3ZuPsvRJ0wVfR43nf5DVOqkSV3NN8ABgzUfTLmDoBuWEoz8+jtf9ZhaXLzJy3xFqky+zHBMm2pMam303erriKGLt+CK6VmD+WSo5NmSbuwFidgTx00dALriDTamRNy5+j1eva6fA==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(346002)(376002)(396003)(136003)(39860400002)(451199018)(36840700001)(46966006)(40470700004)(82740400003)(6666004)(83380400001)(2616005)(86362001)(8676002)(81166007)(41300700001)(4326008)(40480700001)(44832011)(336012)(36756003)(70586007)(82310400005)(426003)(70206006)(47076005)(40460700003)(478600001)(316002)(2906002)(8936002)(186003)(26005)(54906003)(1076003)(36860700001)(110136005)(16526019)(356005)(5660300002)(36900700001)(309714004);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Feb 2023 00:50:36.8858
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f91a36c-f106-4e5b-73e0-08db0bc9fd5a
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000C969.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6458
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Similar to what was done for TX_PUSH, add an RX_PUSH concept
to the ethtool interfaces.

Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
---
 Documentation/networking/ethtool-netlink.rst |  6 ++++--
 include/linux/ethtool.h                      |  4 ++++
 include/uapi/linux/ethtool_netlink.h         |  1 +
 net/ethtool/netlink.h                        |  2 +-
 net/ethtool/rings.c                          | 17 +++++++++++++++--
 5 files changed, 25 insertions(+), 5 deletions(-)

diff --git a/Documentation/networking/ethtool-netlink.rst b/Documentation/networking/ethtool-netlink.rst
index d144e890961d..e1bc6186d7ea 100644
--- a/Documentation/networking/ethtool-netlink.rst
+++ b/Documentation/networking/ethtool-netlink.rst
@@ -874,6 +874,7 @@ Kernel response contents:
   ``ETHTOOL_A_RINGS_TCP_DATA_SPLIT``    u8      TCP header / data split
   ``ETHTOOL_A_RINGS_CQE_SIZE``          u32     Size of TX/RX CQE
   ``ETHTOOL_A_RINGS_TX_PUSH``           u8      flag of TX Push mode
+  ``ETHTOOL_A_RINGS_RX_PUSH``           u8      flag of RX Push mode
   ====================================  ======  ===========================
 
 ``ETHTOOL_A_RINGS_TCP_DATA_SPLIT`` indicates whether the device is usable with
@@ -883,8 +884,8 @@ separate buffers. The device configuration must make it possible to receive
 full memory pages of data, for example because MTU is high enough or through
 HW-GRO.
 
-``ETHTOOL_A_RINGS_TX_PUSH`` flag is used to enable descriptor fast
-path to send packets. In ordinary path, driver fills descriptors in DRAM and
+``ETHTOOL_A_RINGS_[RX|TX]_PUSH`` flag is used to enable descriptor fast
+path to send or receive packets. In ordinary path, driver fills descriptors in DRAM and
 notifies NIC hardware. In fast path, driver pushes descriptors to the device
 through MMIO writes, thus reducing the latency. However, enabling this feature
 may increase the CPU cost. Drivers may enforce additional per-packet
@@ -906,6 +907,7 @@ Request contents:
   ``ETHTOOL_A_RINGS_RX_BUF_LEN``        u32     size of buffers on the ring
   ``ETHTOOL_A_RINGS_CQE_SIZE``          u32     Size of TX/RX CQE
   ``ETHTOOL_A_RINGS_TX_PUSH``           u8      flag of TX Push mode
+  ``ETHTOOL_A_RINGS_RX_PUSH``           u8      flag of RX Push mode
   ====================================  ======  ===========================
 
 Kernel checks that requested ring sizes do not exceed limits reported by
diff --git a/include/linux/ethtool.h b/include/linux/ethtool.h
index 515c78d8eb7c..2792185dda22 100644
--- a/include/linux/ethtool.h
+++ b/include/linux/ethtool.h
@@ -73,12 +73,14 @@ enum {
  * @rx_buf_len: Current length of buffers on the rx ring.
  * @tcp_data_split: Scatter packet headers and data to separate buffers
  * @tx_push: The flag of tx push mode
+ * @rx_push: The flag of rx push mode
  * @cqe_size: Size of TX/RX completion queue event
  */
 struct kernel_ethtool_ringparam {
 	u32	rx_buf_len;
 	u8	tcp_data_split;
 	u8	tx_push;
+	u8	rx_push;
 	u32	cqe_size;
 };
 
@@ -87,11 +89,13 @@ struct kernel_ethtool_ringparam {
  * @ETHTOOL_RING_USE_RX_BUF_LEN: capture for setting rx_buf_len
  * @ETHTOOL_RING_USE_CQE_SIZE: capture for setting cqe_size
  * @ETHTOOL_RING_USE_TX_PUSH: capture for setting tx_push
+ * @ETHTOOL_RING_USE_RX_PUSH: capture for setting rx_push
  */
 enum ethtool_supported_ring_param {
 	ETHTOOL_RING_USE_RX_BUF_LEN = BIT(0),
 	ETHTOOL_RING_USE_CQE_SIZE   = BIT(1),
 	ETHTOOL_RING_USE_TX_PUSH    = BIT(2),
+	ETHTOOL_RING_USE_RX_PUSH    = BIT(3),
 };
 
 #define __ETH_RSS_HASH_BIT(bit)	((u32)1 << (bit))
diff --git a/include/uapi/linux/ethtool_netlink.h b/include/uapi/linux/ethtool_netlink.h
index ffb073c0dbb4..d39ce21381c5 100644
--- a/include/uapi/linux/ethtool_netlink.h
+++ b/include/uapi/linux/ethtool_netlink.h
@@ -356,6 +356,7 @@ enum {
 	ETHTOOL_A_RINGS_TCP_DATA_SPLIT,			/* u8 */
 	ETHTOOL_A_RINGS_CQE_SIZE,			/* u32 */
 	ETHTOOL_A_RINGS_TX_PUSH,			/* u8 */
+	ETHTOOL_A_RINGS_RX_PUSH,			/* u8 */
 
 	/* add new constants above here */
 	__ETHTOOL_A_RINGS_CNT,
diff --git a/net/ethtool/netlink.h b/net/ethtool/netlink.h
index ae0732460e88..f7b189ed96b2 100644
--- a/net/ethtool/netlink.h
+++ b/net/ethtool/netlink.h
@@ -413,7 +413,7 @@ extern const struct nla_policy ethnl_features_set_policy[ETHTOOL_A_FEATURES_WANT
 extern const struct nla_policy ethnl_privflags_get_policy[ETHTOOL_A_PRIVFLAGS_HEADER + 1];
 extern const struct nla_policy ethnl_privflags_set_policy[ETHTOOL_A_PRIVFLAGS_FLAGS + 1];
 extern const struct nla_policy ethnl_rings_get_policy[ETHTOOL_A_RINGS_HEADER + 1];
-extern const struct nla_policy ethnl_rings_set_policy[ETHTOOL_A_RINGS_TX_PUSH + 1];
+extern const struct nla_policy ethnl_rings_set_policy[ETHTOOL_A_RINGS_RX_PUSH + 1];
 extern const struct nla_policy ethnl_channels_get_policy[ETHTOOL_A_CHANNELS_HEADER + 1];
 extern const struct nla_policy ethnl_channels_set_policy[ETHTOOL_A_CHANNELS_COMBINED_COUNT + 1];
 extern const struct nla_policy ethnl_coalesce_get_policy[ETHTOOL_A_COALESCE_HEADER + 1];
diff --git a/net/ethtool/rings.c b/net/ethtool/rings.c
index 2a2d3539630c..f358cd57d094 100644
--- a/net/ethtool/rings.c
+++ b/net/ethtool/rings.c
@@ -56,7 +56,8 @@ static int rings_reply_size(const struct ethnl_req_info *req_base,
 	       nla_total_size(sizeof(u32)) +	/* _RINGS_RX_BUF_LEN */
 	       nla_total_size(sizeof(u8))  +	/* _RINGS_TCP_DATA_SPLIT */
 	       nla_total_size(sizeof(u32)  +	/* _RINGS_CQE_SIZE */
-	       nla_total_size(sizeof(u8)));	/* _RINGS_TX_PUSH */
+	       nla_total_size(sizeof(u8))  +	/* _RINGS_TX_PUSH */
+	       nla_total_size(sizeof(u8)));	/* _RINGS_RX_PUSH */
 }
 
 static int rings_fill_reply(struct sk_buff *skb,
@@ -96,7 +97,8 @@ static int rings_fill_reply(struct sk_buff *skb,
 			 kr->tcp_data_split))) ||
 	    (kr->cqe_size &&
 	     (nla_put_u32(skb, ETHTOOL_A_RINGS_CQE_SIZE, kr->cqe_size))) ||
-	    nla_put_u8(skb, ETHTOOL_A_RINGS_TX_PUSH, !!kr->tx_push))
+	    nla_put_u8(skb, ETHTOOL_A_RINGS_TX_PUSH, !!kr->tx_push) ||
+	    nla_put_u8(skb, ETHTOOL_A_RINGS_RX_PUSH, !!kr->rx_push))
 		return -EMSGSIZE;
 
 	return 0;
@@ -114,6 +116,7 @@ const struct nla_policy ethnl_rings_set_policy[] = {
 	[ETHTOOL_A_RINGS_RX_BUF_LEN]            = NLA_POLICY_MIN(NLA_U32, 1),
 	[ETHTOOL_A_RINGS_CQE_SIZE]		= NLA_POLICY_MIN(NLA_U32, 1),
 	[ETHTOOL_A_RINGS_TX_PUSH]		= NLA_POLICY_MAX(NLA_U8, 1),
+	[ETHTOOL_A_RINGS_RX_PUSH]		= NLA_POLICY_MAX(NLA_U8, 1),
 };
 
 static int
@@ -147,6 +150,14 @@ ethnl_set_rings_validate(struct ethnl_req_info *req_info,
 		return -EOPNOTSUPP;
 	}
 
+	if (tb[ETHTOOL_A_RINGS_RX_PUSH] &&
+	    !(ops->supported_ring_params & ETHTOOL_RING_USE_RX_PUSH)) {
+		NL_SET_ERR_MSG_ATTR(info->extack,
+				    tb[ETHTOOL_A_RINGS_RX_PUSH],
+				    "setting rx push not supported");
+		return -EOPNOTSUPP;
+	}
+
 	return ops->get_ringparam && ops->set_ringparam ? 1 : -EOPNOTSUPP;
 }
 
@@ -176,6 +187,8 @@ ethnl_set_rings(struct ethnl_req_info *req_info, struct genl_info *info)
 			 tb[ETHTOOL_A_RINGS_CQE_SIZE], &mod);
 	ethnl_update_u8(&kernel_ringparam.tx_push,
 			tb[ETHTOOL_A_RINGS_TX_PUSH], &mod);
+	ethnl_update_u8(&kernel_ringparam.rx_push,
+			tb[ETHTOOL_A_RINGS_RX_PUSH], &mod);
 	if (!mod)
 		return 0;
 
-- 
2.17.1

