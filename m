Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DB0D49AC51
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 07:22:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245484AbiAYGVy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 01:21:54 -0500
Received: from mail-dm6nam11on2062.outbound.protection.outlook.com ([40.107.223.62]:40065
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S244647AbiAYGTw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Jan 2022 01:19:52 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P7HYMSABb92g40pCTxkvA1HiYlgWJS12firZ9tWHG15XmScqKxZJKXwp/4rGKzSxFcF+BcUwl3nzTbTTRjjrSrOvqFdKm2Zp295uOZY4HX8+I5vjE00sFHNTTPYjgTX7gNXUO+qeGRBlSecBEwgXl+wBPW9CIKcWOiUd2N6c56gwnFDVWC+DvOsAUynrGENRT1Tr13lp9Di3lr2jw6qA383RnYItmrfskq9kfkzpiQ66TfB8yYE0nZIgc7MUY6SoyxaBKtVoG2hM+bPHyB80BDJJsQJ60EypXbkWl2icKKYMi2KawXLNI8cdjUi8ac9xsjC2eF/0JHxd0eOWrfelkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VgrXuCotWpenuvOgBO5s0mNNruBAafldw+RETouHM3I=;
 b=hZd3pSIVOKdq8ZA3DRInu1pDbBCPKNrl+0brQ+cgXvKgCBo9JDV4pxbytPIr7SCIJ7ONdfLOVIJ0sUq46juFInq9nAtLlFRHKJVk+IArivkJ6RQogyKUDs8VnZzii41NAkzK0mIvMoTCvRygqrpAC81gMuTcICwxt0VL6Jv/00IS2QJ0MX7VOW6Gm1t0yHY6b3+D1fDIHLb5p3IGOd1Etkmwse8o7aM2wC/40iw2VY7qlFgXPanISYnAT6ZIxTxpxccTwT7qy9Zs/rIKVKF75J+pqtlTHmlwFbQKyWDdPU+Kc207lX94WHvQUR+gVzBNEavoyAhPGYpPlu+iQk1ONw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=lists.linux-foundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VgrXuCotWpenuvOgBO5s0mNNruBAafldw+RETouHM3I=;
 b=DmkKdXIjQWnuuWJRf7VxLSxUoquFTit4NmLQNezkM9CXNCLoWpwdvo9Hn5oSQ8+r2wc0mHqZ2H8Y3PNzRf2TTv6TXwfWcDjYTLHF3lhEZ56uyXjx2zCAwSAWfShwMbLD4Eik+K3QqWVJdnQR00LzGV/pmYwY+mLdhyZMo5Iall/Cr8LpabRWrB1MYFNawi+UUC+2MTiuXBTUdZceC3a0Jyx0y5aq/m52kqzrac2uvGF7nlUkrfR2MZP3qz6k79RTI46b9bIViCtrVvZjuRUbbwnIgLufAuVCGqrTSn5WVtfFsXZkWSVRIkLc1EW3d7deH8YfDhAr+ioAG1aLSf9New==
Received: from BN8PR16CA0002.namprd16.prod.outlook.com (2603:10b6:408:4c::15)
 by DM6PR12MB3339.namprd12.prod.outlook.com (2603:10b6:5:119::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.13; Tue, 25 Jan
 2022 06:19:44 +0000
Received: from BN8NAM11FT029.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:4c:cafe::ec) by BN8PR16CA0002.outlook.office365.com
 (2603:10b6:408:4c::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.17 via Frontend
 Transport; Tue, 25 Jan 2022 06:19:43 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.238) by
 BN8NAM11FT029.mail.protection.outlook.com (10.13.177.68) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4909.7 via Frontend Transport; Tue, 25 Jan 2022 06:19:43 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 DRHQMAIL105.nvidia.com (10.27.9.14) with Microsoft SMTP Server (TLS) id
 15.0.1497.18; Tue, 25 Jan 2022 06:19:42 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9;
 Mon, 24 Jan 2022 22:19:41 -0800
Received: from d3.nvidia.com (10.127.8.13) by mail.nvidia.com (10.126.190.182)
 with Microsoft SMTP Server id 15.2.986.9 via Frontend Transport; Mon, 24 Jan
 2022 22:19:40 -0800
From:   Benjamin Poirier <bpoirier@nvidia.com>
To:     Nikolay Aleksandrov <nikolay@nvidia.com>
CC:     Roopa Prabhu <roopa@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        <bridge@lists.linux-foundation.org>, <netdev@vger.kernel.org>
Subject: [PATCH net] net: bridge: vlan: Fix dumping with ifindex
Date:   Tue, 25 Jan 2022 15:19:03 +0900
Message-ID: <20220125061903.714509-1-bpoirier@nvidia.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 18f8efcf-8bbe-41d7-aa8b-08d9dfcaad3e
X-MS-TrafficTypeDiagnostic: DM6PR12MB3339:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB3339ACE41F3C6EB8B4ED5438B05F9@DM6PR12MB3339.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:949;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UjGmUPjhk4/o7GoKQHIhThN49MlFMqDuFZftKwrwvkXnIa7Bw6AWlAvJ1tZrYaDRLtBwUqnJYkrKvJ0gwh4L2f2ogVmL78gGBKkjJpLmzSvQdbhqva6yKOFEuy4OTzL07YpmQV4DDb4pJDEupne/Q5RayV0j1BU+pGE4TvLUTZZvFbYt6UEcbHZZO1bUeGreeAyJkv+6BbmZvHDYCKVVia7Ca1j4BdiUc2fYEWMn00hmVnIubgizapRgN3bm4sxAtU1tUu+JYjLLm9M7b6bjTHLs+Xeb7/Q3H5aYVnhHPCimqQz862QOgFCM7TVl8fAI2PeYGTvw//nSE22eoKrBECtlDZKrXVnQ8L9r3Nwdbs3ZFBOxtq5vmnL+pYosBt/MJ2nII8zcLMuKtEfJvjIZ0Dx3vMjt1TxMGveM227N+Xhft6LoPGfL8nj0iz/CuAEAnM1uQME4bLBycVJP8kpRYqJzuDI/uMiyQW1iHC1S9G8YMf10AMNLNENClelxPDLzMu8uS7pNF49IVDg1Hk6gT5UsjEaGNcq+1gKTp6EIKyY7o76vATnHFPItwXrSPmC2ekCNz5dpaslfoCtMbsKTf3XwhJ3KTUwCiUvoVo4i7J476PI9L2QlO99gVq5KXgiPOlnYI7xHpkq+v9GEmPSG38pcYWmhBwzU4MJ1ShCvpLD3VBO3jB8xHjeXlOgh4mo2GW8ndYAVeCKeDIIk8vKUg7eR9oyEwB8BSrTfptdnuzikpsq8hzgO1tcP16R7/SCXp5x2/72PAC1+yNZFqVMoxuslyg6uvuZxWZS9WbMbJXQ=
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(4636009)(40470700004)(36840700001)(46966006)(6862004)(36860700001)(70206006)(8936002)(5660300002)(7696005)(6636002)(508600001)(81166007)(316002)(356005)(1076003)(40460700003)(2616005)(70586007)(336012)(26005)(2906002)(86362001)(426003)(47076005)(6666004)(36756003)(8676002)(54906003)(37006003)(82310400004)(186003)(4326008)(83380400001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jan 2022 06:19:43.0870
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 18f8efcf-8bbe-41d7-aa8b-08d9dfcaad3e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT029.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3339
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Specifying ifindex in a RTM_GETVLAN dump leads to an infinite repetition
of the same entries. netlink_dump() normally calls the dump function
repeatedly until it returns 0 which br_vlan_rtm_dump() never does in
that case.

Fixes: 8dcea187088b ("net: bridge: vlan: add rtm definitions and dump support")
Signed-off-by: Benjamin Poirier <bpoirier@nvidia.com>
---
 net/bridge/br_vlan.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

The problem can be reproduced by using the following iproute2 patch and
running:
ip link add br0 type bridge
ip link add dummy0 master br0 type dummy
bridge vlan add dev dummy0 vid 100

./bridge/bridge -d vlan show dev dummy0
[infinite loop]

	diff --git a/bridge/vlan.c b/bridge/vlan.c
	index 8300f353..f206a671 100644
	--- a/bridge/vlan.c
	+++ b/bridge/vlan.c
	@@ -1128,7 +1128,8 @@ static int vlan_show(int argc, char **argv, int subject)
		if (show_details && subject == VLAN_SHOW_VLAN) {
			__u32 dump_flags = show_stats ? BRIDGE_VLANDB_DUMPF_STATS : 0;
	 
	-		if (rtnl_brvlandump_req(&rth, PF_BRIDGE, dump_flags) < 0) {
	+		if (rtnl_brvlandump_req(&rth, PF_BRIDGE, dump_flags,
	+					filter_index) < 0) {
				perror("Cannot send dump request");
				exit(1);
			}
	@@ -1240,7 +1241,8 @@ static int vlan_global_show(int argc, char **argv)
	 
		new_json_obj(json);
	 
	-	if (rtnl_brvlandump_req(&rth, PF_BRIDGE, dump_flags) < 0) {
	+	if (rtnl_brvlandump_req(&rth, PF_BRIDGE, dump_flags, filter_index)
	+	    < 0) {
			perror("Cannot send dump request");
			exit(1);
		}
	diff --git a/include/libnetlink.h b/include/libnetlink.h
	index 9e4cc101..276b7fbf 100644
	--- a/include/libnetlink.h
	+++ b/include/libnetlink.h
	@@ -69,7 +69,8 @@ int rtnl_neightbldump_req(struct rtnl_handle *rth, int family)
		__attribute__((warn_unused_result));
	 int rtnl_mdbdump_req(struct rtnl_handle *rth, int family)
		__attribute__((warn_unused_result));
	-int rtnl_brvlandump_req(struct rtnl_handle *rth, int family, __u32 dump_flags)
	+int rtnl_brvlandump_req(struct rtnl_handle *rth, int family, __u32 dump_flags,
	+			int ifindex)
		__attribute__((warn_unused_result));
	 int rtnl_netconfdump_req(struct rtnl_handle *rth, int family)
		__attribute__((warn_unused_result));
	diff --git a/lib/libnetlink.c b/lib/libnetlink.c
	index 7e977a67..e0fce8e5 100644
	--- a/lib/libnetlink.c
	+++ b/lib/libnetlink.c
	@@ -450,7 +450,8 @@ int rtnl_mdbdump_req(struct rtnl_handle *rth, int family)
		return send(rth->fd, &req, sizeof(req), 0);
	 }
	 
	-int rtnl_brvlandump_req(struct rtnl_handle *rth, int family, __u32 dump_flags)
	+int rtnl_brvlandump_req(struct rtnl_handle *rth, int family, __u32 dump_flags,
	+			int ifindex)
	 {
		struct {
			struct nlmsghdr nlh;
	@@ -462,6 +463,7 @@ int rtnl_brvlandump_req(struct rtnl_handle *rth, int family, __u32 dump_flags)
			.nlh.nlmsg_flags = NLM_F_DUMP | NLM_F_REQUEST,
			.nlh.nlmsg_seq = rth->dump = ++rth->seq,
			.bvm.family = family,
	+		.bvm.ifindex = ifindex,
		};
	 
		addattr32(&req.nlh, sizeof(req), BRIDGE_VLANDB_DUMP_FLAGS, dump_flags);
	-- 

diff --git a/net/bridge/br_vlan.c b/net/bridge/br_vlan.c
index 84ba456a78cc..2e606f2b9a4d 100644
--- a/net/bridge/br_vlan.c
+++ b/net/bridge/br_vlan.c
@@ -2013,7 +2013,7 @@ static int br_vlan_rtm_dump(struct sk_buff *skb, struct netlink_callback *cb)
 		dump_flags = nla_get_u32(dtb[BRIDGE_VLANDB_DUMP_FLAGS]);
 
 	rcu_read_lock();
-	if (bvm->ifindex) {
+	if (bvm->ifindex && !s_idx) {
 		dev = dev_get_by_index_rcu(net, bvm->ifindex);
 		if (!dev) {
 			err = -ENODEV;
@@ -2022,7 +2022,9 @@ static int br_vlan_rtm_dump(struct sk_buff *skb, struct netlink_callback *cb)
 		err = br_vlan_dump_dev(dev, skb, cb, dump_flags);
 		if (err && err != -EMSGSIZE)
 			goto out_err;
-	} else {
+		else if (!err)
+			idx++;
+	} else if (!bvm->ifindex) {
 		for_each_netdev_rcu(net, dev) {
 			if (idx < s_idx)
 				goto skip;
-- 
2.34.1

