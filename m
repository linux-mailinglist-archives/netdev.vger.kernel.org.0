Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5E846D4E0F
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 18:37:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232859AbjDCQg7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 12:36:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232867AbjDCQgz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 12:36:55 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2058.outbound.protection.outlook.com [40.107.243.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D84410FB
        for <netdev@vger.kernel.org>; Mon,  3 Apr 2023 09:36:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JQ8QXfHq48RmZq8aYVLKkGIaIo28yMlcsgySAsjXlCtceIzLYcsTanIPRPPD7IZLvxFWdteLLqpfF3sBKYKtqjo41DxkfgyLDn6pYdBFzfqB5gB8j77I3+mUa8BPsXekhylZJRSN0ZG8xqmbo+Ut5vVvui3mzMl1sHPkkbPuyZsQhdgHCmMfTko8gGf+ZvDGovlnTkZM33qBFmKRcIzIyhJAqtbo/9/k870iXjTN0tZg0XnVISRPdPF9suwRcQbFknu9xcM11KYiND58PGdZeoYC2xAKiWVFzaZA51PCOF3bLlaQZZlf590DOj4W8fTM9/mMVV/JixSTKH3sQ5pQ+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uxB7wofnunzHlBJ9L6Yp77N9BBUn+uQmQjUCJ3dkqmE=;
 b=WuFb4CJ/CxFVmyV9QzRKgsfJvFDXD1cESTl//Db2nJoSFN+iLmOPl388CDba7dl/jpIRSfyhQpG7A9t6q3QJ2ehRyvPlX+GAkoo26Q1ODgXJAGpjK7kLE9ISe+OZImI1VCBJnE7e9QyYKGGpE2Z37yBX2XPqDsfEyXi4s0b2aNP05sDsX+uJg5Q9MjRtTHUqxPp3SSyauZQkOKkA6ruplgD6QRvLi9CY0J8Qmzlc86t95kZEvM8pPAbr3BxmMqHN6TmfoSi9Y6+zINRSWVEVAPfkTDEaCbs5XV9EbkxNL1E2XzIuLxa72FNzT1t1DpcIe2KNzXZnTd/CMgDZ71aecA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uxB7wofnunzHlBJ9L6Yp77N9BBUn+uQmQjUCJ3dkqmE=;
 b=kHYqJpT1C/I24H2IaR7iNgXDfTvn08DD1RvqZjdESPxYrSppm60t8eYmuG6yvfdj/5jOgf7DzH95w/gmrjmIJrdExDc7P7af8+tZQ2AqtTutvefz3TfDH9cJMZe2Jxo6zqHovsPGcEaxNiD9nNqJuc/tkgFdkUEJwCaVegJWB1M=
Received: from BN8PR12CA0034.namprd12.prod.outlook.com (2603:10b6:408:60::47)
 by BL0PR12MB4945.namprd12.prod.outlook.com (2603:10b6:208:1c4::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.33; Mon, 3 Apr
 2023 16:36:50 +0000
Received: from BN8NAM11FT050.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:60:cafe::c5) by BN8PR12CA0034.outlook.office365.com
 (2603:10b6:408:60::47) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.22 via Frontend
 Transport; Mon, 3 Apr 2023 16:36:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 BN8NAM11FT050.mail.protection.outlook.com (10.13.177.5) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6277.16 via Frontend Transport; Mon, 3 Apr 2023 16:36:49 +0000
Received: from SATLEXMB08.amd.com (10.181.40.132) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 3 Apr
 2023 11:36:49 -0500
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB08.amd.com
 (10.181.40.132) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 3 Apr
 2023 09:36:49 -0700
Received: from xcbecree41x.xilinx.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34 via Frontend
 Transport; Mon, 3 Apr 2023 11:36:48 -0500
From:   <edward.cree@amd.com>
To:     <linux-net-drivers@amd.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <pabeni@redhat.com>, <edumazet@google.com>
CC:     Edward Cree <ecree.xilinx@gmail.com>, <netdev@vger.kernel.org>,
        <habetsm.xilinx@gmail.com>, <sudheer.mogilappagari@intel.com>
Subject: [RFC PATCH net-next 1/6] net: ethtool: attach an IDR of custom RSS contexts to a netdevice
Date:   Mon, 3 Apr 2023 17:32:58 +0100
Message-ID: <671909f108e480d961b2c170122520dffa166b77.1680538846.git.ecree.xilinx@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1680538846.git.ecree.xilinx@gmail.com>
References: <cover.1680538846.git.ecree.xilinx@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT050:EE_|BL0PR12MB4945:EE_
X-MS-Office365-Filtering-Correlation-Id: a69d29b1-31fb-44db-3eab-08db34619fb2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kd277IR2TaXQ4fxu083IMGuJ7v6tyWtMYyY+5F18ooD+DqgWqAi5mb+3GTQBHdz2KFPjJPxkHOcbEXmInHN/b8boqIL4fLR90LKExT/9HOQR1maNjbLY8tgvXud6xgcr1MyVKJlxoh0yn8wJljWcIahBf+ZbjUTQCL4r/qJPO8zViYwZQJPkpeGZVjg+qUtvoToVCYOdsq0x2QtVMy1HBVDxuDFPWN7///f2KKLaBKAY1GklX1ZyIEgL/YMtvq2kbl0Hp/WMTdy5/ef/9tGHoL5FW3ab74tS51MjDO65XUUTYmq27KiAUYJ4UN2jWOtBelFuX3sMo3p/lVHRlozYCaDSo75r+ufZzQtANbZwJLWn0HYDXaJpTXKL4p6tgvCQrquiCiOTgr4pIjCpLnv16hv/5414XePmvoKrcxEVKggfhBYplsIMjm9Yz7iMOh1npI9qkMadiTHrSQzBa4ieux1RIMER7Qt/cnlBI2Iza/MocTFoGmCqdLB/6a1gcERyuHZILQsvdrIxjcEZD4dtALeHVL7AiNMJgCTygILfSNBoSp0NemHF5AK7S8mrcNO3I0cuPb9VXVeRVmw2Duy+SZ0cjlPNV+GhnMVSEG+ibRg7ly7o+SPFbgcPPd1X/4m3PU8YN9xXgPqEo32We6CW/Nlz3rq7uz4IceQbNcKxXyEzf5R87b7e2t92P1F98U+xMNUatEpq+Ov2pDcLV4NEP8v86WJVegSgfcgnK+kyc5A=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(376002)(136003)(396003)(346002)(39860400002)(451199021)(40470700004)(36840700001)(46966006)(55446002)(86362001)(2876002)(82310400005)(36756003)(2906002)(40480700001)(336012)(426003)(47076005)(186003)(83380400001)(26005)(6666004)(9686003)(70586007)(36860700001)(8676002)(70206006)(40460700003)(478600001)(41300700001)(5660300002)(82740400003)(81166007)(356005)(4326008)(54906003)(316002)(110136005)(8936002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Apr 2023 16:36:49.8475
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a69d29b1-31fb-44db-3eab-08db34619fb2
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT050.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB4945
X-Spam-Status: No, score=0.8 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Edward Cree <ecree.xilinx@gmail.com>

Each context stores the RXFH settings (indir, key, and hfunc) as well
 as optionally some driver private data.
Delete any still-existing contexts at netdev unregister time.

Signed-off-by: Edward Cree <ecree.xilinx@gmail.com>
---
 include/linux/ethtool.h   | 33 +++++++++++++++++++++++++++++++++
 include/linux/netdevice.h |  5 +++++
 net/core/dev.c            | 23 +++++++++++++++++++++++
 3 files changed, 61 insertions(+)

diff --git a/include/linux/ethtool.h b/include/linux/ethtool.h
index 798d35890118..1898f4446666 100644
--- a/include/linux/ethtool.h
+++ b/include/linux/ethtool.h
@@ -157,6 +157,39 @@ static inline u32 ethtool_rxfh_indir_default(u32 index, u32 n_rx_rings)
 	return index % n_rx_rings;
 }
 
