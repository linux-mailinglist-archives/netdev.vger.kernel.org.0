Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A04B24BEFB1
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 03:54:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239353AbiBVCxR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 21:53:17 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233056AbiBVCxQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 21:53:16 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2050.outbound.protection.outlook.com [40.107.237.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B64525C72
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 18:52:52 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LrLhWPUWdZzWGLNdJsJmX+EUeDxZ/mQn+TTnvz/NY+ClY6LS5H2Gb8B1gZN9gU4vapF/st2nkB1B+yKYeqUp9b5I6gU84NV3X2D5FaNN+ZfV6y3gz3uz/ahV5qZKJP3xDDEbkmH50E/bvQts1BMWSevY9/yS3cTRVfvenLSFe3gZ3OxQQWPEr2h15+Z9r0ZC4AzeXSsw3IjYS7JuPtNDXxt5C2fz/w3xdtmLhbRSVd8RL8A5sylaeqUTw2V+1vbrf0PeaASV5UaXEX08OEZV3UpyEuMPemM6NWy9Jj+YLdKrShrJ8Nhg24YVYljhdapScCQxqX0UcxFB/o3qEH6Iaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MZdlaYK8DkP7J8lsmMkyYSAQEAGMkYe/HdDXOTlZQA0=;
 b=KTNBr0NTjt7+t9iA7iO863ROpI1pSR5OgWxElaXT9/aVWveve2NNhVav3Z+sDXId20F4v4M7hYCDGGpnWfi1iTGx79jBCQKr734PzdVeBTIAN2hoUf9TI8kVxu9qE/XORGX6yU4FlF4Pd3kLs+eultN5vpnEULWrSBw3sVPTOSgUZJzPYI7TiOnsuSlllT5abEXyKmRJkKWQMLuFmquGlPu4TdUeMlkWkDZusR6QCTpGGvmLhfyD7kkSGy4Zho8yXaIvLFFk9OlCqxnu72fHT9WyJeKccGB4D/+rIVPEhJ+Kp6wKJqybzrM8p8H8P5KjPwQIS6Wtkyla0LoDLFS6ow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=networkplumber.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MZdlaYK8DkP7J8lsmMkyYSAQEAGMkYe/HdDXOTlZQA0=;
 b=O+2693/lmxobRBnb/87z83h3wG/gAxSWrhsiwChkjMWaFW3N1Q8gaIYN9ArypszEpIJG2aWUyVZBW3yxsblbRXLYlDO/96RC9HMcVFZsn+b/KV+ASgt0T03IkVMJyqfvgXPoZirXYypv6d/3gZbJiXLnnqJRHZLu+KRx51vCcCpj4EzywRbXXsgFZXXuTZbyJGBGzudtZ+G1/ISoMXHmdOBCK8I895it4V/ezFhwgzLEhQIUmuuXUpugNJ+1R9LFU+HNgk13K7N5dgKS1Mc5gyedqqv3n8MafCe8Rbbrt3e6KIT3xMhRPMsz5a71fTmMmMS6A/DaBb4KJAiyQvv+yw==
Received: from DM6PR14CA0071.namprd14.prod.outlook.com (2603:10b6:5:18f::48)
 by DM6PR12MB4059.namprd12.prod.outlook.com (2603:10b6:5:215::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.16; Tue, 22 Feb
 2022 02:52:51 +0000
Received: from DM6NAM11FT065.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:18f:cafe::80) by DM6PR14CA0071.outlook.office365.com
 (2603:10b6:5:18f::48) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.15 via Frontend
 Transport; Tue, 22 Feb 2022 02:52:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 DM6NAM11FT065.mail.protection.outlook.com (10.13.172.109) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4995.15 via Frontend Transport; Tue, 22 Feb 2022 02:52:50 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 22 Feb
 2022 02:52:50 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Mon, 21 Feb 2022
 18:52:49 -0800
Received: from localhost.localdomain (10.127.8.13) by mail.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server id 15.2.986.9 via Frontend
 Transport; Mon, 21 Feb 2022 18:52:48 -0800
From:   Roopa Prabhu <roopa@nvidia.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <stephen@networkplumber.org>,
        <nikolay@cumulusnetworks.com>, <idosch@nvidia.com>,
        <dsahern@gmail.com>, <bpoirier@nvidia.com>
Subject: [PATCH net-next v2 02/12] vxlan_core: fix build warnings in vxlan_xmit_one
Date:   Tue, 22 Feb 2022 02:52:20 +0000
Message-ID: <20220222025230.2119189-3-roopa@nvidia.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220222025230.2119189-1-roopa@nvidia.com>
References: <20220222025230.2119189-1-roopa@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 835be98f-4a77-40f9-5713-08d9f5ae6a86
X-MS-TrafficTypeDiagnostic: DM6PR12MB4059:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB4059A9F582259976808EBCD8CB3B9@DM6PR12MB4059.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Yjwsxx6ChX8Q2gN+czUOAUTElzhP3OSeH6T2cUaWebtM+Tmlg9dD1FDGHp/lUyDvpqELYKXMtbFvl7Z3sS1VflV0eDQXkNcbVuM9052+jvU1XKPvAqfwROqUdKokRQbmTvZgz4DoJOvKwzmVqaIaprXufx+JenFsFo/wRHhk1Apxvncu+QkzHpJEtz/bKPMJBDErRX70SY/5MGBIT2Ms8Upo2cE+377YK3E5WdvhsFQfwCq8hZDrkiOnhMCyl7PrCx4S/pNRRhkIDXJC+jgrzUDucZnv7J51fcmRNpwtXuLy7eXprUEehFcRSH62tFUM0rOb011zfED4gwS66bKuOIMEjzqQz5rh3p2VpJ1T5V1aqGPEyUm2hZR6fFhIsByxEZYSePRpuxe8AHPciiluTSOkDhUnC9vA0Mbysboj1qNVaTglVi6vlW5OzMHO4oYOJaq5p/dnNgFuS1+n3nMkVumRoUt7wtcVUHE65G73lTmvenWCEa9yguOVvd8xRtBtLFrH64jiqrgRwqyBtixZJTnqWnMjmliR+q2g6GbJCuPrwVRS3LpcB4HQrTg0RLLceDcekQ6t6iv764gMapFCIEXK/DiMU+gOcmx6705Kig8yLIdef6u/O/98SwVX8bUnPXeKgdV7JJbsZ9BN6Bn32A7p245cURlY2XyEPLCZAsQZa4DIk0az+tm/oM206z3YVI1oaRC30otPw7HMAB8N4Q==
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(36840700001)(46966006)(47076005)(110136005)(36756003)(70586007)(70206006)(40460700003)(6666004)(54906003)(426003)(83380400001)(8676002)(508600001)(4326008)(336012)(107886003)(26005)(2616005)(8936002)(81166007)(1076003)(186003)(5660300002)(316002)(36860700001)(82310400004)(2906002)(86362001)(356005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Feb 2022 02:52:50.8689
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 835be98f-4a77-40f9-5713-08d9f5ae6a86
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT065.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4059
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the below build warnings reported by kernel test robot:
   - initialize vni in vxlan_xmit_one
   - wrap label in ipv6 enabled checks in vxlan_xmit_one

warnings:
static
 drivers/net/vxlan/vxlan_core.c:2437:14: warning: variable 'label' set
but not used [-Wunused-but-set-variable]
           __be32 vni, label;
                       ^
>> drivers/net/vxlan/vxlan_core.c:2483:7: warning: variable 'vni' is
used uninitialized whenever 'if' condition is true
[-Wsometimes-uninitialized]


Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Roopa Prabhu <roopa@nvidia.com>
---
 drivers/net/vxlan/vxlan_core.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/net/vxlan/vxlan_core.c b/drivers/net/vxlan/vxlan_core.c
index d0dc90d3dac2..a852582e6615 100644
--- a/drivers/net/vxlan/vxlan_core.c
+++ b/drivers/net/vxlan/vxlan_core.c
@@ -2603,13 +2603,16 @@ static void vxlan_xmit_one(struct sk_buff *skb, struct net_device *dev,
 	struct vxlan_metadata *md = &_md;
 	__be16 src_port = 0, dst_port;
 	struct dst_entry *ndst = NULL;
-	__be32 vni, label;
 	__u8 tos, ttl;
 	int ifindex;
 	int err;
 	u32 flags = vxlan->cfg.flags;
 	bool udp_sum = false;
 	bool xnet = !net_eq(vxlan->net, dev_net(vxlan->dev));
+	__be32 vni = 0;
+#if IS_ENABLED(CONFIG_IPV6)
+	__be32 label;
+#endif
 
 	info = skb_tunnel_info(skb);
 
@@ -2647,7 +2650,9 @@ static void vxlan_xmit_one(struct sk_buff *skb, struct net_device *dev,
 			udp_sum = !(flags & VXLAN_F_UDP_ZERO_CSUM_TX);
 		else
 			udp_sum = !(flags & VXLAN_F_UDP_ZERO_CSUM6_TX);
+#if IS_ENABLED(CONFIG_IPV6)
 		label = vxlan->cfg.label;
+#endif
 	} else {
 		if (!info) {
 			WARN_ONCE(1, "%s: Missing encapsulation instructions\n",
@@ -2674,7 +2679,9 @@ static void vxlan_xmit_one(struct sk_buff *skb, struct net_device *dev,
 		}
 		ttl = info->key.ttl;
 		tos = info->key.tos;
+#if IS_ENABLED(CONFIG_IPV6)
 		label = info->key.label;
+#endif
 		udp_sum = !!(info->key.tun_flags & TUNNEL_CSUM);
 	}
 	src_port = udp_flow_src_port(dev_net(dev), skb, vxlan->cfg.port_min,
-- 
2.25.1

