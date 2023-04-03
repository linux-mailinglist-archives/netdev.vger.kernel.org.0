Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C15F56D4E15
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 18:37:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232942AbjDCQhT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 12:37:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232897AbjDCQhB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 12:37:01 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2040.outbound.protection.outlook.com [40.107.102.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31DCD2D5E
        for <netdev@vger.kernel.org>; Mon,  3 Apr 2023 09:37:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mbjvtVwJS2Wcl0dW6RCnEQY1H3yCsO50Pnl2wo0fph8JIzmHvOl0KWKyuCLii8wEwVC9+88/u55Ae45PfoYUG6m5KX9pjFMV/mf+/sJL80010srJCwSHjMCyksNxzlswZdZMcnTBrAQXeau7Bi5mzzf+c2/tTgPIAdnkA3NR/izD3nfSF9kCx81shpXYZ1HmThscqdjr6aBLUMeDMId4ew8lQKhdQxaCIWmaWLXQXDIRVmQ/p7KD3SXfK4VwWzTEADHs6zFNmMRtDj9CJ1KEcXWuIZf/xOlY+fW+vcYt1TClMCbgLq2cTdKCr0fprdSUltK3IL7WBCOCSAFbG1HXIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VscSwlgHb5PrITl/iI4vdyu3MOnuWb0kXhAikb7YXh8=;
 b=Qqdnu/WQ+qvbb4OghJQCbm/Ki7wpluf6paBn3xZQbSvJAafyMxWhxfeFa9XeTTn3J7KBwNESUAvlGwTOhuSRcYaUd4hYNzIRncAcHjdatEtyBfijmVsgH46qZ2f8nEYpYU66qKvk09Y4wsIP2rgKoxBWvOqamqWYQFAb9PzIgceraTPuxcjQ5Nh9CyLcYh99GpNasLQlDEQBXEc0mHpzX+QGZUgX5/m8BHysCc/qeVex5aIIk+tq0D/zM/zKO8PRcYPUbe5F9IqJlNoLyjXWlI86FyVlFVxf/AmndFCcQDKJKDISLkDVRfatCYXLyxiBY4xqlTj9T+Susf1e1H2TgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VscSwlgHb5PrITl/iI4vdyu3MOnuWb0kXhAikb7YXh8=;
 b=rhMoTCZY7wcfJmJtec9fBsD3aFvS2Ly4C3j8/ofbN77wKH8UofdpdP6HZp5hT0T40aFdN32ajuHF/9fuv3sCGXKeFpDibM/NPe6rOY5EQld1N+4C/yf/i2k9+FYCLG1kSxLpPWg2yfdUVbtR5XMdXnHBNaATVO9U5B55Jobb1h0=
Received: from BN9PR03CA0175.namprd03.prod.outlook.com (2603:10b6:408:f4::30)
 by DM8PR12MB5479.namprd12.prod.outlook.com (2603:10b6:8:38::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.30; Mon, 3 Apr
 2023 16:36:56 +0000
Received: from BN8NAM11FT023.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:f4:cafe::61) by BN9PR03CA0175.outlook.office365.com
 (2603:10b6:408:f4::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.22 via Frontend
 Transport; Mon, 3 Apr 2023 16:36:55 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 BN8NAM11FT023.mail.protection.outlook.com (10.13.177.103) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6277.21 via Frontend Transport; Mon, 3 Apr 2023 16:36:55 +0000
Received: from SATLEXMB08.amd.com (10.181.40.132) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 3 Apr
 2023 11:36:55 -0500
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB08.amd.com
 (10.181.40.132) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 3 Apr
 2023 09:36:54 -0700
Received: from xcbecree41x.xilinx.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34 via Frontend
 Transport; Mon, 3 Apr 2023 11:36:53 -0500
From:   <edward.cree@amd.com>
To:     <linux-net-drivers@amd.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <pabeni@redhat.com>, <edumazet@google.com>
CC:     Edward Cree <ecree.xilinx@gmail.com>, <netdev@vger.kernel.org>,
        <habetsm.xilinx@gmail.com>, <sudheer.mogilappagari@intel.com>
Subject: [RFC PATCH net-next 5/6] net: ethtool: add a mutex protecting RSS contexts
Date:   Mon, 3 Apr 2023 17:33:02 +0100
Message-ID: <255a20efdbbaa1cd26f3ae1baf4a3379bf63aa5e.1680538846.git.ecree.xilinx@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1680538846.git.ecree.xilinx@gmail.com>
References: <cover.1680538846.git.ecree.xilinx@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT023:EE_|DM8PR12MB5479:EE_
X-MS-Office365-Filtering-Correlation-Id: a39cb7f0-70c0-4a54-708c-08db3461a31b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sEa1lXSolKzKKkRXISS8v+Ai30SftXQuxfQuKRDPTorHi1CNhwdiLfOXDSqXeW/ADopr0EH7p/OXZKk+JpEhuEe7MzQ6MLV13ELeN0loXjApJyql4L8dZ5MjYHCT5viJSwDRq34FiYC436ziF2oG+Bf7lXwX7AjFNYEeUUhdLt+uLQsPAFL9Ty/tCoVVQEFYznSe5SkVzsxKQGm6sySF4M2+vy7R2WQgIHnDV1i8OnVNa5FhsbFgzSAnWaA+oclcsYLzKAgqxqKeDuTsOaLvQAuhwIy9yFV6077bUPvUibubMiJ2GLtcYDYa46SQtyj1kNqqua2bftG8AamIwMvMtiYLTRBXGgraPO0mWERcjAjWqziFcfzEem7Cu7rlFU9nalDzEWl0VE4dwOZVZgN5mvhNWB3yGQE9v/uBoCW4VuHV2uqjOee7TPkf++WHIzD9qQ+eKceBdk0wTORsCit7Kv/qAHX5blvqf4qREpMwcTSJ2kE9jtiyxK+OjWH413c+XM5juwFItLlBEpunuYbH9G29vmEGRxvJsBwobXF1S9w32wAM0qmaH7NAT40Qe/+ApUpasyQd3TfWmCb8UoUCToKqtvEqoIhU5yZRhxzt/FyR0xpz7jeDreTI8XctU2T5NTJ5c5/VfJ6aZ1Z4myaVnXsh3Bb3czdlF8hhbkSEZ1cZwTYex41TVY3STo04I4Eb7SbX6UO/eOyfQzVRGasXplWiIuaervZqTvXtuHlwdi0=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(396003)(346002)(136003)(39860400002)(376002)(451199021)(36840700001)(46966006)(40470700004)(40480700001)(40460700003)(8676002)(36860700001)(4326008)(70206006)(70586007)(478600001)(316002)(110136005)(8936002)(54906003)(41300700001)(356005)(81166007)(82740400003)(5660300002)(426003)(186003)(47076005)(83380400001)(336012)(26005)(6666004)(9686003)(86362001)(55446002)(36756003)(2906002)(2876002)(82310400005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Apr 2023 16:36:55.5232
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a39cb7f0-70c0-4a54-708c-08db3461a31b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT023.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR12MB5479
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

While this is not needed to serialise the ethtool entry points (which
 are all under RTNL), drivers may have cause to asynchronously access
 dev->rss_ctx; taking dev->rss_lock allows them to do this safely
 without needing to take the RTNL.

Signed-off-by: Edward Cree <ecree.xilinx@gmail.com>
---
 include/linux/netdevice.h | 3 +++
 net/core/dev.c            | 5 +++++
 net/ethtool/ioctl.c       | 7 +++++++
 3 files changed, 15 insertions(+)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 91f7dad070bd..598bbffdcfd2 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -2030,6 +2030,8 @@ enum netdev_ml_priv_type {
  *	@udp_tunnel_nic:	UDP tunnel offload state
  *	@rss_ctx_max_id:	maximum (exclusive) supported RSS context ID
  *	@rss_ctx:	IDR storing custom RSS context state
+ *	@rss_lock:	Protects entries in @rss_ctx.  May be taken from
+ *			within RTNL.
  *	@xdp_state:		stores info on attached XDP BPF programs
  *
  *	@nested_level:	Used as a parameter of spin_lock_nested() of
@@ -2401,6 +2403,7 @@ struct net_device {
 
 	u32			rss_ctx_max_id;
 	struct idr		rss_ctx;
+	struct mutex		rss_lock;
 
 	/* protected by rtnl_lock */
 	struct bpf_xdp_entity	xdp_state[__MAX_XDP_MODE];
diff --git a/net/core/dev.c b/net/core/dev.c
index b2cfc631761d..8309178e9d1a 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -9987,6 +9987,7 @@ int register_netdevice(struct net_device *dev)
 	idr_init_base(&dev->rss_ctx, 1);
 
 	spin_lock_init(&dev->addr_list_lock);
+	mutex_init(&dev->rss_lock);
 	netdev_set_addr_lockdep_class(dev);
 
 	ret = dev_get_valid_name(net, dev, dev->name);
@@ -10788,6 +10789,7 @@ static void netdev_rss_contexts_free(struct net_device *dev)
 	if (!dev->ethtool_ops->set_rxfh_context &&
 	    !dev->ethtool_ops->set_rxfh_context_old)
 		return;
+	mutex_lock(&dev->rss_lock);
 	idr_for_each_entry(&dev->rss_ctx, ctx, context) {
 		u32 *indir = ethtool_rxfh_context_indir(ctx);
 		u8 *key = ethtool_rxfh_context_key(ctx);
@@ -10804,6 +10806,7 @@ static void netdev_rss_contexts_free(struct net_device *dev)
 							       &context, true);
 		kfree(ctx);
 	}
+	mutex_unlock(&dev->rss_lock);
 }
 
 /**
@@ -10917,6 +10920,8 @@ void unregister_netdevice_many_notify(struct list_head *head,
 		if (dev->netdev_ops->ndo_uninit)
 			dev->netdev_ops->ndo_uninit(dev);
 
+		mutex_destroy(&dev->rss_lock);
+
 		if (skb)
 			rtmsg_ifinfo_send(skb, dev, GFP_KERNEL, portid, nlh);
 
diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index fa0a3de1e9fb..3d1190e3abb3 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -1257,6 +1257,7 @@ static noinline_for_stack int ethtool_set_rxfh(struct net_device *dev,
 	u8 *rss_config;
 	u32 rss_cfg_offset = offsetof(struct ethtool_rxfh, rss_config[0]);
 	bool create = false, delete = false;
+	bool locked = false; /* dev->rss_lock taken */
 
 	if (!ops->get_rxnfc || !ops->set_rxfh)
 		return -EOPNOTSUPP;
@@ -1336,6 +1337,10 @@ static noinline_for_stack int ethtool_set_rxfh(struct net_device *dev,
 		}
 	}
 
+	if (rxfh.rss_context) {
+		mutex_lock(&dev->rss_lock);
+		locked = true;
+	}
 	if (create) {
 		if (delete) {
 			ret = -EINVAL;
@@ -1438,6 +1443,8 @@ static noinline_for_stack int ethtool_set_rxfh(struct net_device *dev,
 	}
 
 out:
+	if (locked)
+		mutex_unlock(&dev->rss_lock);
 	kfree(rss_config);
 	return ret;
 }