+/**
+ * struct ethtool_rxfh_context - a custom RSS context configuration
+ * @indir_size: Number of u32 entries in indirection table
+ * @key_size: Size of hash key, in bytes
+ * @hfunc: RSS hash function identifier.  One of the %ETH_RSS_HASH_*
+ * @priv_size: Size of driver private data, in bytes
+ */
+struct ethtool_rxfh_context {
+	u32 indir_size;
+	u32 key_size;
+	u8 hfunc;
+	u16 priv_size;
+	/* private: indirection table, hash key, and driver private data are
+	 * stored sequentially in @data area.  Use below helpers to access
+	 */
+	u8 data[];
+};
+
+static inline u32 *ethtool_rxfh_context_indir(struct ethtool_rxfh_context *ctx)
+{
+	return (u32 *)&ctx->data;
+}
+
+static inline u8 *ethtool_rxfh_context_key(struct ethtool_rxfh_context *ctx)
+{
+	return (u8 *)(ethtool_rxfh_context_indir(ctx) + ctx->indir_size);
+}
+
+static inline void *ethtool_rxfh_context_priv(struct ethtool_rxfh_context *ctx)
+{
+	return ethtool_rxfh_context_key(ctx) + ctx->key_size;
+}
+
 /* declare a link mode bitmap */
 #define __ETHTOOL_DECLARE_LINK_MODE_MASK(name)		\
 	DECLARE_BITMAP(name, __ETHTOOL_LINK_MODE_MASK_NBITS)
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index a740be3bb911..91f7dad070bd 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -2028,6 +2028,8 @@ enum netdev_ml_priv_type {
  *	@udp_tunnel_nic_info:	static structure describing the UDP tunnel
  *				offload capabilities of the device
  *	@udp_tunnel_nic:	UDP tunnel offload state
+ *	@rss_ctx_max_id:	maximum (exclusive) supported RSS context ID
+ *	@rss_ctx:	IDR storing custom RSS context state
  *	@xdp_state:		stores info on attached XDP BPF programs
  *
  *	@nested_level:	Used as a parameter of spin_lock_nested() of
@@ -2397,6 +2399,9 @@ struct net_device {
 	const struct udp_tunnel_nic_info	*udp_tunnel_nic_info;
 	struct udp_tunnel_nic	*udp_tunnel_nic;
 
+	u32			rss_ctx_max_id;
+	struct idr		rss_ctx;
+
 	/* protected by rtnl_lock */
 	struct bpf_xdp_entity	xdp_state[__MAX_XDP_MODE];
 
diff --git a/net/core/dev.c b/net/core/dev.c
index 7ce5985be84b..d0a936d4e532 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -9983,6 +9983,9 @@ int register_netdevice(struct net_device *dev)
 	if (ret)
 		return ret;
 
+	/* rss ctx ID 0 is reserved for the default context, start from 1 */
+	idr_init_base(&dev->rss_ctx, 1);
+
 	spin_lock_init(&dev->addr_list_lock);
 	netdev_set_addr_lockdep_class(dev);
 
@@ -10777,6 +10780,24 @@ void synchronize_net(void)
 }
 EXPORT_SYMBOL(synchronize_net);
 
+static void netdev_rss_contexts_free(struct net_device *dev)
+{
+	struct ethtool_rxfh_context *ctx;
+	u32 context;
+
+	if (!dev->ethtool_ops->set_rxfh_context)
+		return;
+	idr_for_each_entry(&dev->rss_ctx, ctx, context) {
+		u32 *indir = ethtool_rxfh_context_indir(ctx);
+		u8 *key = ethtool_rxfh_context_key(ctx);
+
+		idr_remove(&dev->rss_ctx, context);
+		dev->ethtool_ops->set_rxfh_context(dev, indir, key, ctx->hfunc,
+						   &context, true);
+		kfree(ctx);
+	}
+}
+
 /**
  *	unregister_netdevice_queue - remove device from the kernel
  *	@dev: device
@@ -10881,6 +10902,8 @@ void unregister_netdevice_many_notify(struct list_head *head,
 		netdev_name_node_alt_flush(dev);
 		netdev_name_node_free(dev->name_node);
 
+		netdev_rss_contexts_free(dev);
+
 		call_netdevice_notifiers(NETDEV_PRE_UNINIT, dev);
 
 		if (dev->netdev_ops->ndo_uninit)
